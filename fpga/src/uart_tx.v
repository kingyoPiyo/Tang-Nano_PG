/*****************************************************************
* Title     : UART transmit module
* Date      : 2021/08/07
* Design    : kingyo (https://github.com/kingyoPiyo)
******************************************************************/
module uart_tx (
    input           i_clk,
    input           i_rst_n,
    input   [7:0]   i_data,
    input           i_txen,
    output          o_uart_miso,
    output          o_txempty
    );
    
    parameter   DIV_WID = 10;       // Prescaler bit width
    parameter   DIV_CNT = 10'd520;  // (10MHz / 19,200bps) - 1
    
    reg     [9:0]       data;       // startbit + data + stopbit
    reg                 txempty;
    reg                 miso;
    reg     [DIV_WID-1:0]   div;
    wire                start;
    wire                fin;
    wire                dt_txpls;
    reg     [3:0]       bitCnt;

    assign start = (txempty & i_txen);
    assign fin  = (bitCnt == 4'd10 & div == {DIV_WID{1'b0}});
    assign dt_txpls = (~txempty & div == DIV_CNT);

    /* div counter */
    always @(posedge i_clk or negedge i_rst_n) begin
        if (~i_rst_n)
            div <= {DIV_WID{1'b0}};
        else if (start)
            div <= DIV_CNT;
        else if (~txempty) begin
            if (div == {DIV_WID{1'b0}})
                div <= DIV_CNT;
            else
                div <= div - {{(DIV_WID-1){1'b0}},1'b1};
        end else
            div <= {DIV_WID{1'b0}};
    end
    
    /* txempty control */
    always @(posedge i_clk or negedge i_rst_n) begin
        if (~i_rst_n)
            txempty <= 1'b1;
        else if (start)
            txempty <= 1'b0;
        else if (fin)
            txempty <= 1'b1;
    end

    /* Tx data latch */
    always @(posedge i_clk or negedge i_rst_n) begin
        if (~i_rst_n)
            data <= 10'b1_00000000_0;
        else if (start)
            data <= { 1'b1, i_data[7:0], 1'b0 };
        else if (dt_txpls)
            data <= { 1'd0, data[9:1] };
    end

    /* Tx bit counter */
    always @(posedge i_clk or negedge i_rst_n) begin
        if (~i_rst_n)
            bitCnt <= 4'd0;
        else if (start)
            bitCnt <= 4'd0;
        else if (dt_txpls)
            bitCnt <= bitCnt + 4'd1;
    end

    /* Data send */
    always @(posedge i_clk or negedge i_rst_n) begin
        if (~i_rst_n)
            miso <= 1'b1;
        else if (dt_txpls) begin
            miso <= data[0];    // LSB First
        end
    end

    assign o_uart_miso = miso;
    assign o_txempty = txempty;

endmodule
    