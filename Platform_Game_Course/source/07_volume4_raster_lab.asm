; WHAT: A raster-IRQ frame signal, sprite animation and half-pixel motion. LEFT/RIGHT move. This lab has no tile-map renderer.
; WHY: Make the relationship between raster timing and fractional movement visible in a small experiment.
; HOW: A short raster IRQ sets a frame flag; the main loop consumes it and moves the player by half-pixel steps with carry and borrow.

; C64 Platform Game Course - independent PAL C64 example
; Build with scripts/build_all.py; reset machine to exit.
; VOLUME 4 LAB — raster IRQ, sprite frames, 8.8 motion, camera, coarse/fine scroll
; ACME assembly for a PAL raster example with frame signalling and fractional motion.
; Build: python3 scripts/build_all.py (from the release root)
; Run: LOAD"VOL4.PRG",8,1 : SYS 2064 (or drag PRG into VICE)
*=$0801
!byte $0b,$08,$0a,$00,$9e,$32,$30,$36,$34,$00,$00,$00
*=$0810
SCREEN=$0400
SPRITE_PTR=$07f8
D016=$d016
D015=$d015
D000=$d000
D001=$d001
D010=$d010
D027=$d027
CAMERA_MAX=192          ; 64 columns - 40 columns = 24*8 pixels

start:
    sei                 ; protect IRQ-vector setup
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
    sta $d020           ; black border
    sta $d021           ; black background
    lda #$01 ; Load A with constant $01.
    sta D015            ; enable sprite 0
    lda #$0e ; Load A with constant $0e.
    sta D027            ; light blue sprite
    lda #$80 ; Load A with constant $80.
    sta SPRITE_PTR      ; $80*64=$2000 sprite frame A
    lda #$00 ; Load A with constant $00.
    sta D010            ; sprite X high bit clear
    sta camera_x ; Write A to camera_x.
    sta camera_hi ; Write A to camera_hi.
    sta player_frac ; Write A to player_frac.
    sta player_world_hi ; Write A to player_world_hi.
    sta anim_counter ; Write A to anim_counter.
    sta frame_ready ; Write A to frame_ready.
    lda #$50 ; Load A with constant $50.
    sta player_world    ; world x=80
    lda #$90 ; Load A with constant $90.
    sta D001            ; sprite Y = 144
    jsr clear_screen ; Call clear_screen; the routine returns with RTS.
    jsr draw_status ; Call draw_status; the routine returns with RTS.
    lda #<irq_handler ; Load A with constant <irq_handler.
    sta $0314           ; low byte of KERNAL IRQ vector
    lda #>irq_handler ; Load A with constant >irq_handler.
    sta $0315 ; Write A to $0315.
    lda #$7f ; Load A with constant $7f.
    sta $dc0d           ; disable CIA1 IRQ sources temporarily
    lda $dc0d           ; acknowledge pending CIA1 flags
    lda #$01 ; Load A with constant $01.
    sta $d01a           ; enable VIC raster IRQ
    lda #$00 ; Load A with constant $00.
    sta $d012           ; raster line 0
    lda $d011 ; Load A with vertical control and raster high bit.
    and #$7f            ; raster high bit = 0
    sta $d011 ; Write A to vertical control and raster high bit.
    lda #$01 ; Load A with constant $01.
    sta $d019           ; acknowledge pending raster flag
    cli ; Allow the installed IRQ handler to run.


main_loop:
    lda frame_ready ; Load A with frame_ready.
    beq main_loop       ; wait for next raster IRQ
    sei ; Block maskable IRQ service during ownership changes.
    lda #0 ; Load A with constant 0.
    sta frame_ready ; Write A to frame_ready.
    cli ; Allow the installed IRQ handler to run.
    jsr move_player ; Call move_player; the routine returns with RTS.
    jsr update_camera ; Call update_camera; the routine returns with RTS.
    jsr update_sprite ; Call update_sprite; the routine returns with RTS.
    jsr apply_fine_scroll ; Call apply_fine_scroll; the routine returns with RTS.
    jmp main_loop ; Continue at main_loop without pushing a return address.

; IRQ does minimal work. Save CPU registers before changing A.
irq_handler:
    pha ; Save A on the stack.
    txa ; Copy X into A.
    pha ; Save A on the stack.
    tya ; Copy Y into A.
    pha ; Save A on the stack.
    lda #$01 ; Load A with constant $01.
    sta $d019           ; clear VIC raster IRQ latch
    lda #1 ; Load A with constant 1.
    sta frame_ready     ; signal one frame to main loop
    pla ; Restore A from the stack.
    tay ; Copy A to Y for indexed addressing.
    pla ; Restore A from the stack.
    tax ; Copy A to X for indexed addressing.
    pla ; Restore A from the stack.
    jmp $ea81           ; finish through KERNAL IRQ exit

; Port 2: bit 2 left and bit 3 right, active low.
; Integer and fractional player X form an 8.8 coordinate.
move_player:
    lda $dc00 ; Load A with CIA1 joystick and matrix port.
    and #%00000100 ; Keep only the bits selected by #%00000100.
    beq move_left ; Continue at move_left when the result is zero.
    lda $dc00 ; Load A with CIA1 joystick and matrix port.
    and #%00001000 ; Keep only the bits selected by #%00001000.
    beq move_right ; Continue at move_right when the result is zero.
    rts ; Return to the instruction after the caller JSR.
move_right:
    lda player_world ; Load A with player_world.
    cmp #255 ; Compare A with #255; retain A and update flags.
    beq movement_done ; Continue at movement_done when the result is zero.
    clc ; Clear carry before a new addition.
    lda player_frac ; Load A with player_frac.
    adc #$80            ; +0.5 pixel each frame
    sta player_frac ; Write A to player_frac.
    lda player_world ; Load A with player_world.
    adc #$00            ; add fractional carry
    sta player_world ; Write A to player_world.
    bcc movement_done ; Continue at movement_done when carry is clear.
    inc player_world_hi ; Increase player_world_hi by one.
movement_done:
    rts ; Return to the instruction after the caller JSR.
move_left:
    lda player_world ; Load A with player_world.
    ora player_frac ; Set bits selected by player_frac; retain other set bits.
    beq movement_done ; Continue at movement_done when the result is zero.
    sec ; Set carry before subtraction.
    lda player_frac ; Load A with player_frac.
    sbc #$80            ; -0.5 pixel each frame
    sta player_frac ; Write A to player_frac.
    lda player_world ; Load A with player_world.
    sbc #$00            ; subtract borrow
    sta player_world ; Write A to player_world.
    bcs movement_done ; Continue at movement_done when carry is set.
    dec player_world_hi ; Decrease player_world_hi by one.
    rts ; Return to the instruction after the caller JSR.

; Camera follows when player moves beyond world x=120.
; This compact lab clamps the player world to 0..255 and camera 0..192.
update_camera:
    lda player_world_hi ; Load A with player_world_hi.
    bne camera_far ; Continue at camera_far when the result is nonzero.
    lda player_world ; Load A with player_world.
    cmp #120 ; Compare A with #120; retain A and update flags.
    bcc camera_zero ; Continue at camera_zero when carry is clear.
    sec ; Set carry before subtraction.
    sbc #120 ; Subtract #120 from A using carry as no borrow.
    cmp #CAMERA_MAX ; Compare A with #CAMERA_MAX; retain A and update flags.
    bcc camera_store ; Continue at camera_store when carry is clear.
camera_far:
    lda #CAMERA_MAX ; Load A with constant CAMERA_MAX.
camera_store:
    sta camera_x ; Write A to camera_x.
    rts ; Return to the instruction after the caller JSR.
camera_zero:
    lda #0 ; Load A with constant 0.
    sta camera_x ; Write A to camera_x.
    rts ; Return to the instruction after the caller JSR.

; Screen X = world X - camera X + VIC sprite-screen origin (24).
; This lab keeps sprite X within the 8-bit range.
update_sprite:
    sec ; Set carry before subtraction.
    lda player_world ; Load A with player_world.
    sbc camera_x ; Subtract camera_x from A using carry as no borrow.
    clc ; Clear carry before a new addition.
    adc #24 ; Add #24 and carry to A; propagate overflow.
    sta D000 ; Write A to D000.
    inc anim_counter ; Increase anim_counter by one.
    lda anim_counter ; Load A with anim_counter.
    and #$0f            ; change frame every 16 updates
    bne sprite_done ; Continue at sprite_done when the result is nonzero.
    lda SPRITE_PTR ; Load A with SPRITE_PTR.
    eor #$01            ; toggle $80 / $81
    sta SPRITE_PTR ; Write A to SPRITE_PTR.
sprite_done:
    rts ; Return to the instruction after the caller JSR.

; $D016 bits 0..2 select fine X scroll; bit 3=0 masks edge columns.
; No edge-column renderer in this lab: it teaches register timing only.
apply_fine_scroll:
    lda camera_x ; Load A with camera_x.
    and #7 ; Keep only the bits selected by #7.
    eor #7 ; Toggle A bits selected by #7.
    sta fine_x ; Write A to fine_x.
    lda D016 ; Load A with D016.
    and #%11100000      ; retain upper mode bits; clear bits 0..4
    ora fine_x ; Set bits selected by fine_x; retain other set bits.
    sta D016 ; Write A to D016.
    rts ; Return to the instruction after the caller JSR.

clear_screen:
    lda #$20 ; Load A with constant $20.
    ldx #0 ; Load X with constant 0.
clear_loop:
    sta SCREEN,x ; Write A to SCREEN,x.
    sta SCREEN+250,x ; Write A to SCREEN+250,x.
    sta SCREEN+500,x ; Write A to SCREEN+500,x.
    sta SCREEN+750,x ; Write A to SCREEN+750,x.
    inx ; Advance the X index by one.
    cpx #250 ; Compare X with #250; update flags.
    bne clear_loop ; Continue at clear_loop when the result is nonzero.
    rts ; Return to the instruction after the caller JSR.

draw_status:
    ldx #0 ; Load X with constant 0.
status_loop:
    lda status_text,x ; Load A with status_text,x.
    beq status_done ; Continue at status_done when the result is zero.
    sta SCREEN,x ; Write A to SCREEN,x.
    inx ; Advance the X index by one.
    bne status_loop ; Continue at status_loop when the result is nonzero.
status_done:
    rts ; Return to the instruction after the caller JSR.

status_text:
    !byte 22,15,12,21,13,5,32,52,58,32,13,15,22,5,32,10,15,25,19,20,9,3,11,32,12,5,6,20,32,15,18,32,18,9,7,8,20
    !byte 0

frame_ready:      !byte 0
player_world:     !byte 0
player_world_hi:  !byte 0
player_frac:      !byte 0
camera_x:         !byte 0
camera_hi:        !byte 0
fine_x:           !byte 0
anim_counter:     !byte 0

; Each hardware sprite frame is 63 bytes + 1 padding byte.
; Data: 21 rows * 3 bytes, one-bit sprite, 24x21 pixels.
*=$2000
sprite_frame_a:
!byte $00,$18,$00,$00,$3c,$00,$00,$7e,$00
!byte $00,$ff,$00,$00,$ff,$00,$00,$7e,$00
!byte $00,$3c,$00,$00,$7e,$00,$00,$ff,$00
!byte $01,$ff,$80,$03,$ff,$c0,$03,$ff,$c0
!byte $03,$ff,$c0,$01,$ff,$80,$00,$ff,$00
!byte $00,$ff,$00,$01,$c3,$80,$03,$81,$c0
!byte $03,$00,$c0,$00,$00,$00,$00,$00,$00
!byte 0
sprite_frame_b:
!byte $00,$18,$00,$00,$3c,$00,$00,$7e,$00
!byte $00,$ff,$00,$00,$ff,$00,$00,$7e,$00
!byte $00,$3c,$00,$00,$7e,$00,$00,$ff,$00
!byte $01,$ff,$80,$03,$ff,$c0,$03,$ff,$c0
!byte $03,$ff,$c0,$01,$ff,$80,$00,$ff,$00
!byte $00,$ff,$00,$03,$c3,$00,$07,$81,$00
!byte $06,$00,$00,$00,$00,$00,$00,$00,$00
!byte 0
