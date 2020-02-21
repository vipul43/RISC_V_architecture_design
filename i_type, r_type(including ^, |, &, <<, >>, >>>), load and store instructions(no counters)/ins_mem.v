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


module ins_mem(input clk
    );
    integer file_in;
    reg [31:0]read_data;
    reg [2:0]counter=0;
    
    decoder d1 (.clk(clk), .instruction(read_data));
    initial begin
        file_in = $fopen("im.txt", "r");
    end
    always @ (posedge clk)
    begin
        if(counter==3'b0) begin
            if(!$feof(file_in))begin
                $fscanf(file_in, "%b\n", read_data);
            end
            else 
            begin
                $fclose(file_in);
            end
        end
        counter<=counter+3'b1;
        if(counter==3'b100)begin
            counter<=3'b0;
        end
    end
endmodule
