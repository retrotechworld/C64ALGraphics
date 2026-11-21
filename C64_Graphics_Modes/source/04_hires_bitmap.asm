; WHAT: A red field, white marks near the top left and the plotted pixel at (159,100).
; WHY: Plot individual 320 by 200 pixels instead of selecting whole character cells.
; HOW: Select a bitmap and screen colour matrix, calculate the cell’s bitmap byte and set the selected bit.

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
    lda #$08 ; Load A with constant $08.
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
    lda #$12            ; Set bits white, clear bits red in each cell
    ldx #0 ; Load X with constant 0.
fill_screen:
    sta $0400,x ; Write A to $0400,x.
    sta $0500,x ; Write A to $0500,x.
    sta $0600,x ; Write A to $0600,x.
    sta $0700,x         ; Includes unused tail and sprite pointer area
    inx ; Advance the X index by one.
    bne fill_screen ; Continue at fill_screen when the result is nonzero.
    lda #$80 ; Load A with constant $80.
    sta $2000           ; Pixel (0,0)
    lda #$01 ; Load A with constant $01.
    sta $2000+7         ; Pixel (7,7)
    lda #$ff ; Load A with constant $ff.
    sta $2000+8         ; Eight pixels at x=8..15, y=0
    ; General plotting routine: x = pxlo + 256*pxhi, y = py
    lda #<159 ; Load A with constant <159.
    sta pxlo ; Write A to pxlo.
    lda #>159 ; Load A with constant >159.
    sta pxhi ; Write A to pxhi.
    lda #100 ; Load A with constant 100.
    sta py ; Write A to py.
    jsr plot ; Call plot; the routine returns with RTS.
forever:
    jmp forever ; Continue at forever without pushing a return address.
; plot sets one hires pixel; input x=0..319, y=0..199.
; Clobbers A,X,Y,$FB/$FC and temporary variables. No clipping.
plot:
    lda py ; Load A with py.
    and #$f8 ; Keep only the bits selected by #$f8.
    sta $fb ; Write A to $fb.
    lda #0 ; Load A with constant 0.
    sta $fc ; Write A to $fc.
    ; (y AND $f8)*40 = floor(y/8)*320
    ldx #3 ; Load X with constant 3.
mul8:
    asl $fb ; Shift left, moving bit 7 into carry.
    rol $fc ; Rotate left through carry.
    dex ; Decrease the X counter by one.
    bne mul8 ; Continue at mul8 when the result is nonzero.
    lda $fb ; Load A with $fb.
    sta temp ; Write A to temp.
    lda $fc ; Load A with $fc.
    sta temp+1          ; Save y-band * 8
    asl $fb ; Shift left, moving bit 7 into carry.
    rol $fc ; Rotate left through carry.
    asl $fb ; Shift left, moving bit 7 into carry.
    rol $fc            ; y-band * 32
    clc ; Clear carry before a new addition.
    lda $fb ; Load A with $fb.
    adc temp ; Add temp and carry to A; propagate overflow.
    sta $fb ; Write A to $fb.
    lda $fc ; Load A with $fc.
    adc temp+1 ; Add temp+1 and carry to A; propagate overflow.
    adc #$20           ; Add bitmap base (sum cannot overflow here)
    sta $fc ; Write A to $fc.
    lda pxlo ; Load A with pxlo.
    and #$f8           ; floor(x/8)*8, low byte
    clc ; Clear carry before a new addition.
    adc $fb ; Add $fb and carry to A; propagate overflow.
    sta $fb ; Write A to $fb.
    lda $fc ; Load A with $fc.
    adc pxhi ; Add pxhi and carry to A; propagate overflow.
    sta $fc ; Write A to $fc.
    lda py ; Load A with py.
    and #7 ; Keep only the bits selected by #7.
    tay ; Copy A to Y for indexed addressing.
    lda pxlo ; Load A with pxlo.
    and #7 ; Keep only the bits selected by #7.
    tax ; Copy A to X for indexed addressing.
    lda masks,x ; Load A with masks,x.
    ora ($fb),y ; Set bits selected by ($fb),y; retain other set bits.
    sta ($fb),y ; Write A to ($fb),y.
    rts ; Return to the instruction after the caller JSR.
masks: !byte $80,$40,$20,$10,$08,$04,$02,$01
pxlo: !byte 0
pxhi: !byte 0
py: !byte 0
temp: !word 0
