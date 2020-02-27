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

module decoder(input[2:0]vital, input [63:0]p_counter, input [31:0] instruction, input clk, output [2:0]branch_num, output [63:0]offset, output branch, output jal_sel, output jalr_sel
    );
    wire [63:0] a, b, c, d, e;
    wire [63:0]ambig;
    reg [63:0]imd;
    reg [63:0]imd1;
    wire [63:0]temp;
    wire [63:0]jal_output;
    wire [4:0]read_address;
    wire [63:0]switch;
    wire MemRead, MemToReg, ALUOp, MemWrite, ALUSrc, RegWrite;
    control_unit c1(.clk(clk), .instruction(instruction), .MemRead(MemRead), .MemToReg(MemToReg), .ALUOp(ALUOp), .MemWrite(MemWrite), .ALUSrc(ALUSrc), .RegWrite(RegWrite), .branch(branch), .jal_sel(jal_sel), .jalr_sel(jalr_sel));
    assign ambig = (ALUSrc) ? imd1 : a;                                               //MUX1
    always@(*)begin
        if(instruction[6:0]==7'b0100011 && instruction[14:12]==3'b011)begin         //sd
            imd[4:0]<=instruction[11:7];
            imd[11:5]<=instruction[31:25];
            if(imd[11]==0)begin
                imd[63:12]<=52'd0;
            end
            else begin
                imd[63:12]<=52'b1111111111111111111111111111111111111111111111111111;
            end
        end
        else if( (instruction[6:0]==7'b0010011) || (instruction[6:0]==7'b0000011 && instruction[14:12]==3'b011)) begin     //addi, ld
            imd[11:0]<=instruction[31:20];                      
            if(imd[11]==0)begin
                imd[63:12]<=52'd0;
            end
            else begin
                imd[63:12]<=52'b1111111111111111111111111111111111111111111111111111;
            end
        end
        else if(instruction[6:0]==7'b1100011 && branch==1'b1)begin                  //branch
            imd[0]<=1'b0;
            imd[4:1]<=instruction[11:8];
            imd[10:5]<=instruction[30:25];
            imd[11]<=instruction[7];
            imd[12]<=instruction[31];
            if(imd[12]==0)begin
                imd[63:13]<=51'd0;
            end
            else begin
                imd[63:13]<=51'b111111111111111111111111111111111111111111111111111;
            end
        end
        else if(instruction[6:0]==7'b1101111 && jal_sel==1'b1)begin
            imd[0]<=1'b0;
            imd[19:12]<=instruction[19:12];
            imd[11]<=instruction[20];
            imd[10:1]<=instruction[30:21];
            imd[20]<=instruction[31];
            if(imd[20]==0)begin
                imd[63:21]<=43'd0;
            end
            else begin
                imd[63:21]<=43'b1111111111111111111111111111111111111111111;
            end
        end
        else if(instruction[6:0]==7'b1100111 && jalr_sel==1'b1)begin
            imd[11:0]<=instruction[31:20];
            if(imd[11]==0)begin
                imd[63:12]<=52'd0;
            end
            else begin
                imd[63:12]<=52'b1111111111111111111111111111111111111111111111111111;
            end
        end
    end
    always @(posedge clk)begin
        imd1<=imd;
    end
    assign offset = (jalr_sel) ? c : ambig;
    assign switch = (jalr_sel) ? temp : b;
    reg_file rf1(.jalr_sel(jalr_sel), .vital(vital), .jal_sel(jal_sel), .control(RegWrite), .MemToReg(MemToReg), .clk(clk), .address(instruction[24:20]), .write(1'b0), .in_m(temp), .in(temp), .out(a));
    reg_file rf2(.jalr_sel(jalr_sel), .vital(vital), .jal_sel(jal_sel), .control(RegWrite), .MemToReg(MemToReg), .clk(clk), .address(instruction[19:15]), .write(1'b0), .in_m(temp), .in(temp), .out(b));
    alu a1(.vital(vital), .jal_input(p_counter), .branch_input(a), .clk(clk), .func7(instruction[31:25]), .func3(instruction[14:12]), .opcode(instruction[6:0]), .a(ambig), .b(switch), .out(c), .branch_sel(branch_num), .jal_output(jal_output)); 
    main_memory m1(.vital(vital), .jal_sel(jal_sel), .MemWrite(MemWrite), .MemRead(MemRead),  .clk(clk), .in_store(a), .in_store_address(c), .in_load(c), .out_load(d));
    reg_file rf3(.jalr_sel(jalr_sel), .vital(vital), .jal_sel(jal_sel), .control(RegWrite), .MemToReg(MemToReg), .clk(clk), .address(instruction[11:7]), .write(1'b1), .in_m(d), .in(c), .out(temp), .jal_input(jal_output));
endmodule