import 'dart:convert';
import 'dart:typed_data';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sideswap/models/network_access_provider.dart';

import 'package:sideswap/common/utils/custom_logger.dart';
import 'package:sideswap/models/phone_provider.dart';
import 'package:sideswap/models/wallet.dart';

final sharedPreferencesProvider =
    Provider<SharedPreferences>((_) => throw UnimplementedError());

final configProvider =
    ChangeNotifierProvider<ConfigChangeNotifierProvider>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ConfigChangeNotifierProvider(ref, prefs);
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

  ConfigChangeNotifierProvider(this.ref, this.prefs);

  final Ref ref;
  SharedPreferences prefs;

  Uint8List get mnemonicEncrypted {
    return base64.decode(prefs.getString(mnemonicEncryptedField) ?? '');
  }

  Future<void> setMnemonicEncrypted(Uint8List mnemonicEncrypted) async {
    if (mnemonicEncrypted.isEmpty) {
      await prefs.remove(mnemonicEncryptedField);
    } else {
      await prefs.setString(
          mnemonicEncryptedField, base64.encode(mnemonicEncrypted));
    }

    notifyListeners();
  }

  bool get licenseAccepted {
    return prefs.getBool(licenseAcceptedField) ?? false;
  }

  Future<void> setLicenseAccepted(bool licenseAccepted) async {
    await prefs.setBool(licenseAcceptedField, licenseAccepted);
    notifyListeners();
  }

  bool get useBiometricProtection {
    return prefs.getBool(useBiometricProtectionField) ?? false;
  }

  Future<void> setUseBiometricProtection(bool useBiometricProtection) async {
    await prefs.setBool(useBiometricProtectionField, useBiometricProtection);
    notifyListeners();
  }

  int get env {
    return prefs.getInt(envField) ?? 0;
  }

  Future<void> setEnv(int env) async {
    await prefs.setInt(envField, env);
    notifyListeners();
  }

  Future<void> deleteConfig() async {
    final currentEnv = env;
    await prefs.clear();
    logger.d(phoneNumber);
    ref
        .read(phoneProvider)
        .setConfirmPhoneData(confirmPhoneData: ConfirmPhoneData());
    await setEnv(currentEnv);
    notifyListeners();
  }

  Future<void> setPhoneKey(String phoneKey) async {
    await prefs.setString(phoneKeyField, phoneKey);
    notifyListeners();
  }

  String get phoneKey {
    return prefs.getString(phoneKeyField) ?? '';
  }

  Future<void> setPhoneNumber(String phoneNumber) async {
    await prefs.setString(phoneNumberField, phoneNumber);
    notifyListeners();
  }

  String get phoneNumber {
    return prefs.getString(phoneNumberField) ?? '';
  }

  Future<void> setPinData(PinData pinData) async {
    await prefs.setString(pinSaltField, pinData.salt);
    await prefs.setString(pinEncryptedDataField, pinData.encryptedData);
    await prefs.setString(pinIdentifierField, pinData.pinIdentifier);
    notifyListeners();
  }

  Future<void> setUsePinProtection(bool usePinProtection) async {
    await prefs.setBool(usePinProtectionField, usePinProtection);
    notifyListeners();
  }

  bool get usePinProtection {
    return prefs.getBool(usePinProtectionField) ?? false;
  }

  PinData get pinData {
    final salt = prefs.getString(pinSaltField);
    final encryptedData = prefs.getString(pinEncryptedDataField);
    final pinIdentifier = prefs.getString(pinIdentifierField);

    if (salt == null || encryptedData == null || pinIdentifier == null) {
      return PinData();
    }

    return PinData(
        salt: salt, encryptedData: encryptedData, pinIdentifier: pinIdentifier);
  }

  Future<void> setSettingsNetworkType(SettingsNetworkType type) async {
    await prefs.setString(
        settingsNetworkTypeField, EnumToString.convertToString(type));
    notifyListeners();
  }

  SettingsNetworkType get settingsNetworkType {
    final typeString = prefs.getString(settingsNetworkTypeField);

    if (typeString == null) {
      return SettingsNetworkType.blockstream;
    }

    return EnumToString.fromString(SettingsNetworkType.values, typeString) ??
        SettingsNetworkType.blockstream;
  }

  Future<void> setSettingsHost(String host) async {
    await prefs.setString(settingsHostField, host);
    notifyListeners();
  }

  String get settingsHost {
    return prefs.getString(settingsHostField) ?? '';
  }

  Future<void> setSettingsPort(int port) async {
    await prefs.setInt(settingsPortField, port);
    notifyListeners();
  }

  int get settingsPort {
    return prefs.getInt(settingsPortField) ?? 0;
  }

  Future<void> setSettingsUseTLS(bool value) async {
    await prefs.setBool(settingsUseTLSField, value);
    notifyListeners();
  }

  bool get settingsUseTLS {
    return prefs.getBool(settingsUseTLSField) ?? false;
  }

  String? get settings {
    return prefs.getString(settingsField);
  }

  Future<void> setSettings(String value) async {
    await prefs.setString(settingsField, value);
    notifyListeners();
  }

  Future<void> clearSettings() async {
    await prefs.remove(settingsField);
  }
}
