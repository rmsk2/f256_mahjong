import sys
import os

start_address = 0x0300

def make_24bit_address(addr):
    help, lo = divmod(addr, 256)
    higher, hi = divmod(help, 256)
    return (lo, hi, higher)

l, h, hh = make_24bit_address(os.path.getsize(sys.argv[1]))
sl, sh, shh = make_24bit_address(start_address)

pgz_header = bytes([90, sl, sh, shh, l, h, hh])
pgz_footer = bytes([sl, sh, shh, 0, 0, 0])

with open(sys.argv[1], "rb") as f:
    data = f.read()

with open(sys.argv[2], "rb") as f:
    tiles = f.read()

tile_address = 0x10000
tile_addr_lo, tile_addr_mid, tile_addr_hi = make_24bit_address(tile_address)
tile_len_lo, tile_len_mid, tile_len_hi = make_24bit_address(len(tiles))
pgz_tiles_header = bytes([tile_addr_lo, tile_addr_mid, tile_addr_hi, tile_len_lo, tile_len_mid, tile_len_hi])

with open(sys.argv[1]+".pgz", "wb") as f:
    f.write(pgz_header)
    f.write(data)
    f.write(pgz_tiles_header)
    f.write(tiles)
    f.write(pgz_footer)


