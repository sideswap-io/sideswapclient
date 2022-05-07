import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/protobuf/sideswap.pb.dart';

class AccountType {
  final int id;
  const AccountType(this.id);

  static AccountType get regular {
    return const AccountType(0);
  }

  static AccountType get amp {
    return const AccountType(1);
  }

  static AccountType fromPb(Account account) {
    return AccountType(account.id);
  }

  bool isRegular() {
    return this == regular;
  }

  bool isAmp() {
    return this == amp;
  }

  @override
  bool operator ==(Object other) {
    return other is AccountType && id == other.id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }
}

class AccountAsset implements Comparable<AccountAsset> {
  // Used for sorting
  static late String liquidAssetId;

  final AccountType account;
  final String asset;

  AccountAsset(this.account, this.asset);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AccountAsset &&
        other.account == account &&
        other.asset == asset;
  }

  @override
  int get hashCode {
    return asset.hashCode ^ account.hashCode;
  }

  @override
  int compareTo(AccountAsset other) {
    var result = compareBool(account.isAmp(), other.account.isAmp());
    if (result != 0) {
      return result;
    }
    result = compareBool(asset == liquidAssetId, other.asset == liquidAssetId);
    if (result != 0) {
      return -result;
    }
    return asset.compareTo(other.asset);
  }
}
