#!/usr/bin/env python3
"""
Update coverage_progress.json for a single provider from the command line.

Usage:
    python tools/scripts/update_memory.py <provider_file> <status> [options]
    python tools/scripts/update_memory.py --end-of-session

Options:
    --coverage <float>       Coverage percentage
    --uncovered <n,n,n>      Comma-separated uncovered line numbers
    --notes <str>            Notes to set
    --fix-proposal <path>    Path to fix proposal file
    --retry-count <int>      Retry count
    --end-of-session         Update last_session and increment total_sessions (no provider needed)

Status values: pending, in-progress, done, needs-fix, partial, blocked, removed

Examples:
    python tools/scripts/update_memory.py amp_id_provider.dart done --coverage 100
    python tools/scripts/update_memory.py balances_provider.dart needs-fix --coverage 21 --uncovered 45,67,89 --notes "logger DI needed"
    python tools/scripts/update_memory.py assets_precache_provider.dart blocked --notes "rootBundle/SVG" --fix-proposal tools/prompts/fixes/assets_precache_provider_fix.md
    python tools/scripts/update_memory.py --end-of-session
"""
import argparse
import json
import sys
from datetime import date
from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parent.parent.parent
MEMORY_FILE = PROJECT_ROOT / "tools" / "coverage_progress.json"
TODAY = date.today().isoformat()


def main():
    parser = argparse.ArgumentParser(description="Update provider memory entry")
    parser.add_argument("provider", nargs="?", help="Provider filename (e.g. amp_id_provider.dart)")
    parser.add_argument("status", nargs="?", choices=["pending", "in-progress", "done", "needs-fix", "partial", "blocked", "removed"])
    parser.add_argument("--coverage", type=float)
    parser.add_argument("--uncovered", help="Comma-separated line numbers")
    parser.add_argument("--notes")
    parser.add_argument("--fix-proposal", dest="fix_proposal")
    parser.add_argument("--retry-count", dest="retry_count", type=int)
    parser.add_argument("--increment-retry", dest="increment_retry", action="store_true",
                        help="Increment retry_count by 1 (reads current value from memory)")
    parser.add_argument("--end-of-session", dest="end_of_session", action="store_true",
                        help="Update last_session + increment total_sessions")
    args = parser.parse_args()

    if not MEMORY_FILE.exists():
        print(f"ERROR: {MEMORY_FILE} not found", file=sys.stderr)
        sys.exit(1)

    memory = json.loads(MEMORY_FILE.read_text(encoding="utf-8"))

    if args.end_of_session:
        memory["last_session"] = TODAY
        memory["total_sessions"] = memory.get("total_sessions", 0) + 1
        MEMORY_FILE.write_text(
            json.dumps(memory, indent=2, ensure_ascii=False) + "\n",
            encoding="utf-8",
        )
        print(f"Session closed: last_session={TODAY}, total_sessions={memory['total_sessions']}")
        return

    if not args.provider or not args.status:
        parser.error("provider and status are required unless --end-of-session is set")

    providers = memory.setdefault("providers", {})

    if args.provider not in providers:
        providers[args.provider] = {
            "status": "pending",
            "coverage_pct": 0,
            "uncovered_lines": [],
            "notes": "",
        }

    entry = providers[args.provider]
    entry["status"] = args.status

    if args.coverage is not None:
        entry["coverage_pct"] = args.coverage
    if args.uncovered is not None:
        entry["uncovered_lines"] = [int(n.strip()) for n in args.uncovered.split(",") if n.strip()]
    if args.notes is not None:
        entry["notes"] = args.notes
    if args.fix_proposal is not None:
        entry["fix_proposal"] = args.fix_proposal
    if args.retry_count is not None:
        entry["retry_count"] = args.retry_count
    if args.increment_retry:
        entry["retry_count"] = entry.get("retry_count", 0) + 1

    if args.status == "done":
        entry["completed_date"] = TODAY
        entry.pop("last_attempt", None)
    elif args.status in ("needs-fix", "partial", "blocked", "in-progress"):
        entry["last_attempt"] = TODAY
        entry.pop("completed_date", None)

    MEMORY_FILE.write_text(
        json.dumps(memory, indent=2, ensure_ascii=False) + "\n",
        encoding="utf-8",
    )
    print(f"Updated: {args.provider} -> {args.status}")


if __name__ == "__main__":
    main()
