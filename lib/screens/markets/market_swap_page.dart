import 'package:easy_localization/easy_localization.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/desktop/markets/widgets/balance_line.dart';
import 'package:sideswap/desktop/markets/widgets/market_order_button.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/providers/jade_provider.dart';
import 'package:sideswap/providers/preview_order_dialog_providers.dart';
import 'package:sideswap/providers/quote_event_providers.dart';
import 'package:sideswap/screens/markets/widgets/market_amount_text_field.dart';
import 'package:sideswap/desktop/markets/widgets/market_order_panel.dart';
import 'package:sideswap/listeners/markets_page_listener.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/screens/markets/widgets/market_header.dart';
import 'package:sideswap/screens/markets/widgets/market_index_price.dart';
import 'package:sideswap/screens/markets/widgets/market_preview_order_dialog_common_body.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

const mobileOrderPreviewRouteName = '/mobileOrderPreview';

class MarketSwapPage extends HookConsumerWidget {
  const MarketSwapPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tradeDirState = ref.watch(tradeDirStateNotifierProvider);
    final tradeButtonEnabled = ref.watch(marketOrderTradeButtonEnabledProvider);
    final marketTradeRepository = ref.watch(marketTradeRepositoryProvider);
    final optionQuoteSuccess = ref.watch(marketQuoteSuccessProvider);
    final jadeLockRepository = ref.watch(jadeLockRepositoryProvider);
    final marketOrderButtonText = ref.watch(marketOrderButtonTextProvider);

    final marketOrderButtonPressedCallback = useMemoized(
      () => switch (jadeLockRepository.isUnlocked()) {
        true => switch (tradeButtonEnabled) {
          true => () async {
            FocusManager.instance.primaryFocus?.unfocus();

            await marketTradeRepository.makeSwapTrade(
              context: context,
              optionQuoteSuccess: optionQuoteSuccess,
            );
          },
          _ => null,
        },
        _ => jadeLockRepository.refreshJadeLockState,
      },
      [
        jadeLockRepository.lockState,
        tradeButtonEnabled,
        optionQuoteSuccess,
        marketTradeRepository,
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
            Flexible(child: MarketSwapBody()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: MarketOrderButton(
                isSell: tradeDirState == TradeDir.SELL,
                onPressed: marketOrderButtonPressedCallback,
                text: marketOrderButtonText,
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class MarketSwapBody extends HookConsumerWidget {
  const MarketSwapBody({this.onEditingComplete, super.key});

  final void Function()? onEditingComplete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: SizedBox(height: 16)),
          SliverToBoxAdapter(child: MarketIndexPrice()),
          SliverToBoxAdapter(child: SizedBox(height: 16)),
          SliverToBoxAdapter(child: MarketAssetSwitchButtons(height: 40)),
          SliverToBoxAdapter(child: SizedBox(height: 16)),
          SliverToBoxAdapter(child: MarketSwapAmount()),
        ],
      ),
    );
  }
}

class MarketSwapAmount extends HookConsumerWidget {
  const MarketSwapAmount({this.onEditingComplete, this.onChanged, super.key});

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
    final optionAcceptQuoteError = ref.watch(marketAcceptQuoteErrorProvider);
    final tradeDirState = ref.watch(tradeDirStateNotifierProvider);
    final marketTradeRepository = ref.watch(marketTradeRepositoryProvider);
    final optionQuoteSuccess = ref.watch(marketQuoteSuccessProvider);

    final amountController = useTextEditingController();
    final amountFocusNode = useFocusNode();

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
      final asset = marketSideState == MarketSideState.base()
          ? baseAsset
          : quoteAsset;

      final assetBalance = ref.read(
        availableBalanceForAssetIdProvider(asset.assetId),
      );

      amountController.text = ref
          .watch(amountToStringProvider)
          .amountToString(
            AmountToStringParameters(
              amount: assetBalance,
              trailingZeroes: false,
              precision: asset.precision,
            ),
          );
    }, [marketSideState]);

    return optionBaseAsset.match(
      () => SizedBox(),
      (baseAsset) => optionQuoteAsset.match(
        () => SizedBox(),
        (quoteAsset) => Column(
          children: [
            MarketAmountTextField(
              caption: 'Amount'.tr(),
              asset: marketSideState == MarketSideState.base()
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
              showMaxButton: tradeDirState == TradeDir.SELL,
              onMaxPressed: () {
                onMaxPressedCallback(baseAsset, quoteAsset);
              },
            ),
            BalanceLine(amountSide: true),
            MarketAmountError(),
            MarketLowBalanceError(),
            MarketQuoteSuccess(),
            MarketUnregisteredGaidError(),
          ],
        ),
      ),
    );
  }
}

class MobileOrderPreviewDialog extends HookConsumerWidget {
  const MobileOrderPreviewDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final acceptButtonClicked = useState(false);

    final optionQuoteSuccess = ref.watch(
      previewOrderQuoteSuccessNotifierProvider,
    );
    final orderSignTtl = ref.watch(orderSignTtlProvider);

    final closeCallback = useCallback(() {
      Navigator.of(context, rootNavigator: false).popUntil((route) {
        return route.settings.name != mobileOrderPreviewRouteName;
      });

      Future.microtask(() {
        ref.invalidate(previewOrderQuoteSuccessNotifierProvider);
      });
    });

    ref.listen(previewOrderDialogAcceptStateProvider, (_, state) {
      (switch (state) {
        PreviewOrderDialogAcceptStateAccepted() => () {
          closeCallback();
        },
        _ => () {},
      })();
    });

    final optionAccepQuoteSuccess = ref.watch(marketAcceptQuoteSuccessProvider);
    final optionAcceptQuoteError = ref.watch(marketAcceptQuoteErrorProvider);

    useEffect(() {
      optionAccepQuoteSuccess.match(() {}, (txid) {
        ref.read(quoteEventNotifierProvider.notifier).stopQuotes();
        ref.invalidate(quoteEventNotifierProvider);
        ref.invalidate(marketQuoteNotifierProvider);
      });

      return;
    }, [optionAccepQuoteSuccess]);

    useEffect(() {
      optionAcceptQuoteError.match(() {}, (error) {
        ref.read(quoteEventNotifierProvider.notifier).stopQuotes();
        ref.invalidate(quoteEventNotifierProvider);
        ref.invalidate(marketQuoteNotifierProvider);
        closeCallback();
      });

      return;
    }, [optionAcceptQuoteError]);

    useEffect(() {
      if (orderSignTtl != 0) {
        return;
      }

      Future.microtask(() => closeCallback());

      return;
    }, [orderSignTtl]);

    final previewOrderDialogAcceptState = ref.watch(
      previewOrderDialogAcceptStateProvider,
    );

    return SideSwapScaffold(
      backgroundColor: SideSwapColors.chathamsBlue,
      sideSwapBackground: false,
      appBar: CustomAppBar(
        title: 'Swap proposal'.tr(),
        onPressed: () {
          closeCallback();
        },
      ),
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          closeCallback();
        }
      },
      body: optionQuoteSuccess.match(
        () {
          return SizedBox();
        },
        (quoteSuccess) {
          return Column(
            children: [
              MarketPreviewOrderDialogCommonBody(),
              Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomBigButton(
                        height: 54,
                        onPressed: () {
                          closeCallback();
                        },
                        child: switch (previewOrderDialogAcceptState) {
                          PreviewOrderDialogAcceptStateAccepting() => Text(
                            'Close'.tr(),
                          ),
                          _ => Text('Cancel'.tr()),
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: CustomBigButton(
                        height: 54,
                        onPressed:
                            !acceptButtonClicked.value &&
                                previewOrderDialogAcceptState
                                    is PreviewOrderDialogAcceptStateEmpty
                            ? () async {
                                ref
                                    .read(
                                      jadeAuthInProgressStateNotifierProvider
                                          .notifier,
                                    )
                                    .setState(true);
                                final authSucceed = await ref
                                    .read(walletProvider)
                                    .isAuthenticated();
                                ref.invalidate(
                                  jadeAuthInProgressStateNotifierProvider,
                                );
                                if (!authSucceed) {
                                  return;
                                }

                                final msg = To();
                                msg.acceptQuote = To_AcceptQuote(
                                  quoteId: Int64(quoteSuccess.quoteId),
                                );
                                ref.read(walletProvider).sendMsg(msg);

                                // now app will wait for market accept quote success or error provider
                                acceptButtonClicked.value = true;
                              }
                            : null,
                        child: Row(
                          children: [
                            Spacer(),
                            Text('Accept'.tr()),
                            Expanded(
                              child: Row(
                                children: [
                                  const SizedBox(width: 4),
                                  switch (previewOrderDialogAcceptState) {
                                    PreviewOrderDialogAcceptStateAccepting() =>
                                      const SpinKitCircle(
                                        color: Colors.white,
                                        size: 32,
                                      ),
                                    _ => const SizedBox(),
                                  },
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
            ],
          );
        },
      ),
    );
  }
}
