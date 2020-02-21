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
            output MemRead, MemToReg, ALUOp, MemWrite, ALUSrc, RegWrite
    );
    reg [5:0]aa;
    always@(*) begin
        case ({instruction[14:12], instruction[6:0]})
            10'b0000110011:                 //add/sub_rtype     //addition **ambig**    //rs1 source    //itype
                            aa<=6'b000001;
            10'b1000110011:
                            aa<=6'b000001;  //xor_rtype
            10'b1100110011:
                            aa<=6'b000001;  //or_rtpye
            10'b1110110011:
                            aa<=6'b000001;  //and_rtype
            10'b1010110011: 
                            aa<=6'b000001;  //sra_rtype
            10'b0010110011:
                            aa<=6'b000001;  //sll_rtype
            10'b0000010011:                 //add_itype     //addition  //imd source
                            aa<=6'b000011;  
            10'b0010010011:
                            aa<=6'b000011;  //sll_itype
            10'b0110000011:                 //load      //addition  //imd source
                            aa<=6'b110011;
            10'b0110100011:                 //store     //addition  //imd source
                            aa<=6'b000110;
        endcase 
    end
    assign MemRead=aa[5];
    assign MemToReg=aa[4];
    assign ALUOp=aa[3];
    assign MemWrite=aa[2];
    assign ALUSrc=aa[1];
    assign RegWrite=aa[0];
endmodule
