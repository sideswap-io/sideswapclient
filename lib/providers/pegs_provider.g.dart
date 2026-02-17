// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pegs_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(pegRepository)
const pegRepositoryProvider = PegRepositoryProvider._();

final class PegRepositoryProvider
    extends
        $FunctionalProvider<
          AbstractPegRepository,
          AbstractPegRepository,
          AbstractPegRepository
        >
    with $Provider<AbstractPegRepository> {
  const PegRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pegRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pegRepositoryHash();

  @$internal
  @override
  $ProviderElement<AbstractPegRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AbstractPegRepository create(Ref ref) {
    return pegRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AbstractPegRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AbstractPegRepository>(value),
    );
  }
}

String _$pegRepositoryHash() => r'50398cb614a6b9062940aad1b49bdda42b4fb89c';

@ProviderFor(AllPegsNotifier)
const allPegsProvider = AllPegsNotifierProvider._();

final class AllPegsNotifierProvider
    extends $NotifierProvider<AllPegsNotifier, Map<String, List<TransItem>>> {
  const AllPegsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allPegsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allPegsNotifierHash();

  @$internal
  @override
  AllPegsNotifier create() => AllPegsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, List<TransItem>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, List<TransItem>>>(value),
    );
  }
}

String _$allPegsNotifierHash() => r'eeba1a71e3b28acc27a2232e2b3613be4e59a82c';

abstract class _$AllPegsNotifier
    extends $Notifier<Map<String, List<TransItem>>> {
  Map<String, List<TransItem>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<Map<String, List<TransItem>>, Map<String, List<TransItem>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                Map<String, List<TransItem>>,
                Map<String, List<TransItem>>
              >,
              Map<String, List<TransItem>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(allPegsById)
const allPegsByIdProvider = AllPegsByIdProvider._();

final class AllPegsByIdProvider
    extends
        $FunctionalProvider<
          Map<String, TransItem>,
          Map<String, TransItem>,
          Map<String, TransItem>
        >
    with $Provider<Map<String, TransItem>> {
  const AllPegsByIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allPegsByIdProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allPegsByIdHash();

  @$internal
  @override
  $ProviderElement<Map<String, TransItem>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Map<String, TransItem> create(Ref ref) {
    return allPegsById(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, TransItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, TransItem>>(value),
    );
  }
}

String _$allPegsByIdHash() => r'369a23416d4ec7e65005a0447d22dd2b2c08c405';

@ProviderFor(PegSubscribedValueNotifier)
const pegSubscribedValueProvider = PegSubscribedValueNotifierProvider._();

final class PegSubscribedValueNotifierProvider
    extends $NotifierProvider<PegSubscribedValueNotifier, PegSubscribedValues> {
  const PegSubscribedValueNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pegSubscribedValueProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pegSubscribedValueNotifierHash();

  @$internal
  @override
  PegSubscribedValueNotifier create() => PegSubscribedValueNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PegSubscribedValues value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PegSubscribedValues>(value),
    );
  }
}

String _$pegSubscribedValueNotifierHash() =>
    r'8b367f9ea9790b9b9028e727e62a83dd829190f0';

abstract class _$PegSubscribedValueNotifier
    extends $Notifier<PegSubscribedValues> {
  PegSubscribedValues build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<PegSubscribedValues, PegSubscribedValues>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PegSubscribedValues, PegSubscribedValues>,
              PegSubscribedValues,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(pegOrderIdForTransItem)
const pegOrderIdForTransItemProvider = PegOrderIdForTransItemFamily._();

final class PegOrderIdForTransItemProvider
    extends $FunctionalProvider<Option<String>, Option<String>, Option<String>>
    with $Provider<Option<String>> {
  const PegOrderIdForTransItemProvider._({
    required PegOrderIdForTransItemFamily super.from,
    required TransItem super.argument,
  }) : super(
         retry: null,
         name: r'pegOrderIdForTransItemProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$pegOrderIdForTransItemHash();

  @override
  String toString() {
    return r'pegOrderIdForTransItemProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<Option<String>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Option<String> create(Ref ref) {
    final argument = this.argument as TransItem;
    return pegOrderIdForTransItem(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Option<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Option<String>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PegOrderIdForTransItemProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$pegOrderIdForTransItemHash() =>
    r'3044aa28a3b0321ea84c5e797bb3306be7570fe5';

final class PegOrderIdForTransItemFamily extends $Family
    with $FunctionalFamilyOverride<Option<String>, TransItem> {
  const PegOrderIdForTransItemFamily._()
    : super(
        retry: null,
        name: r'pegOrderIdForTransItemProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PegOrderIdForTransItemProvider call(TransItem transItem) =>
      PegOrderIdForTransItemProvider._(argument: transItem, from: this);

  @override
  String toString() => r'pegOrderIdForTransItemProvider';
}

@ProviderFor(PegOrderFeesNotifier)
const pegOrderFeesProvider = PegOrderFeesNotifierProvider._();

final class PegOrderFeesNotifierProvider
    extends
        $NotifierProvider<PegOrderFeesNotifier, Map<String, PegOrderFeeData>> {
  const PegOrderFeesNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pegOrderFeesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pegOrderFeesNotifierHash();

  @$internal
  @override
  PegOrderFeesNotifier create() => PegOrderFeesNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, PegOrderFeeData> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, PegOrderFeeData>>(value),
    );
  }
}

String _$pegOrderFeesNotifierHash() =>
    r'd8b00828dd378cf6171e519c92251cef24178118';

abstract class _$PegOrderFeesNotifier
    extends $Notifier<Map<String, PegOrderFeeData>> {
  Map<String, PegOrderFeeData> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<Map<String, PegOrderFeeData>, Map<String, PegOrderFeeData>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                Map<String, PegOrderFeeData>,
                Map<String, PegOrderFeeData>
              >,
              Map<String, PegOrderFeeData>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(pegOrderFeeRates)
const pegOrderFeeRatesProvider = PegOrderFeeRatesFamily._();

final class PegOrderFeeRatesProvider
    extends
        $FunctionalProvider<
          Option<PegOrderFeeData>,
          Option<PegOrderFeeData>,
          Option<PegOrderFeeData>
        >
    with $Provider<Option<PegOrderFeeData>> {
  const PegOrderFeeRatesProvider._({
    required PegOrderFeeRatesFamily super.from,
    required TransItem super.argument,
  }) : super(
         retry: null,
         name: r'pegOrderFeeRatesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$pegOrderFeeRatesHash();

  @override
  String toString() {
    return r'pegOrderFeeRatesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<Option<PegOrderFeeData>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Option<PegOrderFeeData> create(Ref ref) {
    final argument = this.argument as TransItem;
    return pegOrderFeeRates(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Option<PegOrderFeeData> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Option<PegOrderFeeData>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PegOrderFeeRatesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$pegOrderFeeRatesHash() => r'c71dc2357fb7ec93ac2f0267e485e217da9377f7';

final class PegOrderFeeRatesFamily extends $Family
    with $FunctionalFamilyOverride<Option<PegOrderFeeData>, TransItem> {
  const PegOrderFeeRatesFamily._()
    : super(
        retry: null,
        name: r'pegOrderFeeRatesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PegOrderFeeRatesProvider call(TransItem transItem) =>
      PegOrderFeeRatesProvider._(argument: transItem, from: this);

  @override
  String toString() => r'pegOrderFeeRatesProvider';
}

@ProviderFor(availablePegOrderFeeChange)
const availablePegOrderFeeChangeProvider = AvailablePegOrderFeeChangeFamily._();

final class AvailablePegOrderFeeChangeProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  const AvailablePegOrderFeeChangeProvider._({
    required AvailablePegOrderFeeChangeFamily super.from,
    required TransItem super.argument,
  }) : super(
         retry: null,
         name: r'availablePegOrderFeeChangeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$availablePegOrderFeeChangeHash();

  @override
  String toString() {
    return r'availablePegOrderFeeChangeProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    final argument = this.argument as TransItem;
    return availablePegOrderFeeChange(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AvailablePegOrderFeeChangeProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$availablePegOrderFeeChangeHash() =>
    r'3cd189bd63fa0feb937c0759688d3fc005c0e4da';

final class AvailablePegOrderFeeChangeFamily extends $Family
    with $FunctionalFamilyOverride<bool, TransItem> {
  const AvailablePegOrderFeeChangeFamily._()
    : super(
        retry: null,
        name: r'availablePegOrderFeeChangeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AvailablePegOrderFeeChangeProvider call(TransItem transItem) =>
      AvailablePegOrderFeeChangeProvider._(argument: transItem, from: this);

  @override
  String toString() => r'availablePegOrderFeeChangeProvider';
}

@ProviderFor(pegOutNextBlockFeeRate)
const pegOutNextBlockFeeRateProvider = PegOutNextBlockFeeRateProvider._();

final class PegOutNextBlockFeeRateProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  const PegOutNextBlockFeeRateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pegOutNextBlockFeeRateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pegOutNextBlockFeeRateHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return pegOutNextBlockFeeRate(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$pegOutNextBlockFeeRateHash() =>
    r'af885c16c4d4371343a0dfb7ff0b41c27f945625';

@ProviderFor(pegOutEditFeeRateHelper)
const pegOutEditFeeRateHelperProvider = PegOutEditFeeRateHelperFamily._();

final class PegOutEditFeeRateHelperProvider
    extends
        $FunctionalProvider<
          PegOutEditFeeRateHelper,
          PegOutEditFeeRateHelper,
          PegOutEditFeeRateHelper
        >
    with $Provider<PegOutEditFeeRateHelper> {
  const PegOutEditFeeRateHelperProvider._({
    required PegOutEditFeeRateHelperFamily super.from,
    required Option<String> super.argument,
  }) : super(
         retry: null,
         name: r'pegOutEditFeeRateHelperProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$pegOutEditFeeRateHelperHash();

  @override
  String toString() {
    return r'pegOutEditFeeRateHelperProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<PegOutEditFeeRateHelper> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PegOutEditFeeRateHelper create(Ref ref) {
    final argument = this.argument as Option<String>;
    return pegOutEditFeeRateHelper(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PegOutEditFeeRateHelper value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PegOutEditFeeRateHelper>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PegOutEditFeeRateHelperProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$pegOutEditFeeRateHelperHash() =>
    r'14c88281dd8e59e07f4e40910e1854fa59ebcd14';

final class PegOutEditFeeRateHelperFamily extends $Family
    with $FunctionalFamilyOverride<PegOutEditFeeRateHelper, Option<String>> {
  const PegOutEditFeeRateHelperFamily._()
    : super(
        retry: null,
        name: r'pegOutEditFeeRateHelperProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PegOutEditFeeRateHelperProvider call(Option<String> optionSelectedFeeRate) =>
      PegOutEditFeeRateHelperProvider._(
        argument: optionSelectedFeeRate,
        from: this,
      );

  @override
  String toString() => r'pegOutEditFeeRateHelperProvider';
}

@ProviderFor(PegOutEditFeeRateResultStream)
const pegOutEditFeeRateResultStreamProvider =
    PegOutEditFeeRateResultStreamProvider._();

final class PegOutEditFeeRateResultStreamProvider
    extends
        $StreamNotifierProvider<
          PegOutEditFeeRateResultStream,
          Option<PegOutEditFeeRateResult>
        > {
  const PegOutEditFeeRateResultStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pegOutEditFeeRateResultStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pegOutEditFeeRateResultStreamHash();

  @$internal
  @override
  PegOutEditFeeRateResultStream create() => PegOutEditFeeRateResultStream();
}

String _$pegOutEditFeeRateResultStreamHash() =>
    r'9f9aaf48feb7379d51827725e98c27830a7d10bf';

abstract class _$PegOutEditFeeRateResultStream
    extends $StreamNotifier<Option<PegOutEditFeeRateResult>> {
  Stream<Option<PegOutEditFeeRateResult>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<Option<PegOutEditFeeRateResult>>,
              Option<PegOutEditFeeRateResult>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<Option<PegOutEditFeeRateResult>>,
                Option<PegOutEditFeeRateResult>
              >,
              AsyncValue<Option<PegOutEditFeeRateResult>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(pegDetailsTransItem)
const pegDetailsTransItemProvider = PegDetailsTransItemProvider._();

final class PegDetailsTransItemProvider
    extends
        $FunctionalProvider<
          Option<TransItem>,
          Option<TransItem>,
          Option<TransItem>
        >
    with $Provider<Option<TransItem>> {
  const PegDetailsTransItemProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pegDetailsTransItemProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pegDetailsTransItemHash();

  @$internal
  @override
  $ProviderElement<Option<TransItem>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Option<TransItem> create(Ref ref) {
    return pegDetailsTransItem(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Option<TransItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Option<TransItem>>(value),
    );
  }
}

String _$pegDetailsTransItemHash() =>
    r'c198f34b4afc13d817609e2969debc2a711fed7f';
