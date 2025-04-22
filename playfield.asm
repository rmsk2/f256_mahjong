TC0 = 7
TC2 = 9
TC3 = 10
TC4 = 11


RAW_TILE = 1
EMPTY_FRAME
    .byte 0, TC0, TC0, TC0, TC0, TC0, TC0, TC0, TC0, TC0, TC0, TC0, TC0, TC0, TC0, 0
    .byte TC0, TC0, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC2, TC2, TC0, TC0
    .byte TC0, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC2, TC2, TC0
    .byte TC0, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC2, TC2, TC0
    .byte TC0, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC2, TC2, TC0
    .byte TC0, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC2, TC2, TC0
    .byte TC0, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC2, TC2, TC0
    .byte TC0, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC2, TC2, TC0
    .byte TC0, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC2, TC2, TC0
    .byte TC0, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC2, TC2, TC0
    .byte TC0, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC2, TC2, TC0
    .byte TC0, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC2, TC2, TC0
    .byte TC0, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC2, TC2, TC0
    .byte TC0, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC2, TC2, TC0
    .byte TC0, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC2, TC2, TC0
    .byte TC0, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC2, TC2, TC0
    .byte TC0, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC2, TC2, TC0
    .byte TC0, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC2, TC2, TC0
    .byte TC0, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC2, TC2, TC0
    .byte TC0, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC2, TC2, TC0
    .byte TC0, TC2, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC4, TC3, TC2, TC2, TC0
    .byte TC0, TC2, TC2, TC2, TC2, TC2, TC2, TC2, TC2, TC2, TC2, TC2, TC2, TC3, TC2, TC0
    .byte TC0, TC0, TC2, TC2, TC2, TC2, TC2, TC2, TC2, TC2, TC2, TC2, TC2, TC2, TC0, TC0
    .byte 0, TC0, TC0, TC0, TC0, TC0, TC0, TC0, TC0, TC0, TC0, TC0, TC0, TC0, TC0, 0




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
    lda #16
    sta memory.BLIT_PARMS.objSize
    lda #24
    sta memory.BLIT_PARMS.numLines
    #load16BitImmediate memory.overwriteWithTransparency, memory.BLIT_VECTOR

    #blitTile EMPTY_FRAME, 24, 12
    ; #blitTile EMPTY_FRAME, 21, 9
    ; #blitTile EMPTY_FRAME, 18, 6
    ; #blitTile EMPTY_FRAME, 15, 3
    ; #blitTile EMPTY_FRAME, 12, 0
    #blitTile EMPTY_FRAME, 40, 12
    #blitTile EMPTY_FRAME, 37, 9
    #blitTile EMPTY_FRAME, 34, 6
    #blitTile EMPTY_FRAME, 31, 3
    #blitTile EMPTY_FRAME, 28, 0
    #blitTile EMPTY_FRAME, 56, 12
    #blitTile EMPTY_FRAME, 53, 9
    #blitTile EMPTY_FRAME, 72, 12
    #blitTile EMPTY_FRAME, 88, 12
    #blitTile EMPTY_FRAME, 104, 12
    #blitTile EMPTY_FRAME, 120, 12
    #blitTile EMPTY_FRAME, 136, 12
    #blitTile EMPTY_FRAME, 152, 12
    #blitTile EMPTY_FRAME, 168, 12
    #blitTile EMPTY_FRAME, 184, 12
    #blitTile EMPTY_FRAME, 200, 12
    #blitTile EMPTY_FRAME, 216, 12

    #blitTile EMPTY_FRAME, 40, 36
    #blitTile EMPTY_FRAME, 40, 60
    #blitTile EMPTY_FRAME, 40, 84

    #blitTile EMPTY_FRAME, 40, 108
    #blitTile EMPTY_FRAME, 40, 132
    #blitTile EMPTY_FRAME, 40, 156
    #blitTile EMPTY_FRAME, 40, 180
    #blitTile EMPTY_FRAME, 40, 204

    #blitTile EMPTY_FRAME, 72, 36
    #blitTile EMPTY_FRAME, 69, 33
    #blitTile EMPTY_FRAME, 66, 30
    #blitTile EMPTY_FRAME, 63, 27

    rts

.endnamespace