`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.02.2020 15:06:10
// Design Name: 
// Module Name: control_unit
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


module control_unit(input clk, input [31:0] instruction, 
            output MemRead, MemToReg, ALUOp, MemWrite, ALUSrc, RegWrite, branch
    );
    reg [6:0]aa;
    always@(*) begin
        case ({instruction[14:12], instruction[6:0]})
            10'b0000110011:                 //add/sub_rtype     //addition **ambig**    //rs1 source    //itype
                            aa<=7'b0000010;
            10'b1000110011:
                            aa<=7'b0000010;  //xor_rtype
            10'b1100110011:
                            aa<=7'b0000010;  //or_rtpye
            10'b1110110011:
                            aa<=7'b0000010;  //and_rtype
            10'b1010110011: 
                            aa<=7'b0000010;  //sra_rtype
            10'b0010110011:
                            aa<=7'b0000010;  //sll_rtype
            10'b0000010011:                 //add_itype     //addition  //imd source
                            aa<=7'b0000110;  
            10'b0010010011:
                            aa<=7'b0000110;  //sll_itype
            10'b0110000011:                 //load      //addition  //imd source
                            aa<=7'b1100110;
            10'b0110100011:                 //store     //addition  //imd source
                            aa<=7'b0001100;
            10'b0001100011:                 //branch
                            aa<=7'b0000101;         //beq
            10'b0011100011:
                            aa<=7'b0000101;         //bne
            10'b1001100011:
                            aa<=7'b0000101;         //blt
            10'b1011100011:
                            aa<=7'b0000101;         //bge
            default:
                            aa<=7'b0000000;         //no instruction case
        endcase 
    end
    assign MemRead=aa[6];
    assign MemToReg=aa[5];
    assign ALUOp=aa[4];
    assign MemWrite=aa[3];
    assign ALUSrc=aa[2];
    assign RegWrite=aa[1];
    assign branch=aa[0];
endmodule
