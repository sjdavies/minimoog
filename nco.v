`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:02:38 01/17/2013 
// Design Name: 
// Module Name:    nco 
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
module nco(
    input clk,
    input reset,
    input nco,
    input [31:0] fcw,
    input [2:0] wave,
    output [11:0] out
    );

	reg [31:0] accum;

	always @(posedge clk, posedge reset)
		if (reset)
			accum <= 0;
		else if (nco)
			accum <= accum + fcw;
		else
			accum <= accum;
		
	PAConverter pac (.amplitude(out), .phase(accum), .waveform(wave) );


endmodule
