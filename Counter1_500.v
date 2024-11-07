`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:38:44 1/11/2024 
// Design Name: 
// Module Name:    Counter1_500 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Counter1_500(
    input wire clk,
	output reg [9:0] count,
	output integer count_integer
	 );
	reg [9:0] next_count;

  always @(posedge clk) begin
    if (count == 10'd500) begin
      next_count <= 10'd1;
    end else begin
      next_count <= count + 1;
    end
  end

  always @(posedge clk) begin
    count <= next_count;
	 count_integer = count;
  end

endmodule
