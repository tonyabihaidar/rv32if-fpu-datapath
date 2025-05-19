`include "archerdefs.v"

module float_regfile(
    input clk,
	input rst_n,
	input FRegWrite,
	input [`LOG2_XRF_SIZE-1:0] rs1,
	input [`LOG2_XRF_SIZE-1:0] rs2,
	input [`LOG2_XRF_SIZE-1:0] rd,
	input [`XLEN-1:0] datain,
	output [`XLEN-1:0] regA,
	output [`XLEN-1:0] regB
    );

    integer i;
    reg [`XLEN-1:0] FRF [0:(2**(`LOG2_XRF_SIZE))-1];
    
    assign regA = FRF[rs1]; //FRF: Float Register File
    assign regB = FRF[rs2];
    
    always @(posedge clk) //no special handling for f0 not like x0
    begin
        if (rst_n == 1'b0)
        begin
            for (i = 0; i < (2**(`LOG2_XRF_SIZE)); i = i + 1) 
            begin
            FRF[i] <= `XLEN'd0;
            end
        end
        else if ((FRegWrite == 1'b1))
            FRF[rd] <= datain;
    end
    
    initial 
    begin
        for (i = 0; i < (2**(`LOG2_XRF_SIZE)); i = i + 1) 
        begin
        FRF[i] = `XLEN'd0;
        end
    end
endmodule
