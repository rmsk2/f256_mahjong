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
TILE_DATA = $10000

playfield .namespace

init
    #load24BitImmediate TILE_DATA, TILE_PARAM.tileBase
    lda #NO_TILE
    sta memory.MEM_SET.valToSet
    #load16BitImmediate PLAYFIELD, memory.MEM_SET.startAddress
    #load16BitImmediate PLAYFIELD_SIZE, memory.MEM_SET.length
    jsr memory.memSet

    #load16BitImmediate 320, memory.BLIT_PARMS.lineSize
    lda #TILE_X
    sta memory.BLIT_PARMS.objSize
    lda #TILE_Y
    sta memory.BLIT_PARMS.numLines
    #load16BitImmediate memory.overwriteWithTransparency, memory.BLIT_VECTOR
    stz A_TILE_IS_SELECTED
    lda #144
    sta TILES_LEFT

    jsr createDummy
    jsr printTilesLeft

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
    tileMem   .word 0
    tilebase  .long 0
.endstruct

X_C0 = 0
X_C1 = 3
X_C2 = 6
X_C3 = 9
X_C4 = 12

Y_C0 = 0
Y_C1 = 3
Y_C2 = 6
Y_C3 = 9
Y_C4 = 12

TILE_PARAM .dstruct TileDrawParam_t
Z_CORRECT_X .byte X_C0, X_C1, X_C2, X_C3, X_C4
Z_CORRECT_Y .byte Y_C0, Y_C1, Y_C2, Y_C3, Y_C4
Z_CORRECT .word 0

SELECTED_TILE .dstruct TileDrawParam_t
A_TILE_IS_SELECTED .byte 0
TILES_LEFT .word 0

WIDTH = NUM_TILES_X * TILE_X
HEIGHT = NUM_TILES_Y * TILE_Y

X_TEMP .word 0
Y_TEMP .byte 0
H .byte 0
MEM_TEMP .word 0

checkForTile
    ldx #4
_loop    
    stx TILE_PARAM.z
    sec
    lda #X_OFFSET
    sbc Z_CORRECT_X, x
    sta H

    sec    
    lda select.CLICK_POS.x
    sbc H
    sta X_TEMP
    lda select.CLICK_POS.x + 1
    sbc #0
    sta X_TEMP + 1
    #cmp16BitImmediate WIDTH, X_TEMP
    bne _l1
    jmp _nexLayer
_l1
    bcs _l2
    jmp _nexLayer

_l2
    sec
    lda #Y_OFFSET
    sbc Z_CORRECT_Y, x
    sta H

    sec
    lda select.CLICK_POS.y
    sbc H
    sta Y_TEMP
    cmp #HEIGHT
    bcs _nexLayer

    #load16BitImmediate TILE_X, $DE04
    #move16Bit X_TEMP, $DE06
    lda $DE14
    cmp #NUM_TILES_X
    bcs _nexLayer
    sta TILE_PARAM.x

    #load16BitImmediate TILE_Y, $DE04
    lda Y_TEMP
    sta $DE06
    stz $DE07
    lda $DE14
    cmp #NUM_TILES_Y
    bcs _nexLayer
    sta TILE_PARAM.y

    jsr getTileCall
    cmp #NO_TILE
    beq _nexLayer
    cpx #4 
    beq _tileFound
    #move16Bit TILE_PARAM.tileMem, MEM_TEMP
    inc TILE_PARAM.z
    jsr getTileCall
    cmp #NO_TILE
    bne _noTile
    stx TILE_PARAM.z
    #move16Bit MEM_TEMP, TILE_PARAM.tileMem
_tileFound
    sec
    rts
_nexLayer
    dex
    bmi _noTile
    jmp _loop
_noTile
    clc
    rts
    

selectTile
    sec
    lda #X_OFFSET
    ldx TILE_PARAM.z
    sbc Z_CORRECT_X, x
    clc
    adc #32
    sta H

    lda TILE_PARAM.x
    sta $DE00
    stz $DE01
    #load16BitImmediate TILE_X, $DE02
    #move16Bit $DE10, sprite.FRAME_POS.x
    clc
    lda sprite.FRAME_POS.x
    adc H
    sta sprite.FRAME_POS.x
    lda sprite.FRAME_POS.x + 1
    adc #0
    sta sprite.FRAME_POS.x + 1

    sec
    lda #Y_OFFSET
    ldx TILE_PARAM.z
    sbc Z_CORRECT_Y, x
    clc
    adc #32
    sta H

    lda TILE_PARAM.y
    sta $DE00
    stz $DE01
    #load16BitImmediate TILE_Y, $DE02
    #move16Bit $DE10, sprite.FRAME_POS.y
    clc
    lda sprite.FRAME_POS.y
    adc H
    sta sprite.FRAME_POS.y

    #load16BitImmediate TILE_PARAM, memory.MEM_CPY.startAddress
    #load16BitImmediate SELECTED_TILE, memory.MEM_CPY.targetAddress
    #load16BitImmediate size(TileDrawParam_t), memory.MEM_CPY.length
    jsr memory.memCpy
    inc A_TILE_IS_SELECTED

    jsr sprite.frameOn

    rts


unselectTile
    stz A_TILE_IS_SELECTED
    jsr sprite.frameOff
    rts


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
    #move16Bit LAYER_ADDR, TILE_PARAM.tileMem
    lda (LAYER_ADDR)
    rts


ADDR_TEMP .word 0
; carry is set if tile is free, else it is clear
isTileFree
    lda TILE_PARAM.x
    cmp #0
    beq _isFree
    cmp #NUM_TILES_X-1
    beq _isFree
    #move16Bit TILE_PARAM.tileMem, LAYER_ADDR
    ldy #1
    lda (LAYER_ADDR), y
    cmp #NO_TILE
    beq _isFree
    #dec16Bit LAYER_ADDR
    lda (LAYER_ADDR)
    cmp #NO_TILE
    beq _isFree
    clc
    rts
_isFree
    sec
    rts


startRedraw
    lda #1
    sta select.REDRAW_IN_PROGRESS
    stz REDRAW_STATE
    rts


; carry is set if selected tile is the same tile as the current tile.
selectedEqual
    lda A_TILE_IS_SELECTED
    bne _checkFurther
    clc
    rts
_checkFurther
    #move16Bit TILE_PARAM.tileMem, LAYER_ADDR
    #move16Bit SELECTED_TILE.tileMem, LAYER_ADDR_SELECTED
    #cmp16Bit LAYER_ADDR, LAYER_ADDR_SELECTED
    beq _equal
    clc
    rts
_equal
    sec
    rts


; carry is set if selected tile is of the same type as the current tile.
selectedMatch
    lda A_TILE_IS_SELECTED
    bne _checkFurther
    clc
    rts
_checkFurther
    #move16Bit TILE_PARAM.tileMem, LAYER_ADDR
    #move16Bit SELECTED_TILE.tileMem, LAYER_ADDR_SELECTED
    lda (LAYER_ADDR)
    cmp (LAYER_ADDR_SELECTED)
    beq _equal
    clc
    rts
_equal
    sec
    rts


TILES_LEFT_TXT .text "Tiles left: "
printTilesLeft
    #locate 60, 3
    #printString TILES_LEFT_TXT, len(TILES_LEFT_TXT)
    #move16Bit TILES_LEFT, txtio.WORD_TEMP
    jsr txtio.printWordDecimal
    rts


erasePair
    #move16Bit TILE_PARAM.tileMem, LAYER_ADDR
    #move16Bit SELECTED_TILE.tileMem, LAYER_ADDR_SELECTED
    lda #NO_TILE
    sta (LAYER_ADDR)
    sta (LAYER_ADDR_SELECTED)
    dec TILES_LEFT
    dec TILES_LEFT
    rts


REDRAW_STATE .byte 0
performRedraw
    lda REDRAW_STATE
    bne _doLayer

    jsr hires.switchLayer
    jsr hires.clearBitmap
    jsr select.mouseWait

    #load16BitImmediate PLAYFIELD, PFIELD_PTR
    stz TILE_PARAM.x
    stz TILE_PARAM.y
    stz TILE_PARAM.z
    inc REDRAW_STATE
    rts
_doLayer
    cmp #46
    beq _finishRedraw

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
    bne _lineDone
    stz TILE_PARAM.y
    inc TILE_PARAM.z
_lineDone
    inc REDRAW_STATE
    rts

_finishRedraw
    jsr hires.showLayer
    stz select.REDRAW_IN_PROGRESS
    jsr select.mouseNormal
    jsr unselectTile
    jsr printTilesLeft
    rts    


drawAll
    jsr hires.switchLayer
    jsr hires.clearBitmap

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

    jsr hires.showLayer
    rts    

.include "dummy_playfield.asm"

.endnamespace