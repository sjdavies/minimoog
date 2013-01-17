`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:        Davies Consulting Pty. Ltd.
// Engineer:       Stephen Davies
// 
// Create Date:    17:30:54 18 December 2012 
// Design Name: 
// Module Name:    prescalar 
// Project Name:   MiniMoog Synth simulator
// Target Devices: Spartan 6
// Tool versions:  ISE 14.4
// Description:    Use the Spartn 6 DCM resources to generate the various clocks required.
//
// Dependencies: 
//
// Revision:       0.01
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module prescalar(
    input clkin,
    output clk0,
	 output clk16,
	 output clk16_180
    );

	wire bufferedIn;
	wire unbuf0;
	wire unbuf16;
	wire unbuf16_180;
	
   IBUFG inBuf       (.O(bufferedIn), .I(clkin));
	BUFG clkOut0      (.O(clk0), .I(unbuf0));	
	BUFG clkOut16     (.O(clk16), .I(unbuf16));
	BUFG clkOut16_180 (.O(clk16_180), .I(unbuf16_180));
	
	//
	// Buffer the 32 MHz system clock and generate a 16 MHz clock for use by the SPI ports.
	//
   DCM_SP #(
      .CLKFX_DIVIDE(4),                     // Divide value on CLKFX outputs - D - (1-32)
      .CLKFX_MULTIPLY(2),                   // Multiply value on CLKFX outputs - M - (2-32)
      .CLKIN_DIVIDE_BY_2("FALSE"),          // CLKIN divide by two (TRUE/FALSE)
      .CLKIN_PERIOD(31.25),                 // Input clock period specified in nS
      .CLKOUT_PHASE_SHIFT("NONE"),          // Output phase shift (NONE, FIXED, VARIABLE)
      .CLK_FEEDBACK("1X"),                  // Feedback source (NONE, 1X, 2X)
      .DESKEW_ADJUST("SYSTEM_SYNCHRONOUS"), // SYSTEM_SYNCHRNOUS or SOURCE_SYNCHRONOUS
      .DFS_FREQUENCY_MODE("LOW"),           // Unsupported - Do not change value
      .DLL_FREQUENCY_MODE("LOW"),           // Unsupported - Do not change value
      .DSS_MODE("NONE"),                    // Unsupported - Do not change value
      .DUTY_CYCLE_CORRECTION("TRUE"),       // Unsupported - Do not change value
      .FACTORY_JF(16'hc080),                // Unsupported - Do not change value
      .PHASE_SHIFT(0),                      // Amount of fixed phase shift (-255 to 255)
      .STARTUP_WAIT("FALSE")                // Delay config DONE until DCM_SP LOCKED (TRUE/FALSE)
   )
   main_dcm (
      .CLKIN(bufferedIn),  	// 1-bit input: Clock input
      .CLK0(unbuf0),	         // 1-bit output: 0 degree clock output
      .CLKFB(clk0),      	   // 1-bit input: Clock feedback input
      .CLKFX(unbuf16),        // 1-bit output: Digital Frequency Synthesizer output (DFS)
      .CLKFX180(unbuf16_180), // 1-bit output: 180 degree CLKFX output
      .DSSEN(1'b0),         	// 1-bit input: Unsupported, specify to GND.
      .PSCLK(1'b0),         	// 1-bit input: Phase shift clock input
      .PSEN(1'b0),          	// 1-bit input: Phase shift enable
      .PSINCDEC(1'b0),      	// 1-bit input: Phase shift increment/decrement input
      .RST(1'b0)            	// 1-bit input: Active high reset input
   );

endmodule
