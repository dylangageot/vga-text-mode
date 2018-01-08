# VGA Text Mode

### Working on a color version

The output resolution of the VGA signal is 640x480. The text mode grid is 80x60. The microcontroller (Microblaze) inside is equipped with UART receiver and transmitter to allows the display to be drive through RS-232.

I've used my character set from my [LCDSim](https://github.com/dylangageot/LCDSim) project to test the system. Every character is draw on 8x8 pixel area, so a font pack 8x8 should be used.

## Block diagram

![block diagram](https://github.com/dylangageot/VGATextMode/raw/master/Images/block_diagram.png)

## Example code output

![example code](https://github.com/dylangageot/VGATextMode/raw/master/Images/output.png)
