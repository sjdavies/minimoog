`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
// Engineer:       Stephen Davies
// 
// Create Date:    21:05:48 10 Jan 2013 
// Design Name:    
// Module Name:    ADC 
// Project Name:   MiniMoog sim
// Target Devices: Spartan 6
// Tool versions:  ISE 14.4
// Description:    State machine logic for polling a TI ADC088S102 ADC chip.
//                 Logic operates in a loop, polling the current port value in a
//                 single 'frame'. Each input port (of 8) is sampled in its own
//                 frame, delimited by CS, so that synchronisation is maintained.
//
//                 A future implementation could make the frames larger, querying all
//                 8 ports in a single frame. This would improve throughput. Maximum
//                 throughput would sample each individual port @125k samples/s. Per port
//                 framing reduces this a little but not enough to worry about given 
//                 that the main function for the analog pins is to attach pots & switches.
//
// Dependencies: 
//
// Revision:       0.02
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module ADC #(
    parameter ADC_WIDTH=8           // ADC sample size in bits, for TI ADC088S102
    ) (
    input clk,                      // 16 MHz clk (max for ADC088S102)
    input clk180,                   // 16 MHz clock, 180 out of phase
    input reset,                    // active high

    output sck,                     // SPI clock (16MHz max for ADC088S102)
    output reg cs_n,                // ADC chip select, active low
    input  din,                     // data stream from ADC chip, sampled on rising edge of SCK
    output reg dout,                // data stream to ADC, ADC chip samples on rising edge of SCK

    input [2:0] addr,               // register read address
    output [ADC_WIDTH-1:0] q        // register output value
    );

    // State machine states
    localparam RESYNC = 1'b0;       // ADC chip select (CS) taken high
    localparam SAMPLE = 1'b1;       // ADC chip select (CS) taken low, analog data being sampled 

    // Variables
    reg [6:0] count;                // 7 bit counter - low order 4 bits count 16 SCK pulses per frame.
                                    //               - high order 3 bits indicate current port
                                    
    wire [2:0]  currentPort;        // port we are receiving dataIn for (high order bits of count)
    reg [4:0]   dataOut;            // Output shift register, contains next port address and two 0 bits. Not all 16 bits are required as unused bits default to 0.
    reg [15:0]  dataIn;             // Input shift register, contains current anaolg sample plus padding
    wire [2:0]  nextPort;           // next analog port to be read, sent as part of current dataOut frame
    wire        endFrameTick;       // indicates end of frame has been reached, drives FSM through RESYNC state

    //
    // 8 x 8 RAM, stores individual values sampled from the ADC.
    // RAM is dual ported, can be written and read via two separate signal paths.
    //
    (* RAM_STYLE="DISTRIBUTED" *)
    reg [ADC_WIDTH-1:0] adcReg [7:0];

    (* FSM_ENCODING="SEQUENTIAL", SAFE_IMPLEMENTATION="YES", SAFE_RECOVERY_STATE="RESYNC" *)
    reg state = RESYNC;             // FSM state (at initial state)
	
	assign endFrameTick = &count[3:0];      // at end EOF when count == 4'b1111
	assign currentPort = count[6:4];        // values 0-7
	assign nextPort = currentPort + 3'd1;   // we always set up the ADC to read the next sequential port
	assign q = adcReg[addr];
	
    //
    // FSM
    //
    always@(posedge clk, posedge reset)
        if (reset) begin                    // system reset
            state <= RESYNC;
            count <= 7'b0;
            cs_n  <= 1'b1;
            end
        else
            (* PARALLEL_CASE, FULL_CASE *)
            case (state)
                RESYNC : begin                      // immediately moves to SAMPLE state after resetting key values
                    state <= SAMPLE;
                    count <= { count[6:4], 4'b0 };	// preserves nextPort value
                    cs_n  <= 1'b0;
                end
                SAMPLE : begin
                    if (endFrameTick) begin         // when 15 SCK cycles have occurred, RESYNC for next analog port
                        state <= RESYNC;
                        count <= count + 7'd1;
                        cs_n <= 1'b1;
                        end
                    else begin                      // keep on clocking...
                        state <= state;
                        count <= count + 7'd1;
                        cs_n <= 1'b0;
                    end
                end
                default: begin                      // Fault Recovery
                    state <= RESYNC;
                    count <= 7'b0;
                    cs_n  <= 1'b1;
                end
            endcase
	
    //
    // DOUT shift register, selects next port to sample.
    // 5 bits long because first 3 bits are zero, next 3 are port and next 10 are zero.
    //
    always @(negedge clk, posedge reset)
        if (reset) begin
            dataOut <= 5'b0;
            dout    <= 1'b0;
            end
        else if (cs_n) begin                        // load register at start of frame
            dataOut <= { nextPort[0], nextPort[1], nextPort[2], 2'b0 };
            dout    <= 1'b0;
            end
        else if (!cs_n) begin                       // shift next bit
            dataOut <= { 1'b0, dataOut[4:1] };
            dout    <= dataOut[0];
            end

    //
    // DIN shift register
    //
    always @(posedge clk)
        if (!cs_n)
            dataIn <= { dataIn[14:0], din };
        else
            adcReg[currentPort - 1] <= dataIn[11:4];

    //
    // Spartan 6 requires special handling for sending clk16 on SCK pin.
    // Apparently not a 'special' clock output pin.
    //
    ODDR2 ODDR2_inst (.Q(sck), .C0(clk), .C1(clk180), .CE(1'b1), .D0(1'b1), .D1(1'b0), .R(1'b0), .S(1'b0));
	
endmodule
