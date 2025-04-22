WIN_SRC    = $8000
WIN_TARGET = $A000

load24BitImmediate .macro val, target
    lda #<\val
    sta \target
    lda #>\val
    sta \target + 1
    lda #`\val
    sta \target + 2
.endmacro

memory .namespace

MMU_SRC =    8 + (WIN_SRC / $2000)
MMU_TARGET = 8 + (WIN_TARGET / $2000)
MUL_RES_CO_PROC = $DE10


MemBlit_t .struct 
    lineSize       .word 0
    targetRAMblock .byte 0
    objSize        .byte 0
    numLines       .byte 0
    
    mmuSrc         .byte 0
    mmuTarget      .byte 0
    mmuBkpSrc      .byte 0
    mmuBkpTarget   .byte 0
.endstruct

BLIT_PARMS .dstruct MemBlit_t


skipByteLinear .macro windowStart, zpPtr
    #inc16Bit \zpPtr
    ; did the pointer wrap around?
    #cmp16BitImmediate \windowStart+$2000, \zpPtr
    bne _done
    ; yes wrap around occurred
    ; switch to next RAM block
    inc 8 + (\windowStart / $2000)
    ; reset address to windowStart
    #load16BitImmediate \windowStart, \zpPtr
_done
.endmacro

readByteLinear .macro windowStart, zpPtr
    lda (\zpPtr)
    pha
    #inc16Bit \zpPtr
    ; did the pointer wrap around?
    #cmp16BitImmediate \windowStart+$2000, \zpPtr
    bne _done
    ; yes wrap around occurred
    ; switch to next RAM block
    inc 8 + (\windowStart / $2000)
    ; reset address to windowStart
    #load16BitImmediate \windowStart, \zpPtr
_done
    pla
.endmacro

BLIT_VECTOR .word overwrite
processByte
    jmp (BLIT_VECTOR)

overwrite
    sta (BLIT_TARGET)
    rts

overwriteWithTransparency
    beq _transparent
    sta (BLIT_TARGET)
_transparent
    rts

MMU_TEMP  .byte 0
ADDR_TEMP .word 0
; source pointer is BLIT_SRC. Target pointer is BLIT_TARGET.
blit
    ; save MMU state
    lda MMU_SRC
    sta BLIT_PARMS.mmuBkpSrc
    lda MMU_TARGET
    sta BLIT_PARMS.mmuBkpTarget

    ; set MMU to start values
    lda BLIT_PARMS.mmuSrc
    sta MMU_SRC
    lda BLIT_PARMS.mmuTarget
    sta MMU_TARGET

    ; initialize line count
    ldy #0
    ; copy one line
_copyLine
    ldx #0
    ; save line start address
    lda MMU_TARGET
    sta MMU_TEMP
    #move16Bit BLIT_TARGET, ADDR_TEMP
_checkEnd
    ; copy one line of object
    cpx BLIT_PARMS.objSize
    beq _lineDone
    #readByteLinear WIN_SRC, BLIT_SRC
    jsr processByte
    #skipByteLinear WIN_TARGET, BLIT_TARGET
    inx
    bra _checkEnd
_lineDone
    ; restore line start address
    lda MMU_TEMP
    sta MMU_TARGET
    #move16Bit ADDR_TEMP, BLIT_TARGET
    ; add line size to target pointer
    #add16Bit BLIT_PARMS.lineSize, BLIT_TARGET
    ; check for overflow in target MMU window
    #cmp16BitImmediate WIN_TARGET + $2000, BLIT_TARGET
    ; if BLIT_TARGET == WIN_TARGET + $2000 => overflow
    beq _overflow
    ; if carry is set then WIN_TARGET + $2000 is larger than the
    ; value stored at BLIT_TARGET => no overflow
    bcs _nextLine
_overflow
    ; move to next target window
    inc MMU_TARGET
    ; reduce target address
    #sub16BitImmediate $2000, BLIT_TARGET
_nextLine
    ; update line counter
    iny
    cpy BLIT_PARMS.numLines
    beq _done
    jmp _copyLine
_done
    ; restore MMU state
    lda BLIT_PARMS.mmuBkpSrc
    sta MMU_SRC
    lda BLIT_PARMS.mmuBkpTarget
    sta MMU_TARGET

    rts


linearToMMU .macro addr, zpPtr, memWindow
    lda \addr
    sta \zpPtr
    lda \addr + 1
    and #%00011111
    ; add MMU window address. Lo byte of window address is assumed to always be zero
    clc
    adc #>\memWindow
    sta \zpPtr + 1

    ; determine RAM block number
    ; first get lower three bits of middle byte
    lda \addr + 1
    lsr
    lsr
    lsr
    lsr
    lsr
    ; get most significant bit for RAM block from high byte TEMP + 2
    ; TEMP + 2 is either zero or one.
    ldy \addr + 2
    beq _notSetBit3
    ora #8
_notSetBit3
.endmacro

GRAPHIC_ADDRESS .byte 0,0
X_POS .word 0
Y_POS .byte 0
TEMP  .long 0

; transform pixel position in X_POS/Y_POS into a 24 bit address where the MMU page is stored in
; BLIT_PARMS.mmuTarget and the address in WIN_TARGET is stored in BLIT_TARGET
pixelPosToTargetAddress
    ; calc BLIT_PARMS.lineSize * Y_POS
    ; multiplication result is stored at $DE04-$DE07
    lda Y_POS
    sta $DE00
    stz $DE01
    #move16Bit BLIT_PARMS.lineSize, $DE02

    ; MUL_RES_CO_PROC contains BLIT_PARMS.lineSize * Y_POS
    ; add X_POS
    clc
    lda MUL_RES_CO_PROC
    adc X_POS
    sta TEMP
    lda MUL_RES_CO_PROC + 1
    adc X_POS + 1
    sta TEMP + 1
    lda #0
    adc MUL_RES_CO_PROC + 2
    sta TEMP + 2
    ; now TEMP contains full 24 bit linear address of pixel

    ; transform to MMU address
    #linearToMMU TEMP, BLIT_TARGET, WIN_TARGET
    clc
    adc BLIT_PARMS.targetRAMblock
    sta BLIT_PARMS.mmuTarget
    rts

SRC_ADDRESS .long 0
; transform 24 bit linear source address to MMU RAM block and window address. Where the
; RAM block is stored in BLIT_PARMS.mmuSrc and window address in BLIT_SRC.
linearToSourceAddress
    #linearToMMU SRC_ADDRESS, BLIT_SRC, WIN_SRC
    sta BLIT_PARMS.mmuSrc
    rts

.endnamespace