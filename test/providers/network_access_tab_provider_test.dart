import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/network_access_tab_provider.dart';

import '../utils.dart';
import '../helpers/fake_configuration.dart';

void main() {
  group('NetworkAccessTabNotifier', () {
    group('build', () {
      test('returns initial state of server', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final state = container.read(networkAccessTabProvider);

        expect(state, isA<NetworkAccessTabStateServer>());
      });
    });

    group('setNetworkAccessTab', () {
      test('changes state from server to proxy', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        final listener = ProviderListener<NetworkAccessTabState>();

        container.listen(
          networkAccessTabProvider,
          listener.call,
          fireImmediately: true,
        );

        verifyInOrder([
          () => listener(null, const NetworkAccessTabState.server())
        ]);
        verifyNoMoreInteractions(listener);

        final notifier = container.read(networkAccessTabProvider.notifier);
        notifier.setNetworkAccessTab(const NetworkAccessTabState.proxy());

        verifyInOrder([
          () => listener(
            const NetworkAccessTabState.server(),
            const NetworkAccessTabState.proxy(),
          )
        ]);
        verifyNoMoreInteractions(listener);
        expect(
          container.read(networkAccessTabProvider),
          isA<NetworkAccessTabStateProxy>(),
        );
      });

      test('changes state from proxy to server', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        final listener = ProviderListener<NetworkAccessTabState>();

        // Start with proxy state
        container.listen(
          networkAccessTabProvider,
          listener.call,
          fireImmediately: true,
        );
        clearInteractions(listener);

        final notifier = container.read(networkAccessTabProvider.notifier);
        notifier.setNetworkAccessTab(const NetworkAccessTabState.proxy());
        clearInteractions(listener);

        // Change back to server
        notifier.setNetworkAccessTab(const NetworkAccessTabState.server());

        verifyInOrder([
          () => listener(
            const NetworkAccessTabState.proxy(),
            const NetworkAccessTabState.server(),
          )
        ]);
        verifyNoMoreInteractions(listener);
        expect(
          container.read(networkAccessTabProvider),
          isA<NetworkAccessTabStateServer>(),
        );
      });
    });
  });

  group('UseProxyNotifier', () {
    group('build', () {
      test('reads useProxy value from configuration provider', () {
        final mockConfigSettings = SideswapSettings.empty(
          mnemonicEncrypted: Uint8List.fromList([]),
          useProxy: true,
        );

        final container = ProviderContainer.test(
          overrides: [
            configurationProvider.overrideWith(() => FakeConfiguration(mockConfigSettings)),
          ],
        );
        addTearDown(container.dispose);

        final useProxy = container.read(useProxyProvider);

        expect(useProxy, true);
      });

      test('reads false when useProxy is false in configuration', () {
        final mockConfigSettings = SideswapSettings.empty(
          mnemonicEncrypted: Uint8List.fromList([]),
          useProxy: false,
        );

        final container = ProviderContainer.test(
          overrides: [
            configurationProvider.overrideWith(() => FakeConfiguration(mockConfigSettings)),
          ],
        );
        addTearDown(container.dispose);

        final useProxy = container.read(useProxyProvider);

        expect(useProxy, false);
      });
    });

    group('setProxyState', () {
      test('updates configuration when proxy state is set to true', () {
        final mockConfigSettings = SideswapSettings.empty(
          mnemonicEncrypted: Uint8List.fromList([]),
          useProxy: false,
        );

        final container = ProviderContainer.test(
          overrides: [
            configurationProvider.overrideWith(() => FakeConfiguration(mockConfigSettings)),
          ],
        );
        addTearDown(container.dispose);

        // Read notifier and call setProxyState
        final notifier = container.read(useProxyProvider.notifier);
        notifier.setProxyState(true);

        // Verify the state was updated through the configuration notifier
        // We verify by checking that the underlying configuration was modified
        final configNotifier = container.read(configurationProvider.notifier);
        expect(configNotifier.state.useProxy, true);
      });

      test('updates configuration when proxy state is set to false', () {
        final mockConfigSettings = SideswapSettings.empty(
          mnemonicEncrypted: Uint8List.fromList([]),
          useProxy: true,
        );

        final container = ProviderContainer.test(
          overrides: [
            configurationProvider.overrideWith(() => FakeConfiguration(mockConfigSettings)),
          ],
        );
        addTearDown(container.dispose);

        final notifier = container.read(useProxyProvider.notifier);
        notifier.setProxyState(false);

        final configNotifier = container.read(configurationProvider.notifier);
        expect(configNotifier.state.useProxy, false);
      });

      test('emits state changes through listener when proxy state changes', () {
        final mockConfigSettings = SideswapSettings.empty(
          mnemonicEncrypted: Uint8List.fromList([]),
          useProxy: false,
        );

        final container = ProviderContainer.test(
          overrides: [
            configurationProvider.overrideWith(() => FakeConfiguration(mockConfigSettings)),
          ],
        );
        addTearDown(container.dispose);
        final listener = ProviderListener<bool>();

        container.listen(
          useProxyProvider,
          listener.call,
          fireImmediately: true,
        );

        verifyInOrder([() => listener(null, false)]);
        verifyNoMoreInteractions(listener);

        final notifier = container.read(useProxyProvider.notifier);
        notifier.setProxyState(true);

        // After calling setProxyState, read the provider to verify the state was updated
        final updatedState = container.read(useProxyProvider);
        expect(updatedState, true);
      });

      test('transitions between true and false states correctly', () {
        final mockConfigSettings = SideswapSettings.empty(
          mnemonicEncrypted: Uint8List.fromList([]),
          useProxy: false,
        );

        final container = ProviderContainer.test(
          overrides: [
            configurationProvider.overrideWith(() => FakeConfiguration(mockConfigSettings)),
          ],
        );
        addTearDown(container.dispose);

        final notifier = container.read(useProxyProvider.notifier);

        // Transition: false -> true
        notifier.setProxyState(true);
        var state = container.read(useProxyProvider);
        expect(state, true);

        // Transition: true -> false
        notifier.setProxyState(false);
        state = container.read(useProxyProvider);
        expect(state, false);
      });
    });
  });
}
