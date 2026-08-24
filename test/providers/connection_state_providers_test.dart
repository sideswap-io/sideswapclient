import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/riverpod.dart';
import 'package:sideswap/models/connection_models.dart';
import 'package:sideswap/providers/connection_state_providers.dart';

import '../utils.dart';

void main() {
  group('ServerConnectionNotifier', () {
    group('build', () {
      test('returns false as initial state', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        expect(container.read(serverConnectionProvider), false);
      });
    });

    group('setServerConnectionState', () {
      test('updates state to true when called with true', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        final listener = ProviderListener<bool>();
        container.listen(serverConnectionProvider, listener.call,
            fireImmediately: true);

        verifyInOrder([() => listener(null, false)]);
        verifyNoMoreInteractions(listener);

        container
            .read(serverConnectionProvider.notifier)
            .setServerConnectionState(true);

        verifyInOrder([() => listener(false, true)]);
        verifyNoMoreInteractions(listener);
      });

      test('updates state to false when called with false', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        final listener = ProviderListener<bool>();
        container.listen(serverConnectionProvider, listener.call,
            fireImmediately: true);

        verifyInOrder([() => listener(null, false)]);
        verifyNoMoreInteractions(listener);

        container
            .read(serverConnectionProvider.notifier)
            .setServerConnectionState(true);

        container
            .read(serverConnectionProvider.notifier)
            .setServerConnectionState(false);

        verifyInOrder([
          () => listener(false, true),
          () => listener(true, false),
        ]);
        verifyNoMoreInteractions(listener);
      });

      test('reflects state change when read after update', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        expect(container.read(serverConnectionProvider), false);

        container
            .read(serverConnectionProvider.notifier)
            .setServerConnectionState(true);

        expect(container.read(serverConnectionProvider), true);
      });
    });
  });

  group('ServerLoginNotifier', () {
    group('build', () {
      test('returns ServerLoginStateLogout as initial state', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        final initialState = container.read(serverLoginProvider);

        expect(initialState, const ServerLoginState.logout());
      });
    });

    group('setServerLoginState', () {
      test('updates state from logout to login', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        final listener = ProviderListener<ServerLoginState>();
        container.listen(serverLoginProvider, listener.call,
            fireImmediately: true);

        verifyInOrder(
            [() => listener(null, const ServerLoginState.logout())]);
        verifyNoMoreInteractions(listener);

        container
            .read(serverLoginProvider.notifier)
            .setServerLoginState(const ServerLoginState.login());

        verifyInOrder([
          () => listener(
              const ServerLoginState.logout(), const ServerLoginState.login())
        ]);
        verifyNoMoreInteractions(listener);
      });

      test('updates state from logout to loginProcessing', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        final listener = ProviderListener<ServerLoginState>();
        container.listen(serverLoginProvider, listener.call,
            fireImmediately: true);

        verifyInOrder(
            [() => listener(null, const ServerLoginState.logout())]);

        container
            .read(serverLoginProvider.notifier)
            .setServerLoginState(const ServerLoginState.loginProcessing());

        verifyInOrder([
          () => listener(const ServerLoginState.logout(),
              const ServerLoginState.loginProcessing())
        ]);
        verifyNoMoreInteractions(listener);
      });

      test('updates state from logout to error with message', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        final listener = ProviderListener<ServerLoginState>();
        container.listen(serverLoginProvider, listener.call,
            fireImmediately: true);

        verifyInOrder(
            [() => listener(null, const ServerLoginState.logout())]);

        container
            .read(serverLoginProvider.notifier)
            .setServerLoginState(const ServerLoginState.error(
                message: 'Connection failed'));

        verifyInOrder([
          () => listener(
              const ServerLoginState.logout(),
              const ServerLoginState.error(message: 'Connection failed'))
        ]);
        verifyNoMoreInteractions(listener);
      });

      test('reflects state change when read after update', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        expect(container.read(serverLoginProvider),
            const ServerLoginState.logout());

        container
            .read(serverLoginProvider.notifier)
            .setServerLoginState(const ServerLoginState.login());

        expect(container.read(serverLoginProvider),
            const ServerLoginState.login());
      });

      test('can transition through multiple states', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        final listener = ProviderListener<ServerLoginState>();
        container.listen(serverLoginProvider, listener.call,
            fireImmediately: true);

        verifyInOrder(
            [() => listener(null, const ServerLoginState.logout())]);

        container
            .read(serverLoginProvider.notifier)
            .setServerLoginState(const ServerLoginState.loginProcessing());
        expect(container.read(serverLoginProvider),
            const ServerLoginState.loginProcessing());

        container
            .read(serverLoginProvider.notifier)
            .setServerLoginState(const ServerLoginState.login());
        expect(container.read(serverLoginProvider),
            const ServerLoginState.login());

        container
            .read(serverLoginProvider.notifier)
            .setServerLoginState(const ServerLoginState.logout());
        expect(container.read(serverLoginProvider),
            const ServerLoginState.logout());
      });
    });
  });
}
