import 'package:collection/collection.dart';
import 'package:decimal/decimal.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/models/client_ffi.dart';
import 'package:sideswap/models/swap_models.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/connection_state_providers.dart';
import 'package:sideswap/providers/server_status_providers.dart';
import 'package:sideswap/providers/swap_providers.dart';
import 'package:sideswap/providers/tx_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

part 'pegs_provider.freezed.dart';
part 'pegs_provider.g.dart';

@freezed
sealed class PegSubscribedValues with _$PegSubscribedValues {
  const factory PegSubscribedValues({
    @Default(0) int pegInMinimumAmount,
    @Default(0) int pegInWalletBalance,
    @Default(0) int pegOutMinimumAmount,
    @Default(0) int pegOutWalletBalance,
    @Default(0) double pegOutNextBlockFeeRate,
  }) = _PegSubscribedValues;
}

abstract class AbstractPegRepository {
  void setActivePage({ActivePage activePage = ActivePage.OTHER});
  String extractValue(int value);
  String pegInMinAmount();
  String pegInWalletBalance();
  String pegOutMinAmount();
  String pegOutWalletBalance();
  String pegOutNextBlockFeeRate();
  void getPegOutAmount();
}

class PegRepository implements AbstractPegRepository {
  final Ref ref;
  final LibClientState libClientState;
  final bool serverConnected;
  final PegSubscribedValues pegSubscribedValues;
  final String liquidAssetId;

  ActivePage currentActivePage = ActivePage.OTHER;

  PegRepository({
    required this.ref,
    required this.libClientState,
    required this.serverConnected,
    required this.pegSubscribedValues,
    required this.liquidAssetId,
  });

  @override
  void setActivePage({ActivePage activePage = ActivePage.OTHER}) {
    if (currentActivePage == activePage) {
      return;
    }

    if (libClientState != LibClientStateInitialized()) {
      return;
    }

    if (!serverConnected) {
      return;
    }

    final msg = To();
    msg.activePage = activePage;
    ref.read(walletProvider).sendMsg(msg);

    currentActivePage = activePage;
  }

  @override
  String extractValue(int value) {
    final liquidAssetId = ref.read(liquidAssetIdStateProvider);
    final amountToString = ref.read(amountToStringProvider);
    final assetState = ref.read(assetsStateProvider);

    final asset = assetState[liquidAssetId];
    if (asset == null) {
      return '';
    }

    final amountString = amountToString.amountToString(
      AmountToStringParameters(
        amount: value.toInt(),
        precision: asset.precision,
        useNumberFormatter: true,
      ),
    );

    final amountDecimal = Decimal.tryParse(amountString) ?? Decimal.zero;
    return amountToString.amountToMobileFormatted(
      amount: amountDecimal,
      precision: asset.precision,
    );
  }

  @override
  String pegInMinAmount() {
    return extractValue(pegSubscribedValues.pegInMinimumAmount);
  }

  @override
  String pegInWalletBalance() {
    return extractValue(pegSubscribedValues.pegInWalletBalance);
  }

  @override
  String pegOutMinAmount() {
    return extractValue(pegSubscribedValues.pegOutMinimumAmount);
  }

  @override
  String pegOutWalletBalance() {
    return extractValue(pegSubscribedValues.pegOutWalletBalance);
  }

  @override
  String pegOutNextBlockFeeRate() {
    return pegSubscribedValues.pegOutNextBlockFeeRate.toString();
  }

  @override
  void getPegOutAmount() {
    ref.read(swapHelperProvider).clearNetworkStates();
    final swapType = ref.read(swapTypeProvider);

    if (swapType == const SwapType.pegOut()) {
      final subscribe = ref.read(swapPriceSubscribeProvider);
      final optionCurrentFeeRate = ref.read(bitcoinCurrentFeeRateProvider);
      final sendAmount = (subscribe == const SwapPriceSubscribeState.send())
          ? ref.read(swapSendSatoshiAmountProvider)
          : null;
      final recvAmount = (subscribe == const SwapPriceSubscribeState.recv())
          ? ref.read(swapRecvSatoshiAmountProvider)
          : null;
      if (((sendAmount ?? 0) > 0 || (recvAmount ?? 0) > 0)) {
        optionCurrentFeeRate.match(() {}, (feeRate) {
          ref
              .read(walletProvider)
              .getPegOutAmount(sendAmount, recvAmount, feeRate);
        });
      }
    }
  }
}

@riverpod
AbstractPegRepository pegRepository(Ref ref) {
  final libClientState = ref.watch(libClientStateProvider);
  final serverConnected = ref.watch(serverConnectionProvider);
  final pegSubscribedValues = ref.watch(pegSubscribedValueProvider);
  final liquidAssetId = ref.watch(liquidAssetIdStateProvider);

  return PegRepository(
    ref: ref,
    libClientState: libClientState,
    serverConnected: serverConnected,
    pegSubscribedValues: pegSubscribedValues,
    liquidAssetId: liquidAssetId,
  );
}

@Riverpod(keepAlive: true)
class AllPegsNotifier extends _$AllPegsNotifier {
  @override
  Map<String, List<TransItem>> build() {
    return {};
  }

  void update({required From_UpdatedPegs pegs}) {
    final allPegs = {...state};
    allPegs[pegs.orderId] = pegs.items;
    state = allPegs;
  }
}

// Keep here all peg items by id.
// Peg-ins items can be in initiated state (not received yet)
// and it's txidRecv can be empty!
@Riverpod(keepAlive: true)
Map<String, TransItem> allPegsById(Ref ref) {
  final allPegsByIdMap = <String, TransItem>{};
  final allPegs = ref.watch(allPegsProvider);

  for (var key in allPegs.keys) {
    final peg = allPegs[key]!;

    for (var item in peg) {
      allPegsByIdMap[item.id] = item;
    }
  }

  // for (var key in allPegs.keys) {
  //   final peg = allPegs[key]!;

  //   for (var item in peg) {
  //     if (item.peg.isPegIn) {
  //       allPegsByTxidMap[item.peg.txidSend] = item;
  //       continue;
  //     }
  //     allPegsByTxidMap[item.peg.txidRecv] = item;
  //   }
  // }

  return allPegsByIdMap;
}

@Riverpod(keepAlive: true)
class PegSubscribedValueNotifier extends _$PegSubscribedValueNotifier {
  @override
  PegSubscribedValues build() {
    return PegSubscribedValues();
  }

  void setState(From_SubscribedValue subscribedValue) {
    final current = state;
    if (subscribedValue.hasPegInMinAmount()) {
      state = current.copyWith(
        pegInMinimumAmount: subscribedValue.pegInMinAmount.toInt(),
      );
    }
    if (subscribedValue.hasPegInWalletBalance()) {
      state = current.copyWith(
        pegInWalletBalance: subscribedValue.pegInWalletBalance.toInt(),
      );
    }
    if (subscribedValue.hasPegOutMinAmount()) {
      state = current.copyWith(
        pegOutMinimumAmount: subscribedValue.pegOutMinAmount.toInt(),
      );
    }
    if (subscribedValue.hasPegOutWalletBalance()) {
      state = current.copyWith(
        pegOutWalletBalance: subscribedValue.pegOutWalletBalance.toInt(),
      );
    }
    if (subscribedValue.hasPegOutNextBlockFeeRate()) {
      state = current.copyWith(
        pegOutNextBlockFeeRate: subscribedValue.pegOutNextBlockFeeRate,
      );
    }
  }
}

@riverpod
Option<String> pegOrderIdForTransItem(Ref ref, TransItem transItem) {
  final allPegs = ref.watch(allPegsProvider);
  return Option.fromNullable(
    allPegs.entries
        .firstWhereOrNull((entry) => entry.value.contains(transItem))
        ?.key,
  );
}

@freezed
sealed class PegOrderFeeData with _$PegOrderFeeData {
  const factory PegOrderFeeData({
    required Decimal feeRate,
    required int bitcoinNetworkFee,
  }) = _PegOrderFeeData;
}

@Riverpod(keepAlive: true)
class PegOrderFeesNotifier extends _$PegOrderFeesNotifier {
  @override
  Map<String, PegOrderFeeData> build() {
    return {};
  }

  void setState(From_UpdatedPegs pegs) {
    final allPegs = {...state};
    final decimalFeeRate =
        Decimal.tryParse(pegs.feeRate.toString()) ?? Decimal.zero;
    if (decimalFeeRate == Decimal.zero) {
      return;
    }
    allPegs[pegs.orderId] = PegOrderFeeData(
      feeRate: decimalFeeRate,
      bitcoinNetworkFee: pegs.bitcoinNetworkFee.toInt(),
    );
    state = allPegs;
  }
}

@riverpod
Option<PegOrderFeeData> pegOrderFeeRates(Ref ref, TransItem transItem) {
  final optionOrderId = ref.watch(pegOrderIdForTransItemProvider(transItem));
  final pegOrderFee = ref.watch(pegOrderFeesProvider);
  return optionOrderId.flatMap(
    (orderId) => Option.fromNullable(pegOrderFee[orderId]),
  );
}

@riverpod
bool availablePegOrderFeeChange(Ref ref, TransItem transItem) {
  return transItem.hasPeg()
      ? transItem.peg.isPegIn
            ? false
            : transItem.peg.txidRecv.isEmpty
      : false;
}

@riverpod
String pegOutNextBlockFeeRate(Ref ref) {
  final repository = ref.watch(pegRepositoryProvider);
  return repository.pegOutNextBlockFeeRate();
}

@riverpod
PegOutEditFeeRateHelper pegOutEditFeeRateHelper(
  Ref ref,
  Option<String> optionSelectedFeeRate,
) {
  final feeRates = ref.watch(bitcoinFeeRatesProvider);
  return PegOutEditFeeRateHelper(feeRates, optionSelectedFeeRate);
}

/// Helper for peg-out fee rate editing UI logic.
class PegOutEditFeeRateHelper {
  final List<FeeRate> feeRates;
  final Option<String> optionSelectedFeeRate;

  // Magic numbers as static const for clarity and maintainability
  static const double fallbackFeeRate = 1.0;
  static const double minFee = 1.0;
  static const double maxFeeMultiplier = 1.5;

  PegOutEditFeeRateHelper(this.feeRates, this.optionSelectedFeeRate);

  /// Returns the two-block fee rate, or fallback if not found.
  double _getTwoBlockFeeRate() =>
      feeRates.firstWhereOrNull((e) => e.blocks == 2)?.value ?? fallbackFeeRate;

  /// Returns the max fee for the slider.
  double _getMaxFee(double twoBlockFeeRate) =>
      maxFeeMultiplier * twoBlockFeeRate;

  /// Parses the current fee from string, or falls back to [fallback].
  double _parseCurrentFee(String value, double fallback) =>
      double.tryParse(value) ?? fallback;

  /// Returns the min, max, and current fee for the slider.
  ({double minFee, double maxFee, double currentFee}) sliderValues() {
    final twoBlockFeeRate = _getTwoBlockFeeRate();
    final maxFee = _getMaxFee(twoBlockFeeRate);
    final currentFee = optionSelectedFeeRate.match(() => twoBlockFeeRate, (
      value,
    ) {
      final current = _parseCurrentFee(value, twoBlockFeeRate);
      return current < maxFee ? current : maxFee;
    });
    return (minFee: minFee, maxFee: maxFee, currentFee: currentFee);
  }

  /// Returns the current fee as a string for display.
  String get currentFeeStr {
    return optionSelectedFeeRate.match(() => 'N/A', (value) {
      final parsed = double.tryParse(value);
      return parsed == null ? 'N/A' : '${parsed.toStringAsFixed(2)} sats';
    });
  }

  /// Returns the default fee rate, capped at maxFee.
  double defaultFeeRate() {
    final twoBlockFeeRate = _getTwoBlockFeeRate();
    final maxFee = _getMaxFee(twoBlockFeeRate);
    final currentFee = optionSelectedFeeRate.match(() => twoBlockFeeRate, (
      value,
    ) {
      final current = _parseCurrentFee(value, twoBlockFeeRate);
      return current < maxFee ? current : maxFee;
    });
    return currentFee;
  }
}

@freezed
sealed class PegOutEditFeeRateResult with _$PegOutEditFeeRateResult {
  const factory PegOutEditFeeRateResult.success() =
      _PegOutEditFeeRateResultSuccess;
  const factory PegOutEditFeeRateResult.failure(String error) =
      _PegOutEditFeeRateResultFailure;
}

@riverpod
class PegOutEditFeeRateResultStream extends _$PegOutEditFeeRateResultStream {
  @override
  Stream<Option<PegOutEditFeeRateResult>> build() async* {
    yield* Stream<Option<PegOutEditFeeRateResult>>.empty();
  }

  void setResult(PegOutEditFeeRateResult result) {
    state = AsyncValue.data(Option.of(result));
  }
}

@riverpod
Option<TransItem> pegDetailsTransItem(Ref ref) {
  final optionCurrentTxid = ref.watch(currentTxPopupItemProvider);

  return optionCurrentTxid.match(() => none(), (txid) {
    final allTxs = ref.watch(allTxsProvider);
    final allPegs = ref.watch(allPegsProvider);

    final txTransItem = allTxs[txid];

    final transItem =
        allPegs.values
            .map(
              (item) => item.firstWhereOrNull(
                (pegTransItem) =>
                    pegTransItem.peg.txidRecv == txid ||
                    pegTransItem.peg.txidSend == txid,
              ),
            )
            .firstWhereOrNull((item) => item != null) ??
        txTransItem;

    return Option.fromNullable(transItem);
  });
}
