`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer:       Stephen Davies
// 
// Create Date:    17:30:54 18 December 2012 
// Design Name: 
// Module Name:    prescalar 
// Project Name:   MiniMoog Synth simulator
// Target Devices: Spartan 6
// Tool versions:  ISE 14.4
// Description:    Use a Spartan 6 DCM resource to generate buffered 32MHz and 16MHz clocks.
//
// Dependencies: 
//
// Revision:       0.02
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module prescalar(
    input clkin,        // raw clock signal from external clock source
    
    output clk0,        // Buffered 32MHz clock
    output clk16,       // Buffered 16 MHz clock
    output clk16_180    // Buffered 16 MHz clock (180 degrees out of phase with clk16)
    );

    wire bufferedIn;
    wire unbuf0;
    wire unbuf16;
    wire unbuf16_180;
	
    //
    // Use Xilinx primitives to buffer in and out clock signals to/from DCM.
    //
    IBUFG   inBuf         (.O(bufferedIn), .I(clkin));
    BUFG    clkOut0       (.O(clk0), .I(unbuf0));	
    BUFG    clkOut16      (.O(clk16), .I(unbuf16));
    BUFG    clkOut16_180  (.O(clk16_180), .I(unbuf16_180));
	
    //
    // Buffer the 32 MHz system clock and generate a 16 MHz clock for use by the SPI ports.
    //
    DCM_SP #(
        // clkin * 2 / 4 = 16 MHz
        .CLKFX_MULTIPLY(2),                   // Multiply value on CLKFX outputs - M - (2-32)
        .CLKFX_DIVIDE(4),                     // Divide value on CLKFX outputs - D - (1-32)

        .CLKIN_DIVIDE_BY_2("FALSE"),          // CLKIN divide by two (TRUE/FALSE)
        .CLKIN_PERIOD(31.25),                 // Input clock period specified in nS
        .CLKOUT_PHASE_SHIFT("NONE"),          // Output phase shift (NONE, FIXED, VARIABLE)
        .CLK_FEEDBACK("1X"),                  // Feedback source (NONE, 1X, 2X)

        // standard template defaults
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
        .CLKIN(bufferedIn),                   // Clock input
        .CLK0(unbuf0),	                      // 0 degree clock output
        .CLKFB(clk0),      	                  // Clock feedback input
        
        .CLKFX(unbuf16),                      // Digital Frequency Synthesizer output (DFS)
        .CLKFX180(unbuf16_180),               // 1-bit output: 180 degree CLKFX output
        
        // standard template values
        .DSSEN(1'b0),         	              // Unsupported, specify to GND.
        .PSCLK(1'b0),         	              // Phase shift clock input
        .PSEN(1'b0),          	              // Phase shift enable
        .PSINCDEC(1'b0),      	              // Phase shift increment/decrement input
        .RST(1'b0)            	              // Active high reset input
    );

endmodule
