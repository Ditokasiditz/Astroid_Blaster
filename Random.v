`timescale 1ns / 1ps

module Random(
    input clk,
    input reset,
    input enable,
    output reg [15:0] random_number,
    output reg valid
);

    reg [31:0] lfsr1, lfsr1_next;
    reg [31:0] lfsr2, lfsr2_next;
    reg [31:0] lfsr3, lfsr3_next;
    reg [3:0] counter;
    reg [3:0] counter_next;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr1 <= 32'h80000057;
            lfsr2 <= 32'h0000000B;
            lfsr3 <= 32'h00000101;
            counter <= 0;
            valid <= 0;
        end else begin
            if (enable) begin
                // Update the LFSRs using different feedback taps
                lfsr1_next = lfsr1 ^ (lfsr1 >> 7) ^ (lfsr1 >> 16) ^ (lfsr1 >> 30);
                lfsr2_next = lfsr2 ^ (lfsr2 >> 13) ^ (lfsr2 >> 23) ^ (lfsr2 >> 31);
                lfsr3_next = lfsr3 ^ (lfsr3 >> 11) ^ (lfsr3 >> 18) ^ (lfsr3 >> 29);
                lfsr1 <= lfsr1_next;
                lfsr2 <= lfsr2_next;
                lfsr3 <= lfsr3_next;

                // Increment the counter
                counter_next = counter + 1;
                counter <= counter_next;

                // Generate a new random number every 16 clock cycles
                if (counter == 4'b1111) begin
                    random_number <= (lfsr1[15:0] ^ lfsr2[15:0] ^ lfsr3[15:0]);
                    valid <= 1;
                end else begin
                    valid <= 0;
                end
            end else begin
                valid <= 0;
            end
        end
    end

endmodule