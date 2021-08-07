/*****************************************************************
* Title     : Tang-Nano FPGA Pulse Generator top module
* Date      : 2021/08/07
* Design    : kingyo (https://github.com/kingyoPiyo)
******************************************************************/
module pg_top
(
    input   wire    mco,        // 24MHz
    input   wire    res_n,      // Button A
    input   wire    btn_b_n,    // Button B

    input   wire    uart_rx,    // FPGA <-- PC
    output  wire    uart_tx,    // FPGA --> PC
    output  wire    [2:0]   led_rgb,

    // Pulse output
    output  wire    pout0,
    output  wire    pout1,
    output  wire    pout2,
    output  wire    pout3
);

    // Wires
    wire            clk100m;
    wire            clk10m;
    wire            w_pll_locked;
    wire            w_sync_res_n;
    wire    [23:0]  w_period_cnt;
    wire    [15:0]  w_regmap_addr;
    wire    [15:0]  w_regmap_rdata;
    wire    [15:0]  w_regmap_wdata;
    wire            w_regmap_wen;
    wire    [15:0]  w_reg0000;
    wire    [15:0]  w_reg0002;
    wire    [15:0]  w_reg0004;
    wire    [15:0]  w_reg0006;
    wire    [15:0]  w_reg0008;
    wire    [15:0]  w_reg000A;
    wire    [15:0]  w_reg000C;
    wire    [15:0]  w_reg000E;
    wire    [15:0]  w_reg0010;


    //==================================
    // PLL
    //  - INPUT:    24MHz
    //  - OUTPUT:   100MHz
    //==================================
    Gowin_rPLL pll (
        .clkin ( mco ),
        .reset ( ~res_n ),
        .clkout ( clk100m ),
        .clkoutd ( clk10m ),
        .lock ( w_pll_locked )
    );

    //==================================
    // Reset
    //==================================
    sync_reset sync_reset (
        .i_clk ( clk10m ),
        .i_res_n ( res_n & w_pll_locked ),
        .o_res_n ( w_sync_res_n )
    );

    //==================================
    // L tika
    //==================================
    led_tikatika l_tika (
        .i_clk ( clk10m ),
        .i_res_n ( w_sync_res_n ),
        .i_en ( 1'b1 ),
        .o_led ( led_rgb[1] )
    );

    assign led_rgb[0] = 1'b1;
    assign led_rgb[2] = 1'b1;

    //==================================
    // UART <--> Register
    //==================================
    uart2reg_if uart2reg (
        .i_clk ( clk10m ),
        .i_rst_n ( w_sync_res_n ),
        .i_rdata ( w_regmap_rdata[15:0] ),
        .i_uart_mosi ( uart_rx ),
        .o_rwaddr ( w_regmap_addr[15:0] ),
        .o_wdata ( w_regmap_wdata[15:0] ),
        .o_wen ( w_regmap_wen ),
        .o_uart_miso ( uart_tx )
    );

    //==================================
    // Register Map
    //==================================
    reg_map reg_map (
        .i_clk ( clk10m ),
        .i_rst_n ( w_sync_res_n ),
        .i_addr ( w_regmap_addr[15:0] ),
        .i_wdata ( w_regmap_wdata[15:0] ),
        .i_wen ( w_regmap_wen ),
        .o_q ( w_regmap_rdata[15:0] ),
        .o_reg0000 ( w_reg0000[15:0] ),
        .o_reg0002 ( w_reg0002[15:0] ),
        .o_reg0004 ( w_reg0004[15:0] ),
        .o_reg0006 ( w_reg0006[15:0] ),
        .o_reg0008 ( w_reg0008[15:0] ),
        .o_reg000A ( w_reg000A[15:0] ),
        .o_reg000C ( w_reg000C[15:0] ),
        .o_reg000E ( w_reg000E[15:0] ),
        .o_reg0010 ( w_reg0010[15:0] )
    );

    //==================================
    // 周期カウンタ値生成
    //==================================
    period_counter period_counter (
        .i_clk ( clk100m ),
        .i_res_n ( w_sync_res_n ),
        .i_period (w_reg0000[15:0] ),
        .o_cnt ( w_period_cnt[23:0] )
    );

    //==================================
    // パルス生成
    //==================================
    pg_oneshot pgo0 (
        .i_clk ( clk100m ),
        .i_res_n ( w_sync_res_n ),
        .i_cnt ( w_period_cnt[23:0] ),
        .i_st  ( w_reg0002[15:0] ),
        .i_end ( w_reg0004[15:0] ),
        .o_pulse ( pout0 )
    );
    pg_oneshot pgo1 (
        .i_clk ( clk100m ),
        .i_res_n ( w_sync_res_n ),
        .i_cnt ( w_period_cnt[23:0] ),
        .i_st  ( w_reg0006[15:0] ),
        .i_end ( w_reg0008[15:0]),
        .o_pulse ( pout1 )
    );
    pg_oneshot pgo2 (
        .i_clk ( clk100m ),
        .i_res_n ( w_sync_res_n ),
        .i_cnt ( w_period_cnt[23:0] ),
        .i_st ( w_reg000A[15:0] ),
        .i_end ( w_reg000C[15:0] ),
        .o_pulse ( pout2 )
    );
    pg_oneshot pgo3 (
        .i_clk ( clk100m ),
        .i_res_n ( w_sync_res_n ),
        .i_cnt ( w_period_cnt[23:0] ),
        .i_st  ( w_reg000E[15:0] ),
        .i_end ( w_reg0010[15:0] ),
        .o_pulse ( pout3 )
    );

endmodule
