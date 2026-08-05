#!/usr/bin/env python3
import re

VCD = "gatev_headless.vcd"

WANT = [
    "clk", "aclk", "areset_n",
    "acc_start", "acc_done", "all_done", "dma_start_q", "dma_done",
    "ctrl_reg", "status_reg", "mode_reg", "dma_ctrl_reg",
    "m_axi_awvalid", "m_axi_wvalid", "m_axi_arvalid", "m_axi_bvalid", "m_axi_rvalid",
    "m_axi_wlast", "m_axi_rlast", "m_axi_awaddr", "m_axi_araddr",
    "m_axi_rdata", "m_axi_wdata",
    "s_axil_awvalid", "s_axil_awready", "s_axil_wvalid", "s_axil_wready",
    "s_axil_rvalid", "s_axil_arvalid", "s_axil_arready",
]

data = open(VCD, 'r', errors='latin1').read().splitlines()
n = len(data)

id2name = {}
series = {}
curtime = 0

i = 0
while i < n:
    ln = data[i].strip()
    if not ln:
        i += 1
        continue
    if ln.startswith('#'):
        curtime = int(ln[1:].strip() or 0)
        i += 1
        continue
    if ln.startswith('$var'):
        p = ln.split()
        if len(p) >= 5:
            id2name[p[3]] = p[4]
            series.setdefault(p[4], [])
        i += 1
        continue
    if ln.startswith('$') or ln.startswith('b') or ln.startswith('B'):
        # decode vector: "b<bin><id>" possibly with a space: "b<bin> <id>"
        body = ln[1:].strip()
        m = re.match(r"([01xXzZ]+)\s+([!-~]+)", body) or re.match(r"([01xXzZ]+)([!-~]+)", body)
        if m and m.group(2) in id2name:
            name = id2name[m.group(2)]
            series[name].append((curtime, m.group(1)))
        i += 1
        continue
    if len(ln) >= 2 and ln[0] in '01xXzZ':
        cid = ln[1:]
        cid = ln[1:].strip()
        if cid in id2name:
            series[id2name[cid]].append((curtime, ln[0]))
    i += 1

print("Parsed %d lines; %d signals captured." % (n, len(series)))

all_time = [x[0] for s in series.values() for x in s]
t1 = max(all_time) if all_time else 0

def bin_to_int(bstr):
    v = 0
    for c in bstr:
        v = (v << 1) | (1 if c == '1' else 0)
    return v

def report(name):
    sv = series.get(name)
    if not sv:
        print("%-20s <absent>" % name)
        return
    span = max(t1, 1)
    high = sum((sv[k + 1][0] - sv[k][0]) for k in range(len(sv) - 1) if sv[k][1] not in ('0',))
    edges = sum(1 for k in range(len(sv) - 1) if sv[k][1] != sv[k + 1][1])
    # last value as int if binary
    lastv = sv[-1][1]
    try:
        if all(c in '01' for c in lastv):
            lastv = "0x%x" % bin_to_int(lastv)
    except Exception:
        pass
    print("%-20s span=%.3fms high=%.2f%% edges=%-6d nchg=%-6d last=%s" % (name, span / 1e9, 100 * high / span, edges, len(sv), lastv))

print("=== GATE-V activity (captured %.3f ms) ===" % (t1 / 1e9))
for w in WANT:
    report(w)