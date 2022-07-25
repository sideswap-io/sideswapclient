import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/models/markets_provider.dart';
import 'package:sideswap/screens/markets/swap_market.dart';
import 'package:sideswap/screens/markets/widgets/empty_requests_page.dart';
import 'package:sideswap/screens/markets/widgets/filled_requests_page.dart';
import 'package:sideswap/screens/markets/widgets/market_type_buttons.dart';
import 'package:sideswap/screens/markets/widgets/markets_bottom_panel.dart';

class Markets extends ConsumerStatefulWidget {
  const Markets({
    super.key,
    required this.onOrdersPressed,
    required this.onSwapPressed,
    this.selectedMarketType = MarketSelectedType.swap,
  });

  final VoidCallback onOrdersPressed;
  final VoidCallback onSwapPressed;
  final MarketSelectedType selectedMarketType;

  @override
  MarketsState createState() => MarketsState();
}

class MarketsState extends ConsumerState<Markets> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 18, left: 16, right: 16),
              child: MarketTypeButtons(
                selectedType: widget.selectedMarketType,
                onOrdersPressed: widget.onOrdersPressed,
                onSwapPressed: widget.onSwapPressed,
              ),
            ),
            if (widget.selectedMarketType == MarketSelectedType.orders) ...[
              Consumer(
                builder: (context, ref, child) {
                  final requestOrders =
                      ref.watch(marketsProvider).getOwnOrders();

                  if (requestOrders.isEmpty) {
                    return const Flexible(child: EmptyRequestsPage());
                  }

                  return Flexible(
                      child: FilledRequestsPage(requests: requestOrders));
                },
              ),
              const MarketsBottomPanel(),
            ] else ...[
              const Flexible(child: SwapMarket()),
              const MarketsBottomBuySellPanel(),
            ],
          ],
        );
      },
    );
  }
}
