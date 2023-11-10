import 'dart:collection';
import 'dart:io';
import 'dart:typed_data';

import 'package:csv/csv.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/tx_provider.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/screens/balances.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

part 'csv_provider.g.dart';

@riverpod
CsvRepository csvRepository(CsvRepositoryRef ref) {
  final allTxs = ref.watch(allTxsNotifierProvider);
  final assets = ref.watch(assetsStateProvider);
  final amountToString = ref.watch(amountToStringProvider);

  return CsvRepository(
    allTxs: allTxs,
    assets: assets,
    amountToString: amountToString,
  );
}

class CsvRepository {
  final Map<String, TransItem> allTxs;
  final Map<String, Asset> assets;
  final AmountToString amountToString;

  CsvRepository({
    required this.allTxs,
    required this.assets,
    required this.amountToString,
  });

  Future<List<List<String>>> fetchData() async {
    final result = <List<String>>[];

    final usedAssets = SplayTreeSet<String>();
    for (final tx in allTxs.values) {
      for (final balance in tx.tx.balances) {
        usedAssets.add(balance.assetId);
      }
    }

    // Keep only known assets where
    usedAssets.removeWhere((element) => !assets.containsKey(element));

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
    var txsSorted = allTxs.values.toList();
    txsSorted.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    for (var tx in txsSorted) {
      final txAmountStr = amountToString.amountToString(
          AmountToStringParameters(amount: tx.tx.networkFee.toInt()));

      final line = <String>[];
      line.add(AccountType.fromPb(tx.account).isAmp
          ? 'Amp'
          : AccountType.fromPb(tx.account).isRegular
              ? 'Regular'
              : 'Unknown');
      line.add(tx.tx.txid);
      line.add(txTypeName(txType(tx.tx)));
      line.add(txDateCsvExport(tx.createdAt.toInt()));
      line.add(txAmountStr);
      line.add(tx.tx.memo);
      for (final assetId in usedAssets) {
        final asset = assets[assetId]!;
        var balance = 0;
        tx.tx.balances
            .where((balance) => balance.assetId == asset.assetId)
            .forEach((item) => balance += item.amount.toInt());

        final assetAmountStr = amountToString.amountToString(
            AmountToStringParameters(
                amount: balance, precision: asset.precision));

        line.add(assetAmountStr);
      }
      result.add(line);
    }

    return result;
  }

  Future<String> fetchStringData() async {
    final data = await fetchData();
    return const ListToCsvConverter().convert(data);
  }

  Future<String> fetchOutputPath() async {
    if (FlavorConfig.isDesktop) {
      final defaultPath = await getApplicationDocumentsDirectory();
      const defaultName = 'transactions.csv';
      final saveLocation = await getSaveLocation(
        initialDirectory: defaultPath.path,
        suggestedName: defaultName,
      );

      if (saveLocation == null) {
        return Future.error('Invalid path or canceled by user');
      }

      return saveLocation.path;
    } else {
      final dir = (await getTemporaryDirectory()).path;
      return '$dir/data.csv';
    }
  }
}

@riverpod
class CsvNotifier extends _$CsvNotifier {
  late CsvRepository _csvRepository;

  @override
  FutureOr<bool> build() async {
    _csvRepository = ref.watch(csvRepositoryProvider);
    return true;
  }

  Future<void> save() async {
    state = const AsyncValue.loading();
    ref.notifyListeners();
    final csvPath = await AsyncValue.guard(() async {
      final path = await _csvRepository.fetchOutputPath();
      return path;
    });

    csvPath.when(loading: () {
      state = const AsyncValue.loading();
    }, data: (value) async {
      const defaultName = 'transactions.csv';
      final csv = await _csvRepository.fetchStringData();
      final data = Uint8List.fromList(csv.codeUnits);
      final file =
          XFile.fromData(data, name: defaultName, mimeType: 'text/plain');
      await file.saveTo(value);

      state = const AsyncValue.data(true);
    }, error: (error, stackTrace) {
      logger.e(error);
      logger.e(stackTrace);

      state = AsyncValue.error(error, stackTrace);
    });
  }

  Future<void> share(RenderBox? box) async {
    final csvPath = await AsyncValue.guard(() async {
      final path = await _csvRepository.fetchOutputPath();
      return path;
    });

    csvPath.when(loading: () {
      state = const AsyncValue.loading();
    }, data: (value) async {
      if (box == null) {
        return;
      }

      final csv = await _csvRepository.fetchStringData();
      await File(value).writeAsString(csv);
      await Share.shareXFiles(
        [XFile(value, mimeType: 'text/csv')],
      );

      state = const AsyncValue.data(true);
    }, error: (error, stackTrace) {
      logger.e(error);
      logger.e(stackTrace);

      state = AsyncValue.error(error, stackTrace);
    });
  }
}
