// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CreateTxState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateTxState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CreateTxState()';
}


}

/// @nodoc
class $CreateTxStateCopyWith<$Res>  {
$CreateTxStateCopyWith(CreateTxState _, $Res Function(CreateTxState) __);
}


/// Adds pattern-matching-related methods to [CreateTxState].
extension CreateTxStatePatterns on CreateTxState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( CreateTxStateEmpty value)?  empty,TResult Function( CreateTxStateCreating value)?  creating,TResult Function( CreateTxStateCreated value)?  created,TResult Function( CreateTxStateError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case CreateTxStateEmpty() when empty != null:
return empty(_that);case CreateTxStateCreating() when creating != null:
return creating(_that);case CreateTxStateCreated() when created != null:
return created(_that);case CreateTxStateError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( CreateTxStateEmpty value)  empty,required TResult Function( CreateTxStateCreating value)  creating,required TResult Function( CreateTxStateCreated value)  created,required TResult Function( CreateTxStateError value)  error,}){
final _that = this;
switch (_that) {
case CreateTxStateEmpty():
return empty(_that);case CreateTxStateCreating():
return creating(_that);case CreateTxStateCreated():
return created(_that);case CreateTxStateError():
return error(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( CreateTxStateEmpty value)?  empty,TResult? Function( CreateTxStateCreating value)?  creating,TResult? Function( CreateTxStateCreated value)?  created,TResult? Function( CreateTxStateError value)?  error,}){
final _that = this;
switch (_that) {
case CreateTxStateEmpty() when empty != null:
return empty(_that);case CreateTxStateCreating() when creating != null:
return creating(_that);case CreateTxStateCreated() when created != null:
return created(_that);case CreateTxStateError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  empty,TResult Function()?  creating,TResult Function( CreatedTx createdTx)?  created,TResult Function( String? errorMsg)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case CreateTxStateEmpty() when empty != null:
return empty();case CreateTxStateCreating() when creating != null:
return creating();case CreateTxStateCreated() when created != null:
return created(_that.createdTx);case CreateTxStateError() when error != null:
return error(_that.errorMsg);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  empty,required TResult Function()  creating,required TResult Function( CreatedTx createdTx)  created,required TResult Function( String? errorMsg)  error,}) {final _that = this;
switch (_that) {
case CreateTxStateEmpty():
return empty();case CreateTxStateCreating():
return creating();case CreateTxStateCreated():
return created(_that.createdTx);case CreateTxStateError():
return error(_that.errorMsg);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  empty,TResult? Function()?  creating,TResult? Function( CreatedTx createdTx)?  created,TResult? Function( String? errorMsg)?  error,}) {final _that = this;
switch (_that) {
case CreateTxStateEmpty() when empty != null:
return empty();case CreateTxStateCreating() when creating != null:
return creating();case CreateTxStateCreated() when created != null:
return created(_that.createdTx);case CreateTxStateError() when error != null:
return error(_that.errorMsg);case _:
  return null;

}
}

}

/// @nodoc


class CreateTxStateEmpty implements CreateTxState {
  const CreateTxStateEmpty();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateTxStateEmpty);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CreateTxState.empty()';
}


}




/// @nodoc


class CreateTxStateCreating implements CreateTxState {
  const CreateTxStateCreating();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateTxStateCreating);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CreateTxState.creating()';
}


}




/// @nodoc


class CreateTxStateCreated implements CreateTxState {
  const CreateTxStateCreated(this.createdTx);
  

 final  CreatedTx createdTx;

/// Create a copy of CreateTxState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateTxStateCreatedCopyWith<CreateTxStateCreated> get copyWith => _$CreateTxStateCreatedCopyWithImpl<CreateTxStateCreated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateTxStateCreated&&(identical(other.createdTx, createdTx) || other.createdTx == createdTx));
}


@override
int get hashCode => Object.hash(runtimeType,createdTx);

@override
String toString() {
  return 'CreateTxState.created(createdTx: $createdTx)';
}


}

/// @nodoc
abstract mixin class $CreateTxStateCreatedCopyWith<$Res> implements $CreateTxStateCopyWith<$Res> {
  factory $CreateTxStateCreatedCopyWith(CreateTxStateCreated value, $Res Function(CreateTxStateCreated) _then) = _$CreateTxStateCreatedCopyWithImpl;
@useResult
$Res call({
 CreatedTx createdTx
});




}
/// @nodoc
class _$CreateTxStateCreatedCopyWithImpl<$Res>
    implements $CreateTxStateCreatedCopyWith<$Res> {
  _$CreateTxStateCreatedCopyWithImpl(this._self, this._then);

  final CreateTxStateCreated _self;
  final $Res Function(CreateTxStateCreated) _then;

/// Create a copy of CreateTxState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? createdTx = null,}) {
  return _then(CreateTxStateCreated(
null == createdTx ? _self.createdTx : createdTx // ignore: cast_nullable_to_non_nullable
as CreatedTx,
  ));
}


}

/// @nodoc


class CreateTxStateError implements CreateTxState {
  const CreateTxStateError({this.errorMsg});
  

 final  String? errorMsg;

/// Create a copy of CreateTxState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateTxStateErrorCopyWith<CreateTxStateError> get copyWith => _$CreateTxStateErrorCopyWithImpl<CreateTxStateError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateTxStateError&&(identical(other.errorMsg, errorMsg) || other.errorMsg == errorMsg));
}


@override
int get hashCode => Object.hash(runtimeType,errorMsg);

@override
String toString() {
  return 'CreateTxState.error(errorMsg: $errorMsg)';
}


}

/// @nodoc
abstract mixin class $CreateTxStateErrorCopyWith<$Res> implements $CreateTxStateCopyWith<$Res> {
  factory $CreateTxStateErrorCopyWith(CreateTxStateError value, $Res Function(CreateTxStateError) _then) = _$CreateTxStateErrorCopyWithImpl;
@useResult
$Res call({
 String? errorMsg
});




}
/// @nodoc
class _$CreateTxStateErrorCopyWithImpl<$Res>
    implements $CreateTxStateErrorCopyWith<$Res> {
  _$CreateTxStateErrorCopyWithImpl(this._self, this._then);

  final CreateTxStateError _self;
  final $Res Function(CreateTxStateError) _then;

/// Create a copy of CreateTxState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? errorMsg = freezed,}) {
  return _then(CreateTxStateError(
errorMsg: freezed == errorMsg ? _self.errorMsg : errorMsg // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$SendTxState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SendTxState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SendTxState()';
}


}

/// @nodoc
class $SendTxStateCopyWith<$Res>  {
$SendTxStateCopyWith(SendTxState _, $Res Function(SendTxState) __);
}


/// Adds pattern-matching-related methods to [SendTxState].
extension SendTxStatePatterns on SendTxState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SendTxStateEmpty value)?  empty,TResult Function( SendTxStateSending value)?  sending,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SendTxStateEmpty() when empty != null:
return empty(_that);case SendTxStateSending() when sending != null:
return sending(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SendTxStateEmpty value)  empty,required TResult Function( SendTxStateSending value)  sending,}){
final _that = this;
switch (_that) {
case SendTxStateEmpty():
return empty(_that);case SendTxStateSending():
return sending(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SendTxStateEmpty value)?  empty,TResult? Function( SendTxStateSending value)?  sending,}){
final _that = this;
switch (_that) {
case SendTxStateEmpty() when empty != null:
return empty(_that);case SendTxStateSending() when sending != null:
return sending(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  empty,TResult Function()?  sending,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SendTxStateEmpty() when empty != null:
return empty();case SendTxStateSending() when sending != null:
return sending();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  empty,required TResult Function()  sending,}) {final _that = this;
switch (_that) {
case SendTxStateEmpty():
return empty();case SendTxStateSending():
return sending();case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  empty,TResult? Function()?  sending,}) {final _that = this;
switch (_that) {
case SendTxStateEmpty() when empty != null:
return empty();case SendTxStateSending() when sending != null:
return sending();case _:
  return null;

}
}

}

/// @nodoc


class SendTxStateEmpty implements SendTxState {
  const SendTxStateEmpty();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SendTxStateEmpty);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SendTxState.empty()';
}


}




/// @nodoc


class SendTxStateSending implements SendTxState {
  const SendTxStateSending();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SendTxStateSending);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SendTxState.sending()';
}


}




// dart format on
