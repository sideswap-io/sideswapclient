import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/screens/markets/widgets/empty_requests_page.dart';
import 'package:sideswap/screens/markets/widgets/filled_requests_page.dart';
import 'package:sideswap/screens/markets/widgets/markets_bottom_panel.dart';
import 'package:sideswap/screens/markets/widgets/new_market_type_buttons.dart';

class Markets extends StatelessWidget {
  const Markets({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 18),
        const MarketTypeButtons(),
        Consumer(
          builder: (context, ref, _) {
            final selectedMarketType = ref.watch(selectedMarketTypeProvider);
            final ownRequestOrders = ref.watch(marketOwnRequestOrdersProvider);

            return switch (selectedMarketType) {
              SelectedMarketTypeEnum.orders => () {
                  if (ownRequestOrders.isEmpty) {
                    return const Flexible(child: EmptyRequestsPage());
                  }

                  return Flexible(
                    child: FilledRequestsPage(requests: ownRequestOrders),
                  );
                }(),
              _ => const SizedBox(),
            };
          },
        ),
        const MarketsBottomPanel(),
      ],
    );
  }
}
