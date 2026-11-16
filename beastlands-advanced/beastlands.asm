; BEASTLANDS PAL C64 PARALLAX DEMO
; Assemble with acme -f cbm -o beastlands.prg beastlands.asm
; See Advanced C64 Parallax.docx for the raster schedule and graphics formats.
; ===========================================================================
; ===========================================================================
; All addresses are hexadecimal when prefixed with $. Screen rows are 0-based.
;
; CPU memory: $0400 screen, $0801 BASIC, $080d code/data, $2000 charset,
;             $2800 white runner masks, $3000 blue masks, $4000 world maps.
; VIC bank: $0000-$3fff. Maps at $4000 are CPU data, not VIC display memory.
; No ROM routines run after startup. IRQ/NMI vectors use RAM under the KERNAL.
; Mainline does nothing: each frame's work is owned by the raster IRQ chain.
; Reset to exit. PAL only; CPU tests do not replace VIC-II timing validation.
!cpu 6510
 
;!to "beastlands.prg",cbm
; BASIC needs a linked program line: next-line address, line number, SYS
; token, ASCII address, terminator. RUN executes SYS 2061 (= $080d).
*=$0801
!word bend
!word 10
!byte $9e
!text "2061"
!byte 0
bend: !word 0
*=$080d
; ---------------------------------------------------------------------------
; 1. TAKE OWNERSHIP OF THE MACHINE
; Mask CPU IRQs before replacing vectors or touching VIC interrupt controls.
; CLD ensures ADC/SBC use binary arithmetic even if the caller left decimal on.
start:
 sei
 cld
 lda #0
 sta $d418              ; Set the master volume to zero before SID initialization.
; CIA interrupt masks use bit 7=0 to clear selected enables. Reading ICR
; acknowledges latched requests. CIA2 drives NMI, so disable it as well.
 lda #$7f
 sta $dc0d
 sta $dd0d
 lda $dc0d
 lda $dd0d
; $35 keeps I/O visible but banks BASIC and KERNAL out. The CPU can now
; fetch the hardware interrupt vectors from RAM at $fffa/$fffe.
 lda #$35
 sta $01
 lda #<irq
 sta $fffe
 lda #>irq
 sta $ffff
 lda #<nmi
 sta $fffa
 lda #>nmi
 sta $fffb
; CIA2 port A bits 0/1 select the VIC bank with inverted logic: 11=bank 0.
; Preserve all other port bits, which also connect to the serial bus.
 lda $dd00
 and #$fc
 ora #3
 sta $dd00
; $1b: display enabled, 25 rows, Y fine offset 3, text mode, raster high bit 0.
; $18 in $d018 selects screen $0400 and character data $2000 within bank 0.
; $17 in $d016 enables multicolour, 38 columns, initial X fine offset 7.
 lda #$1b
 sta $d011
 lda #$18
 sta $d018
 lda #$17
 sta $d016
 lda #0
 sta $d020
 lda #4
 sta $d021
 ldx #0
; X wraps after 256 iterations: four stores clear all 1024 screen bytes.
; Colour RAM is separate from screen RAM; only its low four bits are used.
; The eventual band colours overwrite these initial defaults.
clear:
 lda #0
 sta $0400,x
 sta $0500,x
 sta $0600,x
 sta $0700,x
 lda #14
 sta $d800,x
 sta $d900,x
 lda #5
 sta $da00,x
 lda #9
 sta $db00,x
 inx
 bne clear
 
 ldx #0
; Convert title text to our font slots $80-$bf. Colour 1 (bit 3 clear)
; makes these glyphs hi-res even though global multicolour mode is enabled.
hud:
 lda title,x
 and #63
 ora #128
 sta $0400,x
 lda #1
 sta $d800,x
 inx
 cpx #40
 bne hud
 
 ldx #0
; ---------------------------------------------------------------------------
; 2. POPULATE THE INITIAL 40-COLUMN WINDOWS
; !for is an ASSEMBLER loop: it emits repeated instructions, not a CPU loop.
; The CPU X loop supplies columns 0..39. Each world-map row is 256 bytes.
; Colour values >=8 select multicolour glyphs; low three bits select colour 3.
initial:
 
 ; Canopy rows 1..9 share a single camera with the mapped trunks.
 !for r,0,8 {
 lda woodland_canopy+r*256,x
 sta $0400+(r+1)*40,x
 lda #15
 sta $d800+(r+1)*40,x
 }
 
 !for r,0,5 {
 
 lda maps+(r+6)*256,x
 sta $0400+(r+12)*40,x
  lda #15
 sta $d800+(r+12)*40,x
 
 }
 ; Row 24 remains blank: a uniform base cannot crawl under fine scrolling.
 !for r,0,5 {
 lda maps+(r+12)*256,x
 sta $0400+(r+18)*40,x
  lda #13
 sta $d800+(r+18)*40,x
 }
 inx
 cpx #40
 beq initial_done
 jmp initial
; ---------------------------------------------------------------------------
; 3. HARDWARE SPRITES
; Bits in $d015/$d017/$d01c/$d01d correspond to sprite numbers 0..7.
; The runner uses masks in slots 0 and 7, with independent local colours.
initial_done:
 
 lda #$7e
 
  ora #1
  ora #$80
 sta $d015
 
 lda #$81
 sta $d017
 lda #0
 sta $d01c
 
 lda #0
 sta $d010
 sta $d01b
 sta $d01d
; Runner remains centred at VIC X=172 (screen-relative X=148). Y=168
; places the feet of the vertically doubled 21-line sprite at ground Y=210.
 lda #172
 sta $d000
 lda #168
 sta $d001
 
 sta $d00f
 lda #172
 sta $d00e
 lda #1
 sta $d02e
 lda #$a0
 sta $07ff
 
  lda #14
 sta $d027
  lda #9
 sta $d025
 lda #7
 sta $d026
; A sprite pointer is its address/64 within the VIC bank. $c0*64=$3000.
; Pointers live at screen base+$3f8, not inside the visible 1000-byte matrix.
 lda #$c0
 sta $07f8
  jsr prepare_trees
  jsr init_clouds
  jsr music_init
  lda #49
 sta $d012
; Writing 1 to $d019 ACKNOWLEDGES the raster flag. Writing 1 to $d01a
; ENABLES that interrupt source. CLI finally permits the installed IRQ handler.
 lda #1
 sta $d019
 sta $d01a
 cli
; With all updates in the IRQ there is no polling race or frame-rate-dependent
; main loop. NMI has a safe RTI target in case a stray edge arrives.
idle: jmp idle
nmi: rti
; Mountain copies run at line 75, foreground copies at 145. The canopy
; coarse copy runs below the display, after its camera advances.
; ---------------------------------------------------------------------------
; 4. IRQ PROLOGUE AND RASTER STATE MACHINE
; Hardware saves PC/status, not A/X/Y. Push our registers and restore them in
; reverse order. RTI restores the interrupted status/PC; RTS would be wrong.
; stage identifies the NEXT part of the current video frame to configure.
irq:
 pha
 txa
 pha
 tya
 pha
 lda #1
 sta $d019
 lda stage
 beq raster_top
 cmp #1
 beq split1
 cmp #2
 beq split2
 cmp #3
 beq split3
 
 cmp #5
 bne +
 jmp woodland_top
+
 cmp #6
 bne +
 jmp woodland_trees
+
 
 jmp bottom
; Line 49 fixes the HUD scroll and prepares the upper display palette.
raster_top:
 lda #$17
 sta $d016
  lda #0
 sta $d021
  lda #9
 sta $d022
  lda #7
 sta $d023
 ; The next event starts canopy scrolling below the HUD.
 
 lda #57
 ldx #5
 
 jmp schedule
; Line 75 copies mountains before row 12 fetches them. Clouds still own
; the sprite slots. The next event installs trunks after cloud DMA ends.
split1:
 
  jsr shift_mid
 
 ; Copy the mountain rows while the lower clouds still use the sprite slots.
 lda #118
 ldx #6
 jmp schedule
 
  lda #145
 ldx #2
 jmp schedule
; Line 145 selects mountain fine scroll and palette, then copies the ground.
split2:
 lda fine+1
 ora #$10
 sta $d016
  lda #0
 sta $d021
  lda #9
 sta $d022
 
  lda #15
 
 sta $d023
 jsr shift_near
  lda #193
 ldx #3
 jmp schedule
; Line 193 changes only foreground fine scroll, preserving the join palette.
split3:
 lda fine+2
 ora #$10
 sta $d016
 
; Both sides of the join use solid pixel-code-1 brown.
 lda #250
 ldx #4
 jmp schedule
; Line 250 updates input, animation, SID and camera state below the display.
; Nothing here waits for a note, a key release, or a sprite to finish drawing.
bottom:
 jsr input
 
 jsr limit_tree_camera
  jsr limit_tree_camera
 
  jsr animate
  jsr music_play
 inc tick
 lda direction
 beq no_scroll
 
; PAL movement per frame: clouds/mountains=1, canopy/trunks=2, foreground=3.
; Each layer advances every moving frame at its configured pixel speed.
; Repeated one-pixel calls still detect a coarse boundary at any speed.
 ldx #2
 jsr step_layer
 ldx #2
 jsr step_layer
 ldx #2
 jsr step_layer
 ldx #1
 jsr step_layer
 ldx #0
 jsr step_layer
 
 ldx #0
 jsr step_layer
 
no_scroll:
  jsr prepare_trees
  jsr move_clouds
  jsr shift_canopy
  lda #49
 ldx #0
schedule:
 sta $d012
 stx stage
 pla
 tay
 pla
 tax
 pla
 rti
; Fine scroll + wrap state for each independent band.
; ---------------------------------------------------------------------------
; 5. FINE/COARSE CAMERA STATE (X = layer 0, 1, or 2)
; direction=1 means running right, so scenery shifts LEFT. direction=$ff means
; running left. pending=1 requests a left character copy; $ff requests right.
; A 256-column world uses byte overflow as wraparound, with no division.
step_layer:
 lda direction
 bmi step_left
 dec fine,x
 bpl step_done
 lda #7
 sta fine,x
 inc column,x
 lda #1
 sta pending,x
 rts
; Fine offset rises through 7, then wraps to 0 while world column decreases.
; DEC column wraps 0->$ff, matching the looped map. These are reverse operations
; of the right-running path, so walking out and back restores the same scene.
step_left:
 inc fine,x
 lda fine,x
 cmp #8
 bcc step_done
 lda #0
 sta fine,x
 dec column,x
 lda #255
 sta pending,x
step_done: rts
; ---------------------------------------------------------------------------
; 6. CLOUD SPRITES
; Three hi-res cloud pairs reuse sprites 1..6 before the tree trunks begin.
; Pointers $d8..$dd select six 64-byte tiles at $3600.
; The fixed-zone tree module emits the fast character copies.
init_clouds:
 ldx #5
.init_loop:
 txa
 clc
  adc #$d8
 sta $07f9,x
 lda cloud_color,x
 sta $d028,x
 dex
 bpl .init_loop
 jmp plot_clouds
; A cloud moves when the camera moves. All cadence masks are zero, so every
; moving frame advances every pair by one pixel. X has a low byte and bit 8.
move_clouds:
 lda direction
 bne .moving
 jmp plot_clouds
.moving:
 ldx #5
.move_loop:
 lda tick
 and cloud_mask,x
 bne .next
 lda direction
 bmi .left
 lda cloud_lo,x
 bne .dec_low
 dec cloud_hi,x
; Decrementing across a low-byte zero borrowed from cloud_hi above. Wrap the
; full coordinate range [24,343] so no signed-8-bit comparisons are involved.
.dec_low:
 dec cloud_lo,x
 
 lda cloud_hi,x
 cmp #255
 bne .next
 lda #1
 sta cloud_hi,x
 lda #87
 sta cloud_lo,x
 jmp .next
 
 lda cloud_hi,x
 bne .next
 lda cloud_lo,x
  jmp .next
 cmp #24
 bcs .next
 lda #1
 sta cloud_hi,x
 lda #87
 sta cloud_lo,x
 jmp .next
.left:
 inc cloud_lo,x
 bne .check_end
 inc cloud_hi,x
; 344=$0158 is the right exclusive limit. The asymmetric low-byte tests only
; run after examining the high byte, so X=88 is not mistaken for X=344.
.check_end:
 lda cloud_hi,x
 beq .next
 lda cloud_lo,x
 cmp #88
 bcc .next
 lda #0
 sta cloud_hi,x
  lda #0
 sta cloud_lo,x
.next:
 dex
 bpl .move_loop
; Sprite X/Y register pairs have stride 2; TXA/ASL/TAY forms that offset.
; $d010 is shared by every sprite, so assemble all high bits before one write.
plot_clouds:
 
 ; Let foreground pixels of the character canopy cover the cloud sprites.
 lda #$7e
 sta $d01b
 
  lda #$ff
 sta $d015
 
 lda #$81
 sta $d017
 lda #0
 sta $d01c
 
 lda #0
 sta $d01d
 ldx #5
.restore:
 txa
 clc
  adc #$d8
 sta $07f9,x
 lda cloud_color,x
 sta $d028,x
 dex
 bpl .restore
 
 lda #0
 sta cloud_msb
 ldx #5
.plot_loop:
 txa
 asl
 tay
 lda cloud_lo,x
 sta $d002,y
 lda cloud_y,x
 sta $d003,y
 lda cloud_hi,x
 beq .no_high
 lda cloud_msb
 ora cloud_bit,x
 sta cloud_msb
.no_high:
 dex
 bpl .plot_loop
 lda cloud_msb
 sta $d010
 rts
 
; Paired cloud halves: same Y, adjacent X, same speed. Six sprites, 3 clouds.
cloud_lo: !byte 42,66,174,198,32,56
cloud_hi: !byte 0,0,0,0,1,1
 
cloud_y: !byte 88,88,94,94,84,84
 
; The three cloud pairs move at 50 pixels per second during PAL movement.
 
; Each pair shares Y, speed, local colour and adjacent X coordinates.
cloud_mask: !byte 0,0,0,0,0,0
cloud_color: !byte 15,15,12,12,1,1
 
cloud_bit: !byte 2,4,8,16,32,64
cloud_msb: !byte 0
 
; ---------------------------------------------------------------------------
; 8. DIRECT CIA INPUT (ACTIVE LOW)
; CIA1 port A is also joystick port 2. Make it input before reading joystick,
; then scan selected keyboard columns. No KERNAL keyboard IRQ is running.
; direction is reset each frame; opposite inputs use the later/right priority.
input:
 lda #0
 sta direction
 sta fire
 sta $dc02
 sta $dc03
 lda $dc00
 sta joy
 and #4
 bne joy_right
 lda #255
 sta direction
joy_right:
 lda joy
 and #8
 bne joy_fire
 lda #1
 sta direction
joy_fire:
 lda joy
 and #16
 bne keyboard
 inc fire
; Keep the output latch zero. Only the selected column gets an output DDR
; bit; the others remain inputs. PB bit 2 reads A/D; PB bit 4 reads Space.
; This avoids driving unselected output columns high against joystick grounds.
keyboard:
 ; Only selected column is output-low; other columns are inputs.
 lda #0
 sta $dc00
 lda #2
 sta $dc02
 lda $dc01
 and #4
 bne key_d
 lda #255
 sta direction
key_d:
 lda #4
 sta $dc02
 lda $dc01
 and #4
 bne key_space
 lda #1
 sta direction
key_space:
 lda #128
 sta $dc02
 lda $dc01
 and #16
 bne keys_done
 inc fire
; Restore port A to inputs after scanning. Facing survives when idle and
; selects the mirrored sprite bank: right offset 0, left offset 10 frames.
keys_done:
 lda #0
 sta $dc02
 lda direction
 beq input_done
 bmi face_left
 lda #0
 sta facing
 rts
face_left:
 lda #10
 sta facing
input_done: rts
; ---------------------------------------------------------------------------
; 9. RUN/IDLE/JUMP STATE
; Frames 0..7 run, 8 idle, 9 airborne; frames 10..19 are their mirrored copies.
; anim_tick 0..23 divided by 3 gives one pose every three video frames.
; All animation is frame-based, not dependent on how fast the mainline spins.
animate:
 lda jump
 bne airborne_frame
 lda direction
 beq standing
 inc anim_tick
 lda anim_tick
 cmp #24
 bcc anim_no_wrap
 lda #0
 sta anim_tick
anim_no_wrap:
 ldx #0
; Repeated subtraction divides a tiny bounded value by 3. CMP supplies carry
; before SBC, so the subtraction is correct without a separate SEC here.
frame_divide:
 cmp #3
 bcc frame_ready
 sbc #3
 inx
 bne frame_divide
frame_ready:
 txa
 and #7
 jmp set_frame
standing:
 lda #8
 jmp set_frame
airborne_frame:
 lda #9
; Add the facing bank, then $c0 sprite base. Each increment selects 64 bytes.
; Fire edge + grounded state accepts one jump. Holding fire cannot auto-repeat.
set_frame:
 clc
 adc facing
 adc #$c0
 sta $07f8
 
 ; Matching white mask at $2800: pointer is body pointer minus $20.
 sec
 sbc #$20
 sta $07ff
 
 lda fire
 beq released
 lda old_fire
 bne advance_jump
 lda jump
 bne advance_jump
 lda #1
 sta jump
  jsr jump_sfx
; jump=0 means grounded; 1..33 indexes the precomputed arc (index minus one).
; A lookup table gives a clear tutorial-friendly parabola without signed
; fixed-point velocity/gravity code. Height and duration are edited below.
advance_jump:
 lda fire
 sta old_fire
 lda jump
 beq on_ground
 tax
 lda jump_y-1,x
 sta $d001
  sta $d00f
 inc jump
 lda jump
 cmp #34
 bcc anim_done
 lda #0
 sta jump
on_ground:
 lda #168
 sta $d001
  sta $d00f
anim_done: rts
; Only a release clears the previous-fire latch. Return to the shared jump
; progression so releasing the key early does not freeze the airborne motion.
released:
 lda #0
 sta old_fire
 jmp advance_jump
; ---------------------------------------------------------------------------
; 10. SID MODULE AND STATE DATA
; Source inclusion shares labels directly; no second interrupt/player exists.
 !source "music.asm"
 
stage: !byte 0
; For each scenery layer: 7..0 fine offset; current left map column; queued
; character-copy direction. Arrays use the same layer index throughout.
fine: !byte 7,7,7
column: !byte 0,0,0
pending: !byte 0,0,0
direction: !byte 0
joy: !byte 255
fire: !byte 0
old_fire: !byte 0
facing: !byte 0
jump: !byte 0
tick: !byte 0
anim_tick: !byte 0
; VIC sprite top Y: 168 on the floor, 110 at apex (58-pixel rise).
; Stored absolute positions avoid arithmetic and make the jump easy to teach.
jump_y:
!byte 168,160,153,146,140,135,130,126,122,119,116,114
!byte 112,111,110,110,110,110,111,112,114,116,119,122
!byte 126,130,135,140,146,153,160,168,168
title:
!scr " BEASTLANDS   A/D:MOVE SPACE:JUMP  JOY2   "
!if * > $2000 { !error "Code overlaps charset" }
; Assets are native ACME !byte include files, assembled directly. The custom
; charset is exactly 2048 bytes; all sprite pointers stay within VIC bank 0.
*=$2000
 !source "assets/charset-woodland.inc"
!if * != $2800 { !error "Charset must contain 256 eight-byte glyphs" }
 
 *=$2800
 !source "assets/runner-accent.inc"
 !if * != $2d00 { !error "Runner accents require 20 aligned frames" }
 
*=$3000
 !source "assets/runner-body.inc"
!if * != $3500 { !error "Runner must contain 20 frames of 64 bytes" }
 
 *=$3500
  !source "assets/trees-woodland.inc"
 !if * != $3600 { !error "Four tree tiles must occupy 256 bytes" }
 
 *=$3600
 !source "assets/clouds.inc"
 !if * != $3780 { !error "Six cloud tiles must occupy 384 bytes" }
 
; Reserve the gap before the aligned clipping blocks.
*=$3980
 
  !source "assets/trees-woodland-clipped.inc"
 !if * != $3f80 { !error "Clipped trees must occupy 24 sprite blocks" }
 
*=$4000
; CPU-only map layout: 6 reserved + 6 mountain + 7 ground rows.
; The seventh ground row is deliberately not displayed/scrolled in this build.
maps:
 !source "assets/maps-woodland.inc"
!if * != $5300 { !error "Maps must contain 19 rows of 256 cells" }
 
; The mapped-sprite module lives beyond the character maps, outside VIC bank 0.
 
 *=$5400
 !source "sprite_midground.asm"
 !if * > $7400 { !error "Sprite map module exceeds reserved region" }
 
 *=$7400
woodland_canopy:
 !source "assets/canopy-woodland.inc"
 !if * != $7d00 { !error "Canopy requires nine 256-byte rows" }
 ; Row 0 remains fixed. Set the canopy palette before row 1 starts.
woodland_top:
 lda fine
 ora #$10
 sta $d016
 lda #5
 sta $d022
 lda #13
 sta $d023
 lda #75
 ldx #1
 jmp schedule
woodland_trees:
 ; Cloud DMA has finished. Draw the trunks in front of the character layer.
 lda #0
 sta $d01b
 jsr plot_trees
 lda #145
 ldx #2
 jmp schedule
 !zone WoodlandCopy
shift_canopy: +fast_tree_band 0,1,9,woodland_canopy
 !if * > $a000 { !error "Woodland code exceeds reserved RAM" }
