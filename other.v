
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:41:07 05/17/2016 
// Design Name: 
// Module Name:    other 
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
module buffer_1(clk,grid_in,grid_out
    );
	 parameter sSize = 15;
	 parameter stage = 8;
	 input clk;
	 input [64*sSize-1:0]grid_in;
	 output [64*sSize-1:0]grid_out;
	 genvar i;
    generate 
    for(i=0;i<4;i=i+1)
    begin:loop
    shift_reg_240 s_240(.D(grid_in[i*240+:240]),.CLK(clk),.Q(grid_out[i*240+:240]));
    end
    endgenerate
endmodule

module buffer_2(clk,gind_in,shift_in,grid_in,gind_out,shift_out,grid_out
	 );
	 parameter sSize = 15;
	 parameter stage = 16;
	 input clk;
	 input [2047:0]grid_in;
	 input [31:0]gind_in;
	 input [10:0]shift_in;
	 output [2047:0]grid_out;
	 output [31:0]gind_out;
	 output [10:0]shift_out;
	 
	 genvar i;
    generate 
    for(i=0;i<8;i=i+1)
    begin:loop
    shift_reg s_256 (.D(grid_in[i*256+:256]),.CLK(clk),.Q(grid_out[i*256+:256]));
    end
    endgenerate
	 
	 shift_reg_43 s_43 (.D({shift_in,gind_in}),.CLK(clk),.Q({shift_out,gind_out}));
	 
endmodule

module output_trans(clk,rst,t,grid_in,result
	 );
	 input clk;
	 input rst;
	 input [4:0]t;
	 input [2047:0]grid_in;
	 output [63:0]result;
	 
	 reg [2047:0]tmp;
	 
	 always@(posedge clk)
	 if(rst==0)
	 begin
	 tmp <= 2048'b0;
	 end
	 else
	 begin
		if(t == 1)
		tmp <= grid_in;
		else
		tmp <= tmp << 64;
	 end
	 assign result = tmp[2047:1984];
	 

endmodule

//`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////
//// Company: 
//// Engineer: 
//// 
//// Create Date:    14:41:07 05/17/2016 
//// Design Name: 
//// Module Name:    other 
//// Project Name: 
//// Target Devices: 
//// Tool versions: 
//// Description: 
////
//// Dependencies: 
////
//// Revision: 
//// Revision 0.01 - File Created
//// Additional Comments: 
////
////////////////////////////////////////////////////////////////////////////////////
//module buffer_1(clk,grid_in,grid_out
//    );
//	 parameter sSize = 15;
//	 parameter stage = 8;
//	 input clk;
//	 input [64*sSize-1:0]grid_in;
//	 output [64*sSize-1:0]grid_out;
//	 genvar i;
//    generate 
//    for(i=0;i<4;i=i+1)
//    begin:loop
//    shift_reg_240 s_240(.D(grid_in[i*240+:240]),.CLK(clk),.Q(grid_out[i*240+:240]));
//    end
//    endgenerate
//endmodule

//module buffer_2(clk,gind_in,shift_in,grid_in,gind_out,shift_out,grid_out
//	 );
//	 parameter sSize = 15;
//	 parameter stage = 16;
//	 input clk;
//	 input [2047:0]grid_in;
//	 input [31:0]gind_in;
//	 input [10:0]shift_in;
//	 output [2047:0]grid_out;
//	 output [31:0]gind_out;
//	 output [10:0]shift_out;
	 
//	 genvar i;
//    generate 
//    for(i=0;i<8;i=i+1)
//    begin:loop
//    shift_reg s_256 (.D(grid_in[i*256+:256]),.CLK(clk),.Q(grid_out[i*256+:256]));
//    end
//    endgenerate
	 
//	 shift_reg_43 s_43 (.D({shift_in,gind_in}),.CLK(clk),.Q({shift_out,gind_out}));
	 
//endmodule

//module output_trans(clk,rst,sig_end,t,grid_in,result,num
//	 );
//	 input clk;
//	 input rst;
//	 input sig_end;
//	 input [4:0]t;
//	 input [2047:0]grid_in;
//	 output [63:0]result;
//	 output reg [63:0]num;
	 
//	 reg [2047:0]tmp;
//	 //reg [63:0]count;
	 
//	 always@(posedge clk)
//	 if(rst==0)
//	 begin
//	 tmp <= 2048'b0;
//	 end
//	 else
//	 begin
//		if(t == 1'b1 && sig_end == 1'b1)
//		tmp <= grid_in;
//		else if(sig_end == 1'b1)
//		tmp <= tmp << 64;
//		else
//		tmp <= ~2048'b0;
//	 end
//	 assign result = tmp[2047:1984];
//	 always@(posedge clk)
//	 if(rst==0)
//	   num<=0;
//	 else if(sig_end!=1'b1)
//	   num<=num+1;
//	 else
//	   num<=num;
	 
	 

//endmodule

