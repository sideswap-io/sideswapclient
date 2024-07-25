import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_provider.g.dart';
part 'login_provider.freezed.dart';

@freezed
sealed class LoginState with _$LoginState {
  const factory LoginState.empty() = LoginStateEmpty;
  const factory LoginState.login({String? mnemonic, String? jadeId}) =
      LoginStateLogin;
}

@Riverpod(keepAlive: true)
class LoginStateNotifier extends _$LoginStateNotifier {
  @override
  LoginState build() {
    return const LoginStateEmpty();
  }

  void setState(LoginState loginState) {
    state = loginState;
  }
}
