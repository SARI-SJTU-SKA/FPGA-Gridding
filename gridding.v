`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:28:53 03/30/2016 
// Design Name: 
// Module Name:    gridding 
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
module gridding_0(clk,rst,s_iu,s_iv,s_data,s_offset,C,grid_in,r_gind,w_gind,grid_out,dind,cind,grid_w_in,shift_in,grid_w_out,shift_out);

	parameter nSample = 1820;
	parameter gSize = 128;//32;
	parameter cSize = 1800;//648;//9*9*2*2*2
	parameter support = 7;//4;
	parameter sSize = 15;//9;

    input clk,rst;
    input [31:0]s_iu;//int
    input [31:0]s_iv;//int
    input [63:0]s_data;//double,d_0
    input [31:0]s_offset;//int
    input [64*sSize-1:0]C;
    input [64*sSize-1:0]grid_in;
	 
	 input [2047:0]grid_w_in;
	 input [10:0]shift_in;
 
    output reg[31:0]r_gind;
	 output [31:0]w_gind;
    //output [31:0]dind;
	 output reg[31:0]dind;
	 output reg[31:0]cind;
    output [64*sSize-1:0]grid_out;//2-D array?
	 
	 output [2047:0]grid_w_out;
	 output [10:0]shift_out;
    
    reg [31:0]count_n;//nSample
    reg [3:0]count_s;//sSize
    
    wire [31:0]gind_0;
    wire [31:0]cind_0;
    reg [63:0]d;
	 
	 reg [31:0]gind_1;
	 reg [63:0]d_1;
	 wire [64*sSize-1:0]grid_2;
	 
	 //reg [2047:0]buf_grid_w;
	 //reg [10:0]buf_shift;
	 
	 
	 /*
	 reg flag_1;
	 reg flag_2;
	 reg flag_b1;
	 reg flag_b2;
	 */
	 reg flag_choose;
	 reg [31:0]gind_b1;
	 reg [31:0]gind_b2;
	 //reg [31:0]buf_gind;
	 //reg [31:0]buf_cind;
	 //reg [63:0]buf_data;
	 wire [31:0]buf_gind;
     wire [31:0]buf_cind;
     wire [63:0]buf_data;
     
	 reg [31:0]next_gind;
	 reg [31:0]next_cind;
	 reg [63:0]next_data;
	 
	 reg [63:0]b_gind;
	 reg [63:0]b_cind;
	 reg [127:0]b_data;
	 
	 assign buf_gind = b_gind[31:0];
	 assign buf_cind = b_cind[31:0];
	 assign buf_data = b_data[63:0];
	 /*
    always@(posedge clk)
    if(rst==0)
    begin
        count_n <= 32'b1;
        count_s <= sSize;
    end
    else
    begin
        if(count_n <= nSample && count_s == sSize-1)
        count_n <= count_n + 32'b1;
		  else if(count_s == 1'b1 && gind_0 <= r_gind)
		  count_n <= count_n - 32'b1;
		  else
		  count_n <= count_n;
        if(count_s == sSize)
		  count_s <= 4'b1;
		  else
        count_s <= count_s + 4'b1;
    end
	 
	 
	 assign dind = count_n-32'b1;//?
	 //#0
	 assign gind_0 = s_iu + s_iv * gSize - support;
	 assign cind_0 = s_offset;
	 */
	 always@(posedge clk)
    if(rst==0)
    begin
        count_n <= 32'b1;
        count_s <= sSize;
    end
    else
    begin
        if(count_s == sSize)
		  count_s <= 32'b1;
		  else
        count_s <= count_s + 32'b1;
		  
		  if(count_n < nSample && count_s == sSize-1 && (next_gind != 32'b0 || next_data != 64'b0))//not bubble
        count_n <= count_n + 32'b1;
		  else 
		  count_n <= count_n;
    end
	 
	 
	 //assign dind = count_n-32'b1;//?
	 always@(posedge clk)
	 if(rst == 0)
		dind <= 32'b0;
	 //else if(count_s == sSize-1)
		//dind <= count_n;
	 else if(count_s == sSize)
		dind <= count_n;
	 else if(count_s == 4'd3 && flag_choose == 1'b0 && gind_0 <= gind_b1 && dind <nSample)
	   dind <= dind + 32'b1;
	 else
		dind <= dind;
	 //#0
	 assign gind_0 = s_iu + s_iv * gSize - support;
	 assign cind_0 = s_offset;
	 
	 
	 //flag_conflict
	 /*
	 always@(posedge clk)
	 if(rst == 0)
		flag_1 <= 0;
	 else if((count_s == 4'd2 || count_s == 4'd5)&& (!((gind_0[6:0]-gind_b1[6:0])>7'd14) || ((gind_b1[6:0]-gind_0[6:0])>7'd14)) && !((gind_0[31:7]+25'd4)<gind_b1[31:7] || gind_0[31:7]>(gind_b1[31:7]+25'd14)))
		flag_1 <= 1;
	 else if(count_s == 4'd2 || count_s == 4'd5)
		flag_1 <= 0;
	 else 
	   flag_1 <= flag_1;
	 always@(posedge clk)
	 if(rst == 0)
		flag_2 <= 0;
	 else if((count_s == 4'd2 || count_s == 4'd5) && (!((gind_0[6:0]-gind_b2[6:0])>7'd14) || ((gind_b2[6:0]-gind_0[6:0])>7'd14)) && !(gind_0[31:7]<(gind_b2[31:7]+25'd11) || gind_0[31:7]>(gind_b2[31:7]+25'd14)))
		flag_2 <= 1;
	 else if(count_s == 4'd2 || count_s == 4'd5)
		flag_2 <= 0;
	 else 
	   flag_2 <= flag_2;
	
	 always@(posedge clk)
	 if(rst == 0)
		flag_b1 <= 0;
	 else if(count_s == 4'd2 && (!((buf_gind[6:0]-gind_b1[6:0])>7'd14) || ((gind_b1[6:0]-buf_gind[6:0])>7'd14)) && !((buf_gind[31:7]+25'd4)<gind_b1[31:7] || buf_gind[31:7]>(gind_b1[31:7]+25'd14)))
		flag_b1 <= 1;
	 else if(count_s == 4'd2)
		flag_b1 <= 0;
	 else
	   flag_b1 <= flag_b1;
	 always@(posedge clk)
	 if(rst == 0)
		flag_b2 <= 0;
	 else if(count_s == 4'd2 && (!((buf_gind[6:0]-gind_b2[6:0])>7'd14) || ((gind_b2[6:0]-buf_gind[6:0])>7'd14)) && !(buf_gind[31:7]<(gind_b2[31:7]+25'd11) || buf_gind[31:7]>(gind_b2[31:7]+25'd14)))
		flag_b2 <= 1;
	else if(count_s == 4'd2)
		flag_b2 <= 0;
	 else
		flag_b2 <= flag_b2;
	*/
	always@(posedge clk)
	 if(rst == 0)
	 flag_choose <= 1'b0;
	 else if(count_s == 32'd2 && buf_data == 64'b0)
	 flag_choose <= 1'b0;//choose sample
	 else if(count_s == 32'd2 && buf_data != 64'b0)
	 flag_choose <= 1'b1;//choose buffer
	 else
	 flag_choose <= flag_choose;
	 //gind_buffer
	 
	 always@(posedge clk)
	 if(rst == 0)
	 begin
		 gind_b1 <= 32'b0;
		 gind_b2 <= 32'b0;
	 end
	 else if(count_s == 4'b1)
	 begin
		 gind_b1 <= next_gind + gSize*(sSize - 1);//?
		 gind_b2 <= gind_b1;
	 end
	 else
	 begin
		 gind_b1 <= gind_b1;
		 gind_b2 <= gind_b2;
	 end
	 
	 //sample_buffer
	 always@(posedge clk)
	 if(rst == 0)
	 begin
		 b_gind <= 32'b0;
		 b_cind <= 32'b0;
		 b_data <= 64'b0;
	 end
	 else if(count_s == 4'd3 && gind_0 <= gind_b1 && flag_choose == 1'b0 && buf_data!=64'b0)
	 begin
		 b_gind <= {gind_0,buf_gind};
		 b_cind <= {cind_0,buf_cind};
		 b_data <= {s_data,buf_data};
	 end
	 else if(count_s == 4'd3 && gind_0 <= gind_b1 && flag_choose == 1'b0 && buf_data==64'b0)
	 begin
	     b_gind <= gind_0;
         b_cind <= cind_0;
         b_data <= s_data;
	 end
	 else if(count_s == 4'd3 && flag_choose == 1'b1 && buf_gind > gind_b1)//3 or 4
	 begin
	     b_gind <= {32'b0,b_gind[63:32]};
         b_cind <= {32'b0,b_cind[63:32]};
         b_data <= {64'b0,b_data[127:64]};
	 end
	 //prepare
	 always@(posedge clk)
	 if(rst == 0)
	 begin
		next_gind <= 32'b0;
		next_cind <= 32'b0;
		next_data <= 64'b0;
	 end
	 else if(count_s == 4'd3 && flag_choose == 1'b0 && gind_0 > gind_b1)
	 begin
		next_gind <= gind_0;
		next_cind <= cind_0;
		next_data <= s_data;
	 end
	 else if(count_s == 4'd3 && flag_choose == 1'b1 && buf_gind > gind_b1)
	 begin
		next_gind <= buf_gind;
		next_cind <= buf_cind;
		next_data <= buf_data;
	 end
	 else if(count_s == 4'd3 && flag_choose == 1'b1 && buf_gind <= gind_b1)
	 begin
		next_gind <= 32'b0;
		next_cind <= 32'b0;
		next_data <= 64'b0;
	 end
	 else if(count_s == 4'd6 && b_data[127:64] != 64'b0 && gind_0 > gind_b1 && flag_choose == 1'b0)
	 begin
		next_gind <= gind_0;
		next_cind <= cind_0;
		next_data <= s_data;
	 end
	 else if(count_s == 4'd6 && b_data[127:64] != 64'b0 && gind_0 <= gind_b1 && flag_choose == 1'b0)
	 begin
		next_gind <= 32'b0;
		next_cind <= 32'b0;
		next_data <= 64'b0;
	 end
	 else
	 begin
		next_gind <= next_gind;
		next_cind <= next_cind;
		next_data <= next_data;
	 end
	 /*
	 //pre #1
	 always@(posedge clk)
	 if(rst == 0)
	 begin
		r_gind <= 32'b0;
		cind <= 32'b0;
		d <= 64'b0;
	 end
	 else 
	 begin
		if(count_s == 4'b1 && gind_0 > r_gind)//?
		begin
			r_gind <= gind_0;
			cind <= cind_0;
			d <= s_data;
		end
		else if(count_s == 4'b1 && gind_0 <= r_gind)//?
		begin
			r_gind <= 32'b0;
			cind <= 32'b0;
			d <= 64'b0;
		end
		else
		begin
			r_gind <= r_gind+gSize;
			cind <= cind+sSize;
			d <= d;
		end
	 end*/
	 //pre #1
	 always@(posedge clk)
	 if(rst == 0)
	 begin
		r_gind <= 32'b0;
		cind <= 32'b0;
		d <= 64'b0;
	 end
	 else 
	 begin
		if(count_s == 4'b1)//?
		begin
			r_gind <= next_gind;//?
			cind <= next_cind;//?
			d <= next_data;//?
		end
		else
		begin
			r_gind <= r_gind+gSize;
			cind <= cind+sSize;
			d <= d;
		end
	 end
	 //#1
	 always@(posedge clk)
	 if(rst == 0)
	 begin
		d_1 <= 64'b0;
		gind_1 <= 32'b0;
	 end
	 else
	 begin
		d_1 <= d;
		gind_1 <= r_gind;// - gSize;//?
	 end
	 //#2
	 buffer_1 b1 (.clk(clk),.grid_in(grid_in),.grid_out(grid_2));
	 //#3
	 buffer_2 b2 (.clk(clk),.grid_in(grid_w_in),.gind_in(gind_1),.shift_in(shift_in),.grid_out(grid_w_out),.gind_out(w_gind),.shift_out(shift_out));
	 
    
    wire [32*sSize-1:0]tmp;
	wire [31:0]w_grid_real[0:(sSize-1)];
	wire [sSize-1:0]m_valid;
    wire [sSize-1:0]a_valid; 
    genvar i;
    generate 
    for(i=0;i<sSize;i=i+1)
    begin:loop3
    //[imag,real]
    //step1
	 //multi multi_aa (.a(d_1[31:0]),.b(C[i*64+:32]),.clk(clk),.result(tmp[i*32+:32]));
	 //adder adder_real(.a(tmp[i*32+:32]),.b(grid_2[i*64+:32]),.clk(clk),.result(w_grid_real[i]));
	 multi multi_aa (.s_axis_a_tdata(d_1[31:0]),.s_axis_a_tvalid(1'b1),.s_axis_b_tdata(C[i*64+:32]),.s_axis_b_tvalid(1'b1),.aclk(clk),.m_axis_result_tdata(tmp[i*32+:32]),.m_axis_result_tvalid(m_valid[i]));
     adder adder_real(.s_axis_a_tdata(tmp[i*32+:32]),.s_axis_a_tvalid(1'b1),.s_axis_b_tdata(grid_2[i*64+:32]),.s_axis_b_tvalid(1'b1),.aclk(clk),.m_axis_result_tdata(w_grid_real[i]),.m_axis_result_tvalid(a_valid[i]));
     //f32_multi multi_aa(.opa(d),.opb(reg_C[i*64+:32]),.result(tmp[i*32+:32]));
	 //f32_adder adder_real(.rst(rst),.opa(reg_tmp[i*32+:32]),.opb(grid_in[i*64+:32]),.sum(w_grid_real[i]));
	 assign grid_out[(64*i)+:64] = {32'b0,w_grid_real[i]};
    end
    endgenerate
    
endmodule

//`timescale 1ns / 100ps
////////////////////////////////////////////////////////////////////////////////////
//// Company: 
//// Engineer: 
//// 
//// Create Date:    15:28:53 03/30/2016 
//// Design Name: 
//// Module Name:    gridding 
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
//module gridding_0(clk,rst,s_iu,s_iv,s_data,s_offset,C,grid_in,r_gind,w_gind,grid_out,dind,cind,grid_w_in,shift_in,grid_w_out,shift_out);

//	parameter nSample = 180;
//	parameter gSize = 128;//32;
//	parameter cSize = 1800;//648;//9*9*2*2*2
//	parameter support = 7;//4;
//	parameter sSize = 15;//9;

//    input clk,rst;
//    input [31:0]s_iu;//int
//    input [31:0]s_iv;//int
//    input [63:0]s_data;//double,d_0
//    input [31:0]s_offset;//int
//    input [64*sSize-1:0]C;
//    input [64*sSize-1:0]grid_in;
	 
//	 input [2047:0]grid_w_in;
//	 input [10:0]shift_in;
 
//    output reg[31:0]r_gind;
//	 output [31:0]w_gind;
//    output [31:0]dind;
//	 output reg[31:0]cind;
//    output [64*sSize-1:0]grid_out;//2-D array?
	 
//	 output [2047:0]grid_w_out;
//	 output [10:0]shift_out;
    
//    reg [31:0]count_n;//nSample
//    reg [3:0]count_s;//sSize
    
//    wire [31:0]gind_0;
//    wire [31:0]cind_0;
//    reg [63:0]d;
	 
//	 reg [31:0]gind_1;
//	 reg [63:0]d_1;
//	 wire [64*sSize-1:0]grid_2;
//	 //reg [2047:0]buf_grid_w;
//	 //reg [10:0]buf_shift;
	 
//    always@(posedge clk)
//    if(rst==0)
//    begin
//        count_n <= 32'b1;
//        count_s <= sSize;
//    end
//    else
//    begin
//        if(count_n <= nSample && count_s == sSize-1)
//        count_n <= count_n + 32'b1;
//        if(count_s == sSize)
//		  count_s <= 4'b1;
//		  else
//        count_s <= count_s + 4'b1;
//    end
	 
	 
//	 assign dind = count_n-32'b1;//?
//	 //#0
//	 assign gind_0 = s_iu + s_iv * gSize - support;
//	 assign cind_0 = s_offset;
	 
//	 //pre #1
//	 always@(posedge clk)
//	 if(rst == 0)
//	 begin
//		r_gind <= 32'b0;
//		cind <= 32'b0;
//		d <= 64'b0;
//	 end
//	 else 
//	 begin
//		if(count_s == 4'b1)//?
//		begin
//			r_gind <= gind_0;
//			cind <= cind_0;
//			d <= s_data;
//		end
//		else
//		begin
//			r_gind <= r_gind+gSize;
//			cind <= cind+sSize;
//			d <= d;
//		end
//	 end
//	 //#1
//	 always@(posedge clk)
//	 if(rst == 0)
//	 begin
//		d_1 <= 64'b0;
//		gind_1 <= 32'b0;
//	 end
//	 else
//	 begin
//		d_1 <= d;
//		gind_1 <= r_gind;// - gSize;//?
//	 end
//	 reg [31:0]gind_2;
//	 reg [63:0]d_2;
//	 always@(posedge clk)
//	 if(rst == 0)
//	 begin
//		d_2 <= 64'b0;
//		gind_2 <= 32'b0;
//	 end
//	 else
//	 begin
//		d_2 <= d_1;
//		gind_2 <= gind_1;// - gSize;//?
//	 end
//	 //#2
//	 buffer_1 b1 (.clk(clk),.grid_in(grid_in),.grid_out(grid_2));
//	 //#3
//	 buffer_2 b2 (.clk(clk),.grid_in(grid_w_in),.gind_in(gind_2),.shift_in(shift_in),.grid_out(grid_w_out),.gind_out(w_gind),.shift_out(shift_out));
	 
    
//    wire [32*sSize-1:0]tmp;
//	wire [31:0]w_grid_real[0:(sSize-1)];
//	wire [sSize-1:0]m_valid;
//	wire [sSize-1:0]a_valid;
//    genvar i;
//    generate 
//    for(i=0;i<sSize;i=i+1)
//    begin:loop3
//    //[imag,real]
//    //step1
//	 multi multi_aa (.s_axis_a_tdata(d_2[31:0]),.s_axis_a_tvalid(1'b1),.s_axis_b_tdata(C[i*64+:32]),.s_axis_b_tvalid(1'b1),.aclk(clk),.m_axis_result_tdata(tmp[i*32+:32]),.m_axis_result_tvalid(m_valid[i]));
//	 adder adder_real(.s_axis_a_tdata(tmp[i*32+:32]),.s_axis_a_tvalid(1'b1),.s_axis_b_tdata(grid_2[i*64+:32]),.s_axis_b_tvalid(1'b1),.aclk(clk),.m_axis_result_tdata(w_grid_real[i]),.m_axis_result_tvalid(a_valid[i]));
//	 //f32_multi multi_aa(.opa(d),.opb(reg_C[i*64+:32]),.result(tmp[i*32+:32]));
//	 //f32_adder adder_real(.rst(rst),.opa(reg_tmp[i*32+:32]),.opb(grid_in[i*64+:32]),.sum(w_grid_real[i]));
//	 assign grid_out[(64*i)+:64] = {32'b0,w_grid_real[i]};
//    end
//    endgenerate
    
//endmodule
