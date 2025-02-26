// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'amount_to_string_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AmountToStringParameters {
  int get amount => throw _privateConstructorUsedError;
  bool get forceSign => throw _privateConstructorUsedError;
  int get precision => throw _privateConstructorUsedError;
  bool get trailingZeroes => throw _privateConstructorUsedError;
  bool get useNumberFormatter => throw _privateConstructorUsedError;

  /// Create a copy of AmountToStringParameters
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AmountToStringParametersCopyWith<AmountToStringParameters> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AmountToStringParametersCopyWith<$Res> {
  factory $AmountToStringParametersCopyWith(
    AmountToStringParameters value,
    $Res Function(AmountToStringParameters) then,
  ) = _$AmountToStringParametersCopyWithImpl<$Res, AmountToStringParameters>;
  @useResult
  $Res call({
    int amount,
    bool forceSign,
    int precision,
    bool trailingZeroes,
    bool useNumberFormatter,
  });
}

/// @nodoc
class _$AmountToStringParametersCopyWithImpl<
  $Res,
  $Val extends AmountToStringParameters
>
    implements $AmountToStringParametersCopyWith<$Res> {
  _$AmountToStringParametersCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AmountToStringParameters
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? amount = null,
    Object? forceSign = null,
    Object? precision = null,
    Object? trailingZeroes = null,
    Object? useNumberFormatter = null,
  }) {
    return _then(
      _value.copyWith(
            amount:
                null == amount
                    ? _value.amount
                    : amount // ignore: cast_nullable_to_non_nullable
                        as int,
            forceSign:
                null == forceSign
                    ? _value.forceSign
                    : forceSign // ignore: cast_nullable_to_non_nullable
                        as bool,
            precision:
                null == precision
                    ? _value.precision
                    : precision // ignore: cast_nullable_to_non_nullable
                        as int,
            trailingZeroes:
                null == trailingZeroes
                    ? _value.trailingZeroes
                    : trailingZeroes // ignore: cast_nullable_to_non_nullable
                        as bool,
            useNumberFormatter:
                null == useNumberFormatter
                    ? _value.useNumberFormatter
                    : useNumberFormatter // ignore: cast_nullable_to_non_nullable
                        as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AmountToStringParametersImplCopyWith<$Res>
    implements $AmountToStringParametersCopyWith<$Res> {
  factory _$$AmountToStringParametersImplCopyWith(
    _$AmountToStringParametersImpl value,
    $Res Function(_$AmountToStringParametersImpl) then,
  ) = __$$AmountToStringParametersImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int amount,
    bool forceSign,
    int precision,
    bool trailingZeroes,
    bool useNumberFormatter,
  });
}

/// @nodoc
class __$$AmountToStringParametersImplCopyWithImpl<$Res>
    extends
        _$AmountToStringParametersCopyWithImpl<
          $Res,
          _$AmountToStringParametersImpl
        >
    implements _$$AmountToStringParametersImplCopyWith<$Res> {
  __$$AmountToStringParametersImplCopyWithImpl(
    _$AmountToStringParametersImpl _value,
    $Res Function(_$AmountToStringParametersImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AmountToStringParameters
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? amount = null,
    Object? forceSign = null,
    Object? precision = null,
    Object? trailingZeroes = null,
    Object? useNumberFormatter = null,
  }) {
    return _then(
      _$AmountToStringParametersImpl(
        amount:
            null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                    as int,
        forceSign:
            null == forceSign
                ? _value.forceSign
                : forceSign // ignore: cast_nullable_to_non_nullable
                    as bool,
        precision:
            null == precision
                ? _value.precision
                : precision // ignore: cast_nullable_to_non_nullable
                    as int,
        trailingZeroes:
            null == trailingZeroes
                ? _value.trailingZeroes
                : trailingZeroes // ignore: cast_nullable_to_non_nullable
                    as bool,
        useNumberFormatter:
            null == useNumberFormatter
                ? _value.useNumberFormatter
                : useNumberFormatter // ignore: cast_nullable_to_non_nullable
                    as bool,
      ),
    );
  }
}

/// @nodoc

class _$AmountToStringParametersImpl implements _AmountToStringParameters {
  _$AmountToStringParametersImpl({
    required this.amount,
    this.forceSign = false,
    this.precision = 8,
    this.trailingZeroes = true,
    this.useNumberFormatter = false,
  });

  @override
  final int amount;
  @override
  @JsonKey()
  final bool forceSign;
  @override
  @JsonKey()
  final int precision;
  @override
  @JsonKey()
  final bool trailingZeroes;
  @override
  @JsonKey()
  final bool useNumberFormatter;

  @override
  String toString() {
    return 'AmountToStringParameters(amount: $amount, forceSign: $forceSign, precision: $precision, trailingZeroes: $trailingZeroes, useNumberFormatter: $useNumberFormatter)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AmountToStringParametersImpl &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.forceSign, forceSign) ||
                other.forceSign == forceSign) &&
            (identical(other.precision, precision) ||
                other.precision == precision) &&
            (identical(other.trailingZeroes, trailingZeroes) ||
                other.trailingZeroes == trailingZeroes) &&
            (identical(other.useNumberFormatter, useNumberFormatter) ||
                other.useNumberFormatter == useNumberFormatter));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    amount,
    forceSign,
    precision,
    trailingZeroes,
    useNumberFormatter,
  );

  /// Create a copy of AmountToStringParameters
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AmountToStringParametersImplCopyWith<_$AmountToStringParametersImpl>
  get copyWith => __$$AmountToStringParametersImplCopyWithImpl<
    _$AmountToStringParametersImpl
  >(this, _$identity);
}

abstract class _AmountToStringParameters implements AmountToStringParameters {
  factory _AmountToStringParameters({
    required final int amount,
    final bool forceSign,
    final int precision,
    final bool trailingZeroes,
    final bool useNumberFormatter,
  }) = _$AmountToStringParametersImpl;

  @override
  int get amount;
  @override
  bool get forceSign;
  @override
  int get precision;
  @override
  bool get trailingZeroes;
  @override
  bool get useNumberFormatter;

  /// Create a copy of AmountToStringParameters
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AmountToStringParametersImplCopyWith<_$AmountToStringParametersImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$AmountToStringNamedParameters {
  int get amount => throw _privateConstructorUsedError;
  String get ticker => throw _privateConstructorUsedError;
  bool get forceSign => throw _privateConstructorUsedError;
  int get precision => throw _privateConstructorUsedError;
  bool get trailingZeroes => throw _privateConstructorUsedError;
  bool get useNumberFormatter => throw _privateConstructorUsedError;

  /// Create a copy of AmountToStringNamedParameters
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AmountToStringNamedParametersCopyWith<AmountToStringNamedParameters>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AmountToStringNamedParametersCopyWith<$Res> {
  factory $AmountToStringNamedParametersCopyWith(
    AmountToStringNamedParameters value,
    $Res Function(AmountToStringNamedParameters) then,
  ) =
      _$AmountToStringNamedParametersCopyWithImpl<
        $Res,
        AmountToStringNamedParameters
      >;
  @useResult
  $Res call({
    int amount,
    String ticker,
    bool forceSign,
    int precision,
    bool trailingZeroes,
    bool useNumberFormatter,
  });
}

/// @nodoc
class _$AmountToStringNamedParametersCopyWithImpl<
  $Res,
  $Val extends AmountToStringNamedParameters
>
    implements $AmountToStringNamedParametersCopyWith<$Res> {
  _$AmountToStringNamedParametersCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AmountToStringNamedParameters
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? amount = null,
    Object? ticker = null,
    Object? forceSign = null,
    Object? precision = null,
    Object? trailingZeroes = null,
    Object? useNumberFormatter = null,
  }) {
    return _then(
      _value.copyWith(
            amount:
                null == amount
                    ? _value.amount
                    : amount // ignore: cast_nullable_to_non_nullable
                        as int,
            ticker:
                null == ticker
                    ? _value.ticker
                    : ticker // ignore: cast_nullable_to_non_nullable
                        as String,
            forceSign:
                null == forceSign
                    ? _value.forceSign
                    : forceSign // ignore: cast_nullable_to_non_nullable
                        as bool,
            precision:
                null == precision
                    ? _value.precision
                    : precision // ignore: cast_nullable_to_non_nullable
                        as int,
            trailingZeroes:
                null == trailingZeroes
                    ? _value.trailingZeroes
                    : trailingZeroes // ignore: cast_nullable_to_non_nullable
                        as bool,
            useNumberFormatter:
                null == useNumberFormatter
                    ? _value.useNumberFormatter
                    : useNumberFormatter // ignore: cast_nullable_to_non_nullable
                        as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AmountToStringNamedParametersImplCopyWith<$Res>
    implements $AmountToStringNamedParametersCopyWith<$Res> {
  factory _$$AmountToStringNamedParametersImplCopyWith(
    _$AmountToStringNamedParametersImpl value,
    $Res Function(_$AmountToStringNamedParametersImpl) then,
  ) = __$$AmountToStringNamedParametersImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int amount,
    String ticker,
    bool forceSign,
    int precision,
    bool trailingZeroes,
    bool useNumberFormatter,
  });
}

/// @nodoc
class __$$AmountToStringNamedParametersImplCopyWithImpl<$Res>
    extends
        _$AmountToStringNamedParametersCopyWithImpl<
          $Res,
          _$AmountToStringNamedParametersImpl
        >
    implements _$$AmountToStringNamedParametersImplCopyWith<$Res> {
  __$$AmountToStringNamedParametersImplCopyWithImpl(
    _$AmountToStringNamedParametersImpl _value,
    $Res Function(_$AmountToStringNamedParametersImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AmountToStringNamedParameters
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? amount = null,
    Object? ticker = null,
    Object? forceSign = null,
    Object? precision = null,
    Object? trailingZeroes = null,
    Object? useNumberFormatter = null,
  }) {
    return _then(
      _$AmountToStringNamedParametersImpl(
        amount:
            null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                    as int,
        ticker:
            null == ticker
                ? _value.ticker
                : ticker // ignore: cast_nullable_to_non_nullable
                    as String,
        forceSign:
            null == forceSign
                ? _value.forceSign
                : forceSign // ignore: cast_nullable_to_non_nullable
                    as bool,
        precision:
            null == precision
                ? _value.precision
                : precision // ignore: cast_nullable_to_non_nullable
                    as int,
        trailingZeroes:
            null == trailingZeroes
                ? _value.trailingZeroes
                : trailingZeroes // ignore: cast_nullable_to_non_nullable
                    as bool,
        useNumberFormatter:
            null == useNumberFormatter
                ? _value.useNumberFormatter
                : useNumberFormatter // ignore: cast_nullable_to_non_nullable
                    as bool,
      ),
    );
  }
}

/// @nodoc

class _$AmountToStringNamedParametersImpl
    implements _AmountToStringNamedParameters {
  _$AmountToStringNamedParametersImpl({
    required this.amount,
    required this.ticker,
    this.forceSign = false,
    this.precision = 8,
    this.trailingZeroes = true,
    this.useNumberFormatter = false,
  });

  @override
  final int amount;
  @override
  final String ticker;
  @override
  @JsonKey()
  final bool forceSign;
  @override
  @JsonKey()
  final int precision;
  @override
  @JsonKey()
  final bool trailingZeroes;
  @override
  @JsonKey()
  final bool useNumberFormatter;

  @override
  String toString() {
    return 'AmountToStringNamedParameters(amount: $amount, ticker: $ticker, forceSign: $forceSign, precision: $precision, trailingZeroes: $trailingZeroes, useNumberFormatter: $useNumberFormatter)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AmountToStringNamedParametersImpl &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.ticker, ticker) || other.ticker == ticker) &&
            (identical(other.forceSign, forceSign) ||
                other.forceSign == forceSign) &&
            (identical(other.precision, precision) ||
                other.precision == precision) &&
            (identical(other.trailingZeroes, trailingZeroes) ||
                other.trailingZeroes == trailingZeroes) &&
            (identical(other.useNumberFormatter, useNumberFormatter) ||
                other.useNumberFormatter == useNumberFormatter));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    amount,
    ticker,
    forceSign,
    precision,
    trailingZeroes,
    useNumberFormatter,
  );

  /// Create a copy of AmountToStringNamedParameters
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AmountToStringNamedParametersImplCopyWith<
    _$AmountToStringNamedParametersImpl
  >
  get copyWith => __$$AmountToStringNamedParametersImplCopyWithImpl<
    _$AmountToStringNamedParametersImpl
  >(this, _$identity);
}

abstract class _AmountToStringNamedParameters
    implements AmountToStringNamedParameters {
  factory _AmountToStringNamedParameters({
    required final int amount,
    required final String ticker,
    final bool forceSign,
    final int precision,
    final bool trailingZeroes,
    final bool useNumberFormatter,
  }) = _$AmountToStringNamedParametersImpl;

  @override
  int get amount;
  @override
  String get ticker;
  @override
  bool get forceSign;
  @override
  int get precision;
  @override
  bool get trailingZeroes;
  @override
  bool get useNumberFormatter;

  /// Create a copy of AmountToStringNamedParameters
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AmountToStringNamedParametersImplCopyWith<
    _$AmountToStringNamedParametersImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}
