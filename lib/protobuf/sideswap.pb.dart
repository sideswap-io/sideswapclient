///
//  Generated code. Do not modify.
//  source: sideswap.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'sideswap.pbenum.dart';

export 'sideswap.pbenum.dart';

class Empty extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Empty', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  Empty._() : super();
  factory Empty() => create();
  factory Empty.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Empty.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Empty clone() => Empty()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Empty copyWith(void Function(Empty) updates) => super.copyWith((message) => updates(message as Empty)) as Empty; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Empty create() => Empty._();
  Empty createEmptyInstance() => create();
  static $pb.PbList<Empty> createRepeated() => $pb.PbList<Empty>();
  @$core.pragma('dart2js:noInline')
  static Empty getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Empty>(create);
  static Empty? _defaultInstance;
}

class Account extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Account', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id', $pb.PbFieldType.Q3)
  ;

  Account._() : super();
  factory Account({
    $core.int? id,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    return _result;
  }
  factory Account.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Account.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Account clone() => Account()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Account copyWith(void Function(Account) updates) => super.copyWith((message) => updates(message as Account)) as Account; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Account create() => Account._();
  Account createEmptyInstance() => create();
  static $pb.PbList<Account> createRepeated() => $pb.PbList<Account>();
  @$core.pragma('dart2js:noInline')
  static Account getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Account>(create);
  static Account? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);
}

class Address extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Address', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'addr')
  ;

  Address._() : super();
  factory Address({
    $core.String? addr,
  }) {
    final _result = create();
    if (addr != null) {
      _result.addr = addr;
    }
    return _result;
  }
  factory Address.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Address.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Address clone() => Address()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Address copyWith(void Function(Address) updates) => super.copyWith((message) => updates(message as Address)) as Address; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Address create() => Address._();
  Address createEmptyInstance() => create();
  static $pb.PbList<Address> createRepeated() => $pb.PbList<Address>();
  @$core.pragma('dart2js:noInline')
  static Address getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Address>(create);
  static Address? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get addr => $_getSZ(0);
  @$pb.TagNumber(1)
  set addr($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAddr() => $_has(0);
  @$pb.TagNumber(1)
  void clearAddr() => clearField(1);
}

class AddressAmount extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'AddressAmount', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'address')
    ..a<$fixnum.Int64>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'amount', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aQS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'assetId')
  ;

  AddressAmount._() : super();
  factory AddressAmount({
    $core.String? address,
    $fixnum.Int64? amount,
    $core.String? assetId,
  }) {
    final _result = create();
    if (address != null) {
      _result.address = address;
    }
    if (amount != null) {
      _result.amount = amount;
    }
    if (assetId != null) {
      _result.assetId = assetId;
    }
    return _result;
  }
  factory AddressAmount.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AddressAmount.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AddressAmount clone() => AddressAmount()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AddressAmount copyWith(void Function(AddressAmount) updates) => super.copyWith((message) => updates(message as AddressAmount)) as AddressAmount; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static AddressAmount create() => AddressAmount._();
  AddressAmount createEmptyInstance() => create();
  static $pb.PbList<AddressAmount> createRepeated() => $pb.PbList<AddressAmount>();
  @$core.pragma('dart2js:noInline')
  static AddressAmount getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AddressAmount>(create);
  static AddressAmount? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get address => $_getSZ(0);
  @$pb.TagNumber(1)
  set address($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAddress() => $_has(0);
  @$pb.TagNumber(1)
  void clearAddress() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get amount => $_getI64(1);
  @$pb.TagNumber(2)
  set amount($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAmount() => $_has(1);
  @$pb.TagNumber(2)
  void clearAmount() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get assetId => $_getSZ(2);
  @$pb.TagNumber(3)
  set assetId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAssetId() => $_has(2);
  @$pb.TagNumber(3)
  void clearAssetId() => clearField(3);
}

class Balance extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Balance', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'assetId')
    ..a<$fixnum.Int64>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'amount', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
  ;

  Balance._() : super();
  factory Balance({
    $core.String? assetId,
    $fixnum.Int64? amount,
  }) {
    final _result = create();
    if (assetId != null) {
      _result.assetId = assetId;
    }
    if (amount != null) {
      _result.amount = amount;
    }
    return _result;
  }
  factory Balance.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Balance.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Balance clone() => Balance()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Balance copyWith(void Function(Balance) updates) => super.copyWith((message) => updates(message as Balance)) as Balance; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Balance create() => Balance._();
  Balance createEmptyInstance() => create();
  static $pb.PbList<Balance> createRepeated() => $pb.PbList<Balance>();
  @$core.pragma('dart2js:noInline')
  static Balance getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Balance>(create);
  static Balance? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assetId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetId() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get amount => $_getI64(1);
  @$pb.TagNumber(2)
  set amount($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAmount() => $_has(1);
  @$pb.TagNumber(2)
  void clearAmount() => clearField(2);
}

class TxBalance extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'TxBalance', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'assetId')
    ..a<$fixnum.Int64>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'amount', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aQM<Account>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'account', subBuilder: Account.create)
  ;

  TxBalance._() : super();
  factory TxBalance({
    $core.String? assetId,
    $fixnum.Int64? amount,
    Account? account,
  }) {
    final _result = create();
    if (assetId != null) {
      _result.assetId = assetId;
    }
    if (amount != null) {
      _result.amount = amount;
    }
    if (account != null) {
      _result.account = account;
    }
    return _result;
  }
  factory TxBalance.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TxBalance.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TxBalance clone() => TxBalance()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TxBalance copyWith(void Function(TxBalance) updates) => super.copyWith((message) => updates(message as TxBalance)) as TxBalance; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static TxBalance create() => TxBalance._();
  TxBalance createEmptyInstance() => create();
  static $pb.PbList<TxBalance> createRepeated() => $pb.PbList<TxBalance>();
  @$core.pragma('dart2js:noInline')
  static TxBalance getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TxBalance>(create);
  static TxBalance? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assetId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetId() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get amount => $_getI64(1);
  @$pb.TagNumber(2)
  set amount($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAmount() => $_has(1);
  @$pb.TagNumber(2)
  void clearAmount() => clearField(2);

  @$pb.TagNumber(3)
  Account get account => $_getN(2);
  @$pb.TagNumber(3)
  set account(Account v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasAccount() => $_has(2);
  @$pb.TagNumber(3)
  void clearAccount() => clearField(3);
  @$pb.TagNumber(3)
  Account ensureAccount() => $_ensure(2);
}

class Asset extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Asset', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'assetId')
    ..aQS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
    ..aQS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ticker')
    ..aQS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'icon')
    ..a<$core.int>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'precision', $pb.PbFieldType.QU3)
    ..a<$core.bool>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'swapMarket', $pb.PbFieldType.QB)
    ..aOS(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'domain')
    ..a<$core.bool>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'unregistered', $pb.PbFieldType.QB)
    ..a<$core.bool>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ampMarket', $pb.PbFieldType.QB)
    ..aOS(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'domainAgent')
  ;

  Asset._() : super();
  factory Asset({
    $core.String? assetId,
    $core.String? name,
    $core.String? ticker,
    $core.String? icon,
    $core.int? precision,
    $core.bool? swapMarket,
    $core.String? domain,
    $core.bool? unregistered,
    $core.bool? ampMarket,
    $core.String? domainAgent,
  }) {
    final _result = create();
    if (assetId != null) {
      _result.assetId = assetId;
    }
    if (name != null) {
      _result.name = name;
    }
    if (ticker != null) {
      _result.ticker = ticker;
    }
    if (icon != null) {
      _result.icon = icon;
    }
    if (precision != null) {
      _result.precision = precision;
    }
    if (swapMarket != null) {
      _result.swapMarket = swapMarket;
    }
    if (domain != null) {
      _result.domain = domain;
    }
    if (unregistered != null) {
      _result.unregistered = unregistered;
    }
    if (ampMarket != null) {
      _result.ampMarket = ampMarket;
    }
    if (domainAgent != null) {
      _result.domainAgent = domainAgent;
    }
    return _result;
  }
  factory Asset.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Asset.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Asset clone() => Asset()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Asset copyWith(void Function(Asset) updates) => super.copyWith((message) => updates(message as Asset)) as Asset; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Asset create() => Asset._();
  Asset createEmptyInstance() => create();
  static $pb.PbList<Asset> createRepeated() => $pb.PbList<Asset>();
  @$core.pragma('dart2js:noInline')
  static Asset getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Asset>(create);
  static Asset? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assetId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get ticker => $_getSZ(2);
  @$pb.TagNumber(3)
  set ticker($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasTicker() => $_has(2);
  @$pb.TagNumber(3)
  void clearTicker() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get icon => $_getSZ(3);
  @$pb.TagNumber(4)
  set icon($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasIcon() => $_has(3);
  @$pb.TagNumber(4)
  void clearIcon() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get precision => $_getIZ(4);
  @$pb.TagNumber(5)
  set precision($core.int v) { $_setUnsignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasPrecision() => $_has(4);
  @$pb.TagNumber(5)
  void clearPrecision() => clearField(5);

  @$pb.TagNumber(6)
  $core.bool get swapMarket => $_getBF(5);
  @$pb.TagNumber(6)
  set swapMarket($core.bool v) { $_setBool(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasSwapMarket() => $_has(5);
  @$pb.TagNumber(6)
  void clearSwapMarket() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get domain => $_getSZ(6);
  @$pb.TagNumber(7)
  set domain($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasDomain() => $_has(6);
  @$pb.TagNumber(7)
  void clearDomain() => clearField(7);

  @$pb.TagNumber(8)
  $core.bool get unregistered => $_getBF(7);
  @$pb.TagNumber(8)
  set unregistered($core.bool v) { $_setBool(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasUnregistered() => $_has(7);
  @$pb.TagNumber(8)
  void clearUnregistered() => clearField(8);

  @$pb.TagNumber(9)
  $core.bool get ampMarket => $_getBF(8);
  @$pb.TagNumber(9)
  set ampMarket($core.bool v) { $_setBool(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasAmpMarket() => $_has(8);
  @$pb.TagNumber(9)
  void clearAmpMarket() => clearField(9);

  @$pb.TagNumber(10)
  $core.String get domainAgent => $_getSZ(9);
  @$pb.TagNumber(10)
  set domainAgent($core.String v) { $_setString(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasDomainAgent() => $_has(9);
  @$pb.TagNumber(10)
  void clearDomainAgent() => clearField(10);
}

class Tx extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Tx', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..pc<TxBalance>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'balances', $pb.PbFieldType.PM, subBuilder: TxBalance.create)
    ..aQS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'txid')
    ..a<$fixnum.Int64>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'networkFee', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aQS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'memo')
    ..a<$fixnum.Int64>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'size', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'vsize', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
  ;

  Tx._() : super();
  factory Tx({
    $core.Iterable<TxBalance>? balances,
    $core.String? txid,
    $fixnum.Int64? networkFee,
    $core.String? memo,
    $fixnum.Int64? size,
    $fixnum.Int64? vsize,
  }) {
    final _result = create();
    if (balances != null) {
      _result.balances.addAll(balances);
    }
    if (txid != null) {
      _result.txid = txid;
    }
    if (networkFee != null) {
      _result.networkFee = networkFee;
    }
    if (memo != null) {
      _result.memo = memo;
    }
    if (size != null) {
      _result.size = size;
    }
    if (vsize != null) {
      _result.vsize = vsize;
    }
    return _result;
  }
  factory Tx.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Tx.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Tx clone() => Tx()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Tx copyWith(void Function(Tx) updates) => super.copyWith((message) => updates(message as Tx)) as Tx; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Tx create() => Tx._();
  Tx createEmptyInstance() => create();
  static $pb.PbList<Tx> createRepeated() => $pb.PbList<Tx>();
  @$core.pragma('dart2js:noInline')
  static Tx getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Tx>(create);
  static Tx? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<TxBalance> get balances => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get txid => $_getSZ(1);
  @$pb.TagNumber(2)
  set txid($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTxid() => $_has(1);
  @$pb.TagNumber(2)
  void clearTxid() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get networkFee => $_getI64(2);
  @$pb.TagNumber(3)
  set networkFee($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasNetworkFee() => $_has(2);
  @$pb.TagNumber(3)
  void clearNetworkFee() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get memo => $_getSZ(3);
  @$pb.TagNumber(4)
  set memo($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasMemo() => $_has(3);
  @$pb.TagNumber(4)
  void clearMemo() => clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get size => $_getI64(4);
  @$pb.TagNumber(5)
  set size($fixnum.Int64 v) { $_setInt64(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasSize() => $_has(4);
  @$pb.TagNumber(5)
  void clearSize() => clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get vsize => $_getI64(5);
  @$pb.TagNumber(6)
  set vsize($fixnum.Int64 v) { $_setInt64(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasVsize() => $_has(5);
  @$pb.TagNumber(6)
  void clearVsize() => clearField(6);
}

class Peg extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Peg', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..a<$core.bool>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'isPegIn', $pb.PbFieldType.QB)
    ..a<$fixnum.Int64>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'amountSend', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'amountRecv', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aQS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'addrSend')
    ..aQS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'addrRecv')
    ..aQS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'txidSend')
    ..aOS(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'txidRecv')
  ;

  Peg._() : super();
  factory Peg({
    $core.bool? isPegIn,
    $fixnum.Int64? amountSend,
    $fixnum.Int64? amountRecv,
    $core.String? addrSend,
    $core.String? addrRecv,
    $core.String? txidSend,
    $core.String? txidRecv,
  }) {
    final _result = create();
    if (isPegIn != null) {
      _result.isPegIn = isPegIn;
    }
    if (amountSend != null) {
      _result.amountSend = amountSend;
    }
    if (amountRecv != null) {
      _result.amountRecv = amountRecv;
    }
    if (addrSend != null) {
      _result.addrSend = addrSend;
    }
    if (addrRecv != null) {
      _result.addrRecv = addrRecv;
    }
    if (txidSend != null) {
      _result.txidSend = txidSend;
    }
    if (txidRecv != null) {
      _result.txidRecv = txidRecv;
    }
    return _result;
  }
  factory Peg.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Peg.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Peg clone() => Peg()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Peg copyWith(void Function(Peg) updates) => super.copyWith((message) => updates(message as Peg)) as Peg; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Peg create() => Peg._();
  Peg createEmptyInstance() => create();
  static $pb.PbList<Peg> createRepeated() => $pb.PbList<Peg>();
  @$core.pragma('dart2js:noInline')
  static Peg getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Peg>(create);
  static Peg? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get isPegIn => $_getBF(0);
  @$pb.TagNumber(1)
  set isPegIn($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasIsPegIn() => $_has(0);
  @$pb.TagNumber(1)
  void clearIsPegIn() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get amountSend => $_getI64(1);
  @$pb.TagNumber(2)
  set amountSend($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAmountSend() => $_has(1);
  @$pb.TagNumber(2)
  void clearAmountSend() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get amountRecv => $_getI64(2);
  @$pb.TagNumber(3)
  set amountRecv($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAmountRecv() => $_has(2);
  @$pb.TagNumber(3)
  void clearAmountRecv() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get addrSend => $_getSZ(3);
  @$pb.TagNumber(4)
  set addrSend($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasAddrSend() => $_has(3);
  @$pb.TagNumber(4)
  void clearAddrSend() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get addrRecv => $_getSZ(4);
  @$pb.TagNumber(5)
  set addrRecv($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasAddrRecv() => $_has(4);
  @$pb.TagNumber(5)
  void clearAddrRecv() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get txidSend => $_getSZ(5);
  @$pb.TagNumber(6)
  set txidSend($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasTxidSend() => $_has(5);
  @$pb.TagNumber(6)
  void clearTxidSend() => clearField(6);

  @$pb.TagNumber(8)
  $core.String get txidRecv => $_getSZ(6);
  @$pb.TagNumber(8)
  set txidRecv($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(8)
  $core.bool hasTxidRecv() => $_has(6);
  @$pb.TagNumber(8)
  void clearTxidRecv() => clearField(8);
}

class Confs extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Confs', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'count', $pb.PbFieldType.QU3)
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'total', $pb.PbFieldType.QU3)
  ;

  Confs._() : super();
  factory Confs({
    $core.int? count,
    $core.int? total,
  }) {
    final _result = create();
    if (count != null) {
      _result.count = count;
    }
    if (total != null) {
      _result.total = total;
    }
    return _result;
  }
  factory Confs.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Confs.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Confs clone() => Confs()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Confs copyWith(void Function(Confs) updates) => super.copyWith((message) => updates(message as Confs)) as Confs; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Confs create() => Confs._();
  Confs createEmptyInstance() => create();
  static $pb.PbList<Confs> createRepeated() => $pb.PbList<Confs>();
  @$core.pragma('dart2js:noInline')
  static Confs getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Confs>(create);
  static Confs? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get count => $_getIZ(0);
  @$pb.TagNumber(1)
  set count($core.int v) { $_setUnsignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearCount() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get total => $_getIZ(1);
  @$pb.TagNumber(2)
  set total($core.int v) { $_setUnsignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTotal() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotal() => clearField(2);
}

enum TransItem_Item {
  tx, 
  peg, 
  notSet
}

class TransItem extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, TransItem_Item> _TransItem_ItemByTag = {
    10 : TransItem_Item.tx,
    11 : TransItem_Item.peg,
    0 : TransItem_Item.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'TransItem', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..oo(0, [10, 11])
    ..aQS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..a<$fixnum.Int64>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'createdAt', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOM<Confs>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'confs', subBuilder: Confs.create)
    ..aOM<Tx>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tx', subBuilder: Tx.create)
    ..aOM<Peg>(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'peg', subBuilder: Peg.create)
  ;

  TransItem._() : super();
  factory TransItem({
    $core.String? id,
    $fixnum.Int64? createdAt,
    Confs? confs,
    Tx? tx,
    Peg? peg,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (createdAt != null) {
      _result.createdAt = createdAt;
    }
    if (confs != null) {
      _result.confs = confs;
    }
    if (tx != null) {
      _result.tx = tx;
    }
    if (peg != null) {
      _result.peg = peg;
    }
    return _result;
  }
  factory TransItem.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TransItem.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TransItem clone() => TransItem()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TransItem copyWith(void Function(TransItem) updates) => super.copyWith((message) => updates(message as TransItem)) as TransItem; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static TransItem create() => TransItem._();
  TransItem createEmptyInstance() => create();
  static $pb.PbList<TransItem> createRepeated() => $pb.PbList<TransItem>();
  @$core.pragma('dart2js:noInline')
  static TransItem getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TransItem>(create);
  static TransItem? _defaultInstance;

  TransItem_Item whichItem() => _TransItem_ItemByTag[$_whichOneof(0)]!;
  void clearItem() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get createdAt => $_getI64(1);
  @$pb.TagNumber(2)
  set createdAt($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCreatedAt() => $_has(1);
  @$pb.TagNumber(2)
  void clearCreatedAt() => clearField(2);

  @$pb.TagNumber(3)
  Confs get confs => $_getN(2);
  @$pb.TagNumber(3)
  set confs(Confs v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasConfs() => $_has(2);
  @$pb.TagNumber(3)
  void clearConfs() => clearField(3);
  @$pb.TagNumber(3)
  Confs ensureConfs() => $_ensure(2);

  @$pb.TagNumber(10)
  Tx get tx => $_getN(3);
  @$pb.TagNumber(10)
  set tx(Tx v) { setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasTx() => $_has(3);
  @$pb.TagNumber(10)
  void clearTx() => clearField(10);
  @$pb.TagNumber(10)
  Tx ensureTx() => $_ensure(3);

  @$pb.TagNumber(11)
  Peg get peg => $_getN(4);
  @$pb.TagNumber(11)
  set peg(Peg v) { setField(11, v); }
  @$pb.TagNumber(11)
  $core.bool hasPeg() => $_has(4);
  @$pb.TagNumber(11)
  void clearPeg() => clearField(11);
  @$pb.TagNumber(11)
  Peg ensurePeg() => $_ensure(4);
}

class AssetId extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'AssetId', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'assetId')
  ;

  AssetId._() : super();
  factory AssetId({
    $core.String? assetId,
  }) {
    final _result = create();
    if (assetId != null) {
      _result.assetId = assetId;
    }
    return _result;
  }
  factory AssetId.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AssetId.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AssetId clone() => AssetId()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AssetId copyWith(void Function(AssetId) updates) => super.copyWith((message) => updates(message as AssetId)) as AssetId; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static AssetId create() => AssetId._();
  AssetId createEmptyInstance() => create();
  static $pb.PbList<AssetId> createRepeated() => $pb.PbList<AssetId>();
  @$core.pragma('dart2js:noInline')
  static AssetId getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AssetId>(create);
  static AssetId? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assetId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetId() => clearField(1);
}

class GenericResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GenericResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..a<$core.bool>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'success', $pb.PbFieldType.QB)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'errorMsg')
  ;

  GenericResponse._() : super();
  factory GenericResponse({
    $core.bool? success,
    $core.String? errorMsg,
  }) {
    final _result = create();
    if (success != null) {
      _result.success = success;
    }
    if (errorMsg != null) {
      _result.errorMsg = errorMsg;
    }
    return _result;
  }
  factory GenericResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GenericResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GenericResponse clone() => GenericResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GenericResponse copyWith(void Function(GenericResponse) updates) => super.copyWith((message) => updates(message as GenericResponse)) as GenericResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GenericResponse create() => GenericResponse._();
  GenericResponse createEmptyInstance() => create();
  static $pb.PbList<GenericResponse> createRepeated() => $pb.PbList<GenericResponse>();
  @$core.pragma('dart2js:noInline')
  static GenericResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GenericResponse>(create);
  static GenericResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get errorMsg => $_getSZ(1);
  @$pb.TagNumber(2)
  set errorMsg($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasErrorMsg() => $_has(1);
  @$pb.TagNumber(2)
  void clearErrorMsg() => clearField(2);
}

class FeeRate extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'FeeRate', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'blocks', $pb.PbFieldType.Q3)
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'value', $pb.PbFieldType.QD)
  ;

  FeeRate._() : super();
  factory FeeRate({
    $core.int? blocks,
    $core.double? value,
  }) {
    final _result = create();
    if (blocks != null) {
      _result.blocks = blocks;
    }
    if (value != null) {
      _result.value = value;
    }
    return _result;
  }
  factory FeeRate.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FeeRate.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FeeRate clone() => FeeRate()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FeeRate copyWith(void Function(FeeRate) updates) => super.copyWith((message) => updates(message as FeeRate)) as FeeRate; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static FeeRate create() => FeeRate._();
  FeeRate createEmptyInstance() => create();
  static $pb.PbList<FeeRate> createRepeated() => $pb.PbList<FeeRate>();
  @$core.pragma('dart2js:noInline')
  static FeeRate getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FeeRate>(create);
  static FeeRate? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get blocks => $_getIZ(0);
  @$pb.TagNumber(1)
  set blocks($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasBlocks() => $_has(0);
  @$pb.TagNumber(1)
  void clearBlocks() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get value => $_getN(1);
  @$pb.TagNumber(2)
  set value($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearValue() => clearField(2);
}

class ServerStatus extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ServerStatus', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'minPegInAmount', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'minPegOutAmount', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.double>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'serverFeePercentPegIn', $pb.PbFieldType.QD)
    ..a<$core.double>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'serverFeePercentPegOut', $pb.PbFieldType.QD)
    ..pc<FeeRate>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'bitcoinFeeRates', $pb.PbFieldType.PM, subBuilder: FeeRate.create)
  ;

  ServerStatus._() : super();
  factory ServerStatus({
    $fixnum.Int64? minPegInAmount,
    $fixnum.Int64? minPegOutAmount,
    $core.double? serverFeePercentPegIn,
    $core.double? serverFeePercentPegOut,
    $core.Iterable<FeeRate>? bitcoinFeeRates,
  }) {
    final _result = create();
    if (minPegInAmount != null) {
      _result.minPegInAmount = minPegInAmount;
    }
    if (minPegOutAmount != null) {
      _result.minPegOutAmount = minPegOutAmount;
    }
    if (serverFeePercentPegIn != null) {
      _result.serverFeePercentPegIn = serverFeePercentPegIn;
    }
    if (serverFeePercentPegOut != null) {
      _result.serverFeePercentPegOut = serverFeePercentPegOut;
    }
    if (bitcoinFeeRates != null) {
      _result.bitcoinFeeRates.addAll(bitcoinFeeRates);
    }
    return _result;
  }
  factory ServerStatus.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ServerStatus.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ServerStatus clone() => ServerStatus()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ServerStatus copyWith(void Function(ServerStatus) updates) => super.copyWith((message) => updates(message as ServerStatus)) as ServerStatus; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ServerStatus create() => ServerStatus._();
  ServerStatus createEmptyInstance() => create();
  static $pb.PbList<ServerStatus> createRepeated() => $pb.PbList<ServerStatus>();
  @$core.pragma('dart2js:noInline')
  static ServerStatus getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ServerStatus>(create);
  static ServerStatus? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get minPegInAmount => $_getI64(0);
  @$pb.TagNumber(1)
  set minPegInAmount($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMinPegInAmount() => $_has(0);
  @$pb.TagNumber(1)
  void clearMinPegInAmount() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get minPegOutAmount => $_getI64(1);
  @$pb.TagNumber(2)
  set minPegOutAmount($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMinPegOutAmount() => $_has(1);
  @$pb.TagNumber(2)
  void clearMinPegOutAmount() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get serverFeePercentPegIn => $_getN(2);
  @$pb.TagNumber(3)
  set serverFeePercentPegIn($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasServerFeePercentPegIn() => $_has(2);
  @$pb.TagNumber(3)
  void clearServerFeePercentPegIn() => clearField(3);

  @$pb.TagNumber(4)
  $core.double get serverFeePercentPegOut => $_getN(3);
  @$pb.TagNumber(4)
  set serverFeePercentPegOut($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasServerFeePercentPegOut() => $_has(3);
  @$pb.TagNumber(4)
  void clearServerFeePercentPegOut() => clearField(4);

  @$pb.TagNumber(5)
  $core.List<FeeRate> get bitcoinFeeRates => $_getList(4);
}

class UploadContact extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'UploadContact', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'identifier')
    ..aQS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
    ..pPS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'phones')
  ;

  UploadContact._() : super();
  factory UploadContact({
    $core.String? identifier,
    $core.String? name,
    $core.Iterable<$core.String>? phones,
  }) {
    final _result = create();
    if (identifier != null) {
      _result.identifier = identifier;
    }
    if (name != null) {
      _result.name = name;
    }
    if (phones != null) {
      _result.phones.addAll(phones);
    }
    return _result;
  }
  factory UploadContact.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UploadContact.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UploadContact clone() => UploadContact()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UploadContact copyWith(void Function(UploadContact) updates) => super.copyWith((message) => updates(message as UploadContact)) as UploadContact; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static UploadContact create() => UploadContact._();
  UploadContact createEmptyInstance() => create();
  static $pb.PbList<UploadContact> createRepeated() => $pb.PbList<UploadContact>();
  @$core.pragma('dart2js:noInline')
  static UploadContact getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UploadContact>(create);
  static UploadContact? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get identifier => $_getSZ(0);
  @$pb.TagNumber(1)
  set identifier($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasIdentifier() => $_has(0);
  @$pb.TagNumber(1)
  void clearIdentifier() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.String> get phones => $_getList(2);
}

class Contact extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Contact', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'contactKey')
    ..aQS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
    ..aQS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'phone')
  ;

  Contact._() : super();
  factory Contact({
    $core.String? contactKey,
    $core.String? name,
    $core.String? phone,
  }) {
    final _result = create();
    if (contactKey != null) {
      _result.contactKey = contactKey;
    }
    if (name != null) {
      _result.name = name;
    }
    if (phone != null) {
      _result.phone = phone;
    }
    return _result;
  }
  factory Contact.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Contact.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Contact clone() => Contact()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Contact copyWith(void Function(Contact) updates) => super.copyWith((message) => updates(message as Contact)) as Contact; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Contact create() => Contact._();
  Contact createEmptyInstance() => create();
  static $pb.PbList<Contact> createRepeated() => $pb.PbList<Contact>();
  @$core.pragma('dart2js:noInline')
  static Contact getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Contact>(create);
  static Contact? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get contactKey => $_getSZ(0);
  @$pb.TagNumber(1)
  set contactKey($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasContactKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearContactKey() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get phone => $_getSZ(2);
  @$pb.TagNumber(3)
  set phone($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPhone() => $_has(2);
  @$pb.TagNumber(3)
  void clearPhone() => clearField(3);
}

class ContactTransaction extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ContactTransaction', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'txid')
    ..aQS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'contactKey')
  ;

  ContactTransaction._() : super();
  factory ContactTransaction({
    $core.String? txid,
    $core.String? contactKey,
  }) {
    final _result = create();
    if (txid != null) {
      _result.txid = txid;
    }
    if (contactKey != null) {
      _result.contactKey = contactKey;
    }
    return _result;
  }
  factory ContactTransaction.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ContactTransaction.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ContactTransaction clone() => ContactTransaction()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ContactTransaction copyWith(void Function(ContactTransaction) updates) => super.copyWith((message) => updates(message as ContactTransaction)) as ContactTransaction; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ContactTransaction create() => ContactTransaction._();
  ContactTransaction createEmptyInstance() => create();
  static $pb.PbList<ContactTransaction> createRepeated() => $pb.PbList<ContactTransaction>();
  @$core.pragma('dart2js:noInline')
  static ContactTransaction getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ContactTransaction>(create);
  static ContactTransaction? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get txid => $_getSZ(0);
  @$pb.TagNumber(1)
  set txid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTxid() => $_has(0);
  @$pb.TagNumber(1)
  void clearTxid() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get contactKey => $_getSZ(1);
  @$pb.TagNumber(2)
  set contactKey($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasContactKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearContactKey() => clearField(2);
}

class Order extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Order', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'orderId')
    ..aQS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'assetId')
    ..a<$fixnum.Int64>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'bitcoinAmount', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'serverFee', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'assetAmount', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.double>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'price', $pb.PbFieldType.QD)
    ..a<$fixnum.Int64>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'createdAt', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'expiresAt', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.bool>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'private', $pb.PbFieldType.QB)
    ..a<$core.bool>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sendBitcoins', $pb.PbFieldType.QB)
    ..a<$core.bool>(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'autoSign', $pb.PbFieldType.QB)
    ..a<$core.bool>(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'own', $pb.PbFieldType.QB)
    ..a<$core.bool>(13, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'fromNotification', $pb.PbFieldType.QB)
    ..a<$core.double>(15, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'indexPrice', $pb.PbFieldType.OD)
    ..a<$core.bool>(16, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tokenMarket', $pb.PbFieldType.QB)
  ;

  Order._() : super();
  factory Order({
    $core.String? orderId,
    $core.String? assetId,
    $fixnum.Int64? bitcoinAmount,
    $fixnum.Int64? serverFee,
    $fixnum.Int64? assetAmount,
    $core.double? price,
    $fixnum.Int64? createdAt,
    $fixnum.Int64? expiresAt,
    $core.bool? private,
    $core.bool? sendBitcoins,
    $core.bool? autoSign,
    $core.bool? own,
    $core.bool? fromNotification,
    $core.double? indexPrice,
    $core.bool? tokenMarket,
  }) {
    final _result = create();
    if (orderId != null) {
      _result.orderId = orderId;
    }
    if (assetId != null) {
      _result.assetId = assetId;
    }
    if (bitcoinAmount != null) {
      _result.bitcoinAmount = bitcoinAmount;
    }
    if (serverFee != null) {
      _result.serverFee = serverFee;
    }
    if (assetAmount != null) {
      _result.assetAmount = assetAmount;
    }
    if (price != null) {
      _result.price = price;
    }
    if (createdAt != null) {
      _result.createdAt = createdAt;
    }
    if (expiresAt != null) {
      _result.expiresAt = expiresAt;
    }
    if (private != null) {
      _result.private = private;
    }
    if (sendBitcoins != null) {
      _result.sendBitcoins = sendBitcoins;
    }
    if (autoSign != null) {
      _result.autoSign = autoSign;
    }
    if (own != null) {
      _result.own = own;
    }
    if (fromNotification != null) {
      _result.fromNotification = fromNotification;
    }
    if (indexPrice != null) {
      _result.indexPrice = indexPrice;
    }
    if (tokenMarket != null) {
      _result.tokenMarket = tokenMarket;
    }
    return _result;
  }
  factory Order.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Order.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Order clone() => Order()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Order copyWith(void Function(Order) updates) => super.copyWith((message) => updates(message as Order)) as Order; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Order create() => Order._();
  Order createEmptyInstance() => create();
  static $pb.PbList<Order> createRepeated() => $pb.PbList<Order>();
  @$core.pragma('dart2js:noInline')
  static Order getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Order>(create);
  static Order? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get orderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set orderId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrderId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get assetId => $_getSZ(1);
  @$pb.TagNumber(2)
  set assetId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAssetId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAssetId() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get bitcoinAmount => $_getI64(2);
  @$pb.TagNumber(3)
  set bitcoinAmount($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasBitcoinAmount() => $_has(2);
  @$pb.TagNumber(3)
  void clearBitcoinAmount() => clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get serverFee => $_getI64(3);
  @$pb.TagNumber(4)
  set serverFee($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasServerFee() => $_has(3);
  @$pb.TagNumber(4)
  void clearServerFee() => clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get assetAmount => $_getI64(4);
  @$pb.TagNumber(5)
  set assetAmount($fixnum.Int64 v) { $_setInt64(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasAssetAmount() => $_has(4);
  @$pb.TagNumber(5)
  void clearAssetAmount() => clearField(5);

  @$pb.TagNumber(6)
  $core.double get price => $_getN(5);
  @$pb.TagNumber(6)
  set price($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasPrice() => $_has(5);
  @$pb.TagNumber(6)
  void clearPrice() => clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get createdAt => $_getI64(6);
  @$pb.TagNumber(7)
  set createdAt($fixnum.Int64 v) { $_setInt64(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasCreatedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearCreatedAt() => clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get expiresAt => $_getI64(7);
  @$pb.TagNumber(8)
  set expiresAt($fixnum.Int64 v) { $_setInt64(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasExpiresAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearExpiresAt() => clearField(8);

  @$pb.TagNumber(9)
  $core.bool get private => $_getBF(8);
  @$pb.TagNumber(9)
  set private($core.bool v) { $_setBool(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasPrivate() => $_has(8);
  @$pb.TagNumber(9)
  void clearPrivate() => clearField(9);

  @$pb.TagNumber(10)
  $core.bool get sendBitcoins => $_getBF(9);
  @$pb.TagNumber(10)
  set sendBitcoins($core.bool v) { $_setBool(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasSendBitcoins() => $_has(9);
  @$pb.TagNumber(10)
  void clearSendBitcoins() => clearField(10);

  @$pb.TagNumber(11)
  $core.bool get autoSign => $_getBF(10);
  @$pb.TagNumber(11)
  set autoSign($core.bool v) { $_setBool(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasAutoSign() => $_has(10);
  @$pb.TagNumber(11)
  void clearAutoSign() => clearField(11);

  @$pb.TagNumber(12)
  $core.bool get own => $_getBF(11);
  @$pb.TagNumber(12)
  set own($core.bool v) { $_setBool(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasOwn() => $_has(11);
  @$pb.TagNumber(12)
  void clearOwn() => clearField(12);

  @$pb.TagNumber(13)
  $core.bool get fromNotification => $_getBF(12);
  @$pb.TagNumber(13)
  set fromNotification($core.bool v) { $_setBool(12, v); }
  @$pb.TagNumber(13)
  $core.bool hasFromNotification() => $_has(12);
  @$pb.TagNumber(13)
  void clearFromNotification() => clearField(13);

  @$pb.TagNumber(15)
  $core.double get indexPrice => $_getN(13);
  @$pb.TagNumber(15)
  set indexPrice($core.double v) { $_setDouble(13, v); }
  @$pb.TagNumber(15)
  $core.bool hasIndexPrice() => $_has(13);
  @$pb.TagNumber(15)
  void clearIndexPrice() => clearField(15);

  @$pb.TagNumber(16)
  $core.bool get tokenMarket => $_getBF(14);
  @$pb.TagNumber(16)
  set tokenMarket($core.bool v) { $_setBool(14, v); }
  @$pb.TagNumber(16)
  $core.bool hasTokenMarket() => $_has(14);
  @$pb.TagNumber(16)
  void clearTokenMarket() => clearField(16);
}

class SwapDetails extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SwapDetails', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'orderId')
    ..aQS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sendAsset')
    ..aQS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'recvAsset')
    ..a<$fixnum.Int64>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sendAmount', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'recvAmount', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aQS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'uploadUrl')
  ;

  SwapDetails._() : super();
  factory SwapDetails({
    $core.String? orderId,
    $core.String? sendAsset,
    $core.String? recvAsset,
    $fixnum.Int64? sendAmount,
    $fixnum.Int64? recvAmount,
    $core.String? uploadUrl,
  }) {
    final _result = create();
    if (orderId != null) {
      _result.orderId = orderId;
    }
    if (sendAsset != null) {
      _result.sendAsset = sendAsset;
    }
    if (recvAsset != null) {
      _result.recvAsset = recvAsset;
    }
    if (sendAmount != null) {
      _result.sendAmount = sendAmount;
    }
    if (recvAmount != null) {
      _result.recvAmount = recvAmount;
    }
    if (uploadUrl != null) {
      _result.uploadUrl = uploadUrl;
    }
    return _result;
  }
  factory SwapDetails.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SwapDetails.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SwapDetails clone() => SwapDetails()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SwapDetails copyWith(void Function(SwapDetails) updates) => super.copyWith((message) => updates(message as SwapDetails)) as SwapDetails; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SwapDetails create() => SwapDetails._();
  SwapDetails createEmptyInstance() => create();
  static $pb.PbList<SwapDetails> createRepeated() => $pb.PbList<SwapDetails>();
  @$core.pragma('dart2js:noInline')
  static SwapDetails getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SwapDetails>(create);
  static SwapDetails? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get orderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set orderId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrderId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get sendAsset => $_getSZ(1);
  @$pb.TagNumber(2)
  set sendAsset($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSendAsset() => $_has(1);
  @$pb.TagNumber(2)
  void clearSendAsset() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get recvAsset => $_getSZ(2);
  @$pb.TagNumber(3)
  set recvAsset($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasRecvAsset() => $_has(2);
  @$pb.TagNumber(3)
  void clearRecvAsset() => clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get sendAmount => $_getI64(3);
  @$pb.TagNumber(4)
  set sendAmount($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasSendAmount() => $_has(3);
  @$pb.TagNumber(4)
  void clearSendAmount() => clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get recvAmount => $_getI64(4);
  @$pb.TagNumber(5)
  set recvAmount($fixnum.Int64 v) { $_setInt64(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasRecvAmount() => $_has(4);
  @$pb.TagNumber(5)
  void clearRecvAmount() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get uploadUrl => $_getSZ(5);
  @$pb.TagNumber(6)
  set uploadUrl($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasUploadUrl() => $_has(5);
  @$pb.TagNumber(6)
  void clearUploadUrl() => clearField(6);
}

class NetworkSettings_Custom extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'NetworkSettings.Custom', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'host')
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'port', $pb.PbFieldType.Q3)
    ..a<$core.bool>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'useTls', $pb.PbFieldType.QB)
  ;

  NetworkSettings_Custom._() : super();
  factory NetworkSettings_Custom({
    $core.String? host,
    $core.int? port,
    $core.bool? useTls,
  }) {
    final _result = create();
    if (host != null) {
      _result.host = host;
    }
    if (port != null) {
      _result.port = port;
    }
    if (useTls != null) {
      _result.useTls = useTls;
    }
    return _result;
  }
  factory NetworkSettings_Custom.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory NetworkSettings_Custom.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  NetworkSettings_Custom clone() => NetworkSettings_Custom()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  NetworkSettings_Custom copyWith(void Function(NetworkSettings_Custom) updates) => super.copyWith((message) => updates(message as NetworkSettings_Custom)) as NetworkSettings_Custom; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NetworkSettings_Custom create() => NetworkSettings_Custom._();
  NetworkSettings_Custom createEmptyInstance() => create();
  static $pb.PbList<NetworkSettings_Custom> createRepeated() => $pb.PbList<NetworkSettings_Custom>();
  @$core.pragma('dart2js:noInline')
  static NetworkSettings_Custom getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<NetworkSettings_Custom>(create);
  static NetworkSettings_Custom? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get host => $_getSZ(0);
  @$pb.TagNumber(1)
  set host($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasHost() => $_has(0);
  @$pb.TagNumber(1)
  void clearHost() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get port => $_getIZ(1);
  @$pb.TagNumber(2)
  set port($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPort() => $_has(1);
  @$pb.TagNumber(2)
  void clearPort() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get useTls => $_getBF(2);
  @$pb.TagNumber(3)
  set useTls($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasUseTls() => $_has(2);
  @$pb.TagNumber(3)
  void clearUseTls() => clearField(3);
}

enum NetworkSettings_Selected {
  blockstream, 
  sideswap, 
  custom, 
  notSet
}

class NetworkSettings extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, NetworkSettings_Selected> _NetworkSettings_SelectedByTag = {
    1 : NetworkSettings_Selected.blockstream,
    2 : NetworkSettings_Selected.sideswap,
    3 : NetworkSettings_Selected.custom,
    0 : NetworkSettings_Selected.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'NetworkSettings', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..oo(0, [1, 2, 3])
    ..aOM<Empty>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'blockstream', subBuilder: Empty.create)
    ..aOM<Empty>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sideswap', subBuilder: Empty.create)
    ..aOM<NetworkSettings_Custom>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'custom', subBuilder: NetworkSettings_Custom.create)
  ;

  NetworkSettings._() : super();
  factory NetworkSettings({
    Empty? blockstream,
    Empty? sideswap,
    NetworkSettings_Custom? custom,
  }) {
    final _result = create();
    if (blockstream != null) {
      _result.blockstream = blockstream;
    }
    if (sideswap != null) {
      _result.sideswap = sideswap;
    }
    if (custom != null) {
      _result.custom = custom;
    }
    return _result;
  }
  factory NetworkSettings.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory NetworkSettings.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  NetworkSettings clone() => NetworkSettings()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  NetworkSettings copyWith(void Function(NetworkSettings) updates) => super.copyWith((message) => updates(message as NetworkSettings)) as NetworkSettings; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NetworkSettings create() => NetworkSettings._();
  NetworkSettings createEmptyInstance() => create();
  static $pb.PbList<NetworkSettings> createRepeated() => $pb.PbList<NetworkSettings>();
  @$core.pragma('dart2js:noInline')
  static NetworkSettings getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<NetworkSettings>(create);
  static NetworkSettings? _defaultInstance;

  NetworkSettings_Selected whichSelected() => _NetworkSettings_SelectedByTag[$_whichOneof(0)]!;
  void clearSelected() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  Empty get blockstream => $_getN(0);
  @$pb.TagNumber(1)
  set blockstream(Empty v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasBlockstream() => $_has(0);
  @$pb.TagNumber(1)
  void clearBlockstream() => clearField(1);
  @$pb.TagNumber(1)
  Empty ensureBlockstream() => $_ensure(0);

  @$pb.TagNumber(2)
  Empty get sideswap => $_getN(1);
  @$pb.TagNumber(2)
  set sideswap(Empty v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasSideswap() => $_has(1);
  @$pb.TagNumber(2)
  void clearSideswap() => clearField(2);
  @$pb.TagNumber(2)
  Empty ensureSideswap() => $_ensure(1);

  @$pb.TagNumber(3)
  NetworkSettings_Custom get custom => $_getN(2);
  @$pb.TagNumber(3)
  set custom(NetworkSettings_Custom v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasCustom() => $_has(2);
  @$pb.TagNumber(3)
  void clearCustom() => clearField(3);
  @$pb.TagNumber(3)
  NetworkSettings_Custom ensureCustom() => $_ensure(2);
}

class CreateTx extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CreateTx', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'addr')
    ..aQM<Balance>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'balance', subBuilder: Balance.create)
    ..a<$core.bool>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'isContact', $pb.PbFieldType.QB)
    ..aQM<Account>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'account', subBuilder: Account.create)
  ;

  CreateTx._() : super();
  factory CreateTx({
    $core.String? addr,
    Balance? balance,
    $core.bool? isContact,
    Account? account,
  }) {
    final _result = create();
    if (addr != null) {
      _result.addr = addr;
    }
    if (balance != null) {
      _result.balance = balance;
    }
    if (isContact != null) {
      _result.isContact = isContact;
    }
    if (account != null) {
      _result.account = account;
    }
    return _result;
  }
  factory CreateTx.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateTx.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateTx clone() => CreateTx()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateTx copyWith(void Function(CreateTx) updates) => super.copyWith((message) => updates(message as CreateTx)) as CreateTx; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CreateTx create() => CreateTx._();
  CreateTx createEmptyInstance() => create();
  static $pb.PbList<CreateTx> createRepeated() => $pb.PbList<CreateTx>();
  @$core.pragma('dart2js:noInline')
  static CreateTx getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateTx>(create);
  static CreateTx? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get addr => $_getSZ(0);
  @$pb.TagNumber(1)
  set addr($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAddr() => $_has(0);
  @$pb.TagNumber(1)
  void clearAddr() => clearField(1);

  @$pb.TagNumber(2)
  Balance get balance => $_getN(1);
  @$pb.TagNumber(2)
  set balance(Balance v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasBalance() => $_has(1);
  @$pb.TagNumber(2)
  void clearBalance() => clearField(2);
  @$pb.TagNumber(2)
  Balance ensureBalance() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.bool get isContact => $_getBF(2);
  @$pb.TagNumber(3)
  set isContact($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasIsContact() => $_has(2);
  @$pb.TagNumber(3)
  void clearIsContact() => clearField(3);

  @$pb.TagNumber(4)
  Account get account => $_getN(3);
  @$pb.TagNumber(4)
  set account(Account v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasAccount() => $_has(3);
  @$pb.TagNumber(4)
  void clearAccount() => clearField(4);
  @$pb.TagNumber(4)
  Account ensureAccount() => $_ensure(3);
}

class CreatedTx extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CreatedTx', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQM<CreateTx>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'req', subBuilder: CreateTx.create)
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'inputCount', $pb.PbFieldType.Q3)
    ..a<$core.int>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'outputCount', $pb.PbFieldType.Q3)
    ..a<$fixnum.Int64>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'size', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'networkFee', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.double>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'feePerByte', $pb.PbFieldType.QD)
    ..a<$fixnum.Int64>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'vsize', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..pc<AddressAmount>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'addressees', $pb.PbFieldType.PM, subBuilder: AddressAmount.create)
  ;

  CreatedTx._() : super();
  factory CreatedTx({
    CreateTx? req,
    $core.int? inputCount,
    $core.int? outputCount,
    $fixnum.Int64? size,
    $fixnum.Int64? networkFee,
    $core.double? feePerByte,
    $fixnum.Int64? vsize,
    $core.Iterable<AddressAmount>? addressees,
  }) {
    final _result = create();
    if (req != null) {
      _result.req = req;
    }
    if (inputCount != null) {
      _result.inputCount = inputCount;
    }
    if (outputCount != null) {
      _result.outputCount = outputCount;
    }
    if (size != null) {
      _result.size = size;
    }
    if (networkFee != null) {
      _result.networkFee = networkFee;
    }
    if (feePerByte != null) {
      _result.feePerByte = feePerByte;
    }
    if (vsize != null) {
      _result.vsize = vsize;
    }
    if (addressees != null) {
      _result.addressees.addAll(addressees);
    }
    return _result;
  }
  factory CreatedTx.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreatedTx.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreatedTx clone() => CreatedTx()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreatedTx copyWith(void Function(CreatedTx) updates) => super.copyWith((message) => updates(message as CreatedTx)) as CreatedTx; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CreatedTx create() => CreatedTx._();
  CreatedTx createEmptyInstance() => create();
  static $pb.PbList<CreatedTx> createRepeated() => $pb.PbList<CreatedTx>();
  @$core.pragma('dart2js:noInline')
  static CreatedTx getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreatedTx>(create);
  static CreatedTx? _defaultInstance;

  @$pb.TagNumber(1)
  CreateTx get req => $_getN(0);
  @$pb.TagNumber(1)
  set req(CreateTx v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasReq() => $_has(0);
  @$pb.TagNumber(1)
  void clearReq() => clearField(1);
  @$pb.TagNumber(1)
  CreateTx ensureReq() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.int get inputCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set inputCount($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasInputCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearInputCount() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get outputCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set outputCount($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasOutputCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearOutputCount() => clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get size => $_getI64(3);
  @$pb.TagNumber(4)
  set size($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasSize() => $_has(3);
  @$pb.TagNumber(4)
  void clearSize() => clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get networkFee => $_getI64(4);
  @$pb.TagNumber(5)
  set networkFee($fixnum.Int64 v) { $_setInt64(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasNetworkFee() => $_has(4);
  @$pb.TagNumber(5)
  void clearNetworkFee() => clearField(5);

  @$pb.TagNumber(6)
  $core.double get feePerByte => $_getN(5);
  @$pb.TagNumber(6)
  set feePerByte($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasFeePerByte() => $_has(5);
  @$pb.TagNumber(6)
  void clearFeePerByte() => clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get vsize => $_getI64(6);
  @$pb.TagNumber(7)
  set vsize($fixnum.Int64 v) { $_setInt64(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasVsize() => $_has(6);
  @$pb.TagNumber(7)
  void clearVsize() => clearField(7);

  @$pb.TagNumber(8)
  $core.List<AddressAmount> get addressees => $_getList(7);
}

class ChartPoint extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ChartPoint', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'time')
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'open', $pb.PbFieldType.QD)
    ..a<$core.double>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'close', $pb.PbFieldType.QD)
    ..a<$core.double>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'high', $pb.PbFieldType.QD)
    ..a<$core.double>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'low', $pb.PbFieldType.QD)
    ..a<$core.double>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'volume', $pb.PbFieldType.QD)
  ;

  ChartPoint._() : super();
  factory ChartPoint({
    $core.String? time,
    $core.double? open,
    $core.double? close,
    $core.double? high,
    $core.double? low,
    $core.double? volume,
  }) {
    final _result = create();
    if (time != null) {
      _result.time = time;
    }
    if (open != null) {
      _result.open = open;
    }
    if (close != null) {
      _result.close = close;
    }
    if (high != null) {
      _result.high = high;
    }
    if (low != null) {
      _result.low = low;
    }
    if (volume != null) {
      _result.volume = volume;
    }
    return _result;
  }
  factory ChartPoint.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ChartPoint.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ChartPoint clone() => ChartPoint()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ChartPoint copyWith(void Function(ChartPoint) updates) => super.copyWith((message) => updates(message as ChartPoint)) as ChartPoint; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ChartPoint create() => ChartPoint._();
  ChartPoint createEmptyInstance() => create();
  static $pb.PbList<ChartPoint> createRepeated() => $pb.PbList<ChartPoint>();
  @$core.pragma('dart2js:noInline')
  static ChartPoint getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ChartPoint>(create);
  static ChartPoint? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get time => $_getSZ(0);
  @$pb.TagNumber(1)
  set time($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTime() => $_has(0);
  @$pb.TagNumber(1)
  void clearTime() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get open => $_getN(1);
  @$pb.TagNumber(2)
  set open($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasOpen() => $_has(1);
  @$pb.TagNumber(2)
  void clearOpen() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get close => $_getN(2);
  @$pb.TagNumber(3)
  set close($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasClose() => $_has(2);
  @$pb.TagNumber(3)
  void clearClose() => clearField(3);

  @$pb.TagNumber(4)
  $core.double get high => $_getN(3);
  @$pb.TagNumber(4)
  set high($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasHigh() => $_has(3);
  @$pb.TagNumber(4)
  void clearHigh() => clearField(4);

  @$pb.TagNumber(5)
  $core.double get low => $_getN(4);
  @$pb.TagNumber(5)
  set low($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasLow() => $_has(4);
  @$pb.TagNumber(5)
  void clearLow() => clearField(5);

  @$pb.TagNumber(6)
  $core.double get volume => $_getN(5);
  @$pb.TagNumber(6)
  set volume($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasVolume() => $_has(5);
  @$pb.TagNumber(6)
  void clearVolume() => clearField(6);
}

class To_Login extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'To.Login', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'mnemonic')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'phoneKey')
    ..aQM<NetworkSettings>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'network', subBuilder: NetworkSettings.create)
    ..a<$core.bool>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'desktop', $pb.PbFieldType.QB)
    ..aOB(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sendUtxoUpdates')
  ;

  To_Login._() : super();
  factory To_Login({
    $core.String? mnemonic,
    $core.String? phoneKey,
    NetworkSettings? network,
    $core.bool? desktop,
    $core.bool? sendUtxoUpdates,
  }) {
    final _result = create();
    if (mnemonic != null) {
      _result.mnemonic = mnemonic;
    }
    if (phoneKey != null) {
      _result.phoneKey = phoneKey;
    }
    if (network != null) {
      _result.network = network;
    }
    if (desktop != null) {
      _result.desktop = desktop;
    }
    if (sendUtxoUpdates != null) {
      _result.sendUtxoUpdates = sendUtxoUpdates;
    }
    return _result;
  }
  factory To_Login.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory To_Login.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  To_Login clone() => To_Login()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  To_Login copyWith(void Function(To_Login) updates) => super.copyWith((message) => updates(message as To_Login)) as To_Login; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static To_Login create() => To_Login._();
  To_Login createEmptyInstance() => create();
  static $pb.PbList<To_Login> createRepeated() => $pb.PbList<To_Login>();
  @$core.pragma('dart2js:noInline')
  static To_Login getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<To_Login>(create);
  static To_Login? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get mnemonic => $_getSZ(0);
  @$pb.TagNumber(1)
  set mnemonic($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMnemonic() => $_has(0);
  @$pb.TagNumber(1)
  void clearMnemonic() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get phoneKey => $_getSZ(1);
  @$pb.TagNumber(2)
  set phoneKey($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPhoneKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearPhoneKey() => clearField(2);

  @$pb.TagNumber(4)
  NetworkSettings get network => $_getN(2);
  @$pb.TagNumber(4)
  set network(NetworkSettings v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasNetwork() => $_has(2);
  @$pb.TagNumber(4)
  void clearNetwork() => clearField(4);
  @$pb.TagNumber(4)
  NetworkSettings ensureNetwork() => $_ensure(2);

  @$pb.TagNumber(5)
  $core.bool get desktop => $_getBF(3);
  @$pb.TagNumber(5)
  set desktop($core.bool v) { $_setBool(3, v); }
  @$pb.TagNumber(5)
  $core.bool hasDesktop() => $_has(3);
  @$pb.TagNumber(5)
  void clearDesktop() => clearField(5);

  @$pb.TagNumber(6)
  $core.bool get sendUtxoUpdates => $_getBF(4);
  @$pb.TagNumber(6)
  set sendUtxoUpdates($core.bool v) { $_setBool(4, v); }
  @$pb.TagNumber(6)
  $core.bool hasSendUtxoUpdates() => $_has(4);
  @$pb.TagNumber(6)
  void clearSendUtxoUpdates() => clearField(6);
}

class To_ChangeNetwork extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'To.ChangeNetwork', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQM<NetworkSettings>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'network', subBuilder: NetworkSettings.create)
  ;

  To_ChangeNetwork._() : super();
  factory To_ChangeNetwork({
    NetworkSettings? network,
  }) {
    final _result = create();
    if (network != null) {
      _result.network = network;
    }
    return _result;
  }
  factory To_ChangeNetwork.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory To_ChangeNetwork.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  To_ChangeNetwork clone() => To_ChangeNetwork()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  To_ChangeNetwork copyWith(void Function(To_ChangeNetwork) updates) => super.copyWith((message) => updates(message as To_ChangeNetwork)) as To_ChangeNetwork; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static To_ChangeNetwork create() => To_ChangeNetwork._();
  To_ChangeNetwork createEmptyInstance() => create();
  static $pb.PbList<To_ChangeNetwork> createRepeated() => $pb.PbList<To_ChangeNetwork>();
  @$core.pragma('dart2js:noInline')
  static To_ChangeNetwork getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<To_ChangeNetwork>(create);
  static To_ChangeNetwork? _defaultInstance;

  @$pb.TagNumber(1)
  NetworkSettings get network => $_getN(0);
  @$pb.TagNumber(1)
  set network(NetworkSettings v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasNetwork() => $_has(0);
  @$pb.TagNumber(1)
  void clearNetwork() => clearField(1);
  @$pb.TagNumber(1)
  NetworkSettings ensureNetwork() => $_ensure(0);
}

class To_EncryptPin extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'To.EncryptPin', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pin')
    ..aQS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'mnemonic')
  ;

  To_EncryptPin._() : super();
  factory To_EncryptPin({
    $core.String? pin,
    $core.String? mnemonic,
  }) {
    final _result = create();
    if (pin != null) {
      _result.pin = pin;
    }
    if (mnemonic != null) {
      _result.mnemonic = mnemonic;
    }
    return _result;
  }
  factory To_EncryptPin.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory To_EncryptPin.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  To_EncryptPin clone() => To_EncryptPin()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  To_EncryptPin copyWith(void Function(To_EncryptPin) updates) => super.copyWith((message) => updates(message as To_EncryptPin)) as To_EncryptPin; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static To_EncryptPin create() => To_EncryptPin._();
  To_EncryptPin createEmptyInstance() => create();
  static $pb.PbList<To_EncryptPin> createRepeated() => $pb.PbList<To_EncryptPin>();
  @$core.pragma('dart2js:noInline')
  static To_EncryptPin getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<To_EncryptPin>(create);
  static To_EncryptPin? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get pin => $_getSZ(0);
  @$pb.TagNumber(1)
  set pin($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPin() => $_has(0);
  @$pb.TagNumber(1)
  void clearPin() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get mnemonic => $_getSZ(1);
  @$pb.TagNumber(2)
  set mnemonic($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMnemonic() => $_has(1);
  @$pb.TagNumber(2)
  void clearMnemonic() => clearField(2);
}

class To_DecryptPin extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'To.DecryptPin', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pin')
    ..aQS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'salt')
    ..aQS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'encryptedData')
    ..aQS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pinIdentifier')
  ;

  To_DecryptPin._() : super();
  factory To_DecryptPin({
    $core.String? pin,
    $core.String? salt,
    $core.String? encryptedData,
    $core.String? pinIdentifier,
  }) {
    final _result = create();
    if (pin != null) {
      _result.pin = pin;
    }
    if (salt != null) {
      _result.salt = salt;
    }
    if (encryptedData != null) {
      _result.encryptedData = encryptedData;
    }
    if (pinIdentifier != null) {
      _result.pinIdentifier = pinIdentifier;
    }
    return _result;
  }
  factory To_DecryptPin.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory To_DecryptPin.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  To_DecryptPin clone() => To_DecryptPin()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  To_DecryptPin copyWith(void Function(To_DecryptPin) updates) => super.copyWith((message) => updates(message as To_DecryptPin)) as To_DecryptPin; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static To_DecryptPin create() => To_DecryptPin._();
  To_DecryptPin createEmptyInstance() => create();
  static $pb.PbList<To_DecryptPin> createRepeated() => $pb.PbList<To_DecryptPin>();
  @$core.pragma('dart2js:noInline')
  static To_DecryptPin getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<To_DecryptPin>(create);
  static To_DecryptPin? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get pin => $_getSZ(0);
  @$pb.TagNumber(1)
  set pin($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPin() => $_has(0);
  @$pb.TagNumber(1)
  void clearPin() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get salt => $_getSZ(1);
  @$pb.TagNumber(2)
  set salt($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSalt() => $_has(1);
  @$pb.TagNumber(2)
  void clearSalt() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get encryptedData => $_getSZ(2);
  @$pb.TagNumber(3)
  set encryptedData($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasEncryptedData() => $_has(2);
  @$pb.TagNumber(3)
  void clearEncryptedData() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get pinIdentifier => $_getSZ(3);
  @$pb.TagNumber(4)
  set pinIdentifier($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasPinIdentifier() => $_has(3);
  @$pb.TagNumber(4)
  void clearPinIdentifier() => clearField(4);
}

class To_AppState extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'To.AppState', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..a<$core.bool>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'active', $pb.PbFieldType.QB)
  ;

  To_AppState._() : super();
  factory To_AppState({
    $core.bool? active,
  }) {
    final _result = create();
    if (active != null) {
      _result.active = active;
    }
    return _result;
  }
  factory To_AppState.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory To_AppState.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  To_AppState clone() => To_AppState()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  To_AppState copyWith(void Function(To_AppState) updates) => super.copyWith((message) => updates(message as To_AppState)) as To_AppState; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static To_AppState create() => To_AppState._();
  To_AppState createEmptyInstance() => create();
  static $pb.PbList<To_AppState> createRepeated() => $pb.PbList<To_AppState>();
  @$core.pragma('dart2js:noInline')
  static To_AppState getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<To_AppState>(create);
  static To_AppState? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get active => $_getBF(0);
  @$pb.TagNumber(1)
  set active($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasActive() => $_has(0);
  @$pb.TagNumber(1)
  void clearActive() => clearField(1);
}

class To_SwapRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'To.SwapRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..a<$core.bool>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sendBitcoins', $pb.PbFieldType.QB)
    ..aQS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'asset')
    ..a<$fixnum.Int64>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sendAmount', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'recvAmount', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.double>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'price', $pb.PbFieldType.QD)
  ;

  To_SwapRequest._() : super();
  factory To_SwapRequest({
    $core.bool? sendBitcoins,
    $core.String? asset,
    $fixnum.Int64? sendAmount,
    $fixnum.Int64? recvAmount,
    $core.double? price,
  }) {
    final _result = create();
    if (sendBitcoins != null) {
      _result.sendBitcoins = sendBitcoins;
    }
    if (asset != null) {
      _result.asset = asset;
    }
    if (sendAmount != null) {
      _result.sendAmount = sendAmount;
    }
    if (recvAmount != null) {
      _result.recvAmount = recvAmount;
    }
    if (price != null) {
      _result.price = price;
    }
    return _result;
  }
  factory To_SwapRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory To_SwapRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  To_SwapRequest clone() => To_SwapRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  To_SwapRequest copyWith(void Function(To_SwapRequest) updates) => super.copyWith((message) => updates(message as To_SwapRequest)) as To_SwapRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static To_SwapRequest create() => To_SwapRequest._();
  To_SwapRequest createEmptyInstance() => create();
  static $pb.PbList<To_SwapRequest> createRepeated() => $pb.PbList<To_SwapRequest>();
  @$core.pragma('dart2js:noInline')
  static To_SwapRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<To_SwapRequest>(create);
  static To_SwapRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get sendBitcoins => $_getBF(0);
  @$pb.TagNumber(1)
  set sendBitcoins($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSendBitcoins() => $_has(0);
  @$pb.TagNumber(1)
  void clearSendBitcoins() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get asset => $_getSZ(1);
  @$pb.TagNumber(2)
  set asset($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAsset() => $_has(1);
  @$pb.TagNumber(2)
  void clearAsset() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get sendAmount => $_getI64(2);
  @$pb.TagNumber(3)
  set sendAmount($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSendAmount() => $_has(2);
  @$pb.TagNumber(3)
  void clearSendAmount() => clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get recvAmount => $_getI64(3);
  @$pb.TagNumber(4)
  set recvAmount($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasRecvAmount() => $_has(3);
  @$pb.TagNumber(4)
  void clearRecvAmount() => clearField(4);

  @$pb.TagNumber(5)
  $core.double get price => $_getN(4);
  @$pb.TagNumber(5)
  set price($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasPrice() => $_has(4);
  @$pb.TagNumber(5)
  void clearPrice() => clearField(5);
}

class To_PegInRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'To.PegInRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  To_PegInRequest._() : super();
  factory To_PegInRequest() => create();
  factory To_PegInRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory To_PegInRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  To_PegInRequest clone() => To_PegInRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  To_PegInRequest copyWith(void Function(To_PegInRequest) updates) => super.copyWith((message) => updates(message as To_PegInRequest)) as To_PegInRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static To_PegInRequest create() => To_PegInRequest._();
  To_PegInRequest createEmptyInstance() => create();
  static $pb.PbList<To_PegInRequest> createRepeated() => $pb.PbList<To_PegInRequest>();
  @$core.pragma('dart2js:noInline')
  static To_PegInRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<To_PegInRequest>(create);
  static To_PegInRequest? _defaultInstance;
}

class To_PegOutRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'To.PegOutRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sendAmount', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aQS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'recvAddr')
    ..a<$core.int>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'blocks', $pb.PbFieldType.Q3)
    ..aQM<Account>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'account', subBuilder: Account.create)
  ;

  To_PegOutRequest._() : super();
  factory To_PegOutRequest({
    $fixnum.Int64? sendAmount,
    $core.String? recvAddr,
    $core.int? blocks,
    Account? account,
  }) {
    final _result = create();
    if (sendAmount != null) {
      _result.sendAmount = sendAmount;
    }
    if (recvAddr != null) {
      _result.recvAddr = recvAddr;
    }
    if (blocks != null) {
      _result.blocks = blocks;
    }
    if (account != null) {
      _result.account = account;
    }
    return _result;
  }
  factory To_PegOutRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory To_PegOutRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  To_PegOutRequest clone() => To_PegOutRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  To_PegOutRequest copyWith(void Function(To_PegOutRequest) updates) => super.copyWith((message) => updates(message as To_PegOutRequest)) as To_PegOutRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static To_PegOutRequest create() => To_PegOutRequest._();
  To_PegOutRequest createEmptyInstance() => create();
  static $pb.PbList<To_PegOutRequest> createRepeated() => $pb.PbList<To_PegOutRequest>();
  @$core.pragma('dart2js:noInline')
  static To_PegOutRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<To_PegOutRequest>(create);
  static To_PegOutRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get sendAmount => $_getI64(0);
  @$pb.TagNumber(1)
  set sendAmount($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSendAmount() => $_has(0);
  @$pb.TagNumber(1)
  void clearSendAmount() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get recvAddr => $_getSZ(1);
  @$pb.TagNumber(2)
  set recvAddr($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasRecvAddr() => $_has(1);
  @$pb.TagNumber(2)
  void clearRecvAddr() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get blocks => $_getIZ(2);
  @$pb.TagNumber(3)
  set blocks($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasBlocks() => $_has(2);
  @$pb.TagNumber(3)
  void clearBlocks() => clearField(3);

  @$pb.TagNumber(4)
  Account get account => $_getN(3);
  @$pb.TagNumber(4)
  set account(Account v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasAccount() => $_has(3);
  @$pb.TagNumber(4)
  void clearAccount() => clearField(4);
  @$pb.TagNumber(4)
  Account ensureAccount() => $_ensure(3);
}

class To_SetMemo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'To.SetMemo', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'txid')
    ..aQS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'memo')
  ;

  To_SetMemo._() : super();
  factory To_SetMemo({
    $core.String? txid,
    $core.String? memo,
  }) {
    final _result = create();
    if (txid != null) {
      _result.txid = txid;
    }
    if (memo != null) {
      _result.memo = memo;
    }
    return _result;
  }
  factory To_SetMemo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory To_SetMemo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  To_SetMemo clone() => To_SetMemo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  To_SetMemo copyWith(void Function(To_SetMemo) updates) => super.copyWith((message) => updates(message as To_SetMemo)) as To_SetMemo; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static To_SetMemo create() => To_SetMemo._();
  To_SetMemo createEmptyInstance() => create();
  static $pb.PbList<To_SetMemo> createRepeated() => $pb.PbList<To_SetMemo>();
  @$core.pragma('dart2js:noInline')
  static To_SetMemo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<To_SetMemo>(create);
  static To_SetMemo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get txid => $_getSZ(0);
  @$pb.TagNumber(1)
  set txid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTxid() => $_has(0);
  @$pb.TagNumber(1)
  void clearTxid() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get memo => $_getSZ(1);
  @$pb.TagNumber(2)
  set memo($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMemo() => $_has(1);
  @$pb.TagNumber(2)
  void clearMemo() => clearField(2);
}

class To_SendTx extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'To.SendTx', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQM<Account>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'account', subBuilder: Account.create)
  ;

  To_SendTx._() : super();
  factory To_SendTx({
    Account? account,
  }) {
    final _result = create();
    if (account != null) {
      _result.account = account;
    }
    return _result;
  }
  factory To_SendTx.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory To_SendTx.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  To_SendTx clone() => To_SendTx()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  To_SendTx copyWith(void Function(To_SendTx) updates) => super.copyWith((message) => updates(message as To_SendTx)) as To_SendTx; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static To_SendTx create() => To_SendTx._();
  To_SendTx createEmptyInstance() => create();
  static $pb.PbList<To_SendTx> createRepeated() => $pb.PbList<To_SendTx>();
  @$core.pragma('dart2js:noInline')
  static To_SendTx getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<To_SendTx>(create);
  static To_SendTx? _defaultInstance;

  @$pb.TagNumber(1)
  Account get account => $_getN(0);
  @$pb.TagNumber(1)
  set account(Account v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasAccount() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccount() => clearField(1);
  @$pb.TagNumber(1)
  Account ensureAccount() => $_ensure(0);
}

class To_BlindedValues extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'To.BlindedValues', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'txid')
  ;

  To_BlindedValues._() : super();
  factory To_BlindedValues({
    $core.String? txid,
  }) {
    final _result = create();
    if (txid != null) {
      _result.txid = txid;
    }
    return _result;
  }
  factory To_BlindedValues.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory To_BlindedValues.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  To_BlindedValues clone() => To_BlindedValues()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  To_BlindedValues copyWith(void Function(To_BlindedValues) updates) => super.copyWith((message) => updates(message as To_BlindedValues)) as To_BlindedValues; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static To_BlindedValues create() => To_BlindedValues._();
  To_BlindedValues createEmptyInstance() => create();
  static $pb.PbList<To_BlindedValues> createRepeated() => $pb.PbList<To_BlindedValues>();
  @$core.pragma('dart2js:noInline')
  static To_BlindedValues getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<To_BlindedValues>(create);
  static To_BlindedValues? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get txid => $_getSZ(0);
  @$pb.TagNumber(1)
  set txid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTxid() => $_has(0);
  @$pb.TagNumber(1)
  void clearTxid() => clearField(1);
}

class To_UpdatePushToken extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'To.UpdatePushToken', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'token')
  ;

  To_UpdatePushToken._() : super();
  factory To_UpdatePushToken({
    $core.String? token,
  }) {
    final _result = create();
    if (token != null) {
      _result.token = token;
    }
    return _result;
  }
  factory To_UpdatePushToken.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory To_UpdatePushToken.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  To_UpdatePushToken clone() => To_UpdatePushToken()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  To_UpdatePushToken copyWith(void Function(To_UpdatePushToken) updates) => super.copyWith((message) => updates(message as To_UpdatePushToken)) as To_UpdatePushToken; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static To_UpdatePushToken create() => To_UpdatePushToken._();
  To_UpdatePushToken createEmptyInstance() => create();
  static $pb.PbList<To_UpdatePushToken> createRepeated() => $pb.PbList<To_UpdatePushToken>();
  @$core.pragma('dart2js:noInline')
  static To_UpdatePushToken getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<To_UpdatePushToken>(create);
  static To_UpdatePushToken? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get token => $_getSZ(0);
  @$pb.TagNumber(1)
  set token($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearToken() => clearField(1);
}

class To_RegisterPhone extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'To.RegisterPhone', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'number')
  ;

  To_RegisterPhone._() : super();
  factory To_RegisterPhone({
    $core.String? number,
  }) {
    final _result = create();
    if (number != null) {
      _result.number = number;
    }
    return _result;
  }
  factory To_RegisterPhone.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory To_RegisterPhone.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  To_RegisterPhone clone() => To_RegisterPhone()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  To_RegisterPhone copyWith(void Function(To_RegisterPhone) updates) => super.copyWith((message) => updates(message as To_RegisterPhone)) as To_RegisterPhone; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static To_RegisterPhone create() => To_RegisterPhone._();
  To_RegisterPhone createEmptyInstance() => create();
  static $pb.PbList<To_RegisterPhone> createRepeated() => $pb.PbList<To_RegisterPhone>();
  @$core.pragma('dart2js:noInline')
  static To_RegisterPhone getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<To_RegisterPhone>(create);
  static To_RegisterPhone? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get number => $_getSZ(0);
  @$pb.TagNumber(1)
  set number($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasNumber() => $_has(0);
  @$pb.TagNumber(1)
  void clearNumber() => clearField(1);
}

class To_VerifyPhone extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'To.VerifyPhone', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'phoneKey')
    ..aQS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'code')
  ;

  To_VerifyPhone._() : super();
  factory To_VerifyPhone({
    $core.String? phoneKey,
    $core.String? code,
  }) {
    final _result = create();
    if (phoneKey != null) {
      _result.phoneKey = phoneKey;
    }
    if (code != null) {
      _result.code = code;
    }
    return _result;
  }
  factory To_VerifyPhone.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory To_VerifyPhone.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  To_VerifyPhone clone() => To_VerifyPhone()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  To_VerifyPhone copyWith(void Function(To_VerifyPhone) updates) => super.copyWith((message) => updates(message as To_VerifyPhone)) as To_VerifyPhone; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static To_VerifyPhone create() => To_VerifyPhone._();
  To_VerifyPhone createEmptyInstance() => create();
  static $pb.PbList<To_VerifyPhone> createRepeated() => $pb.PbList<To_VerifyPhone>();
  @$core.pragma('dart2js:noInline')
  static To_VerifyPhone getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<To_VerifyPhone>(create);
  static To_VerifyPhone? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get phoneKey => $_getSZ(0);
  @$pb.TagNumber(1)
  set phoneKey($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPhoneKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearPhoneKey() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get code => $_getSZ(1);
  @$pb.TagNumber(2)
  set code($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearCode() => clearField(2);
}

class To_UnregisterPhone extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'To.UnregisterPhone', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'phoneKey')
  ;

  To_UnregisterPhone._() : super();
  factory To_UnregisterPhone({
    $core.String? phoneKey,
  }) {
    final _result = create();
    if (phoneKey != null) {
      _result.phoneKey = phoneKey;
    }
    return _result;
  }
  factory To_UnregisterPhone.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory To_UnregisterPhone.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  To_UnregisterPhone clone() => To_UnregisterPhone()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  To_UnregisterPhone copyWith(void Function(To_UnregisterPhone) updates) => super.copyWith((message) => updates(message as To_UnregisterPhone)) as To_UnregisterPhone; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static To_UnregisterPhone create() => To_UnregisterPhone._();
  To_UnregisterPhone createEmptyInstance() => create();
  static $pb.PbList<To_UnregisterPhone> createRepeated() => $pb.PbList<To_UnregisterPhone>();
  @$core.pragma('dart2js:noInline')
  static To_UnregisterPhone getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<To_UnregisterPhone>(create);
  static To_UnregisterPhone? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get phoneKey => $_getSZ(0);
  @$pb.TagNumber(1)
  set phoneKey($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPhoneKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearPhoneKey() => clearField(1);
}

class To_UploadAvatar extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'To.UploadAvatar', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'phoneKey')
    ..aQS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'image')
  ;

  To_UploadAvatar._() : super();
  factory To_UploadAvatar({
    $core.String? phoneKey,
    $core.String? image,
  }) {
    final _result = create();
    if (phoneKey != null) {
      _result.phoneKey = phoneKey;
    }
    if (image != null) {
      _result.image = image;
    }
    return _result;
  }
  factory To_UploadAvatar.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory To_UploadAvatar.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  To_UploadAvatar clone() => To_UploadAvatar()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  To_UploadAvatar copyWith(void Function(To_UploadAvatar) updates) => super.copyWith((message) => updates(message as To_UploadAvatar)) as To_UploadAvatar; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static To_UploadAvatar create() => To_UploadAvatar._();
  To_UploadAvatar createEmptyInstance() => create();
  static $pb.PbList<To_UploadAvatar> createRepeated() => $pb.PbList<To_UploadAvatar>();
  @$core.pragma('dart2js:noInline')
  static To_UploadAvatar getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<To_UploadAvatar>(create);
  static To_UploadAvatar? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get phoneKey => $_getSZ(0);
  @$pb.TagNumber(1)
  set phoneKey($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPhoneKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearPhoneKey() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get image => $_getSZ(1);
  @$pb.TagNumber(2)
  set image($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasImage() => $_has(1);
  @$pb.TagNumber(2)
  void clearImage() => clearField(2);
}

class To_UploadContacts extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'To.UploadContacts', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'phoneKey')
    ..pc<UploadContact>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'contacts', $pb.PbFieldType.PM, subBuilder: UploadContact.create)
  ;

  To_UploadContacts._() : super();
  factory To_UploadContacts({
    $core.String? phoneKey,
    $core.Iterable<UploadContact>? contacts,
  }) {
    final _result = create();
    if (phoneKey != null) {
      _result.phoneKey = phoneKey;
    }
    if (contacts != null) {
      _result.contacts.addAll(contacts);
    }
    return _result;
  }
  factory To_UploadContacts.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory To_UploadContacts.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  To_UploadContacts clone() => To_UploadContacts()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  To_UploadContacts copyWith(void Function(To_UploadContacts) updates) => super.copyWith((message) => updates(message as To_UploadContacts)) as To_UploadContacts; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static To_UploadContacts create() => To_UploadContacts._();
  To_UploadContacts createEmptyInstance() => create();
  static $pb.PbList<To_UploadContacts> createRepeated() => $pb.PbList<To_UploadContacts>();
  @$core.pragma('dart2js:noInline')
  static To_UploadContacts getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<To_UploadContacts>(create);
  static To_UploadContacts? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get phoneKey => $_getSZ(0);
  @$pb.TagNumber(1)
  set phoneKey($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPhoneKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearPhoneKey() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<UploadContact> get contacts => $_getList(1);
}

class To_SubmitOrder extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'To.SubmitOrder', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'assetId')
    ..a<$core.double>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'bitcoinAmount', $pb.PbFieldType.OD)
    ..a<$core.double>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'assetAmount', $pb.PbFieldType.OD)
    ..a<$core.double>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'price', $pb.PbFieldType.QD)
    ..a<$core.double>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'indexPrice', $pb.PbFieldType.OD)
    ..aQM<Account>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'account', subBuilder: Account.create)
  ;

  To_SubmitOrder._() : super();
  factory To_SubmitOrder({
    $core.String? assetId,
    $core.double? bitcoinAmount,
    $core.double? assetAmount,
    $core.double? price,
    $core.double? indexPrice,
    Account? account,
  }) {
    final _result = create();
    if (assetId != null) {
      _result.assetId = assetId;
    }
    if (bitcoinAmount != null) {
      _result.bitcoinAmount = bitcoinAmount;
    }
    if (assetAmount != null) {
      _result.assetAmount = assetAmount;
    }
    if (price != null) {
      _result.price = price;
    }
    if (indexPrice != null) {
      _result.indexPrice = indexPrice;
    }
    if (account != null) {
      _result.account = account;
    }
    return _result;
  }
  factory To_SubmitOrder.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory To_SubmitOrder.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  To_SubmitOrder clone() => To_SubmitOrder()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  To_SubmitOrder copyWith(void Function(To_SubmitOrder) updates) => super.copyWith((message) => updates(message as To_SubmitOrder)) as To_SubmitOrder; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static To_SubmitOrder create() => To_SubmitOrder._();
  To_SubmitOrder createEmptyInstance() => create();
  static $pb.PbList<To_SubmitOrder> createRepeated() => $pb.PbList<To_SubmitOrder>();
  @$core.pragma('dart2js:noInline')
  static To_SubmitOrder getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<To_SubmitOrder>(create);
  static To_SubmitOrder? _defaultInstance;

  @$pb.TagNumber(2)
  $core.String get assetId => $_getSZ(0);
  @$pb.TagNumber(2)
  set assetId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(2)
  $core.bool hasAssetId() => $_has(0);
  @$pb.TagNumber(2)
  void clearAssetId() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get bitcoinAmount => $_getN(1);
  @$pb.TagNumber(3)
  set bitcoinAmount($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(3)
  $core.bool hasBitcoinAmount() => $_has(1);
  @$pb.TagNumber(3)
  void clearBitcoinAmount() => clearField(3);

  @$pb.TagNumber(4)
  $core.double get assetAmount => $_getN(2);
  @$pb.TagNumber(4)
  set assetAmount($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(4)
  $core.bool hasAssetAmount() => $_has(2);
  @$pb.TagNumber(4)
  void clearAssetAmount() => clearField(4);

  @$pb.TagNumber(5)
  $core.double get price => $_getN(3);
  @$pb.TagNumber(5)
  set price($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(5)
  $core.bool hasPrice() => $_has(3);
  @$pb.TagNumber(5)
  void clearPrice() => clearField(5);

  @$pb.TagNumber(6)
  $core.double get indexPrice => $_getN(4);
  @$pb.TagNumber(6)
  set indexPrice($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(6)
  $core.bool hasIndexPrice() => $_has(4);
  @$pb.TagNumber(6)
  void clearIndexPrice() => clearField(6);

  @$pb.TagNumber(7)
  Account get account => $_getN(5);
  @$pb.TagNumber(7)
  set account(Account v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasAccount() => $_has(5);
  @$pb.TagNumber(7)
  void clearAccount() => clearField(7);
  @$pb.TagNumber(7)
  Account ensureAccount() => $_ensure(5);
}

class To_LinkOrder extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'To.LinkOrder', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'orderId')
  ;

  To_LinkOrder._() : super();
  factory To_LinkOrder({
    $core.String? orderId,
  }) {
    final _result = create();
    if (orderId != null) {
      _result.orderId = orderId;
    }
    return _result;
  }
  factory To_LinkOrder.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory To_LinkOrder.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  To_LinkOrder clone() => To_LinkOrder()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  To_LinkOrder copyWith(void Function(To_LinkOrder) updates) => super.copyWith((message) => updates(message as To_LinkOrder)) as To_LinkOrder; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static To_LinkOrder create() => To_LinkOrder._();
  To_LinkOrder createEmptyInstance() => create();
  static $pb.PbList<To_LinkOrder> createRepeated() => $pb.PbList<To_LinkOrder>();
  @$core.pragma('dart2js:noInline')
  static To_LinkOrder getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<To_LinkOrder>(create);
  static To_LinkOrder? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get orderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set orderId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrderId() => clearField(1);
}

class To_SubmitDecision extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'To.SubmitDecision', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'orderId')
    ..a<$core.bool>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'accept', $pb.PbFieldType.QB)
    ..aOB(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'autoSign')
    ..aOB(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'private')
    ..a<$fixnum.Int64>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ttlSeconds', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
  ;

  To_SubmitDecision._() : super();
  factory To_SubmitDecision({
    $core.String? orderId,
    $core.bool? accept,
    $core.bool? autoSign,
    $core.bool? private,
    $fixnum.Int64? ttlSeconds,
  }) {
    final _result = create();
    if (orderId != null) {
      _result.orderId = orderId;
    }
    if (accept != null) {
      _result.accept = accept;
    }
    if (autoSign != null) {
      _result.autoSign = autoSign;
    }
    if (private != null) {
      _result.private = private;
    }
    if (ttlSeconds != null) {
      _result.ttlSeconds = ttlSeconds;
    }
    return _result;
  }
  factory To_SubmitDecision.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory To_SubmitDecision.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  To_SubmitDecision clone() => To_SubmitDecision()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  To_SubmitDecision copyWith(void Function(To_SubmitDecision) updates) => super.copyWith((message) => updates(message as To_SubmitDecision)) as To_SubmitDecision; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static To_SubmitDecision create() => To_SubmitDecision._();
  To_SubmitDecision createEmptyInstance() => create();
  static $pb.PbList<To_SubmitDecision> createRepeated() => $pb.PbList<To_SubmitDecision>();
  @$core.pragma('dart2js:noInline')
  static To_SubmitDecision getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<To_SubmitDecision>(create);
  static To_SubmitDecision? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get orderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set orderId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrderId() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get accept => $_getBF(1);
  @$pb.TagNumber(2)
  set accept($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAccept() => $_has(1);
  @$pb.TagNumber(2)
  void clearAccept() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get autoSign => $_getBF(2);
  @$pb.TagNumber(3)
  set autoSign($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAutoSign() => $_has(2);
  @$pb.TagNumber(3)
  void clearAutoSign() => clearField(3);

  @$pb.TagNumber(4)
  $core.bool get private => $_getBF(3);
  @$pb.TagNumber(4)
  set private($core.bool v) { $_setBool(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasPrivate() => $_has(3);
  @$pb.TagNumber(4)
  void clearPrivate() => clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get ttlSeconds => $_getI64(4);
  @$pb.TagNumber(5)
  set ttlSeconds($fixnum.Int64 v) { $_setInt64(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasTtlSeconds() => $_has(4);
  @$pb.TagNumber(5)
  void clearTtlSeconds() => clearField(5);
}

enum To_EditOrder_Data {
  price, 
  indexPrice, 
  autoSign, 
  notSet
}

class To_EditOrder extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, To_EditOrder_Data> _To_EditOrder_DataByTag = {
    2 : To_EditOrder_Data.price,
    3 : To_EditOrder_Data.indexPrice,
    4 : To_EditOrder_Data.autoSign,
    0 : To_EditOrder_Data.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'To.EditOrder', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..oo(0, [2, 3, 4])
    ..aQS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'orderId')
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'price', $pb.PbFieldType.OD)
    ..a<$core.double>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'indexPrice', $pb.PbFieldType.OD)
    ..aOB(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'autoSign')
  ;

  To_EditOrder._() : super();
  factory To_EditOrder({
    $core.String? orderId,
    $core.double? price,
    $core.double? indexPrice,
    $core.bool? autoSign,
  }) {
    final _result = create();
    if (orderId != null) {
      _result.orderId = orderId;
    }
    if (price != null) {
      _result.price = price;
    }
    if (indexPrice != null) {
      _result.indexPrice = indexPrice;
    }
    if (autoSign != null) {
      _result.autoSign = autoSign;
    }
    return _result;
  }
  factory To_EditOrder.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory To_EditOrder.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  To_EditOrder clone() => To_EditOrder()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  To_EditOrder copyWith(void Function(To_EditOrder) updates) => super.copyWith((message) => updates(message as To_EditOrder)) as To_EditOrder; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static To_EditOrder create() => To_EditOrder._();
  To_EditOrder createEmptyInstance() => create();
  static $pb.PbList<To_EditOrder> createRepeated() => $pb.PbList<To_EditOrder>();
  @$core.pragma('dart2js:noInline')
  static To_EditOrder getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<To_EditOrder>(create);
  static To_EditOrder? _defaultInstance;

  To_EditOrder_Data whichData() => _To_EditOrder_DataByTag[$_whichOneof(0)]!;
  void clearData() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get orderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set orderId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrderId() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get price => $_getN(1);
  @$pb.TagNumber(2)
  set price($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPrice() => $_has(1);
  @$pb.TagNumber(2)
  void clearPrice() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get indexPrice => $_getN(2);
  @$pb.TagNumber(3)
  set indexPrice($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasIndexPrice() => $_has(2);
  @$pb.TagNumber(3)
  void clearIndexPrice() => clearField(3);

  @$pb.TagNumber(4)
  $core.bool get autoSign => $_getBF(3);
  @$pb.TagNumber(4)
  set autoSign($core.bool v) { $_setBool(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasAutoSign() => $_has(3);
  @$pb.TagNumber(4)
  void clearAutoSign() => clearField(4);
}

class To_CancelOrder extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'To.CancelOrder', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'orderId')
  ;

  To_CancelOrder._() : super();
  factory To_CancelOrder({
    $core.String? orderId,
  }) {
    final _result = create();
    if (orderId != null) {
      _result.orderId = orderId;
    }
    return _result;
  }
  factory To_CancelOrder.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory To_CancelOrder.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  To_CancelOrder clone() => To_CancelOrder()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  To_CancelOrder copyWith(void Function(To_CancelOrder) updates) => super.copyWith((message) => updates(message as To_CancelOrder)) as To_CancelOrder; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static To_CancelOrder create() => To_CancelOrder._();
  To_CancelOrder createEmptyInstance() => create();
  static $pb.PbList<To_CancelOrder> createRepeated() => $pb.PbList<To_CancelOrder>();
  @$core.pragma('dart2js:noInline')
  static To_CancelOrder getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<To_CancelOrder>(create);
  static To_CancelOrder? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get orderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set orderId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrderId() => clearField(1);
}

class To_Subscribe_Market extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'To.Subscribe.Market', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'assetId')
    ..hasRequiredFields = false
  ;

  To_Subscribe_Market._() : super();
  factory To_Subscribe_Market({
    $core.String? assetId,
  }) {
    final _result = create();
    if (assetId != null) {
      _result.assetId = assetId;
    }
    return _result;
  }
  factory To_Subscribe_Market.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory To_Subscribe_Market.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  To_Subscribe_Market clone() => To_Subscribe_Market()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  To_Subscribe_Market copyWith(void Function(To_Subscribe_Market) updates) => super.copyWith((message) => updates(message as To_Subscribe_Market)) as To_Subscribe_Market; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static To_Subscribe_Market create() => To_Subscribe_Market._();
  To_Subscribe_Market createEmptyInstance() => create();
  static $pb.PbList<To_Subscribe_Market> createRepeated() => $pb.PbList<To_Subscribe_Market>();
  @$core.pragma('dart2js:noInline')
  static To_Subscribe_Market getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<To_Subscribe_Market>(create);
  static To_Subscribe_Market? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assetId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetId() => clearField(1);
}

class To_Subscribe extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'To.Subscribe', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..pc<To_Subscribe_Market>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'markets', $pb.PbFieldType.PM, subBuilder: To_Subscribe_Market.create)
    ..hasRequiredFields = false
  ;

  To_Subscribe._() : super();
  factory To_Subscribe({
    $core.Iterable<To_Subscribe_Market>? markets,
  }) {
    final _result = create();
    if (markets != null) {
      _result.markets.addAll(markets);
    }
    return _result;
  }
  factory To_Subscribe.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory To_Subscribe.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  To_Subscribe clone() => To_Subscribe()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  To_Subscribe copyWith(void Function(To_Subscribe) updates) => super.copyWith((message) => updates(message as To_Subscribe)) as To_Subscribe; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static To_Subscribe create() => To_Subscribe._();
  To_Subscribe createEmptyInstance() => create();
  static $pb.PbList<To_Subscribe> createRepeated() => $pb.PbList<To_Subscribe>();
  @$core.pragma('dart2js:noInline')
  static To_Subscribe getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<To_Subscribe>(create);
  static To_Subscribe? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<To_Subscribe_Market> get markets => $_getList(0);
}

class To_SubscribePriceStream extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'To.SubscribePriceStream', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'assetId')
    ..a<$core.bool>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sendBitcoins', $pb.PbFieldType.QB)
    ..aInt64(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sendAmount')
    ..aInt64(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'recvAmount')
  ;

  To_SubscribePriceStream._() : super();
  factory To_SubscribePriceStream({
    $core.String? assetId,
    $core.bool? sendBitcoins,
    $fixnum.Int64? sendAmount,
    $fixnum.Int64? recvAmount,
  }) {
    final _result = create();
    if (assetId != null) {
      _result.assetId = assetId;
    }
    if (sendBitcoins != null) {
      _result.sendBitcoins = sendBitcoins;
    }
    if (sendAmount != null) {
      _result.sendAmount = sendAmount;
    }
    if (recvAmount != null) {
      _result.recvAmount = recvAmount;
    }
    return _result;
  }
  factory To_SubscribePriceStream.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory To_SubscribePriceStream.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  To_SubscribePriceStream clone() => To_SubscribePriceStream()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  To_SubscribePriceStream copyWith(void Function(To_SubscribePriceStream) updates) => super.copyWith((message) => updates(message as To_SubscribePriceStream)) as To_SubscribePriceStream; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static To_SubscribePriceStream create() => To_SubscribePriceStream._();
  To_SubscribePriceStream createEmptyInstance() => create();
  static $pb.PbList<To_SubscribePriceStream> createRepeated() => $pb.PbList<To_SubscribePriceStream>();
  @$core.pragma('dart2js:noInline')
  static To_SubscribePriceStream getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<To_SubscribePriceStream>(create);
  static To_SubscribePriceStream? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assetId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetId() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get sendBitcoins => $_getBF(1);
  @$pb.TagNumber(2)
  set sendBitcoins($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSendBitcoins() => $_has(1);
  @$pb.TagNumber(2)
  void clearSendBitcoins() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get sendAmount => $_getI64(2);
  @$pb.TagNumber(3)
  set sendAmount($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSendAmount() => $_has(2);
  @$pb.TagNumber(3)
  void clearSendAmount() => clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get recvAmount => $_getI64(3);
  @$pb.TagNumber(4)
  set recvAmount($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasRecvAmount() => $_has(3);
  @$pb.TagNumber(4)
  void clearRecvAmount() => clearField(4);
}

class To_MarketDataSubscribe extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'To.MarketDataSubscribe', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'assetId')
  ;

  To_MarketDataSubscribe._() : super();
  factory To_MarketDataSubscribe({
    $core.String? assetId,
  }) {
    final _result = create();
    if (assetId != null) {
      _result.assetId = assetId;
    }
    return _result;
  }
  factory To_MarketDataSubscribe.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory To_MarketDataSubscribe.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  To_MarketDataSubscribe clone() => To_MarketDataSubscribe()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  To_MarketDataSubscribe copyWith(void Function(To_MarketDataSubscribe) updates) => super.copyWith((message) => updates(message as To_MarketDataSubscribe)) as To_MarketDataSubscribe; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static To_MarketDataSubscribe create() => To_MarketDataSubscribe._();
  To_MarketDataSubscribe createEmptyInstance() => create();
  static $pb.PbList<To_MarketDataSubscribe> createRepeated() => $pb.PbList<To_MarketDataSubscribe>();
  @$core.pragma('dart2js:noInline')
  static To_MarketDataSubscribe getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<To_MarketDataSubscribe>(create);
  static To_MarketDataSubscribe? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assetId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetId() => clearField(1);
}

class To_JadeAction extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'To.JadeAction', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQM<Account>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'account', subBuilder: Account.create)
    ..e<To_JadeAction_Action>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'action', $pb.PbFieldType.QE, defaultOrMaker: To_JadeAction_Action.UNLOCK, valueOf: To_JadeAction_Action.valueOf, enumValues: To_JadeAction_Action.values)
  ;

  To_JadeAction._() : super();
  factory To_JadeAction({
    Account? account,
    To_JadeAction_Action? action,
  }) {
    final _result = create();
    if (account != null) {
      _result.account = account;
    }
    if (action != null) {
      _result.action = action;
    }
    return _result;
  }
  factory To_JadeAction.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory To_JadeAction.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  To_JadeAction clone() => To_JadeAction()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  To_JadeAction copyWith(void Function(To_JadeAction) updates) => super.copyWith((message) => updates(message as To_JadeAction)) as To_JadeAction; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static To_JadeAction create() => To_JadeAction._();
  To_JadeAction createEmptyInstance() => create();
  static $pb.PbList<To_JadeAction> createRepeated() => $pb.PbList<To_JadeAction>();
  @$core.pragma('dart2js:noInline')
  static To_JadeAction getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<To_JadeAction>(create);
  static To_JadeAction? _defaultInstance;

  @$pb.TagNumber(1)
  Account get account => $_getN(0);
  @$pb.TagNumber(1)
  set account(Account v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasAccount() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccount() => clearField(1);
  @$pb.TagNumber(1)
  Account ensureAccount() => $_ensure(0);

  @$pb.TagNumber(2)
  To_JadeAction_Action get action => $_getN(1);
  @$pb.TagNumber(2)
  set action(To_JadeAction_Action v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasAction() => $_has(1);
  @$pb.TagNumber(2)
  void clearAction() => clearField(2);
}

enum To_Msg {
  login, 
  logout, 
  updatePushToken, 
  encryptPin, 
  decryptPin, 
  pushMessage, 
  appState, 
  changeNetwork, 
  setMemo, 
  getRecvAddress, 
  createTx, 
  sendTx, 
  blindedValues, 
  swapRequest, 
  pegInRequest, 
  pegOutRequest, 
  swapAccept, 
  registerPhone, 
  verifyPhone, 
  uploadAvatar, 
  uploadContacts, 
  unregisterPhone, 
  submitOrder, 
  linkOrder, 
  submitDecision, 
  editOrder, 
  cancelOrder, 
  subscribe, 
  subscribePrice, 
  unsubscribePrice, 
  assetDetails, 
  subscribePriceStream, 
  unsubscribePriceStream, 
  marketDataSubscribe, 
  marketDataUnsubscribe, 
  jadeAction, 
  notSet
}

class To extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, To_Msg> _To_MsgByTag = {
    1 : To_Msg.login,
    2 : To_Msg.logout,
    3 : To_Msg.updatePushToken,
    4 : To_Msg.encryptPin,
    5 : To_Msg.decryptPin,
    6 : To_Msg.pushMessage,
    8 : To_Msg.appState,
    9 : To_Msg.changeNetwork,
    10 : To_Msg.setMemo,
    11 : To_Msg.getRecvAddress,
    12 : To_Msg.createTx,
    13 : To_Msg.sendTx,
    14 : To_Msg.blindedValues,
    20 : To_Msg.swapRequest,
    21 : To_Msg.pegInRequest,
    22 : To_Msg.pegOutRequest,
    23 : To_Msg.swapAccept,
    40 : To_Msg.registerPhone,
    41 : To_Msg.verifyPhone,
    42 : To_Msg.uploadAvatar,
    43 : To_Msg.uploadContacts,
    44 : To_Msg.unregisterPhone,
    49 : To_Msg.submitOrder,
    50 : To_Msg.linkOrder,
    51 : To_Msg.submitDecision,
    52 : To_Msg.editOrder,
    53 : To_Msg.cancelOrder,
    54 : To_Msg.subscribe,
    55 : To_Msg.subscribePrice,
    56 : To_Msg.unsubscribePrice,
    57 : To_Msg.assetDetails,
    58 : To_Msg.subscribePriceStream,
    59 : To_Msg.unsubscribePriceStream,
    60 : To_Msg.marketDataSubscribe,
    61 : To_Msg.marketDataUnsubscribe,
    70 : To_Msg.jadeAction,
    0 : To_Msg.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'To', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4, 5, 6, 8, 9, 10, 11, 12, 13, 14, 20, 21, 22, 23, 40, 41, 42, 43, 44, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 70])
    ..aOM<To_Login>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'login', subBuilder: To_Login.create)
    ..aOM<Empty>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'logout', subBuilder: Empty.create)
    ..aOM<To_UpdatePushToken>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'updatePushToken', subBuilder: To_UpdatePushToken.create)
    ..aOM<To_EncryptPin>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'encryptPin', subBuilder: To_EncryptPin.create)
    ..aOM<To_DecryptPin>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'decryptPin', subBuilder: To_DecryptPin.create)
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pushMessage')
    ..aOM<To_AppState>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'appState', subBuilder: To_AppState.create)
    ..aOM<To_ChangeNetwork>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'changeNetwork', subBuilder: To_ChangeNetwork.create)
    ..aOM<To_SetMemo>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'setMemo', subBuilder: To_SetMemo.create)
    ..aOM<Account>(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'getRecvAddress', subBuilder: Account.create)
    ..aOM<CreateTx>(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'createTx', subBuilder: CreateTx.create)
    ..aOM<To_SendTx>(13, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sendTx', subBuilder: To_SendTx.create)
    ..aOM<To_BlindedValues>(14, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'blindedValues', subBuilder: To_BlindedValues.create)
    ..aOM<To_SwapRequest>(20, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'swapRequest', subBuilder: To_SwapRequest.create)
    ..aOM<To_PegInRequest>(21, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pegInRequest', subBuilder: To_PegInRequest.create)
    ..aOM<To_PegOutRequest>(22, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pegOutRequest', subBuilder: To_PegOutRequest.create)
    ..aOM<SwapDetails>(23, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'swapAccept', subBuilder: SwapDetails.create)
    ..aOM<To_RegisterPhone>(40, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'registerPhone', subBuilder: To_RegisterPhone.create)
    ..aOM<To_VerifyPhone>(41, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'verifyPhone', subBuilder: To_VerifyPhone.create)
    ..aOM<To_UploadAvatar>(42, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'uploadAvatar', subBuilder: To_UploadAvatar.create)
    ..aOM<To_UploadContacts>(43, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'uploadContacts', subBuilder: To_UploadContacts.create)
    ..aOM<To_UnregisterPhone>(44, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'unregisterPhone', subBuilder: To_UnregisterPhone.create)
    ..aOM<To_SubmitOrder>(49, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'submitOrder', subBuilder: To_SubmitOrder.create)
    ..aOM<To_LinkOrder>(50, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'linkOrder', subBuilder: To_LinkOrder.create)
    ..aOM<To_SubmitDecision>(51, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'submitDecision', subBuilder: To_SubmitDecision.create)
    ..aOM<To_EditOrder>(52, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'editOrder', subBuilder: To_EditOrder.create)
    ..aOM<To_CancelOrder>(53, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'cancelOrder', subBuilder: To_CancelOrder.create)
    ..aOM<To_Subscribe>(54, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'subscribe', subBuilder: To_Subscribe.create)
    ..aOM<AssetId>(55, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'subscribePrice', subBuilder: AssetId.create)
    ..aOM<AssetId>(56, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'unsubscribePrice', subBuilder: AssetId.create)
    ..aOM<AssetId>(57, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'assetDetails', subBuilder: AssetId.create)
    ..aOM<To_SubscribePriceStream>(58, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'subscribePriceStream', subBuilder: To_SubscribePriceStream.create)
    ..aOM<Empty>(59, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'unsubscribePriceStream', subBuilder: Empty.create)
    ..aOM<To_MarketDataSubscribe>(60, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'marketDataSubscribe', subBuilder: To_MarketDataSubscribe.create)
    ..aOM<Empty>(61, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'marketDataUnsubscribe', subBuilder: Empty.create)
    ..aOM<To_JadeAction>(70, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'jadeAction', subBuilder: To_JadeAction.create)
  ;

  To._() : super();
  factory To({
    To_Login? login,
    Empty? logout,
    To_UpdatePushToken? updatePushToken,
    To_EncryptPin? encryptPin,
    To_DecryptPin? decryptPin,
    $core.String? pushMessage,
    To_AppState? appState,
    To_ChangeNetwork? changeNetwork,
    To_SetMemo? setMemo,
    Account? getRecvAddress,
    CreateTx? createTx,
    To_SendTx? sendTx,
    To_BlindedValues? blindedValues,
    To_SwapRequest? swapRequest,
    To_PegInRequest? pegInRequest,
    To_PegOutRequest? pegOutRequest,
    SwapDetails? swapAccept,
    To_RegisterPhone? registerPhone,
    To_VerifyPhone? verifyPhone,
    To_UploadAvatar? uploadAvatar,
    To_UploadContacts? uploadContacts,
    To_UnregisterPhone? unregisterPhone,
    To_SubmitOrder? submitOrder,
    To_LinkOrder? linkOrder,
    To_SubmitDecision? submitDecision,
    To_EditOrder? editOrder,
    To_CancelOrder? cancelOrder,
    To_Subscribe? subscribe,
    AssetId? subscribePrice,
    AssetId? unsubscribePrice,
    AssetId? assetDetails,
    To_SubscribePriceStream? subscribePriceStream,
    Empty? unsubscribePriceStream,
    To_MarketDataSubscribe? marketDataSubscribe,
    Empty? marketDataUnsubscribe,
    To_JadeAction? jadeAction,
  }) {
    final _result = create();
    if (login != null) {
      _result.login = login;
    }
    if (logout != null) {
      _result.logout = logout;
    }
    if (updatePushToken != null) {
      _result.updatePushToken = updatePushToken;
    }
    if (encryptPin != null) {
      _result.encryptPin = encryptPin;
    }
    if (decryptPin != null) {
      _result.decryptPin = decryptPin;
    }
    if (pushMessage != null) {
      _result.pushMessage = pushMessage;
    }
    if (appState != null) {
      _result.appState = appState;
    }
    if (changeNetwork != null) {
      _result.changeNetwork = changeNetwork;
    }
    if (setMemo != null) {
      _result.setMemo = setMemo;
    }
    if (getRecvAddress != null) {
      _result.getRecvAddress = getRecvAddress;
    }
    if (createTx != null) {
      _result.createTx = createTx;
    }
    if (sendTx != null) {
      _result.sendTx = sendTx;
    }
    if (blindedValues != null) {
      _result.blindedValues = blindedValues;
    }
    if (swapRequest != null) {
      _result.swapRequest = swapRequest;
    }
    if (pegInRequest != null) {
      _result.pegInRequest = pegInRequest;
    }
    if (pegOutRequest != null) {
      _result.pegOutRequest = pegOutRequest;
    }
    if (swapAccept != null) {
      _result.swapAccept = swapAccept;
    }
    if (registerPhone != null) {
      _result.registerPhone = registerPhone;
    }
    if (verifyPhone != null) {
      _result.verifyPhone = verifyPhone;
    }
    if (uploadAvatar != null) {
      _result.uploadAvatar = uploadAvatar;
    }
    if (uploadContacts != null) {
      _result.uploadContacts = uploadContacts;
    }
    if (unregisterPhone != null) {
      _result.unregisterPhone = unregisterPhone;
    }
    if (submitOrder != null) {
      _result.submitOrder = submitOrder;
    }
    if (linkOrder != null) {
      _result.linkOrder = linkOrder;
    }
    if (submitDecision != null) {
      _result.submitDecision = submitDecision;
    }
    if (editOrder != null) {
      _result.editOrder = editOrder;
    }
    if (cancelOrder != null) {
      _result.cancelOrder = cancelOrder;
    }
    if (subscribe != null) {
      _result.subscribe = subscribe;
    }
    if (subscribePrice != null) {
      _result.subscribePrice = subscribePrice;
    }
    if (unsubscribePrice != null) {
      _result.unsubscribePrice = unsubscribePrice;
    }
    if (assetDetails != null) {
      _result.assetDetails = assetDetails;
    }
    if (subscribePriceStream != null) {
      _result.subscribePriceStream = subscribePriceStream;
    }
    if (unsubscribePriceStream != null) {
      _result.unsubscribePriceStream = unsubscribePriceStream;
    }
    if (marketDataSubscribe != null) {
      _result.marketDataSubscribe = marketDataSubscribe;
    }
    if (marketDataUnsubscribe != null) {
      _result.marketDataUnsubscribe = marketDataUnsubscribe;
    }
    if (jadeAction != null) {
      _result.jadeAction = jadeAction;
    }
    return _result;
  }
  factory To.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory To.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  To clone() => To()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  To copyWith(void Function(To) updates) => super.copyWith((message) => updates(message as To)) as To; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static To create() => To._();
  To createEmptyInstance() => create();
  static $pb.PbList<To> createRepeated() => $pb.PbList<To>();
  @$core.pragma('dart2js:noInline')
  static To getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<To>(create);
  static To? _defaultInstance;

  To_Msg whichMsg() => _To_MsgByTag[$_whichOneof(0)]!;
  void clearMsg() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  To_Login get login => $_getN(0);
  @$pb.TagNumber(1)
  set login(To_Login v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasLogin() => $_has(0);
  @$pb.TagNumber(1)
  void clearLogin() => clearField(1);
  @$pb.TagNumber(1)
  To_Login ensureLogin() => $_ensure(0);

  @$pb.TagNumber(2)
  Empty get logout => $_getN(1);
  @$pb.TagNumber(2)
  set logout(Empty v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasLogout() => $_has(1);
  @$pb.TagNumber(2)
  void clearLogout() => clearField(2);
  @$pb.TagNumber(2)
  Empty ensureLogout() => $_ensure(1);

  @$pb.TagNumber(3)
  To_UpdatePushToken get updatePushToken => $_getN(2);
  @$pb.TagNumber(3)
  set updatePushToken(To_UpdatePushToken v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasUpdatePushToken() => $_has(2);
  @$pb.TagNumber(3)
  void clearUpdatePushToken() => clearField(3);
  @$pb.TagNumber(3)
  To_UpdatePushToken ensureUpdatePushToken() => $_ensure(2);

  @$pb.TagNumber(4)
  To_EncryptPin get encryptPin => $_getN(3);
  @$pb.TagNumber(4)
  set encryptPin(To_EncryptPin v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasEncryptPin() => $_has(3);
  @$pb.TagNumber(4)
  void clearEncryptPin() => clearField(4);
  @$pb.TagNumber(4)
  To_EncryptPin ensureEncryptPin() => $_ensure(3);

  @$pb.TagNumber(5)
  To_DecryptPin get decryptPin => $_getN(4);
  @$pb.TagNumber(5)
  set decryptPin(To_DecryptPin v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasDecryptPin() => $_has(4);
  @$pb.TagNumber(5)
  void clearDecryptPin() => clearField(5);
  @$pb.TagNumber(5)
  To_DecryptPin ensureDecryptPin() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.String get pushMessage => $_getSZ(5);
  @$pb.TagNumber(6)
  set pushMessage($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasPushMessage() => $_has(5);
  @$pb.TagNumber(6)
  void clearPushMessage() => clearField(6);

  @$pb.TagNumber(8)
  To_AppState get appState => $_getN(6);
  @$pb.TagNumber(8)
  set appState(To_AppState v) { setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasAppState() => $_has(6);
  @$pb.TagNumber(8)
  void clearAppState() => clearField(8);
  @$pb.TagNumber(8)
  To_AppState ensureAppState() => $_ensure(6);

  @$pb.TagNumber(9)
  To_ChangeNetwork get changeNetwork => $_getN(7);
  @$pb.TagNumber(9)
  set changeNetwork(To_ChangeNetwork v) { setField(9, v); }
  @$pb.TagNumber(9)
  $core.bool hasChangeNetwork() => $_has(7);
  @$pb.TagNumber(9)
  void clearChangeNetwork() => clearField(9);
  @$pb.TagNumber(9)
  To_ChangeNetwork ensureChangeNetwork() => $_ensure(7);

  @$pb.TagNumber(10)
  To_SetMemo get setMemo => $_getN(8);
  @$pb.TagNumber(10)
  set setMemo(To_SetMemo v) { setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasSetMemo() => $_has(8);
  @$pb.TagNumber(10)
  void clearSetMemo() => clearField(10);
  @$pb.TagNumber(10)
  To_SetMemo ensureSetMemo() => $_ensure(8);

  @$pb.TagNumber(11)
  Account get getRecvAddress => $_getN(9);
  @$pb.TagNumber(11)
  set getRecvAddress(Account v) { setField(11, v); }
  @$pb.TagNumber(11)
  $core.bool hasGetRecvAddress() => $_has(9);
  @$pb.TagNumber(11)
  void clearGetRecvAddress() => clearField(11);
  @$pb.TagNumber(11)
  Account ensureGetRecvAddress() => $_ensure(9);

  @$pb.TagNumber(12)
  CreateTx get createTx => $_getN(10);
  @$pb.TagNumber(12)
  set createTx(CreateTx v) { setField(12, v); }
  @$pb.TagNumber(12)
  $core.bool hasCreateTx() => $_has(10);
  @$pb.TagNumber(12)
  void clearCreateTx() => clearField(12);
  @$pb.TagNumber(12)
  CreateTx ensureCreateTx() => $_ensure(10);

  @$pb.TagNumber(13)
  To_SendTx get sendTx => $_getN(11);
  @$pb.TagNumber(13)
  set sendTx(To_SendTx v) { setField(13, v); }
  @$pb.TagNumber(13)
  $core.bool hasSendTx() => $_has(11);
  @$pb.TagNumber(13)
  void clearSendTx() => clearField(13);
  @$pb.TagNumber(13)
  To_SendTx ensureSendTx() => $_ensure(11);

  @$pb.TagNumber(14)
  To_BlindedValues get blindedValues => $_getN(12);
  @$pb.TagNumber(14)
  set blindedValues(To_BlindedValues v) { setField(14, v); }
  @$pb.TagNumber(14)
  $core.bool hasBlindedValues() => $_has(12);
  @$pb.TagNumber(14)
  void clearBlindedValues() => clearField(14);
  @$pb.TagNumber(14)
  To_BlindedValues ensureBlindedValues() => $_ensure(12);

  @$pb.TagNumber(20)
  To_SwapRequest get swapRequest => $_getN(13);
  @$pb.TagNumber(20)
  set swapRequest(To_SwapRequest v) { setField(20, v); }
  @$pb.TagNumber(20)
  $core.bool hasSwapRequest() => $_has(13);
  @$pb.TagNumber(20)
  void clearSwapRequest() => clearField(20);
  @$pb.TagNumber(20)
  To_SwapRequest ensureSwapRequest() => $_ensure(13);

  @$pb.TagNumber(21)
  To_PegInRequest get pegInRequest => $_getN(14);
  @$pb.TagNumber(21)
  set pegInRequest(To_PegInRequest v) { setField(21, v); }
  @$pb.TagNumber(21)
  $core.bool hasPegInRequest() => $_has(14);
  @$pb.TagNumber(21)
  void clearPegInRequest() => clearField(21);
  @$pb.TagNumber(21)
  To_PegInRequest ensurePegInRequest() => $_ensure(14);

  @$pb.TagNumber(22)
  To_PegOutRequest get pegOutRequest => $_getN(15);
  @$pb.TagNumber(22)
  set pegOutRequest(To_PegOutRequest v) { setField(22, v); }
  @$pb.TagNumber(22)
  $core.bool hasPegOutRequest() => $_has(15);
  @$pb.TagNumber(22)
  void clearPegOutRequest() => clearField(22);
  @$pb.TagNumber(22)
  To_PegOutRequest ensurePegOutRequest() => $_ensure(15);

  @$pb.TagNumber(23)
  SwapDetails get swapAccept => $_getN(16);
  @$pb.TagNumber(23)
  set swapAccept(SwapDetails v) { setField(23, v); }
  @$pb.TagNumber(23)
  $core.bool hasSwapAccept() => $_has(16);
  @$pb.TagNumber(23)
  void clearSwapAccept() => clearField(23);
  @$pb.TagNumber(23)
  SwapDetails ensureSwapAccept() => $_ensure(16);

  @$pb.TagNumber(40)
  To_RegisterPhone get registerPhone => $_getN(17);
  @$pb.TagNumber(40)
  set registerPhone(To_RegisterPhone v) { setField(40, v); }
  @$pb.TagNumber(40)
  $core.bool hasRegisterPhone() => $_has(17);
  @$pb.TagNumber(40)
  void clearRegisterPhone() => clearField(40);
  @$pb.TagNumber(40)
  To_RegisterPhone ensureRegisterPhone() => $_ensure(17);

  @$pb.TagNumber(41)
  To_VerifyPhone get verifyPhone => $_getN(18);
  @$pb.TagNumber(41)
  set verifyPhone(To_VerifyPhone v) { setField(41, v); }
  @$pb.TagNumber(41)
  $core.bool hasVerifyPhone() => $_has(18);
  @$pb.TagNumber(41)
  void clearVerifyPhone() => clearField(41);
  @$pb.TagNumber(41)
  To_VerifyPhone ensureVerifyPhone() => $_ensure(18);

  @$pb.TagNumber(42)
  To_UploadAvatar get uploadAvatar => $_getN(19);
  @$pb.TagNumber(42)
  set uploadAvatar(To_UploadAvatar v) { setField(42, v); }
  @$pb.TagNumber(42)
  $core.bool hasUploadAvatar() => $_has(19);
  @$pb.TagNumber(42)
  void clearUploadAvatar() => clearField(42);
  @$pb.TagNumber(42)
  To_UploadAvatar ensureUploadAvatar() => $_ensure(19);

  @$pb.TagNumber(43)
  To_UploadContacts get uploadContacts => $_getN(20);
  @$pb.TagNumber(43)
  set uploadContacts(To_UploadContacts v) { setField(43, v); }
  @$pb.TagNumber(43)
  $core.bool hasUploadContacts() => $_has(20);
  @$pb.TagNumber(43)
  void clearUploadContacts() => clearField(43);
  @$pb.TagNumber(43)
  To_UploadContacts ensureUploadContacts() => $_ensure(20);

  @$pb.TagNumber(44)
  To_UnregisterPhone get unregisterPhone => $_getN(21);
  @$pb.TagNumber(44)
  set unregisterPhone(To_UnregisterPhone v) { setField(44, v); }
  @$pb.TagNumber(44)
  $core.bool hasUnregisterPhone() => $_has(21);
  @$pb.TagNumber(44)
  void clearUnregisterPhone() => clearField(44);
  @$pb.TagNumber(44)
  To_UnregisterPhone ensureUnregisterPhone() => $_ensure(21);

  @$pb.TagNumber(49)
  To_SubmitOrder get submitOrder => $_getN(22);
  @$pb.TagNumber(49)
  set submitOrder(To_SubmitOrder v) { setField(49, v); }
  @$pb.TagNumber(49)
  $core.bool hasSubmitOrder() => $_has(22);
  @$pb.TagNumber(49)
  void clearSubmitOrder() => clearField(49);
  @$pb.TagNumber(49)
  To_SubmitOrder ensureSubmitOrder() => $_ensure(22);

  @$pb.TagNumber(50)
  To_LinkOrder get linkOrder => $_getN(23);
  @$pb.TagNumber(50)
  set linkOrder(To_LinkOrder v) { setField(50, v); }
  @$pb.TagNumber(50)
  $core.bool hasLinkOrder() => $_has(23);
  @$pb.TagNumber(50)
  void clearLinkOrder() => clearField(50);
  @$pb.TagNumber(50)
  To_LinkOrder ensureLinkOrder() => $_ensure(23);

  @$pb.TagNumber(51)
  To_SubmitDecision get submitDecision => $_getN(24);
  @$pb.TagNumber(51)
  set submitDecision(To_SubmitDecision v) { setField(51, v); }
  @$pb.TagNumber(51)
  $core.bool hasSubmitDecision() => $_has(24);
  @$pb.TagNumber(51)
  void clearSubmitDecision() => clearField(51);
  @$pb.TagNumber(51)
  To_SubmitDecision ensureSubmitDecision() => $_ensure(24);

  @$pb.TagNumber(52)
  To_EditOrder get editOrder => $_getN(25);
  @$pb.TagNumber(52)
  set editOrder(To_EditOrder v) { setField(52, v); }
  @$pb.TagNumber(52)
  $core.bool hasEditOrder() => $_has(25);
  @$pb.TagNumber(52)
  void clearEditOrder() => clearField(52);
  @$pb.TagNumber(52)
  To_EditOrder ensureEditOrder() => $_ensure(25);

  @$pb.TagNumber(53)
  To_CancelOrder get cancelOrder => $_getN(26);
  @$pb.TagNumber(53)
  set cancelOrder(To_CancelOrder v) { setField(53, v); }
  @$pb.TagNumber(53)
  $core.bool hasCancelOrder() => $_has(26);
  @$pb.TagNumber(53)
  void clearCancelOrder() => clearField(53);
  @$pb.TagNumber(53)
  To_CancelOrder ensureCancelOrder() => $_ensure(26);

  @$pb.TagNumber(54)
  To_Subscribe get subscribe => $_getN(27);
  @$pb.TagNumber(54)
  set subscribe(To_Subscribe v) { setField(54, v); }
  @$pb.TagNumber(54)
  $core.bool hasSubscribe() => $_has(27);
  @$pb.TagNumber(54)
  void clearSubscribe() => clearField(54);
  @$pb.TagNumber(54)
  To_Subscribe ensureSubscribe() => $_ensure(27);

  @$pb.TagNumber(55)
  AssetId get subscribePrice => $_getN(28);
  @$pb.TagNumber(55)
  set subscribePrice(AssetId v) { setField(55, v); }
  @$pb.TagNumber(55)
  $core.bool hasSubscribePrice() => $_has(28);
  @$pb.TagNumber(55)
  void clearSubscribePrice() => clearField(55);
  @$pb.TagNumber(55)
  AssetId ensureSubscribePrice() => $_ensure(28);

  @$pb.TagNumber(56)
  AssetId get unsubscribePrice => $_getN(29);
  @$pb.TagNumber(56)
  set unsubscribePrice(AssetId v) { setField(56, v); }
  @$pb.TagNumber(56)
  $core.bool hasUnsubscribePrice() => $_has(29);
  @$pb.TagNumber(56)
  void clearUnsubscribePrice() => clearField(56);
  @$pb.TagNumber(56)
  AssetId ensureUnsubscribePrice() => $_ensure(29);

  @$pb.TagNumber(57)
  AssetId get assetDetails => $_getN(30);
  @$pb.TagNumber(57)
  set assetDetails(AssetId v) { setField(57, v); }
  @$pb.TagNumber(57)
  $core.bool hasAssetDetails() => $_has(30);
  @$pb.TagNumber(57)
  void clearAssetDetails() => clearField(57);
  @$pb.TagNumber(57)
  AssetId ensureAssetDetails() => $_ensure(30);

  @$pb.TagNumber(58)
  To_SubscribePriceStream get subscribePriceStream => $_getN(31);
  @$pb.TagNumber(58)
  set subscribePriceStream(To_SubscribePriceStream v) { setField(58, v); }
  @$pb.TagNumber(58)
  $core.bool hasSubscribePriceStream() => $_has(31);
  @$pb.TagNumber(58)
  void clearSubscribePriceStream() => clearField(58);
  @$pb.TagNumber(58)
  To_SubscribePriceStream ensureSubscribePriceStream() => $_ensure(31);

  @$pb.TagNumber(59)
  Empty get unsubscribePriceStream => $_getN(32);
  @$pb.TagNumber(59)
  set unsubscribePriceStream(Empty v) { setField(59, v); }
  @$pb.TagNumber(59)
  $core.bool hasUnsubscribePriceStream() => $_has(32);
  @$pb.TagNumber(59)
  void clearUnsubscribePriceStream() => clearField(59);
  @$pb.TagNumber(59)
  Empty ensureUnsubscribePriceStream() => $_ensure(32);

  @$pb.TagNumber(60)
  To_MarketDataSubscribe get marketDataSubscribe => $_getN(33);
  @$pb.TagNumber(60)
  set marketDataSubscribe(To_MarketDataSubscribe v) { setField(60, v); }
  @$pb.TagNumber(60)
  $core.bool hasMarketDataSubscribe() => $_has(33);
  @$pb.TagNumber(60)
  void clearMarketDataSubscribe() => clearField(60);
  @$pb.TagNumber(60)
  To_MarketDataSubscribe ensureMarketDataSubscribe() => $_ensure(33);

  @$pb.TagNumber(61)
  Empty get marketDataUnsubscribe => $_getN(34);
  @$pb.TagNumber(61)
  set marketDataUnsubscribe(Empty v) { setField(61, v); }
  @$pb.TagNumber(61)
  $core.bool hasMarketDataUnsubscribe() => $_has(34);
  @$pb.TagNumber(61)
  void clearMarketDataUnsubscribe() => clearField(61);
  @$pb.TagNumber(61)
  Empty ensureMarketDataUnsubscribe() => $_ensure(34);

  @$pb.TagNumber(70)
  To_JadeAction get jadeAction => $_getN(35);
  @$pb.TagNumber(70)
  set jadeAction(To_JadeAction v) { setField(70, v); }
  @$pb.TagNumber(70)
  $core.bool hasJadeAction() => $_has(35);
  @$pb.TagNumber(70)
  void clearJadeAction() => clearField(70);
  @$pb.TagNumber(70)
  To_JadeAction ensureJadeAction() => $_ensure(35);
}

class From_EnvSettings extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'From.EnvSettings', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'policyAssetId')
    ..aQS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'usdtAssetId')
    ..aQS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'eurxAssetId')
  ;

  From_EnvSettings._() : super();
  factory From_EnvSettings({
    $core.String? policyAssetId,
    $core.String? usdtAssetId,
    $core.String? eurxAssetId,
  }) {
    final _result = create();
    if (policyAssetId != null) {
      _result.policyAssetId = policyAssetId;
    }
    if (usdtAssetId != null) {
      _result.usdtAssetId = usdtAssetId;
    }
    if (eurxAssetId != null) {
      _result.eurxAssetId = eurxAssetId;
    }
    return _result;
  }
  factory From_EnvSettings.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_EnvSettings.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_EnvSettings clone() => From_EnvSettings()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_EnvSettings copyWith(void Function(From_EnvSettings) updates) => super.copyWith((message) => updates(message as From_EnvSettings)) as From_EnvSettings; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static From_EnvSettings create() => From_EnvSettings._();
  From_EnvSettings createEmptyInstance() => create();
  static $pb.PbList<From_EnvSettings> createRepeated() => $pb.PbList<From_EnvSettings>();
  @$core.pragma('dart2js:noInline')
  static From_EnvSettings getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_EnvSettings>(create);
  static From_EnvSettings? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get policyAssetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set policyAssetId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPolicyAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPolicyAssetId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get usdtAssetId => $_getSZ(1);
  @$pb.TagNumber(2)
  set usdtAssetId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasUsdtAssetId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUsdtAssetId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get eurxAssetId => $_getSZ(2);
  @$pb.TagNumber(3)
  set eurxAssetId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasEurxAssetId() => $_has(2);
  @$pb.TagNumber(3)
  void clearEurxAssetId() => clearField(3);
}

class From_EncryptPin_Data extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'From.EncryptPin.Data', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'salt')
    ..aQS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'encryptedData')
    ..aQS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pinIdentifier')
  ;

  From_EncryptPin_Data._() : super();
  factory From_EncryptPin_Data({
    $core.String? salt,
    $core.String? encryptedData,
    $core.String? pinIdentifier,
  }) {
    final _result = create();
    if (salt != null) {
      _result.salt = salt;
    }
    if (encryptedData != null) {
      _result.encryptedData = encryptedData;
    }
    if (pinIdentifier != null) {
      _result.pinIdentifier = pinIdentifier;
    }
    return _result;
  }
  factory From_EncryptPin_Data.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_EncryptPin_Data.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_EncryptPin_Data clone() => From_EncryptPin_Data()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_EncryptPin_Data copyWith(void Function(From_EncryptPin_Data) updates) => super.copyWith((message) => updates(message as From_EncryptPin_Data)) as From_EncryptPin_Data; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static From_EncryptPin_Data create() => From_EncryptPin_Data._();
  From_EncryptPin_Data createEmptyInstance() => create();
  static $pb.PbList<From_EncryptPin_Data> createRepeated() => $pb.PbList<From_EncryptPin_Data>();
  @$core.pragma('dart2js:noInline')
  static From_EncryptPin_Data getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_EncryptPin_Data>(create);
  static From_EncryptPin_Data? _defaultInstance;

  @$pb.TagNumber(2)
  $core.String get salt => $_getSZ(0);
  @$pb.TagNumber(2)
  set salt($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(2)
  $core.bool hasSalt() => $_has(0);
  @$pb.TagNumber(2)
  void clearSalt() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get encryptedData => $_getSZ(1);
  @$pb.TagNumber(3)
  set encryptedData($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(3)
  $core.bool hasEncryptedData() => $_has(1);
  @$pb.TagNumber(3)
  void clearEncryptedData() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get pinIdentifier => $_getSZ(2);
  @$pb.TagNumber(4)
  set pinIdentifier($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(4)
  $core.bool hasPinIdentifier() => $_has(2);
  @$pb.TagNumber(4)
  void clearPinIdentifier() => clearField(4);
}

enum From_EncryptPin_Result {
  error, 
  data, 
  notSet
}

class From_EncryptPin extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, From_EncryptPin_Result> _From_EncryptPin_ResultByTag = {
    1 : From_EncryptPin_Result.error,
    2 : From_EncryptPin_Result.data,
    0 : From_EncryptPin_Result.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'From.EncryptPin', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'error')
    ..aOM<From_EncryptPin_Data>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'data', subBuilder: From_EncryptPin_Data.create)
  ;

  From_EncryptPin._() : super();
  factory From_EncryptPin({
    $core.String? error,
    From_EncryptPin_Data? data,
  }) {
    final _result = create();
    if (error != null) {
      _result.error = error;
    }
    if (data != null) {
      _result.data = data;
    }
    return _result;
  }
  factory From_EncryptPin.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_EncryptPin.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_EncryptPin clone() => From_EncryptPin()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_EncryptPin copyWith(void Function(From_EncryptPin) updates) => super.copyWith((message) => updates(message as From_EncryptPin)) as From_EncryptPin; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static From_EncryptPin create() => From_EncryptPin._();
  From_EncryptPin createEmptyInstance() => create();
  static $pb.PbList<From_EncryptPin> createRepeated() => $pb.PbList<From_EncryptPin>();
  @$core.pragma('dart2js:noInline')
  static From_EncryptPin getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_EncryptPin>(create);
  static From_EncryptPin? _defaultInstance;

  From_EncryptPin_Result whichResult() => _From_EncryptPin_ResultByTag[$_whichOneof(0)]!;
  void clearResult() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get error => $_getSZ(0);
  @$pb.TagNumber(1)
  set error($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasError() => $_has(0);
  @$pb.TagNumber(1)
  void clearError() => clearField(1);

  @$pb.TagNumber(2)
  From_EncryptPin_Data get data => $_getN(1);
  @$pb.TagNumber(2)
  set data(From_EncryptPin_Data v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasData() => $_has(1);
  @$pb.TagNumber(2)
  void clearData() => clearField(2);
  @$pb.TagNumber(2)
  From_EncryptPin_Data ensureData() => $_ensure(1);
}

enum From_DecryptPin_Result {
  error, 
  mnemonic, 
  notSet
}

class From_DecryptPin extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, From_DecryptPin_Result> _From_DecryptPin_ResultByTag = {
    1 : From_DecryptPin_Result.error,
    2 : From_DecryptPin_Result.mnemonic,
    0 : From_DecryptPin_Result.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'From.DecryptPin', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'error')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'mnemonic')
    ..hasRequiredFields = false
  ;

  From_DecryptPin._() : super();
  factory From_DecryptPin({
    $core.String? error,
    $core.String? mnemonic,
  }) {
    final _result = create();
    if (error != null) {
      _result.error = error;
    }
    if (mnemonic != null) {
      _result.mnemonic = mnemonic;
    }
    return _result;
  }
  factory From_DecryptPin.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_DecryptPin.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_DecryptPin clone() => From_DecryptPin()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_DecryptPin copyWith(void Function(From_DecryptPin) updates) => super.copyWith((message) => updates(message as From_DecryptPin)) as From_DecryptPin; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static From_DecryptPin create() => From_DecryptPin._();
  From_DecryptPin createEmptyInstance() => create();
  static $pb.PbList<From_DecryptPin> createRepeated() => $pb.PbList<From_DecryptPin>();
  @$core.pragma('dart2js:noInline')
  static From_DecryptPin getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_DecryptPin>(create);
  static From_DecryptPin? _defaultInstance;

  From_DecryptPin_Result whichResult() => _From_DecryptPin_ResultByTag[$_whichOneof(0)]!;
  void clearResult() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get error => $_getSZ(0);
  @$pb.TagNumber(1)
  set error($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasError() => $_has(0);
  @$pb.TagNumber(1)
  void clearError() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get mnemonic => $_getSZ(1);
  @$pb.TagNumber(2)
  set mnemonic($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMnemonic() => $_has(1);
  @$pb.TagNumber(2)
  void clearMnemonic() => clearField(2);
}

enum From_RegisterAmp_Result {
  ampId, 
  errorMsg, 
  notSet
}

class From_RegisterAmp extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, From_RegisterAmp_Result> _From_RegisterAmp_ResultByTag = {
    1 : From_RegisterAmp_Result.ampId,
    2 : From_RegisterAmp_Result.errorMsg,
    0 : From_RegisterAmp_Result.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'From.RegisterAmp', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ampId')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'errorMsg')
    ..hasRequiredFields = false
  ;

  From_RegisterAmp._() : super();
  factory From_RegisterAmp({
    $core.String? ampId,
    $core.String? errorMsg,
  }) {
    final _result = create();
    if (ampId != null) {
      _result.ampId = ampId;
    }
    if (errorMsg != null) {
      _result.errorMsg = errorMsg;
    }
    return _result;
  }
  factory From_RegisterAmp.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_RegisterAmp.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_RegisterAmp clone() => From_RegisterAmp()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_RegisterAmp copyWith(void Function(From_RegisterAmp) updates) => super.copyWith((message) => updates(message as From_RegisterAmp)) as From_RegisterAmp; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static From_RegisterAmp create() => From_RegisterAmp._();
  From_RegisterAmp createEmptyInstance() => create();
  static $pb.PbList<From_RegisterAmp> createRepeated() => $pb.PbList<From_RegisterAmp>();
  @$core.pragma('dart2js:noInline')
  static From_RegisterAmp getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_RegisterAmp>(create);
  static From_RegisterAmp? _defaultInstance;

  From_RegisterAmp_Result whichResult() => _From_RegisterAmp_ResultByTag[$_whichOneof(0)]!;
  void clearResult() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get ampId => $_getSZ(0);
  @$pb.TagNumber(1)
  set ampId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAmpId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAmpId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get errorMsg => $_getSZ(1);
  @$pb.TagNumber(2)
  set errorMsg($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasErrorMsg() => $_has(1);
  @$pb.TagNumber(2)
  void clearErrorMsg() => clearField(2);
}

class From_AmpAssets extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'From.AmpAssets', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..pPS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'assets')
    ..hasRequiredFields = false
  ;

  From_AmpAssets._() : super();
  factory From_AmpAssets({
    $core.Iterable<$core.String>? assets,
  }) {
    final _result = create();
    if (assets != null) {
      _result.assets.addAll(assets);
    }
    return _result;
  }
  factory From_AmpAssets.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_AmpAssets.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_AmpAssets clone() => From_AmpAssets()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_AmpAssets copyWith(void Function(From_AmpAssets) updates) => super.copyWith((message) => updates(message as From_AmpAssets)) as From_AmpAssets; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static From_AmpAssets create() => From_AmpAssets._();
  From_AmpAssets createEmptyInstance() => create();
  static $pb.PbList<From_AmpAssets> createRepeated() => $pb.PbList<From_AmpAssets>();
  @$core.pragma('dart2js:noInline')
  static From_AmpAssets getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_AmpAssets>(create);
  static From_AmpAssets? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.String> get assets => $_getList(0);
}

class From_UpdatedTxs extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'From.UpdatedTxs', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..pc<TransItem>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'items', $pb.PbFieldType.PM, subBuilder: TransItem.create)
  ;

  From_UpdatedTxs._() : super();
  factory From_UpdatedTxs({
    $core.Iterable<TransItem>? items,
  }) {
    final _result = create();
    if (items != null) {
      _result.items.addAll(items);
    }
    return _result;
  }
  factory From_UpdatedTxs.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_UpdatedTxs.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_UpdatedTxs clone() => From_UpdatedTxs()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_UpdatedTxs copyWith(void Function(From_UpdatedTxs) updates) => super.copyWith((message) => updates(message as From_UpdatedTxs)) as From_UpdatedTxs; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static From_UpdatedTxs create() => From_UpdatedTxs._();
  From_UpdatedTxs createEmptyInstance() => create();
  static $pb.PbList<From_UpdatedTxs> createRepeated() => $pb.PbList<From_UpdatedTxs>();
  @$core.pragma('dart2js:noInline')
  static From_UpdatedTxs getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_UpdatedTxs>(create);
  static From_UpdatedTxs? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<TransItem> get items => $_getList(0);
}

class From_RemovedTxs extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'From.RemovedTxs', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..pPS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'txids')
    ..hasRequiredFields = false
  ;

  From_RemovedTxs._() : super();
  factory From_RemovedTxs({
    $core.Iterable<$core.String>? txids,
  }) {
    final _result = create();
    if (txids != null) {
      _result.txids.addAll(txids);
    }
    return _result;
  }
  factory From_RemovedTxs.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_RemovedTxs.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_RemovedTxs clone() => From_RemovedTxs()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_RemovedTxs copyWith(void Function(From_RemovedTxs) updates) => super.copyWith((message) => updates(message as From_RemovedTxs)) as From_RemovedTxs; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static From_RemovedTxs create() => From_RemovedTxs._();
  From_RemovedTxs createEmptyInstance() => create();
  static $pb.PbList<From_RemovedTxs> createRepeated() => $pb.PbList<From_RemovedTxs>();
  @$core.pragma('dart2js:noInline')
  static From_RemovedTxs getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_RemovedTxs>(create);
  static From_RemovedTxs? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.String> get txids => $_getList(0);
}

class From_UpdatedPegs extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'From.UpdatedPegs', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'orderId')
    ..pc<TransItem>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'items', $pb.PbFieldType.PM, subBuilder: TransItem.create)
  ;

  From_UpdatedPegs._() : super();
  factory From_UpdatedPegs({
    $core.String? orderId,
    $core.Iterable<TransItem>? items,
  }) {
    final _result = create();
    if (orderId != null) {
      _result.orderId = orderId;
    }
    if (items != null) {
      _result.items.addAll(items);
    }
    return _result;
  }
  factory From_UpdatedPegs.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_UpdatedPegs.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_UpdatedPegs clone() => From_UpdatedPegs()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_UpdatedPegs copyWith(void Function(From_UpdatedPegs) updates) => super.copyWith((message) => updates(message as From_UpdatedPegs)) as From_UpdatedPegs; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static From_UpdatedPegs create() => From_UpdatedPegs._();
  From_UpdatedPegs createEmptyInstance() => create();
  static $pb.PbList<From_UpdatedPegs> createRepeated() => $pb.PbList<From_UpdatedPegs>();
  @$core.pragma('dart2js:noInline')
  static From_UpdatedPegs getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_UpdatedPegs>(create);
  static From_UpdatedPegs? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get orderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set orderId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrderId() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<TransItem> get items => $_getList(1);
}

class From_BalanceUpdate extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'From.BalanceUpdate', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQM<Account>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'account', subBuilder: Account.create)
    ..pc<Balance>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'balances', $pb.PbFieldType.PM, subBuilder: Balance.create)
  ;

  From_BalanceUpdate._() : super();
  factory From_BalanceUpdate({
    Account? account,
    $core.Iterable<Balance>? balances,
  }) {
    final _result = create();
    if (account != null) {
      _result.account = account;
    }
    if (balances != null) {
      _result.balances.addAll(balances);
    }
    return _result;
  }
  factory From_BalanceUpdate.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_BalanceUpdate.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_BalanceUpdate clone() => From_BalanceUpdate()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_BalanceUpdate copyWith(void Function(From_BalanceUpdate) updates) => super.copyWith((message) => updates(message as From_BalanceUpdate)) as From_BalanceUpdate; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static From_BalanceUpdate create() => From_BalanceUpdate._();
  From_BalanceUpdate createEmptyInstance() => create();
  static $pb.PbList<From_BalanceUpdate> createRepeated() => $pb.PbList<From_BalanceUpdate>();
  @$core.pragma('dart2js:noInline')
  static From_BalanceUpdate getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_BalanceUpdate>(create);
  static From_BalanceUpdate? _defaultInstance;

  @$pb.TagNumber(1)
  Account get account => $_getN(0);
  @$pb.TagNumber(1)
  set account(Account v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasAccount() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccount() => clearField(1);
  @$pb.TagNumber(1)
  Account ensureAccount() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.List<Balance> get balances => $_getList(1);
}

class From_UtxoUpdate_Utxo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'From.UtxoUpdate.Utxo', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'txid')
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'vout', $pb.PbFieldType.QU3)
    ..aQS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'assetId')
    ..a<$fixnum.Int64>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'amount', $pb.PbFieldType.QU6, defaultOrMaker: $fixnum.Int64.ZERO)
  ;

  From_UtxoUpdate_Utxo._() : super();
  factory From_UtxoUpdate_Utxo({
    $core.String? txid,
    $core.int? vout,
    $core.String? assetId,
    $fixnum.Int64? amount,
  }) {
    final _result = create();
    if (txid != null) {
      _result.txid = txid;
    }
    if (vout != null) {
      _result.vout = vout;
    }
    if (assetId != null) {
      _result.assetId = assetId;
    }
    if (amount != null) {
      _result.amount = amount;
    }
    return _result;
  }
  factory From_UtxoUpdate_Utxo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_UtxoUpdate_Utxo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_UtxoUpdate_Utxo clone() => From_UtxoUpdate_Utxo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_UtxoUpdate_Utxo copyWith(void Function(From_UtxoUpdate_Utxo) updates) => super.copyWith((message) => updates(message as From_UtxoUpdate_Utxo)) as From_UtxoUpdate_Utxo; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static From_UtxoUpdate_Utxo create() => From_UtxoUpdate_Utxo._();
  From_UtxoUpdate_Utxo createEmptyInstance() => create();
  static $pb.PbList<From_UtxoUpdate_Utxo> createRepeated() => $pb.PbList<From_UtxoUpdate_Utxo>();
  @$core.pragma('dart2js:noInline')
  static From_UtxoUpdate_Utxo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_UtxoUpdate_Utxo>(create);
  static From_UtxoUpdate_Utxo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get txid => $_getSZ(0);
  @$pb.TagNumber(1)
  set txid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTxid() => $_has(0);
  @$pb.TagNumber(1)
  void clearTxid() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get vout => $_getIZ(1);
  @$pb.TagNumber(2)
  set vout($core.int v) { $_setUnsignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasVout() => $_has(1);
  @$pb.TagNumber(2)
  void clearVout() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get assetId => $_getSZ(2);
  @$pb.TagNumber(3)
  set assetId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAssetId() => $_has(2);
  @$pb.TagNumber(3)
  void clearAssetId() => clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get amount => $_getI64(3);
  @$pb.TagNumber(4)
  set amount($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasAmount() => $_has(3);
  @$pb.TagNumber(4)
  void clearAmount() => clearField(4);
}

class From_UtxoUpdate extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'From.UtxoUpdate', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQM<Account>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'account', subBuilder: Account.create)
    ..pc<From_UtxoUpdate_Utxo>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'utxos', $pb.PbFieldType.PM, subBuilder: From_UtxoUpdate_Utxo.create)
  ;

  From_UtxoUpdate._() : super();
  factory From_UtxoUpdate({
    Account? account,
    $core.Iterable<From_UtxoUpdate_Utxo>? utxos,
  }) {
    final _result = create();
    if (account != null) {
      _result.account = account;
    }
    if (utxos != null) {
      _result.utxos.addAll(utxos);
    }
    return _result;
  }
  factory From_UtxoUpdate.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_UtxoUpdate.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_UtxoUpdate clone() => From_UtxoUpdate()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_UtxoUpdate copyWith(void Function(From_UtxoUpdate) updates) => super.copyWith((message) => updates(message as From_UtxoUpdate)) as From_UtxoUpdate; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static From_UtxoUpdate create() => From_UtxoUpdate._();
  From_UtxoUpdate createEmptyInstance() => create();
  static $pb.PbList<From_UtxoUpdate> createRepeated() => $pb.PbList<From_UtxoUpdate>();
  @$core.pragma('dart2js:noInline')
  static From_UtxoUpdate getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_UtxoUpdate>(create);
  static From_UtxoUpdate? _defaultInstance;

  @$pb.TagNumber(1)
  Account get account => $_getN(0);
  @$pb.TagNumber(1)
  set account(Account v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasAccount() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccount() => clearField(1);
  @$pb.TagNumber(1)
  Account ensureAccount() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.List<From_UtxoUpdate_Utxo> get utxos => $_getList(1);
}

class From_PeginWaitTx extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'From.PeginWaitTx', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pegAddr')
    ..aQS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'recvAddr')
  ;

  From_PeginWaitTx._() : super();
  factory From_PeginWaitTx({
    $core.String? pegAddr,
    $core.String? recvAddr,
  }) {
    final _result = create();
    if (pegAddr != null) {
      _result.pegAddr = pegAddr;
    }
    if (recvAddr != null) {
      _result.recvAddr = recvAddr;
    }
    return _result;
  }
  factory From_PeginWaitTx.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_PeginWaitTx.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_PeginWaitTx clone() => From_PeginWaitTx()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_PeginWaitTx copyWith(void Function(From_PeginWaitTx) updates) => super.copyWith((message) => updates(message as From_PeginWaitTx)) as From_PeginWaitTx; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static From_PeginWaitTx create() => From_PeginWaitTx._();
  From_PeginWaitTx createEmptyInstance() => create();
  static $pb.PbList<From_PeginWaitTx> createRepeated() => $pb.PbList<From_PeginWaitTx>();
  @$core.pragma('dart2js:noInline')
  static From_PeginWaitTx getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_PeginWaitTx>(create);
  static From_PeginWaitTx? _defaultInstance;

  @$pb.TagNumber(5)
  $core.String get pegAddr => $_getSZ(0);
  @$pb.TagNumber(5)
  set pegAddr($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(5)
  $core.bool hasPegAddr() => $_has(0);
  @$pb.TagNumber(5)
  void clearPegAddr() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get recvAddr => $_getSZ(1);
  @$pb.TagNumber(6)
  set recvAddr($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(6)
  $core.bool hasRecvAddr() => $_has(1);
  @$pb.TagNumber(6)
  void clearRecvAddr() => clearField(6);
}

class From_RecvAddress extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'From.RecvAddress', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQM<Address>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'addr', subBuilder: Address.create)
    ..aQM<Account>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'account', subBuilder: Account.create)
  ;

  From_RecvAddress._() : super();
  factory From_RecvAddress({
    Address? addr,
    Account? account,
  }) {
    final _result = create();
    if (addr != null) {
      _result.addr = addr;
    }
    if (account != null) {
      _result.account = account;
    }
    return _result;
  }
  factory From_RecvAddress.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_RecvAddress.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_RecvAddress clone() => From_RecvAddress()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_RecvAddress copyWith(void Function(From_RecvAddress) updates) => super.copyWith((message) => updates(message as From_RecvAddress)) as From_RecvAddress; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static From_RecvAddress create() => From_RecvAddress._();
  From_RecvAddress createEmptyInstance() => create();
  static $pb.PbList<From_RecvAddress> createRepeated() => $pb.PbList<From_RecvAddress>();
  @$core.pragma('dart2js:noInline')
  static From_RecvAddress getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_RecvAddress>(create);
  static From_RecvAddress? _defaultInstance;

  @$pb.TagNumber(1)
  Address get addr => $_getN(0);
  @$pb.TagNumber(1)
  set addr(Address v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasAddr() => $_has(0);
  @$pb.TagNumber(1)
  void clearAddr() => clearField(1);
  @$pb.TagNumber(1)
  Address ensureAddr() => $_ensure(0);

  @$pb.TagNumber(2)
  Account get account => $_getN(1);
  @$pb.TagNumber(2)
  set account(Account v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasAccount() => $_has(1);
  @$pb.TagNumber(2)
  void clearAccount() => clearField(2);
  @$pb.TagNumber(2)
  Account ensureAccount() => $_ensure(1);
}

enum From_CreateTxResult_Result {
  errorMsg, 
  createdTx, 
  notSet
}

class From_CreateTxResult extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, From_CreateTxResult_Result> _From_CreateTxResult_ResultByTag = {
    1 : From_CreateTxResult_Result.errorMsg,
    2 : From_CreateTxResult_Result.createdTx,
    0 : From_CreateTxResult_Result.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'From.CreateTxResult', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'errorMsg')
    ..aOM<CreatedTx>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'createdTx', subBuilder: CreatedTx.create)
  ;

  From_CreateTxResult._() : super();
  factory From_CreateTxResult({
    $core.String? errorMsg,
    CreatedTx? createdTx,
  }) {
    final _result = create();
    if (errorMsg != null) {
      _result.errorMsg = errorMsg;
    }
    if (createdTx != null) {
      _result.createdTx = createdTx;
    }
    return _result;
  }
  factory From_CreateTxResult.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_CreateTxResult.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_CreateTxResult clone() => From_CreateTxResult()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_CreateTxResult copyWith(void Function(From_CreateTxResult) updates) => super.copyWith((message) => updates(message as From_CreateTxResult)) as From_CreateTxResult; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static From_CreateTxResult create() => From_CreateTxResult._();
  From_CreateTxResult createEmptyInstance() => create();
  static $pb.PbList<From_CreateTxResult> createRepeated() => $pb.PbList<From_CreateTxResult>();
  @$core.pragma('dart2js:noInline')
  static From_CreateTxResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_CreateTxResult>(create);
  static From_CreateTxResult? _defaultInstance;

  From_CreateTxResult_Result whichResult() => _From_CreateTxResult_ResultByTag[$_whichOneof(0)]!;
  void clearResult() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get errorMsg => $_getSZ(0);
  @$pb.TagNumber(1)
  set errorMsg($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasErrorMsg() => $_has(0);
  @$pb.TagNumber(1)
  void clearErrorMsg() => clearField(1);

  @$pb.TagNumber(2)
  CreatedTx get createdTx => $_getN(1);
  @$pb.TagNumber(2)
  set createdTx(CreatedTx v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasCreatedTx() => $_has(1);
  @$pb.TagNumber(2)
  void clearCreatedTx() => clearField(2);
  @$pb.TagNumber(2)
  CreatedTx ensureCreatedTx() => $_ensure(1);
}

enum From_SendResult_Result {
  errorMsg, 
  txItem, 
  notSet
}

class From_SendResult extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, From_SendResult_Result> _From_SendResult_ResultByTag = {
    1 : From_SendResult_Result.errorMsg,
    2 : From_SendResult_Result.txItem,
    0 : From_SendResult_Result.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'From.SendResult', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'errorMsg')
    ..aOM<TransItem>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'txItem', subBuilder: TransItem.create)
  ;

  From_SendResult._() : super();
  factory From_SendResult({
    $core.String? errorMsg,
    TransItem? txItem,
  }) {
    final _result = create();
    if (errorMsg != null) {
      _result.errorMsg = errorMsg;
    }
    if (txItem != null) {
      _result.txItem = txItem;
    }
    return _result;
  }
  factory From_SendResult.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_SendResult.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_SendResult clone() => From_SendResult()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_SendResult copyWith(void Function(From_SendResult) updates) => super.copyWith((message) => updates(message as From_SendResult)) as From_SendResult; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static From_SendResult create() => From_SendResult._();
  From_SendResult createEmptyInstance() => create();
  static $pb.PbList<From_SendResult> createRepeated() => $pb.PbList<From_SendResult>();
  @$core.pragma('dart2js:noInline')
  static From_SendResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_SendResult>(create);
  static From_SendResult? _defaultInstance;

  From_SendResult_Result whichResult() => _From_SendResult_ResultByTag[$_whichOneof(0)]!;
  void clearResult() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get errorMsg => $_getSZ(0);
  @$pb.TagNumber(1)
  set errorMsg($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasErrorMsg() => $_has(0);
  @$pb.TagNumber(1)
  void clearErrorMsg() => clearField(1);

  @$pb.TagNumber(2)
  TransItem get txItem => $_getN(1);
  @$pb.TagNumber(2)
  set txItem(TransItem v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasTxItem() => $_has(1);
  @$pb.TagNumber(2)
  void clearTxItem() => clearField(2);
  @$pb.TagNumber(2)
  TransItem ensureTxItem() => $_ensure(1);
}

enum From_BlindedValues_Result {
  errorMsg, 
  blindedValues, 
  notSet
}

class From_BlindedValues extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, From_BlindedValues_Result> _From_BlindedValues_ResultByTag = {
    2 : From_BlindedValues_Result.errorMsg,
    3 : From_BlindedValues_Result.blindedValues,
    0 : From_BlindedValues_Result.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'From.BlindedValues', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..oo(0, [2, 3])
    ..aQS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'txid')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'errorMsg')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'blindedValues')
  ;

  From_BlindedValues._() : super();
  factory From_BlindedValues({
    $core.String? txid,
    $core.String? errorMsg,
    $core.String? blindedValues,
  }) {
    final _result = create();
    if (txid != null) {
      _result.txid = txid;
    }
    if (errorMsg != null) {
      _result.errorMsg = errorMsg;
    }
    if (blindedValues != null) {
      _result.blindedValues = blindedValues;
    }
    return _result;
  }
  factory From_BlindedValues.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_BlindedValues.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_BlindedValues clone() => From_BlindedValues()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_BlindedValues copyWith(void Function(From_BlindedValues) updates) => super.copyWith((message) => updates(message as From_BlindedValues)) as From_BlindedValues; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static From_BlindedValues create() => From_BlindedValues._();
  From_BlindedValues createEmptyInstance() => create();
  static $pb.PbList<From_BlindedValues> createRepeated() => $pb.PbList<From_BlindedValues>();
  @$core.pragma('dart2js:noInline')
  static From_BlindedValues getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_BlindedValues>(create);
  static From_BlindedValues? _defaultInstance;

  From_BlindedValues_Result whichResult() => _From_BlindedValues_ResultByTag[$_whichOneof(0)]!;
  void clearResult() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get txid => $_getSZ(0);
  @$pb.TagNumber(1)
  set txid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTxid() => $_has(0);
  @$pb.TagNumber(1)
  void clearTxid() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get errorMsg => $_getSZ(1);
  @$pb.TagNumber(2)
  set errorMsg($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasErrorMsg() => $_has(1);
  @$pb.TagNumber(2)
  void clearErrorMsg() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get blindedValues => $_getSZ(2);
  @$pb.TagNumber(3)
  set blindedValues($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasBlindedValues() => $_has(2);
  @$pb.TagNumber(3)
  void clearBlindedValues() => clearField(3);
}

class From_PriceUpdate extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'From.PriceUpdate', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'asset')
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'bid', $pb.PbFieldType.QD)
    ..a<$core.double>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ask', $pb.PbFieldType.QD)
  ;

  From_PriceUpdate._() : super();
  factory From_PriceUpdate({
    $core.String? asset,
    $core.double? bid,
    $core.double? ask,
  }) {
    final _result = create();
    if (asset != null) {
      _result.asset = asset;
    }
    if (bid != null) {
      _result.bid = bid;
    }
    if (ask != null) {
      _result.ask = ask;
    }
    return _result;
  }
  factory From_PriceUpdate.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_PriceUpdate.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_PriceUpdate clone() => From_PriceUpdate()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_PriceUpdate copyWith(void Function(From_PriceUpdate) updates) => super.copyWith((message) => updates(message as From_PriceUpdate)) as From_PriceUpdate; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static From_PriceUpdate create() => From_PriceUpdate._();
  From_PriceUpdate createEmptyInstance() => create();
  static $pb.PbList<From_PriceUpdate> createRepeated() => $pb.PbList<From_PriceUpdate>();
  @$core.pragma('dart2js:noInline')
  static From_PriceUpdate getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_PriceUpdate>(create);
  static From_PriceUpdate? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get asset => $_getSZ(0);
  @$pb.TagNumber(1)
  set asset($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAsset() => $_has(0);
  @$pb.TagNumber(1)
  void clearAsset() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get bid => $_getN(1);
  @$pb.TagNumber(2)
  set bid($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasBid() => $_has(1);
  @$pb.TagNumber(2)
  void clearBid() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get ask => $_getN(2);
  @$pb.TagNumber(3)
  set ask($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAsk() => $_has(2);
  @$pb.TagNumber(3)
  void clearAsk() => clearField(3);
}

enum From_RegisterPhone_Result {
  phoneKey, 
  errorMsg, 
  notSet
}

class From_RegisterPhone extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, From_RegisterPhone_Result> _From_RegisterPhone_ResultByTag = {
    1 : From_RegisterPhone_Result.phoneKey,
    2 : From_RegisterPhone_Result.errorMsg,
    0 : From_RegisterPhone_Result.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'From.RegisterPhone', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'phoneKey')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'errorMsg')
    ..hasRequiredFields = false
  ;

  From_RegisterPhone._() : super();
  factory From_RegisterPhone({
    $core.String? phoneKey,
    $core.String? errorMsg,
  }) {
    final _result = create();
    if (phoneKey != null) {
      _result.phoneKey = phoneKey;
    }
    if (errorMsg != null) {
      _result.errorMsg = errorMsg;
    }
    return _result;
  }
  factory From_RegisterPhone.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_RegisterPhone.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_RegisterPhone clone() => From_RegisterPhone()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_RegisterPhone copyWith(void Function(From_RegisterPhone) updates) => super.copyWith((message) => updates(message as From_RegisterPhone)) as From_RegisterPhone; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static From_RegisterPhone create() => From_RegisterPhone._();
  From_RegisterPhone createEmptyInstance() => create();
  static $pb.PbList<From_RegisterPhone> createRepeated() => $pb.PbList<From_RegisterPhone>();
  @$core.pragma('dart2js:noInline')
  static From_RegisterPhone getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_RegisterPhone>(create);
  static From_RegisterPhone? _defaultInstance;

  From_RegisterPhone_Result whichResult() => _From_RegisterPhone_ResultByTag[$_whichOneof(0)]!;
  void clearResult() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get phoneKey => $_getSZ(0);
  @$pb.TagNumber(1)
  set phoneKey($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPhoneKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearPhoneKey() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get errorMsg => $_getSZ(1);
  @$pb.TagNumber(2)
  set errorMsg($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasErrorMsg() => $_has(1);
  @$pb.TagNumber(2)
  void clearErrorMsg() => clearField(2);
}

enum From_VerifyPhone_Result {
  success, 
  errorMsg, 
  notSet
}

class From_VerifyPhone extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, From_VerifyPhone_Result> _From_VerifyPhone_ResultByTag = {
    1 : From_VerifyPhone_Result.success,
    2 : From_VerifyPhone_Result.errorMsg,
    0 : From_VerifyPhone_Result.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'From.VerifyPhone', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOM<Empty>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'success', subBuilder: Empty.create)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'errorMsg')
    ..hasRequiredFields = false
  ;

  From_VerifyPhone._() : super();
  factory From_VerifyPhone({
    Empty? success,
    $core.String? errorMsg,
  }) {
    final _result = create();
    if (success != null) {
      _result.success = success;
    }
    if (errorMsg != null) {
      _result.errorMsg = errorMsg;
    }
    return _result;
  }
  factory From_VerifyPhone.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_VerifyPhone.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_VerifyPhone clone() => From_VerifyPhone()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_VerifyPhone copyWith(void Function(From_VerifyPhone) updates) => super.copyWith((message) => updates(message as From_VerifyPhone)) as From_VerifyPhone; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static From_VerifyPhone create() => From_VerifyPhone._();
  From_VerifyPhone createEmptyInstance() => create();
  static $pb.PbList<From_VerifyPhone> createRepeated() => $pb.PbList<From_VerifyPhone>();
  @$core.pragma('dart2js:noInline')
  static From_VerifyPhone getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_VerifyPhone>(create);
  static From_VerifyPhone? _defaultInstance;

  From_VerifyPhone_Result whichResult() => _From_VerifyPhone_ResultByTag[$_whichOneof(0)]!;
  void clearResult() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  Empty get success => $_getN(0);
  @$pb.TagNumber(1)
  set success(Empty v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => clearField(1);
  @$pb.TagNumber(1)
  Empty ensureSuccess() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get errorMsg => $_getSZ(1);
  @$pb.TagNumber(2)
  set errorMsg($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasErrorMsg() => $_has(1);
  @$pb.TagNumber(2)
  void clearErrorMsg() => clearField(2);
}

class From_ShowMessage extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'From.ShowMessage', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'text')
  ;

  From_ShowMessage._() : super();
  factory From_ShowMessage({
    $core.String? text,
  }) {
    final _result = create();
    if (text != null) {
      _result.text = text;
    }
    return _result;
  }
  factory From_ShowMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_ShowMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_ShowMessage clone() => From_ShowMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_ShowMessage copyWith(void Function(From_ShowMessage) updates) => super.copyWith((message) => updates(message as From_ShowMessage)) as From_ShowMessage; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static From_ShowMessage create() => From_ShowMessage._();
  From_ShowMessage createEmptyInstance() => create();
  static $pb.PbList<From_ShowMessage> createRepeated() => $pb.PbList<From_ShowMessage>();
  @$core.pragma('dart2js:noInline')
  static From_ShowMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_ShowMessage>(create);
  static From_ShowMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get text => $_getSZ(0);
  @$pb.TagNumber(1)
  set text($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasText() => $_has(0);
  @$pb.TagNumber(1)
  void clearText() => clearField(1);
}

class From_ShowInsufficientFunds extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'From.ShowInsufficientFunds', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'assetId')
    ..a<$fixnum.Int64>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'available', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'required', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
  ;

  From_ShowInsufficientFunds._() : super();
  factory From_ShowInsufficientFunds({
    $core.String? assetId,
    $fixnum.Int64? available,
    $fixnum.Int64? required,
  }) {
    final _result = create();
    if (assetId != null) {
      _result.assetId = assetId;
    }
    if (available != null) {
      _result.available = available;
    }
    if (required != null) {
      _result.required = required;
    }
    return _result;
  }
  factory From_ShowInsufficientFunds.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_ShowInsufficientFunds.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_ShowInsufficientFunds clone() => From_ShowInsufficientFunds()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_ShowInsufficientFunds copyWith(void Function(From_ShowInsufficientFunds) updates) => super.copyWith((message) => updates(message as From_ShowInsufficientFunds)) as From_ShowInsufficientFunds; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static From_ShowInsufficientFunds create() => From_ShowInsufficientFunds._();
  From_ShowInsufficientFunds createEmptyInstance() => create();
  static $pb.PbList<From_ShowInsufficientFunds> createRepeated() => $pb.PbList<From_ShowInsufficientFunds>();
  @$core.pragma('dart2js:noInline')
  static From_ShowInsufficientFunds getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_ShowInsufficientFunds>(create);
  static From_ShowInsufficientFunds? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assetId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetId() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get available => $_getI64(1);
  @$pb.TagNumber(2)
  set available($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAvailable() => $_has(1);
  @$pb.TagNumber(2)
  void clearAvailable() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get required => $_getI64(2);
  @$pb.TagNumber(3)
  set required($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasRequired() => $_has(2);
  @$pb.TagNumber(3)
  void clearRequired() => clearField(3);
}

class From_SubmitReview extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'From.SubmitReview', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'orderId')
    ..aQS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'asset')
    ..a<$fixnum.Int64>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'bitcoinAmount', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'assetAmount', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.double>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'price', $pb.PbFieldType.QD)
    ..a<$core.bool>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sellBitcoin', $pb.PbFieldType.QB)
    ..e<From_SubmitReview_Step>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'step', $pb.PbFieldType.QE, defaultOrMaker: From_SubmitReview_Step.SUBMIT, valueOf: From_SubmitReview_Step.valueOf, enumValues: From_SubmitReview_Step.values)
    ..a<$fixnum.Int64>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'serverFee', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.bool>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'indexPrice', $pb.PbFieldType.QB)
    ..a<$core.bool>(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'autoSign', $pb.PbFieldType.QB)
  ;

  From_SubmitReview._() : super();
  factory From_SubmitReview({
    $core.String? orderId,
    $core.String? asset,
    $fixnum.Int64? bitcoinAmount,
    $fixnum.Int64? assetAmount,
    $core.double? price,
    $core.bool? sellBitcoin,
    From_SubmitReview_Step? step,
    $fixnum.Int64? serverFee,
    $core.bool? indexPrice,
    $core.bool? autoSign,
  }) {
    final _result = create();
    if (orderId != null) {
      _result.orderId = orderId;
    }
    if (asset != null) {
      _result.asset = asset;
    }
    if (bitcoinAmount != null) {
      _result.bitcoinAmount = bitcoinAmount;
    }
    if (assetAmount != null) {
      _result.assetAmount = assetAmount;
    }
    if (price != null) {
      _result.price = price;
    }
    if (sellBitcoin != null) {
      _result.sellBitcoin = sellBitcoin;
    }
    if (step != null) {
      _result.step = step;
    }
    if (serverFee != null) {
      _result.serverFee = serverFee;
    }
    if (indexPrice != null) {
      _result.indexPrice = indexPrice;
    }
    if (autoSign != null) {
      _result.autoSign = autoSign;
    }
    return _result;
  }
  factory From_SubmitReview.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_SubmitReview.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_SubmitReview clone() => From_SubmitReview()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_SubmitReview copyWith(void Function(From_SubmitReview) updates) => super.copyWith((message) => updates(message as From_SubmitReview)) as From_SubmitReview; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static From_SubmitReview create() => From_SubmitReview._();
  From_SubmitReview createEmptyInstance() => create();
  static $pb.PbList<From_SubmitReview> createRepeated() => $pb.PbList<From_SubmitReview>();
  @$core.pragma('dart2js:noInline')
  static From_SubmitReview getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_SubmitReview>(create);
  static From_SubmitReview? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get orderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set orderId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrderId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get asset => $_getSZ(1);
  @$pb.TagNumber(2)
  set asset($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAsset() => $_has(1);
  @$pb.TagNumber(2)
  void clearAsset() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get bitcoinAmount => $_getI64(2);
  @$pb.TagNumber(3)
  set bitcoinAmount($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasBitcoinAmount() => $_has(2);
  @$pb.TagNumber(3)
  void clearBitcoinAmount() => clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get assetAmount => $_getI64(3);
  @$pb.TagNumber(4)
  set assetAmount($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasAssetAmount() => $_has(3);
  @$pb.TagNumber(4)
  void clearAssetAmount() => clearField(4);

  @$pb.TagNumber(5)
  $core.double get price => $_getN(4);
  @$pb.TagNumber(5)
  set price($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasPrice() => $_has(4);
  @$pb.TagNumber(5)
  void clearPrice() => clearField(5);

  @$pb.TagNumber(6)
  $core.bool get sellBitcoin => $_getBF(5);
  @$pb.TagNumber(6)
  set sellBitcoin($core.bool v) { $_setBool(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasSellBitcoin() => $_has(5);
  @$pb.TagNumber(6)
  void clearSellBitcoin() => clearField(6);

  @$pb.TagNumber(7)
  From_SubmitReview_Step get step => $_getN(6);
  @$pb.TagNumber(7)
  set step(From_SubmitReview_Step v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasStep() => $_has(6);
  @$pb.TagNumber(7)
  void clearStep() => clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get serverFee => $_getI64(7);
  @$pb.TagNumber(8)
  set serverFee($fixnum.Int64 v) { $_setInt64(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasServerFee() => $_has(7);
  @$pb.TagNumber(8)
  void clearServerFee() => clearField(8);

  @$pb.TagNumber(9)
  $core.bool get indexPrice => $_getBF(8);
  @$pb.TagNumber(9)
  set indexPrice($core.bool v) { $_setBool(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasIndexPrice() => $_has(8);
  @$pb.TagNumber(9)
  void clearIndexPrice() => clearField(9);

  @$pb.TagNumber(11)
  $core.bool get autoSign => $_getBF(9);
  @$pb.TagNumber(11)
  set autoSign($core.bool v) { $_setBool(9, v); }
  @$pb.TagNumber(11)
  $core.bool hasAutoSign() => $_has(9);
  @$pb.TagNumber(11)
  void clearAutoSign() => clearField(11);
}

enum From_SubmitResult_Result {
  submitSucceed, 
  swapSucceed, 
  error, 
  notSet
}

class From_SubmitResult extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, From_SubmitResult_Result> _From_SubmitResult_ResultByTag = {
    1 : From_SubmitResult_Result.submitSucceed,
    2 : From_SubmitResult_Result.swapSucceed,
    3 : From_SubmitResult_Result.error,
    0 : From_SubmitResult_Result.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'From.SubmitResult', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..oo(0, [1, 2, 3])
    ..aOM<Empty>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'submitSucceed', subBuilder: Empty.create)
    ..aOM<TransItem>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'swapSucceed', subBuilder: TransItem.create)
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'error')
  ;

  From_SubmitResult._() : super();
  factory From_SubmitResult({
    Empty? submitSucceed,
    TransItem? swapSucceed,
    $core.String? error,
  }) {
    final _result = create();
    if (submitSucceed != null) {
      _result.submitSucceed = submitSucceed;
    }
    if (swapSucceed != null) {
      _result.swapSucceed = swapSucceed;
    }
    if (error != null) {
      _result.error = error;
    }
    return _result;
  }
  factory From_SubmitResult.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_SubmitResult.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_SubmitResult clone() => From_SubmitResult()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_SubmitResult copyWith(void Function(From_SubmitResult) updates) => super.copyWith((message) => updates(message as From_SubmitResult)) as From_SubmitResult; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static From_SubmitResult create() => From_SubmitResult._();
  From_SubmitResult createEmptyInstance() => create();
  static $pb.PbList<From_SubmitResult> createRepeated() => $pb.PbList<From_SubmitResult>();
  @$core.pragma('dart2js:noInline')
  static From_SubmitResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_SubmitResult>(create);
  static From_SubmitResult? _defaultInstance;

  From_SubmitResult_Result whichResult() => _From_SubmitResult_ResultByTag[$_whichOneof(0)]!;
  void clearResult() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  Empty get submitSucceed => $_getN(0);
  @$pb.TagNumber(1)
  set submitSucceed(Empty v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasSubmitSucceed() => $_has(0);
  @$pb.TagNumber(1)
  void clearSubmitSucceed() => clearField(1);
  @$pb.TagNumber(1)
  Empty ensureSubmitSucceed() => $_ensure(0);

  @$pb.TagNumber(2)
  TransItem get swapSucceed => $_getN(1);
  @$pb.TagNumber(2)
  set swapSucceed(TransItem v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasSwapSucceed() => $_has(1);
  @$pb.TagNumber(2)
  void clearSwapSucceed() => clearField(2);
  @$pb.TagNumber(2)
  TransItem ensureSwapSucceed() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get error => $_getSZ(2);
  @$pb.TagNumber(3)
  set error($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasError() => $_has(2);
  @$pb.TagNumber(3)
  void clearError() => clearField(3);
}

class From_OrderCreated extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'From.OrderCreated', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQM<Order>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'order', subBuilder: Order.create)
    ..a<$core.bool>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'new', $pb.PbFieldType.QB)
  ;

  From_OrderCreated._() : super();
  factory From_OrderCreated({
    Order? order,
    $core.bool? new_2,
  }) {
    final _result = create();
    if (order != null) {
      _result.order = order;
    }
    if (new_2 != null) {
      _result.new_2 = new_2;
    }
    return _result;
  }
  factory From_OrderCreated.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_OrderCreated.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_OrderCreated clone() => From_OrderCreated()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_OrderCreated copyWith(void Function(From_OrderCreated) updates) => super.copyWith((message) => updates(message as From_OrderCreated)) as From_OrderCreated; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static From_OrderCreated create() => From_OrderCreated._();
  From_OrderCreated createEmptyInstance() => create();
  static $pb.PbList<From_OrderCreated> createRepeated() => $pb.PbList<From_OrderCreated>();
  @$core.pragma('dart2js:noInline')
  static From_OrderCreated getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_OrderCreated>(create);
  static From_OrderCreated? _defaultInstance;

  @$pb.TagNumber(1)
  Order get order => $_getN(0);
  @$pb.TagNumber(1)
  set order(Order v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasOrder() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrder() => clearField(1);
  @$pb.TagNumber(1)
  Order ensureOrder() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.bool get new_2 => $_getBF(1);
  @$pb.TagNumber(2)
  set new_2($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasNew_2() => $_has(1);
  @$pb.TagNumber(2)
  void clearNew_2() => clearField(2);
}

class From_OrderRemoved extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'From.OrderRemoved', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'orderId')
  ;

  From_OrderRemoved._() : super();
  factory From_OrderRemoved({
    $core.String? orderId,
  }) {
    final _result = create();
    if (orderId != null) {
      _result.orderId = orderId;
    }
    return _result;
  }
  factory From_OrderRemoved.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_OrderRemoved.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_OrderRemoved clone() => From_OrderRemoved()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_OrderRemoved copyWith(void Function(From_OrderRemoved) updates) => super.copyWith((message) => updates(message as From_OrderRemoved)) as From_OrderRemoved; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static From_OrderRemoved create() => From_OrderRemoved._();
  From_OrderRemoved createEmptyInstance() => create();
  static $pb.PbList<From_OrderRemoved> createRepeated() => $pb.PbList<From_OrderRemoved>();
  @$core.pragma('dart2js:noInline')
  static From_OrderRemoved getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_OrderRemoved>(create);
  static From_OrderRemoved? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get orderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set orderId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrderId() => clearField(1);
}

class From_OrderComplete extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'From.OrderComplete', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'orderId')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'txid')
  ;

  From_OrderComplete._() : super();
  factory From_OrderComplete({
    $core.String? orderId,
    $core.String? txid,
  }) {
    final _result = create();
    if (orderId != null) {
      _result.orderId = orderId;
    }
    if (txid != null) {
      _result.txid = txid;
    }
    return _result;
  }
  factory From_OrderComplete.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_OrderComplete.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_OrderComplete clone() => From_OrderComplete()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_OrderComplete copyWith(void Function(From_OrderComplete) updates) => super.copyWith((message) => updates(message as From_OrderComplete)) as From_OrderComplete; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static From_OrderComplete create() => From_OrderComplete._();
  From_OrderComplete createEmptyInstance() => create();
  static $pb.PbList<From_OrderComplete> createRepeated() => $pb.PbList<From_OrderComplete>();
  @$core.pragma('dart2js:noInline')
  static From_OrderComplete getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_OrderComplete>(create);
  static From_OrderComplete? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get orderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set orderId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrderId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get txid => $_getSZ(1);
  @$pb.TagNumber(2)
  set txid($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTxid() => $_has(1);
  @$pb.TagNumber(2)
  void clearTxid() => clearField(2);
}

class From_IndexPrice extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'From.IndexPrice', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'assetId')
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ind', $pb.PbFieldType.OD)
    ..a<$core.double>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'last', $pb.PbFieldType.OD)
  ;

  From_IndexPrice._() : super();
  factory From_IndexPrice({
    $core.String? assetId,
    $core.double? ind,
    $core.double? last,
  }) {
    final _result = create();
    if (assetId != null) {
      _result.assetId = assetId;
    }
    if (ind != null) {
      _result.ind = ind;
    }
    if (last != null) {
      _result.last = last;
    }
    return _result;
  }
  factory From_IndexPrice.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_IndexPrice.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_IndexPrice clone() => From_IndexPrice()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_IndexPrice copyWith(void Function(From_IndexPrice) updates) => super.copyWith((message) => updates(message as From_IndexPrice)) as From_IndexPrice; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static From_IndexPrice create() => From_IndexPrice._();
  From_IndexPrice createEmptyInstance() => create();
  static $pb.PbList<From_IndexPrice> createRepeated() => $pb.PbList<From_IndexPrice>();
  @$core.pragma('dart2js:noInline')
  static From_IndexPrice getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_IndexPrice>(create);
  static From_IndexPrice? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assetId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetId() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get ind => $_getN(1);
  @$pb.TagNumber(2)
  set ind($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasInd() => $_has(1);
  @$pb.TagNumber(2)
  void clearInd() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get last => $_getN(2);
  @$pb.TagNumber(3)
  set last($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasLast() => $_has(2);
  @$pb.TagNumber(3)
  void clearLast() => clearField(3);
}

class From_ContactRemoved extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'From.ContactRemoved', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'contactKey')
  ;

  From_ContactRemoved._() : super();
  factory From_ContactRemoved({
    $core.String? contactKey,
  }) {
    final _result = create();
    if (contactKey != null) {
      _result.contactKey = contactKey;
    }
    return _result;
  }
  factory From_ContactRemoved.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_ContactRemoved.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_ContactRemoved clone() => From_ContactRemoved()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_ContactRemoved copyWith(void Function(From_ContactRemoved) updates) => super.copyWith((message) => updates(message as From_ContactRemoved)) as From_ContactRemoved; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static From_ContactRemoved create() => From_ContactRemoved._();
  From_ContactRemoved createEmptyInstance() => create();
  static $pb.PbList<From_ContactRemoved> createRepeated() => $pb.PbList<From_ContactRemoved>();
  @$core.pragma('dart2js:noInline')
  static From_ContactRemoved getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_ContactRemoved>(create);
  static From_ContactRemoved? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get contactKey => $_getSZ(0);
  @$pb.TagNumber(1)
  set contactKey($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasContactKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearContactKey() => clearField(1);
}

class From_AccountStatus extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'From.AccountStatus', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..a<$core.bool>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'registered', $pb.PbFieldType.QB)
  ;

  From_AccountStatus._() : super();
  factory From_AccountStatus({
    $core.bool? registered,
  }) {
    final _result = create();
    if (registered != null) {
      _result.registered = registered;
    }
    return _result;
  }
  factory From_AccountStatus.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_AccountStatus.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_AccountStatus clone() => From_AccountStatus()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_AccountStatus copyWith(void Function(From_AccountStatus) updates) => super.copyWith((message) => updates(message as From_AccountStatus)) as From_AccountStatus; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static From_AccountStatus create() => From_AccountStatus._();
  From_AccountStatus createEmptyInstance() => create();
  static $pb.PbList<From_AccountStatus> createRepeated() => $pb.PbList<From_AccountStatus>();
  @$core.pragma('dart2js:noInline')
  static From_AccountStatus getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_AccountStatus>(create);
  static From_AccountStatus? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get registered => $_getBF(0);
  @$pb.TagNumber(1)
  set registered($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasRegistered() => $_has(0);
  @$pb.TagNumber(1)
  void clearRegistered() => clearField(1);
}

class From_AssetDetails_Stats extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'From.AssetDetails.Stats', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'issuedAmount', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'burnedAmount', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.bool>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'hasBlindedIssuances', $pb.PbFieldType.QB)
    ..a<$fixnum.Int64>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'offlineAmount', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
  ;

  From_AssetDetails_Stats._() : super();
  factory From_AssetDetails_Stats({
    $fixnum.Int64? issuedAmount,
    $fixnum.Int64? burnedAmount,
    $core.bool? hasBlindedIssuances,
    $fixnum.Int64? offlineAmount,
  }) {
    final _result = create();
    if (issuedAmount != null) {
      _result.issuedAmount = issuedAmount;
    }
    if (burnedAmount != null) {
      _result.burnedAmount = burnedAmount;
    }
    if (hasBlindedIssuances != null) {
      _result.hasBlindedIssuances = hasBlindedIssuances;
    }
    if (offlineAmount != null) {
      _result.offlineAmount = offlineAmount;
    }
    return _result;
  }
  factory From_AssetDetails_Stats.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_AssetDetails_Stats.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_AssetDetails_Stats clone() => From_AssetDetails_Stats()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_AssetDetails_Stats copyWith(void Function(From_AssetDetails_Stats) updates) => super.copyWith((message) => updates(message as From_AssetDetails_Stats)) as From_AssetDetails_Stats; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static From_AssetDetails_Stats create() => From_AssetDetails_Stats._();
  From_AssetDetails_Stats createEmptyInstance() => create();
  static $pb.PbList<From_AssetDetails_Stats> createRepeated() => $pb.PbList<From_AssetDetails_Stats>();
  @$core.pragma('dart2js:noInline')
  static From_AssetDetails_Stats getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_AssetDetails_Stats>(create);
  static From_AssetDetails_Stats? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get issuedAmount => $_getI64(0);
  @$pb.TagNumber(1)
  set issuedAmount($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasIssuedAmount() => $_has(0);
  @$pb.TagNumber(1)
  void clearIssuedAmount() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get burnedAmount => $_getI64(1);
  @$pb.TagNumber(2)
  set burnedAmount($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasBurnedAmount() => $_has(1);
  @$pb.TagNumber(2)
  void clearBurnedAmount() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get hasBlindedIssuances => $_getBF(2);
  @$pb.TagNumber(3)
  set hasBlindedIssuances($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasHasBlindedIssuances() => $_has(2);
  @$pb.TagNumber(3)
  void clearHasBlindedIssuances() => clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get offlineAmount => $_getI64(3);
  @$pb.TagNumber(4)
  set offlineAmount($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasOfflineAmount() => $_has(3);
  @$pb.TagNumber(4)
  void clearOfflineAmount() => clearField(4);
}

class From_AssetDetails_ChartStats extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'From.AssetDetails.ChartStats', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..a<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'low', $pb.PbFieldType.QD)
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'high', $pb.PbFieldType.QD)
    ..a<$core.double>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'last', $pb.PbFieldType.QD)
  ;

  From_AssetDetails_ChartStats._() : super();
  factory From_AssetDetails_ChartStats({
    $core.double? low,
    $core.double? high,
    $core.double? last,
  }) {
    final _result = create();
    if (low != null) {
      _result.low = low;
    }
    if (high != null) {
      _result.high = high;
    }
    if (last != null) {
      _result.last = last;
    }
    return _result;
  }
  factory From_AssetDetails_ChartStats.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_AssetDetails_ChartStats.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_AssetDetails_ChartStats clone() => From_AssetDetails_ChartStats()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_AssetDetails_ChartStats copyWith(void Function(From_AssetDetails_ChartStats) updates) => super.copyWith((message) => updates(message as From_AssetDetails_ChartStats)) as From_AssetDetails_ChartStats; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static From_AssetDetails_ChartStats create() => From_AssetDetails_ChartStats._();
  From_AssetDetails_ChartStats createEmptyInstance() => create();
  static $pb.PbList<From_AssetDetails_ChartStats> createRepeated() => $pb.PbList<From_AssetDetails_ChartStats>();
  @$core.pragma('dart2js:noInline')
  static From_AssetDetails_ChartStats getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_AssetDetails_ChartStats>(create);
  static From_AssetDetails_ChartStats? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get low => $_getN(0);
  @$pb.TagNumber(1)
  set low($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLow() => $_has(0);
  @$pb.TagNumber(1)
  void clearLow() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get high => $_getN(1);
  @$pb.TagNumber(2)
  set high($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasHigh() => $_has(1);
  @$pb.TagNumber(2)
  void clearHigh() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get last => $_getN(2);
  @$pb.TagNumber(3)
  set last($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasLast() => $_has(2);
  @$pb.TagNumber(3)
  void clearLast() => clearField(3);
}

class From_AssetDetails extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'From.AssetDetails', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'assetId')
    ..aOM<From_AssetDetails_Stats>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'stats', subBuilder: From_AssetDetails_Stats.create)
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'chartUrl')
    ..aOM<From_AssetDetails_ChartStats>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'chartStats', subBuilder: From_AssetDetails_ChartStats.create)
  ;

  From_AssetDetails._() : super();
  factory From_AssetDetails({
    $core.String? assetId,
    From_AssetDetails_Stats? stats,
    $core.String? chartUrl,
    From_AssetDetails_ChartStats? chartStats,
  }) {
    final _result = create();
    if (assetId != null) {
      _result.assetId = assetId;
    }
    if (stats != null) {
      _result.stats = stats;
    }
    if (chartUrl != null) {
      _result.chartUrl = chartUrl;
    }
    if (chartStats != null) {
      _result.chartStats = chartStats;
    }
    return _result;
  }
  factory From_AssetDetails.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_AssetDetails.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_AssetDetails clone() => From_AssetDetails()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_AssetDetails copyWith(void Function(From_AssetDetails) updates) => super.copyWith((message) => updates(message as From_AssetDetails)) as From_AssetDetails; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static From_AssetDetails create() => From_AssetDetails._();
  From_AssetDetails createEmptyInstance() => create();
  static $pb.PbList<From_AssetDetails> createRepeated() => $pb.PbList<From_AssetDetails>();
  @$core.pragma('dart2js:noInline')
  static From_AssetDetails getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_AssetDetails>(create);
  static From_AssetDetails? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assetId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetId() => clearField(1);

  @$pb.TagNumber(2)
  From_AssetDetails_Stats get stats => $_getN(1);
  @$pb.TagNumber(2)
  set stats(From_AssetDetails_Stats v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasStats() => $_has(1);
  @$pb.TagNumber(2)
  void clearStats() => clearField(2);
  @$pb.TagNumber(2)
  From_AssetDetails_Stats ensureStats() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get chartUrl => $_getSZ(2);
  @$pb.TagNumber(3)
  set chartUrl($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasChartUrl() => $_has(2);
  @$pb.TagNumber(3)
  void clearChartUrl() => clearField(3);

  @$pb.TagNumber(4)
  From_AssetDetails_ChartStats get chartStats => $_getN(3);
  @$pb.TagNumber(4)
  set chartStats(From_AssetDetails_ChartStats v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasChartStats() => $_has(3);
  @$pb.TagNumber(4)
  void clearChartStats() => clearField(4);
  @$pb.TagNumber(4)
  From_AssetDetails_ChartStats ensureChartStats() => $_ensure(3);
}

class From_UpdatePriceStream extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'From.UpdatePriceStream', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'assetId')
    ..a<$core.bool>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sendBitcoins', $pb.PbFieldType.QB)
    ..aInt64(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sendAmount')
    ..aInt64(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'recvAmount')
    ..a<$core.double>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'price', $pb.PbFieldType.OD)
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'errorMsg')
  ;

  From_UpdatePriceStream._() : super();
  factory From_UpdatePriceStream({
    $core.String? assetId,
    $core.bool? sendBitcoins,
    $fixnum.Int64? sendAmount,
    $fixnum.Int64? recvAmount,
    $core.double? price,
    $core.String? errorMsg,
  }) {
    final _result = create();
    if (assetId != null) {
      _result.assetId = assetId;
    }
    if (sendBitcoins != null) {
      _result.sendBitcoins = sendBitcoins;
    }
    if (sendAmount != null) {
      _result.sendAmount = sendAmount;
    }
    if (recvAmount != null) {
      _result.recvAmount = recvAmount;
    }
    if (price != null) {
      _result.price = price;
    }
    if (errorMsg != null) {
      _result.errorMsg = errorMsg;
    }
    return _result;
  }
  factory From_UpdatePriceStream.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_UpdatePriceStream.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_UpdatePriceStream clone() => From_UpdatePriceStream()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_UpdatePriceStream copyWith(void Function(From_UpdatePriceStream) updates) => super.copyWith((message) => updates(message as From_UpdatePriceStream)) as From_UpdatePriceStream; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static From_UpdatePriceStream create() => From_UpdatePriceStream._();
  From_UpdatePriceStream createEmptyInstance() => create();
  static $pb.PbList<From_UpdatePriceStream> createRepeated() => $pb.PbList<From_UpdatePriceStream>();
  @$core.pragma('dart2js:noInline')
  static From_UpdatePriceStream getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_UpdatePriceStream>(create);
  static From_UpdatePriceStream? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assetId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetId() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get sendBitcoins => $_getBF(1);
  @$pb.TagNumber(2)
  set sendBitcoins($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSendBitcoins() => $_has(1);
  @$pb.TagNumber(2)
  void clearSendBitcoins() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get sendAmount => $_getI64(2);
  @$pb.TagNumber(3)
  set sendAmount($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSendAmount() => $_has(2);
  @$pb.TagNumber(3)
  void clearSendAmount() => clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get recvAmount => $_getI64(3);
  @$pb.TagNumber(4)
  set recvAmount($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasRecvAmount() => $_has(3);
  @$pb.TagNumber(4)
  void clearRecvAmount() => clearField(4);

  @$pb.TagNumber(5)
  $core.double get price => $_getN(4);
  @$pb.TagNumber(5)
  set price($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasPrice() => $_has(4);
  @$pb.TagNumber(5)
  void clearPrice() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get errorMsg => $_getSZ(5);
  @$pb.TagNumber(6)
  set errorMsg($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasErrorMsg() => $_has(5);
  @$pb.TagNumber(6)
  void clearErrorMsg() => clearField(6);
}

class From_LocalMessage extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'From.LocalMessage', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'title')
    ..aQS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'body')
  ;

  From_LocalMessage._() : super();
  factory From_LocalMessage({
    $core.String? title,
    $core.String? body,
  }) {
    final _result = create();
    if (title != null) {
      _result.title = title;
    }
    if (body != null) {
      _result.body = body;
    }
    return _result;
  }
  factory From_LocalMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_LocalMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_LocalMessage clone() => From_LocalMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_LocalMessage copyWith(void Function(From_LocalMessage) updates) => super.copyWith((message) => updates(message as From_LocalMessage)) as From_LocalMessage; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static From_LocalMessage create() => From_LocalMessage._();
  From_LocalMessage createEmptyInstance() => create();
  static $pb.PbList<From_LocalMessage> createRepeated() => $pb.PbList<From_LocalMessage>();
  @$core.pragma('dart2js:noInline')
  static From_LocalMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_LocalMessage>(create);
  static From_LocalMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get body => $_getSZ(1);
  @$pb.TagNumber(2)
  set body($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasBody() => $_has(1);
  @$pb.TagNumber(2)
  void clearBody() => clearField(2);
}

class From_MarketDataSubscribe extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'From.MarketDataSubscribe', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'assetId')
    ..pc<ChartPoint>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'data', $pb.PbFieldType.PM, subBuilder: ChartPoint.create)
  ;

  From_MarketDataSubscribe._() : super();
  factory From_MarketDataSubscribe({
    $core.String? assetId,
    $core.Iterable<ChartPoint>? data,
  }) {
    final _result = create();
    if (assetId != null) {
      _result.assetId = assetId;
    }
    if (data != null) {
      _result.data.addAll(data);
    }
    return _result;
  }
  factory From_MarketDataSubscribe.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_MarketDataSubscribe.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_MarketDataSubscribe clone() => From_MarketDataSubscribe()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_MarketDataSubscribe copyWith(void Function(From_MarketDataSubscribe) updates) => super.copyWith((message) => updates(message as From_MarketDataSubscribe)) as From_MarketDataSubscribe; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static From_MarketDataSubscribe create() => From_MarketDataSubscribe._();
  From_MarketDataSubscribe createEmptyInstance() => create();
  static $pb.PbList<From_MarketDataSubscribe> createRepeated() => $pb.PbList<From_MarketDataSubscribe>();
  @$core.pragma('dart2js:noInline')
  static From_MarketDataSubscribe getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_MarketDataSubscribe>(create);
  static From_MarketDataSubscribe? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assetId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetId() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<ChartPoint> get data => $_getList(1);
}

class From_MarketDataUpdate extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'From.MarketDataUpdate', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'assetId')
    ..aQM<ChartPoint>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'update', subBuilder: ChartPoint.create)
  ;

  From_MarketDataUpdate._() : super();
  factory From_MarketDataUpdate({
    $core.String? assetId,
    ChartPoint? update,
  }) {
    final _result = create();
    if (assetId != null) {
      _result.assetId = assetId;
    }
    if (update != null) {
      _result.update = update;
    }
    return _result;
  }
  factory From_MarketDataUpdate.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_MarketDataUpdate.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_MarketDataUpdate clone() => From_MarketDataUpdate()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_MarketDataUpdate copyWith(void Function(From_MarketDataUpdate) updates) => super.copyWith((message) => updates(message as From_MarketDataUpdate)) as From_MarketDataUpdate; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static From_MarketDataUpdate create() => From_MarketDataUpdate._();
  From_MarketDataUpdate createEmptyInstance() => create();
  static $pb.PbList<From_MarketDataUpdate> createRepeated() => $pb.PbList<From_MarketDataUpdate>();
  @$core.pragma('dart2js:noInline')
  static From_MarketDataUpdate getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_MarketDataUpdate>(create);
  static From_MarketDataUpdate? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assetId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetId() => clearField(1);

  @$pb.TagNumber(2)
  ChartPoint get update => $_getN(1);
  @$pb.TagNumber(2)
  set update(ChartPoint v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasUpdate() => $_has(1);
  @$pb.TagNumber(2)
  void clearUpdate() => clearField(2);
  @$pb.TagNumber(2)
  ChartPoint ensureUpdate() => $_ensure(1);
}

class From_JadeUpdated extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'From.JadeUpdated', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQM<Account>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'account', subBuilder: Account.create)
    ..e<From_JadeUpdated_Status>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'status', $pb.PbFieldType.QE, defaultOrMaker: From_JadeUpdated_Status.UNKNOWN, valueOf: From_JadeUpdated_Status.valueOf, enumValues: From_JadeUpdated_Status.values)
    ..aQS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
  ;

  From_JadeUpdated._() : super();
  factory From_JadeUpdated({
    Account? account,
    From_JadeUpdated_Status? status,
    $core.String? name,
  }) {
    final _result = create();
    if (account != null) {
      _result.account = account;
    }
    if (status != null) {
      _result.status = status;
    }
    if (name != null) {
      _result.name = name;
    }
    return _result;
  }
  factory From_JadeUpdated.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_JadeUpdated.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_JadeUpdated clone() => From_JadeUpdated()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_JadeUpdated copyWith(void Function(From_JadeUpdated) updates) => super.copyWith((message) => updates(message as From_JadeUpdated)) as From_JadeUpdated; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static From_JadeUpdated create() => From_JadeUpdated._();
  From_JadeUpdated createEmptyInstance() => create();
  static $pb.PbList<From_JadeUpdated> createRepeated() => $pb.PbList<From_JadeUpdated>();
  @$core.pragma('dart2js:noInline')
  static From_JadeUpdated getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_JadeUpdated>(create);
  static From_JadeUpdated? _defaultInstance;

  @$pb.TagNumber(1)
  Account get account => $_getN(0);
  @$pb.TagNumber(1)
  set account(Account v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasAccount() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccount() => clearField(1);
  @$pb.TagNumber(1)
  Account ensureAccount() => $_ensure(0);

  @$pb.TagNumber(2)
  From_JadeUpdated_Status get status => $_getN(1);
  @$pb.TagNumber(2)
  set status(From_JadeUpdated_Status v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => clearField(3);
}

class From_JadeRemoved extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'From.JadeRemoved', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQM<Account>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'account', subBuilder: Account.create)
  ;

  From_JadeRemoved._() : super();
  factory From_JadeRemoved({
    Account? account,
  }) {
    final _result = create();
    if (account != null) {
      _result.account = account;
    }
    return _result;
  }
  factory From_JadeRemoved.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_JadeRemoved.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_JadeRemoved clone() => From_JadeRemoved()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_JadeRemoved copyWith(void Function(From_JadeRemoved) updates) => super.copyWith((message) => updates(message as From_JadeRemoved)) as From_JadeRemoved; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static From_JadeRemoved create() => From_JadeRemoved._();
  From_JadeRemoved createEmptyInstance() => create();
  static $pb.PbList<From_JadeRemoved> createRepeated() => $pb.PbList<From_JadeRemoved>();
  @$core.pragma('dart2js:noInline')
  static From_JadeRemoved getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_JadeRemoved>(create);
  static From_JadeRemoved? _defaultInstance;

  @$pb.TagNumber(1)
  Account get account => $_getN(0);
  @$pb.TagNumber(1)
  set account(Account v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasAccount() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccount() => clearField(1);
  @$pb.TagNumber(1)
  Account ensureAccount() => $_ensure(0);
}

enum From_Msg {
  updatedTxs, 
  updatedPegs, 
  newAsset, 
  balanceUpdate, 
  serverStatus, 
  priceUpdate, 
  walletLoaded, 
  registerAmp, 
  ampAssets, 
  encryptPin, 
  decryptPin, 
  removedTxs, 
  envSettings, 
  syncComplete, 
  utxoUpdate, 
  peginWaitTx, 
  swapSucceed, 
  swapFailed, 
  recvAddress, 
  createTxResult, 
  sendResult, 
  blindedValues, 
  registerPhone, 
  verifyPhone, 
  uploadAvatar, 
  uploadContacts, 
  contactCreated, 
  contactRemoved, 
  contactTransaction, 
  accountStatus, 
  showMessage, 
  submitReview, 
  submitResult, 
  editOrder, 
  cancelOrder, 
  insufficientFunds, 
  serverConnected, 
  serverDisconnected, 
  orderCreated, 
  orderRemoved, 
  indexPrice, 
  assetDetails, 
  updatePriceStream, 
  orderComplete, 
  localMessage, 
  marketDataSubscribe, 
  marketDataUpdate, 
  jadeUpdated, 
  jadeRemoved, 
  notSet
}

class From extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, From_Msg> _From_MsgByTag = {
    1 : From_Msg.updatedTxs,
    2 : From_Msg.updatedPegs,
    3 : From_Msg.newAsset,
    4 : From_Msg.balanceUpdate,
    5 : From_Msg.serverStatus,
    6 : From_Msg.priceUpdate,
    7 : From_Msg.walletLoaded,
    8 : From_Msg.registerAmp,
    9 : From_Msg.ampAssets,
    10 : From_Msg.encryptPin,
    11 : From_Msg.decryptPin,
    12 : From_Msg.removedTxs,
    13 : From_Msg.envSettings,
    14 : From_Msg.syncComplete,
    15 : From_Msg.utxoUpdate,
    21 : From_Msg.peginWaitTx,
    22 : From_Msg.swapSucceed,
    23 : From_Msg.swapFailed,
    30 : From_Msg.recvAddress,
    31 : From_Msg.createTxResult,
    32 : From_Msg.sendResult,
    33 : From_Msg.blindedValues,
    40 : From_Msg.registerPhone,
    41 : From_Msg.verifyPhone,
    42 : From_Msg.uploadAvatar,
    43 : From_Msg.uploadContacts,
    44 : From_Msg.contactCreated,
    45 : From_Msg.contactRemoved,
    46 : From_Msg.contactTransaction,
    47 : From_Msg.accountStatus,
    50 : From_Msg.showMessage,
    51 : From_Msg.submitReview,
    52 : From_Msg.submitResult,
    53 : From_Msg.editOrder,
    54 : From_Msg.cancelOrder,
    55 : From_Msg.insufficientFunds,
    60 : From_Msg.serverConnected,
    61 : From_Msg.serverDisconnected,
    62 : From_Msg.orderCreated,
    63 : From_Msg.orderRemoved,
    64 : From_Msg.indexPrice,
    65 : From_Msg.assetDetails,
    66 : From_Msg.updatePriceStream,
    67 : From_Msg.orderComplete,
    68 : From_Msg.localMessage,
    70 : From_Msg.marketDataSubscribe,
    71 : From_Msg.marketDataUpdate,
    80 : From_Msg.jadeUpdated,
    81 : From_Msg.jadeRemoved,
    0 : From_Msg.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'From', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 21, 22, 23, 30, 31, 32, 33, 40, 41, 42, 43, 44, 45, 46, 47, 50, 51, 52, 53, 54, 55, 60, 61, 62, 63, 64, 65, 66, 67, 68, 70, 71, 80, 81])
    ..aOM<From_UpdatedTxs>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'updatedTxs', subBuilder: From_UpdatedTxs.create)
    ..aOM<From_UpdatedPegs>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'updatedPegs', subBuilder: From_UpdatedPegs.create)
    ..aOM<Asset>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'newAsset', subBuilder: Asset.create)
    ..aOM<From_BalanceUpdate>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'balanceUpdate', subBuilder: From_BalanceUpdate.create)
    ..aOM<ServerStatus>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'serverStatus', subBuilder: ServerStatus.create)
    ..aOM<From_PriceUpdate>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'priceUpdate', subBuilder: From_PriceUpdate.create)
    ..aOM<Empty>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'walletLoaded', subBuilder: Empty.create)
    ..aOM<From_RegisterAmp>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'registerAmp', subBuilder: From_RegisterAmp.create)
    ..aOM<From_AmpAssets>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ampAssets', subBuilder: From_AmpAssets.create)
    ..aOM<From_EncryptPin>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'encryptPin', subBuilder: From_EncryptPin.create)
    ..aOM<From_DecryptPin>(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'decryptPin', subBuilder: From_DecryptPin.create)
    ..aOM<From_RemovedTxs>(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'removedTxs', subBuilder: From_RemovedTxs.create)
    ..aOM<From_EnvSettings>(13, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'envSettings', subBuilder: From_EnvSettings.create)
    ..aOM<Empty>(14, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'syncComplete', subBuilder: Empty.create)
    ..aOM<From_UtxoUpdate>(15, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'utxoUpdate', subBuilder: From_UtxoUpdate.create)
    ..aOM<From_PeginWaitTx>(21, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'peginWaitTx', subBuilder: From_PeginWaitTx.create)
    ..aOM<TransItem>(22, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'swapSucceed', subBuilder: TransItem.create)
    ..aOS(23, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'swapFailed')
    ..aOM<From_RecvAddress>(30, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'recvAddress', subBuilder: From_RecvAddress.create)
    ..aOM<From_CreateTxResult>(31, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'createTxResult', subBuilder: From_CreateTxResult.create)
    ..aOM<From_SendResult>(32, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sendResult', subBuilder: From_SendResult.create)
    ..aOM<From_BlindedValues>(33, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'blindedValues', subBuilder: From_BlindedValues.create)
    ..aOM<From_RegisterPhone>(40, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'registerPhone', subBuilder: From_RegisterPhone.create)
    ..aOM<From_VerifyPhone>(41, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'verifyPhone', subBuilder: From_VerifyPhone.create)
    ..aOM<GenericResponse>(42, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'uploadAvatar', subBuilder: GenericResponse.create)
    ..aOM<GenericResponse>(43, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'uploadContacts', subBuilder: GenericResponse.create)
    ..aOM<Contact>(44, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'contactCreated', subBuilder: Contact.create)
    ..aOM<From_ContactRemoved>(45, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'contactRemoved', subBuilder: From_ContactRemoved.create)
    ..aOM<ContactTransaction>(46, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'contactTransaction', subBuilder: ContactTransaction.create)
    ..aOM<From_AccountStatus>(47, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'accountStatus', subBuilder: From_AccountStatus.create)
    ..aOM<From_ShowMessage>(50, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'showMessage', subBuilder: From_ShowMessage.create)
    ..aOM<From_SubmitReview>(51, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'submitReview', subBuilder: From_SubmitReview.create)
    ..aOM<From_SubmitResult>(52, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'submitResult', subBuilder: From_SubmitResult.create)
    ..aOM<GenericResponse>(53, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'editOrder', subBuilder: GenericResponse.create)
    ..aOM<GenericResponse>(54, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'cancelOrder', subBuilder: GenericResponse.create)
    ..aOM<From_ShowInsufficientFunds>(55, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'insufficientFunds', subBuilder: From_ShowInsufficientFunds.create)
    ..aOM<Empty>(60, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'serverConnected', subBuilder: Empty.create)
    ..aOM<Empty>(61, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'serverDisconnected', subBuilder: Empty.create)
    ..aOM<From_OrderCreated>(62, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'orderCreated', subBuilder: From_OrderCreated.create)
    ..aOM<From_OrderRemoved>(63, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'orderRemoved', subBuilder: From_OrderRemoved.create)
    ..aOM<From_IndexPrice>(64, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'indexPrice', subBuilder: From_IndexPrice.create)
    ..aOM<From_AssetDetails>(65, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'assetDetails', subBuilder: From_AssetDetails.create)
    ..aOM<From_UpdatePriceStream>(66, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'updatePriceStream', subBuilder: From_UpdatePriceStream.create)
    ..aOM<From_OrderComplete>(67, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'orderComplete', subBuilder: From_OrderComplete.create)
    ..aOM<From_LocalMessage>(68, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'localMessage', subBuilder: From_LocalMessage.create)
    ..aOM<From_MarketDataSubscribe>(70, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'marketDataSubscribe', subBuilder: From_MarketDataSubscribe.create)
    ..aOM<From_MarketDataUpdate>(71, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'marketDataUpdate', subBuilder: From_MarketDataUpdate.create)
    ..aOM<From_JadeUpdated>(80, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'jadeUpdated', subBuilder: From_JadeUpdated.create)
    ..aOM<From_JadeRemoved>(81, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'jadeRemoved', subBuilder: From_JadeRemoved.create)
  ;

  From._() : super();
  factory From({
    From_UpdatedTxs? updatedTxs,
    From_UpdatedPegs? updatedPegs,
    Asset? newAsset,
    From_BalanceUpdate? balanceUpdate,
    ServerStatus? serverStatus,
    From_PriceUpdate? priceUpdate,
    Empty? walletLoaded,
    From_RegisterAmp? registerAmp,
    From_AmpAssets? ampAssets,
    From_EncryptPin? encryptPin,
    From_DecryptPin? decryptPin,
    From_RemovedTxs? removedTxs,
    From_EnvSettings? envSettings,
    Empty? syncComplete,
    From_UtxoUpdate? utxoUpdate,
    From_PeginWaitTx? peginWaitTx,
    TransItem? swapSucceed,
    $core.String? swapFailed,
    From_RecvAddress? recvAddress,
    From_CreateTxResult? createTxResult,
    From_SendResult? sendResult,
    From_BlindedValues? blindedValues,
    From_RegisterPhone? registerPhone,
    From_VerifyPhone? verifyPhone,
    GenericResponse? uploadAvatar,
    GenericResponse? uploadContacts,
    Contact? contactCreated,
    From_ContactRemoved? contactRemoved,
    ContactTransaction? contactTransaction,
    From_AccountStatus? accountStatus,
    From_ShowMessage? showMessage,
    From_SubmitReview? submitReview,
    From_SubmitResult? submitResult,
    GenericResponse? editOrder,
    GenericResponse? cancelOrder,
    From_ShowInsufficientFunds? insufficientFunds,
    Empty? serverConnected,
    Empty? serverDisconnected,
    From_OrderCreated? orderCreated,
    From_OrderRemoved? orderRemoved,
    From_IndexPrice? indexPrice,
    From_AssetDetails? assetDetails,
    From_UpdatePriceStream? updatePriceStream,
    From_OrderComplete? orderComplete,
    From_LocalMessage? localMessage,
    From_MarketDataSubscribe? marketDataSubscribe,
    From_MarketDataUpdate? marketDataUpdate,
    From_JadeUpdated? jadeUpdated,
    From_JadeRemoved? jadeRemoved,
  }) {
    final _result = create();
    if (updatedTxs != null) {
      _result.updatedTxs = updatedTxs;
    }
    if (updatedPegs != null) {
      _result.updatedPegs = updatedPegs;
    }
    if (newAsset != null) {
      _result.newAsset = newAsset;
    }
    if (balanceUpdate != null) {
      _result.balanceUpdate = balanceUpdate;
    }
    if (serverStatus != null) {
      _result.serverStatus = serverStatus;
    }
    if (priceUpdate != null) {
      _result.priceUpdate = priceUpdate;
    }
    if (walletLoaded != null) {
      _result.walletLoaded = walletLoaded;
    }
    if (registerAmp != null) {
      _result.registerAmp = registerAmp;
    }
    if (ampAssets != null) {
      _result.ampAssets = ampAssets;
    }
    if (encryptPin != null) {
      _result.encryptPin = encryptPin;
    }
    if (decryptPin != null) {
      _result.decryptPin = decryptPin;
    }
    if (removedTxs != null) {
      _result.removedTxs = removedTxs;
    }
    if (envSettings != null) {
      _result.envSettings = envSettings;
    }
    if (syncComplete != null) {
      _result.syncComplete = syncComplete;
    }
    if (utxoUpdate != null) {
      _result.utxoUpdate = utxoUpdate;
    }
    if (peginWaitTx != null) {
      _result.peginWaitTx = peginWaitTx;
    }
    if (swapSucceed != null) {
      _result.swapSucceed = swapSucceed;
    }
    if (swapFailed != null) {
      _result.swapFailed = swapFailed;
    }
    if (recvAddress != null) {
      _result.recvAddress = recvAddress;
    }
    if (createTxResult != null) {
      _result.createTxResult = createTxResult;
    }
    if (sendResult != null) {
      _result.sendResult = sendResult;
    }
    if (blindedValues != null) {
      _result.blindedValues = blindedValues;
    }
    if (registerPhone != null) {
      _result.registerPhone = registerPhone;
    }
    if (verifyPhone != null) {
      _result.verifyPhone = verifyPhone;
    }
    if (uploadAvatar != null) {
      _result.uploadAvatar = uploadAvatar;
    }
    if (uploadContacts != null) {
      _result.uploadContacts = uploadContacts;
    }
    if (contactCreated != null) {
      _result.contactCreated = contactCreated;
    }
    if (contactRemoved != null) {
      _result.contactRemoved = contactRemoved;
    }
    if (contactTransaction != null) {
      _result.contactTransaction = contactTransaction;
    }
    if (accountStatus != null) {
      _result.accountStatus = accountStatus;
    }
    if (showMessage != null) {
      _result.showMessage = showMessage;
    }
    if (submitReview != null) {
      _result.submitReview = submitReview;
    }
    if (submitResult != null) {
      _result.submitResult = submitResult;
    }
    if (editOrder != null) {
      _result.editOrder = editOrder;
    }
    if (cancelOrder != null) {
      _result.cancelOrder = cancelOrder;
    }
    if (insufficientFunds != null) {
      _result.insufficientFunds = insufficientFunds;
    }
    if (serverConnected != null) {
      _result.serverConnected = serverConnected;
    }
    if (serverDisconnected != null) {
      _result.serverDisconnected = serverDisconnected;
    }
    if (orderCreated != null) {
      _result.orderCreated = orderCreated;
    }
    if (orderRemoved != null) {
      _result.orderRemoved = orderRemoved;
    }
    if (indexPrice != null) {
      _result.indexPrice = indexPrice;
    }
    if (assetDetails != null) {
      _result.assetDetails = assetDetails;
    }
    if (updatePriceStream != null) {
      _result.updatePriceStream = updatePriceStream;
    }
    if (orderComplete != null) {
      _result.orderComplete = orderComplete;
    }
    if (localMessage != null) {
      _result.localMessage = localMessage;
    }
    if (marketDataSubscribe != null) {
      _result.marketDataSubscribe = marketDataSubscribe;
    }
    if (marketDataUpdate != null) {
      _result.marketDataUpdate = marketDataUpdate;
    }
    if (jadeUpdated != null) {
      _result.jadeUpdated = jadeUpdated;
    }
    if (jadeRemoved != null) {
      _result.jadeRemoved = jadeRemoved;
    }
    return _result;
  }
  factory From.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From clone() => From()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From copyWith(void Function(From) updates) => super.copyWith((message) => updates(message as From)) as From; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static From create() => From._();
  From createEmptyInstance() => create();
  static $pb.PbList<From> createRepeated() => $pb.PbList<From>();
  @$core.pragma('dart2js:noInline')
  static From getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From>(create);
  static From? _defaultInstance;

  From_Msg whichMsg() => _From_MsgByTag[$_whichOneof(0)]!;
  void clearMsg() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  From_UpdatedTxs get updatedTxs => $_getN(0);
  @$pb.TagNumber(1)
  set updatedTxs(From_UpdatedTxs v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasUpdatedTxs() => $_has(0);
  @$pb.TagNumber(1)
  void clearUpdatedTxs() => clearField(1);
  @$pb.TagNumber(1)
  From_UpdatedTxs ensureUpdatedTxs() => $_ensure(0);

  @$pb.TagNumber(2)
  From_UpdatedPegs get updatedPegs => $_getN(1);
  @$pb.TagNumber(2)
  set updatedPegs(From_UpdatedPegs v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasUpdatedPegs() => $_has(1);
  @$pb.TagNumber(2)
  void clearUpdatedPegs() => clearField(2);
  @$pb.TagNumber(2)
  From_UpdatedPegs ensureUpdatedPegs() => $_ensure(1);

  @$pb.TagNumber(3)
  Asset get newAsset => $_getN(2);
  @$pb.TagNumber(3)
  set newAsset(Asset v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasNewAsset() => $_has(2);
  @$pb.TagNumber(3)
  void clearNewAsset() => clearField(3);
  @$pb.TagNumber(3)
  Asset ensureNewAsset() => $_ensure(2);

  @$pb.TagNumber(4)
  From_BalanceUpdate get balanceUpdate => $_getN(3);
  @$pb.TagNumber(4)
  set balanceUpdate(From_BalanceUpdate v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasBalanceUpdate() => $_has(3);
  @$pb.TagNumber(4)
  void clearBalanceUpdate() => clearField(4);
  @$pb.TagNumber(4)
  From_BalanceUpdate ensureBalanceUpdate() => $_ensure(3);

  @$pb.TagNumber(5)
  ServerStatus get serverStatus => $_getN(4);
  @$pb.TagNumber(5)
  set serverStatus(ServerStatus v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasServerStatus() => $_has(4);
  @$pb.TagNumber(5)
  void clearServerStatus() => clearField(5);
  @$pb.TagNumber(5)
  ServerStatus ensureServerStatus() => $_ensure(4);

  @$pb.TagNumber(6)
  From_PriceUpdate get priceUpdate => $_getN(5);
  @$pb.TagNumber(6)
  set priceUpdate(From_PriceUpdate v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasPriceUpdate() => $_has(5);
  @$pb.TagNumber(6)
  void clearPriceUpdate() => clearField(6);
  @$pb.TagNumber(6)
  From_PriceUpdate ensurePriceUpdate() => $_ensure(5);

  @$pb.TagNumber(7)
  Empty get walletLoaded => $_getN(6);
  @$pb.TagNumber(7)
  set walletLoaded(Empty v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasWalletLoaded() => $_has(6);
  @$pb.TagNumber(7)
  void clearWalletLoaded() => clearField(7);
  @$pb.TagNumber(7)
  Empty ensureWalletLoaded() => $_ensure(6);

  @$pb.TagNumber(8)
  From_RegisterAmp get registerAmp => $_getN(7);
  @$pb.TagNumber(8)
  set registerAmp(From_RegisterAmp v) { setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasRegisterAmp() => $_has(7);
  @$pb.TagNumber(8)
  void clearRegisterAmp() => clearField(8);
  @$pb.TagNumber(8)
  From_RegisterAmp ensureRegisterAmp() => $_ensure(7);

  @$pb.TagNumber(9)
  From_AmpAssets get ampAssets => $_getN(8);
  @$pb.TagNumber(9)
  set ampAssets(From_AmpAssets v) { setField(9, v); }
  @$pb.TagNumber(9)
  $core.bool hasAmpAssets() => $_has(8);
  @$pb.TagNumber(9)
  void clearAmpAssets() => clearField(9);
  @$pb.TagNumber(9)
  From_AmpAssets ensureAmpAssets() => $_ensure(8);

  @$pb.TagNumber(10)
  From_EncryptPin get encryptPin => $_getN(9);
  @$pb.TagNumber(10)
  set encryptPin(From_EncryptPin v) { setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasEncryptPin() => $_has(9);
  @$pb.TagNumber(10)
  void clearEncryptPin() => clearField(10);
  @$pb.TagNumber(10)
  From_EncryptPin ensureEncryptPin() => $_ensure(9);

  @$pb.TagNumber(11)
  From_DecryptPin get decryptPin => $_getN(10);
  @$pb.TagNumber(11)
  set decryptPin(From_DecryptPin v) { setField(11, v); }
  @$pb.TagNumber(11)
  $core.bool hasDecryptPin() => $_has(10);
  @$pb.TagNumber(11)
  void clearDecryptPin() => clearField(11);
  @$pb.TagNumber(11)
  From_DecryptPin ensureDecryptPin() => $_ensure(10);

  @$pb.TagNumber(12)
  From_RemovedTxs get removedTxs => $_getN(11);
  @$pb.TagNumber(12)
  set removedTxs(From_RemovedTxs v) { setField(12, v); }
  @$pb.TagNumber(12)
  $core.bool hasRemovedTxs() => $_has(11);
  @$pb.TagNumber(12)
  void clearRemovedTxs() => clearField(12);
  @$pb.TagNumber(12)
  From_RemovedTxs ensureRemovedTxs() => $_ensure(11);

  @$pb.TagNumber(13)
  From_EnvSettings get envSettings => $_getN(12);
  @$pb.TagNumber(13)
  set envSettings(From_EnvSettings v) { setField(13, v); }
  @$pb.TagNumber(13)
  $core.bool hasEnvSettings() => $_has(12);
  @$pb.TagNumber(13)
  void clearEnvSettings() => clearField(13);
  @$pb.TagNumber(13)
  From_EnvSettings ensureEnvSettings() => $_ensure(12);

  @$pb.TagNumber(14)
  Empty get syncComplete => $_getN(13);
  @$pb.TagNumber(14)
  set syncComplete(Empty v) { setField(14, v); }
  @$pb.TagNumber(14)
  $core.bool hasSyncComplete() => $_has(13);
  @$pb.TagNumber(14)
  void clearSyncComplete() => clearField(14);
  @$pb.TagNumber(14)
  Empty ensureSyncComplete() => $_ensure(13);

  @$pb.TagNumber(15)
  From_UtxoUpdate get utxoUpdate => $_getN(14);
  @$pb.TagNumber(15)
  set utxoUpdate(From_UtxoUpdate v) { setField(15, v); }
  @$pb.TagNumber(15)
  $core.bool hasUtxoUpdate() => $_has(14);
  @$pb.TagNumber(15)
  void clearUtxoUpdate() => clearField(15);
  @$pb.TagNumber(15)
  From_UtxoUpdate ensureUtxoUpdate() => $_ensure(14);

  @$pb.TagNumber(21)
  From_PeginWaitTx get peginWaitTx => $_getN(15);
  @$pb.TagNumber(21)
  set peginWaitTx(From_PeginWaitTx v) { setField(21, v); }
  @$pb.TagNumber(21)
  $core.bool hasPeginWaitTx() => $_has(15);
  @$pb.TagNumber(21)
  void clearPeginWaitTx() => clearField(21);
  @$pb.TagNumber(21)
  From_PeginWaitTx ensurePeginWaitTx() => $_ensure(15);

  @$pb.TagNumber(22)
  TransItem get swapSucceed => $_getN(16);
  @$pb.TagNumber(22)
  set swapSucceed(TransItem v) { setField(22, v); }
  @$pb.TagNumber(22)
  $core.bool hasSwapSucceed() => $_has(16);
  @$pb.TagNumber(22)
  void clearSwapSucceed() => clearField(22);
  @$pb.TagNumber(22)
  TransItem ensureSwapSucceed() => $_ensure(16);

  @$pb.TagNumber(23)
  $core.String get swapFailed => $_getSZ(17);
  @$pb.TagNumber(23)
  set swapFailed($core.String v) { $_setString(17, v); }
  @$pb.TagNumber(23)
  $core.bool hasSwapFailed() => $_has(17);
  @$pb.TagNumber(23)
  void clearSwapFailed() => clearField(23);

  @$pb.TagNumber(30)
  From_RecvAddress get recvAddress => $_getN(18);
  @$pb.TagNumber(30)
  set recvAddress(From_RecvAddress v) { setField(30, v); }
  @$pb.TagNumber(30)
  $core.bool hasRecvAddress() => $_has(18);
  @$pb.TagNumber(30)
  void clearRecvAddress() => clearField(30);
  @$pb.TagNumber(30)
  From_RecvAddress ensureRecvAddress() => $_ensure(18);

  @$pb.TagNumber(31)
  From_CreateTxResult get createTxResult => $_getN(19);
  @$pb.TagNumber(31)
  set createTxResult(From_CreateTxResult v) { setField(31, v); }
  @$pb.TagNumber(31)
  $core.bool hasCreateTxResult() => $_has(19);
  @$pb.TagNumber(31)
  void clearCreateTxResult() => clearField(31);
  @$pb.TagNumber(31)
  From_CreateTxResult ensureCreateTxResult() => $_ensure(19);

  @$pb.TagNumber(32)
  From_SendResult get sendResult => $_getN(20);
  @$pb.TagNumber(32)
  set sendResult(From_SendResult v) { setField(32, v); }
  @$pb.TagNumber(32)
  $core.bool hasSendResult() => $_has(20);
  @$pb.TagNumber(32)
  void clearSendResult() => clearField(32);
  @$pb.TagNumber(32)
  From_SendResult ensureSendResult() => $_ensure(20);

  @$pb.TagNumber(33)
  From_BlindedValues get blindedValues => $_getN(21);
  @$pb.TagNumber(33)
  set blindedValues(From_BlindedValues v) { setField(33, v); }
  @$pb.TagNumber(33)
  $core.bool hasBlindedValues() => $_has(21);
  @$pb.TagNumber(33)
  void clearBlindedValues() => clearField(33);
  @$pb.TagNumber(33)
  From_BlindedValues ensureBlindedValues() => $_ensure(21);

  @$pb.TagNumber(40)
  From_RegisterPhone get registerPhone => $_getN(22);
  @$pb.TagNumber(40)
  set registerPhone(From_RegisterPhone v) { setField(40, v); }
  @$pb.TagNumber(40)
  $core.bool hasRegisterPhone() => $_has(22);
  @$pb.TagNumber(40)
  void clearRegisterPhone() => clearField(40);
  @$pb.TagNumber(40)
  From_RegisterPhone ensureRegisterPhone() => $_ensure(22);

  @$pb.TagNumber(41)
  From_VerifyPhone get verifyPhone => $_getN(23);
  @$pb.TagNumber(41)
  set verifyPhone(From_VerifyPhone v) { setField(41, v); }
  @$pb.TagNumber(41)
  $core.bool hasVerifyPhone() => $_has(23);
  @$pb.TagNumber(41)
  void clearVerifyPhone() => clearField(41);
  @$pb.TagNumber(41)
  From_VerifyPhone ensureVerifyPhone() => $_ensure(23);

  @$pb.TagNumber(42)
  GenericResponse get uploadAvatar => $_getN(24);
  @$pb.TagNumber(42)
  set uploadAvatar(GenericResponse v) { setField(42, v); }
  @$pb.TagNumber(42)
  $core.bool hasUploadAvatar() => $_has(24);
  @$pb.TagNumber(42)
  void clearUploadAvatar() => clearField(42);
  @$pb.TagNumber(42)
  GenericResponse ensureUploadAvatar() => $_ensure(24);

  @$pb.TagNumber(43)
  GenericResponse get uploadContacts => $_getN(25);
  @$pb.TagNumber(43)
  set uploadContacts(GenericResponse v) { setField(43, v); }
  @$pb.TagNumber(43)
  $core.bool hasUploadContacts() => $_has(25);
  @$pb.TagNumber(43)
  void clearUploadContacts() => clearField(43);
  @$pb.TagNumber(43)
  GenericResponse ensureUploadContacts() => $_ensure(25);

  @$pb.TagNumber(44)
  Contact get contactCreated => $_getN(26);
  @$pb.TagNumber(44)
  set contactCreated(Contact v) { setField(44, v); }
  @$pb.TagNumber(44)
  $core.bool hasContactCreated() => $_has(26);
  @$pb.TagNumber(44)
  void clearContactCreated() => clearField(44);
  @$pb.TagNumber(44)
  Contact ensureContactCreated() => $_ensure(26);

  @$pb.TagNumber(45)
  From_ContactRemoved get contactRemoved => $_getN(27);
  @$pb.TagNumber(45)
  set contactRemoved(From_ContactRemoved v) { setField(45, v); }
  @$pb.TagNumber(45)
  $core.bool hasContactRemoved() => $_has(27);
  @$pb.TagNumber(45)
  void clearContactRemoved() => clearField(45);
  @$pb.TagNumber(45)
  From_ContactRemoved ensureContactRemoved() => $_ensure(27);

  @$pb.TagNumber(46)
  ContactTransaction get contactTransaction => $_getN(28);
  @$pb.TagNumber(46)
  set contactTransaction(ContactTransaction v) { setField(46, v); }
  @$pb.TagNumber(46)
  $core.bool hasContactTransaction() => $_has(28);
  @$pb.TagNumber(46)
  void clearContactTransaction() => clearField(46);
  @$pb.TagNumber(46)
  ContactTransaction ensureContactTransaction() => $_ensure(28);

  @$pb.TagNumber(47)
  From_AccountStatus get accountStatus => $_getN(29);
  @$pb.TagNumber(47)
  set accountStatus(From_AccountStatus v) { setField(47, v); }
  @$pb.TagNumber(47)
  $core.bool hasAccountStatus() => $_has(29);
  @$pb.TagNumber(47)
  void clearAccountStatus() => clearField(47);
  @$pb.TagNumber(47)
  From_AccountStatus ensureAccountStatus() => $_ensure(29);

  @$pb.TagNumber(50)
  From_ShowMessage get showMessage => $_getN(30);
  @$pb.TagNumber(50)
  set showMessage(From_ShowMessage v) { setField(50, v); }
  @$pb.TagNumber(50)
  $core.bool hasShowMessage() => $_has(30);
  @$pb.TagNumber(50)
  void clearShowMessage() => clearField(50);
  @$pb.TagNumber(50)
  From_ShowMessage ensureShowMessage() => $_ensure(30);

  @$pb.TagNumber(51)
  From_SubmitReview get submitReview => $_getN(31);
  @$pb.TagNumber(51)
  set submitReview(From_SubmitReview v) { setField(51, v); }
  @$pb.TagNumber(51)
  $core.bool hasSubmitReview() => $_has(31);
  @$pb.TagNumber(51)
  void clearSubmitReview() => clearField(51);
  @$pb.TagNumber(51)
  From_SubmitReview ensureSubmitReview() => $_ensure(31);

  @$pb.TagNumber(52)
  From_SubmitResult get submitResult => $_getN(32);
  @$pb.TagNumber(52)
  set submitResult(From_SubmitResult v) { setField(52, v); }
  @$pb.TagNumber(52)
  $core.bool hasSubmitResult() => $_has(32);
  @$pb.TagNumber(52)
  void clearSubmitResult() => clearField(52);
  @$pb.TagNumber(52)
  From_SubmitResult ensureSubmitResult() => $_ensure(32);

  @$pb.TagNumber(53)
  GenericResponse get editOrder => $_getN(33);
  @$pb.TagNumber(53)
  set editOrder(GenericResponse v) { setField(53, v); }
  @$pb.TagNumber(53)
  $core.bool hasEditOrder() => $_has(33);
  @$pb.TagNumber(53)
  void clearEditOrder() => clearField(53);
  @$pb.TagNumber(53)
  GenericResponse ensureEditOrder() => $_ensure(33);

  @$pb.TagNumber(54)
  GenericResponse get cancelOrder => $_getN(34);
  @$pb.TagNumber(54)
  set cancelOrder(GenericResponse v) { setField(54, v); }
  @$pb.TagNumber(54)
  $core.bool hasCancelOrder() => $_has(34);
  @$pb.TagNumber(54)
  void clearCancelOrder() => clearField(54);
  @$pb.TagNumber(54)
  GenericResponse ensureCancelOrder() => $_ensure(34);

  @$pb.TagNumber(55)
  From_ShowInsufficientFunds get insufficientFunds => $_getN(35);
  @$pb.TagNumber(55)
  set insufficientFunds(From_ShowInsufficientFunds v) { setField(55, v); }
  @$pb.TagNumber(55)
  $core.bool hasInsufficientFunds() => $_has(35);
  @$pb.TagNumber(55)
  void clearInsufficientFunds() => clearField(55);
  @$pb.TagNumber(55)
  From_ShowInsufficientFunds ensureInsufficientFunds() => $_ensure(35);

  @$pb.TagNumber(60)
  Empty get serverConnected => $_getN(36);
  @$pb.TagNumber(60)
  set serverConnected(Empty v) { setField(60, v); }
  @$pb.TagNumber(60)
  $core.bool hasServerConnected() => $_has(36);
  @$pb.TagNumber(60)
  void clearServerConnected() => clearField(60);
  @$pb.TagNumber(60)
  Empty ensureServerConnected() => $_ensure(36);

  @$pb.TagNumber(61)
  Empty get serverDisconnected => $_getN(37);
  @$pb.TagNumber(61)
  set serverDisconnected(Empty v) { setField(61, v); }
  @$pb.TagNumber(61)
  $core.bool hasServerDisconnected() => $_has(37);
  @$pb.TagNumber(61)
  void clearServerDisconnected() => clearField(61);
  @$pb.TagNumber(61)
  Empty ensureServerDisconnected() => $_ensure(37);

  @$pb.TagNumber(62)
  From_OrderCreated get orderCreated => $_getN(38);
  @$pb.TagNumber(62)
  set orderCreated(From_OrderCreated v) { setField(62, v); }
  @$pb.TagNumber(62)
  $core.bool hasOrderCreated() => $_has(38);
  @$pb.TagNumber(62)
  void clearOrderCreated() => clearField(62);
  @$pb.TagNumber(62)
  From_OrderCreated ensureOrderCreated() => $_ensure(38);

  @$pb.TagNumber(63)
  From_OrderRemoved get orderRemoved => $_getN(39);
  @$pb.TagNumber(63)
  set orderRemoved(From_OrderRemoved v) { setField(63, v); }
  @$pb.TagNumber(63)
  $core.bool hasOrderRemoved() => $_has(39);
  @$pb.TagNumber(63)
  void clearOrderRemoved() => clearField(63);
  @$pb.TagNumber(63)
  From_OrderRemoved ensureOrderRemoved() => $_ensure(39);

  @$pb.TagNumber(64)
  From_IndexPrice get indexPrice => $_getN(40);
  @$pb.TagNumber(64)
  set indexPrice(From_IndexPrice v) { setField(64, v); }
  @$pb.TagNumber(64)
  $core.bool hasIndexPrice() => $_has(40);
  @$pb.TagNumber(64)
  void clearIndexPrice() => clearField(64);
  @$pb.TagNumber(64)
  From_IndexPrice ensureIndexPrice() => $_ensure(40);

  @$pb.TagNumber(65)
  From_AssetDetails get assetDetails => $_getN(41);
  @$pb.TagNumber(65)
  set assetDetails(From_AssetDetails v) { setField(65, v); }
  @$pb.TagNumber(65)
  $core.bool hasAssetDetails() => $_has(41);
  @$pb.TagNumber(65)
  void clearAssetDetails() => clearField(65);
  @$pb.TagNumber(65)
  From_AssetDetails ensureAssetDetails() => $_ensure(41);

  @$pb.TagNumber(66)
  From_UpdatePriceStream get updatePriceStream => $_getN(42);
  @$pb.TagNumber(66)
  set updatePriceStream(From_UpdatePriceStream v) { setField(66, v); }
  @$pb.TagNumber(66)
  $core.bool hasUpdatePriceStream() => $_has(42);
  @$pb.TagNumber(66)
  void clearUpdatePriceStream() => clearField(66);
  @$pb.TagNumber(66)
  From_UpdatePriceStream ensureUpdatePriceStream() => $_ensure(42);

  @$pb.TagNumber(67)
  From_OrderComplete get orderComplete => $_getN(43);
  @$pb.TagNumber(67)
  set orderComplete(From_OrderComplete v) { setField(67, v); }
  @$pb.TagNumber(67)
  $core.bool hasOrderComplete() => $_has(43);
  @$pb.TagNumber(67)
  void clearOrderComplete() => clearField(67);
  @$pb.TagNumber(67)
  From_OrderComplete ensureOrderComplete() => $_ensure(43);

  @$pb.TagNumber(68)
  From_LocalMessage get localMessage => $_getN(44);
  @$pb.TagNumber(68)
  set localMessage(From_LocalMessage v) { setField(68, v); }
  @$pb.TagNumber(68)
  $core.bool hasLocalMessage() => $_has(44);
  @$pb.TagNumber(68)
  void clearLocalMessage() => clearField(68);
  @$pb.TagNumber(68)
  From_LocalMessage ensureLocalMessage() => $_ensure(44);

  @$pb.TagNumber(70)
  From_MarketDataSubscribe get marketDataSubscribe => $_getN(45);
  @$pb.TagNumber(70)
  set marketDataSubscribe(From_MarketDataSubscribe v) { setField(70, v); }
  @$pb.TagNumber(70)
  $core.bool hasMarketDataSubscribe() => $_has(45);
  @$pb.TagNumber(70)
  void clearMarketDataSubscribe() => clearField(70);
  @$pb.TagNumber(70)
  From_MarketDataSubscribe ensureMarketDataSubscribe() => $_ensure(45);

  @$pb.TagNumber(71)
  From_MarketDataUpdate get marketDataUpdate => $_getN(46);
  @$pb.TagNumber(71)
  set marketDataUpdate(From_MarketDataUpdate v) { setField(71, v); }
  @$pb.TagNumber(71)
  $core.bool hasMarketDataUpdate() => $_has(46);
  @$pb.TagNumber(71)
  void clearMarketDataUpdate() => clearField(71);
  @$pb.TagNumber(71)
  From_MarketDataUpdate ensureMarketDataUpdate() => $_ensure(46);

  @$pb.TagNumber(80)
  From_JadeUpdated get jadeUpdated => $_getN(47);
  @$pb.TagNumber(80)
  set jadeUpdated(From_JadeUpdated v) { setField(80, v); }
  @$pb.TagNumber(80)
  $core.bool hasJadeUpdated() => $_has(47);
  @$pb.TagNumber(80)
  void clearJadeUpdated() => clearField(80);
  @$pb.TagNumber(80)
  From_JadeUpdated ensureJadeUpdated() => $_ensure(47);

  @$pb.TagNumber(81)
  From_JadeRemoved get jadeRemoved => $_getN(48);
  @$pb.TagNumber(81)
  set jadeRemoved(From_JadeRemoved v) { setField(81, v); }
  @$pb.TagNumber(81)
  $core.bool hasJadeRemoved() => $_has(48);
  @$pb.TagNumber(81)
  void clearJadeRemoved() => clearField(81);
  @$pb.TagNumber(81)
  From_JadeRemoved ensureJadeRemoved() => $_ensure(48);
}

class Settings_AccountAsset extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Settings.AccountAsset', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQM<Account>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'account', subBuilder: Account.create)
    ..aQS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'assetId')
  ;

  Settings_AccountAsset._() : super();
  factory Settings_AccountAsset({
    Account? account,
    $core.String? assetId,
  }) {
    final _result = create();
    if (account != null) {
      _result.account = account;
    }
    if (assetId != null) {
      _result.assetId = assetId;
    }
    return _result;
  }
  factory Settings_AccountAsset.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Settings_AccountAsset.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Settings_AccountAsset clone() => Settings_AccountAsset()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Settings_AccountAsset copyWith(void Function(Settings_AccountAsset) updates) => super.copyWith((message) => updates(message as Settings_AccountAsset)) as Settings_AccountAsset; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Settings_AccountAsset create() => Settings_AccountAsset._();
  Settings_AccountAsset createEmptyInstance() => create();
  static $pb.PbList<Settings_AccountAsset> createRepeated() => $pb.PbList<Settings_AccountAsset>();
  @$core.pragma('dart2js:noInline')
  static Settings_AccountAsset getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Settings_AccountAsset>(create);
  static Settings_AccountAsset? _defaultInstance;

  @$pb.TagNumber(1)
  Account get account => $_getN(0);
  @$pb.TagNumber(1)
  set account(Account v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasAccount() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccount() => clearField(1);
  @$pb.TagNumber(1)
  Account ensureAccount() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get assetId => $_getSZ(1);
  @$pb.TagNumber(2)
  set assetId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAssetId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAssetId() => clearField(2);
}

class Settings extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Settings', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..pc<Settings_AccountAsset>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'disabledAccounts', $pb.PbFieldType.PM, subBuilder: Settings_AccountAsset.create)
  ;

  Settings._() : super();
  factory Settings({
    $core.Iterable<Settings_AccountAsset>? disabledAccounts,
  }) {
    final _result = create();
    if (disabledAccounts != null) {
      _result.disabledAccounts.addAll(disabledAccounts);
    }
    return _result;
  }
  factory Settings.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Settings.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Settings clone() => Settings()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Settings copyWith(void Function(Settings) updates) => super.copyWith((message) => updates(message as Settings)) as Settings; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Settings create() => Settings._();
  Settings createEmptyInstance() => create();
  static $pb.PbList<Settings> createRepeated() => $pb.PbList<Settings>();
  @$core.pragma('dart2js:noInline')
  static Settings getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Settings>(create);
  static Settings? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<Settings_AccountAsset> get disabledAccounts => $_getList(0);
}

