`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/28 12:18:31
// Design Name: 
// Module Name: data_picture
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


module data_picture(
     input  wire sys_clk,//Ҫ�̶���ʱ��
     input  wire rst_n,
     input  wire [23:0] lcd_addr,//���ݵĵ�ַ
     input  wire [10:0] screen_x,//��Ļ�ĺ�����
     input  wire [10:0] screen_y,//��Ļ��������
     input  wire [10:0] poy_x,//ͼƬ����ʼ������
     input  wire [10:0] poy_y,//ͼƬ����ʼ������
     input  wire [23:0] picture_data_in,//��rom�з�����������
     output wire [23:0]picture_data,//��Ҫ��ʾ������
     output reg [31:0]rom_addr      //rom�ĵ�ַ
    );

//.....................................ͼƬ��Ϣ..................................//
parameter piex_x=355;//ͼƬ�Ŀ�
parameter piex_y=200;//ͼƬ�ĸ�


//..............................��ӦͼƬ������...............................//
//.................................RGB888 TO YCbCr........................//
//wire [23:0]rom_temp_data2;
//assign rom_temp_data2=picture_data_in;

reg [23:0] rom_temp_data1;
reg [23:0] rom_temp_data2;
always@(posedge sys_clk or negedge rst_n)begin
     if(!rst_n)begin         
          rom_temp_data1[23:0]<=24'b0;
          rom_temp_data2[23:0]<=24'b0;
     end
     else begin
          rom_temp_data1[23:0]<=(77*picture_data_in[7:0]+150*picture_data_in[15:8]+29*picture_data_in[23:16]);//RGB888 TO YCbCr
          rom_temp_data2[23:0]<={rom_temp_data1[15:8],rom_temp_data1[15:8],rom_temp_data1[15:8]};
     end
end

assign picture_data[23:0] = ((screen_y>=poy_y)&&(screen_y<piex_y+poy_y-1)&&(screen_x<piex_x+poy_x-1)&&(screen_x>=poy_x)) ? rom_temp_data2[23:0] : 24'b00000000_11111111_00000000;
always@(posedge sys_clk or negedge rst_n)begin
     if(!rst_n)begin         
          rom_addr[31:0]<=17'b0;
     end
     else if((screen_y>=poy_y)&&(screen_y<(piex_y+poy_y-1))&&(screen_x<(piex_x+poy_x-1))&&(screen_x>=poy_x))begin 
          rom_addr[31:0]<=(screen_y-poy_y)*(piex_x-1)+(screen_x-poy_x+200);     
     end
     else if(screen_y==0)begin
          rom_addr[31:0]<=17'b0;
     end
end


    
endmodule
