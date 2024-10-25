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


  module vga( sys_clk, sys_rst_n, disp_RGB, hsync, vsync );

            input sys_clk; //系统输入时钟 100MHz
            //input [1:0]switch;//控制
            input sys_rst_n;
            output [11:0] disp_RGB; //VGA 数据输出。RGB 4:4:4
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

            wire vga_clk_w;//使用PLL IP对sys_clk分频后的输出
            wire locked_w;//IP的输出，表示PLL输出稳定
            
            wire rst_n_w;//sys_rst_n与locked相与后得到的中间变量,用于其他模块的复位

            wire [11:0] pixel_data_w;//用于接vga数据模块的输出
            wire [11:0] pixel_xpos_w;//像素点横坐标
            wire [11:0] pixel_ypos_w;//
            


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
//至于颜色的设置，可以打开网上调色板，网上一般为24位RGB888，我们可以选择用每个颜色中的高4位
            always @(posedge vga_clk) //产生竖彩条
            begin
                if(hcount < 223)
                    v_dat <= 12'hF00; //红
                else if(hcount < 303) 
                    v_dat <= 12'h0F0; //绿
                else if(hcount < 383)
                    v_dat <= 12'h00F; //蓝
                else if(hcount < 463)
                    v_dat <= 12'hFFF; //白
                else if(hcount < 543)
                    v_dat <= 12'hFF0; //黄
                else if(hcount < 623)
                    v_dat <= 12'hC0F; //紫
                else if(hcount < 703)
                    v_dat <= 12'h2EE; //浅蓝
                else
                    v_dat <= 12'hFFF; //白色
            end

            always @(posedge vga_clk) //产生横彩条
            begin
                if(vcount < 94)
                    h_dat <= 12'hF00; 
                else if(vcount < 154)
                    h_dat <= 12'h0F0; 
                else if(vcount < 214)
                    h_dat <= 12'h00F; 
                else if(vcount < 274)
                    h_dat <= 12'hFFF; 
                else if(vcount < 334)
                    h_dat <= 12'hFF0; 
                else if(vcount < 394)
                    h_dat <= 12'hC0F; 
                else if(vcount < 454)
                    h_dat <= 12'h2EE; 
                else
                    h_dat <= 12'hFFF;
                end
            endmodule

