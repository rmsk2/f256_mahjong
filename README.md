# f256_mahjong

## The rules

In this game the user is presented with a stack of 144 tiles. A pair of equal or compatible tiles can be removed
from the stack. The game is won, if all tiles have been removed from the playing field. 

A pair of tiles can be removed by clicking on the first tile and then on the second tile using a mouse. This is only 
possible if both of the tiles which have been selected are "free" in the sense that they have no neighbour to the left
or the right and no tile on top of them. Additionally the tiles have to either show the same icon or be both of a 
compatible type. There are two sets of compatible tiles

1. The seasons, shown as two blossoms, a brown leaf and a snow flake  (the four tiles on the right in the title screen)
2. The flowers, shown as four flowers with stems (the four tiles on left in the title screen)

When a tile is selected its upper left corner is painted in pink. As only free tiles can be selected you can use
this feature to test whether a given tile is free or not. If you click again on a selected tile the pink mark is
removed again. 

## Using the software

When playing the game you can return to BASIC at any time by pressing the RUN/STOP key (on your F256 K's keyboard) or 
alternatively `Ctrl+c` on any Foenix 8 bit machine. When you press any key but F1, F3 and F5 a new random start configuration
is created. As a default this start configuration is constructed in such a way that it is guaranteed to be solvable. 
This in  turn does not mean that you are guaranteed to solve the deck because it is not only possible but in fact likely that
you will not recreate the exact steps which were taken during construction of the deck. I estimate that the probability for 
successfully clearing the playing field is about 20%.

Alternatively the start configuration can be chosen at random, which tends to make the game (much) more difficult and offers
no guarantee that the deck is solveable. The strategy used, i.e. `RANDOM` or `SOLVEABLE` is displayed in the first line of the screen. 
Pressing F3 changes the  strategy to `RANDOM` and pressing F5 changes it back to `SOLVEABLE`. Additionally previous moves can be undone by 
pressing F1. The time spent playing using the current deck is shown on the bottom of the screen.

# Building the software

In order to build the software you need 64tass, a Python interpreter and GNU make. If you want to create a
KUP to store in your flash cartridge you will also need [pgz2flash](https://github.com/rmsk2/pgz2flash). Simply 
execute `make` to create a `.pgz` executbable which can be transferred to your Foenix and run from there. Alternatively
you can call `make upload` to build the program and upload the resulting binary via `FoenixMgr`. Use `make cartridge` 
to create a KUP which can be stored in and run from cartridge flash.

A prebuilt executable (`shanghai.pgz`) and a prebuilt cartridge image (`shanghai.bin`) can be found in the
[`Releases`](https://github.com/rmsk2/f256_mahjong/releases) section of this repo. Use [`fcart`](https://github.com/rmsk2/cartflash)
to write the image to your flash cartridge.