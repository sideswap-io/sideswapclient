import 'package:sideswap/common/helpers.dart';

enum AccountType {
  regular,
  amp,
}

extension AccountTypeHelpers on AccountType {
  bool isRegular() {
    return this == AccountType.regular;
  }

  bool isAmp() {
    return this == AccountType.amp;
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
