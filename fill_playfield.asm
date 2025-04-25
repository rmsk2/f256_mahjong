setTile .macro n, x, y, z
    ldx #\n
    lda SHUFFLED_TILES, x
    sta TILE_PARAM.tileNum
    lda #\x
    sta TILE_PARAM.x
    lda #\y
    sta TILE_PARAM.y
    lda #\z
    sta TILE_PARAM.z
    jsr setTileCall
.endmacro

UNSHUFFLED_TILES 
.byte 35, 36, 37, 38
.byte 39, 40, 41, 42
.byte 0, 1, 2, 3, 4, 5, 6, 7, 8
.byte 0, 1, 2, 3, 4, 5, 6, 7, 8
.byte 0, 1, 2, 3, 4, 5, 6, 7, 8
.byte 0, 1, 2, 3, 4, 5, 6, 7, 8
.byte 9, 10, 11, 12, 13, 14, 15, 16, 17
.byte 9, 10, 11, 12, 13, 14, 15, 16, 17
.byte 9, 10, 11, 12, 13, 14, 15, 16, 17
.byte 9, 10, 11, 12, 13, 14, 15, 16, 17
.byte 18, 19, 20, 21, 22, 23, 24, 25, 26
.byte 18, 19, 20, 21, 22, 23, 24, 25, 26
.byte 18, 19, 20, 21, 22, 23, 24, 25, 26
.byte 18, 19, 20, 21, 22, 23, 24, 25, 26
.byte 27, 28, 29
.byte 27, 28, 29
.byte 27, 28, 29
.byte 27, 28, 29
.byte 31, 32, 33, 34
.byte 31, 32, 33, 34
.byte 31, 32, 33, 34
.byte 31, 32, 33, 34

SHUFFLED_TILES .fill 144


initialFill
    ldx #0
_loop
    lda UNSHUFFLED_TILES,x
    sta SHUFFLED_TILES, x
    inx
    cpx #144
    bne _loop
    rts

RAND_COUNT .word 0
RAND_SRC .byte 0
RAND_TARGET .byte 0
shuffle
    #load16BitImmediate 0, RAND_COUNT
    #load16BitImmediate 144, $DE04
    stz $DE07    
_loop
    jsr random.get
    stx $DE06
    ldx $DE16
    stx RAND_SRC
    sta $DE06
    lda $DE16
    sta RAND_SRC
    ldx RAND_SRC
    lda SHUFFLED_TILES, x
    tay
    ldx RAND_TARGET
    lda SHUFFLED_TILES, x
    ldx RAND_SRC
    sta SHUFFLED_TILES, x
    ldx RAND_TARGET
    tya
    sta SHUFFLED_TILES, x

    #inc16Bit RAND_COUNT
    #cmp16BitImmediate 8000, RAND_COUNT
    bne _loop
    rts


fillPlayfield
    jsr initialFill
    jsr shuffle
    ; upper wall
    #setTile 0, 3, 2, 0
    #setTile 1, 4, 2, 0
    #setTile 2, 5, 2, 0
    #setTile 3, 6, 2, 0
    #setTile 4, 7, 2, 0
    #setTile 5, 8, 2, 0
    #setTile 6, 9, 2, 0
    #setTile 7, 3, 2, 1
    #setTile 8, 4, 2, 1
    #setTile 9, 5, 2, 1
    #setTile 10, 6, 2, 1
    #setTile 11, 7, 2, 1
    #setTile 12, 8, 2, 1
    #setTile 13, 9, 2, 1
    #setTile 14, 3, 2, 2
    #setTile 15, 4, 2, 2
    #setTile 16, 5, 2, 2
    #setTile 17, 6, 2, 2
    #setTile 18, 7, 2, 2
    #setTile 19, 8, 2, 2
    #setTile 20, 9, 2, 2
    #setTile 21, 3, 2, 3
    #setTile 22, 4, 2, 3
    #setTile 23, 5, 2, 3
    #setTile 24, 6, 2, 3
    #setTile 25, 7, 2, 3
    #setTile 26, 8, 2, 3
    #setTile 27, 9, 2, 3
    #setTile 28, 3, 2, 4
    #setTile 29, 4, 2, 4
    #setTile 30, 5, 2, 4
    #setTile 31, 6, 2, 4
    #setTile 32, 7, 2, 4
    #setTile 33, 8, 2, 4
    #setTile 34, 9, 2, 4
    ; lower wall
    #setTile 35, 3, 6, 0
    #setTile 36, 4, 6, 0
    #setTile 37, 5, 6, 0
    #setTile 38, 6, 6, 0
    #setTile 39, 7, 6, 0
    #setTile 40, 8, 6, 0
    #setTile 41, 9, 6, 0
    #setTile 42, 3, 6, 1
    #setTile 43, 4, 6, 1
    #setTile 44, 5, 6, 1
    #setTile 45, 6, 6, 1
    #setTile 46, 7, 6, 1
    #setTile 47, 8, 6, 1
    #setTile 48, 9, 6, 1
    #setTile 49, 3, 6, 2
    #setTile 50, 4, 6, 2
    #setTile 51, 5, 6, 2
    #setTile 52, 6, 6, 2
    #setTile 53, 7, 6, 2
    #setTile 54, 8, 6, 2
    #setTile 55, 9, 6, 2
    #setTile 56, 3, 6, 3
    #setTile 57, 4, 6, 3
    #setTile 58, 5, 6, 3
    #setTile 59, 6, 6, 3
    #setTile 60, 7, 6, 3
    #setTile 61, 8, 6, 3
    #setTile 62, 9, 6, 3
    #setTile 63, 3, 6, 4
    #setTile 64, 4, 6, 4
    #setTile 65, 5, 6, 4
    #setTile 66, 6, 6, 4
    #setTile 67, 7, 6, 4
    #setTile 68, 8, 6, 4
    #setTile 69, 9, 6, 4
    ; left wall
    #setTile 70, 3, 3, 0
    #setTile 71, 3, 4, 0
    #setTile 72, 3, 5, 0
    #setTile 73, 3, 3, 1
    #setTile 74, 3, 4, 1
    #setTile 75, 3, 5, 1
    #setTile 76, 3, 3, 2
    #setTile 77, 3, 4, 2
    #setTile 78, 3, 5, 2
    #setTile 79, 3, 3, 3
    #setTile 80, 3, 4, 3
    #setTile 81, 3, 5, 3
    #setTile 82, 3, 3, 4
    #setTile 83, 3, 4, 4
    #setTile 84, 3, 5, 4
    ; right wall
    #setTile 85, 9, 3, 0
    #setTile 86, 9, 4, 0
    #setTile 87, 9, 5, 0
    #setTile 88, 9, 3, 1
    #setTile 89, 9, 4, 1
    #setTile 90, 9, 5, 1
    #setTile 91, 9, 3, 2
    #setTile 92, 9, 4, 2
    #setTile 93, 9, 5, 2
    #setTile 94, 9, 3, 3
    #setTile 95, 9, 4, 3
    #setTile 96, 9, 5, 3
    #setTile 97, 9, 3, 4
    #setTile 98, 9, 4, 4
    #setTile 99, 9, 5, 4
    ; upper left vertical nose
    #setTile 100, 3, 0, 0
    #setTile 101, 3, 1, 0
    #setTile 102, 3, 0, 1
    #setTile 103, 3, 1, 1
    #setTile 104, 3, 1, 2
    ; upper right vertical nose
    #setTile 105, 9, 0, 0
    #setTile 106, 9, 1, 0
    #setTile 107, 9, 0, 1
    #setTile 108, 9, 1, 1
    #setTile 109, 9, 1, 2
    ; lower left vertical nose
    #setTile 110, 3, 7, 0
    #setTile 111, 3, 8, 0
    #setTile 112, 3, 7, 1
    #setTile 113, 3, 8, 1
    #setTile 114, 3, 7, 2
    ; lower right vertical nose
    #setTile 115, 9, 7, 0
    #setTile 116, 9, 8, 0
    #setTile 117, 9, 7, 1
    #setTile 118, 9, 8, 1
    #setTile 119, 9, 7, 2
    ; upper left horizontal nose
    #setTile 120, 0, 2, 0
    #setTile 121, 1, 2, 0
    #setTile 122, 2, 2, 0
    #setTile 123, 1, 2, 1
    #setTile 124, 2, 2, 1
    #setTile 125, 2, 2, 2
    ; lower left horizontal nose
    #setTile 126, 0, 6, 0
    #setTile 127, 1, 6, 0
    #setTile 128, 2, 6, 0
    #setTile 129, 1, 6, 1
    #setTile 130, 2, 6, 1
    #setTile 131, 2, 6, 2
    ; upper right horizontal nose
    #setTile 132, 10, 2, 0
    #setTile 133, 10, 2, 1
    #setTile 134, 10, 2, 2
    #setTile 135, 11, 2, 0
    #setTile 136, 11, 2, 1
    #setTile 137, 12, 2, 0
    ; lower right horizontal nose
    #setTile 138, 10, 6, 0
    #setTile 139, 10, 6, 1
    #setTile 140, 10, 6, 2
    #setTile 141, 11, 6, 0
    #setTile 142, 11, 6, 1
    #setTile 143, 12, 6, 0
    rts