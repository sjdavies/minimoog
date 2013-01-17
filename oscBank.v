`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer:       Stephen Davies
// 
// Create Date:    19:06:09 17 Jan 2013 
// Design Name: 
// Module Name:    oscBank 
// Project Name:   Minimoog synth
// Target Devices: Spartan 6
// Tool versions:  ISE 14.4
// Description:    Simulates the 3 oscillators in the Minimoog oscillator bank.
//                 Uses DDS techniques, there are 3 numerically controlled oscillators.
//
//                 The 8 front panel controls:
//                 - Range (x3)     - 2', 4', 8', 16', 32' and LO
//                 - Frequency (x2) - not on Osc 1
//                 - Waveform (x3)  - sawtooth, square pulse etc. 
//                 are implemented using 8 analog ports from the Retrocade wing.
//                 Multipole switches are wired as multi-step voltage dividers.
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module oscBank (

   input clk,								// 32 MHz system clock
	input reset,	
	
   input [6:0] note,						// current MIDI note number, 0 if none
	input [13:0] bend,					// MIDI pitch control wheel value, centre = 14'h2000
	 
   output [2:0] addr,						// Analog RAM address - selects one of the 8 available analog ports
   input [7:0] data,						// Analog RAM data - value of selected analog port

   output [11:0] osc1,					// OSC 1 output signal
   output [11:0] osc2,					// OSC 2 output signal
   output [11:0] osc3					// OSC 3 output signal
   );

	reg [4:0] count;
	wire [2:0] sw;
	
	reg [2:0] range1;
	reg [2:0] range2;
	reg [2:0] range3;
	
	reg [7:0] freq1;
	reg [7:0] freq2;
	
	reg [2:0] waveform1;
	reg [2:0] waveform2;
	reg [2:0] waveform3;

	wire [31:0] fcw;

	assign addr = count[2:0];
	assign ncoTick = &count;
	
	// continuous counter, used to generate machine timing in module
   always @(posedge clk, posedge reset)
		if (reset)
			count <= 5'b0;
		else
			count <= count + 5'b1;

	// convert analog data to switch position value
	sw6 switch6Position (.a(data), .y(sw));
	
	// latch 1 of 8 possible translated analog values
	always @(posedge clk)
		case (addr)
			3'b000:	range1 <= sw;
			3'b001:	range2 <= sw;
			3'b010:	range3 <= sw;
			3'b011:	freq1 <= data;
			3'b100:	freq2 <= data;
			3'b101:	waveform1 <= sw;
			3'b110:	waveform2 <= sw;
			default:	waveform3 <= sw;
		endcase
		
	NoteTable noteLookup (.midiNote(note), .freqControl(fcw));
	
	nco oscillator1 (.clk(clk), .reset(reset), .nco(ncoTick), .fcw(fcw), .wave(waveform1), .out(osc1));
	nco oscillator2 (.clk(clk), .reset(reset), .nco(ncoTick), .fcw(fcw), .wave(waveform2), .out(osc2));
	nco oscillator3 (.clk(clk), .reset(reset), .nco(ncoTick), .fcw(fcw), .wave(waveform3), .out(osc3));
	
endmodule
