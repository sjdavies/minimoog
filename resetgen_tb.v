`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:33:17 01/06/2013
// Design Name:   resetgen
// Module Name:   C:/data/logic/Synth1/resetgen_tb.v
// Project Name:  Synth1
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: resetgen
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module resetgen_tb;

	localparam T=20;		// 50MHz clock period
	
	// Inputs
	reg clk;

	// Outputs
	wire reset;

	// Instantiate the Unit Under Test (UUT)
	resetgen uut (
		.clk(clk), 
		.reset(reset)
	);

   always
	begin
	   clk = 1'b1;
		#(T/2);
		clk = 1'b0;
		#(T/2);
	end
endmodule

