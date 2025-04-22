select .namespace


doSelect
    jsr drawMousePos

    jsr eventLoop
    
    jsr hires.off
    jsr mouseOff
    sec
    rts


eventLoop
    ; Peek at the queue to see if anything is pending
    lda kernel.args.events.pending ; Negated count
    bpl eventLoop
    ; Get the next event.
    jsr kernel.NextEvent
    bcs eventLoop
    ; Handle the event
    lda myEvent.type    
    cmp #kernel.event.key.PRESSED
    bne _checkMouseEvent
    jsr procKeyPressed
    bcc eventLoop
    rts
_checkMouseEvent
    cmp #kernel.event.mouse.DELTA
    bne _nextEventCheck    
    jsr procMouseEvent
    bra eventLoop
_nextEventCheck
    bra eventLoop


mouseInit
    lda THRESHOLD_MOVE_X
    sta BRAKE.xplus
    sta BRAKE.xminus
    lda THRESHOLD_MOVE_Y    
    sta BRAKE.yplus
    sta BRAKE.yminus
    #load16BitImmediate 0, MOUSE_POS.x
    #load16BitImmediate 0, MOUSE_POS.y
    #load16BitImmediate 0, CLICK_POS.x
    #load16BitImmediate 0, CLICK_POS.y
    stz BUTTON_STATE
    rts


mouseOn
    #saveIo
    #setIo 0
    ; Mouse pointer on
    lda #1
    sta $D6E0

    ; Set position to 0,0
    stz $D6E2
    stz $D6E3
    stz $D6E4
    stz $D6E5
    #restoreIo
    rts


mouseOff
    #saveIo
    #setIo 0
    lda #0
    sta $D6E0
    #restoreIo
    rts


procKeyPressed
    sec
    rts


procMouseEvent
    #saveIo
    #setIo 0
    jsr mouseClick
    jsr mouseLeftRight
    jsr mouseUpDown
    #restoreIo
    jsr drawMousePos
    rts


POS_CLR .text "   "
drawMousePos
    #move16Bit MOUSE_POS.x, txtio.WORD_TEMP
    #locate 72, 6
    #printString POS_CLR, len(POS_CLR)
    #locate 72, 6
    jsr txtio.printWordDecimal

    #move16Bit MOUSE_POS.y, txtio.WORD_TEMP
    #locate 72, 7
    #printString POS_CLR, len(POS_CLR)
    #locate 72, 7
    jsr txtio.printWordDecimal
    
    #locate 72, 8
    lda BUTTON_STATE
    beq _notClciked
    lda #214
    bra _printButtonState
_notClciked
    lda #' '
_printButtonState
    jsr txtio.charOut
_done
    rts


X_MAX = 639
Y_MAX = 479

DIR_LEFT = 0
DIR_RIGHT = 1
DIR_UP = 0
DIR_DOWN = 1

SPEED_SLOW = 0
SPEED_MEDIUM = 1
SPEED_FAST = 2

LEFT_BUTTON = 1
RIGHT_BUTTON = 2

BUTTON_IS_PRESSED = 1
BUTTON_IS_NOT_PRESSED = 0

DIRECTION      .byte 0                                    ; determined direction of delta sent by mouse
SIGN           .byte 0                                    ; raw sign of delta sent by the mouse (1 = negative, 0 = positive)
SPEED          .byte 0                                    ; determined speed (slow, medium or fast)
OFFSET         .byte 0, 0                                 ; calculated number of pixels to move the mouse pointer
PRIMARY_BUTTON .byte LEFT_BUTTON                          ; select left or right handedness 
BUTTON_STATE   .byte 0                                    ; state of the primary button


THRESHOLD_MOVE_X .byte 2                                  ; You need THRESHOLD_MOVE_X kernel messages in x direction to move the pointer at all when in slow mode
THRESHOLD_MEDIUM_X .byte 5                                ; Absolute delta in X direction that signifies a medium speed
THRESHOLD_FAST_X .byte 11                                 ; Absolute delta in X direction that signifies a fast speed

OFFSET_SLOW_X .byte 2                                     ; pixels to move in x direction when speed is slow
OFFSET_MEDIUM_X .byte 6                                   ; pixels to move in x direction when speed is medium
OFFSET_FAST_X .byte 14                                    ; pixels to move in x direction when speed is fast

THRESHOLD_MOVE_Y .byte 2                                  ; You need THRESHOLD_MOVE_Y kernel messages in Y direction to move the pointer at all when in slow mode
THRESHOLD_MEDIUM_Y .byte 5                                ; Absolute delta in Y direction which is considered to be medium speed
THRESHOLD_FAST_Y .byte 11                                 ; Absolute delta in Y direction which is considered to be fast speed

OFFSET_SLOW_Y .byte 2                                     ; pixels to move in y direction when speed is slow
OFFSET_MEDIUM_Y .byte 6                                   ; pixels to move in x direction when speed is medium
OFFSET_FAST_Y .byte 14                                    ; pixels to move in y direction when speed is fast

ClickPos_t .struct 
    x .word 0
    y .word 0
.endstruct

CLICK_POS .dstruct ClickPos_t
MOUSE_POS .dstruct ClickPos_t

Brake_t .struct 
    xplus .byte 0
    yplus .byte 0
    xminus .byte 0
    yminus .byte 0
.endstruct

BRAKE .dstruct Brake_t


calcDirection .macro dirPlus, dirMinus, deltaAddr
    stz SIGN
    ; determine direction using the sign of the offset and
    ; calculate the absolute value of the delta sent by the
    ; mouse.
    lda \deltaAddr
    bmi _minus
    lda #\dirPlus
    sta DIRECTION
    lda \deltaAddr
    bra _speedCheck
_minus
    inc SIGN
    lda #\dirMinus
    sta DIRECTION
    ; reverse two's complement
    lda \deltaAddr
    eor #$FF
    clc
    adc #1
_speedCheck
.endmacro


calcSpeed .macro thresholdMediumAddr, thresholdFastAddr
    ; determine whether speed is slow, medium or fast
    cmp \thresholdFastAddr
    bcs _speedFast
    cmp \thresholdMediumAddr
    bcs _speedMedium
    bra _speedSlow
_speedFast
    lda #SPEED_FAST
    sta SPEED
    bra _finished
_speedMedium
    lda #SPEED_MEDIUM
    sta SPEED
    bra _finished
_speedSlow
    lda #SPEED_SLOW
    sta SPEED
_finished
.endmacro


calcOffset .macro offsetSlowAddr, offsetMediumAddr, offsetFastAddr, brakePlusAddr, brakeMinusAddr, moveThreshold
    ; determine how many pixels the mouse pointer is to be moved
    lda SPEED
    cmp #SPEED_SLOW
    beq _slow
    cmp #SPEED_MEDIUM
    bne _fast
_medium
    lda \offsetMediumAddr
    sta OFFSET
    bra _offsetDone
_fast
    lda \offsetFastAddr
    sta OFFSET
    bra _offsetDone
_slow
    ; In slow mode we have to receive \moveThreshold messages pointing in same direction before
    ; we begin to move the mouse. This is essential for control and accuracy.
    stz OFFSET
    lda SIGN
    bne _signMinus
_signPlus
    lda \moveThreshold
    sta \brakeMinusAddr
    dec \brakePlusAddr
    bne _offsetDone
    lda \moveThreshold
    sta \brakePlusAddr
    bra _setOffset
_signMinus
    lda \moveThreshold
    sta \brakePlusAddr
    dec \brakeMinusAddr
    bne _offsetDone
    lda \moveThreshold
    sta \brakeMinusAddr
_setOffset
    lda \offsetSlowAddr
    sta OFFSET
_offsetDone
.endmacro


evalMouseOffset .macro dirPlus, dirMinus, deltaAddr, theresholdMediumAddr, theresholdFastAddr, offsetSlowAddr, offsetMediumAddr, offsetFastAddr, brakePlusAddr, brakeMinusAddr, moveThreshold
    #calcDirection \dirPlus, \dirMinus, \deltaAddr
    #calcSpeed \theresholdMediumAddr, \theresholdFastAddr
    #calcOffset \offsetSlowAddr, \offsetMediumAddr, \offsetFastAddr, \brakePlusAddr, \brakeMinusAddr, \moveThreshold
.endmacro


POS_TEMP       .word 0


; move mouse pointer in x direction
mouseLeftRight
    lda myEvent.mouse.delta.x
    bne _doEval
    jmp _done
_doEval
    #evalMouseOffset DIR_RIGHT, DIR_LEFT, myEvent.mouse.delta.x, THRESHOLD_MEDIUM_X, THRESHOLD_FAST_X, OFFSET_SLOW_X, OFFSET_MEDIUM_X, OFFSET_FAST_X, BRAKE.xplus, BRAKE.xminus, THRESHOLD_MOVE_X
    lda DIRECTION
    cmp #DIR_RIGHT
    beq _right
_left
    #move16Bit $D6E2, POS_TEMP
    #sub16Bit OFFSET, POS_TEMP
    lda POS_TEMP+1
    bmi _setXPos0
    #move16Bit POS_TEMP, $D6E2
    bra _done
_setXPos0
    #load16BitImmediate 0, $D6E2
    bra _done
_right
    #move16Bit $D6E2, POS_TEMP
    #add16Bit OFFSET, POS_TEMP
    #cmp16BitImmediate X_MAX, POS_TEMP
    bcc _setXPosMax
    #move16Bit POS_TEMP, $D6E2
    bra _done
_setXPosMax
    #load16BitImmediate X_MAX, $D6E2
_done
    #move16Bit $D6E2, MOUSE_POS.x
    #halve16Bit MOUSE_POS.x
    rts


; move mouse pointer in y direction
mouseUpDown 
    lda myEvent.mouse.delta.y
    bne _doEval
    jmp _done
_doEval
    #evalMouseOffset DIR_DOWN, DIR_UP, myEvent.mouse.delta.y, THRESHOLD_MEDIUM_Y, THRESHOLD_FAST_Y, OFFSET_SLOW_Y, OFFSET_MEDIUM_Y, OFFSET_FAST_Y, BRAKE.yplus, BRAKE.yminus,THRESHOLD_MOVE_Y
    lda DIRECTION
    cmp #DIR_DOWN
    beq _down
_left
    #move16Bit $D6E4, POS_TEMP
    #sub16Bit OFFSET, POS_TEMP
    lda POS_TEMP+1
    bmi _setYPos0
    #move16Bit POS_TEMP, $D6E4
    bra _done
_setYPos0
    #load16BitImmediate 0, $D6E4
    bra _done
_down
    #move16Bit $D6E4, POS_TEMP
    #add16Bit OFFSET, POS_TEMP
    #cmp16BitImmediate Y_MAX, POS_TEMP
    bcc _setYPosMax
    #move16Bit POS_TEMP, $D6E4
    bra _done
_setYPosMax
    #load16BitImmediate Y_MAX, $D6E4
_done
    #move16Bit $D6E4, MOUSE_POS.y
    #halve16Bit MOUSE_POS.y
    rts


; record mouse clicks made with the primary button. Return with carry
; set if mouse was clicked. Else carry is clear.
mouseClick
    lda myEvent.mouse.delta.buttons
    and PRIMARY_BUTTON
    beq _notPressed
    lda #BUTTON_IS_PRESSED
    sta BUTTON_STATE

    #move16Bit $D6E2, CLICK_POS.x
    #halve16Bit CLICK_POS.x

    #move16Bit $D6E4, CLICK_POS.y
    #halve16Bit CLICK_POS.y

    sec
    bra _done
_notPressed
    lda #BUTTON_IS_NOT_PRESSED
    sta BUTTON_STATE
    clc
_done
    rts

.endnamespace