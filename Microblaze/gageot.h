// Bibliothèques utiles
#include <mb_interface.h>

#ifndef GAGEOT
#define GAGEOT

// Definitions des types uint_8 et uint_32
typedef unsigned char  uint_8;
typedef unsigned short uint_16;
typedef unsigned int   uint_32;

// Liaisons entre les registres et le programme
#define IRQ_STATUS 		*((uint_32*) 	0x80000030)
#define IRQ_PENDING 	*((uint_32*) 	0x80000034)
#define IRQ_ENABLE		*((uint_32*) 	0x80000038)
#define IRQ_ACK			*((uint_32*) 	0x8000003C)
#define UART_RX			*((uint_32*) 	0x80000000)
#define UART_TX			*((uint_32*) 	0x80000004)
#define UART_STATUS		*((uint_32*) 	0x80000008)
#define PIT1_PRELOAD  	*((uint_32*) 	0x80000040)
#define PIT1_COUNTER  	*((uint_32*) 	0x80000044)
#define PIT1_CONTROL  	*((uint_32*) 	0x80000048)
#define GPO1 			*((uint_32*) 	0x80000010)
#define GPO2			*((uint_32*)	0x80000014)
#define GPO3			*((uint_32*)	0x80000018)
#define GPO4			*((uint_32*)	0x8000001C)
#define GPI1 			*((uint_32*) 	0x80000020)
#define GPI2 			*((uint_32*) 	0x80000024)
#define GPI3 			*((uint_32*) 	0x80000028)
#define GPI4 			*((uint_32*) 	0x8000002C)

// Défintions pour l'afficheur LCD
#define CLEAR_DISPLAY        0x01
#define LCD_HOME             0x02
#define LCD_START            0x03
#define ENTRY_MODE_SET       0x06
#define DISPLAY_ON           0x0C
#define DISPLAY_OFF          0x08
#define SHIFT_CURSOR_LEFT    0x10
#define SHIFT_CURSOR_RIGHT   0x14
#define SHIFT_DISPLAY_LEFT   0x18
#define SHIFT_DISPLAY_RIGHT  0x1C
#define FUNCTION_SET         0x28
#define SET_DDRAM_AD         0x80
#define SET_CGRAM_AD         0x40
#define LCD_CONN        	 GPO2

// Définitions diverses
#define INT_DIGITS 19

// Prototype des fonctions
void Delay_counter();
void Delay_ms(uint_32 ms);
void Delay_us(uint_32 us);
char *itoa(uint_8 i);
void UART_PutChar(char car);
void UART_PutS(char *s);

#endif
