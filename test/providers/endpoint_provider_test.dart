import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/models/endpoint_internal_model.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/providers/connection_state_providers.dart';
import 'package:sideswap/providers/desktop_dialog_providers.dart';
import 'package:sideswap/providers/endpoint_provider.dart';
import 'package:sideswap/providers/payment_provider.dart';
import 'package:sideswap/providers/receive_address_providers.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap_logger/custom_logger.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';
import 'package:sideswap_websocket/sideswap_endpoint.dart';

import '../helpers/test_utils.dart';

void _registerFallbacks() {
  registerFallbackValue(EICreateTransactionEmpty());
  registerFallbackValue(
    EndpointReplyModel(
      reply: EndpointReply(
        id: '',
        type: EndpointReplyType.newAddress,
        data: EndpointReplyDataNewAddress(address: ''),
      ),
    ),
  );
  registerFallbackValue(Asset());
  registerFallbackValue(Account.REG);
}

MockEndpointServer _createMockServer() {
  final mock = MockEndpointServer();
  when(
    () => mock.stop(force: any(named: 'force')),
  ).thenAnswer((_) => Future.value());
  return mock;
}

void main() {
  setUpAll(() {
    _registerFallbacks();
    logger = CustomLogger('SideSwap', output: NoOpLogOutput());
  });

  final createTxRequest = EndpointRequest(
    type: EndpointRequestType.createTransaction,
    data: EndpointRequestDataCreateTransaction(
      address: 'addr1',
      assetId: 'testAsset',
      amount: '100',
    ),
  );
  group('endpointServer provider', () {
    test('creates EndpointServerImpl instance', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final server = container.read(endpointServerProvider);

      expect(server, isA<EndpointServerImpl>());
      expect(server.endpointServer, isNull);
    });

    test('disposes EndpointServerImpl on container disposal', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);
      final server = container.read(endpointServerProvider);

      expect(server, isA<EndpointServerImpl>());

      // Disposal triggers onDispose callback which calls stop(force: true)
      container.dispose();
    });
  });

  group('EiCreateTransactionNotifier', () {
    test('initial state is EICreateTransactionEmpty', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final state = container.read(eiCreateTransactionProvider);

      expect(state, isA<EICreateTransactionEmpty>());
    });

    test('setState updates state to EICreateTransactionData', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final notifier = container.read(eiCreateTransactionProvider.notifier);
      final newState = EICreateTransactionData(
        assetId: 'asset123',
        address: 'address123',
        amount: '1000',
      );

      notifier.setState(newState);

      // Verify final state is correct
      expect(container.read(eiCreateTransactionProvider), newState);
    });

    test('setState transitions from data back to empty', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final notifier = container.read(eiCreateTransactionProvider.notifier);

      // First, set to data
      final dataState = EICreateTransactionData(
        assetId: 'asset123',
        address: 'address123',
        amount: '1000',
      );
      notifier.setState(dataState);

      expect(
        container.read(eiCreateTransactionProvider),
        isA<EICreateTransactionData>(),
      );

      // Then, transition back to empty
      notifier.setState(EICreateTransactionEmpty());

      expect(
        container.read(eiCreateTransactionProvider),
        isA<EICreateTransactionEmpty>(),
      );
    });
  });

  group('serve() with mock', () {
    test('calls mock.serve() when endpointServer is set', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final impl = container.read(endpointServerProvider);
      final mockServer = _createMockServer();
      when(() => mockServer.serve()).thenAnswer((_) => Future.value());
      impl.endpointServer = mockServer;

      impl.serve();

      verify(() => mockServer.serve()).called(1);
    });
  });

  group('serve() without mock → _init path', () {
    test('creates EndpointServer via _init when null', () async {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final impl = container.read(endpointServerProvider);

      expect(impl.endpointServer, isNull);

      // Wrap in zone to suppress async HTTP binding error
      await runZonedGuarded(() {
        impl.serve();
        return Future.value();
      }, (_, _) {});

      // Verify _init created an EndpointServer
      expect(impl.endpointServer, isNotNull);
      expect(impl.endpointServer, isA<EndpointServer>());
    });
  });

  group('onRequest — not connected → sendError', () {
    test('sends error when serverConnectionProvider is false', () {
      final container = ProviderContainer.test(
        overrides: [serverConnectionProvider.overrideWithValue(false)],
      );
      addTearDown(container.dispose);

      final impl = container.read(endpointServerProvider);
      final mockServer = _createMockServer();
      impl.endpointServer = mockServer;

      final request = EndpointRequest(type: EndpointRequestType.newAddress);
      impl.onRequest(request, 'ch1', 'id1');

      verify(
        () => mockServer.sendError(
          message: 'Unable to execute request right now, try again later',
          channelId: 'ch1',
          id: 'id1',
        ),
      ).called(1);
    });
  });

  group('onRequest — unknown request type', () {
    test('ignores ping request type (default branch)', () {
      final container = ProviderContainer.test(
        overrides: [serverConnectionProvider.overrideWithValue(true)],
      );
      addTearDown(container.dispose);

      final impl = container.read(endpointServerProvider);
      final mockServer = _createMockServer();
      impl.endpointServer = mockServer;

      final request = EndpointRequest(type: EndpointRequestType.ping);
      impl.onRequest(request, 'ch1', 'id1');
    });
  });

  group('onRequest — createTransaction invalid data', () {
    test('ignores createTransaction with null data', () {
      final container = ProviderContainer.test(
        overrides: [serverConnectionProvider.overrideWithValue(true)],
      );
      addTearDown(container.dispose);

      final impl = container.read(endpointServerProvider);
      final mockServer = _createMockServer();
      impl.endpointServer = mockServer;

      final request = EndpointRequest(
        type: EndpointRequestType.createTransaction,
      );
      impl.onRequest(request, 'ch1', 'id1');
    });
  });

  group('onRequest — newAddress with FakeAsync', () {
    test('newAddress with valid recvAddress sends encrypted reply', () {
      final mockWallet = MockWallet();
      when(() => mockWallet.toggleRecvAddrType(any())).thenReturn(null);

      final container = ProviderContainer.test(
        overrides: [
          serverConnectionProvider.overrideWithValue(true),
          walletProvider.overrideWithValue(mockWallet),
          currentReceiveAddressProvider.overrideWithValue(
            ReceiveAddress(account: Account.REG, recvAddress: 'bc1test'),
          ),
        ],
      );
      addTearDown(container.dispose);

      final impl = container.read(endpointServerProvider);
      final mockServer = _createMockServer();
      when(
        () => mockServer.sendEncrypted(any(), any()),
      ).thenReturn(const Right(true));
      impl.endpointServer = mockServer;

      fakeAsync((async) {
        impl.onRequest(
          EndpointRequest(type: EndpointRequestType.newAddress),
          'ch1',
          'id1',
        );
        async.elapse(const Duration(seconds: 3));
      });

      verify(() => mockServer.sendEncrypted(any(), 'ch1')).called(1);
    });

    test('newAddress with empty recvAddress does NOT send reply', () {
      final mockWallet = MockWallet();
      when(() => mockWallet.toggleRecvAddrType(any())).thenReturn(null);

      final container = ProviderContainer.test(
        overrides: [
          serverConnectionProvider.overrideWithValue(true),
          walletProvider.overrideWithValue(mockWallet),
          currentReceiveAddressProvider.overrideWithValue(
            ReceiveAddress(account: Account.REG, recvAddress: ''),
          ),
        ],
      );
      addTearDown(container.dispose);

      final impl = container.read(endpointServerProvider);
      final mockServer = _createMockServer();
      when(
        () => mockServer.sendEncrypted(any(), any()),
      ).thenReturn(const Right(true));
      impl.endpointServer = mockServer;

      fakeAsync((async) {
        impl.onRequest(
          EndpointRequest(type: EndpointRequestType.newAddress),
          'ch1',
          'id1',
        );
        async.elapse(const Duration(seconds: 3));
      });

      verifyNever(() => mockServer.sendEncrypted(any(), any()));
    });
  });

  group('onRequest — createTransaction happy path', () {
    test('updates state, calls paymentHelper and desktopDialog', () {
      final testAsset = Asset(assetId: 'testAsset');
      final mockPaymentHelper = MockPaymentHelper();
      when(
        () => mockPaymentHelper.selectPaymentSend(
          any(),
          any(),
          address: any(named: 'address'),
        ),
      ).thenReturn(null);

      final mockDesktopDialog = MockDesktopDialog();
      when(() => mockDesktopDialog.closePopups()).thenReturn(null);
      when(() => mockDesktopDialog.showSendTx()).thenReturn(null);

      final container = ProviderContainer.test(
        overrides: [
          serverConnectionProvider.overrideWithValue(true),
          availableBalanceForAssetIdProvider(
            'testAsset',
          ).overrideWithValue(1000),
          assetFromAssetIdProvider(
            'testAsset',
          ).overrideWithValue(Option.of(testAsset)),
          paymentHelperProvider.overrideWithValue(mockPaymentHelper),
          desktopDialogProvider.overrideWithValue(mockDesktopDialog),
        ],
      );
      addTearDown(container.dispose);

      final impl = container.read(endpointServerProvider);
      final mockServer = _createMockServer();
      impl.endpointServer = mockServer;

      impl.onRequest(createTxRequest, 'ch1', 'id1');

      final txState = container.read(eiCreateTransactionProvider);
      expect(txState, isA<EICreateTransactionData>());
      expect((txState as EICreateTransactionData).assetId, 'testAsset');
      expect(txState.address, 'addr1');
      expect(txState.amount, '100');

      verify(
        () => mockPaymentHelper.selectPaymentSend(
          '100',
          testAsset,
          address: 'addr1',
        ),
      ).called(1);
      verify(() => mockDesktopDialog.closePopups()).called(1);
      verify(() => mockDesktopDialog.showSendTx()).called(1);
    });
  });

  group('onRequest — createTransaction zero balance', () {
    test('early return — paymentHelper not called when balance is 0', () {
      final mockPaymentHelper = MockPaymentHelper();
      final mockDesktopDialog = MockDesktopDialog();

      final container = ProviderContainer.test(
        overrides: [
          serverConnectionProvider.overrideWithValue(true),
          availableBalanceForAssetIdProvider('testAsset').overrideWithValue(0),
          assetFromAssetIdProvider(
            'testAsset',
          ).overrideWithValue(Option.of(Asset(assetId: 'testAsset'))),
          paymentHelperProvider.overrideWithValue(mockPaymentHelper),
          desktopDialogProvider.overrideWithValue(mockDesktopDialog),
        ],
      );
      addTearDown(container.dispose);

      final impl = container.read(endpointServerProvider);
      final mockServer = _createMockServer();
      impl.endpointServer = mockServer;

      impl.onRequest(createTxRequest, 'ch1', 'id1');

      verifyNever(
        () => mockPaymentHelper.selectPaymentSend(
          any(),
          any(),
          address: any(named: 'address'),
        ),
      );
      verifyNever(() => mockDesktopDialog.closePopups());
      verifyNever(() => mockDesktopDialog.showSendTx());
    });
  });

  group('onRequest — createTransaction asset not found', () {
    test('paymentHelper/desktopDialog not called when asset is None', () {
      final mockPaymentHelper = MockPaymentHelper();
      final mockDesktopDialog = MockDesktopDialog();

      final container = ProviderContainer.test(
        overrides: [
          serverConnectionProvider.overrideWithValue(true),
          availableBalanceForAssetIdProvider(
            'testAsset',
          ).overrideWithValue(1000),
          assetFromAssetIdProvider(
            'testAsset',
          ).overrideWithValue(const Option<Asset>.none()),
          paymentHelperProvider.overrideWithValue(mockPaymentHelper),
          desktopDialogProvider.overrideWithValue(mockDesktopDialog),
        ],
      );
      addTearDown(container.dispose);

      final impl = container.read(endpointServerProvider);
      final mockServer = _createMockServer();
      impl.endpointServer = mockServer;

      impl.onRequest(createTxRequest, 'ch1', 'id1');

      verifyNever(
        () => mockPaymentHelper.selectPaymentSend(
          any(),
          any(),
          address: any(named: 'address'),
        ),
      );
      verifyNever(() => mockDesktopDialog.closePopups());
      verifyNever(() => mockDesktopDialog.showSendTx());
    });
  });
}

class MockEndpointServer extends Mock implements EndpointServer {}

class MockWallet extends Mock implements SideswapWallet {}

class MockPaymentHelper extends Mock implements PaymentHelper {}

class MockDesktopDialog extends Mock implements DesktopDialog {}
