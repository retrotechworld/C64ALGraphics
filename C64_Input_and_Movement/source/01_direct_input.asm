; WHAT: Direct horizontal and vertical movement; opposite directions cancel.
; WHY: Give keyboard and joystick input one common representation before moving the character.
; HOW: Read the input sources, form action bits and update a frame-paced, bounded position.

; 01_direct_input: compile from release root, ACME -f cbm -o build/01_direct_input.prg source/01_direct_input.asm
MODE = 0
!source "source/engine.asm"
