
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:00:39 03/31/2016 
// Design Name: 
// Module Name:    top 
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
module top(clk,rst,n_cycles,n_samples,result,grid_index);
//module top(clk,rst);

parameter nSample = 1820;
parameter gSize = 128;//32;
parameter cSize = 1800;//648;//9*9*2*2*2
parameter support = 7;//4;
parameter sSize = 15;//9;

input clk;
input rst;
output reg [31:0]n_cycles;
output [31:0]n_samples;
output [63:0]result;
output [13:0]grid_index;
wire sig_end;

wire [31:0]w_rgind;
wire [31:0]w_wgind;
wire [31:0]w_dind;
wire [31:0]w_cind;
wire [64*sSize-1:0]w_grid_out;
wire [64*sSize-1:0]w_grid_in;
wire [(64*sSize-1):0]w_C;

wire [63:0]dout_c;
wire [63:0]dout_data;
wire [31:0]dout_iu;
wire [31:0]dout_iv;
wire [31:0]dout_offset;
wire [1023:0]r_0;
wire [1023:0]r_1;

wire [2047:0]grid_w_0;
wire [2047:0]grid_w_1;
wire [10:0]s_w;
reg [10:0]s_r;
wire [31:0]addr_r_0;
wire [31:0]addr_r_1;
wire [31:0]addr_w_0;
wire [31:0]addr_w_1;

wire [2047:0]tmp_0;
wire [959:0]a;
wire [2047:0]choose;
wire [2047:0]grid_ch;
wire [2047:0]grid_new;

reg [31:0]count_g;
wire [2047:0]tmp_result;
//////////////////////////////////////////////////////////////////////////////////
//grid kernel
gridding_0 grid_kernel(.clk(clk),.rst(rst),
                           .s_iu(dout_iu),//??
                           .s_iv(dout_iv),
                           .s_data(dout_data),
                           .s_offset(dout_offset),
                           .C(w_C),
                           .grid_in(w_grid_in),//?
                           .r_gind(w_rgind),
									.w_gind(w_wgind),
                           .grid_out(w_grid_out),//?
                           .dind(w_dind),
									.cind(w_cind),
									.grid_w_in(grid_ch),
									.shift_in(s_r),
									.grid_w_out(grid_w_0),
									.shift_out(s_w));
//////////////////////////////////////////////////////////////////////////////////
//MEM

MEM_s_data s_data (
  .clka(clk), // input clka
  .addra(w_dind), // input [31 : 0] addra
  .douta(dout_data) // output [63 : 0] douta
);

MEM_s_iu s_iu (
  .clka(clk), // input clka
  .addra(w_dind), // input [31 : 0] addra
  .douta(dout_iu) // output [31 : 0] douta
);

MEM_s_iv s_iv (
  .clka(clk), // input clka
  .addra(w_dind), // input [31 : 0] addra
  .douta(dout_iv) // output [31 : 0] douta
);

MEM_s_offset s_offset (
  .clka(clk), // input clka
  .addra(w_dind), // input [31 : 0] addra
  .douta(dout_offset) // output [31 : 0] douta
);
wire wea;
assign wea = (~sig_end)&(w_dind >= 2);
assign grid_index = count_g-2;
wire [1023:0]w_0;
wire [1023:0]w_1;
reg flag_r;
assign n_samples = w_dind;
always@(posedge clk)
if(rst == 0)
begin
flag_r <= 0;
s_r <= 0;
end
else
begin
flag_r <= w_rgind[4];
s_r <= (17-w_rgind[3:0])<<6;
end

assign addr_w_0 = addr_w_1 + w_wgind[4];
assign addr_w_1 = w_wgind>>5;
assign w_0 = w_wgind[4] ? (grid_new[1023:0]) : (grid_new[2047:1024]);
assign w_1 = w_wgind[4] ? (grid_new[2047:1024]) : (grid_new[1023:0]);
assign grid_w_1 = w_grid_out<<s_w;
assign grid_new = grid_w_0 | grid_w_1;

assign addr_r_0 = sig_end ? (count_g>>5) : (addr_r_1+{10'b0,w_rgind[4]});
assign addr_r_1 = sig_end ? (count_g>>5) : (w_rgind>>5);
//assign s_r = (17-w_rgind[3:0])<<6;
assign tmp_0 = flag_r ? {r_1,r_0} : {r_0,r_1};
assign w_grid_in = tmp_0 >> s_r;
assign a = 960'b0;
assign choose = {1088'b0,~a}<<s_r;
assign grid_ch = tmp_0 & (~choose);

MEM_grid_0 Reg_grid (
  .clka(clk), // input clka
  .wea(wea), // input [0 : 0] wea
  .addra(addr_w_0), // input [31 : 0] addra
  .dina(w_0), // input [1023 : 0] dina
  .clkb(clk), // input clkb
  .addrb(addr_r_0), // input [31 : 0] addrb
  .doutb(r_0) // output [1023 : 0] doutb
);
MEM_grid_1 Reg_grid_1 (
  .clka(clk), // input clka
  .wea(wea), // input [127 : 0] wea
  .addra(addr_w_1), // input [31 : 0] addra
  .dina(w_1), // input [1023 : 0] dina
  .clkb(clk), // input clkb
  .addrb(addr_r_1), // input [31 : 0] addrb
  .doutb(r_1) // output [1023 : 0] doutb
);
wire [31:0]addr_0;
wire [31:0]addr_1;
reg [10:0]s_1;
reg flag_1;
wire [1023:0]dout_0;
wire [1023:0]dout_1;
wire [2047:0]tmp;
MEM_C_0 Reg_C_0  (
  .clka(clk), // input clka
  .addra(addr_0), // input [31 : 0] addra
  .douta(dout_0) // output [1023 : 0] douta
);
MEM_C_1 Reg_C_1  (
  .clka(clk), // input clka
  .addra(addr_1), // input [31 : 0] addra
  .douta(dout_1) // output [1023 : 0] douta
);

always@(posedge clk)
if(rst == 0)
begin
flag_1 <= 0;
s_1 <= 0;
end
else
begin
flag_1 <= w_cind[4];
s_1 <= (17-w_cind[3:0])<<6;
end
assign addr_0 = addr_1+{10'b0,w_cind[4]};
assign addr_1 = w_cind>>5;//32
//assign s_1 = (17-w_cind[3:0])<<6;
assign tmp = flag_1 ? {dout_1,dout_0} : {dout_0,dout_1};
assign w_C = tmp >> s_1;

always@(posedge clk)
if(rst==0)
count_g <= 0;
else if(w_dind == nSample)
count_g <= count_g + 1;
always@(posedge clk)
if(rst==0)
n_cycles <= 0;
else if(w_dind < nSample && count_g < (gSize*gSize))
n_cycles <= n_cycles + 1;
else
n_cycles <= n_cycles;
assign sig_end = (w_dind == nSample);
assign tmp_result = sig_end ? {r_0,r_1} : (~2048'b0) ;

output_trans grid_result(.clk(clk),.rst(rst),.t(count_g[4:0]),.grid_in(tmp_result),.result(result));
endmodule

//`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////
//// Company: 
//// Engineer: 
//// 
//// Create Date:    19:00:39 03/31/2016 
//// Design Name: 
//// Module Name:    top 
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
//module top(clk,rst,result,num,sig_end);
////module top(clk,rst);

//parameter nSample = 180;
//parameter gSize = 128;//32;
//parameter cSize = 1800;//648;//9*9*2*2*2
//parameter support = 7;//4;
//parameter sSize = 15;//9;

//input clk;
//input rst;
//output [63:0]result;
////wire [63:0]result;
//output [63:0]num;
////wire [63:0]num;
//output sig_end;

//wire [31:0]w_rgind;
//wire [31:0]w_wgind;
//wire [31:0]w_dind;
//wire [31:0]w_cind;
//wire [64*sSize-1:0]w_grid_out;
//wire [64*sSize-1:0]w_grid_in;
//wire [(64*sSize-1):0]w_C;

//wire [63:0]dout_c;
//wire [63:0]dout_data;
//wire [31:0]dout_iu;
//wire [31:0]dout_iv;
//wire [31:0]dout_offset;
//wire [1023:0]r_0;
//wire [1023:0]r_1;

//wire [2047:0]grid_w_0;
//wire [2047:0]grid_w_1;
//wire [10:0]s_w;
//reg [10:0]s_r;
//wire [31:0]addr_r_0;
//wire [31:0]addr_r_1;
//reg [31:0]addr_w_0;
//reg [31:0]addr_w_1;

//reg [2047:0]tmp_0;
//wire [959:0]a;
//wire [2047:0]choose;
//wire [2047:0]grid_ch;
//reg [2047:0]grid_new;

//reg [31:0]count_g;
//wire [2047:0]tmp_result;
////////////////////////////////////////////////////////////////////////////////////
////grid kernel
//gridding_0 grid_kernel(.clk(clk),.rst(rst),
//                           .s_iu(dout_iu),//??
//                           .s_iv(dout_iv),
//                           .s_data(dout_data),
//                           .s_offset(dout_offset),
//                           .C(w_C),
//                           .grid_in(w_grid_in),//?
//                           .r_gind(w_rgind),
//									.w_gind(w_wgind),
//                           .grid_out(w_grid_out),//?
//                           .dind(w_dind),
//									.cind(w_cind),
//									.grid_w_in(grid_ch),
//									.shift_in(s_r),
//									.grid_w_out(grid_w_0),
//									.shift_out(s_w));
////////////////////////////////////////////////////////////////////////////////////
////MEM

//MEM_s_data s_data (
//  .clka(clk), // input clka
//  .addra(w_dind), // input [31 : 0] addra
//  .douta(dout_data) // output [63 : 0] douta
//);

//MEM_s_iu s_iu (
//  .clka(clk), // input clka
//  .addra(w_dind), // input [31 : 0] addra
//  .douta(dout_iu) // output [31 : 0] douta
//);

//MEM_s_iv s_iv (
//  .clka(clk), // input clka
//  .addra(w_dind), // input [31 : 0] addra
//  .douta(dout_iv) // output [31 : 0] douta
//);

//MEM_s_offset s_offset (
//  .clka(clk), // input clka
//  .addra(w_dind), // input [31 : 0] addra
//  .douta(dout_offset) // output [31 : 0] douta
//);
//wire wea;
//assign wea = (~sig_end)&&(w_dind >= 2);

//reg [1023:0]w_0;
//reg [1023:0]w_1;
//reg flag_r;
//reg [10:0]shift_r;
//reg [31:0]tmp_addr;
//always@(posedge clk)
//if(rst == 0)
//begin
//flag_r <= 1'b0;
//shift_r <= 11'b0;
//s_r <= 11'b0;
//tmp_0 <= 2048'b0;
//w_0 <= 1024'b0;
//w_1 <= 1024'b0;
//addr_w_0 <= 32'b0;
//addr_w_1 <= 32'b0;
//tmp_addr <= 32'b0;
//grid_new <= 32'b0;
//end
//else
//begin
//shift_r <= 17-w_rgind[3:0];
//flag_r <= w_rgind[4];
//s_r <= shift_r<<6;
//addr_w_0 <= tmp_addr + w_wgind[4];
//addr_w_1 <= tmp_addr;
//tmp_addr <= w_wgind>>5;
//grid_new <= grid_w_0 | grid_w_1;
//if(flag_r == 1'b1)
//tmp_0 <= {r_1,r_0};
//else
//tmp_0 <= {r_0,r_1};
//if(w_wgind[4]== 1'b1)
//begin
//w_0 <= grid_new[1023:0];
//w_1 <= grid_new[2047:1024];
//end
//else
//begin
//w_0 <= grid_new[2047:1024];
//w_1 <= grid_new[1023:0];
//end
//end
////assign addr_w_0 = addr_w_1 + w_wgind[4];
////assign addr_w_1 = w_wgind>>5;
////assign w_0 = w_wgind[4] ? (grid_new[1023:0]) : (grid_new[2047:1024]);
////assign w_1 = w_wgind[4] ? (grid_new[2047:1024]) : (grid_new[1023:0]);
//assign grid_w_1 = w_grid_out<<s_w;
////assign grid_new = grid_w_0 | grid_w_1;

//assign addr_r_0 = sig_end ? (count_g>>5) : (addr_r_1+{10'b0,w_rgind[4]});
//assign addr_r_1 = sig_end ? (count_g>>5) : (w_rgind>>5);
////assign s_r = (17-w_rgind[3:0])<<6;
////assign tmp_0 = flag_r ? {r_1,r_0} : {r_0,r_1};
//assign w_grid_in = tmp_0 >> s_r;
//assign a = 960'b0;
//assign choose = {1088'b0,~a}<<s_r;
//assign grid_ch = tmp_0 & (~choose);

//MEM_grid_0 Reg_grid (
//  .clka(clk), // input clka
//  .wea(wea), // input [0 : 0] wea
//  .addra(addr_w_0), // input [31 : 0] addra
//  .dina(w_0), // input [1023 : 0] dina
//  .clkb(clk), // input clkb
//  .addrb(addr_r_0), // input [31 : 0] addrb
//  .doutb(r_0) // output [1023 : 0] doutb
//);
//MEM_grid_1 Reg_grid_1 (
//  .clka(clk), // input clka
//  .wea(wea), // input [127 : 0] wea
//  .addra(addr_w_1), // input [31 : 0] addra
//  .dina(w_1), // input [1023 : 0] dina
//  .clkb(clk), // input clkb
//  .addrb(addr_r_1), // input [31 : 0] addrb
//  .doutb(r_1) // output [1023 : 0] doutb
//);
//wire [31:0]addr_0;
//wire [31:0]addr_1;
//reg [10:0]s_1;
//reg flag_1;
//wire [1023:0]dout_0;
//wire [1023:0]dout_1;
//reg [2047:0]tmp;
//reg [10:0]shift_1;
//MEM_C_0 Reg_C_0  (
//  .clka(clk), // input clka
//  .addra(addr_0), // input [31 : 0] addra
//  .douta(dout_0) // output [1023 : 0] douta
//);
//MEM_C_1 Reg_C_1  (
//  .clka(clk), // input clka
//  .addra(addr_1), // input [31 : 0] addra
//  .douta(dout_1) // output [1023 : 0] douta
//);

//always@(posedge clk)
//if(rst == 0)
//begin
//flag_1 <= 1'b0;
//shift_1 <= 11'b0;
//s_1 <= 11'b0;
//tmp <= 2048'b0;
//end
//else
//begin
//flag_1 <= w_cind[4];
//shift_1 <= 17 - w_cind[3:0];
//s_1 <= shift_1 << 6;
//if(flag_1 == 1'b1)
//tmp <= {dout_1,dout_0};
//else
//tmp <= {dout_0,dout_1};
//end

//assign addr_0 = addr_1+{10'b0,w_cind[4]};
//assign addr_1 = w_cind>>5;//32
////assign s_1 = (17-w_cind[3:0])<<6;
////assign tmp = flag_1 ? {dout_1,dout_0} : {dout_0,dout_1};
//assign w_C = tmp >> s_1;

//always@(posedge clk)
//if(rst==0)
//count_g <= 0;
//else if(w_dind == nSample && count_g < (gSize*gSize))
//count_g <= count_g + 1;
//assign sig_end = (w_dind == nSample);
////assign tmp_result = sig_end ? {r_0,r_1} : (~2048'b0) ;
//output_trans grid_result(.clk(clk),.rst(rst),.sig_end(sig_end),.t(count_g[4:0]),.grid_in({r_0,r_1}),.result(result),.num(num));
////ila_0 ila(.clk(clk),.probe0(num),.probe1(result));
//endmodule
