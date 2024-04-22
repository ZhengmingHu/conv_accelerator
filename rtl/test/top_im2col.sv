module top_im2col (
    input                               i_clk                      ,
    input                               i_rst                      ,

    input                               i_pre_valid                ,    // TODO: handshake
    output                              o_pre_ready                ,
    output                              o_post_valid               ,
    input                               i_post_ready               ,

    input                [   7: 0]      i_data [ 27: 0]  [ 27: 0]  ,
    output               [   7: 0]      o_data [ 25: 0]  [  8: 0]  

);

logic               img_buffer_valid                ;
logic               im2col_ready                    ;  
logic   [   4:  0]  addr                            ;
logic   [   7:  0]  data    [   2:  0] [   27:  0]  ;

img_buffer u_img_buffer (
    .i_clk                              (i_clk                     ),
    .i_rst                              (i_rst                     ),
    .i_pre_valid                        (i_pre_valid               ),
    .o_pre_ready                        (o_pre_ready               ),
    .o_post_valid                       (img_buffer_valid          ),
    .i_post_ready                       (im2col_ready              ),
    .i_addr                             (addr                      ),
    .i_data                             (i_data                    ),
    .o_data                             (data                      ) 
);

im2col u_im2col(
    .i_clk                              (i_clk                     ),
    .i_rst                              (i_rst                     ),
    .i_pre_valid                        (img_buffer_valid          ),
    .o_pre_ready                        (im2col_ready              ),
    .o_post_valid                       (o_post_valid              ),
    .i_post_ready                       (i_post_ready              ),
    .i_data                             (data                      ),
    .o_addr                             (addr                      ),
    .o_data                             (o_data                    ) 
);



endmodule