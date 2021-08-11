import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/models/markets_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/markets/swap_market.dart';
import 'package:sideswap/screens/markets/token_market.dart';
import 'package:sideswap/screens/markets/widgets/empty_requests_page.dart';
import 'package:sideswap/screens/markets/widgets/filled_requests_page.dart';
import 'package:sideswap/screens/markets/widgets/market_type_buttons.dart';
import 'package:sideswap/screens/markets/widgets/markets_bottom_panel.dart';

class Markets extends StatefulWidget {
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

class _MarketsState extends State<Markets> {
  BuildContext? currentContext;

  @override
  void initState() {
    super.initState();
    currentContext = context.read(walletProvider).navigatorKey.currentContext;
  }

  @override
  void dispose() {
    // we can't use here context, because that widget could be outside tree
    if (currentContext != null) {
      currentContext!.read(marketsProvider).unsubscribeMarket();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 18.h, left: 16.w, right: 16.w),
              child: MarketTypeButtons(
                selectedType: widget.selectedMarketType,
                onOrdersPressed: () {
                  widget.onOrdersPressed();

                  context.read(marketsProvider).unsubscribeMarket();
                },
                onTokenPressed: () {
                  widget.onTokenPressed();

                  context.read(marketsProvider).subscribeTokenMarket();
                },
                onSwapPressed: () {
                  widget.onSwapPressed();
                },
              ),
            ),
            if (widget.selectedMarketType == MarketSelectedType.orders) ...[
              Consumer(
                builder: (context, watch, child) {
                  final requestOrders = watch(marketsProvider).getOwnOrders();

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
