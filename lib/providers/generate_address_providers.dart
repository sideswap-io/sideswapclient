import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/models/account_asset.dart';

part 'generate_address_providers.g.dart';

@Riverpod(keepAlive: true)
class SelectedAccountTypeNotifier extends _$SelectedAccountTypeNotifier {
  @override
  AccountType build() {
    return AccountType.reg;
  }

  void setAccountType(AccountType value) {
    state = value;
  }
}
