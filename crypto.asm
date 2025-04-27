chacha20 .namespace

; --------------------------------------------------
; Add the 32 bit values pointed to by ZERO_PAGE_1 and ZERO_PAGE_3
; and store the result in ZERO_PAGE_3 
;
; op3 <- op1 + op3
; --------------------------------------------------
add32BitUnsigned
    ldy #0
    clc
    lda (ZERO_PAGE_1),y
    adc (ZERO_PAGE_3),y
    sta (ZERO_PAGE_3),y
    iny
    lda (ZERO_PAGE_1),y
    adc (ZERO_PAGE_3),y
    sta (ZERO_PAGE_3),y    
    iny
    lda (ZERO_PAGE_1),y
    adc (ZERO_PAGE_3),y
    sta (ZERO_PAGE_3),y    
    iny
    lda (ZERO_PAGE_1),y
    adc (ZERO_PAGE_3),y
    sta (ZERO_PAGE_3),y    

    rts


; --------------------------------------------------
; XOR the 32 bit values pointed to by ZERO_PAGE_1 and ZERO_PAGE_3
; and store the result in ZERO_PAGE_3 
;
; op3 <- op1 xor op3
; --------------------------------------------------
xor32BitUnsigned
    ldy #0
    lda (ZERO_PAGE_1),y
    eor (ZERO_PAGE_3),y
    sta (ZERO_PAGE_3),y
    iny
    lda (ZERO_PAGE_1),y
    eor (ZERO_PAGE_3),y
    sta (ZERO_PAGE_3),y    
    iny
    lda (ZERO_PAGE_1),y
    eor (ZERO_PAGE_3),y
    sta (ZERO_PAGE_3),y    
    iny
    lda (ZERO_PAGE_1),y
    eor (ZERO_PAGE_3),y
    sta (ZERO_PAGE_3),y    

    rts

; --------------------------------------------------
; move 32 bit values pointed to by ZERO_PAGE_1 to addres to which ZERO_PAGE_3
; points. 
; 
; op3 <- op1
; --------------------------------------------------
move32Bit
    ldy #3
_loopMove
    lda (ZERO_PAGE_1),y
    sta (ZERO_PAGE_3),y
    dey
    bpl _loopMove

    rts


; --------------------------------------------------
; rot32Bit rotates the 32 bit value to which ZERO_PAGE_1 points one bit
; to the left.
;
; op1 <- op1 <<< 1
; --------------------------------------------------
rot32Bit
    ldy #0
    lda (ZERO_PAGE_1),y
    asl
    sta (ZERO_PAGE_1),y

    iny
    lda (ZERO_PAGE_1),y
    rol
    sta (ZERO_PAGE_1),y

    iny
    lda (ZERO_PAGE_1),y
    rol
    sta (ZERO_PAGE_1),y

    iny
    lda (ZERO_PAGE_1),y
    rol
    sta (ZERO_PAGE_1),y
    bcc _noCarry

    ldy #0
    lda (ZERO_PAGE_1),y
    ora #1
    sta (ZERO_PAGE_1),y
_noCarry
    rts


; --------------------------------------------------
; print32Bit prints the 32 bit value to which ZERO_PAGE_1 points
; --------------------------------------------------
print32Bit
    ldy #3
_loopPrint
    lda (ZERO_PAGE_1),y
    jsr txtio.printByte
    dey
    bpl _loopPrint

    rts    


SCRATCH_ROT_16_1
.byte 0
SCRATCH_ROT_16_2
.byte 0
; --------------------------------------------------
; rot16Bits rotates the 32 bit value to which ZERO_PAGE_1 points 2 bytes
; to the left.
;
; op1 <- op1 <<< 16
; --------------------------------------------------
rot16Bits
    #move16Bit ZERO_PAGE_1, ZERO_PAGE_3
    #sub16BitImmediate 2, ZERO_PAGE_3

    ; save two MSB
    ldy #3
    lda (ZERO_PAGE_1),y
    sta SCRATCH_ROT_16_1
    dey
    lda (ZERO_PAGE_1),y
    sta SCRATCH_ROT_16_2

    ldy #3
    ; copy remaining two bytes
    lda (ZERO_PAGE_3), y
    sta (ZERO_PAGE_1), y 
    dey

    lda (ZERO_PAGE_3), y
    sta (ZERO_PAGE_1), y

    ; copy saved bytes
    ldy #1
    lda SCRATCH_ROT_16_1
    sta (ZERO_PAGE_1),Y
    dey
    lda SCRATCH_ROT_16_2
    sta (ZERO_PAGE_1), y     

    rts


SCRATCH_ROT_8
.byte 0
; --------------------------------------------------
; rot8Bits rotates the 32 bit value to which ZERO_PAGE_1 points 1 byte
; to the left.
;
; op1 <- op1 <<< 8
; --------------------------------------------------
rot8Bits
    #move16Bit ZERO_PAGE_1, ZERO_PAGE_3
    #dec16Bit ZERO_PAGE_3

    ; save most significant byte
    ldy #3
    lda (ZERO_PAGE_1),y
    sta SCRATCH_ROT_8

    ; copy remaining three bytes
    lda (ZERO_PAGE_3), y
    sta (ZERO_PAGE_1), y 
    dey

    lda (ZERO_PAGE_3), y
    sta (ZERO_PAGE_1), y 
    dey

    lda (ZERO_PAGE_3), y
    sta (ZERO_PAGE_1), y
    dey

    ; y reg now contains 0
    lda SCRATCH_ROT_8
    sta (ZERO_PAGE_1),y

    rts


; --------------------------------------------------
; rot7Bit rotates the 32 bit value to which ZERO_PAGE_1 points seven bits
; to the left.
;
; op1 <- op1 <<< 7
; --------------------------------------------------
rot7Bits
    ldx #6
_loopRot7    
    jsr rot32Bit
    dex
    bpl _loopRot7
    rts


; --------------------------------------------------
; rot12Bit rotates the 32 bit value to which ZERO_PAGE_1 points twelve bits
; to the left.
;
; op1 <- op1 <<< 12
; --------------------------------------------------
rot12Bits
    jsr rot8Bits
    ldx #3
_loopRot12    
    jsr rot32Bit
    dex
    bpl _loopRot12
    
    rts


ADDR_A .word 0
ADDR_B .word 0
ADDR_C .word 0
ADDR_D .word 0
; --------------------------------------------------
; chaChaQuarterRound implements a ChaCha20 quarter round.
;
; The memory addresses of the 32 bit values have to be stored in ADDR_A - ADDR_D
; by the caller
; --------------------------------------------------
chaChaQuarterRound
    ; a += b
    #move16Bit ADDR_A, ZERO_PAGE_3
    #move16Bit ADDR_B, ZERO_PAGE_1
    jsr add32BitUnsigned
    ; d ^= a
    #move16Bit ADDR_D, ZERO_PAGE_3
    #move16Bit ADDR_A, ZERO_PAGE_1
    jsr xor32BitUnsigned
    ; d <<< 16
    #move16Bit ADDR_D, ZERO_PAGE_1
    jsr rot16Bits


    ; c += d
    #move16Bit ADDR_C, ZERO_PAGE_3
    #move16Bit ADDR_D, ZERO_PAGE_1
    jsr add32BitUnsigned
    ; b ^= c
    #move16Bit ADDR_B, ZERO_PAGE_3
    #move16Bit ADDR_C, ZERO_PAGE_1
    jsr xor32BitUnsigned
    ; b <<< 12
    #move16Bit ADDR_B, ZERO_PAGE_1
    jsr rot12Bits


    ; a += b
    #move16Bit ADDR_A, ZERO_PAGE_3
    #move16Bit ADDR_B, ZERO_PAGE_1
    jsr add32BitUnsigned
    ; d ^= a
    #move16Bit ADDR_D, ZERO_PAGE_3
    #move16Bit ADDR_A, ZERO_PAGE_1
    jsr xor32BitUnsigned
    ; d <<< 8
    #move16Bit ADDR_D, ZERO_PAGE_1
    jsr rot8Bits


    ; c += d
    #move16Bit ADDR_C, ZERO_PAGE_3
    #move16Bit ADDR_D, ZERO_PAGE_1
    jsr add32BitUnsigned
    ; b ^= c
    #move16Bit ADDR_B, ZERO_PAGE_3
    #move16Bit ADDR_C, ZERO_PAGE_1
    jsr xor32BitUnsigned
    ; b <<< 7
    #move16Bit ADDR_B, ZERO_PAGE_1
    jsr rot7Bits

    rts

loadQuarterData .macro addr1, addr2, addr3, addr4 
    #load16BitImmediate \addr1, ADDR_A
    #load16BitImmediate \addr2, ADDR_B
    #load16BitImmediate \addr3, ADDR_C
    #load16BitImmediate \addr4, ADDR_D
.endmacro

chaChaInnerBlock
    ;QUARTERROUND(0, 4, 8, 12)
    #loadQuarterData C_0, C_4, C_8, C_12
    jsr chaChaQuarterRound
    ;QUARTERROUND(1, 5, 9, 13)
    #loadQuarterData C_1, C_5, C_9, C_13
    jsr chaChaQuarterRound
    ;QUARTERROUND(2, 6, 10, 14)
    #loadQuarterData C_2, C_6, C_10, C_14
    jsr chaChaQuarterRound
    ;QUARTERROUND(3, 7, 11, 15)
    #loadQuarterData C_3, C_7, C_11, C_15
    jsr chaChaQuarterRound
    ;QUARTERROUND(0, 5, 10, 15)
    #loadQuarterData C_0, C_5, C_10, C_15
    jsr chaChaQuarterRound
    ;QUARTERROUND(1, 6, 11, 12)
    #loadQuarterData C_1, C_6, C_11, C_12
    jsr chaChaQuarterRound
    ;QUARTERROUND(2, 7, 8, 13)
    #loadQuarterData C_2, C_7, C_8, C_13
    jsr chaChaQuarterRound
    ;QUARTERROUND(3, 4, 9, 14)
    #loadQuarterData C_3, C_4, C_9, C_14
    jsr chaChaQuarterRound

    rts


; --------------------------------------------------
; chaChaAddState adds CHACHA_INITIAL_STATE and CHACHA_STATE.
; --------------------------------------------------
chaChaAddState
    #load16BitImmediate CHACHA20_INITIAL_STATE, ZERO_PAGE_1
    #load16BitImmediate CHACHA20_STATE, ZERO_PAGE_3
    ldx #15
_loopAddState
    jsr add32BitUnsigned
    #add16BitImmediate 4, ZERO_PAGE_1
    #add16BitImmediate 4, ZERO_PAGE_3
    dex
    bpl _loopAddState

    rts

ROUND_COUNT
.byte 0
; --------------------------------------------------
; chacha20BlockFunc implements the ChaCha20 block function
; --------------------------------------------------
chacha20BlockFunc
    lda #0
    sta ROUND_COUNT
_loopRounds
    jsr chaChaInnerBlock
    inc ROUND_COUNT
    lda ROUND_COUNT
    cmp #10
    bne _loopRounds

    jsr chaChaAddState
    rts


chaChaClearKey
    stz memory.MEM_SET.valToSet
    #load16BitImmediate 32, memory.MEM_SET.length
    #load16BitImmediate CHACHA_KEY, memory.MEM_SET.startAddress
    jsr memory.memSet

    #load16BitImmediate 12, memory.MEM_SET.length
    #load16BitImmediate CHACHA_NONCE, memory.MEM_SET.startAddress
    jsr memory.memSet

    rts


chaChaSetInitialState
    lda #1
    sta CHACHA_BLOCK
    lda #0
    sta CHACHA_BLOCK+1
    sta CHACHA_BLOCK+2
    sta CHACHA_BLOCK+3
chaChaCopyState
    ldx #0
_copyState
    lda CHACHA20_INITIAL_STATE,x
    sta CHACHA20_STATE,x
    inx
    cpx #64
    bne _copyState    

    rts

chaChaNextInitialState
    #inc16Bit CHACHA_BLOCK
    jmp chaChaCopyState


CHACHA20_INITIAL_STATE
I_0
;0x61707865
.byte $65,$78,$70,$61  
I_1
; 0x3320646e
.byte $6e,$64,$20,$33
I_2
; 0x79622d32
.byte $32,$2d,$62,$79
I_3
; 0x6b206574
.byte $74,$65,$20,$6b

CHACHA_KEY
I_4
.byte 0,0,0,0
I_5
.byte 0,0,0,0
I_6
.byte 0,0,0,0
I_7
.byte 0,0,0,0
I_8
.byte 0,0,0,0
I_9
.byte 0,0,0,0
I_10
.byte 0,0,0,0
I_11
.byte 0,0,0,0

CHACHA_BLOCK
I_12
.byte 0,0,0,0

CHACHA_NONCE
I_13
.byte 0,0,0,0
I_14
.byte 0,0,0,0
I_15
.byte 0,0,0,0


CHACHA20_STATE
C_0
.byte 0,0,0,0
C_1
.byte 0,0,0,0
C_2
.byte 0,0,0,0
C_3
.byte 0,0,0,0
C_4
.byte 0,0,0,0
C_5
.byte 0,0,0,0
C_6
.byte 0,0,0,0
C_7
.byte 0,0,0,0
C_8
.byte 0,0,0,0
C_9
.byte 0,0,0,0
C_10
.byte 0,0,0,0
C_11
.byte 0,0,0,0
C_12
.byte 0,0,0,0
C_13
.byte 0,0,0,0
C_14
.byte 0,0,0,0
C_15
.byte 0,0,0,0


chaChaInit
    jsr chaChaSetInitialState
    jsr chacha20BlockFunc
    lda #0
    sta KEY_STREAM_COUNT
    
    rts


KEY_STREAM_COUNT
.byte 0
chaChaGetNextByte
    ldx KEY_STREAM_COUNT
    cpx #64
    bne _getKeyByte
    jsr chaChaNextInitialState
    jsr chacha20BlockFunc
    ldx #0
    stx KEY_STREAM_COUNT
_getKeyByte
    lda CHACHA20_STATE, x
    inc KEY_STREAM_COUNT
    rts


unsetProcCallback
    #load16BitImmediate callBackDummy, PROC_CALLBACK
    rts    


procCallback
    jmp (PROC_CALLBACK)


callBackDummy
    rts

VEC_LEN .byte 0
; --------------------------------------------------
; This routine copies the contents of string to which TEMP_PTR points to the
; address to which TEMP_PTR2 points.
; --------------------------------------------------
copyByteVectorCall
    sta VEC_LEN
    ldy #0
_copyVecLoop
    cpy VEC_LEN
    beq _copyDone
    lda (TEMP_PTR),Y
    sta (TEMP_PTR2), Y
    iny
    bra _copyVecLoop
_copyDone
    rts


KEY_ADDR .word 0
NONCE_ADDR .word 0
BUFFER_ADDR .word 0
NUM_BUFFER_BYTES .word 0
BUFFER_COUNT .word 0

PROC_CALLBACK
    .word callBackDummy
; --------------------------------------------------
; processBufferCall encrypts/decrypts the buffer stored at BUFFER_ADDR using
; the key (as string) stored at KEY_ADDR and the nonce stored (as string) 
; at .NONCE_ADDR. In the buffer NUM_BUFFER_BYTES bytes are encrypted.
; --------------------------------------------------
processBufferCall
    #load16BitImmediate 0, BUFFER_COUNT
    jsr chaChaClearKey

    #move16Bit KEY_ADDR, TEMP_PTR
    #load16BitImmediate CHACHA_KEY, TEMP_PTR2
    lda #32
    jsr copyByteVectorCall

    #move16Bit NONCE_ADDR, TEMP_PTR
    #load16BitImmediate CHACHA_NONCE, TEMP_PTR2
    lda #12
    jsr copyByteVectorCall

    jsr chaChaInit
    #move16Bit BUFFER_ADDR, ZERO_PAGE_7    
_nextByte
    #cmp16Bit BUFFER_COUNT, NUM_BUFFER_BYTES
    beq _processingDone
    jsr procCallback
    jsr chaChaGetNextByte
    eor (ZERO_PAGE_7)
    sta (ZERO_PAGE_7)
    #inc16Bit ZERO_PAGE_7
    #inc16Bit BUFFER_COUNT
    bra _nextByte
_processingDone
    rts

processBufferImmediate .macro addrKey, addrNonce, bufferAddr, numBytes 
    #load16BitImmediate \addrKey, KEY_ADDR
    #load16BitImmediate \addrNonce, NONCE_ADDR
    #load16BitImmediate \bufferAddr, BUFFER_ADDR
    #load16BitImmediate \numBytes, NUM_BUFFER_BYTES
    jsr processBufferCall
.endmacro


processBufferAddr .macro addrKey, addrNonce, bufferAddr, numBytes
    #load16BitImmediate \addrKey, KEY_ADDR
    #load16BitImmediate \addrNonce, NONCE_ADDR
    #load16BitImmediate \bufferAddr, BUFFER_ADDR
    #move16Bit \numBytes, NUM_BUFFER_BYTES
    jsr processBufferCall
.endmacro


IS_TEST = 0

.if IS_TEST == 1

CHACHA_TEST_KEY
.byte $00, $01, $02, $03, $04, $05, $06, $07, $08, $09, $0a, $0b, $0c, $0d, $0e, $0f, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $1a, $1b, $1c, $1d, $1e, $1f
CHACHA_TEST_NONCE
.byte $00, $00 ,$00 ,$00 ,$00 ,$00 ,$00 ,$4a, $00, $00, $00, $00


VALIDATE_LEN = 64
TEST_BUFFER .fill VALIDATE_LEN
BUFFER_LEN .word VALIDATE_LEN
VAL_COUNT .byte 0

chachaTest
    ldy #0
    lda #0
_loop1
    sta TEST_BUFFER, y
    iny
    cpy #VALIDATE_LEN
    bne _loop1

    #processBufferAddr CHACHA_TEST_KEY, CHACHA_TEST_NONCE, TEST_BUFFER, BUFFER_LEN
    
    ldy #0
_loop
    lda TEST_BUFFER, y
    phy
    jsr txtio.printByte
    ply    
    iny
    cpy #VALIDATE_LEN
    bne _loop
    jsr txtio.newLine
    rts

.endif

.endnamespace