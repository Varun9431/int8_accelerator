#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"

int main() {
    init_platform();
    xil_printf("=== UART Serial Test Successful ===\n");
    
    // Temporarily commented out to test system stability:
    // Xil_Out32(0x43C00000, 0x07);

    while(1) {
        // Hold loop
    }

    cleanup_platform();
    return 0;
}