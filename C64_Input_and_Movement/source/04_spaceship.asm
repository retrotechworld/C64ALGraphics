; WHAT: Thrust changes velocity; release applies drag; travel is clamped at the edges.
; WHY: Teach acceleration, drag and bounded movement independently of platform gravity.
; HOW: Update thrust or drag, add the resulting velocity to position, then clamp it at the playfield edges.

; 04_spaceship: compile from release root, ACME -f cbm -o build/04_spaceship.prg source/04_spaceship.asm
MODE = 3
!source "source/engine.asm"
