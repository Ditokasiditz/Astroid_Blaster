`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:47:37 11/2/2024
// Design Name: 
// Module Name:    main 
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
module main(
	input osc,
	input reset,
	input l_move,
	input r_move,
	input btn_shoot,
	input btn_reset,
	
	//input [31:0] score_input, //dit modify
	output h_sync,
	output v_sync,
	output reg [2:0] rgb_out,
	output wire [6:0] segm_out,
	output wire [3:0] common
    );
	
	reg [9:0] k = 0;
	reg [9:0] l = 0;
	reg statefbul = 0;
	reg state_bullet = 1;
	reg check_rand = 0;
	reg [9:0] add_bullet = 0;
	reg [9:0] pos_enemy = 680;
	reg [9:0] pos_enemyy = 0;
	reg [9:0] pos_2enemyy = 0;
	reg [9:0] pos_2enemyx = 600;
	reg [9:0] check_rerand = 0;
	reg [9:0] ene = 0;
	reg state_game = 1'b0;
	
	reg counte1 = 0;
	reg	check_rand2 = 0;
	
	wire [9:0] next_x;
	wire [9:0] next_y;
	wire [9:0] bullet_x;
	wire [9:0] bullet_y;
	wire is_active;
	
	reg [3:0] char = 4'b0000;
	reg [3:0] char2 = 4'b0000;
	reg [3:0] char3 = 4'b0000;
	reg [3:0] char4 = 4'b0011;
	
	reg [3:0] pt1 = 4'b0000;
	reg [3:0] pt2 = 4'b0000;
	reg [3:0] pt3 = 4'b0000;
	
	
	wire [7:0] pixels;
	wire [7:0] pixels2;
	wire [7:0] pixels3;
	wire [7:0] life;
	wire [7:0] lifes;
	
	reg [9:0]  posy7 = 50;

	
	
	vga_driver vga_dv (.clk(osc),
							.reset(reset),
							.next_x(next_x),
							.next_y(next_y),
							.h_sync(h_sync),
							.v_sync(v_sync),
							.is_active(is_active));
							

	
	wire l_move_out;
	wire l_move_out2;
	wire r_move_out;
	wire btn_shoot_out;
	wire clk1hz;
	wire clk4hr;
	wire useloop;
	wire btn_reset_out;
	
	
	module_button_edge mbe (.signal(l_move),
							  .clk(osc),
							  .signal_rising(l_move_out));
	
	module_button_edge mbe2 (.signal(r_move),
							  .clk(osc),
							  .signal_rising(r_move_out));
							  

	
	clk_divider clk_div (.clk_input(osc),
								.clk_output(clk1hz));
	
	
	module_button_edge mbe3 (.signal(clk1hz),
							  .clk(osc),
							  .signal_rising(useloop));
	

						
	module_7segment seg7_1(.char(char),
						   .rownum(next_y - posy7),
							.pixels(pixels));
							
	module_7segment seg7_2(.char(char2),
						   .rownum(next_y - posy7),
							.pixels(pixels2));
	
	module_7segment seg7_3(.char(char3),
						   .rownum(next_y - posy7),
							.pixels(pixels3));
	
	module_7segment seg7_4(.char(4'b1110),
						   .rownum(next_y - 10),
							.pixels(life));
	
	module_7segment seg7_5(.char(char4),
						   .rownum(next_y - 10),
							.pixels(lifes));
	
	clk20t4 c20t4 (.clk_20MHz(osc),
						.clk_4Hz(clk4hr));
	
	module_button_edge shoot (.signal(btn_shoot),
							 .clk(osc),
							 .signal_rising(btn_shoot_out));
							 
	module_button_edge rembt (.signal(btn_reset),
							  .clk(osc),
							  .signal_rising(btn_reset_out));
	
	FourDigitSevenSegment fdss (.clk(osc),
											.bcd1(pt1),	
											.bcd2(pt2),
											.bcd3(pt3),
											.anode(common),
											.seg(segm_out));
				
	
	
	always@(posedge osc)
	begin
		if(is_active && char4 > 4'b0000)
		begin
		//draw space ship 
			if ((next_x >= 0 + k) && (next_x <= 40 +k) && (next_y >= 450) && (next_y <= 460))
				rgb_out <= 3'b111;
			else
				rgb_out <= 3'b000;
			
			if ((next_x >= 15 + k) && (next_x <= 25 +k) && (next_y >= 440) && (next_y <= 450))
				rgb_out <= 3'b111;
			
			
		
		
			/*Heart*/
			if ((next_x >= 418) && (next_x < 426) && (next_y >= 10)&& (next_y < 10 + 8) && lifes[8 - (next_x - 410)])
				rgb_out <= 3'b111;
			if ((next_x >= 430) && (next_x < 439) && (next_y >= 10)&& (next_y < 10 + 8) && life[8 - (next_x - 430)])
				rgb_out <= 3'b111;
			
			if ((next_x >= 457) && (next_x <= 463) && (next_y >= 10) && (next_y <= 12))
				rgb_out <= 3'b100;
				
			/*if ((next_x >= 457) && (next_x <= 463) && (next_y >= 12) && (next_y <= 14))
				rgb_out <= 3'b111;
			if ((next_x >= 457) && (next_x <= 458) && (next_y >= 14) && (next_y <= 16))
				rgb_out <= 3'b111;*/
				
			if ((next_x >= 482) && (next_x <= 488) && (next_y >= 10) && (next_y <= 12))
				rgb_out <= 3'b100;
			if ((next_x >= 452) && (next_x <= 468) && (next_y >= 12) && (next_y <= 14))
				rgb_out <= 3'b100;
			
			if ((next_x >= 477) && (next_x <= 493) && (next_y >= 12) && (next_y <= 14))
				rgb_out <= 3'b100;
			if ((next_x >= 452) && (next_x <= 493) && (next_y >= 14) && (next_y <= 16))
				rgb_out <= 3'b100;
			if ((next_x >= 452) && (next_x <= 493) && (next_y >= 16) && (next_y <= 18))
				rgb_out <= 3'b100;
			if ((next_x >= 457) && (next_x <= 488) && (next_y >= 18) && (next_y <= 20))
				rgb_out <= 3'b100;
			if ((next_x >= 462) && (next_x <= 483) && (next_y >= 20) && (next_y <= 22))
				rgb_out <= 3'b100;
			if ((next_x >= 467) && (next_x <= 478) && (next_y >= 22) && (next_y <= 24))
				rgb_out <= 3'b100;
			if ((next_x >= 472) && (next_x <= 473) && (next_y >= 24) && (next_y <= 26))
				rgb_out <= 3'b100;
			
			
			if ((next_x >= 457) && (next_x <= 463) && (next_y >= 12) && (next_y <= 14))
				rgb_out <= 3'b111;
			if ((next_x >= 457) && (next_x <= 458) && (next_y >= 14) && (next_y <= 16))
				rgb_out <= 3'b111;
				
				
				
				
			if ((next_x >= 10) && (next_x <= 15) && (next_y >= 10) && (next_y <= 15))
				rgb_out <= 3'b111;
			if ((next_x >= 10) && (next_x <= 12) && (next_y >= 15) && (next_y <= 20))
				rgb_out <= 3'b111;
			if ((next_x >= 10) && (next_x <= 15) && (next_y >= 20) && (next_y <= 25))
				rgb_out <= 3'b111;
			if ((next_x >= 13) && (next_x <= 15) && (next_y >= 25) && (next_y <= 30))
				rgb_out <= 3'b111;
			if ((next_x >= 10) && (next_x <= 15) && (next_y >= 30) && (next_y <= 35))
				rgb_out <= 3'b111;
			
			if ((next_x >= 17) && (next_x <= 22) && (next_y >= 10) && (next_y <= 15))
				rgb_out <= 3'b111;
			if ((next_x >= 17) && (next_x <= 19) && (next_y >= 15) && (next_y <= 30))
				rgb_out <= 3'b111;
			if ((next_x >= 17) && (next_x <= 22) && (next_y >= 30) && (next_y <= 35))
				rgb_out <= 3'b111;
				
			
			if ((next_x >= 24) && (next_x <= 29) && (next_y >= 10) && (next_y <= 15))
				rgb_out <= 3'b111;
			if ((next_x >= 24) && (next_x <= 25) && (next_y >= 15) && (next_y <= 30))
				rgb_out <= 3'b111;
			if ((next_x >= 28) && (next_x <= 29) && (next_y >= 15) && (next_y <= 30))
				rgb_out <= 3'b111;
			if ((next_x >= 24) && (next_x <= 29) && (next_y >= 30) && (next_y <= 35))
				rgb_out <= 3'b111;
			
			if ((next_x >= 31) && (next_x <= 36) && (next_y >= 10) && (next_y <= 15))
				rgb_out <= 3'b111;
			if ((next_x >= 31) && (next_x <= 32) && (next_y >= 15) && (next_y <= 25))
				rgb_out <= 3'b111;
			if ((next_x >= 35) && (next_x <= 36) && (next_y >= 15) && (next_y <= 25))
				rgb_out <= 3'b111;
			if ((next_x >= 31) && (next_x <= 36) && (next_y >= 25) && (next_y <= 30))
				rgb_out <= 3'b111;
			if ((next_x >= 31) && (next_x <= 32) && (next_y >= 30) && (next_y <= 35))
				rgb_out <= 3'b111;
			if ((next_x >= 36) && (next_x <= 37) && (next_y >= 30) && (next_y <= 35))
				rgb_out <= 3'b111;
			
			if ((next_x >= 40) && (next_x <= 42) && (next_y >= 10) && (next_y <= 35))
				rgb_out <= 3'b111;
			if ((next_x >= 42) && (next_x <= 44) && (next_y >= 10) && (next_y <= 15))
				rgb_out <= 3'b111;
			if ((next_x >= 42) && (next_x <= 44) && (next_y >= 20) && (next_y <= 25))
				rgb_out <= 3'b111;
			if ((next_x >= 42) && (next_x <= 44) && (next_y >= 30) && (next_y <= 35))
				rgb_out <= 3'b111;
			

			/*score*/
			
			if ((next_x >= 10) && (next_x < 18) && (next_y >= posy7)&& (next_y < posy7 + 8) && pixels[8 - (next_x - 10)])
				rgb_out <= 3'b111;
			if ((next_x >= 19) && (next_x < 27) && (next_y >= posy7)&& (next_y < posy7 + 8) && pixels2[8 - (next_x - 19)])
				rgb_out <= 3'b111;
			if ((next_x >= 28) && (next_x < 36) && (next_y >= posy7)&& (next_y < posy7 + 8) && pixels3[8 - (next_x - 28)])
				rgb_out <= 3'b111;
			

			
			
			if (r_move_out)
				if (k >= 410)
					k = 410;
				else
					k = k + 40;
			if (l_move_out)
				if (k <= 0)
					k = 0;
				else
					k = k - 40;
			if (statefbul == 0)
				l = k;
			if ((next_x >= 15 + l) && (next_x <= 25 + l) && (next_y >= 450 - add_bullet) && (next_y <= 460 - add_bullet))
				rgb_out <= 3'b100;
			
			
			/*check_collision*/
			
			if ((((ene <= 15 + l) && (ene + 40 >= 15 + l)) || ((ene <= 25 + l) && (25 + l <= ene + 40))) && ((pos_enemyy - 30 <= 450 - add_bullet) && (40 + pos_enemyy >= 450 - add_bullet)))
				begin
					add_bullet = 0;
					state_bullet = 1;
					statefbul = 0;
					pos_enemyy = 0;
					check_rerand = 0;
					check_rand = 0;
					pos_enemy = pos_enemy + 640;
					char3 = char3 + 4'b0001;
					if (char3 > 4'b1001)
					begin
						char3 = 4'b0000;
						char2 = char2 + 4'b0001;
					end
					if (char2 > 4'b1001)
					begin
						char2 = 4'b0000;
						char = char + 4'b0001;
					end
					if (char > 4'b1001)
					begin
						char3 = 4'b1001;
						char2 = 4'b1001;
						char = 4'b1001;
					end
					pt1 = char;
					pt2 = char2;
					pt3 = char3;
				
				end
			
		
			
			
			/*check_collision2*/
			
			if ((((pos_2enemyx <= 15 + l) && (pos_2enemyx + 40 >= 15 + l)) || ((pos_2enemyx <= 25 + l) && (25 + l <= pos_2enemyx + 40))) && ((pos_2enemyy - 30 <= 450 - add_bullet) && (40 + pos_2enemyy >= 450 - add_bullet)))
				begin
					add_bullet = 0;
					state_bullet = 1;
					statefbul = 0;
					counte1 = 0;
					pos_2enemyy = 0;
					check_rand2 = 0;
					pos_2enemyx = pos_2enemyx + 690;
					char3 = char3 + 4'b0001;
					if (char3 > 4'b1001)
					begin
						char3 = 4'b0000;
						char2 = char2 + 4'b0001;
					end
					if (char2 > 4'b1001)
					begin
						char2 = 4'b0000;
						char = char + 4'b0001;
					end
					if (char > 4'b1001)
					begin
						char3 = 4'b1001;
						char2 = 4'b1001;
						char = 4'b1001;
					end
					pt1 = char;
					pt2 = char2;
					pt3 = char3;
				end
			
			
	
			if (btn_shoot_out)
			begin
				state_bullet = 0;
				statefbul = 1;
			end
			if (useloop && state_bullet == 0)
				add_bullet = add_bullet + 40;
			if (add_bullet >= 420)
			begin
				add_bullet = 0;
				state_bullet = 1;
				statefbul = 0;
			end
			
			
			if (check_rand == 0)
			begin
				ene = pos_enemy % 500;
				check_rand = 1;
				check_rerand = 1;
			end
			
			if (check_rand2 == 0)
			begin
				pos_2enemyx = pos_2enemyx % 500;
				check_rand2 = 1;
			end
			
			//draw enemy
			if (check_rand == 1)
			begin
				if ((next_x >= 0 + ene) && (next_x <= 40 + ene) && (next_y >= 0 + pos_enemyy) && (next_y <= 40 + pos_enemyy))
				begin	
					rgb_out <= 3'b010;
				end
				if ((next_x >= 10 + ene) && (next_x <= 30 + ene) && (next_y >= 0 + pos_enemyy) && (next_y <= 10 + pos_enemyy))
					rgb_out <= 3'b000; 
				if ((next_x >= 10 + ene) && (next_x <= 30 + ene) && (next_y >= 30 + pos_enemyy) && (next_y <= 40 + pos_enemyy))
					rgb_out <= 3'b000;
				if ((next_x >= 5 + ene) && (next_x <= 12 + ene) && (next_y >= 15 + pos_enemyy) && (next_y <= 18 + pos_enemyy))
					rgb_out <= 3'b100;
				if ((next_x >= 28 + ene) && (next_x <= 35 + ene) && (next_y >= 15 + pos_enemyy) && (next_y <= 18 + pos_enemyy))
					rgb_out <= 3'b100;

			end
			if (counte1 >= 3)
			begin
				if ((next_x >= 0 + pos_2enemyx) && (next_x <= pos_2enemyx + 40) && (next_y >= 0 + pos_2enemyy) && (next_y <= 40 + pos_2enemyy))
				begin	
					rgb_out <= 3'b111;
				end
				if ((next_x >= 10 + pos_2enemyx) && (next_x <= 30 + pos_2enemyx) && (next_y >= 0 + pos_2enemyy) && (next_y <= 10 + pos_2enemyy))
					rgb_out <= 3'b000;
				if ((next_x >= 10 + pos_2enemyx) && (next_x <= 30 + pos_2enemyx) && (next_y >= 30 + pos_2enemyy) && (next_y <= 40 + pos_2enemyy))
					rgb_out <= 3'b000;
			end
				
			if (useloop && check_rand == 1)
			begin
				pos_enemyy = pos_enemyy + 40;
				counte1 = counte1 + 1;
			end
			if (pos_enemyy >= 450)
			begin
				pos_enemyy = 0;
				check_rerand = 0;
				check_rand = 0;
				pos_enemy = pos_enemy + 640;
			end
			
			if (useloop && counte1 >= 3)
			begin
				pos_2enemyy = pos_2enemyy + 40;
			end
			
			if (pos_2enemyy >= 450)
			begin
				counte1 = 0;
				pos_2enemyy = 0;
				check_rand2 = 0;
				pos_2enemyx = pos_2enemyx + 690;
			end
	
					
			/*check_damage*/
			
			if (useloop && (((k <= ene) && (k + 40 >= ene)) || ((k  <= ene + 40) && (ene + 40 <= k  + 40))) && ((450 <= pos_enemyy + 40) && (60 + 450 >= pos_enemyy + 40)))
			begin
				//state_game = 1'b1;
				char4 = char4 - 4'b0001;
			end
			

			
			
		end
		else
		begin
			if ((next_x >= 100) && (next_x <= 110) && (next_y >= 200) && (next_y <= 250))
				rgb_out <= 3'b100;
			else
				rgb_out <= 3'b000;
			// Display "GAME OVER" text on the screen at a specific position
			// "G"
			if ((next_x >= 50 && next_x <= 110) && (next_y >= 100 && next_y <= 120))
				 rgb_out <= 3'b110; // Top horizontal line of G
			if ((next_x >= 50 && next_x <= 70) && (next_y >= 100 && next_y <= 180))
				 rgb_out <= 3'b110; // Left vertical line of G
			if ((next_x >= 90 && next_x <= 110) && (next_y >= 140 && next_y <= 160))
				 rgb_out <= 3'b110; // Middle horizontal line of G
			if ((next_x >= 90 && next_x <= 110) && (next_y >= 160 && next_y <= 180))
				 rgb_out <= 3'b110; // Bottom part of G
			if ((next_x >= 70 && next_x <= 90) && (next_y >= 160 && next_y <= 180))
				 rgb_out <= 3'b110; // Bottom horizontal extension of G

			// "A"
			if ((next_x >= 130 && next_x <= 150) && (next_y >= 100 && next_y <= 180))
				 rgb_out <= 3'b110; // Left vertical line of A
			if ((next_x >= 170 && next_x <= 190) && (next_y >= 100 && next_y <= 180))
				 rgb_out <= 3'b110; // Right vertical line of A
			if ((next_x >= 130 && next_x <= 190) && (next_y >= 100 && next_y <= 120))
				 rgb_out <= 3'b110; // Top horizontal line of A
			if ((next_x >= 150 && next_x <= 170) && (next_y >= 140 && next_y <= 160))
				 rgb_out <= 3'b110; // Middle horizontal line of A

			// "M" with Improved Clarity
			if ((next_x >= 210 && next_x <= 220) && (next_y >= 100 && next_y <= 180))
				 rgb_out <= 3'b110; // Left vertical line of M
			if ((next_x >= 250 && next_x <= 260) && (next_y >= 100 && next_y <= 180))
				 rgb_out <= 3'b110; // Right vertical line of M
			if ((next_x >= 220 && next_x <= 230) && (next_y >= 100 && next_y <= 110))
				 rgb_out <= 3'b110; // Left diagonal of M
			if ((next_x >= 240 && next_x <= 250) && (next_y >= 100 && next_y <= 110))
				 rgb_out <= 3'b110; // Right diagonal of M
			if ((next_x >= 230 && next_x <= 240) && (next_y >= 110 && next_y <= 120))
				 rgb_out <= 3'b110; // Middle peak of M

			// "E" with Improved Clarity
			if ((next_x >= 290 && next_x <= 310) && (next_y >= 100 && next_y <= 180))
				 rgb_out <= 3'b110; // Left vertical line of E
			if ((next_x >= 310 && next_x <= 340) && (next_y >= 100 && next_y <= 120))
				 rgb_out <= 3'b110; // Top horizontal line of E
			if ((next_x >= 310 && next_x <= 330) && (next_y >= 140 && next_y <= 160))
				 rgb_out <= 3'b110; // Middle horizontal line of E
			if ((next_x >= 310 && next_x <= 340) && (next_y >= 160 && next_y <= 180))
				 rgb_out <= 3'b110; // Bottom horizontal line of E

			// Row 2: "OVER" (Doubled size)

			// "O"
			if ((next_x >= 50 && next_x <= 70) && (next_y >= 200 && next_y <= 280))
				 rgb_out <= 3'b110; // Left vertical line of O
			if ((next_x >= 50 && next_x <= 110) && (next_y >= 200 && next_y <= 220))
				 rgb_out <= 3'b110; // Top horizontal line of O
			if ((next_x >= 90 && next_x <= 110) && (next_y >= 200 && next_y <= 280))
				 rgb_out <= 3'b110; // Right vertical line of O
			if ((next_x >= 50 && next_x <= 110) && (next_y >= 260 && next_y <= 280))
				 rgb_out <= 3'b110; // Bottom horizontal line of O

			// "V"
			if ((next_x >= 130 && next_x <= 140) && (next_y >= 200 && next_y <= 260))
				 rgb_out <= 3'b110; // Left vertical line of V
			if ((next_x >= 160 && next_x <= 170) && (next_y >= 200 && next_y <= 260))
				 rgb_out <= 3'b110; // Right vertical line of V
			if ((next_x >= 140 && next_x <= 160) && (next_y >= 260 && next_y <= 280))
				 rgb_out <= 3'b110; // Bottom connecting line of V

			// "E" with Improved Clarity
			if ((next_x >= 190 && next_x <= 210) && (next_y >= 200 && next_y <= 280))
				 rgb_out <= 3'b110; // Left vertical line of E
			if ((next_x >= 210 && next_x <= 240) && (next_y >= 200 && next_y <= 220))
				 rgb_out <= 3'b110; // Top horizontal line of E
			if ((next_x >= 210 && next_x <= 230) && (next_y >= 240 && next_y <= 260))
				 rgb_out <= 3'b110; // Middle horizontal line of E
			if ((next_x >= 210 && next_x <= 240) && (next_y >= 260 && next_y <= 280))
				 rgb_out <= 3'b110; // Bottom horizontal line of E

			// "R"
			if ((next_x >= 260 && next_x <= 280) && (next_y >= 200 && next_y <= 280))
				 rgb_out <= 3'b110; // Left vertical line of R
			if ((next_x >= 280 && next_x <= 310) && (next_y >= 200 && next_y <= 220))
				 rgb_out <= 3'b110; // Top horizontal line of R
			if ((next_x >= 300 && next_x <= 310) && (next_y >= 200 && next_y <= 240))
				 rgb_out <= 3'b110; // Right vertical line of R
			if ((next_x >= 280 && next_x <= 310) && (next_y >= 240 && next_y <= 260))
				 rgb_out <= 3'b110; // Middle horizontal line of R
			if ((next_x >= 290 && next_x <= 310) && (next_y >= 260 && next_y <= 280) && (next_x - 290 == next_y - 260))
				 rgb_out <= 3'b110; // Diagonal line of R


			
			if (btn_reset_out && char4 <= 4'b0000)
			begin
				char4 = 4'b0011;
				char = 4'b0000;
				char2 = 4'b0000;
				char3 = 4'b0000;
			end
			
			pt1 = char;
			pt2 = char2;
			pt3 = char3;

			
		end
	end
	
	
endmodule
