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
    lda #8
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
    ldx #62
copy_sprite:
    lda shape,x
    sta $3000,x
    dex
    bpl copy_sprite
    lda #$c0            ; $3000 / 64, relative to bank zero
    sta $07f8
    sta $07f9
    lda #100
    sta $d000
    lda #160
    sta $d002
    lda #100
    sta $d001
    sta $d003
    lda #0
    sta $d010           ; All sprite X high bits clear
    sta $d017
    sta $d01d           ; No expansion
    sta $d01b           ; Sprites in front of foreground
    lda #2
    sta $d01c           ; Sprite 1 multicolour; sprite 0 hires
    lda #1
    sta $d027
    lda #7
    sta $d028
    lda #2
    sta $d025
    lda #5
    sta $d026
    lda #3
    sta $d015           ; Enable sprites 0 and 1
forever:
    jmp forever
shape:
!for row,0,20 {
    !byte $18,$7e,$18
}
