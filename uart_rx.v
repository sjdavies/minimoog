`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer:       Pong Chu
// 
// Create Date:    15:23:50 22 December 2012 
// Design Name: 
// Module Name:    uart_rx 
// Project Name:   MiniMoog Sytnh simulator
// Target Devices: Spartan 6
// Tool versions:  ISE 14.4
//
// Description:    UART design sourced from book 'FPGA Prototyping by Verilog Examples' by Pong Chu.
//                 ISBN 9780470185322.
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module uart_rx
	#(
		parameter DBIT = 8,		// # data bits
					 SB_TICK = 16	// # ticks for stop bit
	)
	(
    input clk,
    input reset,
    input rx,
    input s_tick,
    output reg rx_done_tick,
    output [7:0] dout
    );

	// Symbolic state declaration
	localparam [1:0] 
		IDLE	= 2'b00,
		START	= 2'b01,
		DATA	= 2'b10,
		STOP	= 2'b11;
		
	// signal declaration
	reg [1:0] state_reg, state_next;
	reg [3:0] s_reg, s_next;		// counter, #s_ticks, 7 in START, 15 in DATA
	reg [2:0] n_reg, n_next;		// counter, # of data bits in DATA state
	reg [7:0] b_reg, b_next;		// shifted data bits
	
	// body
	// FSMD state & data registers
	always @(posedge clk, posedge reset)
		if (reset)
			begin
				state_reg <= IDLE;
				s_reg <= 0;
				n_reg <= 0;
				b_reg <= 0;
			end
		else
			begin
				state_reg <= state_next;
				s_reg <= s_next;
				n_reg <= n_next;
				b_reg <= b_next;
			end
			
	// FSMD next-state logic
	always @*
	begin
		state_next = state_reg;
		rx_done_tick = 1'b0;
		s_next = s_reg;
		n_next = n_reg;
		b_next = b_reg;
		
		case (state_reg)
			IDLE:
				if (~rx)
					begin
						state_next = START;
						s_next = 0;
					end
			START:
				if (s_tick)
					if (s_reg == 7)
						begin
							state_next = DATA;
							s_next = 0;
							n_next = 0;
						end
					else
						s_next = s_reg + 1;
			DATA:
				if (s_tick)
					if (s_reg == 15)
						begin
							s_next = 0;
							b_next = {rx, b_reg[7:1]};
							if (n_reg == (DBIT-1))
								state_next = STOP;
							else
								n_next = n_reg + 1;
						end
					else
						s_next = s_reg + 1;
			STOP:
				if (s_tick)
					if (s_reg ==(SB_TICK-1))
						begin
							state_next = IDLE;
							rx_done_tick = 1'b1;
						end
					else
						s_next = s_reg + 1;
		endcase
	end
	
	// output
	assign dout = b_reg;
	
endmodule
