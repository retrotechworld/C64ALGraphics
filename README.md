# Commodore 64 Graphics Programming

Tested companion source, runnable programs and native graphics assets for the book by **Gareth Jones**.

**Start here:** [Build and run every example](BUILD_AND_RUN.md).

## Quick start

1. On this page choose **Code > Download ZIP**, extract the ZIP, then open the extracted folder. Or clone this repository with Git.
2. Install [ACME](https://sourceforge.net/projects/acme-crossass/) and [VICE](https://vice-emu.sourceforge.io/). Use `x64sc`, the cycle-accurate C64 emulator. Supply its required machine ROMs through the emulator's documented setup.
3. Open a terminal in the extracted repository folder. Run the following commands one line at a time:

```text
cd Before_We_Begin_Project
acme --strict-segments -f cbm -o build/main.prg src/main.asm
x64sc -model c64 -autostartprgmode 1 -autostart build/main.prg
```

Expect **HELLO FROM ACME!** on a blue screen with a black border. Close VICE before starting another example.

On Windows PowerShell, the same arguments work with `acme.exe` and `x64sc.exe`. If either tool is not on PATH, use its full path; for a quoted PowerShell executable path, put `&` before it. On macOS use the actual x64sc executable inside your installed VICE package, rather than assuming the app launcher accepts emulator options.

## Choose a project

| Folder | Learn | Entry programs |
| --- | --- | ---: |
| [Before_We_Begin_Project](Before_We_Begin_Project) | Setup and BASIC SYS startup | 1 |
| [C64_Graphics_Modes](C64_Graphics_Modes) | Character modes, bitmaps and sprites | 6 |
| [C64_Advanced_Tile_Maps](C64_Advanced_Tile_Maps) | Static maps and a coarse-scrolling world | 3 |
| [C64_Input_and_Movement](C64_Input_and_Movement) | Text input, direct movement, jumping and thrust | 5 |
| [beastlands-advanced](beastlands-advanced) | PAL parallax, animation and SID music | 1 |
| [Sound_Integration](Sound_Integration) | Non-blocking music and effect calls | 1 |

## Visual Studio Code

Open **this repository root folder** in VS Code. Choose **Terminal > Run Task** and select a named **Run** task; it builds the matching entry program before launching VICE. **Build all examples** assembles all 17 without launching VICE. The default build shortcut runs the setup example. ACME and x64sc must be on PATH, or edit their `command` entries in `.vscode/tasks.json` to the full executable paths.

The original project-specific tasks are also retained. If you use those, open that individual project folder as the workspace. Do not open a single source file alone. This is a VS Code Tasks workflow, not an F5 debugger integration.

## Controls and scope

Graphical movement examples use **W A S D** and/or **joystick port 2**. Platform examples use **Space/fire** to jump; the parallax scene uses **A/D and Space**. The standalone sound example reads **port-2 fire**, not the keyboard Space key directly. See the [full control table](BUILD_AND_RUN.md#controls-and-expected-results).

Use a PAL C64 model for the verified route. The parallax raster schedule and music tuning are PAL-specific. Most takeover examples deliberately keep running; reset or close VICE to leave. Test keyboard and joystick separately because the C64 shares their wiring.

These projects have independent entry points and memory maps. Do not concatenate them. `engine.asm`, `music.asm` and `sprite_midground.asm` are includes, not additional runnable programs. Tile-map examples render backgrounds; their integration fragments are not a complete collision game. The hardware sprite example is static. The sound demo uses a fire-edge event as a reproducible stand-in for an accepted hit.

## Verification

All 17 entry programs were rebuilt and run in **VICE 3.10 PAL**. Checks covered display modes, bitmap writes, tile cells, keyboard matrix and joystick input, jumps and landings, movement limits, parallax cameras and SID sequencing. Deliberate sprite fixtures checked collision latches. [Validation scope and limits](VICE_VALIDATION_SUMMARY.txt) distinguish emulated checks from physical hardware and NTSC testing.

Prebuilt PRGs and `beastlands.d64` are included. No machine ROMs, emulator or assembler is included. Build instructions use ACME directly and need no Python, asset generator or extra VS Code extension.
