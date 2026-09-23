# ADR-0017 — A refused settings write ends the persist round, and the cache is reloaded from the store

Issue: #285. Extends the write-order reasoning in the comments on `Configuration.activatePinProtection` and `deactivatePinProtection`.

## Context

`Configuration` persists every state change as one *persist round*: `_writeSettings` rewrites every key in one fixed order, and `_saveSettings` queues each round behind the previous one. Two failure modes exist at the store boundary. A platform write can return `false` (`shared_preferences_windows` catches the I/O error and returns `false`; Android returns the result of `commit()`), and a platform call can throw. Today every `_setX` helper discards the `false`, and one throw kills the queue for the notifier's lifetime.

Three facts constrain the answer.

### The blob and the flag are written in one round, blob first

`_setPinData` writes the four blob keys, then `_writeSettings` writes the flag. A round that continues past a refused blob write raises the flag over a blob that is not whole. Measured on a probe against the current code, fresh store, `false` on the salt key: flag `true`, blob empty. That is the *wallet-losing state*.

### The facade updates its cache before the platform answers

`shared_preferences` 2.5.5 sets `_preferenceCache[key] = value` and then calls the platform (`shared_preferences_legacy.dart:173-186`). The cache holds the new value after a `false` and after a throw alike. `_setPinData` skips an unchanged blob by comparing the new blob with `prefs.getString(...)`, which reads the cache. After a failed blob write the next round therefore skips the blob and writes the flag. The disk ends with a partial blob under a raised flag. This is a latent defect in today's throw path, not one this change introduces. `SharedPreferences.reload()` replaces the cache with the platform store (`shared_preferences_legacy.dart:223-228`).

### On Windows a refused write is a refused file

Every `setX` and `remove` on Windows reads the JSON file, changes one key and rewrites the whole file (`shared_preferences_windows` 2.4.1). A `false` on one key means the file did not change. Continuing the round with the remaining keys buys nothing on that platform.

## Decisions

### 1. A `false` from the store ends the persist round

The store is wrapped in a decorator at one line in `_saveSettings`. The decorator logs the key and raises an error when a write returns `false`. The error handler on the queue logs the error and resolves, so the next round runs. Both failure modes take one path. The issue text asked for the round to continue past a `false`. That reading was withdrawn: it cannot hold beside the invariant on the *PIN record*.

### 2. After a failed write the decorator reloads the cache from the store

On `false` and on a throw the decorator awaits `reload()` before it raises. The cache then matches the disk, the blob skip guard compares against the disk, and the next round rewrites the blob. No `_setX` helper body changes.

### 3. The invariant is proven for the two reachable starting states

Enabling from a lowered flag, and disabling from a raised flag. A new blob under a standing flag (rekey) has no entrance from the UI: both settings screens open PIN setup only when PIN is off, and the other entrances are the new-wallet and import flows. A failure inside the blob under a standing flag leaves a mixed blob for the length of one round. Removing that window needs a different write order, which #285 rules out. The test names the case and leaves it unprotected.

### 4. The test double models the cache and the disk apart

`FakeSharedPreferences` holds two maps. A failed write updates the cache and leaves the disk. `reload()` copies the disk into the cache. `snapshot` reads the disk. A fake with one map proves a repair that the real facade does not deliver.

## Considered options

- Continue the round past a `false`, as the issue text asked. Rejected: it raises the flag over a partial blob.
- End the round only for the PIN keys. Rejected: a second path for one key group, and no gain on Windows.
- Drop the skip guard in `_setPinData`. Rejected: it changes a helper body, and it adds four whole-file writes per round on Windows.

## Consequences

- `deleteConfig` no longer reports a write failure to its caller.
- A refused write costs one platform read.
- A rekey under a standing flag stays unprotected against a failure inside the blob. A write-order change for that case is a separate issue.

### A re-read that fails leaves the cache ahead of the disk

The decorator's repair for the cache is `reload()`, and `reload()` goes through the platform that has just refused a write. The two fail together. When the re-read fails the decorator logs it and still raises the refusal, so the round ends on the fault that names the key — but the cache keeps the value the disk never took.

The case that costs something is a refused write on the last blob key while enabling. The three keys before it are on the disk and in the cache; the fourth is in the cache only. With no repair, the next round reads a whole blob out of the cache, `_setPinData` skips it, and the flag goes up over a blob the disk holds without its `hmac`.

Repairing it needs a marker that outlives one round, and the decorator is built fresh inside `_saveSettings` on every round, so it has nowhere to keep one. A decorator with a lifetime is a different design and a separate issue.

### A refusal spanning both disable rounds is a new gap

`deactivatePinProtection` makes two state changes in one synchronous turn, so both rounds are on the queue before the first one runs. Round one lowers the flag; round two drops the blob. Round two is safe *only* because round one landed the lowered flag on the disk.

The queue's error handler removes what used to enforce that. A rejected `_pendingSave` skipped round two; a resolved one runs it. So a refusal that hits the flag key in both rounds — one file lock outliving one round, which on Windows is tens of milliseconds — now ends with the blob removed under a flag that is still up. That is the *wallet-losing state*.

For a `false` from the store this is not new: every `_setX` discarded the boolean, so round one completed and round two removed the blob anyway. For a **throw** it is new, and it is the price of the queue surviving a throwing round at all. Without it, one throw loses every later settings change for the lifetime of the notifier.

Nothing inside the fence of #285 repairs it. A `_setPinData` that refuses to clear the blob while the flag stands on the disk changes a `_setX` body; a disable path that lowers the flag before it clears the blob changes the write order; sequencing round two behind round one needs a `_saveSettings` that reports failure, which this ADR removes. All three are separate issues. `test/providers/config_provider_refused_write_test.dart` asserts today's behaviour, so a later write-order change turns those tests red.
