; ---------------------------------------------------------------------------
; ORIGINAL SID SCORE: "Twilight Passage" (PAL, 50 calls/second)
; Voice 1: slowly phrased triangle lead; voice 2: pulse-wave ostinato.
; Voice 3 is reserved for the jump sound, so it cannot steal music notes.
; No imported tune, sampled music, interrupt or external player is required.
; Routines clobber A/X/Y and are called with interrupts already disabled.
; ---------------------------------------------------------------------------
music_init:
 lda #0
 sta music_clock
 sta melody_pos
 sta arp_clock
 sta arp_pos
 sta pulse_motion
 sta sfx_timer
 ldx #24
.clear_sid:
 lda #0
 sta $d400,x             ; Clear all writable SID registers, including filter.
 dex
 bpl .clear_sid
 lda #$0c
 sta $d418               ; Master volume 12/15; filter modes remain disabled.
 lda #$67
 sta $d405               ; Voice 1: soft attack, medium decay.
 lda #$a8
 sta $d406               ; Sustain 10, long release: the atmospheric lead.
 lda #$24
 sta $d40c               ; Voice 2: quicker attack/decay for pulse ostinato.
 lda #$76
 sta $d40d               ; Lower sustain, moderate release.
 lda #8
 sta $d40a               ; Pulse width high nibble: approximately 50% duty.
 lda #$04
 sta $d413               ; Voice 3: quick attack, short decay for jump.
 lda #$84
 sta $d414               ; Moderate sustain and short release.
 rts
 
music_play:
 ; A 24-frame note lasts 0.48 seconds at 50 Hz. Gate is lowered four frames
 ; before the next note: ADSR gets a real release interval before retriggering.
 lda music_clock
 bne .not_new_note
 ldx melody_pos
 lda melody,x
 tax
 lda note_lo,x
 sta $d400
 lda note_hi,x
 sta $d401
 lda #$11
 sta $d404               ; Triangle ($10) + gate (1), no sync/ring modulation.
 inc melody_pos
 lda melody_pos
 and #31
 sta melody_pos          ; 32-note original melody loops naturally.
.not_new_note:
 lda music_clock
 cmp #20
 bne .lead_gate_done
 lda #$10
 sta $d404               ; Same waveform, gate off starts release.
.lead_gate_done:
 ; A separate six-frame sequencer makes four accompaniment notes per lead.
 lda arp_clock
 bne .not_new_arp
 lda arp_pos
 lsr
 lsr
 lsr
 and #3
 tax
 lda chord_roots,x
 sta chord_temp
 lda arp_pos
 and #3
 tax
 lda arp_intervals,x
 clc
 adc chord_temp
 tax
 lda note_lo,x
 sta $d407
 lda note_hi,x
 sta $d408
 lda #$41
 sta $d40b               ; Pulse ($40) with gate set.
 inc arp_pos
.not_new_arp:
 lda arp_clock
 cmp #4
 bne .arp_gate_done
 lda #$40
 sta $d40b               ; Two frames of release before the next pulse note.
.arp_gate_done:
 inc pulse_motion
 lda pulse_motion
 sta $d409               ; Slow pulse-width motion adds colour, not pitch.
 inc music_clock
 lda music_clock
 cmp #24
 bcc .music_clock_ok
 lda #0
 sta music_clock
.music_clock_ok:
 inc arp_clock
 lda arp_clock
 cmp #6
 bcc .arp_clock_ok
 lda #0
 sta arp_clock
.arp_clock_ok:
 ; Ascending triangle chirp on dedicated voice 3. No busy waits: one small
 ; pitch update per video frame keeps the graphics schedule predictable.
 lda sfx_timer
 beq .done
 dec sfx_timer
 beq .release_jump
 lda #16
 sec
 sbc sfx_timer
 asl
 clc
 adc #$10
 sta $d40f               ; High frequency byte rises throughout the jump chirp.
 lda #0
 sta $d40e
 rts
.release_jump:
 lda #$10
 sta $d412               ; Gate off; allow the envelope's release to finish.
.done:
 rts
 
jump_sfx:
 ; Called ONLY at jump acceptance, not each frame the fire button is held.
 lda #16
 sta sfx_timer
 lda #0
 sta $d40e
 lda #$10
 sta $d40f
 lda #$11
 sta $d412               ; Triangle + gate. Music voices 1/2 are untouched.
 rts
 
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
