; Clouds finish by line 114. At line 118 their slots are reused for trees.
; This fixed-zone multiplexer needs no sorting by Y: lifetimes don't overlap.
; Arbitrary-Y multiplexing requires a sorted list and more raster deadlines.
TREE_COUNT = 12
TREE_CAMERA_END = 2048
 
; Clamp the finite camera after reading input. Clearing direction at an end
; prevents the character scenery and clouds from continuing past the trees.
!zone TreeCamera
limit_tree_camera:
 lda direction
 beq .done
 bmi .left
 lda tree_camera+1
 cmp #>TREE_CAMERA_END
 bcc .right
 lda tree_camera
 cmp #<TREE_CAMERA_END
 bcc .right
 jmp .stop
.right:
 inc tree_camera
 bne .done
 inc tree_camera+1
.done: rts
.left:
 lda tree_camera
 ora tree_camera+1
 beq .stop
 lda tree_camera
 bne .subtract
 dec tree_camera+1
.subtract:
 dec tree_camera
 rts
.stop:
 lda #0
 sta direction
 rts
 
 ; Three composite trees maximum: one upper and one lower tile per tree.
; Each 24x21 multicolour tile is expanded to 48x42. Together: 48x84.
; Sprite slots 1..3 draw upper trunk pieces, 4..6 draw lower pieces.
; The map uses gaps of at least 192 pixels, with at most two visible trees.
!zone TreePrepare
prepare_trees:
 lda #0
 sta tree_enable
 sta tree_msb
 sta tree_slot
 ldx #0
.scan:
 lda tree_world_lo,x
 sec
 sbc tree_camera
 sta tree_x
 lda tree_world_hi,x
 sbc tree_camera+1
 sta tree_x+1
 ; Shift projection by 48 before clipping. Accepted 0..367 corresponds
 ; to actual VIC X=-24..343. Negative X uses pre-clipped graphics at X=0..3;
 ; this avoids relying on undefined/off-line VIC X-counter wrap behaviour.
 lda tree_x
 clc
 adc #48
 sta tree_x
 lda tree_x+1
 adc #0
 bmi .reject
 cmp #2
 bcs .reject
 sta tree_x+1
 lda tree_x+1
 beq .visible
 lda tree_x
 cmp #112             ; shifted projection <368; actual VIC X <344.
 bcs .reject
 jmp .visible
.reject:
 jmp .next
.visible:
 ; Actual VIC coordinate = world-camera+24, hence subtract 24 here.
 lda tree_x
 sec
 sbc #24
 sta tree_x
 lda tree_x+1
 sbc #0
 bmi .clip_left
 sta tree_x+1
 ldy tree_slot
 lda tree_kind,x
 asl
 clc
 adc #$d4
 sta tree_draw_ptr,y
 jmp .store_x
.clip_left:
 ; Shift the source by ceil(-X/4) logical pixels, then keep X=0..3.
 ; Expanded multicolour pixels are four physical pixels wide.
 lda tree_x
 eor #255
 clc
 adc #4
 lsr
 lsr
 sta tree_clip
 asl
 asl
 clc
 adc tree_x
 sta tree_x
 lda #0
 sta tree_x+1
 lda tree_kind,x
 beq .clip_base
 lda #12
.clip_base:
 clc
 adc #$e4             ; $e6 - 2: shift=1 selects first clipped tile pair.
 sta tree_ptr_temp
 lda tree_clip
 asl
 clc
 adc tree_ptr_temp
 ldy tree_slot
 sta tree_draw_ptr,y
.store_x:
 lda tree_x
 sta tree_draw_lo,y
 lda tree_enable
 ora tree_pair_bit,y
 sta tree_enable
 lda tree_x+1
 beq .low
 lda tree_msb
 ora tree_pair_bit,y
 sta tree_msb
.low:
 inc tree_slot
 lda tree_slot
 cmp #3
 beq .done
.next:
 inx
 cpx #TREE_COUNT
 beq .done
 jmp .scan
.done: rts
 
; Configure upper trunk pieces first, ready for sprite DMA at line 126.
; Shared sprite colours are brown and yellow, with local orange for trunks.
; Runner masks 0 and 7 use hi-res light-blue and white pixels.
!zone TreePlot
plot_trees:
 lda tree_enable
  ora #$81 
 sta $d015
 
 lda #$ff
 sta $d017
 lda #$7e
 sta $d01c
 
 lda #$7e
 sta $d01d
 lda #9
 sta $d025
 lda #7
 sta $d026
 lda tree_msb
 sta $d010
 
 lda tree_slot
 beq .no_trees
 
 ldx #0
.canopy:
 lda tree_draw_ptr,x
 sta $07f9,x
  lda #8 
 sta $d028,x
 txa
 asl
 tay
 lda tree_draw_lo,x
 sta $d002,y
 lda #126
 sta $d003,y
 inx
  cpx tree_slot 
 bne .canopy
 ldx #0
.trunk:
 lda tree_draw_ptr,x
 clc
 adc #1
 sta $07fc,x
 lda #8
 sta $d02b,x
 txa
 asl
 tay
 lda tree_draw_lo,x
 sta $d008,y
 lda #168
 sta $d009,y
 inx
  cpx tree_slot 
 bne .trunk
.no_trees:
 rts
 
; Sparse world map. Keep gaps >=192 pixels for at most two visible trees.
; Kinds select upper/lower tile pairs at persistent world positions.
 
; Two entries beyond the route keep the canopy and trunks aligned at its end.
tree_world_lo: !byte <40,<232,<440,<632,<872,<1064,<1272,<1472,<1664,<1856,<2088,<2280
tree_world_hi: !byte >40,>232,>440,>632,>872,>1064,>1272,>1472,>1664,>1856,>2088,>2280
tree_kind: !byte 0,1,0,1,1,0,1,0,1,0,0,1
 
tree_pair_bit: !byte $12,$24,$48
tree_camera: !word 0
tree_x: !word 0
tree_clip: !byte 0
tree_ptr_temp: !byte 0
tree_slot: !byte 0
tree_enable: !byte 0
tree_msb: !byte 0
tree_draw_lo: !fill 3,0
tree_draw_ptr: !fill 3,$d4
 
; Unrolled copies trade RAM for speed. Absolute LDA/STA costs 8 cycles per
; cell rather than an indexed pair plus a runtime loop. ACME emits the loops
; below at assembly time. Forward/reverse copy order still prevents smearing.
!macro fast_tree_band .id,.row,.rows,.map {
 lda pending+.id
 bne .active
 rts
.active:
 bpl .left
 jmp .right
.left:
 !for .c,0,38 {
 !for .r,0,.rows-1 {
 lda $0400+(.row+.r)*40+.c+1
 sta $0400+(.row+.r)*40+.c
 }
 }
 lda column+.id
 clc
 adc #39
 tax
 !for .r,0,.rows-1 {
 lda .map+.r*256,x
 sta $0400+(.row+.r)*40+39
 }
 jmp .clear
.right:
 !for .c,38,0 {
 !for .r,0,.rows-1 {
 lda $0400+(.row+.r)*40+.c
 sta $0400+(.row+.r)*40+.c+1
 }
 }
 ldx column+.id
 !for .r,0,.rows-1 {
 lda .map+.r*256,x
 sta $0400+(.row+.r)*40
 }
.clear:
 lda #0
 sta pending+.id
 rts
}
!zone TreeFastMid
shift_mid: +fast_tree_band 1,12,6,maps+6*256
!zone TreeFastNear
shift_near: +fast_tree_band 2,18,6,maps+12*256
