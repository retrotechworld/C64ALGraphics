; Assemble from the project root. Output format is set by tasks.json.
!cpu 6510
!source "src/includes/hardware.asm"

* = $0801                 ; Standard BASIC program start
!word basic_end           ; Pointer to next BASIC line
!word 10                  ; BASIC line number
!byte $9e                 ; BASIC SYS token
!text "2061"              ; Decimal address of start ($080d)
!byte 0                   ; End of BASIC line
basic_end:
!word 0                   ; End of BASIC program

start:
    lda #0                ; Black border
    sta BORDER ; Write A to BORDER.
    lda #6                ; Blue background
    sta BACKGROUND ; Write A to BACKGROUND.
    lda #147              ; PETSCII clear screen
    jsr CHROUT ; Call CHROUT; RTS resumes after this JSR.
    lda #5                ; PETSCII white text
    jsr CHROUT ; Call CHROUT; RTS resumes after this JSR.
    ldx #0 ; Load X with 0.
print_loop:
    lda message,x ; Read message,x into A.
    beq done ; Branch to done if zero is set.
    stx saved_x           ; Do not depend on ROM preserving X
    jsr CHROUT ; Call CHROUT; RTS resumes after this JSR.
    ldx saved_x ; Read saved x into X.
    inx ; Increment X; update zero and negative flags.
    bne print_loop ; Branch to print_loop if zero is clear.

done:
    jmp done              ; Stay on the result screen
saved_x:
    !byte 0
message:
    !text "HELLO FROM ACME!",13,0 ; Uppercase ASCII bytes match PETSCII here
