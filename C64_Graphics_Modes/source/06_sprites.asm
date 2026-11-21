; WHAT: Two sprites using the same data: one hires and one multicolour.
; WHY: Move an image independently of the background without redrawing its covered cells.
; HOW: Place aligned 63-byte images in 64-byte slots, set sprite pointers, enable sprites and write their positions and colours.

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
    lda #$1b ; Load A with constant $1b.
    sta $d011 ; Write A to vertical control and raster high bit.
    lda #8 ; Load A with constant 8.
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
    ldx #62 ; Load X with constant 62.
copy_sprite:
    lda shape,x ; Load A with shape,x.
    sta $3000,x ; Write A to $3000,x.
    dex ; Decrease the X counter by one.
    bpl copy_sprite ; Continue at copy_sprite when bit 7 is clear.
    lda #$c0            ; $3000 / 64, relative to bank zero
    sta $07f8 ; Write A to $07f8.
    sta $07f9 ; Write A to $07f9.
    lda #100 ; Load A with constant 100.
    sta $d000 ; Write A to $d000.
    lda #160 ; Load A with constant 160.
    sta $d002 ; Write A to $d002.
    lda #100 ; Load A with constant 100.
    sta $d001 ; Write A to $d001.
    sta $d003 ; Write A to $d003.
    lda #0 ; Load A with constant 0.
    sta $d010           ; All sprite X high bits clear
    sta $d017 ; Write A to $d017.
    sta $d01d           ; No expansion
    sta $d01b           ; Sprites in front of foreground
    lda #2 ; Load A with constant 2.
    sta $d01c           ; Sprite 1 multicolour; sprite 0 hires
    lda #1 ; Load A with constant 1.
    sta $d027 ; Write A to $d027.
    lda #7 ; Load A with constant 7.
    sta $d028 ; Write A to $d028.
    lda #2 ; Load A with constant 2.
    sta $d025 ; Write A to $d025.
    lda #5 ; Load A with constant 5.
    sta $d026 ; Write A to $d026.
    lda #3 ; Load A with constant 3.
    sta $d015           ; Enable sprites 0 and 1
forever:
    jmp forever ; Continue at forever without pushing a return address.
shape:
!for row,0,20 {
    !byte $18,$7e,$18
}
