# Build and run every example

These commands start in the repository root. Execute one line at a time. When a block starts with `cd`, return to the repository root before choosing another project. Use the exact folder and source names shown. Prebuilt output folders are supplied.

## Install and check the tools

Install ACME and VICE from the links in the [README](README.md). Run `acme --version` and `x64sc -help` to check that your terminal can find them. First start x64sc by itself and confirm the normal C64 BASIC screen. Missing BASIC, KERNAL or character ROMs are emulator setup issues; resolve them before testing the source.

Use **PAL C64** for the verified configuration. Every PRG command below requests `-model c64` and injects the PRG into RAM before normal BASIC startup. This is separate from loading a real disk image.

## Windows Linux and macOS

The build arguments are the same on all three systems. Windows can use `acme.exe` and `x64sc.exe`. On Linux and macOS use `acme` and `x64sc`. If an executable is outside PATH, replace the executable name with its full path. For example in PowerShell:

```powershell
& "C:/C64Tools/acme/acme.exe" --strict-segments -f cbm -o build/main.prg src/main.asm
& "C:/C64Tools/vice/x64sc.exe" -model c64 -autostartprgmode 1 -autostart build/main.prg
```

The paths are examples: substitute your real installation paths. Quoted executable paths on Linux/macOS do not use the leading PowerShell `&`.

## Build and run commands

### Before_We_Begin_Project

**Development setup**

```text
cd Before_We_Begin_Project
acme --strict-segments -f cbm -o build/main.prg src/main.asm
x64sc -model c64 -autostartprgmode 1 -autostart build/main.prg
```

White HELLO FROM ACME! on a blue screen with a black border. Controls: No controls; reset to leave.

### C64_Graphics_Modes

**01_standard_text**

```text
cd C64_Graphics_Modes
acme --strict-segments -f cbm -o prg/01_standard_text.prg source/01_standard_text.asm
x64sc -model c64 -autostartprgmode 1 -autostart prg/01_standard_text.prg
```

A white A at column 15, row 10 on black. Controls: Static display; reset to leave.

**02_multicolour_text**

```text
cd C64_Graphics_Modes
acme --strict-segments -f cbm -o prg/02_multicolour_text.prg source/02_multicolour_text.asm
x64sc -model c64 -autostartprgmode 1 -autostart prg/02_multicolour_text.prg
```

A repeated multicolour custom-character pattern. Controls: Static display; reset to leave.

**03_extended_text**

```text
cd C64_Graphics_Modes
acme --strict-segments -f cbm -o prg/03_extended_text.prg source/03_extended_text.asm
x64sc -model c64 -autostartprgmode 1 -autostart prg/03_extended_text.prg
```

Four As with four independently selected background colours. Controls: Static display; reset to leave.

**04_hires_bitmap**

```text
cd C64_Graphics_Modes
acme --strict-segments -f cbm -o prg/04_hires_bitmap.prg source/04_hires_bitmap.asm
x64sc -model c64 -autostartprgmode 1 -autostart prg/04_hires_bitmap.prg
```

A red field, white marks near the top left and the plotted pixel at (159,100). Controls: Static display; reset to leave.

**05_multicolour_bitmap**

```text
cd C64_Graphics_Modes
acme --strict-segments -f cbm -o prg/05_multicolour_bitmap.prg source/05_multicolour_bitmap.asm
x64sc -model c64 -autostartprgmode 1 -autostart prg/05_multicolour_bitmap.prg
```

Four pixel-pair values across the first cell and a yellow row in the next cell. Controls: Static display; reset to leave.

**06_sprites**

```text
cd C64_Graphics_Modes
acme --strict-segments -f cbm -o prg/06_sprites.prg source/06_sprites.asm
x64sc -model c64 -autostartprgmode 1 -autostart prg/06_sprites.prg
```

Two sprites using the same data: one hires and one multicolour. Controls: Static display; reset to leave.

### C64_Advanced_Tile_Maps

**01_hires_platform**

```text
cd C64_Advanced_Tile_Maps
acme --strict-segments -f cbm -o build/01_hires_platform.prg source/01_hires_platform.asm
x64sc -model c64 -autostartprgmode 1 -autostart build/01_hires_platform.prg
```

A static hires girder-and-ladder character map. Controls: Automatic display; reset to leave.

**02_mixed_platform**

```text
cd C64_Advanced_Tile_Maps
acme --strict-segments -f cbm -o build/02_mixed_platform.prg source/02_mixed_platform.asm
x64sc -model c64 -autostartprgmode 1 -autostart build/02_mixed_platform.prg
```

A static map mixing hires and multicolour character cells. Controls: Automatic display; reset to leave.

**03_horizontal_world**

```text
cd C64_Advanced_Tile_Maps
acme --strict-segments -f cbm -o build/03_horizontal_world.prg source/03_horizontal_world.asm
x64sc -model c64 -autostartprgmode 1 -autostart build/03_horizontal_world.prg
```

An automatically scrolling 40-column viewport into a 128-column world. Controls: Automatic display; reset to leave.

### C64_Input_and_Movement

**00_kernal_text**

```text
cd C64_Input_and_Movement
acme --strict-segments -f cbm -o build/00_kernal_text.prg source/00_kernal_text.asm
x64sc -model c64 -autostartprgmode 1 -autostart build/00_kernal_text.prg
```

Typed PETSCII is echoed through the KERNAL. Controls: Type text; Return exits to BASIC.

**01_direct_input**

```text
cd C64_Input_and_Movement
acme --strict-segments -f cbm -o build/01_direct_input.prg source/01_direct_input.asm
x64sc -model c64 -autostartprgmode 1 -autostart build/01_direct_input.prg
```

Direct horizontal and vertical movement; opposite directions cancel. Controls: W A S D or joystick port 2.

**02_fixed_jump**

```text
cd C64_Input_and_Movement
acme --strict-segments -f cbm -o build/02_fixed_jump.prg source/02_fixed_jump.asm
x64sc -model c64 -autostartprgmode 1 -autostart build/02_fixed_jump.prg
```

A fixed-height jump lands on the floor. Holding fire does not auto-jump. Controls: A D or port-2 left/right; Space or fire jumps.

**03_variable_jump**

```text
cd C64_Input_and_Movement
acme --strict-segments -f cbm -o build/03_variable_jump.prg source/03_variable_jump.asm
x64sc -model c64 -autostartprgmode 1 -autostart build/03_variable_jump.prg
```

Release early for a shorter jump. Descending through the ledge surface produces a landing. Controls: A D or port-2 left/right; Space or fire jumps.

**04_spaceship**

```text
cd C64_Input_and_Movement
acme --strict-segments -f cbm -o build/04_spaceship.prg source/04_spaceship.asm
x64sc -model c64 -autostartprgmode 1 -autostart build/04_spaceship.prg
```

Thrust changes velocity; release applies drag; travel is clamped at the edges. Controls: W A S D or joystick port 2.

### beastlands-advanced

**Woodland parallax**

```text
cd beastlands-advanced
acme --strict-segments -f cbm -o beastlands.prg beastlands.asm
x64sc -model c64 -autostartprgmode 1 -autostart beastlands.prg
```

A layered woodland scene with runner animation, scrolling, two-voice music and a jump cue. Controls: A D or port-2 left/right; Space or fire jumps; reset exits.

### Sound_Integration

**Music and effect calls**

```text
cd Sound_Integration
acme --strict-segments -f cbm -o sound_calls.prg sound_calls.asm
x64sc -model c64 -autostartprgmode 1 -autostart sound_calls.prg
```

Background music continues while voice 3 plays a short effect. Controls: Joystick port 2 fire requests one cue on a new press.

## Run the parallax disk image

From the repository root:

```text
cd beastlands-advanced
x64sc -model c64 -autostart beastlands.d64
```

Allow disk loading to finish before expecting the woodland scene. In the checked configuration this took about 20 seconds; speed varies with drive settings. To load manually on a C64 or an emulated drive, attach the disk to drive 8 and type:

```basic
LOAD"BEASTLANDS",8,1
RUN
```

Rebuilding beastlands.asm updates the PRG, not the D64 automatically. After changing the program, recreate the disk with the VICE c1541 tool:

```text
c1541 -format "BEASTLANDS,01" d64 beastlands.d64 -write beastlands.prg BEASTLANDS
```

Run that command only when deliberately replacing the disk with your rebuilt program.

## Controls and expected results

| Project and entry | Controls | Visible or audible result |
| --- | --- | --- |

| Before_We_Begin_Project / Development setup | No controls; reset to leave | White HELLO FROM ACME! on a blue screen with a black border. |

| C64_Graphics_Modes / 01_standard_text | Static display; reset to leave | A white A at column 15, row 10 on black. |

| C64_Graphics_Modes / 02_multicolour_text | Static display; reset to leave | A repeated multicolour custom-character pattern. |

| C64_Graphics_Modes / 03_extended_text | Static display; reset to leave | Four As with four independently selected background colours. |

| C64_Graphics_Modes / 04_hires_bitmap | Static display; reset to leave | A red field, white marks near the top left and the plotted pixel at (159,100). |

| C64_Graphics_Modes / 05_multicolour_bitmap | Static display; reset to leave | Four pixel-pair values across the first cell and a yellow row in the next cell. |

| C64_Graphics_Modes / 06_sprites | Static display; reset to leave | Two sprites using the same data: one hires and one multicolour. |

| C64_Advanced_Tile_Maps / 01_hires_platform | Automatic display; reset to leave | A static hires girder-and-ladder character map. |

| C64_Advanced_Tile_Maps / 02_mixed_platform | Automatic display; reset to leave | A static map mixing hires and multicolour character cells. |

| C64_Advanced_Tile_Maps / 03_horizontal_world | Automatic display; reset to leave | An automatically scrolling 40-column viewport into a 128-column world. |

| C64_Input_and_Movement / 00_kernal_text | Type text; Return exits to BASIC | Typed PETSCII is echoed through the KERNAL. |

| C64_Input_and_Movement / 01_direct_input | W A S D or joystick port 2 | Direct horizontal and vertical movement; opposite directions cancel. |

| C64_Input_and_Movement / 02_fixed_jump | A D or port-2 left/right; Space or fire jumps | A fixed-height jump lands on the floor. Holding fire does not auto-jump. |

| C64_Input_and_Movement / 03_variable_jump | A D or port-2 left/right; Space or fire jumps | Release early for a shorter jump. Descending through the ledge surface produces a landing. |

| C64_Input_and_Movement / 04_spaceship | W A S D or joystick port 2 | Thrust changes velocity; release applies drag; travel is clamped at the edges. |

| beastlands-advanced / Woodland parallax | A D or port-2 left/right; Space or fire jumps; reset exits | A layered woodland scene with runner animation, scrolling, two-voice music and a jump cue. |

| Sound_Integration / Music and effect calls | Joystick port 2 fire requests one cue on a new press | Background music continues while voice 3 plays a short effect. |

## Joystick and sound setup

Select joystick **port 2** in VICE. Choose a physical controller or configure a keyboard joystick keyset in VICE input settings. The host key mapped to joystick fire is not necessarily Space. When testing W/A/S/D and Space as C64 keys, avoid a joystick keyset that intercepts those same host keys. Port 1 should remain neutral for these examples.

Enable VICE sound and a working host audio output. The standalone sound example can leave the BASIC display unchanged while music plays. Press and release port-2 fire to hear the cue; holding it should not repeatedly restart the effect. In the parallax program, Space or port-2 fire starts a jump and its cue. Music continues underneath. These are separate SID players; use one owner in an integrated game.

## Common problems

| Problem | What to check |
| --- | --- |
| ACME or x64sc not found | PATH or the exact executable path; restart the terminal or VS Code after changing PATH. |
| Missing ROM or no BASIC boot | VICE machine ROM paths and model settings. |
| Source or include not found | Run the command from the stated project folder, preserving all subfolders. |
| PRG loads but does not run | Use the matching PRG and the supplied `-autostartprgmode 1 -autostart` arguments; do not enter an unrelated SYS address. |
| No movement | Correct C64 window focus, host keyboard mapping, port 2 selection and conflicting joystick keysets. |
| No sound | Host audio output, VICE sound enabled, and the correct port-2 fire action. The BASIC-looking sound screen is expected. |
| Background scroll flashes | The coarse tile-map renderer deliberately blanks the display while redrawing; it is not a smooth raster-scrolling engine. |
| Parallax looks wrong | Use PAL; keep every native asset and included module from this folder. Reset between takeover examples. |
| VICE stays open after a task | Close VICE before starting another run task. |

## Validation

See [VICE_VALIDATION_SUMMARY.txt](VICE_VALIDATION_SUMMARY.txt). The supplied prebuilt binaries match the tested source. New edits need fresh assembly and emulator checks. Physical hardware, host key mappings, every simultaneous input combination and NTSC adaptations were not certified.
