# ADR-0012 — The outputs payload is imported on desktop, and nowhere else

- **Status:** Accepted. Implemented by #237, open at the time of writing.
- **Date:** 2026-08-24
- **Driver:** the public report <https://github.com/sideswap-io/sideswapclient/issues/77>, filed 2026-08-23 against SideSwap 1.9.0 on iOS. It asks why scanning an outputs payload does nothing on mobile. #237 is the work ticket.
- **Scope:** where the outputs payload may enter the app, and what the app owes the user when it declines one. It does not touch the payload format.
- **Reviewed by:** one Codex adversarial pass over the triage brief — twelve numbered claims, each answered against source. Four were refuted and all four refutations were re-verified at their citations before this ADR was written. See [Review notes](#review-notes).

## Context

An **outputs payload** is a `sideswap_app` version `2` JSON document carrying a list of receivers. Importing one creates a single transaction that pays every receiver at once. Desktop imports it from a file, through the send dialog.

Commit `370a6ad2` (2024-03-26, `#SD-292 - multiple output qr code for mobile`, public PR #97) added a second entrance: the mobile QR scanner. It added the JSON fallback in the QR helper, the payload field on the scan result, the branch in the scanner widget, and the two listeners that act on it.

Commit `94519e85`, "Simplify send logic, fix peg-out ui on mobile", later moved the create-transaction outcome out of the wallet message handler and into the amount screen alone. The mobile scan path does not pass through that screen, so it lost its outcome and has been silent ever since.

### What the measurement showed

Mobile does not ignore an outputs payload today. It half-accepts one:

- the QR helper parses it and returns a scan result carrying it, with no error set;
- both mobile listeners call the outputs send helper, which sends a create-transaction message to the core;
- the reply is stored, and no mounted screen observes it.

So the user sees nothing while the app creates a transaction and leaves it behind. The second entrance has been broken for the whole time it has existed, and no user has ever completed a payment through it.

Two further defects were measured on the way:

- A payload whose `receivers` key is absent, `null`, or an empty list decodes as valid. The receiver list is then normalised to empty and a create-transaction message with zero addressees reaches the core. **This is reachable from the desktop file import**, which pops its dialog and opens the send popup on the empty result.
- The amount screen navigates to the confirmation screen whenever it observes a stored created transaction at build time, with no check of where that transaction came from. Nothing clears that value after a successful send. So one completed send, followed by any route that reaches the amount screen without passing the pay screen — the home panel scanner, a `/send/` link, an app2app link — re-opens the confirmation of the transaction that was already sent.

## Decisions

### 1. The outputs payload has one entrance, and it is the desktop import

Mobile does not accept an outputs payload, from the QR scanner or from anywhere else. The 2024 second entrance is removed rather than repaired. This is a scope decision, not a deferral: there is no mobile outputs feature waiting to be built.

### 2. A declined payload says where it works

Rejecting the payload silently would reproduce the reported symptom under a different mechanism. The scanner recognises a `sideswap_app` version `2` document and answers with a message that names the desktop import. Every other unrecognised QR keeps the generic invalid-code message.

The recognition is a local decode inside the QR helper. The scanner never writes to the outputs reader, which today it does as a side effect of any unparseable QR.

### 3. The mobile create-transaction outcome stays where it is

The alternative that #237 first specified was to give the outcome one owner again — the wallet message handler, where `94519e85` took it from — and to strip the navigation out of the amount screen. That rewrite existed to serve entry points that skip the amount screen. Decision 1 removes the only such entry point that had no outcome, so the rewrite buys nothing and is rejected.

### 4. Navigation is driven by a result arriving, never by a stored result being present

The amount screen observes the stored created transaction and navigates on it. That is what makes an abandoned or already-sent transaction replayable. The screen listens for the change instead, so a value that was stored before the screen mounted moves nothing.

This is the general rule, not a patch for one screen: a value that outlives the flow that produced it is not evidence that anybody is waiting for it. Screens that merely *render* the stored value — the confirmation popup — are unaffected, because rendering makes no such claim.

### 5. An empty receiver list is refused at decode, not at send

The guard belongs in the payload decoder, beside the existing type and version checks, so that both surfaces get it and the error reads like the other file errors. Putting it in the send helper would conflate the imported payload with the ordinary send flow, which builds its single receiver a different way.

## Consequences

- The public request is refused. The report is not answered as part of this work; that is a separate decision.
- A user who scans an outputs payload on mobile now gets a message instead of silence, in every one of the three scanner entrances — the pay screen address field, the home bottom panel, and the swap screen.
- One new translation key, in all nine locale files. Both `EasyLocalization` mounts fall back to `en`, so `en.json` is the mandatory one.
- Four JSON-shaped QR errors stop appearing on the scan path: `Wrong type of file`, `Wrong version of file`, `File structure error` and `Json file syntax error`. They describe a file. Nothing is lost, because none of them told a scanning user anything actionable.
- Decision 4 is a behaviour change for the amount screen that no current test covers, and its ordinary path is the mobile send flow. It carries its own tests.
- Decision 5 turns one existing test red on purpose: a desktop file-import case that supplies no `receivers` key and expects success. It becomes a rejection case.
- The scan result type loses its payload field. Two existing QR helper tests reference it and are rewritten with it.

## What this ADR does not settle

- **The payload format, its version, and its parser.** Untouched. Decision 5 adds a validity check; it changes no field.
- **Whether the desktop import should ever be joined by a mobile one.** Decision 1 answers today's question with today's product intent. Reopening it means amending this ADR, not filing an implementation issue.
- **Answering the public report.** A separate call.
- **The deprecated mobile outputs send helper.** Dead in production and still tested. Removing it is tracked by #238.

## Review notes

Findings from the Codex pass that **changed** the design, rather than confirming it. Each was re-verified at its citation.

- **The fallback block serves the whole URI branch, not just the JSON case.** The first draft called its replacement behaviour-preserving. It is not: the `try` it terminates begins at `Uri.parse` and covers the BIP21 and `sideswap:` parsing too. The message change is now stated as intended, not as a no-op.
- **The stale replay is not a race, and it survives decision 1.** The first draft held it out of scope as a narrow timing window that decision 1 would close. Nothing clears the created transaction after a successful send, and two link routes and the home panel scanner all reach the amount screen without passing the pay screen. Decision 4 exists because of this finding.
- **The receiver guard must refuse an explicit `null`, not only an absent key.** The generated decoder accepts both and normalises both to empty.
- **Three existing tests go red under the plan.** Two in the QR helper suite, one in the outputs suite. Named in #237 so they are updated rather than discovered.

## Related

- #237 — implements every decision here.
- #238 — removes the deprecated mobile outputs send helper this ADR leaves in place.
- <https://github.com/sideswap-io/sideswapclient/issues/77> — the public report. Refused by decision 1.
- `370a6ad2` — added the mobile entrance that decision 1 removes.
- `94519e85` — moved the create-transaction outcome to the amount screen, which is what decision 3 declines to undo and decision 4 corrects in place.
