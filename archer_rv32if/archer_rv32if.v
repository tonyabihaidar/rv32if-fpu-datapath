`include "archerdefs.v"

module archer_rv32if (
    input clk,
    input rst_n
);

// === PC wires ===
wire [`XLEN-1:0] pc_in, pc_out, pc_plus4;

// === Instantiate PC ===
pc PC (
    .clk(clk),
    .rst_n(rst_n),
    .datain(pc_in),
    .dataout(pc_out)
);

// === PC + 4 ===
add4 PCAdder (
    .datain(pc_out),
    .result(pc_plus4)
);

// === Instruction Memory ===
wire [`XLEN-1:0] instruction;
rom InstructionMemory (
    .addr(pc_out[`ADDRLEN-1:0]),
    .dataout(instruction)
);

// === Immediate Generator ===
wire [`XLEN-1:0] imm;
immgen ImmGen (
    .instruction(instruction),
    .immediate(imm)
);

// === Control Signals ===
wire Jump, Lui, RegWrite, ALUSrc1, ALUSrc2;
wire [3:0] ALUOp;
wire MemWrite, MemRead, MemToReg;
wire FPRegWrite, FPToReg, FPStart;
wire [3:0] FPUOp;
wire PCSrc;


control Control (
    .instruction(instruction),
    .BranchCond(BranchCond),
    .Jump(Jump),
    .Lui(Lui),
    .RegWrite(RegWrite),
    .ALUSrc1(ALUSrc1),
    .ALUSrc2(ALUSrc2),
    .ALUOp(ALUOp),
    .MemWrite(MemWrite),
    .MemRead(MemRead),
    .MemToReg(MemToReg),
    .FPRegWrite(FPRegWrite),
    .FPToReg(FPToReg),
    .FPUOp(FPUOp),
    .FPStart(FPStart)
);

// === Register File Signals ===
wire [4:0] rs1, rs2, rd;
assign rs1 = instruction[19:15];
assign rs2 = instruction[24:20];
assign rd  = instruction[11:7];

// === Integer Register File ===
wire [`XLEN-1:0] int_rs1_data, int_rs2_data;
regfile RegFile (
    .clk(clk),
    .rst_n(rst_n),
    .RegWrite(RegWrite),
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),
    .datain(regfile_wd),
    .regA(int_rs1_data),
    .regB(int_rs2_data)
);

// === Floating-Point Register File ===
wire [`XLEN-1:0] float_rs1_data, float_rs2_data;
float_regfile FRegFile (
    .clk(clk),
    .rst_n(rst_n),
    .FRegWrite(FPRegWrite),
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),
    .datain(regfile_wd),
    .regA(float_rs1_data),
    .regB(float_rs2_data)
);

// === Select between Integer and Float Data ===
wire [`XLEN-1:0] final_rs1_data, final_rs2_data;
assign final_rs1_data = (instruction[6:0] == `OPCODE_FLOAT || instruction[6:0] == `OPCODE_FLOAD || instruction[6:0] == `OPCODE_FSTORE) ? float_rs1_data : int_rs1_data;
assign final_rs2_data = (instruction[6:0] == `OPCODE_FLOAT || instruction[6:0] == `OPCODE_FLOAD || instruction[6:0] == `OPCODE_FSTORE) ? float_rs2_data : int_rs2_data;

// === ALU Inputs ===
wire [`XLEN-1:0] alu_src1, alu_src2;
assign alu_src1 = ALUSrc1 ? pc_out : final_rs1_data;
assign alu_src2 = ALUSrc2 ? imm : final_rs2_data;

// === Integer ALU ===
wire [`XLEN-1:0] alu_result;
alu ALU (
    .inputA(alu_src1),
    .inputB(alu_src2),
    .ALUop(ALUOp),
    .result(alu_result)
);

// === FPU ===
wire [`XLEN-1:0] fpu_result;
fpu FPU (
    .inputA(final_rs1_data),
    .inputB(final_rs2_data),
    .imm(imm[11:0]),
    .FPU_OP(FPUOp),
    .result(fpu_result)
);

// === Branch Comparator ===
wire BranchCond;
branch_cmp BranchCmp (
    .inputA(final_rs1_data),
    .inputB(final_rs2_data),
    .cond(instruction[14:12]),
    .result(BranchCond)
);

// === PC MUX ===
assign pc_in = PCSrc ? (pc_out + imm) : pc_plus4;

// === LMB and SRAM ===
wire [`XLEN-1:0] proc_addr = alu_result;
wire [`XLEN-1:0] proc_data_send = final_rs2_data;
wire [`XLEN-1:0] proc_data_receive;
wire [1:0] proc_byte_mask = 2'b10; // word
wire proc_sign_ext_n = 1'b1;
wire proc_mem_write = MemWrite;
wire proc_mem_read = MemRead;
wire [`ADDRLEN-1:0] mem_addr;
wire [`XLEN-1:0] mem_datain;
wire [`XLEN-1:0] mem_dataout;
wire mem_wen;
wire [3:0] mem_ben;

lmb limb_inst (
    .proc_addr(proc_addr),
    .proc_data_send(proc_data_send),
    .proc_data_receive(proc_data_receive),
    .proc_byte_mask(proc_byte_mask),
    .proc_sign_ext_n(proc_sign_ext_n),
    .proc_mem_write(proc_mem_write),
    .proc_mem_read(proc_mem_read),
    .mem_addr(mem_addr),
    .mem_datain(mem_datain),
    .mem_dataout(mem_dataout),
    .mem_wen(mem_wen),
    .mem_ben(mem_ben)
);

sram DataMemory (
    .clk(clk),
    .addr(mem_addr),
    .datain(mem_datain),
    .dataout(mem_dataout),
    .wen(mem_wen),
    .ben(mem_ben)
);

// === Write-back MUX ===
wire [`XLEN-1:0] alu_or_mem_result;
mux2to1 mux_alu_mem (
    .sel(MemToReg),
    .input0(alu_result),
    .input1(proc_data_receive),
    .muxout(alu_or_mem_result)
);

wire [`XLEN-1:0] regfile_wd;
assign regfile_wd = FPToReg ? fpu_result : alu_or_mem_result;

endmodule
