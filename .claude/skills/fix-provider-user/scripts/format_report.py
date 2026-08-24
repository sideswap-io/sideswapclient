#!/usr/bin/env python3
"""
Format the final report for a provider fix session.

Usage:
    python <script> <provider.dart> <coverage_pct> [--fixed "L45 addTearDown" "L92 hasLength"] [--skipped "L60-80 table-driven"]

Output: formatted report to stdout.
"""
import argparse
import sys


def main() -> None:
    parser = argparse.ArgumentParser(description="Format fix-provider report")
    parser.add_argument("provider", help="Provider filename (e.g. swap_provider.dart)")
    parser.add_argument("coverage_pct", type=float, help="Final coverage percentage")
    parser.add_argument("--fixed", nargs="*", default=[], help="List of fixed items")
    parser.add_argument("--skipped", nargs="*", default=[], help="List of skipped items")
    args = parser.parse_args()

    print(f"Done: {args.provider} -> {args.coverage_pct:.0f}%")

    if args.fixed:
        print(f"✅ Fixed: {', '.join(args.fixed)}")

    if args.skipped:
        print(f"⏭️ Skipped: {', '.join(args.skipped)}")

    if not args.fixed and not args.skipped:
        print("No issues found — clean pass.")


if __name__ == "__main__":
    main()
