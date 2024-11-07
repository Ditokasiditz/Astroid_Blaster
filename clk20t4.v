`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:13:43 11/03/2024
// Design Name: 
// Module Name:    clk20t4 
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
module clk20t4(
    input wire clk_20MHz,     // 20 MHz input clock
    output reg clk_4Hz        // 4 Hz output clock
    );
	 
	 // Parameters for clock division
	parameter DIVIDER_VALUE = 5000000;  // Divide 20 MHz by 5,000,000 to get 4 Hz

	// Internal signals
	reg [23:0] counter = 0;

	always @(posedge clk_20MHz) begin
    if (counter == DIVIDER_VALUE - 1) begin
        counter <= 0;
        clk_4Hz <= ~clk_4Hz;  // Toggle the output clock
    end else begin
        counter <= counter + 1;
    end
	end


endmodule
