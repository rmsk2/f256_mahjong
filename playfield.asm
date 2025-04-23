TC0 = 7
TC2 = 9
TC3 = 10

TILE_X = 20
TILE_Y = 24
TILE_SIZE = TILE_X * TILE_Y

X_OFFSET = 18
Y_OFFSET = 18

RAW_TILE = 1
EMPTY_FRAME
    .byte 0, TC0, TC0, TC0, TC0, TC0, TC0, TC0, TC0, TC0, TC0, TC0, TC0, TC0, TC0, TC0, TC0, TC0, TC0, 0
    .byte TC0, TC0, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC2, TC2, TC0, TC0
    .byte TC0, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC2, TC2, TC0
    .byte TC0, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC2, TC2, TC0
    .byte TC0, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC2, TC2, TC0
    .byte TC0, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC2, TC2, TC0
    .byte TC0, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC2, TC2, TC0
    .byte TC0, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC2, TC2, TC0
    .byte TC0, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC2, TC2, TC0
    .byte TC0, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC2, TC2, TC0
    .byte TC0, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC2, TC2, TC0
    .byte TC0, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC2, TC2, TC0
    .byte TC0, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC2, TC2, TC0
    .byte TC0, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC2, TC2, TC0
    .byte TC0, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC2, TC2, TC0
    .byte TC0, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC2, TC2, TC0
    .byte TC0, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC2, TC2, TC0
    .byte TC0, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC2, TC2, TC0
    .byte TC0, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC2, TC2, TC0
    .byte TC0, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC2, TC2, TC0
    .byte TC0, TC2, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC2, TC2, TC2, TC0
    .byte TC0, TC2, TC2, TC2, TC2, TC2, TC2, TC2, TC2, TC2, TC2, TC2, TC2, TC2, TC2, TC2, TC2, TC2, TC2, TC0
    .byte TC0, TC0, TC2, TC2, TC2, TC2, TC2, TC2, TC2, TC2, TC2, TC2, TC2, TC2, TC2, TC2, TC2, TC2, TC0, TC0
    .byte 0, TC0, TC0, TC0, TC0, TC0, TC0, TC0, TC0, TC0, TC0, TC0, TC0, TC0, TC0, TC0, TC0, TC0, TC0, 0

    .byte 0, TC0, TC0, TC0, TC0, TC0, TC0, TC0, TC0, TC0, TC0, TC0, TC0, TC0, TC0, TC0, TC0, TC0, TC0, 0
    .byte TC0, TC0, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC2, TC2, TC0, TC0
    .byte TC0, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC2, TC2, TC0
    .byte TC0, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC2, TC2, TC0
    .byte TC0, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC2, TC2, TC0
    .byte TC0, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC2, TC2, TC0
    .byte TC0, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC2, TC2, TC0
    .byte TC0, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC2, TC2, TC0
    .byte TC0, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC2, TC2, TC0
    .byte TC0, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC2, TC2, TC0
    .byte TC0, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC2, TC2, TC0
    .byte TC0, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC2, TC2, TC0
    .byte TC0, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC2, TC2, TC0
    .byte TC0, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC2, TC2, TC0
    .byte TC0, TC3, TC3, TC0, TC0, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC2, TC2, TC0
    .byte TC0, TC3, TC3, TC0, TC0, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC2, TC2, TC0
    .byte TC0, TC3, TC3, TC0, TC0, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC2, TC2, TC0
    .byte TC0, TC3, TC3, TC0, TC0, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC2, TC2, TC0
    .byte TC0, TC3, TC3, TC0, TC0, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC2, TC2, TC0
    .byte TC0, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC2, TC2, TC0
    .byte TC0, TC2, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC3, TC2, TC2, TC2, TC0
    .byte TC0, TC2, TC2, TC2, TC2, TC2, TC2, TC2, TC2, TC2, TC2, TC2, TC2, TC2, TC2, TC2, TC2, TC2, TC2, TC0
    .byte TC0, TC0, TC2, TC2, TC2, TC2, TC2, TC2, TC2, TC2, TC2, TC2, TC2, TC2, TC2, TC2, TC2, TC2, TC0, TC0
    .byte 0, TC0, TC0, TC0, TC0, TC0, TC0, TC0, TC0, TC0, TC0, TC0, TC0, TC0, TC0, TC0, TC0, TC0, TC0, 0


playfield .namespace

init
    #load24BitImmediate EMPTY_FRAME, TILE_PARAM.tileBase
    rts

blitTile .macro n, x, y, z
    lda #\n
    sta TILE_PARAM.tileNum
    lda #\x
    sta TILE_PARAM.x
    lda #\y
    sta TILE_PARAM.y
    lda #\z
    sta TILE_PARAM.z
    jsr blitTileCall
.endmacro

TileDrawParam_t .struct
    tileNum   .byte 0
    x         .byte 0
    y         .byte 0
    z         .byte 0
    tilebase  .long 0
.endstruct

TILE_PARAM .dstruct TileDrawParam_t
Z_CORRECT_X .byte 0, 3, 6, 9, 12
Z_CORRECT_Y .byte 0, 3, 6, 9, 12
Z_CORRECT .word 0

blitTileCall
    stz memory.SRC_ADDRESS + 2
    #mul8x16BitCoproc TILE_PARAM.tileNum, TILE_SIZE, memory.SRC_ADDRESS
    clc
    lda memory.SRC_ADDRESS
    adc TILE_PARAM.tileBase
    sta memory.SRC_ADDRESS
    lda memory.SRC_ADDRESS + 1
    adc TILE_PARAM.tileBase + 1
    sta memory.SRC_ADDRESS + 1
    lda memory.SRC_ADDRESS + 2
    adc TILE_PARAM.tileBase + 2
    sta memory.SRC_ADDRESS + 2
    jsr memory.linearToSourceAddress

    #mul8x8BitCoprocImm TILE_PARAM.x, TILE_X, memory.X_POS
    #add16BitImmediate X_OFFSET, memory.X_POS
    ldx TILE_PARAM.z
    lda Z_CORRECT_X, x
    sta Z_CORRECT
    #sub16Bit Z_CORRECT, memory.X_POS

    #mul8x8BitCoprocImm TILE_PARAM.y, TILE_Y, memory.Y_POS
    ldx TILE_PARAM.z
    lda Z_CORRECT_Y, x
    sta Z_CORRECT
    sec
    lda memory.Y_POS
    sbc Z_CORRECT
    clc
    adc #Y_OFFSET
    sta memory.Y_POS

    jsr memory.pixelPosToTargetAddress    
    jsr memory.blit
    rts


test
    #load16BitImmediate 320, memory.BLIT_PARMS.lineSize
    lda #TILE_X
    sta memory.BLIT_PARMS.objSize
    lda #TILE_Y
    sta memory.BLIT_PARMS.numLines
    #load16BitImmediate memory.overwriteWithTransparency, memory.BLIT_VECTOR

    #blitTile 0, 0, 0, 0

    #blitTile 0, 1, 0, 0
    #blitTile 0, 1, 0, 1
    #blitTile 0, 1, 0, 2
    #blitTile 0, 1, 0, 3
    #blitTile 0, 1, 0, 4

    #blitTile 0, 1, 1, 0

    #blitTile 0, 2, 0, 0
    #blitTile 0, 2, 0, 1
    
    #blitTile 1, 3, 0, 0

    #blitTile 0, 4, 0, 0
    #blitTile 0, 5, 0, 0
    #blitTile 0, 6, 0, 0
    #blitTile 0, 7, 0, 0
    #blitTile 0, 8, 0, 0
    #blitTile 0, 9, 0, 0
    #blitTile 0, 10, 0, 0
    #blitTile 0, 11, 0, 0
    #blitTile 0, 12, 0, 0

    #blitTile 0, 2, 1, 0

    #blitTile 0, 2, 2, 0
    #blitTile 0, 2, 3, 0
    #blitTile 0, 2, 4, 0

    #blitTile 0, 2, 5, 0
    #blitTile 0, 2, 6, 0
    #blitTile 0, 2, 7, 0
    #blitTile 0, 2, 8, 0

    #blitTile 0, 2, 1, 1

    #blitTile 0, 3, 1, 0
    #blitTile 0, 3, 1, 1
    #blitTile 0, 3, 1, 2
    #blitTile 0, 3, 1, 3
    #blitTile 0, 3, 1, 4

    rts

.endnamespace