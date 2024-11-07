`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:58:40 11/02/2024
// Design Name: 
// Module Name:    FourDigitSevenSegment 
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
module FourDigitSevenSegment(
	input wire clk, 
	input wire [3:0] bcd1,   // 4-bit BCD input
	input wire [3:0] bcd2,   // 4-bit BCD input
	input wire [3:0] bcd3,   // 4-bit BCD input
	 output wire [3:0] anode,  // Common anode signals
    output wire [6:0] seg   // 7-segment display output
    );
	 
	 reg [1:0] digit_counter = 2'b00;
	 
	 // Define the 7-segment codes for digits 0 to 9
	reg [6:0] seven_seg_codes [0:9] = {
    7'b0111111, // 0
    7'b0000110, // 1
    7'b1011011, // 2
    7'b1001111, // 3
    7'b1100110, // 4
    7'b1101101, // 5
    7'b1111101, // 6
    7'b0000111, // 7
    7'b1111111, // 8
    7'b1100111  // 9
	};
	
	// Output for the current 7-segment code and common anode
	reg [6:0] current_seg;
	reg [3:0] current_anode;
	
	
	//current_seg <= seven_seg_codes[bcd1];
	
	always @(posedge clk) begin
    // Increment the counter on each clock edge
    //digit_counter <= digit_counter + 1;

    // Update the display based on the current digit counter
    case (digit_counter)
        2'b00: begin
				//current_seg <= seven_seg_codes[bcd1];
            //current_anode <= 4'b1011; // Enable the third common anode

        end
        2'b01: begin
            current_seg <= seven_seg_codes[bcd2];
            current_anode <= 4'b1101; // Enable the second common anode
        end
        2'b10: begin
				current_seg <= seven_seg_codes[bcd3];
            current_anode <= 4'b1110; // Enable the first common anode
        end
        2'b11: begin
            //current_seg <= 7'b0000000;
            //current_anode <= 4'b0111; // Enable the fourth common anode
        end
    endcase
	 
	 digit_counter <= digit_counter + 1;
end

// Output assignment
assign seg = current_seg;
assign anode = current_anode;



endmodule
