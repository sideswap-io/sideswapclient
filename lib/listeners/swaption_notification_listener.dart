import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/providers/notification_removal_reason.dart';
import 'package:sideswap/providers/notifications_provider.dart';
import 'package:sideswap/screens/swaption/swaption_dialogs.dart';

/// Presents Liquid Connect requests on mobile, one at a time and oldest first.
///
/// A request that arrives while a dialog is open joins the pending set and
/// waits there — it is not held anywhere else, so everything read off that set
/// keeps counting it — and is presented once the current request has been
/// resolved, however it was resolved. ADR-0006 decision 5.
class SwaptionNotificationListener extends HookConsumerWidget {
  const SwaptionNotificationListener({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watched rather than read so an arrival while nothing is on screen starts
    // the loop below. A *later* arrival does not change this answer at all —
    // the oldest request is still the oldest — so nothing has to guard against
    // it repointing an open dialog.
    final optionNext = ref.watch(nextPendingRequestProvider);

    // Held rather than kept in state: it gates the loop and a rebuild is not
    // wanted for it.
    final presenting = useRef(false);

    useEffect(() {
      if (optionNext.isNone() || presenting.value) {
        return null;
      }

      // Set before the first await, so two effect runs in one frame cannot both
      // start a loop.
      presenting.value = true;

      // Deferred because this runs inside the build phase, and the navigator
      // may not be mutated from there.
      Future.microtask(() async {
        try {
          while (true) {
            // Re-checked at the top of every turn: each one comes after the
            // previous turn's dialog was awaited.
            if (!context.mounted) {
              return;
            }

            final next = ref.read(nextPendingRequestProvider).toNullable();

            // Read and returned from without an await in between, so nothing
            // can join the queue between finding it empty and releasing the
            // guard below.
            if (next == null) {
              return;
            }

            final notificationId = next.id;
            final reqId = next.type.reqId;

            // A race guard, not a countdown. The notifier sweeps an expired
            // request out of the pending set whether or not anything is
            // watching (ADR-0010 decision 1), but it does so on a timer
            // callback whose delay is unbounded under load. In the gap between
            // the deadline passing and that fire, `nextPendingRequest` still
            // answers with the entry, and presenting it would produce the
            // dialog too brief to read or dismiss that ADR-0006 decision 5
            // exists to prevent. ADR-0010 decision 6.
            if (requestDeadlinePassed(next, now: DateTime.now())) {
              ref
                  .read(notificationsProvider.notifier)
                  .removeNotification(
                    notificationId,
                    reason: NotificationRemovalReason.expired,
                  );
              continue;
            }

            // Both parts of the identity are fixed here, at the moment the
            // dialog is decided on: the id alone is an arrival counter, and a
            // bare integer is not an identity (#211).
            await showDialog<void>(
              context: context,
              barrierDismissible: false,
              builder: (_) =>
                  SwaptionDialog(notificationId: notificationId, reqId: reqId),
            );

            if (!context.mounted) {
              return;
            }

            // The safety net, and only that: what a resolution *was* is recorded
            // by the path that performed it, before its window goes. So a
            // window found closed over a request that is still pending was
            // closed by nothing that spoke for the user — record a rejection,
            // and never read the value the window closed with, which goes to
            // whatever route is on top. ADR-0006 decision 4.
            if (ref
                .read(pendingRequestProvider(notificationId, reqId))
                .isSome()) {
              ref
                  .read(notificationsProvider.notifier)
                  .removeNotification(
                    notificationId,
                    reason: NotificationRemovalReason.rejectedByUser,
                  );
            }
          }
        } finally {
          presenting.value = false;
        }
      });

      return null;
    }, [optionNext]);

    return Container();
  }
}
