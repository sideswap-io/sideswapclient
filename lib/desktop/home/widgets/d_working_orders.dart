import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/common/button/d_button.dart';
import 'package:sideswap/desktop/common/button/d_button_theme.dart';
import 'package:sideswap/desktop/common/button/d_hover_button.dart';
import 'package:sideswap/desktop/markets/widgets/d_working_orders_header.dart';
import 'package:sideswap/desktop/markets/widgets/d_working_orders_row.dart';
import 'package:sideswap/desktop/markets/widgets/d_working_order_item.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/providers/connection_state_providers.dart';
import 'package:sideswap/providers/markets_provider.dart';

class DWorkingOrders extends ConsumerWidget {
  const DWorkingOrders({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        SizedBox(
          height: 43,
          child: DefaultTextStyle(
            style: const TextStyle().merge(
              Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(color: SideSwapColors.glacier),
            ),
            child: DWorkingOrdersRow(
              children: [
                DWorkingOrdersHeader(text: 'Trading pair'.tr()),
                DWorkingOrdersHeader(text: 'Amount'.tr()),
                DWorkingOrdersHeader(text: 'Price per unit'.tr()),
                DWorkingOrdersHeader(text: 'Total'.tr()),
                DWorkingOrdersHeader(text: 'Side'.tr()),
                DWorkingOrdersHeader(text: 'Order type'.tr()),
                DWorkingOrdersHeader(text: 'Two step'.tr()),
                DWorkingOrdersHeader(text: 'TTL'.tr()),
              ],
            ),
          ),
        ),
        const Divider(height: 1, thickness: 0, color: SideSwapColors.jellyBean),
        Flexible(
          child: Consumer(
            builder: (context, ref, child) {
              final ownOrders = ref.watch(marketOwnOrdersNotifierProvider);

              if (ownOrders.isEmpty) {
                return Column(
                  children: [SizedBox(height: 63), DWorkingOrdersEmpty()],
                );
              }

              return DWorkingOrdersList();
            },
          ),
        ),
      ],
    );
  }
}

class DWorkingOrdersList extends ConsumerWidget {
  const DWorkingOrdersList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiOwnOrders = ref.watch(marketUiOwnOrdersProvider);
    final buttonStyle =
        ref.watch(desktopAppThemeNotifierProvider).buttonWithoutBorderStyle;

    return CustomScrollView(
      slivers: [
        SliverList.builder(
          itemCount: uiOwnOrders.length,
          itemBuilder: (context, index) {
            return DButton(
              style: buttonStyle?.merge(
                DButtonStyle(
                  shape: ButtonState.all(
                    const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(0)),
                    ),
                  ),
                ),
              ),
              onPressed: () {},
              child: SizedBox(
                height: 43,
                child: DefaultTextStyle(
                  style: const TextStyle().merge(
                    Theme.of(context).textTheme.titleSmall,
                  ),
                  child: DWorkingOrderItem(order: uiOwnOrders[index]),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class DWorkingOrdersEmpty extends ConsumerWidget {
  const DWorkingOrdersEmpty({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isConnected = ref.watch(serverConnectionNotifierProvider);

    return Text(
      isConnected ? 'No working orders'.tr() : 'Connecting ...'.tr(),
      style: Theme.of(
        context,
      ).textTheme.labelMedium?.copyWith(color: SideSwapColors.glacier),
    );
  }
}
