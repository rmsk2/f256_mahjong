TC0 = 7
TC2 = 9
TC3 = 10

TILE_X = 20
TILE_Y = 24
TILE_SIZE = TILE_X * TILE_Y

NUM_TILES_X = 13
NUM_TILES_Y = 9
NUM_TILES_Z = 5

X_OFFSET = 18
Y_OFFSET = 18

NO_TILE = $FF
PLAYFIELD_SIZE = NUM_TILES_X * NUM_TILES_Y * NUM_TILES_Z

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
    lda #NO_TILE
    sta memory.MEM_SET.valToSet
    #load16BitImmediate PLAYFIELD, memory.MEM_SET.startAddress
    #load16BitImmediate PLAYFIELD_SIZE, memory.MEM_SET.length
    jsr memory.memSet
    rts


setTile .macro n, x, y, z
    lda #\n
    sta TILE_PARAM.tileNum
    lda #\x
    sta TILE_PARAM.x
    lda #\y
    sta TILE_PARAM.y
    lda #\z
    sta TILE_PARAM.z
    jsr setTileCall
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
    lda TILE_PARAM.tileNum
    cmp #NO_TILE
    bne _draw
    rts
_draw
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

PLAYFIELD .fill PLAYFIELD_SIZE

CELL_ADDR  .word 0
setTileCall
    mul8x16BitCoproc TILE_PARAM.z, NUM_TILES_X * NUM_TILES_Y, LAYER_ADDR
    #mul8x8BitCoprocImm TILE_PARAM.y, NUM_TILES_X, CELL_ADDR
    #add16Bit CELL_ADDR, LAYER_ADDR
    #add16BitByte TILE_PARAM.x, LAYER_ADDR
    #add16BitImmediate PLAYFIELD, LAYER_ADDR
    lda TILE_PARAM.tileNum
    sta (LAYER_ADDR)
    rts


getTileCall
    mul8x16BitCoproc TILE_PARAM.z, NUM_TILES_X * NUM_TILES_Y, LAYER_ADDR
    #mul8x8BitCoprocImm TILE_PARAM.y, NUM_TILES_X, CELL_ADDR
    #add16Bit CELL_ADDR, LAYER_ADDR
    #add16BitByte TILE_PARAM.x, LAYER_ADDR
    #add16BitImmediate PLAYFIELD, LAYER_ADDR
    lda (LAYER_ADDR)
    rts


drawAll
    #load16BitImmediate PLAYFIELD, PFIELD_PTR
    stz TILE_PARAM.x
    stz TILE_PARAM.y
    stz TILE_PARAM.z
_loop
    lda (PFIELD_PTR)
    sta TILE_PARAM.tileNum
    jsr blitTileCall
    #inc16Bit PFIELD_PTR
    lda TILE_PARAM.x
    ina
    sta TILE_PARAM.x
    cmp #NUM_TILES_X
    bne _loop
    stz TILE_PARAM.x
    lda TILE_PARAM.y
    ina
    sta TILE_PARAM.y
    cmp #NUM_TILES_Y
    bne _loop
    stz TILE_PARAM.y
    lda TILE_PARAM.z
    ina
    sta TILE_PARAM.z
    cmp #NUM_TILES_Z
    bne _loop
    rts    

.include "dummy_playfield.asm"

.endnamespace