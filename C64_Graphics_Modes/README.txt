C64 graphics modes

Six independent ACME sources and matching PRGs. Build from this folder with:
acme -f cbm -o prg/04_hires_bitmap.prg source/04_hires_bitmap.asm
Run: x64sc -autostartprgmode 1 -autostart prg/04_hires_bitmap.prg

Examples use VIC bank zero and screen $0400. Custom characters and bitmaps
use $2000 in separate programs; sprite data is $3000 in the sprite example.
These demonstrations own the display and interrupt state. Reset to exit.
The plotter accepts X=0..319 and Y=0..199; it does not clip.

Expected results
01: White A at column 15, row 10 on black.
02: Repeated four-colour custom glyph pattern.
03: Four As with separate background selections.
04: Red field, white top-left marks and a white pixel at (159,100).
05: Four pixel-pair choices in the first cell and a yellow row in the second.
06: One hires and one multicolour sprite using the same shape data.

All six were run in PAL VICE 3.10. Their mode bits and bitmap writes were
checked. See the root VICE_VALIDATION_SUMMARY.txt for test scope and limits.
