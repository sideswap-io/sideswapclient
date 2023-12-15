import 'package:sideswap/side_swap_client_ffi.dart';

enum AddrType {
  bitcoin,
  elements,
}

int convertAddrType(AddrType type) {
  return switch (type) {
    AddrType.bitcoin => SIDESWAP_BITCOIN,
    AddrType.elements => SIDESWAP_ELEMENTS,
  };
}

enum BIP21AddressTypeEnum {
  elements,
  bitcoin,
  liquidnetwork,
  other,
}
