//Copyright (C)2014-2021 GOWIN Semiconductor Corporation.
//All rights reserved.
//File Title: Timing Constraints file
//GOWIN Version: 1.9.7.03 Beta
//Created Time: 2021-07-29 00:00:56

create_clock -name mco -period 41.667 -waveform {0 20.834} [get_ports {mco}]
create_generated_clock -name clk100m -source [get_ports {mco}] -master_clock mco -divide_by 6 -multiply_by 25 -duty_cycle 50 [get_nets {clk100m}]
create_generated_clock -name clk10m -source [get_ports {mco}] -master_clock mco -divide_by 60 -multiply_by 25 -duty_cycle 50 [get_nets {clk10m}]
set_clock_groups -asynchronous -group [get_clocks {clk100m}] -group [get_clocks {clk10m}]
set_false_path -from [get_ports {res_n btn_b_n uart_rx}] 
set_false_path -to [get_ports {uart_tx led_rgb[2] led_rgb[1] led_rgb[0] pout0 pout1 pout2 pout3}] 
