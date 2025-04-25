import sys

SIZES = [8, 16, 24, 32]

def parse_spr(data):
    res = {}
    num_sprites = data[0]
    index = data[1:1+2048]
    for i in range(num_sprites):
        lo, mid, hi = index[:3]
        index = index[3:]
        size = SIZES[lo & 3]
        data_addr = (lo &0xF0)
        data_addr = data_addr | (mid << 8)
        data_addr = data_addr | (hi << 16)
        data_addr -= 0x30000
        res[i] = data[data_addr:data_addr + size * size]

    return res


with open(sys.argv[1], "rb") as f:
    data = f.read()

def print_square(data, size):
    while len(data) != 0:
        spr_line = data[4:size]
        sys.stdout.write(".byte ")
        for i in spr_line[:-1]:
            sys.stdout.write(f"${i:02x}, ")
        i = spr_line[19]
        sys.stdout.write(f"${i:02x}")
        sys.stdout.flush()
        print()
        data = data[size:]

res = parse_spr(data)
for i in res:
    print(f"; Tile Nr. {i}")
    print_square(res[i], 24)
