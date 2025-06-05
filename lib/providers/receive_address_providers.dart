import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:sideswap_protobuf/sideswap_api.dart';

part 'receive_address_providers.g.dart';

class ReceiveAddress {
  final Account account;
  final String recvAddress;
  ReceiveAddress({required this.account, required this.recvAddress});

  ReceiveAddress copyWith({Account? account, String? recvAddress}) {
    return ReceiveAddress(
      account: account ?? this.account,
      recvAddress: recvAddress ?? this.recvAddress,
    );
  }

  List<String> get recvAddressList {
    return recvAddress.characters.slices(4).map((e) => e.join()).toList();
  }

  @override
  String toString() =>
      'ReceiveAddress(account: $account, recvAddress: $recvAddress)';

  (Account, String) _equality() => (account, recvAddress);

  @override
  bool operator ==(covariant ReceiveAddress other) {
    if (identical(this, other)) return true;

    return other._equality() == _equality();
  }

  @override
  int get hashCode => account.hashCode ^ recvAddress.hashCode;
}

@Riverpod(keepAlive: true)
class CurrentReceiveAddress extends _$CurrentReceiveAddress {
  @override
  ReceiveAddress build() {
    return ReceiveAddress(account: Account.REG, recvAddress: '');
  }

  void setRecvAddress(ReceiveAddress receiveAddress) {
    state = receiveAddress;
  }
}

@Riverpod(keepAlive: true)
class RegularAccountAddresses extends _$RegularAccountAddresses {
  @override
  List<ReceiveAddress> build() {
    return [];
  }

  void insertAddress(ReceiveAddress receiveAddress) {
    if (receiveAddress.account != Account.REG) {
      return;
    }

    final addresses = [...state, receiveAddress];
    state = addresses;
  }
}
