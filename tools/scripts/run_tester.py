#!/usr/bin/env python3
"""
Run full tester validation for a list of providers.

Replaces the 6-step manual tester subagent flow:
  1. flutter analyze (once for all providers)
  2. flutter test per provider (pass/fail)
  3. flutter test --coverage for passing providers only
  4. extract_coverage.py per provider
  5. Build JSON report

Usage:
    python tools/scripts/run_tester.py <provider1.dart> <provider2.dart> ...
    python tools/scripts/run_tester.py --integrity <provider1.dart> ...

Options:
    --integrity  Run integrity_check.py before tests and include violations in report.

Output: JSON array to stdout, one entry per provider.
Stderr: progress messages.
Exit code: 0 = all PASS, 1 = at least one FAIL/PARTIAL, 2 = script error.

Example:
    python tools/scripts/run_tester.py currency_rates_provider.dart
    python tools/scripts/run_tester.py --integrity currency_rates_provider.dart
"""
import json
import subprocess
import sys
from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parent.parent.parent


def run(cmd: list[str], **kwargs) -> subprocess.CompletedProcess:
    # shell=True required on Windows to resolve PATH-based executables (flutter, dart)
    return subprocess.run(
        " ".join(cmd), cwd=PROJECT_ROOT, capture_output=True, text=True,
        encoding='utf-8', shell=True, **kwargs
    )


def analyze(test_files: list[str]) -> tuple[dict[str, list], dict[str, list]]:
    """Run flutter analyze once and partition results by test file."""
    print("  flutter analyze...", file=sys.stderr)
    result = run(["flutter", "analyze"])
    combined = result.stdout + result.stderr

    errors: dict[str, list] = {f: [] for f in test_files}
    warnings: dict[str, list] = {f: [] for f in test_files}

    for line in combined.splitlines():
        normalized = line.replace("\\", "/")
        for tf in test_files:
            if tf not in normalized:
                continue
            stripped = line.strip()
            if stripped.startswith("error "):
                errors[tf].append(stripped)
            elif stripped.startswith("warning ") or stripped.startswith("info "):
                warnings[tf].append(stripped)

    return errors, warnings


def test_provider(test_file: str) -> tuple[bool, list[str]]:
    """Run flutter test for one provider. Returns (passed, failing_test_names)."""
    result = run(["flutter", "test", test_file, "--reporter", "json"])
    passed = result.returncode == 0

    failing: list[str] = []
    tests: dict[int, str] = {}
    failed_ids: set[int] = set()

    for line in result.stdout.splitlines():
        line = line.strip()
        if not line:
            continue
        try:
            e = json.loads(line)
            t = e.get("type")
            if t == "testStart":
                tests[e["test"]["id"]] = e["test"]["name"]
            elif t == "testDone" and e.get("result") != "success":
                # Direct failure (assertion errors)
                failed_ids.add(e.get("testID"))
            elif t == "error":
                # Async post-completion errors (e.g. MissingPluginException)
                failed_ids.add(e.get("testID"))
        except json.JSONDecodeError:
            pass

    for test_id in failed_ids:
        name = tests.get(test_id, "")
        if name and not name.startswith("loading "):
            failing.append(name)

    return passed, failing


def coverage_run(passing_test_files: list[str]) -> bool:
    """Run flutter test --coverage with full test suite for accurate cross-file coverage."""
    if not passing_test_files:
        return False
    print(f"  flutter test --coverage (full suite)...", file=sys.stderr)
    result = run(["flutter", "test", "--coverage", "test/providers/"])
    return result.returncode == 0


def extract_coverage(provider: str) -> tuple[float | None, list[int], bool]:
    """
    Run extract_coverage.py for a provider.
    Returns (coverage_pct, uncovered_lines, measurement_error).
    """
    result = run(["python", "tools/scripts/extract_coverage.py", provider])
    try:
        data = json.loads(result.stdout)
    except json.JSONDecodeError:
        return None, [], True

    measurement_error = result.returncode == 1
    pct = None if measurement_error else data.get("coverage_pct", 0)
    uncovered = data.get("uncovered_lines", [])
    return pct, uncovered, measurement_error


def verdict(
    compile_errors: list,
    warnings: list,
    tests_passed: bool,
    coverage_pct: float | None,
    measurement_error: bool,
) -> str:
    if compile_errors or not tests_passed:
        return "FAIL"
    if measurement_error or (coverage_pct is not None and coverage_pct == 0):
        return "PARTIAL"
    if coverage_pct == 100 and not warnings:
        return "PASS"
    return "FAIL"


def run_integrity() -> list[str]:
    """Run integrity_check.py and return list of violations."""
    print("  integrity check...", file=sys.stderr)
    result = run(["python", "tools/scripts/integrity_check.py"])
    violations = []
    for line in result.stdout.splitlines():
        if line.startswith("VIOLATION:"):
            violations.append(line.replace("VIOLATION: ", "").strip())
    return violations


def main() -> None:
    if len(sys.argv) < 2:
        print("Usage: python scripts/run_tester.py [--integrity] <provider1.dart> ...", file=sys.stderr)
        sys.exit(2)

    args = sys.argv[1:]
    with_integrity = "--integrity" in args
    providers = [a for a in args if a != "--integrity"]

    if not providers:
        print("Usage: python scripts/run_tester.py [--integrity] <provider1.dart> ...", file=sys.stderr)
        sys.exit(2)

    integrity_violations: list[str] = []
    if with_integrity:
        integrity_violations = run_integrity()
    test_files = [
        f"test/providers/{p.removesuffix('.dart')}_test.dart"
        for p in providers
    ]

    # Step 1 — analyze
    errors, warnings = analyze(test_files)

    # Step 2 — test each provider
    test_results: dict[str, tuple[bool, list]] = {}
    passing_test_files: list[str] = []

    for provider, tf in zip(providers, test_files):
        if errors[tf]:
            print(f"  SKIP tests (compile errors): {provider}", file=sys.stderr)
            test_results[provider] = (False, [])
            continue
        print(f"  flutter test {provider}...", file=sys.stderr)
        passed, failing = test_provider(tf)
        test_results[provider] = (passed, failing)
        if passed:
            passing_test_files.append(tf)

    # Step 3 — coverage for passing only
    coverage_run(passing_test_files)

    # Step 4 — extract coverage + build report
    report = []
    all_pass = True

    for provider, tf in zip(providers, test_files):
        tests_passed, failing = test_results[provider]
        comp_errors = errors[tf]
        warns = warnings[tf]
        pct, uncovered, measurement_error = extract_coverage(provider)

        v = verdict(comp_errors, warns, tests_passed, pct, measurement_error)
        if v != "PASS":
            all_pass = False

        entry = {
            "provider": provider,
            "tests_passed": tests_passed,
            "compilation_errors": comp_errors,
            "warnings": warns,
            "coverage_pct": pct,
            "coverage_measurement_error": measurement_error,
            "failing_tests": failing,
            "uncovered_lines": uncovered,
            "verdict": v,
        }
        if with_integrity:
            entry["integrity_violations"] = integrity_violations
        report.append(entry)

    print(json.dumps(report, indent=2))
    sys.exit(0 if all_pass else 1)


if __name__ == "__main__":
    main()
