#!/usr/bin/env python3
"""
Validate a fix: run dart analyze + integrity_check on a provider.

Usage:
    python <script> <project_root> <provider.dart>

Output: JSON to stdout.
Exit code: 0 = all clear, 1 = issues found, 2 = script error.
"""
import json
import subprocess
import sys
from pathlib import Path


def run(cmd: list[str], cwd: Path, **kwargs) -> subprocess.CompletedProcess:
    return subprocess.run(
        " ".join(cmd), cwd=cwd, capture_output=True, text=True,
        encoding="utf-8", shell=True, **kwargs
    )


def run_analyze(provider: str, project_root: Path) -> tuple[list[str], list[str]]:
    stem = provider.removesuffix(".dart")
    lib_file = f"lib/providers/{provider}"
    test_file = f"test/providers/{stem}_test.dart"

    targets = [lib_file]
    if (project_root / test_file).exists():
        targets.append(test_file)

    result = run(["dart", "analyze"] + targets, cwd=project_root)
    combined = result.stdout + result.stderr

    errors = []
    warnings = []
    for line in combined.splitlines():
        stripped = line.strip()
        if stripped.startswith("error "):
            errors.append(stripped)
        elif stripped.startswith("warning ") or stripped.startswith("info "):
            warnings.append(stripped)

    return errors, warnings


def run_integrity(project_root: Path) -> list[str]:
    result = run(["python", "tools/scripts/integrity_check.py"], cwd=project_root)
    violations = []
    for line in result.stdout.splitlines():
        if line.startswith("VIOLATION:"):
            violations.append(line.replace("VIOLATION: ", "").strip())
    return violations


def main() -> None:
    if len(sys.argv) < 3:
        print("Usage: python <script> <project_root> <provider.dart>",
              file=sys.stderr)
        sys.exit(2)

    project_root = Path(sys.argv[1]).resolve()
    provider = sys.argv[2]

    errors, warnings = run_analyze(provider, project_root)
    violations = run_integrity(project_root)

    all_clear = not errors and not violations

    report = {
        "provider": provider,
        "analyze_errors": errors,
        "analyze_warnings": warnings,
        "integrity_violations": violations,
        "all_clear": all_clear,
    }

    print(json.dumps(report, indent=2))
    sys.exit(0 if all_clear else 1)


if __name__ == "__main__":
    main()
