import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/env_provider.dart';

part 'network_settings_providers.freezed.dart';
part 'network_settings_providers.g.dart';

enum SettingsNetworkType {
  blockstream,
  sideswap,
  personal,
  sideswapChina,
}

@Freezed(equal: false)
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
      final host =
          ref.watch(configurationProvider.select((value) => value.networkHost));
      final port =
          ref.watch(configurationProvider.select((value) => value.networkPort));
      final useTls = ref
          .watch(configurationProvider.select((value) => value.networkUseTLS));

      return NetworkSettingsModelEmpty(
          settingsNetworkType: settingsNetworkType,
          env: env,
          host: host,
          port: port,
          useTls: useTls);
    }

    return networkSettingsModel;
  }

  void setModel(NetworkSettingsModel networkSettingsModel) {
    final settingsNetworkType =
        ref.read(configurationProvider).settingsNetworkType;
    final host = ref.read(configurationProvider).networkHost;
    final port = ref.read(configurationProvider).networkPort;
    final useTls = ref.read(configurationProvider).networkUseTLS;
    final env = ref.read(configurationProvider).env;

    // make sure that empty model have current base settings
    if (networkSettingsModel is NetworkSettingsModelEmpty) {
      state = NetworkSettingsModel.empty(
          settingsNetworkType: settingsNetworkType,
          env: env,
          host: host,
          port: port,
          useTls: useTls);
      return;
    }

    final oldNetworkSettingsModel = NetworkSettingsModel.apply(
        settingsNetworkType: settingsNetworkType,
        env: env,
        host: host,
        port: port,
        useTls: useTls);

    // if it's the same values like current, set model as empty
    if (networkSettingsModel == oldNetworkSettingsModel) {
      state = NetworkSettingsModel.empty(
          settingsNetworkType: networkSettingsModel.settingsNetworkType,
          env: networkSettingsModel.env,
          host: networkSettingsModel.host,
          port: networkSettingsModel.port,
          useTls: networkSettingsModel.useTls);
      save();
      return;
    }

    state = networkSettingsModel;
    save();
  }

  void save() {
    ref.read(configurationProvider.notifier).setNetworkSettingsModel(state);
  }

  void applySettings() {
    if (state is NetworkSettingsModelApply) {
      var sideswapSettings = ref.read(configurationProvider);

      (switch (state.settingsNetworkType) {
        final newSettingsNetworkType?
            when newSettingsNetworkType !=
                sideswapSettings.settingsNetworkType =>
          sideswapSettings = sideswapSettings.copyWith(
              settingsNetworkType: newSettingsNetworkType),
        _ => () {}(),
      });

      (switch (state.host) {
        final newHost? when newHost != sideswapSettings.networkHost =>
          sideswapSettings = sideswapSettings.copyWith(networkHost: newHost),
        _ => () {}(),
      });

      (switch (state.port) {
        final newPort? when newPort != sideswapSettings.networkPort =>
          sideswapSettings = sideswapSettings.copyWith(networkPort: newPort),
        _ => () {}(),
      });

      (switch (state.useTls) {
        final newUseTls? when newUseTls != sideswapSettings.networkUseTLS =>
          sideswapSettings =
              sideswapSettings.copyWith(networkUseTLS: newUseTls),
        _ => () {}(),
      });

      (switch (state.env) {
        final newEnv? when newEnv != sideswapSettings.env => sideswapSettings =
            sideswapSettings.copyWith(env: newEnv),
        _ => () {}(),
      });

      // cleanup apply state
      sideswapSettings = sideswapSettings.copyWith(
          networkSettingsModel: const NetworkSettingsModelEmpty());

      // save
      ref.read(configurationProvider.notifier).setSettings(sideswapSettings);
    }
  }
}

@riverpod
bool networkSettingsNeedSave(NetworkSettingsNeedSaveRef ref) {
  final settingsNetworkType = ref.watch(
      configurationProvider.select((value) => value.settingsNetworkType));
  final env = ref.watch(envProvider);

  final networkSettingsModel = ref.watch(networkSettingsNotifierProvider);

  return (networkSettingsModel is NetworkSettingsModelApply &&
      (networkSettingsModel.settingsNetworkType != settingsNetworkType ||
          networkSettingsModel.env != env));
}
