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
    reg clk;
    wire [31:0] im, op1, res;
    wire [31:0]wrt;
    
    initial begin
    clk=0;
    forever
    #5 clk=~clk;
    end
    ins_mem im1( .clk(clk),  .im(im), .op1(op1), .res(res), .wrt(wrt));
endmodule
