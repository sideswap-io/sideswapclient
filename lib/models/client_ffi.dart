import 'dart:async';
import 'dart:ffi' as ffi;
import 'dart:io';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/side_swap_client_ffi.dart';

part 'client_ffi.g.dart';
part 'client_ffi.freezed.dart';

ffi.DynamicLibrary getDynLib() {
  final dl = runZonedGuarded(
    () {
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
    },
    (error, stack) {
      logger.e('Uncaught error runZoneGuard: $error');
    },
  );

  if (dl != null) {
    return dl;
  }

  throw Exception("Unable to load sideswap_client library");
}

class Lib {
  static var dynLib = getDynLib();
  static var lib = NativeLibrary(Lib.dynLib);
}

@Riverpod(keepAlive: true)
class LibClientId extends _$LibClientId {
  @override
  int build() {
    return 0;
  }

  void setClientId(int clientId) {
    state = clientId;
  }
}

@freezed
sealed class LibClientState with _$LibClientState {
  const factory LibClientState.empty() = LibClientStateEmpty;
  const factory LibClientState.initialized() = LibClientStateInitialized;
}

@Riverpod(keepAlive: true)
LibClientState libClientState(Ref ref) {
  final clientId = ref.watch(libClientIdProvider);

  if (clientId == 0) {
    return const LibClientState.empty();
  }

  return const LibClientState.initialized();
}
