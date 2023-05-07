import 'package:freezed_annotation/freezed_annotation.dart';

part 'pegx_model.freezed.dart';

@freezed
class PegxLoginState with _$PegxLoginState {
  const factory PegxLoginState.loading() = PegxLoginStateLoading;
  const factory PegxLoginState.loginDialog() = PegxLoginStateLoginDialog;
  const factory PegxLoginState.login({required String requestId}) =
      PegxLoginStateLogin;
  const factory PegxLoginState.logged() = PegxLoginStateLogged;
  const factory PegxLoginState.gaidWaiting() = PegxLoginStateGaidWaiting;
  const factory PegxLoginState.gaidAdded() = PegxLoginStateGaidAdded;
  const factory PegxLoginState.gaidError() = PegxLoginStateGaidError;
}

@freezed
class PegxGaidState with _$PegxGaidState {
  const factory PegxGaidState.empty() = PegxGaidStateEmpty;
  const factory PegxGaidState.loading() = PegxGaidStateLoading;
  const factory PegxGaidState.registered() = PegxGaidStateRegistered;
  const factory PegxGaidState.unregistered() = PegxGaidStateUnregistered;
}
