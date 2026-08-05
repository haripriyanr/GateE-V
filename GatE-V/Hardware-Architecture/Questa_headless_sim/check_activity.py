#!/usr/bin/env python3
import re, sys

VCD = "/run/media/user/DATA/DVcon/GatE-V/Hardware-Architecture/Questa_headless_sim/gatev_headless.vcd"
WANT = ["acc_start", "acc_done", "all_done", "ctrl_reg", "status_reg", "mode_reg",
        "dma_start_q", "m_axi_awvalid", "m_axi_arvalid", "m_axi_wvalid",
        "s_axil_awvalid", "s_axil_arvalid"]

id2n = {}
counts = {}   # name -> (first_chg, last_chg, n_chg)
spectrum = {}
curtime = 0

vec_re = re.compile(r"([01xXzZ]+)\s+([!-~]+)")

with open(VCD, 'r', errors='latin1') as f:
    for raw in f:
        ln = raw.strip()
        if not ln:
            continue
        if ln.startswith('#'):
            curtime = int(ln[1:])
            continue
        if ln.startswith('$var'):
            p = ln.split()
            if len(p) >= 5:
                id2n[p[3]] = p[4]
                counts.setdefault(p[4], [0, -1, 0])
            continue
        if ln.startswith('$') or ln.startswith('b') or ln.startswith('B'):
            continue
        if len(ln) >= 2 and ln[0] in '01xXzZ':
            cid = ln[1:]
            if cid in id2n:
                nam = id2n[cid]
                c = counts[nam]
                if c[1] < 0:
                    c[1] = curtime
                c[2] = curtime
                c[0] += 1
        continue

print("signal                     first_us      last_us      changes")
for nam in WANT:
    if nam not in counts:
        print("%-26s absent" % nam)
        continue
    c = counts[nam]
    if c[0] == 0:
        print("%-26s never changed    (defined but idle)" % nam)
    else:
        print("%-26s %.3f       %.3f       %d" % (nam, c[1]/1e6, c[2]/1e6, c[0]))
print("\n(all values relative to 0 ps; 1000 us = full window)")