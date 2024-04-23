/******************************************************************************
*
*  Authors:   Chengyi Zhang
*     Date:   2023/4/20
*   Method:   
*  Version:   
*  Content:  
* 
******************************************************************************/

module top_conv_acc (
    input                               i_clk                      ,
    input                               i_rst                      ,

    input                               i_pre_valid                ,
    output                              o_pre_ready                ,
    output                              o_post_valid               ,
    input                               i_post_ready               ,

    input                [   7: 0]      i_data        [27:0][27:0] ,
    input                [   7: 0]      i_conv_weight [0:0][8:0]   ,
    input                [   7: 0]      i_conv_bias                ,
    input                [   7: 0]      i_fc_weight   [9:0][675:0] , 
    output               [  31: 0]      o_res         [9:0]
);

logic               im2col_valid                      ;
logic               im2col_ready                      ;
logic   [   7: 0]   im2col_data     [  25: 0][   8: 0];

logic               convfc_valid                      ;
logic               convfc_ready                      ;
logic   [  31: 0]   convfc_res      [   9: 0]         ;     



top_im2col u_top_im2col(
    .i_clk                              (i_clk                     ),
    .i_rst                              (i_rst                     ),
    .i_pre_valid                        (i_pre_valid               ),
    .o_pre_ready                        (o_pre_ready               ),
    .o_post_valid                       (im2col_valid              ),
    .i_post_ready                       (im2col_ready              ),
    .i_data                             (i_data                    ),
    .o_data                             (im2col_data               ) 
);

top_conv_fc u_top_conv_fc(
    .i_clk                              (i_clk                     ),
    .i_rst                              (i_rst                     ),
    .i_pre_valid                        (im2col_valid              ),
    .o_pre_ready                        (im2col_ready              ),
    .o_post_valid                       (convfc_valid              ),
    .i_post_ready                       (convfc_ready              ),
    .i_conv_kernel                      (im2col_data               ),
    .i_conv_weight                      (i_conv_weight             ),
    .i_conv_bias                        (i_conv_bias               ),
    .i_fc_weight                        (i_fc_weight               ),
    .o_res                              (convfc_res               ) 
);

acc_reg u_acc_reg(
    .i_clk                              (i_clk                     ),
    .i_rst                              (i_rst                     ),
    .i_pre_valid                        (convfc_valid              ),
    .o_pre_ready                        (convfc_ready              ),
    .o_post_valid                       (o_post_valid              ),
    .i_post_ready                       (i_post_ready              ),
    .i_res                              (convfc_res               ),
    .o_res                              (o_res                     ) 
);




endmodule 