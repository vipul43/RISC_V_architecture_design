`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.01.2020 04:36:25
// Design Name: 
// Module Name: tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module alu(input clk, input [2:0]func3, input [6:0]opcode, input [31:0]a, input [11:0]immediate, output [31:0]out);
    reg [31:0]hold;
    always @(posedge clk)begin
        if(func3==3'b000 && opcode==7'b0010011) begin;
            hold = a + immediate; 
        end
    end
    assign out = hold; 
endmodule