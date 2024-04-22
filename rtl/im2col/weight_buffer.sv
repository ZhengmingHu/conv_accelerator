module fc_weight_buffer (
    input                               i_clk                      ,
    input                               i_rst                      ,

    input   [   1: 0]                   i_addr                     ,
    input   [   7: 0]                   i_weight [ 9: 0]  [  8: 0] ,
    output  [   7: 0]                   o_weight [ 9: 0]  [  2: 0]
);

logic   [   7: 0]   weight_r    [   9: 0][   8: 0];

generate
    for (genvar i = 0; i < 10; i++) begin
        for (genvar j = 0; j < 9; j++) begin
        lib_reg#(
    .WIDTH                              (8                         ),
    .RESET_VAL                          (0                         ) 
        ) u_entry (
    .clk                                (i_clk                     ),
    .rst                                (i_rst                     ),
    .din                                (i_weight[i][j]            ),
    .dout                               (weight_r[i][j]            ),
    .wen                                (1'b1                      ) 
        );
        end
    end
endgenerate

generate
    for (genvar i = 0; i < 10; i++) begin
        for (genvar j = 0; j < 3; j++) begin
            assign o_weight[i][j] = weight_r[i][i_addr*3+j];
        end
    end
endgenerate


endmodule