; WHAT: Four pixel-pair values across the first cell and a yellow row in the next cell.
; WHY: Trade horizontal resolution for a four-colour choice in each bitmap cell.
; HOW: Select multicolour bitmap mode and modify the two-bit pixel pair within its character-sized group of bitmap bytes.

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
    lda #$3b ; Load A with constant $3b.
    sta $d011 ; Write A to vertical control and raster high bit.
    lda #$18 ; Load A with constant $18.
    sta $d016 ; Write A to horizontal control and fine scroll.
    lda #$18 ; Load A with constant $18.
    sta $d018 ; Write A to screen and graphics pointers.
    lda #0 ; Load A with constant 0.
    sta $fb ; Write A to $fb.
    lda #$20 ; Load A with constant $20.
    sta $fc             ; Pointer to bitmap $2000
    lda #0              ; Zero is the bitmap clear value
    ldx #32             ; Clear the full bitmap allocation
    ldy #0 ; Load Y with constant 0.
clear_page:
    sta ($fb),y ; Write A to ($fb),y.
    iny ; Advance the Y index by one.
    bne clear_page ; Continue at clear_page when the result is nonzero.
    inc $fc ; Increase $fc by one.
    dex ; Decrease the X counter by one.
    bne clear_page ; Continue at clear_page when the result is nonzero.
    lda #$25            ; Pair 01 red; pair 10 green
    ldx #0 ; Load X with constant 0.
fill_screen:
    sta $0400,x ; Write A to $0400,x.
    sta $0500,x ; Write A to $0500,x.
    sta $0600,x ; Write A to $0600,x.
    sta $0700,x         ; Includes unused tail and sprite pointer area
    inx ; Advance the X index by one.
    bne fill_screen ; Continue at fill_screen when the result is nonzero.
    lda #7              ; Pair 11 yellow
    ldx #0 ; Load X with constant 0.
fill_colour:
    sta $d800,x ; Write A to $d800,x.
    sta $d900,x ; Write A to $d900,x.
    sta $da00,x ; Write A to $da00,x.
    sta $db00,x ; Write A to $db00,x.
    inx ; Advance the X index by one.
    bne fill_colour ; Continue at fill_colour when the result is nonzero.
    lda #$1b            ; Pairs 00 01 10 11 in first four logical pixels
    sta $2000 ; Write A to $2000.
    lda #$ff            ; Four yellow logical pixels, second cell
    sta $2000+8 ; Write A to $2000+8.
forever:
    jmp forever ; Continue at forever without pushing a return address.
