undo .namespace

MMU_WINDOW = $8000
MMU_ADDR = (MMU_WINDOW / 8192) + 8

; use data at $1E000-$1FFFF
UNDO_DATA_ADDR = $1E000
UNDO_DATA_RAM_BLOCK = UNDO_DATA_ADDR / 8192

NUM_UNDO_STATE_MAX = 72

UndoData_t .struct
    index  .byte 0
    length .byte 0
.endstruct

TileInfo_t .struct
    addr .word 0
    num  .byte 0
.endstruct

StateChange_t .struct
    tile1 .dstruct TileInfo_t
    tile2 .dstruct TileInfo_t
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

    #move16Bit playfield.TILE_PARAM.tileMem, UNDO_PTR2
    #move16Bit playfield.SELECTED_TILE.tileMem, UNDO_PTR3

    ; save value of tile1
    lda (UNDO_PTR2)
    ldy #TileInfo_t.num
    sta (UNDO_PTR1), y

    ; save value of tile2
    lda (UNDO_PTR3)
    ldy #TileInfo_t.num + size(TileInfo_t)
    sta (UNDO_PTR1), y

    ; save address of tile1
    lda UNDO_PTR2
    ldy #TileInfo_t.addr
    sta (UNDO_PTR1), y
    iny
    lda UNDO_PTR2 + 1
    sta (UNDO_PTR1), y

    ; save address of tile2
    lda UNDO_PTR3
    ldy #TileInfo_t.addr + size(TileInfo_t)
    sta (UNDO_PTR1), y
    iny
    lda UNDO_PTR3 + 1
    sta (UNDO_PTR1), y

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


calcIndexAddr
    #mul8x16BitCoproc UNDO_DATA.index, size(StateChange_t), UNDO_PTR1
    #add16BitImmediate MMU_WINDOW, UNDO_PTR1
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

    ; restore address of tile 1
    ldy #TileInfo_t.addr
    lda (UNDO_PTR1), y
    sta UNDO_PTR2
    iny
    lda (UNDO_PTR1), y
    sta UNDO_PTR2 + 1

    ; restore address of tile 2
    ldy #TileInfo_t.addr + size(TileInfo_t)
    lda (UNDO_PTR1), y
    sta UNDO_PTR3
    iny
    lda (UNDO_PTR1), y
    sta UNDO_PTR3 + 1

    ; restore value of tile1
    ldy #TileInfo_t.num
    lda (UNDO_PTR1), y
    sta (UNDO_PTR2)

    ; restore vaule of tile2
    ldy #TileInfo_t.num + size(TileInfo_t)
    lda (UNDO_PTR1), y
    sta (UNDO_PTR3)

    pla
    sta MMU_ADDR

    clc
    rts

.endnamespace