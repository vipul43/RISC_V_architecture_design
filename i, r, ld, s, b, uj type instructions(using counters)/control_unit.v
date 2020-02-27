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
            output MemRead, MemToReg, ALUOp, MemWrite, ALUSrc, RegWrite, branch, jal_sel, jalr_sel
    );
    reg [8:0]aa;
    always@(*) begin
        case ({instruction[14:12], instruction[6:0]})
            10'b0000110011:                 //add/sub_rtype     //addition **ambig**    //rs1 source    //itype
                            aa<=9'b000001000;
            10'b1000110011:
                            aa<=9'b000001000;  //xor_rtype
            10'b1100110011:
                            aa<=9'b000001000;  //or_rtpye
            10'b1110110011:
                            aa<=9'b000001000;  //and_rtype
            10'b1010110011: 
                            aa<=9'b000001000;  //sra_rtype
            10'b0010110011:
                            aa<=9'b000001000;  //sll_rtype
            10'b0000010011:                 //add_itype     //addition  //imd source
                            aa<=9'b000011000;  
            10'b0010010011:
                            aa<=9'b000011000;  //sll_itype
            10'b0110000011:                 //load      //addition  //imd source
                            aa<=9'b110011000;
            10'b0110100011:                 //store     //addition  //imd source
                            aa<=9'b000110000;
            10'b0001100011:                 //branch
                            aa<=9'b000010100;         //beq
            10'b0011100011:
                            aa<=9'b000010100;         //bne
            10'b1001100011:
                            aa<=9'b000010100;         //blt
            10'b1011100011:
                            aa<=9'b000010100;         //bge
            10'b0001101111:                          //jal
                            aa<=9'b000011010;
            10'b0011101111:
                            aa<=9'b000011010;
            10'b0101101111:
                            aa<=9'b000011010;
            10'b0111101111:
                            aa<=9'b000011010;
            10'b1001101111:
                            aa<=9'b000011010;
            10'b1011101111:
                            aa<=9'b000011010;
            10'b1101101111:
                            aa<=9'b000011010;
            10'b1111101111:
                            aa<=9'b000011010;
            10'b0001100111:                         //jalr
                            aa<=9'b000010001;
            default:
                            aa<=9'b000000000;         //no instruction case
        endcase
    end
    assign MemRead=aa[8];
    assign MemToReg=aa[7];
    assign ALUOp=aa[6];
    assign MemWrite=aa[5];
    assign ALUSrc=aa[4];
    assign RegWrite=aa[3];
    assign branch=aa[2];
    assign jal_sel=aa[1];
    assign jalr_sel=aa[0];
endmodule
