`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer:       Stephen Davies
// 
// Create Date:    20:33:58 17 Jan 2013 
// Module Name:    mpSwitch 
// Project Name:   Minimoog Synth
// Target Devices: Spartan 6
// Tool versions:  ISE 14.4
// Description:    Decodes analog values from 6 position switch. Switch has 8 bit ADC converter
//                 decoding voltages 0, 1, 2, 3, 4, and 5.
//
// Dependencies: 
//
// Revision:       0.01
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module sw6 (
    input [7:0] a,
    output reg [2:0] y
    );

	// With 1 volt/step, step size is approximately 51/volt.
	// Thresholds pick the midpoints between voltage ranges.
	localparam THRESHOLD_0_1 = 26;		// 0-1 volts
	localparam THRESHOLD_1_2 = 76;		// 1-2 volts
	localparam THRESHOLD_2_3 = 127;		// 2-3 volts
	localparam THRESHOLD_3_4 = 178;		// 3-4 volts
	localparam THRESHOLD_4_5 = 230;		// 4-5 volts
	
	always @(a)
		if (a < THRESHOLD_0_1)
			y = 3'b000;
		else if (a < THRESHOLD_1_2)
			y = 3'b001;
		else if (a < THRESHOLD_2_3)
			y = 3'b010;
		else if (a < THRESHOLD_3_4)
			y = 3'b011;
		else if (a < THRESHOLD_4_5)
			y = 3'b100;
		else
			y = 3'b101;
			
endmodule
