#!/usr/bin/env python3
"""
Check that no files outside test/ have been modified since HEAD.

Usage:
    python scripts/integrity_check.py

Output:
    PASS                        — no violations
    VIOLATION: lib/foo.dart     — one line per violated file

Exit code: 0 = PASS, 1 = violations found, 2 = git error
"""
import subprocess
import sys
from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parent.parent.parent

# For both tracked and untracked files: only flag lib/ changes.
# Writers must not touch production code. tools/ and test/ are both legitimate
# (tools/ is modified by orchestrator scripts, test/ by writer subagents).
TRACKED_VIOLATION_PREFIXES = ("lib/",)

# For untracked files: only flag new files under lib/ — writers must not create
# production code. We do NOT flag all untracked files because the repo already
# has many pre-existing untracked files (.metadata, android/build/, snap/, etc.)
# that are nothing to do with subagents.
UNTRACKED_VIOLATION_PREFIXES = ("lib/",)


def get_tracked_changes() -> list[str]:
    r = subprocess.run(
        ["git", "diff", "--name-only", "HEAD"],
        cwd=PROJECT_ROOT, capture_output=True, text=True,
    )
    if r.returncode != 0:
        print(f"ERROR: git diff failed: {r.stderr}", file=sys.stderr)
        sys.exit(2)
    return [f for f in r.stdout.strip().splitlines() if f]


def get_untracked_files() -> list[str]:
    r = subprocess.run(
        ["git", "ls-files", "--others", "--exclude-standard"],
        cwd=PROJECT_ROOT, capture_output=True, text=True,
    )
    if r.returncode != 0:
        print(f"ERROR: git ls-files failed: {r.stderr}", file=sys.stderr)
        sys.exit(2)
    return [f for f in r.stdout.strip().splitlines() if f]


def main():
    violations: list[str] = []

    for f in get_tracked_changes():
        if any(f.startswith(p) for p in TRACKED_VIOLATION_PREFIXES):
            violations.append(f)

    for f in get_untracked_files():
        if any(f.startswith(p) for p in UNTRACKED_VIOLATION_PREFIXES):
            violations.append(f)

    if not violations:
        print("PASS")
        sys.exit(0)

    for v in violations:
        print(f"VIOLATION: {v}")
    sys.exit(1)


if __name__ == "__main__":
    main()
