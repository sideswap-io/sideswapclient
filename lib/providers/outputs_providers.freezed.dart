// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'outputs_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OutputsData _$OutputsDataFromJson(Map<String, dynamic> json) {
  return _OutputsData.fromJson(json);
}

/// @nodoc
mixin _$OutputsData {
  String? get type => throw _privateConstructorUsedError;
  String? get version => throw _privateConstructorUsedError;
  int? get timestamp => throw _privateConstructorUsedError;
  List<OutputsReceiver>? get receivers => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OutputsDataCopyWith<OutputsData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OutputsDataCopyWith<$Res> {
  factory $OutputsDataCopyWith(
          OutputsData value, $Res Function(OutputsData) then) =
      _$OutputsDataCopyWithImpl<$Res, OutputsData>;
  @useResult
  $Res call(
      {String? type,
      String? version,
      int? timestamp,
      List<OutputsReceiver>? receivers});
}

/// @nodoc
class _$OutputsDataCopyWithImpl<$Res, $Val extends OutputsData>
    implements $OutputsDataCopyWith<$Res> {
  _$OutputsDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = freezed,
    Object? version = freezed,
    Object? timestamp = freezed,
    Object? receivers = freezed,
  }) {
    return _then(_value.copyWith(
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      version: freezed == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String?,
      timestamp: freezed == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as int?,
      receivers: freezed == receivers
          ? _value.receivers
          : receivers // ignore: cast_nullable_to_non_nullable
              as List<OutputsReceiver>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OutputsDataImplCopyWith<$Res>
    implements $OutputsDataCopyWith<$Res> {
  factory _$$OutputsDataImplCopyWith(
          _$OutputsDataImpl value, $Res Function(_$OutputsDataImpl) then) =
      __$$OutputsDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? type,
      String? version,
      int? timestamp,
      List<OutputsReceiver>? receivers});
}

/// @nodoc
class __$$OutputsDataImplCopyWithImpl<$Res>
    extends _$OutputsDataCopyWithImpl<$Res, _$OutputsDataImpl>
    implements _$$OutputsDataImplCopyWith<$Res> {
  __$$OutputsDataImplCopyWithImpl(
      _$OutputsDataImpl _value, $Res Function(_$OutputsDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = freezed,
    Object? version = freezed,
    Object? timestamp = freezed,
    Object? receivers = freezed,
  }) {
    return _then(_$OutputsDataImpl(
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      version: freezed == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String?,
      timestamp: freezed == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as int?,
      receivers: freezed == receivers
          ? _value._receivers
          : receivers // ignore: cast_nullable_to_non_nullable
              as List<OutputsReceiver>?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class _$OutputsDataImpl implements _OutputsData {
  const _$OutputsDataImpl(
      {this.type,
      this.version,
      this.timestamp,
      final List<OutputsReceiver>? receivers})
      : _receivers = receivers;

  factory _$OutputsDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$OutputsDataImplFromJson(json);

  @override
  final String? type;
  @override
  final String? version;
  @override
  final int? timestamp;
  final List<OutputsReceiver>? _receivers;
  @override
  List<OutputsReceiver>? get receivers {
    final value = _receivers;
    if (value == null) return null;
    if (_receivers is EqualUnmodifiableListView) return _receivers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'OutputsData(type: $type, version: $version, timestamp: $timestamp, receivers: $receivers)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OutputsDataImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            const DeepCollectionEquality()
                .equals(other._receivers, _receivers));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, type, version, timestamp,
      const DeepCollectionEquality().hash(_receivers));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OutputsDataImplCopyWith<_$OutputsDataImpl> get copyWith =>
      __$$OutputsDataImplCopyWithImpl<_$OutputsDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OutputsDataImplToJson(
      this,
    );
  }
}

abstract class _OutputsData implements OutputsData {
  const factory _OutputsData(
      {final String? type,
      final String? version,
      final int? timestamp,
      final List<OutputsReceiver>? receivers}) = _$OutputsDataImpl;

  factory _OutputsData.fromJson(Map<String, dynamic> json) =
      _$OutputsDataImpl.fromJson;

  @override
  String? get type;
  @override
  String? get version;
  @override
  int? get timestamp;
  @override
  List<OutputsReceiver>? get receivers;
  @override
  @JsonKey(ignore: true)
  _$$OutputsDataImplCopyWith<_$OutputsDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OutputsReceiver _$OutputsReceiverFromJson(Map<String, dynamic> json) {
  return _OutputsReceiver.fromJson(json);
}

/// @nodoc
mixin _$OutputsReceiver {
  String? get address => throw _privateConstructorUsedError;
  @JsonKey(name: 'asset_id')
  String? get assetId => throw _privateConstructorUsedError;
  int? get satoshi => throw _privateConstructorUsedError;
  String? get comment => throw _privateConstructorUsedError;
  int? get account => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OutputsReceiverCopyWith<OutputsReceiver> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OutputsReceiverCopyWith<$Res> {
  factory $OutputsReceiverCopyWith(
          OutputsReceiver value, $Res Function(OutputsReceiver) then) =
      _$OutputsReceiverCopyWithImpl<$Res, OutputsReceiver>;
  @useResult
  $Res call(
      {String? address,
      @JsonKey(name: 'asset_id') String? assetId,
      int? satoshi,
      String? comment,
      int? account});
}

/// @nodoc
class _$OutputsReceiverCopyWithImpl<$Res, $Val extends OutputsReceiver>
    implements $OutputsReceiverCopyWith<$Res> {
  _$OutputsReceiverCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? address = freezed,
    Object? assetId = freezed,
    Object? satoshi = freezed,
    Object? comment = freezed,
    Object? account = freezed,
  }) {
    return _then(_value.copyWith(
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      assetId: freezed == assetId
          ? _value.assetId
          : assetId // ignore: cast_nullable_to_non_nullable
              as String?,
      satoshi: freezed == satoshi
          ? _value.satoshi
          : satoshi // ignore: cast_nullable_to_non_nullable
              as int?,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
      account: freezed == account
          ? _value.account
          : account // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OutputsReceiverImplCopyWith<$Res>
    implements $OutputsReceiverCopyWith<$Res> {
  factory _$$OutputsReceiverImplCopyWith(_$OutputsReceiverImpl value,
          $Res Function(_$OutputsReceiverImpl) then) =
      __$$OutputsReceiverImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? address,
      @JsonKey(name: 'asset_id') String? assetId,
      int? satoshi,
      String? comment,
      int? account});
}

/// @nodoc
class __$$OutputsReceiverImplCopyWithImpl<$Res>
    extends _$OutputsReceiverCopyWithImpl<$Res, _$OutputsReceiverImpl>
    implements _$$OutputsReceiverImplCopyWith<$Res> {
  __$$OutputsReceiverImplCopyWithImpl(
      _$OutputsReceiverImpl _value, $Res Function(_$OutputsReceiverImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? address = freezed,
    Object? assetId = freezed,
    Object? satoshi = freezed,
    Object? comment = freezed,
    Object? account = freezed,
  }) {
    return _then(_$OutputsReceiverImpl(
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      assetId: freezed == assetId
          ? _value.assetId
          : assetId // ignore: cast_nullable_to_non_nullable
              as String?,
      satoshi: freezed == satoshi
          ? _value.satoshi
          : satoshi // ignore: cast_nullable_to_non_nullable
              as int?,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
      account: freezed == account
          ? _value.account
          : account // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class _$OutputsReceiverImpl implements _OutputsReceiver {
  const _$OutputsReceiverImpl(
      {this.address,
      @JsonKey(name: 'asset_id') this.assetId,
      this.satoshi,
      this.comment,
      this.account});

  factory _$OutputsReceiverImpl.fromJson(Map<String, dynamic> json) =>
      _$$OutputsReceiverImplFromJson(json);

  @override
  final String? address;
  @override
  @JsonKey(name: 'asset_id')
  final String? assetId;
  @override
  final int? satoshi;
  @override
  final String? comment;
  @override
  final int? account;

  @override
  String toString() {
    return 'OutputsReceiver(address: $address, assetId: $assetId, satoshi: $satoshi, comment: $comment, account: $account)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OutputsReceiverImpl &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.assetId, assetId) || other.assetId == assetId) &&
            (identical(other.satoshi, satoshi) || other.satoshi == satoshi) &&
            (identical(other.comment, comment) || other.comment == comment) &&
            (identical(other.account, account) || other.account == account));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, address, assetId, satoshi, comment, account);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OutputsReceiverImplCopyWith<_$OutputsReceiverImpl> get copyWith =>
      __$$OutputsReceiverImplCopyWithImpl<_$OutputsReceiverImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OutputsReceiverImplToJson(
      this,
    );
  }
}

abstract class _OutputsReceiver implements OutputsReceiver {
  const factory _OutputsReceiver(
      {final String? address,
      @JsonKey(name: 'asset_id') final String? assetId,
      final int? satoshi,
      final String? comment,
      final int? account}) = _$OutputsReceiverImpl;

  factory _OutputsReceiver.fromJson(Map<String, dynamic> json) =
      _$OutputsReceiverImpl.fromJson;

  @override
  String? get address;
  @override
  @JsonKey(name: 'asset_id')
  String? get assetId;
  @override
  int? get satoshi;
  @override
  String? get comment;
  @override
  int? get account;
  @override
  @JsonKey(ignore: true)
  _$$OutputsReceiverImplCopyWith<_$OutputsReceiverImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$OutputsError {
  String? get message => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? message) wrongTypeOfFile,
    required TResult Function(String? message) wrongVersionOfFile,
    required TResult Function(String? message) jsonFileSyntaxError,
    required TResult Function(String? message) fileStructureError,
    required TResult Function(String? message) operationCancelled,
    required TResult Function(String? message) requiredDataIsEmpty,
    required TResult Function(String? message) outputsDataIsEmpty,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? message)? wrongTypeOfFile,
    TResult? Function(String? message)? wrongVersionOfFile,
    TResult? Function(String? message)? jsonFileSyntaxError,
    TResult? Function(String? message)? fileStructureError,
    TResult? Function(String? message)? operationCancelled,
    TResult? Function(String? message)? requiredDataIsEmpty,
    TResult? Function(String? message)? outputsDataIsEmpty,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? message)? wrongTypeOfFile,
    TResult Function(String? message)? wrongVersionOfFile,
    TResult Function(String? message)? jsonFileSyntaxError,
    TResult Function(String? message)? fileStructureError,
    TResult Function(String? message)? operationCancelled,
    TResult Function(String? message)? requiredDataIsEmpty,
    TResult Function(String? message)? outputsDataIsEmpty,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OutputsErrorWrongTypeOfFile value)
        wrongTypeOfFile,
    required TResult Function(OutputsErrorWrongVersionOfFile value)
        wrongVersionOfFile,
    required TResult Function(OutputsErrorJsonFileSyntaxError value)
        jsonFileSyntaxError,
    required TResult Function(OutputsErrorFileStructureError value)
        fileStructureError,
    required TResult Function(OutputsErrorOperationCancelled value)
        operationCancelled,
    required TResult Function(OutputsErrorRequiredDataIsEmpty value)
        requiredDataIsEmpty,
    required TResult Function(OutputsErrorOutputsDataIsEmpty value)
        outputsDataIsEmpty,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OutputsErrorWrongTypeOfFile value)? wrongTypeOfFile,
    TResult? Function(OutputsErrorWrongVersionOfFile value)? wrongVersionOfFile,
    TResult? Function(OutputsErrorJsonFileSyntaxError value)?
        jsonFileSyntaxError,
    TResult? Function(OutputsErrorFileStructureError value)? fileStructureError,
    TResult? Function(OutputsErrorOperationCancelled value)? operationCancelled,
    TResult? Function(OutputsErrorRequiredDataIsEmpty value)?
        requiredDataIsEmpty,
    TResult? Function(OutputsErrorOutputsDataIsEmpty value)? outputsDataIsEmpty,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OutputsErrorWrongTypeOfFile value)? wrongTypeOfFile,
    TResult Function(OutputsErrorWrongVersionOfFile value)? wrongVersionOfFile,
    TResult Function(OutputsErrorJsonFileSyntaxError value)?
        jsonFileSyntaxError,
    TResult Function(OutputsErrorFileStructureError value)? fileStructureError,
    TResult Function(OutputsErrorOperationCancelled value)? operationCancelled,
    TResult Function(OutputsErrorRequiredDataIsEmpty value)?
        requiredDataIsEmpty,
    TResult Function(OutputsErrorOutputsDataIsEmpty value)? outputsDataIsEmpty,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $OutputsErrorCopyWith<OutputsError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OutputsErrorCopyWith<$Res> {
  factory $OutputsErrorCopyWith(
          OutputsError value, $Res Function(OutputsError) then) =
      _$OutputsErrorCopyWithImpl<$Res, OutputsError>;
  @useResult
  $Res call({String? message});
}

/// @nodoc
class _$OutputsErrorCopyWithImpl<$Res, $Val extends OutputsError>
    implements $OutputsErrorCopyWith<$Res> {
  _$OutputsErrorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_value.copyWith(
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OutputsErrorWrongTypeOfFileImplCopyWith<$Res>
    implements $OutputsErrorCopyWith<$Res> {
  factory _$$OutputsErrorWrongTypeOfFileImplCopyWith(
          _$OutputsErrorWrongTypeOfFileImpl value,
          $Res Function(_$OutputsErrorWrongTypeOfFileImpl) then) =
      __$$OutputsErrorWrongTypeOfFileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? message});
}

/// @nodoc
class __$$OutputsErrorWrongTypeOfFileImplCopyWithImpl<$Res>
    extends _$OutputsErrorCopyWithImpl<$Res, _$OutputsErrorWrongTypeOfFileImpl>
    implements _$$OutputsErrorWrongTypeOfFileImplCopyWith<$Res> {
  __$$OutputsErrorWrongTypeOfFileImplCopyWithImpl(
      _$OutputsErrorWrongTypeOfFileImpl _value,
      $Res Function(_$OutputsErrorWrongTypeOfFileImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_$OutputsErrorWrongTypeOfFileImpl(
      freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$OutputsErrorWrongTypeOfFileImpl implements OutputsErrorWrongTypeOfFile {
  const _$OutputsErrorWrongTypeOfFileImpl([this.message]);

  @override
  final String? message;

  @override
  String toString() {
    return 'OutputsError.wrongTypeOfFile(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OutputsErrorWrongTypeOfFileImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OutputsErrorWrongTypeOfFileImplCopyWith<_$OutputsErrorWrongTypeOfFileImpl>
      get copyWith => __$$OutputsErrorWrongTypeOfFileImplCopyWithImpl<
          _$OutputsErrorWrongTypeOfFileImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? message) wrongTypeOfFile,
    required TResult Function(String? message) wrongVersionOfFile,
    required TResult Function(String? message) jsonFileSyntaxError,
    required TResult Function(String? message) fileStructureError,
    required TResult Function(String? message) operationCancelled,
    required TResult Function(String? message) requiredDataIsEmpty,
    required TResult Function(String? message) outputsDataIsEmpty,
  }) {
    return wrongTypeOfFile(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? message)? wrongTypeOfFile,
    TResult? Function(String? message)? wrongVersionOfFile,
    TResult? Function(String? message)? jsonFileSyntaxError,
    TResult? Function(String? message)? fileStructureError,
    TResult? Function(String? message)? operationCancelled,
    TResult? Function(String? message)? requiredDataIsEmpty,
    TResult? Function(String? message)? outputsDataIsEmpty,
  }) {
    return wrongTypeOfFile?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? message)? wrongTypeOfFile,
    TResult Function(String? message)? wrongVersionOfFile,
    TResult Function(String? message)? jsonFileSyntaxError,
    TResult Function(String? message)? fileStructureError,
    TResult Function(String? message)? operationCancelled,
    TResult Function(String? message)? requiredDataIsEmpty,
    TResult Function(String? message)? outputsDataIsEmpty,
    required TResult orElse(),
  }) {
    if (wrongTypeOfFile != null) {
      return wrongTypeOfFile(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OutputsErrorWrongTypeOfFile value)
        wrongTypeOfFile,
    required TResult Function(OutputsErrorWrongVersionOfFile value)
        wrongVersionOfFile,
    required TResult Function(OutputsErrorJsonFileSyntaxError value)
        jsonFileSyntaxError,
    required TResult Function(OutputsErrorFileStructureError value)
        fileStructureError,
    required TResult Function(OutputsErrorOperationCancelled value)
        operationCancelled,
    required TResult Function(OutputsErrorRequiredDataIsEmpty value)
        requiredDataIsEmpty,
    required TResult Function(OutputsErrorOutputsDataIsEmpty value)
        outputsDataIsEmpty,
  }) {
    return wrongTypeOfFile(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OutputsErrorWrongTypeOfFile value)? wrongTypeOfFile,
    TResult? Function(OutputsErrorWrongVersionOfFile value)? wrongVersionOfFile,
    TResult? Function(OutputsErrorJsonFileSyntaxError value)?
        jsonFileSyntaxError,
    TResult? Function(OutputsErrorFileStructureError value)? fileStructureError,
    TResult? Function(OutputsErrorOperationCancelled value)? operationCancelled,
    TResult? Function(OutputsErrorRequiredDataIsEmpty value)?
        requiredDataIsEmpty,
    TResult? Function(OutputsErrorOutputsDataIsEmpty value)? outputsDataIsEmpty,
  }) {
    return wrongTypeOfFile?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OutputsErrorWrongTypeOfFile value)? wrongTypeOfFile,
    TResult Function(OutputsErrorWrongVersionOfFile value)? wrongVersionOfFile,
    TResult Function(OutputsErrorJsonFileSyntaxError value)?
        jsonFileSyntaxError,
    TResult Function(OutputsErrorFileStructureError value)? fileStructureError,
    TResult Function(OutputsErrorOperationCancelled value)? operationCancelled,
    TResult Function(OutputsErrorRequiredDataIsEmpty value)?
        requiredDataIsEmpty,
    TResult Function(OutputsErrorOutputsDataIsEmpty value)? outputsDataIsEmpty,
    required TResult orElse(),
  }) {
    if (wrongTypeOfFile != null) {
      return wrongTypeOfFile(this);
    }
    return orElse();
  }
}

abstract class OutputsErrorWrongTypeOfFile implements OutputsError {
  const factory OutputsErrorWrongTypeOfFile([final String? message]) =
      _$OutputsErrorWrongTypeOfFileImpl;

  @override
  String? get message;
  @override
  @JsonKey(ignore: true)
  _$$OutputsErrorWrongTypeOfFileImplCopyWith<_$OutputsErrorWrongTypeOfFileImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$OutputsErrorWrongVersionOfFileImplCopyWith<$Res>
    implements $OutputsErrorCopyWith<$Res> {
  factory _$$OutputsErrorWrongVersionOfFileImplCopyWith(
          _$OutputsErrorWrongVersionOfFileImpl value,
          $Res Function(_$OutputsErrorWrongVersionOfFileImpl) then) =
      __$$OutputsErrorWrongVersionOfFileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? message});
}

/// @nodoc
class __$$OutputsErrorWrongVersionOfFileImplCopyWithImpl<$Res>
    extends _$OutputsErrorCopyWithImpl<$Res,
        _$OutputsErrorWrongVersionOfFileImpl>
    implements _$$OutputsErrorWrongVersionOfFileImplCopyWith<$Res> {
  __$$OutputsErrorWrongVersionOfFileImplCopyWithImpl(
      _$OutputsErrorWrongVersionOfFileImpl _value,
      $Res Function(_$OutputsErrorWrongVersionOfFileImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_$OutputsErrorWrongVersionOfFileImpl(
      freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$OutputsErrorWrongVersionOfFileImpl
    implements OutputsErrorWrongVersionOfFile {
  const _$OutputsErrorWrongVersionOfFileImpl([this.message]);

  @override
  final String? message;

  @override
  String toString() {
    return 'OutputsError.wrongVersionOfFile(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OutputsErrorWrongVersionOfFileImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OutputsErrorWrongVersionOfFileImplCopyWith<
          _$OutputsErrorWrongVersionOfFileImpl>
      get copyWith => __$$OutputsErrorWrongVersionOfFileImplCopyWithImpl<
          _$OutputsErrorWrongVersionOfFileImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? message) wrongTypeOfFile,
    required TResult Function(String? message) wrongVersionOfFile,
    required TResult Function(String? message) jsonFileSyntaxError,
    required TResult Function(String? message) fileStructureError,
    required TResult Function(String? message) operationCancelled,
    required TResult Function(String? message) requiredDataIsEmpty,
    required TResult Function(String? message) outputsDataIsEmpty,
  }) {
    return wrongVersionOfFile(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? message)? wrongTypeOfFile,
    TResult? Function(String? message)? wrongVersionOfFile,
    TResult? Function(String? message)? jsonFileSyntaxError,
    TResult? Function(String? message)? fileStructureError,
    TResult? Function(String? message)? operationCancelled,
    TResult? Function(String? message)? requiredDataIsEmpty,
    TResult? Function(String? message)? outputsDataIsEmpty,
  }) {
    return wrongVersionOfFile?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? message)? wrongTypeOfFile,
    TResult Function(String? message)? wrongVersionOfFile,
    TResult Function(String? message)? jsonFileSyntaxError,
    TResult Function(String? message)? fileStructureError,
    TResult Function(String? message)? operationCancelled,
    TResult Function(String? message)? requiredDataIsEmpty,
    TResult Function(String? message)? outputsDataIsEmpty,
    required TResult orElse(),
  }) {
    if (wrongVersionOfFile != null) {
      return wrongVersionOfFile(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OutputsErrorWrongTypeOfFile value)
        wrongTypeOfFile,
    required TResult Function(OutputsErrorWrongVersionOfFile value)
        wrongVersionOfFile,
    required TResult Function(OutputsErrorJsonFileSyntaxError value)
        jsonFileSyntaxError,
    required TResult Function(OutputsErrorFileStructureError value)
        fileStructureError,
    required TResult Function(OutputsErrorOperationCancelled value)
        operationCancelled,
    required TResult Function(OutputsErrorRequiredDataIsEmpty value)
        requiredDataIsEmpty,
    required TResult Function(OutputsErrorOutputsDataIsEmpty value)
        outputsDataIsEmpty,
  }) {
    return wrongVersionOfFile(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OutputsErrorWrongTypeOfFile value)? wrongTypeOfFile,
    TResult? Function(OutputsErrorWrongVersionOfFile value)? wrongVersionOfFile,
    TResult? Function(OutputsErrorJsonFileSyntaxError value)?
        jsonFileSyntaxError,
    TResult? Function(OutputsErrorFileStructureError value)? fileStructureError,
    TResult? Function(OutputsErrorOperationCancelled value)? operationCancelled,
    TResult? Function(OutputsErrorRequiredDataIsEmpty value)?
        requiredDataIsEmpty,
    TResult? Function(OutputsErrorOutputsDataIsEmpty value)? outputsDataIsEmpty,
  }) {
    return wrongVersionOfFile?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OutputsErrorWrongTypeOfFile value)? wrongTypeOfFile,
    TResult Function(OutputsErrorWrongVersionOfFile value)? wrongVersionOfFile,
    TResult Function(OutputsErrorJsonFileSyntaxError value)?
        jsonFileSyntaxError,
    TResult Function(OutputsErrorFileStructureError value)? fileStructureError,
    TResult Function(OutputsErrorOperationCancelled value)? operationCancelled,
    TResult Function(OutputsErrorRequiredDataIsEmpty value)?
        requiredDataIsEmpty,
    TResult Function(OutputsErrorOutputsDataIsEmpty value)? outputsDataIsEmpty,
    required TResult orElse(),
  }) {
    if (wrongVersionOfFile != null) {
      return wrongVersionOfFile(this);
    }
    return orElse();
  }
}

abstract class OutputsErrorWrongVersionOfFile implements OutputsError {
  const factory OutputsErrorWrongVersionOfFile([final String? message]) =
      _$OutputsErrorWrongVersionOfFileImpl;

  @override
  String? get message;
  @override
  @JsonKey(ignore: true)
  _$$OutputsErrorWrongVersionOfFileImplCopyWith<
          _$OutputsErrorWrongVersionOfFileImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$OutputsErrorJsonFileSyntaxErrorImplCopyWith<$Res>
    implements $OutputsErrorCopyWith<$Res> {
  factory _$$OutputsErrorJsonFileSyntaxErrorImplCopyWith(
          _$OutputsErrorJsonFileSyntaxErrorImpl value,
          $Res Function(_$OutputsErrorJsonFileSyntaxErrorImpl) then) =
      __$$OutputsErrorJsonFileSyntaxErrorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? message});
}

/// @nodoc
class __$$OutputsErrorJsonFileSyntaxErrorImplCopyWithImpl<$Res>
    extends _$OutputsErrorCopyWithImpl<$Res,
        _$OutputsErrorJsonFileSyntaxErrorImpl>
    implements _$$OutputsErrorJsonFileSyntaxErrorImplCopyWith<$Res> {
  __$$OutputsErrorJsonFileSyntaxErrorImplCopyWithImpl(
      _$OutputsErrorJsonFileSyntaxErrorImpl _value,
      $Res Function(_$OutputsErrorJsonFileSyntaxErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_$OutputsErrorJsonFileSyntaxErrorImpl(
      freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$OutputsErrorJsonFileSyntaxErrorImpl
    implements OutputsErrorJsonFileSyntaxError {
  const _$OutputsErrorJsonFileSyntaxErrorImpl([this.message]);

  @override
  final String? message;

  @override
  String toString() {
    return 'OutputsError.jsonFileSyntaxError(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OutputsErrorJsonFileSyntaxErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OutputsErrorJsonFileSyntaxErrorImplCopyWith<
          _$OutputsErrorJsonFileSyntaxErrorImpl>
      get copyWith => __$$OutputsErrorJsonFileSyntaxErrorImplCopyWithImpl<
          _$OutputsErrorJsonFileSyntaxErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? message) wrongTypeOfFile,
    required TResult Function(String? message) wrongVersionOfFile,
    required TResult Function(String? message) jsonFileSyntaxError,
    required TResult Function(String? message) fileStructureError,
    required TResult Function(String? message) operationCancelled,
    required TResult Function(String? message) requiredDataIsEmpty,
    required TResult Function(String? message) outputsDataIsEmpty,
  }) {
    return jsonFileSyntaxError(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? message)? wrongTypeOfFile,
    TResult? Function(String? message)? wrongVersionOfFile,
    TResult? Function(String? message)? jsonFileSyntaxError,
    TResult? Function(String? message)? fileStructureError,
    TResult? Function(String? message)? operationCancelled,
    TResult? Function(String? message)? requiredDataIsEmpty,
    TResult? Function(String? message)? outputsDataIsEmpty,
  }) {
    return jsonFileSyntaxError?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? message)? wrongTypeOfFile,
    TResult Function(String? message)? wrongVersionOfFile,
    TResult Function(String? message)? jsonFileSyntaxError,
    TResult Function(String? message)? fileStructureError,
    TResult Function(String? message)? operationCancelled,
    TResult Function(String? message)? requiredDataIsEmpty,
    TResult Function(String? message)? outputsDataIsEmpty,
    required TResult orElse(),
  }) {
    if (jsonFileSyntaxError != null) {
      return jsonFileSyntaxError(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OutputsErrorWrongTypeOfFile value)
        wrongTypeOfFile,
    required TResult Function(OutputsErrorWrongVersionOfFile value)
        wrongVersionOfFile,
    required TResult Function(OutputsErrorJsonFileSyntaxError value)
        jsonFileSyntaxError,
    required TResult Function(OutputsErrorFileStructureError value)
        fileStructureError,
    required TResult Function(OutputsErrorOperationCancelled value)
        operationCancelled,
    required TResult Function(OutputsErrorRequiredDataIsEmpty value)
        requiredDataIsEmpty,
    required TResult Function(OutputsErrorOutputsDataIsEmpty value)
        outputsDataIsEmpty,
  }) {
    return jsonFileSyntaxError(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OutputsErrorWrongTypeOfFile value)? wrongTypeOfFile,
    TResult? Function(OutputsErrorWrongVersionOfFile value)? wrongVersionOfFile,
    TResult? Function(OutputsErrorJsonFileSyntaxError value)?
        jsonFileSyntaxError,
    TResult? Function(OutputsErrorFileStructureError value)? fileStructureError,
    TResult? Function(OutputsErrorOperationCancelled value)? operationCancelled,
    TResult? Function(OutputsErrorRequiredDataIsEmpty value)?
        requiredDataIsEmpty,
    TResult? Function(OutputsErrorOutputsDataIsEmpty value)? outputsDataIsEmpty,
  }) {
    return jsonFileSyntaxError?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OutputsErrorWrongTypeOfFile value)? wrongTypeOfFile,
    TResult Function(OutputsErrorWrongVersionOfFile value)? wrongVersionOfFile,
    TResult Function(OutputsErrorJsonFileSyntaxError value)?
        jsonFileSyntaxError,
    TResult Function(OutputsErrorFileStructureError value)? fileStructureError,
    TResult Function(OutputsErrorOperationCancelled value)? operationCancelled,
    TResult Function(OutputsErrorRequiredDataIsEmpty value)?
        requiredDataIsEmpty,
    TResult Function(OutputsErrorOutputsDataIsEmpty value)? outputsDataIsEmpty,
    required TResult orElse(),
  }) {
    if (jsonFileSyntaxError != null) {
      return jsonFileSyntaxError(this);
    }
    return orElse();
  }
}

abstract class OutputsErrorJsonFileSyntaxError implements OutputsError {
  const factory OutputsErrorJsonFileSyntaxError([final String? message]) =
      _$OutputsErrorJsonFileSyntaxErrorImpl;

  @override
  String? get message;
  @override
  @JsonKey(ignore: true)
  _$$OutputsErrorJsonFileSyntaxErrorImplCopyWith<
          _$OutputsErrorJsonFileSyntaxErrorImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$OutputsErrorFileStructureErrorImplCopyWith<$Res>
    implements $OutputsErrorCopyWith<$Res> {
  factory _$$OutputsErrorFileStructureErrorImplCopyWith(
          _$OutputsErrorFileStructureErrorImpl value,
          $Res Function(_$OutputsErrorFileStructureErrorImpl) then) =
      __$$OutputsErrorFileStructureErrorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? message});
}

/// @nodoc
class __$$OutputsErrorFileStructureErrorImplCopyWithImpl<$Res>
    extends _$OutputsErrorCopyWithImpl<$Res,
        _$OutputsErrorFileStructureErrorImpl>
    implements _$$OutputsErrorFileStructureErrorImplCopyWith<$Res> {
  __$$OutputsErrorFileStructureErrorImplCopyWithImpl(
      _$OutputsErrorFileStructureErrorImpl _value,
      $Res Function(_$OutputsErrorFileStructureErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_$OutputsErrorFileStructureErrorImpl(
      freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$OutputsErrorFileStructureErrorImpl
    implements OutputsErrorFileStructureError {
  const _$OutputsErrorFileStructureErrorImpl([this.message]);

  @override
  final String? message;

  @override
  String toString() {
    return 'OutputsError.fileStructureError(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OutputsErrorFileStructureErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OutputsErrorFileStructureErrorImplCopyWith<
          _$OutputsErrorFileStructureErrorImpl>
      get copyWith => __$$OutputsErrorFileStructureErrorImplCopyWithImpl<
          _$OutputsErrorFileStructureErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? message) wrongTypeOfFile,
    required TResult Function(String? message) wrongVersionOfFile,
    required TResult Function(String? message) jsonFileSyntaxError,
    required TResult Function(String? message) fileStructureError,
    required TResult Function(String? message) operationCancelled,
    required TResult Function(String? message) requiredDataIsEmpty,
    required TResult Function(String? message) outputsDataIsEmpty,
  }) {
    return fileStructureError(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? message)? wrongTypeOfFile,
    TResult? Function(String? message)? wrongVersionOfFile,
    TResult? Function(String? message)? jsonFileSyntaxError,
    TResult? Function(String? message)? fileStructureError,
    TResult? Function(String? message)? operationCancelled,
    TResult? Function(String? message)? requiredDataIsEmpty,
    TResult? Function(String? message)? outputsDataIsEmpty,
  }) {
    return fileStructureError?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? message)? wrongTypeOfFile,
    TResult Function(String? message)? wrongVersionOfFile,
    TResult Function(String? message)? jsonFileSyntaxError,
    TResult Function(String? message)? fileStructureError,
    TResult Function(String? message)? operationCancelled,
    TResult Function(String? message)? requiredDataIsEmpty,
    TResult Function(String? message)? outputsDataIsEmpty,
    required TResult orElse(),
  }) {
    if (fileStructureError != null) {
      return fileStructureError(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OutputsErrorWrongTypeOfFile value)
        wrongTypeOfFile,
    required TResult Function(OutputsErrorWrongVersionOfFile value)
        wrongVersionOfFile,
    required TResult Function(OutputsErrorJsonFileSyntaxError value)
        jsonFileSyntaxError,
    required TResult Function(OutputsErrorFileStructureError value)
        fileStructureError,
    required TResult Function(OutputsErrorOperationCancelled value)
        operationCancelled,
    required TResult Function(OutputsErrorRequiredDataIsEmpty value)
        requiredDataIsEmpty,
    required TResult Function(OutputsErrorOutputsDataIsEmpty value)
        outputsDataIsEmpty,
  }) {
    return fileStructureError(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OutputsErrorWrongTypeOfFile value)? wrongTypeOfFile,
    TResult? Function(OutputsErrorWrongVersionOfFile value)? wrongVersionOfFile,
    TResult? Function(OutputsErrorJsonFileSyntaxError value)?
        jsonFileSyntaxError,
    TResult? Function(OutputsErrorFileStructureError value)? fileStructureError,
    TResult? Function(OutputsErrorOperationCancelled value)? operationCancelled,
    TResult? Function(OutputsErrorRequiredDataIsEmpty value)?
        requiredDataIsEmpty,
    TResult? Function(OutputsErrorOutputsDataIsEmpty value)? outputsDataIsEmpty,
  }) {
    return fileStructureError?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OutputsErrorWrongTypeOfFile value)? wrongTypeOfFile,
    TResult Function(OutputsErrorWrongVersionOfFile value)? wrongVersionOfFile,
    TResult Function(OutputsErrorJsonFileSyntaxError value)?
        jsonFileSyntaxError,
    TResult Function(OutputsErrorFileStructureError value)? fileStructureError,
    TResult Function(OutputsErrorOperationCancelled value)? operationCancelled,
    TResult Function(OutputsErrorRequiredDataIsEmpty value)?
        requiredDataIsEmpty,
    TResult Function(OutputsErrorOutputsDataIsEmpty value)? outputsDataIsEmpty,
    required TResult orElse(),
  }) {
    if (fileStructureError != null) {
      return fileStructureError(this);
    }
    return orElse();
  }
}

abstract class OutputsErrorFileStructureError implements OutputsError {
  const factory OutputsErrorFileStructureError([final String? message]) =
      _$OutputsErrorFileStructureErrorImpl;

  @override
  String? get message;
  @override
  @JsonKey(ignore: true)
  _$$OutputsErrorFileStructureErrorImplCopyWith<
          _$OutputsErrorFileStructureErrorImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$OutputsErrorOperationCancelledImplCopyWith<$Res>
    implements $OutputsErrorCopyWith<$Res> {
  factory _$$OutputsErrorOperationCancelledImplCopyWith(
          _$OutputsErrorOperationCancelledImpl value,
          $Res Function(_$OutputsErrorOperationCancelledImpl) then) =
      __$$OutputsErrorOperationCancelledImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? message});
}

/// @nodoc
class __$$OutputsErrorOperationCancelledImplCopyWithImpl<$Res>
    extends _$OutputsErrorCopyWithImpl<$Res,
        _$OutputsErrorOperationCancelledImpl>
    implements _$$OutputsErrorOperationCancelledImplCopyWith<$Res> {
  __$$OutputsErrorOperationCancelledImplCopyWithImpl(
      _$OutputsErrorOperationCancelledImpl _value,
      $Res Function(_$OutputsErrorOperationCancelledImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_$OutputsErrorOperationCancelledImpl(
      freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$OutputsErrorOperationCancelledImpl
    implements OutputsErrorOperationCancelled {
  const _$OutputsErrorOperationCancelledImpl([this.message]);

  @override
  final String? message;

  @override
  String toString() {
    return 'OutputsError.operationCancelled(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OutputsErrorOperationCancelledImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OutputsErrorOperationCancelledImplCopyWith<
          _$OutputsErrorOperationCancelledImpl>
      get copyWith => __$$OutputsErrorOperationCancelledImplCopyWithImpl<
          _$OutputsErrorOperationCancelledImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? message) wrongTypeOfFile,
    required TResult Function(String? message) wrongVersionOfFile,
    required TResult Function(String? message) jsonFileSyntaxError,
    required TResult Function(String? message) fileStructureError,
    required TResult Function(String? message) operationCancelled,
    required TResult Function(String? message) requiredDataIsEmpty,
    required TResult Function(String? message) outputsDataIsEmpty,
  }) {
    return operationCancelled(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? message)? wrongTypeOfFile,
    TResult? Function(String? message)? wrongVersionOfFile,
    TResult? Function(String? message)? jsonFileSyntaxError,
    TResult? Function(String? message)? fileStructureError,
    TResult? Function(String? message)? operationCancelled,
    TResult? Function(String? message)? requiredDataIsEmpty,
    TResult? Function(String? message)? outputsDataIsEmpty,
  }) {
    return operationCancelled?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? message)? wrongTypeOfFile,
    TResult Function(String? message)? wrongVersionOfFile,
    TResult Function(String? message)? jsonFileSyntaxError,
    TResult Function(String? message)? fileStructureError,
    TResult Function(String? message)? operationCancelled,
    TResult Function(String? message)? requiredDataIsEmpty,
    TResult Function(String? message)? outputsDataIsEmpty,
    required TResult orElse(),
  }) {
    if (operationCancelled != null) {
      return operationCancelled(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OutputsErrorWrongTypeOfFile value)
        wrongTypeOfFile,
    required TResult Function(OutputsErrorWrongVersionOfFile value)
        wrongVersionOfFile,
    required TResult Function(OutputsErrorJsonFileSyntaxError value)
        jsonFileSyntaxError,
    required TResult Function(OutputsErrorFileStructureError value)
        fileStructureError,
    required TResult Function(OutputsErrorOperationCancelled value)
        operationCancelled,
    required TResult Function(OutputsErrorRequiredDataIsEmpty value)
        requiredDataIsEmpty,
    required TResult Function(OutputsErrorOutputsDataIsEmpty value)
        outputsDataIsEmpty,
  }) {
    return operationCancelled(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OutputsErrorWrongTypeOfFile value)? wrongTypeOfFile,
    TResult? Function(OutputsErrorWrongVersionOfFile value)? wrongVersionOfFile,
    TResult? Function(OutputsErrorJsonFileSyntaxError value)?
        jsonFileSyntaxError,
    TResult? Function(OutputsErrorFileStructureError value)? fileStructureError,
    TResult? Function(OutputsErrorOperationCancelled value)? operationCancelled,
    TResult? Function(OutputsErrorRequiredDataIsEmpty value)?
        requiredDataIsEmpty,
    TResult? Function(OutputsErrorOutputsDataIsEmpty value)? outputsDataIsEmpty,
  }) {
    return operationCancelled?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OutputsErrorWrongTypeOfFile value)? wrongTypeOfFile,
    TResult Function(OutputsErrorWrongVersionOfFile value)? wrongVersionOfFile,
    TResult Function(OutputsErrorJsonFileSyntaxError value)?
        jsonFileSyntaxError,
    TResult Function(OutputsErrorFileStructureError value)? fileStructureError,
    TResult Function(OutputsErrorOperationCancelled value)? operationCancelled,
    TResult Function(OutputsErrorRequiredDataIsEmpty value)?
        requiredDataIsEmpty,
    TResult Function(OutputsErrorOutputsDataIsEmpty value)? outputsDataIsEmpty,
    required TResult orElse(),
  }) {
    if (operationCancelled != null) {
      return operationCancelled(this);
    }
    return orElse();
  }
}

abstract class OutputsErrorOperationCancelled implements OutputsError {
  const factory OutputsErrorOperationCancelled([final String? message]) =
      _$OutputsErrorOperationCancelledImpl;

  @override
  String? get message;
  @override
  @JsonKey(ignore: true)
  _$$OutputsErrorOperationCancelledImplCopyWith<
          _$OutputsErrorOperationCancelledImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$OutputsErrorRequiredDataIsEmptyImplCopyWith<$Res>
    implements $OutputsErrorCopyWith<$Res> {
  factory _$$OutputsErrorRequiredDataIsEmptyImplCopyWith(
          _$OutputsErrorRequiredDataIsEmptyImpl value,
          $Res Function(_$OutputsErrorRequiredDataIsEmptyImpl) then) =
      __$$OutputsErrorRequiredDataIsEmptyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? message});
}

/// @nodoc
class __$$OutputsErrorRequiredDataIsEmptyImplCopyWithImpl<$Res>
    extends _$OutputsErrorCopyWithImpl<$Res,
        _$OutputsErrorRequiredDataIsEmptyImpl>
    implements _$$OutputsErrorRequiredDataIsEmptyImplCopyWith<$Res> {
  __$$OutputsErrorRequiredDataIsEmptyImplCopyWithImpl(
      _$OutputsErrorRequiredDataIsEmptyImpl _value,
      $Res Function(_$OutputsErrorRequiredDataIsEmptyImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_$OutputsErrorRequiredDataIsEmptyImpl(
      freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$OutputsErrorRequiredDataIsEmptyImpl
    implements OutputsErrorRequiredDataIsEmpty {
  const _$OutputsErrorRequiredDataIsEmptyImpl([this.message]);

  @override
  final String? message;

  @override
  String toString() {
    return 'OutputsError.requiredDataIsEmpty(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OutputsErrorRequiredDataIsEmptyImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OutputsErrorRequiredDataIsEmptyImplCopyWith<
          _$OutputsErrorRequiredDataIsEmptyImpl>
      get copyWith => __$$OutputsErrorRequiredDataIsEmptyImplCopyWithImpl<
          _$OutputsErrorRequiredDataIsEmptyImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? message) wrongTypeOfFile,
    required TResult Function(String? message) wrongVersionOfFile,
    required TResult Function(String? message) jsonFileSyntaxError,
    required TResult Function(String? message) fileStructureError,
    required TResult Function(String? message) operationCancelled,
    required TResult Function(String? message) requiredDataIsEmpty,
    required TResult Function(String? message) outputsDataIsEmpty,
  }) {
    return requiredDataIsEmpty(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? message)? wrongTypeOfFile,
    TResult? Function(String? message)? wrongVersionOfFile,
    TResult? Function(String? message)? jsonFileSyntaxError,
    TResult? Function(String? message)? fileStructureError,
    TResult? Function(String? message)? operationCancelled,
    TResult? Function(String? message)? requiredDataIsEmpty,
    TResult? Function(String? message)? outputsDataIsEmpty,
  }) {
    return requiredDataIsEmpty?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? message)? wrongTypeOfFile,
    TResult Function(String? message)? wrongVersionOfFile,
    TResult Function(String? message)? jsonFileSyntaxError,
    TResult Function(String? message)? fileStructureError,
    TResult Function(String? message)? operationCancelled,
    TResult Function(String? message)? requiredDataIsEmpty,
    TResult Function(String? message)? outputsDataIsEmpty,
    required TResult orElse(),
  }) {
    if (requiredDataIsEmpty != null) {
      return requiredDataIsEmpty(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OutputsErrorWrongTypeOfFile value)
        wrongTypeOfFile,
    required TResult Function(OutputsErrorWrongVersionOfFile value)
        wrongVersionOfFile,
    required TResult Function(OutputsErrorJsonFileSyntaxError value)
        jsonFileSyntaxError,
    required TResult Function(OutputsErrorFileStructureError value)
        fileStructureError,
    required TResult Function(OutputsErrorOperationCancelled value)
        operationCancelled,
    required TResult Function(OutputsErrorRequiredDataIsEmpty value)
        requiredDataIsEmpty,
    required TResult Function(OutputsErrorOutputsDataIsEmpty value)
        outputsDataIsEmpty,
  }) {
    return requiredDataIsEmpty(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OutputsErrorWrongTypeOfFile value)? wrongTypeOfFile,
    TResult? Function(OutputsErrorWrongVersionOfFile value)? wrongVersionOfFile,
    TResult? Function(OutputsErrorJsonFileSyntaxError value)?
        jsonFileSyntaxError,
    TResult? Function(OutputsErrorFileStructureError value)? fileStructureError,
    TResult? Function(OutputsErrorOperationCancelled value)? operationCancelled,
    TResult? Function(OutputsErrorRequiredDataIsEmpty value)?
        requiredDataIsEmpty,
    TResult? Function(OutputsErrorOutputsDataIsEmpty value)? outputsDataIsEmpty,
  }) {
    return requiredDataIsEmpty?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OutputsErrorWrongTypeOfFile value)? wrongTypeOfFile,
    TResult Function(OutputsErrorWrongVersionOfFile value)? wrongVersionOfFile,
    TResult Function(OutputsErrorJsonFileSyntaxError value)?
        jsonFileSyntaxError,
    TResult Function(OutputsErrorFileStructureError value)? fileStructureError,
    TResult Function(OutputsErrorOperationCancelled value)? operationCancelled,
    TResult Function(OutputsErrorRequiredDataIsEmpty value)?
        requiredDataIsEmpty,
    TResult Function(OutputsErrorOutputsDataIsEmpty value)? outputsDataIsEmpty,
    required TResult orElse(),
  }) {
    if (requiredDataIsEmpty != null) {
      return requiredDataIsEmpty(this);
    }
    return orElse();
  }
}

abstract class OutputsErrorRequiredDataIsEmpty implements OutputsError {
  const factory OutputsErrorRequiredDataIsEmpty([final String? message]) =
      _$OutputsErrorRequiredDataIsEmptyImpl;

  @override
  String? get message;
  @override
  @JsonKey(ignore: true)
  _$$OutputsErrorRequiredDataIsEmptyImplCopyWith<
          _$OutputsErrorRequiredDataIsEmptyImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$OutputsErrorOutputsDataIsEmptyImplCopyWith<$Res>
    implements $OutputsErrorCopyWith<$Res> {
  factory _$$OutputsErrorOutputsDataIsEmptyImplCopyWith(
          _$OutputsErrorOutputsDataIsEmptyImpl value,
          $Res Function(_$OutputsErrorOutputsDataIsEmptyImpl) then) =
      __$$OutputsErrorOutputsDataIsEmptyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? message});
}

/// @nodoc
class __$$OutputsErrorOutputsDataIsEmptyImplCopyWithImpl<$Res>
    extends _$OutputsErrorCopyWithImpl<$Res,
        _$OutputsErrorOutputsDataIsEmptyImpl>
    implements _$$OutputsErrorOutputsDataIsEmptyImplCopyWith<$Res> {
  __$$OutputsErrorOutputsDataIsEmptyImplCopyWithImpl(
      _$OutputsErrorOutputsDataIsEmptyImpl _value,
      $Res Function(_$OutputsErrorOutputsDataIsEmptyImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_$OutputsErrorOutputsDataIsEmptyImpl(
      freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$OutputsErrorOutputsDataIsEmptyImpl
    implements OutputsErrorOutputsDataIsEmpty {
  const _$OutputsErrorOutputsDataIsEmptyImpl([this.message]);

  @override
  final String? message;

  @override
  String toString() {
    return 'OutputsError.outputsDataIsEmpty(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OutputsErrorOutputsDataIsEmptyImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OutputsErrorOutputsDataIsEmptyImplCopyWith<
          _$OutputsErrorOutputsDataIsEmptyImpl>
      get copyWith => __$$OutputsErrorOutputsDataIsEmptyImplCopyWithImpl<
          _$OutputsErrorOutputsDataIsEmptyImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? message) wrongTypeOfFile,
    required TResult Function(String? message) wrongVersionOfFile,
    required TResult Function(String? message) jsonFileSyntaxError,
    required TResult Function(String? message) fileStructureError,
    required TResult Function(String? message) operationCancelled,
    required TResult Function(String? message) requiredDataIsEmpty,
    required TResult Function(String? message) outputsDataIsEmpty,
  }) {
    return outputsDataIsEmpty(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? message)? wrongTypeOfFile,
    TResult? Function(String? message)? wrongVersionOfFile,
    TResult? Function(String? message)? jsonFileSyntaxError,
    TResult? Function(String? message)? fileStructureError,
    TResult? Function(String? message)? operationCancelled,
    TResult? Function(String? message)? requiredDataIsEmpty,
    TResult? Function(String? message)? outputsDataIsEmpty,
  }) {
    return outputsDataIsEmpty?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? message)? wrongTypeOfFile,
    TResult Function(String? message)? wrongVersionOfFile,
    TResult Function(String? message)? jsonFileSyntaxError,
    TResult Function(String? message)? fileStructureError,
    TResult Function(String? message)? operationCancelled,
    TResult Function(String? message)? requiredDataIsEmpty,
    TResult Function(String? message)? outputsDataIsEmpty,
    required TResult orElse(),
  }) {
    if (outputsDataIsEmpty != null) {
      return outputsDataIsEmpty(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OutputsErrorWrongTypeOfFile value)
        wrongTypeOfFile,
    required TResult Function(OutputsErrorWrongVersionOfFile value)
        wrongVersionOfFile,
    required TResult Function(OutputsErrorJsonFileSyntaxError value)
        jsonFileSyntaxError,
    required TResult Function(OutputsErrorFileStructureError value)
        fileStructureError,
    required TResult Function(OutputsErrorOperationCancelled value)
        operationCancelled,
    required TResult Function(OutputsErrorRequiredDataIsEmpty value)
        requiredDataIsEmpty,
    required TResult Function(OutputsErrorOutputsDataIsEmpty value)
        outputsDataIsEmpty,
  }) {
    return outputsDataIsEmpty(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OutputsErrorWrongTypeOfFile value)? wrongTypeOfFile,
    TResult? Function(OutputsErrorWrongVersionOfFile value)? wrongVersionOfFile,
    TResult? Function(OutputsErrorJsonFileSyntaxError value)?
        jsonFileSyntaxError,
    TResult? Function(OutputsErrorFileStructureError value)? fileStructureError,
    TResult? Function(OutputsErrorOperationCancelled value)? operationCancelled,
    TResult? Function(OutputsErrorRequiredDataIsEmpty value)?
        requiredDataIsEmpty,
    TResult? Function(OutputsErrorOutputsDataIsEmpty value)? outputsDataIsEmpty,
  }) {
    return outputsDataIsEmpty?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OutputsErrorWrongTypeOfFile value)? wrongTypeOfFile,
    TResult Function(OutputsErrorWrongVersionOfFile value)? wrongVersionOfFile,
    TResult Function(OutputsErrorJsonFileSyntaxError value)?
        jsonFileSyntaxError,
    TResult Function(OutputsErrorFileStructureError value)? fileStructureError,
    TResult Function(OutputsErrorOperationCancelled value)? operationCancelled,
    TResult Function(OutputsErrorRequiredDataIsEmpty value)?
        requiredDataIsEmpty,
    TResult Function(OutputsErrorOutputsDataIsEmpty value)? outputsDataIsEmpty,
    required TResult orElse(),
  }) {
    if (outputsDataIsEmpty != null) {
      return outputsDataIsEmpty(this);
    }
    return orElse();
  }
}

abstract class OutputsErrorOutputsDataIsEmpty implements OutputsError {
  const factory OutputsErrorOutputsDataIsEmpty([final String? message]) =
      _$OutputsErrorOutputsDataIsEmptyImpl;

  @override
  String? get message;
  @override
  @JsonKey(ignore: true)
  _$$OutputsErrorOutputsDataIsEmptyImplCopyWith<
          _$OutputsErrorOutputsDataIsEmptyImpl>
      get copyWith => throw _privateConstructorUsedError;
}
