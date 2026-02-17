// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'peg_out_edit_fee_rate_dialog.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PegOutEditFeeRateDialogTransItem)
const pegOutEditFeeRateDialogTransItemProvider =
    PegOutEditFeeRateDialogTransItemProvider._();

final class PegOutEditFeeRateDialogTransItemProvider
    extends
        $NotifierProvider<PegOutEditFeeRateDialogTransItem, Option<TransItem>> {
  const PegOutEditFeeRateDialogTransItemProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pegOutEditFeeRateDialogTransItemProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pegOutEditFeeRateDialogTransItemHash();

  @$internal
  @override
  PegOutEditFeeRateDialogTransItem create() =>
      PegOutEditFeeRateDialogTransItem();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Option<TransItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Option<TransItem>>(value),
    );
  }
}

String _$pegOutEditFeeRateDialogTransItemHash() =>
    r'92b501123e5d8ea19cc66290ac06f31a90f45a25';

abstract class _$PegOutEditFeeRateDialogTransItem
    extends $Notifier<Option<TransItem>> {
  Option<TransItem> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Option<TransItem>, Option<TransItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Option<TransItem>, Option<TransItem>>,
              Option<TransItem>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
