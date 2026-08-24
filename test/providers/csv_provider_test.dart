import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/csv_provider.dart';
import 'package:sideswap/providers/tx_provider.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap_logger/custom_logger.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class _NoOpLogOutput extends LogOutput {
  @override
  void output(OutputEvent event) {}
}

class MockCsvRepository extends Mock implements CsvRepository {}

class MockCsvFileIo extends Mock implements CsvFileIo {}

class MockCsvPathResolver extends Mock implements CsvPathResolver {}

class MockTransItemHelper extends Mock implements TransItemHelper {}

class _SpyAllTxsNotifier extends AllTxsNotifier {
  int loadTransactionsCalls = 0;

  @override
  Map<String, TransItem> build() => {};

  @override
  void loadTransactions() {
    loadTransactionsCalls++;
  }
}

class _DataAllTxsNotifier extends AllTxsNotifier {
  final Map<String, TransItem> _initial;
  _DataAllTxsNotifier(this._initial);

  @override
  Map<String, TransItem> build() => Map.of(_initial);

  @override
  void loadTransactions() {}
}

// Shared proto builders
Asset _makeAsset(String id, String name, {int precision = 8}) {
  return Asset()
    ..assetId = id
    ..name = name
    ..precision = precision;
}

TransItem _makeTx(
  String txid, {
  int createdAt = 0,
  int networkFee = 1000,
  String memo = '',
  List<Balance>? balances,
}) {
  final tx = Tx()
    ..txid = txid
    ..networkFee = Int64(networkFee)
    ..memo = memo;
  if (balances != null) {
    tx.balances.addAll(balances);
  }
  return TransItem()
    ..tx = tx
    ..createdAt = Int64(createdAt);
}

Balance _makeBalance(String assetId, int amount) {
  return Balance()
    ..assetId = assetId
    ..amount = Int64(amount);
}

void main() {
  setUpAll(() {
    logger = CustomLogger('SideSwap', output: _NoOpLogOutput());
    registerFallbackValue(XFile.fromData(Uint8List(0), name: 'fallback'));
    registerFallbackValue(TransItem());
  });

  group('freezed state types', () {
    test('CvsState variants are distinct', () {
      expect(const CvsState.empty(), isA<CvsStateEmpty>());
      expect(const CvsState.success(), isA<CvsStateSuccess>());
      expect(const CvsState.empty() != const CvsState.success(), true);
    });

    test('ExportCsvState variants construct correctly', () {
      expect(const ExportCsvState.empty(), isA<ExportCsvStateEmpty>());
      expect(const ExportCsvState.loading(), isA<ExportCsvStateLoading>());
      expect(const ExportCsvState.error('msg'), isA<ExportCsvStateError>());
      expect(const ExportCsvState.loaded(), isA<ExportCsvStateLoaded>());
    });
  });

  group('csvRepository', () {
    void setFlavor({bool isDesktop = false}) {
      FlavorConfig(
        flavor: Flavor.production,
        values: FlavorValues(
          enableNetworkSettings: false,
          enableJade: false,
          enableLocalEndpoint: false,
          isDesktop: isDesktop,
        ),
      );
    }

    setUp(() => setFlavor());

    tearDown(() => setFlavor());

    ProviderContainer makeContainer() {
      return ProviderContainer.test(
        overrides: [
          allTxsProvider.overrideWith(_SpyAllTxsNotifier.new),
          assetsStateProvider.overrideWithValue({}),
          amountToStringProvider.overrideWithValue(
            AmountToString(locale: 'en'),
          ),
        ],
      );
    }

    test('creates CsvRepository with mobile pathResolver', () {
      final container = makeContainer();
      addTearDown(container.dispose);

      final repo = container.read(csvRepositoryProvider);
      expect(repo, isA<CsvRepository>());
      expect(repo.allTxs, isEmpty);
      expect(repo.assets, isEmpty);
    });

    test('creates CsvRepository with desktop pathResolver when isDesktop', () {
      setFlavor(isDesktop: true);

      final container = makeContainer();
      addTearDown(container.dispose);

      final repo = container.read(csvRepositoryProvider);
      expect(repo, isA<CsvRepository>());
    });

    test('helperFactory delegates to transItemHelperProvider', () async {
      final mockHelper = MockTransItemHelper();
      when(() => mockHelper.txTypeName()).thenReturn('sent');

      final tx = _makeTx('tx1', balances: [_makeBalance('btc', 100)]);
      final asset = _makeAsset('btc', 'BTC');

      final container = ProviderContainer.test(
        overrides: [
          allTxsProvider.overrideWith(() => _DataAllTxsNotifier({'tx1': tx})),
          assetsStateProvider.overrideWithValue({'btc': asset}),
          amountToStringProvider.overrideWithValue(
            AmountToString(locale: 'en'),
          ),
          transItemHelperProvider.overrideWith((ref, _) => mockHelper),
        ],
      );
      addTearDown(container.dispose);

      final repo = container.read(csvRepositoryProvider);
      final data = await repo.fetchData();
      expect(data, hasLength(2));
      expect(data[1][1], 'sent');
    });
  });

  group('CsvRepository.fetchData', () {
    late MockTransItemHelper mockHelper;
    late MockCsvPathResolver mockPathResolver;

    setUp(() {
      mockHelper = MockTransItemHelper();
      when(() => mockHelper.txTypeName()).thenReturn('received');
      mockPathResolver = MockCsvPathResolver();
    });

    CsvRepository makeRepo({
      required Map<String, TransItem> allTxs,
      required Map<String, Asset> assets,
    }) {
      return CsvRepository(
        allTxs: allTxs,
        assets: assets,
        amountToString: AmountToString(locale: 'en'),
        helperFactory: (_) => mockHelper,
        pathResolver: mockPathResolver,
      );
    }

    test('returns header row with fixed columns + asset names', () async {
      final assets = {'btc': _makeAsset('btc', 'Bitcoin')};
      final tx = _makeTx('tx1', balances: [_makeBalance('btc', 100)]);
      final repo = makeRepo(allTxs: {'tx1': tx}, assets: assets);

      final data = await repo.fetchData();
      expect(data[0], [
        'txid',
        'type',
        'timestamp',
        'network fee',
        'memo',
        'Bitcoin',
      ]);
    });

    test('excludes unknown asset IDs from header', () async {
      final assets = {'btc': _makeAsset('btc', 'Bitcoin')};
      final tx = _makeTx(
        'tx1',
        balances: [_makeBalance('btc', 100), _makeBalance('unknown', 200)],
      );
      final repo = makeRepo(allTxs: {'tx1': tx}, assets: assets);

      final data = await repo.fetchData();
      expect(data[0], isNot(contains('unknown')));
      expect(data[0].length, 6);
    });

    test('rows sorted by createdAt ascending', () async {
      final assets = {'btc': _makeAsset('btc', 'Bitcoin')};
      final tx1 = _makeTx(
        'tx-early',
        createdAt: 100,
        balances: [_makeBalance('btc', 1)],
      );
      final tx2 = _makeTx(
        'tx-late',
        createdAt: 200,
        balances: [_makeBalance('btc', 2)],
      );
      final repo = makeRepo(
        allTxs: {'tx-late': tx2, 'tx-early': tx1},
        assets: assets,
      );

      final data = await repo.fetchData();
      expect(data[1][0], 'tx-early');
      expect(data[2][0], 'tx-late');
    });

    test('row contains txid, type, timestamp, fee, memo', () async {
      final assets = {'btc': _makeAsset('btc', 'Bitcoin', precision: 8)};
      final tx = _makeTx(
        'abc123',
        createdAt: 1700000000,
        networkFee: 500,
        memo: 'test memo',
        balances: [_makeBalance('btc', 100000000)],
      );
      final repo = makeRepo(allTxs: {'abc123': tx}, assets: assets);

      final data = await repo.fetchData();
      final row = data[1];
      expect(row[0], 'abc123');
      expect(row[1], 'received');
      expect(row[2], matches(RegExp(r'\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}')));
      expect(row[4], 'test memo');
    });

    test('empty allTxs returns only header', () async {
      final repo = makeRepo(allTxs: {}, assets: {});

      final data = await repo.fetchData();
      expect(data, hasLength(1));
    });

    test('balance aggregation sums multiple balances per asset', () async {
      final assets = {'btc': _makeAsset('btc', 'Bitcoin', precision: 8)};
      final tx = _makeTx(
        'tx1',
        balances: [
          _makeBalance('btc', 50000000),
          _makeBalance('btc', 30000000),
        ],
      );
      final repo = makeRepo(allTxs: {'tx1': tx}, assets: assets);

      final data = await repo.fetchData();
      expect(data[1].last, '0.80000000');
    });
  });

  group('CsvRepository.fetchStringData', () {
    test('returns CSV-encoded string', () async {
      final mockHelper = MockTransItemHelper();
      when(() => mockHelper.txTypeName()).thenReturn('sent');

      final assets = {'btc': _makeAsset('btc', 'BTC')};
      final tx = _makeTx(
        'tx1',
        networkFee: 100,
        balances: [_makeBalance('btc', 1000)],
      );

      final repo = CsvRepository(
        allTxs: {'tx1': tx},
        assets: assets,
        amountToString: AmountToString(locale: 'en'),
        helperFactory: (_) => mockHelper,
        pathResolver: MockCsvPathResolver(),
      );

      final csv = await repo.fetchStringData();
      expect(csv, contains('txid'));
      expect(csv, contains('tx1'));
    });
  });

  group('CsvRepository.fetchOutputPath', () {
    test('delegates to pathResolver', () async {
      final mockResolver = MockCsvPathResolver();
      when(
        () => mockResolver.resolve(),
      ).thenAnswer((_) async => '/tmp/test.csv');

      final repo = CsvRepository(
        allTxs: {},
        assets: {},
        amountToString: AmountToString(locale: 'en'),
        helperFactory: (_) => MockTransItemHelper(),
        pathResolver: mockResolver,
      );

      final path = await repo.fetchOutputPath();
      expect(path, '/tmp/test.csv');
      verify(() => mockResolver.resolve()).called(1);
    });
  });

  group('CsvNotifier', () {
    late MockCsvRepository mockRepo;
    late MockCsvFileIo mockFileIo;

    setUp(() {
      mockRepo = MockCsvRepository();
      mockFileIo = MockCsvFileIo();
    });

    ProviderContainer makeContainer() {
      return ProviderContainer.test(
        overrides: [
          csvRepositoryProvider.overrideWithValue(mockRepo),
          csvProvider.overrideWith(() => CsvNotifier(fileIo: mockFileIo)),
        ],
      );
    }

    test('build: initial state is CvsState.empty', () {
      final container = makeContainer();
      addTearDown(container.dispose);
      expect(container.read(csvProvider).value, isA<CvsStateEmpty>());
    });

    group('save', () {
      test('happy path: state → success, fileIo called', () async {
        when(
          () => mockRepo.fetchOutputPath(),
        ).thenAnswer((_) async => '/tmp/out.csv');
        when(
          () => mockRepo.fetchStringData(),
        ).thenAnswer((_) async => 'col1,col2\nval1,val2');
        when(
          () => mockFileIo.saveXFileTo(any(), any()),
        ).thenAnswer((_) async {});

        final container = makeContainer();
        addTearDown(container.dispose);

        await container.read(csvProvider.notifier).save();

        verify(() => mockFileIo.saveXFileTo(any(), '/tmp/out.csv')).called(1);
        expect(container.read(csvProvider).value, isA<CvsStateSuccess>());
      });

      test('error path: fetchOutputPath fails → error state', () async {
        when(
          () => mockRepo.fetchOutputPath(),
        ).thenAnswer((_) async => throw Exception('no path'));

        final container = makeContainer();
        addTearDown(container.dispose);

        await container.read(csvProvider.notifier).save();

        expect(container.read(csvProvider).hasError, true);
        verifyNever(() => mockFileIo.saveXFileTo(any(), any()));
      });

      test('error path: fetchStringData fails → error state', () async {
        when(
          () => mockRepo.fetchOutputPath(),
        ).thenAnswer((_) async => '/tmp/out.csv');
        when(
          () => mockRepo.fetchStringData(),
        ).thenAnswer((_) async => throw Exception('csv fail'));

        final container = makeContainer();
        addTearDown(container.dispose);

        await container.read(csvProvider.notifier).save();

        expect(container.read(csvProvider).hasError, true);
      });
    });

    group('share', () {
      test('happy path: writeAndShare called, state success', () async {
        when(
          () => mockRepo.fetchOutputPath(),
        ).thenAnswer((_) async => '/tmp/share.csv');
        when(
          () => mockRepo.fetchStringData(),
        ).thenAnswer((_) async => 'shared,csv');
        when(
          () => mockFileIo.writeAndShare(any(), any()),
        ).thenAnswer((_) async {});

        final container = makeContainer();
        addTearDown(container.dispose);

        await container.read(csvProvider.notifier).share();

        verify(
          () => mockFileIo.writeAndShare('/tmp/share.csv', 'shared,csv'),
        ).called(1);
        expect(container.read(csvProvider).value, isA<CvsStateSuccess>());
      });

      test('error path: fetchOutputPath fails → error state', () async {
        when(
          () => mockRepo.fetchOutputPath(),
        ).thenAnswer((_) async => throw Exception('no path'));

        final container = makeContainer();
        addTearDown(container.dispose);

        await container.read(csvProvider.notifier).share();

        expect(container.read(csvProvider).hasError, true);
        verifyNever(() => mockFileIo.writeAndShare(any(), any()));
      });
    });
  });

  group('ExportCsvStateNotifier', () {
    ProviderContainer makeContainer({
      LoadTransactionsState initialLoadState =
          const LoadTransactionsState.loading(),
      List<TransItem> allTxSorted = const [],
    }) {
      return ProviderContainer.test(
        overrides: [
          loadTransactionsStateProvider.overrideWithBuild(
            (ref, notifier) => initialLoadState,
          ),
          allTxsSortedProvider.overrideWithValue(allTxSorted),
          allTxsProvider.overrideWith(_SpyAllTxsNotifier.new),
        ],
      );
    }

    test('build returns ExportCsvState.empty', () {
      final container = makeContainer();
      addTearDown(container.dispose);

      expect(
        container.read(exportCsvStateProvider),
        isA<ExportCsvStateEmpty>(),
      );
    });

    test('init calls loadTransactions when state is empty', () {
      final spy = _SpyAllTxsNotifier();
      final container = ProviderContainer.test(
        overrides: [
          loadTransactionsStateProvider.overrideWithBuild(
            (ref, notifier) => const LoadTransactionsState.empty(),
          ),
          allTxsSortedProvider.overrideWithValue([]),
          allTxsProvider.overrideWith(() => spy),
        ],
      );
      addTearDown(container.dispose);

      container.read(exportCsvStateProvider);
      expect(spy.loadTransactionsCalls, 1);
    });

    test('listener: Loading → ExportCsvState.loading', () async {
      final container = makeContainer(
        initialLoadState: const LoadTransactionsState.error(),
      );
      addTearDown(container.dispose);

      container.listen(exportCsvStateProvider, (_, _) {});
      await container.pump();

      container
          .read(loadTransactionsStateProvider.notifier)
          .setState(const LoadTransactionsState.loading());
      await container.pump();

      expect(
        container.read(exportCsvStateProvider),
        isA<ExportCsvStateLoading>(),
      );
    });

    test('listener: Error → ExportCsvState.error with message', () async {
      final container = makeContainer();
      addTearDown(container.dispose);

      container.listen(exportCsvStateProvider, (_, _) {});
      await container.pump();

      container
          .read(loadTransactionsStateProvider.notifier)
          .setState(const LoadTransactionsState.error(errorMsg: 'fail'));
      await container.pump();

      final state = container.read(exportCsvStateProvider);
      expect(state, isA<ExportCsvStateError>());
      expect((state as ExportCsvStateError).errorMsg, 'fail');
    });

    test('listener: Empty when Loading → ExportCsvState.loaded', () async {
      final txList = [TransItem()..tx = (Tx()..txid = 'tx1')];
      final container = makeContainer(
        initialLoadState: const LoadTransactionsState.error(),
        allTxSorted: txList,
      );
      addTearDown(container.dispose);

      container.listen(exportCsvStateProvider, (_, _) {});
      await container.pump();

      container
          .read(loadTransactionsStateProvider.notifier)
          .setState(const LoadTransactionsState.loading());
      await container.pump();
      expect(
        container.read(exportCsvStateProvider),
        isA<ExportCsvStateLoading>(),
      );

      container
          .read(loadTransactionsStateProvider.notifier)
          .setState(const LoadTransactionsState.empty());
      await container.pump();

      final state = container.read(exportCsvStateProvider);
      expect(state, isA<ExportCsvStateLoaded>());
      expect((state as ExportCsvStateLoaded).txs, txList);
    });

    test('listener: Empty when initial → stays empty', () async {
      final container = makeContainer();
      addTearDown(container.dispose);

      container.listen(exportCsvStateProvider, (_, _) {});
      await container.pump();

      container
          .read(loadTransactionsStateProvider.notifier)
          .setState(const LoadTransactionsState.empty());
      await container.pump();

      expect(
        container.read(exportCsvStateProvider),
        isA<ExportCsvStateEmpty>(),
      );
    });
  });
}
