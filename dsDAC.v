`timescale 1ns / 1ps
//'define MSBI 7 // Most significant Bit of DAC input

//This is a Delta-Sigma Digital to Analog Converter

module dsDAC
	#(
		parameter N=8			// DAC bit width
	)
	(
    output reg out,			// This is the average output that feeds low pass filter
									// for optimum performance, ensure that this ff is in IOB
	 input [N-1:0] in,		// DAC input (excess 2**MSBI)
	 input clk,
	 input reset
	 );

	reg [N+1:0] DeltaAdder;	// Output of Delta adder
	reg [N+1:0] SigmaAdder;	// Output of Sigma adder
	reg [N+1:0] SigmaLatch;	// Latches output of Sigma adder
	reg [N+1:0] DeltaB;			// B input of Delta adder
	
	always @(SigmaLatch)
		DeltaB = {SigmaLatch[N+1], SigmaLatch[N+1]} << N;
		
	always @(in, DeltaB)
		DeltaAdder = in + DeltaB;
		
	always @(DeltaAdder, SigmaLatch)
		SigmaAdder = DeltaAdder + SigmaLatch;

	always @(posedge clk, posedge reset)
	begin
		if(reset)
			begin
				SigmaLatch <= 1'b1 << N;
				out <= 1'b0;
			end
		else
			begin
				SigmaLatch <= SigmaAdder;
				out <= SigmaLatch[N+1];
			end
	end
		
endmodule
