import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/providers/exchange_providers.dart';
import 'package:sideswap/providers/satoshi_providers.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/screens/instant_swap/listeners/instant_swap_listener.dart';
import 'package:sideswap/screens/instant_swap/widgets/dropdown_amount_text_field.dart';
import 'package:sideswap/screens/instant_swap/widgets/instant_swap_divider.dart';

class InstantSwap extends HookConsumerWidget {
  const InstantSwap({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const InstantSwapListener(),
        const SizedBox(height: 18),
        InstantSwapTitle(),
        const SizedBox(height: 16),
        InstantSwapTopDropdownAmountTextField(),
        const SizedBox(height: 6),
        InstantSwapDivider(),
        ColoredBox(
          color: SideSwapColors.blumine,
          child: Column(
            children: [
              const SizedBox(height: 6),
              InstantSwapBottomDropdownAmountTextField(disabledAmount: false),
            ],
          ),
        ),
        Flexible(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                  color: SideSwapColors.blumine,
                ),
              ),
              Column(
                children: [
                  Spacer(),
                  InstantSwapButton(),
                  const SizedBox(height: 16),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class InstantSwapTitle extends ConsumerWidget {
  const InstantSwapTitle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: 36,
        child: Text(
          'Instant Swap'.tr(),
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}

class InstantSwapTopDropdownAmountTextField extends HookConsumerWidget {
  const InstantSwapTopDropdownAmountTextField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    final focusNode = useFocusNode();
    final errorText = useState<String?>(null);

    final optionError = ref.watch(instantSwapTopDropdownErrorProvider);
    errorText.value = optionError.match(() => null, (error) => error);

    final optionTopAccountAsset = ref.watch(exchangeTopAssetProvider);

    return optionTopAccountAsset.match(
      () {
        return SizedBox();
      },
      (topAccountAsset) {
        final topAssetSatoshiBalance = ref.watch(
          maxAvailableBalanceForAccountAssetProvider(topAccountAsset),
        );

        final topAssets = ref.watch(exchangeTopAssetListProvider);

        ref.listen(exchangeTopAmountProvider, (_, next) {
          if (next.isEmpty) {
            controller.clear();
            return;
          }

          if (next != controller.text) {
            controller.clear();
            controller.value = TextEditingValue(
              text: next,
              selection: TextSelection.collapsed(offset: next.length),
            );
          }
        });

        ref.listen(exchangeTopSatoshiAmountProvider, (_, next) {
          final optionExchangeSide = ref.read(exchangeSideProvider);
          final optionAssetPair = ref.read(exchangeAssetPairProvider);

          final optionTopAsset = ref.read(exchangeTopAssetProvider);
          final optionCurrentEditAsset = ref.read(
            exchangeCurrentEditAssetProvider,
          );
          if (optionCurrentEditAsset == optionTopAsset) {
            if (next == 0) {
              ref.read(exchangeQuoteNotifierProvider.notifier).stopQuotes();
              ref
                  .read(exchangeQuoteNotifierProvider.notifier)
                  .requestIndPriceQuote(optionExchangeSide, optionAssetPair);
            } else {
              optionTopAsset.match(() {}, (topAsset) {
                final topBalance = ref.read(
                  maxAvailableBalanceForAccountAssetProvider(topAsset),
                );
                final topSatoshiAmount = ref.read(
                  exchangeTopSatoshiAmountProvider,
                );

                if (topSatoshiAmount > topBalance) {
                  ref
                      .read(exchangeCustomErrorNotifierProvider.notifier)
                      .setState(ExchangeCustomError.balanceExceeded());
                  ref.invalidate(exchangeBottomAmountProvider);
                }

                ref
                    .read(exchangeQuoteNotifierProvider.notifier)
                    .startSellQuotes(next);
              });
            }
          }
        });

        ref.listen(exchangeQuoteSuccessProvider, (_, optionQuoteSuccess) {
          final optionTopAsset = ref.read(exchangeTopAssetProvider);
          final optionCurrentEditAsset = ref.read(
            exchangeCurrentEditAssetProvider,
          );

          if (optionTopAsset == optionCurrentEditAsset) {
            optionQuoteSuccess.match(() {
              final satoshiTopAmount = ref.read(
                exchangeTopSatoshiAmountProvider,
              );
              if (satoshiTopAmount == 0) {
                ref.invalidate(exchangeBottomAmountProvider);
              }
            }, (_) {});
            return;
          }
        });

        useEffect(() {
          focusNode.requestFocus();

          return;
        }, const []);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: DropdownAmountTextField(
            controller: controller,
            focusNode: focusNode,
            showMaxButton: topAssetSatoshiBalance == 0 ? false : true,
            label: Text(
              'Deliver'.tr(),
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.normal,
                color: SideSwapColors.brightTurquoise,
              ),
            ),
            errorText: errorText.value,
            accountAssets: topAssets,
            accountAsset: topAccountAsset,
            onMaxPressed: () {
              final optionTopAccountAsset = ref.read(exchangeTopAssetProvider);
              final optionAsset = ref.read(
                assetFromAssetIdProvider(topAccountAsset.assetId),
              );

              optionAsset.match(() {}, (asset) {
                final customError = ref.read(
                  exchangeCustomErrorNotifierProvider,
                );

                // set Max Amount as max deliver from error
                if (customError is ExchangeCustomErrorDeliverExceeded &&
                    customError.maxDeliverAmount != null) {
                  final satoshiDeliverAmount = ref
                      .read(satoshiRepositoryProvider)
                      .satoshiForAmount(
                        assetId: topAccountAsset.assetId,
                        amount: customError.maxDeliverAmount!,
                      );

                  final newAmount = ref
                      .read(amountToStringProvider)
                      .amountToString(
                        AmountToStringParameters(
                          amount: satoshiDeliverAmount,
                          trailingZeroes: false,
                          precision: asset.precision,
                        ),
                      );

                  ref
                      .read(exchangeTopAmountProvider.notifier)
                      .setState(newAmount);
                  ref
                      .read(exchangeCurrentEditAssetProvider.notifier)
                      .setState(optionTopAccountAsset);
                  return;
                }

                // set Max Amount as max asset wallet balance (total)
                final balance = ref.read(
                  totalMaxAvailableBalanceForAssetProvider(
                    topAccountAsset.assetId,
                  ),
                );

                final newAmount = ref
                    .read(amountToStringProvider)
                    .amountToString(
                      AmountToStringParameters(
                        amount: balance,
                        trailingZeroes: false,
                        precision: asset.precision,
                      ),
                    );

                ref
                    .read(exchangeTopAmountProvider.notifier)
                    .setState(newAmount);
                ref
                    .read(exchangeCurrentEditAssetProvider.notifier)
                    .setState(optionTopAccountAsset);
              });
            },
            onAccountAssetChanged: (value) {
              // get old top and bottom assets
              final optionTopAsset = ref.read(exchangeTopAssetProvider);
              final optionBottomAsset = ref.read(exchangeBottomAssetProvider);

              // replace top asset
              if (topAssets.any((e) => e == value)) {
                ref.read(exchangeTopAssetProvider.notifier).setState(value);
              } else {
                return;
              }

              // refreshed available bottom asset list
              final bottomAssetList = ref.read(exchangeBottomAssetListProvider);

              optionTopAsset.match(
                () {},
                (topAsset) => optionBottomAsset.match(() {}, (bottomAsset) {
                  // if old bottom asset on the list then replace
                  if (bottomAssetList.any((e) => e == bottomAsset)) {
                    ref
                        .read(exchangeBottomAssetProvider.notifier)
                        .setState(bottomAsset);
                    return;
                  }

                  // else set old top asset as bottom (swap assets)
                  ref
                      .read(exchangeBottomAssetProvider.notifier)
                      .setState(topAsset);
                }),
              );
            },
            onChanged: (value) {
              ref.read(exchangeTopAmountProvider.notifier).setState(value);
              ref
                  .read(exchangeCurrentEditAssetProvider.notifier)
                  .setState(optionTopAccountAsset);
              if (value.isEmpty) {
                ref.invalidate(exchangeBottomAmountProvider);
              }
            },
          ),
        );
      },
    );
  }
}

class InstantSwapBottomDropdownAmountTextField extends HookConsumerWidget {
  const InstantSwapBottomDropdownAmountTextField({
    this.disabledAmount = true,
    super.key,
  });

  final bool disabledAmount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    final focusNode = useFocusNode();

    final optionBottomAsset = ref.watch(exchangeBottomAssetProvider);
    final bottomAssetList = ref.watch(exchangeBottomAssetListProvider);

    ref.listen(exchangeBottomAmountProvider, (_, next) {
      if (next.isEmpty) {
        controller.clear();
        return;
      }

      final oldSelection = controller.selection;
      controller.value = TextEditingValue(text: next, selection: oldSelection);
    });

    ref.listen(exchangeBottomSatoshiAmountProvider, (_, bottomSatoshiAmount) {
      final optionExchangeSide = ref.read(exchangeSideProvider);
      final optionAssetPair = ref.read(exchangeAssetPairProvider);

      final optionBottomAsset = ref.read(exchangeBottomAssetProvider);
      final optionCurrentEditAsset = ref.read(exchangeCurrentEditAssetProvider);
      if (optionCurrentEditAsset == optionBottomAsset) {
        if (bottomSatoshiAmount == 0) {
          ref.read(exchangeQuoteNotifierProvider.notifier).stopQuotes();
          ref
              .read(exchangeQuoteNotifierProvider.notifier)
              .requestIndPriceQuote(optionExchangeSide, optionAssetPair);
        } else {
          optionBottomAsset.match(() {}, (bottomAsset) {
            ref
                .read(exchangeQuoteNotifierProvider.notifier)
                .startBuyQuotes(bottomSatoshiAmount);
          });
        }
      }
    });

    ref.listen(exchangeQuoteSuccessProvider, (_, optionQuoteSuccess) {
      final optionBottomAsset = ref.read(exchangeBottomAssetProvider);
      final optionCurrentEditAsset = ref.read(exchangeCurrentEditAssetProvider);

      if (optionBottomAsset == optionCurrentEditAsset) {
        optionQuoteSuccess.match(() {
          final satoshiBottomAmount = ref.read(
            exchangeBottomSatoshiAmountProvider,
          );
          if (satoshiBottomAmount == 0) {
            ref.invalidate(exchangeTopAmountProvider);
          }
        }, (_) {});
        return;
      }
    });

    final errorText = useState<String?>(null);
    ref.watch(exchangeCustomErrorNotifierProvider);

    ref.listen(exchangeCustomErrorNotifierProvider, (_, customError) {
      final optionBottomAsset = ref.read(exchangeBottomAssetProvider);
      final optionCurrentEditAsset = ref.read(exchangeCurrentEditAssetProvider);

      if (optionBottomAsset != optionCurrentEditAsset) {
        errorText.value = null;
        return;
      }

      errorText.value = switch (customError) {
        ExchangeCustomErrorBalanceExceeded() => 'Balance exceeded'.tr(),
        _ => null,
      };
    });

    return optionBottomAsset.match(
      () => const SizedBox(),
      (bottomAsset) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: DropdownAmountTextField(
          disabledAmount: disabledAmount,
          controller: controller,
          focusNode: focusNode,
          errorText: errorText.value,
          label: Text(
            'Receive'.tr(),
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.normal,
              color: SideSwapColors.brightTurquoise,
            ),
          ),
          accountAssets: bottomAssetList,
          accountAsset: bottomAsset,
          onMaxPressed: () {},
          onAccountAssetChanged: (value) {
            ref
                .read(exchangeBottomAssetProvider.notifier)
                .setState(bottomAssetList.firstWhere((e) => e == value));
          },
          onChanged: (value) {
            ref.read(exchangeBottomAmountProvider.notifier).setState(value);
            final optionBottomAsset = ref.read(exchangeBottomAssetProvider);
            ref
                .read(exchangeCurrentEditAssetProvider.notifier)
                .setState(optionBottomAsset);
            if (value.isEmpty) {
              ref.invalidate(exchangeTopAmountProvider);
            }
          },
        ),
      ),
    );
  }
}

class InstantSwapButton extends ConsumerWidget {
  const InstantSwapButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final optionQuoteSuccess = ref.watch(exchangeQuoteSuccessProvider);
    final enabled = ref.watch(exchangeSwapButtonEnabledProvider);
    final exchangeQuoteNotifier = ref.watch(
      exchangeQuoteNotifierProvider.notifier,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: CustomBigButton(
        width: double.infinity,
        height: 54,
        backgroundColor: SideSwapColors.brightTurquoise,
        onPressed:
            enabled
                ? () {
                  exchangeQuoteNotifier.acceptQuote(
                    optionQuoteSuccess: optionQuoteSuccess,
                  );
                }
                : null,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Consumer(
              builder: (context, ref, _) {
                final buttonText = ref.watch(exchangeSwapButtonTextProvider);

                return Text(
                  buttonText,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                );
              },
            ),
            Consumer(
              builder: (context, ref, _) {
                final acceptQuoteState = ref.watch(
                  exchangeAccepQuoteStateNotifierProvider,
                );
                if (acceptQuoteState is ExchangeAcceptQuoteStateInProgress) {
                  return const Padding(
                    padding: EdgeInsets.only(left: 84),
                    child: SizedBox(
                      width: 32,
                      height: 32,
                      child: SpinKitCircle(color: Colors.white, size: 32),
                    ),
                  );
                }

                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }
}
