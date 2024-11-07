`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    02:20:05 11/02/2024
// Design Name: 
// Module Name:    mod20Mto20K 
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
module mod20Mto20K(
	 input wire clk_20MHz,
    output reg clk_20kHz
    );
	 
	 reg [24:0] count;  // Adjust the bit width based on the desired division ratio

	 always @(posedge clk_20MHz) 
	 begin
    if (count == 1000) 
	 begin  // Adjust this value based on the division ratio
        count <= 0;
        clk_20kHz <= ~clk_20kHz;  // Toggle the output clock
    end 
	 else 
	 begin
        count <= count + 1;
    end
	end


endmodule
