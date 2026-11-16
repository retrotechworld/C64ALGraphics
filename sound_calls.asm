; Standalone ACME demonstration, normal BASIC startup, PAL tuning.
; Joystick port 2 fire requests one effect per new press.
; Replace JSR sound_hit at the acceptance point of a real collision.
; Reset to exit. Calls and all SID writes share one context.
!cpu 6510
* = $0801
!byte $0b,$08,$0a,$00,$9e
!text "2061"
!byte 0,0,0
start:
    sei
    cld
    lda #$7f
    sta $dc0d
    sta $dd0d
    lda $dc0d
    lda $dd0d
    lda #0
    sta $d01a
    sta $d015
    sta old_fire
    sta $dc02           ; CIA1 port A inputs for joystick 2
    sta $dc03           ; No keyboard scanning in this demo
    jsr sound_init
frame:
    bit $d011
    bpl frame
leave_high:
    bit $d011
    bmi leave_high
    lda $dc00
    and #$10
    eor #$10            ; Nonzero means pressed
    beq released
    lda old_fire
    bne update
    lda #1
    sta old_fire
    jsr sound_hit       ; A game calls here after accepting a hit
    jmp update
released:
    lda #0
    sta old_fire
update:
    jsr sound_tick      ; Exactly one call per video frame
    jmp frame
old_fire: !byte 0

; Interface: clobbers A, X, Y and flags. No zero-page workspace.
; Voice 1 melody, voice 2 accompaniment, voice 3 effect.
; All calls must use the same execution context with D clear.
sound_init:
    jsr sound_stop
    lda #0
    sta lead_clock
    sta bass_clock
    sta lead_pos
    sta bass_pos
    sta hit_request
    sta hit_delay
    sta hit_timer
    lda #$24
    sta $d405           ; Melody attack/decay
    lda #$88
    sta $d406           ; Melody sustain/release
    lda #$02
    sta $d40c           ; Pulse accompaniment attack/decay
    lda #$74
    sta $d40d
    lda #0
    sta $d409
    lda #8
    sta $d40a           ; 12-bit pulse width $800
    lda #$02
    sta $d413           ; Effect attack/decay
    lda #$08
    sta $d414           ; Effect sustain 0, release 8
    lda #12
    sta $d418           ; Master volume, filter modes clear
    rts

sound_hit:
    lda #1
    sta hit_request     ; One-byte mailbox, latest hit wins
    rts

sound_tick:
    jsr music_tick
    lda hit_request
    beq no_request
    lda #0
    sta hit_request
    sta hit_timer
    lda #$80
    sta $d412           ; Noise selected, gate off
    lda #1
    sta hit_delay       ; Leave gate off until next frame
    rts
no_request:
    lda hit_delay
    beq running_effect
    lda #0
    sta hit_delay
    sta $d40e
    lda #$30
    sta $d40f
    lda #10
    sta hit_timer
    lda #$81
    sta $d412           ; Start noise and gate
    rts
running_effect:
    lda hit_timer
    beq effect_done
    dec hit_timer
    beq release_effect
    lda hit_timer
    asl
    asl
    clc
    adc #8
    sta $d40f           ; Descending frequency word
    rts
release_effect:
    lda #$80
    sta $d412
effect_done:
    rts

music_tick:
    lda lead_clock
    bne lead_release_check
    ldx lead_pos
    lda melody,x
    tay
    lda note_lo,y
    sta $d400
    lda note_hi,y
    sta $d401
    lda #$11
    sta $d404           ; Triangle and gate
    inc lead_pos
    lda lead_pos
    and #7
    sta lead_pos
lead_release_check:
    lda lead_clock
    cmp #20
    bne lead_advance
    lda #$10
    sta $d404           ; Four frames released before next note
lead_advance:
    inc lead_clock
    lda lead_clock
    cmp #24
    bne bass_update
    lda #0
    sta lead_clock
bass_update:
    lda bass_clock
    bne bass_release_check
    ldx bass_pos
    lda bass,x
    tay
    lda note_lo,y
    sta $d407
    lda note_hi,y
    sta $d408
    lda #$41
    sta $d40b           ; Pulse and gate
    inc bass_pos
    lda bass_pos
    and #7
    sta bass_pos
bass_release_check:
    lda bass_clock
    cmp #4
    bne bass_advance
    lda #$40
    sta $d40b           ; Two frames released before next note
bass_advance:
    inc bass_clock
    lda bass_clock
    cmp #6
    bne music_done
    lda #0
    sta bass_clock
music_done:
    rts

sound_stop:
    lda #0
    ldx #24
clear_sid:
    sta $d400,x         ; Includes master volume and filter controls
    dex
    bpl clear_sid
    sta hit_request
    sta hit_delay
    sta hit_timer
    rts
lead_clock: !byte 0
bass_clock: !byte 0
lead_pos: !byte 0
bass_pos: !byte 0
hit_request: !byte 0
hit_delay: !byte 0
hit_timer: !byte 0
; Eight original note events; indices refer to C2..B4 below.
melody: !byte 24,27,31,34,31,27,22,19
bass:   !byte 0,7,12,7,3,10,15,10
; PAL frequency tables generated with round(Hz*2^24/985248).
note_lo:
!byte $5a,$9c,$e2,$2d,$7b,$cf,$27,$85,$e8,$51,$c1,$37
!byte $b4,$38,$c4,$59,$f7,$9d,$4e,$0a,$d0,$a2,$81,$6d
!byte $67,$70,$89,$b2,$ed,$3b,$9c,$13,$a0,$45,$02,$da
note_hi:
!byte $04,$04,$04,$05,$05,$05,$06,$06,$06,$07,$07,$08
!byte $08,$09,$09,$0a,$0a,$0b,$0c,$0d,$0d,$0e,$0f,$10
!byte $11,$12,$13,$14,$15,$17,$18,$1a,$1b,$1d,$1f,$20
