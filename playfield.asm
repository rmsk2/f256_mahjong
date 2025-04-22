TC0 = 7
TC2 = 9
TC3 = 10


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



playfield .namespace

blitTile .macro src, x, y 
    #load24BitImmediate \src, memory.SRC_ADDRESS
    jsr memory.linearToSourceAddress

    #load16BitImmediate \x, memory.X_POS
    lda #\y
    sta memory.Y_POS
    jsr memory.pixelPosToTargetAddress
    
    jsr memory.blit
.endmacro

test
    #load16BitImmediate 320, memory.BLIT_PARMS.lineSize
    lda #20
    sta memory.BLIT_PARMS.objSize
    lda #24
    sta memory.BLIT_PARMS.numLines
    #load16BitImmediate memory.overwriteWithTransparency, memory.BLIT_VECTOR

    #blitTile EMPTY_FRAME, 24, 12

    #blitTile EMPTY_FRAME, 44, 12
    #blitTile EMPTY_FRAME, 41, 9
    #blitTile EMPTY_FRAME, 38, 6
    #blitTile EMPTY_FRAME, 35, 3
    #blitTile EMPTY_FRAME, 32, 0

    #blitTile EMPTY_FRAME, 64, 12
    #blitTile EMPTY_FRAME, 61, 9
    
    #blitTile EMPTY_FRAME, 84, 12
    #blitTile EMPTY_FRAME, 104, 12
    #blitTile EMPTY_FRAME, 124, 12
    #blitTile EMPTY_FRAME, 144, 12
    #blitTile EMPTY_FRAME, 164, 12
    #blitTile EMPTY_FRAME, 184, 12
    #blitTile EMPTY_FRAME, 204, 12
    #blitTile EMPTY_FRAME, 224, 12
    #blitTile EMPTY_FRAME, 244, 12
    #blitTile EMPTY_FRAME, 264, 12

    #blitTile EMPTY_FRAME, 64, 36

    #blitTile EMPTY_FRAME, 44, 36
    #blitTile EMPTY_FRAME, 44, 60
    #blitTile EMPTY_FRAME, 44, 84

    #blitTile EMPTY_FRAME, 44, 108
    #blitTile EMPTY_FRAME, 44, 132
    #blitTile EMPTY_FRAME, 44, 156
    #blitTile EMPTY_FRAME, 44, 180
    #blitTile EMPTY_FRAME, 44, 204

    #blitTile EMPTY_FRAME, 61, 33

    #blitTile EMPTY_FRAME, 84, 36
    #blitTile EMPTY_FRAME, 81, 33
    #blitTile EMPTY_FRAME, 78, 30
    ;#blitTile EMPTY_FRAME, 63, 27



    rts

.endnamespace