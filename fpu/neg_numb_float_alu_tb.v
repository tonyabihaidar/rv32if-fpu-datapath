`timescale 1ns / 1ps

// === DEFINES ===
`define XLEN            32
`define ALUOPS_SIZE     5

// Floating-point ALU operations
`define F_ALU_OP_ADD    4'b0000 
`define F_ALU_OP_SUB    4'b0001  
`define F_ALU_OP_MUL    4'b0010 
`define F_ALU_OP_MIN    4'b0011 
`define F_ALU_OP_MAX    4'b0100 
`define F_ALU_OP_EQ     4'b0101  
`define F_ALU_OP_LT     4'b0110  
`define F_ALU_OP_LE     4'b0111  

module fpu_tb;

    reg [`XLEN-1:0] inputA, inputB;
    reg [11:0] imm;
    reg [`ALUOPS_SIZE-1:0] FPU_OP;
    wire [`XLEN-1:0] result;

    // Instantiate the FPU
    fpu dut (
        .inputA(inputA),
        .inputB(inputB),
        .imm(imm),
        .FPU_OP(FPU_OP),
        .result(result)
    );

    initial begin
        $display("==== FPU Negative Numbers Testbench ====");
        $dumpfile("fpu_tb.v");
        $dumpvars(0, fpu_tb);

        imm = 12'd0; // Not used

        #5; // Short initial wait

        // === Negative Numbers Functional Tests ===

        // ADD (-1.5) + (-2.0) = -3.5
        inputA = 32'hBFC00000; inputB = 32'hC0000000; FPU_OP = `F_ALU_OP_ADD; #20;
        $display("ADD -1.5 + -2.0 = %h (EXPECTED: C0600000)", result);

        // SUB (-5.0) - (-2.0) = -3.0
        inputA = 32'hC0A00000; inputB = 32'hC0000000; FPU_OP = `F_ALU_OP_SUB; #20;
        $display("SUB -5.0 - (-2.0) = %h (EXPECTED: C0400000)", result);

        // MUL (-3.0) * (-2.0) = 6.0
        inputA = 32'hC0400000; inputB = 32'hC0000000; FPU_OP = `F_ALU_OP_MUL; #20;
        $display("MUL -3.0 * -2.0 = %h (EXPECTED: 40C00000)", result);

        // MIN (-2.0, -5.0) = -5.0
        inputA = 32'hC0000000; inputB = 32'hC0A00000; FPU_OP = `F_ALU_OP_MIN; #20;
        $display("MIN(-2.0, -5.0) = %h (EXPECTED: C0A00000)", result);

        // MAX (-2.0, -5.0) = -2.0
        inputA = 32'hC0000000; inputB = 32'hC0A00000; FPU_OP = `F_ALU_OP_MAX; #20;
        $display("MAX(-2.0, -5.0) = %h (EXPECTED: C0000000)", result);

        // EQ (-2.0 == -2.0) = 1
        inputA = 32'hC0000000; inputB = 32'hC0000000; FPU_OP = `F_ALU_OP_EQ; #20;
        $display("EQ -2.0 == -2.0 -> %d (EXPECTED: 1)", result[0]);

        // LT (-5.0 < -2.0) = 1
        inputA = 32'hC0A00000; inputB = 32'hC0000000; FPU_OP = `F_ALU_OP_LT; #20;
        $display("LT -5.0 < -2.0 -> %d (EXPECTED: 1)", result[0]);

        // LE (-5.0 <= -2.0) = 1
        inputA = 32'hC0A00000; inputB = 32'hC0000000; FPU_OP = `F_ALU_OP_LE; #20;
        $display("LE -5.0 <= -2.0 -> %d (EXPECTED: 1)", result[0]);

        // LT (-2.0 < -5.0) = 0
        inputA = 32'hC0000000; inputB = 32'hC0A00000; FPU_OP = `F_ALU_OP_LT; #20;
        $display("LT -2.0 < -5.0 -> %d (EXPECTED: 0)", result[0]);

        $display("==== FPU Negative Test Complete ====");
        $finish;
    end

endmodule
