`include "archerdefs.v"

module pc (
	input clk,
	input rst_n,
	input [`XLEN-1:0] datain,
	output reg [`XLEN-1:0] dataout
	);
  
  always @(posedge clk) 
  begin
    if (rst_n == 1'b0)
      dataout <= `XLEN'd0;
    else
      dataout <= datain;
  end
  
endmodule
