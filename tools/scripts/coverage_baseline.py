#!/usr/bin/env python3
"""
Coverage baseline script for SideSwap provider tests.

Run by the orchestrator at session start (Plan Section 2, Step 3) instead of
spawning a tester subagent. Updates tools/coverage_progress.json with fresh
coverage data and prints a session-ready summary.

Usage (from project root):
    python tools/scripts/coverage_baseline.py               # full run (flutter test + update JSON)
    python tools/scripts/coverage_baseline.py --stats-only  # print stats from existing JSON, no tests
"""

import json
import subprocess
import sys
from datetime import date
from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parent.parent.parent
PROVIDERS_DIR = PROJECT_ROOT / "lib" / "providers"
TEST_DIR = PROJECT_ROOT / "test" / "providers"
LCOV_FILE = PROJECT_ROOT / "coverage" / "lcov.info"
MEMORY_FILE = PROJECT_ROOT / "tools" / "coverage_progress.json"
TODAY = date.today().isoformat()

# Auto-promote partial → blocked after this many retries with no escape
PARTIAL_RETRY_LIMIT = 2


# ---------------------------------------------------------------------------
# Test runner
# ---------------------------------------------------------------------------

def run_tests() -> bool:
    print("Running: flutter test test/providers/ --coverage")
    result = subprocess.run(
        "flutter test test/providers/ --coverage --reporter compact",
        cwd=PROJECT_ROOT,
        shell=True,
        capture_output=True,
        text=True,
        encoding="utf-8",
        errors="replace",
    )
    # Print only the final summary line (e.g. "+1115 -56: Some tests failed.")
    lines = [l for l in result.stdout.splitlines() if l.strip()]
    if lines:
        print(lines[-1])
    if result.returncode != 0 and result.stderr.strip():
        print(result.stderr.strip()[-500:])
    return result.returncode == 0


# ---------------------------------------------------------------------------
# lcov parser
# ---------------------------------------------------------------------------

def parse_lcov(lcov_path: Path) -> dict[str, dict]:
    """Return {filename: {coverage_pct, covered, total, uncovered_lines}}."""
    if not lcov_path.exists():
        print(f"WARNING: {lcov_path} not found — no coverage data.")
        return {}

    content = lcov_path.read_text(encoding="utf-8")
    result: dict[str, dict] = {}

    for section in content.split("SF:")[1:]:
        lines = section.split("\n")
        sf = lines[0].strip().replace("\\", "/")

        if "lib/providers/" not in sf:
            continue
        filename = sf.split("lib/providers/")[-1]
        if filename.endswith(".g.dart") or filename.endswith(".freezed.dart"):
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
        pct = round(100 * covered / total, 1)

        if filename in result:
            prev = result[filename]
            merged_covered = prev["covered"] + covered
            merged_total = prev["total"] + total
            result[filename] = {
                "coverage_pct": round(100 * merged_covered / merged_total, 1),
                "covered": merged_covered,
                "total": merged_total,
                "uncovered_lines": sorted(set(prev["uncovered_lines"] + uncovered)),
            }
        else:
            result[filename] = {
                "coverage_pct": pct,
                "covered": covered,
                "total": total,
                "uncovered_lines": uncovered,
            }

    return result


# ---------------------------------------------------------------------------
# Git helpers
# ---------------------------------------------------------------------------

def get_lib_commit(provider_file: str) -> str:
    """Return the last git commit hash that touched lib/providers/<file>."""
    result = subprocess.run(
        ["git", "log", "-1", "--format=%H", "--", f"lib/providers/{provider_file}"],
        cwd=PROJECT_ROOT,
        capture_output=True,
        text=True,
        encoding="utf-8",
        errors="replace",
    )
    return result.stdout.strip()


# ---------------------------------------------------------------------------
# Memory helpers
# ---------------------------------------------------------------------------

def load_memory() -> dict:
    if MEMORY_FILE.exists():
        return json.loads(MEMORY_FILE.read_text(encoding="utf-8"))
    return {
        "schema_version": 2,
        "last_session": None,
        "total_sessions": 0,
        "providers": {},
    }


def get_provider_files() -> list[str]:
    return sorted(
        f.name for f in PROVIDERS_DIR.glob("*.dart")
        if not f.name.endswith(".g.dart") and not f.name.endswith(".freezed.dart")
    )


def update_memory(
    memory: dict, coverage: dict, provider_files: list[str]
) -> tuple[list[dict], list[str], list[str]]:
    """Sync memory with fresh coverage.

    Returns:
        regressions     — list of {file, old_pct, new_pct}
        orphaned_tests  — test files whose provider no longer exists
        lib_changed     — blocked/partial providers re-queued because lib/ changed
    """
    providers = memory.setdefault("providers", {})
    regressions: list[dict] = []
    orphaned_tests: list[str] = []
    lib_changed: list[str] = []

    # New files → pending (record current lib commit for future change detection)
    for f in provider_files:
        if f not in providers:
            providers[f] = {
                "status": "pending",
                "coverage_pct": 0,
                "uncovered_lines": [],
                "notes": "",
                "lib_last_commit": get_lib_commit(f),
            }

    # Removed files → delete from memory; warn about orphaned test files
    for f in list(providers):
        if f not in provider_files:
            test_path = TEST_DIR / f.replace(".dart", "_test.dart")
            if test_path.exists():
                orphaned_tests.append(str(test_path.relative_to(PROJECT_ROOT)))
            del providers[f]

    # Update coverage + detect lib/ changes + auto-promote stale partial
    for f in provider_files:
        entry = providers[f]
        old_pct = entry.get("coverage_pct", 0)
        old_status = entry.get("status", "pending")

        # --- lib/ change detection for blocked / partial ---
        if old_status in ("blocked", "partial"):
            stored_commit = entry.get("lib_last_commit", "")
            current_commit = get_lib_commit(f)
            entry["lib_last_commit"] = current_commit
            if current_commit and current_commit != stored_commit:
                lib_changed.append(f)
                entry["status"] = "needs-fix"
                entry["retry_count"] = 0
                note = entry.get("notes", "")
                entry["notes"] = (
                    f"lib/ changed since last attempt ({TODAY}). " + note
                ).strip()
        else:
            # Keep lib_last_commit fresh for all providers
            entry["lib_last_commit"] = get_lib_commit(f)

        # --- coverage update ---
        if f in coverage:
            new_pct = coverage[f]["coverage_pct"]
            new_uncovered = coverage[f]["uncovered_lines"]
        else:
            new_pct = 0
            new_uncovered = []

        # Regression: was done but coverage dropped
        if old_status == "done" and new_pct < 100:
            regressions.append({"file": f, "old_pct": old_pct, "new_pct": new_pct})
            entry["status"] = "needs-fix"
            note = entry.get("notes", "")
            entry["notes"] = (
                f"REGRESSION {TODAY}: was {old_pct}%, now {new_pct}%. " + note
            ).strip()

        entry["coverage_pct"] = new_pct
        entry["uncovered_lines"] = new_uncovered

        # --- auto-promote stale partial → blocked ---
        if entry.get("status") == "partial":
            retries = entry.get("retry_count", 0)
            if retries >= PARTIAL_RETRY_LIMIT:
                entry["status"] = "blocked"
                note = entry.get("notes", "")
                entry["notes"] = (
                    f"Auto-promoted to blocked after {retries} retries ({TODAY}). "
                    + note
                ).strip()

    return regressions, orphaned_tests, lib_changed


def save_memory(memory: dict):
    MEMORY_FILE.write_text(
        json.dumps(memory, indent=2, ensure_ascii=False) + "\n",
        encoding="utf-8",
    )


# ---------------------------------------------------------------------------
# Summary printer
# ---------------------------------------------------------------------------

def print_summary(
    memory: dict,
    regressions: list[dict],
    orphaned_tests: list[str],
    lib_changed: list[str],
):
    providers = memory["providers"]

    counts: dict[str, int] = {}
    for e in providers.values():
        s = e.get("status", "pending")
        counts[s] = counts.get(s, 0) + 1

    done = counts.get("done", 0)
    total = len(providers)

    print("\n" + "=" * 62)
    print("COVERAGE BASELINE — ready for orchestrator")
    print("=" * 62)
    print(f"  Total providers : {total}")
    print(f"  Done (100%)     : {done}")
    print(f"  Needs fix       : {counts.get('needs-fix', 0)}")
    print(f"  Partial         : {counts.get('partial', 0)}")
    print(f"  Pending         : {counts.get('pending', 0)}")
    print(f"  Blocked         : {counts.get('blocked', 0)}")
    print(f"  Overall         : {done}/{total} at 100%")

    if regressions:
        print("\n  !! REGRESSIONS:")
        for r in regressions:
            print(f"    {r['file']}: {r['old_pct']}% -> {r['new_pct']}%")

    if lib_changed:
        print("\n  !! lib/ CHANGED — re-queued as needs-fix:")
        for f in lib_changed:
            print(f"    {f}")

    if orphaned_tests:
        print("\n  !! ORPHANED TEST FILES (provider removed, test file remains):")
        for t in orphaned_tests:
            print(f"    {t}  ← consider deleting")

    # Work queue: needs-fix + pending + partial (all retries exhausted ones are
    # already promoted to blocked above, so all remaining partial are worth retrying)
    queue = sorted(
        [(f, e) for f, e in providers.items()
         if e.get("status") in ("needs-fix", "partial", "pending")],
        key=lambda x: (x[1].get("coverage_pct", 0), x[0]),
    )

    # Blocked: needs lib/ refactoring
    blocked = sorted(
        [(f, e) for f, e in providers.items() if e.get("status") == "blocked"],
        key=lambda x: x[0],
    )

    if queue:
        print(f"\n  Work queue ({len(queue)} providers, lowest coverage first):")
        for f, e in queue[:10]:
            pct = e.get("coverage_pct", 0)
            status = e.get("status", "pending")
            retries = e.get("retry_count", 0)
            retry_tag = f"  retry {retries}" if retries > 0 else ""
            print(f"    [{status:10s}] {f} ({pct}%){retry_tag}")
        if len(queue) > 10:
            print(f"    ... and {len(queue) - 10} more")
    else:
        print()
        if total == done:
            print("  All providers at 100% coverage!")
        else:
            print("  Work queue is empty.")
        if blocked:
            print("  Remaining providers require lib/ refactoring (see blocked list below).")

    if blocked:
        print(f"\n  Blocked — awaiting lib/ refactoring ({len(blocked)} providers):")
        for f, e in blocked:
            fix = e.get("fix_proposal") or f"tools/prompts/fixes/{f}_fix.md"
            print(f"    {f}  ->  {fix}")

    print("\n" + "=" * 62)
    print(f"\n  coverage_progress.json: {MEMORY_FILE}")
    print("\n  Orchestrator: proceed to Step 4 (report to user).")
    print()


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def main():
    stats_only = "--stats-only" in sys.argv

    print(f"SideSwap Coverage Baseline  |  {TODAY}")
    print(f"Project root: {PROJECT_ROOT}\n")

    if stats_only:
        memory = load_memory()
        print_summary(memory, [], [], [])
        sys.exit(0)

    tests_ok = run_tests()
    if not tests_ok:
        print("\nWARNING: Some tests failed — coverage data may be incomplete.\n")

    coverage = parse_lcov(LCOV_FILE)

    memory = load_memory()
    provider_files = get_provider_files()
    regressions, orphaned_tests, lib_changed = update_memory(memory, coverage, provider_files)
    memory["last_session"] = TODAY

    save_memory(memory)
    print_summary(memory, regressions, orphaned_tests, lib_changed)

    sys.exit(0 if tests_ok else 1)


if __name__ == "__main__":
    main()
