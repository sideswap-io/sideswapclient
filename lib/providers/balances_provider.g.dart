// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'balances_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BalancesNotifier)
final balancesProvider = BalancesNotifierProvider._();

final class BalancesNotifierProvider
    extends $NotifierProvider<BalancesNotifier, Map<AccountAsset, int>> {
  BalancesNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'balancesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$balancesNotifierHash();

  @$internal
  @override
  BalancesNotifier create() => BalancesNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<AccountAsset, int> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<AccountAsset, int>>(value),
    );
  }
}

String _$balancesNotifierHash() => r'ed70ac2f9f3052422ba6a16cdd70b1e4c4cbd373';

abstract class _$BalancesNotifier extends $Notifier<Map<AccountAsset, int>> {
  Map<AccountAsset, int> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<Map<AccountAsset, int>, Map<AccountAsset, int>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Map<AccountAsset, int>, Map<AccountAsset, int>>,
              Map<AccountAsset, int>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(assetBalance)
final assetBalanceProvider = AssetBalanceProvider._();

final class AssetBalanceProvider
    extends
        $FunctionalProvider<
          Map<String, int>,
          Map<String, int>,
          Map<String, int>
        >
    with $Provider<Map<String, int>> {
  AssetBalanceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'assetBalanceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$assetBalanceHash();

  @$internal
  @override
  $ProviderElement<Map<String, int>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Map<String, int> create(Ref ref) {
    return assetBalance(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, int> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, int>>(value),
    );
  }
}

String _$assetBalanceHash() => r'9576cbdf3a4cea102bc46dae41fb7c78fcb8501e';

@ProviderFor(outputsBalanceForAsset)
final outputsBalanceForAssetProvider = OutputsBalanceForAssetFamily._();

final class OutputsBalanceForAssetProvider
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  OutputsBalanceForAssetProvider._({
    required OutputsBalanceForAssetFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'outputsBalanceForAssetProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$outputsBalanceForAssetHash();

  @override
  String toString() {
    return r'outputsBalanceForAssetProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    final argument = this.argument as String;
    return outputsBalanceForAsset(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is OutputsBalanceForAssetProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$outputsBalanceForAssetHash() =>
    r'2572afc24a6024b7d30834c599cbac157c7e9132';

final class OutputsBalanceForAssetFamily extends $Family
    with $FunctionalFamilyOverride<int, String> {
  OutputsBalanceForAssetFamily._()
    : super(
        retry: null,
        name: r'outputsBalanceForAssetProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  OutputsBalanceForAssetProvider call(String assetId) =>
      OutputsBalanceForAssetProvider._(argument: assetId, from: this);

  @override
  String toString() => r'outputsBalanceForAssetProvider';
}

/// Inputs related providers

@ProviderFor(selectedInputsBalanceForAsset)
final selectedInputsBalanceForAssetProvider =
    SelectedInputsBalanceForAssetFamily._();

/// Inputs related providers

final class SelectedInputsBalanceForAssetProvider
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  /// Inputs related providers
  SelectedInputsBalanceForAssetProvider._({
    required SelectedInputsBalanceForAssetFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'selectedInputsBalanceForAssetProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$selectedInputsBalanceForAssetHash();

  @override
  String toString() {
    return r'selectedInputsBalanceForAssetProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    final argument = this.argument as String;
    return selectedInputsBalanceForAsset(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SelectedInputsBalanceForAssetProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$selectedInputsBalanceForAssetHash() =>
    r'7cf1808ba1e118c6481cd87380f4dd5c67e2129c';

/// Inputs related providers

final class SelectedInputsBalanceForAssetFamily extends $Family
    with $FunctionalFamilyOverride<int, String> {
  SelectedInputsBalanceForAssetFamily._()
    : super(
        retry: null,
        name: r'selectedInputsBalanceForAssetProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Inputs related providers

  SelectedInputsBalanceForAssetProvider call(String assetId) =>
      SelectedInputsBalanceForAssetProvider._(argument: assetId, from: this);

  @override
  String toString() => r'selectedInputsBalanceForAssetProvider';
}

@ProviderFor(maxAvailableBalanceWithInputsForAsset)
final maxAvailableBalanceWithInputsForAssetProvider =
    MaxAvailableBalanceWithInputsForAssetFamily._();

final class MaxAvailableBalanceWithInputsForAssetProvider
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  MaxAvailableBalanceWithInputsForAssetProvider._({
    required MaxAvailableBalanceWithInputsForAssetFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'maxAvailableBalanceWithInputsForAssetProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() =>
      _$maxAvailableBalanceWithInputsForAssetHash();

  @override
  String toString() {
    return r'maxAvailableBalanceWithInputsForAssetProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    final argument = this.argument as String;
    return maxAvailableBalanceWithInputsForAsset(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MaxAvailableBalanceWithInputsForAssetProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$maxAvailableBalanceWithInputsForAssetHash() =>
    r'2c4366e31f865bfb944e4e0789e5aedeeac616b3';

final class MaxAvailableBalanceWithInputsForAssetFamily extends $Family
    with $FunctionalFamilyOverride<int, String> {
  MaxAvailableBalanceWithInputsForAssetFamily._()
    : super(
        retry: null,
        name: r'maxAvailableBalanceWithInputsForAssetProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MaxAvailableBalanceWithInputsForAssetProvider call(String assetId) =>
      MaxAvailableBalanceWithInputsForAssetProvider._(
        argument: assetId,
        from: this,
      );

  @override
  String toString() => r'maxAvailableBalanceWithInputsForAssetProvider';
}

@ProviderFor(balanceWithInputsForAsset)
final balanceWithInputsForAssetProvider = BalanceWithInputsForAssetFamily._();

final class BalanceWithInputsForAssetProvider
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  BalanceWithInputsForAssetProvider._({
    required BalanceWithInputsForAssetFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'balanceWithInputsForAssetProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$balanceWithInputsForAssetHash();

  @override
  String toString() {
    return r'balanceWithInputsForAssetProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    final argument = this.argument as String;
    return balanceWithInputsForAsset(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is BalanceWithInputsForAssetProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$balanceWithInputsForAssetHash() =>
    r'57a40b0c081587fd03354c4cbb4d687d580c19fa';

final class BalanceWithInputsForAssetFamily extends $Family
    with $FunctionalFamilyOverride<int, String> {
  BalanceWithInputsForAssetFamily._()
    : super(
        retry: null,
        name: r'balanceWithInputsForAssetProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  BalanceWithInputsForAssetProvider call(String assetId) =>
      BalanceWithInputsForAssetProvider._(argument: assetId, from: this);

  @override
  String toString() => r'balanceWithInputsForAssetProvider';
}

@ProviderFor(balanceStringWithInputsForAsset)
final balanceStringWithInputsForAssetProvider =
    BalanceStringWithInputsForAssetFamily._();

final class BalanceStringWithInputsForAssetProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  BalanceStringWithInputsForAssetProvider._({
    required BalanceStringWithInputsForAssetFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'balanceStringWithInputsForAssetProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$balanceStringWithInputsForAssetHash();

  @override
  String toString() {
    return r'balanceStringWithInputsForAssetProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    final argument = this.argument as String;
    return balanceStringWithInputsForAsset(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is BalanceStringWithInputsForAssetProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$balanceStringWithInputsForAssetHash() =>
    r'a70aa70fc1b458398d9046ee93f3db0a51eb4a44';

final class BalanceStringWithInputsForAssetFamily extends $Family
    with $FunctionalFamilyOverride<String, String> {
  BalanceStringWithInputsForAssetFamily._()
    : super(
        retry: null,
        name: r'balanceStringWithInputsForAssetProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  BalanceStringWithInputsForAssetProvider call(String assetId) =>
      BalanceStringWithInputsForAssetProvider._(argument: assetId, from: this);

  @override
  String toString() => r'balanceStringWithInputsForAssetProvider';
}

@ProviderFor(balanceStringWithInputs)
final balanceStringWithInputsProvider = BalanceStringWithInputsProvider._();

final class BalanceStringWithInputsProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  BalanceStringWithInputsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'balanceStringWithInputsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$balanceStringWithInputsHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return balanceStringWithInputs(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$balanceStringWithInputsHash() =>
    r'6dba141e287043a20cb8fc93a030d5e29e0f91c3';

@ProviderFor(assetBalanceWithInputsInDefaultCurrency)
final assetBalanceWithInputsInDefaultCurrencyProvider =
    AssetBalanceWithInputsInDefaultCurrencyFamily._();

final class AssetBalanceWithInputsInDefaultCurrencyProvider
    extends $FunctionalProvider<Decimal, Decimal, Decimal>
    with $Provider<Decimal> {
  AssetBalanceWithInputsInDefaultCurrencyProvider._({
    required AssetBalanceWithInputsInDefaultCurrencyFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'assetBalanceWithInputsInDefaultCurrencyProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() =>
      _$assetBalanceWithInputsInDefaultCurrencyHash();

  @override
  String toString() {
    return r'assetBalanceWithInputsInDefaultCurrencyProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<Decimal> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Decimal create(Ref ref) {
    final argument = this.argument as String;
    return assetBalanceWithInputsInDefaultCurrency(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Decimal value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Decimal>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AssetBalanceWithInputsInDefaultCurrencyProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$assetBalanceWithInputsInDefaultCurrencyHash() =>
    r'108ee37efc8612aa67cf8299af2e77715dadd915';

final class AssetBalanceWithInputsInDefaultCurrencyFamily extends $Family
    with $FunctionalFamilyOverride<Decimal, String> {
  AssetBalanceWithInputsInDefaultCurrencyFamily._()
    : super(
        retry: null,
        name: r'assetBalanceWithInputsInDefaultCurrencyProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AssetBalanceWithInputsInDefaultCurrencyProvider call(String assetId) =>
      AssetBalanceWithInputsInDefaultCurrencyProvider._(
        argument: assetId,
        from: this,
      );

  @override
  String toString() => r'assetBalanceWithInputsInDefaultCurrencyProvider';
}

@ProviderFor(assetBalanceWithInputsInDefaultCurrencyString)
final assetBalanceWithInputsInDefaultCurrencyStringProvider =
    AssetBalanceWithInputsInDefaultCurrencyStringFamily._();

final class AssetBalanceWithInputsInDefaultCurrencyStringProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  AssetBalanceWithInputsInDefaultCurrencyStringProvider._({
    required AssetBalanceWithInputsInDefaultCurrencyStringFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'assetBalanceWithInputsInDefaultCurrencyStringProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() =>
      _$assetBalanceWithInputsInDefaultCurrencyStringHash();

  @override
  String toString() {
    return r'assetBalanceWithInputsInDefaultCurrencyStringProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    final argument = this.argument as String;
    return assetBalanceWithInputsInDefaultCurrencyString(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AssetBalanceWithInputsInDefaultCurrencyStringProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$assetBalanceWithInputsInDefaultCurrencyStringHash() =>
    r'694a49cd1bf9770aef7e95c0be1f47060fc46ed1';

final class AssetBalanceWithInputsInDefaultCurrencyStringFamily extends $Family
    with $FunctionalFamilyOverride<String, String> {
  AssetBalanceWithInputsInDefaultCurrencyStringFamily._()
    : super(
        retry: null,
        name: r'assetBalanceWithInputsInDefaultCurrencyStringProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AssetBalanceWithInputsInDefaultCurrencyStringProvider call(String assetId) =>
      AssetBalanceWithInputsInDefaultCurrencyStringProvider._(
        argument: assetId,
        from: this,
      );

  @override
  String toString() => r'assetBalanceWithInputsInDefaultCurrencyStringProvider';
}

/// Balance providers without inputs

@ProviderFor(availableBalanceForAssetId)
final availableBalanceForAssetIdProvider = AvailableBalanceForAssetIdFamily._();

/// Balance providers without inputs

final class AvailableBalanceForAssetIdProvider
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  /// Balance providers without inputs
  AvailableBalanceForAssetIdProvider._({
    required AvailableBalanceForAssetIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'availableBalanceForAssetIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$availableBalanceForAssetIdHash();

  @override
  String toString() {
    return r'availableBalanceForAssetIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    final argument = this.argument as String;
    return availableBalanceForAssetId(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AvailableBalanceForAssetIdProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$availableBalanceForAssetIdHash() =>
    r'549bf9ece9f30ab63ac70d93508b66f1a0909904';

/// Balance providers without inputs

final class AvailableBalanceForAssetIdFamily extends $Family
    with $FunctionalFamilyOverride<int, String> {
  AvailableBalanceForAssetIdFamily._()
    : super(
        retry: null,
        name: r'availableBalanceForAssetIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Balance providers without inputs

  AvailableBalanceForAssetIdProvider call(String assetId) =>
      AvailableBalanceForAssetIdProvider._(argument: assetId, from: this);

  @override
  String toString() => r'availableBalanceForAssetIdProvider';
}

@ProviderFor(amountUsdInDefaultCurrency)
final amountUsdInDefaultCurrencyProvider = AmountUsdInDefaultCurrencyFamily._();

final class AmountUsdInDefaultCurrencyProvider
    extends $FunctionalProvider<Decimal, Decimal, Decimal>
    with $Provider<Decimal> {
  AmountUsdInDefaultCurrencyProvider._({
    required AmountUsdInDefaultCurrencyFamily super.from,
    required (String?, num) super.argument,
  }) : super(
         retry: null,
         name: r'amountUsdInDefaultCurrencyProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$amountUsdInDefaultCurrencyHash();

  @override
  String toString() {
    return r'amountUsdInDefaultCurrencyProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $ProviderElement<Decimal> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Decimal create(Ref ref) {
    final argument = this.argument as (String?, num);
    return amountUsdInDefaultCurrency(ref, argument.$1, argument.$2);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Decimal value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Decimal>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AmountUsdInDefaultCurrencyProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$amountUsdInDefaultCurrencyHash() =>
    r'b8085e473b91fb484a717183baced9801f1b3b81';

final class AmountUsdInDefaultCurrencyFamily extends $Family
    with $FunctionalFamilyOverride<Decimal, (String?, num)> {
  AmountUsdInDefaultCurrencyFamily._()
    : super(
        retry: null,
        name: r'amountUsdInDefaultCurrencyProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AmountUsdInDefaultCurrencyProvider call(String? assetId, num amount) =>
      AmountUsdInDefaultCurrencyProvider._(
        argument: (assetId, amount),
        from: this,
      );

  @override
  String toString() => r'amountUsdInDefaultCurrencyProvider';
}

@ProviderFor(amountUsd)
final amountUsdProvider = AmountUsdFamily._();

final class AmountUsdProvider
    extends $FunctionalProvider<Decimal, Decimal, Decimal>
    with $Provider<Decimal> {
  AmountUsdProvider._({
    required AmountUsdFamily super.from,
    required (String?, num) super.argument,
  }) : super(
         retry: null,
         name: r'amountUsdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$amountUsdHash();

  @override
  String toString() {
    return r'amountUsdProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $ProviderElement<Decimal> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Decimal create(Ref ref) {
    final argument = this.argument as (String?, num);
    return amountUsd(ref, argument.$1, argument.$2);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Decimal value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Decimal>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AmountUsdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$amountUsdHash() => r'83fdf76112790a1a9086650501bf38cb3696377e';

final class AmountUsdFamily extends $Family
    with $FunctionalFamilyOverride<Decimal, (String?, num)> {
  AmountUsdFamily._()
    : super(
        retry: null,
        name: r'amountUsdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AmountUsdProvider call(String? assetId, num amount) =>
      AmountUsdProvider._(argument: (assetId, amount), from: this);

  @override
  String toString() => r'amountUsdProvider';
}

@ProviderFor(isAmountUsdAvailable)
final isAmountUsdAvailableProvider = IsAmountUsdAvailableFamily._();

final class IsAmountUsdAvailableProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  IsAmountUsdAvailableProvider._({
    required IsAmountUsdAvailableFamily super.from,
    required String? super.argument,
  }) : super(
         retry: null,
         name: r'isAmountUsdAvailableProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$isAmountUsdAvailableHash();

  @override
  String toString() {
    return r'isAmountUsdAvailableProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    final argument = this.argument as String?;
    return isAmountUsdAvailable(ref, argument);
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
    return other is IsAmountUsdAvailableProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$isAmountUsdAvailableHash() =>
    r'9016cd0dea1fa4524b407c0879e599b23f376dc4';

final class IsAmountUsdAvailableFamily extends $Family
    with $FunctionalFamilyOverride<bool, String?> {
  IsAmountUsdAvailableFamily._()
    : super(
        retry: null,
        name: r'isAmountUsdAvailableProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  IsAmountUsdAvailableProvider call(String? assetId) =>
      IsAmountUsdAvailableProvider._(argument: assetId, from: this);

  @override
  String toString() => r'isAmountUsdAvailableProvider';
}

@ProviderFor(defaultCurrencyConversion)
final defaultCurrencyConversionProvider = DefaultCurrencyConversionFamily._();

final class DefaultCurrencyConversionProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  DefaultCurrencyConversionProvider._({
    required DefaultCurrencyConversionFamily super.from,
    required (String?, num) super.argument,
  }) : super(
         retry: null,
         name: r'defaultCurrencyConversionProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$defaultCurrencyConversionHash();

  @override
  String toString() {
    return r'defaultCurrencyConversionProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    final argument = this.argument as (String?, num);
    return defaultCurrencyConversion(ref, argument.$1, argument.$2);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is DefaultCurrencyConversionProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$defaultCurrencyConversionHash() =>
    r'f326e73283c18198419da837b2bfb457fa342cdc';

final class DefaultCurrencyConversionFamily extends $Family
    with $FunctionalFamilyOverride<String, (String?, num)> {
  DefaultCurrencyConversionFamily._()
    : super(
        retry: null,
        name: r'defaultCurrencyConversionProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DefaultCurrencyConversionProvider call(String? assetId, num amount) =>
      DefaultCurrencyConversionProvider._(
        argument: (assetId, amount),
        from: this,
      );

  @override
  String toString() => r'defaultCurrencyConversionProvider';
}

@ProviderFor(defaultCurrencyConversionWithTicker)
final defaultCurrencyConversionWithTickerProvider =
    DefaultCurrencyConversionWithTickerFamily._();

final class DefaultCurrencyConversionWithTickerProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  DefaultCurrencyConversionWithTickerProvider._({
    required DefaultCurrencyConversionWithTickerFamily super.from,
    required (String?, num) super.argument,
  }) : super(
         retry: null,
         name: r'defaultCurrencyConversionWithTickerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() =>
      _$defaultCurrencyConversionWithTickerHash();

  @override
  String toString() {
    return r'defaultCurrencyConversionWithTickerProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    final argument = this.argument as (String?, num);
    return defaultCurrencyConversionWithTicker(ref, argument.$1, argument.$2);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is DefaultCurrencyConversionWithTickerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$defaultCurrencyConversionWithTickerHash() =>
    r'd2d453077c021fee579cb7dc35e6dca567d5f128';

final class DefaultCurrencyConversionWithTickerFamily extends $Family
    with $FunctionalFamilyOverride<String, (String?, num)> {
  DefaultCurrencyConversionWithTickerFamily._()
    : super(
        retry: null,
        name: r'defaultCurrencyConversionWithTickerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DefaultCurrencyConversionWithTickerProvider call(
    String? assetId,
    num amount,
  ) => DefaultCurrencyConversionWithTickerProvider._(
    argument: (assetId, amount),
    from: this,
  );

  @override
  String toString() => r'defaultCurrencyConversionWithTickerProvider';
}

@ProviderFor(defaultCurrencyConversionFromString)
final defaultCurrencyConversionFromStringProvider =
    DefaultCurrencyConversionFromStringFamily._();

final class DefaultCurrencyConversionFromStringProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  DefaultCurrencyConversionFromStringProvider._({
    required DefaultCurrencyConversionFromStringFamily super.from,
    required (String?, String) super.argument,
  }) : super(
         retry: null,
         name: r'defaultCurrencyConversionFromStringProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() =>
      _$defaultCurrencyConversionFromStringHash();

  @override
  String toString() {
    return r'defaultCurrencyConversionFromStringProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    final argument = this.argument as (String?, String);
    return defaultCurrencyConversionFromString(ref, argument.$1, argument.$2);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is DefaultCurrencyConversionFromStringProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$defaultCurrencyConversionFromStringHash() =>
    r'a934e1fc12818e61e309492cd0d49dddc001d539';

final class DefaultCurrencyConversionFromStringFamily extends $Family
    with $FunctionalFamilyOverride<String, (String?, String)> {
  DefaultCurrencyConversionFromStringFamily._()
    : super(
        retry: null,
        name: r'defaultCurrencyConversionFromStringProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DefaultCurrencyConversionFromStringProvider call(
    String? assetId,
    String amount,
  ) => DefaultCurrencyConversionFromStringProvider._(
    argument: (assetId, amount),
    from: this,
  );

  @override
  String toString() => r'defaultCurrencyConversionFromStringProvider';
}

/// Total LBTC ============

@ProviderFor(assetsTotalLbtcBalance)
final assetsTotalLbtcBalanceProvider = AssetsTotalLbtcBalanceFamily._();

/// Total LBTC ============

final class AssetsTotalLbtcBalanceProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  /// Total LBTC ============
  AssetsTotalLbtcBalanceProvider._({
    required AssetsTotalLbtcBalanceFamily super.from,
    required Iterable<Asset> super.argument,
  }) : super(
         retry: null,
         name: r'assetsTotalLbtcBalanceProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$assetsTotalLbtcBalanceHash();

  @override
  String toString() {
    return r'assetsTotalLbtcBalanceProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    final argument = this.argument as Iterable<Asset>;
    return assetsTotalLbtcBalance(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AssetsTotalLbtcBalanceProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$assetsTotalLbtcBalanceHash() =>
    r'4a9e4c930e9fb50e1466f3e0b516d0aef658992d';

/// Total LBTC ============

final class AssetsTotalLbtcBalanceFamily extends $Family
    with $FunctionalFamilyOverride<String, Iterable<Asset>> {
  AssetsTotalLbtcBalanceFamily._()
    : super(
        retry: null,
        name: r'assetsTotalLbtcBalanceProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Total LBTC ============

  AssetsTotalLbtcBalanceProvider call(Iterable<Asset> assets) =>
      AssetsTotalLbtcBalanceProvider._(argument: assets, from: this);

  @override
  String toString() => r'assetsTotalLbtcBalanceProvider';
}

/// USD currency converters ============

@ProviderFor(assetsTotalUsdBalanceString)
final assetsTotalUsdBalanceStringProvider =
    AssetsTotalUsdBalanceStringFamily._();

/// USD currency converters ============

final class AssetsTotalUsdBalanceStringProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  /// USD currency converters ============
  AssetsTotalUsdBalanceStringProvider._({
    required AssetsTotalUsdBalanceStringFamily super.from,
    required Iterable<Asset> super.argument,
  }) : super(
         retry: null,
         name: r'assetsTotalUsdBalanceStringProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$assetsTotalUsdBalanceStringHash();

  @override
  String toString() {
    return r'assetsTotalUsdBalanceStringProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    final argument = this.argument as Iterable<Asset>;
    return assetsTotalUsdBalanceString(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AssetsTotalUsdBalanceStringProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$assetsTotalUsdBalanceStringHash() =>
    r'cb9ed6d66d973eb8e7ba21cfa1d68d9eda6a0d36';

/// USD currency converters ============

final class AssetsTotalUsdBalanceStringFamily extends $Family
    with $FunctionalFamilyOverride<String, Iterable<Asset>> {
  AssetsTotalUsdBalanceStringFamily._()
    : super(
        retry: null,
        name: r'assetsTotalUsdBalanceStringProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// USD currency converters ============

  AssetsTotalUsdBalanceStringProvider call(Iterable<Asset> assets) =>
      AssetsTotalUsdBalanceStringProvider._(argument: assets, from: this);

  @override
  String toString() => r'assetsTotalUsdBalanceStringProvider';
}

@ProviderFor(_assetsTotalUsdBalance)
final _assetsTotalUsdBalanceProvider = _AssetsTotalUsdBalanceFamily._();

final class _AssetsTotalUsdBalanceProvider
    extends $FunctionalProvider<Decimal, Decimal, Decimal>
    with $Provider<Decimal> {
  _AssetsTotalUsdBalanceProvider._({
    required _AssetsTotalUsdBalanceFamily super.from,
    required Iterable<Asset> super.argument,
  }) : super(
         retry: null,
         name: r'_assetsTotalUsdBalanceProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$_assetsTotalUsdBalanceHash();

  @override
  String toString() {
    return r'_assetsTotalUsdBalanceProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<Decimal> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Decimal create(Ref ref) {
    final argument = this.argument as Iterable<Asset>;
    return _assetsTotalUsdBalance(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Decimal value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Decimal>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is _AssetsTotalUsdBalanceProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$_assetsTotalUsdBalanceHash() =>
    r'1a47037c7077921432b002b241f14fbc8a3485d0';

final class _AssetsTotalUsdBalanceFamily extends $Family
    with $FunctionalFamilyOverride<Decimal, Iterable<Asset>> {
  _AssetsTotalUsdBalanceFamily._()
    : super(
        retry: null,
        name: r'_assetsTotalUsdBalanceProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  _AssetsTotalUsdBalanceProvider call(Iterable<Asset> assets) =>
      _AssetsTotalUsdBalanceProvider._(argument: assets, from: this);

  @override
  String toString() => r'_assetsTotalUsdBalanceProvider';
}

@ProviderFor(assetBalanceInUsd)
final assetBalanceInUsdProvider = AssetBalanceInUsdFamily._();

final class AssetBalanceInUsdProvider
    extends $FunctionalProvider<Decimal, Decimal, Decimal>
    with $Provider<Decimal> {
  AssetBalanceInUsdProvider._({
    required AssetBalanceInUsdFamily super.from,
    required Asset super.argument,
  }) : super(
         retry: null,
         name: r'assetBalanceInUsdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$assetBalanceInUsdHash();

  @override
  String toString() {
    return r'assetBalanceInUsdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<Decimal> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Decimal create(Ref ref) {
    final argument = this.argument as Asset;
    return assetBalanceInUsd(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Decimal value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Decimal>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AssetBalanceInUsdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$assetBalanceInUsdHash() => r'6f6845f12c09b750ff696ce71ee2a4351a6b475b';

final class AssetBalanceInUsdFamily extends $Family
    with $FunctionalFamilyOverride<Decimal, Asset> {
  AssetBalanceInUsdFamily._()
    : super(
        retry: null,
        name: r'assetBalanceInUsdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AssetBalanceInUsdProvider call(Asset asset) =>
      AssetBalanceInUsdProvider._(argument: asset, from: this);

  @override
  String toString() => r'assetBalanceInUsdProvider';
}

@ProviderFor(assetBalanceInUsdString)
final assetBalanceInUsdStringProvider = AssetBalanceInUsdStringFamily._();

final class AssetBalanceInUsdStringProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  AssetBalanceInUsdStringProvider._({
    required AssetBalanceInUsdStringFamily super.from,
    required Asset super.argument,
  }) : super(
         retry: null,
         name: r'assetBalanceInUsdStringProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$assetBalanceInUsdStringHash();

  @override
  String toString() {
    return r'assetBalanceInUsdStringProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    final argument = this.argument as Asset;
    return assetBalanceInUsdString(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AssetBalanceInUsdStringProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$assetBalanceInUsdStringHash() =>
    r'b47bc5da72581d56d495aed0288f5cc25ae460d7';

final class AssetBalanceInUsdStringFamily extends $Family
    with $FunctionalFamilyOverride<String, Asset> {
  AssetBalanceInUsdStringFamily._()
    : super(
        retry: null,
        name: r'assetBalanceInUsdStringProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AssetBalanceInUsdStringProvider call(Asset asset) =>
      AssetBalanceInUsdStringProvider._(argument: asset, from: this);

  @override
  String toString() => r'assetBalanceInUsdStringProvider';
}

/// Default currency converters ============

@ProviderFor(assetsTotalDefaultCurrencyBalanceString)
final assetsTotalDefaultCurrencyBalanceStringProvider =
    AssetsTotalDefaultCurrencyBalanceStringFamily._();

/// Default currency converters ============

final class AssetsTotalDefaultCurrencyBalanceStringProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  /// Default currency converters ============
  AssetsTotalDefaultCurrencyBalanceStringProvider._({
    required AssetsTotalDefaultCurrencyBalanceStringFamily super.from,
    required Iterable<Asset> super.argument,
  }) : super(
         retry: null,
         name: r'assetsTotalDefaultCurrencyBalanceStringProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() =>
      _$assetsTotalDefaultCurrencyBalanceStringHash();

  @override
  String toString() {
    return r'assetsTotalDefaultCurrencyBalanceStringProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    final argument = this.argument as Iterable<Asset>;
    return assetsTotalDefaultCurrencyBalanceString(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AssetsTotalDefaultCurrencyBalanceStringProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$assetsTotalDefaultCurrencyBalanceStringHash() =>
    r'29324c093e8671a56041e2018d44e2854f6ae83f';

/// Default currency converters ============

final class AssetsTotalDefaultCurrencyBalanceStringFamily extends $Family
    with $FunctionalFamilyOverride<String, Iterable<Asset>> {
  AssetsTotalDefaultCurrencyBalanceStringFamily._()
    : super(
        retry: null,
        name: r'assetsTotalDefaultCurrencyBalanceStringProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Default currency converters ============

  AssetsTotalDefaultCurrencyBalanceStringProvider call(
    Iterable<Asset> assets,
  ) => AssetsTotalDefaultCurrencyBalanceStringProvider._(
    argument: assets,
    from: this,
  );

  @override
  String toString() => r'assetsTotalDefaultCurrencyBalanceStringProvider';
}

@ProviderFor(assetsTotalDefaultCurrencyBalance)
final assetsTotalDefaultCurrencyBalanceProvider =
    AssetsTotalDefaultCurrencyBalanceFamily._();

final class AssetsTotalDefaultCurrencyBalanceProvider
    extends $FunctionalProvider<Decimal, Decimal, Decimal>
    with $Provider<Decimal> {
  AssetsTotalDefaultCurrencyBalanceProvider._({
    required AssetsTotalDefaultCurrencyBalanceFamily super.from,
    required Iterable<Asset> super.argument,
  }) : super(
         retry: null,
         name: r'assetsTotalDefaultCurrencyBalanceProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() =>
      _$assetsTotalDefaultCurrencyBalanceHash();

  @override
  String toString() {
    return r'assetsTotalDefaultCurrencyBalanceProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<Decimal> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Decimal create(Ref ref) {
    final argument = this.argument as Iterable<Asset>;
    return assetsTotalDefaultCurrencyBalance(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Decimal value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Decimal>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AssetsTotalDefaultCurrencyBalanceProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$assetsTotalDefaultCurrencyBalanceHash() =>
    r'f457c6ab7d96ae62263bd46a3df6785c093d259b';

final class AssetsTotalDefaultCurrencyBalanceFamily extends $Family
    with $FunctionalFamilyOverride<Decimal, Iterable<Asset>> {
  AssetsTotalDefaultCurrencyBalanceFamily._()
    : super(
        retry: null,
        name: r'assetsTotalDefaultCurrencyBalanceProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AssetsTotalDefaultCurrencyBalanceProvider call(Iterable<Asset> assets) =>
      AssetsTotalDefaultCurrencyBalanceProvider._(argument: assets, from: this);

  @override
  String toString() => r'assetsTotalDefaultCurrencyBalanceProvider';
}

@ProviderFor(assetBalanceInDefaultCurrency)
final assetBalanceInDefaultCurrencyProvider =
    AssetBalanceInDefaultCurrencyFamily._();

final class AssetBalanceInDefaultCurrencyProvider
    extends $FunctionalProvider<Decimal, Decimal, Decimal>
    with $Provider<Decimal> {
  AssetBalanceInDefaultCurrencyProvider._({
    required AssetBalanceInDefaultCurrencyFamily super.from,
    required Asset super.argument,
  }) : super(
         retry: null,
         name: r'assetBalanceInDefaultCurrencyProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$assetBalanceInDefaultCurrencyHash();

  @override
  String toString() {
    return r'assetBalanceInDefaultCurrencyProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<Decimal> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Decimal create(Ref ref) {
    final argument = this.argument as Asset;
    return assetBalanceInDefaultCurrency(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Decimal value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Decimal>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AssetBalanceInDefaultCurrencyProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$assetBalanceInDefaultCurrencyHash() =>
    r'd755b77e6f36d000fbd55922b9cf9c75ae66f43c';

final class AssetBalanceInDefaultCurrencyFamily extends $Family
    with $FunctionalFamilyOverride<Decimal, Asset> {
  AssetBalanceInDefaultCurrencyFamily._()
    : super(
        retry: null,
        name: r'assetBalanceInDefaultCurrencyProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AssetBalanceInDefaultCurrencyProvider call(Asset asset) =>
      AssetBalanceInDefaultCurrencyProvider._(argument: asset, from: this);

  @override
  String toString() => r'assetBalanceInDefaultCurrencyProvider';
}

@ProviderFor(assetBalanceInDefaultCurrencyString)
final assetBalanceInDefaultCurrencyStringProvider =
    AssetBalanceInDefaultCurrencyStringFamily._();

final class AssetBalanceInDefaultCurrencyStringProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  AssetBalanceInDefaultCurrencyStringProvider._({
    required AssetBalanceInDefaultCurrencyStringFamily super.from,
    required Asset super.argument,
  }) : super(
         retry: null,
         name: r'assetBalanceInDefaultCurrencyStringProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() =>
      _$assetBalanceInDefaultCurrencyStringHash();

  @override
  String toString() {
    return r'assetBalanceInDefaultCurrencyStringProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    final argument = this.argument as Asset;
    return assetBalanceInDefaultCurrencyString(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AssetBalanceInDefaultCurrencyStringProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$assetBalanceInDefaultCurrencyStringHash() =>
    r'74bd4ccf9655efd315bef50a019d70eb6f6e6287';

final class AssetBalanceInDefaultCurrencyStringFamily extends $Family
    with $FunctionalFamilyOverride<String, Asset> {
  AssetBalanceInDefaultCurrencyStringFamily._()
    : super(
        retry: null,
        name: r'assetBalanceInDefaultCurrencyStringProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AssetBalanceInDefaultCurrencyStringProvider call(Asset asset) =>
      AssetBalanceInDefaultCurrencyStringProvider._(
        argument: asset,
        from: this,
      );

  @override
  String toString() => r'assetBalanceInDefaultCurrencyStringProvider';
}

/// Asset balance ============

@ProviderFor(assetBalanceString)
final assetBalanceStringProvider = AssetBalanceStringFamily._();

/// Asset balance ============

final class AssetBalanceStringProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  /// Asset balance ============
  AssetBalanceStringProvider._({
    required AssetBalanceStringFamily super.from,
    required Asset super.argument,
  }) : super(
         retry: null,
         name: r'assetBalanceStringProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$assetBalanceStringHash();

  @override
  String toString() {
    return r'assetBalanceStringProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    final argument = this.argument as Asset;
    return assetBalanceString(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AssetBalanceStringProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$assetBalanceStringHash() =>
    r'e380490b0208128e3e34a2f56612b784ca04ef69';

/// Asset balance ============

final class AssetBalanceStringFamily extends $Family
    with $FunctionalFamilyOverride<String, Asset> {
  AssetBalanceStringFamily._()
    : super(
        retry: null,
        name: r'assetBalanceStringProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Asset balance ============

  AssetBalanceStringProvider call(Asset asset) =>
      AssetBalanceStringProvider._(argument: asset, from: this);

  @override
  String toString() => r'assetBalanceStringProvider';
}

@ProviderFor(assetBalanceDecimal)
final assetBalanceDecimalProvider = AssetBalanceDecimalFamily._();

final class AssetBalanceDecimalProvider
    extends $FunctionalProvider<Decimal, Decimal, Decimal>
    with $Provider<Decimal> {
  AssetBalanceDecimalProvider._({
    required AssetBalanceDecimalFamily super.from,
    required Asset super.argument,
  }) : super(
         retry: null,
         name: r'assetBalanceDecimalProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$assetBalanceDecimalHash();

  @override
  String toString() {
    return r'assetBalanceDecimalProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<Decimal> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Decimal create(Ref ref) {
    final argument = this.argument as Asset;
    return assetBalanceDecimal(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Decimal value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Decimal>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AssetBalanceDecimalProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$assetBalanceDecimalHash() =>
    r'bfa57a470604bab66c4a58d53681bdde0f147a69';

final class AssetBalanceDecimalFamily extends $Family
    with $FunctionalFamilyOverride<Decimal, Asset> {
  AssetBalanceDecimalFamily._()
    : super(
        retry: null,
        name: r'assetBalanceDecimalProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AssetBalanceDecimalProvider call(Asset asset) =>
      AssetBalanceDecimalProvider._(argument: asset, from: this);

  @override
  String toString() => r'assetBalanceDecimalProvider';
}

@ProviderFor(assetBalanceDouble)
final assetBalanceDoubleProvider = AssetBalanceDoubleFamily._();

final class AssetBalanceDoubleProvider
    extends $FunctionalProvider<double, double, double>
    with $Provider<double> {
  AssetBalanceDoubleProvider._({
    required AssetBalanceDoubleFamily super.from,
    required Asset super.argument,
  }) : super(
         retry: null,
         name: r'assetBalanceDoubleProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$assetBalanceDoubleHash();

  @override
  String toString() {
    return r'assetBalanceDoubleProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<double> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  double create(Ref ref) {
    final argument = this.argument as Asset;
    return assetBalanceDouble(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(double value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<double>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AssetBalanceDoubleProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$assetBalanceDoubleHash() =>
    r'c692732f9d94f63ac2955155c2b153abfafaeb48';

final class AssetBalanceDoubleFamily extends $Family
    with $FunctionalFamilyOverride<double, Asset> {
  AssetBalanceDoubleFamily._()
    : super(
        retry: null,
        name: r'assetBalanceDoubleProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AssetBalanceDoubleProvider call(Asset asset) =>
      AssetBalanceDoubleProvider._(argument: asset, from: this);

  @override
  String toString() => r'assetBalanceDoubleProvider';
}

@ProviderFor(availableBalanceForAssetIdAsString)
final availableBalanceForAssetIdAsStringProvider =
    AvailableBalanceForAssetIdAsStringFamily._();

final class AvailableBalanceForAssetIdAsStringProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  AvailableBalanceForAssetIdAsStringProvider._({
    required AvailableBalanceForAssetIdAsStringFamily super.from,
    required String? super.argument,
  }) : super(
         retry: null,
         name: r'availableBalanceForAssetIdAsStringProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() =>
      _$availableBalanceForAssetIdAsStringHash();

  @override
  String toString() {
    return r'availableBalanceForAssetIdAsStringProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    final argument = this.argument as String?;
    return availableBalanceForAssetIdAsString(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AvailableBalanceForAssetIdAsStringProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$availableBalanceForAssetIdAsStringHash() =>
    r'a4fd4f97c08b789e86ec107bf004dbf38029e358';

final class AvailableBalanceForAssetIdAsStringFamily extends $Family
    with $FunctionalFamilyOverride<String, String?> {
  AvailableBalanceForAssetIdAsStringFamily._()
    : super(
        retry: null,
        name: r'availableBalanceForAssetIdAsStringProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AvailableBalanceForAssetIdAsStringProvider call(String? assetId) =>
      AvailableBalanceForAssetIdAsStringProvider._(
        argument: assetId,
        from: this,
      );

  @override
  String toString() => r'availableBalanceForAssetIdAsStringProvider';
}

@ProviderFor(defaultCurrencyTicker)
final defaultCurrencyTickerProvider = DefaultCurrencyTickerProvider._();

final class DefaultCurrencyTickerProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  DefaultCurrencyTickerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'defaultCurrencyTickerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$defaultCurrencyTickerHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return defaultCurrencyTicker(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$defaultCurrencyTickerHash() =>
    r'66a5c18757aa8af54c4341296e533e303b3cad34';
