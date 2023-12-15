// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ffi/ffi.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:sideswap/common/enums.dart';
import 'package:sideswap/models/client_ffi.dart';
import 'package:sideswap/providers/wallet.dart';

part 'common_providers.g.dart';

@riverpod
bool isAddrTypeValid(IsAddrTypeValidRef ref, String addr, AddrType addrType) {
  final clientId = ref.watch(libClientIdProvider);

  if (addr.isEmpty || clientId == 0) {
    return false;
  }

  final addrPtr = addr.toNativeUtf8();
  return Lib.lib
      .sideswap_check_addr(clientId, addrPtr.cast(), convertAddrType(addrType));
}
