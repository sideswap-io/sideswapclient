// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qrcode_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(QrCodeResultModelNotifier)
const qrCodeResultModelProvider = QrCodeResultModelNotifierProvider._();

final class QrCodeResultModelNotifierProvider
    extends $NotifierProvider<QrCodeResultModelNotifier, QrCodeResultModel> {
  const QrCodeResultModelNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'qrCodeResultModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$qrCodeResultModelNotifierHash();

  @$internal
  @override
  QrCodeResultModelNotifier create() => QrCodeResultModelNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(QrCodeResultModel value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<QrCodeResultModel>(value),
    );
  }
}

String _$qrCodeResultModelNotifierHash() =>
    r'756e6d3ae1b99a069c456536c28027b903da0248';

abstract class _$QrCodeResultModelNotifier
    extends $Notifier<QrCodeResultModel> {
  QrCodeResultModel build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<QrCodeResultModel, QrCodeResultModel>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<QrCodeResultModel, QrCodeResultModel>,
              QrCodeResultModel,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(qrcodeHelper)
const qrcodeHelperProvider = QrcodeHelperProvider._();

final class QrcodeHelperProvider
    extends $FunctionalProvider<QrCodeHelper, QrCodeHelper, QrCodeHelper>
    with $Provider<QrCodeHelper> {
  const QrcodeHelperProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'qrcodeHelperProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$qrcodeHelperHash();

  @$internal
  @override
  $ProviderElement<QrCodeHelper> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  QrCodeHelper create(Ref ref) {
    return qrcodeHelper(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(QrCodeHelper value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<QrCodeHelper>(value),
    );
  }
}

String _$qrcodeHelperHash() => r'6765487f3eb3c6047f4592204937370d9c93d2cf';
