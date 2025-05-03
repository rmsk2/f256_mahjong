dummy .namespace 

setTile .macro n, x, y, z
    lda #\n
    sta playfield.TILE_PARAM.tileNum
    lda #\x
    sta playfield.TILE_PARAM.x
    lda #\y
    sta playfield.TILE_PARAM.y
    lda #\z
    sta playfield.TILE_PARAM.z
    jsr playfield.setTileCall
.endmacro

getDummy
    #setTile 35, 0,0,0
    #setTile 36, 1,0,0
    #setTile 39, 0,1,0
    #setTile 42, 1,1,0
    #setTile 2, 0,2,0
    #setTile 3, 1,2,0
    #setTile 4, 0,3,0
    #setTile 4, 1,3,0

    rts

.endnamespace