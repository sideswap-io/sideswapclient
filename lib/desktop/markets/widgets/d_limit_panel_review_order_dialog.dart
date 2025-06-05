import 'package:easy_localization/easy_localization.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/styles/theme_extensions.dart';
import 'package:sideswap/common/widgets/animated_dropdown_arrow.dart';
import 'package:sideswap/common/widgets/colored_container.dart';
import 'package:sideswap/desktop/common/button/d_button.dart';
import 'package:sideswap/desktop/common/button/d_button_theme.dart';
import 'package:sideswap/desktop/common/button/d_custom_filled_big_button.dart';
import 'package:sideswap/desktop/common/button/d_hover_button.dart';
import 'package:sideswap/desktop/common/d_color.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog_theme.dart';
import 'package:sideswap/desktop/markets/widgets/d_tracking_price.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/providers/asset_image_providers.dart';
import 'package:sideswap/providers/jade_provider.dart';
import 'package:sideswap/providers/limit_review_order_providers.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/screens/markets/widgets/switch_buton.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

const limitPanelReviewOrderRouteName = '/desktopLimitPanelReviewOrder';

class DLimitPanelReviewOrderDialog extends HookConsumerWidget {
  const DLimitPanelReviewOrderDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final defaultDialogTheme = ref
        .watch(desktopAppThemeNotifierProvider)
        .dialogTheme
        .merge(
          const DContentDialogThemeData(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              color: SideSwapColors.blumine,
            ),
          ),
        );

    final closeCallback = useCallback(() {
      Navigator.of(context, rootNavigator: false).popUntil((route) {
        return route.settings.name != limitPanelReviewOrderRouteName;
      });
    });

    return DContentDialog(
      constraints: const BoxConstraints(maxWidth: 580, maxHeight: 733),
      style: defaultDialogTheme,
      title: DContentDialogTitle(
        content: Text('Review limit order'.tr()),
        onClose: () {
          closeCallback();
        },
      ),
      content: SizedBox(
        width: 580,
        height: 571,
        child: Column(
          children: [
            const SizedBox(height: 28),
            ColoredContainer(
              child: Column(
                children: [
                  const SizedBox(height: 3),
                  LimitReviewOrderProduct(),
                  LimitReviewOrderDivider(),
                  LimitReviewOrderAmount(),
                  const SizedBox(height: 3),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  LimitReviewPricePerUnit(),
                  LimitReviewOrderDivider(),
                  LimitReviewOrderAggregatedTotal(),
                  LimitReviewOrderDivider(),
                  LimitReviewOrderSide(),
                  LimitReviewOrderDivider(),
                ],
              ),
            ),
            LimitReviewTTL(),
            const SizedBox(height: 8),
            LimitReviewOfflineSwap(),
            const SizedBox(height: 8),
            LimitReviewOrderType(),
            const SizedBox(height: 8),
            LimitReviewTracking(),
            const Spacer(),
            LimitReviewSubmit(
              onPressed: () {
                closeCallback();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class LimitReviewOrderDivider extends ConsumerWidget {
  const LimitReviewOrderDivider({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const SizedBox(height: 3),
        const Divider(thickness: 1, color: SideSwapColors.jellyBean),
        const SizedBox(height: 3),
      ],
    );
  }
}

class LimitReviewOrderProduct extends ConsumerWidget {
  const LimitReviewOrderProduct({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final optionAssetPair = ref.watch(
      marketSubscribedAssetPairNotifierProvider,
    );

    return optionAssetPair.match(() => const SizedBox(), (assetPair) {
      final baseAsset = ref.watch(
        assetsStateProvider.select((value) => value[assetPair.base]),
      );
      final quoteAsset = ref.watch(
        assetsStateProvider.select((value) => value[assetPair.quote]),
      );

      return Row(
        children: [
          Text(
            'Product'.tr(),
            style: const TextStyle(color: SideSwapColors.hippieBlue),
          ),
          const Spacer(),
          Text('${baseAsset?.ticker ?? ''} / ${quoteAsset?.ticker ?? ''}'),
        ],
      );
    });
  }
}

class LimitReviewOrderAmount extends ConsumerWidget {
  const LimitReviewOrderAmount({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderAmount = ref.watch(limitOrderAmountProvider);
    final icon = ref
        .read(assetImageRepositoryProvider)
        .getVerySmallImage(orderAmount.assetId);
    final asset = ref.watch(
      assetsStateProvider.select((value) => value[orderAmount.assetId]),
    );

    return Row(
      children: [
        Text(
          'Amount'.tr(),
          style: const TextStyle(color: SideSwapColors.hippieBlue),
        ),
        Spacer(),
        Text(orderAmount.asString()),
        SizedBox(
          width: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(width: 8),
              icon,
              Spacer(),
              Text(asset?.ticker ?? ''),
            ],
          ),
        ),
      ],
    );
  }
}

class LimitReviewPricePerUnit extends ConsumerWidget {
  const LimitReviewPricePerUnit({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tradeDirState = ref.watch(tradeDirStateNotifierProvider);
    final priceAmount = ref.watch(limitReviewOrderPriceProvider);
    final icon = ref
        .read(assetImageRepositoryProvider)
        .getVerySmallImage(priceAmount.assetId);
    final asset = ref.watch(
      assetsStateProvider.select((value) => value[priceAmount.assetId]),
    );

    final priceDescription = tradeDirState == TradeDir.SELL
        ? 'Offer price per unit'.tr()
        : 'Bid price per unit'.tr();

    return Row(
      children: [
        Text(
          priceDescription,
          style: const TextStyle(color: SideSwapColors.brightTurquoise),
        ),
        Spacer(),
        Text(priceAmount.asString()),
        SizedBox(
          width: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(width: 8),
              icon,
              Spacer(),
              Text(asset?.ticker ?? ''),
            ],
          ),
        ),
      ],
    );
  }
}

class LimitReviewOrderAggregatedTotal extends ConsumerWidget {
  const LimitReviewOrderAggregatedTotal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tradeDirState = ref.watch(tradeDirStateNotifierProvider);
    final aggregateVolume = ref.watch(limitReviewOrderAggregateVolumeProvider);
    final aggregateTooHigh = ref.watch(
      limitReviewOrderAggregateVolumeTooHighProvider,
    );
    final priceAmount = ref.watch(limitOrderPriceProvider);
    final icon = ref
        .read(assetImageRepositoryProvider)
        .getVerySmallImage(priceAmount.assetId);
    final asset = ref.watch(
      assetsStateProvider.select((value) => value[priceAmount.assetId]),
    );

    final aggregateDescriptionColor =
        tradeDirState == TradeDir.BUY && aggregateTooHigh
        ? SideSwapColors.bitterSweet
        : SideSwapColors.brightTurquoise;

    final aggregateVolumeColor =
        tradeDirState == TradeDir.BUY && aggregateTooHigh
        ? SideSwapColors.bitterSweet
        : Colors.white;

    final aggregateDescription = tradeDirState == TradeDir.BUY
        ? 'Aggregate bid amount:'.tr()
        : 'Aggregate offer value:'.tr();

    return Row(
      children: [
        Text(
          aggregateDescription,
          style: TextStyle(color: aggregateDescriptionColor),
        ),
        const Spacer(),
        Text(
          aggregateVolume.asString(),
          style: TextStyle(color: aggregateVolumeColor),
        ),
        SizedBox(
          width: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(width: 8),
              icon,
              Spacer(),
              Text(asset?.ticker ?? ''),
            ],
          ),
        ),
      ],
    );
  }
}

class LimitReviewOrderSide extends ConsumerWidget {
  const LimitReviewOrderSide({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tradeDirState = ref.watch(tradeDirStateNotifierProvider);
    final side = tradeDirState == TradeDir.SELL ? 'Sell'.tr() : 'Buy'.tr();
    final sideColor = tradeDirState == TradeDir.SELL
        ? Theme.of(context).extension<MarketColorsStyle>()!.sellColor
        : Theme.of(context).extension<MarketColorsStyle>()!.buyColor;

    return Row(
      children: [
        Text(
          'Side'.tr(),
          style: const TextStyle(color: SideSwapColors.brightTurquoise),
        ),
        const Spacer(),
        Text(side, style: TextStyle(color: sideColor)),
      ],
    );
  }
}

class LimitReviewOfflineSwap extends ConsumerWidget {
  const LimitReviewOfflineSwap({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offlineSwapType = ref.watch(marketLimitOfflineSwapProvider);
    final isJadeWallet = ref.watch(isJadeWalletProvider);

    return ColoredContainer(
      child: Row(
        children: [
          Text('Sign type'.tr()),
          Spacer(),
          Tooltip(
            message:
                "Online orders (recommended):\n- Are not tied to specific UTXOs (spending UTXOs won't cancel online orders).\n- Can be partially matched, making them more flexible.\n- Order amount can be more than the available wallet balance.\n- Allow price editing.\n- Requires the application to be open and your computer to be running.\n\nOffline orders:\n- Are tied to specific UTXOs (spending UTXOs can cancel one or more orders).\n- Requires exact UTXO amount and therefore may require a funding transaction and payment of network fee.\n- Order amount cannot exceed available wallet balance.\n- Does not allow price editing.\n- Allows the application to be offline."
                    .tr(),
            child: Icon(
              Icons.help_outlined,
              size: 20,
              color: SideSwapColors.brightTurquoise,
            ),
          ),
          SizedBox(width: 12),
          SwitchButton(
            width: 142,
            height: 34,
            borderRadius: 6,
            borderWidth: 2,
            fontSize: 13,
            activeText: 'Online'.tr(),
            inactiveText: 'Offline'.tr(),
            value: offlineSwapType == OfflineSwapType.empty(),
            onToggle: isJadeWallet
                ? null
                : (value) {
                    if (value) {
                      ref.invalidate(marketLimitOfflineSwapProvider);
                      return;
                    }

                    ref
                        .read(marketLimitOfflineSwapProvider.notifier)
                        .setState(OfflineSwapType.twoStep());
                  },
          ),
        ],
      ),
    );
  }
}

class LimitReviewOrderType extends ConsumerWidget {
  const LimitReviewOrderType({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderType = ref.watch(marketLimitOrderTypeNotifierProvider);

    return ColoredContainer(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('Order type'.tr()),
          Spacer(),
          SwitchButton(
            width: 142,
            height: 34,
            borderRadius: 6,
            borderWidth: 2,
            fontSize: 13,
            activeText: 'Public'.tr(),
            inactiveText: 'Private'.tr(),
            value: orderType == OrderType.public(),
            onToggle: (value) {
              if (value) {
                ref.invalidate(marketLimitOrderTypeNotifierProvider);
                return;
              }

              ref
                  .read(marketLimitOrderTypeNotifierProvider.notifier)
                  .setState(OrderType.private());
            },
          ),
        ],
      ),
    );
  }
}

class LimitReviewTTL extends HookConsumerWidget {
  const LimitReviewTTL({super.key});

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
                    color: selected
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

  Future<LimitTtlFlag?> showTtlMenu(
    BuildContext context,
    GlobalKey buttonKey,
    LimitTtlFlag limitTtlFlag,
  ) async {
    final box = buttonKey.currentContext?.findRenderObject() as RenderBox;
    final buttonOffset = box.localToGlobal(Offset.zero);

    final overlay =
        Navigator.of(context).overlay!.context.findRenderObject()! as RenderBox;

    final position = RelativeRect.fromLTRB(
      buttonOffset.dx + box.size.width - 112,
      buttonOffset.dy + box.size.height + 4,
      overlay.size.width, // same as MediaQuery.of(context).size.width,
      overlay.size.height, // same as MediaQuery.of(context).size.height,
    );

    final result = await showMenu<LimitTtlFlag>(
      context: context,
      position: position,
      color: SideSwapColors.prussianBlue,
      constraints: const BoxConstraints(maxWidth: 140),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      items: popupMenuItems(limitTtlFlag),
    );

    return result;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buttonKey = useMemoized(() => GlobalKey());
    final clicked = useState(false);
    final buttonThemes = ref
        .watch(desktopAppThemeNotifierProvider)
        .buttonThemeData;
    final limitTtlFlag = ref.watch(limitTtlFlagNotifierProvider);

    return ColoredContainer(
      child: Row(
        children: [
          Text('Time-to-live'.tr()),
          Spacer(),
          DButton(
            key: buttonKey,
            style: clicked.value
                ? buttonThemes.filledButtonStyle?.merge(
                    DButtonStyle(
                      backgroundColor: ButtonState.all(
                        SideSwapColors.prussianBlue,
                      ),
                    ),
                  )
                : buttonThemes.filledButtonStyle?.merge(
                    DButtonStyle(
                      backgroundColor: ButtonState.all(
                        SideSwapColors.blueSapphire,
                      ),
                    ),
                  ),
            onPressed: () async {
              clicked.value = true;
              final result = await showTtlMenu(
                context,
                buttonKey,
                limitTtlFlag,
              );
              (switch (result) {
                LimitTtlFlag result =>
                  ref
                      .read(limitTtlFlagNotifierProvider.notifier)
                      .setState(result),
                _ => ref.invalidate(limitTtlFlagNotifierProvider),
              });

              clicked.value = false;
            },
            child: SizedBox(
              width: 110,
              height: 34,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LimitReviewTracking extends HookConsumerWidget {
  const LimitReviewTracking({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tradeDirState = ref.watch(tradeDirStateNotifierProvider);

    final trackingToggled = ref.watch(
      marketLimitTrackIndexPriceStateNotifierProvider,
    );
    final trackingValue = ref.watch(
      marketLimitTrackIndexPriceValueNotifierProvider,
    );

    final offlineSwapType = ref.watch(marketLimitOfflineSwapProvider);

    return DTrackingPrice(
      trackingToggled: trackingToggled,
      trackingValue: trackingValue.asDouble(),
      invertColors: tradeDirState == TradeDir.BUY,
      maxPercent: 5,
      onTrackingChanged: (value) {
        ref
            .read(marketLimitTrackIndexPriceValueNotifierProvider.notifier)
            .setState(TrackingValue(trackingValue: value));
      },
      onTrackingToggle: switch (offlineSwapType) {
        OfflineSwapTypeTwoStep() => null,
        _ => (value) {
          ref
              .read(marketLimitTrackIndexPriceStateNotifierProvider.notifier)
              .setState(value);
        },
      },
    );
  }
}

class LimitReviewSubmit extends HookConsumerWidget {
  const LimitReviewSubmit({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tradeDirState = ref.watch(tradeDirStateNotifierProvider);
    final color = tradeDirState == TradeDir.SELL
        ? Theme.of(context).extension<MarketColorsStyle>()!.sellColor
        : Theme.of(context).extension<MarketColorsStyle>()!.buyColor;

    final submitButtonEnabled = ref.watch(
      limitReviewOrderSubmitButtonEnabledProvider,
    );
    final optionAssetPair = ref.watch(
      marketSubscribedAssetPairNotifierProvider,
    );
    final orderAmount = ref.watch(limitOrderAmountProvider);
    final orderPrice = ref.watch(limitReviewOrderPriceProvider);
    final limitTtlFlag = ref.watch(limitTtlFlagNotifierProvider);
    final orderType = ref.watch(marketLimitOrderTypeNotifierProvider);
    final offlineSwapType = ref.watch(marketLimitOfflineSwapProvider);
    final trackingToggled = ref.watch(
      marketLimitTrackIndexPriceStateNotifierProvider,
    );
    final trackingValue = ref.watch(
      marketLimitTrackIndexPriceValueNotifierProvider,
    );

    final submitCallback = useCallback(
      () async {
        if (!submitButtonEnabled) {
          return;
        }

        var authorized = ref.read(jadeOneTimeAuthorizationProvider);

        if (!ref.read(jadeOneTimeAuthorizationProvider)) {
          authorized = await ref
              .read(jadeOneTimeAuthorizationProvider.notifier)
              .authorize();
        }

        if (!authorized) {
          return;
        }

        // * TODO (malcolmpl): fix price tracking and refreshing edit price dialog window!

        optionAssetPair.match(() {}, (assetPair) {
          final msg = To();
          msg.orderSubmit = To_OrderSubmit(
            assetPair: assetPair,
            baseAmount: Int64(orderAmount.asSatoshi()),
            price: trackingToggled ? null : orderPrice.asDouble(),
            tradeDir: tradeDirState,
            ttlSeconds: limitTtlFlag.seconds(),
            private: orderType == OrderType.private(),
            twoStep: offlineSwapType == OfflineSwapType.twoStep(),
            priceTracking: trackingToggled
                ? trackingValue.asDecimalPercent().toDouble()
                : null,
          );

          ref.read(walletProvider).sendMsg(msg);

          onPressed?.call();
        });
      },
      [
        optionAssetPair,
        orderAmount,
        orderPrice,
        tradeDirState,
        limitTtlFlag,
        orderType,
        offlineSwapType,
        submitButtonEnabled,
        trackingToggled,
        trackingValue,
      ],
    );

    return DCustomFilledBigButton(
      width: double.infinity,
      height: 54,
      onPressed: submitButtonEnabled ? submitCallback : null,
      style: DButtonStyle(
        padding: ButtonState.all(EdgeInsets.zero),
        textStyle: ButtonState.all(
          const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        backgroundColor: ButtonState.resolveWith((states) {
          if (states.isDisabled) {
            return color?.lerpWith(Colors.black, 0.3);
          }
          if (states.isPressing) {
            return color?.lerpWith(Colors.black, 0.2);
          }
          if (states.isHovering) {
            return color?.lerpWith(Colors.black, 0.1);
          }
          return color;
        }),
        foregroundColor: ButtonState.resolveWith((states) {
          if (states.isDisabled) {
            return Colors.white.lerpWith(Colors.black, 0.3);
          }
          return Colors.white;
        }),
        shape: ButtonState.all(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
        border: ButtonState.resolveWith((states) {
          return const BorderSide(color: Colors.transparent, width: 1);
        }),
      ),
      child: Text('SUBMIT'.tr()),
    );
  }
}
