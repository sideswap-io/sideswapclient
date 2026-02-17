// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'jade_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$JadeOnboardingRegistrationState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JadeOnboardingRegistrationState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'JadeOnboardingRegistrationState()';
}


}

/// @nodoc
class $JadeOnboardingRegistrationStateCopyWith<$Res>  {
$JadeOnboardingRegistrationStateCopyWith(JadeOnboardingRegistrationState _, $Res Function(JadeOnboardingRegistrationState) __);
}


/// Adds pattern-matching-related methods to [JadeOnboardingRegistrationState].
extension JadeOnboardingRegistrationStatePatterns on JadeOnboardingRegistrationState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( JadeOnboardingRegistrationStateIdle value)?  idle,TResult Function( JadeOnboardingRegistrationStateProcessing value)?  processing,TResult Function( JadeOnboardingRegistrationStateDone value)?  done,required TResult orElse(),}){
final _that = this;
switch (_that) {
case JadeOnboardingRegistrationStateIdle() when idle != null:
return idle(_that);case JadeOnboardingRegistrationStateProcessing() when processing != null:
return processing(_that);case JadeOnboardingRegistrationStateDone() when done != null:
return done(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( JadeOnboardingRegistrationStateIdle value)  idle,required TResult Function( JadeOnboardingRegistrationStateProcessing value)  processing,required TResult Function( JadeOnboardingRegistrationStateDone value)  done,}){
final _that = this;
switch (_that) {
case JadeOnboardingRegistrationStateIdle():
return idle(_that);case JadeOnboardingRegistrationStateProcessing():
return processing(_that);case JadeOnboardingRegistrationStateDone():
return done(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( JadeOnboardingRegistrationStateIdle value)?  idle,TResult? Function( JadeOnboardingRegistrationStateProcessing value)?  processing,TResult? Function( JadeOnboardingRegistrationStateDone value)?  done,}){
final _that = this;
switch (_that) {
case JadeOnboardingRegistrationStateIdle() when idle != null:
return idle(_that);case JadeOnboardingRegistrationStateProcessing() when processing != null:
return processing(_that);case JadeOnboardingRegistrationStateDone() when done != null:
return done(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  idle,TResult Function()?  processing,TResult Function()?  done,required TResult orElse(),}) {final _that = this;
switch (_that) {
case JadeOnboardingRegistrationStateIdle() when idle != null:
return idle();case JadeOnboardingRegistrationStateProcessing() when processing != null:
return processing();case JadeOnboardingRegistrationStateDone() when done != null:
return done();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  idle,required TResult Function()  processing,required TResult Function()  done,}) {final _that = this;
switch (_that) {
case JadeOnboardingRegistrationStateIdle():
return idle();case JadeOnboardingRegistrationStateProcessing():
return processing();case JadeOnboardingRegistrationStateDone():
return done();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  idle,TResult? Function()?  processing,TResult? Function()?  done,}) {final _that = this;
switch (_that) {
case JadeOnboardingRegistrationStateIdle() when idle != null:
return idle();case JadeOnboardingRegistrationStateProcessing() when processing != null:
return processing();case JadeOnboardingRegistrationStateDone() when done != null:
return done();case _:
  return null;

}
}

}

/// @nodoc


class JadeOnboardingRegistrationStateIdle implements JadeOnboardingRegistrationState {
  const JadeOnboardingRegistrationStateIdle();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JadeOnboardingRegistrationStateIdle);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'JadeOnboardingRegistrationState.idle()';
}


}




/// @nodoc


class JadeOnboardingRegistrationStateProcessing implements JadeOnboardingRegistrationState {
  const JadeOnboardingRegistrationStateProcessing();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JadeOnboardingRegistrationStateProcessing);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'JadeOnboardingRegistrationState.processing()';
}


}




/// @nodoc


class JadeOnboardingRegistrationStateDone implements JadeOnboardingRegistrationState {
  const JadeOnboardingRegistrationStateDone();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JadeOnboardingRegistrationStateDone);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'JadeOnboardingRegistrationState.done()';
}


}




/// @nodoc
mixin _$JadeStatus {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JadeStatus);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'JadeStatus()';
}


}

/// @nodoc
class $JadeStatusCopyWith<$Res>  {
$JadeStatusCopyWith(JadeStatus _, $Res Function(JadeStatus) __);
}


/// Adds pattern-matching-related methods to [JadeStatus].
extension JadeStatusPatterns on JadeStatus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( JadeStatusIdle value)?  idle,TResult Function( JadeStatusReadStatus value)?  readStatus,TResult Function( JadeStatusAuthUser value)?  authUser,TResult Function( JadeStatusSignTx value)?  signTx,TResult Function( JadeStatusMasterBlindingKey value)?  masterBlindingKey,TResult Function( JadeStatusSignOfflineSwap value)?  signOfflineSwap,TResult Function( JadeStatusSignSwap value)?  signSwap,TResult Function( JadeStatusSignSwapOutput value)?  signSwapOutput,TResult Function( JadeStatusConnecting value)?  connecting,TResult Function( JadeStatusSignMessage value)?  signMessage,required TResult orElse(),}){
final _that = this;
switch (_that) {
case JadeStatusIdle() when idle != null:
return idle(_that);case JadeStatusReadStatus() when readStatus != null:
return readStatus(_that);case JadeStatusAuthUser() when authUser != null:
return authUser(_that);case JadeStatusSignTx() when signTx != null:
return signTx(_that);case JadeStatusMasterBlindingKey() when masterBlindingKey != null:
return masterBlindingKey(_that);case JadeStatusSignOfflineSwap() when signOfflineSwap != null:
return signOfflineSwap(_that);case JadeStatusSignSwap() when signSwap != null:
return signSwap(_that);case JadeStatusSignSwapOutput() when signSwapOutput != null:
return signSwapOutput(_that);case JadeStatusConnecting() when connecting != null:
return connecting(_that);case JadeStatusSignMessage() when signMessage != null:
return signMessage(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( JadeStatusIdle value)  idle,required TResult Function( JadeStatusReadStatus value)  readStatus,required TResult Function( JadeStatusAuthUser value)  authUser,required TResult Function( JadeStatusSignTx value)  signTx,required TResult Function( JadeStatusMasterBlindingKey value)  masterBlindingKey,required TResult Function( JadeStatusSignOfflineSwap value)  signOfflineSwap,required TResult Function( JadeStatusSignSwap value)  signSwap,required TResult Function( JadeStatusSignSwapOutput value)  signSwapOutput,required TResult Function( JadeStatusConnecting value)  connecting,required TResult Function( JadeStatusSignMessage value)  signMessage,}){
final _that = this;
switch (_that) {
case JadeStatusIdle():
return idle(_that);case JadeStatusReadStatus():
return readStatus(_that);case JadeStatusAuthUser():
return authUser(_that);case JadeStatusSignTx():
return signTx(_that);case JadeStatusMasterBlindingKey():
return masterBlindingKey(_that);case JadeStatusSignOfflineSwap():
return signOfflineSwap(_that);case JadeStatusSignSwap():
return signSwap(_that);case JadeStatusSignSwapOutput():
return signSwapOutput(_that);case JadeStatusConnecting():
return connecting(_that);case JadeStatusSignMessage():
return signMessage(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( JadeStatusIdle value)?  idle,TResult? Function( JadeStatusReadStatus value)?  readStatus,TResult? Function( JadeStatusAuthUser value)?  authUser,TResult? Function( JadeStatusSignTx value)?  signTx,TResult? Function( JadeStatusMasterBlindingKey value)?  masterBlindingKey,TResult? Function( JadeStatusSignOfflineSwap value)?  signOfflineSwap,TResult? Function( JadeStatusSignSwap value)?  signSwap,TResult? Function( JadeStatusSignSwapOutput value)?  signSwapOutput,TResult? Function( JadeStatusConnecting value)?  connecting,TResult? Function( JadeStatusSignMessage value)?  signMessage,}){
final _that = this;
switch (_that) {
case JadeStatusIdle() when idle != null:
return idle(_that);case JadeStatusReadStatus() when readStatus != null:
return readStatus(_that);case JadeStatusAuthUser() when authUser != null:
return authUser(_that);case JadeStatusSignTx() when signTx != null:
return signTx(_that);case JadeStatusMasterBlindingKey() when masterBlindingKey != null:
return masterBlindingKey(_that);case JadeStatusSignOfflineSwap() when signOfflineSwap != null:
return signOfflineSwap(_that);case JadeStatusSignSwap() when signSwap != null:
return signSwap(_that);case JadeStatusSignSwapOutput() when signSwapOutput != null:
return signSwapOutput(_that);case JadeStatusConnecting() when connecting != null:
return connecting(_that);case JadeStatusSignMessage() when signMessage != null:
return signMessage(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  idle,TResult Function()?  readStatus,TResult Function()?  authUser,TResult Function()?  signTx,TResult Function()?  masterBlindingKey,TResult Function()?  signOfflineSwap,TResult Function()?  signSwap,TResult Function()?  signSwapOutput,TResult Function()?  connecting,TResult Function()?  signMessage,required TResult orElse(),}) {final _that = this;
switch (_that) {
case JadeStatusIdle() when idle != null:
return idle();case JadeStatusReadStatus() when readStatus != null:
return readStatus();case JadeStatusAuthUser() when authUser != null:
return authUser();case JadeStatusSignTx() when signTx != null:
return signTx();case JadeStatusMasterBlindingKey() when masterBlindingKey != null:
return masterBlindingKey();case JadeStatusSignOfflineSwap() when signOfflineSwap != null:
return signOfflineSwap();case JadeStatusSignSwap() when signSwap != null:
return signSwap();case JadeStatusSignSwapOutput() when signSwapOutput != null:
return signSwapOutput();case JadeStatusConnecting() when connecting != null:
return connecting();case JadeStatusSignMessage() when signMessage != null:
return signMessage();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  idle,required TResult Function()  readStatus,required TResult Function()  authUser,required TResult Function()  signTx,required TResult Function()  masterBlindingKey,required TResult Function()  signOfflineSwap,required TResult Function()  signSwap,required TResult Function()  signSwapOutput,required TResult Function()  connecting,required TResult Function()  signMessage,}) {final _that = this;
switch (_that) {
case JadeStatusIdle():
return idle();case JadeStatusReadStatus():
return readStatus();case JadeStatusAuthUser():
return authUser();case JadeStatusSignTx():
return signTx();case JadeStatusMasterBlindingKey():
return masterBlindingKey();case JadeStatusSignOfflineSwap():
return signOfflineSwap();case JadeStatusSignSwap():
return signSwap();case JadeStatusSignSwapOutput():
return signSwapOutput();case JadeStatusConnecting():
return connecting();case JadeStatusSignMessage():
return signMessage();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  idle,TResult? Function()?  readStatus,TResult? Function()?  authUser,TResult? Function()?  signTx,TResult? Function()?  masterBlindingKey,TResult? Function()?  signOfflineSwap,TResult? Function()?  signSwap,TResult? Function()?  signSwapOutput,TResult? Function()?  connecting,TResult? Function()?  signMessage,}) {final _that = this;
switch (_that) {
case JadeStatusIdle() when idle != null:
return idle();case JadeStatusReadStatus() when readStatus != null:
return readStatus();case JadeStatusAuthUser() when authUser != null:
return authUser();case JadeStatusSignTx() when signTx != null:
return signTx();case JadeStatusMasterBlindingKey() when masterBlindingKey != null:
return masterBlindingKey();case JadeStatusSignOfflineSwap() when signOfflineSwap != null:
return signOfflineSwap();case JadeStatusSignSwap() when signSwap != null:
return signSwap();case JadeStatusSignSwapOutput() when signSwapOutput != null:
return signSwapOutput();case JadeStatusConnecting() when connecting != null:
return connecting();case JadeStatusSignMessage() when signMessage != null:
return signMessage();case _:
  return null;

}
}

}

/// @nodoc


class JadeStatusIdle extends JadeStatus {
  const JadeStatusIdle(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JadeStatusIdle);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'JadeStatus.idle()';
}


}




/// @nodoc


class JadeStatusReadStatus extends JadeStatus {
  const JadeStatusReadStatus(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JadeStatusReadStatus);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'JadeStatus.readStatus()';
}


}




/// @nodoc


class JadeStatusAuthUser extends JadeStatus {
  const JadeStatusAuthUser(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JadeStatusAuthUser);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'JadeStatus.authUser()';
}


}




/// @nodoc


class JadeStatusSignTx extends JadeStatus {
  const JadeStatusSignTx(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JadeStatusSignTx);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'JadeStatus.signTx()';
}


}




/// @nodoc


class JadeStatusMasterBlindingKey extends JadeStatus {
  const JadeStatusMasterBlindingKey(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JadeStatusMasterBlindingKey);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'JadeStatus.masterBlindingKey()';
}


}




/// @nodoc


class JadeStatusSignOfflineSwap extends JadeStatus {
  const JadeStatusSignOfflineSwap(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JadeStatusSignOfflineSwap);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'JadeStatus.signOfflineSwap()';
}


}




/// @nodoc


class JadeStatusSignSwap extends JadeStatus {
  const JadeStatusSignSwap(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JadeStatusSignSwap);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'JadeStatus.signSwap()';
}


}




/// @nodoc


class JadeStatusSignSwapOutput extends JadeStatus {
  const JadeStatusSignSwapOutput(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JadeStatusSignSwapOutput);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'JadeStatus.signSwapOutput()';
}


}




/// @nodoc


class JadeStatusConnecting extends JadeStatus {
  const JadeStatusConnecting(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JadeStatusConnecting);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'JadeStatus.connecting()';
}


}




/// @nodoc


class JadeStatusSignMessage extends JadeStatus {
  const JadeStatusSignMessage(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JadeStatusSignMessage);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'JadeStatus.signMessage()';
}


}




/// @nodoc
mixin _$JadeDevicesState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JadeDevicesState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'JadeDevicesState()';
}


}

/// @nodoc
class $JadeDevicesStateCopyWith<$Res>  {
$JadeDevicesStateCopyWith(JadeDevicesState _, $Res Function(JadeDevicesState) __);
}


/// Adds pattern-matching-related methods to [JadeDevicesState].
extension JadeDevicesStatePatterns on JadeDevicesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( JadeDevicesStateUnavailable value)?  unavailable,TResult Function( JadeDevicesStateAvailable value)?  available,required TResult orElse(),}){
final _that = this;
switch (_that) {
case JadeDevicesStateUnavailable() when unavailable != null:
return unavailable(_that);case JadeDevicesStateAvailable() when available != null:
return available(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( JadeDevicesStateUnavailable value)  unavailable,required TResult Function( JadeDevicesStateAvailable value)  available,}){
final _that = this;
switch (_that) {
case JadeDevicesStateUnavailable():
return unavailable(_that);case JadeDevicesStateAvailable():
return available(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( JadeDevicesStateUnavailable value)?  unavailable,TResult? Function( JadeDevicesStateAvailable value)?  available,}){
final _that = this;
switch (_that) {
case JadeDevicesStateUnavailable() when unavailable != null:
return unavailable(_that);case JadeDevicesStateAvailable() when available != null:
return available(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  unavailable,TResult Function( List<From_JadePorts_Port> devices)?  available,required TResult orElse(),}) {final _that = this;
switch (_that) {
case JadeDevicesStateUnavailable() when unavailable != null:
return unavailable();case JadeDevicesStateAvailable() when available != null:
return available(_that.devices);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  unavailable,required TResult Function( List<From_JadePorts_Port> devices)  available,}) {final _that = this;
switch (_that) {
case JadeDevicesStateUnavailable():
return unavailable();case JadeDevicesStateAvailable():
return available(_that.devices);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  unavailable,TResult? Function( List<From_JadePorts_Port> devices)?  available,}) {final _that = this;
switch (_that) {
case JadeDevicesStateUnavailable() when unavailable != null:
return unavailable();case JadeDevicesStateAvailable() when available != null:
return available(_that.devices);case _:
  return null;

}
}

}

/// @nodoc


class JadeDevicesStateUnavailable implements JadeDevicesState {
  const JadeDevicesStateUnavailable();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JadeDevicesStateUnavailable);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'JadeDevicesState.unavailable()';
}


}




/// @nodoc


class JadeDevicesStateAvailable implements JadeDevicesState {
  const JadeDevicesStateAvailable({required final  List<From_JadePorts_Port> devices}): _devices = devices;
  

 final  List<From_JadePorts_Port> _devices;
 List<From_JadePorts_Port> get devices {
  if (_devices is EqualUnmodifiableListView) return _devices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_devices);
}


/// Create a copy of JadeDevicesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JadeDevicesStateAvailableCopyWith<JadeDevicesStateAvailable> get copyWith => _$JadeDevicesStateAvailableCopyWithImpl<JadeDevicesStateAvailable>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JadeDevicesStateAvailable&&const DeepCollectionEquality().equals(other._devices, _devices));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_devices));

@override
String toString() {
  return 'JadeDevicesState.available(devices: $devices)';
}


}

/// @nodoc
abstract mixin class $JadeDevicesStateAvailableCopyWith<$Res> implements $JadeDevicesStateCopyWith<$Res> {
  factory $JadeDevicesStateAvailableCopyWith(JadeDevicesStateAvailable value, $Res Function(JadeDevicesStateAvailable) _then) = _$JadeDevicesStateAvailableCopyWithImpl;
@useResult
$Res call({
 List<From_JadePorts_Port> devices
});




}
/// @nodoc
class _$JadeDevicesStateAvailableCopyWithImpl<$Res>
    implements $JadeDevicesStateAvailableCopyWith<$Res> {
  _$JadeDevicesStateAvailableCopyWithImpl(this._self, this._then);

  final JadeDevicesStateAvailable _self;
  final $Res Function(JadeDevicesStateAvailable) _then;

/// Create a copy of JadeDevicesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? devices = null,}) {
  return _then(JadeDevicesStateAvailable(
devices: null == devices ? _self._devices : devices // ignore: cast_nullable_to_non_nullable
as List<From_JadePorts_Port>,
  ));
}


}

/// @nodoc
mixin _$JadePort {

 From_JadePorts_Port get fromJadePortsPort;
/// Create a copy of JadePort
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JadePortCopyWith<JadePort> get copyWith => _$JadePortCopyWithImpl<JadePort>(this as JadePort, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JadePort&&(identical(other.fromJadePortsPort, fromJadePortsPort) || other.fromJadePortsPort == fromJadePortsPort));
}


@override
int get hashCode => Object.hash(runtimeType,fromJadePortsPort);

@override
String toString() {
  return 'JadePort(fromJadePortsPort: $fromJadePortsPort)';
}


}

/// @nodoc
abstract mixin class $JadePortCopyWith<$Res>  {
  factory $JadePortCopyWith(JadePort value, $Res Function(JadePort) _then) = _$JadePortCopyWithImpl;
@useResult
$Res call({
 From_JadePorts_Port fromJadePortsPort
});




}
/// @nodoc
class _$JadePortCopyWithImpl<$Res>
    implements $JadePortCopyWith<$Res> {
  _$JadePortCopyWithImpl(this._self, this._then);

  final JadePort _self;
  final $Res Function(JadePort) _then;

/// Create a copy of JadePort
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fromJadePortsPort = null,}) {
  return _then(_self.copyWith(
fromJadePortsPort: null == fromJadePortsPort ? _self.fromJadePortsPort : fromJadePortsPort // ignore: cast_nullable_to_non_nullable
as From_JadePorts_Port,
  ));
}

}


/// Adds pattern-matching-related methods to [JadePort].
extension JadePortPatterns on JadePort {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JadePort value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JadePort() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JadePort value)  $default,){
final _that = this;
switch (_that) {
case _JadePort():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JadePort value)?  $default,){
final _that = this;
switch (_that) {
case _JadePort() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( From_JadePorts_Port fromJadePortsPort)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JadePort() when $default != null:
return $default(_that.fromJadePortsPort);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( From_JadePorts_Port fromJadePortsPort)  $default,) {final _that = this;
switch (_that) {
case _JadePort():
return $default(_that.fromJadePortsPort);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( From_JadePorts_Port fromJadePortsPort)?  $default,) {final _that = this;
switch (_that) {
case _JadePort() when $default != null:
return $default(_that.fromJadePortsPort);case _:
  return null;

}
}

}

/// @nodoc


class _JadePort extends JadePort {
   _JadePort({required this.fromJadePortsPort}): super._();
  

@override final  From_JadePorts_Port fromJadePortsPort;

/// Create a copy of JadePort
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JadePortCopyWith<_JadePort> get copyWith => __$JadePortCopyWithImpl<_JadePort>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JadePort&&(identical(other.fromJadePortsPort, fromJadePortsPort) || other.fromJadePortsPort == fromJadePortsPort));
}


@override
int get hashCode => Object.hash(runtimeType,fromJadePortsPort);

@override
String toString() {
  return 'JadePort(fromJadePortsPort: $fromJadePortsPort)';
}


}

/// @nodoc
abstract mixin class _$JadePortCopyWith<$Res> implements $JadePortCopyWith<$Res> {
  factory _$JadePortCopyWith(_JadePort value, $Res Function(_JadePort) _then) = __$JadePortCopyWithImpl;
@override @useResult
$Res call({
 From_JadePorts_Port fromJadePortsPort
});




}
/// @nodoc
class __$JadePortCopyWithImpl<$Res>
    implements _$JadePortCopyWith<$Res> {
  __$JadePortCopyWithImpl(this._self, this._then);

  final _JadePort _self;
  final $Res Function(_JadePort) _then;

/// Create a copy of JadePort
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fromJadePortsPort = null,}) {
  return _then(_JadePort(
fromJadePortsPort: null == fromJadePortsPort ? _self.fromJadePortsPort : fromJadePortsPort // ignore: cast_nullable_to_non_nullable
as From_JadePorts_Port,
  ));
}


}

// dart format on
