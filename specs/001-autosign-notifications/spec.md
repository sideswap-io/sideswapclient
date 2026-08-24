# Feature Specification: Autosign for Connected Sites

**Feature Branch**: `001-autosign-notifications`  
**Created**: 2026-04-09  
**Status**: Draft  
**Input**: User description: "Add autosign checkbox to connected site sessions; auto-accept sign requests silently in background when enabled"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Enable Autosign for a Connected Site (Priority: P1)

A user has a connected site in their sessions list. They trust this site and want all future signing requests from it to be approved automatically without requiring manual interaction each time.

**Why this priority**: Core feature value — the primary capability users need to reduce friction with trusted sites.

**Independent Test**: Can be tested by connecting a site, enabling the autosign checkbox for it, then sending a sign request from that site and verifying it is accepted without any dialog or window activation.

**Acceptance Scenarios**:

1. **Given** a site is connected and autosign is disabled, **When** the user taps the autosign checkbox for that site, **Then** the checkbox shows as enabled and the preference is saved persistently.
2. **Given** autosign is enabled for a site, **When** the app is closed and reopened, **Then** autosign remains enabled for that site.
3. **Given** autosign is disabled for a site, **When** a sign request arrives from that site, **Then** the request is shown as a normal notification requiring user action.

---

### User Story 2 - Silent Background Auto-Accept of Sign Requests (Priority: P1)

When autosign is enabled for a site, incoming sign requests from that site are automatically accepted in the background. No notification appears, no window is brought to the foreground, and no user action is required.

**Why this priority**: Equal priority to P1 — this is the functional outcome of enabling autosign; without it the checkbox has no effect.

**Independent Test**: Can be tested by enabling autosign for a site and confirming that an incoming sign request from that site produces no visible notification and no window focus change, while the transaction is accepted on the network level.

**Acceptance Scenarios**:

1. **Given** autosign is enabled for a site, **When** a sign request arrives from that site, **Then** the request is accepted automatically with no notification added to the list.
2. **Given** autosign is enabled for a site, **When** a sign request is auto-accepted, **Then** the app window is NOT restored or shown (desktop: no window restore/show; mobile: no dialog opens).
3. **Given** autosign is enabled for a site, **When** multiple sign requests arrive in sequence, **Then** each is accepted silently and independently.

---

### User Story 3 - Autosign Setting Removed on Site Disconnect (Priority: P2)

When a site disconnects (session ends), its autosign setting is automatically removed from persistent storage. If the site reconnects in the future, autosign defaults to false again.

**Why this priority**: Data hygiene — prevents orphaned settings accumulating for sites the user no longer uses, and ensures fresh consent when a site reconnects.

**Independent Test**: Can be tested by enabling autosign for a site, disconnecting the site, then reconnecting it and verifying the autosign checkbox is unchecked.

**Acceptance Scenarios**:

1. **Given** autosign is enabled for a site, **When** that site disconnects (session removed), **Then** the autosign setting for that site is removed from persistent storage.
2. **Given** autosign was previously enabled for a site that disconnected, **When** the same site reconnects, **Then** the autosign checkbox is unchecked (default false).

---

### User Story 4 - Disable Autosign for a Connected Site (Priority: P2)

A user previously enabled autosign for a site but now wants to review signing requests manually again.

**Why this priority**: User control — users must be able to revoke autosign at any time.

**Acceptance Scenarios**:

1. **Given** autosign is enabled for a site, **When** the user unchecks the autosign checkbox, **Then** autosign is disabled and future sign requests from that site are shown as normal notifications.
2. **Given** autosign is disabled for a site, **When** a sign request arrives from that site, **Then** the request appears as a normal notification requiring manual approval.

---

### Edge Cases

- **Resolved**: Sign request while autosign is being toggled — read the per-site autosign preference **at processing start** (entry to the sign-request handling path that applies autosign), not at a fixed earlier receive instant, so behavior matches the preference current for that execution.
- **Resolved** — Multiple active sites simultaneously: autosign is per-site keyed by origin/domain; each sign request evaluated independently against its own site's setting. No cross-site interaction.
- **Out of scope** — Persistent storage unavailable when saving autosign preference: not handled.
- **Resolved** — Sign request domain does not match any active session: silently ignore (no response sent, no notification shown). Only sites with an approved active connection may send sign requests. If this guard is absent from current code, it must be added as part of this feature.
- **Resolved**: Sign requests with **multiple value components** — convert each to USDT; if any conversion fails or **any** component exceeds 100 USDT, use the **same** handling as autosign **off** (current code path); autosign only when every component converts and each is ≤ 100 USDT.
- **Resolved**: Autosign path required **unlock** but user **canceled** or **auth failed** — **drop/reject** the sign request; **no** normal notification (site may need to send a new request).

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The connected sessions list MUST display an "Autosign" checkbox for each connected site on both desktop and mobile.
- **FR-002**: The autosign preference MUST default to false (unchecked) for every site.
- **FR-003**: The autosign preference MUST be persisted per site (keyed by site domain) and survive app restarts.
- **FR-004**: When autosign is enabled for a site and a sign request arrives from that site, the system MUST evaluate **each outgoing value component** in the request — specifically each `recipients[]` entry and `networkFee`. `balances[]` represent full UTXO inputs (not transfer amounts) and MUST be excluded from the cap check. Each component MUST be converted to a USDT equivalent using the app's **current market-rate source at request time** (`portfolioPricesProvider`). If conversion **fails for any component** (e.g. rate unavailable, zero quantity, missing asset, or degenerate empty payload), the system MUST fall through using the **same code path and user-visible behavior** as when autosign is **disabled** for that site (current implementation) — including standard sign-request notification handling where applicable. If **any single** converted component is **greater than 100 USDT**, the system MUST fall through the same way. **No** autosign-specific UI (badges, banners, alternate notification types, or extra copy explaining autosign) MUST be added for these fall-through cases. When all components convert successfully and **each** is ≤ 100 USDT, the system MUST trigger wallet unlock if needed. **If the user cancels unlock or authentication fails**, the system MUST **drop** the sign request (no response sent to server) and MUST **NOT** add a normal notification. **After successful authentication**, the system MUST automatically accept the request; signing itself requires no additional action once authenticated. *(Note: explicit 60-second price staleness check was dropped — prices refresh every ~10 s via server timer, making the guard redundant in practice. Any price feed failure surfaces as missing/zero price and falls through correctly.)*
- **FR-004b**: User-configurable autosign limits are out of scope for this iteration.
- **FR-005**: When a sign request is auto-accepted, the system MUST NOT add it to the notification list.
- **FR-006**: When a sign request is auto-accepted on desktop, the system MUST NOT restore or show the application window.
- **FR-007**: When a site session ends (disconnect) **for any reason** (including user-initiated disconnect action, server-initiated disconnect, timeout, or network/session loss), the system MUST remove that site's autosign setting from persistent storage.
- **FR-008**: The user MUST be able to enable or disable autosign for any connected site at any time while the session is active.
- **FR-009**: Autosign state changes MUST be reflected immediately in the UI without requiring app restart.
- **FR-011**: The system MUST silently ignore (no response sent, no notification shown) any sign request whose origin/domain does not match an active approved session at the start of processing. Session active at processing start = authorized; any session disappearing during processing is treated as a race condition and the request proceeds. The system MUST emit an internal warning log entry (logger.w) when a request is silently ignored due to unknown origin. If this guard is not present in the current implementation, it MUST be added.
- **FR-012**: The system MUST emit `logger.w(...)` warning log entries for: (a) unknown-origin silent ignore, (b) auth-cancel/auth-failed autosign drop, (c) missing/ineligible price fallthrough (missing price, zero quantity, over-limit, or degenerate empty payload), (d) missing session on disconnect cleanup. No user-visible output for these events.
- **FR-010**: When deciding whether autosign applies to an incoming sign request, the system MUST read the per-site autosign preference **at the start of processing** that request (handler entry before autosign-specific logic). Once the autosign path is entered (preference was true at handler entry), it proceeds to completion regardless of any concurrent UI toggle — the toggle takes effect for the next incoming request only.

### Key Entities

- **AutosignSetting**: A per-site boolean flag (domain → enabled) stored persistently; default false; removed on any session disconnect (user-initiated or passive/server/network).
- **ConnectedSite**: An active session with a domain identifier and autosign state; shown in the sessions list on both platforms.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Users can enable or disable autosign for a connected site within 2 taps/clicks with no additional dialogs.
- **SC-002**: 100% of **eligible** sign requests from autosign-enabled sites (all value components convertible to USDT with each component ≤ 100 USDT) are accepted automatically without user interaction **beyond wallet unlock when required** (PIN/biometric per FR-004).
- **SC-003**: 0 notifications are shown or windows activated for auto-accepted sign requests.
- **SC-004**: Autosign settings persist correctly across app restarts.
- **SC-005**: 100% of autosign settings for disconnected sites are removed from storage upon session end.

## Assumptions

- Site domain is a stable, unique identifier — the same site always presents the same domain string across connections and sign requests.
- Autosign applies only to sign requests (NotificationTypeSignRequest), not to connection requests — connections always require explicit user approval.
- Auto-accepted sign requests are functionally identical to manually accepted ones from the network's perspective.
- Autosign is a per-device setting and is not synced across devices.
- No additional confirmation dialog is required when enabling autosign — the checkbox toggle is sufficient.
- The 100 USDT threshold applies **per value component** after USDT conversion (not as a single summed total unless the request exposes only one component). Non-USDT amounts use the app's **current market-rate source at request time** per component; if any component cannot be priced, autosign does not apply and the request uses the normal notification flow.
- User-configurable autosign limits are explicitly out of scope for this iteration.
- The 100 USDT hardcoded threshold is an initial conservative limit set by product decision for this iteration. Review and adjustment (including user-configurable limits) is planned for a future iteration.
- Session active at processing start is the authorization boundary; requests received during the brief window of session teardown are treated as authorized and processed normally.
- "Disconnect" includes both user-initiated disconnect and passive/server/network disconnect events.

## Clarifications

### Session 2026-04-09

- Q: What should happen when a sign request arrives for an autosign-enabled site but the wallet is locked/not authenticated? → A: Trigger wallet unlock/authentication flow first; **after successful auth**, auto-accept the sign request (subject to value/threshold rules). Unlock may require user interaction (PIN/biometric); signing itself is automatic once authenticated. **If the user cancels or authentication fails**, reject/drop the sign request **without** a normal notification (see next clarification).
- Q: When autosign would auto-accept after unlock but the user cancels PIN/biometric or authentication fails, should the sign request become a normal notification? → A: **No** — reject or drop the sign request and do **not** add it to the notification list.
- Q: Should autosign apply to all sign requests or only below a value threshold? → A: Only when every value component is at or below **100 USDT equivalent** after conversion (hardcoded limit for this iteration; see later clarification for conversion and multi-component rules). User-configurable limits deferred to a future iteration. If any component exceeds 100 USDT after conversion, fall through to normal notification requiring user interaction even when autosign is enabled.
- Q: How should non-USDT values and multi-component sign requests be evaluated against the 100 USDT autosign limit? → A: Use the app's current market-rate source at request time to convert **each** value component to USDT. If the rate is missing for any component, fall through to a normal notification. If **any** converted component exceeds 100 USDT, fall through to a normal notification. Autosign applies only when every component converts successfully and each is ≤ 100 USDT (then unlock if needed and auto-accept per prior clarification).
- Q: For autosign-setting cleanup, does "disconnect" include user-initiated disconnect (button) or only passive/server disconnect? → A: **All disconnects**. Any session end reason (user button, server-side termination, timeout, or network/session loss) removes the site's autosign setting; reconnect starts with autosign = false.
- Q: When autosign is enabled but a request is not eligible (e.g. any component > 100 USDT after conversion, or missing rate), what UX should appear versus autosign disabled? → A: **No autosign-specific notifications or UI**. Run the **same code path as when autosign is disabled** for that site (existing behavior today) — no extra banners, tags, or alternate notification types for "autosign skipped."
- Q: If a sign request is handled while the user is toggling autosign on/off, which preference wins? → A: Use autosign state **at processing start** (when the sign-request path that evaluates autosign begins), not pinned to arrival time only.
