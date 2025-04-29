# f256_mahjong

## The rules

In this game the user is presented with a stack of 144 tiles. A pair of equal or compatible tiles can be removed
from the stack. The game is won, if all tiles have been removed from the playing field. 

A pair of tiles can be removed by using a mouse to click on the first tile and then on the second tile. This is only 
possible if both of tiles which have been selected are "free" in the sense that they have no neighbour to the left or 
the right and no tile on top of them. Additionally the tiles have to either show the same icon or be both of a 
compatible type. There are two sets of compatible tiles

1. The seasons, shown as two blossoms, a brown leaf and a snow flake
2. The flowers, shown as four flowers with stems

When a tile is selected its upper left corner is painted in pink. As only free tiles can be selected you use this
feature to test whether a given tile is free or not. If you click again on a selected tile the pink mark is removed
again. 

## Using the software

When playing the game you can return to BASIC at any time by pressing the RUN/STOP key (on your F256 K's keyboard) or 
alternatively `Ctrl+c` on any Foenix 8 bit machine. When you press any other key a new random start configuration
is created. This start configuration is constructed in such a way that it is guaranteed to be solvable. This in 
turn does not mean that the player will actually follow the exact steps to clear the playing field. I estimate
that the probability for successfully clearing the playing field is between 10% and 20%.  

# Building the software

In order to build the software you need 64tass, a Python interpreter and GNU make. Simply execute `make`
to create a `.pgz` executbable which can be transferred to your Foenix and run from there. Alternatively
you can call `make upload` to build the program and upload the resulting binary via `FoenixMgr`. You can
use [pgz2flash](https://github.com/rmsk2/pgz2flash) to create a KUP which can be stored in and run from
onboard or cartridge flash. 

