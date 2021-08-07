# Tang-Nano_PG
Pulse Generator for Tang-Nano FPGA.
  
GW1N-1 FPGAチップを搭載した[Tang Nano FPGAボード](https://jp.seeedstudio.com/Sipeed-Tang-Nano-FPGA-board-powered-by-GW1N-1-FPGA-p-4304.html)で動作するパルスジェネレータです。  
  
開発中・・  
  
## Pinout
|  Tang-Nano Pin#  | Description |
| ------ | ---- |
| 42 | CH3 out |
| 43 | CH2 out |
| 44 | CH1 out |
| 45 | CH0 out |
  

## Register Map
|  Address (HEX)  | Description |
| ------ | ---- |
| 0000 | Period [10ns] |
| 0002 | CH0 high timing [10ns] |
| 0004 | CH0 low timing [10ns] |
| 0006 | CH1 high timing [10ns] |
| 0008 | CH1 low timing [10ns] |
| 000A | CH2 high timing [10ns] |
| 000C | CH2 low timing [10ns] |
| 000E | CH3 high timing [10ns] |
| 0010 | CH3 low timing [10ns] |
  
## UART Format
Baudrate : 115,200bps  
### MOSI(PC -> FPGA)
|  Byte  | Description |
| ------ | ---- |
| 1 | CMD (0x00:Read / 0x01:Write) |
| 2 | Register address [15:8] |
| 3 | Register address [7:0] |
| 4 | Data [15:8] |
| 5 | Data [7:0] |
| 6 | Not use (0x00) |

### MISO(FPGA -> PC)
|  Byte  | Description |
| ------ | ---- |
| 1 | Status (0xFF) |
| 2 | Read data [15:8] |
| 3 | Read data [7:0] |
| 4 | Not use (0x00) |
| 5 | Not use (0x00) |
| 6 | Not use (0x00) |

# 参考
- Tang NanoのFPGAとPC間でUART通信をする https://qiita.com/ciniml/items/05ac7fd2515ceed3f88d
