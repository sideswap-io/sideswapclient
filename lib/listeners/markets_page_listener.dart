import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/providers/markets_page_provider.dart';

class MarketsPageListener extends ConsumerWidget {
  const MarketsPageListener({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Consumer(
      builder: (context, ref, child) {
        ref.watch(marketsPageListenerProvider);
        return const SizedBox();
      },
    );
  }
}
