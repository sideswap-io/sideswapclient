import 'dart:io';

import 'package:flutter/services.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';

abstract class AbstractEncryptionRepository {
  bool isPluginAvailable();
  Future<bool> appResetRequired({
    required bool hasEncryptedMnemonic,
    required bool usePinProtection,
  });
  Future<bool> canAuthenticate();
  Future<Uint8List> encryptBiometric(String data);
  Future<String> decryptBiometric(Uint8List data);
  Future<Uint8List> encryptFallback(String data);
  Future<String> decryptFallback(Uint8List data);
}

class EncryptionRepository implements AbstractEncryptionRepository {
  static const platform = MethodChannel('app.sideswap.io/encryption');

  @override
  bool isPluginAvailable() {
    return Platform.isAndroid || Platform.isIOS;
  }

  @override
  Future<bool> appResetRequired({
    required bool hasEncryptedMnemonic,
    required bool usePinProtection,
  }) async {
    // Detect when app is transfered to new iOS device and KeyChain item is not available
    if (!Platform.isIOS || !hasEncryptedMnemonic || usePinProtection) {
      return false;
    }
    final result = await platform.invokeMethod<bool>('decryptNotPossible');
    return result ?? false;
  }

  @override
  Future<bool> canAuthenticate() async {
    // Always use fallback method if plugin is not available
    if (!isPluginAvailable()) {
      return false;
    }

    final result = await platform.invokeMethod<bool>('canAuthenticate');
    return result ?? false;
  }

  @override
  Future<Uint8List> encryptBiometric(String data) async {
    final dataCopy = Uint8List.fromList(data.codeUnits);
    return await _process('encryptBiometric', dataCopy);
  }

  @override
  Future<String> decryptBiometric(Uint8List data) async {
    final result = await _process('decryptBiometric', data);
    return String.fromCharCodes(result);
  }

  @override
  Future<Uint8List> encryptFallback(String data) async {
    final dataCopy = Uint8List.fromList(data.codeUnits);
    return await _process('encryptFallback', dataCopy);
  }

  @override
  Future<String> decryptFallback(Uint8List data) async {
    final result = await _process('decryptFallback', data);
    return String.fromCharCodes(result);
  }

  Future<Uint8List> _process(String methodName, Uint8List data) async {
    if (!isPluginAvailable()) {
      // Just copy as-is for now on desktop
      return data;
    }

    try {
      final result = await platform.invokeMethod<Uint8List>(methodName, data);
      return result ?? Uint8List(0);
    } on PlatformException catch (e) {
      logger.e('failed: $e');
    } on MissingPluginException catch (e) {
      logger.e('not avaialble: $e');
    }
    return Uint8List(0);
  }
}
