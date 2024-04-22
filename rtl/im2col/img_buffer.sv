module img_buffer (
    input                               i_clk                      ,
    input                               i_rst                      ,

    input                               i_pre_valid                ,    // TODO: handshake
    output                              o_pre_ready                ,
    output                              o_post_valid               ,
    input                               i_post_ready               ,

    input   [   4: 0]                   i_addr                     ,
    input   [   7: 0]                   i_data [ 27: 0]  [ 27: 0]  ,
    output  [   7: 0]                   o_data [  2: 0]  [ 27: 0]
);

// 1. shake hands to reg pre/post stage signals://///////////////////////////////////////////////////////////

// i_pre_valid --> ⌈‾‾‾‾⌉ --> o_post_valid
//                 |REG|
// o_pre_ready <-- ⌊____⌋ <-- i_post_ready

wire pre_fire  = i_pre_valid & o_pre_ready;
wire post_fire = o_post_valid & i_post_ready;
wire done      = i_addr == 25;
logic             start_r;

always @(posedge i_clk) begin
    if (i_rst) begin
        start_r <= 1'b1;
    end else if (pre_fire) begin
        start_r <= 1'b0;
    end
end

assign o_pre_ready =  ((o_post_valid & i_post_ready | !o_post_valid) & done) | start_r;


lib_reg #(
    .WIDTH                              (1                         ),
    .RESET_VAL                          (0                         ) 
  ) postvalid (
    .clk                                (i_clk                     ),
    .rst                                (i_rst                     ),
    .wen                                (o_pre_ready               ),
    .din                                (i_pre_valid               ),
    .dout                               (o_post_valid              ) 
  );


// 2. image reg //////////////////////////////////////////////////

logic   [   7: 0]   image_r [  27: 0] [   27: 0];

integer i, j, k, l, m, n;


generate 
    for (genvar i = 0; i < 28; i++) begin
        for (genvar j = 0; j < 28; j++) begin
            lib_reg#(
                .WIDTH(8),
                .RESET_VAL(8'b0)
            ) u_img_reg(
                .clk                                (i_clk                     ),
                .rst                                (i_rst                     ),
                .din                                (i_data[i][j]              ),
                .dout                               (image_r[i][j]             ),
                .wen                                (pre_fire                  ) 
            );
        end
    end
endgenerate

generate
    for (genvar i = 0; i < 3; i++) begin
        for (genvar j = 0; j < 28; j++) begin
            assign o_data[i][j] = image_r[i_addr + i][j];
        end
    end
endgenerate

endmodule