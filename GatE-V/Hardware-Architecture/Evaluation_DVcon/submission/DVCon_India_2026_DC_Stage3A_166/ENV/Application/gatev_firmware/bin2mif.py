import sys

bin_file = sys.argv[1]
mif_file = sys.argv[2]

with open(bin_file, "rb") as f:
    data = f.read()

# Pad to 32KB (32768 bytes)
if len(data) < 32768:
    data = data + b"\x00" * (32768 - len(data))

lines = []
for i in range(0, len(data), 8):
    chunk = data[i:i+8]
    w1 = int.from_bytes(chunk[0:4], "little")
    w2 = int.from_bytes(chunk[4:8], "little")
    s1 = f"{w1:032b}"
    s2 = f"{w2:032b}"
    lines.append(s2 + s1)

with open(mif_file, "w") as f:
    for l in lines:
        f.write(l + "\n")
