# Auxilary feeder
## Rational
You might wonder why I do this? With my Sermoon D1 I often had issues with under extrution or the start of the print failed because the filament slipped out of the feeder. The first issue probably reulted ifrom the way I store the filament.

The extra feeder shall avoid transport problems.

## Hardware connection
The Monster 8 has 8 stepper drivers. For this auxilary feeder I use the driver5:E2.

This is the portion of the .cfg file. It is loctaed inside the extruder.cfg

```
[extruder_stepper auxilary_feeder]
extruder: extruder
# The extruder this stepper is synchronized to. If this is set to an
#  empty string then the stepper will not be synchronized to an
#  extruder. This parameter must be provided.
step_pin: PD2
dir_pin: PD1
enable_pin: !PD3
microsteps: 16
rotation_distance: 32.83
# See the "stepper" section for the definition of the above
# parameters.

[tmc2209 extruder_stepper auxilary_feeder]
uart_pin: PD0
run_current: 0.600
diag_pin:
```

## Testing low level
As with other steppers you can move the stepper back and forth with that command:

`STEPPER_BUZZ STEPPER="extruder_stepper auxilary_feeder"`

At my very first try it did not work, the enable pin needs the inverion flag: 
`enable_pin: !PD3`. After that the Stepper moved back and forth 10 times. (actually forth and back).

## Testing syncronization with extruder
Both the extruder (feeder) and the auxilary_feeder need to tranport the filament in sync. Therefor it should be sufficient to start extruding and the auxilary_feeder should transport the same ammount of filament. At this stage the amounts could still differ if the wheels have different diameters or the steps/mm are not the same.

So at least I want to see some transport.
1. Heat up the hotend to 200°C
2. Wait for heating up
3. Have filamanet in both the regular extruder and the auxilary one.
	I had used different filament pieces so they are independent from each other at this stage.
4. In the dashboard click on extrude.
5. Filamanets in both extruders should move in the same direction.
6. Same with retract.

<img src="assets/mainsailos-extruder.jpg" width="33%">

## Testing the amount of filament
Both extruders must transport the exact same amount of filament. For the test I use PLA from same manufacturer.

1. Mark the filamant in both feeders in same way as described in the Klipper docs (70mm).
	https://www.klipper3d.org/Rotation_Distance.html.
2. Set to relative coordinates `G91`.
3. Extrude 50mm with a slow speed `G1 E50 F60` to reduce the impact of filament melting.
4. Measure the (formerly) 70mm marks. They now should be 20mm away from the reference point.
	If not, calculate new rotation_distance values as described in the Klipper docs.
	In my case it was 20mm for both strings.
5. Do the same test with a higher speed `G1 E50 F600`.
	In my case there was quite a difference. Auxilary feeder was still at 20mm, but the normal feeder/extruder was at 35mm.
	Currently I do not understand why the difference is that big.

# Reserching different filamant transport
Since the last test was not too pleasing, I tried the same with a heigher temperature (225 vs 200).
This time the normal extruder was at 32mm. A bit more filament was feed, but still way too less.

This could be a sign that my extruder has an issue. Or my expectations are plain wrong. Most likely the latter.

