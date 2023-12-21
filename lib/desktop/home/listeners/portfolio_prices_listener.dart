import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/providers/portfolio_prices_providers.dart';

class PortfolioPricesListener extends ConsumerWidget {
  const PortfolioPricesListener({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(requestPortfolioPricesProvider, (previous, next) {});
    return const SizedBox();
  }
}
