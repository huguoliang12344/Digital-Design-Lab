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


  module vga( sys_clk, sys_rst_n,switch, vga_rgb, vga_hs, vga_vs );

            input sys_clk; //系统输入时钟 100MHz
            //input [1:0]switch;//控制
            input sys_rst_n;
            input [2:0] switch;
            output [11:0] vga_rgb; //VGA 数据输出。RGB 4:4:4
            output vga_hs; //VGA 行同步信号
            output vga_vs; //VGA 场同步信号

            wire vga_clk;//使用PLL IP对sys_clk分频后的输出
            wire locked;//IP的输出，表示PLL输出稳定
            
            wire rst_n_w;//sys_rst_n与locked相与后得到的中间变量,用于其他模块的复位
            //将该信号作为VGA驱动模块及显示模块的复位信号，可避免由于系统复位后像素时钟不稳定造成的VGA时序错误。
           
            wire [11:0] pixel_data;//用于接vga数据模块的输出
            wire [9:0] pixel_xpos;//像素点横坐标,10位够用了
            wire [9:0] pixel_ypos;//像素点纵坐标，10位够用了
            
            //Pll输出稳定后就停止复位
            assign rst_n_w =  sys_rst_n & locked;

            //pll核的实例化


            //vga驱动器的实例化


            //vga数据模块的实例化



/*


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

                */
endmodule


//vga驱动模块
module vga_driver(vga_clk,rst_n_w,pixel_data,pixel_xpos,pixel_ypos,vga_hs,vga_vs,vga_rgb);
    input  vga_clk,rst_n_w;//来自pll分频后的时钟以及与后的复位信号
    input [11:0] pixel_data;//来自vga显示模块的像素数据
    output vga_hs,vga_vs;//行同步和场同步信号
    output [9:0] pixel_xpos,pixel_ypos;//像素点横纵坐标
    output [11:0] vga_rgb;//输出像素数据给vga显示器

    //parameter define 
    parameter H_SYNC = 10'd96; //行同步
    parameter H_BACK = 10'd48; //行显示后沿
    parameter H_DISP = 10'd640; //行有效数据
    parameter H_FRONT = 10'd16; //行显示前沿
    parameter H_TOTAL = 10'd800; //行扫描周期
    parameter V_SYNC = 10'd2; //场同步
    parameter V_BACK = 10'd33; //场显示后沿
    parameter V_DISP = 10'd480; //场有效数据
    parameter V_FRONT = 10'd10; //场显示前沿
    parameter V_TOTAL = 10'd525; //场扫描周期

    //reg define 将行场计数器的值与VGA时序中的参数作比较，我们就可以判断行场同步信号何时处于低电平同步状态，以及何时输出RGB444格式的图像数据。
    //过行计数器cnt_h对像素时钟计数，计满一个行扫描周期后清零并重新开始计数。
    reg [9:0] cnt_h;
    //通过场计数器cnt_v对行进行计数，即扫描完一行后cnt_v加1，计满一个场扫描周期后清零并重新开始计数
    reg [9:0] cnt_v;

    //wire define
    wire vga_en;//数据输出使能信号
    wire data_req;//数据请求信号

    //VGA行场同步信号，都是低电平有效
    assign vga_hs = (cnt_h <= H_SYNC - 1'b1) ? 1'b0 : 1'b1;
    assign vga_vs = (cnt_v <= V_SYNC - 1'b1) ? 1'b0 : 1'b1;

    // RGB444数据输出使能信号
    assign vga_en = (((cnt_h >= H_SYNC+H_BACK) && (cnt_h < H_SYNC+H_BACK+H_DISP))
                    &&((cnt_v >= V_SYNC+V_BACK) && (cnt_v < V_SYNC+V_BACK+V_DISP)))
                    ? 1'b1 : 1'b0;


    
    //RGB444数据输出 
    assign vga_rgb = vga_en ? pixel_data : 16'd0;

    //像素点颜色数据输入请求信号     
    //由于坐标输出后下一个时钟周期才能接收到像素点的颜色数据，
    //因此数据请求信号data_req比数据输出使能信号vga_en提前一个时钟周期。
    assign data_req = (((cnt_h >= H_SYNC+H_BACK-1'b1) && (cnt_h < H_SYNC+H_BACK+H_DISP-1'b1))
                      && ((cnt_v >= V_SYNC+V_BACK) && (cnt_v < V_SYNC+V_BACK+V_DISP)))
                      ? 1'b1 : 1'b0;
    
    //输出当前像素点的纵横坐标值
    assign pixel_xpos = data_req ? (cnt_h - (H_SYNC + H_BACK - 1'b1)) : 10'd0;
    assign pixel_ypos = data_req ? (cnt_v - (V_SYNC + V_BACK - 1'b1)) : 10'd0;

    //行计数器对像素时钟计数
    always @(posedge vga_clk or negedge rst_n_w) begin 
        if (!sys_rst_n)
            cnt_h <= 10'd0; 
        else if(cnt_h == H_TOTAL - 1'b1) 
            cnt_h <= 10'd0; 
        else
            cnt_h <= cnt_h +1'b1;
    end

    //场计数器对像素时钟计数
    always @(posedge vga_clk or negedge rst_n_w) begin 
        if (!sys_rst_n)
            cnt_ <= 10'd0; 
        else if(cnt_h == H_TOTAL - 1'b1) begin
            if(cnt_v == V_TOTAL - 1'b1)
                cnt_v <= 10'd0;
            else cnt_v <= cnt_v + 1'b1;
        end
    end
endmodule

module vga_display (vga_clk,rst_n_w,switch,pixel_xpos,pixel_ypos,pixel_data);
input vga_clk,rst_n_w;
input [2:0] switch;//选择显示不同的图案
input [9:0] pixel_xpos,pixel_ypos;
output reg [11:0] pixel_data;

parameter H_DISP = 10'd640;//一行像素数
parameter V_DISP = 10'd480;//一列像素数

//至于颜色的设置，可以打开网上调色板，网上一般为24位RGB888，我们可以选择用每个颜色中的高4位
localparam White = 12'hFFF;//白色
localparam Green = 12'h0F0; //绿
localparam Red = 12'hF00;//红
localparam Blue = 12'h00F; //蓝
localparam Yellow = 12'hFF0; //黄
localparam Purple = 12'hC0F; //紫
localparam Light_Blue =12'h2EE; //浅蓝

reg [11:0] v_data, h_data;

 //根据当前像素点坐标指定当前像素点颜色数据，在屏幕上显示彩条

 //产生竖彩条
 always @(posedge vga_clk or negedge rst_n_w) begin 
    if (!rst_n_w)
         v_data <= 16'd0; 
    else begin
        if((pixel_xpos >= 0) && (pixel_xpos < (H_DISP/6)*1)) 
            v_data <= Green; 
        else if((pixel_xpos >= (H_DISP/6)*1) && (pixel_xpos < (H_DISP/6)*2))
            v_data <= Red; 
        else if((pixel_xpos >= (H_DISP/6)*2) && (pixel_xpos < (H_DISP/6)*3))
            v_data <= Blue; 
        else if((pixel_xpos >= (H_DISP/6)*3) && (pixel_xpos < (H_DISP/6)*4))
            v_data <= Yellow; 
        else if((pixel_xpos >= (H_DISP/6)*4) && (pixel_xpos < (H_DISP/6)*5))
            v_data <= Purple; 
        else 
            v_data <= Light_Blue;
        
    end
 end


//产生横彩条
 always @(posedge vga_clk or negedge rst_n_w) begin 
    if (!rst_n_w)
        h_data <= 16'd0; 
    else begin
        if((pixel_ypos >= 0) && (pixel_ypos < (H_DISP/6)*1)) 
            h_data <= Green; 
        else if((pixel_ypos >= (H_DISP/6)*1) && (pixel_ypos < (H_DISP/6)*2))
            h_data <= Red; 
        else if((pixel_ypos >= (H_DISP/6)*2) && (pixel_ypos < (H_DISP/6)*3))
            h_data <= Blue; 
        else if((pixel_ypos >= (H_DISP/6)*3) && (pixel_ypos < (H_DISP/6)*4))
            h_data <= Yellow; 
        else if((pixel_ypos >= (H_DISP/6)*4) && (pixel_ypos < (H_DISP/6)*5))
            h_data <= Purple; 
        else 
            h_data <= Light_Blue;
        
    end
 end

always @(posedge vga_clk)begin
    case(switch[2:0])
        3'd0: pixel_data <= h_dat; //选择横彩条
        3'd1: pixel_data <= v_dat; //选择竖彩条
        3'd2: pixel_data <= (v_dat ^ h_dat); //产生棋盘格异或
        3'd3: pixel_data <= (v_dat ~^ h_dat); //产生棋盘格同或
        default: pixel_data <= 12'h0000;
    endcase
end
    
endmodule