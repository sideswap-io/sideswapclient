import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/main/d_charts.dart';
import 'package:sideswap/desktop/markets/widgets/make_order_panel.dart';
import 'package:sideswap/desktop/markets/widgets/orders_panel.dart';
import 'package:sideswap/desktop/markets/widgets/working_orders.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/wallet_assets_provider.dart';

class DMarkets extends HookConsumerWidget {
  const DMarkets({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showCharts = useState(false);
    final selectedAssetId = ref.watch(marketSelectedAssetIdProvider);

    useEffect(() {
      final markets = ref.read(marketsProvider);

      return () {
        markets.unsubscribeIndexPrice();
        markets.unsubscribeMarket();
      };
    }, const []);

    useEffect(() {
      final selectedAsset = ref.read(assetsStateProvider)[selectedAssetId];
      final isProduct =
          ref.read(assetUtilsProvider).isProduct(asset: selectedAsset);
      if (isProduct) {
        ref.read(marketsProvider).subscribeIndexPrice(selectedAssetId);
        ref.read(marketsProvider).subscribeSwapMarket(selectedAssetId);
      } else {
        ref.read(marketsProvider).subscribeTokenMarket();
      }

      return;
    }, [selectedAssetId]);

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
          DCharts(
            assetId: selectedAssetId,
            onBackPressed: () {
              showCharts.value = false;
            },
          )
      ],
    );
  }
}
