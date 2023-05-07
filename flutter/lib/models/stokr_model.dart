import 'package:freezed_annotation/freezed_annotation.dart';

part 'stokr_model.freezed.dart';

@freezed
class StokrGaidState with _$StokrGaidState {
  const factory StokrGaidState.empty() = StokrGaidStateEmpty;
  const factory StokrGaidState.loading() = StokrGaidStateLoading;
  const factory StokrGaidState.registered() = StokrGaidStateRegistered;
  const factory StokrGaidState.unregistered() = StokrGaidStateUnregistered;
}
