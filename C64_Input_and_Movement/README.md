# C64 Keyboard Joystick and Movement

## Required tools

ACME assembles every program directly. VICE x64sc runs the PRGs. Use any text editor; VS Code provides the optional automatic build and launch tasks. No build scripts, Python, asset generators or extra VS Code extensions are required.

## VS Code automatic build and launch

1. Extract the complete pack. Open the C64_Input_and_Movement folder in VS Code using File > Open Folder. Keep source, build and .vscode together.
2. Install ACME and VICE. Their executables must be on PATH when VS Code starts. On Windows the tasks use acme.exe and x64sc.exe; on macOS and Linux they use acme and x64sc.
3. If either executable is not on PATH, edit its command in .vscode/tasks.json to its full installed path. On Windows edit the matching windows.command value; JSON paths may use forward slashes. For macOS edit command to the actual executable inside the installed application bundle if needed. No executable paths have been guessed for your computer.
4. Save your source. Choose Terminal > Run Build Task (Ctrl+Shift+B on Windows/Linux, Cmd+Shift+B on macOS). The default task assembles 03_variable_jump and then launches VICE.
5. Choose Terminal > Run Task and select Build and run followed by another example name for the other four programs. Build all examples assembles the five programs without starting VICE.
6. Each launch task depends on its matching ACME build. If assembly fails, correct the errors and rerun; VICE should not be launched by the failed task. Close VICE before launching another session.

The tasks have type process and launch the executables directly. There is no command chain or shell build wrapper. Automatic launch uses VS Code Tasks, not an F5 debugger configuration.

## Plain text editor workflow

Edit and save an entry file, then invoke ACME directly with these arguments from the extracted project folder:

acme -f cbm -o build/03_variable_jump.prg source/03_variable_jump.asm

Use the corresponding filename for each example. Load the resulting PRG using the VICE interface, or invoke x64sc with arguments -autostart build/03_variable_jump.prg. You need no script or preprocessing step. The build folder is supplied.

Entry files: 00_kernal_text.asm, 01_direct_input.asm, 02_fixed_jump.asm, 03_variable_jump.asm and 04_spaceship.asm. engine.asm is the shared ACME include, not a separate runnable program. All graphics are literal assembly data. The entry files select MODE and ACME reads the include itself.

## Controls

W A S D or joystick port 2. Space/fire jumps in the platform examples. Fire has no action in direct movement or spaceship examples. Return ends the text example. Reset exits game examples. Test keyboard and joystick separately when diagnosing emulator keyset conflicts.

## Validation

C64 GRAPHICS PROGRAMMING VICE VALIDATION
16 November 2026

All 17 entry programs were rebuilt with ACME 0.97 strict segment checks and
run in VICE x64sc 3.10. PAL C64 and PAL C64C configurations were used.
Screenshots, mode registers and bitmap writes matched the documented examples.
Each tile renderer matched all 1000 screen and colour cells to its source map.

Movement tests covered normalized port-2 input, W/A/S/D and Space keyboard
matrix reads, direction cancellation, frame-paced movement, fixed and variable
jumping, floor and ledge landings, held fire, thrust, drag and position bounds.
Parallax tests covered movement, jumping, camera limits 0..2048 and D64 boot.
Deliberate sprite fixtures checked sprite/sprite and sprite/background collision
latches. Real CPU reads verified the clear-on-read rule.

SID tests covered gate timing, effect expiry, release/new-press retriggering,
background music progression during effects, and sound_stop silence.
6581, 8580 and parallax audio was recorded with actual synthesized output;
recordings had no full-scale clipped samples. Human listening remains part of
publication proofing. No physical C64 or NTSC timing certification is claimed.

Keyboard matrix and joystick signals were supplied through emulator test
interfaces. Host keyboard mappings and a physical USB joystick were not tested.
VS Code GUI launch across every operating system was not certified.

No application-code fault was reproduced in these defined PAL tests.
All included PRG copies match the tested rebuilt binaries.
The full validation report and evidence are in the publication package.
