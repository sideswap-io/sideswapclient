// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'proxy_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProxySettings {

 String? get host; int? get port;
/// Create a copy of ProxySettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProxySettingsCopyWith<ProxySettings> get copyWith => _$ProxySettingsCopyWithImpl<ProxySettings>(this as ProxySettings, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProxySettings&&(identical(other.host, host) || other.host == host)&&(identical(other.port, port) || other.port == port));
}


@override
int get hashCode => Object.hash(runtimeType,host,port);

@override
String toString() {
  return 'ProxySettings(host: $host, port: $port)';
}


}

/// @nodoc
abstract mixin class $ProxySettingsCopyWith<$Res>  {
  factory $ProxySettingsCopyWith(ProxySettings value, $Res Function(ProxySettings) _then) = _$ProxySettingsCopyWithImpl;
@useResult
$Res call({
 String? host, int? port
});




}
/// @nodoc
class _$ProxySettingsCopyWithImpl<$Res>
    implements $ProxySettingsCopyWith<$Res> {
  _$ProxySettingsCopyWithImpl(this._self, this._then);

  final ProxySettings _self;
  final $Res Function(ProxySettings) _then;

/// Create a copy of ProxySettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? host = freezed,Object? port = freezed,}) {
  return _then(_self.copyWith(
host: freezed == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as String?,port: freezed == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProxySettings].
extension ProxySettingsPatterns on ProxySettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProxySettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProxySettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProxySettings value)  $default,){
final _that = this;
switch (_that) {
case _ProxySettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProxySettings value)?  $default,){
final _that = this;
switch (_that) {
case _ProxySettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? host,  int? port)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProxySettings() when $default != null:
return $default(_that.host,_that.port);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? host,  int? port)  $default,) {final _that = this;
switch (_that) {
case _ProxySettings():
return $default(_that.host,_that.port);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? host,  int? port)?  $default,) {final _that = this;
switch (_that) {
case _ProxySettings() when $default != null:
return $default(_that.host,_that.port);case _:
  return null;

}
}

}

/// @nodoc


class _ProxySettings implements ProxySettings {
   _ProxySettings({this.host, this.port});
  

@override final  String? host;
@override final  int? port;

/// Create a copy of ProxySettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProxySettingsCopyWith<_ProxySettings> get copyWith => __$ProxySettingsCopyWithImpl<_ProxySettings>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProxySettings&&(identical(other.host, host) || other.host == host)&&(identical(other.port, port) || other.port == port));
}


@override
int get hashCode => Object.hash(runtimeType,host,port);

@override
String toString() {
  return 'ProxySettings(host: $host, port: $port)';
}


}

/// @nodoc
abstract mixin class _$ProxySettingsCopyWith<$Res> implements $ProxySettingsCopyWith<$Res> {
  factory _$ProxySettingsCopyWith(_ProxySettings value, $Res Function(_ProxySettings) _then) = __$ProxySettingsCopyWithImpl;
@override @useResult
$Res call({
 String? host, int? port
});




}
/// @nodoc
class __$ProxySettingsCopyWithImpl<$Res>
    implements _$ProxySettingsCopyWith<$Res> {
  __$ProxySettingsCopyWithImpl(this._self, this._then);

  final _ProxySettings _self;
  final $Res Function(_ProxySettings) _then;

/// Create a copy of ProxySettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? host = freezed,Object? port = freezed,}) {
  return _then(_ProxySettings(
host: freezed == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as String?,port: freezed == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
