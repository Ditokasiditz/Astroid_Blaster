`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:55:04 11/02/2024
// Design Name: 
// Module Name:    clk_divider 
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
module clk_divider(
	input wire clk_input,
	output reg	clk_output
    );

reg	[23:0] counter;

always @ (posedge clk_input) begin
	if (counter == 24'd2499999) begin
		counter <= 0;
		clk_output <= ~clk_output;
	end
	else begin
		counter <= counter + 1;
	end
end	
endmodule
