`include "archerdefs.v"


module add4 (
	  input [`XLEN-1:0] datain,
	  output [`XLEN-1:0] result
	);
	
  assign result = datain + `XLEN'd4;
endmodule