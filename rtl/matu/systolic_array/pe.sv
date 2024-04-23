/******************************************************************************
*
*  Authors:   Chengyi Zhang
*     Date:   2023/4/20
*   Method:   
*  Version:   
*  Content:  
* 
******************************************************************************/

module pe # (IN_WIDTH=8, C_WIDTH=16) (
    input                               i_clk                      ,
    input                               i_rst                      ,

    input                               i_ctrl_sa_send_data        ,
    input              [IN_WIDTH-1: 0]  i_a                        ,
    input              [IN_WIDTH-1: 0]  i_b                        ,
    input              [C_WIDTH-1: 0]   i_c                        ,
    input              [IN_WIDTH-1: 0]  i_d                        ,

    output                              o_ctrl_sa_send_data        ,
    output             [IN_WIDTH-1: 0]  o_a                        ,
    output             [IN_WIDTH-1: 0]  o_b                        ,
    output             [C_WIDTH-1: 0]   o_c                        ,
    output             [IN_WIDTH-1: 0]  o_d
);

logic [ 2*IN_WIDTH-1: 0] i_data, data_r;
logic [   IN_WIDTH-1: 0] a_r, b_r, d_r;
logic [    C_WIDTH-1: 0] c_r     ;

assign i_data = {i_a, i_b};

lib_reg#(
    .WIDTH                              (2*IN_WIDTH                ),
    .RESET_VAL                          (0                         ) 
) u_pe (
    .clk                                (i_clk                     ),
    .rst                                (i_rst                     ),
    .din                                (i_data                    ),
    .dout                               (data_r                    ),
    .wen                                (1'b1                      ) 
);

assign {a_r, b_r} = data_r;

always @ (posedge i_clk) begin
    if (i_rst) begin
        d_r <= 0;
    end else if (i_ctrl_sa_send_data) begin
        d_r <= 0;
    end else begin
        d_r <= i_d;
    end
end

logic [ C_WIDTH-1: 0] mac_c;

always @ (posedge i_clk) begin
    if (i_rst) begin
        c_r <= 0;
    end else if (i_ctrl_sa_send_data) begin
        c_r <= i_c;
    end else begin
        c_r <= mac_c;
    end
end

mac #(IN_WIDTH, C_WIDTH) u_mac(i_a, i_b, c_r, mac_c);

assign o_a = a_r;
assign o_b = b_r;
assign o_c = c_r + d_r;
assign o_d = d_r;
assign o_ctrl_sa_send_data = i_ctrl_sa_send_data;

endmodule

module mac # (IN_WIDTH=8, C_WIDTH=16) (
    input              [   IN_WIDTH-1: 0]        i_a                        ,
    input              [   IN_WIDTH-1: 0]        i_b                        ,
    input              [  C_WIDTH-1: 0]          i_c                        ,
    output             [  C_WIDTH-1: 0]          o_c                         
);

assign o_c = i_a * i_b + i_c;

endmodule