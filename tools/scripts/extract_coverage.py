#!/usr/bin/env python3
"""
Extract coverage data for a specific provider from lcov.info.

Usage:
    python scripts/extract_coverage.py <provider_file>

Output (JSON to stdout):
    {"provider": "...", "coverage_pct": 80.4, "covered": 45, "total": 56, "uncovered_lines": [12, 34]}

Exit code: 0 = found, 1 = not found in lcov, 2 = lcov.info missing
"""
import json
import sys
from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parent.parent.parent
LCOV_FILE = PROJECT_ROOT / "coverage" / "lcov.info"


def extract(provider_file: str) -> dict | None:
    if not LCOV_FILE.exists():
        print(f"ERROR: {LCOV_FILE} not found", file=sys.stderr)
        sys.exit(2)

    content = LCOV_FILE.read_text(encoding="utf-8")
    merged: dict | None = None

    for section in content.split("SF:")[1:]:
        lines = section.split("\n")
        sf = lines[0].strip().replace("\\", "/")
        if f"lib/providers/{provider_file}" not in sf:
            continue

        da_lines = [l for l in lines if l.startswith("DA:")]
        total = len(da_lines)
        if total == 0:
            continue

        covered = sum(1 for l in da_lines if not l.endswith(",0"))
        uncovered = sorted(
            int(l.split(",")[0].replace("DA:", ""))
            for l in da_lines if l.endswith(",0")
        )

        if merged is None:
            merged = {"covered": covered, "total": total, "uncovered_lines": uncovered}
        else:
            merged["covered"] += covered
            merged["total"] += total
            merged["uncovered_lines"] = sorted(set(merged["uncovered_lines"] + uncovered))

    if merged is None:
        return None

    pct = round(100 * merged["covered"] / merged["total"], 1)
    return {
        "provider": provider_file,
        "coverage_pct": pct,
        "covered": merged["covered"],
        "total": merged["total"],
        "uncovered_lines": merged["uncovered_lines"],
    }


def main():
    if len(sys.argv) < 2:
        print("Usage: python scripts/extract_coverage.py <provider_file>", file=sys.stderr)
        sys.exit(1)

    provider_file = sys.argv[1]
    result = extract(provider_file)

    if result is None:
        print(json.dumps({
            "provider": provider_file,
            "coverage_pct": 0,
            "covered": 0,
            "total": 0,
            "uncovered_lines": [],
            "note": "not found in lcov.info",
        }))
        sys.exit(1)

    print(json.dumps(result))


if __name__ == "__main__":
    main()
