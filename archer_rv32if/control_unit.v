`include "archerdefs.v"
module control (
    input [`XLEN-1:0] instruction,
    input BranchCond, // BR. COND. SATISFIED = 1; NOT SATISFIED = 0
    output Jump,
    output reg Lui,
    output PCSrc,
    output reg RegWrite,
    output reg ALUSrc1,
    output reg ALUSrc2,
    output reg [3:0] ALUOp,
    output reg MemWrite,
    output reg MemRead,
    output reg MemToReg,
    output reg FPRegWrite,
    output reg FPToReg,
    output reg [3:0] FPUOp,
    output reg FPStart
);

    // Instruction fields
    wire [6:0] opcode;
    wire [2:0] funct3;
    wire [6:0] funct7;
    wire branch_instr;
    wire jump_instr;

    // Assign fields
    assign opcode = instruction[6:0];
    assign funct3 = instruction[14:12];
    assign funct7 = instruction[31:25];

    // Branch & Jump logic
    assign branch_instr = (opcode == `OPCODE_BRANCH) ? 1'b1 : 1'b0;
    assign jump_instr = ((opcode == `OPCODE_JAL) || (opcode == `OPCODE_JALR)) ? 1'b1 : 1'b0;
    assign PCSrc        = (branch_instr & BranchCond) | jump_instr;
    assign Jump         = jump_instr;

    always @(*) begin

        FPRegWrite = 1'b0;
        FPToReg    = 1'b0;
        FPUOp      = 4'b0000;
        FPStart    = 1'b0;

        Lui        = 1'b0;
        RegWrite   = 1'b0;
        ALUSrc1    = 1'b0;
        ALUSrc2    = 1'b0;
        ALUOp      = 4'b0000;
        MemWrite   = 1'b0;
        MemRead    = 1'b0;
        MemToReg   = 1'b0;

        case (opcode)
            `OPCODE_LUI: begin
                Lui = 1'b1;
                RegWrite = 1'b1;
                ALUSrc1 = 1'b1;
                ALUSrc2 = 1'b1;
                ALUOp = `ALU_OP_ADD;
            end

            `OPCODE_AUIPC,`OPCODE_JAL: begin
                RegWrite = 1'b1;
                ALUSrc1 = 1'b1;
                ALUSrc2 = 1'b1;
                ALUOp = `ALU_OP_ADD;
            end

            `OPCODE_JALR: begin
                RegWrite = 1'b1;
                ALUSrc2 = 1'b1;
                ALUOp = `ALU_OP_ADD;
            end

            `OPCODE_BRANCH: begin
                ALUSrc1 = 1'b1;
                ALUSrc2 = 1'b1;
                ALUOp = `ALU_OP_SUB;
            end

            `OPCODE_LOAD: begin
                RegWrite = 1'b1;
                ALUSrc2 = 1'b1;
                ALUOp = `ALU_OP_ADD;
                MemRead = 1'b1;
                MemToReg = 1'b1;
            end

            `OPCODE_STORE: begin
                ALUSrc2 = 1'b1;
                ALUOp = `ALU_OP_ADD;
                MemWrite = 1'b1;
            end

            `OPCODE_IMM: begin
                RegWrite = 1'b1;
                ALUSrc2 = 1'b1;
                if (funct3 == 3'b101) // SRLI/SRAI
                    ALUOp = {funct7[5], funct3};
                else
                    ALUOp = {1'b0, funct3};
            end

            `OPCODE_RTYPE: begin
                RegWrite = 1'b1;
                ALUOp = {funct7[5], funct3};
            end

            // Floating-point load
            `OPCODE_FLOAD: begin
                MemRead = 1'b1;
                ALUSrc2 = 1'b1;
                ALUOp = `ALU_OP_ADD;
                FPToReg = 1'b1;
                FPRegWrite = 1'b1;
            end

            // Floating-point store
            `OPCODE_FSTORE: begin
                MemWrite = 1'b1;
                ALUSrc2  = 1'b1;
                ALUOp = `ALU_OP_ADD;
            end

            // Floating-point operations
            `OPCODE_FLOAT: begin
                FPRegWrite = 1'b1;
                FPStart = 1'b1;
                case (funct7)
                    `FUNCT7_FADD_S: FPUOp = `F_ALU_OP_ADD;
                    `FUNCT7_FSUB_S: FPUOp = `F_ALU_OP_SUB;
                    `FUNCT7_FMUL_S: FPUOp = `F_ALU_OP_MUL;
                    `FUNCT7_FMIN_MAX: begin
                        case (instruction[24:20])
                            `RS2_FMIN: FPUOp = `F_ALU_OP_MIN;
                            `RS2_FMAX: FPUOp = `F_ALU_OP_MAX;
                            default: FPUOp = 2'b11111;
                        endcase
                    end
                    `FUNCT7_FCMP: begin
                        case (instruction[14:12])
                            `RS2_FEQ: FPUOp = `F_ALU_OP_EQ;
                            `RS2_FLT: FPUOp = `F_ALU_OP_LT;
                            `RS2_FLE: FPUOp = `F_ALU_OP_LE;
                            default: FPUOp = 4'b11111;
                        endcase
                    end
                    default: FPUOp = 4'b11111;
                endcase
            end
            default: ;
        endcase
    end
endmodule