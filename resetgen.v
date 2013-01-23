`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer:       Stephen Davies
// 
// Create Date:    16:28:01 6 Jan 2013 
// Module Name:    resetgen 
// Project Name:   MiniMoog Synth simulator
// Target Devices: Spartan 6
// Tool versions:  ISE 14.4
// Description:    Papilio Pro board RESET button forces a system reload. Assert an artificial reset
//                 for 16 clock cycles after reload to ensure it all synchs up.
//
//                 Shift register, initially loaded with 16'hFFFF. After configuration is complete
//                 0's begin to shift in. After 16 clock cycles output goes from 1 to 0. 
//
// Dependencies: 
//
// Revision:       0.02
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module resetgen(
    input clk,
    output reset
    );

    SRL16E #(
        .INIT(16'hFFFF)     // Initial Value of Shift Register, RESET is asserted for another 16 clock cycles after reload.
    )
    SRL16E_inst (
        .Q(reset),
        .A0(1'b1),
        .A1(1'b1),
        .A2(1'b1),
        .A3(1'b1),
        .CE(1'b1),
        .CLK(clk),
        .D(1'b0)            // eventually these zeroes make it out of the shift register.
    );

endmodule
