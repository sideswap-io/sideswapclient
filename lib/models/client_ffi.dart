import 'dart:ffi' as ffi;
import 'dart:io';
import 'package:sideswap/side_swap_client_ffi.dart';

ffi.DynamicLibrary getDynLib() {
  if (Platform.isIOS) {
    return ffi.DynamicLibrary.process();
  }
  if (Platform.isAndroid || Platform.isLinux || Platform.isFuchsia) {
    return ffi.DynamicLibrary.open('libsideswap_client.so');
  }
  if (Platform.isMacOS) {
    return ffi.DynamicLibrary.open('libsideswap_client.dylib');
  }
  if (Platform.isWindows) {
    return ffi.DynamicLibrary.open('sideswap_client.dll');
  }
  throw Exception('unexpected platform');
}

class Lib {
  static var dynLib = getDynLib();
  static var lib = NativeLibrary(Lib.dynLib);
}
