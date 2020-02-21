`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.02.2020 07:12:22
// Design Name: 
// Module Name: main_memory
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


module main_memory( input [2:0]sup, input MemRead, input MemWrite, input clk, input[63:0]in_store, input[63:0]in_store_address, input[63:0]in_load, 
                    output[63:0]out_load
    );
    reg [63:0]memory[0:31];
    reg [63:0]hold;
    reg [63:0]m_wrt;
    integer i;
    integer m_file;
    integer m_file_output;
    initial begin
        m_file = $fopen("main_memory.txt", "r");
        for(i=0;i<32;i=i+1)begin
            $fscanf(m_file, "%b\n", memory[i]);
        end
    end
    always @ (posedge clk)begin
        if(sup==3'b011) begin
            if(MemRead==1'b1 && MemWrite==1'b0)begin           //ld
                hold <= memory[in_load];
            end
            else if(MemRead==1'b0 && MemWrite==1'b1)begin      //sd
                memory[in_store_address]<=in_store;
                m_wrt<=in_store_address;
                //writing to main_memory text file
                m_file_output = $fopen("main_memory.txt", "w");
                for(i=0;i<32;i=i+1)begin
                    $fwrite(m_file_output, "%b\n", memory[i]);
                end
                $fclose(m_file_output);
            end
        end
    end
    assign out_load = hold;
endmodule
