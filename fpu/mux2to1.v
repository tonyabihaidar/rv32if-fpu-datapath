`include "archerdefs.v"

module mux2to1 (
	input sel,
	input [`XLEN-1:0] input0,
	input [`XLEN-1:0] input1,
	output [`XLEN-1:0] muxout
	);
	
  assign muxout = (sel == 1'b0) ? input0 : input1;
  
endmodule