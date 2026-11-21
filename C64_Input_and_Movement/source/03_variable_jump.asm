; WHAT: Release early for a shorter jump. Descending through the ledge surface produces a landing.
; WHY: Let the release of FIRE affect jump height while preserving reliable platform contacts.
; HOW: Apply the early-release rule to upward velocity, then use crossing and support tests to resolve the position.

; 03_variable_jump: compile from release root, ACME -f cbm -o build/03_variable_jump.prg source/03_variable_jump.asm
MODE = 2
!source "source/engine.asm"
