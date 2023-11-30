import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/providers/request_order_provider.dart';

class OrderReviewTwoStepListener extends ConsumerWidget {
  const OrderReviewTwoStepListener({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(orderReviewTwoStepProvider, (_, next) {
      final ttl = ref.read(orderReviewTtlProvider);
      final ttlChanged = ref.read(orderReviewTtlChangedFlagProvider);

      final newTtl = switch (next) {
        true when !ttlChanged => kInfTtl,
        false when ttl == kInfTtl => kOneWeek,
        _ => ttl,
      };

      ref.read(orderReviewTtlProvider.notifier).setTtl(newTtl);
    });
    return const SizedBox();
  }
}

class OrderReviewTtlChangedFlagListener extends ConsumerWidget {
  const OrderReviewTtlChangedFlagListener({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(orderReviewTtlChangedFlagProvider);
    return const SizedBox();
  }
}
