// Code your testbench here
// or browse Examples
`timescale 1ns / 1ps

// === DEFINES ===
`define	XLEN            32
`define	ADDRLEN         10
`define	LOG2_XRF_SIZE   5
`define	ALUOPS_SIZE	    5
`define FP_SIGN_WIDTH    1
`define FP_EXP_WIDTH     8
`define FP_MANT_WIDTH    23
`define FP_TRUNCATE    3'b001

// ALU operations
`define	ALU_OP_ADD	4'b0000
`define	ALU_OP_SUB	4'b1000
`define	ALU_OP_AND	4'b0111
`define	ALU_OP_OR	4'b0110
`define ALU_OP_XOR	4'b0100
`define	ALU_OP_SLL	4'b0001
`define ALU_OP_SRL	4'b0101
`define	ALU_OP_SRA	4'b1101
`define ALU_OP_SLT	4'b0010
`define	ALU_OP_SLTU	4'b0011

// Floating-point ALU operations
`define F_ALU_OP_ADD   4'b0000 
`define F_ALU_OP_SUB   4'b0001  
`define F_ALU_OP_MUL   4'b0010 
`define F_ALU_OP_MIN   4'b0011 
`define F_ALU_OP_MAX   4'b0100 
`define F_ALU_OP_EQ    4'b0101  
`define F_ALU_OP_LT    4'b0110  
`define F_ALU_OP_LE    4'b0111  

// branch conditions
`define	BR_COND_EQ	3'b000
`define BR_COND_NE	3'b001
`define BR_COND_LT	3'b100
`define BR_COND_GE	3'b101
`define BR_COND_LTU	3'b110
`define	BR_COND_GEU	3'b111

// instruction opcodes
`define	OPCODE_LUI	7'b0110111
`define	OPCODE_AUIPC	7'b0010111
`define	OPCODE_JAL	7'b1101111
`define OPCODE_JALR	7'b1100111
`define OPCODE_BRANCH	7'b1100011 // branch instruction
`define OPCODE_LOAD	7'b0000011 // load instruction
`define OPCODE_STORE	7'b0100011 // store instruction
`define	OPCODE_IMM	7'b0010011 // immediate arithmetic, logic, shift, and slt instructions
`define OPCODE_RTYPE	7'b0110011 // R-Type arithmetic, logic, shift, and slt instructions
`define OPCODE_FLOAT  7'b1010011 // Floating point instructions
`define OPCODE_FLOAD  7'b0000111 // Floating point load instructions
`define OPCODE_FSTORE 7'b0100111 // Floating point store instructions

// Floating-point instruction formats (funct7) for specific operations
`define FUNCT7_FADD_S   7'b0000000
`define FUNCT7_FSUB_S   7'b0000100
`define FUNCT7_FMUL_S   7'b0001000
`define FUNCT7_FMIN_MAX 7'b0010100
`define FUNCT7_FCMP     7'b1010000

// Floating-point instruction formats (rs2/funct3 for compare and min/max)
`define RS2_FMIN        3'b000
`define RS2_FMAX        3'b001 
`define RS2_FEQ         3'b010 
`define RS2_FLT         3'b001 
`define RS2_FLE         3'b000 

module fpu_tb;

    reg [`XLEN-1:0] inputA, inputB;
    reg [11:0] imm;
    reg [`ALUOPS_SIZE-1:0] FPU_OP;
    wire [`XLEN-1:0] result;

    // DUT instance
    fpu dut (
        .inputA(inputA),
        .inputB(inputB),
        .imm(imm),
        .FPU_OP(FPU_OP),
        .result(result)
    );

    initial begin
        $display("==== FPU Testbench (Hex Inputs & Outputs) ====");
        $dumpfile("fpu_tb.vcd");
        $dumpvars(0, fpu_tb);

        #10;

        // Add these test cases to your existing initial block in fpu_tb

// === ADD: Fractional Values with Carry ===
inputA = 32'h3F19999A; // ~1.1
inputB = 32'h3F266666; // ~1.15
FPU_OP = `F_ALU_OP_ADD;
#100;
$display("ADD 1.1 + 1.15 = %h", result); // ~2.25 (0x40200000 would be 2.5)

// === SUB: Precision Loss at Small Scales ===
inputA = 32'h3A83126F; // ~0.001
inputB = 32'h3A83126E; // ~0.0009999999
FPU_OP = `F_ALU_OP_SUB;
#100;
$display("SUB 0.001 - 0.0009999999 = %h", result); // ~1.0e-7

// === MUL: Fractional Multiplication ===
inputA = 32'h3F333333; // ~0.7
inputB = 32'h3F99999A; // ~1.2
FPU_OP = `F_ALU_OP_MUL;
#100;
$display("MUL 0.7 * 1.2 = %h", result); // ~0.84

// === MIN: Negative Fractions ===
inputA = 32'hBE4CCCCD; // -0.2
inputB = 32'hBF000000; // -0.5
FPU_OP = `F_ALU_OP_MIN;
#100;
$display("MIN(-0.2, -0.5) = %h", result);

// === MAX: Tiny Positive vs Tiny Negative ===
inputA = 32'h33D6BF95; // ~1.0e-7 (positive)
inputB = 32'hB3D6BF95; // ~-1.0e-7
FPU_OP = `F_ALU_OP_MAX;
#100;
$display("MAX(1e-7, -1e-7) = %h", result);

// === EQ: Almost Equal Fractions ===
inputA = 32'h3F7FF972; // ~0.99999
inputB = 32'h3F800000; // 1.0
FPU_OP = `F_ALU_OP_EQ;
#100;
$display("EQ 0.99999 == 1.0 -> %d", result[0]);

// === LT: Subnormal Comparison ===
inputA = 32'h00000001; // ~1.4e-45 (subnormal)
inputB = 32'h3DCCCCCD; // ~0.1 (normal)
FPU_OP = `F_ALU_OP_LT;
#100;
$display("LT 1.4e-45 < 0.1 -> %d", result[0]);

// === LE: Nearly Equal Decimals ===
inputA = 32'h3D23D70A; // ~0.04
inputB = 32'h3D23D709; // ~0.039999999
FPU_OP = `F_ALU_OP_LE;
#100;
$display("LE 0.04 <= 0.039999999 -> %d", result[0]);

// === ADD: Mantissa Overflow ===
inputA = 32'h3F7FFFFF; // ~0.99999994
inputB = 32'h3F7FFFFF; // ~0.99999994
FPU_OP = `F_ALU_OP_ADD;
#100;
$display("ADD 0.99999994 + 0.99999994 = %h", result); // ~1.99999988

// === MUL: Subnormal Result ===
inputA = 32'h3F000000; // 0.5
inputB = 32'h007FFFFF; // Largest subnormal (~1.1754942e-38)
FPU_OP = `F_ALU_OP_MUL;
#100;
$display("MUL 0.5 * subnormal = %h", result); // ~5.877471e-39

// === MIN: Mixed Normal/Subnormal ===
inputA = 32'h00000001; // Subnormal (~1.4e-45)
inputB = 32'h3DCCCCCD; // Normal (~0.1)
FPU_OP = `F_ALU_OP_MIN;
#100;
$display("MIN(subnormal, 0.1) = %h", result);

// === ADD: Rounding Toward Zero ===
inputA = 32'h3F800000; // 1.0
inputB = 32'h33800000; // ~9.8e-8
FPU_OP = `F_ALU_OP_ADD;
#100;
$display("ADD 1.0 + 9.8e-8 = %h", result); // Should round to 1.0

// === EQ: Signed Zero Comparison ===
inputA = 32'h80000000; // -0.0
inputB = 32'h00000000; // +0.0
FPU_OP = `F_ALU_OP_EQ;
#100;
$display("EQ -0.0 == +0.0 -> %d", result[0]);
end
endmodule