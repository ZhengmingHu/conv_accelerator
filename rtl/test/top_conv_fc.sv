/******************************************************************************
*
*  Authors:   Chengyi Zhang
*     Date:   2023/4/20
*   Method:   
*  Version:   
*  Content:  
* 
******************************************************************************/

module top_conv_fc (
    input                               i_clk                      ,
    input                               i_rst                      ,

    input                               i_pre_valid                ,
    output                              o_pre_ready                ,
    output                              o_post_valid               ,
    input                               i_post_ready               ,

    input           [  7:  0]           i_conv_kernel [25:0][8:0]  ,
    input           [  7:  0]           i_conv_weight [0:0][8:0]   ,
    input           [  7:  0]           i_conv_bias                ,      
    input           [  7:  0]           i_fc_weight   [9:0][675:0] ,
    output          [ 31:  0]           o_res         [9:0]                      
);

wire post_fire = o_post_valid & i_post_ready;

logic  [    15: 0]  conv_res         [0:0][25:0];
logic               conv_valid                  ;
logic  [     7: 0]  conv_bias_extend [0:0]      ;

logic  [    15: 0]  fc_weight_extend [9:0][25:0];
logic  [     4: 0]  fc_weight_addr              ;
logic               fc_ready                    ;
logic  [    15: 0]  fc_bias_extend   [9:0]      ;
logic  [    31: 0]  fc_res           [9:0][0:0] ;     

assign conv_bias_extend[0] = i_conv_bias; 
generate 
    for (genvar i = 0; i < 10; i++) begin
        assign o_res[i] = fc_res[i][0];
        assign fc_bias_extend[i] = 0; 
        for (genvar j = 0; j < 26; j++) begin
            assign fc_weight_extend[i][j] = {8'b0, {i_fc_weight[i][26*fc_weight_addr+j]}};
        end
    end
endgenerate

always @ (posedge i_clk) begin
    if (i_rst) begin
        fc_weight_addr <= 0;
    end else if (conv_valid & fc_ready) begin
        if (fc_weight_addr == 25)
            fc_weight_addr <= 0;
        else 
            fc_weight_addr <= fc_weight_addr + 1;
    end 
end

matu#(
    .INA_ROWS                           (26                        ),
    .INA_COLS                           (9                         ),
    .INB_ROWS                           (1                         ),
    .INB_COLS                           (9                         ),
    .SA_ROWS                            (26                        ),
    .SA_COLS                            (1                         ),
    .IN_WIDTH                           (8                         ),
    .C_WIDTH                            (16                        ) 
) u_conv(
    .i_clk                              (i_clk                     ),
    .i_rst                              (i_rst                     ),
    .i_pre_valid                        (i_pre_valid               ),
    .o_pre_ready                        (o_pre_ready               ),
    .i_post_ready                       (fc_ready                  ),
    .o_post_valid                       (conv_valid                ),
    .i_a                                (i_conv_kernel             ),
    .i_b                                (i_conv_weight             ),
    .i_d                                (conv_bias_extend          ),
    .o_c                                (conv_res                  ) 
);

matu#(
    .INA_ROWS                           (1                         ),
    .INA_COLS                           (26                        ),
    .INB_ROWS                           (10                        ),
    .INB_COLS                           (26                        ),
    .SA_ROWS                            (1                         ),
    .SA_COLS                            (10                        ),
    .IN_WIDTH                           (16                        ),
    .C_WIDTH                            (32                        ) 
) u_fc (
    .i_clk                              (i_clk                     ),
    .i_rst                              (i_rst                     ),
    .i_pre_valid                        (conv_valid                ),
    .o_pre_ready                        (fc_ready                  ),
    .i_post_ready                       (i_post_ready              ),
    .o_post_valid                       (o_post_valid              ),
    .i_a                                (conv_res                  ),
    .i_b                                (fc_weight_extend          ),
    .i_d                                (fc_bias_extend            ),
    .o_c                                (fc_res                    ) 
);

endmodule