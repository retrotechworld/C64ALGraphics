; WHAT: An automatically scrolling 40-column viewport into a 128-column world.
; WHY: Show a level wider than the 40-column display without confusing world and screen coordinates.
; HOW: Add a camera column to each visible map lookup and copy one viewport of screen codes and colour attributes.

; BEGINNER READING GUIDE
; Read start, render, row and cell; then main in example 03.
; WHAT describes the action; WHY gives its purpose; HOW explains the
; mechanism.
; A = accumulator; X = row/frame counter; Y = column or tile ID.
; # is immediate, $ is hexadecimal, < and > select address bytes.
; ($fb),Y means indirect indexed addressing through a zero-page pointer.
; This self-contained source assembles with ACME; Check timing in PAL VICE.

; ACME 6510 source. Assemble from the source directory.
; SYS 2061. Hardware takeover: reset to return to BASIC.
; Assembly origin: place the following bytes at $0801.
* = $0801
; BASIC line header: next-line pointer $080b, line 10 and SYS token $9e.
!byte $0b,$08,$0a,$00,$9e
; Decimal entry address stored as BASIC text; execution starts at $080d.
!text "2061"
; End BASIC text with zero, then end the BASIC program with a zero pointer.
!byte 0,0,0
; WHAT: Configure the display hardware and take over the machine.
; WHY: Custom characters need a known VIC bank, mode and palette.
; HOW: Disable IRQ sources, select bank 0 and point VIC at $2000.
start:
    ; Set interrupt-disable so normal maskable IRQs cannot interrupt setup.
    sei                 ; No KERNAL IRQ while we own the display.
    ; Load constant $7f into A; # means a value, not a memory read.
    lda #$7f ; Load A with constant $7f.
; Store A in CIA1 interrupt control; STA leaves the arithmetic flags
; unchanged.
    sta $dc0d           ; Disable CIA interrupt masks.
; Store A in CIA2 interrupt control; STA leaves the arithmetic flags
; unchanged.
    sta $dd0d ; Write A to $dd0d.
; Read CIA1 interrupt control into A; loading also updates zero and negative
; flags.
    lda $dc0d           ; Acknowledge pending CIA interrupts.
; Read CIA2 interrupt control into A; loading also updates zero and negative
; flags.
    lda $dd0d ; Load A with $dd0d.
    ; Load constant 0 into A; # means a value, not a memory read.
    lda #0 ; Load A with constant 0.
; Store A in VIC interrupt enable; STA leaves the arithmetic flags unchanged.
    sta $d01a           ; Disable VIC IRQs.
; Store A in sprite enable mask; STA leaves the arithmetic flags unchanged.
    sta $d015           ; No sprites in these tile-only examples.
    ; Store A in border colour; STA leaves the arithmetic flags unchanged.
    sta $d020 ; Write A to $d020.
    ; Store A in screen background; STA leaves the arithmetic flags unchanged.
    sta $d021 ; Write A to $d021.
    ; Load constant $06 into A; # means a value, not a memory read.
    lda #$06 ; Load A with constant $06.
; Store A in shared multicolour 01; STA leaves the arithmetic flags unchanged.
    sta $d022           ; Shared multicolour 01: blue.
    ; Load constant $01 into A; # means a value, not a memory read.
    lda #$01 ; Load A with constant $01.
; Store A in shared multicolour 10; STA leaves the arithmetic flags unchanged.
    sta $d023           ; Shared multicolour 10: white.
; Read CIA2 port direction into A; loading also updates zero and negative
; flags.
    lda $dd02 ; Load A with CIA2 port direction.
    ; Set the low two bits in A while preserving the other six bits.
    ora #3 ; Set bits selected by #3; retain other set bits.
; Store A in CIA2 port direction; STA leaves the arithmetic flags unchanged.
    sta $dd02           ; CIA2 bank-select pins must be outputs.
; Read CIA2 port and VIC bank into A; loading also updates zero and negative
; flags.
    lda $dd00 ; Load A with CIA2 VIC bank selection.
    ; Set the low two bits in A while preserving the other six bits.
    ora #3 ; Set bits selected by #3; retain other set bits.
; Store A in CIA2 port and VIC bank; STA leaves the arithmetic flags
; unchanged.
    sta $dd00           ; Inverted bits 11 select VIC bank $0000.
    ; Load constant $18 into A; # means a value, not a memory read.
    lda #$18 ; Load A with constant $18.
; Store A in vertical control and raster high bit; STA leaves the arithmetic
; flags unchanged.
    sta $d011           ; Text mode, 25 rows, display enabled.
    ; Load constant $18 into A; # means a value, not a memory read.
    lda #$18 ; Load A with constant $18.
; Store A in screen and charset pointers; STA leaves the arithmetic flags
; unchanged.
    sta $d018           ; Screen $0400, custom characters $2000.
    ; Load constant 24 into A; # means a value, not a memory read.
    lda #24 ; Load A with constant 24.
; Store A in multicolour, width and fine scroll; STA leaves the arithmetic
; flags unchanged.
    sta $d016 ; Write A to horizontal control and fine scroll.
    ; Push a return address and call render to draw the current viewport.
    jsr render ; Call render; the routine returns with RTS.
; Coarse scrolling demonstration: one column about every 16 frames.
; Blank during redraw so an incomplete screen is never displayed.
; This deliberately trades smoothness for a simple, correct renderer.
; WHAT: Advance the camera every 16 raster-frame transitions.
; WHY: A slow coarse scroll makes the viewport operation easy to see.
; HOW: Wait for frames, increment camera, clamp by wrapping and redraw.
main:
    ; Load constant 16 into X; # means a value, not a memory read.
    ldx #16 ; Load X with constant 16.
frame:
; Copy bit 7 of $d011 into N to test the raster high bit without changing A.
    bit $d011 ; Test vertical control and raster high bit without replacing A.
    ; Loop while BIT reports raster bit 7 clear: raster is below line 256.
    bpl frame           ; Wait for raster >=256.
leave:
; Copy bit 7 of $d011 into N to test the raster high bit without changing A.
    bit $d011 ; Test vertical control and raster high bit without replacing A.
    ; Loop while raster bit 7 is set; leave on the next frame.
    bmi leave           ; Wait for raster <256 (next frame).
    ; Reduce X by one; X counts frames here or rows inside render.
    dex ; Decrease the X counter by one.
    ; Repeat while the preceding result was nonzero.
    bne frame ; Continue at frame when the result is nonzero.
    ; Advance the camera by one world tile column.
    inc camera ; Increase camera by one.
; Read leftmost world tile column into A; loading also updates zero and
; negative flags.
    lda camera ; Load A with camera.
    ; Compare A with the first invalid camera column; do not alter A.
    cmp #89             ; Valid leftmost columns: 0..88.
    ; Keep the camera value when it is below 89 (carry clear).
    bcc position_ok ; Continue at position_ok when carry is clear.
    ; Load constant 0 into A; # means a value, not a memory read.
    lda #0 ; Load A with constant 0.
; Store A in leftmost world tile column; STA leaves the arithmetic flags
; unchanged.
    sta camera ; Write A to camera.
; WHAT: Rebuild the selected viewport with display disabled.
; WHY: The general renderer is too slow for a short border interval.
; HOW: Clear DEN, redraw all cells, then restore DEN.
position_ok:
    ; Load constant $08 into A; # means a value, not a memory read.
    lda #$08 ; Load A with constant $08.
; Store A in vertical control and raster high bit; STA leaves the arithmetic
; flags unchanged.
    sta $d011           ; DEN=0 during the full 1000-cell redraw.
    ; Push a return address and call render to draw the current viewport.
    jsr render ; Call render; the routine returns with RTS.
    ; Load constant $18 into A; # means a value, not a memory read.
    lda #$18 ; Load A with constant $18.
; Store A in vertical control and raster high bit; STA leaves the arithmetic
; flags unchanged.
    sta $d011 ; Write A to vertical control and raster high bit.
; Continue at main; JMP is unconditional and does not create a return address.
    jmp main ; Continue at main without pushing a return address.
; Source stride in character cells; the screen stride remains 40.
MAP_WIDTH = 128

; $fb/$fc = map source; $fd/$fe = screen destination.
; $f9/$fa = colour destination. Render exactly 1000 cells.
; WHAT: Draw 25 rows of 40 tile IDs and matching colour attributes.
; WHY: World rows and screen rows can have different strides.
; HOW: Three pointer pairs walk source, screen and colour RAM.
; INPUT: camera in tile columns; MAP_WIDTH is 40 or 128.
; OUTPUT: $0400-$07e7 and $d800-$dbe7 overwritten.
; CLOBBERS: A, X, Y, flags, $f9-$fe and saved_y.
; Uses the stack for JSR/RTS; no IRQ or KERNAL services required.
render:
    ; Load the low address byte of map into A.
    lda #<map ; Load A with constant <map.
; Store A in map pointer low byte; STA leaves the arithmetic flags unchanged.
    sta $fb ; Write A to $fb.
    ; Load the high address byte of map into A.
    lda #>map ; Load A with constant >map.
; Store A in map pointer high byte; STA leaves the arithmetic flags unchanged.
    sta $fc ; Write A to $fc.
    ; Clear carry before starting a new low-byte address addition.
    clc ; Clear carry before a new addition.
; Read map pointer low byte into A; loading also updates zero and negative
; flags.
    lda $fb ; Load A with $fb.
    ; Add camera and carry to A; carry records any byte overflow.
    adc camera ; Add camera and carry to A; propagate overflow.
; Store A in map pointer low byte; STA leaves the arithmetic flags unchanged.
    sta $fb ; Write A to $fb.
; Read map pointer high byte into A; loading also updates zero and negative
; flags.
    lda $fc ; Load A with $fc.
    ; Add the previous low-byte carry to the pointer high byte.
    adc #0 ; Add #0 and carry to A; propagate overflow.
; Store A in map pointer high byte; STA leaves the arithmetic flags unchanged.
    sta $fc ; Write A to $fc.
    ; Load the low address byte of $0400 into A.
    lda #<$0400 ; Load A with constant <$0400.
; Store A in screen pointer low byte; STA leaves the arithmetic flags
; unchanged.
    sta $fd ; Write A to $fd.
    ; Load the high address byte of $0400 into A.
    lda #>$0400 ; Load A with constant >$0400.
; Store A in screen pointer high byte; STA leaves the arithmetic flags
; unchanged.
    sta $fe ; Write A to $fe.
    ; Load the low address byte of $d800 into A.
    lda #<$d800 ; Load A with constant <$d800.
; Store A in colour pointer low byte; STA leaves the arithmetic flags
; unchanged.
    sta $f9 ; Write A to $f9.
    ; Load the high address byte of $d800 into A.
    lda #>$d800 ; Load A with constant >$d800.
; Store A in colour pointer high byte; STA leaves the arithmetic flags
; unchanged.
    sta $fa ; Write A to $fa.
    ; Load constant 25 into X; # means a value, not a memory read.
    ldx #25 ; Load X with constant 25.
; WHAT: Begin one screen row at column zero.
; WHY: Each source row must restart its column offset.
row:
    ; Load constant 0 into Y; # means a value, not a memory read.
    ldy #0 ; Load Y with constant 0.
; WHAT: Copy one map cell and its colour to the display.
; WHY: Character ID and colour RAM attribute are separate data.
cell:
    ; Read the tile ID at map pointer plus the current screen column Y.
    lda ($fb),y         ; Map byte is a character ID, not PETSCII.
    ; Write the tile ID to screen pointer plus column Y.
    sta ($fd),y ; Write A to ($fd),y.
    ; Save Y before using it as the colour-table index.
    sty saved_y ; Write Y to saved_y.
    ; Copy the tile ID from A to Y for the attribute-table lookup.
    tay                 ; Use the same ID to index its colour.
    ; Read the preferred colour attribute for tile ID Y into A.
    lda colours,y ; Load A with colours,y.
; Read saved screen column into Y; loading also updates zero and negative
; flags.
    ldy saved_y ; Load Y with saved_y.
    ; Write the attribute to colour pointer plus column Y.
    sta ($f9),y ; Write A to ($f9),y.
    ; Advance Y to the next visible column.
    iny ; Advance the Y index by one.
    ; Compare Y with 40; zero means this row is complete.
    cpy #40 ; Compare Y with #40; update flags.
    ; Repeat the next cell until Y reaches 40.
    bne cell ; Continue at cell when the result is nonzero.
    ; Clear carry before starting a new low-byte address addition.
    clc ; Clear carry before a new addition.
; Read map pointer low byte into A; loading also updates zero and negative
; flags.
    lda $fb ; Load A with $fb.
    ; Add MAP_WIDTH and carry to A; carry records any byte overflow.
    adc #MAP_WIDTH      ; Advance source by world stride.
; Store A in map pointer low byte; STA leaves the arithmetic flags unchanged.
    sta $fb ; Write A to $fb.
; Read map pointer high byte into A; loading also updates zero and negative
; flags.
    lda $fc ; Load A with $fc.
    ; Add the previous low-byte carry to the pointer high byte.
    adc #0 ; Add #0 and carry to A; propagate overflow.
; Store A in map pointer high byte; STA leaves the arithmetic flags unchanged.
    sta $fc ; Write A to $fc.
    ; Clear carry before starting a new low-byte address addition.
    clc ; Clear carry before a new addition.
; Read screen pointer low byte into A; loading also updates zero and negative
; flags.
    lda $fd ; Load A with $fd.
    ; Add 40 and carry to A; carry records any byte overflow.
    adc #40 ; Add #40 and carry to A; propagate overflow.
; Store A in screen pointer low byte; STA leaves the arithmetic flags
; unchanged.
    sta $fd ; Write A to $fd.
; Read screen pointer high byte into A; loading also updates zero and negative
; flags.
    lda $fe ; Load A with $fe.
    ; Add the previous low-byte carry to the pointer high byte.
    adc #0 ; Add #0 and carry to A; propagate overflow.
; Store A in screen pointer high byte; STA leaves the arithmetic flags
; unchanged.
    sta $fe ; Write A to $fe.
    ; Clear carry before starting a new low-byte address addition.
    clc ; Clear carry before a new addition.
; Read colour pointer low byte into A; loading also updates zero and negative
; flags.
    lda $f9 ; Load A with $f9.
    ; Add 40 and carry to A; carry records any byte overflow.
    adc #40 ; Add #40 and carry to A; propagate overflow.
; Store A in colour pointer low byte; STA leaves the arithmetic flags
; unchanged.
    sta $f9 ; Write A to $f9.
; Read colour pointer high byte into A; loading also updates zero and negative
; flags.
    lda $fa ; Load A with $fa.
    ; Add the previous low-byte carry to the pointer high byte.
    adc #0 ; Add #0 and carry to A; propagate overflow.
; Store A in colour pointer high byte; STA leaves the arithmetic flags
; unchanged.
    sta $fa ; Write A to $fa.
    ; Reduce X by one; X counts frames here or rows inside render.
    dex ; Decrease the X counter by one.
    ; Repeat while the preceding result was nonzero.
    bne row ; Continue at row when the result is nonzero.
    ; Return to the instruction after the caller JSR.
    rts ; Return to the instruction after the caller JSR.
; Writable camera column, initially zero; static examples leave it unchanged.
camera: !byte 0
; Scratch byte preserving the screen column during colour lookup.
saved_y: !byte 0
; Colours indexed by tile ID 0..5; bit 3 selects multicolour cells.
colours: !byte 0,2,7,11,13,14
; Assembly origin: place the following bytes at $2000.
* = $2000
; WHAT: Define all character pixels in this source file.
; WHY: ACME needs no external binary asset or conversion tool.
; HOW: Eight !byte rows per character, then zero-fill unused IDs.
charset:
; ID 0: air. Each value is one horizontal pixel row.
!byte $00,$00,$00,$00,$00,$00,$00,$00
; ID 1: girder. Each value is one horizontal pixel row.
!byte $ff,$81,$bd,$a5,$a5,$bd,$81,$ff
; ID 2: ladder. Each value is one horizontal pixel row.
!byte $18,$18,$7e,$18,$18,$7e,$18,$18
; ID 3: ground. Each value is one horizontal pixel row.
!byte $55,$aa,$55,$aa,$55,$aa,$55,$aa
; ID 4: slope. Each value is one horizontal pixel row.
!byte $00,$00,$18,$3c,$7e,$ff,$ff,$ff
; ID 5: block. Each value is one horizontal pixel row.
!byte $ff,$aa,$aa,$aa,$aa,$aa,$aa,$ff
; Complete the 256-character set: unused characters are blank.
!fill 2048 - (* - charset), 0
; Assembly origin: place the following bytes at $3000.
* = $3000
map:
; WHAT: Build the 128 by 25 world entirely in ACME.
; WHY: No map conversion or external asset is needed.
; HOW: Choose the ID using row, column and repeating patterns.
; MOD gives the remainder, making each pattern repeat.
!for tile_y, 0, 24 {
    !for tile_x, 0, 127 {
        ; Default to air, then select ground or scenery.
        !set tile_id = 0
        !if tile_y >= 22 {
            ; Three solid rows at the foot of the world.
            !set tile_id = 3
        } else {
            !if (tile_y = 21) and ((tile_x MOD 17) < 5) {
                ; Five slope cells in each 17-column repeat.
                !set tile_id = 4
            } else {
                !if ((tile_y = 12) or (tile_y = 16)) {
                    !if (tile_x MOD 29) < 8 {
                        ; Eight blocks in each 29-column repeat.
                        !set tile_id = 5
                    }
                }
            }
        }
        ; Emit exactly one character ID for this world cell.
        !byte tile_id
    }
}

; Fail assembly if the map size no longer matches the renderer.
!if (* - map) != (MAP_WIDTH * 25) {
    !error "Map dimensions changed"
}
