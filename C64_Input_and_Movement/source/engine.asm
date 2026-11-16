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
    lda #$7f
    sta $dc0d             ; Disable CIA1 interrupt sources.
    sta $dd0d             ; Disable CIA2 interrupt sources.
    lda $dc0d             ; Read to acknowledge pending CIA interrupts.
    lda $dd0d
    lda #0
    sta $d01a             ; Disable VIC IRQs; frame loop polls the raster.
    sta $d015             ; Hide sprites until their data and position are ready.
    sta $d010             ; This bounded demonstration uses X below 256.
    sta $d017             ; Normal sprite height.
    sta $d01d             ; Normal sprite width.
    sta $d01b             ; Sprite in front of character graphics.
    lda $dd02
    ora #3
    sta $dd02             ; CIA2 bank selection pins must be outputs.
    lda $dd00
    and #$fc
    ora #3
    sta $dd00             ; Inverted bits 11 select VIC bank $0000.
    lda #$1b
    sta $d011             ; Text mode, display on, 25 rows, normal Y scroll.
    lda #$18
    sta $d016             ; Multicolour character mode and 40 columns.
    lda #$18
    sta $d018             ; Screen $0400, custom charset $2000.
    lda #0
    sta $d020             ; Black border.
    lda #6
    sta $d021             ; Blue background for transparent character pixels.
    lda #11
    sta $d022             ; Character pair 01 is dark grey.
    lda #15
    sta $d023             ; Character pair 10 is light grey.
    lda #1
    sta $d025             ; Sprite pair 01 is white, shared by all sprites.
    lda #7
    sta $d026             ; Sprite pair 11 is yellow, shared by all sprites.
    lda #2
    sta $d027             ; Sprite pair 10 is red, specific to sprite zero.
    lda #1
    sta $d01c             ; Enable multicolour for sprite zero.
    ldx #0
clear_screen:
    lda #0
    sta $0400,x           ; Character zero is an empty custom tile.
    sta $0500,x
    sta $0600,x
    sta $0700,x           ; Includes padding and pointers; set pointer afterwards.
    lda #13               ; Bit 3 enables multicolour; low 3 bits give green.
    sta $d800,x
    sta $d900,x
    sta $da00,x
    sta $db00,x
    inx
    bne clear_screen
    ldx #39
floor_tiles:
    lda #1
    sta $07c0,x           ; Row 24: $0400 + 24*40. Surface VIC Y=242.
    dex
    bpl floor_tiles
!if MODE = 2 {             ; Extra landing surface only in variable jump demo.
    ldx #9
ledge_tiles:
    lda #1
    sta $068a,x           ; Row 16, columns 10..19; top VIC Y=178.
    dex
    bpl ledge_tiles
}
!if MODE = 3 {
    lda #$c1              ; Ship data $3040 / 64 in VIC bank zero.
} else {
    lda #$c0              ; Actual person data is at $3000 / 64 = $c0.
}
    sta $07f8             ; Pointer zero in current screen matrix.
    lda #80
    sta xpos
    lda #221
    sta ypos              ; 221 + 21 pixel height meets floor at Y=242.
    lda #1
    sta grounded
    sta $d015             ; Show sprite only after setup.
main_loop:
    jsr wait_frame
    jsr controls          ; Produce active high actions and one-frame presses.
!if MODE = 0 {
    jsr direct_move
} else {
!if MODE = 3 {
    jsr ship_move
} else {
    jsr horizontal
    jsr jump_physics
}
}
    lda xpos
    sta $d000             ; Convert logical integer position to VIC coordinate.
    lda ypos
    sta $d001
    jmp main_loop
wait_frame:
    lda #250
wait_leave:
    cmp $d012             ; Leave current line first to prevent repeat updates.
    beq wait_leave
wait_enter:
    cmp $d012             ; Both PAL and NTSC contain raster line 250.
    bne wait_enter
    rts                   ; One update per video frame if work fits a frame.
controls:
    lda actions
    sta previous          ; Save previous normalized button state.
    lda #0
    sta $dc02             ; All port A pins input for joystick two reading.
    sta $dc03             ; All port B pins input for keyboard rows.
    lda $dc00
    eor #$ff              ; Hardware 0 means pressed; software wants 1.
    and #$1f              ; Up=1 down=2 left=4 right=8 fire=16.
    sta actions
    lda #0
    sta $dc00             ; Selected output pins will drive only LOW.
    lda #2
    sta $dc02             ; Select column 1 by making PA1 a low output.
    lda $dc01
    sta keys              ; Snapshot rows so all tests use the same scan.
    and #4                ; A is column 1 row 2.
    bne no_a
    lda actions
    ora #4
    sta actions
no_a:
    lda keys
    and #2                ; W is column 1 row 1.
    bne no_w
    lda actions
    ora #1
    sta actions
no_w:
    lda keys
    and #32               ; S is column 1 row 5.
    bne no_s
    lda actions
    ora #2
    sta actions
no_s:
    lda #4
    sta $dc02             ; Select column 2 for D, row 2.
    lda $dc01
    and #4
    bne no_d
    lda actions
    ora #8
    sta actions
no_d:
    lda #$80
    sta $dc02             ; Select column 7 for space, row 4.
    lda $dc01
    and #16
    bne no_space
    lda actions
    ora #16
    sta actions
no_space:
    lda #0
    sta $dc02             ; Release columns between frames.
    lda previous
    eor #$ff              ; NOT previous, restricted by next AND.
    and actions
    sta pressed           ; Current AND NOT previous detects a new press.
    rts
horizontal:
    lda actions
    and #12               ; Resolve opposite directions to neutral.
    cmp #4
    bne try_right
    lda xpos
    cmp #34
    bcc horizontal_done
    dec xpos              ; Two pixels per frame for platform characters.
    dec xpos
    rts
try_right:
    cmp #8
    bne horizontal_done
    lda xpos
    cmp #239
    bcs horizontal_done
    inc xpos
    inc xpos
horizontal_done:
    rts
direct_move:
    jsr horizontal
    lda actions
    and #3
    cmp #1
    bne direct_down
    lda ypos
    cmp #52
    bcc direct_done
    dec ypos
    dec ypos
    rts
direct_down:
    cmp #2
    bne direct_done
    lda ypos
    cmp #220
    bcs direct_done
    inc ypos
    inc ypos
direct_done:
    rts
jump_physics:
    lda ypos
    sta old_y             ; Previous top for crossing a one-way surface.
    lda grounded
    beq in_air
    lda pressed
    and #16               ; Fire starts once; holding cannot auto-jump.
    beq integrate
    lda #0
    sta grounded
    sta vylo
    lda #$fa
    sta vyhi              ; $fa00 = -6.0 pixels/frame, signed 8.8.
in_air:
!if MODE = 2 {
    lda actions
    and #16               ; Releasing fire shortens only the rising phase.
    bne integrate
    lda vyhi
    cmp #$fe              ; Signed velocities below -2 have high byte < $fe
    bcs integrate         ; Here we first exclude positive velocities below.
    bpl integrate         ; Positive high byte means falling; never cut it.
    lda #$fe
    sta vyhi
    lda #0
    sta vylo              ; Clamp upward speed to -2.0.
}
integrate:
    clc
    lda vylo
    adc #$40              ; Gravity = +0.25 pixels/frame squared.
    sta vylo
    lda vyhi
    adc #0                ; Carry propagates fractional overflow.
    sta vyhi
    bmi add_y
    cmp #6
    bcc add_y
    lda #6                ; Terminal falling speed +6.0.
    sta vyhi
    lda #0
    sta vylo
add_y:
    clc
    lda yfrac
    adc vylo
    sta yfrac
    lda ypos
    adc vyhi              ; Two's complement adds negative velocity too.
    sta ypos
    lda #0
    sta grounded          ; Walking off a ledge begins falling.
    lda vyhi
    bmi jump_done         ; Never land while travelling upward.
!if MODE = 2 {
    lda xpos
    cmp #81               ; Actor right = X+24; overlap platform [104,184).
    bcc check_floor
    cmp #184
    bcs check_floor
    lda old_y
    cmp #158              ; Previous top <=157: previous feet <=178.
    bcs check_floor
    lda ypos
    cmp #157              ; New feet reach/cross ledge surface Y=178.
    bcc check_floor
    lda #157
    jmp land
}
check_floor:
    lda ypos
    cmp #221
    bcc jump_done
    lda #221
land:
    sta ypos              ; Snap feet to surface, preventing penetration.
    lda #0
    sta yfrac
    sta vylo
    sta vyhi
    lda #1
    sta grounded
jump_done:
    rts
ship_move:
    lda actions
    and #12
    cmp #4
    bne ship_right
    lda vx
    cmp #$fc              ; Signed minimum -4.
    beq ship_vertical
    dec vx
    jmp ship_vertical
ship_right:
    cmp #8
    bne ship_drag
    lda vx
    cmp #4
    beq ship_vertical
    inc vx
    jmp ship_vertical
ship_drag:
    lda vx                ; No horizontal thrust: drag one unit toward zero.
    beq ship_vertical
    bmi drag_negative
    dec vx
    jmp ship_vertical
drag_negative:
    inc vx
ship_vertical:
    lda actions
    and #3
    cmp #1
    bne ship_down
    lda sy
    cmp #$fc
    beq ship_integrate
    dec sy
    jmp ship_integrate
ship_down:
    cmp #2
    bne ship_y_drag
    lda sy
    cmp #4
    beq ship_integrate
    inc sy
    jmp ship_integrate
ship_y_drag:
    lda sy
    beq ship_integrate
    bmi y_drag_negative
    dec sy
    jmp ship_integrate
y_drag_negative:
    inc sy
ship_integrate:
    clc
    lda xpos
    adc vx                ; Signed byte velocity; bounds prevent wraparound.
    cmp #32
    bcs check_x_max
    lda #32
    ldx #0
    stx vx
check_x_max:
    cmp #241
    bcc store_x
    lda #240
    ldx #0
    stx vx
store_x:
    sta xpos
    clc
    lda ypos
    adc sy
    cmp #50
    bcs check_y_max
    lda #50
    ldx #0
    stx sy
check_y_max:
    cmp #222
    bcc store_y
    lda #221
    ldx #0
    stx sy
store_y:
    sta ypos
    rts
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
