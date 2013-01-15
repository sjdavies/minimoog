`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:21:49 12/20/2012 
// Design Name: 
// Module Name:    PAConverter 
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
 module PAConverter(
    input [31:0] phase,
    input [2:0] waveform,
    output reg [11:0] amplitude
    );

	always @ (waveform or phase[31:24])
		case (waveform)
			// square wave - 50% duty cycle
			3'b001:
				amplitude = {12{!phase[31]}};
			// square wave - 35% duty cycle
			3'b010:
				begin
					if (phase[31:24] <= 8'd89)
						amplitude = {12'b11111111111};
					else
						amplitude = {12'b00000000000};
				end
			// square wave - 15% duty cycle
			3'b011:
				begin
					if (phase[31:24] <= 8'd38)
						amplitude = {12'b11111111111};
					else
						amplitude = {12'b00000000000};
				end
			// sawtooth
			default:
				amplitude = {phase[31:20]};
		endcase
			
endmodule
