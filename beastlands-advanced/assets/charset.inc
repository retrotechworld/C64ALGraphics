; CHARSET -- native ACME source data, no converter required.
; Edit the !byte values in VS Code and assemble the lesson again.
; Each character occupies 8 bytes. Multicolour pixels use pairs:
; 00=background, 01=$d022, 10=$d023, 11=local colour RAM low 3 bits.
; Hi-res font glyphs use single bits instead; colour RAM bit 3 is clear.
; Glyph $00 at charset offset $0000
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $01 at charset offset $0008
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %10000000 ; scanline 5  pairs 10 00 00 00
!byte %10100000 ; scanline 6  pairs 10 10 00 00
!byte %01101000 ; scanline 7  pairs 01 10 10 00
; Glyph $02 at charset offset $0010
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000010 ; scanline 5  pairs 00 00 00 10
!byte %00001010 ; scanline 6  pairs 00 00 10 10
!byte %00101001 ; scanline 7  pairs 00 10 10 01
; Glyph $03 at charset offset $0018
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %10000000 ; scanline 1  pairs 10 00 00 00
!byte %10100000 ; scanline 2  pairs 10 10 00 00
!byte %01101000 ; scanline 3  pairs 01 10 10 00
!byte %01011010 ; scanline 4  pairs 01 01 10 10
!byte %01010110 ; scanline 5  pairs 01 01 01 10
!byte %01010101 ; scanline 6  pairs 01 01 01 01
!byte %01010101 ; scanline 7  pairs 01 01 01 01
; Glyph $04 at charset offset $0020
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000010 ; scanline 1  pairs 00 00 00 10
!byte %00001010 ; scanline 2  pairs 00 00 10 10
!byte %00101001 ; scanline 3  pairs 00 10 10 01
!byte %10100101 ; scanline 4  pairs 10 10 01 01
!byte %10010101 ; scanline 5  pairs 10 01 01 01
!byte %01010101 ; scanline 6  pairs 01 01 01 01
!byte %01010101 ; scanline 7  pairs 01 01 01 01
; Glyph $05 at charset offset $0028
!byte %01011010 ; scanline 0  pairs 01 01 10 10
!byte %01010110 ; scanline 1  pairs 01 01 01 10
!byte %01010101 ; scanline 2  pairs 01 01 01 01
!byte %01010101 ; scanline 3  pairs 01 01 01 01
!byte %01010101 ; scanline 4  pairs 01 01 01 01
!byte %01010101 ; scanline 5  pairs 01 01 01 01
!byte %01010101 ; scanline 6  pairs 01 01 01 01
!byte %01010101 ; scanline 7  pairs 01 01 01 01
; Glyph $06 at charset offset $0030
!byte %10100101 ; scanline 0  pairs 10 10 01 01
!byte %10010101 ; scanline 1  pairs 10 01 01 01
!byte %01010101 ; scanline 2  pairs 01 01 01 01
!byte %01010101 ; scanline 3  pairs 01 01 01 01
!byte %01010101 ; scanline 4  pairs 01 01 01 01
!byte %01010101 ; scanline 5  pairs 01 01 01 01
!byte %01010101 ; scanline 6  pairs 01 01 01 01
!byte %01010101 ; scanline 7  pairs 01 01 01 01
; Glyph $07 at charset offset $0038
!byte %01010101 ; scanline 0  pairs 01 01 01 01
!byte %01010101 ; scanline 1  pairs 01 01 01 01
!byte %01010101 ; scanline 2  pairs 01 01 01 01
!byte %01010101 ; scanline 3  pairs 01 01 01 01
!byte %01010101 ; scanline 4  pairs 01 01 01 01
!byte %01010101 ; scanline 5  pairs 01 01 01 01
!byte %11010101 ; scanline 6  pairs 11 01 01 01
!byte %11010101 ; scanline 7  pairs 11 01 01 01
; Glyph $08 at charset offset $0040
!byte %01010101 ; scanline 0  pairs 01 01 01 01
!byte %01010101 ; scanline 1  pairs 01 01 01 01
!byte %01010101 ; scanline 2  pairs 01 01 01 01
!byte %01010101 ; scanline 3  pairs 01 01 01 01
!byte %01010101 ; scanline 4  pairs 01 01 01 01
!byte %01010101 ; scanline 5  pairs 01 01 01 01
!byte %01010101 ; scanline 6  pairs 01 01 01 01
!byte %01010101 ; scanline 7  pairs 01 01 01 01
; Glyph $09 at charset offset $0048
!byte %01010101 ; scanline 0  pairs 01 01 01 01
!byte %01010101 ; scanline 1  pairs 01 01 01 01
!byte %11010101 ; scanline 2  pairs 11 01 01 01
!byte %11010101 ; scanline 3  pairs 11 01 01 01
!byte %11010101 ; scanline 4  pairs 11 01 01 01
!byte %11010101 ; scanline 5  pairs 11 01 01 01
!byte %11010101 ; scanline 6  pairs 11 01 01 01
!byte %11010101 ; scanline 7  pairs 11 01 01 01
; Glyph $0a at charset offset $0050
!byte %11010101 ; scanline 0  pairs 11 01 01 01
!byte %11010101 ; scanline 1  pairs 11 01 01 01
!byte %11010101 ; scanline 2  pairs 11 01 01 01
!byte %11010101 ; scanline 3  pairs 11 01 01 01
!byte %11010101 ; scanline 4  pairs 11 01 01 01
!byte %11010101 ; scanline 5  pairs 11 01 01 01
!byte %11010101 ; scanline 6  pairs 11 01 01 01
!byte %11010101 ; scanline 7  pairs 11 01 01 01
; Glyph $0b at charset offset $0058
!byte %01010101 ; scanline 0  pairs 01 01 01 01
!byte %01010101 ; scanline 1  pairs 01 01 01 01
!byte %01010101 ; scanline 2  pairs 01 01 01 01
!byte %01010101 ; scanline 3  pairs 01 01 01 01
!byte %01010101 ; scanline 4  pairs 01 01 01 01
!byte %11010101 ; scanline 5  pairs 11 01 01 01
!byte %11010101 ; scanline 6  pairs 11 01 01 01
!byte %11010101 ; scanline 7  pairs 11 01 01 01
; Glyph $0c at charset offset $0060
!byte %01010101 ; scanline 0  pairs 01 01 01 01
!byte %11010101 ; scanline 1  pairs 11 01 01 01
!byte %11010101 ; scanline 2  pairs 11 01 01 01
!byte %11010101 ; scanline 3  pairs 11 01 01 01
!byte %11010101 ; scanline 4  pairs 11 01 01 01
!byte %11010101 ; scanline 5  pairs 11 01 01 01
!byte %11010101 ; scanline 6  pairs 11 01 01 01
!byte %11010101 ; scanline 7  pairs 11 01 01 01
; Glyph $0d at charset offset $0068
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000001 ; scanline 7  pairs 00 00 00 01
; Glyph $0e at charset offset $0070
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %01010101 ; scanline 3  pairs 01 01 01 01
!byte %01010101 ; scanline 4  pairs 01 01 01 01
!byte %01010101 ; scanline 5  pairs 01 01 01 01
!byte %01011001 ; scanline 6  pairs 01 01 10 01
!byte %01100101 ; scanline 7  pairs 01 10 01 01
; Glyph $0f at charset offset $0078
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %01000000 ; scanline 3  pairs 01 00 00 00
!byte %01000000 ; scanline 4  pairs 01 00 00 00
!byte %01000000 ; scanline 5  pairs 01 00 00 00
!byte %01000000 ; scanline 6  pairs 01 00 00 00
!byte %01010000 ; scanline 7  pairs 01 01 00 00
; Glyph $10 at charset offset $0080
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000101 ; scanline 3  pairs 00 00 01 01
!byte %00000101 ; scanline 4  pairs 00 00 01 01
!byte %00000101 ; scanline 5  pairs 00 00 01 01
!byte %00000101 ; scanline 6  pairs 00 00 01 01
!byte %00010110 ; scanline 7  pairs 00 01 01 10
; Glyph $11 at charset offset $0088
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %01010100 ; scanline 3  pairs 01 01 01 00
!byte %01010100 ; scanline 4  pairs 01 01 01 00
!byte %01010100 ; scanline 5  pairs 01 01 01 00
!byte %10010100 ; scanline 6  pairs 10 01 01 00
!byte %01010101 ; scanline 7  pairs 01 01 01 01
; Glyph $12 at charset offset $0090
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000001 ; scanline 3  pairs 00 00 00 01
!byte %00000001 ; scanline 4  pairs 00 00 00 01
!byte %00000001 ; scanline 5  pairs 00 00 00 01
!byte %00000001 ; scanline 6  pairs 00 00 00 01
!byte %00000101 ; scanline 7  pairs 00 00 01 01
; Glyph $13 at charset offset $0098
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %01010101 ; scanline 3  pairs 01 01 01 01
!byte %01010101 ; scanline 4  pairs 01 01 01 01
!byte %01010101 ; scanline 5  pairs 01 01 01 01
!byte %01100101 ; scanline 6  pairs 01 10 01 01
!byte %10010101 ; scanline 7  pairs 10 01 01 01
; Glyph $14 at charset offset $00a0
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %01000000 ; scanline 7  pairs 01 00 00 00
; Glyph $15 at charset offset $00a8
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00010101 ; scanline 3  pairs 00 01 01 01
!byte %00010101 ; scanline 4  pairs 00 01 01 01
!byte %00010101 ; scanline 5  pairs 00 01 01 01
!byte %00010110 ; scanline 6  pairs 00 01 01 10
!byte %01011001 ; scanline 7  pairs 01 01 10 01
; Glyph $16 at charset offset $00b0
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %01010000 ; scanline 3  pairs 01 01 00 00
!byte %01010000 ; scanline 4  pairs 01 01 00 00
!byte %01010000 ; scanline 5  pairs 01 01 00 00
!byte %01010000 ; scanline 6  pairs 01 01 00 00
!byte %01010100 ; scanline 7  pairs 01 01 01 00
; Glyph $17 at charset offset $00b8
!byte %00000001 ; scanline 0  pairs 00 00 00 01
!byte %00000110 ; scanline 1  pairs 00 00 01 10
!byte %00001001 ; scanline 2  pairs 00 00 10 01
!byte %00100101 ; scanline 3  pairs 00 10 01 01
!byte %00000101 ; scanline 4  pairs 00 00 01 01
!byte %00010101 ; scanline 5  pairs 00 01 01 01
!byte %01011010 ; scanline 6  pairs 01 01 10 10
!byte %10100101 ; scanline 7  pairs 10 10 01 01
; Glyph $18 at charset offset $00c0
!byte %10010101 ; scanline 0  pairs 10 01 01 01
!byte %01010101 ; scanline 1  pairs 01 01 01 01
!byte %01010101 ; scanline 2  pairs 01 01 01 01
!byte %01010101 ; scanline 3  pairs 01 01 01 01
!byte %01011001 ; scanline 4  pairs 01 01 10 01
!byte %10100101 ; scanline 5  pairs 10 10 01 01
!byte %01010101 ; scanline 6  pairs 01 01 01 01
!byte %01010101 ; scanline 7  pairs 01 01 01 01
; Glyph $19 at charset offset $00c8
!byte %01010000 ; scanline 0  pairs 01 01 00 00
!byte %01010100 ; scanline 1  pairs 01 01 01 00
!byte %01010100 ; scanline 2  pairs 01 01 01 00
!byte %01010101 ; scanline 3  pairs 01 01 01 01
!byte %01010100 ; scanline 4  pairs 01 01 01 00
!byte %01010101 ; scanline 5  pairs 01 01 01 01
!byte %01010101 ; scanline 6  pairs 01 01 01 01
!byte %01010101 ; scanline 7  pairs 01 01 01 01
; Glyph $1a at charset offset $00d0
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %01000000 ; scanline 6  pairs 01 00 00 00
!byte %01010000 ; scanline 7  pairs 01 01 00 00
; Glyph $1b at charset offset $00d8
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000010 ; scanline 3  pairs 00 00 00 10
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000001 ; scanline 5  pairs 00 00 00 01
!byte %00000101 ; scanline 6  pairs 00 00 01 01
!byte %00011010 ; scanline 7  pairs 00 01 10 10
; Glyph $1c at charset offset $00e0
!byte %00011001 ; scanline 0  pairs 00 01 10 01
!byte %01100101 ; scanline 1  pairs 01 10 01 01
!byte %10010101 ; scanline 2  pairs 10 01 01 01
!byte %01010101 ; scanline 3  pairs 01 01 01 01
!byte %01010101 ; scanline 4  pairs 01 01 01 01
!byte %01011010 ; scanline 5  pairs 01 01 10 10
!byte %10100101 ; scanline 6  pairs 10 10 01 01
!byte %01010101 ; scanline 7  pairs 01 01 01 01
; Glyph $1d at charset offset $00e8
!byte %01010101 ; scanline 0  pairs 01 01 01 01
!byte %01010101 ; scanline 1  pairs 01 01 01 01
!byte %01010101 ; scanline 2  pairs 01 01 01 01
!byte %01010101 ; scanline 3  pairs 01 01 01 01
!byte %10010101 ; scanline 4  pairs 10 01 01 01
!byte %01010101 ; scanline 5  pairs 01 01 01 01
!byte %01010101 ; scanline 6  pairs 01 01 01 01
!byte %01010101 ; scanline 7  pairs 01 01 01 01
; Glyph $1e at charset offset $00f0
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %01000000 ; scanline 1  pairs 01 00 00 00
!byte %01000000 ; scanline 2  pairs 01 00 00 00
!byte %01010000 ; scanline 3  pairs 01 01 00 00
!byte %01000000 ; scanline 4  pairs 01 00 00 00
!byte %01010000 ; scanline 5  pairs 01 01 00 00
!byte %01010100 ; scanline 6  pairs 01 01 01 00
!byte %01010101 ; scanline 7  pairs 01 01 01 01
; Glyph $1f at charset offset $00f8
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000001 ; scanline 6  pairs 00 00 00 01
!byte %00000110 ; scanline 7  pairs 00 00 01 10
; Glyph $20 at charset offset $0100
!byte %00000110 ; scanline 0  pairs 00 00 01 10
!byte %00011001 ; scanline 1  pairs 00 01 10 01
!byte %00100101 ; scanline 2  pairs 00 10 01 01
!byte %10010101 ; scanline 3  pairs 10 01 01 01
!byte %00010101 ; scanline 4  pairs 00 01 01 01
!byte %01010110 ; scanline 5  pairs 01 01 01 10
!byte %01101001 ; scanline 6  pairs 01 10 10 01
!byte %10010101 ; scanline 7  pairs 10 01 01 01
; Glyph $21 at charset offset $0108
!byte %01010101 ; scanline 0  pairs 01 01 01 01
!byte %01010101 ; scanline 1  pairs 01 01 01 01
!byte %01010101 ; scanline 2  pairs 01 01 01 01
!byte %01010101 ; scanline 3  pairs 01 01 01 01
!byte %01100101 ; scanline 4  pairs 01 10 01 01
!byte %10010101 ; scanline 5  pairs 10 01 01 01
!byte %01010101 ; scanline 6  pairs 01 01 01 01
!byte %01010101 ; scanline 7  pairs 01 01 01 01
; Glyph $22 at charset offset $0110
!byte %01000000 ; scanline 0  pairs 01 00 00 00
!byte %01010000 ; scanline 1  pairs 01 01 00 00
!byte %01010000 ; scanline 2  pairs 01 01 00 00
!byte %01010100 ; scanline 3  pairs 01 01 01 00
!byte %01010000 ; scanline 4  pairs 01 01 00 00
!byte %01010100 ; scanline 5  pairs 01 01 01 00
!byte %01010101 ; scanline 6  pairs 01 01 01 01
!byte %01010101 ; scanline 7  pairs 01 01 01 01
; Glyph $23 at charset offset $0118
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00100101 ; scanline 4  pairs 00 10 01 01
!byte %00100101 ; scanline 5  pairs 00 10 01 01
!byte %00100101 ; scanline 6  pairs 00 10 01 01
!byte %00000101 ; scanline 7  pairs 00 00 01 01
; Glyph $24 at charset offset $0120
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %01111111 ; scanline 4  pairs 01 11 11 11
!byte %01010101 ; scanline 5  pairs 01 01 01 01
!byte %01010101 ; scanline 6  pairs 01 01 01 01
!byte %01010101 ; scanline 7  pairs 01 01 01 01
; Glyph $25 at charset offset $0128
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %11110101 ; scanline 4  pairs 11 11 01 01
!byte %01010101 ; scanline 5  pairs 01 01 01 01
!byte %01010101 ; scanline 6  pairs 01 01 01 01
!byte %01010101 ; scanline 7  pairs 01 01 01 01
; Glyph $26 at charset offset $0130
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %01010101 ; scanline 4  pairs 01 01 01 01
!byte %01010101 ; scanline 5  pairs 01 01 01 01
!byte %01010101 ; scanline 6  pairs 01 01 01 01
!byte %01010101 ; scanline 7  pairs 01 01 01 01
; Glyph $27 at charset offset $0138
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000001 ; scanline 1  pairs 00 00 00 01
!byte %00000010 ; scanline 2  pairs 00 00 00 10
!byte %00001001 ; scanline 3  pairs 00 00 10 01
!byte %00000001 ; scanline 4  pairs 00 00 00 01
!byte %00000101 ; scanline 5  pairs 00 00 01 01
!byte %00010110 ; scanline 6  pairs 00 01 01 10
!byte %01101001 ; scanline 7  pairs 01 10 10 01
; Glyph $28 at charset offset $0140
!byte %01100101 ; scanline 0  pairs 01 10 01 01
!byte %10010101 ; scanline 1  pairs 10 01 01 01
!byte %01010101 ; scanline 2  pairs 01 01 01 01
!byte %01010101 ; scanline 3  pairs 01 01 01 01
!byte %01010110 ; scanline 4  pairs 01 01 01 10
!byte %01101001 ; scanline 5  pairs 01 10 10 01
!byte %10010101 ; scanline 6  pairs 10 01 01 01
!byte %01010101 ; scanline 7  pairs 01 01 01 01
; Glyph $29 at charset offset $0148
!byte %01010100 ; scanline 0  pairs 01 01 01 00
!byte %01010101 ; scanline 1  pairs 01 01 01 01
!byte %01010101 ; scanline 2  pairs 01 01 01 01
!byte %01010101 ; scanline 3  pairs 01 01 01 01
!byte %01010101 ; scanline 4  pairs 01 01 01 01
!byte %01010101 ; scanline 5  pairs 01 01 01 01
!byte %01010101 ; scanline 6  pairs 01 01 01 01
!byte %01010101 ; scanline 7  pairs 01 01 01 01
; Glyph $2a at charset offset $0150
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %01000000 ; scanline 3  pairs 01 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %01000000 ; scanline 5  pairs 01 00 00 00
!byte %01010000 ; scanline 6  pairs 01 01 00 00
!byte %01010100 ; scanline 7  pairs 01 01 01 00
; Glyph $2b at charset offset $0158
!byte %00001010 ; scanline 0  pairs 00 00 10 10
!byte %00100101 ; scanline 1  pairs 00 10 01 01
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000001 ; scanline 5  pairs 00 00 00 01
!byte %00000101 ; scanline 6  pairs 00 00 01 01
!byte %01101010 ; scanline 7  pairs 01 10 10 10
; Glyph $2c at charset offset $0160
!byte %01010101 ; scanline 0  pairs 01 01 01 01
!byte %01010101 ; scanline 1  pairs 01 01 01 01
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000101 ; scanline 3  pairs 00 00 01 01
!byte %00010101 ; scanline 4  pairs 00 01 01 01
!byte %01010110 ; scanline 5  pairs 01 01 01 10
!byte %10101001 ; scanline 6  pairs 10 10 10 01
!byte %01010101 ; scanline 7  pairs 01 01 01 01
; Glyph $2d at charset offset $0168
!byte %01010101 ; scanline 0  pairs 01 01 01 01
!byte %01010101 ; scanline 1  pairs 01 01 01 01
!byte %01010101 ; scanline 2  pairs 01 01 01 01
!byte %01010101 ; scanline 3  pairs 01 01 01 01
!byte %01101001 ; scanline 4  pairs 01 10 10 01
!byte %10010101 ; scanline 5  pairs 10 01 01 01
!byte %01010101 ; scanline 6  pairs 01 01 01 01
!byte %01010101 ; scanline 7  pairs 01 01 01 01
; Glyph $2e at charset offset $0170
!byte %01010101 ; scanline 0  pairs 01 01 01 01
!byte %01010101 ; scanline 1  pairs 01 01 01 01
!byte %01000000 ; scanline 2  pairs 01 00 00 00
!byte %01010100 ; scanline 3  pairs 01 01 01 00
!byte %01010101 ; scanline 4  pairs 01 01 01 01
!byte %01010101 ; scanline 5  pairs 01 01 01 01
!byte %01010101 ; scanline 6  pairs 01 01 01 01
!byte %01010101 ; scanline 7  pairs 01 01 01 01
; Glyph $2f at charset offset $0178
!byte %01010100 ; scanline 0  pairs 01 01 01 00
!byte %01010101 ; scanline 1  pairs 01 01 01 01
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %01010000 ; scanline 5  pairs 01 01 00 00
!byte %01010100 ; scanline 6  pairs 01 01 01 00
!byte %01010101 ; scanline 7  pairs 01 01 01 01
; Glyph $30 at charset offset $0180
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000010 ; scanline 1  pairs 00 00 00 10
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000110 ; scanline 7  pairs 00 00 01 10
; Glyph $31 at charset offset $0188
!byte %10100101 ; scanline 0  pairs 10 10 01 01
!byte %01010101 ; scanline 1  pairs 01 01 01 01
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000001 ; scanline 4  pairs 00 00 00 01
!byte %00010101 ; scanline 5  pairs 00 01 01 01
!byte %01011010 ; scanline 6  pairs 01 01 10 10
!byte %10100101 ; scanline 7  pairs 10 10 01 01
; Glyph $32 at charset offset $0190
!byte %01010101 ; scanline 0  pairs 01 01 01 01
!byte %01010101 ; scanline 1  pairs 01 01 01 01
!byte %00000101 ; scanline 2  pairs 00 00 01 01
!byte %01010101 ; scanline 3  pairs 01 01 01 01
!byte %01010110 ; scanline 4  pairs 01 01 01 10
!byte %01101001 ; scanline 5  pairs 01 10 10 01
!byte %10010101 ; scanline 6  pairs 10 01 01 01
!byte %01010101 ; scanline 7  pairs 01 01 01 01
; Glyph $33 at charset offset $0198
!byte %01010101 ; scanline 0  pairs 01 01 01 01
!byte %01010101 ; scanline 1  pairs 01 01 01 01
!byte %01010100 ; scanline 2  pairs 01 01 01 00
!byte %01010101 ; scanline 3  pairs 01 01 01 01
!byte %10010101 ; scanline 4  pairs 10 01 01 01
!byte %01010101 ; scanline 5  pairs 01 01 01 01
!byte %01010101 ; scanline 6  pairs 01 01 01 01
!byte %01010101 ; scanline 7  pairs 01 01 01 01
; Glyph $34 at charset offset $01a0
!byte %01010101 ; scanline 0  pairs 01 01 01 01
!byte %01010101 ; scanline 1  pairs 01 01 01 01
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %01000000 ; scanline 3  pairs 01 00 00 00
!byte %01010000 ; scanline 4  pairs 01 01 00 00
!byte %01010101 ; scanline 5  pairs 01 01 01 01
!byte %01010101 ; scanline 6  pairs 01 01 01 01
!byte %01010101 ; scanline 7  pairs 01 01 01 01
; Glyph $35 at charset offset $01a8
!byte %01000000 ; scanline 0  pairs 01 00 00 00
!byte %01010000 ; scanline 1  pairs 01 01 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %01000000 ; scanline 6  pairs 01 00 00 00
!byte %01010100 ; scanline 7  pairs 01 01 01 00
; Glyph $36 at charset offset $01b0
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00100101 ; scanline 3  pairs 00 10 01 01
!byte %00100101 ; scanline 4  pairs 00 10 01 01
!byte %00100101 ; scanline 5  pairs 00 10 01 01
!byte %00000101 ; scanline 6  pairs 00 00 01 01
!byte %00000111 ; scanline 7  pairs 00 00 01 11
; Glyph $37 at charset offset $01b8
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %11111111 ; scanline 3  pairs 11 11 11 11
!byte %01010101 ; scanline 4  pairs 01 01 01 01
!byte %01010101 ; scanline 5  pairs 01 01 01 01
!byte %01010101 ; scanline 6  pairs 01 01 01 01
!byte %01010100 ; scanline 7  pairs 01 01 01 00
; Glyph $38 at charset offset $01c0
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %11111111 ; scanline 3  pairs 11 11 11 11
!byte %01010101 ; scanline 4  pairs 01 01 01 01
!byte %01010101 ; scanline 5  pairs 01 01 01 01
!byte %01010101 ; scanline 6  pairs 01 01 01 01
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $39 at charset offset $01c8
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %11111111 ; scanline 3  pairs 11 11 11 11
!byte %01010101 ; scanline 4  pairs 01 01 01 01
!byte %01010101 ; scanline 5  pairs 01 01 01 01
!byte %01010101 ; scanline 6  pairs 01 01 01 01
!byte %00101010 ; scanline 7  pairs 00 10 10 10
; Glyph $3a at charset offset $01d0
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %01010000 ; scanline 3  pairs 01 01 00 00
!byte %01010000 ; scanline 4  pairs 01 01 00 00
!byte %01010000 ; scanline 5  pairs 01 01 00 00
!byte %01010000 ; scanline 6  pairs 01 01 00 00
!byte %10101010 ; scanline 7  pairs 10 10 10 10
; Glyph $3b at charset offset $01d8
!byte %00101001 ; scanline 0  pairs 00 10 10 01
!byte %10010101 ; scanline 1  pairs 10 01 01 01
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000101 ; scanline 5  pairs 00 00 01 01
!byte %00010110 ; scanline 6  pairs 00 01 01 10
!byte %10101001 ; scanline 7  pairs 10 10 10 01
; Glyph $3c at charset offset $01e0
!byte %01010101 ; scanline 0  pairs 01 01 01 01
!byte %01010101 ; scanline 1  pairs 01 01 01 01
!byte %00000001 ; scanline 2  pairs 00 00 00 01
!byte %00010101 ; scanline 3  pairs 00 01 01 01
!byte %01010101 ; scanline 4  pairs 01 01 01 01
!byte %01011010 ; scanline 5  pairs 01 01 10 10
!byte %10100101 ; scanline 6  pairs 10 10 01 01
!byte %01010101 ; scanline 7  pairs 01 01 01 01
; Glyph $3d at charset offset $01e8
!byte %01010101 ; scanline 0  pairs 01 01 01 01
!byte %01010101 ; scanline 1  pairs 01 01 01 01
!byte %01010101 ; scanline 2  pairs 01 01 01 01
!byte %01010101 ; scanline 3  pairs 01 01 01 01
!byte %10100101 ; scanline 4  pairs 10 10 01 01
!byte %01010101 ; scanline 5  pairs 01 01 01 01
!byte %01010101 ; scanline 6  pairs 01 01 01 01
!byte %01010101 ; scanline 7  pairs 01 01 01 01
; Glyph $3e at charset offset $01f0
!byte %01010101 ; scanline 0  pairs 01 01 01 01
!byte %01010101 ; scanline 1  pairs 01 01 01 01
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %01010000 ; scanline 3  pairs 01 01 00 00
!byte %01010100 ; scanline 4  pairs 01 01 01 00
!byte %01010101 ; scanline 5  pairs 01 01 01 01
!byte %01010101 ; scanline 6  pairs 01 01 01 01
!byte %01010101 ; scanline 7  pairs 01 01 01 01
; Glyph $3f at charset offset $01f8
!byte %01010000 ; scanline 0  pairs 01 01 00 00
!byte %01010100 ; scanline 1  pairs 01 01 01 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %01000000 ; scanline 5  pairs 01 00 00 00
!byte %01010000 ; scanline 6  pairs 01 01 00 00
!byte %01010101 ; scanline 7  pairs 01 01 01 01
; Glyph $40 at charset offset $0200
!byte %00000111 ; scanline 0  pairs 00 00 01 11
!byte %00000111 ; scanline 1  pairs 00 00 01 11
!byte %00000111 ; scanline 2  pairs 00 00 01 11
!byte %00000111 ; scanline 3  pairs 00 00 01 11
!byte %00000111 ; scanline 4  pairs 00 00 01 11
!byte %00001010 ; scanline 5  pairs 00 00 10 10
!byte %00000111 ; scanline 6  pairs 00 00 01 11
!byte %00000111 ; scanline 7  pairs 00 00 01 11
; Glyph $41 at charset offset $0208
!byte %01010100 ; scanline 0  pairs 01 01 01 00
!byte %01010100 ; scanline 1  pairs 01 01 01 00
!byte %01010100 ; scanline 2  pairs 01 01 01 00
!byte %01010100 ; scanline 3  pairs 01 01 01 00
!byte %01010100 ; scanline 4  pairs 01 01 01 00
!byte %10101000 ; scanline 5  pairs 10 10 10 00
!byte %01010100 ; scanline 6  pairs 01 01 01 00
!byte %01010100 ; scanline 7  pairs 01 01 01 00
; Glyph $42 at charset offset $0210
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00101010 ; scanline 1  pairs 00 10 10 10
!byte %00101010 ; scanline 2  pairs 00 10 10 10
!byte %00101010 ; scanline 3  pairs 00 10 10 10
!byte %00000111 ; scanline 4  pairs 00 00 01 11
!byte %00000111 ; scanline 5  pairs 00 00 01 11
!byte %00000111 ; scanline 6  pairs 00 00 01 11
!byte %00000111 ; scanline 7  pairs 00 00 01 11
; Glyph $43 at charset offset $0218
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %10101010 ; scanline 1  pairs 10 10 10 10
!byte %10101010 ; scanline 2  pairs 10 10 10 10
!byte %10101010 ; scanline 3  pairs 10 10 10 10
!byte %01010100 ; scanline 4  pairs 01 01 01 00
!byte %01010100 ; scanline 5  pairs 01 01 01 00
!byte %01010100 ; scanline 6  pairs 01 01 01 00
!byte %01010100 ; scanline 7  pairs 01 01 01 00
; Glyph $44 at charset offset $0220
!byte %00000010 ; scanline 0  pairs 00 00 00 10
!byte %00001001 ; scanline 1  pairs 00 00 10 01
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000001 ; scanline 6  pairs 00 00 00 01
!byte %00011010 ; scanline 7  pairs 00 01 10 10
; Glyph $45 at charset offset $0228
!byte %10010101 ; scanline 0  pairs 10 01 01 01
!byte %01010101 ; scanline 1  pairs 01 01 01 01
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000001 ; scanline 3  pairs 00 00 00 01
!byte %00000101 ; scanline 4  pairs 00 00 01 01
!byte %01010101 ; scanline 5  pairs 01 01 01 01
!byte %01101010 ; scanline 6  pairs 01 10 10 10
!byte %10010101 ; scanline 7  pairs 10 01 01 01
; Glyph $46 at charset offset $0230
!byte %01010101 ; scanline 0  pairs 01 01 01 01
!byte %01010101 ; scanline 1  pairs 01 01 01 01
!byte %00010101 ; scanline 2  pairs 00 01 01 01
!byte %01010101 ; scanline 3  pairs 01 01 01 01
!byte %01011010 ; scanline 4  pairs 01 01 10 10
!byte %10100101 ; scanline 5  pairs 10 10 01 01
!byte %01010101 ; scanline 6  pairs 01 01 01 01
!byte %01010101 ; scanline 7  pairs 01 01 01 01
; Glyph $47 at charset offset $0238
!byte %01010101 ; scanline 0  pairs 01 01 01 01
!byte %01010101 ; scanline 1  pairs 01 01 01 01
!byte %01010000 ; scanline 2  pairs 01 01 00 00
!byte %01010101 ; scanline 3  pairs 01 01 01 01
!byte %01010101 ; scanline 4  pairs 01 01 01 01
!byte %01010101 ; scanline 5  pairs 01 01 01 01
!byte %01010101 ; scanline 6  pairs 01 01 01 01
!byte %01010101 ; scanline 7  pairs 01 01 01 01
; Glyph $48 at charset offset $0240
!byte %01010101 ; scanline 0  pairs 01 01 01 01
!byte %01010101 ; scanline 1  pairs 01 01 01 01
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %01000000 ; scanline 4  pairs 01 00 00 00
!byte %01010100 ; scanline 5  pairs 01 01 01 00
!byte %01010101 ; scanline 6  pairs 01 01 01 01
!byte %01010101 ; scanline 7  pairs 01 01 01 01
; Glyph $49 at charset offset $0248
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %01000000 ; scanline 1  pairs 01 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %01010000 ; scanline 7  pairs 01 01 00 00
; Glyph $4a at charset offset $0250
!byte %10010101 ; scanline 0  pairs 10 01 01 01
!byte %01010101 ; scanline 1  pairs 01 01 01 01
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000101 ; scanline 5  pairs 00 00 01 01
!byte %01011010 ; scanline 6  pairs 01 01 10 10
!byte %10100101 ; scanline 7  pairs 10 10 01 01
; Glyph $4b at charset offset $0258
!byte %01010101 ; scanline 0  pairs 01 01 01 01
!byte %01010101 ; scanline 1  pairs 01 01 01 01
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000101 ; scanline 3  pairs 00 00 01 01
!byte %01010101 ; scanline 4  pairs 01 01 01 01
!byte %01011010 ; scanline 5  pairs 01 01 10 10
!byte %10100101 ; scanline 6  pairs 10 10 01 01
!byte %01010101 ; scanline 7  pairs 01 01 01 01
; Glyph $4c at charset offset $0260
!byte %01010000 ; scanline 0  pairs 01 01 00 00
!byte %01010101 ; scanline 1  pairs 01 01 01 01
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %01000000 ; scanline 6  pairs 01 00 00 00
!byte %01010100 ; scanline 7  pairs 01 01 01 00
; Glyph $4d at charset offset $0268
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000010 ; scanline 1  pairs 00 00 00 10
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $4e at charset offset $0270
!byte %00101001 ; scanline 0  pairs 00 10 10 01
!byte %10010101 ; scanline 1  pairs 10 01 01 01
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000101 ; scanline 6  pairs 00 00 01 01
!byte %01101010 ; scanline 7  pairs 01 10 10 10
; Glyph $4f at charset offset $0278
!byte %01010101 ; scanline 0  pairs 01 01 01 01
!byte %01010101 ; scanline 1  pairs 01 01 01 01
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000101 ; scanline 4  pairs 00 00 01 01
!byte %01010101 ; scanline 5  pairs 01 01 01 01
!byte %10101010 ; scanline 6  pairs 10 10 10 10
!byte %01010101 ; scanline 7  pairs 01 01 01 01
; Glyph $50 at charset offset $0280
!byte %01010101 ; scanline 0  pairs 01 01 01 01
!byte %01010101 ; scanline 1  pairs 01 01 01 01
!byte %00000101 ; scanline 2  pairs 00 00 01 01
!byte %01010101 ; scanline 3  pairs 01 01 01 01
!byte %01010110 ; scanline 4  pairs 01 01 01 10
!byte %10101001 ; scanline 5  pairs 10 10 10 01
!byte %01010101 ; scanline 6  pairs 01 01 01 01
!byte %01010101 ; scanline 7  pairs 01 01 01 01
; Glyph $51 at charset offset $0288
!byte %01010101 ; scanline 0  pairs 01 01 01 01
!byte %01010101 ; scanline 1  pairs 01 01 01 01
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %01000000 ; scanline 3  pairs 01 00 00 00
!byte %01010100 ; scanline 4  pairs 01 01 01 00
!byte %01010101 ; scanline 5  pairs 01 01 01 01
!byte %01010101 ; scanline 6  pairs 01 01 01 01
!byte %01010101 ; scanline 7  pairs 01 01 01 01
; Glyph $52 at charset offset $0290
!byte %01010101 ; scanline 0  pairs 01 01 01 01
!byte %01010101 ; scanline 1  pairs 01 01 01 01
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %01000000 ; scanline 5  pairs 01 00 00 00
!byte %01010100 ; scanline 6  pairs 01 01 01 00
!byte %01010101 ; scanline 7  pairs 01 01 01 01
; Glyph $53 at charset offset $0298
!byte %00000111 ; scanline 0  pairs 00 00 01 11
!byte %01010111 ; scanline 1  pairs 01 01 01 11
!byte %00000111 ; scanline 2  pairs 00 00 01 11
!byte %00000111 ; scanline 3  pairs 00 00 01 11
!byte %00001010 ; scanline 4  pairs 00 00 10 10
!byte %00000111 ; scanline 5  pairs 00 00 01 11
!byte %00000111 ; scanline 6  pairs 00 00 01 11
!byte %01000111 ; scanline 7  pairs 01 00 01 11
; Glyph $54 at charset offset $02a0
!byte %01010100 ; scanline 0  pairs 01 01 01 00
!byte %01010100 ; scanline 1  pairs 01 01 01 00
!byte %01010100 ; scanline 2  pairs 01 01 01 00
!byte %01010100 ; scanline 3  pairs 01 01 01 00
!byte %10101000 ; scanline 4  pairs 10 10 10 00
!byte %01010100 ; scanline 5  pairs 01 01 01 00
!byte %01010100 ; scanline 6  pairs 01 01 01 00
!byte %01010100 ; scanline 7  pairs 01 01 01 00
; Glyph $55 at charset offset $02a8
!byte %00101010 ; scanline 0  pairs 00 10 10 10
!byte %00101010 ; scanline 1  pairs 00 10 10 10
!byte %00000111 ; scanline 2  pairs 00 00 01 11
!byte %00000111 ; scanline 3  pairs 00 00 01 11
!byte %00000111 ; scanline 4  pairs 00 00 01 11
!byte %00000111 ; scanline 5  pairs 00 00 01 11
!byte %00000111 ; scanline 6  pairs 00 00 01 11
!byte %00000111 ; scanline 7  pairs 00 00 01 11
; Glyph $56 at charset offset $02b0
!byte %10101010 ; scanline 0  pairs 10 10 10 10
!byte %10101010 ; scanline 1  pairs 10 10 10 10
!byte %01010100 ; scanline 2  pairs 01 01 01 00
!byte %01010100 ; scanline 3  pairs 01 01 01 00
!byte %01010100 ; scanline 4  pairs 01 01 01 00
!byte %01010100 ; scanline 5  pairs 01 01 01 00
!byte %01010100 ; scanline 6  pairs 01 01 01 00
!byte %01010100 ; scanline 7  pairs 01 01 01 00
; Glyph $57 at charset offset $02b8
!byte %00001010 ; scanline 0  pairs 00 00 10 10
!byte %10100101 ; scanline 1  pairs 10 10 01 01
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000001 ; scanline 6  pairs 00 00 00 01
!byte %00011010 ; scanline 7  pairs 00 01 10 10
; Glyph $58 at charset offset $02c0
!byte %01010101 ; scanline 0  pairs 01 01 01 01
!byte %01010101 ; scanline 1  pairs 01 01 01 01
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000001 ; scanline 4  pairs 00 00 00 01
!byte %00010101 ; scanline 5  pairs 00 01 01 01
!byte %01101010 ; scanline 6  pairs 01 10 10 10
!byte %10010101 ; scanline 7  pairs 10 01 01 01
; Glyph $59 at charset offset $02c8
!byte %01010101 ; scanline 0  pairs 01 01 01 01
!byte %01010101 ; scanline 1  pairs 01 01 01 01
!byte %00000001 ; scanline 2  pairs 00 00 00 01
!byte %00010101 ; scanline 3  pairs 00 01 01 01
!byte %01010101 ; scanline 4  pairs 01 01 01 01
!byte %01101010 ; scanline 5  pairs 01 10 10 10
!byte %10010101 ; scanline 6  pairs 10 01 01 01
!byte %01010101 ; scanline 7  pairs 01 01 01 01
; Glyph $5a at charset offset $02d0
!byte %01010101 ; scanline 0  pairs 01 01 01 01
!byte %01010101 ; scanline 1  pairs 01 01 01 01
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %01010000 ; scanline 3  pairs 01 01 00 00
!byte %01010101 ; scanline 4  pairs 01 01 01 01
!byte %01010101 ; scanline 5  pairs 01 01 01 01
!byte %01010101 ; scanline 6  pairs 01 01 01 01
!byte %01010101 ; scanline 7  pairs 01 01 01 01
; Glyph $5b at charset offset $02d8
!byte %01010101 ; scanline 0  pairs 01 01 01 01
!byte %01010101 ; scanline 1  pairs 01 01 01 01
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %01010000 ; scanline 5  pairs 01 01 00 00
!byte %01010101 ; scanline 6  pairs 01 01 01 01
!byte %01010101 ; scanline 7  pairs 01 01 01 01
; Glyph $5c at charset offset $02e0
!byte %01000000 ; scanline 0  pairs 01 00 00 00
!byte %01010100 ; scanline 1  pairs 01 01 01 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %01010000 ; scanline 7  pairs 01 01 00 00
; Glyph $5d at charset offset $02e8
!byte %00000111 ; scanline 0  pairs 00 00 01 11
!byte %00000111 ; scanline 1  pairs 00 00 01 11
!byte %00001010 ; scanline 2  pairs 00 00 10 10
!byte %00000111 ; scanline 3  pairs 00 00 01 11
!byte %00000111 ; scanline 4  pairs 00 00 01 11
!byte %00000111 ; scanline 5  pairs 00 00 01 11
!byte %00000111 ; scanline 6  pairs 00 00 01 11
!byte %00000111 ; scanline 7  pairs 00 00 01 11
; Glyph $5e at charset offset $02f0
!byte %01010100 ; scanline 0  pairs 01 01 01 00
!byte %01010100 ; scanline 1  pairs 01 01 01 00
!byte %10101000 ; scanline 2  pairs 10 10 10 00
!byte %01010100 ; scanline 3  pairs 01 01 01 00
!byte %01010100 ; scanline 4  pairs 01 01 01 00
!byte %01010100 ; scanline 5  pairs 01 01 01 00
!byte %01010100 ; scanline 6  pairs 01 01 01 00
!byte %01010100 ; scanline 7  pairs 01 01 01 00
; Glyph $5f at charset offset $02f8
!byte %00000010 ; scanline 0  pairs 00 00 00 10
!byte %00101001 ; scanline 1  pairs 00 10 10 01
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000110 ; scanline 7  pairs 00 00 01 10
; Glyph $60 at charset offset $0300
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00001010 ; scanline 1  pairs 00 00 10 10
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000001 ; scanline 7  pairs 00 00 00 01
; Glyph $61 at charset offset $0308
!byte %10100101 ; scanline 0  pairs 10 10 01 01
!byte %01010101 ; scanline 1  pairs 01 01 01 01
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000001 ; scanline 5  pairs 00 00 00 01
!byte %00010110 ; scanline 6  pairs 00 01 01 10
!byte %10101001 ; scanline 7  pairs 10 10 10 01
; Glyph $62 at charset offset $0310
!byte %01010101 ; scanline 0  pairs 01 01 01 01
!byte %01010101 ; scanline 1  pairs 01 01 01 01
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000001 ; scanline 3  pairs 00 00 00 01
!byte %00010101 ; scanline 4  pairs 00 01 01 01
!byte %01010110 ; scanline 5  pairs 01 01 01 10
!byte %10101001 ; scanline 6  pairs 10 10 10 01
!byte %01010101 ; scanline 7  pairs 01 01 01 01
; Glyph $63 at charset offset $0318
!byte %01010101 ; scanline 0  pairs 01 01 01 01
!byte %01010101 ; scanline 1  pairs 01 01 01 01
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %01010000 ; scanline 4  pairs 01 01 00 00
!byte %01010101 ; scanline 5  pairs 01 01 01 01
!byte %01010101 ; scanline 6  pairs 01 01 01 01
!byte %01010101 ; scanline 7  pairs 01 01 01 01
; Glyph $64 at charset offset $0320
!byte %01010100 ; scanline 0  pairs 01 01 01 00
!byte %01010101 ; scanline 1  pairs 01 01 01 01
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %01010000 ; scanline 6  pairs 01 01 00 00
!byte %01010101 ; scanline 7  pairs 01 01 01 01
; Glyph $65 at charset offset $0328
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %01000000 ; scanline 1  pairs 01 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $66 at charset offset $0330
!byte %01010101 ; scanline 0  pairs 01 01 01 01
!byte %01010101 ; scanline 1  pairs 01 01 01 01
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $67 at charset offset $0338
!byte %01010101 ; scanline 0  pairs 01 01 01 01
!byte %01010101 ; scanline 1  pairs 01 01 01 01
!byte %00011001 ; scanline 2  pairs 00 01 10 01
!byte %00011001 ; scanline 3  pairs 00 01 10 01
!byte %00011001 ; scanline 4  pairs 00 01 10 01
!byte %00011001 ; scanline 5  pairs 00 01 10 01
!byte %00011001 ; scanline 6  pairs 00 01 10 01
!byte %00011001 ; scanline 7  pairs 00 01 10 01
; Glyph $68 at charset offset $0340
!byte %01001010 ; scanline 0  pairs 01 00 10 10
!byte %10100101 ; scanline 1  pairs 10 10 01 01
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $69 at charset offset $0348
!byte %10010101 ; scanline 0  pairs 10 01 01 01
!byte %01010101 ; scanline 1  pairs 01 01 01 01
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $6a at charset offset $0350
!byte %01010101 ; scanline 0  pairs 01 01 01 01
!byte %01010101 ; scanline 1  pairs 01 01 01 01
!byte %00000001 ; scanline 2  pairs 00 00 00 01
!byte %00000001 ; scanline 3  pairs 00 00 00 01
!byte %00000001 ; scanline 4  pairs 00 00 00 01
!byte %00000001 ; scanline 5  pairs 00 00 00 01
!byte %00000001 ; scanline 6  pairs 00 00 00 01
!byte %00000001 ; scanline 7  pairs 00 00 00 01
; Glyph $6b at charset offset $0358
!byte %01010101 ; scanline 0  pairs 01 01 01 01
!byte %01010101 ; scanline 1  pairs 01 01 01 01
!byte %10010000 ; scanline 2  pairs 10 01 00 00
!byte %10010000 ; scanline 3  pairs 10 01 00 00
!byte %10010000 ; scanline 4  pairs 10 01 00 00
!byte %10010000 ; scanline 5  pairs 10 01 00 00
!byte %10010000 ; scanline 6  pairs 10 01 00 00
!byte %10010000 ; scanline 7  pairs 10 01 00 00
; Glyph $6c at charset offset $0360
!byte %01010111 ; scanline 0  pairs 01 01 01 11
!byte %01010111 ; scanline 1  pairs 01 01 01 11
!byte %00000111 ; scanline 2  pairs 00 00 01 11
!byte %00000111 ; scanline 3  pairs 00 00 01 11
!byte %00001010 ; scanline 4  pairs 00 00 10 10
!byte %00000111 ; scanline 5  pairs 00 00 01 11
!byte %00000111 ; scanline 6  pairs 00 00 01 11
!byte %00000111 ; scanline 7  pairs 00 00 01 11
; Glyph $6d at charset offset $0368
!byte %00001010 ; scanline 0  pairs 00 00 10 10
!byte %00000111 ; scanline 1  pairs 00 00 01 11
!byte %00000111 ; scanline 2  pairs 00 00 01 11
!byte %00000111 ; scanline 3  pairs 00 00 01 11
!byte %00000111 ; scanline 4  pairs 00 00 01 11
!byte %00000111 ; scanline 5  pairs 00 00 01 11
!byte %00000111 ; scanline 6  pairs 00 00 01 11
!byte %00000111 ; scanline 7  pairs 00 00 01 11
; Glyph $6e at charset offset $0370
!byte %10101010 ; scanline 0  pairs 10 10 10 10
!byte %01010101 ; scanline 1  pairs 01 01 01 01
!byte %01010100 ; scanline 2  pairs 01 01 01 00
!byte %01010100 ; scanline 3  pairs 01 01 01 00
!byte %01010100 ; scanline 4  pairs 01 01 01 00
!byte %01010100 ; scanline 5  pairs 01 01 01 00
!byte %01010100 ; scanline 6  pairs 01 01 01 00
!byte %01010100 ; scanline 7  pairs 01 01 01 00
; Glyph $6f at charset offset $0378
!byte %10100101 ; scanline 0  pairs 10 10 01 01
!byte %01010101 ; scanline 1  pairs 01 01 01 01
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $70 at charset offset $0380
!byte %01010101 ; scanline 0  pairs 01 01 01 01
!byte %01010101 ; scanline 1  pairs 01 01 01 01
!byte %01100100 ; scanline 2  pairs 01 10 01 00
!byte %01100100 ; scanline 3  pairs 01 10 01 00
!byte %01100100 ; scanline 4  pairs 01 10 01 00
!byte %01100100 ; scanline 5  pairs 01 10 01 00
!byte %01100100 ; scanline 6  pairs 01 10 01 00
!byte %01100100 ; scanline 7  pairs 01 10 01 00
; Glyph $71 at charset offset $0388
!byte %01010110 ; scanline 0  pairs 01 01 01 10
!byte %01101001 ; scanline 1  pairs 01 10 10 01
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $72 at charset offset $0390
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %01010000 ; scanline 1  pairs 01 01 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $73 at charset offset $0398
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00001010 ; scanline 1  pairs 00 00 10 10
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $74 at charset offset $03a0
!byte %10101001 ; scanline 0  pairs 10 10 10 01
!byte %01010101 ; scanline 1  pairs 01 01 01 01
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $75 at charset offset $03a8
!byte %01000000 ; scanline 0  pairs 01 00 00 00
!byte %01010100 ; scanline 1  pairs 01 01 01 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $76 at charset offset $03b0
!byte %00101010 ; scanline 0  pairs 00 10 10 10
!byte %10010101 ; scanline 1  pairs 10 01 01 01
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $77 at charset offset $03b8
!byte %01010101 ; scanline 0  pairs 01 01 01 01
!byte %01010101 ; scanline 1  pairs 01 01 01 01
!byte %00000110 ; scanline 2  pairs 00 00 01 10
!byte %00000110 ; scanline 3  pairs 00 00 01 10
!byte %00000110 ; scanline 4  pairs 00 00 01 10
!byte %00000110 ; scanline 5  pairs 00 00 01 10
!byte %00000110 ; scanline 6  pairs 00 00 01 10
!byte %00000110 ; scanline 7  pairs 00 00 01 10
; Glyph $78 at charset offset $03c0
!byte %01010101 ; scanline 0  pairs 01 01 01 01
!byte %01010101 ; scanline 1  pairs 01 01 01 01
!byte %01000000 ; scanline 2  pairs 01 00 00 00
!byte %01000000 ; scanline 3  pairs 01 00 00 00
!byte %01000000 ; scanline 4  pairs 01 00 00 00
!byte %01000000 ; scanline 5  pairs 01 00 00 00
!byte %01000000 ; scanline 6  pairs 01 00 00 00
!byte %01000000 ; scanline 7  pairs 01 00 00 00
; Glyph $79 at charset offset $03c8
!byte %01010010 ; scanline 0  pairs 01 01 00 10
!byte %01101001 ; scanline 1  pairs 01 10 10 01
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $7a at charset offset $03d0
!byte %00011001 ; scanline 0  pairs 00 01 10 01
!byte %00011001 ; scanline 1  pairs 00 01 10 01
!byte %00011001 ; scanline 2  pairs 00 01 10 01
!byte %00011001 ; scanline 3  pairs 00 01 10 01
!byte %00011001 ; scanline 4  pairs 00 01 10 01
!byte %00011001 ; scanline 5  pairs 00 01 10 01
!byte %00011001 ; scanline 6  pairs 00 01 10 01
!byte %00011001 ; scanline 7  pairs 00 01 10 01
; Glyph $7b at charset offset $03d8
!byte %00000001 ; scanline 0  pairs 00 00 00 01
!byte %00000001 ; scanline 1  pairs 00 00 00 01
!byte %00000001 ; scanline 2  pairs 00 00 00 01
!byte %00000001 ; scanline 3  pairs 00 00 00 01
!byte %00000001 ; scanline 4  pairs 00 00 00 01
!byte %00000001 ; scanline 5  pairs 00 00 00 01
!byte %00000001 ; scanline 6  pairs 00 00 00 01
!byte %00000001 ; scanline 7  pairs 00 00 00 01
; Glyph $7c at charset offset $03e0
!byte %10010000 ; scanline 0  pairs 10 01 00 00
!byte %10010000 ; scanline 1  pairs 10 01 00 00
!byte %10010000 ; scanline 2  pairs 10 01 00 00
!byte %10010000 ; scanline 3  pairs 10 01 00 00
!byte %10010000 ; scanline 4  pairs 10 01 00 00
!byte %10010000 ; scanline 5  pairs 10 01 00 00
!byte %10010000 ; scanline 6  pairs 10 01 00 00
!byte %10010000 ; scanline 7  pairs 10 01 00 00
; Glyph $7d at charset offset $03e8
!byte %00000111 ; scanline 0  pairs 00 00 01 11
!byte %00000111 ; scanline 1  pairs 00 00 01 11
!byte %00000111 ; scanline 2  pairs 00 00 01 11
!byte %00000111 ; scanline 3  pairs 00 00 01 11
!byte %00001010 ; scanline 4  pairs 00 00 10 10
!byte %00000111 ; scanline 5  pairs 00 00 01 11
!byte %00000111 ; scanline 6  pairs 00 00 01 11
!byte %00000111 ; scanline 7  pairs 00 00 01 11
; Glyph $7e at charset offset $03f0
!byte %10101000 ; scanline 0  pairs 10 10 10 00
!byte %01010100 ; scanline 1  pairs 01 01 01 00
!byte %01010100 ; scanline 2  pairs 01 01 01 00
!byte %01010100 ; scanline 3  pairs 01 01 01 00
!byte %01010100 ; scanline 4  pairs 01 01 01 00
!byte %01010100 ; scanline 5  pairs 01 01 01 00
!byte %01010100 ; scanline 6  pairs 01 01 01 00
!byte %01010100 ; scanline 7  pairs 01 01 01 00
; Glyph $7f at charset offset $03f8
!byte %01100100 ; scanline 0  pairs 01 10 01 00
!byte %01100100 ; scanline 1  pairs 01 10 01 00
!byte %01100100 ; scanline 2  pairs 01 10 01 00
!byte %01100100 ; scanline 3  pairs 01 10 01 00
!byte %01100100 ; scanline 4  pairs 01 10 01 00
!byte %01100100 ; scanline 5  pairs 01 10 01 00
!byte %01100100 ; scanline 6  pairs 01 10 01 00
!byte %01100100 ; scanline 7  pairs 01 10 01 00
; Glyph $80 at charset offset $0400
!byte %00000110 ; scanline 0  pairs 00 00 01 10
!byte %00000110 ; scanline 1  pairs 00 00 01 10
!byte %00000110 ; scanline 2  pairs 00 00 01 10
!byte %00000110 ; scanline 3  pairs 00 00 01 10
!byte %00000110 ; scanline 4  pairs 00 00 01 10
!byte %00000110 ; scanline 5  pairs 00 00 01 10
!byte %00000110 ; scanline 6  pairs 00 00 01 10
!byte %00000110 ; scanline 7  pairs 00 00 01 10
; Glyph $81 at charset offset $0408
!byte %00111000 ; scanline 0  pairs 00 11 10 00
!byte %01000100 ; scanline 1  pairs 01 00 01 00
!byte %01000100 ; scanline 2  pairs 01 00 01 00
!byte %01111100 ; scanline 3  pairs 01 11 11 00
!byte %01000100 ; scanline 4  pairs 01 00 01 00
!byte %01000100 ; scanline 5  pairs 01 00 01 00
!byte %01000100 ; scanline 6  pairs 01 00 01 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $82 at charset offset $0410
!byte %01111000 ; scanline 0  pairs 01 11 10 00
!byte %01000100 ; scanline 1  pairs 01 00 01 00
!byte %01000100 ; scanline 2  pairs 01 00 01 00
!byte %01111000 ; scanline 3  pairs 01 11 10 00
!byte %01000100 ; scanline 4  pairs 01 00 01 00
!byte %01000100 ; scanline 5  pairs 01 00 01 00
!byte %01111000 ; scanline 6  pairs 01 11 10 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $83 at charset offset $0418
!byte %00111100 ; scanline 0  pairs 00 11 11 00
!byte %01000000 ; scanline 1  pairs 01 00 00 00
!byte %01000000 ; scanline 2  pairs 01 00 00 00
!byte %01000000 ; scanline 3  pairs 01 00 00 00
!byte %01000000 ; scanline 4  pairs 01 00 00 00
!byte %01000000 ; scanline 5  pairs 01 00 00 00
!byte %00111100 ; scanline 6  pairs 00 11 11 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $84 at charset offset $0420
!byte %01111000 ; scanline 0  pairs 01 11 10 00
!byte %01000100 ; scanline 1  pairs 01 00 01 00
!byte %01000100 ; scanline 2  pairs 01 00 01 00
!byte %01000100 ; scanline 3  pairs 01 00 01 00
!byte %01000100 ; scanline 4  pairs 01 00 01 00
!byte %01000100 ; scanline 5  pairs 01 00 01 00
!byte %01111000 ; scanline 6  pairs 01 11 10 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $85 at charset offset $0428
!byte %01111100 ; scanline 0  pairs 01 11 11 00
!byte %01000000 ; scanline 1  pairs 01 00 00 00
!byte %01000000 ; scanline 2  pairs 01 00 00 00
!byte %01111000 ; scanline 3  pairs 01 11 10 00
!byte %01000000 ; scanline 4  pairs 01 00 00 00
!byte %01000000 ; scanline 5  pairs 01 00 00 00
!byte %01111100 ; scanline 6  pairs 01 11 11 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $86 at charset offset $0430
!byte %01000000 ; scanline 0  pairs 01 00 00 00
!byte %01000000 ; scanline 1  pairs 01 00 00 00
!byte %01000000 ; scanline 2  pairs 01 00 00 00
!byte %01000000 ; scanline 3  pairs 01 00 00 00
!byte %01000000 ; scanline 4  pairs 01 00 00 00
!byte %01000000 ; scanline 5  pairs 01 00 00 00
!byte %01000000 ; scanline 6  pairs 01 00 00 00
!byte %01000000 ; scanline 7  pairs 01 00 00 00
; Glyph $87 at charset offset $0438
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000011 ; scanline 4  pairs 00 00 00 11
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $88 at charset offset $0440
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %11000000 ; scanline 4  pairs 11 00 00 00
!byte %10000000 ; scanline 5  pairs 10 00 00 00
!byte %00101010 ; scanline 6  pairs 00 10 10 10
!byte %00001010 ; scanline 7  pairs 00 00 10 10
; Glyph $89 at charset offset $0448
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %10000010 ; scanline 5  pairs 10 00 00 10
!byte %10101000 ; scanline 6  pairs 10 10 10 00
!byte %11101000 ; scanline 7  pairs 11 10 10 00
; Glyph $8a at charset offset $0450
!byte %00011100 ; scanline 0  pairs 00 01 11 00
!byte %00001000 ; scanline 1  pairs 00 00 10 00
!byte %00001000 ; scanline 2  pairs 00 00 10 00
!byte %00001000 ; scanline 3  pairs 00 00 10 00
!byte %01001000 ; scanline 4  pairs 01 00 10 00
!byte %01001000 ; scanline 5  pairs 01 00 10 00
!byte %00110000 ; scanline 6  pairs 00 11 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $8b at charset offset $0458
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00100000 ; scanline 3  pairs 00 10 00 00
!byte %10000000 ; scanline 4  pairs 10 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $8c at charset offset $0460
!byte %01000000 ; scanline 0  pairs 01 00 00 00
!byte %01000000 ; scanline 1  pairs 01 00 00 00
!byte %01000000 ; scanline 2  pairs 01 00 00 00
!byte %01000000 ; scanline 3  pairs 01 00 00 00
!byte %01000000 ; scanline 4  pairs 01 00 00 00
!byte %01000000 ; scanline 5  pairs 01 00 00 00
!byte %01111100 ; scanline 6  pairs 01 11 11 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $8d at charset offset $0468
!byte %01000100 ; scanline 0  pairs 01 00 01 00
!byte %01101100 ; scanline 1  pairs 01 10 11 00
!byte %01010100 ; scanline 2  pairs 01 01 01 00
!byte %01010100 ; scanline 3  pairs 01 01 01 00
!byte %01000100 ; scanline 4  pairs 01 00 01 00
!byte %01000100 ; scanline 5  pairs 01 00 01 00
!byte %01000100 ; scanline 6  pairs 01 00 01 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $8e at charset offset $0470
!byte %01000100 ; scanline 0  pairs 01 00 01 00
!byte %01100100 ; scanline 1  pairs 01 10 01 00
!byte %01010100 ; scanline 2  pairs 01 01 01 00
!byte %01001100 ; scanline 3  pairs 01 00 11 00
!byte %01000100 ; scanline 4  pairs 01 00 01 00
!byte %01000100 ; scanline 5  pairs 01 00 01 00
!byte %01000100 ; scanline 6  pairs 01 00 01 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $8f at charset offset $0478
!byte %00111000 ; scanline 0  pairs 00 11 10 00
!byte %01000100 ; scanline 1  pairs 01 00 01 00
!byte %01000100 ; scanline 2  pairs 01 00 01 00
!byte %01000100 ; scanline 3  pairs 01 00 01 00
!byte %01000100 ; scanline 4  pairs 01 00 01 00
!byte %01000100 ; scanline 5  pairs 01 00 01 00
!byte %00111000 ; scanline 6  pairs 00 11 10 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $90 at charset offset $0480
!byte %01111000 ; scanline 0  pairs 01 11 10 00
!byte %01000100 ; scanline 1  pairs 01 00 01 00
!byte %01000100 ; scanline 2  pairs 01 00 01 00
!byte %01111000 ; scanline 3  pairs 01 11 10 00
!byte %01000000 ; scanline 4  pairs 01 00 00 00
!byte %01000000 ; scanline 5  pairs 01 00 00 00
!byte %01000000 ; scanline 6  pairs 01 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $91 at charset offset $0488
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %10000000 ; scanline 7  pairs 10 00 00 00
; Glyph $92 at charset offset $0490
!byte %01111000 ; scanline 0  pairs 01 11 10 00
!byte %01000100 ; scanline 1  pairs 01 00 01 00
!byte %01000100 ; scanline 2  pairs 01 00 01 00
!byte %01111000 ; scanline 3  pairs 01 11 10 00
!byte %01010000 ; scanline 4  pairs 01 01 00 00
!byte %01001000 ; scanline 5  pairs 01 00 10 00
!byte %01000100 ; scanline 6  pairs 01 00 01 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $93 at charset offset $0498
!byte %00111100 ; scanline 0  pairs 00 11 11 00
!byte %01000000 ; scanline 1  pairs 01 00 00 00
!byte %01000000 ; scanline 2  pairs 01 00 00 00
!byte %00111000 ; scanline 3  pairs 00 11 10 00
!byte %00000100 ; scanline 4  pairs 00 00 01 00
!byte %00000100 ; scanline 5  pairs 00 00 01 00
!byte %01111000 ; scanline 6  pairs 01 11 10 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $94 at charset offset $04a0
!byte %01111100 ; scanline 0  pairs 01 11 11 00
!byte %00010000 ; scanline 1  pairs 00 01 00 00
!byte %00010000 ; scanline 2  pairs 00 01 00 00
!byte %00010000 ; scanline 3  pairs 00 01 00 00
!byte %00010000 ; scanline 4  pairs 00 01 00 00
!byte %00010000 ; scanline 5  pairs 00 01 00 00
!byte %00010000 ; scanline 6  pairs 00 01 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $95 at charset offset $04a8
!byte %01000100 ; scanline 0  pairs 01 00 01 00
!byte %01000100 ; scanline 1  pairs 01 00 01 00
!byte %01000100 ; scanline 2  pairs 01 00 01 00
!byte %01000100 ; scanline 3  pairs 01 00 01 00
!byte %01000100 ; scanline 4  pairs 01 00 01 00
!byte %01000100 ; scanline 5  pairs 01 00 01 00
!byte %00111000 ; scanline 6  pairs 00 11 10 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $96 at charset offset $04b0
!byte %01000100 ; scanline 0  pairs 01 00 01 00
!byte %01000100 ; scanline 1  pairs 01 00 01 00
!byte %01000100 ; scanline 2  pairs 01 00 01 00
!byte %01000100 ; scanline 3  pairs 01 00 01 00
!byte %01000100 ; scanline 4  pairs 01 00 01 00
!byte %00101000 ; scanline 5  pairs 00 10 10 00
!byte %00010000 ; scanline 6  pairs 00 01 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $97 at charset offset $04b8
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %11110000 ; scanline 4  pairs 11 11 00 00
!byte %00100000 ; scanline 5  pairs 00 10 00 00
!byte %00001010 ; scanline 6  pairs 00 00 10 10
!byte %00000010 ; scanline 7  pairs 00 00 00 10
; Glyph $98 at charset offset $04c0
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00100000 ; scanline 5  pairs 00 10 00 00
!byte %10101010 ; scanline 6  pairs 10 10 10 10
!byte %10111010 ; scanline 7  pairs 10 11 10 10
; Glyph $99 at charset offset $04c8
!byte %01000100 ; scanline 0  pairs 01 00 01 00
!byte %01000100 ; scanline 1  pairs 01 00 01 00
!byte %00101000 ; scanline 2  pairs 00 10 10 00
!byte %00010000 ; scanline 3  pairs 00 01 00 00
!byte %00010000 ; scanline 4  pairs 00 01 00 00
!byte %00010000 ; scanline 5  pairs 00 01 00 00
!byte %00010000 ; scanline 6  pairs 00 01 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $9a at charset offset $04d0
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00001000 ; scanline 3  pairs 00 00 10 00
!byte %00100000 ; scanline 4  pairs 00 10 00 00
!byte %10000000 ; scanline 5  pairs 10 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $9b at charset offset $04d8
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00100000 ; scanline 7  pairs 00 10 00 00
; Glyph $9c at charset offset $04e0
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00111100 ; scanline 4  pairs 00 11 11 00
!byte %00001000 ; scanline 5  pairs 00 00 10 00
!byte %00000010 ; scanline 6  pairs 00 00 00 10
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $9d at charset offset $04e8
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00001000 ; scanline 5  pairs 00 00 10 00
!byte %10101010 ; scanline 6  pairs 10 10 10 10
!byte %10101110 ; scanline 7  pairs 10 10 11 10
; Glyph $9e at charset offset $04f0
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000010 ; scanline 3  pairs 00 00 00 10
!byte %00001000 ; scanline 4  pairs 00 00 10 00
!byte %00100000 ; scanline 5  pairs 00 10 00 00
!byte %10000000 ; scanline 6  pairs 10 00 00 00
!byte %10000000 ; scanline 7  pairs 10 00 00 00
; Glyph $9f at charset offset $04f8
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00001000 ; scanline 7  pairs 00 00 10 00
; Glyph $a0 at charset offset $0500
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $a1 at charset offset $0508
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00001111 ; scanline 4  pairs 00 00 11 11
!byte %00000010 ; scanline 5  pairs 00 00 00 10
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $a2 at charset offset $0510
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000010 ; scanline 5  pairs 00 00 00 10
!byte %10101010 ; scanline 6  pairs 10 10 10 10
!byte %00101011 ; scanline 7  pairs 00 10 10 11
; Glyph $a3 at charset offset $0518
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000010 ; scanline 4  pairs 00 00 00 10
!byte %00001000 ; scanline 5  pairs 00 00 10 00
!byte %10100000 ; scanline 6  pairs 10 10 00 00
!byte %10100000 ; scanline 7  pairs 10 10 00 00
; Glyph $a4 at charset offset $0520
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %10000000 ; scanline 3  pairs 10 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000010 ; scanline 7  pairs 00 00 00 10
; Glyph $a5 at charset offset $0528
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00001111 ; scanline 3  pairs 00 00 11 11
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $a6 at charset offset $0530
!byte %11110000 ; scanline 0  pairs 11 11 00 00
!byte %00001010 ; scanline 1  pairs 00 00 10 10
!byte %00101110 ; scanline 2  pairs 00 10 11 10
!byte %00101010 ; scanline 3  pairs 00 10 10 10
!byte %10101010 ; scanline 4  pairs 10 10 10 10
!byte %00001010 ; scanline 5  pairs 00 00 10 10
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $a7 at charset offset $0538
!byte %00001010 ; scanline 0  pairs 00 00 10 10
!byte %10001010 ; scanline 1  pairs 10 00 10 10
!byte %10100000 ; scanline 2  pairs 10 10 00 00
!byte %10101000 ; scanline 3  pairs 10 10 10 00
!byte %10100010 ; scanline 4  pairs 10 10 00 10
!byte %10000000 ; scanline 5  pairs 10 00 00 00
!byte %00101000 ; scanline 6  pairs 00 10 10 00
!byte %00000010 ; scanline 7  pairs 00 00 00 10
; Glyph $a8 at charset offset $0540
!byte %10101000 ; scanline 0  pairs 10 10 10 00
!byte %10101000 ; scanline 1  pairs 10 10 10 00
!byte %10000010 ; scanline 2  pairs 10 00 00 10
!byte %10101010 ; scanline 3  pairs 10 10 10 10
!byte %10000010 ; scanline 4  pairs 10 00 00 10
!byte %10000000 ; scanline 5  pairs 10 00 00 00
!byte %10101010 ; scanline 6  pairs 10 10 10 10
!byte %10000000 ; scanline 7  pairs 10 00 00 00
; Glyph $a9 at charset offset $0548
!byte %00001010 ; scanline 0  pairs 00 00 10 10
!byte %10101000 ; scanline 1  pairs 10 10 10 00
!byte %10111010 ; scanline 2  pairs 10 11 10 10
!byte %10101010 ; scanline 3  pairs 10 10 10 10
!byte %10101010 ; scanline 4  pairs 10 10 10 10
!byte %10000000 ; scanline 5  pairs 10 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $aa at charset offset $0550
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00101000 ; scanline 2  pairs 00 10 10 00
!byte %10000000 ; scanline 3  pairs 10 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $ab at charset offset $0558
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000011 ; scanline 3  pairs 00 00 00 11
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $ac at charset offset $0560
!byte %00111100 ; scanline 0  pairs 00 11 11 00
!byte %00000010 ; scanline 1  pairs 00 00 00 10
!byte %00001011 ; scanline 2  pairs 00 00 10 11
!byte %11001010 ; scanline 3  pairs 11 00 10 10
!byte %00101010 ; scanline 4  pairs 00 10 10 10
!byte %00000010 ; scanline 5  pairs 00 00 00 10
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $ad at charset offset $0568
!byte %00000010 ; scanline 0  pairs 00 00 00 10
!byte %10100010 ; scanline 1  pairs 10 10 00 10
!byte %10101000 ; scanline 2  pairs 10 10 10 00
!byte %10101010 ; scanline 3  pairs 10 10 10 10
!byte %10101000 ; scanline 4  pairs 10 10 10 00
!byte %10100000 ; scanline 5  pairs 10 10 00 00
!byte %00001010 ; scanline 6  pairs 00 00 10 10
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $ae at charset offset $0570
!byte %10101010 ; scanline 0  pairs 10 10 10 10
!byte %10101010 ; scanline 1  pairs 10 10 10 10
!byte %00100000 ; scanline 2  pairs 00 10 00 00
!byte %00101010 ; scanline 3  pairs 00 10 10 10
!byte %10100000 ; scanline 4  pairs 10 10 00 00
!byte %00100000 ; scanline 5  pairs 00 10 00 00
!byte %00101010 ; scanline 6  pairs 00 10 10 10
!byte %10100000 ; scanline 7  pairs 10 10 00 00
; Glyph $af at charset offset $0578
!byte %00000100 ; scanline 0  pairs 00 00 01 00
!byte %00001000 ; scanline 1  pairs 00 00 10 00
!byte %00010000 ; scanline 2  pairs 00 01 00 00
!byte %00010000 ; scanline 3  pairs 00 01 00 00
!byte %00100000 ; scanline 4  pairs 00 10 00 00
!byte %01000000 ; scanline 5  pairs 01 00 00 00
!byte %01000000 ; scanline 6  pairs 01 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $b0 at charset offset $0580
!byte %00000010 ; scanline 0  pairs 00 00 00 10
!byte %00101010 ; scanline 1  pairs 00 10 10 10
!byte %10101110 ; scanline 2  pairs 10 10 11 10
!byte %10101010 ; scanline 3  pairs 10 10 10 10
!byte %10101010 ; scanline 4  pairs 10 10 10 10
!byte %00100000 ; scanline 5  pairs 00 10 00 00
!byte %10000000 ; scanline 6  pairs 10 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $b1 at charset offset $0588
!byte %10000000 ; scanline 0  pairs 10 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %10001010 ; scanline 2  pairs 10 00 10 10
!byte %10100000 ; scanline 3  pairs 10 10 00 00
!byte %10000000 ; scanline 4  pairs 10 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $b2 at charset offset $0590
!byte %00111000 ; scanline 0  pairs 00 11 10 00
!byte %01000100 ; scanline 1  pairs 01 00 01 00
!byte %00000100 ; scanline 2  pairs 00 00 01 00
!byte %00011000 ; scanline 3  pairs 00 01 10 00
!byte %00100000 ; scanline 4  pairs 00 10 00 00
!byte %01000000 ; scanline 5  pairs 01 00 00 00
!byte %01111100 ; scanline 6  pairs 01 11 11 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $b3 at charset offset $0598
!byte %00001111 ; scanline 0  pairs 00 00 11 11
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000010 ; scanline 2  pairs 00 00 00 10
!byte %11110010 ; scanline 3  pairs 11 11 00 10
!byte %00001010 ; scanline 4  pairs 00 00 10 10
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $b4 at charset offset $05a0
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %10101000 ; scanline 1  pairs 10 10 10 00
!byte %11101010 ; scanline 2  pairs 11 10 10 10
!byte %10101010 ; scanline 3  pairs 10 10 10 10
!byte %10101010 ; scanline 4  pairs 10 10 10 10
!byte %10101000 ; scanline 5  pairs 10 10 10 00
!byte %00000010 ; scanline 6  pairs 00 00 00 10
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $b5 at charset offset $05a8
!byte %10101010 ; scanline 0  pairs 10 10 10 10
!byte %10101010 ; scanline 1  pairs 10 10 10 10
!byte %00001000 ; scanline 2  pairs 00 00 10 00
!byte %10001010 ; scanline 3  pairs 10 00 10 10
!byte %00101000 ; scanline 4  pairs 00 10 10 00
!byte %00001000 ; scanline 5  pairs 00 00 10 00
!byte %10001010 ; scanline 6  pairs 10 00 10 10
!byte %00101000 ; scanline 7  pairs 00 10 10 00
; Glyph $b6 at charset offset $05b0
!byte %10000000 ; scanline 0  pairs 10 00 00 00
!byte %10001010 ; scanline 1  pairs 10 00 10 10
!byte %00101011 ; scanline 2  pairs 00 10 10 11
!byte %10101010 ; scanline 3  pairs 10 10 10 10
!byte %00101010 ; scanline 4  pairs 00 10 10 10
!byte %00001000 ; scanline 5  pairs 00 00 10 00
!byte %10100000 ; scanline 6  pairs 10 10 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $b7 at charset offset $05b8
!byte %10100000 ; scanline 0  pairs 10 10 00 00
!byte %10000000 ; scanline 1  pairs 10 00 00 00
!byte %10100010 ; scanline 2  pairs 10 10 00 10
!byte %10101000 ; scanline 3  pairs 10 10 10 00
!byte %10100000 ; scanline 4  pairs 10 10 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $b8 at charset offset $05c0
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %10000000 ; scanline 2  pairs 10 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $b9 at charset offset $05c8
!byte %00000011 ; scanline 0  pairs 00 00 00 11
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00111100 ; scanline 3  pairs 00 11 11 00
!byte %00000010 ; scanline 4  pairs 00 00 00 10
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $ba at charset offset $05d0
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00010000 ; scanline 1  pairs 00 01 00 00
!byte %00010000 ; scanline 2  pairs 00 01 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00010000 ; scanline 4  pairs 00 01 00 00
!byte %00010000 ; scanline 5  pairs 00 01 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $bb at charset offset $05d8
!byte %11000000 ; scanline 0  pairs 11 00 00 00
!byte %00101010 ; scanline 1  pairs 00 10 10 10
!byte %10111010 ; scanline 2  pairs 10 11 10 10
!byte %10101010 ; scanline 3  pairs 10 10 10 10
!byte %10101010 ; scanline 4  pairs 10 10 10 10
!byte %00101010 ; scanline 5  pairs 00 10 10 10
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $bc at charset offset $05e0
!byte %00101010 ; scanline 0  pairs 00 10 10 10
!byte %00101010 ; scanline 1  pairs 00 10 10 10
!byte %10000010 ; scanline 2  pairs 10 00 00 10
!byte %10100010 ; scanline 3  pairs 10 10 00 10
!byte %10001010 ; scanline 4  pairs 10 00 10 10
!byte %00000010 ; scanline 5  pairs 00 00 00 10
!byte %10100010 ; scanline 6  pairs 10 10 00 10
!byte %00001010 ; scanline 7  pairs 00 00 10 10
; Glyph $bd at charset offset $05e8
!byte %10100000 ; scanline 0  pairs 10 10 00 00
!byte %10100010 ; scanline 1  pairs 10 10 00 10
!byte %00001010 ; scanline 2  pairs 00 00 10 10
!byte %10101010 ; scanline 3  pairs 10 10 10 10
!byte %00001010 ; scanline 4  pairs 00 00 10 10
!byte %00000010 ; scanline 5  pairs 00 00 00 10
!byte %10101000 ; scanline 6  pairs 10 10 10 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $be at charset offset $05f0
!byte %00101000 ; scanline 0  pairs 00 10 10 00
!byte %10100000 ; scanline 1  pairs 10 10 00 00
!byte %11101000 ; scanline 2  pairs 11 10 10 00
!byte %10101010 ; scanline 3  pairs 10 10 10 10
!byte %10101000 ; scanline 4  pairs 10 10 10 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $bf at charset offset $05f8
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %10100000 ; scanline 2  pairs 10 10 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $c0 at charset offset $0600
!byte %10101010 ; scanline 0  pairs 10 10 10 10
!byte %10101010 ; scanline 1  pairs 10 10 10 10
!byte %10101010 ; scanline 2  pairs 10 10 10 10
!byte %11110101 ; scanline 3  pairs 11 11 01 01
!byte %01010101 ; scanline 4  pairs 01 01 01 01
!byte %01010101 ; scanline 5  pairs 01 01 01 01
!byte %01010101 ; scanline 6  pairs 01 01 01 01
!byte %01010101 ; scanline 7  pairs 01 01 01 01
; Glyph $c1 at charset offset $0608
!byte %01010101 ; scanline 0  pairs 01 01 01 01
!byte %01111101 ; scanline 1  pairs 01 11 11 01
!byte %01010101 ; scanline 2  pairs 01 01 01 01
!byte %01010101 ; scanline 3  pairs 01 01 01 01
!byte %01010101 ; scanline 4  pairs 01 01 01 01
!byte %01010101 ; scanline 5  pairs 01 01 01 01
!byte %01010101 ; scanline 6  pairs 01 01 01 01
!byte %01010101 ; scanline 7  pairs 01 01 01 01
; Glyph $c2 at charset offset $0610
!byte %01010101 ; scanline 0  pairs 01 01 01 01
!byte %01010101 ; scanline 1  pairs 01 01 01 01
!byte %01010101 ; scanline 2  pairs 01 01 01 01
!byte %01010101 ; scanline 3  pairs 01 01 01 01
!byte %01010101 ; scanline 4  pairs 01 01 01 01
!byte %01110101 ; scanline 5  pairs 01 11 01 01
!byte %01010101 ; scanline 6  pairs 01 01 01 01
!byte %01010101 ; scanline 7  pairs 01 01 01 01
; Glyph $c3 at charset offset $0618
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000011 ; scanline 4  pairs 00 00 00 11
!byte %00000011 ; scanline 5  pairs 00 00 00 11
!byte %00001111 ; scanline 6  pairs 00 00 11 11
!byte %00001111 ; scanline 7  pairs 00 00 11 11
; Glyph $c4 at charset offset $0620
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00001111 ; scanline 1  pairs 00 00 11 11
!byte %00111111 ; scanline 2  pairs 00 11 11 11
!byte %11111111 ; scanline 3  pairs 11 11 11 11
!byte %11111100 ; scanline 4  pairs 11 11 11 00
!byte %11111100 ; scanline 5  pairs 11 11 11 00
!byte %11111100 ; scanline 6  pairs 11 11 11 00
!byte %11111100 ; scanline 7  pairs 11 11 11 00
; Glyph $c5 at charset offset $0628
!byte %11000000 ; scanline 0  pairs 11 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $c6 at charset offset $0630
!byte %00001111 ; scanline 0  pairs 00 00 11 11
!byte %00111111 ; scanline 1  pairs 00 11 11 11
!byte %00111111 ; scanline 2  pairs 00 11 11 11
!byte %00111111 ; scanline 3  pairs 00 11 11 11
!byte %00001111 ; scanline 4  pairs 00 00 11 11
!byte %00001111 ; scanline 5  pairs 00 00 11 11
!byte %00001111 ; scanline 6  pairs 00 00 11 11
!byte %00000011 ; scanline 7  pairs 00 00 00 11
; Glyph $c7 at charset offset $0638
!byte %11111100 ; scanline 0  pairs 11 11 11 00
!byte %11111111 ; scanline 1  pairs 11 11 11 11
!byte %11111111 ; scanline 2  pairs 11 11 11 11
!byte %11111111 ; scanline 3  pairs 11 11 11 11
!byte %11111111 ; scanline 4  pairs 11 11 11 11
!byte %11111111 ; scanline 5  pairs 11 11 11 11
!byte %11111111 ; scanline 6  pairs 11 11 11 11
!byte %11111111 ; scanline 7  pairs 11 11 11 11
; Glyph $c8 at charset offset $0640
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %11000000 ; scanline 4  pairs 11 00 00 00
!byte %11110000 ; scanline 5  pairs 11 11 00 00
!byte %11111100 ; scanline 6  pairs 11 11 11 00
!byte %11111111 ; scanline 7  pairs 11 11 11 11
; Glyph $c9 at charset offset $0648
!byte %00000011 ; scanline 0  pairs 00 00 00 11
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $ca at charset offset $0650
!byte %11111111 ; scanline 0  pairs 11 11 11 11
!byte %11111111 ; scanline 1  pairs 11 11 11 11
!byte %00111111 ; scanline 2  pairs 00 11 11 11
!byte %00001111 ; scanline 3  pairs 00 00 11 11
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $cb at charset offset $0658
!byte %11111111 ; scanline 0  pairs 11 11 11 11
!byte %11111111 ; scanline 1  pairs 11 11 11 11
!byte %11111111 ; scanline 2  pairs 11 11 11 11
!byte %11111111 ; scanline 3  pairs 11 11 11 11
!byte %11111111 ; scanline 4  pairs 11 11 11 11
!byte %00000011 ; scanline 5  pairs 00 00 00 11
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $cc at charset offset $0660
!byte %11111100 ; scanline 0  pairs 11 11 11 00
!byte %11111111 ; scanline 1  pairs 11 11 11 11
!byte %11111111 ; scanline 2  pairs 11 11 11 11
!byte %11111111 ; scanline 3  pairs 11 11 11 11
!byte %11111111 ; scanline 4  pairs 11 11 11 11
!byte %11110000 ; scanline 5  pairs 11 11 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $cd at charset offset $0668
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %11111111 ; scanline 1  pairs 11 11 11 11
!byte %11111111 ; scanline 2  pairs 11 11 11 11
!byte %11111100 ; scanline 3  pairs 11 11 11 00
!byte %11000000 ; scanline 4  pairs 11 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $ce at charset offset $0670
!byte %11110000 ; scanline 0  pairs 11 11 00 00
!byte %11000000 ; scanline 1  pairs 11 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $cf at charset offset $0678
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $d0 at charset offset $0680
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $d1 at charset offset $0688
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $d2 at charset offset $0690
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $d3 at charset offset $0698
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $d4 at charset offset $06a0
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $d5 at charset offset $06a8
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $d6 at charset offset $06b0
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $d7 at charset offset $06b8
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $d8 at charset offset $06c0
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $d9 at charset offset $06c8
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $da at charset offset $06d0
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $db at charset offset $06d8
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $dc at charset offset $06e0
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $dd at charset offset $06e8
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $de at charset offset $06f0
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $df at charset offset $06f8
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $e0 at charset offset $0700
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $e1 at charset offset $0708
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $e2 at charset offset $0710
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $e3 at charset offset $0718
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $e4 at charset offset $0720
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $e5 at charset offset $0728
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $e6 at charset offset $0730
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $e7 at charset offset $0738
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $e8 at charset offset $0740
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $e9 at charset offset $0748
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $ea at charset offset $0750
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $eb at charset offset $0758
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $ec at charset offset $0760
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $ed at charset offset $0768
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $ee at charset offset $0770
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $ef at charset offset $0778
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $f0 at charset offset $0780
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $f1 at charset offset $0788
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $f2 at charset offset $0790
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $f3 at charset offset $0798
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $f4 at charset offset $07a0
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $f5 at charset offset $07a8
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $f6 at charset offset $07b0
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $f7 at charset offset $07b8
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $f8 at charset offset $07c0
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $f9 at charset offset $07c8
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $fa at charset offset $07d0
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $fb at charset offset $07d8
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $fc at charset offset $07e0
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $fd at charset offset $07e8
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $fe at charset offset $07f0
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
; Glyph $ff at charset offset $07f8
!byte %00000000 ; scanline 0  pairs 00 00 00 00
!byte %00000000 ; scanline 1  pairs 00 00 00 00
!byte %00000000 ; scanline 2  pairs 00 00 00 00
!byte %00000000 ; scanline 3  pairs 00 00 00 00
!byte %00000000 ; scanline 4  pairs 00 00 00 00
!byte %00000000 ; scanline 5  pairs 00 00 00 00
!byte %00000000 ; scanline 6  pairs 00 00 00 00
!byte %00000000 ; scanline 7  pairs 00 00 00 00
