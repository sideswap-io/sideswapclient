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
    final networkSettingsModel =
        ref.watch(configProvider.select((value) => value.networkSettingsModel));

    if (networkSettingsModel is NetworkSettingsModelEmpty) {
      final env = ref.watch(configProvider.select((value) => value.env));
      final settingsNetworkType = ref
          .watch(configProvider.select((value) => value.settingsNetworkType));
      final settingsHost =
          ref.watch(configProvider.select((value) => value.settingsHost));
      final settingsPort =
          ref.watch(configProvider.select((value) => value.settingsPort));
      final settingsUseTls =
          ref.watch(configProvider.select((value) => value.settingsUseTLS));

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
      final env = ref.read(configProvider).env;
      final settingsNetworkType = ref.read(configProvider).settingsNetworkType;
      final settingsHost = ref.read(configProvider).settingsHost;
      final settingsPort = ref.read(configProvider).settingsPort;
      final settingsUseTls = ref.read(configProvider).settingsUseTLS;
      state = NetworkSettingsModel.empty(
          settingsNetworkType: settingsNetworkType,
          env: env,
          host: settingsHost,
          port: settingsPort,
          useTls: settingsUseTls);
      return;
    }

    state = networkSettingsModel;
  }

  Future<void> save() async {
    await ref.read(configProvider).setNetworkSettingsModel(state);
  }

  Future<void> applySettings() async {
    if (state is NetworkSettingsModelApply) {
      final settingsNetworkType = ref.read(configProvider).settingsNetworkType;
      final settingsHost = ref.read(configProvider).settingsHost;
      final settingsPort = ref.read(configProvider).settingsPort;
      final settingsUseTls = ref.read(configProvider).settingsUseTLS;
      final env = ref.read(configProvider).env;

      (switch (state.settingsNetworkType) {
        final newSettingsNetworkType?
            when newSettingsNetworkType != settingsNetworkType =>
          ref
              .read(configProvider)
              .setSettingsNetworkType(newSettingsNetworkType),
        _ => () {}(),
      });

      (switch (state.host) {
        final newHost? when newHost != settingsHost =>
          ref.read(configProvider).setSettingsHost(newHost),
        _ => () {}(),
      });

      (switch (state.port) {
        final newPort? when newPort != settingsPort =>
          ref.read(configProvider).setSettingsPort(newPort),
        _ => () {}(),
      });

      (switch (state.useTls) {
        final newUseTls? when newUseTls != settingsUseTls =>
          ref.read(configProvider).setSettingsUseTLS(newUseTls),
        _ => () {}(),
      });

      (switch (state.env) {
        final newEnv? when newEnv != env =>
          ref.read(configProvider).setEnv(newEnv),
        _ => () {}(),
      });

      setModel(const NetworkSettingsModelEmpty());
      await save();
    }
  }
}

@riverpod
bool networkSettingsNeedSave(NetworkSettingsNeedSaveRef ref) {
  final configNetworkSettingsModel =
      ref.watch(configProvider.select((value) => value.networkSettingsModel));
  final networkSettingsModel = ref.watch(networkSettingsNotifierProvider);
  return networkSettingsModel != configNetworkSettingsModel;
}
