import 'package:collection/collection.dart';
import 'package:decimal/decimal.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/models/tx_item.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/new_block_providers.dart';
import 'package:sideswap/providers/pegs_provider.dart';
import 'package:sideswap/providers/satoshi_providers.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

part 'tx_provider.g.dart';
part 'tx_provider.freezed.dart';

@freezed
sealed class LoadTransactionsState with _$LoadTransactionsState {
  const factory LoadTransactionsState.empty() = LoadTransactionsStateEmpty;
  const factory LoadTransactionsState.loading() = LoadTransactionsStateLoading;
  const factory LoadTransactionsState.error({String? errorMsg}) =
      LoadTransactionsStateError;
}

@riverpod
class LoadTransactionsStateNotifier extends _$LoadTransactionsStateNotifier {
  @override
  LoadTransactionsState build() {
    return LoadTransactionsState.empty();
  }

  void setState(LoadTransactionsState state) {
    this.state = state;
  }
}

@Riverpod(keepAlive: true)
class AllTxsNotifier extends _$AllTxsNotifier {
  @override
  Map<String, TransItem> build() {
    ref.listen(newBlockNotifierProvider, (_, _) {
      var txShouldUpdated = false;
      for (final transItem in state.values) {
        if (transItem.hasConfs()) {
          txShouldUpdated = true;
        }
      }

      if (txShouldUpdated) {
        loadTransactions();
      }
    });
    return {};
  }

  void update({required From_UpdatedTxs txs}) {
    final allTxs = {...state};

    for (var item in txs.items) {
      allTxs[item.id] = item;
    }

    state = allTxs;
  }

  void updateList({required List<TransItem> txs}) {
    final allTxs = {...state};

    for (var item in txs) {
      allTxs[item.id] = item;
    }

    state = allTxs;
  }

  void remove({required From_RemovedTxs txs}) {
    final allTxs = {...state};

    for (var txid in txs.txids) {
      allTxs.remove(txid);
    }

    state = allTxs;
  }

  Future<void> loadTransactions() async {
    await Future.microtask(
      () => ref
          .read(loadTransactionsStateNotifierProvider.notifier)
          .setState(LoadTransactionsState.loading()),
    );

    final msg = To();
    msg.loadTransactions = Empty();
    ref.read(walletProvider).sendMsg(msg);
  }
}

@riverpod
List<TransItem> allTxsSorted(Ref ref) {
  final allTxs = ref.watch(allTxsNotifierProvider);
  final allPegsById = ref.watch(allPegsByIdProvider);

  final allTxsSorted = allTxs.values.toList()..addAll(allPegsById.values);
  allTxsSorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));

  return allTxsSorted;
}

@riverpod
List<TransItem> allNewTxsSorted(Ref ref) {
  final allTxsSorted = ref.watch(allTxsSortedProvider);

  final allNewTxsSorted = <TransItem>[];
  allNewTxsSorted.addAll(allTxsSorted);
  allNewTxsSorted.removeWhere((e) => !e.hasConfs());
  return allNewTxsSorted;
}

/// Returns map of AccountAsset and list of TxItem.
/// List of TxItem is based on tx balances list. Balances list can include multiple different assets.
/// AccountAsset hold AccountType and assetId information.
/// Each pair of AccountAsset and list of TxItem can hold duplicates of TxItem.
@riverpod
Map<AccountAsset, List<TxItem>> accountAssetTransactions(Ref ref) {
  final allTxs = ref.watch(allTxsNotifierProvider);
  final allPegs = ref.watch(allPegsNotifierProvider);
  final liquidAssetId = ref.watch(liquidAssetIdStateProvider);

  final allAssets = <AccountAsset, List<TxItem>>{};

  void addTxItem(
    Map<AccountAsset, List<TxItem>> accountAssetsTransactions,
    AccountAsset accountAsset,
    TransItem transaction,
  ) {
    if (accountAssetsTransactions[accountAsset] == null) {
      accountAssetsTransactions[accountAsset] = [];
    }
    accountAssetsTransactions[accountAsset]!.add(TxItem(item: transaction));
  }

  final accountAssetTransactions = <AccountAsset, List<TxItem>>{};

  for (final item in allTxs.values) {
    final tx = item.tx;
    for (final balance in tx.balances) {
      final accountAsset = AccountAsset(Account.REG, balance.assetId);
      addTxItem(accountAssetTransactions, accountAsset, item);
    }
  }

  for (final order in allPegs.entries) {
    for (final item in order.value) {
      final accountAsset = AccountAsset(Account.REG, liquidAssetId);
      addTxItem(accountAssetTransactions, accountAsset, item);
    }
  }

  final dateFormat = DateFormat('yyyy-MM-dd');
  for (var item in accountAssetTransactions.entries) {
    item.value.sort((a, b) => b.compareTo(a));

    final tempAssets = <TxItem>[];
    for (var item in item.value) {
      if (tempAssets.isEmpty) {
        tempAssets.add(item.copyWith(showDate: true));
      } else {
        final last = DateTime.parse(
          dateFormat.format(
            DateTime.fromMillisecondsSinceEpoch(tempAssets.last.createdAt),
          ),
        );
        final current = DateTime.parse(
          dateFormat.format(
            DateTime.fromMillisecondsSinceEpoch(item.createdAt),
          ),
        );
        final diff = last.difference(current).inDays;
        tempAssets.add(item.copyWith(showDate: diff != 0));
      }
    }

    allAssets[item.key] = tempAssets;
  }
  return allAssets;

  // final transactions = <TxItem>[...allTxs.values.map((e) => TxItem(item: e))];
  // for (final itemList in allPegs.values) {
  //   transactions.addAll(itemList.map((e) => TxItem(item: e)));
  // }

  // transactions.sort((a, b) => b.compareTo(a));

  // final tempAssets = <TxItem>[];
  // final dateFormat = DateFormat('yyyy-MM-dd');
  // for (var item in transactions) {
  //   if (tempAssets.isEmpty) {
  //     tempAssets.add(item.copyWith(showDate: true));
  //   } else {
  //     final last = DateTime.parse(
  //       dateFormat.format(
  //         DateTime.fromMillisecondsSinceEpoch(tempAssets.last.createdAt),
  //       ),
  //     );
  //     final current = DateTime.parse(
  //       dateFormat.format(DateTime.fromMillisecondsSinceEpoch(item.createdAt)),
  //     );
  //     final diff = last.difference(current).inDays;
  //     tempAssets.add(item.copyWith(showDate: diff != 0));
  //   }
  // }

  // return allAssets;
}

// Version with map of assetid and transaction list
@riverpod
Map<String, List<TxItem>> assetTransactions(Ref ref) {
  final allTxs = ref.watch(allTxsNotifierProvider);
  final allPegs = ref.watch(allPegsNotifierProvider);
  final liquidAssetId = ref.watch(liquidAssetIdStateProvider);

  final transactions = <TxItem>[...allTxs.values.map((e) => TxItem(item: e))];
  for (final itemList in allPegs.values) {
    transactions.addAll(itemList.map((e) => TxItem(item: e)));
  }

  transactions.sort((a, b) => b.compareTo(a));

  void addTxItem(
    Map<String, List<TxItem>> assetsTransactions,
    String assetId,
    TransItem transaction,
  ) {
    if (assetsTransactions[assetId] == null) {
      assetsTransactions[assetId] = [];
    }
    assetsTransactions[assetId]!.add(TxItem(item: transaction));
  }

  final assetTransactions = <String, List<TxItem>>{};

  for (final item in allTxs.values) {
    final tx = item.tx;
    for (final balance in tx.balances) {
      addTxItem(assetTransactions, balance.assetId, item);
    }
  }

  for (final order in allPegs.entries) {
    for (final item in order.value) {
      addTxItem(assetTransactions, liquidAssetId, item);
    }
  }

  final allAssets = <String, List<TxItem>>{};

  final dateFormat = DateFormat('yyyy-MM-dd');
  for (var item in assetTransactions.entries) {
    item.value.sort((a, b) => b.compareTo(a));

    final tempAssets = <TxItem>[];
    for (var item in item.value) {
      if (tempAssets.isEmpty) {
        tempAssets.add(item.copyWith(showDate: true));
      } else {
        final last = DateTime.parse(
          dateFormat.format(
            DateTime.fromMillisecondsSinceEpoch(tempAssets.last.createdAt),
          ),
        );
        final current = DateTime.parse(
          dateFormat.format(
            DateTime.fromMillisecondsSinceEpoch(item.createdAt),
          ),
        );
        final diff = last.difference(current).inDays;
        tempAssets.add(item.copyWith(showDate: diff != 0));
      }
    }

    allAssets[item.key] = tempAssets;
  }
  return allAssets;
}

// TODO (malcolmpl): new wallets
// @riverpod
// List<TxItem> transactionsForAccount(Ref ref, AccountType accountType) {
//   final allAssets = ref.watch(accountAssetTransactionsProvider);

//   final transactions = <TxItem>[];
//   for (final accountAsset in allAssets.keys) {
//     if (accountAsset.account == accountType) {
//       transactions.addAll(allAssets[accountAsset] ?? []);
//     }
//   }

//   return transactions;
// }

@riverpod
List<TxItem> distinctTransactionsForAccount(Ref ref) {
  final allTxSorted = ref.watch(allTxsSortedProvider);

  final transactions = <TxItem>[];
  for (final tx in allTxSorted) {
    transactions.add(TxItem(item: tx));
  }

  transactions.sort((a, b) => b.compareTo(a));

  final dateFormat = DateFormat('yyyy-MM-dd');
  final tempTx = <TxItem>[];

  for (final item in transactions) {
    if (tempTx.isEmpty) {
      tempTx.add(item.copyWith(showDate: true));
    } else {
      final last = DateTime.parse(
        dateFormat.format(
          DateTime.fromMillisecondsSinceEpoch(tempTx.last.createdAt),
        ),
      );
      final current = DateTime.parse(
        dateFormat.format(DateTime.fromMillisecondsSinceEpoch(item.createdAt)),
      );
      final diff = last.difference(current).inDays;
      tempTx.add(item.copyWith(showDate: diff != 0));
    }
  }

  return tempTx;
}

@riverpod
TransItemHelper transItemHelper(Ref ref, TransItem transItem) {
  final liquidAssetId = ref.read(liquidAssetIdStateProvider);
  final bitcoinAssetId = ref.watch(bitcoinAssetIdProvider);
  final assetsState = ref.read(assetsStateProvider);
  final assetUtils = ref.read(assetUtilsProvider);
  final amountToString = ref.read(amountToStringProvider);
  final satoshiRepository = ref.read(satoshiRepositoryProvider);

  return TransItemHelper(
    liquidAssetId,
    bitcoinAssetId,
    assetsState,
    assetUtils,
    amountToString,
    satoshiRepository,
    transItem,
  );
}

enum TxType { received, sent, swap, internal, unknown, pegIn, pegOut }

enum TxCircleImageType {
  pegIn,
  pegOut,
  swap,
  sent,
  received,
  sentAvatar,
  receivedAvatar,
  unknown,
}

class TransItemHelper {
  final String liquidAssetId;
  final String bitcoinAssetId;
  final Map<String, Asset> assetsState;
  final AssetUtils assetUtils;
  final AmountToString amountToString;
  final AbstractSatoshiRepository satoshiRepository;
  final TransItem transItem;

  TransItemHelper(
    this.liquidAssetId,
    this.bitcoinAssetId,
    this.assetsState,
    this.assetUtils,
    this.amountToString,
    this.satoshiRepository,
    this.transItem,
  );

  TxType txType() {
    if (transItem.whichItem() == TransItem_Item.peg) {
      return switch (transItem.peg.isPegIn) {
        true => TxType.pegIn,
        _ => TxType.pegOut,
      };
    }

    final tx = transItem.tx;

    var anyPositive = false;
    var anyNegative = false;
    for (var balance in tx.balances) {
      if (balance.amount > 0) {
        anyPositive = true;
      }
      if (balance.amount < 0) {
        anyNegative = true;
      }
    }
    if (tx.balances.length == 2 &&
        anyPositive &&
        anyNegative &&
        (tx.balances[0].assetId != tx.balances[1].assetId)) {
      return TxType.swap;
    }

    if (tx.balances.length == 1 &&
        tx.balances.first.amount == -tx.networkFee &&
        tx.balances.first.assetId == liquidAssetId) {
      return TxType.internal;
    }
    if (anyPositive && !anyNegative) {
      return TxType.received;
    }
    if (anyNegative && !anyPositive) {
      return TxType.sent;
    }

    return TxType.unknown;
  }

  IconData txIcon() {
    return switch (txType()) {
      TxType.received => Icons.arrow_circle_down,
      TxType.sent => Icons.arrow_circle_up,
      TxType.swap => Icons.swap_horiz,
      TxType.internal => Icons.swap_horiz,
      TxType.unknown => Icons.device_unknown,
      TxType.pegIn => Icons.device_unknown,
      TxType.pegOut => Icons.device_unknown,
    };
  }

  String txTypeName() {
    return switch (txType()) {
      TxType.received => 'Received'.tr(),
      TxType.sent => 'Sent'.tr(),
      TxType.swap => 'Swap'.tr(),
      TxType.internal => 'Internal'.tr(),
      TxType.unknown => 'Unknown'.tr(),
      TxType.pegIn => 'Peg-In'.tr(),
      TxType.pegOut => 'Peg-Out'.tr(),
    };
  }

  String txFromAction() {
    return switch (txType()) {
      TxType.swap ||
      TxType.sent ||
      TxType.internal ||
      TxType.unknown => 'Sent'.tr(),
      TxType.received => 'From'.tr(),
      TxType.pegIn => 'Received'.tr(),
      TxType.pegOut => 'To'.tr(),
    };
  }

  String txToAction() {
    return switch (txType()) {
      TxType.swap ||
      TxType.received ||
      TxType.internal ||
      TxType.unknown => 'Received'.tr(),
      TxType.sent || TxType.pegOut => 'To'.tr(),
      TxType.pegIn => 'From'.tr(),
    };
  }

  int txAssetAmount(String assetId) {
    final tx = transItem.tx;
    var amount = 0;

    for (var balance in tx.balances) {
      if (balance.assetId == assetId) {
        amount += balance.amount.toInt();
      }
    }
    return amount;
  }

  String assetAmountToString(String assetId, Int64 amount) {
    final asset = assetsState[assetId];
    final ticker = asset?.ticker;
    final precision = assetUtils.getPrecisionForAssetId(
      assetId: asset?.assetId,
    );
    final amountStr = amountToString.amountToStringNamed(
      AmountToStringNamedParameters(
        amount: amount.toInt(),
        forceSign: true,
        precision: precision,
        ticker: ticker ?? '',
      ),
    );

    return amountStr;
  }

  ({String sendBalance, String recvBalance}) txSwapBalancesString() {
    final delivered = getSentBalance(liquidAssetId, bitcoinAssetId);
    final received = getRecvBalance(liquidAssetId, bitcoinAssetId);

    final balanceSendStr = assetAmountToString(
      delivered.assetId,
      -delivered.amount,
    );
    final balanceRecvStr = assetAmountToString(
      received.assetId,
      received.amount,
    );

    return (
      sendBalance: balanceSendStr,
      recvBalance: received.amount == 0 ? '' : balanceRecvStr,
    );
  }

  String txSendBalance() {
    final sendBalance = getSentBalance(liquidAssetId, bitcoinAssetId);

    return assetAmountToString(sendBalance.assetId, -sendBalance.amount);
  }

  ({String recvBalance, bool multipleOutputs}) txReceivedBalance() {
    if (getRecvMultipleOutputs()) {
      Set<String> assetOutputs = {};
      for (final balance in transItem.tx.balances) {
        final asset = assetsState[balance.assetId];
        if (asset?.ticker != null) {
          assetOutputs.add(asset!.ticker);
        }
      }

      // String output = '';
      final firstSlice = assetOutputs.slices(3).first;
      return (
        recvBalance: firstSlice.fold<String>(
          '',
          (p, e) => e == firstSlice.last ? '$p$e...' : '$p$e, ',
        ),
        multipleOutputs: true,
      );
    }

    final recvBalance = getRecvBalance(liquidAssetId, bitcoinAssetId);

    return (
      recvBalance: assetAmountToString(recvBalance.assetId, recvBalance.amount),
      multipleOutputs: false,
    );
  }

  ({String assetId, String ticker, String amount}) txPegInBalance() {
    final balance = getRecvBalance(liquidAssetId, bitcoinAssetId);

    final asset = assetsState[balance.assetId];
    final ticker = asset?.ticker ?? '';
    final amount = assetAmountToString(balance.assetId, balance.amount);

    return (assetId: balance.assetId, ticker: ticker, amount: amount);
  }

  String txPegInConversionRate() {
    final amountSend = transItem.peg.amountSend.toInt();
    final amountRecv = transItem.peg.amountRecv.toInt();
    final conversionRate = (amountSend != 0 && amountRecv != 0)
        ? amountRecv * 100 / amountSend
        : 0;
    return '${conversionRate.toStringAsFixed(2)}%';
  }

  ({String assetId, String ticker, String amount}) txPegOutBalance() {
    final balance = getSentBalance(liquidAssetId, bitcoinAssetId);

    final asset = assetsState[balance.assetId];
    final ticker = asset?.ticker ?? '';
    final amount = assetAmountToString(balance.assetId, -balance.amount);

    return (assetId: balance.assetId, ticker: ticker, amount: amount);
  }

  String txPegInAddress() {
    return transItem.hasPeg() ? transItem.peg.addrSend : '';
  }

  String txPegOutAddress() {
    return transItem.hasPeg() ? transItem.peg.addrRecv : '';
  }

  Balance getSentBalance(String liquidAssetId, String bitcoinAssetId) {
    if (transItem.hasPeg()) {
      return Balance(
        amount: transItem.peg.amountSend,
        assetId: transItem.peg.isPegIn ? bitcoinAssetId : liquidAssetId,
      );
    }

    return switch (txType()) {
      TxType.sent => () {
        final balance = transItem.tx.balances.length == 1
            ? transItem.tx.balances.first
            : transItem.tx.balances.firstWhere(
                (e) => e.assetId != liquidAssetId,
              );
        final amount = balance.assetId == liquidAssetId
            ? -balance.amount - transItem.tx.networkFee
            : -balance.amount;
        return Balance(amount: amount, assetId: balance.assetId);
      }(),
      TxType.swap || TxType.internal => () {
        final balance = transItem.tx.balances.firstWhere((e) => e.amount < 0);
        return Balance(amount: -balance.amount, assetId: balance.assetId);
      }(),

      // TxType.internal ||
      TxType.received ||
      TxType.unknown ||
      TxType.pegIn ||
      TxType.pegOut => Balance(),
    };
  }

  Balance getRecvBalance(String liquidBitcoin, String bitcoin) {
    if (transItem.hasPeg()) {
      return Balance(
        amount: transItem.peg.amountRecv,
        assetId: transItem.peg.isPegIn ? liquidBitcoin : bitcoin,
      );
    }

    return switch (txType()) {
      TxType.received || TxType.swap => () {
        final balance = transItem.tx.balances.firstWhere((e) => e.amount > 0);
        return Balance(amount: balance.amount, assetId: balance.assetId);
      }(),
      TxType.internal ||
      TxType.sent ||
      TxType.unknown ||
      TxType.pegIn ||
      TxType.pegOut => Balance(),
    };
  }

  bool getRecvMultipleOutputs() {
    return transItem.tx.balances.where((e) => e.amount > 0).length > 1;
  }

  bool getSentMultipleOutputs() {
    if (txType() != TxType.sent) {
      return false;
    }

    final txFee = transItem.tx.networkFee;
    final tempBalances = [...transItem.tx.balances];
    tempBalances.removeWhere(
      (element) => element.assetId == liquidAssetId && element.amount == -txFee,
    );
    return tempBalances.length > 1;
  }

  List<({String assetId, String ticker, String amount})> getBalancesAll() {
    final values = <({String assetId, String ticker, String amount})>[];
    if (!transItem.hasTx()) {
      return [];
    }

    for (final balance in transItem.tx.balancesAll) {
      final asset = assetsState[balance.assetId];
      final ticker = asset?.ticker;
      final precision = assetUtils.getPrecisionForAssetId(
        assetId: asset?.assetId,
      );
      final amountStr = amountToString.amountToString(
        AmountToStringParameters(
          amount: balance.amount.toInt(),
          forceSign: true,
          precision: precision,
        ),
      );
      values.add((
        assetId: balance.assetId,
        ticker: ticker ?? '',
        amount: amountStr,
      ));
    }

    return values;
  }

  ({String assetId, String ticker, String networkFeeAmount}) getNetworkFee() {
    final liquidAsset = assetsState[liquidAssetId];

    final liquidTicker = liquidAsset?.ticker;
    final precision = assetUtils.getPrecisionForAssetId(assetId: liquidAssetId);
    final networkFee = transItem.tx.networkFee.toInt();
    final networkFeeAmount = amountToString.amountToString(
      AmountToStringParameters(
        amount: networkFee == 0 ? networkFee : -networkFee,
        forceSign: networkFee == 0 ? false : true,
        precision: precision,
      ),
    );

    return (
      assetId: liquidAssetId,
      ticker: liquidTicker ?? '',
      networkFeeAmount: networkFeeAmount,
    );
  }

  ({String assetId, String ticker, String amount}) getSwapDeliveredAmount() {
    final deliveredBalance = getSentBalance(liquidAssetId, bitcoinAssetId);
    final asset = assetsState[deliveredBalance.assetId];
    final deliveredTicker = asset?.ticker ?? '';
    final deliveredPrecision = assetUtils.getPrecisionForAssetId(
      assetId: deliveredBalance.assetId,
    );
    final deliveredAmount = amountToString.amountToString(
      AmountToStringParameters(
        amount: -deliveredBalance.amount.toInt(),
        forceSign: true,
        precision: deliveredPrecision,
      ),
    );

    return (
      assetId: deliveredBalance.assetId,
      ticker: deliveredTicker,
      amount: deliveredAmount,
    );
  }

  ({String assetId, String ticker, String amount}) getSwapReceivedAmount() {
    final receivedBalance = getRecvBalance(liquidAssetId, bitcoinAssetId);
    final asset = assetsState[receivedBalance.assetId];
    final receivedTicker = asset?.ticker ?? '';
    final receivedPrecision = assetUtils.getPrecisionForAssetId(
      assetId: receivedBalance.assetId,
    );
    final receivedAmount = amountToString.amountToString(
      AmountToStringParameters(
        amount: receivedBalance.amount.toInt(),
        forceSign: true,
        precision: receivedPrecision,
      ),
    );

    return (
      assetId: receivedBalance.assetId,
      ticker: receivedTicker,
      amount: receivedAmount,
    );
  }

  List<({String assetId, String ticker, String amount})> getBalances({
    bool removeFeeAsset = false,
  }) {
    if (!transItem.hasTx()) {
      return [];
    }

    final balances = <Balance>[];
    balances.addAll(transItem.tx.balances);

    if (removeFeeAsset) {
      final feeAmount = transItem.tx.networkFee;
      balances.removeWhere(
        (e) => e.amount.abs() == feeAmount && e.assetId == liquidAssetId,
      );
    }

    return List<({String assetId, String ticker, String amount})>.generate(
      balances.length,
      (index) {
        final balance = balances[index];
        final asset = assetsState[balance.assetId];
        final ticker = asset != null ? asset.ticker : '???';
        final amount = amountToString.amountToString(
          AmountToStringParameters(
            amount: balance.amount.toInt(),
            forceSign: true,
            precision: asset?.precision ?? 8,
          ),
        );

        return (assetId: balance.assetId, ticker: ticker, amount: amount);
      },
    );
  }

  TxCircleImageType txTypeToImageType() {
    return switch (txType()) {
      TxType.received => TxCircleImageType.received,
      TxType.sent => TxCircleImageType.sent,
      TxType.swap => TxCircleImageType.swap,
      TxType.internal => TxCircleImageType.swap,
      TxType.unknown => TxCircleImageType.unknown,
      TxType.pegIn => TxCircleImageType.pegIn,
      TxType.pegOut => TxCircleImageType.pegOut,
    };
  }

  String getTxImageAssetName() {
    return switch (txType()) {
      TxType.received => 'assets/tx_icons/recv.svg',
      TxType.sent => 'assets/tx_icons/sent.svg',
      TxType.swap => 'assets/tx_icons/swap.svg',
      TxType.internal => 'assets/tx_icons/internal.svg',
      TxType.unknown => 'assets/tx_icons/unknown.svg',
      TxType.pegIn => 'assets/tx_icons/pegin.svg',
      TxType.pegOut => 'assets/tx_icons/pegout.svg',
    };
  }

  String txTargetPrice() {
    return switch (txType()) {
      TxType.swap => price(),
      _ => '',
    };
  }

  String price() {
    final balanceDelivered = transItem.tx.balances.firstWhere(
      (e) => e.amount < 0,
    );
    final balanceReceived = transItem.tx.balances.firstWhere(
      (e) => e.amount >= 0,
    );

    final assetSent = assetsState[balanceDelivered.assetId];
    final assetRecv = assetsState[balanceReceived.assetId];

    final satoshiDelivered = balanceDelivered.amount.toInt().abs();
    final satoshiReceived = balanceReceived.amount.toInt().abs();
    final sentBitcoin = balanceDelivered.assetId == liquidAssetId;
    final networkFee = transItem.tx.networkFee.toInt().abs();

    final satoshiDeliveredAdjusted = switch (sentBitcoin) {
      true => satoshiDelivered - networkFee,
      _ => satoshiDelivered,
    };

    final decimalDelivered = satoshiRepository.toDecimal(
      amount: satoshiDeliveredAdjusted,
      precision: assetSent?.precision ?? 8,
    );
    final decimalReceived = satoshiRepository.toDecimal(
      amount: satoshiReceived,
      precision: assetRecv?.precision ?? 8,
    );

    // we're treat result as float amount (not an asset) with precision 8
    const pricePrecision = 8;
    final result = switch (sentBitcoin) {
      true =>
        (Decimal.one / decimalDelivered).toDecimal(
              scaleOnInfinitePrecision: pricePrecision,
            ) *
            decimalReceived,
      _ => (decimalDelivered / decimalReceived).toDecimal(
        scaleOnInfinitePrecision: pricePrecision,
      ),
    };

    final decimalKCoin = Decimal.fromInt(kCoin);
    final satoshiResult = result * decimalKCoin;

    final priceString = amountToString.amountToString(
      AmountToStringParameters(
        amount: satoshiResult.toBigInt().toInt(),
        precision: pricePrecision,
        trailingZeroes: true,
        useNumberFormatter: true,
      ),
    );

    // format price
    final targetPrice = replaceCharacterOnPosition(
      input: priceString,
      currencyChar: sentBitcoin
          ? assetRecv?.ticker ?? ''
          : assetSent?.ticker ?? '',
      currencyCharAlignment: CurrencyCharAlignment.end,
    );

    return switch (sentBitcoin) {
      true => '1 ${assetSent?.ticker ?? ''} = $targetPrice',
      _ => '1 ${assetRecv?.ticker ?? ''} = $targetPrice',
    };
  }

  Confs txConfs() {
    return switch (transItem.hasConfs()) {
      true => transItem.confs,
      _ => Confs(),
    };
  }

  List<Balance> txBalances() {
    return switch (transItem.hasTx()) {
      true => transItem.tx.balances,
      _ => [],
    };
  }

  String txStatus() {
    final isPeg = transItem.hasPeg();
    if (isPeg && !transItem.hasConfs()) {
      return !transItem.peg.hasTxidRecv() ? 'Initiated'.tr() : 'Complete'.tr();
    }

    final unconfirmed = 'Unconfirmed'.tr();
    final confirmed = 'Confirmed'.tr();
    return !transItem.hasConfs()
        ? '$confirmed 2/2'
        : '$unconfirmed ${transItem.confs.count}/${transItem.confs.total}';
  }

  String txDateTimeStr() {
    final longFormat = DateFormat('MMM d, yyyy \'at\' HH:mm');
    return longFormat.format(
      DateTime.fromMillisecondsSinceEpoch(transItem.createdAt.toInt()),
    );
  }

  ({String txId, bool isLiquid, bool unblinded}) txId() {
    return switch (txType()) {
      TxType.pegIn => (
        txId: transItem.peg.txidRecv,
        isLiquid: true,
        unblinded: true,
      ),
      TxType.pegOut => (
        txId: transItem.peg.txidRecv,
        isLiquid: false,
        unblinded: true,
      ),
      _ => (txId: transItem.tx.txid, isLiquid: true, unblinded: false),
    };
  }
}
