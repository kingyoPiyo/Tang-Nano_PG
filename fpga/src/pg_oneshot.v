/*****************************************************************
* Title     : one-shot pulse generator
* Date      : 2021/08/07
* Design    : kingyo (https://github.com/kingyoPiyo)
******************************************************************/
module pg_oneshot (
    input   wire            i_clk,
    input   wire            i_res_n,
    input   wire    [23:0]  i_cnt,
    input   wire    [23:0]  i_st,
    input   wire    [23:0]  i_end,
    output  reg             o_pulse
);

    always @(posedge i_clk or negedge i_res_n) begin
        if (~i_res_n) begin
            o_pulse <= 1'b0;
        end else begin
            if (i_cnt == i_st) begin
                o_pulse <= 1'b1;
            end else if (i_cnt == i_end) begin
                o_pulse <= 1'b0;
            end
        end
    end

endmodule
