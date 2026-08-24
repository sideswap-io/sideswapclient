import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/providers/amp_register_provider.dart';
import 'package:sideswap/providers/chart_providers.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/desktop_dialog_providers.dart';
import 'package:sideswap/providers/jade_provider.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/screens/markets/market_swap_dialog.dart';
import 'package:sideswap/providers/page_storage_provider.dart';
import 'package:sideswap/providers/pegs_provider.dart';
import 'package:sideswap/providers/quote_event_providers.dart';
import 'package:sideswap/providers/stokr_providers.dart';
import 'package:sideswap/providers/tx_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap/screens/markets/widgets/market_limit_order_submit_dialog.dart';
import 'package:sideswap/screens/markets/widgets/market_start_order_error_dialog.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class MarketsPageListener extends HookConsumerWidget {
  const MarketsPageListener({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(limitOrderAmountControllerProvider);
    ref.watch(limitOrderPriceControllerProvider);
    ref.watch(marketEditDetailsOrderProvider);
    ref.watch(marketIndexPriceProvider);
    ref.watch(marketLastPriceProvider);
    ref.watch(chartsProvider);
    ref.watch(marketPublicOrdersProvider);
    ref.watch(jadeOneTimeAuthorizationProvider);
    ref.watch(pageStorageKeyDataProvider);
    ref.watch(debouncedMarketPublicOrdersProvider);

    final subscribedAssetPair = ref.watch(marketSubscribedAssetPairProvider);
    final stableMarkets = ref.watch(
      marketInfoByMarketTypeProvider(MarketType_.STABLECOIN),
    );

    useEffect(() {
      Future.microtask(() {
        ref.invalidate(pageStorageKeyDataProvider);
      });

      return;
    }, const []);

    useEffect(() {
      // set inital assetPair when data comes from BE
      if (subscribedAssetPair.isNone() && stableMarkets.isNotEmpty) {
        Future.microtask(
          () => ref
              .read(marketSubscribedAssetPairProvider.notifier)
              .setState(stableMarkets.first.assetPair),
        );
      }

      return;
    }, [stableMarkets, subscribedAssetPair]);

    final stokrSecurities = ref.watch(stokrSecuritiesProvider);
    final stokrSettingsModel = ref
        .watch(configurationProvider)
        .stokrSettingsModel;
    final baseAsset = ref.watch(marketSubscribedBaseAssetProvider);
    final stokrLastSelectedAsset = ref.watch(stokrLastSelectedAssetProvider);

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
              .read(pageStatusProvider.notifier)
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
              .read(stokrLastSelectedAssetProvider.notifier)
              .setLastSelectedAsset(asset),
        );
      });

      return;
    }, [baseAsset]);

    final optionAccepQuoteSuccess = ref.watch(marketAcceptQuoteSuccessProvider);
    final optionAcceptQuoteError = ref.watch(marketAcceptQuoteErrorProvider);
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

          Future.microtask(() async {
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
              ref.invalidate(marketQuoteProvider);
              ref.invalidate(acceptQuoteProvider);
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
            ref.invalidate(marketQuoteProvider);
            ref.invalidate(acceptQuoteProvider);
          });
        },
      )();

      return;
    }, [optionAcceptQuoteError]);

    final uiOwnOrders = ref.watch(marketUiOwnOrdersProvider);
    final optionOrderSubmit = ref.watch(orderSubmitProvider);

    useEffect(() {
      optionOrderSubmit.match(() {}, (orderSubmit) {
        final uiOwnOrder = uiOwnOrders.firstWhereOrNull(
          (e) => e.ownOrder.orderId == orderSubmit.submitSucceed.orderId,
        );

        // set submit order success state
        if (orderSubmit.hasSubmitSucceed() && uiOwnOrder != null) {
          Future.microtask(
            () => ref
                .read(orderSubmitSuccessProvider.notifier)
                .setState(
                  uiOwnOrder.copyWith(ownOrder: orderSubmit.submitSucceed),
                ),
          );
        }

        // set submit order error state
        if (orderSubmit.hasError() && orderSubmit.error.isNotEmpty) {
          Future.microtask(
            () => ref
                .read(orderSubmitErrorProvider.notifier)
                .setState(orderSubmit.error),
          );
        }

        // set submit order unregistered gaid state
        if (orderSubmit.hasUnregisteredGaid()) {
          Future.microtask(
            () => ref
                .read(orderSubmitUnregisteredGaidProvider.notifier)
                .setState(orderSubmit.unregisteredGaid.domainAgent),
          );
        }
      });

      return;
    }, [optionOrderSubmit, uiOwnOrders]);

    final optionOrderSubmitSuccess = ref.watch(orderSubmitSuccessProvider);
    final optionOrderSubmitError = ref.watch(orderSubmitErrorProvider);
    final optionOrderSubmitUnregisteredGaid = ref.watch(
      orderSubmitUnregisteredGaidProvider,
    );

    useEffect(
      () {
        if (optionOrderSubmitSuccess.isSome() ||
            optionOrderSubmitError.isSome() ||
            optionOrderSubmitUnregisteredGaid.isSome()) {
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

        return;
      },
      [
        optionOrderSubmitSuccess,
        optionOrderSubmitError,
        optionOrderSubmitUnregisteredGaid,
      ],
    );

    final optionStartOrderQuoteSuccess = ref.watch(
      marketStartOrderQuoteSuccessProvider,
    );

    useEffect(() {
      Future.microtask(() {
        optionStartOrderQuoteSuccess.match(() {}, (quoteSuccess) async {
          ref.invalidate(marketQuoteProvider);

          if (ref.read(previewOrderQuoteSuccessProvider).isSome()) {
            return;
          }

          await showSwapTradeDialog(
            context, ref,
            optionQuoteSuccess: optionStartOrderQuoteSuccess,
          );

          ref.read(quoteEventProvider.notifier).stopQuotes();
          ref.invalidate(marketStartOrderProvider);
        });
      });

      return;
    }, [optionStartOrderQuoteSuccess]);

    final optionStartOrderQuoteLowBalance = ref.watch(
      marketStartOrderLowBalanceErrorProvider,
    );

    useEffect(() {
      optionStartOrderQuoteLowBalance.match(() {}, (quoteLowBalance) async {
        await Future.microtask(() async {
          if (!context.mounted) {
            return;
          }
          ref.invalidate(marketStartOrderProvider);

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

          ref.invalidate(marketQuoteProvider);
        });
      });
      return;
    }, [optionStartOrderQuoteLowBalance]);

    final optionStartOrderQuoteError = ref.watch(
      marketStartOrderQuoteErrorProvider,
    );

    useEffect(() {
      optionStartOrderQuoteError.match(() {}, (quoteError) async {
        await Future.microtask(() async {
          if (!context.mounted) {
            return;
          }

          ref.invalidate(marketStartOrderProvider);

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

          ref.invalidate(marketQuoteProvider);
        });
      });
      return;
    }, [optionStartOrderQuoteError]);

    final optionStartOrderUnregisteredGaid = ref.watch(
      marketStartOrderUnregisteredGaidProvider,
    );

    useEffect(() {
      optionStartOrderUnregisteredGaid.match(() {}, (unregisteredGaid) async {
        await Future.microtask(() async {
          if (!context.mounted) {
            return;
          }
          ref.invalidate(marketStartOrderProvider);

          await showDialog<void>(
            context: context,
            builder: (context) {
              return MarketStartOrderUnregisteredGaidDialog(
                optionStartOrderUnregisteredGaid:
                    optionStartOrderUnregisteredGaid,
              );
            },
            routeSettings: RouteSettings(
              name: marketStartOrderUnregisteredGaidRouteName,
            ),
            useRootNavigator: false,
          );

          ref.invalidate(marketQuoteProvider);
        });
      });
      return;
    }, [optionStartOrderUnregisteredGaid]);

    final optionStartOrderError = ref.watch(marketStartOrderErrorProvider);

    useEffect(() {
      Future.microtask(() {
        optionStartOrderError.match(() {}, (startOrderError) async {
          if (!context.mounted) {
            return;
          }
          ref.invalidate(marketStartOrderProvider);

          await showDialog<void>(
            context: context,
            builder: (context) {
              return MarketStartOrderErrorDialog();
            },
            routeSettings: RouteSettings(name: marketStartOrderErrorRouteName),
            useRootNavigator: false,
            barrierDismissible: false,
          );

          ref.invalidate(marketStartOrderErrorProvider);
          ref.invalidate(marketQuoteProvider);
        });
      });

      return;
    }, [optionStartOrderError]);

    final optionCurrentQuote = ref.watch(marketQuoteProvider);
    final optionStartOrderId = ref.watch(marketStartOrderProvider);

    ref.listen(marketSideStateProvider, (_, _) {
      optionStartOrderId.match(
        () => optionCurrentQuote.match(() {}, (_) {
          Future.microtask(() {
            ref.invalidate(limitOrderPriceControllerProvider);
            ref.invalidate(marketOrderAmountControllerProvider);
            ref.invalidate(marketQuoteProvider);
          });
        }),
        (_) {},
      );
    });

    return const SizedBox();
  }
}
