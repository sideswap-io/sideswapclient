import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'inputs_providers.g.dart';
part 'inputs_providers.freezed.dart';

@freezed
sealed class InputsWalletFlagType with _$InputsWalletFlagType {
  const factory InputsWalletFlagType.regular() = InputsWalletFlagTypeRegular;
  const factory InputsWalletFlagType.amp() = InputsWalletFlagTypeAmp;
}

@riverpod
class InputsWalletFlagNotifier extends _$InputsWalletFlagNotifier {
  @override
  InputsWalletFlagType build() {
    return const InputsWalletFlagType.regular();
  }

  void setInputsWalletTypeFlag(InputsWalletFlagType value) {
    state = value;
  }
}

@freezed
sealed class InputsTxItem with _$InputsTxItem {
  const factory InputsTxItem({String? tx, int? satoshi}) = _InputsTxItem;
}

@freezed
sealed class InputsAddressItem with _$InputsAddressItem {
  const factory InputsAddressItem({
    String? address,
    int? txAmount,
    String? comment,
    int? satoshi,
    List<InputsTxItem>? inputsTx,
  }) = _InputsAddressItem;
}

@freezed
sealed class InputsItem with _$InputsItem {
  const factory InputsItem({List<InputsAddressItem>? inputs}) = _InputsItem;
}

@riverpod
class InputsNotifier extends _$InputsNotifier {
  @override
  List<InputsItem> build() {
    return [];
  }

  void setInputsItems(List<InputsItem> value) {
    state = value;
  }
}

@riverpod
class SelectedInputsNotifier extends _$SelectedInputsNotifier {
  @override
  List<InputsTxItem> build() {
    return [];
  }

  void setSelectedInputs(List<InputsTxItem> value) {
    state = value;
  }
}
