import 'package:freezed_annotation/freezed_annotation.dart';

part 'connection_models.freezed.dart';

@freezed
class ServerLoginState with _$ServerLoginState {
  const factory ServerLoginState.logout() = ServerLoginStateLogout;
  const factory ServerLoginState.login() = ServerLoginStateLogin;
  const factory ServerLoginState.error({String? message}) =
      ServerLoginStateError;
}
