import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/providers/currency_rates_provider.dart';

class ConversionRatesListener extends ConsumerWidget {
  const ConversionRatesListener({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(requestConversionRatesProvider, (previous, next) {});
    return const SizedBox();
  }
}
