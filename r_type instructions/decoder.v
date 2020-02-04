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
    output [31:0]op1, [31:0]op2, [31:0]res, [31:0]wrt
    );

    wire [31:0] a, b, c;
    wire [31:0]temp;
    reg [31:0] cap;
    integer i;
    integer file;
    reg_file rf1(.clk(clk),.address(instruction[24:20]), .write(1'b0),.in(temp),  .out(a));
    assign op1=a;
    reg_file rf2(.clk(clk),.address(instruction[19:15]), .write(1'b0), .in(temp), .out(b));
    assign op2=b;
    alu a1(.clk(clk),.func7(instruction[31:25]), .func3(instruction[14:12]), .opcode(instruction[6:0]), .a(a), .b(b), .out(c));
    assign res=c;
    reg_file rf3(.clk(clk),.address(instruction[11:7]), .write(1'b1), .in(c), .out(temp));
    always @(posedge clk)begin
            cap=c;
    end
    assign wrt=cap;
endmodule