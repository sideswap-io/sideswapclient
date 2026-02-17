// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notifications_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NotificationItemState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationItemState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NotificationItemState()';
}


}

/// @nodoc
class $NotificationItemStateCopyWith<$Res>  {
$NotificationItemStateCopyWith(NotificationItemState _, $Res Function(NotificationItemState) __);
}


/// Adds pattern-matching-related methods to [NotificationItemState].
extension NotificationItemStatePatterns on NotificationItemState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( NotificationItemStateEmpty value)?  empty,TResult Function( NotificationItemStateCanceled value)?  canceled,required TResult orElse(),}){
final _that = this;
switch (_that) {
case NotificationItemStateEmpty() when empty != null:
return empty(_that);case NotificationItemStateCanceled() when canceled != null:
return canceled(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( NotificationItemStateEmpty value)  empty,required TResult Function( NotificationItemStateCanceled value)  canceled,}){
final _that = this;
switch (_that) {
case NotificationItemStateEmpty():
return empty(_that);case NotificationItemStateCanceled():
return canceled(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( NotificationItemStateEmpty value)?  empty,TResult? Function( NotificationItemStateCanceled value)?  canceled,}){
final _that = this;
switch (_that) {
case NotificationItemStateEmpty() when empty != null:
return empty(_that);case NotificationItemStateCanceled() when canceled != null:
return canceled(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  empty,TResult Function()?  canceled,required TResult orElse(),}) {final _that = this;
switch (_that) {
case NotificationItemStateEmpty() when empty != null:
return empty();case NotificationItemStateCanceled() when canceled != null:
return canceled();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  empty,required TResult Function()  canceled,}) {final _that = this;
switch (_that) {
case NotificationItemStateEmpty():
return empty();case NotificationItemStateCanceled():
return canceled();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  empty,TResult? Function()?  canceled,}) {final _that = this;
switch (_that) {
case NotificationItemStateEmpty() when empty != null:
return empty();case NotificationItemStateCanceled() when canceled != null:
return canceled();case _:
  return null;

}
}

}

/// @nodoc


class NotificationItemStateEmpty implements NotificationItemState {
  const NotificationItemStateEmpty();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationItemStateEmpty);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NotificationItemState.empty()';
}


}




/// @nodoc


class NotificationItemStateCanceled implements NotificationItemState {
  const NotificationItemStateCanceled();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationItemStateCanceled);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NotificationItemState.canceled()';
}


}




/// @nodoc
mixin _$NotificationType {

 String get reqId; String get origin; NotificationItemState get notificationItemState; DateTime get createdAt; Option<int> get ttlMilliseconds;
/// Create a copy of NotificationType
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationTypeCopyWith<NotificationType> get copyWith => _$NotificationTypeCopyWithImpl<NotificationType>(this as NotificationType, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationType&&(identical(other.reqId, reqId) || other.reqId == reqId)&&(identical(other.origin, origin) || other.origin == origin)&&(identical(other.notificationItemState, notificationItemState) || other.notificationItemState == notificationItemState)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.ttlMilliseconds, ttlMilliseconds) || other.ttlMilliseconds == ttlMilliseconds));
}


@override
int get hashCode => Object.hash(runtimeType,reqId,origin,notificationItemState,createdAt,ttlMilliseconds);

@override
String toString() {
  return 'NotificationType(reqId: $reqId, origin: $origin, notificationItemState: $notificationItemState, createdAt: $createdAt, ttlMilliseconds: $ttlMilliseconds)';
}


}

/// @nodoc
abstract mixin class $NotificationTypeCopyWith<$Res>  {
  factory $NotificationTypeCopyWith(NotificationType value, $Res Function(NotificationType) _then) = _$NotificationTypeCopyWithImpl;
@useResult
$Res call({
 String reqId, String origin, NotificationItemState notificationItemState, DateTime createdAt, Option<int> ttlMilliseconds
});


$NotificationItemStateCopyWith<$Res> get notificationItemState;

}
/// @nodoc
class _$NotificationTypeCopyWithImpl<$Res>
    implements $NotificationTypeCopyWith<$Res> {
  _$NotificationTypeCopyWithImpl(this._self, this._then);

  final NotificationType _self;
  final $Res Function(NotificationType) _then;

/// Create a copy of NotificationType
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? reqId = null,Object? origin = null,Object? notificationItemState = null,Object? createdAt = null,Object? ttlMilliseconds = null,}) {
  return _then(_self.copyWith(
reqId: null == reqId ? _self.reqId : reqId // ignore: cast_nullable_to_non_nullable
as String,origin: null == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as String,notificationItemState: null == notificationItemState ? _self.notificationItemState : notificationItemState // ignore: cast_nullable_to_non_nullable
as NotificationItemState,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,ttlMilliseconds: null == ttlMilliseconds ? _self.ttlMilliseconds : ttlMilliseconds // ignore: cast_nullable_to_non_nullable
as Option<int>,
  ));
}
/// Create a copy of NotificationType
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationItemStateCopyWith<$Res> get notificationItemState {
  
  return $NotificationItemStateCopyWith<$Res>(_self.notificationItemState, (value) {
    return _then(_self.copyWith(notificationItemState: value));
  });
}
}


/// Adds pattern-matching-related methods to [NotificationType].
extension NotificationTypePatterns on NotificationType {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( NotificationTypeConnect value)?  connect,TResult Function( NotificationTypeSignRequest value)?  signRequest,required TResult orElse(),}){
final _that = this;
switch (_that) {
case NotificationTypeConnect() when connect != null:
return connect(_that);case NotificationTypeSignRequest() when signRequest != null:
return signRequest(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( NotificationTypeConnect value)  connect,required TResult Function( NotificationTypeSignRequest value)  signRequest,}){
final _that = this;
switch (_that) {
case NotificationTypeConnect():
return connect(_that);case NotificationTypeSignRequest():
return signRequest(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( NotificationTypeConnect value)?  connect,TResult? Function( NotificationTypeSignRequest value)?  signRequest,}){
final _that = this;
switch (_that) {
case NotificationTypeConnect() when connect != null:
return connect(_that);case NotificationTypeSignRequest() when signRequest != null:
return signRequest(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String reqId,  String origin,  NotificationItemState notificationItemState,  DateTime createdAt,  Option<int> ttlMilliseconds)?  connect,TResult Function( From_SignerRequest_Sign sign,  String reqId,  String origin,  NotificationItemState notificationItemState,  DateTime createdAt,  Option<int> ttlMilliseconds)?  signRequest,required TResult orElse(),}) {final _that = this;
switch (_that) {
case NotificationTypeConnect() when connect != null:
return connect(_that.reqId,_that.origin,_that.notificationItemState,_that.createdAt,_that.ttlMilliseconds);case NotificationTypeSignRequest() when signRequest != null:
return signRequest(_that.sign,_that.reqId,_that.origin,_that.notificationItemState,_that.createdAt,_that.ttlMilliseconds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String reqId,  String origin,  NotificationItemState notificationItemState,  DateTime createdAt,  Option<int> ttlMilliseconds)  connect,required TResult Function( From_SignerRequest_Sign sign,  String reqId,  String origin,  NotificationItemState notificationItemState,  DateTime createdAt,  Option<int> ttlMilliseconds)  signRequest,}) {final _that = this;
switch (_that) {
case NotificationTypeConnect():
return connect(_that.reqId,_that.origin,_that.notificationItemState,_that.createdAt,_that.ttlMilliseconds);case NotificationTypeSignRequest():
return signRequest(_that.sign,_that.reqId,_that.origin,_that.notificationItemState,_that.createdAt,_that.ttlMilliseconds);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String reqId,  String origin,  NotificationItemState notificationItemState,  DateTime createdAt,  Option<int> ttlMilliseconds)?  connect,TResult? Function( From_SignerRequest_Sign sign,  String reqId,  String origin,  NotificationItemState notificationItemState,  DateTime createdAt,  Option<int> ttlMilliseconds)?  signRequest,}) {final _that = this;
switch (_that) {
case NotificationTypeConnect() when connect != null:
return connect(_that.reqId,_that.origin,_that.notificationItemState,_that.createdAt,_that.ttlMilliseconds);case NotificationTypeSignRequest() when signRequest != null:
return signRequest(_that.sign,_that.reqId,_that.origin,_that.notificationItemState,_that.createdAt,_that.ttlMilliseconds);case _:
  return null;

}
}

}

/// @nodoc


class NotificationTypeConnect implements NotificationType {
  const NotificationTypeConnect(this.reqId, this.origin, this.notificationItemState, this.createdAt, this.ttlMilliseconds);
  

@override final  String reqId;
@override final  String origin;
@override final  NotificationItemState notificationItemState;
@override final  DateTime createdAt;
@override final  Option<int> ttlMilliseconds;

/// Create a copy of NotificationType
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationTypeConnectCopyWith<NotificationTypeConnect> get copyWith => _$NotificationTypeConnectCopyWithImpl<NotificationTypeConnect>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationTypeConnect&&(identical(other.reqId, reqId) || other.reqId == reqId)&&(identical(other.origin, origin) || other.origin == origin)&&(identical(other.notificationItemState, notificationItemState) || other.notificationItemState == notificationItemState)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.ttlMilliseconds, ttlMilliseconds) || other.ttlMilliseconds == ttlMilliseconds));
}


@override
int get hashCode => Object.hash(runtimeType,reqId,origin,notificationItemState,createdAt,ttlMilliseconds);

@override
String toString() {
  return 'NotificationType.connect(reqId: $reqId, origin: $origin, notificationItemState: $notificationItemState, createdAt: $createdAt, ttlMilliseconds: $ttlMilliseconds)';
}


}

/// @nodoc
abstract mixin class $NotificationTypeConnectCopyWith<$Res> implements $NotificationTypeCopyWith<$Res> {
  factory $NotificationTypeConnectCopyWith(NotificationTypeConnect value, $Res Function(NotificationTypeConnect) _then) = _$NotificationTypeConnectCopyWithImpl;
@override @useResult
$Res call({
 String reqId, String origin, NotificationItemState notificationItemState, DateTime createdAt, Option<int> ttlMilliseconds
});


@override $NotificationItemStateCopyWith<$Res> get notificationItemState;

}
/// @nodoc
class _$NotificationTypeConnectCopyWithImpl<$Res>
    implements $NotificationTypeConnectCopyWith<$Res> {
  _$NotificationTypeConnectCopyWithImpl(this._self, this._then);

  final NotificationTypeConnect _self;
  final $Res Function(NotificationTypeConnect) _then;

/// Create a copy of NotificationType
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? reqId = null,Object? origin = null,Object? notificationItemState = null,Object? createdAt = null,Object? ttlMilliseconds = null,}) {
  return _then(NotificationTypeConnect(
null == reqId ? _self.reqId : reqId // ignore: cast_nullable_to_non_nullable
as String,null == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as String,null == notificationItemState ? _self.notificationItemState : notificationItemState // ignore: cast_nullable_to_non_nullable
as NotificationItemState,null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,null == ttlMilliseconds ? _self.ttlMilliseconds : ttlMilliseconds // ignore: cast_nullable_to_non_nullable
as Option<int>,
  ));
}

/// Create a copy of NotificationType
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationItemStateCopyWith<$Res> get notificationItemState {
  
  return $NotificationItemStateCopyWith<$Res>(_self.notificationItemState, (value) {
    return _then(_self.copyWith(notificationItemState: value));
  });
}
}

/// @nodoc


class NotificationTypeSignRequest implements NotificationType {
  const NotificationTypeSignRequest(this.sign, this.reqId, this.origin, this.notificationItemState, this.createdAt, this.ttlMilliseconds);
  

 final  From_SignerRequest_Sign sign;
@override final  String reqId;
@override final  String origin;
@override final  NotificationItemState notificationItemState;
@override final  DateTime createdAt;
@override final  Option<int> ttlMilliseconds;

/// Create a copy of NotificationType
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationTypeSignRequestCopyWith<NotificationTypeSignRequest> get copyWith => _$NotificationTypeSignRequestCopyWithImpl<NotificationTypeSignRequest>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationTypeSignRequest&&(identical(other.sign, sign) || other.sign == sign)&&(identical(other.reqId, reqId) || other.reqId == reqId)&&(identical(other.origin, origin) || other.origin == origin)&&(identical(other.notificationItemState, notificationItemState) || other.notificationItemState == notificationItemState)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.ttlMilliseconds, ttlMilliseconds) || other.ttlMilliseconds == ttlMilliseconds));
}


@override
int get hashCode => Object.hash(runtimeType,sign,reqId,origin,notificationItemState,createdAt,ttlMilliseconds);

@override
String toString() {
  return 'NotificationType.signRequest(sign: $sign, reqId: $reqId, origin: $origin, notificationItemState: $notificationItemState, createdAt: $createdAt, ttlMilliseconds: $ttlMilliseconds)';
}


}

/// @nodoc
abstract mixin class $NotificationTypeSignRequestCopyWith<$Res> implements $NotificationTypeCopyWith<$Res> {
  factory $NotificationTypeSignRequestCopyWith(NotificationTypeSignRequest value, $Res Function(NotificationTypeSignRequest) _then) = _$NotificationTypeSignRequestCopyWithImpl;
@override @useResult
$Res call({
 From_SignerRequest_Sign sign, String reqId, String origin, NotificationItemState notificationItemState, DateTime createdAt, Option<int> ttlMilliseconds
});


@override $NotificationItemStateCopyWith<$Res> get notificationItemState;

}
/// @nodoc
class _$NotificationTypeSignRequestCopyWithImpl<$Res>
    implements $NotificationTypeSignRequestCopyWith<$Res> {
  _$NotificationTypeSignRequestCopyWithImpl(this._self, this._then);

  final NotificationTypeSignRequest _self;
  final $Res Function(NotificationTypeSignRequest) _then;

/// Create a copy of NotificationType
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sign = null,Object? reqId = null,Object? origin = null,Object? notificationItemState = null,Object? createdAt = null,Object? ttlMilliseconds = null,}) {
  return _then(NotificationTypeSignRequest(
null == sign ? _self.sign : sign // ignore: cast_nullable_to_non_nullable
as From_SignerRequest_Sign,null == reqId ? _self.reqId : reqId // ignore: cast_nullable_to_non_nullable
as String,null == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as String,null == notificationItemState ? _self.notificationItemState : notificationItemState // ignore: cast_nullable_to_non_nullable
as NotificationItemState,null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,null == ttlMilliseconds ? _self.ttlMilliseconds : ttlMilliseconds // ignore: cast_nullable_to_non_nullable
as Option<int>,
  ));
}

/// Create a copy of NotificationType
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationItemStateCopyWith<$Res> get notificationItemState {
  
  return $NotificationItemStateCopyWith<$Res>(_self.notificationItemState, (value) {
    return _then(_self.copyWith(notificationItemState: value));
  });
}
}

/// @nodoc
mixin _$NotificationData {

 int get id; NotificationType get type;
/// Create a copy of NotificationData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationDataCopyWith<NotificationData> get copyWith => _$NotificationDataCopyWithImpl<NotificationData>(this as NotificationData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationData&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type));
}


@override
int get hashCode => Object.hash(runtimeType,id,type);

@override
String toString() {
  return 'NotificationData(id: $id, type: $type)';
}


}

/// @nodoc
abstract mixin class $NotificationDataCopyWith<$Res>  {
  factory $NotificationDataCopyWith(NotificationData value, $Res Function(NotificationData) _then) = _$NotificationDataCopyWithImpl;
@useResult
$Res call({
 int id, NotificationType type
});


$NotificationTypeCopyWith<$Res> get type;

}
/// @nodoc
class _$NotificationDataCopyWithImpl<$Res>
    implements $NotificationDataCopyWith<$Res> {
  _$NotificationDataCopyWithImpl(this._self, this._then);

  final NotificationData _self;
  final $Res Function(NotificationData) _then;

/// Create a copy of NotificationData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as NotificationType,
  ));
}
/// Create a copy of NotificationData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationTypeCopyWith<$Res> get type {
  
  return $NotificationTypeCopyWith<$Res>(_self.type, (value) {
    return _then(_self.copyWith(type: value));
  });
}
}


/// Adds pattern-matching-related methods to [NotificationData].
extension NotificationDataPatterns on NotificationData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationData value)  $default,){
final _that = this;
switch (_that) {
case _NotificationData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationData value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  NotificationType type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationData() when $default != null:
return $default(_that.id,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  NotificationType type)  $default,) {final _that = this;
switch (_that) {
case _NotificationData():
return $default(_that.id,_that.type);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  NotificationType type)?  $default,) {final _that = this;
switch (_that) {
case _NotificationData() when $default != null:
return $default(_that.id,_that.type);case _:
  return null;

}
}

}

/// @nodoc


class _NotificationData implements NotificationData {
  const _NotificationData(this.id, this.type);
  

@override final  int id;
@override final  NotificationType type;

/// Create a copy of NotificationData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationDataCopyWith<_NotificationData> get copyWith => __$NotificationDataCopyWithImpl<_NotificationData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationData&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type));
}


@override
int get hashCode => Object.hash(runtimeType,id,type);

@override
String toString() {
  return 'NotificationData(id: $id, type: $type)';
}


}

/// @nodoc
abstract mixin class _$NotificationDataCopyWith<$Res> implements $NotificationDataCopyWith<$Res> {
  factory _$NotificationDataCopyWith(_NotificationData value, $Res Function(_NotificationData) _then) = __$NotificationDataCopyWithImpl;
@override @useResult
$Res call({
 int id, NotificationType type
});


@override $NotificationTypeCopyWith<$Res> get type;

}
/// @nodoc
class __$NotificationDataCopyWithImpl<$Res>
    implements _$NotificationDataCopyWith<$Res> {
  __$NotificationDataCopyWithImpl(this._self, this._then);

  final _NotificationData _self;
  final $Res Function(_NotificationData) _then;

/// Create a copy of NotificationData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,}) {
  return _then(_NotificationData(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as NotificationType,
  ));
}

/// Create a copy of NotificationData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationTypeCopyWith<$Res> get type {
  
  return $NotificationTypeCopyWith<$Res>(_self.type, (value) {
    return _then(_self.copyWith(type: value));
  });
}
}

// dart format on
