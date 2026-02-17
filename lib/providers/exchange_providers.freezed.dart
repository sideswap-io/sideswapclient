// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exchange_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExchangeSide {

 Asset get asset;
/// Create a copy of ExchangeSide
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExchangeSideCopyWith<ExchangeSide> get copyWith => _$ExchangeSideCopyWithImpl<ExchangeSide>(this as ExchangeSide, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExchangeSide&&(identical(other.asset, asset) || other.asset == asset));
}


@override
int get hashCode => Object.hash(runtimeType,asset);

@override
String toString() {
  return 'ExchangeSide(asset: $asset)';
}


}

/// @nodoc
abstract mixin class $ExchangeSideCopyWith<$Res>  {
  factory $ExchangeSideCopyWith(ExchangeSide value, $Res Function(ExchangeSide) _then) = _$ExchangeSideCopyWithImpl;
@useResult
$Res call({
 Asset asset
});




}
/// @nodoc
class _$ExchangeSideCopyWithImpl<$Res>
    implements $ExchangeSideCopyWith<$Res> {
  _$ExchangeSideCopyWithImpl(this._self, this._then);

  final ExchangeSide _self;
  final $Res Function(ExchangeSide) _then;

/// Create a copy of ExchangeSide
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? asset = null,}) {
  return _then(_self.copyWith(
asset: null == asset ? _self.asset : asset // ignore: cast_nullable_to_non_nullable
as Asset,
  ));
}

}


/// Adds pattern-matching-related methods to [ExchangeSide].
extension ExchangeSidePatterns on ExchangeSide {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ExchangeSideSell value)?  sell,TResult Function( ExchangeSideBuy value)?  buy,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ExchangeSideSell() when sell != null:
return sell(_that);case ExchangeSideBuy() when buy != null:
return buy(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ExchangeSideSell value)  sell,required TResult Function( ExchangeSideBuy value)  buy,}){
final _that = this;
switch (_that) {
case ExchangeSideSell():
return sell(_that);case ExchangeSideBuy():
return buy(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ExchangeSideSell value)?  sell,TResult? Function( ExchangeSideBuy value)?  buy,}){
final _that = this;
switch (_that) {
case ExchangeSideSell() when sell != null:
return sell(_that);case ExchangeSideBuy() when buy != null:
return buy(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( Asset asset)?  sell,TResult Function( Asset asset)?  buy,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ExchangeSideSell() when sell != null:
return sell(_that.asset);case ExchangeSideBuy() when buy != null:
return buy(_that.asset);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( Asset asset)  sell,required TResult Function( Asset asset)  buy,}) {final _that = this;
switch (_that) {
case ExchangeSideSell():
return sell(_that.asset);case ExchangeSideBuy():
return buy(_that.asset);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( Asset asset)?  sell,TResult? Function( Asset asset)?  buy,}) {final _that = this;
switch (_that) {
case ExchangeSideSell() when sell != null:
return sell(_that.asset);case ExchangeSideBuy() when buy != null:
return buy(_that.asset);case _:
  return null;

}
}

}

/// @nodoc


class ExchangeSideSell implements ExchangeSide {
  const ExchangeSideSell(this.asset);
  

@override final  Asset asset;

/// Create a copy of ExchangeSide
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExchangeSideSellCopyWith<ExchangeSideSell> get copyWith => _$ExchangeSideSellCopyWithImpl<ExchangeSideSell>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExchangeSideSell&&(identical(other.asset, asset) || other.asset == asset));
}


@override
int get hashCode => Object.hash(runtimeType,asset);

@override
String toString() {
  return 'ExchangeSide.sell(asset: $asset)';
}


}

/// @nodoc
abstract mixin class $ExchangeSideSellCopyWith<$Res> implements $ExchangeSideCopyWith<$Res> {
  factory $ExchangeSideSellCopyWith(ExchangeSideSell value, $Res Function(ExchangeSideSell) _then) = _$ExchangeSideSellCopyWithImpl;
@override @useResult
$Res call({
 Asset asset
});




}
/// @nodoc
class _$ExchangeSideSellCopyWithImpl<$Res>
    implements $ExchangeSideSellCopyWith<$Res> {
  _$ExchangeSideSellCopyWithImpl(this._self, this._then);

  final ExchangeSideSell _self;
  final $Res Function(ExchangeSideSell) _then;

/// Create a copy of ExchangeSide
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? asset = null,}) {
  return _then(ExchangeSideSell(
null == asset ? _self.asset : asset // ignore: cast_nullable_to_non_nullable
as Asset,
  ));
}


}

/// @nodoc


class ExchangeSideBuy implements ExchangeSide {
  const ExchangeSideBuy(this.asset);
  

@override final  Asset asset;

/// Create a copy of ExchangeSide
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExchangeSideBuyCopyWith<ExchangeSideBuy> get copyWith => _$ExchangeSideBuyCopyWithImpl<ExchangeSideBuy>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExchangeSideBuy&&(identical(other.asset, asset) || other.asset == asset));
}


@override
int get hashCode => Object.hash(runtimeType,asset);

@override
String toString() {
  return 'ExchangeSide.buy(asset: $asset)';
}


}

/// @nodoc
abstract mixin class $ExchangeSideBuyCopyWith<$Res> implements $ExchangeSideCopyWith<$Res> {
  factory $ExchangeSideBuyCopyWith(ExchangeSideBuy value, $Res Function(ExchangeSideBuy) _then) = _$ExchangeSideBuyCopyWithImpl;
@override @useResult
$Res call({
 Asset asset
});




}
/// @nodoc
class _$ExchangeSideBuyCopyWithImpl<$Res>
    implements $ExchangeSideBuyCopyWith<$Res> {
  _$ExchangeSideBuyCopyWithImpl(this._self, this._then);

  final ExchangeSideBuy _self;
  final $Res Function(ExchangeSideBuy) _then;

/// Create a copy of ExchangeSide
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? asset = null,}) {
  return _then(ExchangeSideBuy(
null == asset ? _self.asset : asset // ignore: cast_nullable_to_non_nullable
as Asset,
  ));
}


}

/// @nodoc
mixin _$ExchangeAcceptQuoteState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExchangeAcceptQuoteState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ExchangeAcceptQuoteState()';
}


}

/// @nodoc
class $ExchangeAcceptQuoteStateCopyWith<$Res>  {
$ExchangeAcceptQuoteStateCopyWith(ExchangeAcceptQuoteState _, $Res Function(ExchangeAcceptQuoteState) __);
}


/// Adds pattern-matching-related methods to [ExchangeAcceptQuoteState].
extension ExchangeAcceptQuoteStatePatterns on ExchangeAcceptQuoteState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ExchangeAcceptQuoteStateEmpty value)?  empty,TResult Function( ExchangeAcceptQuoteStateInProgress value)?  inProgress,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ExchangeAcceptQuoteStateEmpty() when empty != null:
return empty(_that);case ExchangeAcceptQuoteStateInProgress() when inProgress != null:
return inProgress(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ExchangeAcceptQuoteStateEmpty value)  empty,required TResult Function( ExchangeAcceptQuoteStateInProgress value)  inProgress,}){
final _that = this;
switch (_that) {
case ExchangeAcceptQuoteStateEmpty():
return empty(_that);case ExchangeAcceptQuoteStateInProgress():
return inProgress(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ExchangeAcceptQuoteStateEmpty value)?  empty,TResult? Function( ExchangeAcceptQuoteStateInProgress value)?  inProgress,}){
final _that = this;
switch (_that) {
case ExchangeAcceptQuoteStateEmpty() when empty != null:
return empty(_that);case ExchangeAcceptQuoteStateInProgress() when inProgress != null:
return inProgress(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  empty,TResult Function()?  inProgress,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ExchangeAcceptQuoteStateEmpty() when empty != null:
return empty();case ExchangeAcceptQuoteStateInProgress() when inProgress != null:
return inProgress();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  empty,required TResult Function()  inProgress,}) {final _that = this;
switch (_that) {
case ExchangeAcceptQuoteStateEmpty():
return empty();case ExchangeAcceptQuoteStateInProgress():
return inProgress();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  empty,TResult? Function()?  inProgress,}) {final _that = this;
switch (_that) {
case ExchangeAcceptQuoteStateEmpty() when empty != null:
return empty();case ExchangeAcceptQuoteStateInProgress() when inProgress != null:
return inProgress();case _:
  return null;

}
}

}

/// @nodoc


class ExchangeAcceptQuoteStateEmpty implements ExchangeAcceptQuoteState {
  const ExchangeAcceptQuoteStateEmpty();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExchangeAcceptQuoteStateEmpty);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ExchangeAcceptQuoteState.empty()';
}


}




/// @nodoc


class ExchangeAcceptQuoteStateInProgress implements ExchangeAcceptQuoteState {
  const ExchangeAcceptQuoteStateInProgress();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExchangeAcceptQuoteStateInProgress);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ExchangeAcceptQuoteState.inProgress()';
}


}




/// @nodoc
mixin _$InstantSwapState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InstantSwapState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'InstantSwapState()';
}


}

/// @nodoc
class $InstantSwapStateCopyWith<$Res>  {
$InstantSwapStateCopyWith(InstantSwapState _, $Res Function(InstantSwapState) __);
}


/// Adds pattern-matching-related methods to [InstantSwapState].
extension InstantSwapStatePatterns on InstantSwapState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( InstantSwapStateEmpty value)?  empty,TResult Function( InstantSwapStateInProgress value)?  inProgress,required TResult orElse(),}){
final _that = this;
switch (_that) {
case InstantSwapStateEmpty() when empty != null:
return empty(_that);case InstantSwapStateInProgress() when inProgress != null:
return inProgress(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( InstantSwapStateEmpty value)  empty,required TResult Function( InstantSwapStateInProgress value)  inProgress,}){
final _that = this;
switch (_that) {
case InstantSwapStateEmpty():
return empty(_that);case InstantSwapStateInProgress():
return inProgress(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( InstantSwapStateEmpty value)?  empty,TResult? Function( InstantSwapStateInProgress value)?  inProgress,}){
final _that = this;
switch (_that) {
case InstantSwapStateEmpty() when empty != null:
return empty(_that);case InstantSwapStateInProgress() when inProgress != null:
return inProgress(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  empty,TResult Function()?  inProgress,required TResult orElse(),}) {final _that = this;
switch (_that) {
case InstantSwapStateEmpty() when empty != null:
return empty();case InstantSwapStateInProgress() when inProgress != null:
return inProgress();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  empty,required TResult Function()  inProgress,}) {final _that = this;
switch (_that) {
case InstantSwapStateEmpty():
return empty();case InstantSwapStateInProgress():
return inProgress();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  empty,TResult? Function()?  inProgress,}) {final _that = this;
switch (_that) {
case InstantSwapStateEmpty() when empty != null:
return empty();case InstantSwapStateInProgress() when inProgress != null:
return inProgress();case _:
  return null;

}
}

}

/// @nodoc


class InstantSwapStateEmpty implements InstantSwapState {
  const InstantSwapStateEmpty();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InstantSwapStateEmpty);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'InstantSwapState.empty()';
}


}




/// @nodoc


class InstantSwapStateInProgress implements InstantSwapState {
  const InstantSwapStateInProgress();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InstantSwapStateInProgress);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'InstantSwapState.inProgress()';
}


}




// dart format on
