; WHAT: Typed PETSCII is echoed through the KERNAL.
; WHY: Read buffered text through the operating system before taking over game input directly.
; HOW: Call GETIN, display accepted PETSCII characters and recognise the Return action through the KERNAL interface.

; Text-entry example: KERNAL IRQ remains active after normal BASIC startup.
; GETIN is buffered PETSCII, suitable for menus, not held-direction state.
* = $0801
!byte $0b,$08,$0a,$00,$9e
!text "2064"
!byte 0,0,0
!fill $0810-*,0
start:
    cld                 ; Binary arithmetic convention.
    cli                 ; Let the normal KERNAL IRQ scan the keyboard.
loop:
    jsr $ffe4           ; GETIN: A=0 if no character is queued.
    beq loop            ; Nothing ready: poll again.
    cmp #13             ; Return key ends the example.
    beq done ; Continue at done when the result is zero.
    jsr $ffd2           ; CHROUT displays PETSCII in A.
    jmp loop            ; Read next queued character.
done:
    rts                 ; SYS returns to BASIC using its existing stack frame.
