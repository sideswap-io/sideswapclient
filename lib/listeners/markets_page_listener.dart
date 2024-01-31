import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/utils/use_async_effect.dart';
import 'package:sideswap/providers/markets_provider.dart';

class MarketsPageListener extends HookConsumerWidget {
  const MarketsPageListener({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedAccountAsset =
        ref.watch(marketSelectedAccountAssetStateProvider);

    useAsyncEffect(() async {
      ref.read(marketAssetSubscriberNotifierProvider.notifier).unsubscribeAll();

      if (selectedAccountAsset.assetId != null) {
        ref
            .read(indexPriceSubscriberNotifierProvider.notifier)
            .subscribeOne(selectedAccountAsset.assetId!);

        ref
            .read(marketAssetSubscriberNotifierProvider.notifier)
            .subscribe(selectedAccountAsset.assetId!);
      } else {
        ref
            .read(indexPriceSubscriberNotifierProvider.notifier)
            .unsubscribeAll();
      }

      return;
    }, [selectedAccountAsset]);

    return const SizedBox();
  }
}
