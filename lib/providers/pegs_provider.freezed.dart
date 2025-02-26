// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pegs_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$PegSubscribedValues {
  int get pegInMinimumAmount => throw _privateConstructorUsedError;
  int get pegInWalletBalance => throw _privateConstructorUsedError;
  int get pegOutMinimumAmount => throw _privateConstructorUsedError;
  int get pegOutWalletBalance => throw _privateConstructorUsedError;

  /// Create a copy of PegSubscribedValues
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PegSubscribedValuesCopyWith<PegSubscribedValues> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PegSubscribedValuesCopyWith<$Res> {
  factory $PegSubscribedValuesCopyWith(
    PegSubscribedValues value,
    $Res Function(PegSubscribedValues) then,
  ) = _$PegSubscribedValuesCopyWithImpl<$Res, PegSubscribedValues>;
  @useResult
  $Res call({
    int pegInMinimumAmount,
    int pegInWalletBalance,
    int pegOutMinimumAmount,
    int pegOutWalletBalance,
  });
}

/// @nodoc
class _$PegSubscribedValuesCopyWithImpl<$Res, $Val extends PegSubscribedValues>
    implements $PegSubscribedValuesCopyWith<$Res> {
  _$PegSubscribedValuesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PegSubscribedValues
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pegInMinimumAmount = null,
    Object? pegInWalletBalance = null,
    Object? pegOutMinimumAmount = null,
    Object? pegOutWalletBalance = null,
  }) {
    return _then(
      _value.copyWith(
            pegInMinimumAmount:
                null == pegInMinimumAmount
                    ? _value.pegInMinimumAmount
                    : pegInMinimumAmount // ignore: cast_nullable_to_non_nullable
                        as int,
            pegInWalletBalance:
                null == pegInWalletBalance
                    ? _value.pegInWalletBalance
                    : pegInWalletBalance // ignore: cast_nullable_to_non_nullable
                        as int,
            pegOutMinimumAmount:
                null == pegOutMinimumAmount
                    ? _value.pegOutMinimumAmount
                    : pegOutMinimumAmount // ignore: cast_nullable_to_non_nullable
                        as int,
            pegOutWalletBalance:
                null == pegOutWalletBalance
                    ? _value.pegOutWalletBalance
                    : pegOutWalletBalance // ignore: cast_nullable_to_non_nullable
                        as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PegSubscribedValuesImplCopyWith<$Res>
    implements $PegSubscribedValuesCopyWith<$Res> {
  factory _$$PegSubscribedValuesImplCopyWith(
    _$PegSubscribedValuesImpl value,
    $Res Function(_$PegSubscribedValuesImpl) then,
  ) = __$$PegSubscribedValuesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int pegInMinimumAmount,
    int pegInWalletBalance,
    int pegOutMinimumAmount,
    int pegOutWalletBalance,
  });
}

/// @nodoc
class __$$PegSubscribedValuesImplCopyWithImpl<$Res>
    extends _$PegSubscribedValuesCopyWithImpl<$Res, _$PegSubscribedValuesImpl>
    implements _$$PegSubscribedValuesImplCopyWith<$Res> {
  __$$PegSubscribedValuesImplCopyWithImpl(
    _$PegSubscribedValuesImpl _value,
    $Res Function(_$PegSubscribedValuesImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PegSubscribedValues
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pegInMinimumAmount = null,
    Object? pegInWalletBalance = null,
    Object? pegOutMinimumAmount = null,
    Object? pegOutWalletBalance = null,
  }) {
    return _then(
      _$PegSubscribedValuesImpl(
        pegInMinimumAmount:
            null == pegInMinimumAmount
                ? _value.pegInMinimumAmount
                : pegInMinimumAmount // ignore: cast_nullable_to_non_nullable
                    as int,
        pegInWalletBalance:
            null == pegInWalletBalance
                ? _value.pegInWalletBalance
                : pegInWalletBalance // ignore: cast_nullable_to_non_nullable
                    as int,
        pegOutMinimumAmount:
            null == pegOutMinimumAmount
                ? _value.pegOutMinimumAmount
                : pegOutMinimumAmount // ignore: cast_nullable_to_non_nullable
                    as int,
        pegOutWalletBalance:
            null == pegOutWalletBalance
                ? _value.pegOutWalletBalance
                : pegOutWalletBalance // ignore: cast_nullable_to_non_nullable
                    as int,
      ),
    );
  }
}

/// @nodoc

class _$PegSubscribedValuesImpl implements _PegSubscribedValues {
  const _$PegSubscribedValuesImpl({
    this.pegInMinimumAmount = 0,
    this.pegInWalletBalance = 0,
    this.pegOutMinimumAmount = 0,
    this.pegOutWalletBalance = 0,
  });

  @override
  @JsonKey()
  final int pegInMinimumAmount;
  @override
  @JsonKey()
  final int pegInWalletBalance;
  @override
  @JsonKey()
  final int pegOutMinimumAmount;
  @override
  @JsonKey()
  final int pegOutWalletBalance;

  @override
  String toString() {
    return 'PegSubscribedValues(pegInMinimumAmount: $pegInMinimumAmount, pegInWalletBalance: $pegInWalletBalance, pegOutMinimumAmount: $pegOutMinimumAmount, pegOutWalletBalance: $pegOutWalletBalance)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PegSubscribedValuesImpl &&
            (identical(other.pegInMinimumAmount, pegInMinimumAmount) ||
                other.pegInMinimumAmount == pegInMinimumAmount) &&
            (identical(other.pegInWalletBalance, pegInWalletBalance) ||
                other.pegInWalletBalance == pegInWalletBalance) &&
            (identical(other.pegOutMinimumAmount, pegOutMinimumAmount) ||
                other.pegOutMinimumAmount == pegOutMinimumAmount) &&
            (identical(other.pegOutWalletBalance, pegOutWalletBalance) ||
                other.pegOutWalletBalance == pegOutWalletBalance));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    pegInMinimumAmount,
    pegInWalletBalance,
    pegOutMinimumAmount,
    pegOutWalletBalance,
  );

  /// Create a copy of PegSubscribedValues
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PegSubscribedValuesImplCopyWith<_$PegSubscribedValuesImpl> get copyWith =>
      __$$PegSubscribedValuesImplCopyWithImpl<_$PegSubscribedValuesImpl>(
        this,
        _$identity,
      );
}

abstract class _PegSubscribedValues implements PegSubscribedValues {
  const factory _PegSubscribedValues({
    final int pegInMinimumAmount,
    final int pegInWalletBalance,
    final int pegOutMinimumAmount,
    final int pegOutWalletBalance,
  }) = _$PegSubscribedValuesImpl;

  @override
  int get pegInMinimumAmount;
  @override
  int get pegInWalletBalance;
  @override
  int get pegOutMinimumAmount;
  @override
  int get pegOutWalletBalance;

  /// Create a copy of PegSubscribedValues
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PegSubscribedValuesImplCopyWith<_$PegSubscribedValuesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
