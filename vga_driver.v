`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:00:28 11/02/2024 
// Design Name: 
// Module Name:    vga_driver 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module vga_driver(
	input clk,
	input reset,
	output [9:0] next_x,
	output [9:0] next_y,
	output h_sync,
	output v_sync,
	output is_active
    );
	 
	 // Configurate for 20MHz Clk
	 // H_Sync Parameters
	 parameter [9:0] H_ACTIVE = 10'd_507;	 
	 parameter [9:0] H_FRONT = 10'd_12;
	 parameter [9:0] H_PULSE = 10'd_75;
	 parameter [9:0] H_BACK = 10'd_34;
	 
	 // V_Sync Parameters
	 parameter [9:0] V_ACTIVE = 10'd_479;
	 parameter [9:0] V_FRONT = 10'd_9;
	 parameter [9:0] V_PULSE = 10'd_1;
	 parameter [9:0] V_BACK = 10'd_32;
	 
	 // States
	 parameter [1:0] H_ACTIVE_STATE = 2'b_00;	 
	 parameter [1:0] H_FRONT_STATE = 2'b_01;
	 parameter [1:0] H_PULSE_STATE = 2'b_10;
	 parameter [1:0] H_BACK_STATE = 2'b_11;

	 parameter [1:0] V_ACTIVE_STATE = 2'b_00;	 
	 parameter [1:0] V_FRONT_STATE = 2'b_01;
	 parameter [1:0] V_PULSE_STATE = 2'b_10;
	 parameter [1:0] V_BACK_STATE = 2'b_11;
		
	 // For readability
	 parameter LOW = 1'b_0;
	 parameter HIGH = 1'b_1;
		
	 // Registers for memory of sort
	 reg h_sync_reg; 
	 reg v_sync_reg;
	 reg line_done;
	 
	 reg [9:0] h_counter;
	 reg [9:0] v_counter;
	 
	 reg [1:0] h_state;
	 reg [1:0] v_state;
	 
	 // State Machine
	 always@(posedge clk) begin
		if (reset) begin // Reset the driver
			h_counter <= 10'd_0;
			v_counter <= 10'd_0;
			
			h_state <= 2'b_00;
			v_state <= 2'b_00;
			
			line_done <= LOW;
		end
		else begin // Horizontal States
			if (h_state == H_ACTIVE_STATE) begin
				h_counter <= (h_counter == H_ACTIVE)?10'd_0:(h_counter + 10'd_1);
				h_state <= (h_counter == H_ACTIVE)?H_FRONT_STATE:H_ACTIVE_STATE;
				h_sync_reg <= HIGH;
				line_done <= LOW;
			end
			if (h_state == H_FRONT_STATE) begin
				h_counter <= (h_counter == H_FRONT)?10'd_0:(h_counter + 10'd_1);
				h_state <= (h_counter == H_FRONT)?H_PULSE_STATE:H_FRONT_STATE;
				h_sync_reg <= HIGH;
			end
			if (h_state == H_PULSE_STATE) begin
				h_counter <= (h_counter == H_PULSE)?10'd_0:(h_counter + 10'd_1);
				h_state <= (h_counter == H_PULSE)?H_BACK_STATE:H_PULSE_STATE;
				h_sync_reg <= LOW;
			end
			if (h_state == H_BACK_STATE) begin
				h_counter <= (h_counter == H_BACK)?10'd_0:(h_counter + 10'd_1);
				h_state <= (h_counter == H_BACK)?H_ACTIVE_STATE:H_BACK_STATE;
				h_sync_reg <= HIGH;
				line_done <= (h_counter == (H_BACK - 10'd_1))?HIGH:LOW;
			end
			
			if (v_state == V_ACTIVE_STATE) begin
				v_counter <= (line_done)?((v_counter == V_ACTIVE)?10'd_0:(v_counter + 10'd_1)):v_counter;
				v_state <= (line_done)?((v_counter == V_ACTIVE)?V_FRONT_STATE:V_ACTIVE_STATE):V_ACTIVE_STATE;
				v_sync_reg <= HIGH;
			end
			if (v_state == V_FRONT_STATE) begin
				v_counter <= (line_done)?((v_counter == V_FRONT)?10'd_0:(v_counter + 10'd_1)):v_counter;
				v_state <= (line_done)?((v_counter == V_FRONT)?V_PULSE_STATE:V_FRONT_STATE):V_FRONT_STATE;
				v_sync_reg <= HIGH;
			end
			if (v_state == V_PULSE_STATE) begin
				v_counter <= (line_done)?((v_counter == V_PULSE)?10'd_0:(v_counter + 10'd_1)):v_counter;
				v_state <= (line_done)?((v_counter == V_PULSE)?V_BACK_STATE:V_PULSE_STATE):V_PULSE_STATE;
				v_sync_reg <= LOW;
			end
			if (v_state == V_BACK_STATE) begin
				v_counter <= (line_done)?((v_counter == V_BACK)?10'd_0:(v_counter + 10'd_1)):v_counter;
				v_state <= (line_done)?((v_counter == V_BACK)?V_ACTIVE_STATE:V_BACK_STATE):V_BACK_STATE;
				v_sync_reg <= HIGH;
			end
		end
	 end
	 
	 assign h_sync = h_sync_reg;
	 assign v_sync = v_sync_reg;
	
	 assign next_x = (h_state==H_ACTIVE_STATE)?h_counter:10'd_0;
	 assign next_y = (v_state==V_ACTIVE_STATE)?v_counter:10'd_0;
	 
	 assign is_active = ((h_state==H_ACTIVE_STATE) && (v_state==V_ACTIVE_STATE));

endmodule
