import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/providers/desktop_dialog_providers.dart';
import 'package:sideswap/providers/exchange_providers.dart';
import 'package:sideswap/providers/jade_provider.dart';
import 'package:sideswap/providers/pegs_provider.dart';
import 'package:sideswap/providers/quote_event_providers.dart';
import 'package:sideswap/providers/tx_provider.dart';
import 'package:sideswap/providers/ui_state_args_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/screens/flavor_config.dart';

class InstantSwapListener extends HookConsumerWidget {
  const InstantSwapListener({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(exchangeQuoteProvider, (_, _) {});
    ref.listen(exchangeIndexPriceProvider, (_, _) {});
    ref.listen(jadeOneTimeAuthorizationProvider, (_, _) {});

    final optionAssetPair = ref.watch(exchangeAssetPairProvider);
    final optionExchangeSide = ref.watch(exchangeSideProvider);
    final optionTopAsset = ref.watch(exchangeTopAssetProvider);
    final optionBottomAsset = ref.watch(exchangeBottomAssetProvider);

    ref.listen(exchangeTopSatoshiAmountProvider, (_, next) {
      if (next == 0) {
        Future.microtask(() => ref.invalidate(exchangeQuoteErrorProvider));
      }
    });

    useEffect(
      () {
        Future.microtask(() {
          ref
              .read(exchangeQuoteProvider.notifier)
              .requestIndPriceQuote(optionExchangeSide, optionAssetPair);
        });
        return;
      },
      [optionExchangeSide, optionAssetPair, optionTopAsset, optionBottomAsset],
    );

    final optionAccepQuoteSuccess = ref.watch(
      exchangeAcceptQuoteSuccessProvider,
    );
    final allTxSorted = ref.watch(allTxsSortedProvider);
    final exchangeAcceptState = ref.watch(exchangeAccepQuoteStateProvider);

    useEffect(() {
      optionAccepQuoteSuccess.match(
        () => () {},
        (txid) => () {
          final index = allTxSorted.indexWhere((e) => e.tx.txid == txid);
          if (index < 0) {
            return;
          }

          final transItem = allTxSorted[index];
          final allPegsById = ref.read(allPegsByIdProvider);

          Future.microtask(() async {
            ref.invalidate(exchangeQuoteProvider);
            ref.invalidate(acceptQuoteProvider);

            if (!FlavorConfig.isDesktop) {
              ref.read(walletProvider).showTxDetails(transItem);
            } else {
              await ref
                  .read(desktopDialogProvider)
                  .showTx(
                    transItem,
                    isPeg: transItem.hasPeg()
                        ? allPegsById.containsKey(
                            transItem.peg.isPegIn
                                ? transItem.peg.txidRecv
                                : transItem.peg.txidSend,
                          )
                        : false,
                  );
              final walletMainArguments = ref.read(uiStateArgsProvider);
              ref
                  .read(uiStateArgsProvider.notifier)
                  .setWalletMainArguments(
                    walletMainArguments.fromIndexDesktop(0),
                  );
            }
            ref.invalidate(exchangeAccepQuoteStateProvider);
            // unfreeze quote values
            ref.invalidate(instantSwapStateProvider);
          });
        },
      )();

      return;
    }, [optionAccepQuoteSuccess, allTxSorted]);

    final optionAcceptQuoteError = ref.watch(exchangeAcceptQuoteErrorProvider);

    useEffect(() {
      optionAcceptQuoteError.match(
        () => () {},
        (error) => () {
          Future.microtask(() async {
            await ref.read(desktopDialogProvider).showAcceptQuoteErrorDialog();
            ref.invalidate(exchangeQuoteProvider);
            ref.invalidate(acceptQuoteProvider);
            // unfreeze quote values
            ref.invalidate(instantSwapStateProvider);
          });
        },
      )();

      return;
    }, [optionAcceptQuoteError]);

    // cleanup previous accept quote
    useEffect(() {
      final topSatoshiAmount = ref.read(exchangeTopSatoshiAmountProvider);

      if (exchangeAcceptState is ExchangeAcceptQuoteStateEmpty &&
          topSatoshiAmount != 0) {
        Future.microtask(() => ref.invalidate(acceptQuoteProvider));
      }

      return;
    }, [exchangeAcceptState]);

    return const SizedBox();
  }
}
