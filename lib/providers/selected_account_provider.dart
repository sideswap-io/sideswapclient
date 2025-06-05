import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

part 'selected_account_provider.g.dart';

// TODO (malcolmpl): new wallets - remove this?
@Riverpod(keepAlive: true)
class SelectedAccountTypeNotifier extends _$SelectedAccountTypeNotifier {
  @override
  Account build() {
    return Account.REG;
  }

  void setAccountType(Account value) {
    state = value;
  }
}
