import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/listeners/markets_page_listener.dart';
import 'package:sideswap/providers/markets_provider.dart';

import 'package:sideswap/screens/markets/swap_market.dart';
import 'package:sideswap/screens/markets/widgets/market_type_buttons.dart';
import 'package:sideswap/screens/markets/widgets/markets_bottom_panel.dart';
import 'package:sideswap/screens/markets/widgets/working_orders_empty.dart';
import 'package:sideswap/screens/markets/widgets/working_orders_list.dart';

class Markets extends HookConsumerWidget {
  const Markets({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMarketTypeButton = ref.watch(
      selectedMarketTypeButtonNotifierProvider,
    );

    return Column(
      children: [
        MarketsPageListener(),
        ColoredBox(
          color: SideSwapColors.chathamsBlue,
          child: Padding(
            padding: EdgeInsets.only(top: 18, left: 16, right: 16, bottom: 12),
            child: MarketTypeButtons(),
          ),
        ),
        ...switch (selectedMarketTypeButton) {
          SelectedMarketTypeButtonEnum.swap => [
            Flexible(child: SwapMarket()),
            MarketsBottomButtonsPanel(),
          ],
          SelectedMarketTypeButtonEnum.orders => [
            SizedBox(),
            Consumer(
              builder: (context, ref, child) {
                final ownOrders = ref.watch(marketOwnOrdersNotifierProvider);

                return switch (ownOrders.isEmpty) {
                  true => Flexible(child: WorkingOrdersEmpty()),
                  _ => Flexible(child: WorkingOrdersList()),
                };
              },
            ),
          ],
        },
      ],
    );
  }
}
