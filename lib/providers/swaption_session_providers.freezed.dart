// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'swaption_session_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SwaptionSession {

 String get sessionId; String get domain;
/// Create a copy of SwaptionSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SwaptionSessionCopyWith<SwaptionSession> get copyWith => _$SwaptionSessionCopyWithImpl<SwaptionSession>(this as SwaptionSession, _$identity);

  /// Serializes this SwaptionSession to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SwaptionSession&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.domain, domain) || other.domain == domain));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId,domain);

@override
String toString() {
  return 'SwaptionSession(sessionId: $sessionId, domain: $domain)';
}


}

/// @nodoc
abstract mixin class $SwaptionSessionCopyWith<$Res>  {
  factory $SwaptionSessionCopyWith(SwaptionSession value, $Res Function(SwaptionSession) _then) = _$SwaptionSessionCopyWithImpl;
@useResult
$Res call({
 String sessionId, String domain
});




}
/// @nodoc
class _$SwaptionSessionCopyWithImpl<$Res>
    implements $SwaptionSessionCopyWith<$Res> {
  _$SwaptionSessionCopyWithImpl(this._self, this._then);

  final SwaptionSession _self;
  final $Res Function(SwaptionSession) _then;

/// Create a copy of SwaptionSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessionId = null,Object? domain = null,}) {
  return _then(_self.copyWith(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,domain: null == domain ? _self.domain : domain // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SwaptionSession].
extension SwaptionSessionPatterns on SwaptionSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SwaptionSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SwaptionSession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SwaptionSession value)  $default,){
final _that = this;
switch (_that) {
case _SwaptionSession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SwaptionSession value)?  $default,){
final _that = this;
switch (_that) {
case _SwaptionSession() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sessionId,  String domain)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SwaptionSession() when $default != null:
return $default(_that.sessionId,_that.domain);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sessionId,  String domain)  $default,) {final _that = this;
switch (_that) {
case _SwaptionSession():
return $default(_that.sessionId,_that.domain);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sessionId,  String domain)?  $default,) {final _that = this;
switch (_that) {
case _SwaptionSession() when $default != null:
return $default(_that.sessionId,_that.domain);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SwaptionSession implements SwaptionSession {
  const _SwaptionSession({required this.sessionId, required this.domain});
  factory _SwaptionSession.fromJson(Map<String, dynamic> json) => _$SwaptionSessionFromJson(json);

@override final  String sessionId;
@override final  String domain;

/// Create a copy of SwaptionSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SwaptionSessionCopyWith<_SwaptionSession> get copyWith => __$SwaptionSessionCopyWithImpl<_SwaptionSession>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SwaptionSessionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SwaptionSession&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.domain, domain) || other.domain == domain));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId,domain);

@override
String toString() {
  return 'SwaptionSession(sessionId: $sessionId, domain: $domain)';
}


}

/// @nodoc
abstract mixin class _$SwaptionSessionCopyWith<$Res> implements $SwaptionSessionCopyWith<$Res> {
  factory _$SwaptionSessionCopyWith(_SwaptionSession value, $Res Function(_SwaptionSession) _then) = __$SwaptionSessionCopyWithImpl;
@override @useResult
$Res call({
 String sessionId, String domain
});




}
/// @nodoc
class __$SwaptionSessionCopyWithImpl<$Res>
    implements _$SwaptionSessionCopyWith<$Res> {
  __$SwaptionSessionCopyWithImpl(this._self, this._then);

  final _SwaptionSession _self;
  final $Res Function(_SwaptionSession) _then;

/// Create a copy of SwaptionSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = null,Object? domain = null,}) {
  return _then(_SwaptionSession(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,domain: null == domain ? _self.domain : domain // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
