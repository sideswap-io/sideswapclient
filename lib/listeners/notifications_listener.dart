import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/providers/notifications_provider.dart';

class NotificationsListener extends HookConsumerWidget {
  const NotificationsListener({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(notificationsProvider, (_, next) {});

    return Container();
  }
}
