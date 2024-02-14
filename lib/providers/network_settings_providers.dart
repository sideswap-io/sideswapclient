import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/providers/config_provider.dart';

part 'network_settings_providers.freezed.dart';
part 'network_settings_providers.g.dart';

enum SettingsNetworkType {
  blockstream,
  sideswap,
  personal,
  sideswapChina,
}

@freezed
class NetworkSettingsModel with _$NetworkSettingsModel {
  const factory NetworkSettingsModel.empty({
    SettingsNetworkType? settingsNetworkType,
    int? env,
    String? host,
    int? port,
    bool? useTls,
  }) = NetworkSettingsModelEmpty;
  const factory NetworkSettingsModel.apply({
    SettingsNetworkType? settingsNetworkType,
    int? env,
    String? host,
    int? port,
    bool? useTls,
  }) = NetworkSettingsModelApply;

  factory NetworkSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$NetworkSettingsModelFromJson(json);
}

@riverpod
class NetworkSettingsNotifier extends _$NetworkSettingsNotifier {
  @override
  NetworkSettingsModel build() {
    final networkSettingsModel = ref.watch(
        configurationProvider.select((value) => value.networkSettingsModel));

    if (networkSettingsModel is NetworkSettingsModelEmpty ||
        networkSettingsModel == null) {
      final env = ref.watch(configurationProvider.select((value) => value.env));
      final settingsNetworkType = ref.watch(
          configurationProvider.select((value) => value.settingsNetworkType));
      final settingsHost =
          ref.watch(configurationProvider.select((value) => value.networkHost));
      final settingsPort =
          ref.watch(configurationProvider.select((value) => value.networkPort));
      final settingsUseTls = ref
          .watch(configurationProvider.select((value) => value.networkUseTLS));

      return NetworkSettingsModelEmpty(
          settingsNetworkType: settingsNetworkType,
          env: env,
          host: settingsHost,
          port: settingsPort,
          useTls: settingsUseTls);
    }

    return networkSettingsModel;
  }

  void setModel(NetworkSettingsModel networkSettingsModel) {
    // make sure that empty model have current base settings
    if (networkSettingsModel is NetworkSettingsModelEmpty) {
      final env = ref.read(configurationProvider).env;
      final settingsNetworkType =
          ref.read(configurationProvider).settingsNetworkType;
      final networkHost = ref.read(configurationProvider).networkHost;
      final networkPort = ref.read(configurationProvider).networkPort;
      final networkUseTls = ref.read(configurationProvider).networkUseTLS;
      state = NetworkSettingsModel.empty(
          settingsNetworkType: settingsNetworkType,
          env: env,
          host: networkHost,
          port: networkPort,
          useTls: networkUseTls);
      return;
    }

    state = networkSettingsModel;
  }

  void save() {
    ref.read(configurationProvider.notifier).setNetworkSettingsModel(state);
  }

  void applySettings() {
    if (state is NetworkSettingsModelApply) {
      final settingsNetworkType =
          ref.read(configurationProvider).settingsNetworkType;
      final settingsHost = ref.read(configurationProvider).networkHost;
      final settingsPort = ref.read(configurationProvider).networkPort;
      final settingsUseTls = ref.read(configurationProvider).networkUseTLS;
      final env = ref.read(configurationProvider).env;

      (switch (state.settingsNetworkType) {
        final newSettingsNetworkType?
            when newSettingsNetworkType != settingsNetworkType =>
          ref
              .read(configurationProvider.notifier)
              .setSettingsNetworkType(newSettingsNetworkType),
        _ => () {}(),
      });

      (switch (state.host) {
        final newHost? when newHost != settingsHost =>
          ref.read(configurationProvider.notifier).setNetworkHost(newHost),
        _ => () {}(),
      });

      (switch (state.port) {
        final newPort? when newPort != settingsPort =>
          ref.read(configurationProvider.notifier).setNetworkPort(newPort),
        _ => () {}(),
      });

      (switch (state.useTls) {
        final newUseTls? when newUseTls != settingsUseTls =>
          ref.read(configurationProvider.notifier).setNetworkUseTLS(newUseTls),
        _ => () {}(),
      });

      (switch (state.env) {
        final newEnv? when newEnv != env =>
          ref.read(configurationProvider.notifier).setEnv(newEnv),
        _ => () {}(),
      });

      setModel(const NetworkSettingsModelEmpty());
      save();
    }
  }
}

@riverpod
bool networkSettingsNeedSave(NetworkSettingsNeedSaveRef ref) {
  final configNetworkSettingsModel = ref.watch(
      configurationProvider.select((value) => value.networkSettingsModel));
  final networkSettingsModel = ref.watch(networkSettingsNotifierProvider);
  return networkSettingsModel != configNetworkSettingsModel;
}
