import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/providers/amp_register_provider.dart';
import 'package:sideswap/providers/chart_providers.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/desktop_dialog_providers.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/pegs_provider.dart';
import 'package:sideswap/providers/stokr_providers.dart';
import 'package:sideswap/providers/tx_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap/screens/markets/widgets/market_accept_quote_success_dialog.dart';
import 'package:sideswap/screens/markets/widgets/market_limit_order_submit_dialog.dart';
import 'package:sideswap/screens/markets/widgets/market_start_order_error_dialog.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class MarketsPageListener extends HookConsumerWidget {
  const MarketsPageListener({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(limitOrderPriceAmountControllerNotifierProvider);
    ref.watch(marketEditDetailsOrderNotifierProvider);
    ref.watch(marketIndexPriceProvider);
    ref.watch(marketLastPriceProvider);
    ref.watch(chartsNotifierProvider);
    ref.watch(marketPublicOrdersNotifierProvider);
    ref.watch(marketOneTimeAuthorizedProvider);

    final subscribedAssetPair = ref.watch(
      marketSubscribedAssetPairNotifierProvider,
    );
    final stableMarkets = ref.watch(
      marketInfoByMarketTypeProvider(MarketType_.STABLECOIN),
    );

    useEffect(() {
      // set inital assetPair when data comes from BE
      if (subscribedAssetPair.isNone() && stableMarkets.isNotEmpty) {
        Future.microtask(
          () => ref
              .read(marketSubscribedAssetPairNotifierProvider.notifier)
              .setState(stableMarkets.first.assetPair),
        );
      }

      return;
    }, [stableMarkets, subscribedAssetPair]);

    final stokrSecurities = ref.watch(stokrSecuritiesProvider);
    final stokrSettingsModel =
        ref.watch(configurationProvider).stokrSettingsModel;
    final baseAsset = ref.watch(marketSubscribedBaseAssetProvider);
    final stokrLastSelectedAsset = ref.watch(
      stokrLastSelectedAssetNotifierProvider,
    );

    final stokrAssetRestrictedPopupCallback = useCallback((Asset asset) {
      final isStokrAsset = stokrSecurities.any(
        (element) => element.assetId == asset.assetId,
      );
      final hasAssetRestrictions = asset.hasAmpAssetRestrictions();

      if (!isStokrAsset || !hasAssetRestrictions) {
        return false;
      }

      if (stokrSettingsModel?.firstRun != false) {
        Future.microtask(
          () => ref
              .read(pageStatusNotifierProvider.notifier)
              .setStatus(Status.stokrRestrictionsInfo),
        );
        return true;
      }

      return false;
    });

    useEffect(() {
      baseAsset.match(() {}, (asset) {
        stokrLastSelectedAsset.match(
          () {
            stokrAssetRestrictedPopupCallback(asset);
          },
          (stokrAsset) {
            if (stokrAsset != asset) {
              stokrAssetRestrictedPopupCallback(asset);
            }
          },
        );

        Future.microtask(
          () => ref
              .read(stokrLastSelectedAssetNotifierProvider.notifier)
              .setLastSelectedAsset(asset),
        );
      });

      return;
    }, [baseAsset]);

    final showAcceptQuoteSuccessDialog = ref.watch(
      marketAcceptQuoteSuccessShowDialogNotifierProvider,
    );

    useEffect(() {
      if (showAcceptQuoteSuccessDialog) {
        Future.microtask(() async {
          ref
              .read(marketAcceptQuoteSuccessShowDialogNotifierProvider.notifier)
              .setState(false);

          if (!context.mounted) {
            return;
          }
          await showDialog<void>(
            context: context,
            builder: (context) {
              return MarketAcceptQuoteSuccessDialog();
            },
            routeSettings: RouteSettings(name: acceptQuoteSuccessRouteName),
            useRootNavigator: false,
          );
        });
      }

      return;
    }, [showAcceptQuoteSuccessDialog]);

    final optionAccepQuoteSuccess = ref.watch(marketAcceptQuoteSuccessProvider);
    final optionAcceptQuoteError = ref.watch(acceptQuoteErrorProvider);
    final allTxSorted = ref.watch(allTxsSortedProvider);

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

          Navigator.of(context, rootNavigator: false).popUntil((route) {
            return route.settings.name != acceptQuoteSuccessRouteName;
          });

          Future.microtask(() async {
            if (!FlavorConfig.isDesktop) {
              ref.read(walletProvider).showTxDetails(transItem);
            } else {
              await ref
                  .read(desktopDialogProvider)
                  .showTx(
                    transItem,
                    isPeg: allPegsById.containsKey(transItem.id),
                  );
              ref.invalidate(marketQuoteNotifierProvider);
              ref.invalidate(marketAcceptQuoteNotifierProvider);
            }
          });
        },
      )();

      return;
    }, [optionAccepQuoteSuccess, allTxSorted]);

    useEffect(() {
      optionAcceptQuoteError.match(
        () => () {},
        (error) => () {
          Future.microtask(() async {
            await ref.read(desktopDialogProvider).showAcceptQuoteErrorDialog();
            ref.invalidate(marketQuoteNotifierProvider);
            ref.invalidate(marketAcceptQuoteNotifierProvider);
          });
        },
      )();

      return;
    }, [optionAcceptQuoteError]);

    final optionOrderSubmit = ref.watch(orderSubmitNotifierProvider);

    useEffect(() {
      optionOrderSubmit.match(
        () => () {},
        (orderSubmit) => () {
          if (orderSubmit.hasSubmitSucceed() ||
              orderSubmit.hasError() ||
              orderSubmit.hasUnregisteredGaid()) {
            Future.microtask(() async {
              if (!context.mounted) {
                return;
              }
              await showDialog<void>(
                context: context,
                builder: (context) {
                  return OrderSubmitDialog();
                },
                routeSettings: RouteSettings(name: orderSubmitRouteName),
                useRootNavigator: false,
                barrierDismissible: false,
              );
            });
          }
        },
      )();

      return;
    }, [optionOrderSubmit]);

    final marketTradeRepository = ref.watch(marketTradeRepositoryProvider);
    final optionStartOrderQuoteSuccess = ref.watch(
      marketStartOrderQuoteSuccessProvider,
    );

    useEffect(() {
      Future.microtask(() {
        optionStartOrderQuoteSuccess.match(() {}, (quoteSuccess) async {
          ref.invalidate(marketQuoteNotifierProvider);

          await marketTradeRepository.makeSwapTrade(
            context: context,
            optionQuoteSuccess: optionStartOrderQuoteSuccess,
          );

          ref.invalidate(marketStartOrderNotifierProvider);
        });
      });

      return;
    }, [optionStartOrderQuoteSuccess, marketTradeRepository]);

    final optionStartOrderQuoteLowBalance = ref.watch(
      marketStartOrderLowBalanceErrorProvider,
    );

    useEffect(() {
      optionStartOrderQuoteLowBalance.match(() {}, (quoteLowBalance) async {
        Future.microtask(() async {
          if (!context.mounted) {
            return;
          }
          ref.invalidate(marketStartOrderNotifierProvider);

          await showDialog<void>(
            context: context,
            builder: (context) {
              return MarketStartOrderLowBalanceErrorDialog(
                optionStartOrderQuoteLowBalance:
                    optionStartOrderQuoteLowBalance,
              );
            },
            routeSettings: RouteSettings(
              name: marketStartOrderLowBalanceErrorRouteName,
            ),
            useRootNavigator: false,
          );

          ref.invalidate(marketQuoteNotifierProvider);
        });
      });
      return;
    }, [optionStartOrderQuoteLowBalance]);

    final optionStartOrderQuoteError = ref.watch(
      marketStartOrderQuoteErrorProvider,
    );

    useEffect(() {
      optionStartOrderQuoteError.match(() {}, (quoteError) async {
        Future.microtask(() async {
          if (!context.mounted) {
            return;
          }

          ref.invalidate(marketStartOrderNotifierProvider);

          await showDialog<void>(
            context: context,
            builder: (context) {
              return MarketStartOrderQuoteErrorDialog(
                optionStartOrderQuoteError: optionStartOrderQuoteError,
              );
            },
            routeSettings: RouteSettings(
              name: marketStartOrderQuoteErrorRouteName,
            ),
            useRootNavigator: false,
          );

          ref.invalidate(marketQuoteNotifierProvider);
        });
      });
      return;
    }, [optionStartOrderQuoteError]);

    final optionStartOrderError = ref.watch(
      marketStartOrderErrorNotifierProvider,
    );

    useEffect(() {
      Future.microtask(() {
        optionStartOrderError.match(() {}, (startOrderError) async {
          if (!context.mounted) {
            return;
          }
          ref.invalidate(marketStartOrderNotifierProvider);

          await showDialog<void>(
            context: context,
            builder: (context) {
              return MarketStartOrderErrorDialog();
            },
            routeSettings: RouteSettings(name: marketStartOrderErrorRouteName),
            useRootNavigator: false,
            barrierDismissible: false,
          );

          ref.invalidate(marketStartOrderErrorNotifierProvider);
          ref.invalidate(marketQuoteNotifierProvider);
        });
      });

      return;
    }, [optionStartOrderError]);

    final optionCurrentQuote = ref.watch(marketQuoteNotifierProvider);
    final optionStartOrderId = ref.watch(marketStartOrderNotifierProvider);

    ref.listen(marketSideStateNotifierProvider, (_, _) {
      optionStartOrderId.match(
        () => optionCurrentQuote.match(() {}, (_) {
          Future.microtask(() {
            ref.invalidate(limitOrderPriceAmountControllerNotifierProvider);
            ref.invalidate(marketOrderAmountControllerNotifierProvider);
            ref.invalidate(marketQuoteNotifierProvider);
          });
        }),
        (_) {},
      );
    });

    return const SizedBox();
  }
}
