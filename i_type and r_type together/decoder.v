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
    output [31:0]op1, [31:0]op2, [31:0]res
    );

    wire [31:0] a, b, c;
    reg [31:0]ambig;
    reg [31:0]imd;
    wire [31:0]temp;
    integer file;
    always @(a, imd) begin
        if(instruction[14:12]==3'b000 && instruction[6:0]==7'b0110011)begin
            ambig=a;
        end
        else if(instruction[14:12]==3'b000 && instruction[6:0]==7'b0010011)begin
            ambig=imd;
        end
    end
    always@(posedge clk)begin
        imd[11:0]<=instruction[31:20];
        if(instruction[20]==1'b0)begin
            imd[31:12]<=20'b00000000000000000000;
        end
        else begin
            imd[31:12]<=20'b11111111111111111111;
        end
    end
    reg_file rf1(.clk(clk),.address(instruction[24:20]), .write(1'b0),.in(temp),  .out(a));
    assign op1=ambig;
    reg_file rf2(.clk(clk),.address(instruction[19:15]), .write(1'b0),.in(temp),  .out(b));
    assign op2=b;
    alu a1(.clk(clk), .func7(instruction[31:25]), .func3(instruction[14:12]), .opcode(instruction[6:0]), .a(op1), .b(b), .out(c));
    assign res=c;
    reg_file rf3(.clk(clk),.address(instruction[11:7]), .write(1'b1), .in(c), .out(temp));
endmodule