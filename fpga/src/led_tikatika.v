/*****************************************************************
* Title     : LED flasher
* Date      : 2021/08/07
* Design    : kingyo (https://github.com/kingyoPiyo)
******************************************************************/
module led_tikatika (
    input   wire    i_clk,
    input   wire    i_res_n,
    input   wire    i_en,
    output  reg     o_led
);

    reg     [23:0]  r_cnt;

    wire            w_cnt_top = (r_cnt == 24'd4999999);    // 1Hz@10MHz
    always @(posedge i_clk or negedge i_res_n) begin
        if (~i_res_n) begin
            r_cnt <= 24'd0;
            o_led <= 1'b0;
        end else begin
            if (~i_en) begin
                r_cnt <= 24'd0;
                o_led <= 1'b0;
            end else if (w_cnt_top) begin
                r_cnt <= 24'd0;
                o_led <= ~o_led;
            end else begin
                r_cnt <= r_cnt + 24'd1;
            end
        end
    end

endmodule
