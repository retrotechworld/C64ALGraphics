; ACME assembler. Build: acme -f cbm -o demo.prg demo.asm
; Load PRG in VICE or C64, then RUN. Reset to return to BASIC.
; Standalone demonstration: owns screen, zero page $FB/$FC and IRQ state.
* = $0801
!byte $0b,$08,$0a,$00,$9e
!text "2061"
!byte 0,0,0
start:
    cld
    sei                 ; Stop normal IRQ processing during this demo
    lda #$7f
    sta $dc0d           ; Disable CIA interrupt sources
    sta $dd0d
    lda $dc0d           ; Clear any pending CIA status
    lda $dd0d
    lda #0
    sta $d01a           ; Disable VIC IRQ sources
    sta $d015           ; Start with sprites disabled
    lda $dd02
    ora #3
    sta $dd02           ; CIA2 bank selection bits must be outputs
    lda $dd00
    and #$fc
    ora #3
    sta $dd00           ; VIC bank 0: $0000-$3fff
    lda #0
    sta $d020
    sta $d021
    lda #$1b
    sta $d011
    lda #$08
    sta $d016
    lda #$14
    sta $d018
    lda #32
    ldx #0
fill_screen:
    sta $0400,x
    sta $0500,x
    sta $0600,x
    sta $0700,x         ; Includes unused tail and sprite pointer area
    inx
    bne fill_screen
    lda #1
    ldx #0
fill_colour:
    sta $d800,x
    sta $d900,x
    sta $da00,x
    sta $db00,x
    inx
    bne fill_colour
    lda #1              ; Screen code 1 = A, not PETSCII $41
    sta $0400+10*40+15
forever:
    jmp forever
