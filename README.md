# VGA Text Mode

The output resolution of the VGA signal is 640x480. The text mode grid is 80x60. The microcontroller used in the circuit description is a softcore Microblaze. The microcontroller embeds a UART controller so that the display can be drived through an external source.

I've used my character set from my [LCDSim](https://github.com/dylangageot/LCDSim) project to test the system. Every character is draw on 8x8 pixel area, so a font pack 8x8 should be used.

## Block diagram

![block diagram](https://github.com/dylangageot/VGATextMode/raw/master/Images/block_diagram.png)

## Example code output

![example code](https://github.com/dylangageot/VGATextMode/raw/master/Images/output.png)
