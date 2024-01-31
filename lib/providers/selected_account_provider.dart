import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/models/account_asset.dart';

part 'selected_account_provider.g.dart';

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
