import 'dart:collection';
import 'dart:io';
import 'dart:typed_data';

import 'package:csv/csv.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/utils/custom_logger.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/balances.dart';
import 'package:sideswap/screens/flavor_config.dart';

final exportTxListProvider = Provider.autoDispose<List<List<String>>>((ref) {
  final txs = ref.watch(walletProvider.select((value) => value.allTxs.values));
  final assets = ref.watch(walletProvider.select((value) => value.assets));

  final result = <List<String>>[];

  final usedAssets = SplayTreeSet<String>();
  for (final tx in txs) {
    for (final balance in tx.tx.balances) {
      usedAssets.add(balance.assetId);
    }
  }
  // Keep only known assets where
  usedAssets.remove((String asset) => !assets.containsKey(asset));

  // Header
  final line = <String>[];
  line.add('Wallet');
  line.add("txid");
  line.add("type");
  line.add("timestamp");
  line.add("network fee");
  line.add("memo");
  for (final asset in usedAssets) {
    line.add(assets[asset]!.name);
  }
  result.add(line);

  // Items
  var txsSorted = txs.toList();
  txsSorted.sort((a, b) => a.createdAt.compareTo(b.createdAt));
  for (var tx in txsSorted) {
    final line = <String>[];
    line.add(AccountType.fromPb(tx.account).isAmp()
        ? 'Amp'
        : AccountType.fromPb(tx.account).isRegular()
            ? 'Regular'
            : 'Unknown');
    line.add(tx.tx.txid);
    line.add(txTypeName(txType(tx.tx)));
    line.add(txDateCsvExport(tx.createdAt.toInt()));
    line.add(amountStr(tx.tx.networkFee.toInt()));
    line.add(tx.tx.memo);
    for (final assetId in usedAssets) {
      final asset = assets[assetId]!;
      var balance = 0;
      tx.tx.balances
          .where((balance) => balance.assetId == asset.assetId)
          .forEach((item) => balance += item.amount.toInt());
      line.add(amountStr(balance, precision: asset.precision));
    }
    result.add(line);
  }

  return result;
});

final csvListProvider = Provider.autoDispose<String>((ref) {
  final list = ref.watch(exportTxListProvider);
  return const ListToCsvConverter().convert(list);
});

final csvPathFutureProvider = FutureProvider.autoDispose<String>((ref) async {
  if (FlavorConfig.isDesktop) {
    final defaultPath = await getApplicationDocumentsDirectory();
    const defaultName = 'transactions.csv';
    final path = await getSavePath(
      initialDirectory: defaultPath.path,
      suggestedName: defaultName,
    );

    if (path == null) {
      throw 'Invalid path';
    }

    return path;
  } else {
    final dir = (await getTemporaryDirectory()).path;
    return '$dir/data.csv';
  }
});

final csvStateNotifierProvider =
    StateNotifierProvider.autoDispose<CsvProvider, AsyncValue<bool>>((ref) {
  final csv = ref.watch(csvListProvider);

  return CsvProvider(ref, csv);
});

class CsvProvider extends StateNotifier<AsyncValue<bool>> {
  final Ref ref;
  final String csv;

  CsvProvider(this.ref, this.csv) : super(const AsyncValue.loading());

  Future<void> save() async {
    final csvPath = await AsyncValue.guard(() async {
      final path = await ref.read(csvPathFutureProvider.future);
      return path;
    });

    csvPath.when(loading: () {
      if (mounted) {
        state = const AsyncValue.loading();
      }
    }, data: (value) async {
      const defaultName = 'transactions.csv';
      final data = Uint8List.fromList(csv.codeUnits);
      final file =
          XFile.fromData(data, name: defaultName, mimeType: 'text/plain');
      await file.saveTo(value);

      if (mounted) {
        state = const AsyncValue.data(true);
      }
    }, error: (error, stackTrace) {
      logger.e(error);
      logger.e(stackTrace);

      if (mounted) {
        state = AsyncValue.error(error, stackTrace);
      }
    });
  }

  Future<void> share(RenderBox? box) async {
    final csvPath = await AsyncValue.guard(() async {
      final path = await ref.read(csvPathFutureProvider.future);
      return path;
    });

    csvPath.when(loading: () {
      if (mounted) {
        state = const AsyncValue.loading();
      }
    }, data: (value) async {
      if (box == null) {
        return;
      }

      await File(value).writeAsString(csv);
      await Share.shareFiles(
        [value],
        mimeTypes: ['text/csv'],
        text: 'Transactions list',
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
      );

      if (mounted) {
        state = const AsyncValue.data(true);
      }
    }, error: (error, stackTrace) {
      logger.e(error);
      logger.e(stackTrace);

      if (mounted) {
        state = AsyncValue.error(error, stackTrace);
      }
    });
  }
}
