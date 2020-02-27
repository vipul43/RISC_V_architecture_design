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

module decoder(input [31:0] instruction, input clk, output [2:0]branch_num, output [63:0]offset, output branch
    );
    wire [63:0] a, b, c, d, e;
    wire [63:0]ambig;
    reg [63:0]imd;
    reg [63:0]imd1;
    wire [63:0]temp;
    wire MemRead, MemToReg, ALUOp, MemWrite, ALUSrc, RegWrite;
    integer pc;
//    initial begin
//        pc=-4;
//    end
//    always@(instruction)begin
//        if(branch==1'b1)begin
//            if(branch_sel==3'b000)begin          //beq
//                pc=pc+(imd*2);
//            end
//            else if(branch_sel==3'b001)begin     //bne
//                pc=pc+(imd*2);
//            end
//            else if(branch_sel==3'b010)begin     //blt
//                pc=pc+(imd*2);
//            end
//            else if(branch_sel==3'b011)begin     //bge
//                pc=pc+(imd*2);
//            end
//            else begin
//                pc=pc+4;
//            end
//        end
//        else begin
//                pc=pc+4;
//        end
//    end
    control_unit c1(.clk(clk), .instruction(instruction), .MemRead(MemRead), .MemToReg(MemToReg), .ALUOp(ALUOp), .MemWrite(MemWrite), .ALUSrc(ALUSrc), .RegWrite(RegWrite), .branch(branch));
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
    end
    always @(posedge clk)begin
        imd1<=imd;
    end
    assign offset=imd;
    reg_file rf1(.control(RegWrite), .MemToReg(MemToReg), .clk(clk), .address(instruction[24:20]), .write(1'b0), .in_m(temp), .in(temp), .out(a));
    reg_file rf2(.control(RegWrite), .MemToReg(MemToReg), .clk(clk), .address(instruction[19:15]), .write(1'b0), .in_m(temp), .in(temp), .out(b));
    alu a1(.branch_input(a), .clk(clk), .func7(instruction[31:25]), .func3(instruction[14:12]), .opcode(instruction[6:0]), .a(ambig), .b(b), .out(c), .branch_sel(branch_num)); 
    main_memory m1(.MemWrite(MemWrite), .MemRead(MemRead),  .clk(clk), .in_store(a), .in_store_address(c), .in_load(c), .out_load(d));
    reg_file rf3(.control(RegWrite), .MemToReg(MemToReg), .clk(clk), .address(instruction[11:7]), .write(1'b1), .in_m(d), .in(c), .out(temp));
endmodule