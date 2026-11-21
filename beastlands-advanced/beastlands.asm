; WHAT: A layered woodland scene with runner animation, scrolling, two-voice music and a jump cue.
; WHY: Create depth by giving layers different camera speeds while sharing the VIC and raster budget.
; HOW: Use a raster schedule, character copies, mapped sprite scenery, runner animation and one non-blocking music/effect tick.

; BEASTLANDS PAL C64 PARALLAX DEMO
; Assemble with acme -f cbm -o beastlands.prg beastlands.asm
; See Part Six for the raster schedule and graphics formats.
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
 sei ; Block maskable IRQ service during ownership changes.
 cld ; Select ordinary binary arithmetic.
 lda #0 ; Load A with constant 0.
 sta $d418              ; Set the master volume to zero before SID initialization.
; CIA interrupt masks use bit 7=0 to clear selected enables. Reading ICR
; acknowledges latched requests. CIA2 drives NMI, so disable it as well.
 lda #$7f ; Load A with constant $7f.
 sta $dc0d ; Write A to $dc0d.
 sta $dd0d ; Write A to $dd0d.
 lda $dc0d ; Load A with $dc0d.
 lda $dd0d ; Load A with $dd0d.
; $35 keeps I/O visible but banks BASIC and KERNAL out. The CPU can now
; fetch the hardware interrupt vectors from RAM at $fffa/$fffe.
 lda #$35 ; Load A with constant $35.
 sta $01 ; Write A to $01.
 lda #<irq ; Load A with constant <irq.
 sta $fffe ; Write A to $fffe.
 lda #>irq ; Load A with constant >irq.
 sta $ffff ; Write A to $ffff.
 lda #<nmi ; Load A with constant <nmi.
 sta $fffa ; Write A to $fffa.
 lda #>nmi ; Load A with constant >nmi.
 sta $fffb ; Write A to $fffb.
; CIA2 port A bits 0/1 select the VIC bank with inverted logic: 11=bank 0.
; Preserve all other port bits, which also connect to the serial bus.
 lda $dd00 ; Load A with CIA2 VIC bank selection.
 and #$fc ; Keep only the bits selected by #$fc.
 ora #3 ; Set bits selected by #3; retain other set bits.
 sta $dd00 ; Write A to CIA2 VIC bank selection.
; $1b: display enabled, 25 rows, Y fine offset 3, text mode, raster high bit 0.
; $18 in $d018 selects screen $0400 and character data $2000 within bank 0.
; $17 in $d016 enables multicolour, 38 columns, initial X fine offset 7.
 lda #$1b ; Load A with constant $1b.
 sta $d011 ; Write A to vertical control and raster high bit.
 lda #$18 ; Load A with constant $18.
 sta $d018 ; Write A to screen and graphics pointers.
 lda #$17 ; Load A with constant $17.
 sta $d016 ; Write A to horizontal control and fine scroll.
 lda #0 ; Load A with constant 0.
 sta $d020 ; Write A to $d020.
 lda #4 ; Load A with constant 4.
 sta $d021 ; Write A to $d021.
 ldx #0 ; Load X with constant 0.
; X wraps after 256 iterations: four stores clear all 1024 screen bytes.
; Colour RAM is separate from screen RAM; only its low four bits are used.
; The eventual band colours overwrite these initial defaults.
clear:
 lda #0 ; Load A with constant 0.
 sta $0400,x ; Write A to $0400,x.
 sta $0500,x ; Write A to $0500,x.
 sta $0600,x ; Write A to $0600,x.
 sta $0700,x ; Write A to $0700,x.
 lda #14 ; Load A with constant 14.
 sta $d800,x ; Write A to $d800,x.
 sta $d900,x ; Write A to $d900,x.
 lda #5 ; Load A with constant 5.
 sta $da00,x ; Write A to $da00,x.
 lda #9 ; Load A with constant 9.
 sta $db00,x ; Write A to $db00,x.
 inx ; Advance the X index by one.
 bne clear ; Continue at clear when the result is nonzero.

 ldx #0 ; Load X with constant 0.
; Convert title text to our font slots $80-$bf. Colour 1 (bit 3 clear)
; makes these glyphs hi-res even though global multicolour mode is enabled.
hud:
 lda title,x ; Load A with title,x.
 and #63 ; Keep only the bits selected by #63.
 ora #128 ; Set bits selected by #128; retain other set bits.
 sta $0400,x ; Write A to $0400,x.
 lda #1 ; Load A with constant 1.
 sta $d800,x ; Write A to $d800,x.
 inx ; Advance the X index by one.
 cpx #40 ; Compare X with #40; update flags.
 bne hud ; Continue at hud when the result is nonzero.

 ldx #0 ; Load X with constant 0.
; ---------------------------------------------------------------------------
; 2. POPULATE THE INITIAL 40-COLUMN WINDOWS
; !for is an ASSEMBLER loop: it emits repeated instructions, not a CPU loop.
; The CPU X loop supplies columns 0..39. Each world-map row is 256 bytes.
; Colour values >=8 select multicolour glyphs; low three bits select colour 3.
initial:

 ; Canopy rows 1..9 share a single camera with the mapped trunks.
 !for r,0,8 {
 lda woodland_canopy+r*256,x ; Load A with woodland_canopy+r*256,x.
 sta $0400+(r+1)*40,x ; Write A to $0400+(r+1)*40,x.
 lda #15 ; Load A with constant 15.
 sta $d800+(r+1)*40,x ; Write A to $d800+(r+1)*40,x.
 }

 !for r,0,5 {

 lda maps+(r+6)*256,x ; Load A with maps+(r+6)*256,x.
 sta $0400+(r+12)*40,x ; Write A to $0400+(r+12)*40,x.
  lda #15 ; Load A with constant 15.
 sta $d800+(r+12)*40,x ; Write A to $d800+(r+12)*40,x.

 }
 ; Row 24 remains blank: a uniform base cannot crawl under fine scrolling.
 !for r,0,5 {
 lda maps+(r+12)*256,x ; Load A with maps+(r+12)*256,x.
 sta $0400+(r+18)*40,x ; Write A to $0400+(r+18)*40,x.
  lda #13 ; Load A with constant 13.
 sta $d800+(r+18)*40,x ; Write A to $d800+(r+18)*40,x.
 }
 inx ; Advance the X index by one.
 cpx #40 ; Compare X with #40; update flags.
 beq initial_done ; Continue at initial_done when the result is zero.
 jmp initial ; Continue at initial without pushing a return address.
; ---------------------------------------------------------------------------
; 3. HARDWARE SPRITES
; Bits in $d015/$d017/$d01c/$d01d correspond to sprite numbers 0..7.
; The runner uses masks in slots 0 and 7, with independent local colours.
initial_done:

 lda #$7e ; Load A with constant $7e.

  ora #1 ; Set bits selected by #1; retain other set bits.
  ora #$80 ; Set bits selected by #$80; retain other set bits.
 sta $d015 ; Write A to sprite enable mask.

 lda #$81 ; Load A with constant $81.
 sta $d017 ; Write A to $d017.
 lda #0 ; Load A with constant 0.
 sta $d01c ; Write A to $d01c.

 lda #0 ; Load A with constant 0.
 sta $d010 ; Write A to sprite X high bits.
 sta $d01b ; Write A to $d01b.
 sta $d01d ; Write A to $d01d.
; Runner remains centred at VIC X=172 (screen-relative X=148). Y=168
; places the feet of the vertically doubled 21-line sprite at ground Y=210.
 lda #172 ; Load A with constant 172.
 sta $d000 ; Write A to $d000.
 lda #168 ; Load A with constant 168.
 sta $d001 ; Write A to $d001.

 sta $d00f ; Write A to $d00f.
 lda #172 ; Load A with constant 172.
 sta $d00e ; Write A to $d00e.
 lda #1 ; Load A with constant 1.
 sta $d02e ; Write A to $d02e.
 lda #$a0 ; Load A with constant $a0.
 sta $07ff ; Write A to $07ff.

  lda #14 ; Load A with constant 14.
 sta $d027 ; Write A to $d027.
  lda #9 ; Load A with constant 9.
 sta $d025 ; Write A to $d025.
 lda #7 ; Load A with constant 7.
 sta $d026 ; Write A to $d026.
; A sprite pointer is its address/64 within the VIC bank. $c0*64=$3000.
; Pointers live at screen base+$3f8, not inside the visible 1000-byte matrix.
 lda #$c0 ; Load A with constant $c0.
 sta $07f8 ; Write A to $07f8.
  jsr prepare_trees ; Call prepare_trees; the routine returns with RTS.
  jsr init_clouds ; Call init_clouds; the routine returns with RTS.
  jsr music_init ; Call music_init; the routine returns with RTS.
  lda #49 ; Load A with constant 49.
 sta $d012 ; Write A to raster comparator.
; Writing 1 to $d019 ACKNOWLEDGES the raster flag. Writing 1 to $d01a
; ENABLES that interrupt source. CLI finally permits the installed IRQ handler.
 lda #1 ; Load A with constant 1.
 sta $d019 ; Write A to VIC interrupt acknowledgement.
 sta $d01a ; Write A to VIC interrupt mask.
 cli ; Allow the installed IRQ handler to run.
; With all updates in the IRQ there is no polling race or frame-rate-dependent
; main loop. NMI has a safe RTI target in case a stray edge arrives.
idle: jmp idle ; Continue at idle without pushing a return address.
nmi: rti ; Restore interrupt context and resume execution.
; Mountain copies run at line 75, foreground copies at 145. The canopy
; coarse copy runs below the display, after its camera advances.
; ---------------------------------------------------------------------------
; 4. IRQ PROLOGUE AND RASTER STATE MACHINE
; Hardware saves PC/status, not A/X/Y. Push our registers and restore them in
; reverse order. RTI restores the interrupted status/PC; RTS would be wrong.
; stage identifies the NEXT part of the current video frame to configure.
irq:
 pha ; Save A on the stack.
 txa ; Copy X into A.
 pha ; Save A on the stack.
 tya ; Copy Y into A.
 pha ; Save A on the stack.
 lda #1 ; Load A with constant 1.
 sta $d019 ; Write A to VIC interrupt acknowledgement.
 lda stage ; Load A with stage.
 beq raster_top ; Continue at raster_top when the result is zero.
 cmp #1 ; Compare A with #1; retain A and update flags.
 beq split1 ; Continue at split1 when the result is zero.
 cmp #2 ; Compare A with #2; retain A and update flags.
 beq split2 ; Continue at split2 when the result is zero.
 cmp #3 ; Compare A with #3; retain A and update flags.
 beq split3 ; Continue at split3 when the result is zero.

 cmp #5 ; Compare A with #5; retain A and update flags.
 bne + ; Continue at + when the result is nonzero.
 jmp woodland_top ; Continue at woodland_top without pushing a return address.
+
 cmp #6 ; Compare A with #6; retain A and update flags.
 bne + ; Continue at + when the result is nonzero.
 jmp woodland_trees ; Continue at woodland_trees without pushing a return address.
+

 jmp bottom ; Continue at bottom without pushing a return address.
; Line 49 fixes the HUD scroll and prepares the upper display palette.
raster_top:
 lda #$17 ; Load A with constant $17.
 sta $d016 ; Write A to horizontal control and fine scroll.
  lda #0 ; Load A with constant 0.
 sta $d021 ; Write A to $d021.
  lda #9 ; Load A with constant 9.
 sta $d022 ; Write A to $d022.
  lda #7 ; Load A with constant 7.
 sta $d023 ; Write A to $d023.
 ; The next event starts canopy scrolling below the HUD.

 lda #57 ; Load A with constant 57.
 ldx #5 ; Load X with constant 5.

 jmp schedule ; Continue at schedule without pushing a return address.
; Line 75 copies mountains before row 12 fetches them. Clouds still own
; the sprite slots. The next event installs trunks after cloud DMA ends.
split1:

  jsr shift_mid ; Call shift_mid; the routine returns with RTS.

 ; Copy the mountain rows while the lower clouds still use the sprite slots.
 lda #118 ; Load A with constant 118.
 ldx #6 ; Load X with constant 6.
 jmp schedule ; Continue at schedule without pushing a return address.

  lda #145 ; Load A with constant 145.
 ldx #2 ; Load X with constant 2.
 jmp schedule ; Continue at schedule without pushing a return address.
; Line 145 selects mountain fine scroll and palette, then copies the ground.
split2:
 lda fine+1 ; Load A with fine+1.
 ora #$10 ; Set bits selected by #$10; retain other set bits.
 sta $d016 ; Write A to horizontal control and fine scroll.
  lda #0 ; Load A with constant 0.
 sta $d021 ; Write A to $d021.
  lda #9 ; Load A with constant 9.
 sta $d022 ; Write A to $d022.

  lda #15 ; Load A with constant 15.

 sta $d023 ; Write A to $d023.
 jsr shift_near ; Call shift_near; the routine returns with RTS.
  lda #193 ; Load A with constant 193.
 ldx #3 ; Load X with constant 3.
 jmp schedule ; Continue at schedule without pushing a return address.
; Line 193 changes only foreground fine scroll, preserving the join palette.
split3:
 lda fine+2 ; Load A with fine+2.
 ora #$10 ; Set bits selected by #$10; retain other set bits.
 sta $d016 ; Write A to horizontal control and fine scroll.

; Both sides of the join use solid pixel-code-1 brown.
 lda #250 ; Load A with constant 250.
 ldx #4 ; Load X with constant 4.
 jmp schedule ; Continue at schedule without pushing a return address.
; Line 250 updates input, animation, SID and camera state below the display.
; Nothing here waits for a note, a key release, or a sprite to finish drawing.
bottom:
 jsr input ; Call input; the routine returns with RTS.

 jsr limit_tree_camera ; Call limit_tree_camera; the routine returns with RTS.
  jsr limit_tree_camera ; Call limit_tree_camera; the routine returns with RTS.

  jsr animate ; Call animate; the routine returns with RTS.
  jsr music_play ; Call music_play; the routine returns with RTS.
 inc tick ; Increase tick by one.
 lda direction ; Load A with direction.
 beq no_scroll ; Continue at no_scroll when the result is zero.

; PAL movement per frame: clouds/mountains=1, canopy/trunks=2, foreground=3.
; Each layer advances every moving frame at its configured pixel speed.
; Repeated one-pixel calls still detect a coarse boundary at any speed.
 ldx #2 ; Load X with constant 2.
 jsr step_layer ; Call step_layer; the routine returns with RTS.
 ldx #2 ; Load X with constant 2.
 jsr step_layer ; Call step_layer; the routine returns with RTS.
 ldx #2 ; Load X with constant 2.
 jsr step_layer ; Call step_layer; the routine returns with RTS.
 ldx #1 ; Load X with constant 1.
 jsr step_layer ; Call step_layer; the routine returns with RTS.
 ldx #0 ; Load X with constant 0.
 jsr step_layer ; Call step_layer; the routine returns with RTS.

 ldx #0 ; Load X with constant 0.
 jsr step_layer ; Call step_layer; the routine returns with RTS.

no_scroll:
  jsr prepare_trees ; Call prepare_trees; the routine returns with RTS.
  jsr move_clouds ; Call move_clouds; the routine returns with RTS.
  jsr shift_canopy ; Call shift_canopy; the routine returns with RTS.
  lda #49 ; Load A with constant 49.
 ldx #0 ; Load X with constant 0.
schedule:
 sta $d012 ; Write A to raster comparator.
 stx stage ; Write X to stage.
 pla ; Restore A from the stack.
 tay ; Copy A to Y for indexed addressing.
 pla ; Restore A from the stack.
 tax ; Copy A to X for indexed addressing.
 pla ; Restore A from the stack.
 rti ; Restore interrupt context and resume execution.
; Fine scroll + wrap state for each independent band.
; ---------------------------------------------------------------------------
; 5. FINE/COARSE CAMERA STATE (X = layer 0, 1, or 2)
; direction=1 means running right, so scenery shifts LEFT. direction=$ff means
; running left. pending=1 requests a left character copy; $ff requests right.
; A 256-column world uses byte overflow as wraparound, with no division.
step_layer:
 lda direction ; Load A with direction.
 bmi step_left ; Continue at step_left when bit 7 is set.
 dec fine,x ; Decrease fine,x by one.
 bpl step_done ; Continue at step_done when bit 7 is clear.
 lda #7 ; Load A with constant 7.
 sta fine,x ; Write A to fine,x.
 inc column,x ; Increase column,x by one.
 lda #1 ; Load A with constant 1.
 sta pending,x ; Write A to pending,x.
 rts ; Return to the instruction after the caller JSR.
; Fine offset rises through 7, then wraps to 0 while world column decreases.
; DEC column wraps 0->$ff, matching the looped map. These are reverse operations
; of the right-running path, so walking out and back restores the same scene.
step_left:
 inc fine,x ; Increase fine,x by one.
 lda fine,x ; Load A with fine,x.
 cmp #8 ; Compare A with #8; retain A and update flags.
 bcc step_done ; Continue at step_done when carry is clear.
 lda #0 ; Load A with constant 0.
 sta fine,x ; Write A to fine,x.
 dec column,x ; Decrease column,x by one.
 lda #255 ; Load A with constant 255.
 sta pending,x ; Write A to pending,x.
step_done: rts ; Return to the instruction after the caller JSR.
; ---------------------------------------------------------------------------
; 6. CLOUD SPRITES
; Three hi-res cloud pairs reuse sprites 1..6 before the tree trunks begin.
; Pointers $d8..$dd select six 64-byte tiles at $3600.
; The fixed-zone tree module emits the fast character copies.
init_clouds:
 ldx #5 ; Load X with constant 5.
.init_loop:
 txa ; Copy X into A.
 clc ; Clear carry before a new addition.
  adc #$d8 ; Add #$d8 and carry to A; propagate overflow.
 sta $07f9,x ; Write A to $07f9,x.
 lda cloud_color,x ; Load A with cloud_color,x.
 sta $d028,x ; Write A to $d028,x.
 dex ; Decrease the X counter by one.
 bpl .init_loop ; Continue at .init_loop when bit 7 is clear.
 jmp plot_clouds ; Continue at plot_clouds without pushing a return address.
; A cloud moves when the camera moves. All cadence masks are zero, so every
; moving frame advances every pair by one pixel. X has a low byte and bit 8.
move_clouds:
 lda direction ; Load A with direction.
 bne .moving ; Continue at .moving when the result is nonzero.
 jmp plot_clouds ; Continue at plot_clouds without pushing a return address.
.moving:
 ldx #5 ; Load X with constant 5.
.move_loop:
 lda tick ; Load A with tick.
 and cloud_mask,x ; Keep only the bits selected by cloud_mask,x.
 bne .next ; Continue at .next when the result is nonzero.
 lda direction ; Load A with direction.
 bmi .left ; Continue at .left when bit 7 is set.
 lda cloud_lo,x ; Load A with cloud_lo,x.
 bne .dec_low ; Continue at .dec_low when the result is nonzero.
 dec cloud_hi,x ; Decrease cloud_hi,x by one.
; Decrementing across a low-byte zero borrowed from cloud_hi above. Wrap the
; full coordinate range [24,343] so no signed-8-bit comparisons are involved.
.dec_low:
 dec cloud_lo,x ; Decrease cloud_lo,x by one.

 lda cloud_hi,x ; Load A with cloud_hi,x.
 cmp #255 ; Compare A with #255; retain A and update flags.
 bne .next ; Continue at .next when the result is nonzero.
 lda #1 ; Load A with constant 1.
 sta cloud_hi,x ; Write A to cloud_hi,x.
 lda #87 ; Load A with constant 87.
 sta cloud_lo,x ; Write A to cloud_lo,x.
 jmp .next ; Continue at .next without pushing a return address.

 lda cloud_hi,x ; Load A with cloud_hi,x.
 bne .next ; Continue at .next when the result is nonzero.
 lda cloud_lo,x ; Load A with cloud_lo,x.
  jmp .next ; Continue at .next without pushing a return address.
 cmp #24 ; Compare A with #24; retain A and update flags.
 bcs .next ; Continue at .next when carry is set.
 lda #1 ; Load A with constant 1.
 sta cloud_hi,x ; Write A to cloud_hi,x.
 lda #87 ; Load A with constant 87.
 sta cloud_lo,x ; Write A to cloud_lo,x.
 jmp .next ; Continue at .next without pushing a return address.
.left:
 inc cloud_lo,x ; Increase cloud_lo,x by one.
 bne .check_end ; Continue at .check_end when the result is nonzero.
 inc cloud_hi,x ; Increase cloud_hi,x by one.
; 344=$0158 is the right exclusive limit. The asymmetric low-byte tests only
; run after examining the high byte, so X=88 is not mistaken for X=344.
.check_end:
 lda cloud_hi,x ; Load A with cloud_hi,x.
 beq .next ; Continue at .next when the result is zero.
 lda cloud_lo,x ; Load A with cloud_lo,x.
 cmp #88 ; Compare A with #88; retain A and update flags.
 bcc .next ; Continue at .next when carry is clear.
 lda #0 ; Load A with constant 0.
 sta cloud_hi,x ; Write A to cloud_hi,x.
  lda #0 ; Load A with constant 0.
 sta cloud_lo,x ; Write A to cloud_lo,x.
.next:
 dex ; Decrease the X counter by one.
 bpl .move_loop ; Continue at .move_loop when bit 7 is clear.
; Sprite X/Y register pairs have stride 2; TXA/ASL/TAY forms that offset.
; $d010 is shared by every sprite, so assemble all high bits before one write.
plot_clouds:

 ; Let foreground pixels of the character canopy cover the cloud sprites.
 lda #$7e ; Load A with constant $7e.
 sta $d01b ; Write A to $d01b.

  lda #$ff ; Load A with constant $ff.
 sta $d015 ; Write A to sprite enable mask.

 lda #$81 ; Load A with constant $81.
 sta $d017 ; Write A to $d017.
 lda #0 ; Load A with constant 0.
 sta $d01c ; Write A to $d01c.

 lda #0 ; Load A with constant 0.
 sta $d01d ; Write A to $d01d.
 ldx #5 ; Load X with constant 5.
.restore:
 txa ; Copy X into A.
 clc ; Clear carry before a new addition.
  adc #$d8 ; Add #$d8 and carry to A; propagate overflow.
 sta $07f9,x ; Write A to $07f9,x.
 lda cloud_color,x ; Load A with cloud_color,x.
 sta $d028,x ; Write A to $d028,x.
 dex ; Decrease the X counter by one.
 bpl .restore ; Continue at .restore when bit 7 is clear.

 lda #0 ; Load A with constant 0.
 sta cloud_msb ; Write A to cloud_msb.
 ldx #5 ; Load X with constant 5.
.plot_loop:
 txa ; Copy X into A.
 asl ; Shift left, moving bit 7 into carry.
 tay ; Copy A to Y for indexed addressing.
 lda cloud_lo,x ; Load A with cloud_lo,x.
 sta $d002,y ; Write A to $d002,y.
 lda cloud_y,x ; Load A with cloud_y,x.
 sta $d003,y ; Write A to $d003,y.
 lda cloud_hi,x ; Load A with cloud_hi,x.
 beq .no_high ; Continue at .no_high when the result is zero.
 lda cloud_msb ; Load A with cloud_msb.
 ora cloud_bit,x ; Set bits selected by cloud_bit,x; retain other set bits.
 sta cloud_msb ; Write A to cloud_msb.
.no_high:
 dex ; Decrease the X counter by one.
 bpl .plot_loop ; Continue at .plot_loop when bit 7 is clear.
 lda cloud_msb ; Load A with cloud_msb.
 sta $d010 ; Write A to sprite X high bits.
 rts ; Return to the instruction after the caller JSR.

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
 lda #0 ; Load A with constant 0.
 sta direction ; Write A to direction.
 sta fire ; Write A to fire.
 sta $dc02 ; Write A to CIA1 port A direction.
 sta $dc03 ; Write A to CIA1 port B direction.
 lda $dc00 ; Load A with CIA1 joystick and matrix port.
 sta joy ; Write A to joy.
 and #4 ; Keep only the bits selected by #4.
 bne joy_right ; Continue at joy_right when the result is nonzero.
 lda #255 ; Load A with constant 255.
 sta direction ; Write A to direction.
joy_right:
 lda joy ; Load A with joy.
 and #8 ; Keep only the bits selected by #8.
 bne joy_fire ; Continue at joy_fire when the result is nonzero.
 lda #1 ; Load A with constant 1.
 sta direction ; Write A to direction.
joy_fire:
 lda joy ; Load A with joy.
 and #16 ; Keep only the bits selected by #16.
 bne keyboard ; Continue at keyboard when the result is nonzero.
 inc fire ; Increase fire by one.
; Keep the output latch zero. Only the selected column gets an output DDR
; bit; the others remain inputs. PB bit 2 reads A/D; PB bit 4 reads Space.
; This avoids driving unselected output columns high against joystick grounds.
keyboard:
 ; Only selected column is output-low; other columns are inputs.
 lda #0 ; Load A with constant 0.
 sta $dc00 ; Write A to CIA1 joystick and matrix port.
 lda #2 ; Load A with constant 2.
 sta $dc02 ; Write A to CIA1 port A direction.
 lda $dc01 ; Load A with CIA1 keyboard row input.
 and #4 ; Keep only the bits selected by #4.
 bne key_d ; Continue at key_d when the result is nonzero.
 lda #255 ; Load A with constant 255.
 sta direction ; Write A to direction.
key_d:
 lda #4 ; Load A with constant 4.
 sta $dc02 ; Write A to CIA1 port A direction.
 lda $dc01 ; Load A with CIA1 keyboard row input.
 and #4 ; Keep only the bits selected by #4.
 bne key_space ; Continue at key_space when the result is nonzero.
 lda #1 ; Load A with constant 1.
 sta direction ; Write A to direction.
key_space:
 lda #128 ; Load A with constant 128.
 sta $dc02 ; Write A to CIA1 port A direction.
 lda $dc01 ; Load A with CIA1 keyboard row input.
 and #16 ; Keep only the bits selected by #16.
 bne keys_done ; Continue at keys_done when the result is nonzero.
 inc fire ; Increase fire by one.
; Restore port A to inputs after scanning. Facing survives when idle and
; selects the mirrored sprite bank: right offset 0, left offset 10 frames.
keys_done:
 lda #0 ; Load A with constant 0.
 sta $dc02 ; Write A to CIA1 port A direction.
 lda direction ; Load A with direction.
 beq input_done ; Continue at input_done when the result is zero.
 bmi face_left ; Continue at face_left when bit 7 is set.
 lda #0 ; Load A with constant 0.
 sta facing ; Write A to facing.
 rts ; Return to the instruction after the caller JSR.
face_left:
 lda #10 ; Load A with constant 10.
 sta facing ; Write A to facing.
input_done: rts ; Return to the instruction after the caller JSR.
; ---------------------------------------------------------------------------
; 9. RUN/IDLE/JUMP STATE
; Frames 0..7 run, 8 idle, 9 airborne; frames 10..19 are their mirrored copies.
; anim_tick 0..23 divided by 3 gives one pose every three video frames.
; All animation is frame-based, not dependent on how fast the mainline spins.
animate:
 lda jump ; Load A with jump.
 bne airborne_frame ; Continue at airborne_frame when the result is nonzero.
 lda direction ; Load A with direction.
 beq standing ; Continue at standing when the result is zero.
 inc anim_tick ; Increase anim_tick by one.
 lda anim_tick ; Load A with anim_tick.
 cmp #24 ; Compare A with #24; retain A and update flags.
 bcc anim_no_wrap ; Continue at anim_no_wrap when carry is clear.
 lda #0 ; Load A with constant 0.
 sta anim_tick ; Write A to anim_tick.
anim_no_wrap:
 ldx #0 ; Load X with constant 0.
; Repeated subtraction divides a tiny bounded value by 3. CMP supplies carry
; before SBC, so the subtraction is correct without a separate SEC here.
frame_divide:
 cmp #3 ; Compare A with #3; retain A and update flags.
 bcc frame_ready ; Continue at frame_ready when carry is clear.
 sbc #3 ; Subtract #3 from A using carry as no borrow.
 inx ; Advance the X index by one.
 bne frame_divide ; Continue at frame_divide when the result is nonzero.
frame_ready:
 txa ; Copy X into A.
 and #7 ; Keep only the bits selected by #7.
 jmp set_frame ; Continue at set_frame without pushing a return address.
standing:
 lda #8 ; Load A with constant 8.
 jmp set_frame ; Continue at set_frame without pushing a return address.
airborne_frame:
 lda #9 ; Load A with constant 9.
; Add the facing bank, then $c0 sprite base. Each increment selects 64 bytes.
; Fire edge + grounded state accepts one jump. Holding fire cannot auto-repeat.
set_frame:
 clc ; Clear carry before a new addition.
 adc facing ; Add facing and carry to A; propagate overflow.
 adc #$c0 ; Add #$c0 and carry to A; propagate overflow.
 sta $07f8 ; Write A to $07f8.

 ; Matching white mask at $2800: pointer is body pointer minus $20.
 sec ; Set carry before subtraction.
 sbc #$20 ; Subtract #$20 from A using carry as no borrow.
 sta $07ff ; Write A to $07ff.

 lda fire ; Load A with fire.
 beq released ; Continue at released when the result is zero.
 lda old_fire ; Load A with old_fire.
 bne advance_jump ; Continue at advance_jump when the result is nonzero.
 lda jump ; Load A with jump.
 bne advance_jump ; Continue at advance_jump when the result is nonzero.
 lda #1 ; Load A with constant 1.
 sta jump ; Write A to jump.
  jsr jump_sfx ; Call jump_sfx; the routine returns with RTS.
; jump=0 means grounded; 1..33 indexes the precomputed arc (index minus one).
; A lookup table gives a clear tutorial-friendly parabola without signed
; fixed-point velocity/gravity code. Height and duration are edited below.
advance_jump:
 lda fire ; Load A with fire.
 sta old_fire ; Write A to old_fire.
 lda jump ; Load A with jump.
 beq on_ground ; Continue at on_ground when the result is zero.
 tax ; Copy A to X for indexed addressing.
 lda jump_y-1,x ; Load A with jump_y-1,x.
 sta $d001 ; Write A to $d001.
  sta $d00f ; Write A to $d00f.
 inc jump ; Increase jump by one.
 lda jump ; Load A with jump.
 cmp #34 ; Compare A with #34; retain A and update flags.
 bcc anim_done ; Continue at anim_done when carry is clear.
 lda #0 ; Load A with constant 0.
 sta jump ; Write A to jump.
on_ground:
 lda #168 ; Load A with constant 168.
 sta $d001 ; Write A to $d001.
  sta $d00f ; Write A to $d00f.
anim_done: rts ; Return to the instruction after the caller JSR.
; Only a release clears the previous-fire latch. Return to the shared jump
; progression so releasing the key early does not freeze the airborne motion.
released:
 lda #0 ; Load A with constant 0.
 sta old_fire ; Write A to old_fire.
 jmp advance_jump ; Continue at advance_jump without pushing a return address.
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
 lda fine ; Load A with fine.
 ora #$10 ; Set bits selected by #$10; retain other set bits.
 sta $d016 ; Write A to horizontal control and fine scroll.
 lda #5 ; Load A with constant 5.
 sta $d022 ; Write A to $d022.
 lda #13 ; Load A with constant 13.
 sta $d023 ; Write A to $d023.
 lda #75 ; Load A with constant 75.
 ldx #1 ; Load X with constant 1.
 jmp schedule ; Continue at schedule without pushing a return address.
woodland_trees:
 ; Cloud DMA has finished. Draw the trunks in front of the character layer.
 lda #0 ; Load A with constant 0.
 sta $d01b ; Write A to $d01b.
 jsr plot_trees ; Call plot_trees; the routine returns with RTS.
 lda #145 ; Load A with constant 145.
 ldx #2 ; Load X with constant 2.
 jmp schedule ; Continue at schedule without pushing a return address.
 !zone WoodlandCopy
shift_canopy: +fast_tree_band 0,1,9,woodland_canopy
 !if * > $a000 { !error "Woodland code exceeds reserved RAM" }
