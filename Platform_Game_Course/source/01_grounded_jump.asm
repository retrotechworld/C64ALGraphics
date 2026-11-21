; WHAT: Grounded jumping and one-way surfaces. LEFT/RIGHT move; fresh FIRE jumps.
; WHY: Avoid repeated held-button jumps and missed landings when motion skips across a surface.
; HOW: Read active-low port 2 input, latch FIRE edges, integrate signed vertical speed and snap old/new feet crossings to one-way tops.

; C64 Platform Game Course - independent PAL C64 example
; Build with scripts/build_all.py; reset machine to exit.
; C64 PLATFORM GAME: grounded jumping, gravity, one-way platforms
; ACME: python3 scripts/build_all.py (from the release root)
; Start in BASIC: RUN  (or SYS 2064)
; Joystick port 2: left/right, FIRE to jump. No music/interrupts.
; VIC coordinates: character screen begins at X=24, Y=50.
; Platforms are 8-pixel-high screen-character rows, their TOP edges
; are at Y=146,186,218. Collision uses the platform TOP, not its bottom.

*=$0801
!byte $0b,$08,$0a,$00,$9e,$32,$30,$36,$34,$00,$00,$00
*=$0810

PLAYER_X=$fb
PLAYER_Y=$fc
VEL_Y=$fd
GROUNDED=$fe
OLD_FEET=$f9
NEW_FEET=$fa
INDEX=$f8
TICK=$f7

FIREOLD=$e9

start:
    sei ; Block maskable IRQ service during ownership changes.
    cld ; Select ordinary binary arithmetic.
    lda #$37 ; Load A with constant $37.
    sta $01 ; Write A to $01.
    lda #$7f ; Load A with constant $7f.
    sta $dc0d ; Write A to $dc0d.
    sta $dd0d ; Write A to $dd0d.
    lda $dc0d ; Load A with $dc0d.
    lda $dd0d ; Load A with $dd0d.
    lda #0 ; Load A with constant 0.
    sta $d01a ; Write A to VIC interrupt mask.
    lda #$ff ; Load A with constant $ff.
    sta $dc02 ; Write A to CIA1 port A direction.
    sta $dc00 ; Write A to CIA1 joystick and matrix port.
    lda $dd02 ; Load A with CIA2 port direction.
    ora #3 ; Set bits selected by #3; retain other set bits.
    sta $dd02 ; Write A to CIA2 port direction.
    lda $dd00 ; Load A with CIA2 VIC bank selection.
    ora #3 ; Set bits selected by #3; retain other set bits.
    sta $dd00 ; Write A to CIA2 VIC bank selection.
    lda #$1b ; Load A with constant $1b.
    sta $d011 ; Write A to vertical control and raster high bit.
    lda #$08 ; Load A with constant $08.
    sta $d016 ; Write A to horizontal control and fine scroll.
    lda #$15 ; Load A with constant $15.
    sta $d018 ; Write A to screen and graphics pointers.
    lda #0 ; Load A with constant 0.
    sta $d015 ; Write A to sprite enable mask.
    sta $d017 ; Write A to $d017.
    sta $d01d ; Write A to $d01d.
    sta $d01c ; Write A to $d01c.
    sta $d010 ; Write A to sprite X high bits.
    sta $d01b ; Write A to $d01b.
    lda #$00 ; Load A with constant $00.
    sta $d015               ; disable sprites during setup
    sta $d01b               ; sprites in front of foreground pixels
    sta $d017               ; no vertical expansion
    sta $d01d               ; no horizontal expansion
    lda #$06 ; Load A with constant $06.
    sta $d020               ; blue border
    lda #$00 ; Load A with constant $00.
    sta $d021               ; black background
    lda #$20 ; Load A with constant $20.
    ldx #$00 ; Load X with constant $00.
clear_screen:
    sta $0400,x ; Write A to $0400,x.
    sta $0500,x ; Write A to $0500,x.
    sta $0600,x ; Write A to $0600,x.
    sta $0700,x             ; includes unused tail beyond visible screen
    inx ; Advance the X index by one.
    bne clear_screen ; Continue at clear_screen when the result is nonzero.
    lda #$01 ; Load A with constant $01.
    ldx #$00 ; Load X with constant $00.
clear_colours:
    sta $d800,x ; Write A to $d800,x.
    sta $d900,x ; Write A to $d900,x.
    sta $da00,x ; Write A to $da00,x.
    sta $db00,x ; Write A to $db00,x.
    inx ; Advance the X index by one.
    bne clear_colours ; Continue at clear_colours when the result is nonzero.

    ; Three platforms: screen row 12, columns 5..13 (top Y=146)
    ldx #$00 ; Load X with constant $00.
platform_one:
    lda #$a0               ; reverse-space: solid block on standard charset
    sta $05e5,x           ; $0400 + 12*40 + 5
    lda #$05 ; Load A with constant $05.
    sta $d9e5,x ; Write A to $d9e5,x.
    inx ; Advance the X index by one.
    cpx #9 ; Compare X with #9; update flags.
    bne platform_one ; Continue at platform_one when the result is nonzero.
    ; Row 17, columns 14..22 (top Y=186)
    ldx #$00 ; Load X with constant $00.
platform_two:
    lda #$a0 ; Load A with constant $a0.
    sta $06be,x           ; $0400 + 17*40 + 14
    lda #$07 ; Load A with constant $07.
    sta $dabe,x ; Write A to $dabe,x.
    inx ; Advance the X index by one.
    cpx #9 ; Compare X with #9; update flags.
    bne platform_two ; Continue at platform_two when the result is nonzero.
    ; Row 21, columns 3..24 (top Y=218)
    ldx #$00 ; Load X with constant $00.
platform_three:
    lda #$a0 ; Load A with constant $a0.
    sta $074b,x           ; $0400 + 21*40 + 3
    lda #$0d ; Load A with constant $0d.
    sta $db4b,x ; Write A to $db4b,x.
    inx ; Advance the X index by one.
    cpx #22 ; Compare X with #22; update flags.
    bne platform_three ; Continue at platform_three when the result is nonzero.

    ; Screen text (row 1, column 2)
    ldx #0 ; Load X with constant 0.
headline:
    lda title_text,x ; Load A with title_text,x.
    beq headline_done ; Continue at headline_done when the result is zero.
    sta $042a,x ; Write A to $042a,x.
    inx ; Advance the X index by one.
    bne headline ; Continue at headline when the result is nonzero.
headline_done:

    lda #$00 ; Load A with constant $00.
    sta $d010               ; X high bits clear
    lda #$01 ; Load A with constant $01.
    sta $d01c               ; sprite 0 is multicolour
    lda #$0a ; Load A with constant $0a.
    sta $d025               ; shared colour 1: light red (skin placeholder)
    lda #$06 ; Load A with constant $06.
    sta $d026               ; shared colour 2: blue
    lda #$02 ; Load A with constant $02.
    sta $d027               ; sprite 0 individual: red
    lda #player_sprite / 64 ; sprite pointer within VIC bank 0
    sta $07f8 ; Write A to $07f8.
    lda #$01 ; Load A with constant $01.
    sta $d015 ; Write A to sprite enable mask.
    lda #80 ; Load A with constant 80.
    sta PLAYER_X ; Write A to PLAYER_X.
    lda #125 ; Load A with constant 125.
    sta PLAYER_Y          ; feet = 146, on top of first platform
    lda #0 ; Load A with constant 0.
    sta VEL_Y ; Write A to VEL_Y.
    sta FIREOLD ; Write A to FIREOLD.
    sta TICK ; Write A to TICK.
    lda #1 ; Load A with constant 1.
    sta GROUNDED ; Write A to GROUNDED.


main_loop:
    ; Wait for a fresh raster frame: raster line 250, then wait to leave it
wait_raster:
    lda $d012 ; Load A with raster comparator.
    cmp #250 ; Compare A with #250; retain A and update flags.
    bne wait_raster ; Continue at wait_raster when the result is nonzero.
wait_leave:
    lda $d012 ; Load A with raster comparator.
    cmp #250 ; Compare A with #250; retain A and update flags.
    beq wait_leave ; Continue at wait_leave when the result is zero.

    ; Joystick port 2, active-low: left bit 2, right bit 3, fire bit 4
    lda $dc00 ; Load A with CIA1 joystick and matrix port.
    and #%00000100 ; Keep only the bits selected by #%00000100.
    bne no_left ; Continue at no_left when the result is nonzero.
    lda PLAYER_X ; Load A with PLAYER_X.
    cmp #26 ; Compare A with #26; retain A and update flags.
    bcc no_left ; Continue at no_left when carry is clear.
    dec PLAYER_X ; Decrease PLAYER_X by one.
    dec PLAYER_X ; Decrease PLAYER_X by one.
no_left:
    lda $dc00 ; Load A with CIA1 joystick and matrix port.
    and #%00001000 ; Keep only the bits selected by #%00001000.
    bne no_right ; Continue at no_right when the result is nonzero.
    lda PLAYER_X ; Load A with PLAYER_X.
    cmp #220 ; Compare A with #220; retain A and update flags.
    bcs no_right ; Continue at no_right when carry is set.
    inc PLAYER_X ; Increase PLAYER_X by one.
    inc PLAYER_X ; Increase PLAYER_X by one.
no_right:
    lda $dc00 ; Load A with CIA1 joystick and matrix port.
    and #$10 ; Keep only the bits selected by #$10.
    beq fire_down ; Continue at fire_down when the result is zero.
    lda #0 ; Load A with constant 0.
    sta FIREOLD ; Write A to FIREOLD.
    jmp no_jump ; Continue at no_jump without pushing a return address.
fire_down:
    lda FIREOLD ; Load A with FIREOLD.
    bne no_jump ; Continue at no_jump when the result is nonzero.
    lda #1 ; Load A with constant 1.
    sta FIREOLD ; Write A to FIREOLD.
    lda GROUNDED ; Load A with GROUNDED.
    beq no_jump ; Continue at no_jump when the result is zero.
    lda #$f9               ; signed -7: initial upward speed
    sta VEL_Y ; Write A to VEL_Y.
    lda #0 ; Load A with constant 0.
    sta GROUNDED ; Write A to GROUNDED.
no_jump:
    ; Check standing support every frame, even with zero velocity.
    ; If player has walked off an edge, begin falling.
    lda GROUNDED ; Load A with GROUNDED.
    beq airborne ; Continue at airborne when the result is zero.
    jsr find_support ; Call find_support; the routine returns with RTS.
    bcs supported ; Continue at supported when carry is set.
    lda #0 ; Load A with constant 0.
    sta GROUNDED ; Write A to GROUNDED.
supported:
airborne:
    lda PLAYER_Y ; Load A with PLAYER_Y.
    clc ; Clear carry before a new addition.
    adc #21 ; Add #21 and carry to A; propagate overflow.
    sta OLD_FEET ; Write A to OLD_FEET.

    ; Gravity every fourth frame. Signed vertical velocity capped at +5.
    lda GROUNDED ; Load A with GROUNDED.
    bne gravity_done ; Continue at gravity_done when the result is nonzero.
    inc TICK ; Increase TICK by one.
    lda TICK ; Load A with TICK.
    and #3 ; Keep only the bits selected by #3.
    bne gravity_done ; Continue at gravity_done when the result is nonzero.
    lda VEL_Y ; Load A with VEL_Y.
    cmp #5 ; Compare A with #5; retain A and update flags.
    beq gravity_done ; Continue at gravity_done when the result is zero.
    clc ; Clear carry before a new addition.
    adc #1 ; Add #1 and carry to A; propagate overflow.
    sta VEL_Y ; Write A to VEL_Y.
gravity_done:
    lda GROUNDED ; Load A with GROUNDED.
    bne skip_motion ; Continue at skip_motion when the result is nonzero.
    ; Signed addition: -7 is $F9, so adding it moves upward.
    clc ; Clear carry before a new addition.
    lda PLAYER_Y ; Load A with PLAYER_Y.
    adc VEL_Y ; Add VEL_Y and carry to A; propagate overflow.
    sta PLAYER_Y ; Write A to PLAYER_Y.
    ; Clamp to top of VIC display region
    cmp #48 ; Compare A with #48; retain A and update flags.
    bcs not_too_high ; Continue at not_too_high when carry is set.
    lda #48 ; Load A with constant 48.
    sta PLAYER_Y ; Write A to PLAYER_Y.
    lda #0 ; Load A with constant 0.
    sta VEL_Y ; Write A to VEL_Y.
not_too_high:
    lda PLAYER_Y ; Load A with PLAYER_Y.
    cmp #229 ; Compare A with #229; retain A and update flags.
    bcc below_reset ; Continue at below_reset when carry is clear.
    lda #80 ; Load A with constant 80.
    sta PLAYER_X ; Write A to PLAYER_X.
    lda #125 ; Load A with constant 125.
    sta PLAYER_Y ; Write A to PLAYER_Y.
    lda #0 ; Load A with constant 0.
    sta VEL_Y ; Write A to VEL_Y.
    lda #1 ; Load A with constant 1.
    sta GROUNDED ; Write A to GROUNDED.
below_reset:
    lda PLAYER_Y ; Load A with PLAYER_Y.
    clc ; Clear carry before a new addition.
    adc #21 ; Add #21 and carry to A; propagate overflow.
    sta NEW_FEET ; Write A to NEW_FEET.
    ; Only falling (velocity >= 0) can land on a one-way platform.
    lda VEL_Y ; Load A with VEL_Y.
    bmi skip_motion ; Continue at skip_motion when bit 7 is set.
    jsr find_landing ; Call find_landing; the routine returns with RTS.
skip_motion:
    lda PLAYER_X ; Load A with PLAYER_X.
    sta $d000 ; Write A to $d000.
    lda PLAYER_Y ; Load A with PLAYER_Y.
    sta $d001 ; Write A to $d001.
    jmp main_loop ; Continue at main_loop without pushing a return address.

; find_support: carry SET if player's feet equal a platform top
; and player's horizontal footprint overlaps the platform.
find_support:
    ldx #0 ; Load X with constant 0.
support_loop:
    lda PLAYER_Y ; Load A with PLAYER_Y.
    clc ; Clear carry before a new addition.
    adc #21 ; Add #21 and carry to A; propagate overflow.
    cmp platform_top,x ; Compare A with platform_top,x; retain A and update flags.
    bne next_support ; Continue at next_support when the result is nonzero.
    jsr horizontal_overlap ; Call horizontal_overlap; the routine returns with RTS.
    bcs support_yes ; Continue at support_yes when carry is set.
next_support:
    inx ; Advance the X index by one.
    cpx #3 ; Compare X with #3; update flags.
    bne support_loop ; Continue at support_loop when the result is nonzero.
    clc ; Clear carry before a new addition.
    rts ; Return to the instruction after the caller JSR.
support_yes:
    sec ; Set carry before subtraction.
    rts ; Return to the instruction after the caller JSR.

; find_landing: downward crossing of platform top, with X overlap
find_landing:
    ldx #0 ; Load X with constant 0.
landing_loop:
    lda OLD_FEET ; Load A with OLD_FEET.
    cmp platform_top,x ; Compare A with platform_top,x; retain A and update flags.
    bcc old_above ; Continue at old_above when carry is clear.
    beq old_above ; Continue at old_above when the result is zero.
    jmp next_landing ; Continue at next_landing without pushing a return address.
old_above:
    lda NEW_FEET ; Load A with NEW_FEET.
    cmp platform_top,x ; Compare A with platform_top,x; retain A and update flags.
    bcc next_landing ; Continue at next_landing when carry is clear.
    jsr horizontal_overlap ; Call horizontal_overlap; the routine returns with RTS.
    bcc next_landing ; Continue at next_landing when carry is clear.
    lda platform_top,x ; Load A with platform_top,x.
    sec ; Set carry before subtraction.
    sbc #21 ; Subtract #21 from A using carry as no borrow.
    sta PLAYER_Y          ; snap feet EXACTLY to platform top
    lda #0 ; Load A with constant 0.
    sta VEL_Y ; Write A to VEL_Y.
    lda #1 ; Load A with constant 1.
    sta GROUNDED ; Write A to GROUNDED.
    rts ; Return to the instruction after the caller JSR.
next_landing:
    inx ; Advance the X index by one.
    cpx #3 ; Compare X with #3; update flags.
    bne landing_loop ; Continue at landing_loop when the result is nonzero.
    rts ; Return to the instruction after the caller JSR.

; horizontal_overlap: carry SET if [playerX,playerX+24)
; overlaps [platform_left,platform_right). Uses unsigned values.
horizontal_overlap:
    lda PLAYER_X ; Load A with PLAYER_X.
    cmp platform_right,x ; Compare A with platform_right,x; retain A and update flags.
    bcs no_overlap ; Continue at no_overlap when carry is set.
    clc ; Clear carry before a new addition.
    adc #24 ; Add #24 and carry to A; propagate overflow.
    cmp platform_left,x ; Compare A with platform_left,x; retain A and update flags.
    bcc no_overlap ; Continue at no_overlap when carry is clear.
    beq no_overlap ; Continue at no_overlap when the result is zero.
    sec ; Set carry before subtraction.
    rts ; Return to the instruction after the caller JSR.
no_overlap:
    clc ; Clear carry before a new addition.
    rts ; Return to the instruction after the caller JSR.

; Sprite X coordinates in VIC space; rows match drawn screen blocks.
platform_left:  !byte 64,136,48
platform_right: !byte 136,208,224
platform_top:   !byte 146,186,218
; Screen code is in PETSCII screen-code compatible uppercase range
; To avoid encoding issues, title uses literal screen codes.
title_text: !byte 16,12,1,20,6,15,18,13,32,4,5,13,15,0 ; PLATFORM DEMO

; Align the 64-byte sprite to a VIC pointer boundary.
!if * > $2000 { !error "Code overlaps sprite area" }
*=$2000
!align 63,0
player_sprite:
    !byte $00,$AA,$00,$02,$AA,$80,$0A,$AA,$A0
    !byte $05,$55,$40,$15,$55,$50,$15,$15,$10
    !byte $15,$55,$50,$05,$55,$40,$02,$AA,$00
    !byte $0A,$EE,$80,$2A,$FF,$A0,$AA,$FF,$A8
    !byte $5A,$FF,$A5,$16,$FF,$94,$03,$FF,$C0
    !byte $03,$FF,$C0,$03,$C3,$C0,$03,$C3,$C0
    !byte $03,$C3,$C0,$03,$C3,$C0,$0F,$C3,$F0
    !byte $00
