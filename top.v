`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer:       Stephen Davies
// 
// Create Date:    16:37:10 2 Dec 2012 
// Module Name:    top 
// Project Name:   MiniMoog Synth simulator
// Target Devices: Spartan 6
// Tool versions:  ISE 14.4
// Description:    Top level module for use with Papilio Pro board & Retrocade Synth Megawing mounted.
//
// Dependencies: 
//
// Revision:       0.02
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module top(

   input				CLK,					// 32 MHz signal from crystal oscillator
	
	// Analog output pins (connected to RC network for low pass filter)
	output			A1L,
	output			A1R,
	output			A2L,
	//output			A2R,
	
	// ADC port #1
	output			ADC1_SCK,
	output			ADC1_nCS,
	output			ADC1_DI,
	input				ADC1_DO,

	// ADC port #2
	output			ADC2_SCK,
	output			ADC2_nCS,
	output			ADC2_DI,
	input				ADC2_DO,
	
	// utility wing
	output [7:0]  A,
	
	// Unused resources that need to be put into an inert state
	output			SDRAM_nCS
	
   );

	localparam		DAC_WIDTH = 12;		// DAC size in bits
	
	wire clk0;			// Buffered 32MHz clock (system clock)
	wire clk16;			// Buffered 16Mhz clock (for ADC SPI)
	wire clk16_180;   // Buffered 16Mhz clock (for ADC SPI)
	
	reg [4:0] count;
	wire ncoTick;		// once every 32 clk cycles
	
	wire reset;			// Papilio Pro does not have a user RESET pin, simulate one by delaying startup

	wire [2:0] oscAddr;		// selects analog port to read into oscBank
	wire [7:0] oscData;		// data value for selected analog port
	
	//
	// Output busses, values are unsigned int
	//
	wire [DAC_WIDTH-1:0] dac1L;
	wire [DAC_WIDTH-1:0] dac1R;
	wire [DAC_WIDTH-1:0] dac2L;
	//wire [DAC_WIDTH-1:0] dac2R;
	
	//
	// Core system resources i.e. reset and clock generation
	//
	resetgen rst (.reset(reset), .clk(clk0));
	prescalar prescale (.clk0(clk0), .clk16(clk16), .clk16_180(clk16_180), .clkin(CLK));
	
	//
	// Analog to Digital Converters.
	// Retrocade wing has 2 x ADC088S102 chips, they are polled continuously.
	//
	ADC adc1 (.sck(ADC1_SCK), .cs_n(ADC1_nCS), .dout(ADC1_DI), .clk(clk16), .clk180(clk16_180), .reset(reset), .din(ADC1_DO), .addr(oscAddr), .q(oscData));
	ADC adc2 (.sck(ADC2_SCK), .cs_n(ADC2_nCS), .dout(ADC2_DI), .clk(clk16), .clk180(clk16_180), .reset(reset), .din(ADC2_DO), .addr(3'b0), .q(A[7:0]));
	
	//
	// Oscillator Bank.
	// Controlled through keyboard and adc1.
	//
	oscBank oscillators (.clk(clk0), .reset(reset), .note(7'd69), .bend(14'h2000), .addr(oscAddr), .data(oscData), .osc1(dac1L), .osc2(dac1R), .osc3(dac2L));

	//
	// Continuous, 5 bit counter. Used to generate 1MHz 'tick' for DAC's.
	//
   always @(posedge clk0, posedge reset)
		if (reset)
			count <= 5'b0;
		else
			count <= count + 5'b1;

	assign ncoTick = &count;

	//
	// Digital to Analog converters
	//
	dsDAC #(.N(DAC_WIDTH)) dsDAC1L (.out(A1L), .in(dac1L), .clk(clk0), .nco(ncoTick), .reset(reset));
	dsDAC #(.N(DAC_WIDTH)) dsDAC1R (.out(A1R), .in(dac1R), .clk(clk0), .nco(ncoTick), .reset(reset));
	dsDAC #(.N(DAC_WIDTH)) dsDAC2L (.out(A2L), .in(dac2L), .clk(clk0), .nco(ncoTick), .reset(reset));
	//dsDAC #(.N(DAC_WIDTH)) dsDAC2R (.out(A2R), .in(dac2R), .clk(clkNCO), .reset(reset));

	//
	// Outputs for disabled resources.
	//
	assign SDRAM_nCS = 1'b1;
	
endmodule
