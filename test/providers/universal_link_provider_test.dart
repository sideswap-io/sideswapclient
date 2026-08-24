import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:fpdart/fpdart.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/riverpod.dart';
import 'package:sideswap/common/enums.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/models/connection_models.dart';
import 'package:sideswap/providers/bip32_providers.dart';
import 'package:sideswap/providers/connection_state_providers.dart';
import 'package:sideswap/providers/payment_provider.dart';
import 'package:sideswap/providers/ui_state_args_provider.dart';
import 'package:sideswap/providers/universal_link_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart'
    show pageStatusProvider, Status;
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap_logger/custom_logger.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

import '../utils.dart';

class MockAppLinks extends Mock implements AppLinks {}

class _NoOpLogOutput extends LogOutput {
  @override
  void output(OutputEvent event) {}
}

class _FakeSideswapWallet extends Fake implements SideswapWallet {
  @override
  void sendMsg(To to) {}
}

void _setDesktopFlavor() {
  FlavorConfig(
    flavor: Flavor.production,
    values: FlavorValues(
      enableNetworkSettings: false,
      enableJade: false,
      enableLocalEndpoint: false,
      isDesktop: true,
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    logger = CustomLogger('SideSwap', output: _NoOpLogOutput());
    registerFallbackValue(LinkResultState.empty());
  });

  group('UniversalLinkResultStateNotifier', () {
    group('build', () {
      test('returns empty state as initial state', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final state = container.read(universalLinkResultStateProvider);
        expect(state, isA<LinkResultStateEmpty>());
      });
    });

    group('setState', () {
      test('updates state to provided LinkResultState', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final listener = ProviderListener<LinkResultState>();
        container.listen(
          universalLinkResultStateProvider,
          listener.call,
          fireImmediately: true,
        );

        final newState = LinkResultState.failed();
        container
            .read(universalLinkResultStateProvider.notifier)
            .setState(newState);

        // Verify that listener was called twice: once for initial state, once for update
        verify(() => listener(any(), any())).called(2);
      });

      test('preserves state type through multiple updates', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        var state1 = LinkResultState.unknown();
        container
            .read(universalLinkResultStateProvider.notifier)
            .setState(state1);
        expect(container.read(universalLinkResultStateProvider), state1);

        var state2 = LinkResultState.unknownUri();
        container
            .read(universalLinkResultStateProvider.notifier)
            .setState(state2);
        expect(container.read(universalLinkResultStateProvider), state2);
      });
    });
  });

  group('getSendLinkUrl', () {
    test('constructs correct send link URL with address', () {
      final url = getSendLinkUrl('bc1qw508d6qejxtdg4y5r3zarvary0c5xw7kv8f3t4');
      expect(
        url,
        'https://app.sideswap.io/send/?address=bc1qw508d6qejxtdg4y5r3zarvary0c5xw7kv8f3t4',
      );
    });

    test('handles empty address', () {
      final url = getSendLinkUrl('');
      expect(url, 'https://app.sideswap.io/send/?address=');
    });

    test('handles special characters in address', () {
      final url = getSendLinkUrl('address%with%special');
      expect(url, 'https://app.sideswap.io/send/?address=address%with%special');
    });
  });

  group('LinkResultState union types', () {
    test('creates empty state', () {
      final state = LinkResultState.empty();
      expect(state, isA<LinkResultStateEmpty>());
    });

    test('creates unknown state', () {
      final state = LinkResultState.unknown();
      expect(state, isA<LinkResultStateUnknown>());
    });

    test('creates unknownUri state', () {
      final state = LinkResultState.unknownUri();
      expect(state, isA<LinkResultStateUnknownUri>());
    });

    test('creates unknownScheme state', () {
      final state = LinkResultState.unknownScheme();
      expect(state, isA<LinkResultStateUnknownScheme>());
    });

    test('creates unknownHost state', () {
      final state = LinkResultState.unknownHost();
      expect(state, isA<LinkResultStateUnknownHost>());
    });

    test('creates failed state', () {
      final state = LinkResultState.failed();
      expect(state, isA<LinkResultStateFailed>());
    });

    test('creates failedUriPath state', () {
      final state = LinkResultState.failedUriPath();
      expect(state, isA<LinkResultStateFailedUriPath>());
    });

    test('creates success state without details', () {
      final state = LinkResultState.success();
      expect(state, isA<LinkResultStateSuccess>());
    });

    test('creates success state with swap details', () {
      final details = LinkResultDetails.swap(orderId: '123', privateId: 'abc');
      final state = LinkResultState.success(details: details);
      expect(state, isA<LinkResultStateSuccess>());
      if (state is LinkResultStateSuccess) {
        expect(state.details, details);
      }
    });

    test('creates success state with swaption details', () {
      final uri = Uri.parse('https://example.com');
      final details = LinkResultDetails.swaption(uri: uri);
      final state = LinkResultState.success(details: details);
      expect(state, isA<LinkResultStateSuccess>());
      if (state is LinkResultStateSuccess) {
        expect(state.details, details);
      }
    });
  });

  group('LinkResultDetails union types', () {
    test('creates swap details with orderId and privateId', () {
      final details = LinkResultDetails.swap(
        orderId: '12345',
        privateId: 'secret',
      );
      expect(details, isA<LinkResultDetailsSwap>());
      if (details is LinkResultDetailsSwap) {
        expect(details.orderId, '12345');
        expect(details.privateId, 'secret');
      }
    });

    test('creates swap details with only orderId', () {
      final details = LinkResultDetails.swap(orderId: '12345');
      expect(details, isA<LinkResultDetailsSwap>());
      if (details is LinkResultDetailsSwap) {
        expect(details.orderId, '12345');
        expect(details.privateId, isNull);
      }
    });

    test('creates swaption details with uri', () {
      final uri = Uri.parse('liquidconnect://test?id=123');
      final details = LinkResultDetails.swaption(uri: uri);
      expect(details, isA<LinkResultDetailsSwaption>());
      if (details is LinkResultDetailsSwaption) {
        expect(details.uri, uri);
      }
    });

    test('creates swaption details without uri', () {
      final details = LinkResultDetails.swaption();
      expect(details, isA<LinkResultDetailsSwaption>());
      if (details is LinkResultDetailsSwaption) {
        expect(details.uri, isNull);
      }
    });
  });

  group('UniversalLink - pure methods', () {
    late ProviderContainer container;
    late UniversalLink sut;

    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
      // Access the provider to get the UniversalLink instance
      sut = container.read(universalLinkProvider);
    });

    group('getDouble', () {
      test('parses valid double from query parameters', () {
        final uri = Uri.parse('https://example.com?price=19.99');
        final result = sut.getDouble(uri, 'price');
        expect(result, 19.99);
      });

      test('returns null for missing parameter', () {
        final uri = Uri.parse('https://example.com');
        final result = sut.getDouble(uri, 'price');
        expect(result, isNull);
      });

      test('returns null for non-numeric value', () {
        final uri = Uri.parse('https://example.com?price=abc');
        final result = sut.getDouble(uri, 'price');
        expect(result, isNull);
      });

      test('parses zero', () {
        final uri = Uri.parse('https://example.com?price=0');
        final result = sut.getDouble(uri, 'price');
        expect(result, 0.0);
      });

      test('parses negative values', () {
        final uri = Uri.parse('https://example.com?price=-15.5');
        final result = sut.getDouble(uri, 'price');
        expect(result, -15.5);
      });

      test('parses large numbers', () {
        final uri = Uri.parse('https://example.com?price=1000000.12345');
        final result = sut.getDouble(uri, 'price');
        expect(result, 1000000.12345);
      });
    });

    group('handleSwapPrompt - pure parsing logic', () {
      test('returns success with both order_id and private_id present', () {
        final uri = Uri.parse(
          'https://app.sideswap.io/swap/?order_id=12345&private_id=abc123',
        );
        final result = sut.handleSwapPrompt(uri);

        expect(result, isA<LinkResultStateSuccess>());
        if (result is LinkResultStateSuccess) {
          final details = result.details;
          if (details is LinkResultDetailsSwap) {
            expect(details.orderId, '12345');
            expect(details.privateId, 'abc123');
          }
        }
      });

      test('returns success with order_id but empty private_id', () {
        final uri = Uri.parse('https://app.sideswap.io/swap/?order_id=12345');
        final result = sut.handleSwapPrompt(uri);

        expect(result, isA<LinkResultStateSuccess>());
        if (result is LinkResultStateSuccess) {
          final details = result.details;
          if (details is LinkResultDetailsSwap) {
            expect(details.orderId, '12345');
            expect(details.privateId, '');
          }
        }
      });

      test('returns failed when order_id is missing', () {
        final uri = Uri.parse(
          'https://app.sideswap.io/swap/?private_id=abc123',
        );
        final result = sut.handleSwapPrompt(uri);

        expect(result, isA<LinkResultStateFailed>());
      });

      test('returns failed when order_id is empty string', () {
        final uri = Uri.parse('https://app.sideswap.io/swap/?order_id=');
        final result = sut.handleSwapPrompt(uri);

        expect(result, isA<LinkResultStateFailed>());
      });

      test('extracts order_id from multiple query parameters', () {
        final uri = Uri.parse(
          'https://app.sideswap.io/swap/?order_id=999&private_id=xyz&extra=param',
        );
        final result = sut.handleSwapPrompt(uri);

        expect(result, isA<LinkResultStateSuccess>());
        if (result is LinkResultStateSuccess) {
          final details = result.details;
          if (details is LinkResultDetailsSwap) {
            expect(details.orderId, '999');
            expect(details.privateId, 'xyz');
          }
        }
      });

      test('handles special characters in order_id', () {
        final uri = Uri.parse(
          'https://app.sideswap.io/swap/?order_id=abc-def-123&private_id=secret',
        );
        final result = sut.handleSwapPrompt(uri);

        expect(result, isA<LinkResultStateSuccess>());
        if (result is LinkResultStateSuccess) {
          final details = result.details;
          if (details is LinkResultDetailsSwap) {
            expect(details.orderId, 'abc-def-123');
          }
        }
      });
    });

    group('handleSubmitOrder', () {
      test('always returns failed state', () {
        final uri = Uri.parse('https://app.sideswap.io/submit/?order_id=123');
        final result = sut.handleSubmitOrder(uri);

        expect(result, isA<LinkResultStateFailed>());
      });

      test('ignores query parameters', () {
        final uri = Uri.parse('https://app.sideswap.io/submit/?a=1&b=2&c=3');
        final result = sut.handleSubmitOrder(uri);

        expect(result, isA<LinkResultStateFailed>());
      });
    });

    group('handleSwapLinkResult - callback invocation', () {
      test('returns false for non-success states', () {
        final states = [
          LinkResultState.empty(),
          LinkResultState.unknown(),
          LinkResultState.unknownUri(),
          LinkResultState.unknownScheme(),
          LinkResultState.unknownHost(),
          LinkResultState.failed(),
          LinkResultState.failedUriPath(),
        ];

        for (final state in states) {
          var callbackCalled = false;
          final result = sut.handleSwapLinkResult(state, (id, priv) {
            callbackCalled = true;
          });

          expect(result, false, reason: 'Should return false for $state');
          expect(
            callbackCalled,
            false,
            reason: 'Callback should not be called for $state',
          );
        }
      });

      test('returns false for success state without details', () {
        final state = LinkResultState.success();
        var callbackCalled = false;

        final result = sut.handleSwapLinkResult(state, (id, priv) {
          callbackCalled = true;
        });

        expect(result, false);
        expect(callbackCalled, false);
      });

      test('returns false for success state with swaption details', () {
        final state = LinkResultState.success(
          details: LinkResultDetails.swaption(
            uri: Uri.parse('https://test.com'),
          ),
        );
        var callbackCalled = false;

        final result = sut.handleSwapLinkResult(state, (id, priv) {
          callbackCalled = true;
        });

        expect(result, false);
        expect(callbackCalled, false);
      });

      test('returns false when orderId is missing in swap details', () {
        final state = LinkResultState.success(
          details: LinkResultDetails.swap(privateId: 'private123'),
        );
        var callbackCalled = false;

        final result = sut.handleSwapLinkResult(state, (id, priv) {
          callbackCalled = true;
        });

        expect(result, false);
        expect(callbackCalled, false);
      });

      test('returns false when privateId is missing in swap details', () {
        final state = LinkResultState.success(
          details: LinkResultDetails.swap(orderId: '12345'),
        );
        var callbackCalled = false;

        final result = sut.handleSwapLinkResult(state, (id, priv) {
          callbackCalled = true;
        });

        expect(result, false);
        expect(callbackCalled, false);
      });

      test('invokes callback with parsed orderId and privateId', () {
        final state = LinkResultState.success(
          details: LinkResultDetails.swap(
            orderId: '9876543210',
            privateId: 'private_abc',
          ),
        );
        Int64? capturedOrderId;
        String? capturedPrivateId;

        final result = sut.handleSwapLinkResult(state, (id, priv) {
          capturedOrderId = id;
          capturedPrivateId = priv;
        });

        expect(result, true);
        expect(capturedOrderId, Int64(9876543210));
        expect(capturedPrivateId, 'private_abc');
      });

      test('invokes callback with large orderId value', () {
        final largeOrderId = '9223372036854775807'; // Max Int64
        final state = LinkResultState.success(
          details: LinkResultDetails.swap(
            orderId: largeOrderId,
            privateId: 'private123',
          ),
        );
        Int64? capturedOrderId;

        final result = sut.handleSwapLinkResult(state, (id, priv) {
          capturedOrderId = id;
        });

        expect(result, true);
        expect(capturedOrderId, Int64.parseRadix(largeOrderId, 10));
      });

      test('invokes callback with zero orderId', () {
        final state = LinkResultState.success(
          details: LinkResultDetails.swap(
            orderId: '0',
            privateId: 'private123',
          ),
        );
        Int64? capturedOrderId;

        final result = sut.handleSwapLinkResult(state, (id, priv) {
          capturedOrderId = id;
        });

        expect(result, true);
        expect(capturedOrderId, Int64(0));
      });

      test('invokes callback with negative orderId', () {
        final state = LinkResultState.success(
          details: LinkResultDetails.swap(
            orderId: '-12345',
            privateId: 'private123',
          ),
        );
        Int64? capturedOrderId;

        final result = sut.handleSwapLinkResult(state, (id, priv) {
          capturedOrderId = id;
        });

        expect(result, true);
        expect(capturedOrderId, Int64(-12345));
      });

      test('invokes callback with empty privateId', () {
        final state = LinkResultState.success(
          details: LinkResultDetails.swap(orderId: '12345', privateId: ''),
        );
        String? capturedPrivateId;

        final result = sut.handleSwapLinkResult(state, (id, priv) {
          capturedPrivateId = priv;
        });

        expect(result, true);
        expect(capturedPrivateId, '');
      });

      test('invokes callback with special characters in privateId', () {
        final state = LinkResultState.success(
          details: LinkResultDetails.swap(
            orderId: '12345',
            privateId: 'priv@te_id-123!',
          ),
        );
        String? capturedPrivateId;

        final result = sut.handleSwapLinkResult(state, (id, priv) {
          capturedPrivateId = priv;
        });

        expect(result, true);
        expect(capturedPrivateId, 'priv@te_id-123!');
      });

      test('returns false and logs error for non-numeric orderId', () {
        final state = LinkResultState.success(
          details: LinkResultDetails.swap(
            orderId: 'not-a-number',
            privateId: 'priv',
          ),
        );
        var callbackCalled = false;

        final result = sut.handleSwapLinkResult(state, (id, priv) {
          callbackCalled = true;
        });

        expect(result, false);
        expect(callbackCalled, false);
      });

      test('returns false for orderId with mixed alphanumeric', () {
        final state = LinkResultState.success(
          details: LinkResultDetails.swap(orderId: '123abc', privateId: 'priv'),
        );

        final result = sut.handleSwapLinkResult(state, (_, _) {});

        expect(result, false);
      });
    });

    group('handleAppUrlStr - URI parsing and delegation', () {
      test('parses valid URI string and delegates to handleAppUri', () {
        final uriStr =
            'https://app.sideswap.io/swap/?order_id=555&private_id=xyz';
        final result = sut.handleAppUrlStr(uriStr);

        expect(result, isA<LinkResultStateSuccess>());
        if (result is LinkResultStateSuccess) {
          final details = result.details;
          if (details is LinkResultDetailsSwap) {
            expect(details.orderId, '555');
            expect(details.privateId, 'xyz');
          }
        }
      });

      test('returns unknownUri for unparseable string', () {
        final result = sut.handleAppUrlStr('not a valid uri:::/');
        expect(result, isA<LinkResultStateUnknownUri>());
      });

      test('returns unknownScheme for empty string', () {
        final result = sut.handleAppUrlStr('');
        expect(result, isA<LinkResultStateUnknownScheme>());
      });

      test('respects handleSwaption parameter when true', () {
        final container = ProviderContainer.test(
          overrides: [walletProvider.overrideWithValue(_FakeSideswapWallet())],
        );
        addTearDown(container.dispose);
        final localSut = container.read(universalLinkProvider);
        final uriStr = 'liquidconnect://test?id=123';
        final result = localSut.handleAppUrlStr(uriStr, handleSwaption: true);
        expect(result, isA<LinkResultStateSuccess>());
      });

      test('handles send link URI', () {
        final uriStr = 'https://app.sideswap.io/send/?address=bc1qtest123';
        final result = sut.handleAppUrlStr(uriStr);
        expect(result, isA<LinkResultStateSuccess>());
      });
    });

    group('handleAppUri - routing logic', () {
      test('routes https swap path correctly', () {
        final uri = Uri.parse(
          'https://app.sideswap.io/swap/?order_id=111&private_id=abc',
        );
        final result = sut.handleAppUri(uri);

        expect(result, isA<LinkResultStateSuccess>());
        if (result is LinkResultStateSuccess) {
          final details = result.details;
          if (details is LinkResultDetailsSwap) {
            expect(details.orderId, '111');
          }
        }
      });

      test('routes https login path', () {
        final uri = Uri.parse('https://app.sideswap.io/login/?id=test123');
        final result = sut.handleAppUri(uri, handleSwaption: false);
        expect(result, isA<LinkResultStateSuccess>());
      });

      test('routes https sign path', () {
        final uri = Uri.parse('https://app.sideswap.io/sign/?id=test456');
        final result = sut.handleAppUri(uri, handleSwaption: false);
        expect(result, isA<LinkResultStateSuccess>());
      });

      test('routes submit path to failed', () {
        final uri = Uri.parse('https://app.sideswap.io/submit/?id=123');
        final result = sut.handleAppUri(uri);
        expect(result, isA<LinkResultStateFailed>());
      });

      test('routes unknown path to failedUriPath', () {
        final uri = Uri.parse('https://app.sideswap.io/unknown/');
        final result = sut.handleAppUri(uri);
        expect(result, isA<LinkResultStateFailedUriPath>());
      });

      test('rejects non-sideswap host', () {
        final uri = Uri.parse('https://other-domain.io/swap/?order_id=123');
        final result = sut.handleAppUri(uri);
        expect(result, isA<LinkResultStateUnknownHost>());
      });

      test('rejects non-https/liquidconnect scheme', () {
        final uri = Uri.parse('http://app.sideswap.io/swap/?order_id=123');
        final result = sut.handleAppUri(uri);
        expect(result, isA<LinkResultStateUnknownScheme>());
      });

      test('handles liquidconnect scheme', () {
        final uri = Uri.parse('liquidconnect://test?id=123');
        final result = sut.handleAppUri(uri, handleSwaption: false);
        expect(result, isA<LinkResultStateSuccess>());
      });

      test('routes send path', () {
        final uri = Uri.parse('https://app.sideswap.io/send/?address=addr123');
        final result = sut.handleAppUri(uri);
        expect(result, isA<LinkResultStateSuccess>());
      });

      test('respects handleSwaption flag when false', () {
        final uri = Uri.parse('liquidconnect://test');
        final resultWithFlag = sut.handleAppUri(uri, handleSwaption: false);
        expect(resultWithFlag, isA<LinkResultStateSuccess>());
      });
    });

    group('handleSendLink - payment page state updates', () {
      late ProviderContainer container;
      late UniversalLink sut;

      setUp(() {
        container = ProviderContainer.test();
        addTearDown(container.dispose);
        sut = container.read(universalLinkProvider);
      });

      test('sets payment amount page arguments and status on valid address', () {
        final uri = Uri.parse(
          'https://app.sideswap.io/send/?address=bc1qw508d6qejxtdg4y5r3zarvary0c5xw7kv8f3t4',
        );
        final result = sut.handleSendLink(uri);

        expect(result, isA<LinkResultStateSuccess>());

        // Verify provider state was updated
        final args = container.read(paymentAmountPageArgumentsProvider);
        expect(
          args.result?.address,
          'bc1qw508d6qejxtdg4y5r3zarvary0c5xw7kv8f3t4',
        );

        final status = container.read(pageStatusProvider);
        expect(status, Status.paymentAmountPage);
      });

      test('returns failed when address is missing', () {
        final uri = Uri.parse('https://app.sideswap.io/send/');
        final result = sut.handleSendLink(uri);

        expect(result, isA<LinkResultStateFailed>());
      });

      test('returns failed when address parameter is null', () {
        final uri = Uri.parse('https://app.sideswap.io/send/?other=param');
        final result = sut.handleSendLink(uri);

        expect(result, isA<LinkResultStateFailed>());
      });

      test('sets page status to paymentAmountPage', () {
        final uri = Uri.parse(
          'https://app.sideswap.io/send/?address=test_address',
        );
        sut.handleSendLink(uri);

        final status = container.read(pageStatusProvider);
        expect(status, Status.paymentAmountPage);
      });

      test('preserves address in payment arguments on success', () {
        final testAddress = 'special-address-123';
        final uri = Uri.parse(
          'https://app.sideswap.io/send/?address=$testAddress',
        );
        sut.handleSendLink(uri);

        final args = container.read(paymentAmountPageArgumentsProvider);
        expect(args.result?.address, testAddress);
      });
    });

    group('handleSigner - wallet integration', () {
      late ProviderContainer container;
      late UniversalLink sut;
      late _FakeSideswapWallet fakeWallet;

      setUp(() {
        fakeWallet = _FakeSideswapWallet();
        container = ProviderContainer.test(
          overrides: [walletProvider.overrideWithValue(fakeWallet)],
        );
        addTearDown(container.dispose);
        sut = container.read(universalLinkProvider);
      });

      test('returns success with swaption uri when handleSwaption is true', () {
        final uri = Uri.parse('liquidconnect://test?id=123');
        final result = sut.handleSigner(uri, handleSwaption: true);

        expect(result, isA<LinkResultStateSuccess>());
        if (result is LinkResultStateSuccess) {
          final details = result.details;
          if (details is LinkResultDetailsSwaption) {
            expect(details.uri, uri);
          }
        }
      });

      test('returns success with https signer uri', () {
        final uri = Uri.parse('https://app.sideswap.io/login/?token=abc123');
        final result = sut.handleSigner(uri, handleSwaption: true);

        expect(result, isA<LinkResultStateSuccess>());
        if (result is LinkResultStateSuccess) {
          final details = result.details;
          if (details is LinkResultDetailsSwaption) {
            expect(details.uri, uri);
          }
        }
      });

      test('does not send message when handleSwaption is false', () {
        final uri = Uri.parse('liquidconnect://test?id=123');
        final result = sut.handleSigner(uri, handleSwaption: false);

        expect(result, isA<LinkResultStateSuccess>());
      });
    });

    group('handleApp2App - error paths', () {
      final errorCases = [
        (
          name: 'missing addressType',
          uri: 'https://app.sideswap.io/app2app/?address=test',
        ),
        (
          name: 'invalid addressType',
          uri:
              'https://app.sideswap.io/app2app/?addressType=invalid&address=test',
        ),
        (
          name: 'missing address',
          uri: 'https://app.sideswap.io/app2app/?addressType=bitcoin',
        ),
      ];
      for (final c in errorCases) {
        test('returns failed for ${c.name}', () {
          final result = sut.handleApp2App(Uri.parse(c.uri));
          expect(result, isA<LinkResultStateFailed>());
        });
      }
    });

    group('handleApp2App - parseBIP21 integration', () {
      test('returns unknownScheme when parseBIP21 returns Left', () {
        // fakeAddress for ?address=testaddr&addressType=bitcoin → 'bitcoin:testaddr?'
        // Mirrors lib L276: '${addressType.asString()}:$address?' with no extra params.
        final container = ProviderContainer.test(
          overrides: [
            parseBIP21Provider(
              'bitcoin:testaddr?',
              BIP21AddressTypeEnum.bitcoin,
            ).overrideWithValue(
              Left<Exception, BIP21Result>(Exception('parse error')),
            ),
          ],
        );
        addTearDown(container.dispose);
        final localSut = container.read(universalLinkProvider);

        final uri = Uri.parse(
          'https://app.sideswap.io/app2app/?address=testaddr&addressType=bitcoin',
        );
        final result = localSut.handleApp2App(uri);
        expect(result, isA<LinkResultStateUnknownScheme>());
      });

      test('sets payment args and returns success when parseBIP21 returns Right', () {
        final bip21Result = BIP21Result(
          amount: 0.001,
          label: 'test label',
          message: 'test msg',
          assetId: 'asset123',
          ticker: 'BTC',
          address: 'testaddr',
          addressType: BIP21AddressTypeEnum.bitcoin,
        );
        // fakeAddress: 'bitcoin:testaddr?&amount=0.001'
        // Construction mirrors lib L276-283:
        //   '${addressType.asString()}:$address?' then append '&$key=${query[key]}'
        //   for each query param that is not 'address' or 'addressType'.
        // URI has ?address=testaddr&addressType=bitcoin&amount=0.001, so the
        // only extra param is 'amount=0.001', yielding 'bitcoin:testaddr?&amount=0.001'.
        final fakeAddress = 'bitcoin:testaddr?&amount=0.001';
        final container = ProviderContainer.test(
          overrides: [
            parseBIP21Provider(
              fakeAddress,
              BIP21AddressTypeEnum.bitcoin,
            ).overrideWithValue(Right<Exception, BIP21Result>(bip21Result)),
          ],
        );
        addTearDown(container.dispose);
        final localSut = container.read(universalLinkProvider);

        final uri = Uri.parse(
          'https://app.sideswap.io/app2app/?address=testaddr&addressType=bitcoin&amount=0.001',
        );
        final result = localSut.handleApp2App(uri);

        expect(result, isA<LinkResultStateSuccess>());
        expect(container.read(pageStatusProvider), Status.paymentAmountPage);
        final args = container.read(paymentAmountPageArgumentsProvider);
        expect(args.result?.address, 'testaddr');
        expect(args.result?.addressType, BIP21AddressTypeEnum.bitcoin);
        expect(args.result?.amount, 0.001);
        expect(args.result?.ticker, 'BTC');
      });
    });
  });
  group('handleIncomingLinks', () {
    late MockAppLinks mockAppLinks;

    setUp(() {
      mockAppLinks = MockAppLinks();
    });

    test('returns early when universalLinksAvailable is false', () {
      // isDesktop=false; test platform is not Android/iOS → universalLinksAvailable()=false.
      FlavorConfig(
        flavor: Flavor.production,
        values: FlavorValues(
          enableNetworkSettings: false,
          enableJade: false,
          enableLocalEndpoint: false,
          isDesktop: false,
        ),
      );
      final container = ProviderContainer.test(
        overrides: [
          universalLinkProvider.overrideWith((ref) {
            return UniversalLink(
              ref.watch(uiStateArgsProvider),
              ref,
              appLinks: mockAppLinks,
            );
          }),
        ],
      );
      addTearDown(container.dispose);
      final sut = container.read(universalLinkProvider);

      sut.handleIncomingLinks();

      // verifyNever is sufficient — uriLinkStream was never accessed.
      verifyNever(() => mockAppLinks.uriLinkStream);
    });

    test(
      'stream emits URI when server is logged in → handleAppUri called',
      () async {
        _setDesktopFlavor();
        final streamController = StreamController<Uri>();
        addTearDown(() => streamController.close());
        when(
          () => mockAppLinks.uriLinkStream,
        ).thenAnswer((_) => streamController.stream);

        final container = ProviderContainer.test(
          overrides: [
            serverLoginProvider.overrideWith(() => ServerLoginNotifier()),
            universalLinkProvider.overrideWith((ref) {
              return UniversalLink(
                ref.watch(uiStateArgsProvider),
                ref,
                appLinks: mockAppLinks,
              );
            }),
          ],
        );
        addTearDown(container.dispose);
        container
            .read(serverLoginProvider.notifier)
            .setServerLoginState(const ServerLoginStateLogin());

        final sut = container.read(universalLinkProvider);
        sut.handleIncomingLinks();

        final testUri = Uri.parse(
          'https://app.sideswap.io/swap/?order_id=42&private_id=abc',
        );
        streamController.add(testUri);
        await Future<void>.delayed(Duration.zero);

        expect(sut.latestUri, testUri);
        expect(
          container.read(universalLinkResultStateProvider),
          isA<LinkResultStateSuccess>(),
        );

        await streamController.close();
      },
    );

    test(
      'stream emits URI when server NOT logged in → stores as initialUri',
      () async {
        _setDesktopFlavor();
        final streamController = StreamController<Uri>();
        addTearDown(() => streamController.close());
        when(
          () => mockAppLinks.uriLinkStream,
        ).thenAnswer((_) => streamController.stream);

        final container = ProviderContainer.test(
          overrides: [
            universalLinkProvider.overrideWith((ref) {
              return UniversalLink(
                ref.watch(uiStateArgsProvider),
                ref,
                appLinks: mockAppLinks,
              );
            }),
          ],
        );
        addTearDown(container.dispose);
        // default serverLoginProvider state is logout

        final sut = container.read(universalLinkProvider);
        sut.handleIncomingLinks();

        final testUri = Uri.parse(
          'https://app.sideswap.io/swap/?order_id=99&private_id=xyz',
        );
        streamController.add(testUri);
        await Future<void>.delayed(Duration.zero);

        expect(sut.latestUri, testUri);
        expect(sut.initialUri, testUri);
        // state unchanged (still empty)
        expect(
          container.read(universalLinkResultStateProvider),
          isA<LinkResultStateEmpty>(),
        );

        await streamController.close();
      },
    );

    test('stream error → latestUri set to null', () async {
      _setDesktopFlavor();
      final streamController = StreamController<Uri>();
      addTearDown(() => streamController.close());
      when(
        () => mockAppLinks.uriLinkStream,
      ).thenAnswer((_) => streamController.stream);

      final container = ProviderContainer.test(
        overrides: [
          universalLinkProvider.overrideWith((ref) {
            return UniversalLink(
              ref.watch(uiStateArgsProvider),
              ref,
              appLinks: mockAppLinks,
            );
          }),
        ],
      );
      addTearDown(container.dispose);

      final sut = container.read(universalLinkProvider);
      sut.handleIncomingLinks();

      final testUri = Uri.parse('https://app.sideswap.io/swap/?order_id=1');
      streamController.add(testUri);
      await Future<void>.delayed(Duration.zero);
      expect(sut.latestUri, testUri);

      streamController.addError(Exception('stream error'));
      await Future<void>.delayed(Duration.zero);
      expect(sut.latestUri, isNull);

      await streamController.close();
    });
  });

  group('handleInitialUri', () {
    late MockAppLinks mockAppLinks;

    setUp(() {
      FlavorConfig(
        flavor: Flavor.production,
        values: FlavorValues(
          enableNetworkSettings: false,
          enableJade: false,
          enableLocalEndpoint: false,
          isDesktop: false,
        ),
      );
      mockAppLinks = MockAppLinks();
    });

    test('returns early when universalLinksAvailable is false', () async {
      // setUp sets isDesktop: false — no override needed here.
      final container = ProviderContainer.test(
        overrides: [
          universalLinkProvider.overrideWith((ref) {
            return UniversalLink(
              ref.watch(uiStateArgsProvider),
              ref,
              appLinks: mockAppLinks,
            );
          }),
        ],
      );
      addTearDown(container.dispose);
      final sut = container.read(universalLinkProvider);

      await sut.handleInitialUri();

      verifyNever(() => mockAppLinks.getInitialLink());
      expect(sut.initialUri, isNull);
    });

    test('skips when _initialUriIsHandled is already true', () async {
      FlavorConfig(
        flavor: Flavor.production,
        values: FlavorValues(
          enableNetworkSettings: false,
          enableJade: false,
          enableLocalEndpoint: false,
          isDesktop: true,
        ),
      );
      when(() => mockAppLinks.getInitialLink()).thenAnswer((_) async => null);
      final container = ProviderContainer.test(
        overrides: [
          universalLinkProvider.overrideWith((ref) {
            return UniversalLink(
              ref.watch(uiStateArgsProvider),
              ref,
              appLinks: mockAppLinks,
            );
          }),
        ],
      );
      addTearDown(container.dispose);
      final sut = container.read(universalLinkProvider);

      await sut.handleInitialUri(); // first call sets _initialUriIsHandled=true
      await sut.handleInitialUri(); // second call should skip

      verify(() => mockAppLinks.getInitialLink()).called(1);
    });

    test('initialUri remains null when getInitialLink returns null', () async {
      FlavorConfig(
        flavor: Flavor.production,
        values: FlavorValues(
          enableNetworkSettings: false,
          enableJade: false,
          enableLocalEndpoint: false,
          isDesktop: true,
        ),
      );
      when(() => mockAppLinks.getInitialLink()).thenAnswer((_) async => null);
      final container = ProviderContainer.test(
        overrides: [
          universalLinkProvider.overrideWith((ref) {
            return UniversalLink(
              ref.watch(uiStateArgsProvider),
              ref,
              appLinks: mockAppLinks,
            );
          }),
        ],
      );
      addTearDown(container.dispose);
      final sut = container.read(universalLinkProvider);

      await sut.handleInitialUri();

      expect(sut.initialUri, isNull);
    });

    test('getInitialLink returns valid URI → stores as initialUri', () async {
      FlavorConfig(
        flavor: Flavor.production,
        values: FlavorValues(
          enableNetworkSettings: false,
          enableJade: false,
          enableLocalEndpoint: false,
          isDesktop: true,
        ),
      );
      final testUri = Uri.parse('https://app.sideswap.io/swap/?order_id=77');
      when(
        () => mockAppLinks.getInitialLink(),
      ).thenAnswer((_) async => testUri);
      final container = ProviderContainer.test(
        overrides: [
          universalLinkProvider.overrideWith((ref) {
            return UniversalLink(
              ref.watch(uiStateArgsProvider),
              ref,
              appLinks: mockAppLinks,
            );
          }),
        ],
      );
      addTearDown(container.dispose);
      final sut = container.read(universalLinkProvider);

      await sut.handleInitialUri();

      expect(sut.initialUri, testUri);
    });

    test(
      'getInitialLink throws PlatformException → caught and logged',
      () async {
        FlavorConfig(
          flavor: Flavor.production,
          values: FlavorValues(
            enableNetworkSettings: false,
            enableJade: false,
            enableLocalEndpoint: false,
            isDesktop: true,
          ),
        );
        when(
          () => mockAppLinks.getInitialLink(),
        ).thenThrow(PlatformException(code: 'ERR', message: 'platform error'));
        final container = ProviderContainer.test(
          overrides: [
            universalLinkProvider.overrideWith((ref) {
              return UniversalLink(
                ref.watch(uiStateArgsProvider),
                ref,
                appLinks: mockAppLinks,
              );
            }),
          ],
        );
        addTearDown(container.dispose);
        final sut = container.read(universalLinkProvider);

        // Should not throw
        await expectLater(sut.handleInitialUri(), completes);
        expect(sut.initialUri, isNull);
      },
    );

    test('getInitialLink throws FormatException → caught and logged', () async {
      FlavorConfig(
        flavor: Flavor.production,
        values: FlavorValues(
          enableNetworkSettings: false,
          enableJade: false,
          enableLocalEndpoint: false,
          isDesktop: true,
        ),
      );
      when(
        () => mockAppLinks.getInitialLink(),
      ).thenThrow(const FormatException('bad uri format'));
      final container = ProviderContainer.test(
        overrides: [
          universalLinkProvider.overrideWith((ref) {
            return UniversalLink(
              ref.watch(uiStateArgsProvider),
              ref,
              appLinks: mockAppLinks,
            );
          }),
        ],
      );
      addTearDown(container.dispose);
      final sut = container.read(universalLinkProvider);

      await expectLater(sut.handleInitialUri(), completes);
      expect(sut.initialUri, isNull);
    });
  });
}
