TILE_X = 20
TILE_Y = 24
TILE_SIZE = TILE_X * TILE_Y

NUM_TILES_X = 13
NUM_TILES_Y = 9
NUM_TILES_Z = 5

X_OFFSET = 18
Y_OFFSET = 18

NO_TILE = $FF
GROUP_SEASONS = 100
GROUP_FLOWERS = 101
GROUP_GENERIC = 30

PLAYFIELD_SIZE = NUM_TILES_X * NUM_TILES_Y * NUM_TILES_Z
TILE_DATA = $10000

initTileData .macro memUnshuffled, memShuffled, numElements
    ldx #0
_loop
    lda \memUnshuffled,x
    sta \memShuffled, x
    inx
    cpx #\numElements
    bne _loop
.endmacro    

playfield .namespace

dataInit
    #load24BitImmediate TILE_DATA, TILE_PARAM.tileBase
    #load16BitImmediate PLAYFIELD_MAIN, PLAYFIELD_VEC
    #load16BitImmediate 320, memory.BLIT_PARMS.lineSize
    lda #TILE_X
    sta memory.BLIT_PARMS.objSize
    lda #TILE_Y
    sta memory.BLIT_PARMS.numLines
    #load16BitImmediate memory.overwriteWithTransparency, memory.BLIT_VECTOR
    rts


init
    jsr dataInit
    jsr clearPlayfield
    jsr unselectTile
    stz A_TILE_IS_SELECTED
    lda #144
    sta TILES_LEFT
    #getTimestamp TIMER_STATE.tsStart
    lda #1
    sta TIMER_STATE.doDisplay

    jsr createRandPlayfield
    jsr printTilesLeft
    jsr checkPossibleMove
    jsr printUndoMoves

    rts

TimerState_t .struct
    doDisplay .byte 0
    tsStart   .dstruct TimeStamp_t, 0, 0, 0
.endstruct

TIMER_STATE .dstruct TimerState_t


DIFFICULTY_SOLVEABLE .text "SOLVEABLE"
DIFFICULTY_RANDOM    .text " RANDOM  "

DIFFICULTY_VEC .word DIFFICULTY_SOLVEABLE

SHUFFLE_VEC .word 0

createRandPlayfield
    jmp (SHUFFLE_VEC)


clearPlayfield
    lda #NO_TILE
setPlayfield
    sta memory.MEM_SET.valToSet
    #move16Bit PLAYFIELD_VEC, memory.MEM_SET.startAddress
    #load16BitImmediate PLAYFIELD_SIZE, memory.MEM_SET.length
    jsr memory.memSet
    rts


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



TILE_NUM .byte 0
; tile number in TILE_NUM
; plot pos in X_POS and Y_POS
blitTile2D
    sta TILE_NUM
    stz memory.SRC_ADDRESS + 2
    #mul8x16BitCoproc TILE_NUM, TILE_SIZE, memory.SRC_ADDRESS
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

    jsr memory.pixelPosToTargetAddress    
    jsr memory.blit
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


PLAYFIELD_VEC .word PLAYFIELD_MAIN

PLAYFIELD_MAIN .fill PLAYFIELD_SIZE

FreeList_t .struct
    data   .fill NUM_TILES_X * NUM_TILES_Y * 2
    values .fill NUM_TILES_X * NUM_TILES_Y
    len  .byte 0
.endstruct

FREE_LIST  .dstruct FreeList_t


LAYER_COUNTER .byte 0

determineTopLayer
    lda #4
    sta LAYER_COUNTER
_loop
    lda LAYER_COUNTER
    sta TILE_PARAM.z
    jsr getTileCall
    cmp #NO_TILE
    bne _done
    dec LAYER_COUNTER
    bpl _loop
_done
    rts


getAllFreeTiles
    stz FREE_LIST .len
    ldx #0
    ldy #0
_loop
    stx TILE_PARAM.x
    sty TILE_PARAM.y
    stz TILE_PARAM.z
    jsr getTileCall
    cmp #NO_TILE
    beq _next
    ; we have at least one tile in the column x, y
    jsr determineTopLayer
    lda LAYER_COUNTER
    sta TILE_PARAM.z
    phy
    jsr isTileFree
    ply
    bcc _next
    phx
    ; determine start byte in free list
    lda FREE_LIST.len
    asl
    tax
    ; index of byte to write is now in x-register
    lda TILE_PARAM.x
    ; store x corrdinate in free list
    sta FREE_LIST.data,x
    ; load y coordinate
    lda TILE_PARAM.y
    ; move value to upper 4 bits
    asl
    asl
    asl
    asl
    ora FREE_LIST.data,x
    ; write x and y coordinates to free list
    sta FREE_LIST.data,x
    inx
    ; write z coordinate into free lest
    lda TILE_PARAM.z
    sta FREE_LIST.data,x
    ; save tile value
    #move16Bit TILE_PARAM.tileMem, LAYER_ADDR
    lda (LAYER_ADDR)
    jsr isFlower
    bcc _noFlower
    lda #GROUP_FLOWERS
    bra _writeTileVal
_noFlower
    lda (LAYER_ADDR)
    jsr isSeason
    bcc _noSpecial
    lda #GROUP_SEASONS
    bra _writeTileVal
_noSpecial
    lda (LAYER_ADDR)
_writeTileVal
    ldx FREE_LIST.len
    sta FREE_LIST.values, x
    plx
    ; increment free list counter
    inc FREE_LIST.len
_next
    inx
    cpx #NUM_TILES_X
    bne _loop
    ldx #0
    iny
    cpy #NUM_TILES_Y
    bne _loop

    rts


TILE_SET_FLAGS .fill 256

; carry is clear if no valid moves are left
movesLeft
    ; clear TILE_SET_FLAGS
    lda #0
    sta memory.MEM_SET.valToSet
    #load16BitImmediate TILE_SET_FLAGS, memory.MEM_SET.startAddress
    #load16BitImmediate 256, memory.MEM_SET.length
    jsr memory.memSet
    ldy #0
_loop
    cpy FREE_LIST.len
    beq _done
    lda FREE_LIST.values, y
    tax
    lda #1
    ora TILE_SET_FLAGS, x
    sta TILE_SET_FLAGS, x
    iny
    bra _loop
_done
    lda #0
    ldy #0
    clc
_loop2
    adc TILE_SET_FLAGS, y
    iny
    cpy #NO_TILE
    bne _loop2
    cmp FREE_LIST.len
    beq _noMoves
    sec
    rts
_noMoves
    clc
    rts


CELL_ADDR  .word 0
setTileCall
    mul8x16BitCoproc TILE_PARAM.z, NUM_TILES_X * NUM_TILES_Y, LAYER_ADDR
    #mul8x8BitCoprocImm TILE_PARAM.y, NUM_TILES_X, CELL_ADDR
    #add16Bit CELL_ADDR, LAYER_ADDR
    #add16BitByte TILE_PARAM.x, LAYER_ADDR
    #add16Bit PLAYFIELD_VEC, LAYER_ADDR
    lda TILE_PARAM.tileNum
    sta (LAYER_ADDR)
    rts


getTileCall
    mul8x16BitCoproc TILE_PARAM.z, NUM_TILES_X * NUM_TILES_Y, LAYER_ADDR
    #mul8x8BitCoprocImm TILE_PARAM.y, NUM_TILES_X, CELL_ADDR
    #add16Bit CELL_ADDR, LAYER_ADDR
    #add16BitByte TILE_PARAM.x, LAYER_ADDR
    #add16Bit PLAYFIELD_VEC, LAYER_ADDR
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


isSpecial .macro start, end
    cmp #\start
    bcc _done
    cmp #\end+1
    bcc _ok
    clc
    bra _done
_ok
    sec
_done
    lda #0
    rol
.endmacro

isSeason
    #isSpecial 39, 42
    rts


isFlower
    #isSpecial 35, 38
    rts


TYPE_TEMP .byte 0
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
    
    ; check for seasons
    lda (LAYER_ADDR)
    jsr isSeason
    sta TYPE_TEMP
    lda (LAYER_ADDR_SELECTED)
    jsr isSeason
    and TYPE_TEMP
    bne _equal

    ; check for flowers
    lda (LAYER_ADDR)
    jsr isFlower
    sta TYPE_TEMP
    lda (LAYER_ADDR_SELECTED)
    jsr isFlower
    and TYPE_TEMP
    bne _equal
    clc
    rts
_equal
    sec
    rts


TILES_LEFT_TXT    .text "Tiles left:    "
TXT_YOU_WIN       .text "All tiles have been removed. You win!"
TXT_YOU_WIN_CLEAR .text "                                     "

printTilesLeft
    #locate 20, 30
    #printString TXT_YOU_WIN_CLEAR, len(TXT_YOU_WIN_CLEAR)
    #locate 60, 3
    #printString TILES_LEFT_TXT, len(TILES_LEFT_TXT)
    #locate 72, 3
    #move16Bit TILES_LEFT, txtio.WORD_TEMP
    jsr txtio.printWordDecimal
    #locate 32, 0
    #move16Bit DIFFICULTY_VEC, TXT_PTR3
    lda #len(DIFFICULTY_SOLVEABLE)
    jsr txtio.printStr
    lda TILES_LEFT
    bne _done
    #locate 20, 30
    #printString TXT_YOU_WIN, len(TXT_YOU_WIN)
    stz TIMER_STATE.doDisplay
_done
    rts


TXT_UNDO_MOVES .text "Moves to undo:   "
printUndoMoves
    #locate 60, 4
    #printString TXT_UNDO_MOVES, len(TXT_UNDO_MOVES)
    #locate 75, 4
    lda undo.UNDO_DATA.length
    sta txtio.WORD_TEMP
    stz txtio.WORD_TEMP + 1
    jsr txtio.printWordDecimal
    rts


TIME_STR .fill 8
CURRENT_TIME .dstruct TimeStamp_t
displayTime
    lda TIMER_STATE.doDisplay
    beq _done
    #getTimestamp CURRENT_TIME
    #diffTime TIMER_STATE.tsStart, CURRENT_TIME
    #getTimeStr TIME_STR, CURRENT_TIME
    #locate 32, 59
    #printString TIME_STR, 8
_done
    rts



performUndo
    jsr undo.popState
    bcs _doNothing
    clc
    lda #2
    adc TILES_LEFT
    sta TILES_LEFT
    jsr playfield.startRedraw
    lda #1
    sta TIMER_STATE.doDisplay
_doNothing
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

    #move16Bit PLAYFIELD_VEC, PFIELD_PTR
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
    jsr checkPossibleMove
    jsr printUndoMoves
    rts


TXT_NO_MOVES_LEFT .text "No moves left"
TXT_MOVES_LEFT    .text "             "

checkPossibleMove
    jsr getAllFreeTiles
    #locate 60, 5
    jsr movesLeft
    bcc _noMoves
    printString TXT_MOVES_LEFT, len(TXT_MOVES_LEFT)
    bra _end
_noMoves
    printString TXT_NO_MOVES_LEFT, len(TXT_NO_MOVES_LEFT)
    stz TIMER_STATE.doDisplay
_end
    rts



drawAll
    jsr hires.switchLayer
    jsr hires.clearBitmap

    #move16Bit PLAYFIELD_VEC, PFIELD_PTR
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

.include "fill_playfield.asm"

.endnamespace