#!/usr/bin/env python3
"""
Check transitive blocked dependencies for a provider file.

Run by the orchestrator BEFORE spawning a writer subagent. Detects which of this
provider's Riverpod dependencies are already marked "blocked" in coverage_progress.json.
Output is injected directly into the writer prompt so the writer does not need to
read coverage_progress.json or reason about the dependency graph itself.

Usage (from project root):
    python tools/scripts/check_transitive_deps.py <provider_file.dart>

Output (JSON to stdout):
    {
      "blocked_deps": ["pegs_provider.dart"],
      "all_deps": ["pegs_provider.dart", "wallet_provider.dart"]
    }

Exit codes:
    0 — success (even if blocked deps found)
    1 — provider file not found or other error
"""

import json
import re
import sys
from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parent.parent.parent
PROVIDERS_DIR = PROJECT_ROOT / "lib" / "providers"
MEMORY_FILE = PROJECT_ROOT / "tools" / "coverage_progress.json"


def extract_provider_refs(content: str) -> set:
    """Extract provider names from ref.watch/read/listen calls."""
    pattern = r"ref\.(?:watch|read|listen)\(\s*(\w+Provider)"
    return set(re.findall(pattern, content))


def find_defining_file(provider_name: str, self_file: str) -> str | None:
    """
    Find which lib/providers/*.dart (non-generated) file defines a given provider.
    Strips 'Provider' suffix and searches for the matching function or class.
    """
    base = provider_name.removesuffix("Provider")
    if not base:
        return None
    capitalized = base[0].upper() + base[1:]

    # Patterns that identify the definition of a Riverpod provider
    search_terms = [
        rf"(?m)^(?:Future|Stream|[\w<>?]+)\s+{re.escape(base)}\s*\(",   # functional: T base(Ref ref)
        rf"class\s+_{re.escape(capitalized)}\b",                          # generated notifier base: class _CapName
        rf"class\s+{re.escape(capitalized)}\b",                           # public class: class CapName
    ]

    for dart_file in sorted(PROVIDERS_DIR.glob("*.dart")):
        if dart_file.name.endswith((".g.dart", ".freezed.dart")):
            continue
        if dart_file.name == self_file:
            continue  # skip self — intra-file providers are not external deps
        try:
            text = dart_file.read_text(encoding="utf-8", errors="replace")
        except OSError:
            continue
        for term in search_terms:
            if re.search(term, text):
                return dart_file.name
    return None


def main() -> None:
    if len(sys.argv) < 2:
        print("Usage: check_transitive_deps.py <provider_file.dart>", file=sys.stderr)
        sys.exit(1)

    provider_filename = Path(sys.argv[1]).name
    provider_file = PROVIDERS_DIR / provider_filename

    if not provider_file.exists():
        print(f"ERROR: {provider_file} not found", file=sys.stderr)
        sys.exit(1)

    try:
        memory = json.loads(MEMORY_FILE.read_text(encoding="utf-8"))
        providers_memory = memory.get("providers", {})
    except (OSError, json.JSONDecodeError) as exc:
        print(f"ERROR reading memory file: {exc}", file=sys.stderr)
        sys.exit(1)

    content = provider_file.read_text(encoding="utf-8", errors="replace")
    refs = extract_provider_refs(content)

    blocked_deps = []
    all_deps = []
    seen = set()

    for ref in sorted(refs):
        defining_file = find_defining_file(ref, provider_filename)
        if defining_file is None or defining_file in seen:
            continue
        seen.add(defining_file)

        all_deps.append(defining_file)
        entry = providers_memory.get(defining_file, {})
        if entry.get("status") == "blocked":
            blocked_deps.append(defining_file)

    print(json.dumps({"blocked_deps": blocked_deps, "all_deps": all_deps}, indent=2))


if __name__ == "__main__":
    main()
