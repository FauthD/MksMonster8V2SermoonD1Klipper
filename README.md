# MksMonster8V2SermoonD1Klipper
Klipper settings for MKS Monster8 V2 build into the Creality Sermoon D1

This is WIP, do not use it yet.
I will add details here when it is ready and works.

# CAUTION: DO not use DFU with 24V connected with this board.
It can kill transistor Q7 (turning on bed heater all the time and Q7 gets very hot).
See there

[Bed is always heated after upgrade FW to v0.11.0-241-gffb5105b](https://github.com/makerbase-mks/MKS-Monster8/issues/40)

and

[V2 board starts burning when attempting dfu mode](https://github.com/makerbase-mks/MKS-Monster8/issues/26)

# Progress
[You can see many installation details there](InstallationJournal.md).

## Mechanics
Created an adapter to mount the Monster8 since it does not fit to the mounting holes. I also added some mounts for a big 120mm fan (because it was easier with a fan larger than the board). The fan runs with about 600 rmp and is barly audible.
There are also 3 mounting places for typical Step-Down regulators. I only use two for the fans, the third is spare.

Note: The monster board has 12V outputs for fans, so I would only need one step-down for the mainboard fan (7V), but the 12V step down was already wired from hystory (SKR 3 board). I am too lazy to change that right now.

| With 120mm fan |
| :----: |
| <img src="Monster8-Adapter/PNG/Monster8-Adapter-withFan.png" width="80%" height="80%"> 

Note: You either need to cut a hole onto the bottom sheet or replace it with some new and larger feet (my plan).

Note2: The original mainboard fan does not transport much air, but makes quite some noise. So a slow turning 120mm fan is much better.
The next source of noise is the fan in the power supply. I replaced that fan with a low noise 120mm fan. Now it is barly audible.

Note3: We need heigher feet. Already printed some test feet with 28mm height (need 40mm screws - probably will increase by 5mm when I have that screws available).

Note4: I cannot check whether the original wires are long enough since I did buy the printer used and the wires are not original anymore.
## Klipper

Working on this.

