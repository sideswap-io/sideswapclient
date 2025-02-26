import 'package:sideswap/common/helpers.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class AccountType {
  final int id;
  const AccountType(this.id);

  static AccountType get reg => const AccountType(0);
  static AccountType get amp => const AccountType(1);
  static AccountType fromPb(Account account) => AccountType(account.id);

  bool get isRegular => this == reg;
  bool get isAmp => this == amp;

  (int,) _equality() => (id,);

  @override
  bool operator ==(covariant AccountType other) {
    if (identical(this, other)) return true;

    return other._equality() == _equality();
  }

  @override
  int get hashCode => _equality().hashCode;

  @override
  String toString() => 'AccountType(id: $id)';
}

class AccountAsset implements Comparable<AccountAsset> {
  // Used for sorting
  static late String liquidAssetId;

  final AccountType account;
  final String? assetId;

  AccountAsset(this.account, this.assetId);

  (AccountType, String?) _equality() => (account, assetId);

  @override
  bool operator ==(covariant AccountAsset other) {
    if (identical(this, other)) return true;

    return other._equality() == _equality();
  }

  @override
  int get hashCode => _equality().hashCode;

  @override
  int compareTo(AccountAsset other) {
    var result = compareBool(account.isAmp, other.account.isAmp);
    if (result != 0) {
      return result;
    }
    result = compareBool(
      assetId == liquidAssetId,
      other.assetId == liquidAssetId,
    );
    if (result != 0) {
      return -result;
    }
    return assetId?.compareTo(other.assetId ?? '') ?? -1;
  }

  @override
  String toString() => 'AccountAsset(account: $account, assetId: $assetId)';
}
