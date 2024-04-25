/******************************************************************************
*
*  Authors:   Chengyi Zhang
*     Date:   2023/4/20
*   Method:   
*  Version:   
*  Content:  
* 
******************************************************************************/

module tb_conv_acc;
    reg                                 i_clk                      ;
    reg                                 i_rst                      ;

    reg                                 i_pre_valid                ;
    wire                                o_pre_ready                ;
    reg                                 i_post_ready               ;
    wire                                o_post_valid               ;
    
    wire          [ 31:  0]             o_res         [9:0]        ;    

top_conv_acc u_top_conv_acc(
    .i_clk                              (i_clk                     ),
    .i_rst                              (i_rst                     ),
    .i_pre_valid                        (i_pre_valid               ),
    .o_pre_ready                        (o_pre_ready               ),
    .o_post_valid                       (o_post_valid              ),
    .i_post_ready                       (i_post_ready              ),
    .o_res                              (o_res                     ) 
);

integer fp;

always #5 i_clk = ~i_clk;

initial begin
    i_clk = 0;  i_rst = 0; i_pre_valid = 0; i_post_ready = 0;   #5  
                i_rst = 1;                                      #15 
                i_rst = 0; i_pre_valid = 1; i_post_ready = 1;
end

initial begin
//    i_conv_bias = 15;
//    for (i = 0; i < 28; i++) begin
//        for (j = 0; j < 28; j++) begin
//            i_data[i][j] = j;
//        end
//    end
 
    
//    for (i = 0; i < 9; i++) begin
//        i_conv_weight[i] = i;
//    end

//    fp = $fopen("E:/Vivadoproj/PKUCourse/conv_acc/tb/conv_weight.txt", "r");
//    for (int i = 0; i < 9; i++) begin
//        integer temp;
//        $fscanf(fp, "%d", temp);
//        i_conv_weight[i] = temp;
//    end
    
//    for (int i = 0; i < 676; i++) begin
//        for (int j = 0; j < 10; j++) begin
//            i_fc_weight[i][j] = i + 1;
//        end
//    end

//    fp = $fopen("E:/Vivadoproj/PKUCourse/conv_acc/tb/fc_weight.txt", "r");
//    for (int i = 0; i < 676; i++) begin
//        for (int j = 0; j < 10; j++) begin
//            integer temp;
//            $fscanf(fp, "%d", temp);
//            i_fc_weight[i][j] = temp;
//        end
//    end

//    for (int i = 0; i < 10; i++) begin
//        i_fc_bias[i] = i;
//    end

//    fp = $fopen("E:/Vivadoproj/PKUCourse/conv_acc/tb/fc_bias.txt", "r");
//    for (int i = 0; i < 10; i++) begin
//        integer temp;
//        $fscanf(fp, "%d", temp);
//        i_fc_bias[i] = temp;
//    end

    #1000
    $finish;
end


endmodule