#include "gageot.h"

uint_32 vga_current_address;

void Interrupt() __attribute__ ((interrupt_handler));
void MB_Init();
void VGA_Print(char* str);
void VGA_PrintCh(char str);
void VGA_Cursor_Position(uint_8 line, uint_8 column);
void VGA_Cls_Screen();
void VGA_Cls_Line(uint_8 line);
void VGA_Introduction();
void write_to_RAM(uint_32 address, uint_8 data);


int main() {
    MB_Init();
    VGA_Cls_Screen();
    VGA_Introduction();
    VGA_Cursor_Position(29, 33);
    VGA_Print("Hello GitHub !");
    while (1);
}

/*--------------------------------------------------------------------------*/
void VGA_Introduction() {
	int i;
	write_to_RAM(26,4);
	for (i = 27; i < 53; i++)
		write_to_RAM(i,6);
	write_to_RAM(53,5);
	write_to_RAM(106,4);
	write_to_RAM(133,5);
	write_to_RAM(186,4);
	write_to_RAM(213,5);
	write_to_RAM(266,4);
	for (i = 267; i < 293; i++)
		write_to_RAM(i,7);
	write_to_RAM(293,5);
    VGA_Cursor_Position(1, 30);
    VGA_Print("Dylan GAGEOT - 2018");
    VGA_Cursor_Position(2, 28);
    VGA_Print("640x480 VGA 8 BIT DRIVER");
}
/*--------------------------------------------------------------------------*/
void VGA_PrintCh(char car) {
	int i;
	if (car == '\n' || car == '\r') {
		for (i = 0; i < 4800; i+=80) {
			if (vga_current_address < i) {
				vga_current_address = i;
				break;
			}
		}
	} else {
		if (car == 0x08)
			write_to_RAM(--vga_current_address, ' ');
		else
			write_to_RAM(vga_current_address++, car);
	}
}
/*--------------------------------------------------------------------------*/
void VGA_Print(char* str) {
	while (*str) {
		VGA_PrintCh(*(str++));
	}
}
/*--------------------------------------------------------------------------*/
void VGA_Cursor_Position(uint_8 line, uint_8 column) {
	vga_current_address = column + line*80;
}
/*--------------------------------------------------------------------------*/
void VGA_Cls_Screen() {
	int i;
	for (i = 0; i < 4800; i++) {
		write_to_RAM(i, ' ');
	}
}
/*--------------------------------------------------------------------------*/
void VGA_Cls_Line(uint_8 line) {
	int i;
	for (i = line*80; i < line*80; i++) {
		write_to_RAM(i, ' ');
	}
}
/*--------------------------------------------------------------------------*/
void write_to_RAM(uint_32 address, uint_8 data) {
	while (GPI1 == 0);
	GPO1 = data;
	GPO2 = address;
	GPO3 = 0x00000003;
	GPO3 = 0x00000000;
}
/*--------------------------------------------------------------------------*/
void Interrupt() {
	if (IRQ_PENDING & 0x00000004) {
	
	}
	if (IRQ_PENDING & 0x00000008) {
		Delay_counter();
	}
	IRQ_ACK = 0xFFFFFFFF; // Effacez les notificiations d'interruption une fois
					      // traitée.
}
/*--------------------------------------------------------------------------*/
void MB_Init() {
	microblaze_enable_interrupts(); // Active les interruptions.
	IRQ_ENABLE = 0x0000000C; // Active les interruptions de
							 // récepetion sur le module UART et TIMER.
}
/*--------------------------------------------------------------------------*/
