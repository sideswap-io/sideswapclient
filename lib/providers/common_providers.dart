// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ffi/ffi.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:sideswap/common/enums.dart';
import 'package:sideswap/models/client_ffi.dart';

part 'common_providers.g.dart';

@riverpod
bool isAddrTypeValid(IsAddrTypeValidRef ref, String addr, AddrType addrType) {
  final libClientState = ref.watch(libClientStateProvider);

  if (addr.isEmpty || libClientState == const LibClientStateEmpty()) {
    return false;
  }

  final clientId = ref.watch(libClientIdProvider);

  final addrPtr = addr.toNativeUtf8();
  return Lib.lib
      .sideswap_check_addr(clientId, addrPtr.cast(), convertAddrType(addrType));
}
