# docs-mcp-server Usage

All subagents (Writer, Reviewer, Diagnoza, Fix, Simplify) MUST use docs-mcp-server as PRIMARY documentation source — don't guess, don't read raw package source files from Pub/Cache.

## Tools

- `search_docs` — search indexed documentation. Use FIRST for any API lookup, pattern verification, or example search. Fall back to reading source only if docs-mcp returns nothing useful.
- `WebFetch` — when search returns a URL but not enough detail, use with a specific question to extract only what's needed (fewer tokens than full page).
- `list_libraries` — get current list of indexed libraries (don't hardcode — libraries change).

## Mandatory Verification: Override Methods

Before writing ANY Riverpod override (`overrideWith`, `overrideWithValue`, `overrideWithBuild`), search docs-mcp-server for the exact method and its signature for the specific provider type being overridden. Include the search query and result in your reasoning. Guessing override APIs is the #1 source of compilation errors.

**CAVEAT: `overrideWithBuild` signature.** The docs show `(ref)` but the actual typedef is `RunNotifierBuild<NotifierT, CreatedT> = CreatedT Function(Ref ref, NotifierT notifier)` — always use two arguments: `(ref, notifier) => value`.

## Topics

Riverpod, Flutter test, mocktail.

## Indexed Projects (use as code reference)

- **sideswap** — this project's source
- **stableapp** — very similar app; search it for algorithmic test solutions when stuck on a sideswap provider pattern
