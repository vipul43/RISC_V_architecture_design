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


module tb(
    );
    wire [31:0]op1, op2, res, im;
    wire [31:0]wrt;
    reg clk;
    initial begin
    clk=0;
    forever
    #5 clk=~clk;
    end
    ins_mem im1( .clk(clk),  .im(im), .op1(op1), .op2(op2), .res(res), .wrt(wrt));
endmodule
