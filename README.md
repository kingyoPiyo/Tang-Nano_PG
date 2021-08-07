# Tang-Nano_PG
Pulse Generator for Tang-Nano FPGA.
  
GW1N-1 FPGAチップを搭載した[Tang Nano FPGAボード](https://jp.seeedstudio.com/Sipeed-Tang-Nano-FPGA-board-powered-by-GW1N-1-FPGA-p-4304.html)で動作するパルスジェネレータです。  
  
開発中・・  

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
