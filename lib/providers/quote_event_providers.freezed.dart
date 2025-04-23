// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quote_event_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QuoteError {

 String get error; int get orderId;
/// Create a copy of QuoteError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuoteErrorCopyWith<QuoteError> get copyWith => _$QuoteErrorCopyWithImpl<QuoteError>(this as QuoteError, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuoteError&&(identical(other.error, error) || other.error == error)&&(identical(other.orderId, orderId) || other.orderId == orderId));
}


@override
int get hashCode => Object.hash(runtimeType,error,orderId);

@override
String toString() {
  return 'QuoteError(error: $error, orderId: $orderId)';
}


}

/// @nodoc
abstract mixin class $QuoteErrorCopyWith<$Res>  {
  factory $QuoteErrorCopyWith(QuoteError value, $Res Function(QuoteError) _then) = _$QuoteErrorCopyWithImpl;
@useResult
$Res call({
 String error, int orderId
});




}
/// @nodoc
class _$QuoteErrorCopyWithImpl<$Res>
    implements $QuoteErrorCopyWith<$Res> {
  _$QuoteErrorCopyWithImpl(this._self, this._then);

  final QuoteError _self;
  final $Res Function(QuoteError) _then;

/// Create a copy of QuoteError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? error = null,Object? orderId = null,}) {
  return _then(_self.copyWith(
error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// @nodoc


class _QuoteError implements QuoteError {
  const _QuoteError({this.error = '', this.orderId = 0});
  

@override@JsonKey() final  String error;
@override@JsonKey() final  int orderId;

/// Create a copy of QuoteError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuoteErrorCopyWith<_QuoteError> get copyWith => __$QuoteErrorCopyWithImpl<_QuoteError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuoteError&&(identical(other.error, error) || other.error == error)&&(identical(other.orderId, orderId) || other.orderId == orderId));
}


@override
int get hashCode => Object.hash(runtimeType,error,orderId);

@override
String toString() {
  return 'QuoteError(error: $error, orderId: $orderId)';
}


}

/// @nodoc
abstract mixin class _$QuoteErrorCopyWith<$Res> implements $QuoteErrorCopyWith<$Res> {
  factory _$QuoteErrorCopyWith(_QuoteError value, $Res Function(_QuoteError) _then) = __$QuoteErrorCopyWithImpl;
@override @useResult
$Res call({
 String error, int orderId
});




}
/// @nodoc
class __$QuoteErrorCopyWithImpl<$Res>
    implements _$QuoteErrorCopyWith<$Res> {
  __$QuoteErrorCopyWithImpl(this._self, this._then);

  final _QuoteError _self;
  final $Res Function(_QuoteError) _then;

/// Create a copy of QuoteError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? error = null,Object? orderId = null,}) {
  return _then(_QuoteError(
error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
