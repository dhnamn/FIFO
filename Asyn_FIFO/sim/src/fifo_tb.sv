`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/25/2025 01:16:09 PM
// Design Name: 
// Module Name: fifo_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module fifo_tb;
    // Parameters
    parameter DATAWIDTH = 8;
    parameter DEPTH = 4;
    
    // Input/output
    logic clk;
    logic resetn;
    logic [DATAWIDTH-1:0] wr_data;
    logic wr_en;
    logic rd_en;
    logic [DATAWIDTH-1:0] rd_data;
    logic full;
    logic empty;
    
    // DUT
    fifo #(
    .DATAWIDTH(DATAWIDTH),
    .DEPTH(DEPTH)
    ) dut (
    .clk(clk),
    .resetn(resetn),
    .wr_data(wr_data),
    .wr_en(wr_en),
    .rd_en(rd_en),
    .rd_data(rd_data),
    .full(full),
    .empty(empty)
    );
    
    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk; // 100MHz
    
    // Initial state
    initial begin
    wr_data = 0;
    wr_en = 0;
    rd_en = 0;
    
    // Reset
    resetn = 0;
    #20;
    resetn = 1;
    end
    
    // Write process at negedge clk
    initial begin
    // Wait until out of reset
    @(posedge resetn);
    #10;
    
    repeat (DEPTH + 1) begin
      @(negedge clk);
      wr_data <= $random;
      wr_en <= 1;
    end
    
    @(negedge clk);
    wr_en <= 0;
    end
    
    // Read process at negedge clk
    initial begin
    // Wait for write to finish
    @(posedge resetn);
    #10;
    #(DEPTH * 10); // Wait enough time for all writes
    
    repeat (DEPTH) begin
      @(negedge clk);
      rd_en = 1;
    end
    
    @(negedge clk);
    rd_en = 0;
    
    // Finish after some time
    #20;
    $finish;
    end 

endmodule
