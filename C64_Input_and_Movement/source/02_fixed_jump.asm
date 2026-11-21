; WHAT: A fixed-height jump lands on the floor. Holding fire does not auto-jump.
; WHY: Make a jump follow velocity and gravity and land on a known support surface.
; HOW: Use fixed-point vertical integration, a fresh jump request and an explicit grounded state.

; 02_fixed_jump: compile from release root, ACME -f cbm -o build/02_fixed_jump.prg source/02_fixed_jump.asm
MODE = 1
!source "source/engine.asm"
