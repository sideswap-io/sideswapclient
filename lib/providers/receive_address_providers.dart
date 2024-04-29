import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:sideswap/models/account_asset.dart';

part 'receive_address_providers.g.dart';

class ReceiveAddress {
  final AccountType accountType;
  final String recvAddress;
  ReceiveAddress({
    required this.accountType,
    required this.recvAddress,
  });

  ReceiveAddress copyWith({
    AccountType? accountType,
    String? recvAddress,
  }) {
    return ReceiveAddress(
      accountType: accountType ?? this.accountType,
      recvAddress: recvAddress ?? this.recvAddress,
    );
  }

  @override
  String toString() =>
      'ReceiveAddress(accountType: $accountType, recvAddress: $recvAddress)';

  (AccountType, String) _equality() => (accountType, recvAddress);

  @override
  bool operator ==(covariant ReceiveAddress other) {
    if (identical(this, other)) return true;

    return other._equality() == _equality();
  }

  @override
  int get hashCode => accountType.hashCode ^ recvAddress.hashCode;
}

@Riverpod(keepAlive: true)
class CurrentReceiveAddress extends _$CurrentReceiveAddress {
  @override
  ReceiveAddress build() {
    return ReceiveAddress(accountType: AccountType.reg, recvAddress: '');
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
    if (receiveAddress.accountType != AccountType.reg) {
      return;
    }

    final addresses = [...state, receiveAddress];
    state = addresses;
  }
}
