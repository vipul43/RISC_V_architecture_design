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

module alu(input clk, input[6:0]func7, input [2:0]func3, input [6:0]opcode, input [31:0]a, input [31:0]b, output [31:0]out);
    reg [31:0]hold;
    always @(posedge clk)begin
        if(func3==3'b000 && opcode==7'b0010011) begin
            hold = a + b; 
        end
        else if(func3==3'b000 && opcode==7'b0110011)begin
            if(func7==0000000)begin
                hold = a + b;
            end
            else if(func7==0100000)begin
                hold = a - b;
            end
        end
    end
    assign out = hold; 
endmodule