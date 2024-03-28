import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/providers/route_providers.dart';

class DesktopRouteListener extends ConsumerWidget {
  const DesktopRouteListener({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(desktopRoutePageProvider, (_, next) async {
      await next.mapStatus();
    });
    return const SizedBox();
  }
}
