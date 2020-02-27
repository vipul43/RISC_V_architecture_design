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
    reg [31:0]pc[0:31];
    reg [2:0]counter=0;
    wire [2:0]vital;
    wire [2:0]branch_sel;
    wire [63:0] p_counter;
    wire [63:0]offset;
    wire branch, jal_sel, jalr_sel;
    reg [63:0]i=64'd0;
    decoder d1 (.clk(clk), .instruction(read_data), .branch_num(branch_sel), .offset(offset), .branch(branch), .p_counter(p_counter), .jal_sel(jal_sel), .vital(vital), .jalr_sel(jalr_sel));
    initial begin
        file_in = $fopen("im.txt", "r");
        for(i=0;i<32;i=i+1)begin
            if(!$feof(file_in))begin
                $fscanf(file_in, "%b\n", pc[i]);
            end
            else begin
                $fclose(file_in);
            end
        end
        i=64'd0;
    end
    always @ (posedge clk)
    begin
        if(counter==3'b000) begin
            read_data<=pc[i];
        end
        counter<=counter+3'b1;
        if(counter==3'b100)begin
            counter<=3'b000;
            if(branch_sel==3'b000 && branch==1'b1)begin         //beq
                i=(offset+i);
            end
            else if(branch_sel==3'b001 && branch==1'b1)begin    //bne
                i=(offset+i);
            end
            else if(branch_sel==3'b010 && branch==1'b1)begin    //blt
                i=(offset+i);
            end
            else if(branch_sel==3'b011 && branch==1'b1)begin    //bge
                i=(offset+i);
            end
            else if(branch_sel==3'b111 && branch==1'b1)begin    //non branch satisfying case
                i=i+64'd1;
            end
            else if(jal_sel==1'b1)begin                         //jal
                i=(offset+i);
            end
            else if(jalr_sel==1'b1)begin                        //jalr
                i=offset;
            end
            else begin
                i=i+64'd1;
            end
        end
    end
    assign p_counter=i;
    assign vital=counter;
endmodule
