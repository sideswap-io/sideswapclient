import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/warmup_app_provider.dart';

class WarmupAppListener extends ConsumerWidget {
  const WarmupAppListener({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final warmupAsync = ref.watch(warmupAppProvider);

    return switch (warmupAsync) {
      AsyncValue(hasValue: true, value: WarmupAppState warmupState) => switch (
            warmupState) {
          WarmupAppStateInitialized() => () {
              logger.d('Warming done.');
              Future.microtask(
                () async {
                  await ref.read(walletProvider).startClient();
                },
              );
              return const SizedBox();
            }(),
          _ => () {
              logger.d('Warming up the app.');
              Future.microtask(
                () async {
                  await ref.read(warmupAppProvider.notifier).initializeApp();
                },
              );
              return const SizedBox();
            }(),
        },
      AsyncValue(isLoading: true) => const SizedBox(),
      _ => () {
          logger.d('Warmup error');
          throw Exception('Warmup error');
        }(),
    };
  }
}
