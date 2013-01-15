`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:22:44 12/06/2012 
// Design Name: 
// Module Name:    NoteTable 
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
module NoteTable(
    input [6:0] midiNote,
    output reg [31:0] freqControl
    );

   always @(midiNote)
      case (midiNote)
			7'd21: freqControl <= 32'h1CD60;
			7'd22: freqControl <= 32'h1E8CE;
			7'd23: freqControl <= 32'h205E1;
			7'd24: freqControl <= 32'h224AA;
			7'd25: freqControl <= 32'h2454C;
			7'd26: freqControl <= 32'h267DC;
			7'd27: freqControl <= 32'h28C7C;
			7'd28: freqControl <= 32'h2B346;
			7'd29: freqControl <= 32'h2DC65;
			7'd30: freqControl <= 32'h307EE;
			7'd31: freqControl <= 32'h33611;
			7'd32: freqControl <= 32'h366F5;
			7'd33: freqControl <= 32'h39ABF;
			7'd34: freqControl <= 32'h3D19C;
			7'd35: freqControl <= 32'h40BBE;
			7'd36: freqControl <= 32'h44955;
			7'd37: freqControl <= 32'h48A98;
			7'd38: freqControl <= 32'h4CFB7;
			7'd39: freqControl <= 32'h518F7;
			7'd40: freqControl <= 32'h5668F;
			7'd41: freqControl <= 32'h5B8C5;
			7'd42: freqControl <= 32'h60FE0;
			7'd43: freqControl <= 32'h66C27;
			7'd44: freqControl <= 32'h6CDE9;
			7'd45: freqControl <= 32'h7357E;
			7'd46: freqControl <= 32'h7A33C;
			7'd47: freqControl <= 32'h81780;
			7'd48: freqControl <= 32'h892AE;
			7'd49: freqControl <= 32'h9152C;
			7'd50: freqControl <= 32'h99F6F;
			7'd51: freqControl <= 32'hA31EA;
			7'd52: freqControl <= 32'hACD1F;
			7'd53: freqControl <= 32'hB7189;
			7'd54: freqControl <= 32'hC1FBC;
			7'd55: freqControl <= 32'hCD84D;
			7'd56: freqControl <= 32'hD9BD3;
			7'd57: freqControl <= 32'hE6AFD;
			7'd58: freqControl <= 32'hF4678;
			7'd59: freqControl <= 32'h102F00;
			7'd60: freqControl <= 32'h11255B;
			7'd61: freqControl <= 32'h122A5C;
			7'd62: freqControl <= 32'h133EE2;
			7'd63: freqControl <= 32'h1463D8;
			7'd64: freqControl <= 32'h159A3D;
			7'd65: freqControl <= 32'h16E313;
			7'd66: freqControl <= 32'h183F78;
			7'd67: freqControl <= 32'h19B096;
			7'd68: freqControl <= 32'h1B37A9;
			7'd69: freqControl <= 32'h1CD5FA;
			7'd70: freqControl <= 32'h1E8CEF;
			7'd71: freqControl <= 32'h205DFB;
			7'd72: freqControl <= 32'h224AB2;
			7'd73: freqControl <= 32'h2454B4;
			7'd74: freqControl <= 32'h267DC3;
			7'd75: freqControl <= 32'h28C7B1;
			7'd76: freqControl <= 32'h2B3477;
			7'd77: freqControl <= 32'h2DC626;
			7'd78: freqControl <= 32'h307EF5;
			7'd79: freqControl <= 32'h336130;
			7'd80: freqControl <= 32'h366F4E;
			7'd81: freqControl <= 32'h39ABF3;
			7'd82: freqControl <= 32'h3D19DE;
			7'd83: freqControl <= 32'h40BBFB;
			7'd84: freqControl <= 32'h449564;
			7'd85: freqControl <= 32'h48A96B;
			7'd86: freqControl <= 32'h4CFB82;
			7'd87: freqControl <= 32'h518F61;
			7'd88: freqControl <= 32'h5668ED;
			7'd89: freqControl <= 32'h5B8C50;
			7'd90: freqControl <= 32'h60FDE9;
			7'd91: freqControl <= 32'h66C25F;
			7'd92: freqControl <= 32'h6CDEA1;
			7'd93: freqControl <= 32'h7357E6;
			7'd94: freqControl <= 32'h7A33B8;
			7'd95: freqControl <= 32'h8177F2;
			7'd96: freqControl <= 32'h892ACC;
			7'd97: freqControl <= 32'h9152D2;
			7'd98: freqControl <= 32'h99F704;
			7'd99: freqControl <= 32'hA31EC2;
			7'd100: freqControl <= 32'hACD1DF;
			7'd101: freqControl <= 32'hB7189F;
			7'd102: freqControl <= 32'hC1FBCE;
			7'd103: freqControl <= 32'hCD84BF;
			7'd104: freqControl <= 32'hD9BD43;
			7'd105: freqControl <= 32'hE6AFCD;
			7'd106: freqControl <= 32'hF46770;
			7'd107: freqControl <= 32'h102EFE3;
			7'd108: freqControl <= 32'h1125594;
			7'd109: freqControl <= 32'h122A5A5;
			7'd110: freqControl <= 32'h133EE08;
			7'd111: freqControl <= 32'h1463D85;
			7'd112: freqControl <= 32'h159A3BE;
			7'd113: freqControl <= 32'h16E313F;
			7'd114: freqControl <= 32'h183F79C;
			7'd115: freqControl <= 32'h19B097E;
			7'd116: freqControl <= 32'h1B37A85;
			7'd117: freqControl <= 32'h1CD5F9A;
			7'd118: freqControl <= 32'h1E8CEE1;
			7'd119: freqControl <= 32'h205DFC7;
			7'd120: freqControl <= 32'h224AB28;
			7'd121: freqControl <= 32'h2454B4A;
			7'd122: freqControl <= 32'h267DC10;
			7'd123: freqControl <= 32'h28C7B09;
			7'd124: freqControl <= 32'h2B3477C;
			7'd125: freqControl <= 32'h2DC627D;
			7'd126: freqControl <= 32'h307EF38;
			7'd127: freqControl <= 32'h33612FB;
			default: freqControl <= 32'h00000000;
		endcase
		
endmodule
