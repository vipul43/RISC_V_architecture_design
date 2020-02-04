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

module reg_file(input clk, input [4:0]address, input write, input [31:0]in, input control,
            output [31:0]out
);
    
    reg [31:0]registers[0:31];
    reg [31:0]hold;
    reg [31:0] wrt;
    integer i;
    integer r_file;
    initial begin
        r_file = $fopen("register.txt", "r");
        for(i=0;i<32;i=i+1)begin
            $fscanf(r_file, "%b\n", registers[i]);
        end
    end
    always @ (posedge clk)begin
        if(write == 1'b0)begin
            hold <= registers[address]; 
        end
        else begin
            registers[address] = in;
            wrt=in;
        end
    end
    assign out = hold;
    integer file_output;
    always @(posedge clk)
    begin
        file_output = $fopen("register.txt", "w");
        for(i=0;i<32;i=i+1)begin
            $fwrite(file_output, "%b\n", registers[i]);
        end
        $fclose(file_output);
    end
endmodule
