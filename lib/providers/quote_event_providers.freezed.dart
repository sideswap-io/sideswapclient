// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quote_event_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QuoteError implements DiagnosticableTreeMixin {

 String get error; int get orderId;
/// Create a copy of QuoteError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuoteErrorCopyWith<QuoteError> get copyWith => _$QuoteErrorCopyWithImpl<QuoteError>(this as QuoteError, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'QuoteError'))
    ..add(DiagnosticsProperty('error', error))..add(DiagnosticsProperty('orderId', orderId));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuoteError&&(identical(other.error, error) || other.error == error)&&(identical(other.orderId, orderId) || other.orderId == orderId));
}


@override
int get hashCode => Object.hash(runtimeType,error,orderId);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
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


/// Adds pattern-matching-related methods to [QuoteError].
extension QuoteErrorPatterns on QuoteError {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuoteError value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuoteError() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuoteError value)  $default,){
final _that = this;
switch (_that) {
case _QuoteError():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuoteError value)?  $default,){
final _that = this;
switch (_that) {
case _QuoteError() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String error,  int orderId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuoteError() when $default != null:
return $default(_that.error,_that.orderId);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String error,  int orderId)  $default,) {final _that = this;
switch (_that) {
case _QuoteError():
return $default(_that.error,_that.orderId);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String error,  int orderId)?  $default,) {final _that = this;
switch (_that) {
case _QuoteError() when $default != null:
return $default(_that.error,_that.orderId);case _:
  return null;

}
}

}

/// @nodoc


class _QuoteError with DiagnosticableTreeMixin implements QuoteError {
  const _QuoteError({this.error = '', this.orderId = 0});
  

@override@JsonKey() final  String error;
@override@JsonKey() final  int orderId;

/// Create a copy of QuoteError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuoteErrorCopyWith<_QuoteError> get copyWith => __$QuoteErrorCopyWithImpl<_QuoteError>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'QuoteError'))
    ..add(DiagnosticsProperty('error', error))..add(DiagnosticsProperty('orderId', orderId));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuoteError&&(identical(other.error, error) || other.error == error)&&(identical(other.orderId, orderId) || other.orderId == orderId));
}


@override
int get hashCode => Object.hash(runtimeType,error,orderId);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
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

/// @nodoc
mixin _$OrderTtlState implements DiagnosticableTreeMixin {




@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'OrderTtlState'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderTtlState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'OrderTtlState()';
}


}

/// @nodoc
class $OrderTtlStateCopyWith<$Res>  {
$OrderTtlStateCopyWith(OrderTtlState _, $Res Function(OrderTtlState) __);
}


/// Adds pattern-matching-related methods to [OrderTtlState].
extension OrderTtlStatePatterns on OrderTtlState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( OrderTtlStateEmpty value)?  empty,TResult Function( OrderTtlStateData value)?  data,required TResult orElse(),}){
final _that = this;
switch (_that) {
case OrderTtlStateEmpty() when empty != null:
return empty(_that);case OrderTtlStateData() when data != null:
return data(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( OrderTtlStateEmpty value)  empty,required TResult Function( OrderTtlStateData value)  data,}){
final _that = this;
switch (_that) {
case OrderTtlStateEmpty():
return empty(_that);case OrderTtlStateData():
return data(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( OrderTtlStateEmpty value)?  empty,TResult? Function( OrderTtlStateData value)?  data,}){
final _that = this;
switch (_that) {
case OrderTtlStateEmpty() when empty != null:
return empty(_that);case OrderTtlStateData() when data != null:
return data(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  empty,TResult Function( int seconds,  DateTime timestamp)?  data,required TResult orElse(),}) {final _that = this;
switch (_that) {
case OrderTtlStateEmpty() when empty != null:
return empty();case OrderTtlStateData() when data != null:
return data(_that.seconds,_that.timestamp);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  empty,required TResult Function( int seconds,  DateTime timestamp)  data,}) {final _that = this;
switch (_that) {
case OrderTtlStateEmpty():
return empty();case OrderTtlStateData():
return data(_that.seconds,_that.timestamp);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  empty,TResult? Function( int seconds,  DateTime timestamp)?  data,}) {final _that = this;
switch (_that) {
case OrderTtlStateEmpty() when empty != null:
return empty();case OrderTtlStateData() when data != null:
return data(_that.seconds,_that.timestamp);case _:
  return null;

}
}

}

/// @nodoc


class OrderTtlStateEmpty with DiagnosticableTreeMixin implements OrderTtlState {
  const OrderTtlStateEmpty();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'OrderTtlState.empty'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderTtlStateEmpty);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'OrderTtlState.empty()';
}


}




/// @nodoc


class OrderTtlStateData with DiagnosticableTreeMixin implements OrderTtlState {
  const OrderTtlStateData({required this.seconds, required this.timestamp});
  

 final  int seconds;
 final  DateTime timestamp;

/// Create a copy of OrderTtlState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderTtlStateDataCopyWith<OrderTtlStateData> get copyWith => _$OrderTtlStateDataCopyWithImpl<OrderTtlStateData>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'OrderTtlState.data'))
    ..add(DiagnosticsProperty('seconds', seconds))..add(DiagnosticsProperty('timestamp', timestamp));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderTtlStateData&&(identical(other.seconds, seconds) || other.seconds == seconds)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}


@override
int get hashCode => Object.hash(runtimeType,seconds,timestamp);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'OrderTtlState.data(seconds: $seconds, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $OrderTtlStateDataCopyWith<$Res> implements $OrderTtlStateCopyWith<$Res> {
  factory $OrderTtlStateDataCopyWith(OrderTtlStateData value, $Res Function(OrderTtlStateData) _then) = _$OrderTtlStateDataCopyWithImpl;
@useResult
$Res call({
 int seconds, DateTime timestamp
});




}
/// @nodoc
class _$OrderTtlStateDataCopyWithImpl<$Res>
    implements $OrderTtlStateDataCopyWith<$Res> {
  _$OrderTtlStateDataCopyWithImpl(this._self, this._then);

  final OrderTtlStateData _self;
  final $Res Function(OrderTtlStateData) _then;

/// Create a copy of OrderTtlState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? seconds = null,Object? timestamp = null,}) {
  return _then(OrderTtlStateData(
seconds: null == seconds ? _self.seconds : seconds // ignore: cast_nullable_to_non_nullable
as int,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
