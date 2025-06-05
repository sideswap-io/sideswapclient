import 'package:easy_localization/easy_localization.dart';
import 'package:collection/collection.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/common/utils/ref_debounce_extension.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/jade_provider.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/quote_event_providers.dart';
import 'package:sideswap/providers/satoshi_providers.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

part 'exchange_providers.g.dart';
part 'exchange_providers.freezed.dart';

@freezed
sealed class ExchangeSide with _$ExchangeSide {
  const factory ExchangeSide.sell(Asset asset) = ExchangeSideSell;

  const factory ExchangeSide.buy(Asset asset) = ExchangeSideBuy;
}

@riverpod
Option<ExchangeSide> exchangeSide(Ref ref) {
  final optionTopAsset = ref.watch(exchangeTopAssetProvider);
  final optionBottomAsset = ref.watch(exchangeBottomAssetProvider);

  final stableMarkets = ref.watch(stableMarketsProvider);

  if (stableMarkets.isEmpty) {
    return Option.none();
  }

  return optionTopAsset.match(
    () {
      return Option.none();
    },
    (topAsset) => optionBottomAsset.match(
      () {
        return Option.none();
      },
      (bottomAsset) {
        final found = stableMarkets.any(
          (e) =>
              e.assetPair.base == topAsset.assetId &&
              e.assetPair.quote == bottomAsset.assetId,
        );

        if (found) {
          return Option.of(ExchangeSide.buy(bottomAsset));
        }

        return Option.of(ExchangeSide.sell(topAsset));
      },
    ),
  );
}

@riverpod
class ExchangeCurrentEditAsset extends _$ExchangeCurrentEditAsset {
  @override
  Option<Asset> build() {
    return Option.none();
  }

  void setState(Option<Asset> optionAsset) {
    state = optionAsset;
  }
}

@riverpod
Option<AssetPair> exchangeAssetPair(Ref ref) {
  final optionTopAsset = ref.watch(exchangeTopAssetProvider);
  final optionBottomAsset = ref.watch(exchangeBottomAssetProvider);
  final optionSide = ref.watch(exchangeSideProvider);

  return optionSide.match(
    () {
      return Option.none();
    },
    (side) => optionTopAsset.match(
      () {
        return Option.none();
      },
      (topAsset) => optionBottomAsset.match(
        () {
          return Option.none();
        },
        (bottomAsset) {
          final AssetPair assetPair = switch (side) {
            ExchangeSideBuy() => AssetPair(
              base: topAsset.assetId,
              quote: bottomAsset.assetId,
            ),
            _ => AssetPair(base: bottomAsset.assetId, quote: topAsset.assetId),
          };

          final markets = ref.watch(stableMarketsProvider);

          final marketInfo = markets.firstWhereOrNull(
            (e) => e.assetPair == assetPair,
          );

          if (marketInfo == null) {
            return Option.none();
          }

          return Option.of(marketInfo.assetPair);
        },
      ),
    ),
  );
}

@riverpod
Option<MarketInfo> exchangeMarketInfo(Ref ref) {
  final markets = ref.watch(stableMarketsProvider);
  final optionAssetPair = ref.watch(exchangeAssetPairProvider);

  return optionAssetPair.match(() => Option.none(), (assetPair) {
    final marketInfo = markets.firstWhereOrNull(
      (e) => e.assetPair == assetPair,
    );
    return marketInfo == null ? Option.none() : Option.of(marketInfo);
  });
}

@riverpod
List<Asset> exchangeTopAssetList(Ref ref) {
  final markets = ref.watch(stableMarketsProvider);
  final result = <Asset>{};

  for (final m in markets) {
    final baseId = m.assetPair.base;
    final quoteId = m.assetPair.quote;

    final optionBaseAsset = ref.watch(assetFromAssetIdProvider(baseId));
    optionBaseAsset.match(() {}, (baseAsset) {
      if (baseAsset.ticker.isNotEmpty) {
        result.add(baseAsset);
      }
    });

    final optionQuoteAsset = ref.watch(assetFromAssetIdProvider(quoteId));
    optionQuoteAsset.match(() {}, (quoteAsset) {
      if (quoteAsset.ticker.isNotEmpty) {
        result.add(quoteAsset);
      }
    });
  }

  final newList = result.toList();
  newList.sort((a, b) => a.ticker.compareTo(b.ticker));

  return newList;
}

@riverpod
class ExchangeTopAsset extends _$ExchangeTopAsset {
  @override
  Option<Asset> build() {
    final topAssetList = ref.watch(exchangeTopAssetListProvider);
    final liquidAssetId = ref.watch(liquidAssetIdStateProvider);

    final defaultAsset = topAssetList.firstWhereOrNull(
      (e) => e.assetId == liquidAssetId,
    );
    return switch (defaultAsset) {
      Asset()? => Option.of(defaultAsset),
      _ => topAssetList.firstOption,
    };
  }

  void setState(Asset value) {
    final topAssetList = ref.read(exchangeTopAssetListProvider);
    if (topAssetList.any((e) => e == value)) {
      state = Option.of(value);
    }
  }
}

@riverpod
List<Asset> exchangeBottomAssetList(Ref ref) {
  final optionTopAsset = ref.watch(exchangeTopAssetProvider);
  final markets = ref.watch(stableMarketsProvider);

  if (markets.isEmpty) {
    return [];
  }

  return optionTopAsset.match(
    () {
      return [];
    },
    (topAsset) {
      final result = <Asset>{};

      for (final m in markets) {
        final optionBaseAsset = ref.watch(
          assetFromAssetIdProvider(m.assetPair.base),
        );
        final optionQuoteAsset = ref.watch(
          assetFromAssetIdProvider(m.assetPair.quote),
        );

        optionBaseAsset.match(
          () {},
          (baseAsset) => optionQuoteAsset.match(() {}, (quoteAsset) {
            if (m.assetPair.base == topAsset.assetId) {
              result.add(quoteAsset);
            }

            if (m.assetPair.quote == topAsset.assetId) {
              result.add(baseAsset);
            }
          }),
        );
      }

      final newList = result.toList();
      newList.sort((a, b) => a.ticker.compareTo(b.ticker));

      return newList;
    },
  );
}

@riverpod
class ExchangeBottomAsset extends _$ExchangeBottomAsset {
  @override
  Option<Asset> build() {
    final bottomAssetList = ref.watch(exchangeBottomAssetListProvider);
    final tetherAssetId = ref.watch(tetherAssetIdStateProvider);

    final defaultAsset = bottomAssetList.firstWhereOrNull(
      (e) => e.assetId == tetherAssetId,
    );
    return switch (defaultAsset) {
      Asset()? => Option.of(defaultAsset),
      _ => bottomAssetList.firstOption,
    };
  }

  void setState(Asset asset) {
    final bottomAssetList = ref.read(exchangeBottomAssetListProvider);
    if (bottomAssetList.any((e) => e == asset)) {
      state = Option.of(asset);
      return;
    }

    state = bottomAssetList.firstOption;
  }
}

@riverpod
class ExchangeTopAmount extends _$ExchangeTopAmount {
  @override
  String build() {
    ref.listen(exchangeAccepQuoteStateNotifierProvider, (_, next) {
      if (next is ExchangeAcceptQuoteStateInProgress) {
        ref.invalidateSelf();
      }
    });

    ref.watch(exchangeBottomAssetProvider);
    final optionTopAsset = ref.watch(exchangeTopAssetProvider);

    ref.listen(exchangeLowBalanceErrorProvider, (_, optionLowBalance) {
      optionLowBalance.match(() {}, (lowBalance) {
        lowBalance.deliverAsset.match(
          () {},
          (deliverAsset) => optionTopAsset.match(() {}, (topAsset) {
            if (deliverAsset.assetId == topAsset.assetId &&
                lowBalance.tradeDir == TradeDir.BUY) {
              state = lowBalance.deliverAmount;
            }
          }),
        );
      });
    });

    ref.listen(exchangeQuoteSuccessProvider, (_, optionQuoteSuccess) {
      optionQuoteSuccess.match(() {}, (quoteSuccess) {
        quoteSuccess.deliverAsset.match(
          () {},
          (deliverAsset) => optionTopAsset.match(() {}, (topAsset) {
            if (deliverAsset.assetId == topAsset.assetId &&
                quoteSuccess.tradeDir == TradeDir.BUY) {
              state = quoteSuccess.deliverAmount;
            }
          }),
        );
      });
    });

    ref.listen(exchangeQuoteErrorProvider, (_, optionQuoteError) {
      optionQuoteError.match(() {}, (quoteError) {
        final optionCurrentEditAsset = ref.read(
          exchangeCurrentEditAssetProvider,
        );
        final optionTopAsset = ref.watch(exchangeTopAssetProvider);
        optionCurrentEditAsset.match(
          () {},
          (currentEditAsset) => optionTopAsset.match(() {}, (topAsset) {
            if (quoteError.error.isNotEmpty && topAsset != currentEditAsset) {
              ref.invalidateSelf();
            }
          }),
        );
      });
    });

    return '';
  }

  void setState(String amount) {
    if (amount.isEmpty) {
      ref.invalidateSelf();
      return;
    }

    state = amount;
  }
}

@riverpod
int exchangeTopSatoshiAmount(Ref ref) {
  final optionTopAsset = ref.watch(exchangeTopAssetProvider);

  return optionTopAsset.match(
    () {
      return 0;
    },
    (topAsset) {
      final topAmountString = ref.watch(exchangeTopAmountProvider);

      final topSatoshiAmount = ref
          .watch(satoshiRepositoryProvider)
          .satoshiForAmount(assetId: topAsset.assetId, amount: topAmountString);
      return topSatoshiAmount;
    },
  );
}

@riverpod
Future<int> exchangeTopDebounceSatoshiAmount(Ref ref) async {
  final topSatoshiAmount = ref.watch(exchangeTopSatoshiAmountProvider);

  await ref.debounce(const Duration(milliseconds: 300));

  return topSatoshiAmount;
}

@riverpod
class ExchangeBottomAmount extends _$ExchangeBottomAmount {
  @override
  String build() {
    ref.listen(exchangeAccepQuoteStateNotifierProvider, (_, next) {
      if (next is ExchangeAcceptQuoteStateInProgress) {
        ref.invalidateSelf();
      }
    });

    ref.watch(exchangeTopAssetProvider);
    final optionBottomAsset = ref.watch(exchangeBottomAssetProvider);

    ref.listen(exchangeLowBalanceErrorProvider, (_, optionLowBalance) {
      optionLowBalance.match(() {}, (lowBalance) {
        lowBalance.receiveAsset.match(
          () {},
          (receiveAsset) => optionBottomAsset.match(() {}, (bottomAsset) {
            if (receiveAsset.assetId == bottomAsset.assetId &&
                lowBalance.tradeDir == TradeDir.SELL) {
              state = lowBalance.receiveAmount;
            }
          }),
        );
      });
    });

    ref.listen(exchangeQuoteSuccessProvider, (_, optionQuoteSuccess) {
      optionQuoteSuccess.match(() {}, (quoteSuccess) {
        quoteSuccess.receiveAsset.match(
          () {},
          (receiveAsset) => optionBottomAsset.match(() {}, (bottomAsset) {
            if (receiveAsset.assetId == bottomAsset.assetId &&
                quoteSuccess.tradeDir == TradeDir.SELL) {
              state = quoteSuccess.receiveAmount;
            }
          }),
        );
      });
    });

    ref.listen(exchangeQuoteErrorProvider, (_, optionQuoteError) {
      optionQuoteError.match(() {}, (quoteError) {
        final optionCurrentEditAsset = ref.read(
          exchangeCurrentEditAssetProvider,
        );
        final optionTopAsset = ref.watch(exchangeTopAssetProvider);
        optionCurrentEditAsset.match(
          () {},
          (currentEditAsset) => optionTopAsset.match(() {}, (topAsset) {
            if (quoteError.error.isNotEmpty && topAsset == currentEditAsset) {
              ref.invalidateSelf();
            }
          }),
        );
      });
    });

    return '';
  }

  void setState(String amount) {
    if (amount.isEmpty) {
      ref.invalidateSelf();
      return;
    }

    state = amount;
  }
}

@riverpod
int exchangeBottomSatoshiAmount(Ref ref) {
  final optionBottomAsset = ref.watch(exchangeBottomAssetProvider);

  return optionBottomAsset.match(
    () {
      return 0;
    },
    (bottomAsset) {
      final bottomAmountString = ref.watch(exchangeBottomAmountProvider);

      final bottomSatoshiAmount = ref
          .watch(satoshiRepositoryProvider)
          .satoshiForAmount(
            assetId: bottomAsset.assetId,
            amount: bottomAmountString,
          );
      return bottomSatoshiAmount;
    },
  );
}

@riverpod
Future<int> exchangeBottomDebounceSatoshiAmount(Ref ref) async {
  final bottomSatoshiAmount = ref.watch(exchangeBottomSatoshiAmountProvider);

  await ref.debounce(const Duration(milliseconds: 300));

  return bottomSatoshiAmount;
}

/// Exchange quotes

@riverpod
class ExchangeQuoteNotifier extends _$ExchangeQuoteNotifier {
  @override
  Option<From_Quote> build() {
    ref.listen(exchangeCurrentEditAssetProvider, (_, _) {});
    final optionQuoteEvent = ref.watch(quoteEventNotifierProvider);

    return optionQuoteEvent;
  }

  void requestIndPriceQuote(
    Option<ExchangeSide> optionExchangeSide,
    Option<AssetPair> optionAssetPair,
  ) {
    optionExchangeSide.match(
      () {},
      (exchangeSide) => optionAssetPair.match(() {}, (assetPair) {
        final assetType = switch (exchangeSide) {
          ExchangeSideBuy() => AssetType.BASE,
          _ => AssetType.QUOTE,
        };

        ref
            .read(quoteEventNotifierProvider.notifier)
            .startQuotes(
              amount: 0,
              assetPair: assetPair,
              assetType: assetType,
              tradeDir: TradeDir.SELL,
              instantSwap: true,
            );
      }),
    );
  }

  void startSellQuotes(int satoshiAmount) {
    final optionExchangeSide = ref.read(exchangeSideProvider);
    final optionAssetPair = ref.read(exchangeAssetPairProvider);

    if (satoshiAmount == 0) {
      return;
    }

    optionExchangeSide.match(
      () {},
      (exchangeSide) => optionAssetPair.match(() {}, (assetPair) {
        final assetType = switch (exchangeSide) {
          ExchangeSideBuy() => AssetType.BASE,
          _ => AssetType.QUOTE,
        };

        ref
            .read(quoteEventNotifierProvider.notifier)
            .startQuotes(
              assetPair: assetPair,
              assetType: assetType,
              amount: satoshiAmount,
              tradeDir: TradeDir.SELL,
              instantSwap: true,
            );
      }),
    );
  }

  void startBuyQuotes(int satoshiAmount) {
    final optionExchangeSide = ref.read(exchangeSideProvider);
    final optionAssetPair = ref.read(exchangeAssetPairProvider);

    if (satoshiAmount == 0) {
      return;
    }

    optionExchangeSide.match(
      () {},
      (exchangeSide) => optionAssetPair.match(() {}, (assetPair) {
        final assetType = switch (exchangeSide) {
          ExchangeSideBuy() => AssetType.QUOTE,
          _ => AssetType.BASE,
        };

        ref
            .read(quoteEventNotifierProvider.notifier)
            .startQuotes(
              assetPair: assetPair,
              assetType: assetType,
              amount: satoshiAmount,
              tradeDir: TradeDir.BUY,
              instantSwap: true,
            );
      }),
    );
  }

  void stopQuotes() {
    ref.read(quoteEventNotifierProvider.notifier).stopQuotes();
  }

  void acceptQuote({required Option<QuoteSuccess> optionQuoteSuccess}) {
    final jadeLockRepository = ref.read(jadeLockRepositoryProvider);

    optionQuoteSuccess.match(() {}, (quoteSuccess) {
      (switch (jadeLockRepository.isUnlocked()) {
        true => () async {
          var authorized = ref.read(jadeOneTimeAuthorizationProvider);

          if (!ref.read(jadeOneTimeAuthorizationProvider)) {
            authorized = await ref
                .read(jadeOneTimeAuthorizationProvider.notifier)
                .authorize();
          }

          if (!authorized) {
            return;
          }

          ref
              .read(previewOrderQuoteSuccessNotifierProvider.notifier)
              .setState(quoteSuccess);

          final msg = To();
          msg.acceptQuote = To_AcceptQuote(
            quoteId: quoteSuccess.quoteSuccess.quoteId,
          );
          ref.read(walletProvider).sendMsg(msg);

          ref
              .read(exchangeAccepQuoteStateNotifierProvider.notifier)
              .setState(ExchangeAcceptQuoteState.inProgress());
          stopQuotes();

          final isJadeWallet = ref.read(isJadeWalletProvider);

          if (isJadeWallet) {
            // cleanup on jade sign dialog close
            return;
          }

          ref.invalidate(previewOrderQuoteSuccessNotifierProvider);
        },
        _ => jadeLockRepository.refreshJadeLockState,
      }());
    });
  }
}

@riverpod
String exchangeSwapButtonText(Ref ref) {
  final continueText = 'Swap'.tr();
  final unlockText = 'Unlock'.tr();

  final isJadeWallet = ref.watch(isJadeWalletProvider);

  if (!isJadeWallet) {
    return continueText;
  }

  final jadeLockState = ref.watch(jadeLockStateNotifierProvider);
  return switch (jadeLockState) {
    JadeLockStateUnlocked() => continueText,
    _ => unlockText,
  };
}

@riverpod
Option<QuoteError> exchangeQuoteError(Ref ref) {
  final optionQuote = ref.watch(exchangeQuoteNotifierProvider);
  final optionAcceptQuoteError = ref.watch(exchangeAcceptQuoteErrorProvider);

  return optionQuote.match(
    () => optionAcceptQuoteError.match(
      () => Option.none(),
      (acceptQuoteError) => Option.of(QuoteError(error: acceptQuoteError)),
    ),
    (quote) {
      if (!quote.hasError()) {
        return Option.none();
      }

      if (quote.hasIndPrice()) {
        return Option.none();
      }

      return Option.of(
        QuoteError(error: quote.error, orderId: quote.orderId.toInt()),
      );
    },
  );
}

@riverpod
Option<String> instantSwapTopDropdownError(Ref ref) {
  final optionQuoteLowBalance = ref.watch(exchangeLowBalanceErrorProvider);
  final optionQuoteError = ref.watch(exchangeQuoteErrorProvider);

  return optionQuoteLowBalance.match(
    () => optionQuoteError.match(
      () => Option.none(),
      (quoteError) => Option.of(quoteError.error),
    ),
    (quoteLowBalance) => Option.of('Low balance'.tr()),
  );
}

@riverpod
class ExchangeIndexPrice extends _$ExchangeIndexPrice {
  @override
  Option<QuoteIndexPrice> build() {
    final amountToString = ref.watch(amountToStringProvider);
    final assetsState = ref.watch(assetsStateProvider);
    final satoshiRepository = ref.watch(satoshiRepositoryProvider);

    ref.listen(exchangeQuoteNotifierProvider, (_, optionQuote) {
      optionQuote.match(() {}, (quote) {
        double? priceTaker;

        if (quote.hasSuccess() && quote.success.hasPriceTaker()) {
          priceTaker = quote.success.priceTaker;
        }

        if (quote.hasLowBalance() && quote.lowBalance.hasPriceTaker()) {
          priceTaker = quote.lowBalance.priceTaker;
        }

        if (quote.hasIndPrice()) {
          priceTaker = quote.indPrice.priceTaker;
        }

        if (priceTaker == null) {
          state = Option.none();
          return;
        }

        state = Option.of(
          QuoteIndexPrice(
            amountToString,
            priceTaker,
            quote.assetPair,
            quote.assetType,
            quote.tradeDir,
            assetsState,
            satoshiRepository,
          ),
        );
      });
    });

    return Option.none();
  }
}

@riverpod
Option<QuoteLowBalance> exchangeLowBalanceError(Ref ref) {
  final optionAssetPair = ref.watch(exchangeAssetPairProvider);
  final optionQuote = ref.watch(exchangeQuoteNotifierProvider);
  final optionMarketInfo = ref.watch(exchangeMarketInfoProvider);

  return optionAssetPair.match(
    () => Option.none(),
    (assetPair) => optionQuote.match(
      () => Option.none(),
      (quote) => optionMarketInfo.match(() => Option.none(), (marketInfo) {
        if (!quote.hasLowBalance()) {
          return Option.none();
        }

        if (quote.assetPair != assetPair) {
          return Option.none();
        }

        final amountToString = ref.watch(amountToStringProvider);
        final assetsState = ref.watch(assetsStateProvider);

        return Option.of(
          QuoteLowBalance(
            amountToString,
            quote.lowBalance,
            quote.assetPair,
            quote.assetType,
            quote.tradeDir,
            marketInfo.feeAsset,
            assetsState,
            quote.orderId.toInt(),
          ),
        );
      }),
    ),
  );
}

@riverpod
Option<QuoteSuccess> exchangeQuoteSuccess(Ref ref) {
  final optionAssetPair = ref.watch(exchangeAssetPairProvider);
  final optionQuote = ref.watch(exchangeQuoteNotifierProvider);
  final optionMarketInfo = ref.watch(exchangeMarketInfoProvider);

  return optionQuote.match(
    () => Option.none(),
    (quote) => optionAssetPair.match(
      () => Option.none(),
      (assetPair) => optionMarketInfo.match(() => Option.none(), (marketInfo) {
        if (!quote.hasSuccess()) {
          return Option.none();
        }

        if (quote.assetPair != assetPair) {
          return Option.none();
        }

        final amountToString = ref.watch(amountToStringProvider);
        final assetsState = ref.watch(assetsStateProvider);

        final optionQuoteSuccess = Option.of(
          QuoteSuccess(
            amountToString,
            quote.success,
            quote.assetPair,
            quote.assetType,
            quote.tradeDir,
            marketInfo.feeAsset,
            assetsState,
            quote.orderId.toInt(),
          ),
        );

        return optionQuoteSuccess;
      }),
    ),
  );
}

@riverpod
bool exchangeSwapButtonEnabled(Ref ref) {
  final acceptQuoteState = ref.watch(exchangeAccepQuoteStateNotifierProvider);
  if (acceptQuoteState is ExchangeAcceptQuoteStateInProgress) {
    return false;
  }

  final optionQuoteSuccess = ref.watch(exchangeQuoteSuccessProvider);
  return optionQuoteSuccess.match(() => false, (_) => true);
}

/// Accept quote

@freezed
sealed class ExchangeAcceptQuoteState with _$ExchangeAcceptQuoteState {
  const factory ExchangeAcceptQuoteState.empty() =
      ExchangeAcceptQuoteStateEmpty;
  const factory ExchangeAcceptQuoteState.inProgress() =
      ExchangeAcceptQuoteStateInProgress;
}

@riverpod
class ExchangeAccepQuoteStateNotifier
    extends _$ExchangeAccepQuoteStateNotifier {
  @override
  ExchangeAcceptQuoteState build() {
    ref.listen(exchangeAcceptQuoteErrorProvider, (_, next) {
      next.match(() {}, (acceptQuoteError) {
        state = ExchangeAcceptQuoteState.empty();
      });
    });

    return ExchangeAcceptQuoteState.empty();
  }

  void setState(ExchangeAcceptQuoteState value) {
    state = value;
  }
}

@riverpod
Option<From_AcceptQuote> exchangeAcceptQuote(Ref ref) {
  return ref.watch(acceptQuoteNotifierProvider);
}

@riverpod
Option<String> exchangeAcceptQuoteSuccess(Ref ref) {
  final optionAcceptQuote = ref.watch(exchangeAcceptQuoteProvider);

  return optionAcceptQuote.match(
    () => () {
      return Option<String>.none();
    },
    (acceptQuote) => () {
      if (acceptQuote.hasSuccess()) {
        return Option.of(acceptQuote.success.txid);
      }

      return Option<String>.none();
    },
  )();
}

@riverpod
Option<String> exchangeAcceptQuoteError(Ref ref) {
  final optionAcceptQuote = ref.watch(exchangeAcceptQuoteProvider);

  return optionAcceptQuote.match(
    () => () {
      return Option<String>.none();
    },
    (acceptQuote) => () {
      if (acceptQuote.hasError()) {
        return Option.of(acceptQuote.error);
      }

      return Option<String>.none();
    },
  )();
}
