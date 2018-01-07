#include "gageot.h"

// Dylan GAGEOT - 2018

uint_32 current_address;

#define TOP_X 29
#define TOP_Y 26

void Interrupt() __attribute__ ((interrupt_handler));
void MB_Init();
void VGA_Print(char* str);
void VGA_PrintCh(char car);
void VGA_PrintB(uint_8 bin);
void VGA_Cursor_Position(uint_8 line, uint_8 column);
void VGA_Cls_Screen();
void VGA_Cls_Line(uint_8 line);
void write_to_RAM(uint_32 address, uint_8 data);

int main() {
	int i = 0;
    MB_Init();
    VGA_Cls_Screen();

    // Draw GUI
    VGA_Cursor_Position(TOP_Y, TOP_X);
    VGA_PrintB(0x00);
    for (i = 0; i < 18; i++)
    	VGA_PrintB(0x06);
    VGA_PrintB(0x01);

    VGA_Cursor_Position(TOP_Y+1, TOP_X);
    VGA_PrintB(0x05);
    VGA_Print("   Dylan GAGEOT   ");
    VGA_PrintB(0x04);

    VGA_Cursor_Position(TOP_Y+2, TOP_X);
    VGA_PrintB(0x05);
    VGA_Print("640x480 VGA DRIVER");
    VGA_PrintB(0x04);

    VGA_Cursor_Position(TOP_Y+3, TOP_X);
    VGA_PrintB(0x08);
    for (i = 0; i < 18; i++)
    	VGA_PrintB(0x0A);
    VGA_PrintB(0x09);

    VGA_Cursor_Position(TOP_Y+4, TOP_X);
    VGA_PrintB(0x05);
    VGA_Print("   Hello GitHub   ");
    VGA_PrintB(0x04);

    VGA_Cursor_Position(TOP_Y+5, TOP_X);
    VGA_PrintB(0x02);
    for (i = 0; i < 18; i++)
    	VGA_PrintB(0x07);
    VGA_PrintB(0x03);

    while(1);
}

void VGA_PrintB(uint_8 bin) {
	write_to_RAM(current_address++, bin);
}

void VGA_PrintCh(char car) {
	int i;
	if (car == '\n' || car == '\r') {
		for (i = 0; i < 4800; i+=80) {
			if (current_address < i) {
				current_address = i;
				break;
			}
		}
	} else {
		if (car == 0x08)
			write_to_RAM(--current_address, ' ');
		else
			write_to_RAM(current_address++, car);
	}
}

void VGA_Print(char* str) {
	while (*str) {
		VGA_PrintCh(*(str++));
	}
}

void VGA_Cursor_Position(uint_8 line, uint_8 column) {
	current_address = column + line*80;
}

void VGA_Cls_Screen() {
	int i;
	for (i = 0; i < 4800; i++) {
		write_to_RAM(i, ' ');
	}
}

void VGA_Cls_Line(uint_8 line) {
	int i;
	for (i = line*80; i < line*80; i++) {
		write_to_RAM(i, ' ');
	}
}

void write_to_RAM(uint_32 address, uint_8 data) {
	while (GPI1 == 0);
	GPO1 = data;
	GPO2 = address;
	GPO3 = 0x00000003;
	GPO3 = 0x00000000;
}

/*--------------------------------------------------------------------------*/
void Interrupt() {
//	if (IRQ_PENDING & 0x00000004) {
//
//	}
	if (IRQ_PENDING & 0x00000008) {
		Delay_counter();
	}
	IRQ_ACK = 0xFFFFFFFF; // Clear IRQ flag
}
/*--------------------------------------------------------------------------*/
void MB_Init() {
	microblaze_enable_interrupts(); // Enable Interruptions
	IRQ_ENABLE = 0x0000000C; // Enable UART RX and TIMER interrupt
}
/*--------------------------------------------------------------------------*/
