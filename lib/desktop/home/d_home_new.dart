import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/home/listeners/portfolio_prices_listener.dart';
import 'package:sideswap/desktop/home/widgets/d_amp_wallet_assets_panel.dart';
import 'package:sideswap/desktop/home/widgets/d_regular_wallet_assets_panel.dart';
import 'package:sideswap/desktop/home/widgets/d_top_overview_toolbar.dart';
import 'package:sideswap/desktop/home/widgets/d_tx_and_orders_panel.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';

class DesktopHomeNew extends HookConsumerWidget {
  const DesktopHomeNew({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tetherAssetId = ref.watch(tetherAssetIdStateProvider);

    useEffect(() {
      ref.read(marketsProvider).subscribeIndexPrice(tetherAssetId);

      return;
    }, [tetherAssetId]);

    return const Stack(
      children: [
        PortfolioPricesListener(),
        Padding(
          padding: EdgeInsets.only(left: 16, right: 16, top: 16),
          child: Column(
            children: [
              DTopOverviewToolbar(),
              SizedBox(height: 16),
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(child: DRegularWalletAssetsPanel()),
                    SizedBox(width: 16),
                    Flexible(child: DAmpWalletAssetsPanel()),
                  ],
                ),
              ),
              SizedBox(height: 16),
              DTxAndOrdersPanel(),
            ],
          ),
        ),
      ],
    );
  }
}
