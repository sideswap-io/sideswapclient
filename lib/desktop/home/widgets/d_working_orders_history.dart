import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/common/button/d_button.dart';
import 'package:sideswap/desktop/common/button/d_button_theme.dart';
import 'package:sideswap/desktop/common/button/d_hover_button.dart';
import 'package:sideswap/desktop/markets/widgets/d_working_history_order_item.dart';
import 'package:sideswap/desktop/markets/widgets/d_working_orders_header.dart';
import 'package:sideswap/desktop/markets/widgets/d_working_history_orders_row.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/providers/connection_state_providers.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class DWorkingHistoryOrders extends HookConsumerWidget {
  const DWorkingHistoryOrders({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      final msg = To();
      msg.loadHistory = To_LoadHistory(skip: 0, count: 10);
      ref.read(walletProvider).sendMsg(msg);

      return;
    }, const []);

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
            child: DWorkingHistoryOrdersRow(
              children: [
                DWorkingOrdersHeader(text: 'Date'.tr()),
                DWorkingOrdersHeader(text: 'Type'.tr()),
                DWorkingOrdersHeader(text: 'Sent'.tr()),
                DWorkingOrdersHeader(text: 'Received'.tr()),
                DWorkingOrdersHeader(text: 'Status'.tr()),
                DWorkingOrdersHeader(text: 'Link'.tr()),
              ],
            ),
          ),
        ),
        const Divider(height: 1, thickness: 0, color: SideSwapColors.jellyBean),
        Flexible(
          child: Consumer(
            builder: (context, ref, child) {
              final historyOrders = ref.watch(
                marketHistoryOrderNotifierProvider,
              );

              if (historyOrders.isEmpty) {
                return Column(
                  children: [SizedBox(height: 63), DWorkingHistoryOrderEmpty()],
                );
              }

              return DWorkingHistoryOrderList();
            },
          ),
        ),
      ],
    );
  }
}

class DWorkingHistoryOrderEmpty extends ConsumerWidget {
  const DWorkingHistoryOrderEmpty({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isConnected = ref.watch(serverConnectionNotifierProvider);

    return Text(
      isConnected ? 'No transactions history'.tr() : 'Connecting ...'.tr(),
      style: Theme.of(
        context,
      ).textTheme.labelMedium?.copyWith(color: SideSwapColors.glacier),
    );
  }
}

class DWorkingHistoryOrderList extends HookConsumerWidget {
  const DWorkingHistoryOrderList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiHistoryOrders = ref.watch(marketUiHistoryOrdersProvider);
    final totalHistoryOrders = ref.watch(marketHistoryTotalProvider);
    final buttonStyle =
        ref.watch(desktopAppThemeNotifierProvider).buttonWithoutBorderStyle;

    final scrollController = useScrollController();

    final loadMoreCallback = useCallback(({int skip = 0, int count = 20}) {
      Future.microtask(() async {
        final msg = To();
        msg.loadHistory = To_LoadHistory(skip: skip, count: count);

        ref.read(walletProvider).sendMsg(msg);
      });
    });

    useEffect(() {
      void onScroll() {
        final historyOrders = ref.read(marketHistoryOrderNotifierProvider);
        if (scrollController.position.pixels ==
                scrollController.position.maxScrollExtent &&
            historyOrders.length != totalHistoryOrders) {
          loadMoreCallback(skip: historyOrders.length);
        }
      }

      scrollController.addListener(onScroll);
      loadMoreCallback();

      return;
    }, const []);

    useEffect(() {
      if (uiHistoryOrders.length != totalHistoryOrders) {
        loadMoreCallback(skip: uiHistoryOrders.length);
      }

      return;
    }, [uiHistoryOrders]);

    return Scrollbar(
      thumbVisibility: true,
      controller: scrollController,
      child: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverList.builder(
            itemCount: uiHistoryOrders.length,
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
                    child: DWorkingHistoryOrderItem(
                      historyOrder: uiHistoryOrders[index],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
