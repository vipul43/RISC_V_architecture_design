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

module decoder(input [31:0] instruction, input clk,
    output [31:0]op1, [31:0]res, [31:0]wrt
    );

    wire [31:0] a, c;
    wire [31:0]temp;
    reg [31:0] cap;
    reg [11:0] imd;
    integer i;
    integer file;
    reg_file rf1(.clk(clk),.address(instruction[19:15]), .write(1'b0),.in(temp),  .out(a));
    assign op1=a;
    alu a1(.clk(clk),.immediate(imd), .func3(instruction[14:12]), .opcode(instruction[6:0]), .a(a), .out(c));
    assign res=c;
    reg_file rf3(.clk(clk),.address(instruction[11:7]), .write(1'b1), .in(c), .out(temp));
    always @(posedge clk)begin
        imd = instruction[31:20];
        cap = c;
    end
    assign wrt=cap;
endmodule