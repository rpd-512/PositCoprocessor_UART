#!/bin/bash
# Fresh-process binary search + local sweep. Every point = its own Genus process.
# Run from: PositCoprocessor_UART/gds/genus_workflow/
#   chmod +x run_sweep.sh && ./run_sweep.sh
# Needs fresh_point.tcl in the same directory.

FREQ_LOW=10
FREQ_HIGH=500
FREQ_TOL=2
LOCAL_OFFSETS="-40 -20 -10"

OUT=./sweep_fresh
FINAL=./final_results_fresh
CSV=$OUT/sweep_results.csv

mkdir -p "$OUT"
echo "freq_mhz,period_ns,wns_ns,tns_ns,area_um2,leakage_power_uw,dynamic_power_uw,total_power_uw,timing_met,phase" > "$CSV"

# run_point <freq> <phase>: runs one fresh Genus process, appends its row to the CSV
run_point() {
    local f=$1 phase=$2
    rm -f "$OUT/row_${f}.csv"
    echo "===== ${phase}: ${f} MHz (fresh Genus process) ====="
    FREQ=$f OUT_DIR=$OUT genus -f fresh_point.tcl -no_gui -log "$OUT/genus_${f}.log" > /dev/null 2>&1
    if [ -s "$OUT/row_${f}.csv" ]; then
        echo "$(cat "$OUT/row_${f}.csv"),${phase}" >> "$CSV"
    else
        echo "WARNING: no result row for ${f} MHz (see $OUT/genus_${f}.log)"
        echo "${f},NA,NA,NA,NA,NA,NA,NA,0,${phase}" >> "$CSV"
    fi
}

# met <freq>: prints 1 if that frequency met timing, else 0
met() {
    awk -F, -v f="$1" '$1==f {v=$9} END {print (v==1) ? 1 : 0}' "$CSV"
}

measured() {
    awk -F, -v f="$1" '$1==f {found=1} END {print found ? 1 : 0}' "$CSV"
}

# ---- Phase 1: binary search ----
lo=$FREQ_LOW
hi=$FREQ_HIGH
run_point $lo binary_search
if [ "$(met $lo)" != "1" ]; then
    echo "ERROR: even ${lo} MHz fails (or the run failed). Check $OUT/genus_${lo}.log"
    exit 1
fi
while [ $((hi - lo)) -gt $FREQ_TOL ]; do
    mid=$(( (lo + hi) / 2 ))
    run_point $mid binary_search
    if [ "$(met $mid)" = "1" ]; then lo=$mid; else hi=$mid; fi
done
search_best=$lo
echo "Binary search converged: max passing frequency ~= ${search_best} MHz"
if [ $hi -eq $FREQ_HIGH ]; then
    echo "WARNING: nothing failed, so ${search_best} MHz is only a lower bound. Raise FREQ_HIGH."
fi

# ---- Phase 2: local sweep below the boundary ----
for off in $LOCAL_OFFSETS; do
    f=$((search_best + off))
    [ $f -le 0 ] && continue
    if [ "$(measured $f)" = "1" ]; then echo "(skipping ${f} MHz: already measured)"; continue; fi
    run_point $f local_sweep
done

# ---- Phase 3: pick highest passing point that has a saved netlist ----
best=""
for f in $(awk -F, 'NR>1 && $9==1 {print $1}' "$CSV" | sort -rn); do
    if [ -s "$OUT/pt_${f}MHz/coprocessor_netlist.v" ]; then best=$f; break; fi
done
if [ -z "$best" ]; then
    echo "ERROR: no passing point with a saved netlist."
    exit 1
fi

mkdir -p "$FINAL"
cp "$OUT/pt_${best}MHz/coprocessor_netlist.v" "$OUT/pt_${best}MHz/coprocessor.sdc" "$FINAL/"
for r in area power timing; do cp "$OUT/${r}_${best}.rpt" "$FINAL/${r}.rpt"; done
cp "$CSV" "$FINAL/"

echo
echo "===== DONE ====="
echo "Fmax (fresh-session) : ${search_best} MHz"
echo "Selected point       : ${best} MHz"
echo "Hand-off files       : $FINAL/"
echo "All points           : $CSV"
echo "NOTE: every point was synthesised in its own fresh process. The hand-off point's WNS is"
echo "      likely ~0, so consider handing off a lower frequency for post-route margin."
