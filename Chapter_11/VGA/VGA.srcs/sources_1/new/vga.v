`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/20/2016 10:46:52 AM
// Design Name: 
// Module Name: vga
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 产生两种条纹和两种棋盘格照片，通过拨码开关控制具体显示哪一个
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


  module vga( sys_clk, switch, disp_RGB, hsync, vsync );

            input sys_clk; //系统输入时钟 100MHz
            input [1:0]switch;//控制
            output [11:0]disp_RGB; //VGA 数据输出。RGB 4:4:4
            output hsync; //VGA 行同步信号
            output vsync; //VGA 场同步信号

            reg [9:0] hcount; //VGA 行扫描计数器
            reg [9:0] vcount; //VGA 场扫描计数器
            reg [11:0] data;
            reg [11:0] h_dat;
            reg [11:0] v_dat;
            reg flag;
            wire hcount_ov;
            wire vcount_ov;
            wire dat_act;
            wire hsync;
            wire vsync;
            wire vga_clk;
            //reg cnt_clk=0; //分频计数



            //VGA 行、场扫描时序参数表
            parameter hsync_end = 10'd95,
                      hdat_begin = 10'd143,
                      hdat_end = 10'd783,
                      hpixel_end = 10'd799,
                      vsync_end = 10'd1,
                      vdat_begin = 10'd34,
                      vdat_end = 10'd514,
                      vline_end = 10'd524;

            clk_wiz_0 inst
              (
              // Clock out ports  
              .clk_out1(vga_clk),
              .clk_in1(sys_clk)
              );
/*
            always @(posedge sys_clk)
            begin
                if(cnt_clk == 1)begin
                    vga_clk <= ~vga_clk;
                    cnt_clk <= 0;
                end
                else
                    cnt_clk <= cnt_clk +1;
            end
*/
  //************************VGA 驱动部分*******************************//行扫描
            always @(posedge vga_clk)
            begin
                if (hcount_ov)
                    hcount <= 10'd0;
                 else
                    hcount <= hcount + 10'd1;
            end
            assign hcount_ov = (hcount == hpixel_end);

            //场扫描
            always @(posedge vga_clk)
            begin
                if (hcount_ov) begin
                    if (vcount_ov)
                        vcount <= 10'd0;
                    else
                        vcount <= vcount + 10'd1;
                end
            end
            assign vcount_ov = (vcount == vline_end);

            //数据、同步信号输
            assign dat_act = ((hcount >= hdat_begin) && (hcount < hdat_end))
&& ((vcount >= vdat_begin) && (vcount < vdat_end));
            assign hsync = (hcount > hsync_end);
            assign vsync = (vcount > vsync_end);
            assign disp_RGB = (dat_act) ? data : 12'h000;

            always @(posedge vga_clk)
            begin
                case(switch[1:0])
                    2'd0: data <= h_dat; //选择横彩条
                    2'd1: data <= v_dat; //选择竖彩条
                    2'd2: data <= (v_dat ^ h_dat); //产生棋盘格
                    2'd3: data <= (v_dat ~^ h_dat); //产生棋盘格
                endcase
            end

            always @(posedge vga_clk) //产生竖彩条
            begin
                if(hcount < 223)
                    v_dat <= 12'hF00; 
                else if(hcount < 303)
                    v_dat <= 12'h0F0; 
                else if(hcount < 383)
                    v_dat <= 12'h00F;
                else if(hcount < 463)
                    v_dat <= 12'hCCC; 
                else if(hcount < 543)
                    v_dat <= 12'hAAA; 
                else if(hcount < 623)
                    v_dat <= 12'hCCC; 
                else if(hcount < 703)
                    v_dat <= 12'h000; 
                else
                    v_dat <= 12'h000; 
            end

            always @(posedge vga_clk) //产生横彩条
            begin
                if(vcount < 94)
                    h_dat <= 12'hF00; 
                else if(vcount < 154)
                    h_dat <= 12'h000; 
                else if(vcount < 214)
                    h_dat <= 12'hF00; 
                else if(vcount < 274)
                    h_dat <= 12'h444; 
                else if(vcount < 334)
                    h_dat <= 12'h333; 
                else if(vcount < 394)
                    h_dat <= 12'h222; 
                else if(vcount < 454)
                    h_dat <= 12'h111; 
                else
                    h_dat <= 12'h000;
                end
            endmodule

