import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  static const disabledAssetsField = 'disabled_assets';
  static const envField = 'env';
  static const txItemList = 'txItemList';
  static const phoneKeyField = 'phoneKey';
  static const phoneNumberField = 'phoneNumber';
  static const usePinProtectionField = 'pinProtectionField';
  static const pinSaltField = 'pinSalt';
  static const pinEncryptedDataField = 'pinEncryptedData';
  static const pinIdentifierField = 'pinIdentifierField';

  ConfigChangeNotifierProvider(this.read);

  final Reader read;
  SharedPreferences _prefs;

  Future<void> init() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
      notifyListeners();
    }
  }

  Uint8List get mnemonicEncrypted {
    return base64.decode(_prefs.getString(mnemonicEncryptedField) ?? '');
  }

  Future<void> setMnemonicEncrypted(Uint8List mnemonicEncrypted) async {
    if (mnemonicEncrypted == null || mnemonicEncrypted.isEmpty) {
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

  List<String> get disabledAssetIds {
    return _prefs.getStringList(disabledAssetsField) ?? [];
  }

  Future<void> setDisabledAssetIds(List<String> value) async {
    await _prefs.setStringList(disabledAssetsField, value.toList());
    notifyListeners();
  }

  bool get useBiometricProtection {
    return _prefs.getBool(useBiometricProtectionField) ?? false;
  }

  Future<void> setUseBiometricProtection(bool useBiometricProtection) async {
    await _prefs.setBool(useBiometricProtectionField, useBiometricProtection);
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
    read(phoneProvider).setConfirmPhoneData(confirmPhoneData: null);
    await setEnv(currentEnv);
    notifyListeners();
  }

  Future<void> setPhoneKey(String phoneKey) async {
    await _prefs.setString(phoneKeyField, phoneKey);
  }

  String get phoneKey {
    return _prefs.getString(phoneKeyField) ?? '';
  }

  Future<void> setPhoneNumber(String phoneNumber) async {
    await _prefs.setString(phoneNumberField, phoneNumber);
  }

  String get phoneNumber {
    return _prefs.getString(phoneNumberField) ?? '';
  }

  Future<void> setPinData(PinData pinData) async {
    if (pinData.error != null) {
      return;
    }

    await _prefs.setString(pinSaltField, pinData.salt);
    await _prefs.setString(pinEncryptedDataField, pinData.encryptedData);
    await _prefs.setString(pinIdentifierField, pinData.pinIdentifier);
  }

  Future<void> setUsePinProtection(bool usePinProtection) async {
    await _prefs.setBool(usePinProtectionField, usePinProtection);
  }

  bool get usePinProtection {
    return _prefs.getBool(usePinProtectionField) ?? false;
  }

  PinData get pinData {
    final salt = _prefs.getString(pinSaltField);
    final encryptedData = _prefs.getString(pinEncryptedDataField);
    final pinIdentifier = _prefs.getString(pinIdentifierField);

    return PinData(
        salt: salt, encryptedData: encryptedData, pinIdentifier: pinIdentifier);
  }
}
