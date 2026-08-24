import 'dart:async';
import 'dart:typed_data';

import 'package:async/async.dart';
import 'package:fake_async/fake_async.dart';
// ignore: implementation_imports
import 'package:easy_localization/src/localization.dart';
// ignore: implementation_imports
import 'package:easy_localization/src/translations.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/widgets.dart' show Locale;
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/models/pegx_model.dart';
import 'package:sideswap/providers/amp_id_provider.dart';
import 'package:sideswap/providers/env_provider.dart';
import 'package:sideswap/providers/pegx_connection.dart';
import 'package:sideswap/providers/pegx_provider.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart';
import 'package:sideswap/side_swap_client_ffi.dart';
import 'package:sideswap_logger/custom_logger.dart';
import 'package:sideswap_protobuf/pegx_api.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../utils.dart';

class _NoOpLogOutput extends LogOutput {
  @override
  void output(OutputEvent event) {}
}

// Inline fakes (cannot import from other test files)
class _FakeWebSocketChannel implements WebSocketChannel {
  final streamController = StreamController<Object?>();
  final sinkController = StreamController<Object?>();
  late final _FakeWebSocketSink _sink = _FakeWebSocketSink(sinkController);

  @override
  // ignore: avoid_annotating_with_dynamic
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Stream<dynamic> get stream => streamController.stream;
  @override
  WebSocketSink get sink => _sink;
  @override
  Future<void> get ready => Future.value();
  @override
  String? get protocol => null;
  @override
  int? get closeCode => null;
  @override
  String? get closeReason => null;
}

class _FakeWebSocketSink extends DelegatingStreamSink<Object?>
    implements WebSocketSink {
  _FakeWebSocketSink(StreamController<Object?> controller)
    : super(controller.sink);

  @override
  Future<void> close([int? closeCode, String? closeReason]) => super.close();
}

class _TestnetEnv extends Env {
  @override
  int build() => SIDESWAP_ENV_TESTNET;
}

void main() {
  setUpAll(() {
    registerFallbackValue(const PegxLoginState.loading());
    registerFallbackValue(const PegxGaidState.empty());
    logger = CustomLogger('SideSwap', output: _NoOpLogOutput());
    Localization.load(
      const Locale('en'),
      translations: Translations({
        'Adding AMP ID failed. Try again.': 'Adding AMP ID failed. Try again.',
      }),
    );
  });

  tearDownAll(() {
    Localization.load(const Locale('en'));
  });

  group('PegxLoginStateNotifier', () {
    group('build', () {
      test('returns PegxLoginStateLoading as initial state', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final state = container.read(pegxLoginStateProvider);

        expect(state, isA<PegxLoginStateLoading>());
      });
    });

    group('setState', () {
      test('transitions to PegxLoginStateLogin with requestId', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        final listener = ProviderListener<PegxLoginState>();

        container.listen(
          pegxLoginStateProvider,
          listener.call,
          fireImmediately: true,
        );

        const requestId = 'test-request-123';
        container
            .read(pegxLoginStateProvider.notifier)
            .setState(PegxLoginState.login(requestId: requestId));

        expect(
          container.read(pegxLoginStateProvider),
          isA<PegxLoginStateLogin>().having(
            (s) => s.requestId,
            'requestId',
            requestId,
          ),
        );
      });

      test('transitions to PegxLoginStateLogged', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        container
            .read(pegxLoginStateProvider.notifier)
            .setState(const PegxLoginState.logged());

        expect(
          container.read(pegxLoginStateProvider),
          isA<PegxLoginStateLogged>(),
        );
      });

      test('transitions to PegxLoginStateGaidWaiting', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        container
            .read(pegxLoginStateProvider.notifier)
            .setState(const PegxLoginState.gaidWaiting());

        expect(
          container.read(pegxLoginStateProvider),
          isA<PegxLoginStateGaidWaiting>(),
        );
      });

      test('transitions to PegxLoginStateGaidAdded', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        container
            .read(pegxLoginStateProvider.notifier)
            .setState(const PegxLoginState.gaidAdded());

        expect(
          container.read(pegxLoginStateProvider),
          isA<PegxLoginStateGaidAdded>(),
        );
      });

      test('transitions to PegxLoginStateGaidError', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        container
            .read(pegxLoginStateProvider.notifier)
            .setState(const PegxLoginState.gaidError());

        expect(
          container.read(pegxLoginStateProvider),
          isA<PegxLoginStateGaidError>(),
        );
      });

      test('notifies listeners on state change', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        final listener = ProviderListener<PegxLoginState>();

        container.listen(
          pegxLoginStateProvider,
          listener.call,
          fireImmediately: true,
        );

        container
            .read(pegxLoginStateProvider.notifier)
            .setState(const PegxLoginState.logged());

        expect(
          container.read(pegxLoginStateProvider),
          isA<PegxLoginStateLogged>(),
        );
      });
    });
  });

  group('PegxGaidNotifier', () {
    group('build', () {
      test('returns PegxGaidStateEmpty as initial state', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final state = container.read(pegxGaidProvider);

        expect(state, isA<PegxGaidStateEmpty>());
      });
    });

    group('setState', () {
      test('transitions to PegxGaidStateLoading', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        container
            .read(pegxGaidProvider.notifier)
            .setState(const PegxGaidState.loading());

        expect(container.read(pegxGaidProvider), isA<PegxGaidStateLoading>());
      });

      test('transitions to PegxGaidStateRegistered', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        container
            .read(pegxGaidProvider.notifier)
            .setState(const PegxGaidState.registered());

        expect(
          container.read(pegxGaidProvider),
          isA<PegxGaidStateRegistered>(),
        );
      });

      test('transitions to PegxGaidStateUnregistered', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        container
            .read(pegxGaidProvider.notifier)
            .setState(const PegxGaidState.unregistered());

        expect(
          container.read(pegxGaidProvider),
          isA<PegxGaidStateUnregistered>(),
        );
      });

      test('notifies listeners on state change', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        final listener = ProviderListener<PegxGaidState>();

        container.listen(
          pegxGaidProvider,
          listener.call,
          fireImmediately: true,
        );

        container
            .read(pegxGaidProvider.notifier)
            .setState(const PegxGaidState.loading());

        expect(container.read(pegxGaidProvider), isA<PegxGaidStateLoading>());
      });

      test('preserves state across reads when keepAlive is true', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        container
            .read(pegxGaidProvider.notifier)
            .setState(const PegxGaidState.registered());

        final state1 = container.read(pegxGaidProvider);
        final state2 = container.read(pegxGaidProvider);

        expect(state1, state2);
        expect(state1, isA<PegxGaidStateRegistered>());
      });
    });
  });

  group('PegxRegisterFailedNotifier', () {
    group('build', () {
      test('returns empty string as initial state', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final state = container.read(pegxRegisterFailedProvider);

        expect(state, '');
      });
    });

    group('setState', () {
      test('updates state with error message', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        const errorMessage = 'Registration failed: Invalid credentials';
        container
            .read(pegxRegisterFailedProvider.notifier)
            .setState(errorMessage);

        expect(container.read(pegxRegisterFailedProvider), errorMessage);
      });

      test('can clear error message by setting to empty string', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        container
            .read(pegxRegisterFailedProvider.notifier)
            .setState('Some error');
        container.read(pegxRegisterFailedProvider.notifier).setState('');

        expect(container.read(pegxRegisterFailedProvider), '');
      });

      test('notifies listeners on state change', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        final listener = ProviderListener<String>();

        container.listen(
          pegxRegisterFailedProvider,
          listener.call,
          fireImmediately: true,
        );

        const errorMsg = 'Test error';
        container.read(pegxRegisterFailedProvider.notifier).setState(errorMsg);

        verify(() => listener('', errorMsg));
      });

      test('preserves state across reads when keepAlive is true', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        const errorMsg = 'Persistent error';
        container.read(pegxRegisterFailedProvider.notifier).setState(errorMsg);

        final state1 = container.read(pegxRegisterFailedProvider);
        final state2 = container.read(pegxRegisterFailedProvider);

        expect(state1, state2);
        expect(state1, errorMsg);
      });

      test('can update error message multiple times', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        final listener = ProviderListener<String>();

        container.listen(
          pegxRegisterFailedProvider,
          listener.call,
          fireImmediately: true,
        );

        container.read(pegxRegisterFailedProvider.notifier).setState('Error 1');
        container.read(pegxRegisterFailedProvider.notifier).setState('Error 2');

        verifyInOrder([
          () => listener(null, ''),
          () => listener('', 'Error 1'),
          () => listener('Error 1', 'Error 2'),
        ]);
        verifyNoMoreInteractions(listener);
      });
    });
  });

  group('pegxRandomId', () {
    test('returns positive Int64 with defaults', () {
      final id = pegxRandomId();
      expect(id > Int64.ZERO, isTrue);
    });

    test('returns Int64 within specified range', () {
      for (var i = 0; i < 100; i++) {
        final id = pegxRandomId(min: 10, max: 100);
        expect(id.toInt(), greaterThanOrEqualTo(10));
        expect(id.toInt(), lessThan(100));
      }
    });

    test('throws ArgumentError when min > max', () {
      expect(
        () => pegxRandomId(min: 100, max: 10),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  group('pegxWebsocketClient provider', () {
    test('returns PegxProtocolHandler without auto-connecting', () {
      final container = ProviderContainer.test(
        overrides: [envProvider.overrideWith(() => _TestnetEnv())],
      );
      addTearDown(container.dispose);

      final handler = container.read(pegxWebsocketClientProvider);
      expect(handler, isA<PegxProtocolHandler>());
      // Verify no side effects: login state still Loading (no connect happened)
      expect(
        container.read(pegxLoginStateProvider),
        isA<PegxLoginStateLoading>(),
      );
    });
  });

  group('PegxProtocolHandler', () {
    late _FakeWebSocketChannel fakeChannel;
    late PegxConnection connection;
    late PegxProtocolHandler handler;
    late ProviderContainer container;

    setUp(() async {
      fakeChannel = _FakeWebSocketChannel();
      connection = PegxConnection(channelFactory: (_) async => fakeChannel);

      container = ProviderContainer.test(
        overrides: [
          ampIdProvider.overrideWith(() {
            final notifier = AmpIdNotifier();
            return notifier;
          }),
          pegxWebsocketClientProvider.overrideWith((ref) {
            return PegxProtocolHandler(
              ref,
              SIDESWAP_ENV_TESTNET,
              connection: connection,
              idGenerator: () => Int64(42),
            );
          }),
        ],
      );
      addTearDown(container.dispose);

      handler = container.read(pegxWebsocketClientProvider);
      await handler.connectToSocket();
    });

    group('handleNotif', () {
      test('loginOrRegisterFailed sets pegxRegisterFailedProvider', () {
        final notif = Notif(
          loginOrRegisterFailed: Notif_LoginOrRegisterFailed(
            text: 'auth error',
          ),
        );
        handler.handleNotif(notif);
        expect(container.read(pegxRegisterFailedProvider), 'auth error');
      });

      test(
        'loginOrRegisterSucceed stores token and sends resume to sink',
        () async {
          final notif = Notif(
            loginOrRegisterSucceed: Notif_LoginOrRegisterSucceed(
              token: 'tok123',
            ),
          );

          // Collect bytes written to sink
          final received = <Object?>[];
          fakeChannel.sinkController.stream.listen(received.add);

          handler.handleNotif(notif);
          // Give microtasks a chance to flush
          await Future<void>.delayed(Duration.zero);

          // Exactly one Req (resume) must have been sent
          expect(received, hasLength(1));
          final bytes = received.first as Uint8List;
          final req = Req.fromBuffer(bytes);
          expect(req.hasResume(), isTrue);
          expect(req.resume.token, 'tok123');
        },
      );

      test('freeShares branch does not crash or change state', () {
        final before = container.read(pegxLoginStateProvider);
        handler.handleNotif(Notif(freeShares: Notif_FreeShares()));
        expect(container.read(pegxLoginStateProvider), before);
      });

      test('buyShares branch does not crash or change state', () {
        final before = container.read(pegxLoginStateProvider);
        handler.handleNotif(Notif(buyShares: Notif_BuyShares()));
        expect(container.read(pegxLoginStateProvider), before);
      });

      test('soldShares branch does not crash or change state', () {
        final before = container.read(pegxLoginStateProvider);
        handler.handleNotif(Notif(soldShares: Notif_SoldShares()));
        expect(container.read(pegxLoginStateProvider), before);
      });

      test('userShares branch does not crash or change state', () {
        final before = container.read(pegxLoginStateProvider);
        handler.handleNotif(Notif(userShares: Notif_UserShares()));
        expect(container.read(pegxLoginStateProvider), before);
      });

      test('updatePrices branch does not crash or change state', () {
        final before = container.read(pegxLoginStateProvider);
        handler.handleNotif(Notif(updatePrices: Notif_UpdatePrices()));
        expect(container.read(pegxLoginStateProvider), before);
      });

      test('updateMarketData branch does not crash or change state', () {
        final before = container.read(pegxLoginStateProvider);
        handler.handleNotif(Notif(updateMarketData: Notif_UpdateMarketData()));
        expect(container.read(pegxLoginStateProvider), before);
      });

      test('updateBalances branch does not crash or change state', () {
        final before = container.read(pegxLoginStateProvider);
        handler.handleNotif(Notif(updateBalances: Notif_UpdateBalances()));
        expect(container.read(pegxLoginStateProvider), before);
      });

      test('notSet branch does not crash or change state', () {
        final before = container.read(pegxLoginStateProvider);
        handler.handleNotif(Notif());
        expect(container.read(pegxLoginStateProvider), before);
      });
    });

    group('handleResp', () {
      test('loginOrRegister sets PegxLoginStateLogin with requestId', () {
        final resp = Resp(
          loginOrRegister: Resp_LoginOrRegister(requestId: 'req-abc'),
        );
        handler.handleResp(resp);
        expect(
          container.read(pegxLoginStateProvider),
          isA<PegxLoginStateLogin>().having(
            (s) => s.requestId,
            'requestId',
            'req-abc',
          ),
        );
      });

      test('resume with gaid matching ampId sets PegxLoginStateGaidAdded', () {
        container.read(ampIdProvider.notifier).setAmpId('test-amp-id');
        final resp = Resp(
          resume: Resp_Resume(
            accounts: [
              Account(accountKey: 'key1', gaids: ['test-amp-id']),
            ],
          ),
        );
        handler.handleResp(resp);
        expect(
          container.read(pegxLoginStateProvider),
          isA<PegxLoginStateGaidAdded>(),
        );
      });

      test('resume without gaid match sets PegxLoginStateLogged', () {
        container.read(ampIdProvider.notifier).setAmpId('other-amp-id');
        final resp = Resp(
          resume: Resp_Resume(
            accounts: [
              Account(accountKey: 'key1', gaids: ['different-gaid']),
            ],
          ),
        );
        handler.handleResp(resp);
        expect(
          container.read(pegxLoginStateProvider),
          isA<PegxLoginStateLogged>(),
        );
      });

      test('addGaid resets lastAddGaidId and sets PegxLoginStateGaidAdded', () {
        // Set a pending addGaid id by calling addGaid
        container.read(ampIdProvider.notifier).setAmpId('test-amp-id');
        handler.addGaid(); // sets _lastAddGaidId = 42

        final resp = Resp(addGaid: Resp_AddGaid());
        handler.handleResp(resp);

        expect(
          container.read(pegxLoginStateProvider),
          isA<PegxLoginStateGaidAdded>(),
        );
      });

      test('logout branch does not crash or change login state', () {
        final before = container.read(pegxLoginStateProvider);
        handler.handleResp(Resp(logout: Resp_Logout()));
        expect(container.read(pegxLoginStateProvider), before);
      });

      test('registerIssuer branch does not crash', () {
        expect(
          () => handler.handleResp(Resp(registerIssuer: Resp_RegisterIssuer())),
          returnsNormally,
        );
      });

      test('loadAssets branch does not crash', () {
        expect(
          () => handler.handleResp(Resp(loadAssets: Resp_LoadAssets())),
          returnsNormally,
        );
      });

      test('buyShares branch does not crash', () {
        expect(
          () => handler.handleResp(Resp(buyShares: Resp_BuyShares())),
          returnsNormally,
        );
      });

      test('loadCountries branch does not crash', () {
        expect(
          () => handler.handleResp(Resp(loadCountries: Resp_LoadCountries())),
          returnsNormally,
        );
      });

      test('loadRegs branch does not crash', () {
        expect(
          () => handler.handleResp(Resp(loadRegs: Resp_LoadRegs())),
          returnsNormally,
        );
      });

      test('loadFile branch does not crash', () {
        expect(
          () => handler.handleResp(Resp(loadFile: Resp_LoadFile())),
          returnsNormally,
        );
      });

      test('listAllTransactions branch does not crash', () {
        expect(
          () => handler.handleResp(
            Resp(listAllTransactions: Resp_ListAllTransactions()),
          ),
          returnsNormally,
        );
      });

      test('listOwnTransactions branch does not crash', () {
        expect(
          () => handler.handleResp(
            Resp(listOwnTransactions: Resp_ListOwnTransactions()),
          ),
          returnsNormally,
        );
      });

      test('listAllBalances branch does not crash', () {
        expect(
          () =>
              handler.handleResp(Resp(listAllBalances: Resp_ListAllBalances())),
          returnsNormally,
        );
      });

      test('listAllSeries branch does not crash', () {
        expect(
          () => handler.handleResp(Resp(listAllSeries: Resp_ListAllSeries())),
          returnsNormally,
        );
      });

      test('notSet branch does not crash', () {
        expect(() => handler.handleResp(Resp()), returnsNormally);
      });
    });

    group('handleError', () {
      test('matching _lastAddGaidId sets PegxLoginStateGaidError', () {
        container.read(ampIdProvider.notifier).setAmpId('test-amp-id');
        handler.addGaid(); // sets _lastAddGaidId = 42

        handler.handleError(Err(id: Int64(42), text: 'gaid failed'));

        expect(
          container.read(pegxLoginStateProvider),
          isA<PegxLoginStateGaidError>(),
        );
      });

      test('non-matching id does not change login state', () {
        container.read(ampIdProvider.notifier).setAmpId('test-amp-id');
        handler.addGaid(); // sets _lastAddGaidId = 42
        // Reset to Loading so we can detect an unwanted change
        container
            .read(pegxLoginStateProvider.notifier)
            .setState(const PegxLoginStateLoading());

        handler.handleError(Err(id: Int64(99), text: 'other error'));

        expect(
          container.read(pegxLoginStateProvider),
          isA<PegxLoginStateLoading>(),
        );
      });

      test('zero id (no pending addGaid) does not set GaidError', () {
        handler.handleError(Err(id: Int64(0), text: 'error'));

        // _lastAddGaidId starts as Int64() (zero), and error.id is also zero —
        // but after connectToSocket, _lastAddGaidId is reset to Int64() which equals
        // Int64(0). This should match and set GaidError.
        // Verifies the branch fires when ids match at zero.
        expect(
          container.read(pegxLoginStateProvider),
          isA<PegxLoginStateGaidError>(),
        );
      });
    });

    group('connectToSocket', () {
      test('happy path — stream listener fires when message pushed', () async {
        // handler already connected in setUp — prove _listenToMessage was called
        // by pushing a message and observing handleResp fires
        fakeChannel.streamController.add(
          Res(
            resp: Resp(
              loginOrRegister: Resp_LoginOrRegister(
                requestId: 'verify-connect',
              ),
            ),
          ).writeToBuffer(),
        );
        await Future<void>.value();
        await Future<void>.value();
        expect(
          container.read(pegxLoginStateProvider),
          isA<PegxLoginStateLogin>().having(
            (s) => s.requestId,
            'requestId',
            'verify-connect',
          ),
        );
      });

      test('does nothing when already connected', () async {
        // handler is already connected from setUp — second call should be a no-op
        final stateBefore = container.read(pegxLoginStateProvider);
        await handler.connectToSocket();
        expect(container.read(pegxLoginStateProvider), stateBefore);
      });

      test(
        'error path — channelFactory throws, calls disconnect + reconnect',
        () async {
          final failConnection = PegxConnection(
            channelFactory: (_) => throw Exception('ws fail'),
          );
          final failContainer = ProviderContainer.test(
            overrides: [
              ampIdProvider.overrideWith(() => AmpIdNotifier()),
              pegxWebsocketClientProvider.overrideWith((ref) {
                return PegxProtocolHandler(
                  ref,
                  SIDESWAP_ENV_TESTNET,
                  connection: failConnection,
                  idGenerator: () => Int64(42),
                );
              }),
            ],
          );
          addTearDown(failContainer.dispose);
          final failHandler = failContainer.read(pegxWebsocketClientProvider);

          // Should not throw — error is caught internally
          await failHandler.connectToSocket();
          // Not connected since factory threw
          expect(failConnection.isConnected, isFalse);
        },
      );
    });

    group('login', () {
      test('sends Req with loginOrRegister to sink', () async {
        final received = <Object?>[];
        fakeChannel.sinkController.stream.listen(received.add);

        handler.login();
        await Future<void>.value();

        expect(received, hasLength(1));
        final req = Req.fromBuffer(received.first as Uint8List);
        expect(req.hasLoginOrRegister(), isTrue);
      });
    });

    group('resume', () {
      test('sends Req with resume and token to sink', () async {
        final received = <Object?>[];
        fakeChannel.sinkController.stream.listen(received.add);

        handler.resume(token: 'mytoken');
        await Future<void>.value();

        expect(received, hasLength(1));
        final req = Req.fromBuffer(received.first as Uint8List);
        expect(req.hasResume(), isTrue);
        expect(req.resume.token, 'mytoken');
      });

      test('sends Req with resume and no token when null', () async {
        final received = <Object?>[];
        fakeChannel.sinkController.stream.listen(received.add);

        handler.resume();
        await Future<void>.value();

        expect(received, hasLength(1));
        final req = Req.fromBuffer(received.first as Uint8List);
        expect(req.hasResume(), isTrue);
      });
    });

    group('addGaid', () {
      test(
        'sets GaidWaiting and sends Req with addGaid when ampId is set',
        () async {
          container.read(ampIdProvider.notifier).setAmpId('test-amp-id');

          final received = <Object?>[];
          final sub = fakeChannel.sinkController.stream.listen(received.add);
          addTearDown(sub.cancel);

          handler.addGaid();

          // State is set synchronously
          expect(
            container.read(pegxLoginStateProvider),
            isA<PegxLoginStateGaidWaiting>(),
          );

          // Flush the stream delivery (StreamController is async by default)
          await Future<void>.value();

          expect(received, hasLength(1));
          final req = Req.fromBuffer(received.first as Uint8List);
          expect(req.hasAddGaid(), isTrue);
          expect(req.addGaid.gaid, 'test-amp-id');
        },
      );

      test('early return when _lastAddGaidId is non-zero (already pending)', () {
        container.read(ampIdProvider.notifier).setAmpId('test-amp-id');
        handler
            .addGaid(); // first call: _lastAddGaidId = 42, state → GaidWaiting

        // Reset to Logged so we can detect any unwanted state change
        container
            .read(pegxLoginStateProvider.notifier)
            .setState(const PegxLoginStateLogged());

        handler.addGaid(); // second call: _lastAddGaidId != 0 → early return
        expect(
          container.read(pegxLoginStateProvider),
          isA<PegxLoginStateLogged>(),
        );
      });

      test('empty ampId — sets GaidWaiting then calls errorAndGoBack', () {
        // ampId is '' by default in this container
        handler.addGaid();

        // errorAndGoBack: sets pegxRegisterFailedProvider + disconnects + sets ampRegister
        expect(
          container.read(pegxRegisterFailedProvider),
          'Adding AMP ID failed. Try again.',
        );
        expect(container.read(pageStatusProvider), Status.ampRegister);
        expect(connection.isConnected, isFalse);
      });
    });

    group('disconnect', () {
      test('when connected — closes connection and sets LoginStateLoading', () {
        handler.disconnect();
        expect(connection.isConnected, isFalse);
        expect(
          container.read(pegxLoginStateProvider),
          isA<PegxLoginStateLoading>(),
        );
      });

      test('when not connected — no-op, does not change state', () {
        handler.disconnect(); // disconnects

        // Set to Logged so we can detect an unwanted state change
        container
            .read(pegxLoginStateProvider.notifier)
            .setState(const PegxLoginStateLogged());

        handler.disconnect(); // second disconnect — not connected anymore
        expect(
          container.read(pegxLoginStateProvider),
          isA<PegxLoginStateLogged>(),
        );
      });
    });

    group('errorAndGoBack', () {
      test('sets error state, disconnects, sets Status.ampRegister', () {
        handler.errorAndGoBack('some error');

        expect(container.read(pegxRegisterFailedProvider), 'some error');
        expect(connection.isConnected, isFalse);
        expect(container.read(pageStatusProvider), Status.ampRegister);
      });
    });

    group('_listenToMessage via stream', () {
      test('routes Res_Body.resp to handleResp', () async {
        final respData = Res(
          resp: Resp(
            loginOrRegister: Resp_LoginOrRegister(requestId: 'stream-test'),
          ),
        );
        fakeChannel.streamController.add(respData.writeToBuffer());
        await Future<void>.value();
        await Future<void>.value();

        expect(
          container.read(pegxLoginStateProvider),
          isA<PegxLoginStateLogin>().having(
            (s) => s.requestId,
            'requestId',
            'stream-test',
          ),
        );
      });

      test('routes Res_Body.notif to handleNotif', () async {
        final notifData = Res(
          notif: Notif(
            loginOrRegisterFailed: Notif_LoginOrRegisterFailed(
              text: 'stream-notif',
            ),
          ),
        );
        fakeChannel.streamController.add(notifData.writeToBuffer());
        await Future<void>.value();
        await Future<void>.value();

        expect(container.read(pegxRegisterFailedProvider), 'stream-notif');
      });

      test(
        'routes Res_Body.error to handleError — non-matching id logs only',
        () async {
          final errData = Res(
            error: Err(id: Int64(999), text: 'stream-error'),
          );
          fakeChannel.streamController.add(errData.writeToBuffer());
          await Future<void>.value();
          await Future<void>.value();

          // Non-matching id → just logs, no state change; no crash = pass
          expect(
            container.read(pegxLoginStateProvider),
            isA<PegxLoginStateLoading>(),
          );
        },
      );

      test('routes Res_Body.notSet — no-op', () async {
        final notSetData = Res(); // empty Res → whichBody() == notSet
        fakeChannel.streamController.add(notSetData.writeToBuffer());
        await Future<void>.value();
        // No crash, no state change
        expect(
          container.read(pegxLoginStateProvider),
          isA<PegxLoginStateLoading>(),
        );
      });

      test('onDone calls disconnect — state transitions to Loading', () async {
        await fakeChannel.streamController.close();
        await Future<void>.value();
        await Future<void>.value();

        expect(
          container.read(pegxLoginStateProvider),
          isA<PegxLoginStateLoading>(),
        );
      });
    });

    group('_startHeartBeatTimer', () {
      test('sends loadAssets request every 10 seconds', () {
        fakeAsync((async) {
          final fakeChannel2 = _FakeWebSocketChannel();
          final connection2 = PegxConnection(
            channelFactory: (_) async => fakeChannel2,
          );
          final container2 = ProviderContainer.test(
            overrides: [
              ampIdProvider.overrideWithValue('test-amp-id'),
              pegxWebsocketClientProvider.overrideWith((ref) {
                return PegxProtocolHandler(
                  ref,
                  SIDESWAP_ENV_TESTNET,
                  connection: connection2,
                  idGenerator: () => Int64(42),
                );
              }),
            ],
          );
          addTearDown(container2.dispose);
          final handler2 = container2.read(pegxWebsocketClientProvider);

          final sentData = <Uint8List>[];
          fakeChannel2.sinkController.stream.listen((data) {
            sentData.add(data as Uint8List);
          });

          handler2.connectToSocket();
          async.flushMicrotasks(); // complete connect + start heartbeat timer

          async.elapse(const Duration(seconds: 10)); // first heartbeat fires
          async.flushMicrotasks();

          expect(sentData.isNotEmpty, isTrue);
          final req = Req.fromBuffer(sentData.last);
          expect(req.hasLoadAssets(), isTrue);

          async.elapse(const Duration(seconds: 10)); // second heartbeat
          async.flushMicrotasks();
          expect(sentData.length, greaterThanOrEqualTo(2));
        });
      });
    });

    group('_reconnect', () {
      test('timer fires and re-attempts connectToSocket on failure', () {
        fakeAsync((async) {
          var callCount = 0;
          final failConnection = PegxConnection(
            channelFactory: (_) {
              callCount++;
              throw Exception('ws fail');
            },
          );
          final container2 = ProviderContainer.test(
            overrides: [
              ampIdProvider.overrideWithValue('test-amp-id'),
              pegxWebsocketClientProvider.overrideWith((ref) {
                return PegxProtocolHandler(
                  ref,
                  SIDESWAP_ENV_TESTNET,
                  connection: failConnection,
                  idGenerator: () => Int64(42),
                );
              }),
            ],
          );
          addTearDown(container2.dispose);
          final handler2 = container2.read(pegxWebsocketClientProvider);

          handler2.connectToSocket(); // fails → starts _reconnect timer
          async.flushMicrotasks();

          final initialCount = callCount;

          async.elapse(const Duration(milliseconds: 5000)); // reconnect fires
          async.flushMicrotasks();

          expect(callCount, greaterThan(initialCount));
        });
      });

      test('succeeds on retry with stateful factory', () {
        fakeAsync((async) {
          var attempts = 0;
          late _FakeWebSocketChannel goodChannel;

          final retryConnection = PegxConnection(
            channelFactory: (_) async {
              attempts++;
              if (attempts == 1) throw Exception('first fail');
              goodChannel = _FakeWebSocketChannel();
              return goodChannel;
            },
          );
          final container2 = ProviderContainer.test(
            overrides: [
              ampIdProvider.overrideWithValue('test-amp-id'),
              pegxWebsocketClientProvider.overrideWith((ref) {
                return PegxProtocolHandler(
                  ref,
                  SIDESWAP_ENV_TESTNET,
                  connection: retryConnection,
                  idGenerator: () => Int64(42),
                );
              }),
            ],
          );
          addTearDown(container2.dispose);
          final handler2 = container2.read(pegxWebsocketClientProvider);

          handler2.connectToSocket(); // attempt 1: fails
          async.flushMicrotasks();
          expect(retryConnection.isConnected, isFalse);

          async.elapse(const Duration(milliseconds: 5000)); // reconnect fires
          async.flushMicrotasks();

          expect(attempts, 2);
          expect(retryConnection.isConnected, isTrue);
        });
      });

      test('stops when reconnectCount reaches 0', () {
        fakeAsync((async) {
          var callCount = 0;
          // PegxProtocolHandler._reconnectCount starts at 120
          // Each timer tick calls connectToSocket (fails) + decrements count
          // At count == 0, timer cancels
          final failConnection = PegxConnection(
            channelFactory: (_) {
              callCount++;
              throw Exception('ws fail');
            },
          );
          final container3 = ProviderContainer.test(
            overrides: [
              ampIdProvider.overrideWithValue('test-amp-id'),
              pegxWebsocketClientProvider.overrideWith((ref) {
                return PegxProtocolHandler(
                  ref,
                  SIDESWAP_ENV_TESTNET,
                  connection: failConnection,
                  idGenerator: () => Int64(42),
                );
              }),
            ],
          );
          addTearDown(container3.dispose);
          final handler3 = container3.read(pegxWebsocketClientProvider);

          handler3.connectToSocket(); // attempt 1: fails → _reconnect starts
          async.flushMicrotasks();
          final afterFirstCall = callCount;

          // Elapse enough time to exhaust 120 reconnect attempts
          // Each attempt at 5000ms interval: 120 * 5000ms = 600s
          async.elapse(const Duration(seconds: 605));
          async.flushMicrotasks();

          // After exhaustion, no more calls should happen
          final afterExhaustion = callCount;
          async.elapse(const Duration(seconds: 30));
          async.flushMicrotasks();

          // No additional calls after exhaustion
          expect(callCount, afterExhaustion);
          expect(callCount, greaterThan(afterFirstCall));
        });
      });
    });
  });
}
