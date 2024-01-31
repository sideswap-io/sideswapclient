import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/utils/use_async_effect.dart';
import 'package:sideswap/listeners/markets_page_listener.dart';

import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/screens/markets/swap_market.dart';
import 'package:sideswap/screens/markets/widgets/empty_requests_page.dart';
import 'package:sideswap/screens/markets/widgets/filled_requests_page.dart';
import 'package:sideswap/screens/markets/widgets/market_type_buttons.dart';
import 'package:sideswap/screens/markets/widgets/markets_bottom_panel.dart';

class Markets extends HookConsumerWidget {
  const Markets({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMarketTypeButton =
        ref.watch(selectedMarketTypeButtonNotifierProvider);

    useAsyncEffect(() async {
      (switch (selectedMarketTypeButton) {
        SelectedMarketTypeButtonEnum.orders => () {
            ref
                .read(indexPriceSubscriberNotifierProvider.notifier)
                .unsubscribeAll();
          }(),
        _ => () {}(),
      });
      return;
    }, [selectedMarketTypeButton]);

    return Column(
      children: [
        const MarketsPageListener(),
        const ColoredBox(
          color: SideSwapColors.chathamsBlue,
          child: Padding(
            padding: EdgeInsets.only(top: 18, left: 16, right: 16),
            child: MarketTypeButtons(),
          ),
        ),
        ...switch (selectedMarketTypeButton) {
          SelectedMarketTypeButtonEnum.swap => [
              const Flexible(child: SwapMarket()),
              const MarketsBottomBuySellPanel(),
            ],
          SelectedMarketTypeButtonEnum.orders => [
              Consumer(
                builder: (context, ref, child) {
                  final ownRequestOrders =
                      ref.watch(marketOwnRequestOrdersProvider);

                  return switch (ownRequestOrders.isEmpty) {
                    true => const Flexible(child: EmptyRequestsPage()),
                    _ => Flexible(
                        child: FilledRequestsPage(requests: ownRequestOrders)),
                  };
                },
              ),
            ],
        },
      ],
    );
  }
}
