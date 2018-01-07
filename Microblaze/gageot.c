#include "gageot.h"

uint_32 time_counter;

/*--------------------------------------------------------------------------*/
char *itoa(uint_8 i) {
	static char buf[INT_DIGITS + 2];
	char *p = buf + INT_DIGITS + 1;	/* points to terminating '\0' */
	do {
		*--p = '0' + (i % 10);
		i /= 10;
	} while (i != 0);
	return p;
}
/*--------------------------------------------------------------------------*/
void Delay_us(uint_32 us) {
	PIT1_PRELOAD = 0x00000063;
	PIT1_CONTROL = 0x00000003;
	while(time_counter != us);
	PIT1_CONTROL = 0x00000000;
	time_counter = 0;
}
/*--------------------------------------------------------------------------*/
void Delay_ms(uint_32 ms) {
	PIT1_PRELOAD = 0x0001869F;
	PIT1_CONTROL = 0x00000003;
	while(time_counter != ms);
	PIT1_CONTROL = 0x00000000;
	time_counter = 0;
}
/*--------------------------------------------------------------------------*/
void Delay_counter() {
	time_counter++;
}
/*--------------------------------------------------------------------------*/
void UART_PutChar(char car) {
	UART_TX = (uint_32) car;
	while(UART_STATUS & 0x00000008);
}
/*--------------------------------------------------------------------------*/
void UART_PutS(char *s) {
	while (*s)
		UART_PutChar(*(s++));
}
/*--------------------------------------------------------------------------*/