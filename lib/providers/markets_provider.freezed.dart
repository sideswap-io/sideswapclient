// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'markets_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MarketSideState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MarketSideState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MarketSideState()';
}


}

/// @nodoc
class $MarketSideStateCopyWith<$Res>  {
$MarketSideStateCopyWith(MarketSideState _, $Res Function(MarketSideState) __);
}


/// Adds pattern-matching-related methods to [MarketSideState].
extension MarketSideStatePatterns on MarketSideState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( MarketSideStateBase value)?  base,TResult Function( MarketSideStateQuote value)?  quote,required TResult orElse(),}){
final _that = this;
switch (_that) {
case MarketSideStateBase() when base != null:
return base(_that);case MarketSideStateQuote() when quote != null:
return quote(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( MarketSideStateBase value)  base,required TResult Function( MarketSideStateQuote value)  quote,}){
final _that = this;
switch (_that) {
case MarketSideStateBase():
return base(_that);case MarketSideStateQuote():
return quote(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( MarketSideStateBase value)?  base,TResult? Function( MarketSideStateQuote value)?  quote,}){
final _that = this;
switch (_that) {
case MarketSideStateBase() when base != null:
return base(_that);case MarketSideStateQuote() when quote != null:
return quote(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  base,TResult Function()?  quote,required TResult orElse(),}) {final _that = this;
switch (_that) {
case MarketSideStateBase() when base != null:
return base();case MarketSideStateQuote() when quote != null:
return quote();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  base,required TResult Function()  quote,}) {final _that = this;
switch (_that) {
case MarketSideStateBase():
return base();case MarketSideStateQuote():
return quote();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  base,TResult? Function()?  quote,}) {final _that = this;
switch (_that) {
case MarketSideStateBase() when base != null:
return base();case MarketSideStateQuote() when quote != null:
return quote();case _:
  return null;

}
}

}

/// @nodoc


class MarketSideStateBase implements MarketSideState {
  const MarketSideStateBase();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MarketSideStateBase);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MarketSideState.base()';
}


}




/// @nodoc


class MarketSideStateQuote implements MarketSideState {
  const MarketSideStateQuote();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MarketSideStateQuote);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MarketSideState.quote()';
}


}




/// @nodoc
mixin _$MarketTypeSwitchState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MarketTypeSwitchState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MarketTypeSwitchState()';
}


}

/// @nodoc
class $MarketTypeSwitchStateCopyWith<$Res>  {
$MarketTypeSwitchStateCopyWith(MarketTypeSwitchState _, $Res Function(MarketTypeSwitchState) __);
}


/// Adds pattern-matching-related methods to [MarketTypeSwitchState].
extension MarketTypeSwitchStatePatterns on MarketTypeSwitchState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( MarketTypeSwitchStateMarket value)?  market,TResult Function( MarketTypeSwitchStateLimit value)?  limit,required TResult orElse(),}){
final _that = this;
switch (_that) {
case MarketTypeSwitchStateMarket() when market != null:
return market(_that);case MarketTypeSwitchStateLimit() when limit != null:
return limit(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( MarketTypeSwitchStateMarket value)  market,required TResult Function( MarketTypeSwitchStateLimit value)  limit,}){
final _that = this;
switch (_that) {
case MarketTypeSwitchStateMarket():
return market(_that);case MarketTypeSwitchStateLimit():
return limit(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( MarketTypeSwitchStateMarket value)?  market,TResult? Function( MarketTypeSwitchStateLimit value)?  limit,}){
final _that = this;
switch (_that) {
case MarketTypeSwitchStateMarket() when market != null:
return market(_that);case MarketTypeSwitchStateLimit() when limit != null:
return limit(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  market,TResult Function()?  limit,required TResult orElse(),}) {final _that = this;
switch (_that) {
case MarketTypeSwitchStateMarket() when market != null:
return market();case MarketTypeSwitchStateLimit() when limit != null:
return limit();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  market,required TResult Function()  limit,}) {final _that = this;
switch (_that) {
case MarketTypeSwitchStateMarket():
return market();case MarketTypeSwitchStateLimit():
return limit();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  market,TResult? Function()?  limit,}) {final _that = this;
switch (_that) {
case MarketTypeSwitchStateMarket() when market != null:
return market();case MarketTypeSwitchStateLimit() when limit != null:
return limit();case _:
  return null;

}
}

}

/// @nodoc


class MarketTypeSwitchStateMarket implements MarketTypeSwitchState {
  const MarketTypeSwitchStateMarket();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MarketTypeSwitchStateMarket);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MarketTypeSwitchState.market()';
}


}




/// @nodoc


class MarketTypeSwitchStateLimit implements MarketTypeSwitchState {
  const MarketTypeSwitchStateLimit();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MarketTypeSwitchStateLimit);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MarketTypeSwitchState.limit()';
}


}




/// @nodoc
mixin _$LimitTtlFlag {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LimitTtlFlag);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LimitTtlFlag()';
}


}

/// @nodoc
class $LimitTtlFlagCopyWith<$Res>  {
$LimitTtlFlagCopyWith(LimitTtlFlag _, $Res Function(LimitTtlFlag) __);
}


/// Adds pattern-matching-related methods to [LimitTtlFlag].
extension LimitTtlFlagPatterns on LimitTtlFlag {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LimitTtlFlagOneHour value)?  oneHour,TResult Function( LimitTtlFlagSixHours value)?  sixHours,TResult Function( LimitTtlFlagTwelveHours value)?  twelveHours,TResult Function( LimitTtlFlagTwentyFourHours value)?  twentyFourHours,TResult Function( LimitTtlFlagThreeDays value)?  threeDays,TResult Function( LimitTtlFlagOneWeek value)?  oneWeek,TResult Function( LimitTtlFlagOneMonth value)?  oneMonth,TResult Function( LimitTtlFlagUnlimited value)?  unlimited,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LimitTtlFlagOneHour() when oneHour != null:
return oneHour(_that);case LimitTtlFlagSixHours() when sixHours != null:
return sixHours(_that);case LimitTtlFlagTwelveHours() when twelveHours != null:
return twelveHours(_that);case LimitTtlFlagTwentyFourHours() when twentyFourHours != null:
return twentyFourHours(_that);case LimitTtlFlagThreeDays() when threeDays != null:
return threeDays(_that);case LimitTtlFlagOneWeek() when oneWeek != null:
return oneWeek(_that);case LimitTtlFlagOneMonth() when oneMonth != null:
return oneMonth(_that);case LimitTtlFlagUnlimited() when unlimited != null:
return unlimited(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LimitTtlFlagOneHour value)  oneHour,required TResult Function( LimitTtlFlagSixHours value)  sixHours,required TResult Function( LimitTtlFlagTwelveHours value)  twelveHours,required TResult Function( LimitTtlFlagTwentyFourHours value)  twentyFourHours,required TResult Function( LimitTtlFlagThreeDays value)  threeDays,required TResult Function( LimitTtlFlagOneWeek value)  oneWeek,required TResult Function( LimitTtlFlagOneMonth value)  oneMonth,required TResult Function( LimitTtlFlagUnlimited value)  unlimited,}){
final _that = this;
switch (_that) {
case LimitTtlFlagOneHour():
return oneHour(_that);case LimitTtlFlagSixHours():
return sixHours(_that);case LimitTtlFlagTwelveHours():
return twelveHours(_that);case LimitTtlFlagTwentyFourHours():
return twentyFourHours(_that);case LimitTtlFlagThreeDays():
return threeDays(_that);case LimitTtlFlagOneWeek():
return oneWeek(_that);case LimitTtlFlagOneMonth():
return oneMonth(_that);case LimitTtlFlagUnlimited():
return unlimited(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LimitTtlFlagOneHour value)?  oneHour,TResult? Function( LimitTtlFlagSixHours value)?  sixHours,TResult? Function( LimitTtlFlagTwelveHours value)?  twelveHours,TResult? Function( LimitTtlFlagTwentyFourHours value)?  twentyFourHours,TResult? Function( LimitTtlFlagThreeDays value)?  threeDays,TResult? Function( LimitTtlFlagOneWeek value)?  oneWeek,TResult? Function( LimitTtlFlagOneMonth value)?  oneMonth,TResult? Function( LimitTtlFlagUnlimited value)?  unlimited,}){
final _that = this;
switch (_that) {
case LimitTtlFlagOneHour() when oneHour != null:
return oneHour(_that);case LimitTtlFlagSixHours() when sixHours != null:
return sixHours(_that);case LimitTtlFlagTwelveHours() when twelveHours != null:
return twelveHours(_that);case LimitTtlFlagTwentyFourHours() when twentyFourHours != null:
return twentyFourHours(_that);case LimitTtlFlagThreeDays() when threeDays != null:
return threeDays(_that);case LimitTtlFlagOneWeek() when oneWeek != null:
return oneWeek(_that);case LimitTtlFlagOneMonth() when oneMonth != null:
return oneMonth(_that);case LimitTtlFlagUnlimited() when unlimited != null:
return unlimited(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  oneHour,TResult Function()?  sixHours,TResult Function()?  twelveHours,TResult Function()?  twentyFourHours,TResult Function()?  threeDays,TResult Function()?  oneWeek,TResult Function()?  oneMonth,TResult Function()?  unlimited,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LimitTtlFlagOneHour() when oneHour != null:
return oneHour();case LimitTtlFlagSixHours() when sixHours != null:
return sixHours();case LimitTtlFlagTwelveHours() when twelveHours != null:
return twelveHours();case LimitTtlFlagTwentyFourHours() when twentyFourHours != null:
return twentyFourHours();case LimitTtlFlagThreeDays() when threeDays != null:
return threeDays();case LimitTtlFlagOneWeek() when oneWeek != null:
return oneWeek();case LimitTtlFlagOneMonth() when oneMonth != null:
return oneMonth();case LimitTtlFlagUnlimited() when unlimited != null:
return unlimited();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  oneHour,required TResult Function()  sixHours,required TResult Function()  twelveHours,required TResult Function()  twentyFourHours,required TResult Function()  threeDays,required TResult Function()  oneWeek,required TResult Function()  oneMonth,required TResult Function()  unlimited,}) {final _that = this;
switch (_that) {
case LimitTtlFlagOneHour():
return oneHour();case LimitTtlFlagSixHours():
return sixHours();case LimitTtlFlagTwelveHours():
return twelveHours();case LimitTtlFlagTwentyFourHours():
return twentyFourHours();case LimitTtlFlagThreeDays():
return threeDays();case LimitTtlFlagOneWeek():
return oneWeek();case LimitTtlFlagOneMonth():
return oneMonth();case LimitTtlFlagUnlimited():
return unlimited();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  oneHour,TResult? Function()?  sixHours,TResult? Function()?  twelveHours,TResult? Function()?  twentyFourHours,TResult? Function()?  threeDays,TResult? Function()?  oneWeek,TResult? Function()?  oneMonth,TResult? Function()?  unlimited,}) {final _that = this;
switch (_that) {
case LimitTtlFlagOneHour() when oneHour != null:
return oneHour();case LimitTtlFlagSixHours() when sixHours != null:
return sixHours();case LimitTtlFlagTwelveHours() when twelveHours != null:
return twelveHours();case LimitTtlFlagTwentyFourHours() when twentyFourHours != null:
return twentyFourHours();case LimitTtlFlagThreeDays() when threeDays != null:
return threeDays();case LimitTtlFlagOneWeek() when oneWeek != null:
return oneWeek();case LimitTtlFlagOneMonth() when oneMonth != null:
return oneMonth();case LimitTtlFlagUnlimited() when unlimited != null:
return unlimited();case _:
  return null;

}
}

}

/// @nodoc


class LimitTtlFlagOneHour extends LimitTtlFlag {
  const LimitTtlFlagOneHour(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LimitTtlFlagOneHour);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LimitTtlFlag.oneHour()';
}


}




/// @nodoc


class LimitTtlFlagSixHours extends LimitTtlFlag {
  const LimitTtlFlagSixHours(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LimitTtlFlagSixHours);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LimitTtlFlag.sixHours()';
}


}




/// @nodoc


class LimitTtlFlagTwelveHours extends LimitTtlFlag {
  const LimitTtlFlagTwelveHours(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LimitTtlFlagTwelveHours);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LimitTtlFlag.twelveHours()';
}


}




/// @nodoc


class LimitTtlFlagTwentyFourHours extends LimitTtlFlag {
  const LimitTtlFlagTwentyFourHours(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LimitTtlFlagTwentyFourHours);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LimitTtlFlag.twentyFourHours()';
}


}




/// @nodoc


class LimitTtlFlagThreeDays extends LimitTtlFlag {
  const LimitTtlFlagThreeDays(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LimitTtlFlagThreeDays);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LimitTtlFlag.threeDays()';
}


}




/// @nodoc


class LimitTtlFlagOneWeek extends LimitTtlFlag {
  const LimitTtlFlagOneWeek(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LimitTtlFlagOneWeek);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LimitTtlFlag.oneWeek()';
}


}




/// @nodoc


class LimitTtlFlagOneMonth extends LimitTtlFlag {
  const LimitTtlFlagOneMonth(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LimitTtlFlagOneMonth);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LimitTtlFlag.oneMonth()';
}


}




/// @nodoc


class LimitTtlFlagUnlimited extends LimitTtlFlag {
  const LimitTtlFlagUnlimited(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LimitTtlFlagUnlimited);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LimitTtlFlag.unlimited()';
}


}




/// @nodoc
mixin _$OrderType {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderType);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OrderType()';
}


}

/// @nodoc
class $OrderTypeCopyWith<$Res>  {
$OrderTypeCopyWith(OrderType _, $Res Function(OrderType) __);
}


/// Adds pattern-matching-related methods to [OrderType].
extension OrderTypePatterns on OrderType {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( OrderTypePublic value)?  public,TResult Function( OrderTypePrivate value)?  private,required TResult orElse(),}){
final _that = this;
switch (_that) {
case OrderTypePublic() when public != null:
return public(_that);case OrderTypePrivate() when private != null:
return private(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( OrderTypePublic value)  public,required TResult Function( OrderTypePrivate value)  private,}){
final _that = this;
switch (_that) {
case OrderTypePublic():
return public(_that);case OrderTypePrivate():
return private(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( OrderTypePublic value)?  public,TResult? Function( OrderTypePrivate value)?  private,}){
final _that = this;
switch (_that) {
case OrderTypePublic() when public != null:
return public(_that);case OrderTypePrivate() when private != null:
return private(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  public,TResult Function()?  private,required TResult orElse(),}) {final _that = this;
switch (_that) {
case OrderTypePublic() when public != null:
return public();case OrderTypePrivate() when private != null:
return private();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  public,required TResult Function()  private,}) {final _that = this;
switch (_that) {
case OrderTypePublic():
return public();case OrderTypePrivate():
return private();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  public,TResult? Function()?  private,}) {final _that = this;
switch (_that) {
case OrderTypePublic() when public != null:
return public();case OrderTypePrivate() when private != null:
return private();case _:
  return null;

}
}

}

/// @nodoc


class OrderTypePublic implements OrderType {
  const OrderTypePublic();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderTypePublic);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OrderType.public()';
}


}




/// @nodoc


class OrderTypePrivate implements OrderType {
  const OrderTypePrivate();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderTypePrivate);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OrderType.private()';
}


}




/// @nodoc
mixin _$OfflineSwapType {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OfflineSwapType);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OfflineSwapType()';
}


}

/// @nodoc
class $OfflineSwapTypeCopyWith<$Res>  {
$OfflineSwapTypeCopyWith(OfflineSwapType _, $Res Function(OfflineSwapType) __);
}


/// Adds pattern-matching-related methods to [OfflineSwapType].
extension OfflineSwapTypePatterns on OfflineSwapType {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( OfflineSwapTypeEmpty value)?  empty,TResult Function( OfflineSwapTypeTwoStep value)?  twoStep,required TResult orElse(),}){
final _that = this;
switch (_that) {
case OfflineSwapTypeEmpty() when empty != null:
return empty(_that);case OfflineSwapTypeTwoStep() when twoStep != null:
return twoStep(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( OfflineSwapTypeEmpty value)  empty,required TResult Function( OfflineSwapTypeTwoStep value)  twoStep,}){
final _that = this;
switch (_that) {
case OfflineSwapTypeEmpty():
return empty(_that);case OfflineSwapTypeTwoStep():
return twoStep(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( OfflineSwapTypeEmpty value)?  empty,TResult? Function( OfflineSwapTypeTwoStep value)?  twoStep,}){
final _that = this;
switch (_that) {
case OfflineSwapTypeEmpty() when empty != null:
return empty(_that);case OfflineSwapTypeTwoStep() when twoStep != null:
return twoStep(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  empty,TResult Function()?  twoStep,required TResult orElse(),}) {final _that = this;
switch (_that) {
case OfflineSwapTypeEmpty() when empty != null:
return empty();case OfflineSwapTypeTwoStep() when twoStep != null:
return twoStep();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  empty,required TResult Function()  twoStep,}) {final _that = this;
switch (_that) {
case OfflineSwapTypeEmpty():
return empty();case OfflineSwapTypeTwoStep():
return twoStep();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  empty,TResult? Function()?  twoStep,}) {final _that = this;
switch (_that) {
case OfflineSwapTypeEmpty() when empty != null:
return empty();case OfflineSwapTypeTwoStep() when twoStep != null:
return twoStep();case _:
  return null;

}
}

}

/// @nodoc


class OfflineSwapTypeEmpty implements OfflineSwapType {
  const OfflineSwapTypeEmpty();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OfflineSwapTypeEmpty);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OfflineSwapType.empty()';
}


}




/// @nodoc


class OfflineSwapTypeTwoStep implements OfflineSwapType {
  const OfflineSwapTypeTwoStep();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OfflineSwapTypeTwoStep);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OfflineSwapType.twoStep()';
}


}




/// @nodoc
mixin _$StartOrderError {

 String get error; int get orderId;
/// Create a copy of StartOrderError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StartOrderErrorCopyWith<StartOrderError> get copyWith => _$StartOrderErrorCopyWithImpl<StartOrderError>(this as StartOrderError, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StartOrderError&&(identical(other.error, error) || other.error == error)&&(identical(other.orderId, orderId) || other.orderId == orderId));
}


@override
int get hashCode => Object.hash(runtimeType,error,orderId);

@override
String toString() {
  return 'StartOrderError(error: $error, orderId: $orderId)';
}


}

/// @nodoc
abstract mixin class $StartOrderErrorCopyWith<$Res>  {
  factory $StartOrderErrorCopyWith(StartOrderError value, $Res Function(StartOrderError) _then) = _$StartOrderErrorCopyWithImpl;
@useResult
$Res call({
 String error, int orderId
});




}
/// @nodoc
class _$StartOrderErrorCopyWithImpl<$Res>
    implements $StartOrderErrorCopyWith<$Res> {
  _$StartOrderErrorCopyWithImpl(this._self, this._then);

  final StartOrderError _self;
  final $Res Function(StartOrderError) _then;

/// Create a copy of StartOrderError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? error = null,Object? orderId = null,}) {
  return _then(_self.copyWith(
error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [StartOrderError].
extension StartOrderErrorPatterns on StartOrderError {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StartOrderError value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StartOrderError() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StartOrderError value)  $default,){
final _that = this;
switch (_that) {
case _StartOrderError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StartOrderError value)?  $default,){
final _that = this;
switch (_that) {
case _StartOrderError() when $default != null:
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
case _StartOrderError() when $default != null:
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
case _StartOrderError():
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
case _StartOrderError() when $default != null:
return $default(_that.error,_that.orderId);case _:
  return null;

}
}

}

/// @nodoc


class _StartOrderError implements StartOrderError {
  const _StartOrderError({this.error = '', this.orderId = 0});
  

@override@JsonKey() final  String error;
@override@JsonKey() final  int orderId;

/// Create a copy of StartOrderError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StartOrderErrorCopyWith<_StartOrderError> get copyWith => __$StartOrderErrorCopyWithImpl<_StartOrderError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StartOrderError&&(identical(other.error, error) || other.error == error)&&(identical(other.orderId, orderId) || other.orderId == orderId));
}


@override
int get hashCode => Object.hash(runtimeType,error,orderId);

@override
String toString() {
  return 'StartOrderError(error: $error, orderId: $orderId)';
}


}

/// @nodoc
abstract mixin class _$StartOrderErrorCopyWith<$Res> implements $StartOrderErrorCopyWith<$Res> {
  factory _$StartOrderErrorCopyWith(_StartOrderError value, $Res Function(_StartOrderError) _then) = __$StartOrderErrorCopyWithImpl;
@override @useResult
$Res call({
 String error, int orderId
});




}
/// @nodoc
class __$StartOrderErrorCopyWithImpl<$Res>
    implements _$StartOrderErrorCopyWith<$Res> {
  __$StartOrderErrorCopyWithImpl(this._self, this._then);

  final _StartOrderError _self;
  final $Res Function(_StartOrderError) _then;

/// Create a copy of StartOrderError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? error = null,Object? orderId = null,}) {
  return _then(_StartOrderError(
error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
