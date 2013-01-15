`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:01:26 12/21/2012
// Design Name:   mod_m_counter
// Module Name:   C:/data/logic/Synth1/mod_m_counter_tb.v
// Project Name:  Synth1
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: mod_m_counter
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module mod_m_counter_tb;

	// Declarations
	localparam	T = 20;	// clock period in ns
	reg clk;
	reg reset;
	wire max_tick;
	wire [3:0] q;

	// Instantiate the Unit Under Test (UUT)
	// mod=10, 4 bits
	mod_m_counter uut (
		.clk(clk), 
		.reset(reset), 
		.max_tick(max_tick), 
		.q(q)
	);

	// Clock
	always
	begin
		clk = 1'b1;
		#(T/2);
		clk = 1'b0;
		#(T/2);
	end
	
	// reset for the first half cycle
	initial
	begin
		reset = 1'b1;
		#(T/2);
		reset = 1'b0;
 	end
      
endmodule

