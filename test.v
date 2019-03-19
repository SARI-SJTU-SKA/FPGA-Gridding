`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:48:53 04/26/2016 
// Design Name: 
// Module Name:    test 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module test;
reg clk;
reg rst;
//reg [31:0]A;
//wire [31:0]B;
initial
begin
    clk = 0;
    rst = 0;
    #7 rst = 1;
	 //A = 32'b00111111100000000000000000000000;
	 //#10 A = 32'b00111001110110011011000000000000;
	 //#10  A = 32'b00111001110110001011000000000000;
	 //#10  A = 32'b00111001110100001011000000000000;
end
always
#5 clk = ~clk;

/*
wire [31:0]C_m;
wire [31:0]C_a;
assign B = 32'b01000010000000110010100000100100;
multi multi_test (.a(A),.b(B),.clk(clk),.result(C_m));
adder adder_test(.a(A),.b(B),.clk(clk),.result(C_a));
*/
//wire [63:0]result;
//wire [63:0]num;
//wire sig_end;
wire [31:0]n_cycles;
wire [31:0]n_samples;
wire [63:0]result;
wire [13:0]grid_index;
top test(.clk(clk),.rst(rst),.result(result),.n_cycles(n_cycles),.n_samples(n_samples),.grid_index(grid_index));
endmodule
/*
module test(clk,rst);
	 input clk;
	 input rst;
	 output [255:0]result;
	 input [255:0]data_a;
	 input [255:0]data_b;
	 wire [63:0]data_c[0:3];
	 wire [63:0]data_d[0:3];
	 
	 genvar i;
    generate 
    for(i=0;i<4;i=i+1)
    begin:loop3
    //step1
	 //multi multi_aa(.a(data_a[i*64+:64]),.b(data_b[i*64+:64]),.clk(clk),.result(data_c[i]));
	 //adder adder_real(.a(data_a[i*64+:64]),.b(data_c[i]),.clk(clk),.result(data_d[i]));
	 f64_multi multi_aa(.opa(data_a[i*64+:64]),.opb(data_b[i*64+:64]),.result(data_c[i]));
	 f64_adder adder_real(.rst(rst),.opa(data_a[i*64+:64]),.opb(data_c[i]),.sum(data_d[i]));
	 assign result[i*64+:64] = data_d[i];
    end
    endgenerate

module test(clk,rst,data_a,data_b,result
    );
	 input clk;
	 input rst;
	 output [255:0]result;
	 input [255:0]data_a;
	 input [255:0]data_b;
	 wire [63:0]data_c[0:3];
	 wire [63:0]data_d[0:3];
	 
	 genvar i;
    generate 
    for(i=0;i<4;i=i+1)
    begin:loop3
    //step1
	 //multi multi_aa(.a(data_a[i*64+:64]),.b(data_b[i*64+:64]),.clk(clk),.result(data_c[i]));
	 //adder adder_real(.a(data_a[i*64+:64]),.b(data_c[i]),.clk(clk),.result(data_d[i]));
	 f64_multi multi_aa(.opa(data_a[i*64+:64]),.opb(data_b[i*64+:64]),.result(data_c[i]));
	 f64_adder adder_real(.rst(rst),.opa(data_a[i*64+:64]),.opb(data_c[i]),.sum(data_d[i]));
	 assign result[i*64+:64] = data_d[i];
    end
    endgenerate
endmodule
*/