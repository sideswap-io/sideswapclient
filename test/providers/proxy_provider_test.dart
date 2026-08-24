import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/proxy_provider.dart';

import '../helpers/fake_configuration.dart';
import '../utils.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(
      ProxySettingsRepository(ProxySettings(), useProxy: false),
    );
  });
  group('ProxySettings', () {
    test('creates instance with host and port', () {
      final settings = ProxySettings(host: 'localhost', port: 8080);
      expect(settings.host, 'localhost');
      expect(settings.port, 8080);
    });

    test('creates instance with null host', () {
      final settings = ProxySettings(host: null, port: 8080);
      expect(settings.host, isNull);
      expect(settings.port, 8080);
    });

    test('creates instance with null port', () {
      final settings = ProxySettings(host: 'localhost', port: null);
      expect(settings.host, 'localhost');
      expect(settings.port, isNull);
    });

    test('creates instance with both null', () {
      final settings = ProxySettings(host: null, port: null);
      expect(settings.host, isNull);
      expect(settings.port, isNull);
    });
  });

  group('ProxySettingsRepository', () {
    group('getProxySettings', () {
      test(
        'sets proxy when useProxy is true and all fields are valid',
        () {
          final proxySettings = ProxySettings(host: 'proxy.example.com', port: 8080);
          final repo = ProxySettingsRepository(proxySettings, useProxy: true);

          final result = repo.getProxySettings();

          expect(result.proxy.host, 'proxy.example.com');
          expect(result.proxy.port, 8080);
        },
      );

      test(
        'does not set proxy when useProxy is false',
        () {
          final proxySettings = ProxySettings(host: 'proxy.example.com', port: 8080);
          final repo = ProxySettingsRepository(proxySettings, useProxy: false);

          final result = repo.getProxySettings();

          expect(result.proxy.host, '');
          expect(result.proxy.port, 0);
        },
      );

      test(
        'does not set proxy when host is null',
        () {
          final proxySettings = ProxySettings(host: null, port: 8080);
          final repo = ProxySettingsRepository(proxySettings, useProxy: true);

          final result = repo.getProxySettings();

          expect(result.proxy.host, '');
          expect(result.proxy.port, 0);
        },
      );

      test(
        'does not set proxy when host is empty',
        () {
          final proxySettings = ProxySettings(host: '', port: 8080);
          final repo = ProxySettingsRepository(proxySettings, useProxy: true);

          final result = repo.getProxySettings();

          expect(result.proxy.host, '');
          expect(result.proxy.port, 0);
        },
      );

      test(
        'does not set proxy when port is null',
        () {
          final proxySettings = ProxySettings(host: 'proxy.example.com', port: null);
          final repo = ProxySettingsRepository(proxySettings, useProxy: true);

          final result = repo.getProxySettings();

          expect(result.proxy.host, '');
          expect(result.proxy.port, 0);
        },
      );

      test(
        'does not set proxy when port is 0',
        () {
          final proxySettings = ProxySettings(host: 'proxy.example.com', port: 0);
          final repo = ProxySettingsRepository(proxySettings, useProxy: true);

          final result = repo.getProxySettings();

          expect(result.proxy.host, '');
          expect(result.proxy.port, 0);
        },
      );

      test(
        'does not set proxy when port is negative',
        () {
          final proxySettings = ProxySettings(host: 'proxy.example.com', port: -1);
          final repo = ProxySettingsRepository(proxySettings, useProxy: true);

          final result = repo.getProxySettings();

          expect(result.proxy.host, '');
          expect(result.proxy.port, 0);
        },
      );

      test(
        'does not set proxy when port equals 65535',
        () {
          final proxySettings = ProxySettings(host: 'proxy.example.com', port: 65535);
          final repo = ProxySettingsRepository(proxySettings, useProxy: true);

          final result = repo.getProxySettings();

          expect(result.proxy.host, '');
          expect(result.proxy.port, 0);
        },
      );

      test(
        'does not set proxy when port is greater than 65535',
        () {
          final proxySettings = ProxySettings(host: 'proxy.example.com', port: 65536);
          final repo = ProxySettingsRepository(proxySettings, useProxy: true);

          final result = repo.getProxySettings();

          expect(result.proxy.host, '');
          expect(result.proxy.port, 0);
        },
      );

      test(
        'sets proxy when port is 1 (minimum valid)',
        () {
          final proxySettings = ProxySettings(host: 'proxy.example.com', port: 1);
          final repo = ProxySettingsRepository(proxySettings, useProxy: true);

          final result = repo.getProxySettings();

          expect(result.proxy.host, 'proxy.example.com');
          expect(result.proxy.port, 1);
        },
      );

      test(
        'sets proxy when port is 65534 (maximum valid)',
        () {
          final proxySettings = ProxySettings(host: 'proxy.example.com', port: 65534);
          final repo = ProxySettingsRepository(proxySettings, useProxy: true);

          final result = repo.getProxySettings();

          expect(result.proxy.host, 'proxy.example.com');
          expect(result.proxy.port, 65534);
        },
      );

      test(
        'does not set proxy when useProxy is true but multiple fields invalid',
        () {
          final proxySettings = ProxySettings(host: '', port: -1);
          final repo = ProxySettingsRepository(proxySettings, useProxy: true);

          final result = repo.getProxySettings();

          expect(result.proxy.host, '');
          expect(result.proxy.port, 0);
        },
      );

      test(
        'returns empty To_ProxySettings when useProxy is false regardless of fields',
        () {
          final proxySettings = ProxySettings(host: 'proxy.example.com', port: 8080);
          final repo = ProxySettingsRepository(proxySettings, useProxy: false);

          final result = repo.getProxySettings();

          expect(result.proxy.host, '');
          expect(result.proxy.port, 0);
          expect(result.hasProxy(), false);
        },
      );
    });
  });

  group('ProxySettingsRepositoryNotifier', () {
    group('build', () {
      test(
        'returns repository with proxy settings and useProxy from configuration',
        () {
          final proxySettings = ProxySettings(host: 'proxy.example.com', port: 8080);
          final settings = SideswapSettings.empty(
            mnemonicEncrypted: Uint8List.fromList([]),
            proxySettings: proxySettings,
            useProxy: true,
          );

          final container = ProviderContainer.test(
            overrides: [
              configurationProvider.overrideWith(
                () => FakeConfiguration(settings),
              ),
            ],
          );
          addTearDown(container.dispose);

          final repo = container.read(proxySettingsRepositoryProvider);

          expect(repo, isA<ProxySettingsRepository>());
          expect((repo as ProxySettingsRepository).proxySettings, proxySettings);
          expect(repo.useProxy, true);
        },
      );

      test(
        'returns repository with default proxy settings when config provides null',
        () {
          final settings = SideswapSettings.empty(
            mnemonicEncrypted: Uint8List.fromList([]),
            proxySettings: null,
            useProxy: false,
          );

          final container = ProviderContainer.test(
            overrides: [
              configurationProvider.overrideWith(
                () => FakeConfiguration(settings),
              ),
            ],
          );
          addTearDown(container.dispose);

          final repo = container.read(proxySettingsRepositoryProvider) as ProxySettingsRepository;

          expect(repo, isA<ProxySettingsRepository>());
          final defaultSettings = repo.proxySettings;
          expect(defaultSettings.host, isNull);
          expect(defaultSettings.port, isNull);
          expect(repo.useProxy, false);
        },
      );

      test(
        'returns repository with useProxy disabled when config provides false',
        () {
          final proxySettings = ProxySettings(host: 'proxy.example.com', port: 8080);
          final settings = SideswapSettings.empty(
            mnemonicEncrypted: Uint8List.fromList([]),
            proxySettings: proxySettings,
            useProxy: false,
          );

          final container = ProviderContainer.test(
            overrides: [
              configurationProvider.overrideWith(
                () => FakeConfiguration(settings),
              ),
            ],
          );
          addTearDown(container.dispose);

          final repo = container.read(proxySettingsRepositoryProvider) as ProxySettingsRepository;

          expect(repo.useProxy, false);
        },
      );

      test(
        'updates repository when configuration changes',
        () {
          final proxySettings1 = ProxySettings(host: 'proxy1.example.com', port: 8080);
          final settings1 = SideswapSettings.empty(
            mnemonicEncrypted: Uint8List.fromList([]),
            proxySettings: proxySettings1,
            useProxy: true,
          );

          final container = ProviderContainer.test(
            overrides: [
              configurationProvider.overrideWith(
                () => FakeConfiguration(settings1),
              ),
            ],
          );
          addTearDown(container.dispose);

          var repo = container.read(proxySettingsRepositoryProvider) as ProxySettingsRepository;
          expect(repo.proxySettings.host, 'proxy1.example.com');

          final proxySettings2 = ProxySettings(host: 'proxy2.example.com', port: 9090);
          final settings2 = SideswapSettings.empty(
            mnemonicEncrypted: Uint8List.fromList([]),
            proxySettings: proxySettings2,
            useProxy: true,
          );

          container.invalidate(configurationProvider);
          container.read(configurationProvider);

          // Override with new configuration
          final newContainer = ProviderContainer.test(
            overrides: [
              configurationProvider.overrideWith(
                () => FakeConfiguration(settings2),
              ),
            ],
          );
          addTearDown(newContainer.dispose);

          repo = newContainer.read(proxySettingsRepositoryProvider) as ProxySettingsRepository;
          expect(repo.proxySettings.host, 'proxy2.example.com');
        },
      );
    });

    group('setState', () {
      test(
        'updates state with new repository',
        () {
          final initialSettings = SideswapSettings.empty(
            mnemonicEncrypted: Uint8List.fromList([]),
            proxySettings: null,
            useProxy: false,
          );

          final container = ProviderContainer.test(
            overrides: [
              configurationProvider.overrideWith(
                () => FakeConfiguration(initialSettings),
              ),
            ],
          );
          addTearDown(container.dispose);

          final listener = ProviderListener<AbstractProxySettingsRepository>();
          container.listen(
            proxySettingsRepositoryProvider,
            listener.call,
            fireImmediately: true,
          );

          final notifier = container.read(proxySettingsRepositoryProvider.notifier);
          final newRepo = ProxySettingsRepository(
            ProxySettings(host: 'newproxy.example.com', port: 3128),
            useProxy: true,
          );

          notifier.setState(newRepo);

          final updatedRepo = container.read(proxySettingsRepositoryProvider) as ProxySettingsRepository;
          expect(updatedRepo.proxySettings.host, 'newproxy.example.com');
          expect(updatedRepo.proxySettings.port, 3128);
          expect(updatedRepo.useProxy, true);
        },
      );

      test(
        'fires listener when setState is called',
        () {
          final initialSettings = SideswapSettings.empty(
            mnemonicEncrypted: Uint8List.fromList([]),
            proxySettings: ProxySettings(host: 'old.example.com', port: 8080),
            useProxy: true,
          );

          final container = ProviderContainer.test(
            overrides: [
              configurationProvider.overrideWith(
                () => FakeConfiguration(initialSettings),
              ),
            ],
          );
          addTearDown(container.dispose);

          final listener = ProviderListener<AbstractProxySettingsRepository>();
          container.listen(
            proxySettingsRepositoryProvider,
            listener.call,
            fireImmediately: true,
          );

          verify(() => listener(any(), any())).called(1);
          clearInteractions(listener);

          final notifier = container.read(proxySettingsRepositoryProvider.notifier);
          final newRepo = ProxySettingsRepository(
            ProxySettings(host: 'new.example.com', port: 9090),
            useProxy: false,
          );

          notifier.setState(newRepo);

          verify(() => listener(any(), any())).called(1);
          verifyNoMoreInteractions(listener);
        },
      );
    });
  });
}
