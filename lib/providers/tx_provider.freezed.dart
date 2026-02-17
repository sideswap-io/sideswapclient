// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tx_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LoadTransactionsState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadTransactionsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LoadTransactionsState()';
}


}

/// @nodoc
class $LoadTransactionsStateCopyWith<$Res>  {
$LoadTransactionsStateCopyWith(LoadTransactionsState _, $Res Function(LoadTransactionsState) __);
}


/// Adds pattern-matching-related methods to [LoadTransactionsState].
extension LoadTransactionsStatePatterns on LoadTransactionsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LoadTransactionsStateEmpty value)?  empty,TResult Function( LoadTransactionsStateLoading value)?  loading,TResult Function( LoadTransactionsStateError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LoadTransactionsStateEmpty() when empty != null:
return empty(_that);case LoadTransactionsStateLoading() when loading != null:
return loading(_that);case LoadTransactionsStateError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LoadTransactionsStateEmpty value)  empty,required TResult Function( LoadTransactionsStateLoading value)  loading,required TResult Function( LoadTransactionsStateError value)  error,}){
final _that = this;
switch (_that) {
case LoadTransactionsStateEmpty():
return empty(_that);case LoadTransactionsStateLoading():
return loading(_that);case LoadTransactionsStateError():
return error(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LoadTransactionsStateEmpty value)?  empty,TResult? Function( LoadTransactionsStateLoading value)?  loading,TResult? Function( LoadTransactionsStateError value)?  error,}){
final _that = this;
switch (_that) {
case LoadTransactionsStateEmpty() when empty != null:
return empty(_that);case LoadTransactionsStateLoading() when loading != null:
return loading(_that);case LoadTransactionsStateError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  empty,TResult Function()?  loading,TResult Function( String? errorMsg)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LoadTransactionsStateEmpty() when empty != null:
return empty();case LoadTransactionsStateLoading() when loading != null:
return loading();case LoadTransactionsStateError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  empty,required TResult Function()  loading,required TResult Function( String? errorMsg)  error,}) {final _that = this;
switch (_that) {
case LoadTransactionsStateEmpty():
return empty();case LoadTransactionsStateLoading():
return loading();case LoadTransactionsStateError():
return error(_that.errorMsg);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  empty,TResult? Function()?  loading,TResult? Function( String? errorMsg)?  error,}) {final _that = this;
switch (_that) {
case LoadTransactionsStateEmpty() when empty != null:
return empty();case LoadTransactionsStateLoading() when loading != null:
return loading();case LoadTransactionsStateError() when error != null:
return error(_that.errorMsg);case _:
  return null;

}
}

}

/// @nodoc


class LoadTransactionsStateEmpty implements LoadTransactionsState {
  const LoadTransactionsStateEmpty();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadTransactionsStateEmpty);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LoadTransactionsState.empty()';
}


}




/// @nodoc


class LoadTransactionsStateLoading implements LoadTransactionsState {
  const LoadTransactionsStateLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadTransactionsStateLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LoadTransactionsState.loading()';
}


}




/// @nodoc


class LoadTransactionsStateError implements LoadTransactionsState {
  const LoadTransactionsStateError({this.errorMsg});
  

 final  String? errorMsg;

/// Create a copy of LoadTransactionsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoadTransactionsStateErrorCopyWith<LoadTransactionsStateError> get copyWith => _$LoadTransactionsStateErrorCopyWithImpl<LoadTransactionsStateError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadTransactionsStateError&&(identical(other.errorMsg, errorMsg) || other.errorMsg == errorMsg));
}


@override
int get hashCode => Object.hash(runtimeType,errorMsg);

@override
String toString() {
  return 'LoadTransactionsState.error(errorMsg: $errorMsg)';
}


}

/// @nodoc
abstract mixin class $LoadTransactionsStateErrorCopyWith<$Res> implements $LoadTransactionsStateCopyWith<$Res> {
  factory $LoadTransactionsStateErrorCopyWith(LoadTransactionsStateError value, $Res Function(LoadTransactionsStateError) _then) = _$LoadTransactionsStateErrorCopyWithImpl;
@useResult
$Res call({
 String? errorMsg
});




}
/// @nodoc
class _$LoadTransactionsStateErrorCopyWithImpl<$Res>
    implements $LoadTransactionsStateErrorCopyWith<$Res> {
  _$LoadTransactionsStateErrorCopyWithImpl(this._self, this._then);

  final LoadTransactionsStateError _self;
  final $Res Function(LoadTransactionsStateError) _then;

/// Create a copy of LoadTransactionsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? errorMsg = freezed,}) {
  return _then(LoadTransactionsStateError(
errorMsg: freezed == errorMsg ? _self.errorMsg : errorMsg // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$TxHistoryState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TxHistoryState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TxHistoryState()';
}


}

/// @nodoc
class $TxHistoryStateCopyWith<$Res>  {
$TxHistoryStateCopyWith(TxHistoryState _, $Res Function(TxHistoryState) __);
}


/// Adds pattern-matching-related methods to [TxHistoryState].
extension TxHistoryStatePatterns on TxHistoryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TxHistoryStateInvisible value)?  invisible,TResult Function( TxHistoryStateVisible value)?  visible,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TxHistoryStateInvisible() when invisible != null:
return invisible(_that);case TxHistoryStateVisible() when visible != null:
return visible(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TxHistoryStateInvisible value)  invisible,required TResult Function( TxHistoryStateVisible value)  visible,}){
final _that = this;
switch (_that) {
case TxHistoryStateInvisible():
return invisible(_that);case TxHistoryStateVisible():
return visible(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TxHistoryStateInvisible value)?  invisible,TResult? Function( TxHistoryStateVisible value)?  visible,}){
final _that = this;
switch (_that) {
case TxHistoryStateInvisible() when invisible != null:
return invisible(_that);case TxHistoryStateVisible() when visible != null:
return visible(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  invisible,TResult Function()?  visible,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TxHistoryStateInvisible() when invisible != null:
return invisible();case TxHistoryStateVisible() when visible != null:
return visible();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  invisible,required TResult Function()  visible,}) {final _that = this;
switch (_that) {
case TxHistoryStateInvisible():
return invisible();case TxHistoryStateVisible():
return visible();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  invisible,TResult? Function()?  visible,}) {final _that = this;
switch (_that) {
case TxHistoryStateInvisible() when invisible != null:
return invisible();case TxHistoryStateVisible() when visible != null:
return visible();case _:
  return null;

}
}

}

/// @nodoc


class TxHistoryStateInvisible implements TxHistoryState {
  const TxHistoryStateInvisible();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TxHistoryStateInvisible);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TxHistoryState.invisible()';
}


}




/// @nodoc


class TxHistoryStateVisible implements TxHistoryState {
  const TxHistoryStateVisible();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TxHistoryStateVisible);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TxHistoryState.visible()';
}


}




// dart format on
