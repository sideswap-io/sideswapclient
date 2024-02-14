import 'dart:convert';
import 'dart:typed_data';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/providers/network_settings_providers.dart';

import 'package:sideswap/providers/phone_provider.dart';
import 'package:sideswap/providers/wallet.dart';

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
    PinData? pinData,
    @Default(SettingsNetworkType.sideswap)
    SettingsNetworkType settingsNetworkType,
    @Default('') String networkHost,
    @Default(0) int networkPort,
    @Default(false) bool networkUseTLS,
    String? settings,
    @Default(0) int knownNewReleaseBuild,
    @Default(true) bool showAmpOnboarding,
    NetworkSettingsModel? networkSettingsModel,
    @Default(false) bool hideTxChainingPromptValue,
    @Default(false) bool hidePegInInfo,
    @Default(false) bool hidePegOutInfo,
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
    PinData? pinData,
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
  static const settingsNetworkTypeField = 'settingsNetworkTypeFieldNew';
  static const settingsHostField = 'settingsHostFieldNew';
  static const settingsPortField = 'settingsPortFieldNew';
  static const settingsUseTLSField = 'settingsUseTLSFieldNew';
  static const settingsField = 'settings';
  static const knownNewReleaseField = 'known_new_release';
  static const showAmpOnboardingField = 'show_amp_onboarding';
  static const networkSettingsModelField = 'network_settings_model';
  static const hideTxChainingPromptField = 'hide_tx_chaining_prompt';
  static const hidePegInInfoField = 'hide_peg_in_info';
  static const hidePegOutInfoField = 'hide_peg_out_info_new';
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

    return _readSettings(prefs);
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
      pinData: _pinData(prefs),
      settingsNetworkType: _settingsNetworkType(prefs),
      networkHost: _networkHost(prefs),
      networkPort: _networkPort(prefs),
      networkUseTLS: _networkUseTLS(prefs),
      settings: _settings(prefs),
      knownNewReleaseBuild: _knownNewReleaseBuild(prefs),
      showAmpOnboarding: _showAmpOnboarding(prefs),
      networkSettingsModel: _networkSettingsModel(prefs),
      hideTxChainingPromptValue: _hideTxChainingPromptValue(prefs),
      hidePegInInfo: _hidePegInInfo(prefs),
      hidePegOutInfo: _hidePegOutInfo(prefs),
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
    if (state.pinData != null) {
      await _setPinData(prefs, state.pinData!);
    } else {
      await prefs.remove(SideswapSettings.pinEncryptedDataField);
      await prefs.remove(SideswapSettings.pinIdentifierField);
      await prefs.remove(SideswapSettings.pinSaltField);
    }
    await _setSettingsNetworkType(prefs, state.settingsNetworkType);
    await _setNetworkHost(prefs, state.networkHost);
    await _setNetworkPort(prefs, state.networkPort);
    await _setNetworkUseTLS(prefs, state.networkUseTLS);
    if (state.settings != null) {
      await _setSettings(prefs, state.settings!);
    } else {
      await prefs.remove(SideswapSettings.settingsField);
    }
    await _setKnownNewReleaseBuild(prefs, state.knownNewReleaseBuild);
    await _setShowAmpOnboarding(prefs, state.showAmpOnboarding);
    if (state.networkSettingsModel != null) {
      await _setNetworkSettingsModel(prefs, state.networkSettingsModel!);
    } else {
      await prefs.remove(SideswapSettings.networkSettingsModelField);
    }
    await _setHideTxChainingPromptValue(prefs, state.hideTxChainingPromptValue);
    await _setHidePegInInfo(prefs, state.hidePegInInfo);
    await _setHidePegOutInfo(prefs, state.hidePegOutInfo);
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

  void setPinData(PinData? pinData) {
    state = state.copyWith(pinData: pinData);
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

  void setSettings(String? settings) {
    state = state.copyWith(settings: settings);
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

  void deleteConfig() {
    final currentEnv = state.env;
    ref
        .read(phoneProvider)
        .setConfirmPhoneData(confirmPhoneData: ConfirmPhoneData());
    state = SideswapSettings.empty(
        mnemonicEncrypted: Uint8List.fromList([]),
        env: currentEnv,
        showAmpOnboarding: true);
  }

  void clearSettings() {
    state = state.copyWith(settings: null);
  }

  ///
  /// Shared preferences functions
  Uint8List _mnemonicEncrypted(SharedPreferences prefs) {
    return base64
        .decode(prefs.getString(SideswapSettings.mnemonicEncryptedField) ?? '');
  }

  Future<void> _setMnemonicEncrypted(
      SharedPreferences prefs, Uint8List mnemonicEncrypted) async {
    if (mnemonicEncrypted.isEmpty) {
      await prefs.remove(SideswapSettings.mnemonicEncryptedField);
    } else {
      await prefs.setString(SideswapSettings.mnemonicEncryptedField,
          base64.encode(mnemonicEncrypted));
    }
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

  PinData _pinData(SharedPreferences prefs) {
    final salt = prefs.getString(SideswapSettings.pinSaltField);
    final encryptedData =
        prefs.getString(SideswapSettings.pinEncryptedDataField);
    final pinIdentifier = prefs.getString(SideswapSettings.pinIdentifierField);

    if (salt == null || encryptedData == null || pinIdentifier == null) {
      return PinData();
    }

    return PinData(
        salt: salt, encryptedData: encryptedData, pinIdentifier: pinIdentifier);
  }

  Future<void> _setPinData(SharedPreferences prefs, PinData pinData) async {
    await prefs.setString(SideswapSettings.pinSaltField, pinData.salt);
    await prefs.setString(
        SideswapSettings.pinEncryptedDataField, pinData.encryptedData);
    await prefs.setString(
        SideswapSettings.pinIdentifierField, pinData.pinIdentifier);
  }

  Future<void> _setSettingsNetworkType(
      SharedPreferences prefs, SettingsNetworkType type) async {
    await prefs.setString(SideswapSettings.settingsNetworkTypeField,
        EnumToString.convertToString(type));
  }

  SettingsNetworkType _settingsNetworkType(SharedPreferences prefs) {
    final typeString =
        prefs.getString(SideswapSettings.settingsNetworkTypeField);

    if (typeString == null) {
      return SettingsNetworkType.sideswap;
    }

    return EnumToString.fromString(SettingsNetworkType.values, typeString) ??
        SettingsNetworkType.sideswap;
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

  String? _settings(SharedPreferences prefs) {
    return prefs.getString(SideswapSettings.settingsField);
  }

  Future<void> _setSettings(SharedPreferences prefs, String value) async {
    await prefs.setString(SideswapSettings.settingsField, value);
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
      SharedPreferences prefs, NetworkSettingsModel model) async {
    final encoded = jsonEncode(model.toJson());
    await prefs.setString(SideswapSettings.networkSettingsModelField, encoded);
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
}
