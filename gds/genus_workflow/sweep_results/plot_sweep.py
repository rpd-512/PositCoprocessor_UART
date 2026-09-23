#!/usr/bin/env python3
"""
Plot all numeric columns from a Genus frequency-sweep CSV
(freq_mhz, period_ns, wns_ns, tns_ns, area_um2, leakage_power_uw,
 dynamic_power_uw, total_power_uw, timing_met, phase)

Usage:
    python plot_sweep_results.py sweep_results.csv
    python plot_sweep_results.py sweep_results.csv --out sweep_plots.png
"""

import argparse
import sys

import matplotlib.pyplot as plt
import pandas as pd


def load_csv(path):
    df = pd.read_csv(path, na_values=["NA"])
    df = df.sort_values("freq_mhz").reset_index(drop=True)
    return df


def split_pass_fail(df):
    passed = df[df["timing_met"] == 1]
    failed = df[df["timing_met"] == 0]
    return passed, failed


def plot_metric(ax, df, ycol, ylabel, title, log_y=False):
    passed, failed = split_pass_fail(df)

    if not passed.empty:
        ax.scatter(passed["freq_mhz"], passed[ycol], color="tab:green",
                   label="timing met", zorder=3)
    if not failed.empty:
        ax.scatter(failed["freq_mhz"], failed[ycol], color="tab:red",
                   marker="x", label="timing failed", zorder=3)

    # connecting line across all points sorted by frequency, ignoring NaNs
    valid = df.dropna(subset=[ycol])
    ax.plot(valid["freq_mhz"], valid[ycol], color="gray", alpha=0.4,
             linewidth=1, zorder=1)

    if log_y:
        ax.set_yscale("log")

    ax.set_xlabel("Frequency (MHz)")
    ax.set_ylabel(ylabel)
    ax.set_title(title)
    ax.grid(True, alpha=0.3)
    ax.legend(fontsize=8)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("csv_path", help="Path to sweep_results.csv")
    parser.add_argument("--out", default=None,
                        help="Save figure to this path instead of showing it "
                             "(e.g. sweep_plots.png)")
    args = parser.parse_args()

    try:
        df = load_csv(args.csv_path)
    except FileNotFoundError:
        print(f"Error: file not found: {args.csv_path}", file=sys.stderr)
        sys.exit(1)

    required_cols = {"freq_mhz", "wns_ns", "area_um2", "leakage_power_uw",
                     "dynamic_power_uw", "total_power_uw", "timing_met"}
    missing = required_cols - set(df.columns)
    if missing:
        print(f"Error: CSV is missing expected columns: {missing}", file=sys.stderr)
        sys.exit(1)

    fig, axes = plt.subplots(2, 2, figsize=(12, 9))
    fig.suptitle("Genus Frequency Sweep — All Metrics vs Frequency", fontsize=14)

    # 1. WNS vs frequency (the pass/fail boundary)
    plot_metric(axes[0, 0], df, "wns_ns", "WNS (ns)",
               "Worst Negative Slack")
    axes[0, 0].axhline(0, color="black", linewidth=0.8, linestyle="--")

    # 2. Area vs frequency
    plot_metric(axes[0, 1], df, "area_um2", "Area (\u00b5m\u00b2)",
               "Total Area")

    # 3. Total power vs frequency (log scale — spans orders of magnitude)
    plot_metric(axes[1, 0], df, "total_power_uw", "Total Power (\u00b5W)",
               "Total Power", log_y=True)

    # 4. Leakage vs dynamic power, stacked-style comparison
    ax4 = axes[1, 1]
    valid = df.dropna(subset=["leakage_power_uw", "dynamic_power_uw"])
    ax4.plot(valid["freq_mhz"], valid["dynamic_power_uw"], "o-",
             color="tab:blue", label="Dynamic power")
    ax4.plot(valid["freq_mhz"], valid["leakage_power_uw"], "o-",
             color="tab:orange", label="Leakage power")
    ax4.set_yscale("log")
    ax4.set_xlabel("Frequency (MHz)")
    ax4.set_ylabel("Power (\u00b5W)")
    ax4.set_title("Dynamic vs Leakage Power")
    ax4.grid(True, alpha=0.3)
    ax4.legend(fontsize=8)

    plt.tight_layout(rect=[0, 0, 1, 0.96])

    if args.out:
        plt.savefig(args.out, dpi=150)
        print(f"Saved plot to {args.out}")
    else:
        plt.show()


if __name__ == "__main__":
    main()
