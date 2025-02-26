import 'package:easy_localization/easy_localization.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/styles/theme_extensions.dart';
import 'package:sideswap/common/widgets/animated_dropdown_arrow.dart';
import 'package:sideswap/desktop/common/button/d_button.dart';
import 'package:sideswap/desktop/common/button/d_button_theme.dart';
import 'package:sideswap/desktop/common/button/d_hover_button.dart';
import 'package:sideswap/desktop/common/button/d_url_link.dart';
import 'package:sideswap/providers/asset_image_providers.dart';
import 'package:sideswap/screens/markets/widgets/limit_amount_text_field.dart';
import 'package:sideswap/screens/markets/widgets/limit_price_text_field.dart';
import 'package:sideswap/screens/markets/widgets/market_amount_text_field.dart';
import 'package:sideswap/desktop/markets/widgets/balance_line.dart';
import 'package:sideswap/desktop/markets/widgets/market_order_button.dart';
import 'package:sideswap/desktop/markets/widgets/product_columns.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/providers/jade_provider.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/screens/markets/widgets/switch_buton.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class MarketOrderPanel extends HookConsumerWidget {
  const MarketOrderPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const headerDefaultColor = SideSwapColors.prussianBlue;
    const headerActiveColor = Color(0xFF084366);
    const panelColor = SideSwapColors.chathamsBlue;

    final trackingToggled = useState(false);
    final trackingValue = useState(0.0);
    final tradeDirState = ref.watch(tradeDirStateNotifierProvider);
    final isSell = tradeDirState == TradeDir.SELL;
    final expanded = useState(false);
    final focusNodeAmount = useFocusNode();

    useEffect(() {
      trackingValue.value = 0;

      return;
    }, [trackingToggled.value]);

    useEffect(() {
      focusNodeAmount.requestFocus();

      return;
    }, [isSell]);

    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 200),
      initialValue: 0,
    );

    final Animation<double> heightFactor = useMemoized(() {
      return animationController.drive(CurveTween(curve: Curves.easeIn));
    }, [animationController]);

    useEffect(() {
      if (expanded.value) {
        animationController.forward();
        return;
      }

      animationController.reverse();
      return;
    }, [expanded.value]);

    final drawProductColumns = useState<bool>(false);

    useEffect(() {
      animationController.addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.dismissed) {
          drawProductColumns.value = false;
          return;
        }

        if (!drawProductColumns.value) {
          drawProductColumns.value = true;
        }
      });

      return;
    }, [animationController]);

    return Container(
      width: 377,
      decoration: const BoxDecoration(
        color: panelColor,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        children: [
          DHoverButton(
            builder: (context, states) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color:
                      states.isHovering || expanded.value
                          ? headerActiveColor
                          : headerDefaultColor,
                  borderRadius:
                      drawProductColumns.value
                          ? const BorderRadius.vertical(top: Radius.circular(8))
                          : const BorderRadius.all(Radius.circular(8)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Product'.tr(),
                      style: const TextStyle(
                        color: SideSwapColors.brightTurquoise,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Row(
                      children: [
                        Consumer(
                          builder: (context, ref, child) {
                            final marketInfo = ref.watch(
                              subscribedMarketInfoProvider,
                            );

                            return marketInfo.match(() => SizedBox(), (
                              marketInfo,
                            ) {
                              final productName = ref.watch(
                                subscribedMarketProductNameProvider,
                              );

                              return Text(
                                productName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              );
                            });
                          },
                        ),
                        const SizedBox(width: 16),
                        AnimatedDropdownArrow(target: expanded.value ? 1 : 0),
                        const Spacer(),
                        SwitchButton(
                          width: 142,
                          height: 32,
                          borderRadius: 8,
                          borderWidth: 2,
                          fontSize: 13,
                          activeText: 'Sell'.tr(),
                          inactiveText: 'Buy'.tr(),
                          value: tradeDirState == TradeDir.SELL,
                          activeToggleBackground:
                              tradeDirState == TradeDir.SELL
                                  ? Theme.of(
                                    context,
                                  ).extension<MarketColorsTheme>()!.sellColor!
                                  : Theme.of(
                                    context,
                                  ).extension<MarketColorsTheme>()!.buyColor!,
                          inactiveToggleBackground: SideSwapColors.darkCerulean,
                          backgroundColor: SideSwapColors.darkCerulean,
                          borderColor: SideSwapColors.darkCerulean,
                          onToggle: (value) {
                            if (value) {
                              ref
                                  .read(tradeDirStateNotifierProvider.notifier)
                                  .setSide(TradeDir.SELL);
                            } else {
                              ref
                                  .read(tradeDirStateNotifierProvider.notifier)
                                  .setSide(TradeDir.BUY);
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
            onPressed: () {
              expanded.value = !expanded.value;
            },
          ),
          Flexible(
            child: Stack(
              children: [
                FocusTraversalGroup(
                  child: Column(
                    children: [
                      MarketTypeSwitch(),
                      Consumer(
                        builder: (context, ref, child) {
                          final marketTypeSwitchState = ref.watch(
                            marketTypeSwitchStateNotifierProvider,
                          );

                          return switch (marketTypeSwitchState) {
                            MarketTypeSwitchStateMarket() => MarketPanel(),
                            _ => LimitPanel(),
                          };
                        },
                      ),
                    ],
                  ),
                ),
                AnimatedBuilder(
                  animation: animationController.view,
                  builder: (context, child) {
                    return FractionallySizedBox(
                      heightFactor: heightFactor.value,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: headerActiveColor,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                        ),
                        child: child,
                      ),
                    );
                  },
                  child: switch (drawProductColumns.value) {
                    true => () {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: ProductColumns(
                          onMarketSelected: () {
                            expanded.value = !expanded.value;
                          },
                        ),
                      );
                    }(),
                    _ => () {
                      return const SizedBox();
                    }(),
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MarketTypeSwitch extends ConsumerWidget {
  const MarketTypeSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final marketTypeSwitchState = ref.watch(
      marketTypeSwitchStateNotifierProvider,
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SwitchButton(
        width: 355,
        height: 35,
        borderRadius: 8,
        borderWidth: 3,
        fontSize: 13,
        activeText: 'Limit order'.tr(),
        inactiveText: 'Market order'.tr(),
        value: marketTypeSwitchState == MarketTypeSwitchState.limit(),
        activeToggleBackground:
            Theme.of(context).extension<MarketColorsTheme>()!.buyColor!,
        inactiveToggleBackground: SideSwapColors.darkCerulean,
        backgroundColor: SideSwapColors.darkCerulean,
        borderColor: SideSwapColors.darkCerulean,
        onToggle: (value) {
          if (value) {
            ref
                .read(marketTypeSwitchStateNotifierProvider.notifier)
                .setState(MarketTypeSwitchState.limit());
            return;
          }

          ref
              .read(marketTypeSwitchStateNotifierProvider.notifier)
              .setState(MarketTypeSwitchState.market());
        },
      ),
    );
  }
}

class MarketPanel extends ConsumerWidget {
  const MarketPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final optionMarketInfo = ref.watch(subscribedMarketInfoProvider);

    return optionMarketInfo.match(
      () => SizedBox(),
      (_) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            border: Border.all(width: 1, color: SideSwapColors.blumine),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(1),
            child: SizedBox(
              width: 370,
              height: 331,
              child: Column(
                children: [
                  SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: MarketAssetSwitchButtons(height: 36),
                  ),
                  MarketAmountPanel(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MarketAssetSwitchButtons extends ConsumerWidget {
  const MarketAssetSwitchButtons({this.width, this.height, super.key});

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final marketSideState = ref.watch(marketSideStateNotifierProvider);
    final baseAsset = ref.watch(marketSubscribedBaseAssetProvider);
    final quoteAsset = ref.watch(marketSubscribedQuoteAssetProvider);

    return baseAsset.match(
      () => SizedBox(),
      (baseAsset) => quoteAsset.match(
        () => SizedBox(),
        (quoteAsset) => SwitchButton(
          width: width,
          height: height,
          borderRadius: 8,
          borderWidth: 3,
          fontSize: 13,
          activeText: quoteAsset.ticker,
          inactiveText: baseAsset.ticker,
          value: marketSideState == MarketSideState.quote(),
          activeToggleBackground:
              Theme.of(context).extension<MarketColorsTheme>()!.buyColor!,
          inactiveToggleBackground: SideSwapColors.darkCerulean,
          backgroundColor: SideSwapColors.darkCerulean,
          borderColor: SideSwapColors.darkCerulean,
          onToggle: (value) {
            if (value) {
              ref
                  .read(marketSideStateNotifierProvider.notifier)
                  .setState(MarketSideState.quote());
              return;
            }

            ref
                .read(marketSideStateNotifierProvider.notifier)
                .setState(MarketSideState.base());
          },
        ),
      ),
    );
  }
}

class MarketAmountPanel extends HookConsumerWidget {
  const MarketAmountPanel({
    this.onMaxPressed,
    this.focusNode,
    this.onEditingComplete,
    this.onChanged,
    super.key,
  });

  final void Function()? onMaxPressed;
  final FocusNode? focusNode;
  final void Function()? onEditingComplete;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final marketSideState = ref.watch(marketSideStateNotifierProvider);
    final optionBaseAsset = ref.watch(marketSubscribedBaseAssetProvider);
    final optionQuoteAsset = ref.watch(marketSubscribedQuoteAssetProvider);
    final tradeButtonEnabled = ref.watch(marketOrderTradeButtonEnabledProvider);
    final optionSubscribedAssetPair = ref.watch(
      marketSubscribedAssetPairNotifierProvider,
    );
    final tradeDirState = ref.watch(tradeDirStateNotifierProvider);
    final optionAcceptQuoteError = ref.watch(acceptQuoteErrorProvider);

    final amountController = useTextEditingController();

    useEffect(() {
      optionAcceptQuoteError.match(() {}, (_) {
        amountController.clear();
        Future.microtask(
          () => ref
              .read(marketOrderAmountControllerNotifierProvider.notifier)
              .setState(amountController.text),
        );
      });
      return;
    }, [optionAcceptQuoteError]);

    useEffect(() {
      amountController.addListener(() {
        Future.microtask(
          () => ref
              .read(marketOrderAmountControllerNotifierProvider.notifier)
              .setState(amountController.text),
        );
      });

      return;
    }, [amountController]);

    final amountFocusNode = focusNode ?? useFocusNode();

    useEffect(() {
      amountController.clear();
      Future.microtask(
        () => ref
            .read(marketOrderAmountControllerNotifierProvider.notifier)
            .setState(amountController.text),
      );

      amountFocusNode.requestFocus();

      return;
    }, [marketSideState, optionSubscribedAssetPair, tradeDirState]);

    ref.listen(marketAcceptQuoteSuccessProvider, (prev, next) {
      if (next.isSome()) {
        amountController.text = '';
      }
    });

    final onMaxPressedCallback = useCallback((
      Asset baseAsset,
      Asset quoteAsset,
    ) {
      final asset =
          marketSideState == MarketSideState.base() ? baseAsset : quoteAsset;

      /// * get amp balance for amp asset or instead get sum for all accounts
      final balance =
          asset.ampMarket
              ? ref.read(
                maxAvailableBalanceForAccountAssetProvider(
                  AccountAsset(AccountType.amp, asset.assetId),
                ),
              )
              : ref.read(
                totalMaxAvailableBalanceForAssetProvider(asset.assetId),
              );

      amountController.text = ref
          .watch(amountToStringProvider)
          .amountToString(
            AmountToStringParameters(
              amount: balance,
              trailingZeroes: false,
              precision: asset.precision,
            ),
          );
    }, [marketSideState]);

    final marketTradeRepository = ref.watch(marketTradeRepositoryProvider);
    final optionQuoteSuccess = ref.watch(marketQuoteSuccessProvider);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: optionBaseAsset.match(
        () => SizedBox(),
        (baseAsset) => optionQuoteAsset.match(
          () => SizedBox(),
          (quoteAsset) => SizedBox(
            height: 264,
            width: 359,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MarketAmountTextField(
                  caption: 'Amount'.tr(),
                  asset:
                      marketSideState == MarketSideState.base()
                          ? baseAsset
                          : quoteAsset,
                  controller: amountController,
                  autofocus: true,
                  focusNode: amountFocusNode,
                  onEditingComplete: () async {
                    onEditingComplete?.call();
                    if (tradeButtonEnabled) {
                      await marketTradeRepository.makeSwapTrade(
                        context: context,
                        optionQuoteSuccess: optionQuoteSuccess,
                      );
                    }
                  },
                  onChanged: onChanged,
                ),
                FocusTraversalGroup(
                  descendantsAreFocusable: false,
                  child: BalanceLine(
                    onMaxPressed: () {
                      onMaxPressedCallback(baseAsset, quoteAsset);
                    },
                    amountSide: true,
                  ),
                ),
                MarketAmountError(),
                MarketLowBalanceError(),
                MarketQuoteSuccess(),
                MarketUnregisteredGaidError(),
                Spacer(),
                MarketOrderButton(
                  isSell: tradeDirState == TradeDir.SELL,
                  onPressed:
                      tradeButtonEnabled
                          ? () async {
                            await marketTradeRepository.makeSwapTrade(
                              context: context,
                              optionQuoteSuccess: optionQuoteSuccess,
                            );
                          }
                          : null,
                  text: 'Continue'.tr().toUpperCase(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MarketAssetRow extends ConsumerWidget {
  const MarketAssetRow({
    required this.asset,
    required this.amount,
    this.isError = false,
    this.showConversion = false,
    this.label = '',
    this.theme,
    super.key,
  });

  final Option<Asset> asset;
  final String amount;
  final bool isError;
  final bool showConversion;
  final String label;
  final MarketAssetRowTheme? theme;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assetId = asset.toNullable()?.assetId;
    final deliverIcon = ref
        .read(assetImageRepositoryProvider)
        .getVerySmallImage(assetId);
    final defaultCurrencyConversion =
        showConversion
            ? ref.watch(
              defaultCurrencyConversionFromStringProvider(assetId, amount),
            )
            : null;

    final defaultTheme =
        theme ?? Theme.of(context).extension<MarketAssetRowTheme>()!;

    return Column(
      children: [
        Row(
          children: [
            Text(
              label,
              style:
                  isError
                      ? defaultTheme.errorLabelStyle
                      : defaultTheme.labelStyle,
            ),
            Spacer(),
            Text(
              amount,
              style:
                  isError
                      ? defaultTheme.errorAmountStyle
                      : defaultTheme.amountStyle,
            ),
            SizedBox(
              width: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(width: 8),
                  deliverIcon,
                  Spacer(),
                  Text(
                    asset.toNullable()?.ticker ?? '',
                    style:
                        isError
                            ? defaultTheme.errorTickerStyle
                            : defaultTheme.tickerStyle,
                  ),
                ],
              ),
            ),
          ],
        ),
        switch (showConversion) {
          true => Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '≈ $defaultCurrencyConversion',
                style: defaultTheme.conversionStyle,
              ),
            ],
          ),
          false => SizedBox(),
        },
      ],
    );
  }
}

class MarketDeliverRow extends ConsumerWidget {
  const MarketDeliverRow({
    required this.deliverAsset,
    required this.deliverAmount,
    this.isError = false,
    this.showConversion = false,
    this.theme,
    super.key,
  });

  final Option<Asset> deliverAsset;
  final String deliverAmount;
  final bool isError;
  final bool showConversion;
  final MarketAssetRowTheme? theme;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MarketAssetRow(
      amount: deliverAmount,
      asset: deliverAsset,
      isError: isError,
      showConversion: showConversion,
      label: 'Deliver'.tr(),
      theme: theme,
    );
  }
}

class MarketReceiveRow extends ConsumerWidget {
  const MarketReceiveRow({
    required this.receiveAsset,
    required this.receiveAmount,
    this.isError = false,
    this.showConversion = false,
    this.theme,
    super.key,
  });

  final Option<Asset> receiveAsset;
  final String receiveAmount;
  final bool isError;
  final bool showConversion;
  final MarketAssetRowTheme? theme;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MarketAssetRow(
      asset: receiveAsset,
      amount: receiveAmount,
      isError: isError,
      showConversion: showConversion,
      label: 'Receive'.tr(),
      theme: theme,
    );
  }
}

class MarketQuoteSuccess extends ConsumerWidget {
  const MarketQuoteSuccess({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final optionQuoteSuccess = ref.watch(marketQuoteSuccessProvider);

    return optionQuoteSuccess.match(
      () => SizedBox(),
      (quoteSuccess) => Column(
        children: [
          SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: SideSwapColors.darkCerulean,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  MarketDeliverRow(
                    deliverAsset: quoteSuccess.deliverAsset,
                    deliverAmount: quoteSuccess.deliverAmount,
                  ),
                  SizedBox(height: 4),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: SideSwapColors.glacier.withValues(alpha: 0.4),
                  ),
                  SizedBox(height: 4),
                  MarketReceiveRow(
                    receiveAsset: quoteSuccess.receiveAsset,
                    receiveAmount: quoteSuccess.receiveAmount,
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MarketAmountError extends ConsumerWidget {
  const MarketAmountError({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final optionQuoteError = ref.watch(marketQuoteErrorProvider);

    return optionQuoteError.match(
      () => SizedBox(),
      (quoteError) => Column(
        children: [
          SizedBox(height: 10),
          Row(
            children: [
              Flexible(
                child: Text(
                  quoteError.error,
                  textAlign: TextAlign.start,
                  softWrap: true,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: SideSwapColors.bitterSweet,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MarketLowBalanceError extends ConsumerWidget {
  const MarketLowBalanceError({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final optionLowBalance = ref.watch(marketQuoteLowBalanceErrorProvider);

    return optionLowBalance.match(
      () => SizedBox(),
      (lowBalance) => DefaultTextStyle(
        style: Theme.of(
          context,
        ).textTheme.titleSmall!.copyWith(color: SideSwapColors.bitterSweet),
        child: Column(
          children: [
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: SideSwapColors.darkCerulean,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    MarketDeliverRow(
                      deliverAsset: lowBalance.deliverAsset,
                      deliverAmount: lowBalance.deliverAmount,
                      isError: true,
                    ),
                    SizedBox(height: 4),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: SideSwapColors.glacier.withValues(alpha: 0.4),
                    ),
                    SizedBox(height: 4),
                    MarketReceiveRow(
                      receiveAsset: lowBalance.receiveAsset,
                      receiveAmount: lowBalance.receiveAmount,
                      isError: true,
                    ),
                    SizedBox(height: 4),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: SideSwapColors.glacier.withValues(alpha: 0.4),
                    ),
                    SizedBox(height: 4),
                    MarketAssetRow(
                      asset: lowBalance.deliverAsset,
                      amount: lowBalance.availableAmount,
                      isError: true,
                      label: 'Available'.tr(),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MarketLowBalanceErrorRow extends ConsumerWidget {
  final String description;
  final String amount;
  final Option<Asset> optionAsset;

  const MarketLowBalanceErrorRow(
    this.description,
    this.amount,
    this.optionAsset, {
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyle = Theme.of(
      context,
    ).textTheme.titleSmall?.copyWith(color: SideSwapColors.bitterSweet);

    return Row(
      children: [
        Text(description, style: textStyle),
        Spacer(),
        Text(amount, style: textStyle),
        optionAsset.match(
          () => SizedBox(),
          (asset) => SizedBox(
            width: 80,
            child: Row(
              children: [
                SizedBox(width: 4),
                ref
                    .read(assetImageRepositoryProvider)
                    .getVerySmallImage(asset.assetId),
                Spacer(),
                Text(asset.ticker, style: textStyle),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class MarketUnregisteredGaidError extends ConsumerWidget {
  const MarketUnregisteredGaidError({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyle = Theme.of(
      context,
    ).textTheme.titleSmall?.copyWith(color: SideSwapColors.bitterSweet);

    final optionUnregisteredGaid = ref.watch(
      marketQuoteUnregisteredGaidProvider,
    );

    return optionUnregisteredGaid.match(
      () => SizedBox(),
      (quoteUnregisteredGaid) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 6),
          Text('Unregistered AMP ID'.tr(), style: textStyle),
          SizedBox(height: 6),
          Text('Register AMP ID at:'.tr(), style: textStyle),
          SizedBox(height: 6),
          DUrlLink(
            text: 'https://${quoteUnregisteredGaid.domainAgent}',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              decoration: TextDecoration.underline,
              color: SideSwapColors.brightTurquoise,
            ),
          ),
        ],
      ),
    );
  }
}

class LimitPanel extends HookConsumerWidget {
  const LimitPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final optionMarketInfo = ref.watch(subscribedMarketInfoProvider);
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

        var authorized = ref.read(marketOneTimeAuthorizedProvider);

        if (!ref.read(marketOneTimeAuthorizedProvider)) {
          authorized =
              await ref
                  .read(marketOneTimeAuthorizedProvider.notifier)
                  .authorize();
        }

        if (!authorized) {
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

    return optionMarketInfo.match(
      () => SizedBox(),
      (_) => optionAssetPair.match(
        () => SizedBox(),
        (assetPair) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border.all(width: 1, color: SideSwapColors.blumine),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: SizedBox(
              width: 370,
              height: 331,
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.only(left: 8, right: 8, top: 6),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        children: [
                          LimitAmountTextField(
                            onEditingComplete: () {
                              tradeCallback();
                            },
                          ),
                          LimitPriceTextField(
                            onEditingComplete: () {
                              tradeCallback();
                            },
                          ),
                          LimitPanelTtl(),
                          LimitPanelOrderType(),
                          LimitPanelOfflineSwap(),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    sliver: SliverFillRemaining(
                      hasScrollBody: false,
                      child: MarketOrderButton(
                        isSell: tradeDirState == TradeDir.SELL,
                        onPressed:
                            tradeButtonEnabled
                                ? () {
                                  tradeCallback();
                                }
                                : null,
                        text: 'Continue'.tr().toUpperCase(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LimitPanelOrderType extends ConsumerWidget {
  const LimitPanelOrderType({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderType = ref.watch(marketLimitOrderTypeNotifierProvider);

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SwitchButton(
            width: 142,
            height: 24,
            borderRadius: 8,
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

class LimitPanelOfflineSwap extends ConsumerWidget {
  const LimitPanelOfflineSwap({this.forceOfflineOnly = false, super.key});

  final bool forceOfflineOnly;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offlineSwapType = ref.watch(marketLimitOfflineSwapProvider);
    final isJadeWallet = ref.watch(isJadeWalletProvider);

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SwitchButton(
            width: 142,
            height: 24,
            borderRadius: 8,
            borderWidth: 2,
            fontSize: 13,
            activeText: 'Online'.tr(),
            inactiveText: 'Offline'.tr(),
            value: offlineSwapType == OfflineSwapType.empty(),
            onToggle:
                isJadeWallet || forceOfflineOnly
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

class LimitPanelTtl extends HookConsumerWidget {
  const LimitPanelTtl({super.key});

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
    final buttonThemes =
        ref.watch(desktopAppThemeNotifierProvider).buttonThemeData;
    final limitTtlFlag = ref.watch(limitTtlFlagNotifierProvider);

    return Row(
      children: [
        Spacer(),
        Flexible(
          child: DButton(
            key: buttonKey,
            style:
                clicked.value
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
                LimitTtlFlag result => ref
                    .read(limitTtlFlagNotifierProvider.notifier)
                    .setState(result),
                _ => ref.invalidate(limitTtlFlagNotifierProvider),
              });

              clicked.value = false;
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 9),
              child: SizedBox(
                height: 24,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
