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
// �����������ƺ��������̸���Ƭ��ͨ�����뿪�ؿ��ƾ�����ʾ��һ��
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


  module vga( sys_clk, sys_rst_n, disp_RGB, hsync, vsync );

            input sys_clk; //ϵͳ����ʱ�� 100MHz
            //input [1:0]switch;//����
            input sys_rst_n;
            output [11:0] disp_RGB; //VGA ���������RGB 4:4:4
            output hsync; //VGA ��ͬ���ź�
            output vsync; //VGA ��ͬ���ź�

            reg [9:0] hcount; //VGA ��ɨ�������
            reg [9:0] vcount; //VGA ��ɨ�������
            reg [11:0] data;
            reg [11:0] h_dat;
            reg [11:0] v_dat;
            reg flag;
            wire hcount_ov;
            wire vcount_ov;
            wire dat_act;

            wire vga_clk_w;//ʹ��PLL IP��sys_clk��Ƶ������
            wire locked_w;//IP���������ʾPLL����ȶ�
            
            wire rst_n_w;//sys_rst_n��locked�����õ����м����
                        //��������ģ��ĸ�λ
            wire [11:0] pixel_data_w;
            


            //VGA �С���ɨ��ʱ�������
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
  //************************VGA ��������*******************************//��ɨ��
            always @(posedge vga_clk)
            begin
                if (hcount_ov)
                    hcount <= 10'd0;
                 else
                    hcount <= hcount + 10'd1;
            end
            assign hcount_ov = (hcount == hpixel_end);

            //��ɨ��
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

            //���ݡ�ͬ���ź���
            assign dat_act = ((hcount >= hdat_begin) && (hcount < hdat_end))
&& ((vcount >= vdat_begin) && (vcount < vdat_end));
            assign hsync = (hcount > hsync_end);
            assign vsync = (vcount > vsync_end);
            assign disp_RGB = (dat_act) ? data : 12'h000;

            always @(posedge vga_clk)
            begin
                case(switch[1:0])
                    2'd0: data <= h_dat; //ѡ������
                    2'd1: data <= v_dat; //ѡ��������
                    2'd2: data <= (v_dat ^ h_dat); //�������̸�
                    2'd3: data <= (v_dat ~^ h_dat); //�������̸�
                endcase
            end
//������ɫ�����ã����Դ����ϵ�ɫ�壬����һ��Ϊ24λRGB888�����ǿ���ѡ����ÿ����ɫ�еĸ�4λ
            always @(posedge vga_clk) //����������
            begin
                if(hcount < 223)
                    v_dat <= 12'hF00; //��
                else if(hcount < 303) 
                    v_dat <= 12'h0F0; //��
                else if(hcount < 383)
                    v_dat <= 12'h00F; //��
                else if(hcount < 463)
                    v_dat <= 12'hFFF; //��
                else if(hcount < 543)
                    v_dat <= 12'hFF0; //��
                else if(hcount < 623)
                    v_dat <= 12'hC0F; //��
                else if(hcount < 703)
                    v_dat <= 12'h2EE; //ǳ��
                else
                    v_dat <= 12'hFFF; //��ɫ
            end

            always @(posedge vga_clk) //���������
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
