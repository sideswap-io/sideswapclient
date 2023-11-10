import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/main/d_charts.dart';
import 'package:sideswap/desktop/markets/widgets/make_order_panel.dart';
import 'package:sideswap/desktop/markets/widgets/orders_panel.dart';
import 'package:sideswap/desktop/markets/widgets/working_orders.dart';
import 'package:sideswap/providers/markets_page_provider.dart';
import 'package:sideswap/providers/markets_provider.dart';

class DMarkets extends HookConsumerWidget {
  const DMarkets({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showCharts = useState(false);
    ref.listen(marketsPageListenerProvider, (_, __) {});

    return Stack(
      children: [
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
                const WorkingOrders(),
              ],
            ),
          ),
        ),
        if (showCharts.value)
          Consumer(
            builder: (context, ref, child) {
              final selectedAssetId =
                  ref.watch(marketSelectedAssetIdStateProvider);
              return DCharts(
                assetId: selectedAssetId,
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
