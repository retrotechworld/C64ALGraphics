; Clouds finish by line 114. At line 118 their slots are reused for trees.
; This fixed-zone multiplexer needs no sorting by Y: lifetimes don't overlap.
; Arbitrary-Y multiplexing requires a sorted list and more raster deadlines.
TREE_COUNT = 12
TREE_CAMERA_END = 2048

; Clamp the finite camera after reading input. Clearing direction at an end
; prevents the character scenery and clouds from continuing past the trees.
!zone TreeCamera
limit_tree_camera:
 lda direction ; Load A with direction.
 beq .done ; Continue at .done when the result is zero.
 bmi .left ; Continue at .left when bit 7 is set.
 lda tree_camera+1 ; Load A with tree_camera+1.
 cmp #>TREE_CAMERA_END ; Compare A with #>TREE_CAMERA_END; retain A and update flags.
 bcc .right ; Continue at .right when carry is clear.
 lda tree_camera ; Load A with tree_camera.
 cmp #<TREE_CAMERA_END ; Compare A with #<TREE_CAMERA_END; retain A and update flags.
 bcc .right ; Continue at .right when carry is clear.
 jmp .stop ; Continue at .stop without pushing a return address.
.right:
 inc tree_camera ; Increase tree_camera by one.
 bne .done ; Continue at .done when the result is nonzero.
 inc tree_camera+1 ; Increase tree_camera+1 by one.
.done: rts ; Return to the instruction after the caller JSR.
.left:
 lda tree_camera ; Load A with tree_camera.
 ora tree_camera+1 ; Set bits selected by tree_camera+1; retain other set bits.
 beq .stop ; Continue at .stop when the result is zero.
 lda tree_camera ; Load A with tree_camera.
 bne .subtract ; Continue at .subtract when the result is nonzero.
 dec tree_camera+1 ; Decrease tree_camera+1 by one.
.subtract:
 dec tree_camera ; Decrease tree_camera by one.
 rts ; Return to the instruction after the caller JSR.
.stop:
 lda #0 ; Load A with constant 0.
 sta direction ; Write A to direction.
 rts ; Return to the instruction after the caller JSR.

 ; Three composite trees maximum: one upper and one lower tile per tree.
; Each 24x21 multicolour tile is expanded to 48x42. Together: 48x84.
; Sprite slots 1..3 draw upper trunk pieces, 4..6 draw lower pieces.
; The map uses gaps of at least 192 pixels, with at most two visible trees.
!zone TreePrepare
prepare_trees:
 lda #0 ; Load A with constant 0.
 sta tree_enable ; Write A to tree_enable.
 sta tree_msb ; Write A to tree_msb.
 sta tree_slot ; Write A to tree_slot.
 ldx #0 ; Load X with constant 0.
.scan:
 lda tree_world_lo,x ; Load A with tree_world_lo,x.
 sec ; Set carry before subtraction.
 sbc tree_camera ; Subtract tree_camera from A using carry as no borrow.
 sta tree_x ; Write A to tree_x.
 lda tree_world_hi,x ; Load A with tree_world_hi,x.
 sbc tree_camera+1 ; Subtract tree_camera+1 from A using carry as no borrow.
 sta tree_x+1 ; Write A to tree_x+1.
 ; Shift projection by 48 before clipping. Accepted 0..367 corresponds
 ; to actual VIC X=-24..343. Negative X uses pre-clipped graphics at X=0..3;
 ; this avoids relying on undefined/off-line VIC X-counter wrap behaviour.
 lda tree_x ; Load A with tree_x.
 clc ; Clear carry before a new addition.
 adc #48 ; Add #48 and carry to A; propagate overflow.
 sta tree_x ; Write A to tree_x.
 lda tree_x+1 ; Load A with tree_x+1.
 adc #0 ; Add #0 and carry to A; propagate overflow.
 bmi .reject ; Continue at .reject when bit 7 is set.
 cmp #2 ; Compare A with #2; retain A and update flags.
 bcs .reject ; Continue at .reject when carry is set.
 sta tree_x+1 ; Write A to tree_x+1.
 lda tree_x+1 ; Load A with tree_x+1.
 beq .visible ; Continue at .visible when the result is zero.
 lda tree_x ; Load A with tree_x.
 cmp #112             ; shifted projection <368; actual VIC X <344.
 bcs .reject ; Continue at .reject when carry is set.
 jmp .visible ; Continue at .visible without pushing a return address.
.reject:
 jmp .next ; Continue at .next without pushing a return address.
.visible:
 ; Actual VIC coordinate = world-camera+24, hence subtract 24 here.
 lda tree_x ; Load A with tree_x.
 sec ; Set carry before subtraction.
 sbc #24 ; Subtract #24 from A using carry as no borrow.
 sta tree_x ; Write A to tree_x.
 lda tree_x+1 ; Load A with tree_x+1.
 sbc #0 ; Subtract #0 from A using carry as no borrow.
 bmi .clip_left ; Continue at .clip_left when bit 7 is set.
 sta tree_x+1 ; Write A to tree_x+1.
 ldy tree_slot ; Load Y with tree_slot.
 lda tree_kind,x ; Load A with tree_kind,x.
 asl ; Shift left, moving bit 7 into carry.
 clc ; Clear carry before a new addition.
 adc #$d4 ; Add #$d4 and carry to A; propagate overflow.
 sta tree_draw_ptr,y ; Write A to tree_draw_ptr,y.
 jmp .store_x ; Continue at .store_x without pushing a return address.
.clip_left:
 ; Shift the source by ceil(-X/4) logical pixels, then keep X=0..3.
 ; Expanded multicolour pixels are four physical pixels wide.
 lda tree_x ; Load A with tree_x.
 eor #255 ; Toggle A bits selected by #255.
 clc ; Clear carry before a new addition.
 adc #4 ; Add #4 and carry to A; propagate overflow.
 lsr ; Shift right, moving bit 0 into carry.
 lsr ; Shift right, moving bit 0 into carry.
 sta tree_clip ; Write A to tree_clip.
 asl ; Shift left, moving bit 7 into carry.
 asl ; Shift left, moving bit 7 into carry.
 clc ; Clear carry before a new addition.
 adc tree_x ; Add tree_x and carry to A; propagate overflow.
 sta tree_x ; Write A to tree_x.
 lda #0 ; Load A with constant 0.
 sta tree_x+1 ; Write A to tree_x+1.
 lda tree_kind,x ; Load A with tree_kind,x.
 beq .clip_base ; Continue at .clip_base when the result is zero.
 lda #12 ; Load A with constant 12.
.clip_base:
 clc ; Clear carry before a new addition.
 adc #$e4             ; $e6 - 2: shift=1 selects first clipped tile pair.
 sta tree_ptr_temp ; Write A to tree_ptr_temp.
 lda tree_clip ; Load A with tree_clip.
 asl ; Shift left, moving bit 7 into carry.
 clc ; Clear carry before a new addition.
 adc tree_ptr_temp ; Add tree_ptr_temp and carry to A; propagate overflow.
 ldy tree_slot ; Load Y with tree_slot.
 sta tree_draw_ptr,y ; Write A to tree_draw_ptr,y.
.store_x:
 lda tree_x ; Load A with tree_x.
 sta tree_draw_lo,y ; Write A to tree_draw_lo,y.
 lda tree_enable ; Load A with tree_enable.
 ora tree_pair_bit,y ; Set bits selected by tree_pair_bit,y; retain other set bits.
 sta tree_enable ; Write A to tree_enable.
 lda tree_x+1 ; Load A with tree_x+1.
 beq .low ; Continue at .low when the result is zero.
 lda tree_msb ; Load A with tree_msb.
 ora tree_pair_bit,y ; Set bits selected by tree_pair_bit,y; retain other set bits.
 sta tree_msb ; Write A to tree_msb.
.low:
 inc tree_slot ; Increase tree_slot by one.
 lda tree_slot ; Load A with tree_slot.
 cmp #3 ; Compare A with #3; retain A and update flags.
 beq .done ; Continue at .done when the result is zero.
.next:
 inx ; Advance the X index by one.
 cpx #TREE_COUNT ; Compare X with #TREE_COUNT; update flags.
 beq .done ; Continue at .done when the result is zero.
 jmp .scan ; Continue at .scan without pushing a return address.
.done: rts ; Return to the instruction after the caller JSR.

; Configure upper trunk pieces first, ready for sprite DMA at line 126.
; Shared sprite colours are brown and yellow, with local orange for trunks.
; Runner masks 0 and 7 use hi-res light-blue and white pixels.
!zone TreePlot
plot_trees:
 lda tree_enable ; Load A with tree_enable.
  ora #$81 ; Set bits selected by #$81; retain other set bits.
 sta $d015 ; Write A to sprite enable mask.

 lda #$ff ; Load A with constant $ff.
 sta $d017 ; Write A to $d017.
 lda #$7e ; Load A with constant $7e.
 sta $d01c ; Write A to $d01c.

 lda #$7e ; Load A with constant $7e.
 sta $d01d ; Write A to $d01d.
 lda #9 ; Load A with constant 9.
 sta $d025 ; Write A to $d025.
 lda #7 ; Load A with constant 7.
 sta $d026 ; Write A to $d026.
 lda tree_msb ; Load A with tree_msb.
 sta $d010 ; Write A to sprite X high bits.

 lda tree_slot ; Load A with tree_slot.
 beq .no_trees ; Continue at .no_trees when the result is zero.

 ldx #0 ; Load X with constant 0.
.canopy:
 lda tree_draw_ptr,x ; Load A with tree_draw_ptr,x.
 sta $07f9,x ; Write A to $07f9,x.
  lda #8 ; Load A with constant 8.
 sta $d028,x ; Write A to $d028,x.
 txa ; Copy X into A.
 asl ; Shift left, moving bit 7 into carry.
 tay ; Copy A to Y for indexed addressing.
 lda tree_draw_lo,x ; Load A with tree_draw_lo,x.
 sta $d002,y ; Write A to $d002,y.
 lda #126 ; Load A with constant 126.
 sta $d003,y ; Write A to $d003,y.
 inx ; Advance the X index by one.
  cpx tree_slot ; Compare X with tree_slot; update flags.
 bne .canopy ; Continue at .canopy when the result is nonzero.
 ldx #0 ; Load X with constant 0.
.trunk:
 lda tree_draw_ptr,x ; Load A with tree_draw_ptr,x.
 clc ; Clear carry before a new addition.
 adc #1 ; Add #1 and carry to A; propagate overflow.
 sta $07fc,x ; Write A to $07fc,x.
 lda #8 ; Load A with constant 8.
 sta $d02b,x ; Write A to $d02b,x.
 txa ; Copy X into A.
 asl ; Shift left, moving bit 7 into carry.
 tay ; Copy A to Y for indexed addressing.
 lda tree_draw_lo,x ; Load A with tree_draw_lo,x.
 sta $d008,y ; Write A to $d008,y.
 lda #168 ; Load A with constant 168.
 sta $d009,y ; Write A to $d009,y.
 inx ; Advance the X index by one.
  cpx tree_slot ; Compare X with tree_slot; update flags.
 bne .trunk ; Continue at .trunk when the result is nonzero.
.no_trees:
 rts ; Return to the instruction after the caller JSR.

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
 lda pending+.id ; Load A with pending+.id.
 bne .active ; Continue at .active when the result is nonzero.
 rts ; Return to the instruction after the caller JSR.
.active:
 bpl .left ; Continue at .left when bit 7 is clear.
 jmp .right ; Continue at .right without pushing a return address.
.left:
 !for .c,0,38 {
 !for .r,0,.rows-1 {
 lda $0400+(.row+.r)*40+.c+1 ; Load A with $0400+(.row+.r)*40+.c+1.
 sta $0400+(.row+.r)*40+.c ; Write A to $0400+(.row+.r)*40+.c.
 }
 }
 lda column+.id ; Load A with column+.id.
 clc ; Clear carry before a new addition.
 adc #39 ; Add #39 and carry to A; propagate overflow.
 tax ; Copy A to X for indexed addressing.
 !for .r,0,.rows-1 {
 lda .map+.r*256,x ; Load A with .map+.r*256,x.
 sta $0400+(.row+.r)*40+39 ; Write A to $0400+(.row+.r)*40+39.
 }
 jmp .clear ; Continue at .clear without pushing a return address.
.right:
 !for .c,38,0 {
 !for .r,0,.rows-1 {
 lda $0400+(.row+.r)*40+.c ; Load A with $0400+(.row+.r)*40+.c.
 sta $0400+(.row+.r)*40+.c+1 ; Write A to $0400+(.row+.r)*40+.c+1.
 }
 }
 ldx column+.id ; Load X with column+.id.
 !for .r,0,.rows-1 {
 lda .map+.r*256,x ; Load A with .map+.r*256,x.
 sta $0400+(.row+.r)*40 ; Write A to $0400+(.row+.r)*40.
 }
.clear:
 lda #0 ; Load A with constant 0.
 sta pending+.id ; Write A to pending+.id.
 rts ; Return to the instruction after the caller JSR.
}
!zone TreeFastMid
shift_mid: +fast_tree_band 1,12,6,maps+6*256
!zone TreeFastNear
shift_near: +fast_tree_band 2,18,6,maps+12*256
