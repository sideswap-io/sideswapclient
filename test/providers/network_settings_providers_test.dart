import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/network_settings_providers.dart';

import '../helpers/fake_configuration.dart';

void main() {
  group('NetworkSettingsNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    group('build', () {
      test('returns NetworkSettingsModelEmpty with config values when '
          'networkSettingsModel is null', () {
        final settings = SideswapSettings.empty(
          mnemonicEncrypted: Uint8List(0),
          env: 1,
          settingsNetworkType: SettingsNetworkType.blockstream,
          networkHost: 'example.com',
          networkPort: 8080,
          networkUseTLS: true,
        );

        container = ProviderContainer.test(
          overrides: [
            configurationProvider.overrideWith(
              () => FakeConfiguration(settings),
            ),
          ],
        );
        addTearDown(container.dispose);

        final state = container.read(networkSettingsProvider);

        expect(state, isA<NetworkSettingsModelEmpty>());
        expect(state.env, 1);
        expect(state.settingsNetworkType, SettingsNetworkType.blockstream);
        expect(state.host, 'example.com');
        expect(state.port, 8080);
        expect(state.useTls, true);
      });

      test('returns NetworkSettingsModelEmpty with config values when '
          'networkSettingsModel is NetworkSettingsModelEmpty', () {
        final settings = SideswapSettings.empty(
          mnemonicEncrypted: Uint8List(0),
          env: 2,
          settingsNetworkType: SettingsNetworkType.sideswap,
          networkHost: 'host.local',
          networkPort: 9000,
          networkUseTLS: false,
          networkSettingsModel: const NetworkSettingsModelEmpty(),
        );

        container = ProviderContainer.test(
          overrides: [
            configurationProvider.overrideWith(
              () => FakeConfiguration(settings),
            ),
          ],
        );
        addTearDown(container.dispose);

        final state = container.read(networkSettingsProvider);

        expect(state, isA<NetworkSettingsModelEmpty>());
        expect(state.env, 2);
        expect(state.settingsNetworkType, SettingsNetworkType.sideswap);
      });

      test('returns existing NetworkSettingsModelApply when '
          'networkSettingsModel is NetworkSettingsModelApply', () {
        final model = NetworkSettingsModel.apply(
          env: 3,
          settingsNetworkType: SettingsNetworkType.personal,
          host: 'personal.net',
          port: 5000,
          useTls: true,
        );

        final settings = SideswapSettings.empty(
          mnemonicEncrypted: Uint8List(0),
          networkSettingsModel: model,
        );

        container = ProviderContainer.test(
          overrides: [
            configurationProvider.overrideWith(
              () => FakeConfiguration(settings),
            ),
          ],
        );
        addTearDown(container.dispose);

        final state = container.read(networkSettingsProvider);

        expect(state, isA<NetworkSettingsModelApply>());
        expect(identical(state, model), true);
      });
    });

    group('setModel', () {
      test('sets state to empty model with current config values when '
          'receiving NetworkSettingsModelEmpty', () {
        final settings = SideswapSettings.empty(
          mnemonicEncrypted: Uint8List(0),
          env: 1,
          settingsNetworkType: SettingsNetworkType.blockstream,
          networkHost: 'host1.com',
          networkPort: 1234,
          networkUseTLS: true,
        );

        container = ProviderContainer.test(
          overrides: [
            configurationProvider.overrideWith(
              () => FakeConfiguration(settings),
            ),
          ],
        );
        addTearDown(container.dispose);

        container.read(networkSettingsProvider.notifier).setModel(
          const NetworkSettingsModelEmpty(),
        );

        final state = container.read(networkSettingsProvider);
        expect(state, isA<NetworkSettingsModelEmpty>());
        expect(state.env, 1);
        expect(state.settingsNetworkType, SettingsNetworkType.blockstream);
        expect(state.host, 'host1.com');
        expect(state.port, 1234);
        expect(state.useTls, true);
      });

      test('sets state to apply model when receiving apply model that differs '
          'from current config', () {
        final settings = SideswapSettings.empty(
          mnemonicEncrypted: Uint8List(0),
          env: 1,
          settingsNetworkType: SettingsNetworkType.blockstream,
          networkHost: 'old.com',
          networkPort: 1234,
          networkUseTLS: true,
        );

        container = ProviderContainer.test(
          overrides: [
            configurationProvider.overrideWith(
              () => FakeConfiguration(settings),
            ),
          ],
        );
        addTearDown(container.dispose);

        final newModel = NetworkSettingsModel.apply(
          env: 2,
          settingsNetworkType: SettingsNetworkType.sideswap,
          host: 'new.com',
          port: 5678,
          useTls: false,
        );

        container.read(networkSettingsProvider.notifier).setModel(newModel);

        final state = container.read(networkSettingsProvider);
        expect(state, isA<NetworkSettingsModelApply>());
        expect(state.env, 2);
        expect(state.settingsNetworkType, SettingsNetworkType.sideswap);
        expect(state.host, 'new.com');
        expect(state.port, 5678);
        expect(state.useTls, false);
      });

      test('preserves empty model fields when receiving empty model', () {
        final settings = SideswapSettings.empty(
          mnemonicEncrypted: Uint8List(0),
          env: 5,
          settingsNetworkType: SettingsNetworkType.sideswapChina,
          networkHost: 'china.net',
          networkPort: 443,
          networkUseTLS: true,
        );

        container = ProviderContainer.test(
          overrides: [
            configurationProvider.overrideWith(
              () => FakeConfiguration(settings),
            ),
          ],
        );
        addTearDown(container.dispose);

        final emptyModel = NetworkSettingsModel.empty(
          settingsNetworkType: SettingsNetworkType.sideswapChina,
          env: 5,
          host: 'china.net',
          port: 443,
          useTls: true,
        );

        container.read(networkSettingsProvider.notifier).setModel(emptyModel);

        final state = container.read(networkSettingsProvider);
        expect(state, isA<NetworkSettingsModelEmpty>());
        expect(state.env, 5);
        expect(state.settingsNetworkType, SettingsNetworkType.sideswapChina);
        expect(state.host, 'china.net');
        expect(state.port, 443);
        expect(state.useTls, true);
      });

      test('sets state to empty when apply model matches non-personal config', () {
        final settings = SideswapSettings.empty(
          mnemonicEncrypted: Uint8List(0),
          env: 1,
          settingsNetworkType: SettingsNetworkType.sideswap,
          networkHost: 'irrelevant.com',
          networkPort: 1234,
          networkUseTLS: true,
        );

        container = ProviderContainer.test(
          overrides: [
            configurationProvider.overrideWith(
              () => FakeConfiguration(settings),
            ),
          ],
        );
        addTearDown(container.dispose);

        container.read(networkSettingsProvider.notifier).setModel(
          const NetworkSettingsModelApply(
            settingsNetworkType: SettingsNetworkType.sideswap,
            env: 1,
          ),
        );

        final state = container.read(networkSettingsProvider);
        expect(state, isA<NetworkSettingsModelEmpty>());
        expect(state.settingsNetworkType, SettingsNetworkType.sideswap);
        expect(state.env, 1);
      });

      test('sets state to empty when personal apply model matches all config fields', () {
        final settings = SideswapSettings.empty(
          mnemonicEncrypted: Uint8List(0),
          env: 1,
          settingsNetworkType: SettingsNetworkType.personal,
          networkHost: 'my.server.com',
          networkPort: 9000,
          networkUseTLS: true,
        );

        container = ProviderContainer.test(
          overrides: [
            configurationProvider.overrideWith(
              () => FakeConfiguration(settings),
            ),
          ],
        );
        addTearDown(container.dispose);

        container.read(networkSettingsProvider.notifier).setModel(
          const NetworkSettingsModelApply(
            settingsNetworkType: SettingsNetworkType.personal,
            env: 1,
            host: 'my.server.com',
            port: 9000,
            useTls: true,
          ),
        );

        final state = container.read(networkSettingsProvider);
        expect(state, isA<NetworkSettingsModelEmpty>());
      });

      test('sets state to apply when personal apply model has different host', () {
        final settings = SideswapSettings.empty(
          mnemonicEncrypted: Uint8List(0),
          env: 1,
          settingsNetworkType: SettingsNetworkType.personal,
          networkHost: 'old.server.com',
          networkPort: 9000,
          networkUseTLS: true,
        );

        container = ProviderContainer.test(
          overrides: [
            configurationProvider.overrideWith(
              () => FakeConfiguration(settings),
            ),
          ],
        );
        addTearDown(container.dispose);

        container.read(networkSettingsProvider.notifier).setModel(
          const NetworkSettingsModelApply(
            settingsNetworkType: SettingsNetworkType.personal,
            env: 1,
            host: 'new.server.com',
            port: 9000,
            useTls: true,
          ),
        );

        expect(container.read(networkSettingsProvider), isA<NetworkSettingsModelApply>());
      });

      test('sets state to apply when personal apply model has different port', () {
        final settings = SideswapSettings.empty(
          mnemonicEncrypted: Uint8List(0),
          env: 1,
          settingsNetworkType: SettingsNetworkType.personal,
          networkHost: 'my.server.com',
          networkPort: 9000,
          networkUseTLS: true,
        );

        container = ProviderContainer.test(
          overrides: [
            configurationProvider.overrideWith(
              () => FakeConfiguration(settings),
            ),
          ],
        );
        addTearDown(container.dispose);

        container.read(networkSettingsProvider.notifier).setModel(
          const NetworkSettingsModelApply(
            settingsNetworkType: SettingsNetworkType.personal,
            env: 1,
            host: 'my.server.com',
            port: 9999,
            useTls: true,
          ),
        );

        expect(container.read(networkSettingsProvider), isA<NetworkSettingsModelApply>());
      });

      test('sets state to apply when personal apply model has different useTls', () {
        final settings = SideswapSettings.empty(
          mnemonicEncrypted: Uint8List(0),
          env: 1,
          settingsNetworkType: SettingsNetworkType.personal,
          networkHost: 'my.server.com',
          networkPort: 9000,
          networkUseTLS: true,
        );

        container = ProviderContainer.test(
          overrides: [
            configurationProvider.overrideWith(
              () => FakeConfiguration(settings),
            ),
          ],
        );
        addTearDown(container.dispose);

        container.read(networkSettingsProvider.notifier).setModel(
          const NetworkSettingsModelApply(
            settingsNetworkType: SettingsNetworkType.personal,
            env: 1,
            host: 'my.server.com',
            port: 9000,
            useTls: false,
          ),
        );

        expect(container.read(networkSettingsProvider), isA<NetworkSettingsModelApply>());
      });

      test('sets state to apply model when all fields differ', () {
        final settings = SideswapSettings.empty(
          mnemonicEncrypted: Uint8List(0),
          env: 0,
          settingsNetworkType: SettingsNetworkType.blockstream,
          networkHost: 'old.com',
          networkPort: 1111,
          networkUseTLS: false,
        );

        container = ProviderContainer.test(
          overrides: [
            configurationProvider.overrideWith(
              () => FakeConfiguration(settings),
            ),
          ],
        );
        addTearDown(container.dispose);

        final completelyDifferentModel = NetworkSettingsModel.apply(
          env: 1,
          settingsNetworkType: SettingsNetworkType.sideswap,
          host: 'completely.different',
          port: 2222,
          useTls: true,
        );

        container
            .read(networkSettingsProvider.notifier)
            .setModel(completelyDifferentModel);

        final state = container.read(networkSettingsProvider);
        expect(state, isA<NetworkSettingsModelApply>());
      });
    });

    group('applySettings', () {
      test('does nothing when state is NetworkSettingsModelEmpty', () {
        final settings = SideswapSettings.empty(
          mnemonicEncrypted: Uint8List(0),
        );

        container = ProviderContainer.test(
          overrides: [
            configurationProvider.overrideWith(
              () => FakeConfiguration(settings),
            ),
          ],
        );
        addTearDown(container.dispose);

        // applySettings should not throw and should not change state
        expect(() {
          container.read(networkSettingsProvider.notifier).applySettings();
        }, returnsNormally);

        final state = container.read(networkSettingsProvider);
        expect(state, isA<NetworkSettingsModelEmpty>());
      });

      test('applies settings when state is apply model with differences', () {
        final settings = SideswapSettings.empty(
          mnemonicEncrypted: Uint8List(0),
          env: 0,
          settingsNetworkType: SettingsNetworkType.blockstream,
          networkHost: 'old.com',
          networkPort: 8080,
          networkUseTLS: false,
        );

        final applyModel = NetworkSettingsModel.apply(
          env: 1,
          settingsNetworkType: SettingsNetworkType.sideswap,
          host: 'new.com',
          port: 9090,
          useTls: true,
        );

        final settingsWithApply = settings.copyWith(
          networkSettingsModel: applyModel,
        );

        container = ProviderContainer.test(
          overrides: [
            configurationProvider.overrideWith(
              () => FakeConfiguration(settingsWithApply),
            ),
          ],
        );
        addTearDown(container.dispose);

        container.read(networkSettingsProvider.notifier).applySettings();

        // After apply, networkSettingsModel should be set to empty
        final state = container.read(networkSettingsProvider);
        expect(state, isA<NetworkSettingsModelEmpty>());
      });

      test('ignores null values in apply model', () {
        final settings = SideswapSettings.empty(
          mnemonicEncrypted: Uint8List(0),
          env: 0,
          settingsNetworkType: SettingsNetworkType.blockstream,
          networkHost: 'host.com',
          networkPort: 8080,
          networkUseTLS: false,
        );

        final applyModel = NetworkSettingsModel.apply(
          settingsNetworkType: null,
          host: null,
          port: null,
          useTls: null,
          env: null,
        );

        final settingsWithApply = settings.copyWith(
          networkSettingsModel: applyModel,
        );

        container = ProviderContainer.test(
          overrides: [
            configurationProvider.overrideWith(
              () => FakeConfiguration(settingsWithApply),
            ),
          ],
        );
        addTearDown(container.dispose);

        container.read(networkSettingsProvider.notifier).applySettings();

        final state = container.read(networkSettingsProvider);
        expect(state, isA<NetworkSettingsModelEmpty>());
      });

      test('applies only changed fields', () {
        final settings = SideswapSettings.empty(
          mnemonicEncrypted: Uint8List(0),
          env: 0,
          settingsNetworkType: SettingsNetworkType.blockstream,
          networkHost: 'host.com',
          networkPort: 8080,
          networkUseTLS: false,
        );

        final applyModel = NetworkSettingsModel.apply(
          settingsNetworkType: SettingsNetworkType.sideswap,
          host: 'host.com',
          port: 8080,
          useTls: false,
          env: 0,
        );

        final settingsWithApply = settings.copyWith(
          networkSettingsModel: applyModel,
        );

        container = ProviderContainer.test(
          overrides: [
            configurationProvider.overrideWith(
              () => FakeConfiguration(settingsWithApply),
            ),
          ],
        );
        addTearDown(container.dispose);

        container.read(networkSettingsProvider.notifier).applySettings();

        final state = container.read(networkSettingsProvider);
        expect(state, isA<NetworkSettingsModelEmpty>());
      });
    });

    group('save', () {
      test('saves current state to configuration', () {
        final settings = SideswapSettings.empty(
          mnemonicEncrypted: Uint8List(0),
        );

        container = ProviderContainer.test(
          overrides: [
            configurationProvider.overrideWith(
              () => FakeConfiguration(settings),
            ),
          ],
        );
        addTearDown(container.dispose);

        final newModel = NetworkSettingsModel.apply(
          env: 1,
          settingsNetworkType: SettingsNetworkType.sideswap,
          host: 'test.com',
          port: 5000,
          useTls: true,
        );

        container.read(networkSettingsProvider.notifier).state = newModel;
        container.read(networkSettingsProvider.notifier).save();

        final savedConfig = container.read(configurationProvider);
        expect(savedConfig.networkSettingsModel, newModel);
      });
    });
  });

  group('NetworkSettingsModel.fromJson', () {
    test('parses empty model', () {
      final model = NetworkSettingsModel.fromJson({
        'runtimeType': 'empty',
        'settingsNetworkType': null,
        'env': null,
        'host': null,
        'port': null,
        'useTls': null,
      });
      expect(model, isA<NetworkSettingsModelEmpty>());
    });

    test('parses apply model', () {
      final model = NetworkSettingsModel.fromJson({
        'runtimeType': 'apply',
        'settingsNetworkType': null,
        'env': null,
        'host': null,
        'port': null,
        'useTls': null,
      });
      expect(model, isA<NetworkSettingsModelApply>());
    });
  });

  group('networkSettingsNeedSave', () {
    test('returns true when state is apply model and '
        'settingsNetworkType differs', () {
      final settings = SideswapSettings.empty(
        mnemonicEncrypted: Uint8List(0),
        settingsNetworkType: SettingsNetworkType.blockstream,
        networkSettingsModel: NetworkSettingsModel.apply(
          settingsNetworkType: SettingsNetworkType.sideswap,
        ),
      );

      final container = ProviderContainer.test(
        overrides: [
          configurationProvider.overrideWith(
            () => FakeConfiguration(settings),
          ),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(networkSettingsNeedSaveProvider), true);
    });

    test('returns true when state is apply model and env differs', () {
      final settings = SideswapSettings.empty(
        mnemonicEncrypted: Uint8List(0),
        env: 0,
        networkSettingsModel: NetworkSettingsModel.apply(
          env: 1,
        ),
      );

      final container = ProviderContainer.test(
        overrides: [
          configurationProvider.overrideWith(
            () => FakeConfiguration(settings),
          ),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(networkSettingsNeedSaveProvider), true);
    });

    test('returns false when state is empty model', () {
      final settings = SideswapSettings.empty(
        mnemonicEncrypted: Uint8List(0),
        settingsNetworkType: SettingsNetworkType.blockstream,
        networkSettingsModel: const NetworkSettingsModelEmpty(),
      );

      final container = ProviderContainer.test(
        overrides: [
          configurationProvider.overrideWith(
            () => FakeConfiguration(settings),
          ),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(networkSettingsNeedSaveProvider), false);
    });

    test('returns false when apply model matches config type and env', () {
      final settings = SideswapSettings.empty(
        mnemonicEncrypted: Uint8List(0),
        env: 1,
        settingsNetworkType: SettingsNetworkType.sideswap,
        networkSettingsModel: NetworkSettingsModel.apply(
          env: 1,
          settingsNetworkType: SettingsNetworkType.sideswap,
        ),
      );

      final container = ProviderContainer.test(
        overrides: [
          configurationProvider.overrideWith(
            () => FakeConfiguration(settings),
          ),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(networkSettingsNeedSaveProvider), false);
    });

    test('returns false when networkSettingsModel is null', () {
      final settings = SideswapSettings.empty(
        mnemonicEncrypted: Uint8List(0),
        settingsNetworkType: SettingsNetworkType.blockstream,
        networkSettingsModel: null,
      );

      final container = ProviderContainer.test(
        overrides: [
          configurationProvider.overrideWith(
            () => FakeConfiguration(settings),
          ),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(networkSettingsNeedSaveProvider), false);
    });
  });

  group('networkSettingsNeedRestart', () {
    test('returns true when state is apply model and env differs', () {
      final settings = SideswapSettings.empty(
        mnemonicEncrypted: Uint8List(0),
        env: 0,
        networkSettingsModel: NetworkSettingsModel.apply(
          env: 1,
        ),
      );

      final container = ProviderContainer.test(
        overrides: [
          configurationProvider.overrideWith(
            () => FakeConfiguration(settings),
          ),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(networkSettingsNeedRestartProvider), true);
    });

    test('returns false when state is empty model', () {
      final settings = SideswapSettings.empty(
        mnemonicEncrypted: Uint8List(0),
        env: 1,
        networkSettingsModel: const NetworkSettingsModelEmpty(),
      );

      final container = ProviderContainer.test(
        overrides: [
          configurationProvider.overrideWith(
            () => FakeConfiguration(settings),
          ),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(networkSettingsNeedRestartProvider), false);
    });

    test('returns false when apply model env matches config env', () {
      final settings = SideswapSettings.empty(
        mnemonicEncrypted: Uint8List(0),
        env: 2,
        networkSettingsModel: NetworkSettingsModel.apply(
          env: 2,
        ),
      );

      final container = ProviderContainer.test(
        overrides: [
          configurationProvider.overrideWith(
            () => FakeConfiguration(settings),
          ),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(networkSettingsNeedRestartProvider), false);
    });

    test('returns false when networkSettingsModel is null', () {
      final settings = SideswapSettings.empty(
        mnemonicEncrypted: Uint8List(0),
        env: 1,
        networkSettingsModel: null,
      );

      final container = ProviderContainer.test(
        overrides: [
          configurationProvider.overrideWith(
            () => FakeConfiguration(settings),
          ),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(networkSettingsNeedRestartProvider), false);
    });
  });
}
