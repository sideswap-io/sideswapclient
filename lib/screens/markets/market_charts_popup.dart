import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/providers/chart_providers.dart';
import 'package:sideswap/screens/markets/market_charts.dart';

class MarketChartsPopup extends HookConsumerWidget {
  const MarketChartsPopup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final popupCallback = useCallback(() {
      ref.read(chartsSubscriptionFlagNotifierProvider.notifier).unsubscribe();
      Navigator.of(context).pop();
    });

    return SideSwapScaffold(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          popupCallback();
        }
      },
      appBar: CustomAppBar(
        title: 'Chart'.tr(),
        onPressed: () {
          popupCallback();
        },
      ),
      body: SafeArea(
        child: MarketCharts(
          onBackPressed: () {
            popupCallback();
          },
        ),
      ),
    );
  }
}
