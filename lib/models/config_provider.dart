import 'dart:convert';
import 'dart:typed_data';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sideswap/models/network_access_provider.dart';

import 'package:sideswap/common/utils/custom_logger.dart';
import 'package:sideswap/models/phone_provider.dart';
import 'package:sideswap/models/wallet.dart';

final configProvider =
    ChangeNotifierProvider<ConfigChangeNotifierProvider>((ref) {
  return ConfigChangeNotifierProvider(ref.read);
});

class ConfigChangeNotifierProvider with ChangeNotifier {
  static const mnemonicEncryptedField = 'mnemonic_encrypted';
  static const useBiometricProtectionField = 'biometric_protection';
  static const licenseAcceptedField = 'license_accepted';
  static const envField = 'env';
  static const txItemList = 'txItemList';
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

  ConfigChangeNotifierProvider(this.read);

  final Reader read;
  late SharedPreferences _prefs;

  Future<bool> init() async {
    _prefs = await SharedPreferences.getInstance();
    notifyListeners();

    return true;
  }

  Uint8List get mnemonicEncrypted {
    return base64.decode(_prefs.getString(mnemonicEncryptedField) ?? '');
  }

  Future<void> setMnemonicEncrypted(Uint8List mnemonicEncrypted) async {
    if (mnemonicEncrypted.isEmpty) {
      await _prefs.remove(mnemonicEncryptedField);
    } else {
      await _prefs.setString(
          mnemonicEncryptedField, base64.encode(mnemonicEncrypted));
    }

    notifyListeners();
  }

  bool get licenseAccepted {
    return _prefs.getBool(licenseAcceptedField) ?? false;
  }

  Future<void> setLicenseAccepted(bool licenseAccepted) async {
    await _prefs.setBool(licenseAcceptedField, licenseAccepted);
    notifyListeners();
  }

  bool get useBiometricProtection {
    return _prefs.getBool(useBiometricProtectionField) ?? false;
  }

  Future<void> setUseBiometricProtection(bool useBiometricProtection) async {
    await _prefs.setBool(useBiometricProtectionField, useBiometricProtection);
    notifyListeners();
  }

  int get env {
    return _prefs.getInt(envField) ?? 0;
  }

  Future<void> setEnv(int env) async {
    await _prefs.setInt(envField, env);
    notifyListeners();
  }

  Future<void> deleteConfig() async {
    final currentEnv = env;
    await _prefs.clear();
    logger.d(phoneNumber);
    read(phoneProvider)
        .setConfirmPhoneData(confirmPhoneData: ConfirmPhoneData());
    await setEnv(currentEnv);
    notifyListeners();
  }

  Future<void> setPhoneKey(String phoneKey) async {
    await _prefs.setString(phoneKeyField, phoneKey);
    notifyListeners();
  }

  String get phoneKey {
    return _prefs.getString(phoneKeyField) ?? '';
  }

  Future<void> setPhoneNumber(String phoneNumber) async {
    await _prefs.setString(phoneNumberField, phoneNumber);
    notifyListeners();
  }

  String get phoneNumber {
    return _prefs.getString(phoneNumberField) ?? '';
  }

  Future<void> setPinData(PinData pinData) async {
    await _prefs.setString(pinSaltField, pinData.salt);
    await _prefs.setString(pinEncryptedDataField, pinData.encryptedData);
    await _prefs.setString(pinIdentifierField, pinData.pinIdentifier);
    notifyListeners();
  }

  Future<void> setUsePinProtection(bool usePinProtection) async {
    await _prefs.setBool(usePinProtectionField, usePinProtection);
    notifyListeners();
  }

  bool get usePinProtection {
    return _prefs.getBool(usePinProtectionField) ?? false;
  }

  PinData get pinData {
    final salt = _prefs.getString(pinSaltField);
    final encryptedData = _prefs.getString(pinEncryptedDataField);
    final pinIdentifier = _prefs.getString(pinIdentifierField);

    if (salt == null || encryptedData == null || pinIdentifier == null) {
      return PinData();
    }

    return PinData(
        salt: salt, encryptedData: encryptedData, pinIdentifier: pinIdentifier);
  }

  Future<void> setSettingsNetworkType(SettingsNetworkType type) async {
    await _prefs.setString(
        settingsNetworkTypeField, EnumToString.convertToString(type));
  }

  SettingsNetworkType get settingsNetworkType {
    final typeString = _prefs.getString(settingsNetworkTypeField);

    return EnumToString.fromString(
            SettingsNetworkType.values, typeString ?? '') ??
        SettingsNetworkType.blockstream;
  }

  Future<void> setSettingsHost(String host) async {
    await _prefs.setString(settingsHostField, host);
  }

  String get settingsHost {
    return _prefs.getString(settingsHostField) ?? '';
  }

  Future<void> setSettingsPort(int port) async {
    await _prefs.setInt(settingsPortField, port);
  }

  int get settingsPort {
    return _prefs.getInt(settingsPortField) ?? 0;
  }

  Future<void> setSettingsUseTLS(bool value) async {
    await _prefs.setBool(settingsUseTLSField, value);
  }

  bool get settingsUseTLS {
    return _prefs.getBool(settingsUseTLSField) ?? false;
  }

  String? get settings {
    return _prefs.getString(settingsField);
  }

  Future<void> setSettings(String value) async {
    await _prefs.setString(settingsField, value);
  }

  Future<void> clearSettings() async {
    await _prefs.remove(settingsField);
  }
}
