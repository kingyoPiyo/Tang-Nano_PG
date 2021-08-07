/*****************************************************************
* Title     : Period counter
* Date      : 2021/08/07
* Design    : kingyo (https://github.com/kingyoPiyo)
******************************************************************/
module period_counter (
    input   wire            i_clk,
    input   wire            i_res_n,
    input   wire    [23:0]  i_period,
    output  reg     [23:0]  o_cnt
);

    wire    w_top_en = (o_cnt == i_period);
    always @(posedge i_clk or negedge i_res_n) begin
        if (~i_res_n) begin
            o_cnt <= 24'd0;
        end else begin
            if (w_top_en) begin
                o_cnt <= 24'd0;
            end else begin
                o_cnt <= o_cnt + 24'd1;
            end
        end
    end

endmodule
