// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'currency_rates_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ConversionRate {
  String get name => throw _privateConstructorUsedError;
  Decimal get rate => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ConversionRateCopyWith<ConversionRate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConversionRateCopyWith<$Res> {
  factory $ConversionRateCopyWith(
          ConversionRate value, $Res Function(ConversionRate) then) =
      _$ConversionRateCopyWithImpl<$Res, ConversionRate>;
  @useResult
  $Res call({String name, Decimal rate});
}

/// @nodoc
class _$ConversionRateCopyWithImpl<$Res, $Val extends ConversionRate>
    implements $ConversionRateCopyWith<$Res> {
  _$ConversionRateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? rate = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      rate: null == rate
          ? _value.rate
          : rate // ignore: cast_nullable_to_non_nullable
              as Decimal,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ConversionRateImplCopyWith<$Res>
    implements $ConversionRateCopyWith<$Res> {
  factory _$$ConversionRateImplCopyWith(_$ConversionRateImpl value,
          $Res Function(_$ConversionRateImpl) then) =
      __$$ConversionRateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, Decimal rate});
}

/// @nodoc
class __$$ConversionRateImplCopyWithImpl<$Res>
    extends _$ConversionRateCopyWithImpl<$Res, _$ConversionRateImpl>
    implements _$$ConversionRateImplCopyWith<$Res> {
  __$$ConversionRateImplCopyWithImpl(
      _$ConversionRateImpl _value, $Res Function(_$ConversionRateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? rate = null,
  }) {
    return _then(_$ConversionRateImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      rate: null == rate
          ? _value.rate
          : rate // ignore: cast_nullable_to_non_nullable
              as Decimal,
    ));
  }
}

/// @nodoc

class _$ConversionRateImpl implements _ConversionRate {
  const _$ConversionRateImpl({required this.name, required this.rate});

  @override
  final String name;
  @override
  final Decimal rate;

  @override
  String toString() {
    return 'ConversionRate(name: $name, rate: $rate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConversionRateImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.rate, rate) || other.rate == rate));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name, rate);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ConversionRateImplCopyWith<_$ConversionRateImpl> get copyWith =>
      __$$ConversionRateImplCopyWithImpl<_$ConversionRateImpl>(
          this, _$identity);
}

abstract class _ConversionRate implements ConversionRate {
  const factory _ConversionRate(
      {required final String name,
      required final Decimal rate}) = _$ConversionRateImpl;

  @override
  String get name;
  @override
  Decimal get rate;
  @override
  @JsonKey(ignore: true)
  _$$ConversionRateImplCopyWith<_$ConversionRateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ConversionRates {
  List<ConversionRate> get usdConversionRates =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ConversionRatesCopyWith<ConversionRates> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConversionRatesCopyWith<$Res> {
  factory $ConversionRatesCopyWith(
          ConversionRates value, $Res Function(ConversionRates) then) =
      _$ConversionRatesCopyWithImpl<$Res, ConversionRates>;
  @useResult
  $Res call({List<ConversionRate> usdConversionRates});
}

/// @nodoc
class _$ConversionRatesCopyWithImpl<$Res, $Val extends ConversionRates>
    implements $ConversionRatesCopyWith<$Res> {
  _$ConversionRatesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? usdConversionRates = null,
  }) {
    return _then(_value.copyWith(
      usdConversionRates: null == usdConversionRates
          ? _value.usdConversionRates
          : usdConversionRates // ignore: cast_nullable_to_non_nullable
              as List<ConversionRate>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UsdConversionRatesImplCopyWith<$Res>
    implements $ConversionRatesCopyWith<$Res> {
  factory _$$UsdConversionRatesImplCopyWith(_$UsdConversionRatesImpl value,
          $Res Function(_$UsdConversionRatesImpl) then) =
      __$$UsdConversionRatesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<ConversionRate> usdConversionRates});
}

/// @nodoc
class __$$UsdConversionRatesImplCopyWithImpl<$Res>
    extends _$ConversionRatesCopyWithImpl<$Res, _$UsdConversionRatesImpl>
    implements _$$UsdConversionRatesImplCopyWith<$Res> {
  __$$UsdConversionRatesImplCopyWithImpl(_$UsdConversionRatesImpl _value,
      $Res Function(_$UsdConversionRatesImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? usdConversionRates = null,
  }) {
    return _then(_$UsdConversionRatesImpl(
      usdConversionRates: null == usdConversionRates
          ? _value._usdConversionRates
          : usdConversionRates // ignore: cast_nullable_to_non_nullable
              as List<ConversionRate>,
    ));
  }
}

/// @nodoc

class _$UsdConversionRatesImpl implements _UsdConversionRates {
  const _$UsdConversionRatesImpl(
      {required final List<ConversionRate> usdConversionRates})
      : _usdConversionRates = usdConversionRates;

  final List<ConversionRate> _usdConversionRates;
  @override
  List<ConversionRate> get usdConversionRates {
    if (_usdConversionRates is EqualUnmodifiableListView)
      return _usdConversionRates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_usdConversionRates);
  }

  @override
  String toString() {
    return 'ConversionRates(usdConversionRates: $usdConversionRates)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UsdConversionRatesImpl &&
            const DeepCollectionEquality()
                .equals(other._usdConversionRates, _usdConversionRates));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_usdConversionRates));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UsdConversionRatesImplCopyWith<_$UsdConversionRatesImpl> get copyWith =>
      __$$UsdConversionRatesImplCopyWithImpl<_$UsdConversionRatesImpl>(
          this, _$identity);
}

abstract class _UsdConversionRates implements ConversionRates {
  const factory _UsdConversionRates(
          {required final List<ConversionRate> usdConversionRates}) =
      _$UsdConversionRatesImpl;

  @override
  List<ConversionRate> get usdConversionRates;
  @override
  @JsonKey(ignore: true)
  _$$UsdConversionRatesImplCopyWith<_$UsdConversionRatesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
