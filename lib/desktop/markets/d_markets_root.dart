import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/home/widgets/d_tx_and_orders_panel.dart';
import 'package:sideswap/desktop/main/d_charts.dart';
import 'package:sideswap/desktop/markets/widgets/market_order_panel.dart';
import 'package:sideswap/desktop/markets/widgets/orders_view.dart';
import 'package:sideswap/listeners/markets_page_listener.dart';
import 'package:sideswap/providers/chart_providers.dart';
import 'package:sideswap/providers/markets_provider.dart';

/// The height the order column is asked for before the history panel yields
/// any of its own: the market-type switch and the order form itself, which is
/// what a user reads and fills in at this size.
///
/// This is what the history panel gives *up to*, not a floor the column is
/// guaranteed. At the supported floor there is not enough page for both, the
/// history panel stops at [kTxAndOrdersPanelMinHeight], and the order column
/// takes what is left — more than it has today, and still less than this.
const double _marketOrderColumnMinHeight = 380;

class DMarkets extends HookConsumerWidget {
  const DMarkets({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chartsSubscriptionFlag = ref.watch(chartsSubscriptionFlagProvider);
    final showCharts =
        chartsSubscriptionFlag == ChartsSubscriptionFlagSubscribed();

    return Stack(
      children: [
        const MarketsPageListener(),
        Offstage(
          offstage: showCharts,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            // The history panel is the one that yields: it is capped at what
            // is left once the order column has its lower bound, so the two
            // share the shortfall instead of the order column absorbing all
            // of it. ADR-0014 decision 11.
            child: LayoutBuilder(
              builder: (context, constraints) {
                final txMaxHeight = txAndOrdersPanelMaxHeight(
                  available: constraints.maxHeight,
                  gap: kTxAndOrdersPanelGap,
                  companionMinHeight: _marketOrderColumnMinHeight,
                );
                return Column(
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
                                        chartsSubscriptionFlagProvider.notifier,
                                      )
                                      .subscribe();
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: kTxAndOrdersPanelGap),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: txMaxHeight),
                      child: const DTxAndOrdersPanel(onlyWorkingOrders: true),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        Consumer(
          builder: (context, ref, child) {
            final optionAssetPair = ref.watch(
              marketSubscribedAssetPairProvider,
            );

            if (!showCharts) {
              return SizedBox();
            }

            return optionAssetPair.match(
              () => SizedBox(),
              (assetPair) => DCharts(
                onBackPressed: () {
                  ref
                      .read(chartsSubscriptionFlagProvider.notifier)
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
