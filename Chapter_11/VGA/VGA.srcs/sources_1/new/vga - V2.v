`timescale 1ns / 1ps

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

            //pll IP核的实例化

            vga_pll u_pll
            (
            // Clock out ports
            .clk_out1(vga_clk),     // output clk_out1
            // Status and control signals
            .resetn(sys_rst_n), // input resetn
            .locked(locked),       // output locked
            // Clock in ports
            .clk_in1(sys_clk));      // input clk_in1


            //vga_driver驱动器的实例化
            vga_driver u_vga_driver(
                    .vga_clk(vga_clk),
                    .rst_n_w(rst_n_w),
                    .pixel_data(pixel_data),
                    .pixel_xpos(pixel_xpos),
                    .pixel_ypos(pixel_ypos),
                    .vga_hs(vga_hs),
                    .vga_vs(vga_vs),
                    .vga_rgb(vga_rgb));

            //vga_display模块的实例化

            vga_display u_vga_display(
                    .vga_clk(vga_clk),
                    .rst_n_w(rst_n_w),
                    .switch(switch),
                    .pixel_xpos(pixel_xpos),
                    .pixel_ypos(pixel_ypos),
                    .pixel_data(pixel_data));

            ila_0 u_ila_0 (
                    .clk(vga_clk), // input wire clk


                    .probe0(u_vga_display.rom_rd_en), // input wire [0:0]  probe0  
                    .probe1(u_vga_display.rom_valid), // input wire [0:0]  probe1 
                    .probe2(u_vga_display.rom_addr), // input wire [18:0]  probe2 
                    .probe3(u_vga_display.rom_data), // input wire [23:0]  probe3 
                    .probe4(pixel_data), // input wire [11:0]  probe4
                    .probe5(pixel_xpos), 
                    .probe6(pixel_ypos) 

                );

  
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
    assign data_req = (((cnt_h >= H_SYNC + H_BACK-1'b1) && (cnt_h < H_SYNC + H_BACK + H_DISP-1'b1))
                      && ((cnt_v >= V_SYNC + V_BACK) && (cnt_v < V_SYNC + V_BACK + V_DISP)))
                      ? 1'b1 : 1'b0;
    
    //输出当前像素点的纵横坐标值
    assign pixel_xpos = data_req ? (cnt_h - (H_SYNC + H_BACK - 1'b1)) : 10'd0;
    assign pixel_ypos = data_req ? (cnt_v - (V_SYNC + V_BACK - 1'b1)) : 10'd0;

    //行计数器对像素时钟计数
    always @(posedge vga_clk or negedge rst_n_w) begin 
        if (!rst_n_w)
            cnt_h <= 10'd0; 
        else if(cnt_h == H_TOTAL - 1'b1) 
            cnt_h <= 10'd0; 
        else
            cnt_h <= cnt_h +1'b1;
    end

    //场计数器对像素时钟计数
    always @(posedge vga_clk or negedge rst_n_w) begin 
        if (!rst_n_w)
            cnt_v <= 10'd0; 
        else if(cnt_h == H_TOTAL - 1'b1) begin
            if(cnt_v == V_TOTAL - 1'b1)
                cnt_v <= 10'd0;
            else cnt_v <= cnt_v + 1'b1;
        end
    end
endmodule










//vga_display模块
module vga_display (vga_clk,rst_n_w,switch,pixel_xpos,pixel_ypos,pixel_data);
input vga_clk,rst_n_w;
input [2:0] switch;//选择显示不同的图案
input [9:0] pixel_xpos,pixel_ypos;
output reg [11:0] pixel_data;

parameter H_DISP = 10'd640;//一行像素数
parameter V_DISP = 10'd480;//一列像素数

//至于颜色的设置，可以打开网上调色板，网上一般为24位RGB888，我们可以选择用每个颜色中的高4位
localparam White      = 12'hFFF;//白色
localparam Green      = 12'h0F0; //绿
localparam Red        = 12'hF00;//红
localparam Blue       = 12'h00F; //蓝
localparam Yellow     = 12'hFF0; //黄
localparam Purple     = 12'hC0F; //紫
localparam Light_Blue = 12'h2EE; //浅蓝
localparam Black      = 12'h000;//黑色

reg [11:0] v_data, h_data;//控制彩条数据的

always @(posedge vga_clk) begin
    case(switch[2:0])
        3'd0: pixel_data <= v_data; //选择竖彩条
        3'd1: pixel_data <= h_data; //选择横彩条
        3'd2: pixel_data <= (v_data ^ h_data); //产生棋盘格异或
        3'd3: pixel_data <= (v_data ~^ h_data); //产生棋盘格同或
        3'd4: pixel_data <= char_data;//选择显示字符
        3'd5: pixel_data <= pic_data;//选择显示图片
        default: pixel_data <= White;//其他显示纯白
    endcase
end



 //产生竖彩条
 always @(posedge vga_clk or negedge rst_n_w) begin 
    if (!rst_n_w)
         v_data <= 12'd0; 
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
        h_data <= 12'd0; 
    else begin
        if((pixel_ypos >= 0) && (pixel_ypos < (V_DISP/6)*1)) 
            h_data <= Green; 
        else if((pixel_ypos >= (V_DISP/6)*1) && (pixel_ypos < (V_DISP/6)*2))
            h_data <= Red; 
        else if((pixel_ypos >= (V_DISP/6)*2) && (pixel_ypos < (V_DISP/6)*3))
            h_data <= Blue; 
        else if((pixel_ypos >= (V_DISP/6)*3) && (pixel_ypos < (V_DISP/6)*4))
            h_data <= Yellow; 
        else if((pixel_ypos >= (V_DISP/6)*4) && (pixel_ypos < (V_DISP/6)*5))
            h_data <= Purple; 
        else 
            h_data <= Light_Blue;
    end
 end


/*下面代码用于在显示器上显示字符，显示字符其实和现实图片原理类似，但是更简单,
因为驱魔软件此时只区分白色和其他颜色，白色就是0，其他颜色就是1
为了方便在VGA上显示，我们将所有要显示的汉字看作一个整体，从而获得一个“大字模”
为了简化字符设计，将多个字符合在一起成一张bmp图像再处理成字模文件，而且字也不大
一个字占用16*16的像素，一个四个字，所以一共宽度是64，高度是16*/

localparam POS_X = 10'd288;//字符区域起始点横坐标 
localparam POS_Y = 10'd232;//字符区域起始点横坐标 

localparam WIDTH = 10'd64;//字符区域宽度
localparam HEIGHT = 10'd16;//字符区域高度

reg [63:0] char [15:0];//用存储期类型形式存储字符，类似二维数组

//为了利用上字符存储器，需要定义变量计算像素点相对于字符区域起始点坐标
wire [9:0] x_cnt;
wire [9:0] y_cnt;

assign x_cnt = pixel_xpos - POS_X; //像素点相对于字符区域起始点水平坐标
assign y_cnt = pixel_ypos - POS_Y; //像素点相对于字符区域起始点竖直坐标

//给字符数组赋值取模后的值,为了简单可以直接用excel写这段代码，或者用C语言或者matlab循环语句写
always @(posedge vga_clk) begin
    char[0]         <=  64'h    0000066001801830;
    char[1]         <=  64'h    FFFF066001801830;
    char[2]         <=  64'h    0660066001801830;
    char[3]         <=  64'h    066006667FFE1830;
    char[4]         <=  64'h    0660066C6306FFFF;
    char[5]         <=  64'h    3FFC7E78C30C1830;
    char[6]         <=  64'h    366C067007803878;
    char[7]         <=  64'h    366C0660078C3C78;
    char[8]         <=  64'h    366C06600CD87EFC;
    char[9]         <=  64'h    366C06601CF078FC;
    char[10]        <=  64'h    3C3C06603C60D9B6;
    char[11]        <=  64'h    380C06636C301B33;
    char[12]        <=  64'h    300C1E63CC181E30;
    char[13]        <=  64'h    300CF6630F0C1830;
    char[14]        <=  64'h    3FFC663F0E071830;
    char[15]        <=  64'h    300C06000C001830;  //西北农林bmp生成的字模
end

reg [11:0] char_data;
 //给不同的区域绘制不同的颜色
 always @(posedge vga_clk or negedge rst_n_w) begin 
    if (!rst_n_w)
        char_data <= White;
    else begin
        if((pixel_xpos >= POS_X) && (pixel_xpos < POS_X + WIDTH)
            && (pixel_ypos >= POS_Y) && (pixel_ypos < POS_Y + HEIGHT)) 
            begin
                if(char[y_cnt][10'd63 - x_cnt])//y_cnt行，（63 - x_cnt)列,此处值为1说明是有文字位置
                    char_data <= Red; //绘制字符为红色
                else
                    char_data <= Yellow; //绘制字符区域背景为黄色 
            end
        else
            char_data <= Black; //绘制屏幕背景为黑色
    end
 end
    
/****************下面代码是显示图片功能设计*****************************/
/*在“VGA字符显示实验”中利用一个二维数组存储字符的点阵数据，进而实现汉字的
显示。字符显示时每个像素点采用二维数组中的1位（bit）数据来表示，只有0和1的差别，即
只能区分两种颜色。然而在显示图片时，由于1bit的数据无法区分各像素点的色彩差异，因此
二维数组已经不能满足图片存储的需要。本章我们将通过例化IP核来实现使用ROM存储图片，
并将ROM中存储的图片通过VGA接口显示到屏幕上。*/
localparam Pic_Pos_X = 10'd0;//图片显示起始横坐标
localparam Pic_Pos_Y = 10'd0;//图片显示起始纵坐标
localparam Pic_Width = 10'd640; //图片宽度
localparam Pic_Height= 10'd480; //图片高度
localparam Pix_Total = Pic_Width*Pic_Height;//总像素数640*480

wire        rom_rd_en;//读ROM使能信号
reg  [18:0] rom_addr;//存下像素总数需要19位
reg         rom_valid;//读ROM数据有效信号

wire [11:0] rom_data; //rom输出数据
wire [11:0] pic_data;

//从ROM中读出的图像数据有效时，将其输出显示
assign pic_data = rom_valid ? rom_data : Black;
//assign pic_data = rom_valid ? Yellow : Black;

//当前像素点坐标位于图片显示区域内时，读ROM使能信号拉高
assign rom_rd_en = (pixel_xpos >= Pic_Pos_X) && (pixel_xpos < Pic_Pos_X + Pic_Width)
                     && (pixel_ypos >= Pic_Pos_Y) && (pixel_ypos < Pic_Pos_Y + Pic_Height)
                     ? 1'b1 : 1'b0;

//控制读地址
always @(posedge vga_clk or negedge rst_n_w) begin 
    if (!rst_n_w) 
        rom_addr <= 19'd0;
    else if(rom_addr == Pix_Total-1'b1)
        rom_addr <= 19'd0; //读到ROM末地址后，从首地址重新开始读操作
    else if(rom_rd_en) 
        rom_addr <= rom_addr + 1'b1; //每次读ROM操作后，读地址加1
    else
       rom_addr <= rom_addr;
end

//控制读地址
/*always @(posedge vga_clk or negedge rst_n_w) begin 
    if (!rst_n_w) 
        rom_addr <= 19'd0;
    else if(rom_rd_en) begin
        if(rom_addr < Pix_Total - 1'b1)
            rom_addr <= rom_addr + 1'b1; //每次读ROM操作后，读地址加1
        else
        rom_addr <= 19'd0; //读到ROM末地址后，从首地址重新开始读操作
    end
    else
        rom_addr <= rom_addr;
end*/

//从发出读使能到ROM输出有效数据存在一个时钟周期的延时
always @(posedge vga_clk or negedge rst_n_w) begin 
    if (!rst_n_w)
        rom_valid <= 1'b0;
    else
        rom_valid <= rom_rd_en;
end

pic_ROM u_pic_ROM(
  .clka(vga_clk),    // input wire clka
  .ena(rom_rd_en),      // input wire ena
  .addra(rom_addr),  // input wire [18 : 0] addra
  .douta(rom_data)  // output wire [11 : 0] douta
);


endmodule