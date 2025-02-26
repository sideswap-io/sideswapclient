import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/home/widgets/d_tx_and_orders_panel.dart';
import 'package:sideswap/desktop/main/d_charts.dart';
import 'package:sideswap/desktop/markets/widgets/market_order_panel.dart';
import 'package:sideswap/desktop/markets/widgets/orders_view.dart';
import 'package:sideswap/listeners/markets_page_listener.dart';
import 'package:sideswap/providers/chart_providers.dart';
import 'package:sideswap/providers/markets_provider.dart';

class DMarkets extends HookConsumerWidget {
  const DMarkets({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chartsSubscriptionFlag = ref.watch(
      chartsSubscriptionFlagNotifierProvider,
    );
    final showCharts =
        chartsSubscriptionFlag == ChartsSubscriptionFlagSubscribed();

    return Stack(
      children: [
        const MarketsPageListener(),
        Offstage(
          offstage: showCharts,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const MarketOrderPanel(),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: OrdersView(
                            onChartsPressed: () {
                              ref
                                  .read(
                                    chartsSubscriptionFlagNotifierProvider
                                        .notifier,
                                  )
                                  .subscribe();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const DTxAndOrdersPanel(onlyWorkingOrders: true),
              ],
            ),
          ),
        ),
        Consumer(
          builder: (context, ref, child) {
            final optionAssetPair = ref.watch(
              marketSubscribedAssetPairNotifierProvider,
            );

            if (!showCharts) {
              return SizedBox();
            }

            return optionAssetPair.match(
              () => SizedBox(),
              (assetPair) => DCharts(
                onBackPressed: () {
                  ref
                      .read(chartsSubscriptionFlagNotifierProvider.notifier)
                      .unsubscribe();
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
