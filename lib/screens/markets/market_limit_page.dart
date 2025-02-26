import 'package:easy_localization/easy_localization.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/animated_dropdown_arrow.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/desktop/markets/widgets/market_order_button.dart';
import 'package:sideswap/desktop/markets/widgets/market_order_panel.dart';
import 'package:sideswap/listeners/markets_page_listener.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/swap_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/screens/markets/widgets/limit_amount_text_field.dart';
import 'package:sideswap/screens/markets/widgets/limit_price_text_field.dart';
import 'package:sideswap/screens/markets/widgets/market_header.dart';
import 'package:sideswap/screens/markets/widgets/market_index_price.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class MarketLimitPage extends HookConsumerWidget {
  const MarketLimitPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tradeButtonEnabled = ref.watch(limitOrderTradeButtonEnabledProvider);
    final optionAssetPair = ref.watch(
      marketSubscribedAssetPairNotifierProvider,
    );
    final baseAmount = ref.watch(limitOrderAmountProvider);
    final priceAmount = ref.watch(limitPriceAmountProvider);
    final tradeDirState = ref.watch(tradeDirStateNotifierProvider);
    final limitTtlFlag = ref.watch(limitTtlFlagNotifierProvider);
    final orderType = ref.watch(marketLimitOrderTypeNotifierProvider);
    final offlineSwapType = ref.watch(marketLimitOfflineSwapProvider);

    final tradeCallback = useCallback(
      () async {
        if (!tradeButtonEnabled) {
          return;
        }

        ref.read(authInProgressStateNotifierProvider.notifier).setState(true);
        final authSucceed = await ref.read(walletProvider).isAuthenticated();
        ref.invalidate(authInProgressStateNotifierProvider);
        if (!authSucceed) {
          return;
        }

        optionAssetPair.match(() {}, (assetPair) {
          final msg = To();
          msg.orderSubmit = To_OrderSubmit(
            assetPair: assetPair,
            baseAmount: Int64(baseAmount.asSatoshi()),
            price: priceAmount.asDouble(),
            tradeDir: tradeDirState,
            ttlSeconds: limitTtlFlag.seconds(),
            private: orderType == OrderType.private(),
            twoStep: offlineSwapType == OfflineSwapType.twoStep(),
          );

          ref.read(walletProvider).sendMsg(msg);
        });
      },
      [
        optionAssetPair,
        baseAmount,
        priceAmount,
        tradeDirState,
        limitTtlFlag,
        orderType,
        offlineSwapType,
        tradeButtonEnabled,
      ],
    );

    return SideSwapScaffold(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          ref.read(walletProvider).goBack();
        }
      },
      body: SafeArea(
        child: Column(
          children: [
            MarketsPageListener(),
            SizedBox(height: 14),
            MarketHeader(),
            Flexible(child: MarketLimitBody()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: MarketOrderButton(
                isSell: tradeDirState == TradeDir.SELL,
                onPressed:
                    tradeButtonEnabled
                        ? () async {
                          await tradeCallback();
                        }
                        : null,
                text: 'Continue'.tr().toUpperCase(),
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class MarketLimitBody extends ConsumerWidget {
  const MarketLimitBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: SizedBox(height: 16)),
          SliverToBoxAdapter(child: MarketIndexPrice()),
          SliverToBoxAdapter(child: SizedBox(height: 24)),
          SliverToBoxAdapter(child: LimitAmountTextField()),
          SliverToBoxAdapter(child: SizedBox(height: 6)),
          SliverToBoxAdapter(child: LimitPriceTextField()),
          SliverToBoxAdapter(child: LimitTtlPopupMenu()),
          SliverToBoxAdapter(child: LimitPanelOrderType()),
          SliverToBoxAdapter(
            child: LimitPanelOfflineSwap(forceOfflineOnly: true),
          ),
        ],
      ),
    );
  }
}

class LimitTtlPopupMenu extends HookConsumerWidget {
  const LimitTtlPopupMenu({super.key});

  PopupMenuItem<T> popupMenuItem<T>(
    T value,
    String description,
    bool selected,
  ) {
    return PopupMenuItem<T>(
      height: 30,
      value: value,
      padding: const EdgeInsets.symmetric(horizontal: 9),
      child: HookBuilder(
        builder: (context) {
          final over = useState(false);
          return MouseRegion(
            onEnter: (event) {
              over.value = true;
            },
            onExit: (event) {
              over.value = false;
            },
            child: SizedBox(
              height: 32,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  description,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontSize: 13,
                    color:
                        selected
                            ? SideSwapColors.airSuperiorityBlue
                            : over.value
                            ? SideSwapColors.brightTurquoise
                            : Colors.white,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<PopupMenuEntry<LimitTtlFlag>> popupMenuItems(LimitTtlFlag limitTtlFlag) {
    return [
      popupMenuItem<LimitTtlFlag>(
        LimitTtlFlagUnlimited(),
        LimitTtlFlagUnlimited().description(),
        limitTtlFlag == LimitTtlFlagUnlimited(),
      ),
      popupMenuItem<LimitTtlFlag>(
        LimitTtlFlagOneHour(),
        LimitTtlFlagOneHour().description(),
        limitTtlFlag == LimitTtlFlagOneHour(),
      ),
      popupMenuItem<LimitTtlFlag>(
        LimitTtlFlagSixHours(),
        LimitTtlFlagSixHours().description(),
        limitTtlFlag == LimitTtlFlagSixHours(),
      ),
      popupMenuItem<LimitTtlFlag>(
        LimitTtlFlagTwelveHours(),
        LimitTtlFlagTwelveHours().description(),
        limitTtlFlag == LimitTtlFlagTwelveHours(),
      ),
      popupMenuItem<LimitTtlFlag>(
        LimitTtlFlagTwentyFourHours(),
        LimitTtlFlagTwentyFourHours().description(),
        limitTtlFlag == LimitTtlFlagTwentyFourHours(),
      ),
      popupMenuItem<LimitTtlFlag>(
        LimitTtlFlagThreeDays(),
        LimitTtlFlagThreeDays().description(),
        limitTtlFlag == LimitTtlFlagThreeDays(),
      ),
      popupMenuItem<LimitTtlFlag>(
        LimitTtlFlagOneWeek(),
        LimitTtlFlagOneWeek().description(),
        limitTtlFlag == LimitTtlFlagOneWeek(),
      ),
      popupMenuItem<LimitTtlFlag>(
        LimitTtlFlagOneMonth(),
        LimitTtlFlagOneMonth().description(),
        limitTtlFlag == LimitTtlFlagOneMonth(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final limitTtlFlag = ref.watch(limitTtlFlagNotifierProvider);

    final clicked = useState(false);

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          PopupMenuButton(
            onOpened: () => clicked.value = !clicked.value,
            onSelected: (value) {
              clicked.value = !clicked.value;
              ref.read(limitTtlFlagNotifierProvider.notifier).setState(value);
            },
            onCanceled: () {
              clicked.value = false;
            },
            itemBuilder: (BuildContext context) => popupMenuItems(limitTtlFlag),
            child: Container(
              width: 142,
              height: 24,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: SideSwapColors.blumine,
              ),
              child: Row(
                children: [
                  SizedBox(width: 6),
                  SvgPicture.asset('assets/clock.svg', width: 14, height: 14),
                  SizedBox(width: 6),
                  Text(
                    'TTL'.tr(),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: SideSwapColors.brightTurquoise,
                    ),
                  ),
                  Spacer(),
                  Text(
                    limitTtlFlag.description(),
                    style: Theme.of(
                      context,
                    ).textTheme.labelMedium?.copyWith(fontSize: 13),
                  ),
                  const SizedBox(width: 6),
                  AnimatedDropdownArrow(
                    target: clicked.value ? 1 : 0,
                    iconColor: SideSwapColors.brightTurquoise,
                  ),
                  SizedBox(width: 6),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
