import 'dart:ffi' as ffi;
import 'dart:io';
import 'package:sideswap/side_swap_client_ffi.dart';

class Lib {
  static var dynLib = (Platform.isIOS || Platform.isMacOS)
      ? ffi.DynamicLibrary.process()
      : ffi.DynamicLibrary.open('libsideswap_client.so');
  static var lib = NativeLibrary(Lib.dynLib);
}
