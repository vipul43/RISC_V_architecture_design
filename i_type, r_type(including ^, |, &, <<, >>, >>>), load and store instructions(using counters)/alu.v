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

module alu(input[2:0]sup, input clk, input[6:0]func7, input [2:0]func3, input [6:0]opcode, input [63:0]a, input [63:0]b, output [63:0]out);
    reg [63:0]hold;
    always @(posedge clk)begin
        if(sup==3'b010)begin
            if(opcode==7'b0010011)begin             //itype
                if(func3==3'b000)begin
                    hold = a + b;       //addi
                end
                else if(func3==3'b001)begin
                    hold = a << b;      //slli
                end
            end
            else if(opcode==7'b0110011)begin        //rtype
                if(func7==7'b0000000 && func3==3'b000)begin
                    hold = a + b;           //add_rtype
                end
                else if(func7==7'b0100000 && func3==3'b000)begin
                    hold = a - b;           //sub_rtype
                end
                else if(func7==7'b0000000 && func3==3'b100)begin
                    hold = a^b;             //xor_rtype
                end
                else if(func7==7'b0000000 && func3==3'b110)begin
                    hold = a | b;           //or_rtype
                end
                else if(func7==7'b0000000 && func3==3'b111)begin
                    hold = a & b;           //and_rtype
                end
                else if(func7==7'b0000000 && func3==3'b001)begin
                    hold = b << a;          //sll_rtype
                end
                else if(func7==7'b0000000 && func3==3'b101)begin
                    hold = b >>> a;         //sra_rtype
                end
            end
            else if(func3==3'b011 && opcode==7'b0000011)begin
                hold = a + b;                       //load
            end
            else if(func3==3'b011 && opcode==7'b0100011)begin
                hold = a + b;                       //store
            end
        end
    end
    assign out = hold; 
endmodule