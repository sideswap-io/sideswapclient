import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/providers/notification_removal_reason.dart';
import 'package:sideswap/providers/notifications_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

part 'signer_acceptance_provider.g.dart';

/// The acceptance attempts currently in flight, by request id.
///
/// An *acceptance attempt* — the acceptance gate, the pending re-check, the
/// send and the record — belongs to the request it answers, not to the widget
/// the press came from. Once the gate is crossed no widget is a party to the
/// outcome: an approval control that is unmounted, recreated or repurposed
/// mid-authentication changes nothing about the attempt it started.
/// ADR-0009 decisions 1 and 2.
///
/// The state is the set of request ids with an attempt outstanding. An approval
/// control renders busy by watching this set for **its own** request id, which
/// is why an element repurposed to another request shows that request's state
/// rather than the previous one's.
///
/// The lifetime is a contract rather than a framework guarantee, and each
/// clause below is load-bearing — ADR-0009 decision 3:
///
/// - It is `keepAlive` because the last watcher going away is precisely the
///   event this notifier defends against. An autodisposed guard would be
///   discarded at the moment it is needed and rebuilt empty.
/// - **Nothing invalidates it.** Not [Notifications.clearAll], which
///   invalidates only [notificationsProvider]; not a wallet reset, which resets
///   neither. Anyone adding an invalidation is changing this decision and must
///   say what happens to an attempt that is at the gate when it lands.
/// - **[build] watches nothing.** `ref.mounted` goes false when a rebuild
///   replaces the `Ref`, and a rebuild follows any watched dependency changing,
///   so a notifier that watched the notification list would invalidate its own
///   in-flight attempt every time a request arrived. Every collaborator is read
///   inside [accept]. Others watching *this* notifier are inbound listeners and
///   rebuild nothing here.
@Riverpod(keepAlive: true)
class SignerAcceptance extends _$SignerAcceptance {
  @override
  Set<String> build() {
    return const <String>{};
  }

  /// Accepts the request [reqId] shown by the entry [notificationId], unless an
  /// attempt for that request id is already running.
  ///
  /// Returns nothing the caller acts on. A returned outcome would restore the
  /// dependency this notifier removes — "for the UI to react, the element must
  /// survive the await" — so the rule is without exception: once the gate is
  /// crossed, the widget is no longer a party. ADR-0009 decision 2.
  Future<void> accept({
    required int notificationId,
    required String reqId,
  }) async {
    // Outside the `try`, and before the record: a refused second press must not
    // run the `finally` that releases the first attempt's guard. Identity is
    // the request id and not the pair, because one acceptance answers one wire
    // request and the local id is an arrival counter carrying no identity of
    // its own (#211).
    // ADR-0009 decision 1.
    if (state.contains(reqId)) {
      return;
    }

    // Recorded synchronously, before the first await, so a second press in the
    // same turn is refused even though the rebuild that disables the control
    // has not landed yet. Reassigned rather than mutated: adding to the same
    // `Set` instance would not notify, and the busy state would never reach the
    // control.
    state = {...state, reqId};

    try {
      if (!await _gateAllows(reqId)) {
        return;
      }

      // The order is pinned — ADR-0006 decision 2, kept by ADR-0009 decision 2
      // with its first step re-pointed: liveness, then identity, then state.
      // Liveness first because reading through a disposed `ref` throws exactly
      // in the case the re-check exists to handle. What is gone is not the
      // guard but its coupling to a list element: a notification item
      // unmounting is no longer one of the things that can fail it.
      if (!ref.mounted) {
        return;
      }

      // A separate case: the notifier is still there, but the request it was
      // asked about is gone, cancelled, or has been replaced. The gate is an
      // ordinary route with the request's timers running underneath it, so the
      // request can be withdrawn or expire while it is up. Asked of
      // [pendingRequestProvider], which already answers ADR-0006 decision 2's
      // identity-and-state question and is what mobile has always used — a
      // read, not a subscription.
      if (ref.read(pendingRequestProvider(notificationId, reqId)).isNone()) {
        return;
      }

      // One synchronous block: `sendMsg` is `void`, so an await opened between
      // the send and the record would let an acceptance reach the origin
      // unrecorded. ADR-0006 decision 4.
      final msg = To();
      msg.signerResponse = To_SignerResponse(reqId: reqId, accept: true);
      ref.read(walletProvider).sendMsg(msg);

      ref
          .read(notificationsProvider.notifier)
          .removeNotification(
            notificationId,
            reason: NotificationRemovalReason.acceptedByUser,
          );
    } finally {
      // Released on every outcome — after a failed gate the request is still
      // pending and its control usable again. Nothing else clears it: not a
      // removal from the list, not a collapse, not the list notifier being
      // invalidated underneath it.
      //
      // The liveness guard is not an exception to that. A torn-down container
      // abandons the attempt whatever the `keepAlive`, and writing `state`
      // through a disposed notifier throws — out of a future nobody awaits.
      if (ref.mounted) {
        state = {...state}..remove(reqId);
      }
    }
  }

  /// The acceptance gate, with a gate that throws treated as one that failed.
  ///
  /// [SideswapWallet.isAuthenticated] is a `Future<bool>` with no non-throwing
  /// guarantee: it crosses a platform channel for biometrics and a decryption
  /// for the fallback, and not every failure there is converted to a result.
  /// Letting the error propagate would surface it as an unhandled asynchronous
  /// error — [accept] is deliberately unawaited — while the control stayed busy
  /// for a request that is still pending. Nothing is sent and nothing is closed
  /// either way, so the observable outcome is the one ADR-0006 decision 6
  /// already specifies for a user who dismissed their own prompt.
  /// ADR-0009 decision 6.
  Future<bool> _gateAllows(String reqId) async {
    try {
      return await ref.read(walletProvider).isAuthenticated();
    } catch (e) {
      logger.e('acceptance gate threw for request $reqId: $e');
      return false;
    }
  }
}
