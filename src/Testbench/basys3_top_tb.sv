`timescale 1ns/1ps
 
module basys3_top_tb;
 
  logic        clk;
  logic        btnC;
  logic [4:0]  sw;
  logic [4:0]  led;
  logic [6:0]  seg;
  logic [3:0]  an;
 
  basys3_top dut (
    .clk  (clk),
    .btnC (btnC),
    .sw   (sw),
    .led  (led),
    .seg  (seg),
    .an   (an)
  );
 
  // 10ns clock
  initial clk = 0;
  always #5 clk = ~clk;
 
  initial begin
    // Assert reset
    btnC = 1;
    sw   = 5'd0;
    #20;
 
    // Release reset, let program run for 500ns
    btnC = 0;
    #500;
 
    // Check x0 (should always be 0)
    sw = 5'd0;
    #20;
    $display("x0  = %h (expected: 00000000)", dut.reg_data);
 
    // Check x1
    sw = 5'd1;
    #20;
    $display("x1  = %h", dut.reg_data);
 
    // Check x2
    sw = 5'd2;
    #20;
    $display("x2  = %h", dut.reg_data);
 
    // Check x3
    sw = 5'd3;
    #20;
    $display("x3  = %h", dut.reg_data);
 
    // Check x4
    sw = 5'd4;
    #20;
    $display("x4  = %h", dut.reg_data);
 
    #50;
    $display("Simulation complete.");
    $finish;
  end
 
endmodule