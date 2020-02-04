`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.01.2020 04:32:08
// Design Name: 
// Module Name: ins_mem
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


module ins_mem(input clk,
        output [31:0]op1, [31:0]op2, [31:0]res, [31:0]im
    );
    integer file_in;
    reg [31:0]read_data;
    reg [1:0]counter=0;
    decoder d1 (.op1(op1),.op2(op2), .res(res), .instruction(read_data), .clk(clk));
    initial begin
        file_in = $fopen("im.txt", "r");
    end
    always @ (posedge clk)
    begin
        if(counter==2'b0) begin
            if(!$feof(file_in))begin
                $fscanf(file_in, "%b\n", read_data);
            end
            else 
            begin
                $fclose(file_in);
            end
        end
        counter<=counter+2'b1;
        if(counter==2'b11)begin
            counter<=2'b0;
        end
    end 
    assign im = read_data;
endmodule
