import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'dart:io';

import 'package:sideswap/common/utils/custom_logger.dart';

class Encryption {
  static const platform = MethodChannel('app.sideswap.io/encryption');

  bool isPluginAvailable() {
    return Platform.isAndroid || Platform.isIOS;
  }

  Future<bool> canAuthenticate() async {
    // Always use fallback method is plugin is not available
    if (!isPluginAvailable()) {
      return false;
    }

    final result = await platform.invokeMethod<bool>('canAuthenticate');
    return result;
  }

  Future<Uint8List> encryptBiometric(String data) async {
    final dataCopy = Uint8List.fromList(data.codeUnits);
    final result = await _process('encryptBiometric', dataCopy);
    return result;
  }

  Future<String> decryptBiometric(Uint8List data) async {
    final result = await _process('decryptBiometric', data);
    return result == null ? null : String.fromCharCodes(result);
  }

  Future<Uint8List> encryptFallback(String data) async {
    final dataCopy = Uint8List.fromList(data.codeUnits);
    final result = await _process('encryptFallback', dataCopy);
    return result;
  }

  Future<String> decryptFallback(Uint8List data) async {
    final result = await _process('decryptFallback', data);
    return result == null ? null : String.fromCharCodes(result);
  }

  Future<Uint8List> _process(String methodName, Uint8List data) async {
    if (!isPluginAvailable()) {
      // Just copy as-is for now on desktop
      return data;
    }

    try {
      final result = await platform.invokeMethod<Uint8List>(methodName, data);
      return result;
    } on PlatformException catch (e) {
      logger.e('failed: $e');
    } on MissingPluginException catch (e) {
      logger.e('not avaialble: $e');
    }
    return null;
  }
}
