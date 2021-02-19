import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  List<String> get disabledAssetTickers {
    return _prefs.getStringList(disabledAssetsField) ?? [];
  }

  Future<void> setDisabledAssetTickers(
      List<String> disabledAssetTickers) async {
    await _prefs.setStringList(
        disabledAssetsField, disabledAssetTickers.toList());
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
    await _prefs.clear();
    notifyListeners();
  }
}
