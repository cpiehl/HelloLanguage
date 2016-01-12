	*=$0801
	.byte $0c, $08, $0a, $00, $9e, $20
	.byte $34, $30, $39, $36, $00, $00
	.byte $00
	*=$1000
	jsr $e544 ;clear screen

	; store 123456 (0x0001E240) little endian
	lda #$40
	sta value
	lda #$E2
	sta value+1
	lda #$01
	sta value+2
	lda #$00
	sta value+3

	; prints a 32 bit value to the screen
printdec
	jsr hex2dec

	ldx #9
l1      lda result,x
	bne l2
	dex             ; skip leading zeros
	bne l1

l2      lda result,x
	ora #$30
	jsr $ffd2
	dex
	bpl l2
	rts

	; converts 10 digits (32 bit values have max. 10 decimal digits)
hex2dec
	ldx #0
l3      jsr div10
	sta result,x
	inx
	cpx #10
	bne l3
	rts

	; divides a 32 bit value by 10
	; remainder is returned in akku
div10
	ldy #32         ; 32 bits
	lda #0
	clc
l4      rol
	cmp #10
	bcc skip
	sbc #10
skip    rol value
	rol value+1
	rol value+2
	rol value+3
	dey
	bpl l4
	rts

value   .byte $ff,$ff,$ff,$ff

result  .byte 0,0,0,0,0,0,0,0,0,0