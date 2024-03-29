import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/home/widgets/d_tx_and_orders_panel.dart';
import 'package:sideswap/desktop/main/d_charts.dart';
import 'package:sideswap/desktop/markets/widgets/make_order_panel.dart';
import 'package:sideswap/desktop/markets/widgets/orders_panel.dart';
import 'package:sideswap/listeners/markets_page_listener.dart';
import 'package:sideswap/providers/markets_provider.dart';

class DMarkets extends HookConsumerWidget {
  const DMarkets({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showCharts = useState(false);

    return Stack(
      children: [
        const MarketsPageListener(),
        Offstage(
          offstage: showCharts.value,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const MakeOrderPanel(),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: OrdersPanel(
                            onChartsPressed: () {
                              showCharts.value = true;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const DTxAndOrdersPanel(
                  onlyWorkingOrders: true,
                ),
              ],
            ),
          ),
        ),
        if (showCharts.value)
          Consumer(
            builder: (context, ref, child) {
              final selectedAccountAsset =
                  ref.watch(marketSelectedAccountAssetStateProvider);
              return DCharts(
                assetId: selectedAccountAsset.assetId,
                onBackPressed: () {
                  showCharts.value = false;
                },
              );
            },
          )
      ],
    );
  }
}
