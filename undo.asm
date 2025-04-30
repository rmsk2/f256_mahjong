undo .namespace

MMU_WINDOW = $8000
MMU_ADDR = (MMU_WINDOW / 8192) + 8

; use data at $1E000-$1FFFF
UNDO_DATA_ADDR = $1E000
UNDO_DATA_RAM_BLOCK = UNDO_DATA_ADDR / 8192

NUM_UNDO_STATE_MAX = 14


UndoData_t .struct
    index  .byte 0
    length .byte 0
.endstruct

UNDO_DATA .dstruct UndoData_t

init
    stz UNDO_DATA.index
    stz UNDO_DATA.length
    rts


pushState
    lda MMU_ADDR
    pha
    lda #UNDO_DATA_RAM_BLOCK
    sta MMU_ADDR

    jsr calcIndexAddr    
    #load16BitImmediate playfield.PLAYFIELD_MAIN, memory.MEM_CPY.startAddress
    #move16Bit INDEX_ADDR, memory.MEM_CPY.targetAddress
    #load16BitImmediate PLAYFIELD_SIZE, memory.MEM_CPY.length
    jsr memory.memCpy

    pla
    sta MMU_ADDR

    inc UNDO_DATA.index
    #mod8x8BitCoprocImm UNDO_DATA.index, NUM_UNDO_STATE_MAX
    sta UNDO_DATA.index
    lda UNDO_DATA.length
    cmp #NUM_UNDO_STATE_MAX
    beq _done
    inc UNDO_DATA.length
_done
    rts


INDEX_ADDR .word 0
calcIndexAddr
    #mul8x16BitCoproc UNDO_DATA.index, PLAYFIELD_SIZE, INDEX_ADDR
    #add16BitImmediate MMU_WINDOW, INDEX_ADDR
    rts


; carry is set if ring buffer is empty upon call
popState
    lda UNDO_DATA.length
    bne _notEmpty
    sec
    rts
_notEmpty
    lda UNDO_DATA.index
    clc
    adc #NUM_UNDO_STATE_MAX-1
    sta UNDO_DATA.index
    #mod8x8BitCoprocImm UNDO_DATA.index, NUM_UNDO_STATE_MAX
    sta UNDO_DATA.index
    dec UNDO_DATA.length

    lda MMU_ADDR
    pha
    lda #UNDO_DATA_RAM_BLOCK
    sta MMU_ADDR

    jsr calcIndexAddr
    #move16Bit INDEX_ADDR, memory.MEM_CPY.startAddress
    #load16BitImmediate playfield.PLAYFIELD_MAIN, memory.MEM_CPY.targetAddress
    #load16BitImmediate PLAYFIELD_SIZE, memory.MEM_CPY.length
    jsr memory.memCpy

    pla
    sta MMU_ADDR

    clc
    rts

.endnamespace