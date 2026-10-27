#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xil_io.h"
#include "xparameters.h"

// Base address automatically generated from xparameters.h
#ifdef XPAR_MATRIX_MULT_IP_0_S00_AXI_BASEADDR
  #define MATRIX_BASE_ADDR XPAR_MATRIX_MULT_IP_0_S00_AXI_BASEADDR
#else
  #define MATRIX_BASE_ADDR 0x43C00000 // Default AXI-Lite Base Address
#endif

// Custom IP Control & Status Register Addresses
#define REG_CTRL   (MATRIX_BASE_ADDR + 0x00) // slv_reg0: [0]=rst, [1]=en, [2]=clr_acc
#define REG_ADDR   (MATRIX_BASE_ADDR + 0x04) // slv_reg1: [9:0]=addr_a, [25:16]=addr_b
#define REG_ACC00  (MATRIX_BASE_ADDR + 0x08) // Read-only Accumulator (0,0)
#define REG_ACC01  (MATRIX_BASE_ADDR + 0x0C) // Read-only Accumulator (0,1)
#define REG_ACC10  (MATRIX_BASE_ADDR + 0x10) // Read-only Accumulator (1,0)
#define REG_ACC11  (MATRIX_BASE_ADDR + 0x14) // Read-only Accumulator (1,1)

int main() {
    init_platform();

    xil_printf("\n========================================\n");
    xil_printf("   ZedBoard 2x2 Matrix Multiplier Demo  \n");
    xil_printf("========================================\n\n");

    // 1. Assert Reset (rst=1, en=0, clr_acc=1) -> Control = 0x05
    Xil_Out32(REG_CTRL, 0x05);
    
    // 2. Clear Reset, enable accelerator & clear accumulator (rst=0, en=1, clr_acc=1) -> Control = 0x06
    Xil_Out32(REG_CTRL, 0x06);

    // 3. Load BRAM Addresses (addr_a = 0, addr_b = 0)
    Xil_Out32(REG_ADDR, (0 << 16) | 0);

    // 4. Start execution/accumulation (rst=0, en=1, clr_acc=0) -> Control = 0x02
    Xil_Out32(REG_CTRL, 0x02);

    // 5. Read back calculated 32-bit output matrix from hardware registers
    int acc00 = (int)Xil_In32(REG_ACC00);
    int acc01 = (int)Xil_In32(REG_ACC01);
    int acc10 = (int)Xil_In32(REG_ACC10);
    int acc11 = (int)Xil_In32(REG_ACC11);

    // 6. Print 2x2 output matrix to USB-UART terminal
    xil_printf("Result Matrix Output:\n");
    xil_printf("  [ %d , %d ]\n", acc00, acc01);
    xil_printf("  [ %d , %d ]\n\n", acc10, acc11);
    xil_printf("========================================\n");

    cleanup_platform();
    return 0;
}