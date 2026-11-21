; ---------------------------------------------------------------------------
; ORIGINAL SID SCORE: "Twilight Passage" (PAL, 50 calls/second)
; Voice 1: slowly phrased triangle lead; voice 2: pulse-wave ostinato.
; Voice 3 is reserved for the jump sound, so it cannot steal music notes.
; No imported tune, sampled music, interrupt or external player is required.
; Routines clobber A/X/Y and are called with interrupts already disabled.
; ---------------------------------------------------------------------------
music_init:
 lda #0 ; Load A with constant 0.
 sta music_clock ; Write A to music_clock.
 sta melody_pos ; Write A to melody_pos.
 sta arp_clock ; Write A to arp_clock.
 sta arp_pos ; Write A to arp_pos.
 sta pulse_motion ; Write A to pulse_motion.
 sta sfx_timer ; Write A to sfx_timer.
 ldx #24 ; Load X with constant 24.
.clear_sid:
 lda #0 ; Load A with constant 0.
 sta $d400,x             ; Clear all writable SID registers, including filter.
 dex ; Decrease the X counter by one.
 bpl .clear_sid ; Continue at .clear_sid when bit 7 is clear.
 lda #$0c ; Load A with constant $0c.
 sta $d418               ; Master volume 12/15; filter modes remain disabled.
 lda #$67 ; Load A with constant $67.
 sta $d405               ; Voice 1: soft attack, medium decay.
 lda #$a8 ; Load A with constant $a8.
 sta $d406               ; Sustain 10, long release: the atmospheric lead.
 lda #$24 ; Load A with constant $24.
 sta $d40c               ; Voice 2: quicker attack/decay for pulse ostinato.
 lda #$76 ; Load A with constant $76.
 sta $d40d               ; Lower sustain, moderate release.
 lda #8 ; Load A with constant 8.
 sta $d40a               ; Pulse width high nibble: approximately 50% duty.
 lda #$04 ; Load A with constant $04.
 sta $d413               ; Voice 3: quick attack, short decay for jump.
 lda #$84 ; Load A with constant $84.
 sta $d414               ; Moderate sustain and short release.
 rts ; Return to the instruction after the caller JSR.

music_play:
 ; A 24-frame note lasts 0.48 seconds at 50 Hz. Gate is lowered four frames
 ; before the next note: ADSR gets a real release interval before retriggering.
 lda music_clock ; Load A with music_clock.
 bne .not_new_note ; Continue at .not_new_note when the result is nonzero.
 ldx melody_pos ; Load X with melody_pos.
 lda melody,x ; Load A with melody,x.
 tax ; Copy A to X for indexed addressing.
 lda note_lo,x ; Load A with note_lo,x.
 sta $d400 ; Write A to $d400.
 lda note_hi,x ; Load A with note_hi,x.
 sta $d401 ; Write A to $d401.
 lda #$11 ; Load A with constant $11.
 sta $d404               ; Triangle ($10) + gate (1), no sync/ring modulation.
 inc melody_pos ; Increase melody_pos by one.
 lda melody_pos ; Load A with melody_pos.
 and #31 ; Keep only the bits selected by #31.
 sta melody_pos          ; 32-note original melody loops naturally.
.not_new_note:
 lda music_clock ; Load A with music_clock.
 cmp #20 ; Compare A with #20; retain A and update flags.
 bne .lead_gate_done ; Continue at .lead_gate_done when the result is nonzero.
 lda #$10 ; Load A with constant $10.
 sta $d404               ; Same waveform, gate off starts release.
.lead_gate_done:
 ; A separate six-frame sequencer makes four accompaniment notes per lead.
 lda arp_clock ; Load A with arp_clock.
 bne .not_new_arp ; Continue at .not_new_arp when the result is nonzero.
 lda arp_pos ; Load A with arp_pos.
 lsr ; Shift right, moving bit 0 into carry.
 lsr ; Shift right, moving bit 0 into carry.
 lsr ; Shift right, moving bit 0 into carry.
 and #3 ; Keep only the bits selected by #3.
 tax ; Copy A to X for indexed addressing.
 lda chord_roots,x ; Load A with chord_roots,x.
 sta chord_temp ; Write A to chord_temp.
 lda arp_pos ; Load A with arp_pos.
 and #3 ; Keep only the bits selected by #3.
 tax ; Copy A to X for indexed addressing.
 lda arp_intervals,x ; Load A with arp_intervals,x.
 clc ; Clear carry before a new addition.
 adc chord_temp ; Add chord_temp and carry to A; propagate overflow.
 tax ; Copy A to X for indexed addressing.
 lda note_lo,x ; Load A with note_lo,x.
 sta $d407 ; Write A to $d407.
 lda note_hi,x ; Load A with note_hi,x.
 sta $d408 ; Write A to $d408.
 lda #$41 ; Load A with constant $41.
 sta $d40b               ; Pulse ($40) with gate set.
 inc arp_pos ; Increase arp_pos by one.
.not_new_arp:
 lda arp_clock ; Load A with arp_clock.
 cmp #4 ; Compare A with #4; retain A and update flags.
 bne .arp_gate_done ; Continue at .arp_gate_done when the result is nonzero.
 lda #$40 ; Load A with constant $40.
 sta $d40b               ; Two frames of release before the next pulse note.
.arp_gate_done:
 inc pulse_motion ; Increase pulse_motion by one.
 lda pulse_motion ; Load A with pulse_motion.
 sta $d409               ; Slow pulse-width motion adds colour, not pitch.
 inc music_clock ; Increase music_clock by one.
 lda music_clock ; Load A with music_clock.
 cmp #24 ; Compare A with #24; retain A and update flags.
 bcc .music_clock_ok ; Continue at .music_clock_ok when carry is clear.
 lda #0 ; Load A with constant 0.
 sta music_clock ; Write A to music_clock.
.music_clock_ok:
 inc arp_clock ; Increase arp_clock by one.
 lda arp_clock ; Load A with arp_clock.
 cmp #6 ; Compare A with #6; retain A and update flags.
 bcc .arp_clock_ok ; Continue at .arp_clock_ok when carry is clear.
 lda #0 ; Load A with constant 0.
 sta arp_clock ; Write A to arp_clock.
.arp_clock_ok:
 ; Ascending triangle chirp on dedicated voice 3. No busy waits: one small
 ; pitch update per video frame keeps the graphics schedule predictable.
 lda sfx_timer ; Load A with sfx_timer.
 beq .done ; Continue at .done when the result is zero.
 dec sfx_timer ; Decrease sfx_timer by one.
 beq .release_jump ; Continue at .release_jump when the result is zero.
 lda #16 ; Load A with constant 16.
 sec ; Set carry before subtraction.
 sbc sfx_timer ; Subtract sfx_timer from A using carry as no borrow.
 asl ; Shift left, moving bit 7 into carry.
 clc ; Clear carry before a new addition.
 adc #$10 ; Add #$10 and carry to A; propagate overflow.
 sta $d40f               ; High frequency byte rises throughout the jump chirp.
 lda #0 ; Load A with constant 0.
 sta $d40e ; Write A to $d40e.
 rts ; Return to the instruction after the caller JSR.
.release_jump:
 lda #$10 ; Load A with constant $10.
 sta $d412               ; Gate off; allow the envelope's release to finish.
.done:
 rts ; Return to the instruction after the caller JSR.

jump_sfx:
 ; Called ONLY at jump acceptance, not each frame the fire button is held.
 lda #16 ; Load A with constant 16.
 sta sfx_timer ; Write A to sfx_timer.
 lda #0 ; Load A with constant 0.
 sta $d40e ; Write A to $d40e.
 lda #$10 ; Load A with constant $10.
 sta $d40f ; Write A to $d40f.
 lda #$11 ; Load A with constant $11.
 sta $d412               ; Triangle + gate. Music voices 1/2 are untouched.
 rts ; Return to the instruction after the caller JSR.

music_clock: !byte 0
melody_pos: !byte 0
arp_clock: !byte 0
arp_pos: !byte 0
pulse_motion: !byte 0
chord_temp: !byte 0
sfx_timer: !byte 0
; Note index 0 = C2 (MIDI 36). Modal D-minor colours, independently composed.
melody:
!byte 38,45,41,40,38,36,33,36, 38,41,45,48,45,41,40,36
!byte 34,41,38,36,34,33,29,33, 36,43,40,38,33,40,37,33
chord_roots: !byte 14,10,12,9
arp_intervals: !byte 0,7,12,7
; PAL SID tuning: round(Hz * 2^24 / 985248). Tables are low/high bytes.
; Valid indices 0..59 = C2..B6. Higher notes require range/tuning care;
; a SID frequency word is only 16 bits, so do not silently truncate overflow.
note_lo:
!byte $5a,$9c,$e2,$2d,$7b,$cf,$27,$85,$e8,$51,$c1,$37
!byte $b4,$38,$c4,$59,$f7,$9d,$4e,$0a,$d0,$a2,$81,$6d
!byte $67,$70,$89,$b2,$ed,$3b,$9c,$13,$a0,$45,$02,$da
!byte $ce,$e0,$11,$64,$da,$76,$39,$26,$40,$89,$04,$b4
!byte $9c,$c0,$23,$c8,$b4,$eb,$72,$4c,$80,$12,$08,$68
note_hi:
!byte $04,$04,$04,$05,$05,$05,$06,$06,$06,$07,$07,$08
!byte $08,$09,$09,$0a,$0a,$0b,$0c,$0d,$0d,$0e,$0f,$10
!byte $11,$12,$13,$14,$15,$17,$18,$1a,$1b,$1d,$1f,$20
!byte $22,$24,$27,$29,$2b,$2e,$31,$34,$37,$3a,$3e,$41
!byte $45,$49,$4e,$52,$57,$5c,$62,$68,$6e,$75,$7c,$83
