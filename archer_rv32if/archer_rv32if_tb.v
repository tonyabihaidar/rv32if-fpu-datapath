`timescale 1ns / 1ps

module archer_rv32if_tb();

  reg clk;
  reg rst_n;

  // Instantiate the DUT (Device Under Test)
  archer_rv32if dut (
    .clk(clk),
    .rst_n(rst_n)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk; // 10ns clock period -> 100 MHz
  end

  // Reset and Stimulus
  initial begin
    // Initialize reset
    rst_n = 0;

    // Hold reset low for a few cycles
    #20;
    rst_n = 1;

    // Run simulation for some time
    #1000;

    // Finish simulation
    $finish;
  end

  // Optionally dump VCD file for waveform viewing
  initial begin
    $dumpfile("archer_rv32if_tb.vcd");
    $dumpvars(0, archer_rv32if_tb);
  end

endmodule
