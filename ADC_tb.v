`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:12:31 01/10/2013
// Design Name:   spiAdc
// Module Name:   C:/data/logic/S3test/spiAdc_tb.v
// Project Name:  S3test
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: spiAdc
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module spiAdc_tb;

	localparam T = 40;	// clock period in ns

	// Inputs
	reg clk;
	reg reset;
	reg di;

	// Outputs
	wire sck;
	wire cs_n;
	wire dout;

	// Instantiate the Unit Under Test (UUT)
	spiAdc uut (
		.clk(clk), 
		.reset(reset), 
		.din(di), 
		.sck(sck), 
		.cs_n(cs_n), 
		.dout(dout)
	);

	// Clock
	always
	begin
		clk = 1'b1;
		#(T/2);
		clk = 1'b0;
		#(T/2);
	end

	initial begin
		// Initialize Inputs
		reset = 1;
		di = 0;

		// Wait 100 ns for global reset to finish
		#100;
		reset = 0;
		
		// Add stimulus here

	end
      
endmodule

