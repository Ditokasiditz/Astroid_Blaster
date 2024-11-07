`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:21:55 11/10/2023 
// Design Name: 
// Module Name:    score 
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

module score(
  input [31:0] score,
  input clk,
  output reg [6:0] seg_a, seg_b, seg_c, seg_d, seg_e, seg_f, seg_g
);

  reg [3:0] digit_selector;
  reg [6:0] seven_segment_data;
  reg [6:0] seven_segment_data_text; // Declare seven_segment_data_text


  always @(posedge clk) begin
    // Increment the digit selector
    digit_selector <= (digit_selector == 3) ? 0 : digit_selector + 1;

    // Determine the seven-segment code for the current digit
    case(digit_selector)
      0: seven_segment_data <= 7'b1000000; // 0
      1: seven_segment_data <= 7'b1111001; // 1
      2: seven_segment_data <= 7'b0100100; // 2
      3: seven_segment_data <= 7'b0110000; // 3
      default: seven_segment_data <= 7'b1111111; // Turn off all segments if unexpected value
    endcase
	 
	 // Determine the seven-segment code for the text "Score"
      case(digit_selector)
        0: seven_segment_data_text <= 7'b0111101; // S
        1: seven_segment_data_text <= 7'b1001000; // c
        2: seven_segment_data_text <= 7'b1001000; // o
        3: seven_segment_data_text <= 7'b0111101; // r
        default: seven_segment_data_text <= 7'b1111111; // Turn off all segments if unexpected value
    endcase
	 

    // Display the current digit on the seven-segment display
    case(digit_selector)
      0: begin seg_a <= seven_segment_data[0]; seg_b <= seven_segment_data[1]; seg_c <= seven_segment_data[2]; seg_d <= seven_segment_data[3]; end
      1: begin seg_a <= seven_segment_data[0]; seg_b <= seven_segment_data[1]; seg_c <= seven_segment_data[2]; seg_d <= seven_segment_data[3]; end
      2: begin seg_a <= seven_segment_data[0]; seg_b <= seven_segment_data[1]; seg_c <= seven_segment_data[2]; seg_d <= seven_segment_data[3]; end
      3: begin seg_a <= seven_segment_data[0]; seg_b <= seven_segment_data[1]; seg_c <= seven_segment_data[2]; seg_d <= seven_segment_data[3]; end
      default: begin seg_a <= 1'b0; seg_b <= 1'b0; seg_c <= 1'b0; seg_d <= 1'b0; end
    endcase
  end

endmodule
