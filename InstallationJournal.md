# Installation journal
This is WIP!

## Retrive information
```
gh repo clone makerbase-mks/MKS-Monster8
```
I am using V2.0 of the board. 

### Poor documentation from MKS
Unfortunatelly the documentation is quite poor, especially for the V2.0.
MKS should look into the docs of BTT (SKR3) to learn how a good documentation should look like.

- There is nothing that deserves the name manual.
- Schematics of the board cannot be searched through, it is pure graphics.
- No values are written in the schematics.
- Wire labels are not alligned correctly in many places (E.g. Reset at pin 14 of the MCU). This is just dirty.

## Preparation of the board

### Flash firmware
1. Copy "MKS-Monster8/klipper firmware/mks_monster8 v0.10.0-557.bin" to µSdCard (FAT) as "firmware.bin".
2. Set jumper USBPWR to on (behind the USB-C connector).
3. Plug µSdCard into board.
4. Connect board to host (Linux PC or RPI). Wait 1 second. (24V supply is not needed)

On host open terminal:
```
ls -l /dev/serial/by-id
```
Response:
```
total 0
drwxr-xr-x 2 root root 80 Mai 17 11:24 ./
drwxr-xr-x 4 root root 80 Mai 17 09:25 ../
lrwxrwxrwx 1 root root 13 Mai 17 11:24 usb-STMicroelectronics_MARLIN_STM32F407VGT6_CCM_CDC_in_FS_Mode_2077338F4B30-if00 -> ../../ttyACM0
```

Use this part: "usb-STMicroelectronics_MARLIN_STM32F407VGT6_CCM_CDC_in_FS_Mode_2077338F4B30-if00"
for the mcu section.

Note: This device name contains the serial number of the board and is therefore different on each installation. Using this method avoids the volatile naming (ttyACM0).

```
[mcu]
serial: /dev/serial/by-id/usb-STMicroelectronics_MARLIN_STM32F407VGT6_CCM_CDC_in_FS_Mode_2077338F4B30-if00
```

5. Unplug the board.
6. Set jumper USBPWR back to off !

### Set Jumpers

1. In my case I use TMC 2209 in UART mode:

   <img src="assets/TMC-Jumper.png"> 

2. Check the voltage for the fans. In my case I need 24V (VIN). These jumper are the factoy default.

   <img src="assets/FanJumper.png">

3. Check the jumper for end stop power. In my case I need 5V and this is the factory default.
	This is very important since I can probably fry the board?

   <img src="assets/EndStopPwr.png">

4. Check the voltage for the TMC drivers. 5V is recommended and factory default.

   <img src="assets/TMC_Voltage.png">

5. Check Jumpers for heatings. These must be unpluged, or the heating will be off.
   This is J14, J16, J17, J19.

   <img src="assets/HeatingJumpers.png">


6. There are more jumpers, for now I leave them at factory defaults. Perhaps I will come back later and add more details.

### Check polarity of connections
For luck I did not find any differences for the pinouts of the connectors. * and - are correct.
Only the BL_Touch will need extra care due to different connectors.

### Prepare Klipper config

Using the correct version of the PIN file. In my case it is located in "MKS-Monster8/hardware/MKS Monster8 V2.0_002/MKS Monster8 V2.0_002 PIN.pdf". You can also find the schematics in the same directory.

There is an example Klipper config "MKS-Monster8/klipper firmware/generic-mks-monster8.cfg".
In my case I had a working config for the BTT SKR3 board, so I used that as a starting point and adjusted the pin definitions to the monster 8.

Both the example config (copy paste some lines) and the PIN definition file (PDF named above) do help with details. Below is a screenshot of the pin definitions to ensure you find the right file.

   <img src="assets/PinDefinitions.png">

Klipper supports the split the config into several files. This help to find the right stuff later. Therefore my printer.cfg mostly contains include statements.

printer.cfg
```
[include mainsail.cfg]
[include sermoon_d1.cfg]
[include stepper.cfg]
[include extruder.cfg]
[include bed_screws.cfg]
[include bltouch.cfg]
[include z_tilt.cfg]
[include heater_bed.cfg]
[include fans.cfg]
[include mcu.cfg]
[include display.cfg]
[include filament_sensor.cfg]
[include leds.cfg]
[include input_shaper.cfg]
[include macros/macros.cfg]

# bltouch must be directly in printer.cfg in order the SAVE_CONFIG can work
[bltouch]
....

```



To be continued....
