import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/models/markets_provider.dart';
import 'package:sideswap/screens/markets/swap_market.dart';
import 'package:sideswap/screens/markets/token_market.dart';
import 'package:sideswap/screens/markets/widgets/empty_requests_page.dart';
import 'package:sideswap/screens/markets/widgets/filled_requests_page.dart';
import 'package:sideswap/screens/markets/widgets/market_type_buttons.dart';
import 'package:sideswap/screens/markets/widgets/markets_bottom_panel.dart';

class Markets extends ConsumerStatefulWidget {
  const Markets({
    Key? key,
    required this.onOrdersPressed,
    required this.onTokenPressed,
    required this.onSwapPressed,
    this.selectedMarketType = MarketSelectedType.orders,
  }) : super(key: key);

  final VoidCallback onOrdersPressed;
  final VoidCallback onTokenPressed;
  final VoidCallback onSwapPressed;
  final MarketSelectedType selectedMarketType;

  @override
  _MarketsState createState() => _MarketsState();
}

class _MarketsState extends ConsumerState<Markets> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 18.h, left: 16.w, right: 16.w),
              child: MarketTypeButtons(
                selectedType: widget.selectedMarketType,
                onOrdersPressed: widget.onOrdersPressed,
                onTokenPressed: widget.onTokenPressed,
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
            ] else if (widget.selectedMarketType ==
                MarketSelectedType.token) ...[
              const Flexible(child: TokenMarket()),
            ] else ...[
              const Flexible(child: SwapMarket()),
            ],
          ],
        );
      },
    );
  }
}
