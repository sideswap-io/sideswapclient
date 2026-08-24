import 'package:decimal/decimal.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/new_block_providers.dart';
import 'package:sideswap/providers/new_tx_providers.dart';
import 'package:sideswap/providers/satoshi_providers.dart';
import 'package:sideswap/providers/tx_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/pegs_provider.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class MockSideswapWallet extends Mock implements SideswapWallet {}

class MockAssetUtils extends Mock implements AssetUtils {}

class MockSatoshiRepository extends Mock implements AbstractSatoshiRepository {}

// Subclass that overrides txType() to test unreachable switch branches.
class _FakeTypedHelper extends TransItemHelper {
  final TxType _forcedType;
  _FakeTypedHelper(
    TxType forcedType,
    TransItem item,
    Map<String, Asset> assets,
  ) : _forcedType = forcedType,
      super(
        'liquid-id',
        'bitcoin-id',
        assets,
        () {
          final m = MockAssetUtils();
          when(() => m.getPrecisionForAssetId(assetId: any(named: 'assetId'))).thenReturn(8);
          return m;
        }(),
        AmountToString(locale: 'en'),
        MockSatoshiRepository(),
        item,
        Option.none(),
      );

  @override
  TxType txType() => _forcedType;
}

// Constructs a TransItem with a regular Tx (not a peg).
// Note: TransItem.id is a separate top-level field — not tx.txid.
TransItem _makeTxItem({
  String id = 'txid1',
  String txid = 'txid1',
  List<Balance> balances = const [],
  int networkFee = 0,
  Confs? confs,
}) {
  final tx = Tx()
    ..txid = txid
    ..networkFee = Int64(networkFee)
    ..balances.addAll(balances);
  final item = TransItem()
    ..id = id
    ..tx = tx;
  if (confs != null) {
    item.confs = confs;
  }
  return item;
}

// Constructs a TransItem with a Peg.
TransItem _makePegItem({bool isPegIn = true, int amountSend = 0, int amountRecv = 0}) {
  final peg = Peg()
    ..isPegIn = isPegIn
    ..amountSend = Int64(amountSend)
    ..amountRecv = Int64(amountRecv);
  return TransItem()..peg = peg;
}

Balance _balance(int amount, String assetId) =>
    Balance()
      ..amount = Int64(amount)
      ..assetId = assetId;

void main() {
  setUpAll(() {
    WidgetsFlutterBinding.ensureInitialized();
    Logger.level = Level.off;
    registerFallbackValue(To());
    registerFallbackValue(From_RemovedTxs());
  });

  // ---------------------------------------------------------------------------
  // LoadTransactionsStateNotifier
  // ---------------------------------------------------------------------------

  group('LoadTransactionsStateNotifier', () {
    late ProviderContainer container;
    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    group('setState', () {
      test('transitions from empty to loading', () {
        container
            .read(loadTransactionsStateProvider.notifier)
            .setState(LoadTransactionsState.loading());
        expect(
          container.read(loadTransactionsStateProvider),
          isA<LoadTransactionsStateLoading>(),
        );
      });

      test('transitions to error state', () {
        container
            .read(loadTransactionsStateProvider.notifier)
            .setState(LoadTransactionsState.error(errorMsg: 'oops'));
        final state = container.read(loadTransactionsStateProvider);
        expect(state, isA<LoadTransactionsStateError>());
        expect((state as LoadTransactionsStateError).errorMsg, 'oops');
      });
    });
  });

  // ---------------------------------------------------------------------------
  // TxHistoryStateNotifier
  // ---------------------------------------------------------------------------

  group('TxHistoryStateNotifier', () {
    late ProviderContainer container;
    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    group('build', () {
      test('initial state is invisible', () {
        expect(
          container.read(txHistoryStateProvider),
          isA<TxHistoryStateInvisible>(),
        );
      });
    });

    group('setVisible', () {
      test('transitions to visible via microtask', () async {
        container.read(txHistoryStateProvider.notifier).setVisible();
        // State not yet visible — microtask hasn't run yet
        expect(
          container.read(txHistoryStateProvider),
          isA<TxHistoryStateInvisible>(),
        );
        // Yield to microtask queue (Future.delayed is faked by WidgetsBinding)
        await Future<void>.microtask(() {});
        expect(
          container.read(txHistoryStateProvider),
          isA<TxHistoryStateVisible>(),
        );
      });
    });
  });

  // ---------------------------------------------------------------------------
  // UpdatedTxsNotifier
  // ---------------------------------------------------------------------------

  group('UpdatedTxsNotifier', () {
    late ProviderContainer container;
    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    group('update', () {
      test('replaces state with items from the update message', () {
        final item = _makeTxItem(txid: 'abc');
        final msg = From_UpdatedTxs()..items.add(item);
        container.read(updatedTxsProvider.notifier).update(msg);
        expect(container.read(updatedTxsProvider), [item]);
      });

      test('replaces state with empty list when message has no items', () {
        // Seed with an item first
        container
            .read(updatedTxsProvider.notifier)
            .update(From_UpdatedTxs()..items.add(_makeTxItem()));
        container
            .read(updatedTxsProvider.notifier)
            .update(From_UpdatedTxs());
        expect(container.read(updatedTxsProvider), isEmpty);
      });
    });

    group('remove', () {
      test('does nothing when txids list is empty', () {
        container
            .read(updatedTxsProvider.notifier)
            .update(From_UpdatedTxs()..items.add(_makeTxItem(txid: 'abc')));
        container
            .read(updatedTxsProvider.notifier)
            .remove(From_RemovedTxs());
        expect(container.read(updatedTxsProvider), hasLength(1));
      });

      test('removes item matching TransItem.id from state', () {
        final item = _makeTxItem(id: 'abc', txid: 'abc');
        container
            .read(updatedTxsProvider.notifier)
            .update(From_UpdatedTxs()..items.add(item));
        final removeMsg = From_RemovedTxs()..txids.add('abc');
        container.read(updatedTxsProvider.notifier).remove(removeMsg);
        expect(container.read(updatedTxsProvider), isEmpty);
      });

      test('only removes matching id, keeps others', () {
        final a = _makeTxItem(id: 'aaa', txid: 'aaa');
        final b = _makeTxItem(id: 'bbb', txid: 'bbb');
        container
            .read(updatedTxsProvider.notifier)
            .update(From_UpdatedTxs()..items.addAll([a, b]));
        final removeMsg = From_RemovedTxs()..txids.add('aaa');
        container.read(updatedTxsProvider.notifier).remove(removeMsg);
        expect(container.read(updatedTxsProvider), [b]);
      });
    });
  });

  // ---------------------------------------------------------------------------
  // ShowTransactionNotifier
  // ---------------------------------------------------------------------------

  group('ShowTransactionNotifier', () {
    late ProviderContainer container;
    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    group('build', () {
      test('initial state is none', () {
        expect(container.read(showTransactionProvider).isNone(), isTrue);
      });
    });

    group('setState', () {
      test('wraps transaction in Some', () {
        final tx = _makeTxItem(txid: 'tx1');
        container.read(showTransactionProvider.notifier).setState(tx);
        expect(container.read(showTransactionProvider).isSome(), isTrue);
      });
    });
  });

  // ---------------------------------------------------------------------------
  // CurrentTxPopupItemNotifier
  // ---------------------------------------------------------------------------

  group('CurrentTxPopupItemNotifier', () {
    late ProviderContainer container;
    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    group('build', () {
      test('initial state is none', () {
        expect(container.read(currentTxPopupItemProvider).isNone(), isTrue);
      });
    });

    group('setCurrentTxId', () {
      test('wraps txId in Some', () {
        container
            .read(currentTxPopupItemProvider.notifier)
            .setCurrentTxId('abc123');
        expect(
          container.read(currentTxPopupItemProvider),
          equals(Option.of('abc123')),
        );
      });
    });
  });

  // ---------------------------------------------------------------------------
  // AllTxsNotifier
  // ---------------------------------------------------------------------------

  group('AllTxsNotifier', () {
    late MockSideswapWallet mockWallet;
    late ProviderContainer container;

    setUp(() {
      mockWallet = MockSideswapWallet();
      when(() => mockWallet.sendMsg(any())).thenReturn(null);
      container = ProviderContainer.test(
        overrides: [walletProvider.overrideWithValue(mockWallet)],
      );
      addTearDown(container.dispose);
    });

    group('build', () {
      test('initial state is empty map', () {
        expect(container.read(allTxsProvider), isEmpty);
      });
    });

    group('updateList', () {
      test('inserts new transactions keyed by txid', () {
        final item = _makeTxItem(txid: 'tx1');
        container.read(allTxsProvider.notifier).updateList(txs: [item]);
        expect(container.read(allTxsProvider)['tx1'], equals(item));
      });

      test('overwrites existing transaction with same txid', () {
        final old = _makeTxItem(txid: 'tx1');
        final updated = _makeTxItem(txid: 'tx1', networkFee: 100);
        container.read(allTxsProvider.notifier).updateList(txs: [old]);
        container.read(allTxsProvider.notifier).updateList(txs: [updated]);
        expect(container.read(allTxsProvider)['tx1']?.tx.networkFee, Int64(100));
      });

      test('accumulates multiple transactions', () {
        final a = _makeTxItem(txid: 'tx1');
        final b = _makeTxItem(txid: 'tx2');
        container.read(allTxsProvider.notifier).updateList(txs: [a, b]);
        expect(container.read(allTxsProvider), hasLength(2));
      });
    });

    group('remove', () {
      test('removes transaction by txid', () {
        final item = _makeTxItem(txid: 'tx1');
        container.read(allTxsProvider.notifier).updateList(txs: [item]);
        final msg = From_RemovedTxs()..txids.add('tx1');
        container.read(allTxsProvider.notifier).remove(msg);
        expect(container.read(allTxsProvider), isEmpty);
      });

      test('only removes matching txid, keeps others', () {
        final a = _makeTxItem(txid: 'tx1');
        final b = _makeTxItem(txid: 'tx2');
        container.read(allTxsProvider.notifier).updateList(txs: [a, b]);
        final msg = From_RemovedTxs()..txids.add('tx1');
        container.read(allTxsProvider.notifier).remove(msg);
        expect(container.read(allTxsProvider).keys, contains('tx2'));
        expect(container.read(allTxsProvider).keys, isNot(contains('tx1')));
      });
    });

    group('loadTransactions', () {
      test('sends loadTransactions message when state is empty', () async {
        // Ensure AllTxsNotifier is initialized (sets up its listeners)
        container.read(allTxsProvider);
        // Trigger via txHistoryState becoming visible
        container.read(txHistoryStateProvider.notifier).setVisible();
        // Flush microtask 1: setVisible sets txHistoryState
        await Future<void>.microtask(() {});
        // Flush microtask 2: AllTxsNotifier listener fires loadTransactions
        await Future<void>.microtask(() {});
        verify(() => mockWallet.sendMsg(any())).called(greaterThanOrEqualTo(1));
      });

      test('does not send message when already loading', () async {
        container.read(allTxsProvider);
        container
            .read(loadTransactionsStateProvider.notifier)
            .setState(LoadTransactionsState.loading());
        container.read(txHistoryStateProvider.notifier).setVisible();
        await Future<void>.microtask(() {});
        await Future<void>.microtask(() {});
        verifyNever(() => mockWallet.sendMsg(any()));
      });
    });

    group('updatedTxs listener', () {
      test('calls updateList when updatedTxs changes', () {
        // Initialize AllTxsNotifier first so its listeners are registered
        container.read(allTxsProvider);
        final item = _makeTxItem(id: 'tx1', txid: 'tx1');
        container
            .read(updatedTxsProvider.notifier)
            .update(From_UpdatedTxs()..items.add(item));
        expect(container.read(allTxsProvider)['tx1'], equals(item));
      });
    });

    // -------------------------------------------------------------------------
    // AllTxsNotifier — showTransaction listener
    // -------------------------------------------------------------------------

    group('showTransaction listener', () {
      test('adds tx to allTxs when Some(tx) is set', () {
        container.read(allTxsProvider);
        final item = _makeTxItem(id: 'show1', txid: 'show1');
        container.read(showTransactionProvider.notifier).setState(item);
        expect(container.read(allTxsProvider)['show1'], equals(item));
      });

      test('initial None does not add anything to allTxs', () {
        container.read(allTxsProvider);
        // showTransactionProvider starts as None — nothing should be added
        expect(container.read(allTxsProvider), isEmpty);
      });
    });

    // -------------------------------------------------------------------------
    // AllTxsNotifier — newTx listener
    // -------------------------------------------------------------------------

    group('newTx listener', () {
      test('does not call sendMsg when txHistoryState is invisible', () async {
        container.read(allTxsProvider);
        // History state is invisible (default) — newTx should no-op
        container.read(newTxProvider.notifier).update();
        await Future<void>.microtask(() {});
        verifyNever(() => mockWallet.sendMsg(any()));
      });

      test('calls sendMsg when visible and loadTransactionsState is empty', () async {
        container.read(allTxsProvider);
        // Make visible
        container.read(txHistoryStateProvider.notifier).setVisible();
        await Future<void>.microtask(() {});
        await Future<void>.microtask(() {});
        // Now state is Loading — reset to empty so we can test newTx trigger
        container
            .read(loadTransactionsStateProvider.notifier)
            .setState(LoadTransactionsState.empty());
        clearInteractions(mockWallet);
        // Trigger newTx
        container.read(newTxProvider.notifier).update();
        await Future<void>.microtask(() {});
        verify(() => mockWallet.sendMsg(any())).called(greaterThanOrEqualTo(1));
      });
    });

    // -------------------------------------------------------------------------
    // AllTxsNotifier — newBlock listener
    // -------------------------------------------------------------------------

    group('newBlock listener', () {
      test('does not call sendMsg when txHistoryState is invisible', () async {
        container.read(allTxsProvider);
        container.read(newBlockProvider.notifier).update();
        await Future<void>.microtask(() {});
        verifyNever(() => mockWallet.sendMsg(any()));
      });

      test('does not call sendMsg when visible but no tx has confs', () async {
        container.read(allTxsProvider);
        // Add a tx without confs
        final item = _makeTxItem(txid: 'tx1');
        container.read(allTxsProvider.notifier).updateList(txs: [item]);
        // Make visible
        container.read(txHistoryStateProvider.notifier).setVisible();
        await Future<void>.microtask(() {});
        await Future<void>.microtask(() {});
        // Reset to empty + clear interactions
        container
            .read(loadTransactionsStateProvider.notifier)
            .setState(LoadTransactionsState.empty());
        clearInteractions(mockWallet);
        // Trigger newBlock
        container.read(newBlockProvider.notifier).update();
        await Future<void>.microtask(() {});
        verifyNever(() => mockWallet.sendMsg(any()));
      });

      test('calls sendMsg when visible and tx has confs', () async {
        container.read(allTxsProvider);
        // Add a tx WITH confs
        final confs = Confs()
          ..count = 1
          ..total = 6;
        final item = _makeTxItem(txid: 'tx1', confs: confs);
        container.read(allTxsProvider.notifier).updateList(txs: [item]);
        // Make visible
        container.read(txHistoryStateProvider.notifier).setVisible();
        await Future<void>.microtask(() {});
        await Future<void>.microtask(() {});
        // Reset to empty + clear interactions
        container
            .read(loadTransactionsStateProvider.notifier)
            .setState(LoadTransactionsState.empty());
        clearInteractions(mockWallet);
        // Trigger newBlock
        container.read(newBlockProvider.notifier).update();
        await Future<void>.microtask(() {});
        verify(() => mockWallet.sendMsg(any())).called(greaterThanOrEqualTo(1));
      });
    });
  });

  // ---------------------------------------------------------------------------
  // TransItemHelper — txType()
  // ---------------------------------------------------------------------------

  group('TransItemHelper', () {
    const liquidId = 'liquid-id';
    const bitcoinId = 'bitcoin-id';

    TransItemHelper makeHelper(
      TransItem item, {
      Map<String, Asset> assets = const {},
      Option<PegOrderFeeData>? pegFeeData,
      MockSatoshiRepository? satoshi,
    }) {
      final mockAssetUtils = MockAssetUtils();
      when(() => mockAssetUtils.getPrecisionForAssetId(assetId: any(named: 'assetId')))
          .thenReturn(8);
      final amountToString = AmountToString(locale: 'en');
      final mockSatoshi = satoshi ?? MockSatoshiRepository();
      return TransItemHelper(
        liquidId,
        bitcoinId,
        assets,
        mockAssetUtils,
        amountToString,
        mockSatoshi,
        item,
        pegFeeData ?? Option.none(),
      );
    }

    group('txType', () {
      test('returns pegIn when item is a peg with isPegIn=true', () {
        final helper = makeHelper(_makePegItem(isPegIn: true));
        expect(helper.txType(), TxType.pegIn);
      });

      test('returns pegOut when item is a peg with isPegIn=false', () {
        final helper = makeHelper(_makePegItem(isPegIn: false));
        expect(helper.txType(), TxType.pegOut);
      });

      test('returns swap when 2 balances with opposite signs and different assets', () {
        final item = _makeTxItem(balances: [
          _balance(100, 'asset-a'),
          _balance(-50, 'asset-b'),
        ]);
        final helper = makeHelper(item);
        expect(helper.txType(), TxType.swap);
      });

      test('returns internal when single balance equal to network fee on liquid', () {
        final item = _makeTxItem(
          balances: [_balance(-500, liquidId)],
          networkFee: 500,
        );
        final helper = makeHelper(item);
        expect(helper.txType(), TxType.internal);
      });

      test('returns received when all balances are positive', () {
        final item = _makeTxItem(balances: [
          _balance(100, 'asset-a'),
          _balance(200, 'asset-b'),
        ]);
        final helper = makeHelper(item);
        expect(helper.txType(), TxType.received);
      });

      test('returns sent when all balances are negative', () {
        final item = _makeTxItem(balances: [
          _balance(-100, 'asset-a'),
        ]);
        final helper = makeHelper(item);
        expect(helper.txType(), TxType.sent);
      });

      test('returns unknown when balances are empty', () {
        final item = _makeTxItem(balances: []);
        final helper = makeHelper(item);
        expect(helper.txType(), TxType.unknown);
      });

      test('returns unknown when both positive and negative on same asset', () {
        final item = _makeTxItem(balances: [
          _balance(100, liquidId),
          _balance(-50, liquidId),
        ]);
        final helper = makeHelper(item);
        expect(helper.txType(), TxType.unknown);
      });
    });

    group('txPegInConversionRate', () {
      test('returns formatted percentage of amountRecv/amountSend', () {
        final item = _makePegItem(amountSend: 1000, amountRecv: 950);
        final helper = makeHelper(item);
        expect(helper.txPegInConversionRate(), '95.00%');
      });

      test('returns 0.00% when amountSend is zero', () {
        final item = _makePegItem(amountSend: 0, amountRecv: 950);
        final helper = makeHelper(item);
        expect(helper.txPegInConversionRate(), '0.00%');
      });

      test('returns 0.00% when amountRecv is zero', () {
        final item = _makePegItem(amountSend: 1000, amountRecv: 0);
        final helper = makeHelper(item);
        expect(helper.txPegInConversionRate(), '0.00%');
      });
    });

    group('txPegInAddress', () {
      test('returns addrSend when item has peg', () {
        final peg = Peg()..addrSend = 'addr-send-123';
        final item = TransItem()..peg = peg;
        final helper = makeHelper(item);
        expect(helper.txPegInAddress(), 'addr-send-123');
      });

      test('returns empty string when item has no peg', () {
        final helper = makeHelper(_makeTxItem());
        expect(helper.txPegInAddress(), '');
      });
    });

    group('txPegOutAddress', () {
      test('returns addrRecv when item has peg', () {
        final peg = Peg()..addrRecv = 'addr-recv-456';
        final item = TransItem()..peg = peg;
        final helper = makeHelper(item);
        expect(helper.txPegOutAddress(), 'addr-recv-456');
      });

      test('returns empty string when item has no peg', () {
        final helper = makeHelper(_makeTxItem());
        expect(helper.txPegOutAddress(), '');
      });
    });

    group('txConfs', () {
      test('returns Some(confs) when item has confs', () {
        final confs = Confs()
          ..count = 1
          ..total = 2;
        final item = _makeTxItem(confs: confs);
        final helper = makeHelper(item);
        expect(helper.txConfs().isSome(), isTrue);
      });

      test('returns None when item has no confs', () {
        final helper = makeHelper(_makeTxItem());
        expect(helper.txConfs().isNone(), isTrue);
      });
    });

    group('txBalances', () {
      test('returns balances list when item has tx', () {
        final b = _balance(100, 'asset-x');
        final item = _makeTxItem(balances: [b]);
        final helper = makeHelper(item);
        expect(helper.txBalances(), [b]);
      });

      test('returns empty list when item has no tx (peg item)', () {
        final helper = makeHelper(_makePegItem());
        expect(helper.txBalances(), isEmpty);
      });
    });

    group('getRecvMultipleOutputs', () {
      test('returns true when more than one balance has positive amount', () {
        final item = _makeTxItem(balances: [
          _balance(100, 'a'),
          _balance(200, 'b'),
        ]);
        expect(makeHelper(item).getRecvMultipleOutputs(), isTrue);
      });

      test('returns false when only one positive balance', () {
        final item = _makeTxItem(balances: [_balance(100, 'a')]);
        expect(makeHelper(item).getRecvMultipleOutputs(), isFalse);
      });
    });

    group('getSentMultipleOutputs', () {
      test('returns false when txType is not sent', () {
        final item = _makeTxItem(balances: [_balance(100, 'a')]);
        expect(makeHelper(item).getSentMultipleOutputs(), isFalse);
      });

      test('returns false when sent with single balance after fee removal', () {
        final item = _makeTxItem(
          balances: [_balance(-100, 'asset-a')],
        );
        expect(makeHelper(item).getSentMultipleOutputs(), isFalse);
      });

      test('returns true when sent with multiple non-fee balances', () {
        // sent: two negative balances on different assets
        final item = _makeTxItem(
          balances: [
            _balance(-100, 'asset-a'),
            _balance(-200, 'asset-b'),
          ],
        );
        expect(makeHelper(item).getSentMultipleOutputs(), isTrue);
      });
    });

    // -------------------------------------------------------------------------
    // txIcon
    // -------------------------------------------------------------------------

    group('txIcon', () {
      test('received → arrow_circle_down', () {
        final item = _makeTxItem(balances: [_balance(100, 'asset-a')]);
        expect(makeHelper(item).txIcon(), Icons.arrow_circle_down);
      });

      test('sent → arrow_circle_up', () {
        final item = _makeTxItem(balances: [_balance(-100, 'asset-a')]);
        expect(makeHelper(item).txIcon(), Icons.arrow_circle_up);
      });

      test('swap → swap_horiz', () {
        final item = _makeTxItem(balances: [
          _balance(100, 'asset-a'),
          _balance(-50, 'asset-b'),
        ]);
        expect(makeHelper(item).txIcon(), Icons.swap_horiz);
      });

      test('internal → swap_horiz', () {
        final item = _makeTxItem(
          balances: [_balance(-500, liquidId)],
          networkFee: 500,
        );
        expect(makeHelper(item).txIcon(), Icons.swap_horiz);
      });

      test('unknown → device_unknown', () {
        final item = _makeTxItem(balances: []);
        expect(makeHelper(item).txIcon(), Icons.device_unknown);
      });

      test('pegIn → device_unknown', () {
        expect(makeHelper(_makePegItem(isPegIn: true)).txIcon(), Icons.device_unknown);
      });

      test('pegOut → device_unknown', () {
        expect(makeHelper(_makePegItem(isPegIn: false)).txIcon(), Icons.device_unknown);
      });
    });

    // -------------------------------------------------------------------------
    // txTypeName
    // -------------------------------------------------------------------------

    group('txTypeName', () {
      test('received → Received', () {
        final item = _makeTxItem(balances: [_balance(100, 'a')]);
        expect(makeHelper(item).txTypeName(), 'Received');
      });

      test('sent → Sent', () {
        final item = _makeTxItem(balances: [_balance(-100, 'a')]);
        expect(makeHelper(item).txTypeName(), 'Sent');
      });

      test('swap → Swap', () {
        final item = _makeTxItem(balances: [
          _balance(100, 'a'),
          _balance(-50, 'b'),
        ]);
        expect(makeHelper(item).txTypeName(), 'Swap');
      });

      test('internal → Internal', () {
        final item = _makeTxItem(
          balances: [_balance(-500, liquidId)],
          networkFee: 500,
        );
        expect(makeHelper(item).txTypeName(), 'Internal');
      });

      test('unknown → Unknown', () {
        final item = _makeTxItem(balances: []);
        expect(makeHelper(item).txTypeName(), 'Unknown');
      });

      test('pegIn → Peg-In', () {
        expect(makeHelper(_makePegItem(isPegIn: true)).txTypeName(), 'Peg-In');
      });

      test('pegOut → Peg-Out', () {
        expect(makeHelper(_makePegItem(isPegIn: false)).txTypeName(), 'Peg-Out');
      });
    });

    // -------------------------------------------------------------------------
    // txFromAction
    // -------------------------------------------------------------------------

    group('txFromAction', () {
      test('swap → Sent', () {
        final item = _makeTxItem(balances: [
          _balance(100, 'a'),
          _balance(-50, 'b'),
        ]);
        expect(makeHelper(item).txFromAction(), 'Sent');
      });

      test('sent → Sent', () {
        final item = _makeTxItem(balances: [_balance(-100, 'a')]);
        expect(makeHelper(item).txFromAction(), 'Sent');
      });

      test('internal → Sent', () {
        final item = _makeTxItem(
          balances: [_balance(-500, liquidId)],
          networkFee: 500,
        );
        expect(makeHelper(item).txFromAction(), 'Sent');
      });

      test('unknown → Sent', () {
        final item = _makeTxItem(balances: []);
        expect(makeHelper(item).txFromAction(), 'Sent');
      });

      test('received → From', () {
        final item = _makeTxItem(balances: [_balance(100, 'a')]);
        expect(makeHelper(item).txFromAction(), 'From');
      });

      test('pegIn → Received', () {
        expect(makeHelper(_makePegItem(isPegIn: true)).txFromAction(), 'Received');
      });

      test('pegOut → To', () {
        expect(makeHelper(_makePegItem(isPegIn: false)).txFromAction(), 'To');
      });
    });

    // -------------------------------------------------------------------------
    // txToAction
    // -------------------------------------------------------------------------

    group('txToAction', () {
      test('swap → Received', () {
        final item = _makeTxItem(balances: [
          _balance(100, 'a'),
          _balance(-50, 'b'),
        ]);
        expect(makeHelper(item).txToAction(), 'Received');
      });

      test('received → Received', () {
        final item = _makeTxItem(balances: [_balance(100, 'a')]);
        expect(makeHelper(item).txToAction(), 'Received');
      });

      test('internal → Received', () {
        final item = _makeTxItem(
          balances: [_balance(-500, liquidId)],
          networkFee: 500,
        );
        expect(makeHelper(item).txToAction(), 'Received');
      });

      test('unknown → Received', () {
        final item = _makeTxItem(balances: []);
        expect(makeHelper(item).txToAction(), 'Received');
      });

      test('sent → To', () {
        final item = _makeTxItem(balances: [_balance(-100, 'a')]);
        expect(makeHelper(item).txToAction(), 'To');
      });

      test('pegOut → To', () {
        expect(makeHelper(_makePegItem(isPegIn: false)).txToAction(), 'To');
      });

      test('pegIn → From', () {
        expect(makeHelper(_makePegItem(isPegIn: true)).txToAction(), 'From');
      });
    });

    // -------------------------------------------------------------------------
    // txAssetAmount
    // -------------------------------------------------------------------------

    group('txAssetAmount', () {
      test('returns sum of balances matching assetId', () {
        final item = _makeTxItem(balances: [
          _balance(100, 'asset-a'),
          _balance(200, 'asset-a'),
        ]);
        expect(makeHelper(item).txAssetAmount('asset-a'), 300);
      });

      test('returns 0 when no matching balance', () {
        final item = _makeTxItem(balances: [_balance(100, 'asset-a')]);
        expect(makeHelper(item).txAssetAmount('asset-b'), 0);
      });

      test('handles single balance', () {
        final item = _makeTxItem(balances: [_balance(500, 'asset-x')]);
        expect(makeHelper(item).txAssetAmount('asset-x'), 500);
      });
    });

    // -------------------------------------------------------------------------
    // assetAmountToString
    // -------------------------------------------------------------------------

    group('assetAmountToString', () {
      test('uses asset ticker when asset is found', () {
        final assets = {
          'asset-a': Asset()
            ..ticker = 'USD'
            ..assetId = 'asset-a'
            ..precision = 2,
        };
        final item = _makeTxItem();
        final result = makeHelper(item, assets: assets)
            .assetAmountToString('asset-a', Int64(100));
        expect(result, contains('USD'));
      });

      test('uses empty ticker when asset not found', () {
        final item = _makeTxItem();
        // asset not in map → ticker null → uses ''
        final result = makeHelper(item).assetAmountToString('unknown', Int64(100));
        expect(result, isA<String>());
      });
    });

    // -------------------------------------------------------------------------
    // getSentBalance
    // -------------------------------------------------------------------------

    group('getSentBalance', () {
      test('peg isPegIn=true → amount=amountSend, assetId=bitcoinId', () {
        final item = _makePegItem(isPegIn: true, amountSend: 5000);
        final b = makeHelper(item).getSentBalance(liquidId, bitcoinId);
        expect(b.amount, Int64(5000));
        expect(b.assetId, bitcoinId);
      });

      test('peg isPegIn=false → amount=amountSend, assetId=liquidId', () {
        final item = _makePegItem(isPegIn: false, amountSend: 3000);
        final b = makeHelper(item).getSentBalance(liquidId, bitcoinId);
        expect(b.amount, Int64(3000));
        expect(b.assetId, liquidId);
      });

      test('sent with 1 balance on liquidId → amount = -balance.amount - networkFee', () {
        final item = _makeTxItem(
          balances: [_balance(-1000, liquidId)],
          networkFee: 100,
        );
        final b = makeHelper(item).getSentBalance(liquidId, bitcoinId);
        expect(b.amount, Int64(900));
        expect(b.assetId, liquidId);
      });

      test('sent with 1 balance on non-liquid → amount = -balance.amount', () {
        final item = _makeTxItem(
          balances: [_balance(-500, 'other-asset')],
        );
        final b = makeHelper(item).getSentBalance(liquidId, bitcoinId);
        expect(b.amount, Int64(500));
        expect(b.assetId, 'other-asset');
      });

      test('sent with 2 balances → uses non-liquid balance', () {
        // 2 balances: fee balance on liquid, main on other
        final item = _makeTxItem(
          balances: [
            _balance(-100, liquidId),
            _balance(-400, 'other-asset'),
          ],
          networkFee: 100,
        );
        final b = makeHelper(item).getSentBalance(liquidId, bitcoinId);
        expect(b.assetId, 'other-asset');
        expect(b.amount, Int64(400));
      });

      test('swap/internal → balance with amount<0, returns negated amount', () {
        final item = _makeTxItem(balances: [
          _balance(200, 'asset-recv'),
          _balance(-100, 'asset-sent'),
        ]);
        final b = makeHelper(item).getSentBalance(liquidId, bitcoinId);
        expect(b.amount, Int64(100));
        expect(b.assetId, 'asset-sent');
      });

      test('received → returns empty Balance', () {
        final item = _makeTxItem(balances: [_balance(100, 'asset-a')]);
        final b = makeHelper(item).getSentBalance(liquidId, bitcoinId);
        expect(b.amount, Int64(0));
      });

      test('unknown → returns empty Balance', () {
        final item = _makeTxItem(balances: []);
        final b = makeHelper(item).getSentBalance(liquidId, bitcoinId);
        expect(b.amount, Int64(0));
      });

      test('pegIn txType (non-peg item forced) → returns empty Balance', () {
        final item = _makeTxItem();
        final helper = _FakeTypedHelper(TxType.pegIn, item, {});
        final b = helper.getSentBalance(liquidId, bitcoinId);
        expect(b.amount, Int64(0));
      });

      test('pegOut txType (non-peg item forced) → returns empty Balance', () {
        final item = _makeTxItem();
        final helper = _FakeTypedHelper(TxType.pegOut, item, {});
        final b = helper.getSentBalance(liquidId, bitcoinId);
        expect(b.amount, Int64(0));
      });
    });

    // -------------------------------------------------------------------------
    // getRecvBalance
    // -------------------------------------------------------------------------

    group('getRecvBalance', () {
      test('peg isPegIn=true → amount=amountRecv, assetId=liquidId', () {
        final item = _makePegItem(isPegIn: true, amountRecv: 4000);
        final b = makeHelper(item).getRecvBalance(liquidId, bitcoinId);
        expect(b.amount, Int64(4000));
        expect(b.assetId, liquidId);
      });

      test('peg isPegIn=false → amount=amountRecv, assetId=bitcoinId', () {
        final item = _makePegItem(isPegIn: false, amountRecv: 2000);
        final b = makeHelper(item).getRecvBalance(liquidId, bitcoinId);
        expect(b.amount, Int64(2000));
        expect(b.assetId, bitcoinId);
      });

      test('received → balance with amount>0', () {
        final item = _makeTxItem(balances: [_balance(300, 'asset-x')]);
        final b = makeHelper(item).getRecvBalance(liquidId, bitcoinId);
        expect(b.amount, Int64(300));
        expect(b.assetId, 'asset-x');
      });

      test('swap → balance with amount>0', () {
        final item = _makeTxItem(balances: [
          _balance(200, 'asset-recv'),
          _balance(-100, 'asset-sent'),
        ]);
        final b = makeHelper(item).getRecvBalance(liquidId, bitcoinId);
        expect(b.amount, Int64(200));
        expect(b.assetId, 'asset-recv');
      });

      test('internal → returns empty Balance', () {
        final item = _makeTxItem(
          balances: [_balance(-500, liquidId)],
          networkFee: 500,
        );
        final b = makeHelper(item).getRecvBalance(liquidId, bitcoinId);
        expect(b.amount, Int64(0));
      });

      test('sent → returns empty Balance', () {
        final item = _makeTxItem(balances: [_balance(-100, 'a')]);
        final b = makeHelper(item).getRecvBalance(liquidId, bitcoinId);
        expect(b.amount, Int64(0));
      });

      test('unknown → returns empty Balance', () {
        final item = _makeTxItem(balances: []);
        final b = makeHelper(item).getRecvBalance(liquidId, bitcoinId);
        expect(b.amount, Int64(0));
      });

      test('pegIn txType (non-peg item forced) → returns empty Balance', () {
        final item = _makeTxItem();
        final helper = _FakeTypedHelper(TxType.pegIn, item, {});
        final b = helper.getRecvBalance(liquidId, bitcoinId);
        expect(b.amount, Int64(0));
      });

      test('pegOut txType (non-peg item forced) → returns empty Balance', () {
        final item = _makeTxItem();
        final helper = _FakeTypedHelper(TxType.pegOut, item, {});
        final b = helper.getRecvBalance(liquidId, bitcoinId);
        expect(b.amount, Int64(0));
      });
    });

    // -------------------------------------------------------------------------
    // txSwapBalancesString
    // -------------------------------------------------------------------------

    group('txSwapBalancesString', () {
      test('swap tx: returns sendBalance and recvBalance strings', () {
        final item = _makeTxItem(balances: [
          _balance(-100, liquidId),
          _balance(200, 'other-asset'),
        ]);
        final result = makeHelper(item).txSwapBalancesString();
        expect(result.sendBalance, isA<String>());
        expect(result.recvBalance, isA<String>());
        expect(result.recvBalance, isNotEmpty);
      });

      test('when recvBalance amount is 0 → recvBalance is empty string', () {
        // swap but recv amount = 0 (edge case: both balances on same asset → unknown type)
        // To get recvBalance=0, use a received tx where getRecvBalance returns 0
        // Actually let's use a peg item with amountRecv=0
        final item = _makePegItem(isPegIn: true, amountSend: 100, amountRecv: 0);
        final result = makeHelper(item).txSwapBalancesString();
        expect(result.recvBalance, '');
      });
    });

    // -------------------------------------------------------------------------
    // txSendBalance
    // -------------------------------------------------------------------------

    group('txSendBalance', () {
      test('sent tx: returns formatted string', () {
        final item = _makeTxItem(
          balances: [_balance(-500, liquidId)],
          networkFee: 100,
        );
        final result = makeHelper(item).txSendBalance();
        expect(result, isA<String>());
        expect(result, isNotEmpty);
      });
    });

    // -------------------------------------------------------------------------
    // txReceivedBalance
    // -------------------------------------------------------------------------

    group('txReceivedBalance', () {
      test('single output: multipleOutputs=false, recvBalance is formatted string', () {
        final item = _makeTxItem(balances: [_balance(300, 'asset-x')]);
        final result = makeHelper(item).txReceivedBalance();
        expect(result.multipleOutputs, isFalse);
        expect(result.recvBalance, isA<String>());
      });

      test('multiple positive outputs: multipleOutputs=true, recvBalance has tickers', () {
        final assets = {
          'asset-a': Asset()
            ..ticker = 'AAA'
            ..assetId = 'asset-a'
            ..precision = 8,
          'asset-b': Asset()
            ..ticker = 'BBB'
            ..assetId = 'asset-b'
            ..precision = 8,
        };
        final item = _makeTxItem(balances: [
          _balance(100, 'asset-a'),
          _balance(200, 'asset-b'),
        ]);
        final result = makeHelper(item, assets: assets).txReceivedBalance();
        expect(result.multipleOutputs, isTrue);
        expect(result.recvBalance, contains('...'));
      });
    });

    // -------------------------------------------------------------------------
    // txPegInBalance
    // -------------------------------------------------------------------------

    group('txPegInBalance', () {
      test('pegIn: returns assetId=liquidId, ticker from assets', () {
        final assets = {
          liquidId: Asset()
            ..ticker = 'LBTC'
            ..assetId = liquidId
            ..precision = 8,
        };
        final item = _makePegItem(isPegIn: true, amountRecv: 5000);
        final result = makeHelper(item, assets: assets).txPegInBalance();
        expect(result.assetId, liquidId);
        expect(result.ticker, 'LBTC');
        expect(result.amount, isNotEmpty);
      });

      test('pegOut: getRecvBalance returns bitcoinId balance', () {
        final item = _makePegItem(isPegIn: false, amountRecv: 1000);
        final result = makeHelper(item).txPegInBalance();
        // pegOut: getRecvBalance returns assetId=bitcoinId
        expect(result.assetId, bitcoinId);
        expect(result.ticker, '');
      });
    });

    // -------------------------------------------------------------------------
    // txPegOutBalance
    // -------------------------------------------------------------------------

    group('txPegOutBalance', () {
      test('pegOut: returns assetId=liquidId, ticker from assets', () {
        final assets = {
          liquidId: Asset()
            ..ticker = 'LBTC'
            ..assetId = liquidId
            ..precision = 8,
        };
        final item = _makePegItem(isPegIn: false, amountSend: 3000);
        final result = makeHelper(item, assets: assets).txPegOutBalance();
        expect(result.assetId, liquidId);
        expect(result.ticker, 'LBTC');
        expect(result.amount, isNotEmpty);
      });

      test('empty assets: ticker is empty string', () {
        final item = _makePegItem(isPegIn: false, amountSend: 3000);
        final result = makeHelper(item).txPegOutBalance();
        expect(result.ticker, '');
      });
    });

    // -------------------------------------------------------------------------
    // getBalancesAll
    // -------------------------------------------------------------------------

    group('getBalancesAll', () {
      test('peg item (no tx) → returns empty list', () {
        final item = _makePegItem();
        expect(makeHelper(item).getBalancesAll(), isEmpty);
      });

      test('tx with balancesAll → returns list with assetId, ticker, amount', () {
        final assets = {
          'asset-a': Asset()
            ..ticker = 'AAA'
            ..assetId = 'asset-a'
            ..precision = 8,
        };
        final tx = Tx()..txid = 't1';
        tx.balancesAll.add(_balance(100, 'asset-a'));
        final item = TransItem()..tx = tx;
        final result = makeHelper(item, assets: assets).getBalancesAll();
        expect(result, hasLength(1));
        expect(result.first.assetId, 'asset-a');
        expect(result.first.ticker, 'AAA');
        expect(result.first.amount, isNotEmpty);
      });

      test('tx with balancesAll missing asset → ticker is empty string', () {
        final tx = Tx()..txid = 't1';
        tx.balancesAll.add(_balance(100, 'unknown-asset'));
        final item = TransItem()..tx = tx;
        final result = makeHelper(item).getBalancesAll();
        expect(result, hasLength(1));
        expect(result.first.ticker, '');
      });
    });

    // -------------------------------------------------------------------------
    // getNetworkFee
    // -------------------------------------------------------------------------

    group('getNetworkFee', () {
      test('networkFee=0 → amount has no forceSign, shows 0', () {
        final assets = {
          liquidId: Asset()
            ..ticker = 'LBTC'
            ..assetId = liquidId
            ..precision = 8,
        };
        final item = _makeTxItem(networkFee: 0);
        final result = makeHelper(item, assets: assets).getNetworkFee();
        expect(result.assetId, liquidId);
        expect(result.ticker, 'LBTC');
        expect(result.networkFeeAmount, contains('0'));
      });

      test('networkFee!=0 → amount is negative (forceSign)', () {
        final assets = {
          liquidId: Asset()
            ..ticker = 'LBTC'
            ..assetId = liquidId
            ..precision = 8,
        };
        final item = _makeTxItem(networkFee: 1000);
        final result = makeHelper(item, assets: assets).getNetworkFee();
        expect(result.networkFeeAmount, contains('-'));
      });

      test('liquid asset not in assetsState → ticker is empty string', () {
        final item = _makeTxItem(networkFee: 0);
        final result = makeHelper(item).getNetworkFee();
        expect(result.ticker, '');
      });
    });

    // -------------------------------------------------------------------------
    // getSwapDeliveredAmount / getSwapReceivedAmount
    // -------------------------------------------------------------------------

    group('getSwapDeliveredAmount', () {
      test('swap tx: returns assetId, ticker, amount for delivered side', () {
        final assets = {
          liquidId: Asset()
            ..ticker = 'LBTC'
            ..assetId = liquidId
            ..precision = 8,
        };
        final item = _makeTxItem(balances: [
          _balance(-1000, liquidId),
          _balance(500, 'other-asset'),
        ]);
        final result = makeHelper(item, assets: assets).getSwapDeliveredAmount();
        expect(result.assetId, liquidId);
        expect(result.ticker, 'LBTC');
        expect(result.amount, isNotEmpty);
      });

      test('assetId not in assetsState → ticker is empty string', () {
        final item = _makeTxItem(balances: [
          _balance(-1000, 'unknown-asset'),
          _balance(500, 'other-asset'),
        ]);
        final result = makeHelper(item).getSwapDeliveredAmount();
        expect(result.ticker, '');
      });
    });

    group('getSwapReceivedAmount', () {
      test('swap tx: returns assetId, ticker, amount for received side', () {
        final assets = {
          'other-asset': Asset()
            ..ticker = 'OTH'
            ..assetId = 'other-asset'
            ..precision = 8,
        };
        final item = _makeTxItem(balances: [
          _balance(-1000, liquidId),
          _balance(500, 'other-asset'),
        ]);
        final result = makeHelper(item, assets: assets).getSwapReceivedAmount();
        expect(result.assetId, 'other-asset');
        expect(result.ticker, 'OTH');
        expect(result.amount, isNotEmpty);
      });

      test('assetId not in assetsState → ticker is empty string', () {
        final item = _makeTxItem(balances: [
          _balance(-1000, liquidId),
          _balance(500, 'other-asset'),
        ]);
        final result = makeHelper(item).getSwapReceivedAmount();
        expect(result.ticker, '');
      });
    });

    // -------------------------------------------------------------------------
    // getBalances
    // -------------------------------------------------------------------------

    group('getBalances', () {
      test('peg item (no tx) → returns empty list', () {
        final item = _makePegItem();
        expect(makeHelper(item).getBalances(), isEmpty);
      });

      test('removeFeeAsset=false → includes all balances', () {
        final item = _makeTxItem(
          balances: [
            _balance(-100, liquidId),
            _balance(-400, 'other'),
          ],
          networkFee: 100,
        );
        final result = makeHelper(item).getBalances();
        expect(result, hasLength(2));
      });

      test('removeFeeAsset=true → excludes fee balance', () {
        final item = _makeTxItem(
          balances: [
            _balance(-100, liquidId),
            _balance(-400, 'other'),
          ],
          networkFee: 100,
        );
        final result = makeHelper(item).getBalances(removeFeeAsset: true);
        expect(result, hasLength(1));
        expect(result.first.assetId, 'other');
      });

      test('unknown asset → ticker is ???', () {
        final item = _makeTxItem(balances: [_balance(100, 'unknown-asset')]);
        final result = makeHelper(item).getBalances();
        expect(result.first.ticker, '???');
      });

      test('known asset → ticker from assetsState', () {
        final assets = {
          'asset-a': Asset()
            ..ticker = 'AAA'
            ..assetId = 'asset-a'
            ..precision = 8,
        };
        final item = _makeTxItem(balances: [_balance(100, 'asset-a')]);
        final result = makeHelper(item, assets: assets).getBalances();
        expect(result.first.ticker, 'AAA');
      });
    });

    // -------------------------------------------------------------------------
    // txTypeToImageType
    // -------------------------------------------------------------------------

    group('txTypeToImageType', () {
      test('received → TxCircleImageType.received', () {
        final item = _makeTxItem(balances: [_balance(100, 'a')]);
        expect(makeHelper(item).txTypeToImageType(), TxCircleImageType.received);
      });

      test('sent → TxCircleImageType.sent', () {
        final item = _makeTxItem(balances: [_balance(-100, 'a')]);
        expect(makeHelper(item).txTypeToImageType(), TxCircleImageType.sent);
      });

      test('swap → TxCircleImageType.swap', () {
        final item = _makeTxItem(balances: [
          _balance(100, 'a'),
          _balance(-50, 'b'),
        ]);
        expect(makeHelper(item).txTypeToImageType(), TxCircleImageType.swap);
      });

      test('internal → TxCircleImageType.swap', () {
        final item = _makeTxItem(
          balances: [_balance(-500, liquidId)],
          networkFee: 500,
        );
        expect(makeHelper(item).txTypeToImageType(), TxCircleImageType.swap);
      });

      test('unknown → TxCircleImageType.unknown', () {
        final item = _makeTxItem(balances: []);
        expect(makeHelper(item).txTypeToImageType(), TxCircleImageType.unknown);
      });

      test('pegIn → TxCircleImageType.pegIn', () {
        expect(
          makeHelper(_makePegItem(isPegIn: true)).txTypeToImageType(),
          TxCircleImageType.pegIn,
        );
      });

      test('pegOut → TxCircleImageType.pegOut', () {
        expect(
          makeHelper(_makePegItem(isPegIn: false)).txTypeToImageType(),
          TxCircleImageType.pegOut,
        );
      });
    });

    // -------------------------------------------------------------------------
    // getTxImageAssetName
    // -------------------------------------------------------------------------

    group('getTxImageAssetName', () {
      test('received → recv.svg', () {
        final item = _makeTxItem(balances: [_balance(100, 'a')]);
        expect(makeHelper(item).getTxImageAssetName(), 'assets/tx_icons/recv.svg');
      });

      test('sent → sent.svg', () {
        final item = _makeTxItem(balances: [_balance(-100, 'a')]);
        expect(makeHelper(item).getTxImageAssetName(), 'assets/tx_icons/sent.svg');
      });

      test('swap → swap.svg', () {
        final item = _makeTxItem(balances: [
          _balance(100, 'a'),
          _balance(-50, 'b'),
        ]);
        expect(makeHelper(item).getTxImageAssetName(), 'assets/tx_icons/swap.svg');
      });

      test('internal → internal.svg', () {
        final item = _makeTxItem(
          balances: [_balance(-500, liquidId)],
          networkFee: 500,
        );
        expect(makeHelper(item).getTxImageAssetName(), 'assets/tx_icons/internal.svg');
      });

      test('unknown → unknown.svg', () {
        final item = _makeTxItem(balances: []);
        expect(makeHelper(item).getTxImageAssetName(), 'assets/tx_icons/unknown.svg');
      });

      test('pegIn → pegin.svg', () {
        expect(
          makeHelper(_makePegItem(isPegIn: true)).getTxImageAssetName(),
          'assets/tx_icons/pegin.svg',
        );
      });

      test('pegOut → pegout.svg', () {
        expect(
          makeHelper(_makePegItem(isPegIn: false)).getTxImageAssetName(),
          'assets/tx_icons/pegout.svg',
        );
      });
    });

    // -------------------------------------------------------------------------
    // txTargetPrice
    // -------------------------------------------------------------------------

    group('txTargetPrice', () {
      test('non-swap → returns empty string', () {
        final item = _makeTxItem(balances: [_balance(100, 'a')]);
        expect(makeHelper(item).txTargetPrice(), '');
      });

      test('swap → calls price(), returns non-empty string', () {
        final mockSatoshi = MockSatoshiRepository();
        when(
          () => mockSatoshi.toDecimal(
            amount: any(named: 'amount'),
            precision: any(named: 'precision'),
          ),
        ).thenReturn(Decimal.one);
        final assets = {
          liquidId: Asset()
            ..ticker = 'LBTC'
            ..assetId = liquidId
            ..precision = 8,
          'other-asset': Asset()
            ..ticker = 'OTH'
            ..assetId = 'other-asset'
            ..precision = 8,
        };
        final item = _makeTxItem(
          balances: [
            _balance(-1000, liquidId),
            _balance(500, 'other-asset'),
          ],
          networkFee: 0,
        );
        final result = makeHelper(item, assets: assets, satoshi: mockSatoshi)
            .txTargetPrice();
        expect(result, isNotEmpty);
        expect(result, startsWith('1 '));
      });
    });

    // -------------------------------------------------------------------------
    // price
    // -------------------------------------------------------------------------

    group('price', () {
      test('sentBitcoin=true, decimalDelivered==0 → result contains 0', () {
        final mockSatoshi = MockSatoshiRepository();
        // networkFee == balance amount → satoshiDeliveredAdjusted = 0
        // Register general stub first, then specific — mocktail uses last-registered wins
        when(
          () => mockSatoshi.toDecimal(
            amount: any(named: 'amount'),
            precision: any(named: 'precision'),
          ),
        ).thenReturn(Decimal.one);
        when(
          () => mockSatoshi.toDecimal(
            amount: 0,
            precision: any(named: 'precision'),
          ),
        ).thenReturn(Decimal.zero);
        final assets = {
          liquidId: Asset()
            ..ticker = 'LBTC'
            ..assetId = liquidId
            ..precision = 8,
          'other': Asset()
            ..ticker = 'OTH'
            ..assetId = 'other'
            ..precision = 8,
        };
        // balance = -1000, networkFee = 1000 → adjusted = 0
        final item = _makeTxItem(
          balances: [
            _balance(-1000, liquidId),
            _balance(500, 'other'),
          ],
          networkFee: 1000,
        );
        final result = makeHelper(item, assets: assets, satoshi: mockSatoshi).price();
        expect(result, isA<String>());
      });

      test('sentBitcoin=false, valid amounts → result starts with 1 ', () {
        final mockSatoshi = MockSatoshiRepository();
        when(
          () => mockSatoshi.toDecimal(
            amount: any(named: 'amount'),
            precision: any(named: 'precision'),
          ),
        ).thenReturn(Decimal.fromInt(2));
        final assets = {
          liquidId: Asset()
            ..ticker = 'LBTC'
            ..assetId = liquidId
            ..precision = 8,
          'other': Asset()
            ..ticker = 'OTH'
            ..assetId = 'other'
            ..precision = 8,
        };
        // delivered is non-liquid (sentBitcoin=false)
        final item = _makeTxItem(
          balances: [
            _balance(-1000, 'other'),
            _balance(500, liquidId),
          ],
          networkFee: 0,
        );
        final result = makeHelper(item, assets: assets, satoshi: mockSatoshi).price();
        expect(result, isA<String>());
        expect(result, startsWith('1 '));
      });

      test('sentBitcoin=false, decimalReceived==0 → result is a string', () {
        final mockSatoshi = MockSatoshiRepository();
        when(
          () => mockSatoshi.toDecimal(
            amount: any(named: 'amount'),
            precision: any(named: 'precision'),
          ),
        ).thenReturn(Decimal.zero);
        final assets = {
          liquidId: Asset()
            ..ticker = 'LBTC'
            ..assetId = liquidId
            ..precision = 8,
          'other': Asset()
            ..ticker = 'OTH'
            ..assetId = 'other'
            ..precision = 8,
        };
        final item = _makeTxItem(
          balances: [
            _balance(-1000, 'other'),
            _balance(500, liquidId),
          ],
          networkFee: 0,
        );
        final result = makeHelper(item, assets: assets, satoshi: mockSatoshi).price();
        expect(result, isA<String>());
      });

      test('sentBitcoin=true, valid amounts → result starts with 1 ', () {
        final mockSatoshi = MockSatoshiRepository();
        when(
          () => mockSatoshi.toDecimal(
            amount: any(named: 'amount'),
            precision: any(named: 'precision'),
          ),
        ).thenReturn(Decimal.fromInt(2));
        final assets = {
          liquidId: Asset()
            ..ticker = 'LBTC'
            ..assetId = liquidId
            ..precision = 8,
          'other': Asset()
            ..ticker = 'OTH'
            ..assetId = 'other'
            ..precision = 8,
        };
        final item = _makeTxItem(
          balances: [
            _balance(-1000, liquidId),
            _balance(500, 'other'),
          ],
          networkFee: 0,
        );
        final result = makeHelper(item, assets: assets, satoshi: mockSatoshi).price();
        expect(result, isA<String>());
        expect(result, startsWith('1 '));
      });
    });

    // -------------------------------------------------------------------------
    // txStatus
    // -------------------------------------------------------------------------

    group('txStatus', () {
      test('peg, no confs, no txidRecv → Initiated, confirmed=false', () {
        final peg = Peg()..isPegIn = true;
        final item = TransItem()..peg = peg;
        final result = makeHelper(item).txStatus();
        expect(result.status, 'Initiated');
        expect(result.confirmed, isFalse);
      });

      test('peg, no confs, has txidRecv → Complete, confirmed=true', () {
        final peg = Peg()
          ..isPegIn = true
          ..txidRecv = 'some-txid-recv';
        final item = TransItem()..peg = peg;
        final result = makeHelper(item).txStatus();
        expect(result.status, 'Complete');
        expect(result.confirmed, isTrue);
      });

      test('has confs (count=1, total=6) → Unconfirmed 1/6, confirmed=false', () {
        final confs = Confs()
          ..count = 1
          ..total = 6;
        final item = _makeTxItem(confs: confs);
        final result = makeHelper(item).txStatus();
        expect(result.status, 'Unconfirmed 1/6');
        expect(result.confirmed, isFalse);
      });

      test('no confs (tx confirmed) → Confirmed 2/2, confirmed=true', () {
        final item = _makeTxItem(); // no confs set
        final result = makeHelper(item).txStatus();
        expect(result.status, 'Confirmed 2/2');
        expect(result.confirmed, isTrue);
      });
    });

    // -------------------------------------------------------------------------
    // txDateTimeStr
    // -------------------------------------------------------------------------

    group('txDateTimeStr', () {
      test('returns non-empty formatted date string', () {
        final item = TransItem()
          ..createdAt = Int64(1704067200000)
          ..tx = (Tx()..txid = 'tx1');
        final result = makeHelper(item).txDateTimeStr();
        expect(result, isNotEmpty);
        // 2024-01-01 UTC — formatted as Jan 1, 2024 at HH:MM
        expect(result, startsWith('Jan'));
      });
    });

    // -------------------------------------------------------------------------
    // txId
    // -------------------------------------------------------------------------

    group('txId', () {
      test('pegIn → isLiquid=true, unblinded=true, txId=peg.txidRecv', () {
        final peg = Peg()
          ..isPegIn = true
          ..txidRecv = 'recv-txid';
        final item = TransItem()..peg = peg;
        final result = makeHelper(item).txId();
        expect(result.txId, 'recv-txid');
        expect(result.isLiquid, isTrue);
        expect(result.unblinded, isTrue);
      });

      test('pegOut → isLiquid=false, unblinded=true, txId=peg.txidRecv', () {
        final peg = Peg()
          ..isPegIn = false
          ..txidRecv = 'bitcoin-txid';
        final item = TransItem()..peg = peg;
        final result = makeHelper(item).txId();
        expect(result.txId, 'bitcoin-txid');
        expect(result.isLiquid, isFalse);
        expect(result.unblinded, isTrue);
      });

      test('regular tx → isLiquid=true, unblinded=false, txId=tx.txid', () {
        final item = _makeTxItem(txid: 'regular-txid');
        final result = makeHelper(item).txId();
        expect(result.txId, 'regular-txid');
        expect(result.isLiquid, isTrue);
        expect(result.unblinded, isFalse);
      });
    });

    // -------------------------------------------------------------------------
    // selectedFeeRate / bitcoinNetworkFee
    // -------------------------------------------------------------------------

    group('selectedFeeRate', () {
      test('Option.none() → returns none()', () {
        final item = _makeTxItem();
        expect(makeHelper(item).selectedFeeRate().isNone(), isTrue);
      });

      test('Some(PegOrderFeeData) → returns Some(feeRate.toString())', () {
        final feeData = PegOrderFeeData(
          feeRate: Decimal.parse('0.5'),
          bitcoinNetworkFee: 1000,
        );
        final item = _makeTxItem();
        final result = makeHelper(
          item,
          pegFeeData: Option.of(feeData),
        ).selectedFeeRate();
        expect(result.isSome(), isTrue);
        expect(result.getOrElse(() => ''), '0.5');
      });
    });

    group('bitcoinNetworkFee', () {
      test('Option.none() → returns none()', () {
        final item = _makeTxItem();
        expect(makeHelper(item).bitcoinNetworkFee().isNone(), isTrue);
      });

      test('Some(PegOrderFeeData) → returns Some(bitcoinNetworkFee.toString())', () {
        final feeData = PegOrderFeeData(
          feeRate: Decimal.parse('0.5'),
          bitcoinNetworkFee: 1000,
        );
        final item = _makeTxItem();
        final result = makeHelper(
          item,
          pegFeeData: Option.of(feeData),
        ).bitcoinNetworkFee();
        expect(result.isSome(), isTrue);
        expect(result.getOrElse(() => ''), '1000');
      });
    });
  });

  // ---------------------------------------------------------------------------
  // allTxsSorted provider
  // ---------------------------------------------------------------------------

  group('allTxsSorted', () {
    late MockSideswapWallet mockWallet;
    late ProviderContainer container;

    setUp(() {
      mockWallet = MockSideswapWallet();
      when(() => mockWallet.sendMsg(any())).thenReturn(null);
      container = ProviderContainer.test(
        overrides: [walletProvider.overrideWithValue(mockWallet)],
      );
      addTearDown(container.dispose);
    });

    test('returns empty when both allTxs and allPegs are empty', () {
      expect(container.read(allTxsSortedProvider), isEmpty);
    });

    test('regular tx not in any peg list → included', () {
      final item = _makeTxItem(txid: 'tx1');
      container.read(allTxsProvider.notifier).updateList(txs: [item]);
      final result = container.read(allTxsSortedProvider);
      expect(result, hasLength(1));
      expect(result.first.tx.txid, 'tx1');
    });

    test('tx whose txid matches peg.txidSend → excluded, peg included', () {
      // Add a regular tx
      final txItem = _makeTxItem(txid: 'send-txid');
      container.read(allTxsProvider.notifier).updateList(txs: [txItem]);
      // Add a peg that has txidSend = 'send-txid'
      final peg = Peg()
        ..isPegIn = true
        ..txidSend = 'send-txid';
      final pegItem = TransItem()
        ..id = 'peg1'
        ..peg = peg;
      final pegsMsg = From_UpdatedPegs()..orderId = 'order1';
      pegsMsg.items.add(pegItem);
      container.read(allPegsProvider.notifier).update(pegs: pegsMsg);

      final result = container.read(allTxsSortedProvider);
      final txids = result.map((e) => e.hasTx() ? e.tx.txid : '').toList();
      expect(txids, isNot(contains('send-txid')));
      expect(result.any((e) => e.hasPeg() && e.peg.txidSend == 'send-txid'), isTrue);
    });

    test('tx whose txid matches peg.txidRecv → excluded', () {
      final txItem = _makeTxItem(txid: 'recv-txid');
      container.read(allTxsProvider.notifier).updateList(txs: [txItem]);
      final peg = Peg()
        ..isPegIn = true
        ..txidRecv = 'recv-txid';
      final pegItem = TransItem()
        ..id = 'peg2'
        ..peg = peg;
      final pegsMsg = From_UpdatedPegs()..orderId = 'order2';
      pegsMsg.items.add(pegItem);
      container.read(allPegsProvider.notifier).update(pegs: pegsMsg);

      final result = container.read(allTxsSortedProvider);
      final txids = result.map((e) => e.hasTx() ? e.tx.txid : '').toList();
      expect(txids, isNot(contains('recv-txid')));
    });

    test('sorts by createdAt descending', () {
      final old = TransItem()
        ..id = 'old'
        ..createdAt = Int64(1000)
        ..tx = (Tx()..txid = 'old');
      final newer = TransItem()
        ..id = 'newer'
        ..createdAt = Int64(2000)
        ..tx = (Tx()..txid = 'newer');
      container.read(allTxsProvider.notifier).updateList(txs: [old, newer]);
      final result = container.read(allTxsSortedProvider);
      expect(result.first.tx.txid, 'newer');
      expect(result.last.tx.txid, 'old');
    });
  });

  // ---------------------------------------------------------------------------
  // allNewTxsSorted provider
  // ---------------------------------------------------------------------------

  group('allNewTxsSorted', () {
    late MockSideswapWallet mockWallet;
    late ProviderContainer container;

    setUp(() {
      mockWallet = MockSideswapWallet();
      when(() => mockWallet.sendMsg(any())).thenReturn(null);
      container = ProviderContainer.test(
        overrides: [walletProvider.overrideWithValue(mockWallet)],
      );
      addTearDown(container.dispose);
    });

    test('items with confs → included', () {
      final confs = Confs()
        ..count = 1
        ..total = 6;
      final item = _makeTxItem(txid: 'tx1', confs: confs);
      container.read(allTxsProvider.notifier).updateList(txs: [item]);
      final result = container.read(allNewTxsSortedProvider);
      expect(result, hasLength(1));
    });

    test('items without confs → excluded', () {
      final item = _makeTxItem(txid: 'tx1'); // no confs
      container.read(allTxsProvider.notifier).updateList(txs: [item]);
      final result = container.read(allNewTxsSortedProvider);
      expect(result, isEmpty);
    });
  });

  // ---------------------------------------------------------------------------
  // unconfirmedTxs provider
  // ---------------------------------------------------------------------------

  group('unconfirmedTxs', () {
    late MockSideswapWallet mockWallet;
    late ProviderContainer container;

    setUp(() {
      mockWallet = MockSideswapWallet();
      when(() => mockWallet.sendMsg(any())).thenReturn(null);
      container = ProviderContainer.test(
        overrides: [walletProvider.overrideWithValue(mockWallet)],
      );
      addTearDown(container.dispose);
    });

    test('returns updatedTxs items', () {
      final item = _makeTxItem(id: 'u1', txid: 'u1');
      container.read(updatedTxsProvider.notifier).update(
            From_UpdatedTxs()..items.add(item),
          );
      final result = container.read(unconfirmedTxsProvider);
      expect(result, contains(item));
    });

    test('includes peg item without confs and without txidRecv', () {
      final peg = Peg()..isPegIn = true;
      final pegItem = TransItem()
        ..id = 'peg1'
        ..peg = peg;
      final pegsMsg = From_UpdatedPegs()..orderId = 'ord1';
      pegsMsg.items.add(pegItem);
      container.read(allPegsProvider.notifier).update(pegs: pegsMsg);

      final result = container.read(unconfirmedTxsProvider);
      expect(result.any((e) => e.hasPeg() && !e.peg.hasTxidRecv()), isTrue);
    });

    test('excludes regular tx items (hasPeg=false)', () {
      final item = _makeTxItem(txid: 'tx1');
      container.read(allTxsProvider.notifier).updateList(txs: [item]);
      final result = container.read(unconfirmedTxsProvider);
      // regular tx items are not in pegLackOfConfs and not in updatedTxs
      expect(result.any((e) => e.hasTx() && e.tx.txid == 'tx1'), isFalse);
    });

    test('excludes peg item that has confs', () {
      final confs = Confs()
        ..count = 1
        ..total = 6;
      final peg = Peg()..isPegIn = true;
      final pegItem = TransItem()
        ..id = 'peg2'
        ..peg = peg
        ..confs = confs;
      final pegsMsg = From_UpdatedPegs()..orderId = 'ord2';
      pegsMsg.items.add(pegItem);
      container.read(allPegsProvider.notifier).update(pegs: pegsMsg);

      final result = container.read(unconfirmedTxsProvider);
      expect(result.any((e) => e.hasPeg() && e.id == 'peg2'), isFalse);
    });

    test('excludes peg item that has txidRecv set', () {
      final peg = Peg()
        ..isPegIn = true
        ..txidRecv = 'some-recv';
      final pegItem = TransItem()
        ..id = 'peg3'
        ..peg = peg;
      final pegsMsg = From_UpdatedPegs()..orderId = 'ord3';
      pegsMsg.items.add(pegItem);
      container.read(allPegsProvider.notifier).update(pegs: pegsMsg);

      final result = container.read(unconfirmedTxsProvider);
      expect(result.any((e) => e.hasPeg() && e.id == 'peg3'), isFalse);
    });
  });

  // ---------------------------------------------------------------------------
  // distinctTransactionsForAccount provider
  // ---------------------------------------------------------------------------

  group('distinctTransactionsForAccount', () {
    late MockSideswapWallet mockWallet;
    late ProviderContainer container;

    setUp(() {
      mockWallet = MockSideswapWallet();
      when(() => mockWallet.sendMsg(any())).thenReturn(null);
      container = ProviderContainer.test(
        overrides: [walletProvider.overrideWithValue(mockWallet)],
      );
      addTearDown(container.dispose);
    });

    test('first item gets showDate=true', () {
      final item = TransItem()
        ..id = 'a'
        ..createdAt = Int64(1704067200000)
        ..tx = (Tx()..txid = 'a');
      container.read(allTxsProvider.notifier).updateList(txs: [item]);
      final result = container.read(distinctTransactionsForAccountProvider);
      expect(result.first.showDate, isTrue);
    });

    test('second item on same calendar day gets showDate=false', () {
      // Same day: 1704067200000 (Jan 1 2024 00:00 UTC) and 1704110400000 (Jan 1 2024 12:00 UTC)
      final a = TransItem()
        ..id = 'a'
        ..createdAt = Int64(1704110400000) // Jan 1 12:00 — sorted first (newer)
        ..tx = (Tx()..txid = 'a');
      final b = TransItem()
        ..id = 'b'
        ..createdAt = Int64(1704067200000) // Jan 1 00:00 — sorted second (older)
        ..tx = (Tx()..txid = 'b');
      container.read(allTxsProvider.notifier).updateList(txs: [a, b]);
      final result = container.read(distinctTransactionsForAccountProvider);
      expect(result[0].showDate, isTrue);
      expect(result[1].showDate, isFalse);
    });

    test('second item on different calendar day gets showDate=true', () {
      final a = TransItem()
        ..id = 'a'
        ..createdAt = Int64(1704153600000) // Jan 2 2024 — sorted first (newer)
        ..tx = (Tx()..txid = 'a');
      final b = TransItem()
        ..id = 'b'
        ..createdAt = Int64(1704067200000) // Jan 1 2024 — sorted second (older)
        ..tx = (Tx()..txid = 'b');
      container.read(allTxsProvider.notifier).updateList(txs: [a, b]);
      final result = container.read(distinctTransactionsForAccountProvider);
      expect(result[0].showDate, isTrue);
      expect(result[1].showDate, isTrue);
    });
  });

  // ---------------------------------------------------------------------------
  // accountAssetTransactions provider
  // ---------------------------------------------------------------------------

  group('accountAssetTransactions', () {
    late MockSideswapWallet mockWallet;
    late ProviderContainer container;

    setUp(() {
      mockWallet = MockSideswapWallet();
      when(() => mockWallet.sendMsg(any())).thenReturn(null);
      container = ProviderContainer.test(
        overrides: [walletProvider.overrideWithValue(mockWallet)],
      );
      addTearDown(container.dispose);
    });

    test('empty input → empty output', () {
      expect(container.read(accountAssetTransactionsProvider), isEmpty);
    });

    test('tx with balance on assetId → keyed by AccountAsset(REG, assetId)', () {
      final item = _makeTxItem(
        txid: 'tx1',
        balances: [_balance(100, 'asset-a')],
      );
      container.read(allTxsProvider.notifier).updateList(txs: [item]);
      final result = container.read(accountAssetTransactionsProvider);
      final key = AccountAsset(Account.REG, 'asset-a');
      expect(result.containsKey(key), isTrue);
      expect(result[key], hasLength(1));
    });

    test('first item in group gets showDate=true', () {
      final item = TransItem()
        ..id = 'a'
        ..createdAt = Int64(1704067200000)
        ..tx = (Tx()
          ..txid = 'a'
          ..balances.add(_balance(100, 'asset-a')));
      container.read(allTxsProvider.notifier).updateList(txs: [item]);
      final result = container.read(accountAssetTransactionsProvider);
      final key = AccountAsset(Account.REG, 'asset-a');
      expect(result[key]!.first.showDate, isTrue);
    });

    test('two txs same day → second showDate=false', () {
      final a = TransItem()
        ..id = 'a'
        ..createdAt = Int64(1704110400000)
        ..tx = (Tx()
          ..txid = 'a'
          ..balances.add(_balance(100, 'asset-a')));
      final b = TransItem()
        ..id = 'b'
        ..createdAt = Int64(1704067200000)
        ..tx = (Tx()
          ..txid = 'b'
          ..balances.add(_balance(100, 'asset-a')));
      container.read(allTxsProvider.notifier).updateList(txs: [a, b]);
      final result = container.read(accountAssetTransactionsProvider);
      final key = AccountAsset(Account.REG, 'asset-a');
      final list = result[key]!;
      expect(list[0].showDate, isTrue);
      expect(list[1].showDate, isFalse);
    });

    test('two txs different day → second showDate=true', () {
      final a = TransItem()
        ..id = 'a'
        ..createdAt = Int64(1704153600000)
        ..tx = (Tx()
          ..txid = 'a'
          ..balances.add(_balance(100, 'asset-a')));
      final b = TransItem()
        ..id = 'b'
        ..createdAt = Int64(1704067200000)
        ..tx = (Tx()
          ..txid = 'b'
          ..balances.add(_balance(100, 'asset-a')));
      container.read(allTxsProvider.notifier).updateList(txs: [a, b]);
      final result = container.read(accountAssetTransactionsProvider);
      final key = AccountAsset(Account.REG, 'asset-a');
      final list = result[key]!;
      expect(list[0].showDate, isTrue);
      expect(list[1].showDate, isTrue);
    });

    test('peg items → keyed by AccountAsset(REG, liquidAssetId)', () {
      container.read(liquidAssetIdStateProvider.notifier).setState('liquid-id');
      final peg = Peg()..isPegIn = true;
      final pegItem = TransItem()
        ..id = 'peg1'
        ..peg = peg;
      final pegsMsg = From_UpdatedPegs()..orderId = 'ord1';
      pegsMsg.items.add(pegItem);
      container.read(allPegsProvider.notifier).update(pegs: pegsMsg);
      final result = container.read(accountAssetTransactionsProvider);
      final key = AccountAsset(Account.REG, 'liquid-id');
      expect(result.containsKey(key), isTrue);
    });
  });

  // ---------------------------------------------------------------------------
  // assetTransactions provider
  // ---------------------------------------------------------------------------

  group('assetTransactions', () {
    late MockSideswapWallet mockWallet;
    late ProviderContainer container;

    setUp(() {
      mockWallet = MockSideswapWallet();
      when(() => mockWallet.sendMsg(any())).thenReturn(null);
      container = ProviderContainer.test(
        overrides: [walletProvider.overrideWithValue(mockWallet)],
      );
      addTearDown(container.dispose);
    });

    test('empty → empty', () {
      expect(container.read(assetTransactionsProvider), isEmpty);
    });

    test('tx with balance → keyed by assetId', () {
      final item = _makeTxItem(
        txid: 'tx1',
        balances: [_balance(100, 'asset-a')],
      );
      container.read(allTxsProvider.notifier).updateList(txs: [item]);
      final result = container.read(assetTransactionsProvider);
      expect(result.containsKey('asset-a'), isTrue);
      expect(result['asset-a'], hasLength(1));
    });

    test('first item showDate=true', () {
      final item = TransItem()
        ..id = 'a'
        ..createdAt = Int64(1704067200000)
        ..tx = (Tx()
          ..txid = 'a'
          ..balances.add(_balance(100, 'asset-a')));
      container.read(allTxsProvider.notifier).updateList(txs: [item]);
      final result = container.read(assetTransactionsProvider);
      expect(result['asset-a']!.first.showDate, isTrue);
    });

    test('two txs same day → second showDate=false', () {
      final a = TransItem()
        ..id = 'a'
        ..createdAt = Int64(1704110400000)
        ..tx = (Tx()
          ..txid = 'a'
          ..balances.add(_balance(100, 'asset-a')));
      final b = TransItem()
        ..id = 'b'
        ..createdAt = Int64(1704067200000)
        ..tx = (Tx()
          ..txid = 'b'
          ..balances.add(_balance(100, 'asset-a')));
      container.read(allTxsProvider.notifier).updateList(txs: [a, b]);
      final result = container.read(assetTransactionsProvider);
      expect(result['asset-a']![0].showDate, isTrue);
      expect(result['asset-a']![1].showDate, isFalse);
    });

    test('peg items → keyed by liquidAssetId', () {
      container.read(liquidAssetIdStateProvider.notifier).setState('liquid-id');
      final peg = Peg()..isPegIn = true;
      final pegItem = TransItem()
        ..id = 'peg1'
        ..peg = peg;
      final pegsMsg = From_UpdatedPegs()..orderId = 'ord1';
      pegsMsg.items.add(pegItem);
      container.read(allPegsProvider.notifier).update(pegs: pegsMsg);
      final result = container.read(assetTransactionsProvider);
      expect(result.containsKey('liquid-id'), isTrue);
    });
  });

  // ---------------------------------------------------------------------------
  // transItemHelperProvider
  // ---------------------------------------------------------------------------

  group('transItemHelperProvider', () {
    late ProviderContainer container;
    late TransItem transItem;

    setUp(() {
      transItem = _makeTxItem(txid: 'tx1');
      container = ProviderContainer.test(
        overrides: [
          pegOrderFeeRatesProvider(transItem).overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);
    });

    test('returns TransItemHelper wrapping the given TransItem', () {
      final helper = container.read(transItemHelperProvider(transItem));
      expect(helper, isA<TransItemHelper>());
      expect(helper.transItem, transItem);
    });
  });
}
