`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/25/2025 10:36:07 AM
// Design Name: 
// Module Name: fifo
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


module fifo
#(parameter DATAWIDTH = 8, DEPTH = 16)
(
    input clk,
    input resetn,
    input [DATAWIDTH - 1:0] wr_data,
    input wr_en,
    input rd_en,
    
    output logic [DATAWIDTH - 1:0]rd_data,
    output logic full,
    output logic empty
    );
    
    logic [DATAWIDTH - 1:0] memory [DEPTH -1:0];
    logic [$clog2(DEPTH): 0] data_cnt;
    logic [$clog2(DEPTH) - 1: 0] wptr, rptr;
    
    wire read_enable, write_enable;
    
    assign read_enable = rd_en & (~empty);
    assign write_enable = wr_en & (~full);
    
    always_ff @(posedge clk, negedge resetn) begin
        if (!resetn) begin
            for (int i=0; i<DEPTH; i++) begin
                memory[i] <= 0;
            end
            wptr <= 0;
        end else begin
            if (write_enable) begin
                memory[wptr] <= wr_data;
                wptr <= wptr + 1;
            end
        end
    end
    
    always_ff @(posedge clk, negedge resetn) begin
        if (!resetn) begin
            rd_data <= 0;
            rptr <= 0;
        end else begin
            if (read_enable) begin
                rd_data <= memory[rptr];
                rptr <= rptr + 1;
            end
        end
    end
    
    always_ff @(posedge clk, negedge resetn) begin
        if (!resetn) begin
            data_cnt <= 0;
        end else begin
            if (read_enable & (~write_enable)) begin
                data_cnt <= data_cnt - 1;
            end else if ((~read_enable) & write_enable) begin
                data_cnt <= data_cnt + 1;
            end else begin
                data_cnt <= data_cnt;
            end
        end
    end
    
    assign full = (data_cnt == DEPTH);
    assign empty = (data_cnt == 0);
endmodule