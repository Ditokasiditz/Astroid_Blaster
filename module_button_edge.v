`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:42:04 11/02/2024
// Design Name: 
// Module Name:    module_button_edge 
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
module module_button_edge(
  input signal,
  input clk,
  output signal_rising
    );
	reg signal_delay;

	always @(posedge clk) signal_delay <= signal;

	assign signal_rising = signal & ~signal_delay;

endmodule
