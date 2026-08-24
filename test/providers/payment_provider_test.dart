import 'package:fixnum/fixnum.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/common/enums.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/providers/addresses_providers.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/providers/common_providers.dart';
import 'package:sideswap/providers/outputs_providers.dart';
import 'package:sideswap/providers/payment_provider.dart';
import 'package:sideswap/providers/payjoin_providers.dart';
import 'package:sideswap/providers/satoshi_providers.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/screens/pay/payment_amount_page.dart';
import 'package:sideswap_logger/custom_logger.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class MockSideswapWallet extends Mock implements SideswapWallet {}

class MockSatoshiRepository extends Mock
    implements AbstractSatoshiRepository {}

class MockAssetUtils extends Mock implements AssetUtils {}

class MockAmountToString extends Mock implements AmountToString {}

class _NoOpLogOutput extends LogOutput {
  @override
  void output(OutputEvent event) {}
}

void main() {
  setUpAll(() {
    logger = CustomLogger('SideSwap', output: _NoOpLogOutput());
    registerFallbackValue(CreateTx());
    registerFallbackValue(AmountToStringNamedParameters(amount: 0, ticker: ''));
    registerFallbackValue(Asset());
  });

  group('CreateTxStateNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    test('initial state is empty', () {
      expect(container.read(createTxStateProvider),
          isA<CreateTxStateEmpty>());
    });

    test('setCreateTxState updates state to creating', () {
      container
          .read(createTxStateProvider.notifier)
          .setCreateTxState(const CreateTxState.creating());
      expect(container.read(createTxStateProvider),
          isA<CreateTxStateCreating>());
    });

    test('setCreateTxState updates state to created with value', () {
      final createdTx = CreatedTx(
        req: CreateTx(),
        inputCount: 5,
        outputCount: 2,
        size: Int64(250),
        networkFee: Int64(1000),
        feePerByte: 2.5,
        vsize: Int64(200),
        serverFee: Int64(100),
        discountVsize: Int64(180),
      );
      final state = CreateTxState.created(createdTx);
      container.read(createTxStateProvider.notifier).setCreateTxState(state);
      expect(container.read(createTxStateProvider),
          isA<CreateTxStateCreated>());
    });

    test('setCreateTxState updates state to error with message', () {
      container
          .read(createTxStateProvider.notifier)
          .setCreateTxState(
            const CreateTxState.error(errorMsg: 'Test error'),
          );
      expect(container.read(createTxStateProvider),
          isA<CreateTxStateError>());
    });

    test('setCreateTxState updates state to error without message', () {
      container
          .read(createTxStateProvider.notifier)
          .setCreateTxState(const CreateTxState.error());
      expect(
          container.read(createTxStateProvider), isA<CreateTxStateError>());
    });
  });

  group('SendTxStateNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    test('initial state is empty', () {
      expect(container.read(sendTxStateProvider),
          isA<SendTxStateEmpty>());
    });

    test('setSendTxState updates state to sending', () {
      container
          .read(sendTxStateProvider.notifier)
          .setSendTxState(const SendTxState.sending());
      expect(container.read(sendTxStateProvider),
          isA<SendTxStateSending>());
    });

    test('setSendTxState back to empty', () {
      container
          .read(sendTxStateProvider.notifier)
          .setSendTxState(const SendTxState.empty());
      expect(container.read(sendTxStateProvider), isA<SendTxStateEmpty>());
    });
  });

  group('PaymentSendAddressParsedNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    test('initial state is empty string', () {
      expect(container.read(paymentSendAddressParsedProvider), '');
    });

    test('setSendAddressParsed updates state', () {
      const address = '1A1z7agoat2YTQQ5DhqzfX7T8pRwBVgWu1';
      container
          .read(paymentSendAddressParsedProvider.notifier)
          .setSendAddressParsed(address);
      expect(container.read(paymentSendAddressParsedProvider), address);
    });

    test('setSendAddressParsed overwrites previous value', () {
      const address1 = '1A1z7agoat2YTQQ5DhqzfX7T8pRwBVgWu1';
      const address2 = '1BvBMSEYstWetqTFn5Au4m4GFg7xJaNVN2';
      container
          .read(paymentSendAddressParsedProvider.notifier)
          .setSendAddressParsed(address1);
      container
          .read(paymentSendAddressParsedProvider.notifier)
          .setSendAddressParsed(address2);
      expect(container.read(paymentSendAddressParsedProvider), address2);
    });
  });

  group('PaymentSendAmountParsedNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    test('initial state is zero', () {
      expect(container.read(paymentSendAmountParsedProvider), 0);
    });

    test('setSendAmountParsed updates state', () {
      container
          .read(paymentSendAmountParsedProvider.notifier)
          .setSendAmountParsed(50000);
      expect(container.read(paymentSendAmountParsedProvider), 50000);
    });

    test('setSendAmountParsed with large amount', () {
      const largeAmount = 2100000000000000;
      container
          .read(paymentSendAmountParsedProvider.notifier)
          .setSendAmountParsed(largeAmount);
      expect(container.read(paymentSendAmountParsedProvider), largeAmount);
    });
  });

  group('PaymentAmountPageArgumentsNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    test('initial state is default PaymentAmountPageArguments', () {
      final state = container.read(paymentAmountPageArgumentsProvider);
      expect(state.result, isNull);
    });

    test('setPaymentAmountPageArguments updates state', () {
      final args = PaymentAmountPageArguments(result: null);
      container
          .read(paymentAmountPageArgumentsProvider.notifier)
          .setPaymentAmountPageArguments(args);
      expect(
          container.read(paymentAmountPageArgumentsProvider).runtimeType,
          args.runtimeType);
    });
  });

  group('CreatedTxHelper', () {
    test('feePerByte returns formatted string with s/b suffix', () {
      final createdTx = CreatedTx(
        req: CreateTx(),
        inputCount: 5,
        outputCount: 2,
        size: Int64(250),
        networkFee: Int64(1000),
        feePerByte: 2.567,
        vsize: Int64(200),
        serverFee: Int64(100),
        discountVsize: Int64(180),
      );
      final helper = CreatedTxHelper(createdTx: createdTx);

      expect(helper.feePerByte(), '2.567 s/b');
    });

    test('feePerByte handles null createdTx', () {
      final helper = CreatedTxHelper(createdTx: null);

      expect(helper.feePerByte(), '0 s/b');
    });

    test('txSize returns formatted string with size and vsize', () {
      final createdTx = CreatedTx(
        req: CreateTx(),
        inputCount: 5,
        outputCount: 2,
        size: Int64(250),
        networkFee: Int64(1000),
        feePerByte: 2.5,
        vsize: Int64(200),
        serverFee: Int64(100),
        discountVsize: Int64(180),
      );
      final helper = CreatedTxHelper(createdTx: createdTx);

      expect(helper.txSize(), '250 Bytes / 200 VBytes');
    });

    test('txSize handles null createdTx', () {
      final helper = CreatedTxHelper(createdTx: null);

      expect(helper.txSize(), '0 Bytes / 0 VBytes');
    });

    test('networkFee returns provided fee', () {
      final helper = CreatedTxHelper(
        networkFee: '0.001 L-BTC',
        createdTx: null,
      );

      expect(helper.networkFee(), '0.001 L-BTC');
    });

    test('networkFee returns empty string when not provided', () {
      final helper = CreatedTxHelper(createdTx: null);

      expect(helper.networkFee(), '');
    });

    test('hasServerFee returns true when serverFee is non-zero', () {
      final createdTx = CreatedTx(
        req: CreateTx(),
        inputCount: 5,
        outputCount: 2,
        size: Int64(250),
        networkFee: Int64(1000),
        feePerByte: 2.5,
        vsize: Int64(200),
        serverFee: Int64(100),
        discountVsize: Int64(180),
      );
      final helper = CreatedTxHelper(createdTx: createdTx);

      expect(helper.hasServerFee(), true);
    });

    test('hasServerFee returns false when serverFee is zero', () {
      final createdTx = CreatedTx(
        req: CreateTx(),
        inputCount: 5,
        outputCount: 2,
        size: Int64(250),
        networkFee: Int64(1000),
        feePerByte: 2.5,
        vsize: Int64(200),
        serverFee: Int64(0),
        discountVsize: Int64(180),
      );
      final helper = CreatedTxHelper(createdTx: createdTx);

      expect(helper.hasServerFee(), false);
    });

    test('hasServerFee returns false when createdTx is null', () {
      final helper = CreatedTxHelper(createdTx: null);

      expect(helper.hasServerFee(), false);
    });

    test('serverFee returns provided fee', () {
      final helper = CreatedTxHelper(
        serverFee: '10 USD',
        createdTx: null,
      );

      expect(helper.serverFee(), '10 USD');
    });

    test('serverFee returns empty string when not provided', () {
      final helper = CreatedTxHelper(createdTx: null);

      expect(helper.serverFee(), '');
    });

    test('vsize returns formatted string with vB suffix', () {
      final createdTx = CreatedTx(
        req: CreateTx(),
        inputCount: 5,
        outputCount: 2,
        size: Int64(250),
        networkFee: Int64(1000),
        feePerByte: 2.5,
        vsize: Int64(200),
        serverFee: Int64(100),
        discountVsize: Int64(185),
      );
      final helper = CreatedTxHelper(createdTx: createdTx);

      expect(helper.vsize(), '185 vB');
    });

    test('vsize returns 0 vB when discountVsize is null', () {
      final createdTx = CreatedTx(
        req: CreateTx(),
        inputCount: 5,
        outputCount: 2,
        size: Int64(250),
        networkFee: Int64(1000),
        feePerByte: 2.5,
        vsize: Int64(200),
        serverFee: Int64(100),
        discountVsize: null,
      );
      final helper = CreatedTxHelper(createdTx: createdTx);

      expect(helper.vsize(), '0 vB');
    });

    test('inputCount returns string representation', () {
      final createdTx = CreatedTx(
        req: CreateTx(),
        inputCount: 5,
        outputCount: 2,
        size: Int64(250),
        networkFee: Int64(1000),
        feePerByte: 2.5,
        vsize: Int64(200),
        serverFee: Int64(100),
        discountVsize: Int64(180),
      );
      final helper = CreatedTxHelper(createdTx: createdTx);

      expect(helper.inputCount(), '5');
    });

    test('inputCount returns empty string when createdTx is null', () {
      final helper = CreatedTxHelper(createdTx: null);

      expect(helper.inputCount(), '');
    });

    test('outputCount returns string representation', () {
      final createdTx = CreatedTx(
        req: CreateTx(),
        inputCount: 5,
        outputCount: 3,
        size: Int64(250),
        networkFee: Int64(1000),
        feePerByte: 2.5,
        vsize: Int64(200),
        serverFee: Int64(100),
        discountVsize: Int64(180),
      );
      final helper = CreatedTxHelper(createdTx: createdTx);

      expect(helper.outputCount(), '3');
    });

    test('outputCount returns empty string when createdTx is null', () {
      final helper = CreatedTxHelper(createdTx: null);

      expect(helper.outputCount(), '');
    });
  });

  group('paymentHelper provider', () {
    test('returns PaymentHelper instance with correct dependencies', () {
      final mockSatoshiRepository = MockSatoshiRepository();

      final container = ProviderContainer.test(
        overrides: [
          outputsCreatorProvider.overrideWithValue(
            const Right(OutputsData()),
          ),
          deductFeeFromOutputProvider.overrideWithValue(false),
          payjoinRadioButtonIndexProvider.overrideWithValue(0),
          payjoinFeeAssetProvider.overrideWithValue(null),
          liquidAssetIdStateProvider.overrideWithValue('lbtc'),
          satoshiRepositoryProvider.overrideWithValue(mockSatoshiRepository),
        ],
      );
      addTearDown(container.dispose);

      final helper = container.read(paymentHelperProvider);

      expect(helper, isA<PaymentHelper>());
      expect(helper.deductFeeFromOutput, false);
      expect(helper.deductIndex, 0);
      expect(helper.feeAsset, null);
      expect(helper.liquidAssetId, 'lbtc');
    });

    test('PaymentHelper receives correct dependencies from provider overrides',
        () {
      final mockSatoshiRepository = MockSatoshiRepository();
      final feeAsset = Asset();
      feeAsset.assetId = 'fee-asset';

      final container = ProviderContainer.test(
        overrides: [
          outputsCreatorProvider.overrideWithValue(
            const Right(OutputsData()),
          ),
          deductFeeFromOutputProvider.overrideWithValue(true),
          payjoinRadioButtonIndexProvider.overrideWithValue(1),
          payjoinFeeAssetProvider.overrideWithValue(feeAsset),
          liquidAssetIdStateProvider.overrideWithValue('lbtc'),
          satoshiRepositoryProvider.overrideWithValue(mockSatoshiRepository),
        ],
      );
      addTearDown(container.dispose);

      final helper = container.read(paymentHelperProvider);

      expect(helper.deductFeeFromOutput, true);
      expect(helper.deductIndex, 1);
      expect(helper.feeAsset, feeAsset);
    });
  });

  group('createdTxHelper provider', () {
    test('returns CreatedTxHelper with correct initialization', () {
      final mockAmountToString = MockAmountToString();
      final mockAssetUtils = MockAssetUtils();

      when(() => mockAmountToString.amountToStringNamed(any()))
          .thenReturn('0.001 L-BTC');
      when(() => mockAssetUtils.tickerForAssetId(any()))
          .thenReturn('L-BTC');

      final createdTx = CreatedTx(
        req: CreateTx(),
        inputCount: 5,
        outputCount: 2,
        size: Int64(250),
        networkFee: Int64(1000),
        feePerByte: 2.5,
        vsize: Int64(200),
        serverFee: Int64(0),
        discountVsize: Int64(180),
      );

      final container = ProviderContainer.test(
        overrides: [
          amountToStringProvider.overrideWithValue(mockAmountToString),
          assetUtilsProvider.overrideWithValue(mockAssetUtils),
        ],
      );
      addTearDown(container.dispose);

      final helper = container.read(createdTxHelperProvider(createdTx));

      expect(helper.createdTx, createdTx);
      expect(helper.networkFee(), '0.001 L-BTC');
    });

    test('handles null createdTx', () {
      final mockAmountToString = MockAmountToString();
      final mockAssetUtils = MockAssetUtils();

      when(() => mockAmountToString.amountToStringNamed(any()))
          .thenReturn('');
      when(() => mockAssetUtils.tickerForAssetId(any())).thenReturn('');

      final container = ProviderContainer.test(
        overrides: [
          amountToStringProvider.overrideWithValue(mockAmountToString),
          assetUtilsProvider.overrideWithValue(mockAssetUtils),
        ],
      );
      addTearDown(container.dispose);

      final helper = container.read(createdTxHelperProvider(null));

      expect(helper.createdTx, isNull);
    });

    test('passes correct parameters to amountToString for networkFee', () {
      final mockAmountToString = MockAmountToString();
      final mockAssetUtils = MockAssetUtils();

      when(() => mockAmountToString.amountToStringNamed(any()))
          .thenReturn('0.001 L-BTC');
      when(() => mockAssetUtils.tickerForAssetId(any()))
          .thenReturn('L-BTC');

      final createdTx = CreatedTx(
        req: CreateTx(),
        inputCount: 1,
        outputCount: 1,
        size: Int64(100),
        networkFee: Int64(5000),
        feePerByte: 1.5,
        vsize: Int64(100),
        serverFee: Int64(0),
        discountVsize: Int64(90),
      );

      final container = ProviderContainer.test(
        overrides: [
          amountToStringProvider.overrideWithValue(mockAmountToString),
          assetUtilsProvider.overrideWithValue(mockAssetUtils),
        ],
      );
      addTearDown(container.dispose);

      container.read(createdTxHelperProvider(createdTx));

      verify(() => mockAmountToString.amountToStringNamed(any())).called(2);
      verify(() => mockAssetUtils.tickerForAssetId(any())).called(1);
    });
  });

  // ---------------------------------------------------------------------------
  // PaymentHelper.outputsPaymentSend
  // ---------------------------------------------------------------------------
  group('PaymentHelper.outputsPaymentSend', () {
    late MockSideswapWallet mockWallet;
    late MockSatoshiRepository mockSatoshiRepo;

    setUp(() {
      mockWallet = MockSideswapWallet();
      mockSatoshiRepo = MockSatoshiRepository();
      when(() => mockWallet.createTx(any())).thenReturn(null);
    });

    /// Creates a container + helper for outputsPaymentSend tests.
    /// Returns the helper and a capture function.
    (PaymentHelper, ProviderContainer) makeContainerAndHelper({
      required Either<OutputsError, OutputsData> outputsData,
      bool deductFeeFromOutput = false,
      int deductIndex = 0,
      Asset? feeAsset,
      String liquidAssetId = 'lbtc',
    }) {
      final container = ProviderContainer.test(
        overrides: [
          outputsCreatorProvider.overrideWithValue(outputsData),
          deductFeeFromOutputProvider.overrideWithValue(deductFeeFromOutput),
          payjoinRadioButtonIndexProvider.overrideWithValue(deductIndex),
          payjoinFeeAssetProvider.overrideWithValue(feeAsset),
          liquidAssetIdStateProvider.overrideWithValue(liquidAssetId),
          satoshiRepositoryProvider.overrideWithValue(mockSatoshiRepo),
          walletProvider.overrideWithValue(mockWallet),
        ],
      );
      final helper = container.read(paymentHelperProvider);
      return (helper, container);
    }

    test('Left outputsData returns error message', () {
      const errMsg = 'outputs error';
      final (helper, container) = makeContainerAndHelper(
        outputsData: Left(OutputsErrorWrongTypeOfFile(errMsg)),
      );
      addTearDown(container.dispose);

      final result = helper.outputsPaymentSend();
      expect(result, errMsg);
      verifyNever(() => mockWallet.createTx(any()));
    });

    test('Right with null receivers returns null, no createTx', () {
      final (helper, container) = makeContainerAndHelper(
        outputsData: const Right(OutputsData()),
      );
      addTearDown(container.dispose);

      final result = helper.outputsPaymentSend();
      expect(result, isNull);
      verifyNever(() => mockWallet.createTx(any()));
    });

    test('Right with receivers calls createTx', () {
      final receiver = const OutputsReceiver(
        address: 'addr1',
        assetId: 'asset1',
        satoshi: 5000,
      );
      final (helper, container) = makeContainerAndHelper(
        outputsData: Right(OutputsData(receivers: [receiver])),
      );
      addTearDown(container.dispose);

      helper.outputsPaymentSend();
      verify(() => mockWallet.createTx(any())).called(1);
    });

    test('Right with receivers and selectedInputs passes utxos', () {
      final receiver = const OutputsReceiver(
        address: 'addr1',
        assetId: 'asset1',
        satoshi: 5000,
      );
      final (helper, container) = makeContainerAndHelper(
        outputsData: Right(OutputsData(receivers: [receiver])),
      );
      addTearDown(container.dispose);

      final utxo = const UtxosItem(txid: 'txid1', vout: 0);
      helper.outputsPaymentSend(selectedInputs: [utxo]);

      final captured =
          verify(() => mockWallet.createTx(captureAny())).captured;
      final createTx = captured.first as CreateTx;
      expect(createTx.utxos.isNotEmpty, true);
      expect(createTx.utxos.first.txid, 'txid1');
    });

    test('deductFeeFromOutput=true sets deductFeeOutput to deductIndex', () {
      final receiver = const OutputsReceiver(
        address: 'addr1',
        assetId: 'asset1',
        satoshi: 5000,
      );
      final (helper, container) = makeContainerAndHelper(
        outputsData: Right(OutputsData(receivers: [receiver])),
        deductFeeFromOutput: true,
        deductIndex: 1,
      );
      addTearDown(container.dispose);

      helper.outputsPaymentSend();
      final captured =
          verify(() => mockWallet.createTx(captureAny())).captured;
      final createTx = captured.first as CreateTx;
      expect(createTx.deductFeeOutput, 1);
    });

    test('deductFeeFromOutput=false does not set deductFeeOutput', () {
      final receiver = const OutputsReceiver(
        address: 'addr1',
        assetId: 'asset1',
        satoshi: 5000,
      );
      final (helper, container) = makeContainerAndHelper(
        outputsData: Right(OutputsData(receivers: [receiver])),
        deductFeeFromOutput: false,
        deductIndex: 1,
      );
      addTearDown(container.dispose);

      helper.outputsPaymentSend();
      final captured =
          verify(() => mockWallet.createTx(captureAny())).captured;
      final createTx = captured.first as CreateTx;
      expect(createTx.hasDeductFeeOutput(), false);
    });

    test('feeAsset.assetId != liquidAssetId sets feeAssetId in CreateTx', () {
      final receiver = const OutputsReceiver(
        address: 'addr1',
        assetId: 'asset1',
        satoshi: 5000,
      );
      final feeAsset = Asset()..assetId = 'fee-asset-id';
      final (helper, container) = makeContainerAndHelper(
        outputsData: Right(OutputsData(receivers: [receiver])),
        feeAsset: feeAsset,
        liquidAssetId: 'lbtc',
      );
      addTearDown(container.dispose);

      helper.outputsPaymentSend();
      final captured =
          verify(() => mockWallet.createTx(captureAny())).captured;
      final createTx = captured.first as CreateTx;
      expect(createTx.feeAssetId, 'fee-asset-id');
    });

    test('feeAsset.assetId == liquidAssetId does not set feeAssetId', () {
      final receiver = const OutputsReceiver(
        address: 'addr1',
        assetId: 'asset1',
        satoshi: 5000,
      );
      final feeAsset = Asset()..assetId = 'lbtc';
      final (helper, container) = makeContainerAndHelper(
        outputsData: Right(OutputsData(receivers: [receiver])),
        feeAsset: feeAsset,
        liquidAssetId: 'lbtc',
      );
      addTearDown(container.dispose);

      helper.outputsPaymentSend();
      final captured =
          verify(() => mockWallet.createTx(captureAny())).captured;
      final createTx = captured.first as CreateTx;
      expect(createTx.hasFeeAssetId(), false);
    });
  });

  // ---------------------------------------------------------------------------
  // PaymentHelper.mobileOutputsPaymentSend
  // ---------------------------------------------------------------------------
  group('PaymentHelper.mobileOutputsPaymentSend', () {
    late MockSideswapWallet mockWallet;
    late MockSatoshiRepository mockSatoshiRepo;

    setUp(() {
      mockWallet = MockSideswapWallet();
      mockSatoshiRepo = MockSatoshiRepository();
      when(() => mockWallet.createTx(any())).thenReturn(null);
    });

    (PaymentHelper, ProviderContainer) makeContainerAndHelper({
      required Either<OutputsError, OutputsData> outputsData,
      bool deductFeeFromOutput = false,
      int deductIndex = 0,
      Asset? feeAsset,
      Asset? payjoinFeeAsset,
      String liquidAssetId = 'lbtc',
      Map<String, int> balances = const {},
    }) {
      final container = ProviderContainer.test(
        overrides: [
          outputsCreatorProvider.overrideWithValue(outputsData),
          deductFeeFromOutputProvider.overrideWithValue(deductFeeFromOutput),
          payjoinRadioButtonIndexProvider.overrideWithValue(deductIndex),
          payjoinFeeAssetProvider.overrideWithValue(payjoinFeeAsset),
          liquidAssetIdStateProvider.overrideWithValue(liquidAssetId),
          satoshiRepositoryProvider.overrideWithValue(mockSatoshiRepo),
          walletProvider.overrideWithValue(mockWallet),
          for (final entry in balances.entries)
            availableBalanceForAssetIdProvider(entry.key)
                .overrideWithValue(entry.value),
        ],
      );
      final helper = container.read(paymentHelperProvider);
      return (helper, container);
    }

    test('Left outputsData returns error message', () {
      const errMsg = 'mobile error';
      final (helper, container) = makeContainerAndHelper(
        outputsData: Left(OutputsErrorWrongTypeOfFile(errMsg)),
      );
      addTearDown(container.dispose);

      // ignore: deprecated_member_use
      final result = helper.mobileOutputsPaymentSend();
      expect(result, errMsg);
      verifyNever(() => mockWallet.createTx(any()));
    });

    test('Right with null receivers returns null, no createTx', () {
      final (helper, container) = makeContainerAndHelper(
        outputsData: const Right(OutputsData()),
      );
      addTearDown(container.dispose);

      // ignore: deprecated_member_use
      final result = helper.mobileOutputsPaymentSend();
      expect(result, isNull);
      verifyNever(() => mockWallet.createTx(any()));
    });

    test('payjoinFeeAsset null returns null (early exit)', () {
      final receiver = const OutputsReceiver(
        address: 'addr1',
        assetId: 'asset1',
        satoshi: 5000,
      );
      final (helper, container) = makeContainerAndHelper(
        outputsData: Right(OutputsData(receivers: [receiver])),
        payjoinFeeAsset: null,
      );
      addTearDown(container.dispose);

      // ignore: deprecated_member_use
      final result = helper.mobileOutputsPaymentSend();
      expect(result, isNull);
      verifyNever(() => mockWallet.createTx(any()));
    });

    test('outputSatoshi > maxBalance-1000 sets mobileDeductFeeFromOutput=true',
        () {
      const assetId = 'asset1';
      final receiver = const OutputsReceiver(
        address: 'addr1',
        assetId: assetId,
        satoshi: 100000,
      );
      final feeAsset = Asset()..assetId = assetId;
      // maxBalance=100500, 100000 > (100500-1000)=99500 → deduct=true
      final (helper, container) = makeContainerAndHelper(
        outputsData: Right(OutputsData(receivers: [receiver])),
        payjoinFeeAsset: feeAsset,
        liquidAssetId: 'lbtc',
        balances: {assetId: 100500},
      );
      addTearDown(container.dispose);

      // ignore: deprecated_member_use
      helper.mobileOutputsPaymentSend();
      final captured =
          verify(() => mockWallet.createTx(captureAny())).captured;
      final createTx = captured.first as CreateTx;
      expect(createTx.deductFeeOutput, 0);
      expect(createTx.feeAssetId, assetId);
    });

    test(
        'outputSatoshi <= maxBalance-1000 sets mobileDeductFeeFromOutput=false',
        () {
      const assetId = 'asset1';
      final receiver = const OutputsReceiver(
        address: 'addr1',
        assetId: assetId,
        satoshi: 5000,
      );
      final feeAsset = Asset()..assetId = 'lbtc';
      // maxBalance=100000, 5000 <= (100000-1000)=99000 → deduct=false
      final (helper, container) = makeContainerAndHelper(
        outputsData: Right(OutputsData(receivers: [receiver])),
        payjoinFeeAsset: feeAsset,
        liquidAssetId: 'lbtc',
        balances: {assetId: 100000},
      );
      addTearDown(container.dispose);

      // ignore: deprecated_member_use
      helper.mobileOutputsPaymentSend();
      final captured =
          verify(() => mockWallet.createTx(captureAny())).captured;
      final createTx = captured.first as CreateTx;
      expect(createTx.hasDeductFeeOutput(), false);
    });

    test('when not deducting and feeAsset != liquidAssetId, feeAssetId is set',
        () {
      const assetId = 'asset1';
      final receiver = const OutputsReceiver(
        address: 'addr1',
        assetId: assetId,
        satoshi: 5000,
      );
      final feeAsset = Asset()..assetId = 'fee-other';
      // maxBalance=100000, 5000 <= 99000 → deduct=false → feeAsset branch
      final (helper, container) = makeContainerAndHelper(
        outputsData: Right(OutputsData(receivers: [receiver])),
        payjoinFeeAsset: feeAsset,
        liquidAssetId: 'lbtc',
        balances: {assetId: 100000},
      );
      addTearDown(container.dispose);

      // ignore: deprecated_member_use
      helper.mobileOutputsPaymentSend();
      final captured =
          verify(() => mockWallet.createTx(captureAny())).captured;
      final createTx = captured.first as CreateTx;
      expect(createTx.feeAssetId, 'fee-other');
    });

    test('Right with receivers and selectedInputs passes utxos to createTx',
        () {
      const assetId = 'asset1';
      final receiver = const OutputsReceiver(
        address: 'addr1',
        assetId: assetId,
        satoshi: 5000,
      );
      final feeAsset = Asset()..assetId = 'lbtc';
      final (helper, container) = makeContainerAndHelper(
        outputsData: Right(OutputsData(receivers: [receiver])),
        payjoinFeeAsset: feeAsset,
        liquidAssetId: 'lbtc',
        balances: {assetId: 100000},
      );
      addTearDown(container.dispose);

      final utxo = const UtxosItem(txid: 'mobile-txid', vout: 1);
      // ignore: deprecated_member_use
      helper.mobileOutputsPaymentSend(selectedInputs: [utxo]);

      final captured =
          verify(() => mockWallet.createTx(captureAny())).captured;
      final createTx = captured.first as CreateTx;
      expect(createTx.utxos.isNotEmpty, true);
      expect(createTx.utxos.first.txid, 'mobile-txid');
    });
  });

  // ---------------------------------------------------------------------------
  // PaymentHelper.selectPaymentSend
  // ---------------------------------------------------------------------------
  group('PaymentHelper.selectPaymentSend', () {
    late MockSideswapWallet mockWallet;
    late MockSatoshiRepository mockSatoshiRepo;
    late MockAssetUtils mockAssetUtils;

    setUp(() {
      mockWallet = MockSideswapWallet();
      mockSatoshiRepo = MockSatoshiRepository();
      mockAssetUtils = MockAssetUtils();
      when(() => mockWallet.createTx(any())).thenReturn(null);
      when(() => mockAssetUtils.getPrecisionForAssetId(
            assetId: any(named: 'assetId'),
          )).thenReturn(8);
    });

    (PaymentHelper, ProviderContainer) makeContainerAndHelper({
      String liquidAssetId = 'lbtc',
      Asset? feeAsset,
      bool validAddress = true,
      String address = 'valid-addr',
      int? parsedAmount,
      int balance = 100000,
      String assetId = 'asset1',
    }) {
      final container = ProviderContainer.test(
        overrides: [
          outputsCreatorProvider.overrideWithValue(const Right(OutputsData())),
          deductFeeFromOutputProvider.overrideWithValue(false),
          payjoinRadioButtonIndexProvider.overrideWithValue(0),
          payjoinFeeAssetProvider.overrideWithValue(null),
          liquidAssetIdStateProvider.overrideWithValue(liquidAssetId),
          satoshiRepositoryProvider.overrideWithValue(mockSatoshiRepo),
          walletProvider.overrideWithValue(mockWallet),
          assetUtilsProvider.overrideWithValue(mockAssetUtils),
          isAddrTypeValidProvider(address, AddrType.elements)
              .overrideWithValue(validAddress),
          availableBalanceForAssetIdProvider(assetId).overrideWithValue(balance),
        ],
      );
      final helper = container.read(paymentHelperProvider);
      return (helper, container);
    }

    test('null address returns early, no createTx called', () {
      final (helper, container) = makeContainerAndHelper();
      addTearDown(container.dispose);

      final asset = Asset()..assetId = 'asset1';
      helper.selectPaymentSend('1000', asset, address: null);
      verifyNever(() => mockWallet.createTx(any()));
    });

    test('invalid address returns early, no createTx called', () {
      const addr = 'invalid-addr';
      final (helper, container) = makeContainerAndHelper(
        address: addr,
        validAddress: false,
      );
      addTearDown(container.dispose);

      final asset = Asset()..assetId = 'asset1';
      helper.selectPaymentSend('1000', asset, address: addr);
      verifyNever(() => mockWallet.createTx(any()));
    });

    test('parseAssetAmount returns null → early return, no createTx', () {
      when(() => mockSatoshiRepo.parseAssetAmount(
            amount: any(named: 'amount'),
            precision: any(named: 'precision'),
          )).thenReturn(null);

      final (helper, container) = makeContainerAndHelper(
        validAddress: true,
        balance: 100000,
      );
      addTearDown(container.dispose);

      final asset = Asset()..assetId = 'asset1';
      helper.selectPaymentSend('abc', asset, address: 'valid-addr');
      verifyNever(() => mockWallet.createTx(any()));
    });

    test('amount <= 0 → early return, no createTx', () {
      when(() => mockSatoshiRepo.parseAssetAmount(
            amount: any(named: 'amount'),
            precision: any(named: 'precision'),
          )).thenReturn(0);

      final (helper, container) = makeContainerAndHelper(
        validAddress: true,
        balance: 100000,
      );
      addTearDown(container.dispose);

      final asset = Asset()..assetId = 'asset1';
      helper.selectPaymentSend('0', asset, address: 'valid-addr');
      verifyNever(() => mockWallet.createTx(any()));
    });

    test('amount > balance → early return, no createTx', () {
      when(() => mockSatoshiRepo.parseAssetAmount(
            amount: any(named: 'amount'),
            precision: any(named: 'precision'),
          )).thenReturn(200000);

      final (helper, container) = makeContainerAndHelper(
        validAddress: true,
        balance: 100000,
      );
      addTearDown(container.dispose);

      final asset = Asset()..assetId = 'asset1';
      helper.selectPaymentSend('200000', asset, address: 'valid-addr');
      verifyNever(() => mockWallet.createTx(any()));
    });

    test('happy path calls createTx and updates notifiers', () {
      when(() => mockSatoshiRepo.parseAssetAmount(
            amount: any(named: 'amount'),
            precision: any(named: 'precision'),
          )).thenReturn(50000);

      final (helper, container) = makeContainerAndHelper(
        validAddress: true,
        balance: 100000,
        liquidAssetId: 'lbtc',
      );
      addTearDown(container.dispose);

      final asset = Asset()..assetId = 'asset1';
      helper.selectPaymentSend('0.0005', asset, address: 'valid-addr');

      verify(() => mockWallet.createTx(any())).called(1);
      expect(container.read(paymentSendAddressParsedProvider), 'valid-addr');
      expect(container.read(paymentSendAmountParsedProvider), 50000);
    });

    test('happy path: microtask triggers selectedWalletAsset setState', () async {
      when(() => mockSatoshiRepo.parseAssetAmount(
            amount: any(named: 'amount'),
            precision: any(named: 'precision'),
          )).thenReturn(50000);

      final container = ProviderContainer.test(
        overrides: [
          outputsCreatorProvider.overrideWithValue(const Right(OutputsData())),
          deductFeeFromOutputProvider.overrideWithValue(false),
          payjoinRadioButtonIndexProvider.overrideWithValue(0),
          payjoinFeeAssetProvider.overrideWithValue(null),
          liquidAssetIdStateProvider.overrideWithValue('lbtc'),
          satoshiRepositoryProvider.overrideWithValue(mockSatoshiRepo),
          walletProvider.overrideWithValue(mockWallet),
          assetUtilsProvider.overrideWithValue(mockAssetUtils),
          isAddrTypeValidProvider('valid-addr', AddrType.elements)
              .overrideWithValue(true),
          availableBalanceForAssetIdProvider('lbtc').overrideWithValue(100000),
        ],
      );
      addTearDown(container.dispose);

      final helper = container.read(paymentHelperProvider);
      final asset = Asset()..assetId = 'lbtc';
      helper.selectPaymentSend('0.0005', asset, address: 'valid-addr');

      // before microtask: state is None (no selected asset yet, or default)
      await Future.delayed(Duration.zero);
      // after microtask: selectedWalletAssetProvider should have the asset
      final selectedAsset = container.read(selectedWalletAssetProvider);
      expect(selectedAsset.isSome(), true);
    });

    test('invalid address: microtask still fires before validation check',
        () async {
      final container = ProviderContainer.test(
        overrides: [
          outputsCreatorProvider.overrideWithValue(const Right(OutputsData())),
          deductFeeFromOutputProvider.overrideWithValue(false),
          payjoinRadioButtonIndexProvider.overrideWithValue(0),
          payjoinFeeAssetProvider.overrideWithValue(null),
          liquidAssetIdStateProvider.overrideWithValue('lbtc'),
          satoshiRepositoryProvider.overrideWithValue(mockSatoshiRepo),
          walletProvider.overrideWithValue(mockWallet),
          assetUtilsProvider.overrideWithValue(mockAssetUtils),
          isAddrTypeValidProvider('bad-addr', AddrType.elements)
              .overrideWithValue(false),
          availableBalanceForAssetIdProvider('asset1').overrideWithValue(100000),
        ],
      );
      addTearDown(container.dispose);

      final helper = container.read(paymentHelperProvider);
      final asset = Asset()..assetId = 'asset1';
      helper.selectPaymentSend('1000', asset, address: 'bad-addr');

      await Future.delayed(Duration.zero);
      // microtask fires setState even for invalid address
      final selectedAsset = container.read(selectedWalletAssetProvider);
      expect(selectedAsset.isSome(), true);
      verifyNever(() => mockWallet.createTx(any()));
    });

    test('isGreedy + amount==balance + liquid asset → deductFeeOutput=0', () {
      const balance = 100000;

      when(() => mockSatoshiRepo.parseAssetAmount(
            amount: any(named: 'amount'),
            precision: any(named: 'precision'),
          )).thenReturn(balance);

      final (helper, container) = makeContainerAndHelper(
        validAddress: true,
        balance: balance,
        liquidAssetId: 'lbtc',
        assetId: 'lbtc',
      );
      addTearDown(container.dispose);

      final asset = Asset()..assetId = 'lbtc';
      helper.selectPaymentSend('0.001', asset,
          address: 'valid-addr', isGreedy: true);

      final captured =
          verify(() => mockWallet.createTx(captureAny())).captured;
      final createTx = captured.first as CreateTx;
      expect(createTx.deductFeeOutput, 0);
    });

    test('isGreedy + amount==balance but non-liquid asset → no deduct', () {
      const balance = 100000;

      when(() => mockSatoshiRepo.parseAssetAmount(
            amount: any(named: 'amount'),
            precision: any(named: 'precision'),
          )).thenReturn(balance);

      final (helper, container) = makeContainerAndHelper(
        validAddress: true,
        balance: balance,
        liquidAssetId: 'lbtc',
        assetId: 'asset1',
      );
      addTearDown(container.dispose);

      final asset = Asset()..assetId = 'asset1';
      helper.selectPaymentSend('0.001', asset,
          address: 'valid-addr', isGreedy: true);

      final captured =
          verify(() => mockWallet.createTx(captureAny())).captured;
      final createTx = captured.first as CreateTx;
      expect(createTx.hasDeductFeeOutput(), false);
    });

    test('isGreedy but amount < balance → no deduct', () {
      const balance = 100000;

      when(() => mockSatoshiRepo.parseAssetAmount(
            amount: any(named: 'amount'),
            precision: any(named: 'precision'),
          )).thenReturn(50000); // less than balance

      final (helper, container) = makeContainerAndHelper(
        validAddress: true,
        balance: balance,
        liquidAssetId: 'lbtc',
        assetId: 'lbtc',
      );
      addTearDown(container.dispose);

      final asset = Asset()..assetId = 'lbtc';
      helper.selectPaymentSend('0.0005', asset,
          address: 'valid-addr', isGreedy: true);

      final captured =
          verify(() => mockWallet.createTx(captureAny())).captured;
      final createTx = captured.first as CreateTx;
      expect(createTx.hasDeductFeeOutput(), false);
    });
  });

  // ---------------------------------------------------------------------------
  // Generated .g.dart coverage: overrideWithValue, operator==, toString
  // ---------------------------------------------------------------------------
  group('generated provider overrideWithValue coverage', () {
    test('createTxStateProvider.overrideWithValue works', () {
      const state = CreateTxState.creating();
      final container = ProviderContainer.test(overrides: [
        createTxStateProvider.overrideWithValue(state),
      ]);
      addTearDown(container.dispose);
      expect(container.read(createTxStateProvider), isA<CreateTxStateCreating>());
    });

    test('sendTxStateProvider.overrideWithValue works', () {
      const state = SendTxState.sending();
      final container = ProviderContainer.test(overrides: [
        sendTxStateProvider.overrideWithValue(state),
      ]);
      addTearDown(container.dispose);
      expect(container.read(sendTxStateProvider), isA<SendTxStateSending>());
    });

    test('paymentSendAddressParsedProvider.overrideWithValue works', () {
      final container = ProviderContainer.test(overrides: [
        paymentSendAddressParsedProvider.overrideWithValue('override-addr'),
      ]);
      addTearDown(container.dispose);
      expect(container.read(paymentSendAddressParsedProvider), 'override-addr');
    });

    test('paymentSendAmountParsedProvider.overrideWithValue works', () {
      final container = ProviderContainer.test(overrides: [
        paymentSendAmountParsedProvider.overrideWithValue(99999),
      ]);
      addTearDown(container.dispose);
      expect(container.read(paymentSendAmountParsedProvider), 99999);
    });

    test('paymentAmountPageArgumentsProvider.overrideWithValue works', () {
      final args = PaymentAmountPageArguments(result: null);
      final container = ProviderContainer.test(overrides: [
        paymentAmountPageArgumentsProvider.overrideWithValue(args),
      ]);
      addTearDown(container.dispose);
      expect(
          container.read(paymentAmountPageArgumentsProvider).runtimeType,
          args.runtimeType);
    });

    test('paymentHelperProvider.overrideWithValue works', () {
      final mockSatoshiRepo = MockSatoshiRepository();
      final mockWallet = MockSideswapWallet();
      final innerContainer = ProviderContainer.test(overrides: [
        outputsCreatorProvider.overrideWithValue(const Right(OutputsData())),
        deductFeeFromOutputProvider.overrideWithValue(false),
        payjoinRadioButtonIndexProvider.overrideWithValue(0),
        payjoinFeeAssetProvider.overrideWithValue(null),
        liquidAssetIdStateProvider.overrideWithValue('lbtc'),
        satoshiRepositoryProvider.overrideWithValue(mockSatoshiRepo),
        walletProvider.overrideWithValue(mockWallet),
      ]);
      addTearDown(innerContainer.dispose);
      final fakeHelper = innerContainer.read(paymentHelperProvider);
      final container = ProviderContainer.test(overrides: [
        paymentHelperProvider.overrideWithValue(fakeHelper),
      ]);
      addTearDown(container.dispose);
      expect(container.read(paymentHelperProvider), same(fakeHelper));
    });

    test('createdTxHelperProvider.overrideWithValue works', () {
      final mockAmountToString = MockAmountToString();
      final mockAssetUtils = MockAssetUtils();
      when(() => mockAmountToString.amountToStringNamed(any())).thenReturn('');
      when(() => mockAssetUtils.tickerForAssetId(any())).thenReturn('');

      final innerContainer = ProviderContainer.test(overrides: [
        amountToStringProvider.overrideWithValue(mockAmountToString),
        assetUtilsProvider.overrideWithValue(mockAssetUtils),
      ]);
      addTearDown(innerContainer.dispose);
      final fakeHelper = innerContainer.read(createdTxHelperProvider(null));

      final container = ProviderContainer.test(overrides: [
        createdTxHelperProvider(null).overrideWithValue(fakeHelper),
      ]);
      addTearDown(container.dispose);
      expect(container.read(createdTxHelperProvider(null)), same(fakeHelper));
    });

    test('createdTxHelperProvider equality: same arg equals', () {
      final p1 = createdTxHelperProvider(null);
      final p2 = createdTxHelperProvider(null);
      expect(p1, equals(p2));
      expect(p1.hashCode, equals(p2.hashCode));
    });

    test('createdTxHelperProvider equality: different arg not equal', () {
      final tx = CreatedTx(
        req: CreateTx(),
        inputCount: 1,
        outputCount: 1,
        size: Int64(100),
        networkFee: Int64(100),
        feePerByte: 1.0,
        vsize: Int64(100),
        serverFee: Int64(0),
        discountVsize: Int64(90),
      );
      final p1 = createdTxHelperProvider(null);
      final p2 = createdTxHelperProvider(tx);
      expect(p1 == p2, false);
    });

    test('createdTxHelperProvider toString contains provider name', () {
      final p = createdTxHelperProvider(null);
      expect(p.toString(), contains('createdTxHelperProvider'));
    });

    test('createdTxHelperProvider family toString', () {
      expect(createdTxHelperProvider.toString(),
          contains('createdTxHelperProvider'));
    });
  });
}
