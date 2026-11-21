; WHAT: Four As with four independently selected background colours.
; WHY: Give character cells several background colours while retaining one-bit character shapes.
; HOW: Enable extended-background mode and encode the background selector in the high two screen-code bits.

; ACME assembler. Build: acme -f cbm -o demo.prg demo.asm
; Load PRG in VICE or C64, then RUN. Reset to return to BASIC.
; Standalone demonstration: owns screen, zero page $FB/$FC and IRQ state.
* = $0801
!byte $0b,$08,$0a,$00,$9e
!text "2061"
!byte 0,0,0
start:
    cld ; Select ordinary binary arithmetic.
    sei                 ; Stop normal IRQ processing during this demo
    lda #$7f ; Load A with constant $7f.
    sta $dc0d           ; Disable CIA interrupt sources
    sta $dd0d ; Write A to $dd0d.
    lda $dc0d           ; Clear any pending CIA status
    lda $dd0d ; Load A with $dd0d.
    lda #0 ; Load A with constant 0.
    sta $d01a           ; Disable VIC IRQ sources
    sta $d015           ; Start with sprites disabled
    lda $dd02 ; Load A with CIA2 port direction.
    ora #3 ; Set bits selected by #3; retain other set bits.
    sta $dd02           ; CIA2 bank selection bits must be outputs
    lda $dd00 ; Load A with CIA2 VIC bank selection.
    and #$fc ; Keep only the bits selected by #$fc.
    ora #3 ; Set bits selected by #3; retain other set bits.
    sta $dd00           ; VIC bank 0: $0000-$3fff
    lda #0 ; Load A with constant 0.
    sta $d020 ; Write A to $d020.
    sta $d021 ; Write A to $d021.
    lda #$5b ; Load A with constant $5b.
    sta $d011 ; Write A to vertical control and raster high bit.
    lda #$08 ; Load A with constant $08.
    sta $d016 ; Write A to horizontal control and fine scroll.
    lda #$14 ; Load A with constant $14.
    sta $d018 ; Write A to screen and graphics pointers.
    lda #32 ; Load A with constant 32.
    ldx #0 ; Load X with constant 0.
fill_screen:
    sta $0400,x ; Write A to $0400,x.
    sta $0500,x ; Write A to $0500,x.
    sta $0600,x ; Write A to $0600,x.
    sta $0700,x         ; Includes unused tail and sprite pointer area
    inx ; Advance the X index by one.
    bne fill_screen ; Continue at fill_screen when the result is nonzero.
    lda #1 ; Load A with constant 1.
    ldx #0 ; Load X with constant 0.
fill_colour:
    sta $d800,x ; Write A to $d800,x.
    sta $d900,x ; Write A to $d900,x.
    sta $da00,x ; Write A to $da00,x.
    sta $db00,x ; Write A to $db00,x.
    inx ; Advance the X index by one.
    bne fill_colour ; Continue at fill_colour when the result is nonzero.
    lda #2 ; Load A with constant 2.
    sta $d022 ; Write A to $d022.
    lda #5 ; Load A with constant 5.
    sta $d023 ; Write A to $d023.
    lda #6 ; Load A with constant 6.
    sta $d024 ; Write A to $d024.
    lda #1 ; Load A with constant 1.
    sta $0400           ; Glyph 1, background $d021
    lda #$41 ; Load A with constant $41.
    sta $0401           ; Same glyph, background $d022
    lda #$81 ; Load A with constant $81.
    sta $0402           ; Same glyph, background $d023
    lda #$c1 ; Load A with constant $c1.
    sta $0403           ; Same glyph, background $d024
forever:
    jmp forever ; Continue at forever without pushing a return address.
