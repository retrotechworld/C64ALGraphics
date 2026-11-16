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
    lda #$3b
    sta $d011
    lda #$08
    sta $d016
    lda #$18
    sta $d018
    lda #0
    sta $fb
    lda #$20
    sta $fc             ; Pointer to bitmap $2000
    lda #0              ; Zero is the bitmap clear value
    ldx #32             ; Clear the full bitmap allocation
    ldy #0
clear_page:
    sta ($fb),y
    iny
    bne clear_page
    inc $fc
    dex
    bne clear_page
    lda #$12            ; Set bits white, clear bits red in each cell
    ldx #0
fill_screen:
    sta $0400,x
    sta $0500,x
    sta $0600,x
    sta $0700,x         ; Includes unused tail and sprite pointer area
    inx
    bne fill_screen
    lda #$80
    sta $2000           ; Pixel (0,0)
    lda #$01
    sta $2000+7         ; Pixel (7,7)
    lda #$ff
    sta $2000+8         ; Eight pixels at x=8..15, y=0
    ; General plotting routine: x = pxlo + 256*pxhi, y = py
    lda #<159
    sta pxlo
    lda #>159
    sta pxhi
    lda #100
    sta py
    jsr plot
forever:
    jmp forever
; plot sets one hires pixel; input x=0..319, y=0..199.
; Clobbers A,X,Y,$FB/$FC and temporary variables. No clipping.
plot:
    lda py
    and #$f8
    sta $fb
    lda #0
    sta $fc
    ; (y AND $f8)*40 = floor(y/8)*320
    ldx #3
mul8:
    asl $fb
    rol $fc
    dex
    bne mul8
    lda $fb
    sta temp
    lda $fc
    sta temp+1          ; Save y-band * 8
    asl $fb
    rol $fc
    asl $fb
    rol $fc            ; y-band * 32
    clc
    lda $fb
    adc temp
    sta $fb
    lda $fc
    adc temp+1
    adc #$20           ; Add bitmap base (sum cannot overflow here)
    sta $fc
    lda pxlo
    and #$f8           ; floor(x/8)*8, low byte
    clc
    adc $fb
    sta $fb
    lda $fc
    adc pxhi
    sta $fc
    lda py
    and #7
    tay
    lda pxlo
    and #7
    tax
    lda masks,x
    ora ($fb),y
    sta ($fb),y
    rts
masks: !byte $80,$40,$20,$10,$08,$04,$02,$01
pxlo: !byte 0
pxhi: !byte 0
py: !byte 0
temp: !word 0
