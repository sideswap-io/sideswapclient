import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/utils/market_helpers.dart';
import 'package:sideswap/desktop/common/button/d_hover_button.dart';
import 'package:sideswap/desktop/markets/widgets/orders_header.dart';
import 'package:sideswap/desktop/markets/widgets/orders_row.dart';
import 'package:sideswap/desktop/markets/widgets/working_order.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/connection_state_providers.dart';

class WorkingOrders extends StatelessWidget {
  const WorkingOrders({super.key});

  @override
  Widget build(BuildContext context) {
    // final visibleCount = min(orders.length, 3);
    const visibleCount = 3;

    if (visibleCount == 0) {
      return const SizedBox();
    }

    return Container(
      decoration: const BoxDecoration(
          color: SideSwapColors.chathamsBlue,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Text(
              'Working orders'.tr(),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 26,
              vertical: 12,
            ),
            child: OrdersRow(children: [
              OrdersHeader(text: 'Trading pair'.tr()),
              OrdersHeader(text: 'Amount'.tr()),
              OrdersHeader(text: 'Price per unit'.tr()),
              OrdersHeader(text: 'Total'.tr()),
              OrdersHeader(text: 'Side'.tr()),
              OrdersHeader(text: 'Limit/Tracking'.tr()),
              OrdersHeader(text: 'Order type'.tr()),
              OrdersHeader(text: 'TTL'.tr()),
            ]),
          ),
          SizedBox(
            height: 44.0 * visibleCount,
            child: Consumer(
              builder: (context, ref, child) {
                final orders = ref.watch(marketOwnRequestOrdersProvider);

                if (orders.isEmpty) {
                  return const WorkingOrdersEmpty();
                }

                return const WorkingOrdersList();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class WorkingOrdersList extends HookConsumerWidget {
  const WorkingOrdersList({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();

    final orders = ref.watch(marketOwnRequestOrdersProvider);

    return Scrollbar(
      controller: scrollController,
      thumbVisibility: true,
      child: ListView.builder(
        controller: scrollController,
        itemBuilder: (BuildContext context, int index) {
          final order = orders[index];

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  height: 1,
                  color: SideSwapColors.jellyBean,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: DHoverButton(
                  builder: (context, states) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 26 - 16,
                      ),
                      color: states.isHovering
                          ? const Color(0xFF22668C)
                          : Colors.transparent,
                      child: WorkingOrder(
                        order: order,
                      ),
                    );
                  },
                  onPressed: () {
                    ref
                        .read(marketSelectedAccountAssetStateProvider.notifier)
                        .setSelectedAccountAsset(
                          AccountAsset(
                            order.marketType == MarketType.amp
                                ? AccountType.amp
                                : AccountType.reg,
                            order.assetId,
                          ),
                        );
                  },
                ),
              ),
            ],
          );
        },
        itemCount: orders.length,
      ),
    );
  }
}

class WorkingOrdersEmpty extends StatelessWidget {
  const WorkingOrdersEmpty({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            height: 1,
            color: SideSwapColors.jellyBean,
          ),
        ),
        const SizedBox(height: 12),
        Consumer(
          builder: (context, ref, child) {
            final isConnected = ref.watch(serverConnectionStateProvider);

            return Text(
              isConnected ? 'No working orders'.tr() : 'Connecting ...'.tr(),
              style: const TextStyle(
                color: Color(0xFF87C1E1),
              ),
            );
          },
        ),
      ],
    );
  }
}
