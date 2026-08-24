import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/providers/login_provider.dart';

import '../utils.dart';

void main() {

  group('LoginStateNotifier', () {
    group('build', () {
      test('initializes with empty login state', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        expect(container.read(loginStateProvider), isA<LoginStateEmpty>());
      });
    });

    group('setState', () {
      test('updates state with empty login state', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        final listener = ProviderListener<LoginState>();

        container.listen(
          loginStateProvider,
          listener.call,
          fireImmediately: true,
        );

        verifyInOrder([() => listener(null, const LoginStateEmpty())]);
        verifyNoMoreInteractions(listener);

        final notifier = container.read(loginStateProvider.notifier);
        const newState = LoginStateEmpty();
        notifier.setState(newState);

        // Setting the same empty state value does not trigger listener notification
        verifyNoMoreInteractions(listener);
      });

      test('updates state with login state containing mnemonic', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        final listener = ProviderListener<LoginState>();

        container.listen(
          loginStateProvider,
          listener.call,
          fireImmediately: true,
        );

        verifyInOrder([() => listener(null, const LoginStateEmpty())]);
        verifyNoMoreInteractions(listener);

        final notifier = container.read(loginStateProvider.notifier);
        const mnemonic = 'test mnemonic phrase';
        const loginState = LoginStateLogin(mnemonic: mnemonic);

        notifier.setState(loginState);

        verifyInOrder([() => listener(const LoginStateEmpty(), loginState)]);
        verifyNoMoreInteractions(listener);

        expect(container.read(loginStateProvider), isA<LoginStateLogin>());
        expect(
          (container.read(loginStateProvider) as LoginStateLogin).mnemonic,
          mnemonic,
        );
      });

      test('updates state with login state containing jadeId', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        final listener = ProviderListener<LoginState>();

        container.listen(
          loginStateProvider,
          listener.call,
          fireImmediately: true,
        );

        verifyInOrder([() => listener(null, const LoginStateEmpty())]);
        verifyNoMoreInteractions(listener);

        final notifier = container.read(loginStateProvider.notifier);
        const jadeId = 'jade_device_id_123';
        const loginState = LoginStateLogin(jadeId: jadeId);

        notifier.setState(loginState);

        verifyInOrder([() => listener(const LoginStateEmpty(), loginState)]);
        verifyNoMoreInteractions(listener);

        expect(container.read(loginStateProvider), isA<LoginStateLogin>());
        expect(
          (container.read(loginStateProvider) as LoginStateLogin).jadeId,
          jadeId,
        );
      });

      test('updates state with login state containing both mnemonic and jadeId', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        final listener = ProviderListener<LoginState>();

        container.listen(
          loginStateProvider,
          listener.call,
          fireImmediately: true,
        );

        verifyInOrder([() => listener(null, const LoginStateEmpty())]);
        verifyNoMoreInteractions(listener);

        final notifier = container.read(loginStateProvider.notifier);
        const mnemonic = 'test mnemonic phrase';
        const jadeId = 'jade_device_id_123';
        const loginState = LoginStateLogin(mnemonic: mnemonic, jadeId: jadeId);

        notifier.setState(loginState);

        verifyInOrder([() => listener(const LoginStateEmpty(), loginState)]);
        verifyNoMoreInteractions(listener);

        final resultState = container.read(loginStateProvider) as LoginStateLogin;
        expect(resultState.mnemonic, mnemonic);
        expect(resultState.jadeId, jadeId);
      });

      test('multiple consecutive state updates', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        final listener = ProviderListener<LoginState>();

        container.listen(
          loginStateProvider,
          listener.call,
          fireImmediately: true,
        );

        final notifier = container.read(loginStateProvider.notifier);

        // First update
        const mnemonic1 = 'first mnemonic';
        const state1 = LoginStateLogin(mnemonic: mnemonic1);
        notifier.setState(state1);

        // Second update
        const jadeId = 'jade_id';
        const state2 = LoginStateLogin(jadeId: jadeId);
        notifier.setState(state2);

        // Verify sequence of updates
        verifyInOrder([
          () => listener(null, const LoginStateEmpty()),
          () => listener(const LoginStateEmpty(), state1),
          () => listener(state1, state2),
        ]);
        verifyNoMoreInteractions(listener);

        expect(container.read(loginStateProvider), isA<LoginStateLogin>());
      });
    });
  });
}
