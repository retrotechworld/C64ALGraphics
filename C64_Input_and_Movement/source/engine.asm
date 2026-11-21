; Shared teaching engine for ACME. See tutorial for contracts and limitations.
; A and flags are scratch across routines. X and Y are scratch unless stated.
* = $0801
!byte $0b,$08,$0a,$00,$9e ; BASIC line 10 with SYS token
!text "2064"              ; decimal address of start at $0810
!byte 0,0,0               ; line end and BASIC program end
!fill $0810-*,0
start:
    sei                   ; Own CIA scan; stop KERNAL IRQ from changing columns.
    cld                   ; Physics needs binary ADC and SBC, never decimal.
    lda #$7f ; Load A with constant $7f.
    sta $dc0d             ; Disable CIA1 interrupt sources.
    sta $dd0d             ; Disable CIA2 interrupt sources.
    lda $dc0d             ; Read to acknowledge pending CIA interrupts.
    lda $dd0d ; Load A with $dd0d.
    lda #0 ; Load A with constant 0.
    sta $d01a             ; Disable VIC IRQs; frame loop polls the raster.
    sta $d015             ; Hide sprites until their data and position are ready.
    sta $d010             ; This bounded demonstration uses X below 256.
    sta $d017             ; Normal sprite height.
    sta $d01d             ; Normal sprite width.
    sta $d01b             ; Sprite in front of character graphics.
    lda $dd02 ; Load A with CIA2 port direction.
    ora #3 ; Set bits selected by #3; retain other set bits.
    sta $dd02             ; CIA2 bank selection pins must be outputs.
    lda $dd00 ; Load A with CIA2 VIC bank selection.
    and #$fc ; Keep only the bits selected by #$fc.
    ora #3 ; Set bits selected by #3; retain other set bits.
    sta $dd00             ; Inverted bits 11 select VIC bank $0000.
    lda #$1b ; Load A with constant $1b.
    sta $d011             ; Text mode, display on, 25 rows, normal Y scroll.
    lda #$18 ; Load A with constant $18.
    sta $d016             ; Multicolour character mode and 40 columns.
    lda #$18 ; Load A with constant $18.
    sta $d018             ; Screen $0400, custom charset $2000.
    lda #0 ; Load A with constant 0.
    sta $d020             ; Black border.
    lda #6 ; Load A with constant 6.
    sta $d021             ; Blue background for transparent character pixels.
    lda #11 ; Load A with constant 11.
    sta $d022             ; Character pair 01 is dark grey.
    lda #15 ; Load A with constant 15.
    sta $d023             ; Character pair 10 is light grey.
    lda #1 ; Load A with constant 1.
    sta $d025             ; Sprite pair 01 is white, shared by all sprites.
    lda #7 ; Load A with constant 7.
    sta $d026             ; Sprite pair 11 is yellow, shared by all sprites.
    lda #2 ; Load A with constant 2.
    sta $d027             ; Sprite pair 10 is red, specific to sprite zero.
    lda #1 ; Load A with constant 1.
    sta $d01c             ; Enable multicolour for sprite zero.
    ldx #0 ; Load X with constant 0.
clear_screen:
    lda #0 ; Load A with constant 0.
    sta $0400,x           ; Character zero is an empty custom tile.
    sta $0500,x ; Write A to $0500,x.
    sta $0600,x ; Write A to $0600,x.
    sta $0700,x           ; Includes padding and pointers; set pointer afterwards.
    lda #13               ; Bit 3 enables multicolour; low 3 bits give green.
    sta $d800,x ; Write A to $d800,x.
    sta $d900,x ; Write A to $d900,x.
    sta $da00,x ; Write A to $da00,x.
    sta $db00,x ; Write A to $db00,x.
    inx ; Advance the X index by one.
    bne clear_screen ; Continue at clear_screen when the result is nonzero.
    ldx #39 ; Load X with constant 39.
floor_tiles:
    lda #1 ; Load A with constant 1.
    sta $07c0,x           ; Row 24: $0400 + 24*40. Surface VIC Y=242.
    dex ; Decrease the X counter by one.
    bpl floor_tiles ; Continue at floor_tiles when bit 7 is clear.
!if MODE = 2 {             ; Extra landing surface only in variable jump demo.
    ldx #9 ; Load X with constant 9.
ledge_tiles:
    lda #1 ; Load A with constant 1.
    sta $068a,x           ; Row 16, columns 10..19; top VIC Y=178.
    dex ; Decrease the X counter by one.
    bpl ledge_tiles ; Continue at ledge_tiles when bit 7 is clear.
}
!if MODE = 3 {
    lda #$c1              ; Ship data $3040 / 64 in VIC bank zero.
} else {
    lda #$c0              ; Actual person data is at $3000 / 64 = $c0.
}
    sta $07f8             ; Pointer zero in current screen matrix.
    lda #80 ; Load A with constant 80.
    sta xpos ; Write A to xpos.
    lda #221 ; Load A with constant 221.
    sta ypos              ; 221 + 21 pixel height meets floor at Y=242.
    lda #1 ; Load A with constant 1.
    sta grounded ; Write A to grounded.
    sta $d015             ; Show sprite only after setup.
main_loop:
    jsr wait_frame ; Call wait_frame; the routine returns with RTS.
    jsr controls          ; Produce active high actions and one-frame presses.
!if MODE = 0 {
    jsr direct_move ; Call direct_move; the routine returns with RTS.
} else {
!if MODE = 3 {
    jsr ship_move ; Call ship_move; the routine returns with RTS.
} else {
    jsr horizontal ; Call horizontal; the routine returns with RTS.
    jsr jump_physics ; Call jump_physics; the routine returns with RTS.
}
}
    lda xpos ; Load A with xpos.
    sta $d000             ; Convert logical integer position to VIC coordinate.
    lda ypos ; Load A with ypos.
    sta $d001 ; Write A to $d001.
    jmp main_loop ; Continue at main_loop without pushing a return address.
wait_frame:
    lda #250 ; Load A with constant 250.
wait_leave:
    cmp $d012             ; Leave current line first to prevent repeat updates.
    beq wait_leave ; Continue at wait_leave when the result is zero.
wait_enter:
    cmp $d012             ; Both PAL and NTSC contain raster line 250.
    bne wait_enter ; Continue at wait_enter when the result is nonzero.
    rts                   ; One update per video frame if work fits a frame.
controls:
    lda actions ; Load A with actions.
    sta previous          ; Save previous normalized button state.
    lda #0 ; Load A with constant 0.
    sta $dc02             ; All port A pins input for joystick two reading.
    sta $dc03             ; All port B pins input for keyboard rows.
    lda $dc00 ; Load A with CIA1 joystick and matrix port.
    eor #$ff              ; Hardware 0 means pressed; software wants 1.
    and #$1f              ; Up=1 down=2 left=4 right=8 fire=16.
    sta actions ; Write A to actions.
    lda #0 ; Load A with constant 0.
    sta $dc00             ; Selected output pins will drive only LOW.
    lda #2 ; Load A with constant 2.
    sta $dc02             ; Select column 1 by making PA1 a low output.
    lda $dc01 ; Load A with CIA1 keyboard row input.
    sta keys              ; Snapshot rows so all tests use the same scan.
    and #4                ; A is column 1 row 2.
    bne no_a ; Continue at no_a when the result is nonzero.
    lda actions ; Load A with actions.
    ora #4 ; Set bits selected by #4; retain other set bits.
    sta actions ; Write A to actions.
no_a:
    lda keys ; Load A with keys.
    and #2                ; W is column 1 row 1.
    bne no_w ; Continue at no_w when the result is nonzero.
    lda actions ; Load A with actions.
    ora #1 ; Set bits selected by #1; retain other set bits.
    sta actions ; Write A to actions.
no_w:
    lda keys ; Load A with keys.
    and #32               ; S is column 1 row 5.
    bne no_s ; Continue at no_s when the result is nonzero.
    lda actions ; Load A with actions.
    ora #2 ; Set bits selected by #2; retain other set bits.
    sta actions ; Write A to actions.
no_s:
    lda #4 ; Load A with constant 4.
    sta $dc02             ; Select column 2 for D, row 2.
    lda $dc01 ; Load A with CIA1 keyboard row input.
    and #4 ; Keep only the bits selected by #4.
    bne no_d ; Continue at no_d when the result is nonzero.
    lda actions ; Load A with actions.
    ora #8 ; Set bits selected by #8; retain other set bits.
    sta actions ; Write A to actions.
no_d:
    lda #$80 ; Load A with constant $80.
    sta $dc02             ; Select column 7 for space, row 4.
    lda $dc01 ; Load A with CIA1 keyboard row input.
    and #16 ; Keep only the bits selected by #16.
    bne no_space ; Continue at no_space when the result is nonzero.
    lda actions ; Load A with actions.
    ora #16 ; Set bits selected by #16; retain other set bits.
    sta actions ; Write A to actions.
no_space:
    lda #0 ; Load A with constant 0.
    sta $dc02             ; Release columns between frames.
    lda previous ; Load A with previous.
    eor #$ff              ; NOT previous, restricted by next AND.
    and actions ; Keep only the bits selected by actions.
    sta pressed           ; Current AND NOT previous detects a new press.
    rts ; Return to the instruction after the caller JSR.
horizontal:
    lda actions ; Load A with actions.
    and #12               ; Resolve opposite directions to neutral.
    cmp #4 ; Compare A with #4; retain A and update flags.
    bne try_right ; Continue at try_right when the result is nonzero.
    lda xpos ; Load A with xpos.
    cmp #34 ; Compare A with #34; retain A and update flags.
    bcc horizontal_done ; Continue at horizontal_done when carry is clear.
    dec xpos              ; Two pixels per frame for platform characters.
    dec xpos ; Decrease xpos by one.
    rts ; Return to the instruction after the caller JSR.
try_right:
    cmp #8 ; Compare A with #8; retain A and update flags.
    bne horizontal_done ; Continue at horizontal_done when the result is nonzero.
    lda xpos ; Load A with xpos.
    cmp #239 ; Compare A with #239; retain A and update flags.
    bcs horizontal_done ; Continue at horizontal_done when carry is set.
    inc xpos ; Increase xpos by one.
    inc xpos ; Increase xpos by one.
horizontal_done:
    rts ; Return to the instruction after the caller JSR.
direct_move:
    jsr horizontal ; Call horizontal; the routine returns with RTS.
    lda actions ; Load A with actions.
    and #3 ; Keep only the bits selected by #3.
    cmp #1 ; Compare A with #1; retain A and update flags.
    bne direct_down ; Continue at direct_down when the result is nonzero.
    lda ypos ; Load A with ypos.
    cmp #52 ; Compare A with #52; retain A and update flags.
    bcc direct_done ; Continue at direct_done when carry is clear.
    dec ypos ; Decrease ypos by one.
    dec ypos ; Decrease ypos by one.
    rts ; Return to the instruction after the caller JSR.
direct_down:
    cmp #2 ; Compare A with #2; retain A and update flags.
    bne direct_done ; Continue at direct_done when the result is nonzero.
    lda ypos ; Load A with ypos.
    cmp #220 ; Compare A with #220; retain A and update flags.
    bcs direct_done ; Continue at direct_done when carry is set.
    inc ypos ; Increase ypos by one.
    inc ypos ; Increase ypos by one.
direct_done:
    rts ; Return to the instruction after the caller JSR.
jump_physics:
    lda ypos ; Load A with ypos.
    sta old_y             ; Previous top for crossing a one-way surface.
    lda grounded ; Load A with grounded.
    beq in_air ; Continue at in_air when the result is zero.
    lda pressed ; Load A with pressed.
    and #16               ; Fire starts once; holding cannot auto-jump.
    beq integrate ; Continue at integrate when the result is zero.
    lda #0 ; Load A with constant 0.
    sta grounded ; Write A to grounded.
    sta vylo ; Write A to vylo.
    lda #$fa ; Load A with constant $fa.
    sta vyhi              ; $fa00 = -6.0 pixels/frame, signed 8.8.
in_air:
!if MODE = 2 {
    lda actions ; Load A with actions.
    and #16               ; Releasing fire shortens only the rising phase.
    bne integrate ; Continue at integrate when the result is nonzero.
    lda vyhi ; Load A with vyhi.
    cmp #$fe              ; Signed velocities below -2 have high byte < $fe
    bcs integrate         ; Here we first exclude positive velocities below.
    bpl integrate         ; Positive high byte means falling; never cut it.
    lda #$fe ; Load A with constant $fe.
    sta vyhi ; Write A to vyhi.
    lda #0 ; Load A with constant 0.
    sta vylo              ; Clamp upward speed to -2.0.
}
integrate:
    clc ; Clear carry before a new addition.
    lda vylo ; Load A with vylo.
    adc #$40              ; Gravity = +0.25 pixels/frame squared.
    sta vylo ; Write A to vylo.
    lda vyhi ; Load A with vyhi.
    adc #0                ; Carry propagates fractional overflow.
    sta vyhi ; Write A to vyhi.
    bmi add_y ; Continue at add_y when bit 7 is set.
    cmp #6 ; Compare A with #6; retain A and update flags.
    bcc add_y ; Continue at add_y when carry is clear.
    lda #6                ; Terminal falling speed +6.0.
    sta vyhi ; Write A to vyhi.
    lda #0 ; Load A with constant 0.
    sta vylo ; Write A to vylo.
add_y:
    clc ; Clear carry before a new addition.
    lda yfrac ; Load A with yfrac.
    adc vylo ; Add vylo and carry to A; propagate overflow.
    sta yfrac ; Write A to yfrac.
    lda ypos ; Load A with ypos.
    adc vyhi              ; Two's complement adds negative velocity too.
    sta ypos ; Write A to ypos.
    lda #0 ; Load A with constant 0.
    sta grounded          ; Walking off a ledge begins falling.
    lda vyhi ; Load A with vyhi.
    bmi jump_done         ; Never land while travelling upward.
!if MODE = 2 {
    lda xpos ; Load A with xpos.
    cmp #81               ; Actor right = X+24; overlap platform [104,184).
    bcc check_floor ; Continue at check_floor when carry is clear.
    cmp #184 ; Compare A with #184; retain A and update flags.
    bcs check_floor ; Continue at check_floor when carry is set.
    lda old_y ; Load A with old_y.
    cmp #158              ; Previous top <=157: previous feet <=178.
    bcs check_floor ; Continue at check_floor when carry is set.
    lda ypos ; Load A with ypos.
    cmp #157              ; New feet reach/cross ledge surface Y=178.
    bcc check_floor ; Continue at check_floor when carry is clear.
    lda #157 ; Load A with constant 157.
    jmp land ; Continue at land without pushing a return address.
}
check_floor:
    lda ypos ; Load A with ypos.
    cmp #221 ; Compare A with #221; retain A and update flags.
    bcc jump_done ; Continue at jump_done when carry is clear.
    lda #221 ; Load A with constant 221.
land:
    sta ypos              ; Snap feet to surface, preventing penetration.
    lda #0 ; Load A with constant 0.
    sta yfrac ; Write A to yfrac.
    sta vylo ; Write A to vylo.
    sta vyhi ; Write A to vyhi.
    lda #1 ; Load A with constant 1.
    sta grounded ; Write A to grounded.
jump_done:
    rts ; Return to the instruction after the caller JSR.
ship_move:
    lda actions ; Load A with actions.
    and #12 ; Keep only the bits selected by #12.
    cmp #4 ; Compare A with #4; retain A and update flags.
    bne ship_right ; Continue at ship_right when the result is nonzero.
    lda vx ; Load A with vx.
    cmp #$fc              ; Signed minimum -4.
    beq ship_vertical ; Continue at ship_vertical when the result is zero.
    dec vx ; Decrease vx by one.
    jmp ship_vertical ; Continue at ship_vertical without pushing a return address.
ship_right:
    cmp #8 ; Compare A with #8; retain A and update flags.
    bne ship_drag ; Continue at ship_drag when the result is nonzero.
    lda vx ; Load A with vx.
    cmp #4 ; Compare A with #4; retain A and update flags.
    beq ship_vertical ; Continue at ship_vertical when the result is zero.
    inc vx ; Increase vx by one.
    jmp ship_vertical ; Continue at ship_vertical without pushing a return address.
ship_drag:
    lda vx                ; No horizontal thrust: drag one unit toward zero.
    beq ship_vertical ; Continue at ship_vertical when the result is zero.
    bmi drag_negative ; Continue at drag_negative when bit 7 is set.
    dec vx ; Decrease vx by one.
    jmp ship_vertical ; Continue at ship_vertical without pushing a return address.
drag_negative:
    inc vx ; Increase vx by one.
ship_vertical:
    lda actions ; Load A with actions.
    and #3 ; Keep only the bits selected by #3.
    cmp #1 ; Compare A with #1; retain A and update flags.
    bne ship_down ; Continue at ship_down when the result is nonzero.
    lda sy ; Load A with sy.
    cmp #$fc ; Compare A with #$fc; retain A and update flags.
    beq ship_integrate ; Continue at ship_integrate when the result is zero.
    dec sy ; Decrease sy by one.
    jmp ship_integrate ; Continue at ship_integrate without pushing a return address.
ship_down:
    cmp #2 ; Compare A with #2; retain A and update flags.
    bne ship_y_drag ; Continue at ship_y_drag when the result is nonzero.
    lda sy ; Load A with sy.
    cmp #4 ; Compare A with #4; retain A and update flags.
    beq ship_integrate ; Continue at ship_integrate when the result is zero.
    inc sy ; Increase sy by one.
    jmp ship_integrate ; Continue at ship_integrate without pushing a return address.
ship_y_drag:
    lda sy ; Load A with sy.
    beq ship_integrate ; Continue at ship_integrate when the result is zero.
    bmi y_drag_negative ; Continue at y_drag_negative when bit 7 is set.
    dec sy ; Decrease sy by one.
    jmp ship_integrate ; Continue at ship_integrate without pushing a return address.
y_drag_negative:
    inc sy ; Increase sy by one.
ship_integrate:
    clc ; Clear carry before a new addition.
    lda xpos ; Load A with xpos.
    adc vx                ; Signed byte velocity; bounds prevent wraparound.
    cmp #32 ; Compare A with #32; retain A and update flags.
    bcs check_x_max ; Continue at check_x_max when carry is set.
    lda #32 ; Load A with constant 32.
    ldx #0 ; Load X with constant 0.
    stx vx ; Write X to vx.
check_x_max:
    cmp #241 ; Compare A with #241; retain A and update flags.
    bcc store_x ; Continue at store_x when carry is clear.
    lda #240 ; Load A with constant 240.
    ldx #0 ; Load X with constant 0.
    stx vx ; Write X to vx.
store_x:
    sta xpos ; Write A to xpos.
    clc ; Clear carry before a new addition.
    lda ypos ; Load A with ypos.
    adc sy ; Add sy and carry to A; propagate overflow.
    cmp #50 ; Compare A with #50; retain A and update flags.
    bcs check_y_max ; Continue at check_y_max when carry is set.
    lda #50 ; Load A with constant 50.
    ldx #0 ; Load X with constant 0.
    stx sy ; Write X to sy.
check_y_max:
    cmp #222 ; Compare A with #222; retain A and update flags.
    bcc store_y ; Continue at store_y when carry is clear.
    lda #221 ; Load A with constant 221.
    ldx #0 ; Load X with constant 0.
    stx sy ; Write X to sy.
store_y:
    sta ypos ; Write A to ypos.
    rts ; Return to the instruction after the caller JSR.
; Variables live in the program image, not unreserved BASIC zero page.
actions: !byte 0
previous: !byte 0
pressed: !byte 0
keys: !byte 0
xpos: !byte 0
ypos: !byte 0
yfrac: !byte 0
vylo: !byte 0
vyhi: !byte 0
old_y: !byte 0
grounded: !byte 0
vx: !byte 0
sy: !byte 0
!if * > $2000 { !error "Code overlaps custom charset" }
* = $2000
!byte 0,0,0,0,0,0,0,0    ; Tile zero: all background.
!byte $55,$aa,$ff,$ee,$bb,$ee,$bb,$ff ; Tile one: custom stone.
!fill $2800-*,0           ; Reserve full 2K charset, including unused glyphs.
* = $3000
person:
!byte $00,$55,$00 ; 000011110000 pairs 0 transparent 1 white 2 red 3 yellow
!byte $01,$a9,$00 ; 000122210000 pairs 0 transparent 1 white 2 red 3 yellow
!byte $01,$a9,$00 ; 000122210000 pairs 0 transparent 1 white 2 red 3 yellow
!byte $00,$55,$00 ; 000011110000 pairs 0 transparent 1 white 2 red 3 yellow
!byte $00,$ff,$00 ; 000033330000 pairs 0 transparent 1 white 2 red 3 yellow
!byte $07,$ff,$d0 ; 001333333100 pairs 0 transparent 1 white 2 red 3 yellow
!byte $1f,$ff,$f4 ; 013333333310 pairs 0 transparent 1 white 2 red 3 yellow
!byte $1f,$ff,$f4 ; 013333333310 pairs 0 transparent 1 white 2 red 3 yellow
!byte $13,$ff,$04 ; 010333330010 pairs 0 transparent 1 white 2 red 3 yellow
!byte $03,$ff,$00 ; 000333330000 pairs 0 transparent 1 white 2 red 3 yellow
!byte $03,$ff,$00 ; 000333330000 pairs 0 transparent 1 white 2 red 3 yellow
!byte $03,$ff,$00 ; 000333330000 pairs 0 transparent 1 white 2 red 3 yellow
!byte $01,$55,$00 ; 000111110000 pairs 0 transparent 1 white 2 red 3 yellow
!byte $01,$45,$00 ; 000110110000 pairs 0 transparent 1 white 2 red 3 yellow
!byte $01,$45,$00 ; 000110110000 pairs 0 transparent 1 white 2 red 3 yellow
!byte $01,$45,$00 ; 000110110000 pairs 0 transparent 1 white 2 red 3 yellow
!byte $01,$45,$00 ; 000110110000 pairs 0 transparent 1 white 2 red 3 yellow
!byte $01,$45,$00 ; 000110110000 pairs 0 transparent 1 white 2 red 3 yellow
!byte $05,$45,$40 ; 001110111000 pairs 0 transparent 1 white 2 red 3 yellow
!byte $05,$45,$40 ; 001110111000 pairs 0 transparent 1 white 2 red 3 yellow
!byte $00,$00,$00 ; 000000000000 pairs 0 transparent 1 white 2 red 3 yellow
!byte 0 ; Pad 63 visible bytes to a 64-byte sprite block.
ship:
!byte $00,$14,$00 ; 000001100000 pairs 0 transparent 1 white 2 red 3 yellow
!byte $00,$69,$00 ; 000012210000 pairs 0 transparent 1 white 2 red 3 yellow
!byte $00,$69,$00 ; 000012210000 pairs 0 transparent 1 white 2 red 3 yellow
!byte $01,$aa,$40 ; 000122221000 pairs 0 transparent 1 white 2 red 3 yellow
!byte $01,$aa,$40 ; 000122221000 pairs 0 transparent 1 white 2 red 3 yellow
!byte $06,$aa,$90 ; 001222222100 pairs 0 transparent 1 white 2 red 3 yellow
!byte $06,$be,$90 ; 001223322100 pairs 0 transparent 1 white 2 red 3 yellow
!byte $1a,$be,$a4 ; 012223322210 pairs 0 transparent 1 white 2 red 3 yellow
!byte $1a,$be,$a4 ; 012223322210 pairs 0 transparent 1 white 2 red 3 yellow
!byte $6a,$aa,$a9 ; 122222222221 pairs 0 transparent 1 white 2 red 3 yellow
!byte $6a,$aa,$a9 ; 122222222221 pairs 0 transparent 1 white 2 red 3 yellow
!byte $55,$aa,$55 ; 111122221111 pairs 0 transparent 1 white 2 red 3 yellow
!byte $01,$aa,$40 ; 000122221000 pairs 0 transparent 1 white 2 red 3 yellow
!byte $01,$ff,$40 ; 000133331000 pairs 0 transparent 1 white 2 red 3 yellow
!byte $00,$ff,$00 ; 000033330000 pairs 0 transparent 1 white 2 red 3 yellow
!byte $00,$3c,$00 ; 000003300000 pairs 0 transparent 1 white 2 red 3 yellow
!byte $00,$00,$00 ; 000000000000 pairs 0 transparent 1 white 2 red 3 yellow
!byte $00,$00,$00 ; 000000000000 pairs 0 transparent 1 white 2 red 3 yellow
!byte $00,$00,$00 ; 000000000000 pairs 0 transparent 1 white 2 red 3 yellow
!byte $00,$00,$00 ; 000000000000 pairs 0 transparent 1 white 2 red 3 yellow
!byte $00,$00,$00 ; 000000000000 pairs 0 transparent 1 white 2 red 3 yellow
!byte 0 ; Pad 63 visible bytes to a 64-byte sprite block.
