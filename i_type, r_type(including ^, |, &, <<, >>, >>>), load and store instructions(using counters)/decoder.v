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

module decoder(input [31:0] instruction, input clk, input[2:0]loop
    );
    wire [63:0] a, b, c, d, e;
    wire [63:0]ambig;
    reg [63:0]imd;
    reg [63:0]imd1;
    wire [63:0]temp;
    wire MemRead, MemToReg, ALUOp, MemWrite, ALUSrc, RegWrite;
    control_unit c1(.clk(clk), .instruction(instruction), .MemRead(MemRead), .MemToReg(MemToReg), .ALUOp(ALUOp), .MemWrite(MemWrite), .ALUSrc(ALUSrc), .RegWrite(RegWrite));
//    always @(a, imd) begin
//        if(instruction[14:12]==3'b000 && instruction[6:0]==7'b0110011)begin
//            ambig=a;
//        end
//        else if( (instruction[14:12]==3'b000 && instruction[6:0]==7'b0010011) || (instruction[14:12]==3'b011 && instruction[6:0]==7'b0000011) || (instruction[14:12]==3'b011 && instruction[6:0]==7'b0100011))begin
//            ambig=imd1;  //addi, ld, sd
//        end
//    end
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
    end
    always @(posedge clk)begin
        imd1<=imd;
    end
    reg_file rf1(.sup(loop), .control(RegWrite), .MemToReg(MemToReg), .clk(clk), .address(instruction[24:20]), .write(1'b0), .in_m(temp), .in(temp), .out(a));
    reg_file rf2(.sup(loop), .control(RegWrite), .MemToReg(MemToReg), .clk(clk), .address(instruction[19:15]), .write(1'b0), .in_m(temp), .in(temp), .out(b));
    alu a1(.sup(loop), .clk(clk), .func7(instruction[31:25]), .func3(instruction[14:12]), .opcode(instruction[6:0]), .a(ambig), .b(b), .out(c)); 
    main_memory m1(.sup(loop), .MemWrite(MemWrite), .MemRead(MemRead),  .clk(clk), .in_store(a), .in_store_address(c), .in_load(c), .out_load(d));
    reg_file rf3(.sup(loop), .control(RegWrite), .MemToReg(MemToReg), .clk(clk), .address(instruction[11:7]), .write(1'b1), .in_m(d), .in(c), .out(temp));
endmodule