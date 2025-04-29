solvablegen .namespace

PLAYFIELD_GEN  .fill PLAYFIELD_SIZE


UNSHUFFLED_DATA
.byte GROUP_SEASONS, GROUP_SEASONS
.byte GROUP_FLOWERS, GROUP_FLOWERS
.byte 0, 1, 2, 3, 4, 5, 6, 7, 8
.byte 0, 1, 2, 3, 4, 5, 6, 7, 8
.byte 9, 10, 11, 12, 13, 14, 15, 16, 17
.byte 9, 10, 11, 12, 13, 14, 15, 16, 17
.byte 18, 19, 20, 21, 22, 23, 24, 25, 26
.byte 18, 19, 20, 21, 22, 23, 24, 25, 26
.byte 27, 28, 29
.byte 27, 28, 29
.byte 31, 32, 33, 34
.byte 31, 32, 33, 34

LEN_TILE_DATA = 72
SHUFFLED_DATA .fill LEN_TILE_DATA


FREE_TILE_INDEX .byte 0
; accu contains tile num. X register index in free list
setAndDeleteGeneratedTile
    sta playfield.TILE_PARAM.tileNum
    stx FREE_TILE_INDEX
    lda FREE_TILE_INDEX
    asl
    tax
    lda playfield.FREE_LIST.data, x
    and #$0F
    sta playfield.TILE_PARAM.x
    lda playfield.FREE_LIST.data, x
    lsr
    lsr
    lsr
    lsr
    sta playfield.TILE_PARAM.y
    inx
    lda playfield.FREE_LIST.data, x
    sta playfield.TILE_PARAM.z

    ; set value in real playing field
    #load16BitImmediate playfield.PLAYFIELD_MAIN, playfield.PLAYFIELD_VEC
    jsr playfield.setTileCall
    ; delete tile in twin
    #load16BitImmediate PLAYFIELD_GEN, playfield.PLAYFIELD_VEC
    lda #NO_TILE
    sta playfield.TILE_PARAM.tileNum
    jsr playfield.setTileCall

    rts


PAIR_TEMP .byte 0
; accu contains tile number from SHUFFLED_DATA
genNewPair
    sta PAIR_TEMP
    cmp #GROUP_FLOWERS
    bne _checkSeason
    ldy FLOWER_PTR
    lda FLOWERS, y
    sta PAIR_VAL_1
    iny
    lda FLOWERS, y
    sta PAIR_VAL_2
    iny
    sty FLOWER_PTR
    rts
_checkSeason
    lda PAIR_TEMP
    cmp #GROUP_SEASONS
    bne _notSpecial
    ldy SEASON_PTR
    lda SEASONS, y
    sta PAIR_VAL_1
    iny
    lda SEASONS, y
    sta PAIR_VAL_2
    iny
    sty SEASON_PTR
    rts
_notSpecial
    lda PAIR_TEMP
    sta PAIR_VAL_1
    sta PAIR_VAL_2
    rts


FLOWER_PTR .byte 0
FLOWERS
    .byte 35, 36, 37, 38

SEASON_PTR .byte 0
SEASONS
    .byte 39, 40, 41, 42

CURRENT_PAIR .byte 0
FIRST  .byte 0
SECOND .byte 0
PAIR_VAL_1 .byte 0
PAIR_VAL_2 .byte 0

generate
    ; initialize tiles to place on playfield
    #initTileData UNSHUFFLED_DATA, SHUFFLED_DATA, LEN_TILE_DATA
    ; shuffle input pairs
    #load16BitImmediate 4000, playfield.RAND_MAX
    lda #LEN_TILE_DATA
    sta playfield.RANGE_MAX
    #load16BitImmediate SHUFFLED_DATA, playfield.DATA_ADDR
    jsr playfield.shuffle
_tryAgain
    ; clear twin
    #load16BitImmediate PLAYFIELD_GEN, playfield.PLAYFIELD_VEC    
    jsr playfield.clearPlayfield
    ; clear real playing field
    #load16BitImmediate playfield.PLAYFIELD_MAIN, playfield.PLAYFIELD_VEC
    jsr playfield.clearPlayfield
    ; initialize stuff
    stz CURRENT_PAIR
    stz FLOWER_PTR
    stz SEASON_PTR
    ; fill twin with all generic tiles
    jsr createTwin
_loop
    ; we have 144 / 2 pairs to distribute
    lda CURRENT_PAIR
    cmp #LEN_TILE_DATA
    beq _done
    ; switch to twin
    #load16BitImmediate PLAYFIELD_GEN, playfield.PLAYFIELD_VEC
    jsr playfield.getAllFreeTiles

    lda playfield.FREE_LIST.len
    cmp #2
    bne _doRand
    lda #0
    sta FIRST
    ina
    sta SECOND
    bra _setTiles
_doRand
    ; determine two random and different free tiles
    lda playfield.FREE_LIST.len
    ; If we end up with two tiles on top of each other restart calculation
    cmp #1
    beq _tryAgain
    jsr random.getRange
    sta FIRST
    lda playfield.FREE_LIST.len
    jsr random.getRange
    ; check for equality
    sta SECOND
    cmp FIRST
    beq _doRand

_setTiles
    ; here we have two random and different entries
    ldx CURRENT_PAIR
    lda SHUFFLED_DATA, x
    jsr genNewPair
    lda PAIR_VAL_1
    ldx FIRST
    jsr setAndDeleteGeneratedTile
    lda PAIR_VAL_2
    ldx SECOND
    jsr setAndDeleteGeneratedTile
    inc CURRENT_PAIR
    bra _loop
_done
    #load16BitImmediate playfield.PLAYFIELD_MAIN, playfield.PLAYFIELD_VEC
    rts


createTwin
    #load16BitImmediate PLAYFIELD_GEN, playfield.PLAYFIELD_VEC

    lda #GROUP_GENERIC
    sta memory.MEM_SET.valToSet
    #load16BitImmediate playfield.SHUFFLED_TILES, memory.MEM_SET.startAddress
    #load16BitImmediate 144, memory.MEM_SET.length
    jsr memory.memSet

    jsr playfield.fillPlayfieldNoShuffle

    #load16BitImmediate playfield.PLAYFIELD_MAIN, playfield.PLAYFIELD_VEC
    rts    

.endnamespace