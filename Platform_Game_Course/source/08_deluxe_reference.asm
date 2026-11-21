; WHAT: Acceleration, variable jump height, walls, a ceiling, collectibles, a hazard and a moving platform. LEFT/RIGHT move; FIRE jumps; UP+FIRE toggles pause.
; WHY: Bring variable jumping, solid objects, moving support and collectibles together on one screen.
; HOW: Run input, horizontal motion, support, jump, gravity, events and animation in a deliberate frame order, with pause handled before play updates.

; C64 Platform Game Course - independent PAL C64 example
; Build with scripts/build_all.py; reset machine to exit.
; ================================================================
; PLATFORM DELUXE - C64 6510 / ACME teaching demonstration
; ================================================================
; Build: acme -f cbm -o build/08_deluxe_reference.prg source/08_deluxe_reference.asm
; Run: LOAD "08_DELUXE_REFERENCE.PRG",8,1 : RUN
; Controls: joystick port 2 LEFT/RIGHT, FIRE = jump, UP+FIRE = pause
;
; WHAT: software-controlled platform physics with animated hardware sprite
; WHY: VIC-II collision latches do not report a safe landing surface
; HOW: old-feet/new-feet crossing + horizontal overlap + snap-to-top
;
; Single-screen platform movement and events. Read README.md for the program controls.
; All coordinates below are VIC-II sprite coordinates, NOT screen columns.
; X restricted to 28..220, Y 54..226, to keep 8-bit calculations safe.
;
*=$0801
!byte $0b,$08,$0a,$00,$9e,$32,$30,$36,$34,$00,$00,$00
*=$0810

; Private zero page: BASIC/KERNAL scanning is disabled; reset to exit.
PX=$80           ; player sprite left X
PY=$81           ; player sprite top Y
VX=$82           ; horizontal velocity, signed: -3..+3
VY=$83           ; vertical velocity, signed: -7..+5
GROUNDED=$84     ; 1 if standing on a surface
OLD_FEET=$85     ; feet before gravity/movement
NEW_FEET=$86     ; feet after gravity/movement
OLD_HEAD=$87     ; top of player before movement
TICK=$88         ; frame counter
JOY=$89          ; cached joystick input
ANIM=$8a         ; animation timer
FACE=$8b         ; 0 left, 1 right
PLATX=$8c        ; moving platform sprite X
PLATDIR=$8d      ; 0 left, 1 right
PLATOLD=$8e      ; old moving platform X
SUPPORT=$8f      ; 0 none, 1 fixed, 2 moving
SCORE=$90        ; number of collected items, 0..3
ITEMS=$91        ; bit mask: bit=1 means collected
PAUSED=$92       ; 1 when paused
KEYOLD=$93       ; previous pause-combo status
PREVX=$94        ; player X before horizontal movement
FIREOLD=$98      ; previous FIRE state for one-jump-per-press
TEMP=$95

SCREEN=$0400
COLOR=$d800
PLAYER_W=16       ; physics footprint narrower than 24-pixel sprite image
PLAYER_H=21

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
    lda #0 ; Load A with constant 0.
    sta $d015        ; hide all sprites during setup
    sta $d01b        ; sprite foreground priority
    sta $d017        ; no vertical expansion
    sta $d01d        ; no horizontal expansion
    sta $d010        ; all sprite X high bits zero
    lda #6 ; Load A with constant 6.
    sta $d020        ; blue border
    lda #0 ; Load A with constant 0.
    sta $d021        ; black background
    lda #$20 ; Load A with constant $20.
    ldx #0 ; Load X with constant 0.
clear_screen:
    sta $0400,x ; Write A to $0400,x.
    sta $0500,x ; Write A to $0500,x.
    sta $0600,x ; Write A to $0600,x.
    sta $0700,x ; Write A to $0700,x.
    inx ; Advance the X index by one.
    bne clear_screen ; Continue at clear_screen when the result is nonzero.
    lda #1 ; Load A with constant 1.
    ldx #0 ; Load X with constant 0.
clear_color:
    sta $d800,x ; Write A to $d800,x.
    sta $d900,x ; Write A to $d900,x.
    sta $da00,x ; Write A to $da00,x.
    sta $db00,x ; Write A to $db00,x.
    inx ; Advance the X index by one.
    bne clear_color ; Continue at clear_color when the result is nonzero.
    jsr draw_level ; Call draw_level; the routine returns with RTS.
    jsr draw_hud ; Call draw_hud; the routine returns with RTS.

    ; Sprite 0: player; sprite 1: moving platform.
    ; Sprite pointers are bank-relative 64-byte block numbers.
    lda #player_idle / 64 ; Load A with constant player_idle / 64.
    sta $07f8 ; Write A to $07f8.
    lda #platform_sprite / 64 ; Load A with constant platform_sprite / 64.
    sta $07f9 ; Write A to $07f9.
    lda #$01 ; Load A with constant $01.
    sta $d01c        ; player uses multicolour; platform hires
    lda #10 ; Load A with constant 10.
    sta $d025        ; shared sprite colour 1 = light red
    lda #6 ; Load A with constant 6.
    sta $d026        ; shared sprite colour 2 = blue
    lda #2 ; Load A with constant 2.
    sta $d027        ; player individual colour = red
    lda #5 ; Load A with constant 5.
    sta $d028        ; platform green
    lda #3 ; Load A with constant 3.
    sta $d015        ; enable sprites 0 and 1
    lda #114 ; Load A with constant 114.
    sta $d003        ; moving platform top
    jsr reset_player ; Call reset_player; the routine returns with RTS.
    lda #170 ; Load A with constant 170.
    sta PLATX ; Write A to PLATX.
    sta $d002 ; Write A to $d002.
    lda #1 ; Load A with constant 1.
    sta PLATDIR ; Write A to PLATDIR.
    lda #0 ; Load A with constant 0.
    sta TICK ; Write A to TICK.
    sta ANIM ; Write A to ANIM.
    sta SCORE ; Write A to SCORE.
    sta ITEMS ; Write A to ITEMS.
    sta PAUSED ; Write A to PAUSED.
    sta KEYOLD ; Write A to KEYOLD.
    sta FIREOLD ; Write A to FIREOLD.
    jsr update_score ; Call update_score; the routine returns with RTS.


main:
    ; Wait for raster 250, then wait until it changes.
    ; This yields approximately one update per PAL video frame.
wait_frame:
    lda $d012 ; Load A with raster comparator.
    cmp #250 ; Compare A with #250; retain A and update flags.
    bne wait_frame ; Continue at wait_frame when the result is nonzero.
wait_frame_end:
    lda $d012 ; Load A with raster comparator.
    cmp #250 ; Compare A with #250; retain A and update flags.
    beq wait_frame_end ; Continue at wait_frame_end when the result is zero.
    inc TICK ; Increase TICK by one.
    lda $dc00 ; Load A with CIA1 joystick and matrix port.
    sta JOY ; Write A to JOY.
    jsr poll_pause ; Call poll_pause; the routine returns with RTS.
    lda PAUSED ; Load A with PAUSED.
    beq run_frame ; Continue at run_frame when the result is zero.
    jmp main ; Continue at main without pushing a return address.
run_frame:
    jsr move_platform ; Call move_platform; the routine returns with RTS.
    jsr read_horizontal ; Call read_horizontal; the routine returns with RTS.
    jsr check_support ; Call check_support; the routine returns with RTS.
    jsr try_jump ; Call try_jump; the routine returns with RTS.
    jsr apply_gravity ; Call apply_gravity; the routine returns with RTS.
    jsr check_items ; Call check_items; the routine returns with RTS.
    jsr check_hazard ; Call check_hazard; the routine returns with RTS.
    jsr animate_player ; Call animate_player; the routine returns with RTS.
    lda PX ; Load A with PX.
    sta $d000 ; Write A to $d000.
    lda PY ; Load A with PY.
    sta $d001 ; Write A to $d001.
    jmp main ; Continue at main without pushing a return address.

reset_player:
    lda #72 ; Load A with constant 72.
    sta PX ; Write A to PX.
    lda #125            ; feet 146 = first fixed platform top
    sta PY ; Write A to PY.
    lda #0 ; Load A with constant 0.
    sta VX ; Write A to VX.
    sta VY ; Write A to VY.
    lda #1 ; Load A with constant 1.
    sta GROUNDED ; Write A to GROUNDED.
    sta SUPPORT ; Write A to SUPPORT.
    rts ; Return to the instruction after the caller JSR.

; ---------------------------------------------------------------
; Input and horizontal acceleration/friction
; WHAT: ramp VX up/down rather than jumping instantly to +/-3
; WHY: smoother starts and stops
; HOW: accelerate one step every fourth video frame
; ---------------------------------------------------------------
read_horizontal:
    lda PX ; Load A with PX.
    sta PREVX ; Write A to PREVX.
    lda TICK ; Load A with TICK.
    and #3 ; Keep only the bits selected by #3.
    bne horizontal_move ; Continue at horizontal_move when the result is nonzero.
    lda JOY ; Load A with JOY.
    and #%00000100   ; left active low
    bne test_right ; Continue at test_right when the result is nonzero.
    lda #0 ; Load A with constant 0.
    sta FACE ; Write A to FACE.
    lda VX ; Load A with VX.
    cmp #$fd          ; -3
    beq horizontal_move ; Continue at horizontal_move when the result is zero.
    dec VX ; Decrease VX by one.
    jmp horizontal_move ; Continue at horizontal_move without pushing a return address.
test_right:
    lda JOY ; Load A with JOY.
    and #%00001000   ; right active low
    bne friction ; Continue at friction when the result is nonzero.
    lda #1 ; Load A with constant 1.
    sta FACE ; Write A to FACE.
    lda VX ; Load A with VX.
    cmp #3 ; Compare A with #3; retain A and update flags.
    beq horizontal_move ; Continue at horizontal_move when the result is zero.
    inc VX ; Increase VX by one.
    jmp horizontal_move ; Continue at horizontal_move without pushing a return address.
friction:
    lda VX ; Load A with VX.
    beq horizontal_move ; Continue at horizontal_move when the result is zero.
    bmi friction_negative ; Continue at friction_negative when bit 7 is set.
    dec VX ; Decrease VX by one.
    jmp horizontal_move ; Continue at horizontal_move without pushing a return address.
friction_negative:
    inc VX ; Increase VX by one.
horizontal_move:
    clc ; Clear carry before a new addition.
    lda PX ; Load A with PX.
    adc VX ; Add VX and carry to A; propagate overflow.
    sta PX ; Write A to PX.
    cmp #28 ; Compare A with #28; retain A and update flags.
    bcs check_right_limit ; Continue at check_right_limit when carry is set.
    lda #28 ; Load A with constant 28.
    sta PX ; Write A to PX.
    lda #0 ; Load A with constant 0.
    sta VX ; Write A to VX.
check_right_limit:
    lda PX ; Load A with PX.
    cmp #221 ; Compare A with #221; retain A and update flags.
    bcc check_walls ; Continue at check_walls when carry is clear.
    lda #220 ; Load A with constant 220.
    sta PX ; Write A to PX.
    lda #0 ; Load A with constant 0.
    sta VX ; Write A to VX.
check_walls:
    jsr solid_wall_overlap ; Call solid_wall_overlap; the routine returns with RTS.
    bcc horizontal_done ; Continue at horizontal_done when carry is clear.
    lda PREVX ; Load A with PREVX.
    sta PX ; Write A to PX.
    lda #0 ; Load A with constant 0.
    sta VX ; Write A to VX.
horizontal_done:
    rts ; Return to the instruction after the caller JSR.

; ---------------------------------------------------------------
; Ground support: if feet no longer overlap, begin falling.
; ---------------------------------------------------------------
check_support:
    lda GROUNDED ; Load A with GROUNDED.
    bne check_support_now ; Continue at check_support_now when the result is nonzero.
    rts ; Return to the instruction after the caller JSR.
check_support_now:
    lda #0 ; Load A with constant 0.
    sta SUPPORT ; Write A to SUPPORT.
    lda PY ; Load A with PY.
    clc ; Clear carry before a new addition.
    adc #PLAYER_H ; Add #PLAYER_H and carry to A; propagate overflow.
    sta TEMP ; Write A to TEMP.
    ldx #0 ; Load X with constant 0.
support_fixed_loop:
    lda TEMP ; Load A with TEMP.
    cmp platform_top,x ; Compare A with platform_top,x; retain A and update flags.
    bne support_fixed_next ; Continue at support_fixed_next when the result is nonzero.
    jsr overlap_fixed ; Call overlap_fixed; the routine returns with RTS.
    bcc support_fixed_next ; Continue at support_fixed_next when carry is clear.
    lda #1 ; Load A with constant 1.
    sta SUPPORT ; Write A to SUPPORT.
    jmp support_done ; Continue at support_done without pushing a return address.
support_fixed_next:
    inx ; Advance the X index by one.
    cpx #3 ; Compare X with #3; update flags.
    bne support_fixed_loop ; Continue at support_fixed_loop when the result is nonzero.
    lda TEMP ; Load A with TEMP.
    cmp #114 ; Compare A with #114; retain A and update flags.
    bne support_done ; Continue at support_done when the result is nonzero.
    jsr overlap_moving ; Call overlap_moving; the routine returns with RTS.
    bcc support_done ; Continue at support_done when carry is clear.
    lda #2 ; Load A with constant 2.
    sta SUPPORT ; Write A to SUPPORT.
support_done:
    lda SUPPORT ; Load A with SUPPORT.
    bne supported_yes ; Continue at supported_yes when the result is nonzero.
    lda #0 ; Load A with constant 0.
    sta GROUNDED ; Write A to GROUNDED.
supported_yes:
    rts ; Return to the instruction after the caller JSR.

try_jump:
    ; FIRE is active low. Detect the transition from released to held.
    ; This avoids automatic re-jumping when FIRE remains held.
    lda JOY ; Load A with JOY.
    and #%00010000 ; Keep only the bits selected by #%00010000.
    beq fire_held ; Continue at fire_held when the result is zero.
    lda #0 ; Load A with constant 0.
    sta FIREOLD ; Write A to FIREOLD.
    rts ; Return to the instruction after the caller JSR.
fire_held:
    lda FIREOLD ; Load A with FIREOLD.
    beq fresh_fire ; Continue at fresh_fire when the result is zero.
    rts ; Return to the instruction after the caller JSR.
fresh_fire:
    lda #1 ; Load A with constant 1.
    sta FIREOLD ; Write A to FIREOLD.
    lda JOY ; Load A with JOY.
    and #1           ; UP held? then this is pause combo, not jump
    beq no_jump_combo ; Continue at no_jump_combo when the result is zero.
    lda GROUNDED ; Load A with GROUNDED.
    bne jump_now ; Continue at jump_now when the result is nonzero.
    rts ; Return to the instruction after the caller JSR.
no_jump_combo:
    rts ; Return to the instruction after the caller JSR.
jump_now:
    lda #$f9          ; -7 in signed two's complement
    sta VY ; Write A to VY.
    lda #0 ; Load A with constant 0.
    sta GROUNDED ; Write A to GROUNDED.
    sta SUPPORT ; Write A to SUPPORT.
    rts ; Return to the instruction after the caller JSR.

; ---------------------------------------------------------------
; Gravity, variable jump, landing and ceiling collisions.
; ---------------------------------------------------------------
apply_gravity:
    lda GROUNDED ; Load A with GROUNDED.
    beq airborne_now ; Continue at airborne_now when the result is zero.
    rts ; Return to the instruction after the caller JSR.
airborne_now:
    lda PY ; Load A with PY.
    sta OLD_HEAD ; Write A to OLD_HEAD.
    clc ; Clear carry before a new addition.
    adc #PLAYER_H ; Add #PLAYER_H and carry to A; propagate overflow.
    sta OLD_FEET ; Write A to OLD_FEET.

    ; Variable jump: releasing FIRE while rising cuts upward speed.
    lda VY ; Load A with VY.
    bpl gravity_tick ; Continue at gravity_tick when bit 7 is clear.
    lda JOY ; Load A with JOY.
    and #%00010000 ; Keep only the bits selected by #%00010000.
    beq gravity_tick ; Continue at gravity_tick when the result is zero.
    lda VY ; Load A with VY.
    cmp #$fd          ; -3
    bcs gravity_tick ; Continue at gravity_tick when carry is set.
    lda #$fd ; Load A with constant $fd.
    sta VY ; Write A to VY.
gravity_tick:
    lda TICK ; Load A with TICK.
    and #3 ; Keep only the bits selected by #3.
    bne move_vertical ; Continue at move_vertical when the result is nonzero.
    lda VY ; Load A with VY.
    cmp #5 ; Compare A with #5; retain A and update flags.
    beq move_vertical ; Continue at move_vertical when the result is zero.
    clc ; Clear carry before a new addition.
    adc #1 ; Add #1 and carry to A; propagate overflow.
    sta VY ; Write A to VY.
move_vertical:
    clc ; Clear carry before a new addition.
    lda PY ; Load A with PY.
    adc VY ; Add VY and carry to A; propagate overflow.
    sta PY ; Write A to PY.
    lda VY ; Load A with VY.
    bmi moving_up ; Continue at moving_up when bit 7 is set.
    jmp moving_down ; Continue at moving_down without pushing a return address.
moving_up:
    lda PY ; Load A with PY.
    cmp #54 ; Compare A with #54; retain A and update flags.
    bcs ceiling_objects ; Continue at ceiling_objects when carry is set.
    lda #54 ; Load A with constant 54.
    sta PY ; Write A to PY.
    lda #0 ; Load A with constant 0.
    sta VY ; Write A to VY.
ceiling_objects:
    ; Fixed solid ceiling: [144,200) X, underside Y=106.
    ; Rising player head crosses from >=106 to <106.
    lda OLD_HEAD ; Load A with OLD_HEAD.
    cmp #106 ; Compare A with #106; retain A and update flags.
    bcs long_branch_0_401 ; Continue at long_branch_0_401 when carry is set.
    jmp vertical_done ; Continue at vertical_done without pushing a return address.
long_branch_0_401:
    lda PY ; Load A with PY.
    cmp #106 ; Compare A with #106; retain A and update flags.
    bcs vertical_done ; Continue at vertical_done when carry is set.
    lda PX ; Load A with PX.
    cmp #200 ; Compare A with #200; retain A and update flags.
    bcs vertical_done ; Continue at vertical_done when carry is set.
    clc ; Clear carry before a new addition.
    adc #PLAYER_W ; Add #PLAYER_W and carry to A; propagate overflow.
    cmp #144 ; Compare A with #144; retain A and update flags.
    bcc vertical_done ; Continue at vertical_done when carry is clear.
    beq vertical_done ; Continue at vertical_done when the result is zero.
    lda #106 ; Load A with constant 106.
    sta PY ; Write A to PY.
    lda #0 ; Load A with constant 0.
    sta VY ; Write A to VY.
    jmp vertical_done ; Continue at vertical_done without pushing a return address.
moving_down:
    lda PY ; Load A with PY.
    clc ; Clear carry before a new addition.
    adc #PLAYER_H ; Add #PLAYER_H and carry to A; propagate overflow.
    sta NEW_FEET ; Write A to NEW_FEET.
    ldx #0 ; Load X with constant 0.
landing_fixed_loop:
    lda OLD_FEET ; Load A with OLD_FEET.
    cmp platform_top,x ; Compare A with platform_top,x; retain A and update flags.
    bcc fixed_old_ok ; Continue at fixed_old_ok when carry is clear.
    beq fixed_old_ok ; Continue at fixed_old_ok when the result is zero.
    jmp landing_fixed_next ; Continue at landing_fixed_next without pushing a return address.
fixed_old_ok:
    lda NEW_FEET ; Load A with NEW_FEET.
    cmp platform_top,x ; Compare A with platform_top,x; retain A and update flags.
    bcc landing_fixed_next ; Continue at landing_fixed_next when carry is clear.
    jsr overlap_fixed ; Call overlap_fixed; the routine returns with RTS.
    bcc landing_fixed_next ; Continue at landing_fixed_next when carry is clear.
    lda platform_top,x ; Load A with platform_top,x.
    sec ; Set carry before subtraction.
    sbc #PLAYER_H ; Subtract #PLAYER_H from A using carry as no borrow.
    sta PY ; Write A to PY.
    jsr landed_fixed ; Call landed_fixed; the routine returns with RTS.
    jmp vertical_done ; Continue at vertical_done without pushing a return address.
landing_fixed_next:
    inx ; Advance the X index by one.
    cpx #3 ; Compare X with #3; update flags.
    bne landing_fixed_loop ; Continue at landing_fixed_loop when the result is nonzero.
    lda OLD_FEET ; Load A with OLD_FEET.
    cmp #115 ; Compare A with #115; retain A and update flags.
    bcs check_bottom ; Continue at check_bottom when carry is set.
    lda NEW_FEET ; Load A with NEW_FEET.
    cmp #114 ; Compare A with #114; retain A and update flags.
    bcc check_bottom ; Continue at check_bottom when carry is clear.
    jsr overlap_moving ; Call overlap_moving; the routine returns with RTS.
    bcc check_bottom ; Continue at check_bottom when carry is clear.
    lda #93           ; 114 - PLAYER_H
    sta PY ; Write A to PY.
    lda #0 ; Load A with constant 0.
    sta VY ; Write A to VY.
    lda #1 ; Load A with constant 1.
    sta GROUNDED ; Write A to GROUNDED.
    lda #2 ; Load A with constant 2.
    sta SUPPORT ; Write A to SUPPORT.
    jmp vertical_done ; Continue at vertical_done without pushing a return address.
check_bottom:
    lda PY ; Load A with PY.
    cmp #226 ; Compare A with #226; retain A and update flags.
    bcc vertical_done ; Continue at vertical_done when carry is clear.
    jsr reset_player ; Call reset_player; the routine returns with RTS.
vertical_done:
    rts ; Return to the instruction after the caller JSR.
landed_fixed:
    lda #0 ; Load A with constant 0.
    sta VY ; Write A to VY.
    lda #1 ; Load A with constant 1.
    sta GROUNDED ; Write A to GROUNDED.
    sta SUPPORT ; Write A to SUPPORT.
    rts ; Return to the instruction after the caller JSR.

; AABB X overlap: player [PX,PX+16), platform [left,right).
overlap_fixed:
    lda PX ; Load A with PX.
    cmp platform_right,x ; Compare A with platform_right,x; retain A and update flags.
    bcs fixed_no ; Continue at fixed_no when carry is set.
    clc ; Clear carry before a new addition.
    adc #PLAYER_W ; Add #PLAYER_W and carry to A; propagate overflow.
    cmp platform_left,x ; Compare A with platform_left,x; retain A and update flags.
    bcc fixed_no ; Continue at fixed_no when carry is clear.
    beq fixed_no ; Continue at fixed_no when the result is zero.
    sec ; Set carry before subtraction.
    rts ; Return to the instruction after the caller JSR.
fixed_no:
    clc ; Clear carry before a new addition.
    rts ; Return to the instruction after the caller JSR.

overlap_moving:
    lda PX ; Load A with PX.
    clc ; Clear carry before a new addition.
    adc #PLAYER_W ; Add #PLAYER_W and carry to A; propagate overflow.
    cmp PLATX ; Compare A with PLATX; retain A and update flags.
    bcc moving_no ; Continue at moving_no when carry is clear.
    beq moving_no ; Continue at moving_no when the result is zero.
    lda PLATX ; Load A with PLATX.
    clc ; Clear carry before a new addition.
    adc #24 ; Add #24 and carry to A; propagate overflow.
    cmp PX ; Compare A with PX; retain A and update flags.
    bcc moving_no ; Continue at moving_no when carry is clear.
    beq moving_no ; Continue at moving_no when the result is zero.
    sec ; Set carry before subtraction.
    rts ; Return to the instruction after the caller JSR.
moving_no:
    clc ; Clear carry before a new addition.
    rts ; Return to the instruction after the caller JSR.

; Solid side wall AABB. Two narrow columns of level geometry.
solid_wall_overlap:
    ldx #0 ; Load X with constant 0.
wall_loop:
    lda PX ; Load A with PX.
    cmp wall_right,x ; Compare A with wall_right,x; retain A and update flags.
    bcs wall_next ; Continue at wall_next when carry is set.
    clc ; Clear carry before a new addition.
    adc #PLAYER_W ; Add #PLAYER_W and carry to A; propagate overflow.
    cmp wall_left,x ; Compare A with wall_left,x; retain A and update flags.
    bcc wall_next ; Continue at wall_next when carry is clear.
    beq wall_next ; Continue at wall_next when the result is zero.
    lda PY ; Load A with PY.
    cmp wall_bottom,x ; Compare A with wall_bottom,x; retain A and update flags.
    bcs wall_next ; Continue at wall_next when carry is set.
    clc ; Clear carry before a new addition.
    adc #PLAYER_H ; Add #PLAYER_H and carry to A; propagate overflow.
    cmp wall_top,x ; Compare A with wall_top,x; retain A and update flags.
    bcc wall_next ; Continue at wall_next when carry is clear.
    beq wall_next ; Continue at wall_next when the result is zero.
    sec ; Set carry before subtraction.
    rts ; Return to the instruction after the caller JSR.
wall_next:
    inx ; Advance the X index by one.
    cpx #2 ; Compare X with #2; update flags.
    bne wall_loop ; Continue at wall_loop when the result is nonzero.
    clc ; Clear carry before a new addition.
    rts ; Return to the instruction after the caller JSR.

; ---------------------------------------------------------------
; Moving platform: moves +/-1 every fourth frame; carries rider.
; ---------------------------------------------------------------
move_platform:
    lda TICK ; Load A with TICK.
    and #3 ; Keep only the bits selected by #3.
    bne moving_draw ; Continue at moving_draw when the result is nonzero.
    lda PLATX ; Load A with PLATX.
    sta PLATOLD ; Write A to PLATOLD.
    lda PLATDIR ; Load A with PLATDIR.
    beq platform_go_left ; Continue at platform_go_left when the result is zero.
    inc PLATX ; Increase PLATX by one.
    lda PLATX ; Load A with PLATX.
    cmp #195 ; Compare A with #195; retain A and update flags.
    bcc moving_carry ; Continue at moving_carry when carry is clear.
    lda #0 ; Load A with constant 0.
    sta PLATDIR ; Write A to PLATDIR.
    jmp moving_carry ; Continue at moving_carry without pushing a return address.
platform_go_left:
    dec PLATX ; Decrease PLATX by one.
    lda PLATX ; Load A with PLATX.
    cmp #151 ; Compare A with #151; retain A and update flags.
    bcs moving_carry ; Continue at moving_carry when carry is set.
    lda #1 ; Load A with constant 1.
    sta PLATDIR ; Write A to PLATDIR.
moving_carry:
    lda GROUNDED ; Load A with GROUNDED.
    beq moving_draw ; Continue at moving_draw when the result is zero.
    lda SUPPORT ; Load A with SUPPORT.
    cmp #2 ; Compare A with #2; retain A and update flags.
    bne moving_draw ; Continue at moving_draw when the result is nonzero.
    lda PLATX ; Load A with PLATX.
    cmp PLATOLD ; Compare A with PLATOLD; retain A and update flags.
    bcc carry_platform_left ; Continue at carry_platform_left when carry is clear.
    inc PX ; Increase PX by one.
    jmp moving_draw ; Continue at moving_draw without pushing a return address.
carry_platform_left:
    dec PX ; Decrease PX by one.
moving_draw:
    lda PLATX ; Load A with PLATX.
    sta $d002 ; Write A to $d002.
    rts ; Return to the instruction after the caller JSR.

; ---------------------------------------------------------------
; Collectibles: 3 simple coordinate-based pickups, one-time only.
; Collision boxes are 12x12, using player's top-left proximity.
; ---------------------------------------------------------------
check_items:
    ldx #0 ; Load X with constant 0.
item_loop:
    lda ITEMS ; Load A with ITEMS.
    and item_mask,x ; Keep only the bits selected by item_mask,x.
    bne item_next ; Continue at item_next when the result is nonzero.
    lda PX ; Load A with PX.
    cmp item_right,x ; Compare A with item_right,x; retain A and update flags.
    bcs item_next ; Continue at item_next when carry is set.
    clc ; Clear carry before a new addition.
    adc #PLAYER_W ; Add #PLAYER_W and carry to A; propagate overflow.
    cmp item_left,x ; Compare A with item_left,x; retain A and update flags.
    bcc item_next ; Continue at item_next when carry is clear.
    beq item_next ; Continue at item_next when the result is zero.
    lda PY ; Load A with PY.
    cmp item_bottom,x ; Compare A with item_bottom,x; retain A and update flags.
    bcs item_next ; Continue at item_next when carry is set.
    clc ; Clear carry before a new addition.
    adc #PLAYER_H ; Add #PLAYER_H and carry to A; propagate overflow.
    cmp item_top,x ; Compare A with item_top,x; retain A and update flags.
    bcc item_next ; Continue at item_next when carry is clear.
    beq item_next ; Continue at item_next when the result is zero.
    lda ITEMS ; Load A with ITEMS.
    ora item_mask,x ; Set bits selected by item_mask,x; retain other set bits.
    sta ITEMS ; Write A to ITEMS.
    inc SCORE ; Increase SCORE by one.
    ; WHAT: remove collected marker from the character screen.
    ; HOW: load its screen address from two parallel tables into $96/$97.
    ; Indirect indexed addressing ($96),Y then writes to that address.
    lda item_screen_low,x ; Load A with item_screen_low,x.
    sta $96 ; Write A to $96.
    lda item_screen_high,x ; Load A with item_screen_high,x.
    sta $97 ; Write A to $97.
    ldy #0 ; Load Y with constant 0.
    lda #$20 ; Load A with constant $20.
    sta ($96),y ; Write A to ($96),y.
    jsr update_score ; Call update_score; the routine returns with RTS.

item_next:
    inx ; Advance the X index by one.
    cpx #3 ; Compare X with #3; update flags.
    bne item_loop ; Continue at item_loop when the result is nonzero.
    rts ; Return to the instruction after the caller JSR.

; Hazard: rectangular red zone; touching it respawns the player.
check_hazard:
    lda PX ; Load A with PX.
    cmp #176 ; Compare A with #176; retain A and update flags.
    bcs hazard_done ; Continue at hazard_done when carry is set.
    clc ; Clear carry before a new addition.
    adc #PLAYER_W ; Add #PLAYER_W and carry to A; propagate overflow.
    cmp #160 ; Compare A with #160; retain A and update flags.
    bcc hazard_done ; Continue at hazard_done when carry is clear.
    beq hazard_done ; Continue at hazard_done when the result is zero.
    lda PY ; Load A with PY.
    cmp #218 ; Compare A with #218; retain A and update flags.
    bcs hazard_done ; Continue at hazard_done when carry is set.
    clc ; Clear carry before a new addition.
    adc #PLAYER_H ; Add #PLAYER_H and carry to A; propagate overflow.
    cmp #210 ; Compare A with #210; retain A and update flags.
    bcc hazard_done ; Continue at hazard_done when carry is clear.
    beq hazard_done ; Continue at hazard_done when the result is zero.
    jsr reset_player ; Call reset_player; the routine returns with RTS.
hazard_done:
    rts ; Return to the instruction after the caller JSR.

animate_player:
    lda GROUNDED ; Load A with GROUNDED.
    bne animation_ground ; Continue at animation_ground when the result is nonzero.
    lda #player_jump/64 ; Load A with constant player_jump/64.
    sta $07f8 ; Write A to $07f8.
    rts ; Return to the instruction after the caller JSR.
animation_ground:
    lda VX ; Load A with VX.
    bne animation_walk ; Continue at animation_walk when the result is nonzero.
    lda #player_idle/64 ; Load A with constant player_idle/64.
    sta $07f8 ; Write A to $07f8.
    rts ; Return to the instruction after the caller JSR.
animation_walk:
    lda TICK ; Load A with TICK.
    and #$08 ; Keep only the bits selected by #$08.
    beq animation_walk_a ; Continue at animation_walk_a when the result is zero.
    lda #player_walk_b/64 ; Load A with constant player_walk_b/64.
    sta $07f8 ; Write A to $07f8.
    rts ; Return to the instruction after the caller JSR.
animation_walk_a:
    lda #player_walk_a/64 ; Load A with constant player_walk_a/64.
    sta $07f8 ; Write A to $07f8.
    rts ; Return to the instruction after the caller JSR.

poll_pause:
    ; Pause shortcut = UP + FIRE simultaneously (joystick port 2).
    ; Avoid changing CIA keyboard matrix direction while reading joystick.
    lda JOY ; Load A with JOY.
    and #%00010001 ; Keep only the bits selected by #%00010001.
    bne combo_released ; Continue at combo_released when the result is nonzero.
    lda KEYOLD ; Load A with KEYOLD.
    bne pause_done ; Continue at pause_done when the result is nonzero.
    lda #1 ; Load A with constant 1.
    sta KEYOLD ; Write A to KEYOLD.
    lda PAUSED ; Load A with PAUSED.
    eor #1 ; Toggle A bits selected by #1.
    sta PAUSED ; Write A to PAUSED.
pause_done:
    rts ; Return to the instruction after the caller JSR.
combo_released:
    lda #0 ; Load A with constant 0.
    sta KEYOLD ; Write A to KEYOLD.
    rts ; Return to the instruction after the caller JSR.

update_score:
    ; Display a single decimal digit 0..3 using C64 screen codes.
    lda SCORE ; Load A with SCORE.
    clc ; Clear carry before a new addition.
    adc #48 ; Add #48 and carry to A; propagate overflow.
    sta $0430       ; row 1, col 8 (score digit)
    rts ; Return to the instruction after the caller JSR.

; Draw level with filled reverse-space characters.
draw_level:
    ldx #0 ; Load X with constant 0.
level_a:
    lda #$a0 ; Load A with constant $a0.
    sta $05e5,x      ; row12 col5, 9 cells
    lda #5 ; Load A with constant 5.
    sta $d9e5,x ; Write A to $d9e5,x.
    inx ; Advance the X index by one.
    cpx #9 ; Compare X with #9; update flags.
    bne level_a ; Continue at level_a when the result is nonzero.
    ldx #0 ; Load X with constant 0.
level_b:
    lda #$a0 ; Load A with constant $a0.
    sta $06be,x      ; row17 col14, 9 cells
    lda #7 ; Load A with constant 7.
    sta $dabe,x ; Write A to $dabe,x.
    inx ; Advance the X index by one.
    cpx #9 ; Compare X with #9; update flags.
    bne level_b ; Continue at level_b when the result is nonzero.
    ldx #0 ; Load X with constant 0.
level_c:
    lda #$a0 ; Load A with constant $a0.
    sta $074b,x      ; row21 col3, 22 cells
    lda #13 ; Load A with constant 13.
    sta $db4b,x ; Write A to $db4b,x.
    inx ; Advance the X index by one.
    cpx #22 ; Compare X with #22; update flags.
    bne level_c ; Continue at level_c when the result is nonzero.
    ; Solid wall blocks at known screen cells.
    lda #$a0 ; Load A with constant $a0.
    sta $0613 ; Write A to $0613.
    sta $063b ; Write A to $063b.
    sta $0663 ; Write A to $0663.
    sta $068b ; Write A to $068b.
    sta $06c1 ; Write A to $06c1.
    sta $06e9 ; Write A to $06e9.
    sta $0711 ; Write A to $0711.
    sta $0739 ; Write A to $0739.
    ; Ceiling above moving platform.
    sta $04ff ; Write A to $04ff.
    sta $0500 ; Write A to $0500.
    sta $0501 ; Write A to $0501.
    sta $0502 ; Write A to $0502.
    sta $0503 ; Write A to $0503.
    sta $0504 ; Write A to $0504.
    sta $0505 ; Write A to $0505.
    ; Hazard area, drawn as red reversed blocks.
    sta $0731 ; Write A to $0731.
    sta $0732 ; Write A to $0732.
    lda #2 ; Load A with constant 2.
    sta $db31 ; Write A to $db31.
    sta $db32 ; Write A to $db32.
    ; Collectible markers, simple coloured asterisks.
    lda #$2a ; Load A with constant $2a.
    sta $0598 ; Write A to $0598.
    sta $066a ; Write A to $066a.
    sta $0707 ; Write A to $0707.
    lda #7 ; Load A with constant 7.
    sta $d998 ; Write A to $d998.
    sta $da6a ; Write A to $da6a.
    sta $db07 ; Write A to $db07.
    rts ; Return to the instruction after the caller JSR.

draw_hud:
    ldx #0 ; Load X with constant 0.
hud_loop:
    lda hud_text,x ; Load A with hud_text,x.
    beq hud_done ; Continue at hud_done when the result is zero.
    sta $0428,x ; Write A to $0428,x.
    inx ; Advance the X index by one.
    bne hud_loop ; Continue at hud_loop when the result is nonzero.
hud_done:
    rts ; Return to the instruction after the caller JSR.

; Fixed platform collision rectangles (must match level artwork).
platform_left:  !byte 64,136,48
platform_right: !byte 136,208,224
platform_top:   !byte 146,186,218
wall_left:      !byte 112,224
wall_right:     !byte 120,232
wall_top:       !byte 154,186
wall_bottom:    !byte 186,218
item_left:      !byte 88,168,144
item_right:     !byte 100,180,156
item_top:       !byte 130,170,202
item_bottom:    !byte 142,182,214
item_mask:      !byte 1,2,4
item_screen_low: !byte <$0598,<$066a,<$0707
item_screen_high: !byte >$0598,>$066a,>$0707
hud_text:       !byte 19,3,15,18,5,32,32,32,0 ; SCORE   (digit at col9)

; 4 frames of 64-byte-aligned 24x21 multicolour sprites.
; Each contains 21 rows x 3 bytes, followed by 1 padding byte.
!if * > $2000 { !error "Code overlaps sprite area" }
*=$2000
!align 63,0
player_idle:
!byte $00,$aa,$00,$02,$aa,$80,$0a,$aa,$a0,$05,$55,$40
!byte $15,$55,$50,$15,$15,$10,$15,$55,$50,$05,$55,$40
!byte $02,$aa,$00,$0a,$ee,$80,$2a,$ff,$a0,$aa,$ff,$a8
!byte $5a,$ff,$a5,$16,$ff,$94,$03,$ff,$c0,$03,$ff,$c0
!byte $03,$c3,$c0,$03,$c3,$c0,$03,$c3,$c0,$03,$c3,$c0
!byte $0f,$c3,$f0,$00
!align 63,0
player_walk_a:
!byte $00,$aa,$00,$02,$aa,$80,$0a,$aa,$a0,$05,$55,$40
!byte $15,$55,$50,$15,$15,$10,$15,$55,$50,$05,$55,$40
!byte $02,$aa,$00,$0a,$ee,$80,$2a,$ff,$a0,$aa,$ff,$a8
!byte $5a,$ff,$a5,$16,$ff,$94,$03,$ff,$c0,$03,$ff,$c0
!byte $03,$c3,$c0,$03,$c3,$00,$03,$c0,$c0,$0f,$00,$c0
!byte $0f,$00,$f0,$00
!align 63,0
player_walk_b:
!byte $00,$aa,$00,$02,$aa,$80,$0a,$aa,$a0,$05,$55,$40
!byte $15,$55,$50,$15,$15,$10,$15,$55,$50,$05,$55,$40
!byte $02,$aa,$00,$0a,$ee,$80,$2a,$ff,$a0,$aa,$ff,$a8
!byte $5a,$ff,$a5,$16,$ff,$94,$03,$ff,$c0,$03,$ff,$c0
!byte $03,$c3,$c0,$00,$c3,$c0,$03,$03,$c0,$03,$00,$f0
!byte $0f,$00,$f0,$00
!align 63,0
player_jump:
!byte $00,$aa,$00,$02,$aa,$80,$0a,$aa,$a0,$05,$55,$40
!byte $15,$55,$50,$15,$15,$10,$15,$55,$50,$05,$55,$40
!byte $02,$aa,$00,$0a,$ee,$80,$2a,$ff,$a0,$aa,$ff,$a8
!byte $5a,$ff,$a5,$16,$ff,$94,$03,$ff,$c0,$03,$ff,$c0
!byte $0f,$c3,$f0,$0f,$c3,$f0,$03,$c3,$c0,$03,$c3,$c0
!byte $03,$c3,$c0,$00
!align 63,0
platform_sprite:
!byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
!fill 54,0
!byte 0
