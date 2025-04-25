import sys


with open(sys.argv[1], "rb") as f:
    data = f.read()


while len(data) != 0:
    one_col = data[:4]
    print(f".byte ${one_col[0]:02X}, ${one_col[1]:02X}, ${one_col[2]:02X}, ${one_col[3]:02X}")
    data = data[4:]