# Data model: Autosign for connected sites

## Entity: AutosignSetting (logical)

| Field | Type | Rules |
|-------|------|--------|
| `domain` | `String` | Stable site identifier; key in maps and match target for `From_SignerRequest.origin` (FR-011 + session list). |
| `enabled` | `bool` | Default **false**; toggled only by user while session active. |

**Persistence:** Stored as **`Map<String, bool> autosignDomains`** on **`SideswapSettings`** (`config_provider.dart`), serialized to **`SharedPreferences`** as JSON (new string key, e.g. `autosign_domains`), following patterns like `stokrSettingsModel`.

**Relationships:**

- **ConnectedSite / `SwaptionSession`:** Runtime list from server; `domain` + `sessionId`. Autosign map is keyed by **`domain`** only (per spec: per-site by domain).
- **Sign request:** `From_SignerRequest.origin` must match an active session domain before autosign or normal notification (FR-011).

## State transitions (AutosignSetting per domain)

```text
[implicit default] enabled=false (key absent)
       │ user checks Autosign in UI
       ▼
   enabled=true (persisted)
       │ user unchecks OR sessionRemoved for that domain
       ▼
   key removed from map (false implicit)  ← FR-007 / FR-003
```

**Session disconnect (any cause):** Remove entry for that session’s **domain** (resolve domain via `swaptionSessionProvider` **before** `removeSessions`, using `sessionId` from `From_SessionRemoved`).

**App restart:** Map reloaded from prefs; domains with no active session may still exist briefly if sessions sync later — optional hygiene: UI only shows autosign for **current** sessions; **implementation may** prune orphan keys on `replaceSessions` / session list sync (out of spec strict minimum: cleanup on **sessionRemoved** is mandatory).

## Configuration fields (concrete)

| Location | Field | Type |
|----------|-------|------|
| `SideswapSettings` | `autosignDomains` | `Map<String, bool>` default `{}` |
| `SharedPreferences` | new constant key | JSON object string `{"domain.example": true, ...}` |

## Validation (from requirements)

- FR-002: default false → absent key = false.
- FR-003: persist per domain across restarts.
- FR-007 / FR-005 / FR-006: enforced in wallet + notification paths, not in map structure.
- FR-004: threshold and conversion — **not** stored; computed at request time from `From_SignerRequest_Sign` + `portfolioPricesProvider`.

## Derived / ephemeral (not persisted)

- **Autosign eligibility for one request:** function of current `autosignDomains[origin]`, active sessions, `From_SignerRequest_Sign` components, current `pricesUsd`, unlock outcome — no separate DB row.
