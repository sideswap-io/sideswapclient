import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/providers/notification_removal_reason.dart';
import 'package:sideswap/providers/notifications_provider.dart';
import 'package:sideswap/screens/swaption/swaption_dialogs.dart';

class SwaptionNotificationListener extends HookConsumerWidget {
  const SwaptionNotificationListener({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationsProvider);
    final optionShowNotificationMenu = ref.watch(showNotificationMenuProvider);

    useEffect(() {
      optionShowNotificationMenu.match(() {}, (notificationId) {
        final notificationData = notifications.firstWhereOrNull(
          (e) => e.id == notificationId,
        );
        if (notificationData != null &&
            notificationData.type.notificationItemState !=
                NotificationItemStateCanceled()) {
          Future.microtask(() async {
            if (context.mounted) {
              final accepted = await showDialog<bool>(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return SwaptionDialog();
                },
              );

              // A dialog that closed without saying so is treated as a
              // rejection: never claim the user accepted something.
              ref
                  .read(notificationsProvider.notifier)
                  .removeNotification(
                    notificationId,
                    reason: accepted == true
                        ? NotificationRemovalReason.acceptedByUser
                        : NotificationRemovalReason.rejectedByUser,
                  );
            }
          });
        }
      });

      return;
    }, [notifications, optionShowNotificationMenu]);

    return Container();
  }
}
