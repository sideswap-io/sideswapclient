import 'dart:convert';
import 'dart:typed_data';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/models/pin_models.dart';
import 'package:sideswap/providers/locales_provider.dart';
import 'package:sideswap/providers/network_settings_providers.dart';

import 'package:sideswap/providers/phone_provider.dart';
import 'package:sideswap/providers/proxy_provider.dart';
import 'package:sideswap/providers/stokr_providers.dart';
import 'package:sideswap/providers/warmup_app_provider.dart';

part 'config_provider.freezed.dart';
part 'config_provider.g.dart';

@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(SharedPreferencesRef ref) {
  throw UnimplementedError();
}

@freezed
class SideswapSettings with _$SideswapSettings {
  factory SideswapSettings.empty({
    required Uint8List mnemonicEncrypted,
    @Default('') String jadeId,
    @Default(false) bool licenseAccepted,
    @Default(true) bool enableEndpoint,
    @Default(false) bool useBiometricProtection,
    @Default(0) int env,
    @Default('') String phoneKey,
    @Default('') String phoneNumber,
    @Default(false) bool usePinProtection,
    PinDataState? pinDataState,
    @Default(SettingsNetworkType.sideswap)
    SettingsNetworkType settingsNetworkType,
    @Default('') String networkHost,
    @Default(0) int networkPort,
    @Default(false) bool networkUseTLS,
    @Default(0) int knownNewReleaseBuild,
    @Default(true) bool showAmpOnboarding,
    NetworkSettingsModel? networkSettingsModel,
    @Default(false) bool hideTxChainingPromptValue,
    @Default(false) bool hidePegInInfo,
    @Default(false) bool hidePegOutInfo,
    ProxySettings? proxySettings,
    @Default(false) bool useProxy,
    String? defaultCurrency,
    StokrSettingsModel? stokrSettingsModel,
  }) = _SideswapSettings;

  factory SideswapSettings({
    required String jadeId,
    required bool licenseAccepted,
    required bool enableEndpoint,
    required bool useBiometricProtection,
    required int env,
    required String phoneKey,
    required String phoneNumber,
    required bool usePinProtection,
    PinDataState? pinDataState,
    required SettingsNetworkType settingsNetworkType,
    required String networkHost,
    required int networkPort,
    required bool networkUseTLS,
    String? settings,
    required int knownNewReleaseBuild,
    required bool showAmpOnboarding,
    NetworkSettingsModel? networkSettingsModel,
    required bool hideTxChainingPromptValue,
    required bool hidePegInInfo,
    required bool hidePegOutInfo,
    ProxySettings? proxySettings,
    required bool useProxy,
    String? defaultCurrency,
    StokrSettingsModel? stokrSettingsModel,
  }) {
    return _SideswapSettings(mnemonicEncrypted: Uint8List.fromList([]));
  }

  // do not change EVER this fields. It will broke user configuration
  static const mnemonicEncryptedField = 'mnemonic_encrypted';
  static const jadeIdField = 'jade_id';
  static const licenseAcceptedField = 'license_accepted';
  static const enableEndpointField = 'enable_endpoint';
  static const useBiometricProtectionField = 'biometric_protection';
  static const envField = 'env';
  static const phoneKeyField = 'phoneKey';
  static const phoneNumberField = 'phoneNumber';
  static const usePinProtectionField = 'pinProtectionField';
  static const pinSaltField = 'pinSalt';
  static const pinEncryptedDataField = 'pinEncryptedData';
  static const pinIdentifierField = 'pinIdentifierField';
  static const pinHmacField = 'pinHmac';
  static const settingsNetworkTypeField = 'settingsNetworkTypeFieldNew';
  static const settingsHostField = 'settingsHostFieldNew';
  static const settingsPortField = 'settingsPortFieldNew';
  static const settingsUseTLSField = 'settingsUseTLSFieldNew';
  static const knownNewReleaseField = 'known_new_release';
  static const showAmpOnboardingField = 'show_amp_onboarding';
  static const networkSettingsModelField = 'network_settings_model';
  static const hideTxChainingPromptField = 'hide_tx_chaining_prompt';
  static const hidePegInInfoField = 'hide_peg_in_info';
  static const hidePegOutInfoField = 'hide_peg_out_info_new';
  static const proxyHostField = 'proxyHost';
  static const proxyPortField = 'proxyPort';
  static const useProxyField = 'useProxy';
  static const defaultCurrencyField = 'defaultCurrency';
  static const stokrSettingsModelField = 'stokrSettings';
}

@riverpod
class Configuration extends _$Configuration {
  @override
  SideswapSettings build() {
    ref.listenSelf((_, __) async {
      final prefs = ref.read(sharedPreferencesProvider);
      await _saveSettings(prefs);
    });

    final prefs = ref.watch(sharedPreferencesProvider);

    final settings = _readSettings(prefs);
    return settings;
  }

  SideswapSettings _readSettings(SharedPreferences prefs) {
    return SideswapSettings.empty(
      mnemonicEncrypted: _mnemonicEncrypted(prefs),
      jadeId: _jadeId(prefs),
      licenseAccepted: _licenseAccepted(prefs),
      enableEndpoint: _enableEndpoint(prefs),
      useBiometricProtection: _useBiometricProtection(prefs),
      env: _env(prefs),
      phoneKey: _phoneKey(prefs),
      phoneNumber: _phoneNumber(prefs),
      usePinProtection: _usePinProtection(prefs),
      pinDataState: _pinData(prefs),
      settingsNetworkType: _settingsNetworkType(prefs),
      networkHost: _networkHost(prefs),
      networkPort: _networkPort(prefs),
      networkUseTLS: _networkUseTLS(prefs),
      knownNewReleaseBuild: _knownNewReleaseBuild(prefs),
      showAmpOnboarding: _showAmpOnboarding(prefs),
      networkSettingsModel: _networkSettingsModel(prefs),
      hideTxChainingPromptValue: _hideTxChainingPromptValue(prefs),
      hidePegInInfo: _hidePegInInfo(prefs),
      hidePegOutInfo: _hidePegOutInfo(prefs),
      proxySettings: _proxySettings(prefs),
      useProxy: _useProxy(prefs),
      defaultCurrency: _defaultCurrency(prefs),
      stokrSettingsModel: _stokrSettings(prefs),
    );
  }

  Future<void> _saveSettings(SharedPreferences prefs) async {
    await _setMnemonicEncrypted(prefs, state.mnemonicEncrypted);
    await _setJadeId(prefs, state.jadeId);
    await _setLicenseAccepted(prefs, state.licenseAccepted);
    await _setEnableEndpoint(prefs, state.enableEndpoint);
    await _setUseBiometricProtection(prefs, state.useBiometricProtection);
    await _setEnv(prefs, state.env);
    await _setPhoneKey(prefs, state.phoneKey);
    await _setPhoneNumber(prefs, state.phoneNumber);
    await _setUsePinProtection(prefs, state.usePinProtection);
    await _setPinData(prefs, state.pinDataState);
    await _setSettingsNetworkType(prefs, state.settingsNetworkType);
    await _setNetworkHost(prefs, state.networkHost);
    await _setNetworkPort(prefs, state.networkPort);
    await _setNetworkUseTLS(prefs, state.networkUseTLS);
    await _setKnownNewReleaseBuild(prefs, state.knownNewReleaseBuild);
    await _setShowAmpOnboarding(prefs, state.showAmpOnboarding);
    await _setNetworkSettingsModel(prefs, state.networkSettingsModel);
    await _setHideTxChainingPromptValue(prefs, state.hideTxChainingPromptValue);
    await _setHidePegInInfo(prefs, state.hidePegInInfo);
    await _setHidePegOutInfo(prefs, state.hidePegOutInfo);
    await _setProxySettings(prefs, state.proxySettings);
    await _setUseProxy(prefs, state.useProxy);
    await _setDefaultCurrency(prefs, state.defaultCurrency);
    await _setStokrSettings(prefs, state.stokrSettingsModel);
  }

  bool isRegistered() {
    final prefs = ref.read(sharedPreferencesProvider);
    final mnemonic = _mnemonicEncrypted(prefs);
    return mnemonic.isNotEmpty;
  }

  void setSettings(SideswapSettings sideswapSettings) {
    state = sideswapSettings;
  }

  void setDefaultCurrency(String defaultCurrency) {
    state = state.copyWith(defaultCurrency: defaultCurrency);
  }

  void setMnemonicEncrypted(Uint8List mnemonicEncrypted) {
    state = state.copyWith(mnemonicEncrypted: mnemonicEncrypted);
  }

  void setJadeId(String jadeId) {
    state = state.copyWith(jadeId: jadeId);
  }

  void setLicenseAccepted(bool licenseAccepted) {
    state = state.copyWith(licenseAccepted: licenseAccepted);
  }

  void setEnableEndpoint(bool enableEndpoint) {
    state = state.copyWith(enableEndpoint: enableEndpoint);
  }

  void setUseBiometricProtection(bool useBiometricProtection) {
    state = state.copyWith(useBiometricProtection: useBiometricProtection);
  }

  void setEnv(int env) {
    state = state.copyWith(env: env);
  }

  void setPhoneKey(String phoneKey) {
    state = state.copyWith(phoneKey: phoneKey);
  }

  void setPhoneNumber(String phoneNumber) {
    state = state.copyWith(phoneNumber: phoneNumber);
  }

  void setUsePinProtection(bool usePinProtection) {
    state = state.copyWith(usePinProtection: usePinProtection);
  }

  void setPinData(PinDataStateData? pinData) {
    state = state.copyWith(pinDataState: pinData);
  }

  void setSettingsNetworkType(SettingsNetworkType settingsNetworkType) {
    state = state.copyWith(settingsNetworkType: settingsNetworkType);
  }

  void setNetworkHost(String networkHost) {
    state = state.copyWith(networkHost: networkHost);
  }

  void setNetworkPort(int networkPort) {
    state = state.copyWith(networkPort: networkPort);
  }

  void setNetworkUseTLS(bool networkUseTLS) {
    state = state.copyWith(networkUseTLS: networkUseTLS);
  }

  void setKnownNewReleaseBuild(int knownNewReleaseBuild) {
    state = state.copyWith(knownNewReleaseBuild: knownNewReleaseBuild);
  }

  void setShowAmpOnboarding(bool showAmpOnboarding) {
    state = state.copyWith(showAmpOnboarding: showAmpOnboarding);
  }

  void setNetworkSettingsModel(NetworkSettingsModel? networkSettingsModel) {
    state = state.copyWith(networkSettingsModel: networkSettingsModel);
  }

  void setStokrSettingsModel(StokrSettingsModel? stokrSettingsModel) {
    state = state.copyWith(stokrSettingsModel: stokrSettingsModel);
  }

  void setHideTxChainingPromptValue(bool hideTxChainingPromptValue) {
    state =
        state.copyWith(hideTxChainingPromptValue: hideTxChainingPromptValue);
  }

  void setHidePegInInfo(bool hidePegInInfo) {
    state = state.copyWith(hidePegInInfo: hidePegInInfo);
  }

  void setHidePegOutInfo(bool hidePegOutInfo) {
    state = state.copyWith(hidePegOutInfo: hidePegOutInfo);
  }

  void setProxySettings(ProxySettings? proxySettings) {
    state = state.copyWith(proxySettings: proxySettings);
  }

  void setUseProxy(bool useProxy) {
    state = state.copyWith(useProxy: useProxy);
  }

  Future<void> deleteConfig() async {
    final currentEnv = state.env;
    ref
        .read(phoneProvider)
        .setConfirmPhoneData(confirmPhoneData: ConfirmPhoneData());
    state = SideswapSettings.empty(
        mnemonicEncrypted: Uint8List.fromList([]),
        env: currentEnv,
        showAmpOnboarding: true);

    final prefs = ref.read(sharedPreferencesProvider);
    await _saveSettings(prefs);
  }

  ///
  /// Shared preferences functions
  String? _defaultCurrency(SharedPreferences prefs) {
    return prefs.getString(SideswapSettings.defaultCurrencyField);
  }

  Uint8List _mnemonicEncrypted(SharedPreferences prefs) {
    return base64
        .decode(prefs.getString(SideswapSettings.mnemonicEncryptedField) ?? '');
  }

  Future<void> _setMnemonicEncrypted(
      SharedPreferences prefs, Uint8List mnemonicEncrypted) async {
    return switch (mnemonicEncrypted.isEmpty) {
      true => () async {
          await prefs.remove(SideswapSettings.mnemonicEncryptedField);
        }(),
      _ => () async {
          await prefs.setString(SideswapSettings.mnemonicEncryptedField,
              base64.encode(mnemonicEncrypted));
        }(),
    };
  }

  String _jadeId(SharedPreferences prefs) {
    return prefs.getString(SideswapSettings.jadeIdField) ?? '';
  }

  Future<void> _setJadeId(SharedPreferences prefs, String jadeId) async {
    await prefs.setString(SideswapSettings.jadeIdField, jadeId);
  }

  bool _licenseAccepted(SharedPreferences prefs) {
    return prefs.getBool(SideswapSettings.licenseAcceptedField) ?? false;
  }

  Future<void> _setLicenseAccepted(
      SharedPreferences prefs, bool licenseAccepted) async {
    await prefs.setBool(SideswapSettings.licenseAcceptedField, licenseAccepted);
  }

  bool _enableEndpoint(SharedPreferences prefs) {
    return prefs.getBool(SideswapSettings.enableEndpointField) ?? true;
  }

  Future<void> _setEnableEndpoint(
      SharedPreferences prefs, bool enableEndpoint) async {
    await prefs.setBool(SideswapSettings.enableEndpointField, enableEndpoint);
  }

  bool _useBiometricProtection(SharedPreferences prefs) {
    return prefs.getBool(SideswapSettings.useBiometricProtectionField) ?? false;
  }

  Future<void> _setUseBiometricProtection(
      SharedPreferences prefs, bool useBiometricProtection) async {
    await prefs.setBool(
        SideswapSettings.useBiometricProtectionField, useBiometricProtection);
  }

  int _env(SharedPreferences prefs) {
    return prefs.getInt(SideswapSettings.envField) ?? 0;
  }

  Future<void> _setEnv(SharedPreferences prefs, int env) async {
    await prefs.setInt(SideswapSettings.envField, env);
  }

  Future<void> _setPhoneKey(SharedPreferences prefs, String phoneKey) async {
    await prefs.setString(SideswapSettings.phoneKeyField, phoneKey);
  }

  String _phoneKey(SharedPreferences prefs) {
    return prefs.getString(SideswapSettings.phoneKeyField) ?? '';
  }

  Future<void> _setPhoneNumber(
      SharedPreferences prefs, String phoneNumber) async {
    await prefs.setString(SideswapSettings.phoneNumberField, phoneNumber);
  }

  String _phoneNumber(SharedPreferences prefs) {
    return prefs.getString(SideswapSettings.phoneNumberField) ?? '';
  }

  Future<void> _setUsePinProtection(
      SharedPreferences prefs, bool usePinProtection) async {
    await prefs.setBool(
        SideswapSettings.usePinProtectionField, usePinProtection);
  }

  bool _usePinProtection(SharedPreferences prefs) {
    return prefs.getBool(SideswapSettings.usePinProtectionField) ?? false;
  }

  PinDataState? _pinData(SharedPreferences prefs) {
    final salt = prefs.getString(SideswapSettings.pinSaltField);
    final encryptedData =
        prefs.getString(SideswapSettings.pinEncryptedDataField);
    final pinIdentifier = prefs.getString(SideswapSettings.pinIdentifierField);
    final pinHmac = prefs.getString(SideswapSettings.pinHmacField);

    final pinData = PinDataStateData(
      salt: salt ?? '',
      encryptedData: encryptedData ?? '',
      pinIdentifier: pinIdentifier ?? '',
      hmac: pinHmac ?? '',
    );

    return switch (pinData) {
      PinDataStateData(
        salt: final salt,
        encryptedData: final encryptedData,
        pinIdentifier: final pinIdentifier
      )
          when salt.isNotEmpty &&
              encryptedData.isNotEmpty &&
              pinIdentifier.isNotEmpty =>
        pinData,
      _ => const PinDataStateEmpty(),
    };
  }

  Future<void> _setDefaultCurrency(
      SharedPreferences prefs, String? defaultCurrency) async {
    (switch (defaultCurrency) {
      final defaultCurrency? => await prefs.setString(
          SideswapSettings.defaultCurrencyField, defaultCurrency),
      _ => () {}(),
    });
  }

  Future<void> _setPinData(
      SharedPreferences prefs, PinDataState? pinData) async {
    return switch (pinData) {
      PinDataStateData(
        salt: final salt,
        encryptedData: final encryptedData,
        pinIdentifier: final pinIdentifier,
        hmac: final pinHmac,
      )
          when salt.isNotEmpty &&
              encryptedData.isNotEmpty &&
              pinIdentifier.isNotEmpty =>
        () async {
          await prefs.setString(SideswapSettings.pinSaltField, salt);
          await prefs.setString(
              SideswapSettings.pinEncryptedDataField, encryptedData);
          await prefs.setString(
              SideswapSettings.pinIdentifierField, pinIdentifier);
          await prefs.setString(SideswapSettings.pinHmacField, pinHmac);
        }(),
      _ => () async {
          await prefs.remove(SideswapSettings.pinEncryptedDataField);
          await prefs.remove(SideswapSettings.pinIdentifierField);
          await prefs.remove(SideswapSettings.pinSaltField);
          await prefs.remove(SideswapSettings.pinHmacField);
        }(),
    };
  }

  Future<void> _setSettingsNetworkType(
      SharedPreferences prefs, SettingsNetworkType type) async {
    await prefs.setString(SideswapSettings.settingsNetworkTypeField,
        EnumToString.convertToString(type));
  }

  SettingsNetworkType _settingsNetworkType(SharedPreferences prefs) {
    final typeString =
        prefs.getString(SideswapSettings.settingsNetworkTypeField);

    final settingsNetworkType = switch (typeString) {
      final notNullString? =>
        EnumToString.fromString(SettingsNetworkType.values, notNullString),
      _ => null,
    };

    final context = ref.read(navigatorKeyProvider).currentContext;
    final lang = ref.read(localesNotifierProvider);
    if (settingsNetworkType == null && context != null && lang == 'zh') {
      return SettingsNetworkType.sideswapChina;
    }

    if (settingsNetworkType == null) {
      return SettingsNetworkType.sideswap;
    }

    return settingsNetworkType;
  }

  Future<void> _setNetworkHost(SharedPreferences prefs, String host) async {
    await prefs.setString(SideswapSettings.settingsHostField, host);
  }

  String _networkHost(SharedPreferences prefs) {
    return prefs.getString(SideswapSettings.settingsHostField) ?? '';
  }

  Future<void> _setNetworkPort(SharedPreferences prefs, int port) async {
    await prefs.setInt(SideswapSettings.settingsPortField, port);
  }

  int _networkPort(SharedPreferences prefs) {
    return prefs.getInt(SideswapSettings.settingsPortField) ?? 0;
  }

  Future<void> _setNetworkUseTLS(SharedPreferences prefs, bool value) async {
    await prefs.setBool(SideswapSettings.settingsUseTLSField, value);
  }

  bool _networkUseTLS(SharedPreferences prefs) {
    return prefs.getBool(SideswapSettings.settingsUseTLSField) ?? false;
  }

  Future<void> _setKnownNewReleaseBuild(
      SharedPreferences prefs, int value) async {
    await prefs.setInt(SideswapSettings.knownNewReleaseField, value);
  }

  int _knownNewReleaseBuild(SharedPreferences prefs) {
    return prefs.getInt(SideswapSettings.knownNewReleaseField) ?? 0;
  }

  Future<void> _setShowAmpOnboarding(
      SharedPreferences prefs, bool value) async {
    await prefs.setBool(SideswapSettings.showAmpOnboardingField, value);
  }

  bool _showAmpOnboarding(SharedPreferences prefs) {
    return prefs.getBool(SideswapSettings.showAmpOnboardingField) ?? true;
  }

  Future<void> _setNetworkSettingsModel(
      SharedPreferences prefs, NetworkSettingsModel? model) async {
    return switch (model) {
      final model? => () async {
          final encoded = jsonEncode(model.toJson());
          await prefs.setString(
              SideswapSettings.networkSettingsModelField, encoded);
        }(),
      _ => () async {
          await prefs.remove(SideswapSettings.networkSettingsModelField);
        }(),
    };
  }

  NetworkSettingsModel _networkSettingsModel(SharedPreferences prefs) {
    final encoded = prefs.getString(SideswapSettings.networkSettingsModelField);

    try {
      return switch (encoded) {
        final encodedJson? => () {
            final json = jsonDecode(encodedJson) as Map<String, dynamic>;
            return NetworkSettingsModel.fromJson(json);
          }(),
        _ => () {
            return NetworkSettingsModelEmpty(
              settingsNetworkType: _settingsNetworkType(prefs),
              env: _env(prefs),
            );
          }(),
      };
    } catch (e) {
      logger.w(e);
    }

    return NetworkSettingsModelEmpty(
      settingsNetworkType: _settingsNetworkType(prefs),
      env: _env(prefs),
    );
  }

  Future<void> _setStokrSettings(
      SharedPreferences prefs, StokrSettingsModel? model) async {
    return switch (model) {
      final model? => () async {
          final encoded = jsonEncode(model.toJson());
          await prefs.setString(
              SideswapSettings.stokrSettingsModelField, encoded);
        }(),
      _ => () async {
          await prefs.remove(SideswapSettings.stokrSettingsModelField);
        }(),
    };
  }

  StokrSettingsModel _stokrSettings(SharedPreferences prefs) {
    final encoded = prefs.getString(SideswapSettings.stokrSettingsModelField);

    try {
      return switch (encoded) {
        final encodedJson? => () {
            final json = jsonDecode(encodedJson) as Map<String, dynamic>;
            return StokrSettingsModel.fromJson(json);
          }(),
        _ => () {
            return const StokrSettingsModel();
          }(),
      };
    } catch (e) {
      logger.e(e);
    }

    return const StokrSettingsModel();
  }

  Future<void> _setHideTxChainingPromptValue(
      SharedPreferences prefs, bool value) async {
    await prefs.setBool(SideswapSettings.hideTxChainingPromptField, value);
  }

  bool _hideTxChainingPromptValue(SharedPreferences prefs) {
    return prefs.getBool(SideswapSettings.hideTxChainingPromptField) ?? false;
  }

  Future<void> _setHidePegInInfo(
      SharedPreferences prefs, bool hidePegInInfo) async {
    await prefs.setBool(SideswapSettings.hidePegInInfoField, hidePegInInfo);
  }

  bool _hidePegInInfo(SharedPreferences prefs) {
    return prefs.getBool(SideswapSettings.hidePegInInfoField) ?? false;
  }

  Future<void> _setHidePegOutInfo(
      SharedPreferences prefs, bool hidePegOutInfo) async {
    await prefs.setBool(SideswapSettings.hidePegOutInfoField, hidePegOutInfo);
  }

  bool _hidePegOutInfo(SharedPreferences prefs) {
    return prefs.getBool(SideswapSettings.hidePegOutInfoField) ?? false;
  }

  Future<void> _setProxySettings(
    SharedPreferences prefs,
    ProxySettings? proxySettings,
  ) async {
    return switch (proxySettings) {
      ProxySettings(host: String host, port: int port) => () async {
          await prefs.setString(SideswapSettings.proxyHostField, host);
          await prefs.setInt(SideswapSettings.proxyPortField, port);
        }(),
      _ => () async {
          await prefs.remove(SideswapSettings.proxyHostField);
          await prefs.remove(SideswapSettings.proxyPortField);
        }(),
    };
  }

  ProxySettings? _proxySettings(SharedPreferences prefs) {
    final host = prefs.getString(SideswapSettings.proxyHostField);
    final port = prefs.getInt(SideswapSettings.proxyPortField);

    final proxySettings = ProxySettings(host: host, port: port);

    return switch (proxySettings) {
      // ignore: non_constant_identifier_names, constant_identifier_names
      ProxySettings(host: String _, port: int __) => proxySettings,
      _ => null,
    };
  }

  Future<void> _setUseProxy(SharedPreferences prefs, bool useProxy) async {
    await prefs.setBool(SideswapSettings.useProxyField, useProxy);
  }

  bool _useProxy(SharedPreferences prefs) {
    return prefs.getBool(SideswapSettings.useProxyField) ?? false;
  }
}
