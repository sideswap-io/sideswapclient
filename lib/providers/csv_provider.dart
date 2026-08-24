import 'dart:collection';
import 'dart:typed_data';

import 'package:csv/csv.dart';
import 'package:file_selector/file_selector.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/tx_provider.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/screens/accounts/widgets/csv_io_impl.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

part 'csv_provider.g.dart';
part 'csv_provider.freezed.dart';

typedef HelperFactory = TransItemHelper Function(TransItem);

abstract class CsvPathResolver {
  Future<String> resolve();
}

abstract class CsvFileIo {
  Future<void> saveXFileTo(XFile file, String path);
  Future<void> writeAndShare(String path, String content);
}

@riverpod
CsvRepository csvRepository(Ref ref) {
  final allTxs = ref.watch(allTxsProvider);
  final assets = ref.watch(assetsStateProvider);
  final amountToString = ref.watch(amountToStringProvider);

  return CsvRepository(
    allTxs: allTxs,
    assets: assets,
    amountToString: amountToString,
    helperFactory: (tx) => ref.read(transItemHelperProvider(tx)),
    pathResolver: FlavorConfig.isDesktop
        ? const DesktopCsvPathResolver()
        : const MobileCsvPathResolver(),
  );
}

class CsvRepository {
  final Map<String, TransItem> allTxs;
  final Map<String, Asset> assets;
  final AmountToString amountToString;
  final HelperFactory _helperFactory;
  final CsvPathResolver _pathResolver;

  CsvRepository({
    required this.allTxs,
    required this.assets,
    required this.amountToString,
    required this._helperFactory,
    required this._pathResolver,
  });

  Future<List<List<String>>> fetchData() async {
    final result = <List<String>>[];

    final usedAssets = SplayTreeSet<String>();
    for (final tx in allTxs.values) {
      for (final balance in tx.tx.balances) {
        usedAssets.add(balance.assetId);
      }
    }

    usedAssets.removeWhere((element) => !assets.containsKey(element));

    final line = <String>[];
    line.add("txid");
    line.add("type");
    line.add("timestamp");
    line.add("network fee");
    line.add("memo");
    for (final asset in usedAssets) {
      line.add(assets[asset]!.name);
    }
    result.add(line);

    var txsSorted = allTxs.values.toList();
    txsSorted.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    for (var transItem in txsSorted) {
      final transItemHelper = _helperFactory(transItem);
      final txAmountStr = amountToString.amountToString(
        AmountToStringParameters(amount: transItem.tx.networkFee.toInt()),
      );

      final line = <String>[];
      line.add(transItem.tx.txid);
      line.add(transItemHelper.txTypeName());
      line.add(txDateCsvExport(transItem.createdAt.toInt()));
      line.add(txAmountStr);
      line.add(transItem.tx.memo);
      for (final assetId in usedAssets) {
        final asset = assets[assetId]!;
        var balance = 0;
        transItem.tx.balances
            .where((balance) => balance.assetId == asset.assetId)
            .forEach((item) => balance += item.amount.toInt());

        final assetAmountStr = amountToString.amountToString(
          AmountToStringParameters(amount: balance, precision: asset.precision),
        );

        line.add(assetAmountStr);
      }
      result.add(line);
    }

    return result;
  }

  Future<String> fetchStringData() async {
    final data = await fetchData();
    return csv.encode(data);
  }

  Future<String> fetchOutputPath() => _pathResolver.resolve();
}

@freezed
sealed class CvsState with _$CvsState {
  const factory CvsState.empty() = CvsStateEmpty;
  const factory CvsState.success() = CvsStateSuccess;
}

@riverpod
class CsvNotifier extends _$CsvNotifier {
  late CsvRepository _csvRepository;
  final CsvFileIo _fileIo;

  CsvNotifier({CsvFileIo? fileIo}) : _fileIo = fileIo ?? const RealCsvFileIo();

  @override
  FutureOr<CvsState> build() {
    _csvRepository = ref.watch(csvRepositoryProvider);
    return CvsState.empty();
  }

  Future<void> save() async {
    state = AsyncValue.loading();
    ref.notifyListeners();

    try {
      final path = await _csvRepository.fetchOutputPath();
      final csv = await _csvRepository.fetchStringData();
      final data = Uint8List.fromList(csv.codeUnits);
      final file = XFile.fromData(
        data,
        name: 'transactions.csv',
        mimeType: 'text/plain',
      );
      await _fileIo.saveXFileTo(file, path);
      state = const AsyncValue.data(CvsState.success());
    } catch (error, stackTrace) {
      logger.e(error);
      logger.e(stackTrace);
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> share() async {
    try {
      final path = await _csvRepository.fetchOutputPath();
      final csv = await _csvRepository.fetchStringData();
      await _fileIo.writeAndShare(path, csv);
      state = const AsyncValue.data(CvsState.success());
    } catch (error, stackTrace) {
      logger.e(error);
      logger.e(stackTrace);
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

@freezed
sealed class ExportCsvState with _$ExportCsvState {
  const factory ExportCsvState.empty() = ExportCsvStateEmpty;
  const factory ExportCsvState.loading() = ExportCsvStateLoading;
  const factory ExportCsvState.error([String? errorMsg]) = ExportCsvStateError;
  const factory ExportCsvState.loaded([List<TransItem>? txs]) =
      ExportCsvStateLoaded;
}

@riverpod
class ExportCsvStateNotifier extends _$ExportCsvStateNotifier {
  @override
  ExportCsvState build() {
    ref.listen(loadTransactionsStateProvider, (_, loadTransactionsState) {
      final allTxSorted = ref.read(allTxsSortedProvider);

      (switch (loadTransactionsState) {
        LoadTransactionsStateEmpty()
            when state is ExportCsvStateLoading ||
                state is ExportCsvStateLoaded =>
          state = ExportCsvState.loaded(allTxSorted),
        LoadTransactionsStateError() => state = ExportCsvState.error(
          loadTransactionsState.errorMsg,
        ),
        LoadTransactionsStateLoading() => state = ExportCsvState.loading(),
        _ => state = ExportCsvState.empty(),
      });
    });

    init();

    return const ExportCsvState.empty();
  }

  void init() {
    final loadTransactionsState = ref.read(loadTransactionsStateProvider);
    if (loadTransactionsState is LoadTransactionsStateEmpty) {
      ref.read(allTxsProvider.notifier).loadTransactions();
    }
  }
}
