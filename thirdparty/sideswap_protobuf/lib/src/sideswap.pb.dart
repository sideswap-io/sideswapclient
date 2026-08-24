// This is a generated file - do not edit.
//
// Generated from sideswap.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'sideswap.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'sideswap.pbenum.dart';

class Empty extends $pb.GeneratedMessage {
  factory Empty() => create();

  Empty._();

  factory Empty.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Empty.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Empty',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Empty clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Empty copyWith(void Function(Empty) updates) =>
      super.copyWith((message) => updates(message as Empty)) as Empty;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Empty create() => Empty._();
  @$core.override
  Empty createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Empty getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Empty>(create);
  static Empty? _defaultInstance;
}

class Address extends $pb.GeneratedMessage {
  factory Address({
    $core.String? addr,
  }) {
    final result = create();
    if (addr != null) result.addr = addr;
    return result;
  }

  Address._();

  factory Address.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Address.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Address',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'addr');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Address clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Address copyWith(void Function(Address) updates) =>
      super.copyWith((message) => updates(message as Address)) as Address;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Address create() => Address._();
  @$core.override
  Address createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Address getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Address>(create);
  static Address? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get addr => $_getSZ(0);
  @$pb.TagNumber(1)
  set addr($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAddr() => $_has(0);
  @$pb.TagNumber(1)
  void clearAddr() => $_clearField(1);
}

class AddressAmount extends $pb.GeneratedMessage {
  factory AddressAmount({
    $core.String? address,
    $fixnum.Int64? amount,
    $core.String? assetId,
  }) {
    final result = create();
    if (address != null) result.address = address;
    if (amount != null) result.amount = amount;
    if (assetId != null) result.assetId = assetId;
    return result;
  }

  AddressAmount._();

  factory AddressAmount.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddressAmount.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddressAmount',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'address')
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'amount', $pb.PbFieldType.Q6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aQS(3, _omitFieldNames ? '' : 'assetId');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddressAmount clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddressAmount copyWith(void Function(AddressAmount) updates) =>
      super.copyWith((message) => updates(message as AddressAmount))
          as AddressAmount;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddressAmount create() => AddressAmount._();
  @$core.override
  AddressAmount createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AddressAmount getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddressAmount>(create);
  static AddressAmount? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get address => $_getSZ(0);
  @$pb.TagNumber(1)
  set address($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAddress() => $_has(0);
  @$pb.TagNumber(1)
  void clearAddress() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get amount => $_getI64(1);
  @$pb.TagNumber(2)
  set amount($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAmount() => $_has(1);
  @$pb.TagNumber(2)
  void clearAmount() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get assetId => $_getSZ(2);
  @$pb.TagNumber(3)
  set assetId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAssetId() => $_has(2);
  @$pb.TagNumber(3)
  void clearAssetId() => $_clearField(3);
}

class Balance extends $pb.GeneratedMessage {
  factory Balance({
    $core.String? assetId,
    $fixnum.Int64? amount,
  }) {
    final result = create();
    if (assetId != null) result.assetId = assetId;
    if (amount != null) result.amount = amount;
    return result;
  }

  Balance._();

  factory Balance.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Balance.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Balance',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'assetId')
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'amount', $pb.PbFieldType.Q6,
        defaultOrMaker: $fixnum.Int64.ZERO);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Balance clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Balance copyWith(void Function(Balance) updates) =>
      super.copyWith((message) => updates(message as Balance)) as Balance;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Balance create() => Balance._();
  @$core.override
  Balance createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Balance getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Balance>(create);
  static Balance? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assetId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get amount => $_getI64(1);
  @$pb.TagNumber(2)
  set amount($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAmount() => $_has(1);
  @$pb.TagNumber(2)
  void clearAmount() => $_clearField(2);
}

class AmpAssetRestrictions extends $pb.GeneratedMessage {
  factory AmpAssetRestrictions({
    $core.Iterable<$core.String>? allowedCountries,
  }) {
    final result = create();
    if (allowedCountries != null)
      result.allowedCountries.addAll(allowedCountries);
    return result;
  }

  AmpAssetRestrictions._();

  factory AmpAssetRestrictions.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AmpAssetRestrictions.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AmpAssetRestrictions',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'allowedCountries')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AmpAssetRestrictions clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AmpAssetRestrictions copyWith(void Function(AmpAssetRestrictions) updates) =>
      super.copyWith((message) => updates(message as AmpAssetRestrictions))
          as AmpAssetRestrictions;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AmpAssetRestrictions create() => AmpAssetRestrictions._();
  @$core.override
  AmpAssetRestrictions createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AmpAssetRestrictions getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AmpAssetRestrictions>(create);
  static AmpAssetRestrictions? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get allowedCountries => $_getList(0);
}

class Asset extends $pb.GeneratedMessage {
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
    $core.bool? instantSwaps,
    $core.bool? alwaysShow,
    $core.String? domainAgentLink,
    AmpAssetRestrictions? ampAssetRestrictions,
    $core.bool? payjoin,
  }) {
    final result = create();
    if (assetId != null) result.assetId = assetId;
    if (name != null) result.name = name;
    if (ticker != null) result.ticker = ticker;
    if (icon != null) result.icon = icon;
    if (precision != null) result.precision = precision;
    if (swapMarket != null) result.swapMarket = swapMarket;
    if (domain != null) result.domain = domain;
    if (unregistered != null) result.unregistered = unregistered;
    if (ampMarket != null) result.ampMarket = ampMarket;
    if (domainAgent != null) result.domainAgent = domainAgent;
    if (instantSwaps != null) result.instantSwaps = instantSwaps;
    if (alwaysShow != null) result.alwaysShow = alwaysShow;
    if (domainAgentLink != null) result.domainAgentLink = domainAgentLink;
    if (ampAssetRestrictions != null)
      result.ampAssetRestrictions = ampAssetRestrictions;
    if (payjoin != null) result.payjoin = payjoin;
    return result;
  }

  Asset._();

  factory Asset.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Asset.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Asset',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'assetId')
    ..aQS(2, _omitFieldNames ? '' : 'name')
    ..aQS(3, _omitFieldNames ? '' : 'ticker')
    ..aQS(4, _omitFieldNames ? '' : 'icon')
    ..aI(5, _omitFieldNames ? '' : 'precision', fieldType: $pb.PbFieldType.QU3)
    ..a<$core.bool>(6, _omitFieldNames ? '' : 'swapMarket', $pb.PbFieldType.QB)
    ..aOS(7, _omitFieldNames ? '' : 'domain')
    ..a<$core.bool>(
        8, _omitFieldNames ? '' : 'unregistered', $pb.PbFieldType.QB)
    ..a<$core.bool>(9, _omitFieldNames ? '' : 'ampMarket', $pb.PbFieldType.QB)
    ..aOS(10, _omitFieldNames ? '' : 'domainAgent')
    ..a<$core.bool>(
        11, _omitFieldNames ? '' : 'instantSwaps', $pb.PbFieldType.QB)
    ..aOB(12, _omitFieldNames ? '' : 'alwaysShow')
    ..aOS(13, _omitFieldNames ? '' : 'domainAgentLink')
    ..aOM<AmpAssetRestrictions>(
        14, _omitFieldNames ? '' : 'ampAssetRestrictions',
        subBuilder: AmpAssetRestrictions.create)
    ..aOB(15, _omitFieldNames ? '' : 'payjoin');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Asset clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Asset copyWith(void Function(Asset) updates) =>
      super.copyWith((message) => updates(message as Asset)) as Asset;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Asset create() => Asset._();
  @$core.override
  Asset createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Asset getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Asset>(create);
  static Asset? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assetId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get ticker => $_getSZ(2);
  @$pb.TagNumber(3)
  set ticker($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTicker() => $_has(2);
  @$pb.TagNumber(3)
  void clearTicker() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get icon => $_getSZ(3);
  @$pb.TagNumber(4)
  set icon($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIcon() => $_has(3);
  @$pb.TagNumber(4)
  void clearIcon() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get precision => $_getIZ(4);
  @$pb.TagNumber(5)
  set precision($core.int value) => $_setUnsignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPrecision() => $_has(4);
  @$pb.TagNumber(5)
  void clearPrecision() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get swapMarket => $_getBF(5);
  @$pb.TagNumber(6)
  set swapMarket($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSwapMarket() => $_has(5);
  @$pb.TagNumber(6)
  void clearSwapMarket() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get domain => $_getSZ(6);
  @$pb.TagNumber(7)
  set domain($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasDomain() => $_has(6);
  @$pb.TagNumber(7)
  void clearDomain() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get unregistered => $_getBF(7);
  @$pb.TagNumber(8)
  set unregistered($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasUnregistered() => $_has(7);
  @$pb.TagNumber(8)
  void clearUnregistered() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get ampMarket => $_getBF(8);
  @$pb.TagNumber(9)
  set ampMarket($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasAmpMarket() => $_has(8);
  @$pb.TagNumber(9)
  void clearAmpMarket() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get domainAgent => $_getSZ(9);
  @$pb.TagNumber(10)
  set domainAgent($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasDomainAgent() => $_has(9);
  @$pb.TagNumber(10)
  void clearDomainAgent() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.bool get instantSwaps => $_getBF(10);
  @$pb.TagNumber(11)
  set instantSwaps($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasInstantSwaps() => $_has(10);
  @$pb.TagNumber(11)
  void clearInstantSwaps() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.bool get alwaysShow => $_getBF(11);
  @$pb.TagNumber(12)
  set alwaysShow($core.bool value) => $_setBool(11, value);
  @$pb.TagNumber(12)
  $core.bool hasAlwaysShow() => $_has(11);
  @$pb.TagNumber(12)
  void clearAlwaysShow() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get domainAgentLink => $_getSZ(12);
  @$pb.TagNumber(13)
  set domainAgentLink($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasDomainAgentLink() => $_has(12);
  @$pb.TagNumber(13)
  void clearDomainAgentLink() => $_clearField(13);

  @$pb.TagNumber(14)
  AmpAssetRestrictions get ampAssetRestrictions => $_getN(13);
  @$pb.TagNumber(14)
  set ampAssetRestrictions(AmpAssetRestrictions value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasAmpAssetRestrictions() => $_has(13);
  @$pb.TagNumber(14)
  void clearAmpAssetRestrictions() => $_clearField(14);
  @$pb.TagNumber(14)
  AmpAssetRestrictions ensureAmpAssetRestrictions() => $_ensure(13);

  @$pb.TagNumber(15)
  $core.bool get payjoin => $_getBF(14);
  @$pb.TagNumber(15)
  set payjoin($core.bool value) => $_setBool(14, value);
  @$pb.TagNumber(15)
  $core.bool hasPayjoin() => $_has(14);
  @$pb.TagNumber(15)
  void clearPayjoin() => $_clearField(15);
}

class Tx extends $pb.GeneratedMessage {
  factory Tx({
    $core.Iterable<Balance>? balances,
    $core.String? txid,
    $fixnum.Int64? networkFee,
    $core.String? memo,
    $fixnum.Int64? vsize,
    $core.Iterable<Balance>? balancesAll,
  }) {
    final result = create();
    if (balances != null) result.balances.addAll(balances);
    if (txid != null) result.txid = txid;
    if (networkFee != null) result.networkFee = networkFee;
    if (memo != null) result.memo = memo;
    if (vsize != null) result.vsize = vsize;
    if (balancesAll != null) result.balancesAll.addAll(balancesAll);
    return result;
  }

  Tx._();

  factory Tx.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Tx.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Tx',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..pPM<Balance>(1, _omitFieldNames ? '' : 'balances',
        subBuilder: Balance.create)
    ..aQS(2, _omitFieldNames ? '' : 'txid')
    ..a<$fixnum.Int64>(
        3, _omitFieldNames ? '' : 'networkFee', $pb.PbFieldType.Q6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aQS(4, _omitFieldNames ? '' : 'memo')
    ..a<$fixnum.Int64>(6, _omitFieldNames ? '' : 'vsize', $pb.PbFieldType.Q6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..pPM<Balance>(7, _omitFieldNames ? '' : 'balancesAll',
        subBuilder: Balance.create);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Tx clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Tx copyWith(void Function(Tx) updates) =>
      super.copyWith((message) => updates(message as Tx)) as Tx;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Tx create() => Tx._();
  @$core.override
  Tx createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Tx getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Tx>(create);
  static Tx? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Balance> get balances => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get txid => $_getSZ(1);
  @$pb.TagNumber(2)
  set txid($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTxid() => $_has(1);
  @$pb.TagNumber(2)
  void clearTxid() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get networkFee => $_getI64(2);
  @$pb.TagNumber(3)
  set networkFee($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNetworkFee() => $_has(2);
  @$pb.TagNumber(3)
  void clearNetworkFee() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get memo => $_getSZ(3);
  @$pb.TagNumber(4)
  set memo($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMemo() => $_has(3);
  @$pb.TagNumber(4)
  void clearMemo() => $_clearField(4);

  @$pb.TagNumber(6)
  $fixnum.Int64 get vsize => $_getI64(4);
  @$pb.TagNumber(6)
  set vsize($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(6)
  $core.bool hasVsize() => $_has(4);
  @$pb.TagNumber(6)
  void clearVsize() => $_clearField(6);

  @$pb.TagNumber(7)
  $pb.PbList<Balance> get balancesAll => $_getList(5);
}

class Peg extends $pb.GeneratedMessage {
  factory Peg({
    $core.bool? isPegIn,
    $fixnum.Int64? amountSend,
    $fixnum.Int64? amountRecv,
    $core.String? addrSend,
    $core.String? addrRecv,
    $core.String? txidSend,
    $core.String? txidRecv,
  }) {
    final result = create();
    if (isPegIn != null) result.isPegIn = isPegIn;
    if (amountSend != null) result.amountSend = amountSend;
    if (amountRecv != null) result.amountRecv = amountRecv;
    if (addrSend != null) result.addrSend = addrSend;
    if (addrRecv != null) result.addrRecv = addrRecv;
    if (txidSend != null) result.txidSend = txidSend;
    if (txidRecv != null) result.txidRecv = txidRecv;
    return result;
  }

  Peg._();

  factory Peg.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Peg.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Peg',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..a<$core.bool>(1, _omitFieldNames ? '' : 'isPegIn', $pb.PbFieldType.QB)
    ..a<$fixnum.Int64>(
        2, _omitFieldNames ? '' : 'amountSend', $pb.PbFieldType.Q6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        3, _omitFieldNames ? '' : 'amountRecv', $pb.PbFieldType.Q6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aQS(4, _omitFieldNames ? '' : 'addrSend')
    ..aQS(5, _omitFieldNames ? '' : 'addrRecv')
    ..aQS(6, _omitFieldNames ? '' : 'txidSend')
    ..aOS(8, _omitFieldNames ? '' : 'txidRecv');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Peg clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Peg copyWith(void Function(Peg) updates) =>
      super.copyWith((message) => updates(message as Peg)) as Peg;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Peg create() => Peg._();
  @$core.override
  Peg createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Peg getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Peg>(create);
  static Peg? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get isPegIn => $_getBF(0);
  @$pb.TagNumber(1)
  set isPegIn($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIsPegIn() => $_has(0);
  @$pb.TagNumber(1)
  void clearIsPegIn() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get amountSend => $_getI64(1);
  @$pb.TagNumber(2)
  set amountSend($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAmountSend() => $_has(1);
  @$pb.TagNumber(2)
  void clearAmountSend() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get amountRecv => $_getI64(2);
  @$pb.TagNumber(3)
  set amountRecv($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAmountRecv() => $_has(2);
  @$pb.TagNumber(3)
  void clearAmountRecv() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get addrSend => $_getSZ(3);
  @$pb.TagNumber(4)
  set addrSend($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAddrSend() => $_has(3);
  @$pb.TagNumber(4)
  void clearAddrSend() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get addrRecv => $_getSZ(4);
  @$pb.TagNumber(5)
  set addrRecv($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAddrRecv() => $_has(4);
  @$pb.TagNumber(5)
  void clearAddrRecv() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get txidSend => $_getSZ(5);
  @$pb.TagNumber(6)
  set txidSend($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTxidSend() => $_has(5);
  @$pb.TagNumber(6)
  void clearTxidSend() => $_clearField(6);

  @$pb.TagNumber(8)
  $core.String get txidRecv => $_getSZ(6);
  @$pb.TagNumber(8)
  set txidRecv($core.String value) => $_setString(6, value);
  @$pb.TagNumber(8)
  $core.bool hasTxidRecv() => $_has(6);
  @$pb.TagNumber(8)
  void clearTxidRecv() => $_clearField(8);
}

class Confs extends $pb.GeneratedMessage {
  factory Confs({
    $core.int? count,
    $core.int? total,
  }) {
    final result = create();
    if (count != null) result.count = count;
    if (total != null) result.total = total;
    return result;
  }

  Confs._();

  factory Confs.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Confs.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Confs',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'count', fieldType: $pb.PbFieldType.QU3)
    ..aI(2, _omitFieldNames ? '' : 'total', fieldType: $pb.PbFieldType.QU3);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Confs clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Confs copyWith(void Function(Confs) updates) =>
      super.copyWith((message) => updates(message as Confs)) as Confs;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Confs create() => Confs._();
  @$core.override
  Confs createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Confs getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Confs>(create);
  static Confs? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get count => $_getIZ(0);
  @$pb.TagNumber(1)
  set count($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearCount() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get total => $_getIZ(1);
  @$pb.TagNumber(2)
  set total($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotal() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotal() => $_clearField(2);
}

enum TransItem_Item { tx, peg, notSet }

class TransItem extends $pb.GeneratedMessage {
  factory TransItem({
    $core.String? id,
    $fixnum.Int64? createdAt,
    Confs? confs,
    Tx? tx,
    Peg? peg,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (createdAt != null) result.createdAt = createdAt;
    if (confs != null) result.confs = confs;
    if (tx != null) result.tx = tx;
    if (peg != null) result.peg = peg;
    return result;
  }

  TransItem._();

  factory TransItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TransItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, TransItem_Item> _TransItem_ItemByTag = {
    10: TransItem_Item.tx,
    11: TransItem_Item.peg,
    0: TransItem_Item.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TransItem',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..oo(0, [10, 11])
    ..aQS(1, _omitFieldNames ? '' : 'id')
    ..a<$fixnum.Int64>(
        2, _omitFieldNames ? '' : 'createdAt', $pb.PbFieldType.Q6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOM<Confs>(3, _omitFieldNames ? '' : 'confs', subBuilder: Confs.create)
    ..aOM<Tx>(10, _omitFieldNames ? '' : 'tx', subBuilder: Tx.create)
    ..aOM<Peg>(11, _omitFieldNames ? '' : 'peg', subBuilder: Peg.create);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TransItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TransItem copyWith(void Function(TransItem) updates) =>
      super.copyWith((message) => updates(message as TransItem)) as TransItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TransItem create() => TransItem._();
  @$core.override
  TransItem createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TransItem getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TransItem>(create);
  static TransItem? _defaultInstance;

  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  TransItem_Item whichItem() => _TransItem_ItemByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  void clearItem() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get createdAt => $_getI64(1);
  @$pb.TagNumber(2)
  set createdAt($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCreatedAt() => $_has(1);
  @$pb.TagNumber(2)
  void clearCreatedAt() => $_clearField(2);

  @$pb.TagNumber(3)
  Confs get confs => $_getN(2);
  @$pb.TagNumber(3)
  set confs(Confs value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasConfs() => $_has(2);
  @$pb.TagNumber(3)
  void clearConfs() => $_clearField(3);
  @$pb.TagNumber(3)
  Confs ensureConfs() => $_ensure(2);

  @$pb.TagNumber(10)
  Tx get tx => $_getN(3);
  @$pb.TagNumber(10)
  set tx(Tx value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasTx() => $_has(3);
  @$pb.TagNumber(10)
  void clearTx() => $_clearField(10);
  @$pb.TagNumber(10)
  Tx ensureTx() => $_ensure(3);

  @$pb.TagNumber(11)
  Peg get peg => $_getN(4);
  @$pb.TagNumber(11)
  set peg(Peg value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasPeg() => $_has(4);
  @$pb.TagNumber(11)
  void clearPeg() => $_clearField(11);
  @$pb.TagNumber(11)
  Peg ensurePeg() => $_ensure(4);
}

class AssetId extends $pb.GeneratedMessage {
  factory AssetId({
    $core.String? assetId,
  }) {
    final result = create();
    if (assetId != null) result.assetId = assetId;
    return result;
  }

  AssetId._();

  factory AssetId.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AssetId.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AssetId',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'assetId');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AssetId clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AssetId copyWith(void Function(AssetId) updates) =>
      super.copyWith((message) => updates(message as AssetId)) as AssetId;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AssetId create() => AssetId._();
  @$core.override
  AssetId createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AssetId getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AssetId>(create);
  static AssetId? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assetId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetId() => $_clearField(1);
}

class GenericResponse extends $pb.GeneratedMessage {
  factory GenericResponse({
    $core.bool? success,
    $core.String? errorMsg,
  }) {
    final result = create();
    if (success != null) result.success = success;
    if (errorMsg != null) result.errorMsg = errorMsg;
    return result;
  }

  GenericResponse._();

  factory GenericResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GenericResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GenericResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..a<$core.bool>(1, _omitFieldNames ? '' : 'success', $pb.PbFieldType.QB)
    ..aOS(2, _omitFieldNames ? '' : 'errorMsg');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GenericResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GenericResponse copyWith(void Function(GenericResponse) updates) =>
      super.copyWith((message) => updates(message as GenericResponse))
          as GenericResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GenericResponse create() => GenericResponse._();
  @$core.override
  GenericResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GenericResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GenericResponse>(create);
  static GenericResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get errorMsg => $_getSZ(1);
  @$pb.TagNumber(2)
  set errorMsg($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasErrorMsg() => $_has(1);
  @$pb.TagNumber(2)
  void clearErrorMsg() => $_clearField(2);
}

class FeeRate extends $pb.GeneratedMessage {
  factory FeeRate({
    $core.int? blocks,
    $core.double? value,
  }) {
    final result = create();
    if (blocks != null) result.blocks = blocks;
    if (value != null) result.value = value;
    return result;
  }

  FeeRate._();

  factory FeeRate.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FeeRate.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FeeRate',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'blocks', fieldType: $pb.PbFieldType.Q3)
    ..aD(2, _omitFieldNames ? '' : 'value', fieldType: $pb.PbFieldType.QD);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FeeRate clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FeeRate copyWith(void Function(FeeRate) updates) =>
      super.copyWith((message) => updates(message as FeeRate)) as FeeRate;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FeeRate create() => FeeRate._();
  @$core.override
  FeeRate createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FeeRate getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FeeRate>(create);
  static FeeRate? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get blocks => $_getIZ(0);
  @$pb.TagNumber(1)
  set blocks($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasBlocks() => $_has(0);
  @$pb.TagNumber(1)
  void clearBlocks() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get value => $_getN(1);
  @$pb.TagNumber(2)
  set value($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearValue() => $_clearField(2);
}

class ServerStatus extends $pb.GeneratedMessage {
  factory ServerStatus({
    $fixnum.Int64? minPegInAmount,
    $fixnum.Int64? minPegOutAmount,
    $core.double? serverFeePercentPegIn,
    $core.double? serverFeePercentPegOut,
    $core.Iterable<FeeRate>? bitcoinFeeRates,
  }) {
    final result = create();
    if (minPegInAmount != null) result.minPegInAmount = minPegInAmount;
    if (minPegOutAmount != null) result.minPegOutAmount = minPegOutAmount;
    if (serverFeePercentPegIn != null)
      result.serverFeePercentPegIn = serverFeePercentPegIn;
    if (serverFeePercentPegOut != null)
      result.serverFeePercentPegOut = serverFeePercentPegOut;
    if (bitcoinFeeRates != null) result.bitcoinFeeRates.addAll(bitcoinFeeRates);
    return result;
  }

  ServerStatus._();

  factory ServerStatus.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ServerStatus.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ServerStatus',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(
        1, _omitFieldNames ? '' : 'minPegInAmount', $pb.PbFieldType.Q6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        2, _omitFieldNames ? '' : 'minPegOutAmount', $pb.PbFieldType.Q6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aD(3, _omitFieldNames ? '' : 'serverFeePercentPegIn',
        fieldType: $pb.PbFieldType.QD)
    ..aD(4, _omitFieldNames ? '' : 'serverFeePercentPegOut',
        fieldType: $pb.PbFieldType.QD)
    ..pPM<FeeRate>(5, _omitFieldNames ? '' : 'bitcoinFeeRates',
        subBuilder: FeeRate.create);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServerStatus clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServerStatus copyWith(void Function(ServerStatus) updates) =>
      super.copyWith((message) => updates(message as ServerStatus))
          as ServerStatus;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServerStatus create() => ServerStatus._();
  @$core.override
  ServerStatus createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ServerStatus getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ServerStatus>(create);
  static ServerStatus? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get minPegInAmount => $_getI64(0);
  @$pb.TagNumber(1)
  set minPegInAmount($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMinPegInAmount() => $_has(0);
  @$pb.TagNumber(1)
  void clearMinPegInAmount() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get minPegOutAmount => $_getI64(1);
  @$pb.TagNumber(2)
  set minPegOutAmount($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMinPegOutAmount() => $_has(1);
  @$pb.TagNumber(2)
  void clearMinPegOutAmount() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get serverFeePercentPegIn => $_getN(2);
  @$pb.TagNumber(3)
  set serverFeePercentPegIn($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasServerFeePercentPegIn() => $_has(2);
  @$pb.TagNumber(3)
  void clearServerFeePercentPegIn() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get serverFeePercentPegOut => $_getN(3);
  @$pb.TagNumber(4)
  set serverFeePercentPegOut($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasServerFeePercentPegOut() => $_has(3);
  @$pb.TagNumber(4)
  void clearServerFeePercentPegOut() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<FeeRate> get bitcoinFeeRates => $_getList(4);
}

class OutPoint extends $pb.GeneratedMessage {
  factory OutPoint({
    $core.String? txid,
    $core.int? vout,
  }) {
    final result = create();
    if (txid != null) result.txid = txid;
    if (vout != null) result.vout = vout;
    return result;
  }

  OutPoint._();

  factory OutPoint.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OutPoint.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OutPoint',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'txid')
    ..aI(2, _omitFieldNames ? '' : 'vout', fieldType: $pb.PbFieldType.QU3);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OutPoint clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OutPoint copyWith(void Function(OutPoint) updates) =>
      super.copyWith((message) => updates(message as OutPoint)) as OutPoint;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OutPoint create() => OutPoint._();
  @$core.override
  OutPoint createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OutPoint getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OutPoint>(create);
  static OutPoint? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get txid => $_getSZ(0);
  @$pb.TagNumber(1)
  set txid($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTxid() => $_has(0);
  @$pb.TagNumber(1)
  void clearTxid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get vout => $_getIZ(1);
  @$pb.TagNumber(2)
  set vout($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVout() => $_has(1);
  @$pb.TagNumber(2)
  void clearVout() => $_clearField(2);
}

class CreateTx extends $pb.GeneratedMessage {
  factory CreateTx({
    $core.Iterable<AddressAmount>? addressees,
    $core.Iterable<OutPoint>? utxos,
    $core.String? feeAssetId,
    $core.int? deductFeeOutput,
  }) {
    final result = create();
    if (addressees != null) result.addressees.addAll(addressees);
    if (utxos != null) result.utxos.addAll(utxos);
    if (feeAssetId != null) result.feeAssetId = feeAssetId;
    if (deductFeeOutput != null) result.deductFeeOutput = deductFeeOutput;
    return result;
  }

  CreateTx._();

  factory CreateTx.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateTx.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateTx',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..pPM<AddressAmount>(1, _omitFieldNames ? '' : 'addressees',
        subBuilder: AddressAmount.create)
    ..pPM<OutPoint>(3, _omitFieldNames ? '' : 'utxos',
        subBuilder: OutPoint.create)
    ..aOS(4, _omitFieldNames ? '' : 'feeAssetId')
    ..aI(5, _omitFieldNames ? '' : 'deductFeeOutput',
        fieldType: $pb.PbFieldType.OU3);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateTx clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateTx copyWith(void Function(CreateTx) updates) =>
      super.copyWith((message) => updates(message as CreateTx)) as CreateTx;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateTx create() => CreateTx._();
  @$core.override
  CreateTx createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CreateTx getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateTx>(create);
  static CreateTx? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<AddressAmount> get addressees => $_getList(0);

  @$pb.TagNumber(3)
  $pb.PbList<OutPoint> get utxos => $_getList(1);

  @$pb.TagNumber(4)
  $core.String get feeAssetId => $_getSZ(2);
  @$pb.TagNumber(4)
  set feeAssetId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(4)
  $core.bool hasFeeAssetId() => $_has(2);
  @$pb.TagNumber(4)
  void clearFeeAssetId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get deductFeeOutput => $_getIZ(3);
  @$pb.TagNumber(5)
  set deductFeeOutput($core.int value) => $_setUnsignedInt32(3, value);
  @$pb.TagNumber(5)
  $core.bool hasDeductFeeOutput() => $_has(3);
  @$pb.TagNumber(5)
  void clearDeductFeeOutput() => $_clearField(5);
}

class CreatedTx extends $pb.GeneratedMessage {
  factory CreatedTx({
    CreateTx? req,
    $core.int? inputCount,
    $core.int? outputCount,
    $fixnum.Int64? size,
    $fixnum.Int64? networkFee,
    $core.double? feePerByte,
    $fixnum.Int64? vsize,
    $core.Iterable<AddressAmount>? addressees,
    $core.String? id,
    $fixnum.Int64? serverFee,
    $fixnum.Int64? discountVsize,
  }) {
    final result = create();
    if (req != null) result.req = req;
    if (inputCount != null) result.inputCount = inputCount;
    if (outputCount != null) result.outputCount = outputCount;
    if (size != null) result.size = size;
    if (networkFee != null) result.networkFee = networkFee;
    if (feePerByte != null) result.feePerByte = feePerByte;
    if (vsize != null) result.vsize = vsize;
    if (addressees != null) result.addressees.addAll(addressees);
    if (id != null) result.id = id;
    if (serverFee != null) result.serverFee = serverFee;
    if (discountVsize != null) result.discountVsize = discountVsize;
    return result;
  }

  CreatedTx._();

  factory CreatedTx.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreatedTx.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreatedTx',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..aQM<CreateTx>(1, _omitFieldNames ? '' : 'req',
        subBuilder: CreateTx.create)
    ..aI(2, _omitFieldNames ? '' : 'inputCount', fieldType: $pb.PbFieldType.Q3)
    ..aI(3, _omitFieldNames ? '' : 'outputCount', fieldType: $pb.PbFieldType.Q3)
    ..a<$fixnum.Int64>(4, _omitFieldNames ? '' : 'size', $pb.PbFieldType.Q6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        5, _omitFieldNames ? '' : 'networkFee', $pb.PbFieldType.Q6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aD(6, _omitFieldNames ? '' : 'feePerByte', fieldType: $pb.PbFieldType.QD)
    ..a<$fixnum.Int64>(7, _omitFieldNames ? '' : 'vsize', $pb.PbFieldType.Q6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..pPM<AddressAmount>(8, _omitFieldNames ? '' : 'addressees',
        subBuilder: AddressAmount.create)
    ..aQS(9, _omitFieldNames ? '' : 'id')
    ..aInt64(10, _omitFieldNames ? '' : 'serverFee')
    ..a<$fixnum.Int64>(
        11, _omitFieldNames ? '' : 'discountVsize', $pb.PbFieldType.Q6,
        defaultOrMaker: $fixnum.Int64.ZERO);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreatedTx clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreatedTx copyWith(void Function(CreatedTx) updates) =>
      super.copyWith((message) => updates(message as CreatedTx)) as CreatedTx;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreatedTx create() => CreatedTx._();
  @$core.override
  CreatedTx createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CreatedTx getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreatedTx>(create);
  static CreatedTx? _defaultInstance;

  @$pb.TagNumber(1)
  CreateTx get req => $_getN(0);
  @$pb.TagNumber(1)
  set req(CreateTx value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasReq() => $_has(0);
  @$pb.TagNumber(1)
  void clearReq() => $_clearField(1);
  @$pb.TagNumber(1)
  CreateTx ensureReq() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.int get inputCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set inputCount($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasInputCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearInputCount() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get outputCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set outputCount($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOutputCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearOutputCount() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get size => $_getI64(3);
  @$pb.TagNumber(4)
  set size($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSize() => $_has(3);
  @$pb.TagNumber(4)
  void clearSize() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get networkFee => $_getI64(4);
  @$pb.TagNumber(5)
  set networkFee($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasNetworkFee() => $_has(4);
  @$pb.TagNumber(5)
  void clearNetworkFee() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get feePerByte => $_getN(5);
  @$pb.TagNumber(6)
  set feePerByte($core.double value) => $_setDouble(5, value);
  @$pb.TagNumber(6)
  $core.bool hasFeePerByte() => $_has(5);
  @$pb.TagNumber(6)
  void clearFeePerByte() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get vsize => $_getI64(6);
  @$pb.TagNumber(7)
  set vsize($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasVsize() => $_has(6);
  @$pb.TagNumber(7)
  void clearVsize() => $_clearField(7);

  @$pb.TagNumber(8)
  $pb.PbList<AddressAmount> get addressees => $_getList(7);

  @$pb.TagNumber(9)
  $core.String get id => $_getSZ(8);
  @$pb.TagNumber(9)
  set id($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasId() => $_has(8);
  @$pb.TagNumber(9)
  void clearId() => $_clearField(9);

  @$pb.TagNumber(10)
  $fixnum.Int64 get serverFee => $_getI64(9);
  @$pb.TagNumber(10)
  set serverFee($fixnum.Int64 value) => $_setInt64(9, value);
  @$pb.TagNumber(10)
  $core.bool hasServerFee() => $_has(9);
  @$pb.TagNumber(10)
  void clearServerFee() => $_clearField(10);

  @$pb.TagNumber(11)
  $fixnum.Int64 get discountVsize => $_getI64(10);
  @$pb.TagNumber(11)
  set discountVsize($fixnum.Int64 value) => $_setInt64(10, value);
  @$pb.TagNumber(11)
  $core.bool hasDiscountVsize() => $_has(10);
  @$pb.TagNumber(11)
  void clearDiscountVsize() => $_clearField(11);
}

class ChartPoint extends $pb.GeneratedMessage {
  factory ChartPoint({
    $core.String? time,
    $core.double? open,
    $core.double? close,
    $core.double? high,
    $core.double? low,
    $core.double? volume,
  }) {
    final result = create();
    if (time != null) result.time = time;
    if (open != null) result.open = open;
    if (close != null) result.close = close;
    if (high != null) result.high = high;
    if (low != null) result.low = low;
    if (volume != null) result.volume = volume;
    return result;
  }

  ChartPoint._();

  factory ChartPoint.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChartPoint.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChartPoint',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'time')
    ..aD(2, _omitFieldNames ? '' : 'open', fieldType: $pb.PbFieldType.QD)
    ..aD(3, _omitFieldNames ? '' : 'close', fieldType: $pb.PbFieldType.QD)
    ..aD(4, _omitFieldNames ? '' : 'high', fieldType: $pb.PbFieldType.QD)
    ..aD(5, _omitFieldNames ? '' : 'low', fieldType: $pb.PbFieldType.QD)
    ..aD(6, _omitFieldNames ? '' : 'volume', fieldType: $pb.PbFieldType.QD);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChartPoint clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChartPoint copyWith(void Function(ChartPoint) updates) =>
      super.copyWith((message) => updates(message as ChartPoint)) as ChartPoint;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChartPoint create() => ChartPoint._();
  @$core.override
  ChartPoint createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChartPoint getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChartPoint>(create);
  static ChartPoint? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get time => $_getSZ(0);
  @$pb.TagNumber(1)
  set time($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTime() => $_has(0);
  @$pb.TagNumber(1)
  void clearTime() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get open => $_getN(1);
  @$pb.TagNumber(2)
  set open($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOpen() => $_has(1);
  @$pb.TagNumber(2)
  void clearOpen() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get close => $_getN(2);
  @$pb.TagNumber(3)
  set close($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasClose() => $_has(2);
  @$pb.TagNumber(3)
  void clearClose() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get high => $_getN(3);
  @$pb.TagNumber(4)
  set high($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasHigh() => $_has(3);
  @$pb.TagNumber(4)
  void clearHigh() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get low => $_getN(4);
  @$pb.TagNumber(5)
  set low($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasLow() => $_has(4);
  @$pb.TagNumber(5)
  void clearLow() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get volume => $_getN(5);
  @$pb.TagNumber(6)
  set volume($core.double value) => $_setDouble(5, value);
  @$pb.TagNumber(6)
  $core.bool hasVolume() => $_has(5);
  @$pb.TagNumber(6)
  void clearVolume() => $_clearField(6);
}

class AssetPair extends $pb.GeneratedMessage {
  factory AssetPair({
    $core.String? base,
    $core.String? quote,
  }) {
    final result = create();
    if (base != null) result.base = base;
    if (quote != null) result.quote = quote;
    return result;
  }

  AssetPair._();

  factory AssetPair.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AssetPair.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AssetPair',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'base')
    ..aQS(2, _omitFieldNames ? '' : 'quote');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AssetPair clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AssetPair copyWith(void Function(AssetPair) updates) =>
      super.copyWith((message) => updates(message as AssetPair)) as AssetPair;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AssetPair create() => AssetPair._();
  @$core.override
  AssetPair createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AssetPair getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AssetPair>(create);
  static AssetPair? _defaultInstance;

  /// Base asset id
  @$pb.TagNumber(1)
  $core.String get base => $_getSZ(0);
  @$pb.TagNumber(1)
  set base($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasBase() => $_has(0);
  @$pb.TagNumber(1)
  void clearBase() => $_clearField(1);

  /// Quote asset id
  @$pb.TagNumber(2)
  $core.String get quote => $_getSZ(1);
  @$pb.TagNumber(2)
  set quote($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasQuote() => $_has(1);
  @$pb.TagNumber(2)
  void clearQuote() => $_clearField(2);
}

class MarketInfo extends $pb.GeneratedMessage {
  factory MarketInfo({
    AssetPair? assetPair,
    AssetType? feeAsset,
    MarketType_? type,
  }) {
    final result = create();
    if (assetPair != null) result.assetPair = assetPair;
    if (feeAsset != null) result.feeAsset = feeAsset;
    if (type != null) result.type = type;
    return result;
  }

  MarketInfo._();

  factory MarketInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MarketInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MarketInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..aQM<AssetPair>(1, _omitFieldNames ? '' : 'assetPair',
        subBuilder: AssetPair.create)
    ..aE<AssetType>(2, _omitFieldNames ? '' : 'feeAsset',
        fieldType: $pb.PbFieldType.QE, enumValues: AssetType.values)
    ..aE<MarketType_>(3, _omitFieldNames ? '' : 'type',
        fieldType: $pb.PbFieldType.QE, enumValues: MarketType_.values);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarketInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarketInfo copyWith(void Function(MarketInfo) updates) =>
      super.copyWith((message) => updates(message as MarketInfo)) as MarketInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MarketInfo create() => MarketInfo._();
  @$core.override
  MarketInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MarketInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MarketInfo>(create);
  static MarketInfo? _defaultInstance;

  @$pb.TagNumber(1)
  AssetPair get assetPair => $_getN(0);
  @$pb.TagNumber(1)
  set assetPair(AssetPair value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAssetPair() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetPair() => $_clearField(1);
  @$pb.TagNumber(1)
  AssetPair ensureAssetPair() => $_ensure(0);

  @$pb.TagNumber(2)
  AssetType get feeAsset => $_getN(1);
  @$pb.TagNumber(2)
  set feeAsset(AssetType value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasFeeAsset() => $_has(1);
  @$pb.TagNumber(2)
  void clearFeeAsset() => $_clearField(2);

  @$pb.TagNumber(3)
  MarketType_ get type => $_getN(2);
  @$pb.TagNumber(3)
  set type(MarketType_ value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasType() => $_has(2);
  @$pb.TagNumber(3)
  void clearType() => $_clearField(3);
}

class OrderId extends $pb.GeneratedMessage {
  factory OrderId({
    $fixnum.Int64? id,
  }) {
    final result = create();
    if (id != null) result.id = id;
    return result;
  }

  OrderId._();

  factory OrderId.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OrderId.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OrderId',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.QU6,
        defaultOrMaker: $fixnum.Int64.ZERO);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderId clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderId copyWith(void Function(OrderId) updates) =>
      super.copyWith((message) => updates(message as OrderId)) as OrderId;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OrderId create() => OrderId._();
  @$core.override
  OrderId createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OrderId getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OrderId>(create);
  static OrderId? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class PublicOrder extends $pb.GeneratedMessage {
  factory PublicOrder({
    OrderId? orderId,
    AssetPair? assetPair,
    TradeDir? tradeDir,
    $fixnum.Int64? amount,
    $core.double? price,
    $core.bool? twoStep,
  }) {
    final result = create();
    if (orderId != null) result.orderId = orderId;
    if (assetPair != null) result.assetPair = assetPair;
    if (tradeDir != null) result.tradeDir = tradeDir;
    if (amount != null) result.amount = amount;
    if (price != null) result.price = price;
    if (twoStep != null) result.twoStep = twoStep;
    return result;
  }

  PublicOrder._();

  factory PublicOrder.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PublicOrder.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PublicOrder',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..aQM<OrderId>(1, _omitFieldNames ? '' : 'orderId',
        subBuilder: OrderId.create)
    ..aQM<AssetPair>(2, _omitFieldNames ? '' : 'assetPair',
        subBuilder: AssetPair.create)
    ..aE<TradeDir>(3, _omitFieldNames ? '' : 'tradeDir',
        fieldType: $pb.PbFieldType.QE, enumValues: TradeDir.values)
    ..a<$fixnum.Int64>(4, _omitFieldNames ? '' : 'amount', $pb.PbFieldType.QU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aD(5, _omitFieldNames ? '' : 'price', fieldType: $pb.PbFieldType.QD)
    ..a<$core.bool>(6, _omitFieldNames ? '' : 'twoStep', $pb.PbFieldType.QB);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PublicOrder clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PublicOrder copyWith(void Function(PublicOrder) updates) =>
      super.copyWith((message) => updates(message as PublicOrder))
          as PublicOrder;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PublicOrder create() => PublicOrder._();
  @$core.override
  PublicOrder createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PublicOrder getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PublicOrder>(create);
  static PublicOrder? _defaultInstance;

  @$pb.TagNumber(1)
  OrderId get orderId => $_getN(0);
  @$pb.TagNumber(1)
  set orderId(OrderId value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrderId() => $_clearField(1);
  @$pb.TagNumber(1)
  OrderId ensureOrderId() => $_ensure(0);

  @$pb.TagNumber(2)
  AssetPair get assetPair => $_getN(1);
  @$pb.TagNumber(2)
  set assetPair(AssetPair value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAssetPair() => $_has(1);
  @$pb.TagNumber(2)
  void clearAssetPair() => $_clearField(2);
  @$pb.TagNumber(2)
  AssetPair ensureAssetPair() => $_ensure(1);

  @$pb.TagNumber(3)
  TradeDir get tradeDir => $_getN(2);
  @$pb.TagNumber(3)
  set tradeDir(TradeDir value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasTradeDir() => $_has(2);
  @$pb.TagNumber(3)
  void clearTradeDir() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get amount => $_getI64(3);
  @$pb.TagNumber(4)
  set amount($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAmount() => $_has(3);
  @$pb.TagNumber(4)
  void clearAmount() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get price => $_getN(4);
  @$pb.TagNumber(5)
  set price($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPrice() => $_has(4);
  @$pb.TagNumber(5)
  void clearPrice() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get twoStep => $_getBF(5);
  @$pb.TagNumber(6)
  set twoStep($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTwoStep() => $_has(5);
  @$pb.TagNumber(6)
  void clearTwoStep() => $_clearField(6);
}

class OwnOrder extends $pb.GeneratedMessage {
  factory OwnOrder({
    OrderId? orderId,
    AssetPair? assetPair,
    TradeDir? tradeDir,
    $fixnum.Int64? origAmount,
    $fixnum.Int64? activeAmount,
    $core.double? price,
    $core.String? privateId,
    $fixnum.Int64? ttlSeconds,
    $core.bool? twoStep,
    $core.double? priceTracking,
  }) {
    final result = create();
    if (orderId != null) result.orderId = orderId;
    if (assetPair != null) result.assetPair = assetPair;
    if (tradeDir != null) result.tradeDir = tradeDir;
    if (origAmount != null) result.origAmount = origAmount;
    if (activeAmount != null) result.activeAmount = activeAmount;
    if (price != null) result.price = price;
    if (privateId != null) result.privateId = privateId;
    if (ttlSeconds != null) result.ttlSeconds = ttlSeconds;
    if (twoStep != null) result.twoStep = twoStep;
    if (priceTracking != null) result.priceTracking = priceTracking;
    return result;
  }

  OwnOrder._();

  factory OwnOrder.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OwnOrder.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OwnOrder',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..aQM<OrderId>(1, _omitFieldNames ? '' : 'orderId',
        subBuilder: OrderId.create)
    ..aQM<AssetPair>(2, _omitFieldNames ? '' : 'assetPair',
        subBuilder: AssetPair.create)
    ..aE<TradeDir>(3, _omitFieldNames ? '' : 'tradeDir',
        fieldType: $pb.PbFieldType.QE, enumValues: TradeDir.values)
    ..a<$fixnum.Int64>(
        4, _omitFieldNames ? '' : 'origAmount', $pb.PbFieldType.QU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        5, _omitFieldNames ? '' : 'activeAmount', $pb.PbFieldType.QU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aD(6, _omitFieldNames ? '' : 'price', fieldType: $pb.PbFieldType.QD)
    ..aOS(7, _omitFieldNames ? '' : 'privateId')
    ..a<$fixnum.Int64>(
        8, _omitFieldNames ? '' : 'ttlSeconds', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.bool>(9, _omitFieldNames ? '' : 'twoStep', $pb.PbFieldType.QB)
    ..aD(10, _omitFieldNames ? '' : 'priceTracking');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OwnOrder clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OwnOrder copyWith(void Function(OwnOrder) updates) =>
      super.copyWith((message) => updates(message as OwnOrder)) as OwnOrder;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OwnOrder create() => OwnOrder._();
  @$core.override
  OwnOrder createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OwnOrder getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OwnOrder>(create);
  static OwnOrder? _defaultInstance;

  @$pb.TagNumber(1)
  OrderId get orderId => $_getN(0);
  @$pb.TagNumber(1)
  set orderId(OrderId value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrderId() => $_clearField(1);
  @$pb.TagNumber(1)
  OrderId ensureOrderId() => $_ensure(0);

  @$pb.TagNumber(2)
  AssetPair get assetPair => $_getN(1);
  @$pb.TagNumber(2)
  set assetPair(AssetPair value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAssetPair() => $_has(1);
  @$pb.TagNumber(2)
  void clearAssetPair() => $_clearField(2);
  @$pb.TagNumber(2)
  AssetPair ensureAssetPair() => $_ensure(1);

  @$pb.TagNumber(3)
  TradeDir get tradeDir => $_getN(2);
  @$pb.TagNumber(3)
  set tradeDir(TradeDir value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasTradeDir() => $_has(2);
  @$pb.TagNumber(3)
  void clearTradeDir() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get origAmount => $_getI64(3);
  @$pb.TagNumber(4)
  set origAmount($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOrigAmount() => $_has(3);
  @$pb.TagNumber(4)
  void clearOrigAmount() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get activeAmount => $_getI64(4);
  @$pb.TagNumber(5)
  set activeAmount($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasActiveAmount() => $_has(4);
  @$pb.TagNumber(5)
  void clearActiveAmount() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get price => $_getN(5);
  @$pb.TagNumber(6)
  set price($core.double value) => $_setDouble(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPrice() => $_has(5);
  @$pb.TagNumber(6)
  void clearPrice() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get privateId => $_getSZ(6);
  @$pb.TagNumber(7)
  set privateId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasPrivateId() => $_has(6);
  @$pb.TagNumber(7)
  void clearPrivateId() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get ttlSeconds => $_getI64(7);
  @$pb.TagNumber(8)
  set ttlSeconds($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasTtlSeconds() => $_has(7);
  @$pb.TagNumber(8)
  void clearTtlSeconds() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get twoStep => $_getBF(8);
  @$pb.TagNumber(9)
  set twoStep($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasTwoStep() => $_has(8);
  @$pb.TagNumber(9)
  void clearTwoStep() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.double get priceTracking => $_getN(9);
  @$pb.TagNumber(10)
  set priceTracking($core.double value) => $_setDouble(9, value);
  @$pb.TagNumber(10)
  $core.bool hasPriceTracking() => $_has(9);
  @$pb.TagNumber(10)
  void clearPriceTracking() => $_clearField(10);
}

class HistoryOrder extends $pb.GeneratedMessage {
  factory HistoryOrder({
    $fixnum.Int64? id,
    OrderId? orderId,
    AssetPair? assetPair,
    TradeDir? tradeDir,
    $fixnum.Int64? baseAmount,
    $fixnum.Int64? quoteAmount,
    $core.double? price,
    HistStatus? status,
    $core.String? txid,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (orderId != null) result.orderId = orderId;
    if (assetPair != null) result.assetPair = assetPair;
    if (tradeDir != null) result.tradeDir = tradeDir;
    if (baseAmount != null) result.baseAmount = baseAmount;
    if (quoteAmount != null) result.quoteAmount = quoteAmount;
    if (price != null) result.price = price;
    if (status != null) result.status = status;
    if (txid != null) result.txid = txid;
    return result;
  }

  HistoryOrder._();

  factory HistoryOrder.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory HistoryOrder.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HistoryOrder',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.QU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aQM<OrderId>(2, _omitFieldNames ? '' : 'orderId',
        subBuilder: OrderId.create)
    ..aQM<AssetPair>(3, _omitFieldNames ? '' : 'assetPair',
        subBuilder: AssetPair.create)
    ..aE<TradeDir>(4, _omitFieldNames ? '' : 'tradeDir',
        fieldType: $pb.PbFieldType.QE, enumValues: TradeDir.values)
    ..a<$fixnum.Int64>(
        5, _omitFieldNames ? '' : 'baseAmount', $pb.PbFieldType.QU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        6, _omitFieldNames ? '' : 'quoteAmount', $pb.PbFieldType.QU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aD(7, _omitFieldNames ? '' : 'price', fieldType: $pb.PbFieldType.QD)
    ..aE<HistStatus>(8, _omitFieldNames ? '' : 'status',
        fieldType: $pb.PbFieldType.QE, enumValues: HistStatus.values)
    ..aOS(9, _omitFieldNames ? '' : 'txid');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HistoryOrder clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HistoryOrder copyWith(void Function(HistoryOrder) updates) =>
      super.copyWith((message) => updates(message as HistoryOrder))
          as HistoryOrder;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HistoryOrder create() => HistoryOrder._();
  @$core.override
  HistoryOrder createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static HistoryOrder getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HistoryOrder>(create);
  static HistoryOrder? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  OrderId get orderId => $_getN(1);
  @$pb.TagNumber(2)
  set orderId(OrderId value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasOrderId() => $_has(1);
  @$pb.TagNumber(2)
  void clearOrderId() => $_clearField(2);
  @$pb.TagNumber(2)
  OrderId ensureOrderId() => $_ensure(1);

  @$pb.TagNumber(3)
  AssetPair get assetPair => $_getN(2);
  @$pb.TagNumber(3)
  set assetPair(AssetPair value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasAssetPair() => $_has(2);
  @$pb.TagNumber(3)
  void clearAssetPair() => $_clearField(3);
  @$pb.TagNumber(3)
  AssetPair ensureAssetPair() => $_ensure(2);

  @$pb.TagNumber(4)
  TradeDir get tradeDir => $_getN(3);
  @$pb.TagNumber(4)
  set tradeDir(TradeDir value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasTradeDir() => $_has(3);
  @$pb.TagNumber(4)
  void clearTradeDir() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get baseAmount => $_getI64(4);
  @$pb.TagNumber(5)
  set baseAmount($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasBaseAmount() => $_has(4);
  @$pb.TagNumber(5)
  void clearBaseAmount() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get quoteAmount => $_getI64(5);
  @$pb.TagNumber(6)
  set quoteAmount($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasQuoteAmount() => $_has(5);
  @$pb.TagNumber(6)
  void clearQuoteAmount() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get price => $_getN(6);
  @$pb.TagNumber(7)
  set price($core.double value) => $_setDouble(6, value);
  @$pb.TagNumber(7)
  $core.bool hasPrice() => $_has(6);
  @$pb.TagNumber(7)
  void clearPrice() => $_clearField(7);

  @$pb.TagNumber(8)
  HistStatus get status => $_getN(7);
  @$pb.TagNumber(8)
  set status(HistStatus value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasStatus() => $_has(7);
  @$pb.TagNumber(8)
  void clearStatus() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get txid => $_getSZ(8);
  @$pb.TagNumber(9)
  set txid($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasTxid() => $_has(8);
  @$pb.TagNumber(9)
  void clearTxid() => $_clearField(9);
}

class Session extends $pb.GeneratedMessage {
  factory Session({
    $core.String? sessionId,
    $core.String? domain,
    $core.bool? isLocal,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    if (domain != null) result.domain = domain;
    if (isLocal != null) result.isLocal = isLocal;
    return result;
  }

  Session._();

  factory Session.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Session.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Session',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'sessionId')
    ..aQS(2, _omitFieldNames ? '' : 'domain')
    ..a<$core.bool>(3, _omitFieldNames ? '' : 'isLocal', $pb.PbFieldType.QB);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Session clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Session copyWith(void Function(Session) updates) =>
      super.copyWith((message) => updates(message as Session)) as Session;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Session create() => Session._();
  @$core.override
  Session createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Session getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Session>(create);
  static Session? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get domain => $_getSZ(1);
  @$pb.TagNumber(2)
  set domain($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDomain() => $_has(1);
  @$pb.TagNumber(2)
  void clearDomain() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get isLocal => $_getBF(2);
  @$pb.TagNumber(3)
  set isLocal($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIsLocal() => $_has(2);
  @$pb.TagNumber(3)
  void clearIsLocal() => $_clearField(3);
}

enum To_Login_Wallet { mnemonic, jadeId, notSet }

class To_Login extends $pb.GeneratedMessage {
  factory To_Login({
    $core.String? mnemonic,
    $core.String? phoneKey,
    $core.String? jadeId,
  }) {
    final result = create();
    if (mnemonic != null) result.mnemonic = mnemonic;
    if (phoneKey != null) result.phoneKey = phoneKey;
    if (jadeId != null) result.jadeId = jadeId;
    return result;
  }

  To_Login._();

  factory To_Login.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory To_Login.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, To_Login_Wallet> _To_Login_WalletByTag = {
    1: To_Login_Wallet.mnemonic,
    7: To_Login_Wallet.jadeId,
    0: To_Login_Wallet.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'To.Login',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..oo(0, [1, 7])
    ..aOS(1, _omitFieldNames ? '' : 'mnemonic')
    ..aOS(2, _omitFieldNames ? '' : 'phoneKey')
    ..aOS(7, _omitFieldNames ? '' : 'jadeId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  To_Login clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  To_Login copyWith(void Function(To_Login) updates) =>
      super.copyWith((message) => updates(message as To_Login)) as To_Login;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static To_Login create() => To_Login._();
  @$core.override
  To_Login createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static To_Login getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<To_Login>(create);
  static To_Login? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(7)
  To_Login_Wallet whichWallet() => _To_Login_WalletByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(7)
  void clearWallet() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get mnemonic => $_getSZ(0);
  @$pb.TagNumber(1)
  set mnemonic($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMnemonic() => $_has(0);
  @$pb.TagNumber(1)
  void clearMnemonic() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get phoneKey => $_getSZ(1);
  @$pb.TagNumber(2)
  set phoneKey($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPhoneKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearPhoneKey() => $_clearField(2);

  @$pb.TagNumber(7)
  $core.String get jadeId => $_getSZ(2);
  @$pb.TagNumber(7)
  set jadeId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(7)
  $core.bool hasJadeId() => $_has(2);
  @$pb.TagNumber(7)
  void clearJadeId() => $_clearField(7);
}

class To_NetworkSettings_Custom extends $pb.GeneratedMessage {
  factory To_NetworkSettings_Custom({
    $core.String? host,
    $core.int? port,
    $core.bool? useTls,
  }) {
    final result = create();
    if (host != null) result.host = host;
    if (port != null) result.port = port;
    if (useTls != null) result.useTls = useTls;
    return result;
  }

  To_NetworkSettings_Custom._();

  factory To_NetworkSettings_Custom.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory To_NetworkSettings_Custom.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'To.NetworkSettings.Custom',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'host')
    ..aI(2, _omitFieldNames ? '' : 'port', fieldType: $pb.PbFieldType.Q3)
    ..a<$core.bool>(3, _omitFieldNames ? '' : 'useTls', $pb.PbFieldType.QB);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  To_NetworkSettings_Custom clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  To_NetworkSettings_Custom copyWith(
          void Function(To_NetworkSettings_Custom) updates) =>
      super.copyWith((message) => updates(message as To_NetworkSettings_Custom))
          as To_NetworkSettings_Custom;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static To_NetworkSettings_Custom create() => To_NetworkSettings_Custom._();
  @$core.override
  To_NetworkSettings_Custom createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static To_NetworkSettings_Custom getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<To_NetworkSettings_Custom>(create);
  static To_NetworkSettings_Custom? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get host => $_getSZ(0);
  @$pb.TagNumber(1)
  set host($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasHost() => $_has(0);
  @$pb.TagNumber(1)
  void clearHost() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get port => $_getIZ(1);
  @$pb.TagNumber(2)
  set port($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPort() => $_has(1);
  @$pb.TagNumber(2)
  void clearPort() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get useTls => $_getBF(2);
  @$pb.TagNumber(3)
  set useTls($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUseTls() => $_has(2);
  @$pb.TagNumber(3)
  void clearUseTls() => $_clearField(3);
}

enum To_NetworkSettings_Selected {
  blockstream,
  sideswap,
  sideswapCn,
  custom,
  notSet
}

class To_NetworkSettings extends $pb.GeneratedMessage {
  factory To_NetworkSettings({
    Empty? blockstream,
    Empty? sideswap,
    Empty? sideswapCn,
    To_NetworkSettings_Custom? custom,
  }) {
    final result = create();
    if (blockstream != null) result.blockstream = blockstream;
    if (sideswap != null) result.sideswap = sideswap;
    if (sideswapCn != null) result.sideswapCn = sideswapCn;
    if (custom != null) result.custom = custom;
    return result;
  }

  To_NetworkSettings._();

  factory To_NetworkSettings.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory To_NetworkSettings.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, To_NetworkSettings_Selected>
      _To_NetworkSettings_SelectedByTag = {
    1: To_NetworkSettings_Selected.blockstream,
    2: To_NetworkSettings_Selected.sideswap,
    3: To_NetworkSettings_Selected.sideswapCn,
    4: To_NetworkSettings_Selected.custom,
    0: To_NetworkSettings_Selected.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'To.NetworkSettings',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4])
    ..aOM<Empty>(1, _omitFieldNames ? '' : 'blockstream',
        subBuilder: Empty.create)
    ..aOM<Empty>(2, _omitFieldNames ? '' : 'sideswap', subBuilder: Empty.create)
    ..aOM<Empty>(3, _omitFieldNames ? '' : 'sideswapCn',
        subBuilder: Empty.create)
    ..aOM<To_NetworkSettings_Custom>(4, _omitFieldNames ? '' : 'custom',
        subBuilder: To_NetworkSettings_Custom.create);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  To_NetworkSettings clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  To_NetworkSettings copyWith(void Function(To_NetworkSettings) updates) =>
      super.copyWith((message) => updates(message as To_NetworkSettings))
          as To_NetworkSettings;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static To_NetworkSettings create() => To_NetworkSettings._();
  @$core.override
  To_NetworkSettings createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static To_NetworkSettings getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<To_NetworkSettings>(create);
  static To_NetworkSettings? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  To_NetworkSettings_Selected whichSelected() =>
      _To_NetworkSettings_SelectedByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  void clearSelected() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  Empty get blockstream => $_getN(0);
  @$pb.TagNumber(1)
  set blockstream(Empty value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBlockstream() => $_has(0);
  @$pb.TagNumber(1)
  void clearBlockstream() => $_clearField(1);
  @$pb.TagNumber(1)
  Empty ensureBlockstream() => $_ensure(0);

  @$pb.TagNumber(2)
  Empty get sideswap => $_getN(1);
  @$pb.TagNumber(2)
  set sideswap(Empty value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasSideswap() => $_has(1);
  @$pb.TagNumber(2)
  void clearSideswap() => $_clearField(2);
  @$pb.TagNumber(2)
  Empty ensureSideswap() => $_ensure(1);

  @$pb.TagNumber(3)
  Empty get sideswapCn => $_getN(2);
  @$pb.TagNumber(3)
  set sideswapCn(Empty value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasSideswapCn() => $_has(2);
  @$pb.TagNumber(3)
  void clearSideswapCn() => $_clearField(3);
  @$pb.TagNumber(3)
  Empty ensureSideswapCn() => $_ensure(2);

  @$pb.TagNumber(4)
  To_NetworkSettings_Custom get custom => $_getN(3);
  @$pb.TagNumber(4)
  set custom(To_NetworkSettings_Custom value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasCustom() => $_has(3);
  @$pb.TagNumber(4)
  void clearCustom() => $_clearField(4);
  @$pb.TagNumber(4)
  To_NetworkSettings_Custom ensureCustom() => $_ensure(3);
}

class To_ProxySettings_Proxy extends $pb.GeneratedMessage {
  factory To_ProxySettings_Proxy({
    $core.String? host,
    $core.int? port,
  }) {
    final result = create();
    if (host != null) result.host = host;
    if (port != null) result.port = port;
    return result;
  }

  To_ProxySettings_Proxy._();

  factory To_ProxySettings_Proxy.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory To_ProxySettings_Proxy.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'To.ProxySettings.Proxy',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'host')
    ..aI(2, _omitFieldNames ? '' : 'port', fieldType: $pb.PbFieldType.Q3);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  To_ProxySettings_Proxy clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  To_ProxySettings_Proxy copyWith(
          void Function(To_ProxySettings_Proxy) updates) =>
      super.copyWith((message) => updates(message as To_ProxySettings_Proxy))
          as To_ProxySettings_Proxy;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static To_ProxySettings_Proxy create() => To_ProxySettings_Proxy._();
  @$core.override
  To_ProxySettings_Proxy createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static To_ProxySettings_Proxy getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<To_ProxySettings_Proxy>(create);
  static To_ProxySettings_Proxy? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get host => $_getSZ(0);
  @$pb.TagNumber(1)
  set host($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasHost() => $_has(0);
  @$pb.TagNumber(1)
  void clearHost() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get port => $_getIZ(1);
  @$pb.TagNumber(2)
  set port($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPort() => $_has(1);
  @$pb.TagNumber(2)
  void clearPort() => $_clearField(2);
}

class To_ProxySettings extends $pb.GeneratedMessage {
  factory To_ProxySettings({
    To_ProxySettings_Proxy? proxy,
  }) {
    final result = create();
    if (proxy != null) result.proxy = proxy;
    return result;
  }

  To_ProxySettings._();

  factory To_ProxySettings.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory To_ProxySettings.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'To.ProxySettings',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..aOM<To_ProxySettings_Proxy>(1, _omitFieldNames ? '' : 'proxy',
        subBuilder: To_ProxySettings_Proxy.create);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  To_ProxySettings clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  To_ProxySettings copyWith(void Function(To_ProxySettings) updates) =>
      super.copyWith((message) => updates(message as To_ProxySettings))
          as To_ProxySettings;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static To_ProxySettings create() => To_ProxySettings._();
  @$core.override
  To_ProxySettings createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static To_ProxySettings getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<To_ProxySettings>(create);
  static To_ProxySettings? _defaultInstance;

  @$pb.TagNumber(1)
  To_ProxySettings_Proxy get proxy => $_getN(0);
  @$pb.TagNumber(1)
  set proxy(To_ProxySettings_Proxy value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasProxy() => $_has(0);
  @$pb.TagNumber(1)
  void clearProxy() => $_clearField(1);
  @$pb.TagNumber(1)
  To_ProxySettings_Proxy ensureProxy() => $_ensure(0);
}

class To_EncryptPin extends $pb.GeneratedMessage {
  factory To_EncryptPin({
    $core.String? pin,
    $core.String? mnemonic,
  }) {
    final result = create();
    if (pin != null) result.pin = pin;
    if (mnemonic != null) result.mnemonic = mnemonic;
    return result;
  }

  To_EncryptPin._();

  factory To_EncryptPin.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory To_EncryptPin.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'To.EncryptPin',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'pin')
    ..aQS(2, _omitFieldNames ? '' : 'mnemonic');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  To_EncryptPin clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  To_EncryptPin copyWith(void Function(To_EncryptPin) updates) =>
      super.copyWith((message) => updates(message as To_EncryptPin))
          as To_EncryptPin;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static To_EncryptPin create() => To_EncryptPin._();
  @$core.override
  To_EncryptPin createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static To_EncryptPin getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<To_EncryptPin>(create);
  static To_EncryptPin? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get pin => $_getSZ(0);
  @$pb.TagNumber(1)
  set pin($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPin() => $_has(0);
  @$pb.TagNumber(1)
  void clearPin() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get mnemonic => $_getSZ(1);
  @$pb.TagNumber(2)
  set mnemonic($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMnemonic() => $_has(1);
  @$pb.TagNumber(2)
  void clearMnemonic() => $_clearField(2);
}

class To_DecryptPin extends $pb.GeneratedMessage {
  factory To_DecryptPin({
    $core.String? pin,
    $core.String? salt,
    $core.String? encryptedData,
    $core.String? pinIdentifier,
    $core.String? hmac,
  }) {
    final result = create();
    if (pin != null) result.pin = pin;
    if (salt != null) result.salt = salt;
    if (encryptedData != null) result.encryptedData = encryptedData;
    if (pinIdentifier != null) result.pinIdentifier = pinIdentifier;
    if (hmac != null) result.hmac = hmac;
    return result;
  }

  To_DecryptPin._();

  factory To_DecryptPin.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory To_DecryptPin.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'To.DecryptPin',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'pin')
    ..aQS(2, _omitFieldNames ? '' : 'salt')
    ..aQS(3, _omitFieldNames ? '' : 'encryptedData')
    ..aQS(4, _omitFieldNames ? '' : 'pinIdentifier')
    ..aOS(5, _omitFieldNames ? '' : 'hmac');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  To_DecryptPin clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  To_DecryptPin copyWith(void Function(To_DecryptPin) updates) =>
      super.copyWith((message) => updates(message as To_DecryptPin))
          as To_DecryptPin;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static To_DecryptPin create() => To_DecryptPin._();
  @$core.override
  To_DecryptPin createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static To_DecryptPin getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<To_DecryptPin>(create);
  static To_DecryptPin? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get pin => $_getSZ(0);
  @$pb.TagNumber(1)
  set pin($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPin() => $_has(0);
  @$pb.TagNumber(1)
  void clearPin() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get salt => $_getSZ(1);
  @$pb.TagNumber(2)
  set salt($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSalt() => $_has(1);
  @$pb.TagNumber(2)
  void clearSalt() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get encryptedData => $_getSZ(2);
  @$pb.TagNumber(3)
  set encryptedData($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEncryptedData() => $_has(2);
  @$pb.TagNumber(3)
  void clearEncryptedData() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get pinIdentifier => $_getSZ(3);
  @$pb.TagNumber(4)
  set pinIdentifier($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPinIdentifier() => $_has(3);
  @$pb.TagNumber(4)
  void clearPinIdentifier() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get hmac => $_getSZ(4);
  @$pb.TagNumber(5)
  set hmac($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasHmac() => $_has(4);
  @$pb.TagNumber(5)
  void clearHmac() => $_clearField(5);
}

class To_AppState extends $pb.GeneratedMessage {
  factory To_AppState({
    $core.bool? active,
  }) {
    final result = create();
    if (active != null) result.active = active;
    return result;
  }

  To_AppState._();

  factory To_AppState.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory To_AppState.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'To.AppState',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..a<$core.bool>(1, _omitFieldNames ? '' : 'active', $pb.PbFieldType.QB);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  To_AppState clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  To_AppState copyWith(void Function(To_AppState) updates) =>
      super.copyWith((message) => updates(message as To_AppState))
          as To_AppState;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static To_AppState create() => To_AppState._();
  @$core.override
  To_AppState createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static To_AppState getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<To_AppState>(create);
  static To_AppState? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get active => $_getBF(0);
  @$pb.TagNumber(1)
  set active($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasActive() => $_has(0);
  @$pb.TagNumber(1)
  void clearActive() => $_clearField(1);
}

class To_PegInRequest extends $pb.GeneratedMessage {
  factory To_PegInRequest() => create();

  To_PegInRequest._();

  factory To_PegInRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory To_PegInRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'To.PegInRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  To_PegInRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  To_PegInRequest copyWith(void Function(To_PegInRequest) updates) =>
      super.copyWith((message) => updates(message as To_PegInRequest))
          as To_PegInRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static To_PegInRequest create() => To_PegInRequest._();
  @$core.override
  To_PegInRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static To_PegInRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<To_PegInRequest>(create);
  static To_PegInRequest? _defaultInstance;
}

class To_PegOutAmount extends $pb.GeneratedMessage {
  factory To_PegOutAmount({
    $fixnum.Int64? amount,
    $core.bool? isSendEntered,
    $core.double? feeRate,
  }) {
    final result = create();
    if (amount != null) result.amount = amount;
    if (isSendEntered != null) result.isSendEntered = isSendEntered;
    if (feeRate != null) result.feeRate = feeRate;
    return result;
  }

  To_PegOutAmount._();

  factory To_PegOutAmount.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory To_PegOutAmount.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'To.PegOutAmount',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'amount', $pb.PbFieldType.Q6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.bool>(
        2, _omitFieldNames ? '' : 'isSendEntered', $pb.PbFieldType.QB)
    ..aD(3, _omitFieldNames ? '' : 'feeRate', fieldType: $pb.PbFieldType.QD);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  To_PegOutAmount clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  To_PegOutAmount copyWith(void Function(To_PegOutAmount) updates) =>
      super.copyWith((message) => updates(message as To_PegOutAmount))
          as To_PegOutAmount;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static To_PegOutAmount create() => To_PegOutAmount._();
  @$core.override
  To_PegOutAmount createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static To_PegOutAmount getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<To_PegOutAmount>(create);
  static To_PegOutAmount? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get amount => $_getI64(0);
  @$pb.TagNumber(1)
  set amount($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAmount() => $_has(0);
  @$pb.TagNumber(1)
  void clearAmount() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get isSendEntered => $_getBF(1);
  @$pb.TagNumber(2)
  set isSendEntered($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIsSendEntered() => $_has(1);
  @$pb.TagNumber(2)
  void clearIsSendEntered() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get feeRate => $_getN(2);
  @$pb.TagNumber(3)
  set feeRate($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFeeRate() => $_has(2);
  @$pb.TagNumber(3)
  void clearFeeRate() => $_clearField(3);
}

class To_PegOutRequest extends $pb.GeneratedMessage {
  factory To_PegOutRequest({
    $fixnum.Int64? sendAmount,
    $fixnum.Int64? recvAmount,
    $core.bool? isSendEntered,
    $core.double? feeRate,
    $core.String? recvAddr,
  }) {
    final result = create();
    if (sendAmount != null) result.sendAmount = sendAmount;
    if (recvAmount != null) result.recvAmount = recvAmount;
    if (isSendEntered != null) result.isSendEntered = isSendEntered;
    if (feeRate != null) result.feeRate = feeRate;
    if (recvAddr != null) result.recvAddr = recvAddr;
    return result;
  }

  To_PegOutRequest._();

  factory To_PegOutRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory To_PegOutRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'To.PegOutRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(
        1, _omitFieldNames ? '' : 'sendAmount', $pb.PbFieldType.Q6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        2, _omitFieldNames ? '' : 'recvAmount', $pb.PbFieldType.Q6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.bool>(
        4, _omitFieldNames ? '' : 'isSendEntered', $pb.PbFieldType.QB)
    ..aD(5, _omitFieldNames ? '' : 'feeRate', fieldType: $pb.PbFieldType.QD)
    ..aQS(6, _omitFieldNames ? '' : 'recvAddr');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  To_PegOutRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  To_PegOutRequest copyWith(void Function(To_PegOutRequest) updates) =>
      super.copyWith((message) => updates(message as To_PegOutRequest))
          as To_PegOutRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static To_PegOutRequest create() => To_PegOutRequest._();
  @$core.override
  To_PegOutRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static To_PegOutRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<To_PegOutRequest>(create);
  static To_PegOutRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get sendAmount => $_getI64(0);
  @$pb.TagNumber(1)
  set sendAmount($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSendAmount() => $_has(0);
  @$pb.TagNumber(1)
  void clearSendAmount() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get recvAmount => $_getI64(1);
  @$pb.TagNumber(2)
  set recvAmount($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRecvAmount() => $_has(1);
  @$pb.TagNumber(2)
  void clearRecvAmount() => $_clearField(2);

  @$pb.TagNumber(4)
  $core.bool get isSendEntered => $_getBF(2);
  @$pb.TagNumber(4)
  set isSendEntered($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(4)
  $core.bool hasIsSendEntered() => $_has(2);
  @$pb.TagNumber(4)
  void clearIsSendEntered() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get feeRate => $_getN(3);
  @$pb.TagNumber(5)
  set feeRate($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(5)
  $core.bool hasFeeRate() => $_has(3);
  @$pb.TagNumber(5)
  void clearFeeRate() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get recvAddr => $_getSZ(4);
  @$pb.TagNumber(6)
  set recvAddr($core.String value) => $_setString(4, value);
  @$pb.TagNumber(6)
  $core.bool hasRecvAddr() => $_has(4);
  @$pb.TagNumber(6)
  void clearRecvAddr() => $_clearField(6);
}

class To_PegEdit extends $pb.GeneratedMessage {
  factory To_PegEdit({
    $core.String? orderId,
    $core.double? feeRate,
  }) {
    final result = create();
    if (orderId != null) result.orderId = orderId;
    if (feeRate != null) result.feeRate = feeRate;
    return result;
  }

  To_PegEdit._();

  factory To_PegEdit.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory To_PegEdit.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'To.PegEdit',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'orderId')
    ..aD(2, _omitFieldNames ? '' : 'feeRate');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  To_PegEdit clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  To_PegEdit copyWith(void Function(To_PegEdit) updates) =>
      super.copyWith((message) => updates(message as To_PegEdit)) as To_PegEdit;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static To_PegEdit create() => To_PegEdit._();
  @$core.override
  To_PegEdit createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static To_PegEdit getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<To_PegEdit>(create);
  static To_PegEdit? _defaultInstance;

  /// order_id is from the UpdatedPegs message
  @$pb.TagNumber(1)
  $core.String get orderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set orderId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrderId() => $_clearField(1);

  /// If set, the peg-out fee rate will be changed
  @$pb.TagNumber(2)
  $core.double get feeRate => $_getN(1);
  @$pb.TagNumber(2)
  set feeRate($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFeeRate() => $_has(1);
  @$pb.TagNumber(2)
  void clearFeeRate() => $_clearField(2);
}

class To_SetMemo extends $pb.GeneratedMessage {
  factory To_SetMemo({
    Account? account,
    $core.String? txid,
    $core.String? memo,
  }) {
    final result = create();
    if (account != null) result.account = account;
    if (txid != null) result.txid = txid;
    if (memo != null) result.memo = memo;
    return result;
  }

  To_SetMemo._();

  factory To_SetMemo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory To_SetMemo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'To.SetMemo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..aE<Account>(1, _omitFieldNames ? '' : 'account',
        fieldType: $pb.PbFieldType.QE, enumValues: Account.values)
    ..aQS(2, _omitFieldNames ? '' : 'txid')
    ..aQS(3, _omitFieldNames ? '' : 'memo');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  To_SetMemo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  To_SetMemo copyWith(void Function(To_SetMemo) updates) =>
      super.copyWith((message) => updates(message as To_SetMemo)) as To_SetMemo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static To_SetMemo create() => To_SetMemo._();
  @$core.override
  To_SetMemo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static To_SetMemo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<To_SetMemo>(create);
  static To_SetMemo? _defaultInstance;

  @$pb.TagNumber(1)
  Account get account => $_getN(0);
  @$pb.TagNumber(1)
  set account(Account value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAccount() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccount() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get txid => $_getSZ(1);
  @$pb.TagNumber(2)
  set txid($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTxid() => $_has(1);
  @$pb.TagNumber(2)
  void clearTxid() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get memo => $_getSZ(2);
  @$pb.TagNumber(3)
  set memo($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMemo() => $_has(2);
  @$pb.TagNumber(3)
  void clearMemo() => $_clearField(3);
}

class To_SendTx extends $pb.GeneratedMessage {
  factory To_SendTx({
    $core.String? id,
  }) {
    final result = create();
    if (id != null) result.id = id;
    return result;
  }

  To_SendTx._();

  factory To_SendTx.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory To_SendTx.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'To.SendTx',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..aQS(2, _omitFieldNames ? '' : 'id');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  To_SendTx clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  To_SendTx copyWith(void Function(To_SendTx) updates) =>
      super.copyWith((message) => updates(message as To_SendTx)) as To_SendTx;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static To_SendTx create() => To_SendTx._();
  @$core.override
  To_SendTx createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static To_SendTx getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<To_SendTx>(create);
  static To_SendTx? _defaultInstance;

  @$pb.TagNumber(2)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(2)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(2)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(2)
  void clearId() => $_clearField(2);
}

class To_BlindedValues extends $pb.GeneratedMessage {
  factory To_BlindedValues({
    $core.String? txid,
  }) {
    final result = create();
    if (txid != null) result.txid = txid;
    return result;
  }

  To_BlindedValues._();

  factory To_BlindedValues.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory To_BlindedValues.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'To.BlindedValues',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'txid');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  To_BlindedValues clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  To_BlindedValues copyWith(void Function(To_BlindedValues) updates) =>
      super.copyWith((message) => updates(message as To_BlindedValues))
          as To_BlindedValues;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static To_BlindedValues create() => To_BlindedValues._();
  @$core.override
  To_BlindedValues createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static To_BlindedValues getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<To_BlindedValues>(create);
  static To_BlindedValues? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get txid => $_getSZ(0);
  @$pb.TagNumber(1)
  set txid($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTxid() => $_has(0);
  @$pb.TagNumber(1)
  void clearTxid() => $_clearField(1);
}

class To_ShowTransaction extends $pb.GeneratedMessage {
  factory To_ShowTransaction({
    $core.String? txid,
  }) {
    final result = create();
    if (txid != null) result.txid = txid;
    return result;
  }

  To_ShowTransaction._();

  factory To_ShowTransaction.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory To_ShowTransaction.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'To.ShowTransaction',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'txid')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  To_ShowTransaction clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  To_ShowTransaction copyWith(void Function(To_ShowTransaction) updates) =>
      super.copyWith((message) => updates(message as To_ShowTransaction))
          as To_ShowTransaction;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static To_ShowTransaction create() => To_ShowTransaction._();
  @$core.override
  To_ShowTransaction createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static To_ShowTransaction getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<To_ShowTransaction>(create);
  static To_ShowTransaction? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get txid => $_getSZ(0);
  @$pb.TagNumber(1)
  set txid($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTxid() => $_has(0);
  @$pb.TagNumber(1)
  void clearTxid() => $_clearField(1);
}

class To_UpdatePushToken extends $pb.GeneratedMessage {
  factory To_UpdatePushToken({
    $core.String? token,
  }) {
    final result = create();
    if (token != null) result.token = token;
    return result;
  }

  To_UpdatePushToken._();

  factory To_UpdatePushToken.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory To_UpdatePushToken.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'To.UpdatePushToken',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'token');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  To_UpdatePushToken clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  To_UpdatePushToken copyWith(void Function(To_UpdatePushToken) updates) =>
      super.copyWith((message) => updates(message as To_UpdatePushToken))
          as To_UpdatePushToken;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static To_UpdatePushToken create() => To_UpdatePushToken._();
  @$core.override
  To_UpdatePushToken createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static To_UpdatePushToken getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<To_UpdatePushToken>(create);
  static To_UpdatePushToken? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get token => $_getSZ(0);
  @$pb.TagNumber(1)
  set token($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearToken() => $_clearField(1);
}

class To_GaidStatus extends $pb.GeneratedMessage {
  factory To_GaidStatus({
    $core.String? gaid,
    $core.String? assetId,
  }) {
    final result = create();
    if (gaid != null) result.gaid = gaid;
    if (assetId != null) result.assetId = assetId;
    return result;
  }

  To_GaidStatus._();

  factory To_GaidStatus.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory To_GaidStatus.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'To.GaidStatus',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'gaid')
    ..aQS(2, _omitFieldNames ? '' : 'assetId');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  To_GaidStatus clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  To_GaidStatus copyWith(void Function(To_GaidStatus) updates) =>
      super.copyWith((message) => updates(message as To_GaidStatus))
          as To_GaidStatus;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static To_GaidStatus create() => To_GaidStatus._();
  @$core.override
  To_GaidStatus createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static To_GaidStatus getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<To_GaidStatus>(create);
  static To_GaidStatus? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get gaid => $_getSZ(0);
  @$pb.TagNumber(1)
  set gaid($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasGaid() => $_has(0);
  @$pb.TagNumber(1)
  void clearGaid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get assetId => $_getSZ(1);
  @$pb.TagNumber(2)
  set assetId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAssetId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAssetId() => $_clearField(2);
}

class To_OrderSubmit extends $pb.GeneratedMessage {
  factory To_OrderSubmit({
    AssetPair? assetPair,
    $fixnum.Int64? baseAmount,
    $core.double? price,
    TradeDir? tradeDir,
    $fixnum.Int64? ttlSeconds,
    $core.bool? twoStep,
    $core.bool? private,
    $core.double? priceTracking,
  }) {
    final result = create();
    if (assetPair != null) result.assetPair = assetPair;
    if (baseAmount != null) result.baseAmount = baseAmount;
    if (price != null) result.price = price;
    if (tradeDir != null) result.tradeDir = tradeDir;
    if (ttlSeconds != null) result.ttlSeconds = ttlSeconds;
    if (twoStep != null) result.twoStep = twoStep;
    if (private != null) result.private = private;
    if (priceTracking != null) result.priceTracking = priceTracking;
    return result;
  }

  To_OrderSubmit._();

  factory To_OrderSubmit.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory To_OrderSubmit.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'To.OrderSubmit',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..aQM<AssetPair>(1, _omitFieldNames ? '' : 'assetPair',
        subBuilder: AssetPair.create)
    ..a<$fixnum.Int64>(
        2, _omitFieldNames ? '' : 'baseAmount', $pb.PbFieldType.QU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aD(3, _omitFieldNames ? '' : 'price')
    ..aE<TradeDir>(4, _omitFieldNames ? '' : 'tradeDir',
        fieldType: $pb.PbFieldType.QE, enumValues: TradeDir.values)
    ..a<$fixnum.Int64>(
        5, _omitFieldNames ? '' : 'ttlSeconds', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.bool>(6, _omitFieldNames ? '' : 'twoStep', $pb.PbFieldType.QB)
    ..a<$core.bool>(8, _omitFieldNames ? '' : 'private', $pb.PbFieldType.QB)
    ..aD(9, _omitFieldNames ? '' : 'priceTracking');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  To_OrderSubmit clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  To_OrderSubmit copyWith(void Function(To_OrderSubmit) updates) =>
      super.copyWith((message) => updates(message as To_OrderSubmit))
          as To_OrderSubmit;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static To_OrderSubmit create() => To_OrderSubmit._();
  @$core.override
  To_OrderSubmit createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static To_OrderSubmit getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<To_OrderSubmit>(create);
  static To_OrderSubmit? _defaultInstance;

  @$pb.TagNumber(1)
  AssetPair get assetPair => $_getN(0);
  @$pb.TagNumber(1)
  set assetPair(AssetPair value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAssetPair() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetPair() => $_clearField(1);
  @$pb.TagNumber(1)
  AssetPair ensureAssetPair() => $_ensure(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get baseAmount => $_getI64(1);
  @$pb.TagNumber(2)
  set baseAmount($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBaseAmount() => $_has(1);
  @$pb.TagNumber(2)
  void clearBaseAmount() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get price => $_getN(2);
  @$pb.TagNumber(3)
  set price($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPrice() => $_has(2);
  @$pb.TagNumber(3)
  void clearPrice() => $_clearField(3);

  @$pb.TagNumber(4)
  TradeDir get tradeDir => $_getN(3);
  @$pb.TagNumber(4)
  set tradeDir(TradeDir value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasTradeDir() => $_has(3);
  @$pb.TagNumber(4)
  void clearTradeDir() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get ttlSeconds => $_getI64(4);
  @$pb.TagNumber(5)
  set ttlSeconds($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTtlSeconds() => $_has(4);
  @$pb.TagNumber(5)
  void clearTtlSeconds() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get twoStep => $_getBF(5);
  @$pb.TagNumber(6)
  set twoStep($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTwoStep() => $_has(5);
  @$pb.TagNumber(6)
  void clearTwoStep() => $_clearField(6);

  @$pb.TagNumber(8)
  $core.bool get private => $_getBF(6);
  @$pb.TagNumber(8)
  set private($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(8)
  $core.bool hasPrivate() => $_has(6);
  @$pb.TagNumber(8)
  void clearPrivate() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.double get priceTracking => $_getN(7);
  @$pb.TagNumber(9)
  set priceTracking($core.double value) => $_setDouble(7, value);
  @$pb.TagNumber(9)
  $core.bool hasPriceTracking() => $_has(7);
  @$pb.TagNumber(9)
  void clearPriceTracking() => $_clearField(9);
}

class To_OrderEdit extends $pb.GeneratedMessage {
  factory To_OrderEdit({
    OrderId? orderId,
    $fixnum.Int64? baseAmount,
    $core.double? price,
    $core.double? priceTracking,
  }) {
    final result = create();
    if (orderId != null) result.orderId = orderId;
    if (baseAmount != null) result.baseAmount = baseAmount;
    if (price != null) result.price = price;
    if (priceTracking != null) result.priceTracking = priceTracking;
    return result;
  }

  To_OrderEdit._();

  factory To_OrderEdit.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory To_OrderEdit.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'To.OrderEdit',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..aQM<OrderId>(1, _omitFieldNames ? '' : 'orderId',
        subBuilder: OrderId.create)
    ..a<$fixnum.Int64>(
        2, _omitFieldNames ? '' : 'baseAmount', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aD(3, _omitFieldNames ? '' : 'price')
    ..aD(4, _omitFieldNames ? '' : 'priceTracking');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  To_OrderEdit clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  To_OrderEdit copyWith(void Function(To_OrderEdit) updates) =>
      super.copyWith((message) => updates(message as To_OrderEdit))
          as To_OrderEdit;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static To_OrderEdit create() => To_OrderEdit._();
  @$core.override
  To_OrderEdit createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static To_OrderEdit getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<To_OrderEdit>(create);
  static To_OrderEdit? _defaultInstance;

  @$pb.TagNumber(1)
  OrderId get orderId => $_getN(0);
  @$pb.TagNumber(1)
  set orderId(OrderId value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrderId() => $_clearField(1);
  @$pb.TagNumber(1)
  OrderId ensureOrderId() => $_ensure(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get baseAmount => $_getI64(1);
  @$pb.TagNumber(2)
  set baseAmount($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBaseAmount() => $_has(1);
  @$pb.TagNumber(2)
  void clearBaseAmount() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get price => $_getN(2);
  @$pb.TagNumber(3)
  set price($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPrice() => $_has(2);
  @$pb.TagNumber(3)
  void clearPrice() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get priceTracking => $_getN(3);
  @$pb.TagNumber(4)
  set priceTracking($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPriceTracking() => $_has(3);
  @$pb.TagNumber(4)
  void clearPriceTracking() => $_clearField(4);
}

class To_OrderCancel extends $pb.GeneratedMessage {
  factory To_OrderCancel({
    OrderId? orderId,
  }) {
    final result = create();
    if (orderId != null) result.orderId = orderId;
    return result;
  }

  To_OrderCancel._();

  factory To_OrderCancel.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory To_OrderCancel.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'To.OrderCancel',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..aQM<OrderId>(1, _omitFieldNames ? '' : 'orderId',
        subBuilder: OrderId.create);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  To_OrderCancel clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  To_OrderCancel copyWith(void Function(To_OrderCancel) updates) =>
      super.copyWith((message) => updates(message as To_OrderCancel))
          as To_OrderCancel;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static To_OrderCancel create() => To_OrderCancel._();
  @$core.override
  To_OrderCancel createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static To_OrderCancel getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<To_OrderCancel>(create);
  static To_OrderCancel? _defaultInstance;

  @$pb.TagNumber(1)
  OrderId get orderId => $_getN(0);
  @$pb.TagNumber(1)
  set orderId(OrderId value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrderId() => $_clearField(1);
  @$pb.TagNumber(1)
  OrderId ensureOrderId() => $_ensure(0);
}

class To_StartQuotes extends $pb.GeneratedMessage {
  factory To_StartQuotes({
    AssetPair? assetPair,
    AssetType? assetType,
    $fixnum.Int64? amount,
    TradeDir? tradeDir,
    $core.bool? instantSwap,
    $fixnum.Int64? clientSubId,
  }) {
    final result = create();
    if (assetPair != null) result.assetPair = assetPair;
    if (assetType != null) result.assetType = assetType;
    if (amount != null) result.amount = amount;
    if (tradeDir != null) result.tradeDir = tradeDir;
    if (instantSwap != null) result.instantSwap = instantSwap;
    if (clientSubId != null) result.clientSubId = clientSubId;
    return result;
  }

  To_StartQuotes._();

  factory To_StartQuotes.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory To_StartQuotes.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'To.StartQuotes',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..aQM<AssetPair>(1, _omitFieldNames ? '' : 'assetPair',
        subBuilder: AssetPair.create)
    ..aE<AssetType>(2, _omitFieldNames ? '' : 'assetType',
        fieldType: $pb.PbFieldType.QE, enumValues: AssetType.values)
    ..a<$fixnum.Int64>(3, _omitFieldNames ? '' : 'amount', $pb.PbFieldType.QU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aE<TradeDir>(4, _omitFieldNames ? '' : 'tradeDir',
        fieldType: $pb.PbFieldType.QE, enumValues: TradeDir.values)
    ..a<$core.bool>(5, _omitFieldNames ? '' : 'instantSwap', $pb.PbFieldType.QB)
    ..aInt64(6, _omitFieldNames ? '' : 'clientSubId');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  To_StartQuotes clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  To_StartQuotes copyWith(void Function(To_StartQuotes) updates) =>
      super.copyWith((message) => updates(message as To_StartQuotes))
          as To_StartQuotes;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static To_StartQuotes create() => To_StartQuotes._();
  @$core.override
  To_StartQuotes createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static To_StartQuotes getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<To_StartQuotes>(create);
  static To_StartQuotes? _defaultInstance;

  @$pb.TagNumber(1)
  AssetPair get assetPair => $_getN(0);
  @$pb.TagNumber(1)
  set assetPair(AssetPair value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAssetPair() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetPair() => $_clearField(1);
  @$pb.TagNumber(1)
  AssetPair ensureAssetPair() => $_ensure(0);

  @$pb.TagNumber(2)
  AssetType get assetType => $_getN(1);
  @$pb.TagNumber(2)
  set assetType(AssetType value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAssetType() => $_has(1);
  @$pb.TagNumber(2)
  void clearAssetType() => $_clearField(2);

  /// Can be 0, if instant_swap is true.
  /// 0 can be used to load indicative buy and sell prices (the best price from the order book).
  @$pb.TagNumber(3)
  $fixnum.Int64 get amount => $_getI64(2);
  @$pb.TagNumber(3)
  set amount($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAmount() => $_has(2);
  @$pb.TagNumber(3)
  void clearAmount() => $_clearField(3);

  @$pb.TagNumber(4)
  TradeDir get tradeDir => $_getN(3);
  @$pb.TagNumber(4)
  set tradeDir(TradeDir value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasTradeDir() => $_has(3);
  @$pb.TagNumber(4)
  void clearTradeDir() => $_clearField(4);

  /// Set to true, if started from the Instant Swaps page
  @$pb.TagNumber(5)
  $core.bool get instantSwap => $_getBF(4);
  @$pb.TagNumber(5)
  set instantSwap($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasInstantSwap() => $_has(4);
  @$pb.TagNumber(5)
  void clearInstantSwap() => $_clearField(5);

  /// Optional client-generated ID that will later be returned with all received quotes
  @$pb.TagNumber(6)
  $fixnum.Int64 get clientSubId => $_getI64(5);
  @$pb.TagNumber(6)
  set clientSubId($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasClientSubId() => $_has(5);
  @$pb.TagNumber(6)
  void clearClientSubId() => $_clearField(6);
}

class To_StartOrder extends $pb.GeneratedMessage {
  factory To_StartOrder({
    $fixnum.Int64? orderId,
    $core.String? privateId,
  }) {
    final result = create();
    if (orderId != null) result.orderId = orderId;
    if (privateId != null) result.privateId = privateId;
    return result;
  }

  To_StartOrder._();

  factory To_StartOrder.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory To_StartOrder.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'To.StartOrder',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'orderId', $pb.PbFieldType.QU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(2, _omitFieldNames ? '' : 'privateId');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  To_StartOrder clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  To_StartOrder copyWith(void Function(To_StartOrder) updates) =>
      super.copyWith((message) => updates(message as To_StartOrder))
          as To_StartOrder;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static To_StartOrder create() => To_StartOrder._();
  @$core.override
  To_StartOrder createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static To_StartOrder getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<To_StartOrder>(create);
  static To_StartOrder? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get orderId => $_getI64(0);
  @$pb.TagNumber(1)
  set orderId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrderId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get privateId => $_getSZ(1);
  @$pb.TagNumber(2)
  set privateId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPrivateId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPrivateId() => $_clearField(2);
}

class To_AcceptQuote extends $pb.GeneratedMessage {
  factory To_AcceptQuote({
    $fixnum.Int64? quoteId,
  }) {
    final result = create();
    if (quoteId != null) result.quoteId = quoteId;
    return result;
  }

  To_AcceptQuote._();

  factory To_AcceptQuote.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory To_AcceptQuote.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'To.AcceptQuote',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'quoteId', $pb.PbFieldType.QU6,
        defaultOrMaker: $fixnum.Int64.ZERO);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  To_AcceptQuote clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  To_AcceptQuote copyWith(void Function(To_AcceptQuote) updates) =>
      super.copyWith((message) => updates(message as To_AcceptQuote))
          as To_AcceptQuote;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static To_AcceptQuote create() => To_AcceptQuote._();
  @$core.override
  To_AcceptQuote createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static To_AcceptQuote getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<To_AcceptQuote>(create);
  static To_AcceptQuote? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get quoteId => $_getI64(0);
  @$pb.TagNumber(1)
  set quoteId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasQuoteId() => $_has(0);
  @$pb.TagNumber(1)
  void clearQuoteId() => $_clearField(1);
}

class To_LoadHistory extends $pb.GeneratedMessage {
  factory To_LoadHistory({
    $fixnum.Int64? startTime,
    $fixnum.Int64? endTime,
    $core.int? skip,
    $core.int? count,
  }) {
    final result = create();
    if (startTime != null) result.startTime = startTime;
    if (endTime != null) result.endTime = endTime;
    if (skip != null) result.skip = skip;
    if (count != null) result.count = count;
    return result;
  }

  To_LoadHistory._();

  factory To_LoadHistory.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory To_LoadHistory.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'To.LoadHistory',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(
        1, _omitFieldNames ? '' : 'startTime', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'endTime', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aI(3, _omitFieldNames ? '' : 'skip', fieldType: $pb.PbFieldType.OU3)
    ..aI(4, _omitFieldNames ? '' : 'count', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  To_LoadHistory clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  To_LoadHistory copyWith(void Function(To_LoadHistory) updates) =>
      super.copyWith((message) => updates(message as To_LoadHistory))
          as To_LoadHistory;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static To_LoadHistory create() => To_LoadHistory._();
  @$core.override
  To_LoadHistory createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static To_LoadHistory getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<To_LoadHistory>(create);
  static To_LoadHistory? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get startTime => $_getI64(0);
  @$pb.TagNumber(1)
  set startTime($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStartTime() => $_has(0);
  @$pb.TagNumber(1)
  void clearStartTime() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get endTime => $_getI64(1);
  @$pb.TagNumber(2)
  set endTime($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEndTime() => $_has(1);
  @$pb.TagNumber(2)
  void clearEndTime() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get skip => $_getIZ(2);
  @$pb.TagNumber(3)
  set skip($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSkip() => $_has(2);
  @$pb.TagNumber(3)
  void clearSkip() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get count => $_getIZ(3);
  @$pb.TagNumber(4)
  set count($core.int value) => $_setUnsignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCount() => $_has(3);
  @$pb.TagNumber(4)
  void clearCount() => $_clearField(4);
}

class To_SignerResponse extends $pb.GeneratedMessage {
  factory To_SignerResponse({
    $core.String? reqId,
    $core.bool? accept,
  }) {
    final result = create();
    if (reqId != null) result.reqId = reqId;
    if (accept != null) result.accept = accept;
    return result;
  }

  To_SignerResponse._();

  factory To_SignerResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory To_SignerResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'To.SignerResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'reqId')
    ..a<$core.bool>(2, _omitFieldNames ? '' : 'accept', $pb.PbFieldType.QB);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  To_SignerResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  To_SignerResponse copyWith(void Function(To_SignerResponse) updates) =>
      super.copyWith((message) => updates(message as To_SignerResponse))
          as To_SignerResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static To_SignerResponse create() => To_SignerResponse._();
  @$core.override
  To_SignerResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static To_SignerResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<To_SignerResponse>(create);
  static To_SignerResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reqId => $_getSZ(0);
  @$pb.TagNumber(1)
  set reqId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReqId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReqId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get accept => $_getBF(1);
  @$pb.TagNumber(2)
  set accept($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAccept() => $_has(1);
  @$pb.TagNumber(2)
  void clearAccept() => $_clearField(2);
}

class To_AppLink extends $pb.GeneratedMessage {
  factory To_AppLink({
    $core.String? url,
  }) {
    final result = create();
    if (url != null) result.url = url;
    return result;
  }

  To_AppLink._();

  factory To_AppLink.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory To_AppLink.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'To.AppLink',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'url');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  To_AppLink clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  To_AppLink copyWith(void Function(To_AppLink) updates) =>
      super.copyWith((message) => updates(message as To_AppLink)) as To_AppLink;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static To_AppLink create() => To_AppLink._();
  @$core.override
  To_AppLink createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static To_AppLink getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<To_AppLink>(create);
  static To_AppLink? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get url => $_getSZ(0);
  @$pb.TagNumber(1)
  set url($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearUrl() => $_clearField(1);
}

class To_StopSession extends $pb.GeneratedMessage {
  factory To_StopSession({
    $core.String? sessionId,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    return result;
  }

  To_StopSession._();

  factory To_StopSession.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory To_StopSession.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'To.StopSession',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'sessionId');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  To_StopSession clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  To_StopSession copyWith(void Function(To_StopSession) updates) =>
      super.copyWith((message) => updates(message as To_StopSession))
          as To_StopSession;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static To_StopSession create() => To_StopSession._();
  @$core.override
  To_StopSession createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static To_StopSession getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<To_StopSession>(create);
  static To_StopSession? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);
}

enum To_Msg {
  login,
  logout,
  updatePushToken,
  encryptPin,
  decryptPin,
  pushMessage,
  proxySettings,
  appState,
  networkSettings,
  setMemo,
  getRecvAddress,
  createTx,
  sendTx,
  blindedValues,
  showTransaction,
  loadUtxos,
  loadAddresses,
  activePage,
  loadTransactions,
  pegInRequest,
  pegOutRequest,
  pegEdit,
  pegOutAmount,
  assetDetails,
  portfolioPrices,
  conversionRates,
  jadeRescan,
  jadeUnlock,
  jadeVerifyAddress,
  gaidStatus,
  appLink,
  marketSubscribe,
  marketUnsubscribe,
  orderSubmit,
  orderEdit,
  orderCancel,
  startQuotes,
  stopQuotes,
  acceptQuote,
  startOrder,
  chartsSubscribe,
  chartsUnsubscribe,
  loadHistory,
  signerResponse,
  stopSession,
  notSet
}

class To extends $pb.GeneratedMessage {
  factory To({
    To_Login? login,
    Empty? logout,
    To_UpdatePushToken? updatePushToken,
    To_EncryptPin? encryptPin,
    To_DecryptPin? decryptPin,
    $core.String? pushMessage,
    To_ProxySettings? proxySettings,
    To_AppState? appState,
    To_NetworkSettings? networkSettings,
    To_SetMemo? setMemo,
    Account? getRecvAddress,
    CreateTx? createTx,
    To_SendTx? sendTx,
    To_BlindedValues? blindedValues,
    To_ShowTransaction? showTransaction,
    Account? loadUtxos,
    Account? loadAddresses,
    ActivePage? activePage,
    Empty? loadTransactions,
    To_PegInRequest? pegInRequest,
    To_PegOutRequest? pegOutRequest,
    To_PegEdit? pegEdit,
    To_PegOutAmount? pegOutAmount,
    AssetId? assetDetails,
    Empty? portfolioPrices,
    Empty? conversionRates,
    Empty? jadeRescan,
    Empty? jadeUnlock,
    Address? jadeVerifyAddress,
    To_GaidStatus? gaidStatus,
    To_AppLink? appLink,
    AssetPair? marketSubscribe,
    Empty? marketUnsubscribe,
    To_OrderSubmit? orderSubmit,
    To_OrderEdit? orderEdit,
    To_OrderCancel? orderCancel,
    To_StartQuotes? startQuotes,
    Empty? stopQuotes,
    To_AcceptQuote? acceptQuote,
    To_StartOrder? startOrder,
    AssetPair? chartsSubscribe,
    Empty? chartsUnsubscribe,
    To_LoadHistory? loadHistory,
    To_SignerResponse? signerResponse,
    To_StopSession? stopSession,
  }) {
    final result = create();
    if (login != null) result.login = login;
    if (logout != null) result.logout = logout;
    if (updatePushToken != null) result.updatePushToken = updatePushToken;
    if (encryptPin != null) result.encryptPin = encryptPin;
    if (decryptPin != null) result.decryptPin = decryptPin;
    if (pushMessage != null) result.pushMessage = pushMessage;
    if (proxySettings != null) result.proxySettings = proxySettings;
    if (appState != null) result.appState = appState;
    if (networkSettings != null) result.networkSettings = networkSettings;
    if (setMemo != null) result.setMemo = setMemo;
    if (getRecvAddress != null) result.getRecvAddress = getRecvAddress;
    if (createTx != null) result.createTx = createTx;
    if (sendTx != null) result.sendTx = sendTx;
    if (blindedValues != null) result.blindedValues = blindedValues;
    if (showTransaction != null) result.showTransaction = showTransaction;
    if (loadUtxos != null) result.loadUtxos = loadUtxos;
    if (loadAddresses != null) result.loadAddresses = loadAddresses;
    if (activePage != null) result.activePage = activePage;
    if (loadTransactions != null) result.loadTransactions = loadTransactions;
    if (pegInRequest != null) result.pegInRequest = pegInRequest;
    if (pegOutRequest != null) result.pegOutRequest = pegOutRequest;
    if (pegEdit != null) result.pegEdit = pegEdit;
    if (pegOutAmount != null) result.pegOutAmount = pegOutAmount;
    if (assetDetails != null) result.assetDetails = assetDetails;
    if (portfolioPrices != null) result.portfolioPrices = portfolioPrices;
    if (conversionRates != null) result.conversionRates = conversionRates;
    if (jadeRescan != null) result.jadeRescan = jadeRescan;
    if (jadeUnlock != null) result.jadeUnlock = jadeUnlock;
    if (jadeVerifyAddress != null) result.jadeVerifyAddress = jadeVerifyAddress;
    if (gaidStatus != null) result.gaidStatus = gaidStatus;
    if (appLink != null) result.appLink = appLink;
    if (marketSubscribe != null) result.marketSubscribe = marketSubscribe;
    if (marketUnsubscribe != null) result.marketUnsubscribe = marketUnsubscribe;
    if (orderSubmit != null) result.orderSubmit = orderSubmit;
    if (orderEdit != null) result.orderEdit = orderEdit;
    if (orderCancel != null) result.orderCancel = orderCancel;
    if (startQuotes != null) result.startQuotes = startQuotes;
    if (stopQuotes != null) result.stopQuotes = stopQuotes;
    if (acceptQuote != null) result.acceptQuote = acceptQuote;
    if (startOrder != null) result.startOrder = startOrder;
    if (chartsSubscribe != null) result.chartsSubscribe = chartsSubscribe;
    if (chartsUnsubscribe != null) result.chartsUnsubscribe = chartsUnsubscribe;
    if (loadHistory != null) result.loadHistory = loadHistory;
    if (signerResponse != null) result.signerResponse = signerResponse;
    if (stopSession != null) result.stopSession = stopSession;
    return result;
  }

  To._();

  factory To.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory To.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, To_Msg> _To_MsgByTag = {
    1: To_Msg.login,
    2: To_Msg.logout,
    3: To_Msg.updatePushToken,
    4: To_Msg.encryptPin,
    5: To_Msg.decryptPin,
    6: To_Msg.pushMessage,
    7: To_Msg.proxySettings,
    8: To_Msg.appState,
    9: To_Msg.networkSettings,
    10: To_Msg.setMemo,
    11: To_Msg.getRecvAddress,
    12: To_Msg.createTx,
    13: To_Msg.sendTx,
    14: To_Msg.blindedValues,
    15: To_Msg.showTransaction,
    17: To_Msg.loadUtxos,
    18: To_Msg.loadAddresses,
    19: To_Msg.activePage,
    20: To_Msg.loadTransactions,
    21: To_Msg.pegInRequest,
    22: To_Msg.pegOutRequest,
    23: To_Msg.pegEdit,
    24: To_Msg.pegOutAmount,
    57: To_Msg.assetDetails,
    62: To_Msg.portfolioPrices,
    63: To_Msg.conversionRates,
    71: To_Msg.jadeRescan,
    72: To_Msg.jadeUnlock,
    73: To_Msg.jadeVerifyAddress,
    81: To_Msg.gaidStatus,
    90: To_Msg.appLink,
    100: To_Msg.marketSubscribe,
    101: To_Msg.marketUnsubscribe,
    102: To_Msg.orderSubmit,
    103: To_Msg.orderEdit,
    104: To_Msg.orderCancel,
    110: To_Msg.startQuotes,
    111: To_Msg.stopQuotes,
    112: To_Msg.acceptQuote,
    113: To_Msg.startOrder,
    120: To_Msg.chartsSubscribe,
    121: To_Msg.chartsUnsubscribe,
    130: To_Msg.loadHistory,
    140: To_Msg.signerResponse,
    150: To_Msg.stopSession,
    0: To_Msg.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'To',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..oo(0, [
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8,
      9,
      10,
      11,
      12,
      13,
      14,
      15,
      17,
      18,
      19,
      20,
      21,
      22,
      23,
      24,
      57,
      62,
      63,
      71,
      72,
      73,
      81,
      90,
      100,
      101,
      102,
      103,
      104,
      110,
      111,
      112,
      113,
      120,
      121,
      130,
      140,
      150
    ])
    ..aOM<To_Login>(1, _omitFieldNames ? '' : 'login',
        subBuilder: To_Login.create)
    ..aOM<Empty>(2, _omitFieldNames ? '' : 'logout', subBuilder: Empty.create)
    ..aOM<To_UpdatePushToken>(3, _omitFieldNames ? '' : 'updatePushToken',
        subBuilder: To_UpdatePushToken.create)
    ..aOM<To_EncryptPin>(4, _omitFieldNames ? '' : 'encryptPin',
        subBuilder: To_EncryptPin.create)
    ..aOM<To_DecryptPin>(5, _omitFieldNames ? '' : 'decryptPin',
        subBuilder: To_DecryptPin.create)
    ..aOS(6, _omitFieldNames ? '' : 'pushMessage')
    ..aOM<To_ProxySettings>(7, _omitFieldNames ? '' : 'proxySettings',
        subBuilder: To_ProxySettings.create)
    ..aOM<To_AppState>(8, _omitFieldNames ? '' : 'appState',
        subBuilder: To_AppState.create)
    ..aOM<To_NetworkSettings>(9, _omitFieldNames ? '' : 'networkSettings',
        subBuilder: To_NetworkSettings.create)
    ..aOM<To_SetMemo>(10, _omitFieldNames ? '' : 'setMemo',
        subBuilder: To_SetMemo.create)
    ..aE<Account>(11, _omitFieldNames ? '' : 'getRecvAddress',
        enumValues: Account.values)
    ..aOM<CreateTx>(12, _omitFieldNames ? '' : 'createTx',
        subBuilder: CreateTx.create)
    ..aOM<To_SendTx>(13, _omitFieldNames ? '' : 'sendTx',
        subBuilder: To_SendTx.create)
    ..aOM<To_BlindedValues>(14, _omitFieldNames ? '' : 'blindedValues',
        subBuilder: To_BlindedValues.create)
    ..aOM<To_ShowTransaction>(15, _omitFieldNames ? '' : 'showTransaction',
        subBuilder: To_ShowTransaction.create)
    ..aE<Account>(17, _omitFieldNames ? '' : 'loadUtxos',
        enumValues: Account.values)
    ..aE<Account>(18, _omitFieldNames ? '' : 'loadAddresses',
        enumValues: Account.values)
    ..aE<ActivePage>(19, _omitFieldNames ? '' : 'activePage',
        enumValues: ActivePage.values)
    ..aOM<Empty>(20, _omitFieldNames ? '' : 'loadTransactions',
        subBuilder: Empty.create)
    ..aOM<To_PegInRequest>(21, _omitFieldNames ? '' : 'pegInRequest',
        subBuilder: To_PegInRequest.create)
    ..aOM<To_PegOutRequest>(22, _omitFieldNames ? '' : 'pegOutRequest',
        subBuilder: To_PegOutRequest.create)
    ..aOM<To_PegEdit>(23, _omitFieldNames ? '' : 'pegEdit',
        subBuilder: To_PegEdit.create)
    ..aOM<To_PegOutAmount>(24, _omitFieldNames ? '' : 'pegOutAmount',
        subBuilder: To_PegOutAmount.create)
    ..aOM<AssetId>(57, _omitFieldNames ? '' : 'assetDetails',
        subBuilder: AssetId.create)
    ..aOM<Empty>(62, _omitFieldNames ? '' : 'portfolioPrices',
        subBuilder: Empty.create)
    ..aOM<Empty>(63, _omitFieldNames ? '' : 'conversionRates',
        subBuilder: Empty.create)
    ..aOM<Empty>(71, _omitFieldNames ? '' : 'jadeRescan',
        subBuilder: Empty.create)
    ..aOM<Empty>(72, _omitFieldNames ? '' : 'jadeUnlock',
        subBuilder: Empty.create)
    ..aOM<Address>(73, _omitFieldNames ? '' : 'jadeVerifyAddress',
        subBuilder: Address.create)
    ..aOM<To_GaidStatus>(81, _omitFieldNames ? '' : 'gaidStatus',
        subBuilder: To_GaidStatus.create)
    ..aOM<To_AppLink>(90, _omitFieldNames ? '' : 'appLink',
        subBuilder: To_AppLink.create)
    ..aOM<AssetPair>(100, _omitFieldNames ? '' : 'marketSubscribe',
        subBuilder: AssetPair.create)
    ..aOM<Empty>(101, _omitFieldNames ? '' : 'marketUnsubscribe',
        subBuilder: Empty.create)
    ..aOM<To_OrderSubmit>(102, _omitFieldNames ? '' : 'orderSubmit',
        subBuilder: To_OrderSubmit.create)
    ..aOM<To_OrderEdit>(103, _omitFieldNames ? '' : 'orderEdit',
        subBuilder: To_OrderEdit.create)
    ..aOM<To_OrderCancel>(104, _omitFieldNames ? '' : 'orderCancel',
        subBuilder: To_OrderCancel.create)
    ..aOM<To_StartQuotes>(110, _omitFieldNames ? '' : 'startQuotes',
        subBuilder: To_StartQuotes.create)
    ..aOM<Empty>(111, _omitFieldNames ? '' : 'stopQuotes',
        subBuilder: Empty.create)
    ..aOM<To_AcceptQuote>(112, _omitFieldNames ? '' : 'acceptQuote',
        subBuilder: To_AcceptQuote.create)
    ..aOM<To_StartOrder>(113, _omitFieldNames ? '' : 'startOrder',
        subBuilder: To_StartOrder.create)
    ..aOM<AssetPair>(120, _omitFieldNames ? '' : 'chartsSubscribe',
        subBuilder: AssetPair.create)
    ..aOM<Empty>(121, _omitFieldNames ? '' : 'chartsUnsubscribe',
        subBuilder: Empty.create)
    ..aOM<To_LoadHistory>(130, _omitFieldNames ? '' : 'loadHistory',
        subBuilder: To_LoadHistory.create)
    ..aOM<To_SignerResponse>(140, _omitFieldNames ? '' : 'signerResponse',
        subBuilder: To_SignerResponse.create)
    ..aOM<To_StopSession>(150, _omitFieldNames ? '' : 'stopSession',
        subBuilder: To_StopSession.create);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  To clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  To copyWith(void Function(To) updates) =>
      super.copyWith((message) => updates(message as To)) as To;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static To create() => To._();
  @$core.override
  To createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static To getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<To>(create);
  static To? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  @$pb.TagNumber(13)
  @$pb.TagNumber(14)
  @$pb.TagNumber(15)
  @$pb.TagNumber(17)
  @$pb.TagNumber(18)
  @$pb.TagNumber(19)
  @$pb.TagNumber(20)
  @$pb.TagNumber(21)
  @$pb.TagNumber(22)
  @$pb.TagNumber(23)
  @$pb.TagNumber(24)
  @$pb.TagNumber(57)
  @$pb.TagNumber(62)
  @$pb.TagNumber(63)
  @$pb.TagNumber(71)
  @$pb.TagNumber(72)
  @$pb.TagNumber(73)
  @$pb.TagNumber(81)
  @$pb.TagNumber(90)
  @$pb.TagNumber(100)
  @$pb.TagNumber(101)
  @$pb.TagNumber(102)
  @$pb.TagNumber(103)
  @$pb.TagNumber(104)
  @$pb.TagNumber(110)
  @$pb.TagNumber(111)
  @$pb.TagNumber(112)
  @$pb.TagNumber(113)
  @$pb.TagNumber(120)
  @$pb.TagNumber(121)
  @$pb.TagNumber(130)
  @$pb.TagNumber(140)
  @$pb.TagNumber(150)
  To_Msg whichMsg() => _To_MsgByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  @$pb.TagNumber(13)
  @$pb.TagNumber(14)
  @$pb.TagNumber(15)
  @$pb.TagNumber(17)
  @$pb.TagNumber(18)
  @$pb.TagNumber(19)
  @$pb.TagNumber(20)
  @$pb.TagNumber(21)
  @$pb.TagNumber(22)
  @$pb.TagNumber(23)
  @$pb.TagNumber(24)
  @$pb.TagNumber(57)
  @$pb.TagNumber(62)
  @$pb.TagNumber(63)
  @$pb.TagNumber(71)
  @$pb.TagNumber(72)
  @$pb.TagNumber(73)
  @$pb.TagNumber(81)
  @$pb.TagNumber(90)
  @$pb.TagNumber(100)
  @$pb.TagNumber(101)
  @$pb.TagNumber(102)
  @$pb.TagNumber(103)
  @$pb.TagNumber(104)
  @$pb.TagNumber(110)
  @$pb.TagNumber(111)
  @$pb.TagNumber(112)
  @$pb.TagNumber(113)
  @$pb.TagNumber(120)
  @$pb.TagNumber(121)
  @$pb.TagNumber(130)
  @$pb.TagNumber(140)
  @$pb.TagNumber(150)
  void clearMsg() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  To_Login get login => $_getN(0);
  @$pb.TagNumber(1)
  set login(To_Login value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasLogin() => $_has(0);
  @$pb.TagNumber(1)
  void clearLogin() => $_clearField(1);
  @$pb.TagNumber(1)
  To_Login ensureLogin() => $_ensure(0);

  @$pb.TagNumber(2)
  Empty get logout => $_getN(1);
  @$pb.TagNumber(2)
  set logout(Empty value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasLogout() => $_has(1);
  @$pb.TagNumber(2)
  void clearLogout() => $_clearField(2);
  @$pb.TagNumber(2)
  Empty ensureLogout() => $_ensure(1);

  @$pb.TagNumber(3)
  To_UpdatePushToken get updatePushToken => $_getN(2);
  @$pb.TagNumber(3)
  set updatePushToken(To_UpdatePushToken value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasUpdatePushToken() => $_has(2);
  @$pb.TagNumber(3)
  void clearUpdatePushToken() => $_clearField(3);
  @$pb.TagNumber(3)
  To_UpdatePushToken ensureUpdatePushToken() => $_ensure(2);

  @$pb.TagNumber(4)
  To_EncryptPin get encryptPin => $_getN(3);
  @$pb.TagNumber(4)
  set encryptPin(To_EncryptPin value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasEncryptPin() => $_has(3);
  @$pb.TagNumber(4)
  void clearEncryptPin() => $_clearField(4);
  @$pb.TagNumber(4)
  To_EncryptPin ensureEncryptPin() => $_ensure(3);

  @$pb.TagNumber(5)
  To_DecryptPin get decryptPin => $_getN(4);
  @$pb.TagNumber(5)
  set decryptPin(To_DecryptPin value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasDecryptPin() => $_has(4);
  @$pb.TagNumber(5)
  void clearDecryptPin() => $_clearField(5);
  @$pb.TagNumber(5)
  To_DecryptPin ensureDecryptPin() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.String get pushMessage => $_getSZ(5);
  @$pb.TagNumber(6)
  set pushMessage($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPushMessage() => $_has(5);
  @$pb.TagNumber(6)
  void clearPushMessage() => $_clearField(6);

  @$pb.TagNumber(7)
  To_ProxySettings get proxySettings => $_getN(6);
  @$pb.TagNumber(7)
  set proxySettings(To_ProxySettings value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasProxySettings() => $_has(6);
  @$pb.TagNumber(7)
  void clearProxySettings() => $_clearField(7);
  @$pb.TagNumber(7)
  To_ProxySettings ensureProxySettings() => $_ensure(6);

  @$pb.TagNumber(8)
  To_AppState get appState => $_getN(7);
  @$pb.TagNumber(8)
  set appState(To_AppState value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasAppState() => $_has(7);
  @$pb.TagNumber(8)
  void clearAppState() => $_clearField(8);
  @$pb.TagNumber(8)
  To_AppState ensureAppState() => $_ensure(7);

  @$pb.TagNumber(9)
  To_NetworkSettings get networkSettings => $_getN(8);
  @$pb.TagNumber(9)
  set networkSettings(To_NetworkSettings value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasNetworkSettings() => $_has(8);
  @$pb.TagNumber(9)
  void clearNetworkSettings() => $_clearField(9);
  @$pb.TagNumber(9)
  To_NetworkSettings ensureNetworkSettings() => $_ensure(8);

  @$pb.TagNumber(10)
  To_SetMemo get setMemo => $_getN(9);
  @$pb.TagNumber(10)
  set setMemo(To_SetMemo value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasSetMemo() => $_has(9);
  @$pb.TagNumber(10)
  void clearSetMemo() => $_clearField(10);
  @$pb.TagNumber(10)
  To_SetMemo ensureSetMemo() => $_ensure(9);

  @$pb.TagNumber(11)
  Account get getRecvAddress => $_getN(10);
  @$pb.TagNumber(11)
  set getRecvAddress(Account value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasGetRecvAddress() => $_has(10);
  @$pb.TagNumber(11)
  void clearGetRecvAddress() => $_clearField(11);

  @$pb.TagNumber(12)
  CreateTx get createTx => $_getN(11);
  @$pb.TagNumber(12)
  set createTx(CreateTx value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasCreateTx() => $_has(11);
  @$pb.TagNumber(12)
  void clearCreateTx() => $_clearField(12);
  @$pb.TagNumber(12)
  CreateTx ensureCreateTx() => $_ensure(11);

  @$pb.TagNumber(13)
  To_SendTx get sendTx => $_getN(12);
  @$pb.TagNumber(13)
  set sendTx(To_SendTx value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasSendTx() => $_has(12);
  @$pb.TagNumber(13)
  void clearSendTx() => $_clearField(13);
  @$pb.TagNumber(13)
  To_SendTx ensureSendTx() => $_ensure(12);

  @$pb.TagNumber(14)
  To_BlindedValues get blindedValues => $_getN(13);
  @$pb.TagNumber(14)
  set blindedValues(To_BlindedValues value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasBlindedValues() => $_has(13);
  @$pb.TagNumber(14)
  void clearBlindedValues() => $_clearField(14);
  @$pb.TagNumber(14)
  To_BlindedValues ensureBlindedValues() => $_ensure(13);

  @$pb.TagNumber(15)
  To_ShowTransaction get showTransaction => $_getN(14);
  @$pb.TagNumber(15)
  set showTransaction(To_ShowTransaction value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasShowTransaction() => $_has(14);
  @$pb.TagNumber(15)
  void clearShowTransaction() => $_clearField(15);
  @$pb.TagNumber(15)
  To_ShowTransaction ensureShowTransaction() => $_ensure(14);

  @$pb.TagNumber(17)
  Account get loadUtxos => $_getN(15);
  @$pb.TagNumber(17)
  set loadUtxos(Account value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasLoadUtxos() => $_has(15);
  @$pb.TagNumber(17)
  void clearLoadUtxos() => $_clearField(17);

  @$pb.TagNumber(18)
  Account get loadAddresses => $_getN(16);
  @$pb.TagNumber(18)
  set loadAddresses(Account value) => $_setField(18, value);
  @$pb.TagNumber(18)
  $core.bool hasLoadAddresses() => $_has(16);
  @$pb.TagNumber(18)
  void clearLoadAddresses() => $_clearField(18);

  @$pb.TagNumber(19)
  ActivePage get activePage => $_getN(17);
  @$pb.TagNumber(19)
  set activePage(ActivePage value) => $_setField(19, value);
  @$pb.TagNumber(19)
  $core.bool hasActivePage() => $_has(17);
  @$pb.TagNumber(19)
  void clearActivePage() => $_clearField(19);

  @$pb.TagNumber(20)
  Empty get loadTransactions => $_getN(18);
  @$pb.TagNumber(20)
  set loadTransactions(Empty value) => $_setField(20, value);
  @$pb.TagNumber(20)
  $core.bool hasLoadTransactions() => $_has(18);
  @$pb.TagNumber(20)
  void clearLoadTransactions() => $_clearField(20);
  @$pb.TagNumber(20)
  Empty ensureLoadTransactions() => $_ensure(18);

  @$pb.TagNumber(21)
  To_PegInRequest get pegInRequest => $_getN(19);
  @$pb.TagNumber(21)
  set pegInRequest(To_PegInRequest value) => $_setField(21, value);
  @$pb.TagNumber(21)
  $core.bool hasPegInRequest() => $_has(19);
  @$pb.TagNumber(21)
  void clearPegInRequest() => $_clearField(21);
  @$pb.TagNumber(21)
  To_PegInRequest ensurePegInRequest() => $_ensure(19);

  @$pb.TagNumber(22)
  To_PegOutRequest get pegOutRequest => $_getN(20);
  @$pb.TagNumber(22)
  set pegOutRequest(To_PegOutRequest value) => $_setField(22, value);
  @$pb.TagNumber(22)
  $core.bool hasPegOutRequest() => $_has(20);
  @$pb.TagNumber(22)
  void clearPegOutRequest() => $_clearField(22);
  @$pb.TagNumber(22)
  To_PegOutRequest ensurePegOutRequest() => $_ensure(20);

  @$pb.TagNumber(23)
  To_PegEdit get pegEdit => $_getN(21);
  @$pb.TagNumber(23)
  set pegEdit(To_PegEdit value) => $_setField(23, value);
  @$pb.TagNumber(23)
  $core.bool hasPegEdit() => $_has(21);
  @$pb.TagNumber(23)
  void clearPegEdit() => $_clearField(23);
  @$pb.TagNumber(23)
  To_PegEdit ensurePegEdit() => $_ensure(21);

  @$pb.TagNumber(24)
  To_PegOutAmount get pegOutAmount => $_getN(22);
  @$pb.TagNumber(24)
  set pegOutAmount(To_PegOutAmount value) => $_setField(24, value);
  @$pb.TagNumber(24)
  $core.bool hasPegOutAmount() => $_has(22);
  @$pb.TagNumber(24)
  void clearPegOutAmount() => $_clearField(24);
  @$pb.TagNumber(24)
  To_PegOutAmount ensurePegOutAmount() => $_ensure(22);

  @$pb.TagNumber(57)
  AssetId get assetDetails => $_getN(23);
  @$pb.TagNumber(57)
  set assetDetails(AssetId value) => $_setField(57, value);
  @$pb.TagNumber(57)
  $core.bool hasAssetDetails() => $_has(23);
  @$pb.TagNumber(57)
  void clearAssetDetails() => $_clearField(57);
  @$pb.TagNumber(57)
  AssetId ensureAssetDetails() => $_ensure(23);

  @$pb.TagNumber(62)
  Empty get portfolioPrices => $_getN(24);
  @$pb.TagNumber(62)
  set portfolioPrices(Empty value) => $_setField(62, value);
  @$pb.TagNumber(62)
  $core.bool hasPortfolioPrices() => $_has(24);
  @$pb.TagNumber(62)
  void clearPortfolioPrices() => $_clearField(62);
  @$pb.TagNumber(62)
  Empty ensurePortfolioPrices() => $_ensure(24);

  @$pb.TagNumber(63)
  Empty get conversionRates => $_getN(25);
  @$pb.TagNumber(63)
  set conversionRates(Empty value) => $_setField(63, value);
  @$pb.TagNumber(63)
  $core.bool hasConversionRates() => $_has(25);
  @$pb.TagNumber(63)
  void clearConversionRates() => $_clearField(63);
  @$pb.TagNumber(63)
  Empty ensureConversionRates() => $_ensure(25);

  @$pb.TagNumber(71)
  Empty get jadeRescan => $_getN(26);
  @$pb.TagNumber(71)
  set jadeRescan(Empty value) => $_setField(71, value);
  @$pb.TagNumber(71)
  $core.bool hasJadeRescan() => $_has(26);
  @$pb.TagNumber(71)
  void clearJadeRescan() => $_clearField(71);
  @$pb.TagNumber(71)
  Empty ensureJadeRescan() => $_ensure(26);

  @$pb.TagNumber(72)
  Empty get jadeUnlock => $_getN(27);
  @$pb.TagNumber(72)
  set jadeUnlock(Empty value) => $_setField(72, value);
  @$pb.TagNumber(72)
  $core.bool hasJadeUnlock() => $_has(27);
  @$pb.TagNumber(72)
  void clearJadeUnlock() => $_clearField(72);
  @$pb.TagNumber(72)
  Empty ensureJadeUnlock() => $_ensure(27);

  @$pb.TagNumber(73)
  Address get jadeVerifyAddress => $_getN(28);
  @$pb.TagNumber(73)
  set jadeVerifyAddress(Address value) => $_setField(73, value);
  @$pb.TagNumber(73)
  $core.bool hasJadeVerifyAddress() => $_has(28);
  @$pb.TagNumber(73)
  void clearJadeVerifyAddress() => $_clearField(73);
  @$pb.TagNumber(73)
  Address ensureJadeVerifyAddress() => $_ensure(28);

  @$pb.TagNumber(81)
  To_GaidStatus get gaidStatus => $_getN(29);
  @$pb.TagNumber(81)
  set gaidStatus(To_GaidStatus value) => $_setField(81, value);
  @$pb.TagNumber(81)
  $core.bool hasGaidStatus() => $_has(29);
  @$pb.TagNumber(81)
  void clearGaidStatus() => $_clearField(81);
  @$pb.TagNumber(81)
  To_GaidStatus ensureGaidStatus() => $_ensure(29);

  @$pb.TagNumber(90)
  To_AppLink get appLink => $_getN(30);
  @$pb.TagNumber(90)
  set appLink(To_AppLink value) => $_setField(90, value);
  @$pb.TagNumber(90)
  $core.bool hasAppLink() => $_has(30);
  @$pb.TagNumber(90)
  void clearAppLink() => $_clearField(90);
  @$pb.TagNumber(90)
  To_AppLink ensureAppLink() => $_ensure(30);

  @$pb.TagNumber(100)
  AssetPair get marketSubscribe => $_getN(31);
  @$pb.TagNumber(100)
  set marketSubscribe(AssetPair value) => $_setField(100, value);
  @$pb.TagNumber(100)
  $core.bool hasMarketSubscribe() => $_has(31);
  @$pb.TagNumber(100)
  void clearMarketSubscribe() => $_clearField(100);
  @$pb.TagNumber(100)
  AssetPair ensureMarketSubscribe() => $_ensure(31);

  @$pb.TagNumber(101)
  Empty get marketUnsubscribe => $_getN(32);
  @$pb.TagNumber(101)
  set marketUnsubscribe(Empty value) => $_setField(101, value);
  @$pb.TagNumber(101)
  $core.bool hasMarketUnsubscribe() => $_has(32);
  @$pb.TagNumber(101)
  void clearMarketUnsubscribe() => $_clearField(101);
  @$pb.TagNumber(101)
  Empty ensureMarketUnsubscribe() => $_ensure(32);

  @$pb.TagNumber(102)
  To_OrderSubmit get orderSubmit => $_getN(33);
  @$pb.TagNumber(102)
  set orderSubmit(To_OrderSubmit value) => $_setField(102, value);
  @$pb.TagNumber(102)
  $core.bool hasOrderSubmit() => $_has(33);
  @$pb.TagNumber(102)
  void clearOrderSubmit() => $_clearField(102);
  @$pb.TagNumber(102)
  To_OrderSubmit ensureOrderSubmit() => $_ensure(33);

  @$pb.TagNumber(103)
  To_OrderEdit get orderEdit => $_getN(34);
  @$pb.TagNumber(103)
  set orderEdit(To_OrderEdit value) => $_setField(103, value);
  @$pb.TagNumber(103)
  $core.bool hasOrderEdit() => $_has(34);
  @$pb.TagNumber(103)
  void clearOrderEdit() => $_clearField(103);
  @$pb.TagNumber(103)
  To_OrderEdit ensureOrderEdit() => $_ensure(34);

  @$pb.TagNumber(104)
  To_OrderCancel get orderCancel => $_getN(35);
  @$pb.TagNumber(104)
  set orderCancel(To_OrderCancel value) => $_setField(104, value);
  @$pb.TagNumber(104)
  $core.bool hasOrderCancel() => $_has(35);
  @$pb.TagNumber(104)
  void clearOrderCancel() => $_clearField(104);
  @$pb.TagNumber(104)
  To_OrderCancel ensureOrderCancel() => $_ensure(35);

  @$pb.TagNumber(110)
  To_StartQuotes get startQuotes => $_getN(36);
  @$pb.TagNumber(110)
  set startQuotes(To_StartQuotes value) => $_setField(110, value);
  @$pb.TagNumber(110)
  $core.bool hasStartQuotes() => $_has(36);
  @$pb.TagNumber(110)
  void clearStartQuotes() => $_clearField(110);
  @$pb.TagNumber(110)
  To_StartQuotes ensureStartQuotes() => $_ensure(36);

  @$pb.TagNumber(111)
  Empty get stopQuotes => $_getN(37);
  @$pb.TagNumber(111)
  set stopQuotes(Empty value) => $_setField(111, value);
  @$pb.TagNumber(111)
  $core.bool hasStopQuotes() => $_has(37);
  @$pb.TagNumber(111)
  void clearStopQuotes() => $_clearField(111);
  @$pb.TagNumber(111)
  Empty ensureStopQuotes() => $_ensure(37);

  @$pb.TagNumber(112)
  To_AcceptQuote get acceptQuote => $_getN(38);
  @$pb.TagNumber(112)
  set acceptQuote(To_AcceptQuote value) => $_setField(112, value);
  @$pb.TagNumber(112)
  $core.bool hasAcceptQuote() => $_has(38);
  @$pb.TagNumber(112)
  void clearAcceptQuote() => $_clearField(112);
  @$pb.TagNumber(112)
  To_AcceptQuote ensureAcceptQuote() => $_ensure(38);

  @$pb.TagNumber(113)
  To_StartOrder get startOrder => $_getN(39);
  @$pb.TagNumber(113)
  set startOrder(To_StartOrder value) => $_setField(113, value);
  @$pb.TagNumber(113)
  $core.bool hasStartOrder() => $_has(39);
  @$pb.TagNumber(113)
  void clearStartOrder() => $_clearField(113);
  @$pb.TagNumber(113)
  To_StartOrder ensureStartOrder() => $_ensure(39);

  @$pb.TagNumber(120)
  AssetPair get chartsSubscribe => $_getN(40);
  @$pb.TagNumber(120)
  set chartsSubscribe(AssetPair value) => $_setField(120, value);
  @$pb.TagNumber(120)
  $core.bool hasChartsSubscribe() => $_has(40);
  @$pb.TagNumber(120)
  void clearChartsSubscribe() => $_clearField(120);
  @$pb.TagNumber(120)
  AssetPair ensureChartsSubscribe() => $_ensure(40);

  @$pb.TagNumber(121)
  Empty get chartsUnsubscribe => $_getN(41);
  @$pb.TagNumber(121)
  set chartsUnsubscribe(Empty value) => $_setField(121, value);
  @$pb.TagNumber(121)
  $core.bool hasChartsUnsubscribe() => $_has(41);
  @$pb.TagNumber(121)
  void clearChartsUnsubscribe() => $_clearField(121);
  @$pb.TagNumber(121)
  Empty ensureChartsUnsubscribe() => $_ensure(41);

  @$pb.TagNumber(130)
  To_LoadHistory get loadHistory => $_getN(42);
  @$pb.TagNumber(130)
  set loadHistory(To_LoadHistory value) => $_setField(130, value);
  @$pb.TagNumber(130)
  $core.bool hasLoadHistory() => $_has(42);
  @$pb.TagNumber(130)
  void clearLoadHistory() => $_clearField(130);
  @$pb.TagNumber(130)
  To_LoadHistory ensureLoadHistory() => $_ensure(42);

  @$pb.TagNumber(140)
  To_SignerResponse get signerResponse => $_getN(43);
  @$pb.TagNumber(140)
  set signerResponse(To_SignerResponse value) => $_setField(140, value);
  @$pb.TagNumber(140)
  $core.bool hasSignerResponse() => $_has(43);
  @$pb.TagNumber(140)
  void clearSignerResponse() => $_clearField(140);
  @$pb.TagNumber(140)
  To_SignerResponse ensureSignerResponse() => $_ensure(43);

  @$pb.TagNumber(150)
  To_StopSession get stopSession => $_getN(44);
  @$pb.TagNumber(150)
  set stopSession(To_StopSession value) => $_setField(150, value);
  @$pb.TagNumber(150)
  $core.bool hasStopSession() => $_has(44);
  @$pb.TagNumber(150)
  void clearStopSession() => $_clearField(150);
  @$pb.TagNumber(150)
  To_StopSession ensureStopSession() => $_ensure(44);
}

class From_Login_LoginInfo extends $pb.GeneratedMessage {
  factory From_Login_LoginInfo({
    $core.String? nativeSegwitDescriptor,
    $core.String? nestedSegwitDescriptor,
  }) {
    final result = create();
    if (nativeSegwitDescriptor != null)
      result.nativeSegwitDescriptor = nativeSegwitDescriptor;
    if (nestedSegwitDescriptor != null)
      result.nestedSegwitDescriptor = nestedSegwitDescriptor;
    return result;
  }

  From_Login_LoginInfo._();

  factory From_Login_LoginInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory From_Login_LoginInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'From.Login.LoginInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'nativeSegwitDescriptor')
    ..aQS(2, _omitFieldNames ? '' : 'nestedSegwitDescriptor');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_Login_LoginInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_Login_LoginInfo copyWith(void Function(From_Login_LoginInfo) updates) =>
      super.copyWith((message) => updates(message as From_Login_LoginInfo))
          as From_Login_LoginInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_Login_LoginInfo create() => From_Login_LoginInfo._();
  @$core.override
  From_Login_LoginInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static From_Login_LoginInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<From_Login_LoginInfo>(create);
  static From_Login_LoginInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get nativeSegwitDescriptor => $_getSZ(0);
  @$pb.TagNumber(1)
  set nativeSegwitDescriptor($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNativeSegwitDescriptor() => $_has(0);
  @$pb.TagNumber(1)
  void clearNativeSegwitDescriptor() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get nestedSegwitDescriptor => $_getSZ(1);
  @$pb.TagNumber(2)
  set nestedSegwitDescriptor($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNestedSegwitDescriptor() => $_has(1);
  @$pb.TagNumber(2)
  void clearNestedSegwitDescriptor() => $_clearField(2);
}

enum From_Login_Result { errorMsg, success, notSet }

class From_Login extends $pb.GeneratedMessage {
  factory From_Login({
    $core.String? errorMsg,
    From_Login_LoginInfo? success,
  }) {
    final result = create();
    if (errorMsg != null) result.errorMsg = errorMsg;
    if (success != null) result.success = success;
    return result;
  }

  From_Login._();

  factory From_Login.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory From_Login.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, From_Login_Result> _From_Login_ResultByTag =
      {
    1: From_Login_Result.errorMsg,
    2: From_Login_Result.success,
    0: From_Login_Result.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'From.Login',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOS(1, _omitFieldNames ? '' : 'errorMsg')
    ..aOM<From_Login_LoginInfo>(2, _omitFieldNames ? '' : 'success',
        subBuilder: From_Login_LoginInfo.create);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_Login clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_Login copyWith(void Function(From_Login) updates) =>
      super.copyWith((message) => updates(message as From_Login)) as From_Login;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_Login create() => From_Login._();
  @$core.override
  From_Login createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static From_Login getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<From_Login>(create);
  static From_Login? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  From_Login_Result whichResult() => _From_Login_ResultByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  void clearResult() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get errorMsg => $_getSZ(0);
  @$pb.TagNumber(1)
  set errorMsg($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasErrorMsg() => $_has(0);
  @$pb.TagNumber(1)
  void clearErrorMsg() => $_clearField(1);

  @$pb.TagNumber(2)
  From_Login_LoginInfo get success => $_getN(1);
  @$pb.TagNumber(2)
  set success(From_Login_LoginInfo value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasSuccess() => $_has(1);
  @$pb.TagNumber(2)
  void clearSuccess() => $_clearField(2);
  @$pb.TagNumber(2)
  From_Login_LoginInfo ensureSuccess() => $_ensure(1);
}

class From_EnvSettings extends $pb.GeneratedMessage {
  factory From_EnvSettings({
    $core.String? policyAssetId,
    $core.String? usdtAssetId,
    $core.String? eurxAssetId,
  }) {
    final result = create();
    if (policyAssetId != null) result.policyAssetId = policyAssetId;
    if (usdtAssetId != null) result.usdtAssetId = usdtAssetId;
    if (eurxAssetId != null) result.eurxAssetId = eurxAssetId;
    return result;
  }

  From_EnvSettings._();

  factory From_EnvSettings.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory From_EnvSettings.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'From.EnvSettings',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'policyAssetId')
    ..aQS(2, _omitFieldNames ? '' : 'usdtAssetId')
    ..aQS(3, _omitFieldNames ? '' : 'eurxAssetId');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_EnvSettings clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_EnvSettings copyWith(void Function(From_EnvSettings) updates) =>
      super.copyWith((message) => updates(message as From_EnvSettings))
          as From_EnvSettings;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_EnvSettings create() => From_EnvSettings._();
  @$core.override
  From_EnvSettings createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static From_EnvSettings getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<From_EnvSettings>(create);
  static From_EnvSettings? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get policyAssetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set policyAssetId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPolicyAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPolicyAssetId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get usdtAssetId => $_getSZ(1);
  @$pb.TagNumber(2)
  set usdtAssetId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUsdtAssetId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUsdtAssetId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get eurxAssetId => $_getSZ(2);
  @$pb.TagNumber(3)
  set eurxAssetId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEurxAssetId() => $_has(2);
  @$pb.TagNumber(3)
  void clearEurxAssetId() => $_clearField(3);
}

class From_EncryptPin_Data extends $pb.GeneratedMessage {
  factory From_EncryptPin_Data({
    $core.String? salt,
    $core.String? encryptedData,
    $core.String? pinIdentifier,
    $core.String? hmac,
  }) {
    final result = create();
    if (salt != null) result.salt = salt;
    if (encryptedData != null) result.encryptedData = encryptedData;
    if (pinIdentifier != null) result.pinIdentifier = pinIdentifier;
    if (hmac != null) result.hmac = hmac;
    return result;
  }

  From_EncryptPin_Data._();

  factory From_EncryptPin_Data.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory From_EncryptPin_Data.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'From.EncryptPin.Data',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..aQS(2, _omitFieldNames ? '' : 'salt')
    ..aQS(3, _omitFieldNames ? '' : 'encryptedData')
    ..aQS(4, _omitFieldNames ? '' : 'pinIdentifier')
    ..aOS(5, _omitFieldNames ? '' : 'hmac');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_EncryptPin_Data clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_EncryptPin_Data copyWith(void Function(From_EncryptPin_Data) updates) =>
      super.copyWith((message) => updates(message as From_EncryptPin_Data))
          as From_EncryptPin_Data;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_EncryptPin_Data create() => From_EncryptPin_Data._();
  @$core.override
  From_EncryptPin_Data createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static From_EncryptPin_Data getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<From_EncryptPin_Data>(create);
  static From_EncryptPin_Data? _defaultInstance;

  @$pb.TagNumber(2)
  $core.String get salt => $_getSZ(0);
  @$pb.TagNumber(2)
  set salt($core.String value) => $_setString(0, value);
  @$pb.TagNumber(2)
  $core.bool hasSalt() => $_has(0);
  @$pb.TagNumber(2)
  void clearSalt() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get encryptedData => $_getSZ(1);
  @$pb.TagNumber(3)
  set encryptedData($core.String value) => $_setString(1, value);
  @$pb.TagNumber(3)
  $core.bool hasEncryptedData() => $_has(1);
  @$pb.TagNumber(3)
  void clearEncryptedData() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get pinIdentifier => $_getSZ(2);
  @$pb.TagNumber(4)
  set pinIdentifier($core.String value) => $_setString(2, value);
  @$pb.TagNumber(4)
  $core.bool hasPinIdentifier() => $_has(2);
  @$pb.TagNumber(4)
  void clearPinIdentifier() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get hmac => $_getSZ(3);
  @$pb.TagNumber(5)
  set hmac($core.String value) => $_setString(3, value);
  @$pb.TagNumber(5)
  $core.bool hasHmac() => $_has(3);
  @$pb.TagNumber(5)
  void clearHmac() => $_clearField(5);
}

enum From_EncryptPin_Result { error, data, notSet }

class From_EncryptPin extends $pb.GeneratedMessage {
  factory From_EncryptPin({
    $core.String? error,
    From_EncryptPin_Data? data,
  }) {
    final result = create();
    if (error != null) result.error = error;
    if (data != null) result.data = data;
    return result;
  }

  From_EncryptPin._();

  factory From_EncryptPin.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory From_EncryptPin.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, From_EncryptPin_Result>
      _From_EncryptPin_ResultByTag = {
    1: From_EncryptPin_Result.error,
    2: From_EncryptPin_Result.data,
    0: From_EncryptPin_Result.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'From.EncryptPin',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOS(1, _omitFieldNames ? '' : 'error')
    ..aOM<From_EncryptPin_Data>(2, _omitFieldNames ? '' : 'data',
        subBuilder: From_EncryptPin_Data.create);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_EncryptPin clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_EncryptPin copyWith(void Function(From_EncryptPin) updates) =>
      super.copyWith((message) => updates(message as From_EncryptPin))
          as From_EncryptPin;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_EncryptPin create() => From_EncryptPin._();
  @$core.override
  From_EncryptPin createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static From_EncryptPin getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<From_EncryptPin>(create);
  static From_EncryptPin? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  From_EncryptPin_Result whichResult() =>
      _From_EncryptPin_ResultByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  void clearResult() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get error => $_getSZ(0);
  @$pb.TagNumber(1)
  set error($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasError() => $_has(0);
  @$pb.TagNumber(1)
  void clearError() => $_clearField(1);

  @$pb.TagNumber(2)
  From_EncryptPin_Data get data => $_getN(1);
  @$pb.TagNumber(2)
  set data(From_EncryptPin_Data value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasData() => $_has(1);
  @$pb.TagNumber(2)
  void clearData() => $_clearField(2);
  @$pb.TagNumber(2)
  From_EncryptPin_Data ensureData() => $_ensure(1);
}

class From_DecryptPin_Error extends $pb.GeneratedMessage {
  factory From_DecryptPin_Error({
    $core.String? errorMsg,
    From_DecryptPin_ErrorCode? errorCode,
  }) {
    final result = create();
    if (errorMsg != null) result.errorMsg = errorMsg;
    if (errorCode != null) result.errorCode = errorCode;
    return result;
  }

  From_DecryptPin_Error._();

  factory From_DecryptPin_Error.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory From_DecryptPin_Error.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'From.DecryptPin.Error',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'errorMsg')
    ..aE<From_DecryptPin_ErrorCode>(2, _omitFieldNames ? '' : 'errorCode',
        fieldType: $pb.PbFieldType.QE,
        enumValues: From_DecryptPin_ErrorCode.values);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_DecryptPin_Error clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_DecryptPin_Error copyWith(
          void Function(From_DecryptPin_Error) updates) =>
      super.copyWith((message) => updates(message as From_DecryptPin_Error))
          as From_DecryptPin_Error;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_DecryptPin_Error create() => From_DecryptPin_Error._();
  @$core.override
  From_DecryptPin_Error createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static From_DecryptPin_Error getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<From_DecryptPin_Error>(create);
  static From_DecryptPin_Error? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get errorMsg => $_getSZ(0);
  @$pb.TagNumber(1)
  set errorMsg($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasErrorMsg() => $_has(0);
  @$pb.TagNumber(1)
  void clearErrorMsg() => $_clearField(1);

  @$pb.TagNumber(2)
  From_DecryptPin_ErrorCode get errorCode => $_getN(1);
  @$pb.TagNumber(2)
  set errorCode(From_DecryptPin_ErrorCode value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasErrorCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearErrorCode() => $_clearField(2);
}

enum From_DecryptPin_Result { error, mnemonic, notSet }

class From_DecryptPin extends $pb.GeneratedMessage {
  factory From_DecryptPin({
    From_DecryptPin_Error? error,
    $core.String? mnemonic,
  }) {
    final result = create();
    if (error != null) result.error = error;
    if (mnemonic != null) result.mnemonic = mnemonic;
    return result;
  }

  From_DecryptPin._();

  factory From_DecryptPin.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory From_DecryptPin.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, From_DecryptPin_Result>
      _From_DecryptPin_ResultByTag = {
    1: From_DecryptPin_Result.error,
    2: From_DecryptPin_Result.mnemonic,
    0: From_DecryptPin_Result.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'From.DecryptPin',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOM<From_DecryptPin_Error>(1, _omitFieldNames ? '' : 'error',
        subBuilder: From_DecryptPin_Error.create)
    ..aOS(2, _omitFieldNames ? '' : 'mnemonic');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_DecryptPin clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_DecryptPin copyWith(void Function(From_DecryptPin) updates) =>
      super.copyWith((message) => updates(message as From_DecryptPin))
          as From_DecryptPin;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_DecryptPin create() => From_DecryptPin._();
  @$core.override
  From_DecryptPin createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static From_DecryptPin getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<From_DecryptPin>(create);
  static From_DecryptPin? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  From_DecryptPin_Result whichResult() =>
      _From_DecryptPin_ResultByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  void clearResult() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  From_DecryptPin_Error get error => $_getN(0);
  @$pb.TagNumber(1)
  set error(From_DecryptPin_Error value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasError() => $_has(0);
  @$pb.TagNumber(1)
  void clearError() => $_clearField(1);
  @$pb.TagNumber(1)
  From_DecryptPin_Error ensureError() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get mnemonic => $_getSZ(1);
  @$pb.TagNumber(2)
  set mnemonic($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMnemonic() => $_has(1);
  @$pb.TagNumber(2)
  void clearMnemonic() => $_clearField(2);
}

enum From_RegisterAmp_Result { ampId, errorMsg, notSet }

class From_RegisterAmp extends $pb.GeneratedMessage {
  factory From_RegisterAmp({
    $core.String? ampId,
    $core.String? errorMsg,
  }) {
    final result = create();
    if (ampId != null) result.ampId = ampId;
    if (errorMsg != null) result.errorMsg = errorMsg;
    return result;
  }

  From_RegisterAmp._();

  factory From_RegisterAmp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory From_RegisterAmp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, From_RegisterAmp_Result>
      _From_RegisterAmp_ResultByTag = {
    1: From_RegisterAmp_Result.ampId,
    2: From_RegisterAmp_Result.errorMsg,
    0: From_RegisterAmp_Result.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'From.RegisterAmp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOS(1, _omitFieldNames ? '' : 'ampId')
    ..aOS(2, _omitFieldNames ? '' : 'errorMsg')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_RegisterAmp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_RegisterAmp copyWith(void Function(From_RegisterAmp) updates) =>
      super.copyWith((message) => updates(message as From_RegisterAmp))
          as From_RegisterAmp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_RegisterAmp create() => From_RegisterAmp._();
  @$core.override
  From_RegisterAmp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static From_RegisterAmp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<From_RegisterAmp>(create);
  static From_RegisterAmp? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  From_RegisterAmp_Result whichResult() =>
      _From_RegisterAmp_ResultByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  void clearResult() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get ampId => $_getSZ(0);
  @$pb.TagNumber(1)
  set ampId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAmpId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAmpId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get errorMsg => $_getSZ(1);
  @$pb.TagNumber(2)
  set errorMsg($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasErrorMsg() => $_has(1);
  @$pb.TagNumber(2)
  void clearErrorMsg() => $_clearField(2);
}

class From_AmpAssets extends $pb.GeneratedMessage {
  factory From_AmpAssets({
    $core.Iterable<$core.String>? assets,
  }) {
    final result = create();
    if (assets != null) result.assets.addAll(assets);
    return result;
  }

  From_AmpAssets._();

  factory From_AmpAssets.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory From_AmpAssets.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'From.AmpAssets',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'assets')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_AmpAssets clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_AmpAssets copyWith(void Function(From_AmpAssets) updates) =>
      super.copyWith((message) => updates(message as From_AmpAssets))
          as From_AmpAssets;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_AmpAssets create() => From_AmpAssets._();
  @$core.override
  From_AmpAssets createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static From_AmpAssets getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<From_AmpAssets>(create);
  static From_AmpAssets? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get assets => $_getList(0);
}

class From_UpdatedTxs extends $pb.GeneratedMessage {
  factory From_UpdatedTxs({
    $core.Iterable<TransItem>? items,
  }) {
    final result = create();
    if (items != null) result.items.addAll(items);
    return result;
  }

  From_UpdatedTxs._();

  factory From_UpdatedTxs.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory From_UpdatedTxs.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'From.UpdatedTxs',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..pPM<TransItem>(1, _omitFieldNames ? '' : 'items',
        subBuilder: TransItem.create);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_UpdatedTxs clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_UpdatedTxs copyWith(void Function(From_UpdatedTxs) updates) =>
      super.copyWith((message) => updates(message as From_UpdatedTxs))
          as From_UpdatedTxs;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_UpdatedTxs create() => From_UpdatedTxs._();
  @$core.override
  From_UpdatedTxs createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static From_UpdatedTxs getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<From_UpdatedTxs>(create);
  static From_UpdatedTxs? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<TransItem> get items => $_getList(0);
}

class From_RemovedTxs extends $pb.GeneratedMessage {
  factory From_RemovedTxs({
    $core.Iterable<$core.String>? txids,
  }) {
    final result = create();
    if (txids != null) result.txids.addAll(txids);
    return result;
  }

  From_RemovedTxs._();

  factory From_RemovedTxs.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory From_RemovedTxs.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'From.RemovedTxs',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'txids')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_RemovedTxs clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_RemovedTxs copyWith(void Function(From_RemovedTxs) updates) =>
      super.copyWith((message) => updates(message as From_RemovedTxs))
          as From_RemovedTxs;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_RemovedTxs create() => From_RemovedTxs._();
  @$core.override
  From_RemovedTxs createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static From_RemovedTxs getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<From_RemovedTxs>(create);
  static From_RemovedTxs? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get txids => $_getList(0);
}

class From_UpdatedPegs extends $pb.GeneratedMessage {
  factory From_UpdatedPegs({
    $core.String? orderId,
    $core.Iterable<TransItem>? items,
    $core.double? feeRate,
    $fixnum.Int64? bitcoinNetworkFee,
  }) {
    final result = create();
    if (orderId != null) result.orderId = orderId;
    if (items != null) result.items.addAll(items);
    if (feeRate != null) result.feeRate = feeRate;
    if (bitcoinNetworkFee != null) result.bitcoinNetworkFee = bitcoinNetworkFee;
    return result;
  }

  From_UpdatedPegs._();

  factory From_UpdatedPegs.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory From_UpdatedPegs.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'From.UpdatedPegs',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'orderId')
    ..pPM<TransItem>(2, _omitFieldNames ? '' : 'items',
        subBuilder: TransItem.create)
    ..aD(3, _omitFieldNames ? '' : 'feeRate')
    ..a<$fixnum.Int64>(
        4, _omitFieldNames ? '' : 'bitcoinNetworkFee', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_UpdatedPegs clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_UpdatedPegs copyWith(void Function(From_UpdatedPegs) updates) =>
      super.copyWith((message) => updates(message as From_UpdatedPegs))
          as From_UpdatedPegs;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_UpdatedPegs create() => From_UpdatedPegs._();
  @$core.override
  From_UpdatedPegs createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static From_UpdatedPegs getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<From_UpdatedPegs>(create);
  static From_UpdatedPegs? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get orderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set orderId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrderId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<TransItem> get items => $_getList(1);

  @$pb.TagNumber(3)
  $core.double get feeRate => $_getN(2);
  @$pb.TagNumber(3)
  set feeRate($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFeeRate() => $_has(2);
  @$pb.TagNumber(3)
  void clearFeeRate() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get bitcoinNetworkFee => $_getI64(3);
  @$pb.TagNumber(4)
  set bitcoinNetworkFee($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasBitcoinNetworkFee() => $_has(3);
  @$pb.TagNumber(4)
  void clearBitcoinNetworkFee() => $_clearField(4);
}

class From_BalanceUpdate extends $pb.GeneratedMessage {
  factory From_BalanceUpdate({
    Account? account,
    $core.Iterable<Balance>? balances,
  }) {
    final result = create();
    if (account != null) result.account = account;
    if (balances != null) result.balances.addAll(balances);
    return result;
  }

  From_BalanceUpdate._();

  factory From_BalanceUpdate.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory From_BalanceUpdate.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'From.BalanceUpdate',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..aE<Account>(1, _omitFieldNames ? '' : 'account',
        fieldType: $pb.PbFieldType.QE, enumValues: Account.values)
    ..pPM<Balance>(2, _omitFieldNames ? '' : 'balances',
        subBuilder: Balance.create);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_BalanceUpdate clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_BalanceUpdate copyWith(void Function(From_BalanceUpdate) updates) =>
      super.copyWith((message) => updates(message as From_BalanceUpdate))
          as From_BalanceUpdate;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_BalanceUpdate create() => From_BalanceUpdate._();
  @$core.override
  From_BalanceUpdate createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static From_BalanceUpdate getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<From_BalanceUpdate>(create);
  static From_BalanceUpdate? _defaultInstance;

  @$pb.TagNumber(1)
  Account get account => $_getN(0);
  @$pb.TagNumber(1)
  set account(Account value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAccount() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccount() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<Balance> get balances => $_getList(1);
}

class From_PeginWaitTx extends $pb.GeneratedMessage {
  factory From_PeginWaitTx({
    $core.String? orderId,
    $core.String? pegAddr,
    $core.String? recvAddr,
  }) {
    final result = create();
    if (orderId != null) result.orderId = orderId;
    if (pegAddr != null) result.pegAddr = pegAddr;
    if (recvAddr != null) result.recvAddr = recvAddr;
    return result;
  }

  From_PeginWaitTx._();

  factory From_PeginWaitTx.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory From_PeginWaitTx.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'From.PeginWaitTx',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'orderId')
    ..aQS(5, _omitFieldNames ? '' : 'pegAddr')
    ..aQS(6, _omitFieldNames ? '' : 'recvAddr');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_PeginWaitTx clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_PeginWaitTx copyWith(void Function(From_PeginWaitTx) updates) =>
      super.copyWith((message) => updates(message as From_PeginWaitTx))
          as From_PeginWaitTx;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_PeginWaitTx create() => From_PeginWaitTx._();
  @$core.override
  From_PeginWaitTx createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static From_PeginWaitTx getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<From_PeginWaitTx>(create);
  static From_PeginWaitTx? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get orderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set orderId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrderId() => $_clearField(1);

  @$pb.TagNumber(5)
  $core.String get pegAddr => $_getSZ(1);
  @$pb.TagNumber(5)
  set pegAddr($core.String value) => $_setString(1, value);
  @$pb.TagNumber(5)
  $core.bool hasPegAddr() => $_has(1);
  @$pb.TagNumber(5)
  void clearPegAddr() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get recvAddr => $_getSZ(2);
  @$pb.TagNumber(6)
  set recvAddr($core.String value) => $_setString(2, value);
  @$pb.TagNumber(6)
  $core.bool hasRecvAddr() => $_has(2);
  @$pb.TagNumber(6)
  void clearRecvAddr() => $_clearField(6);
}

class From_PegOutAmount_Amounts extends $pb.GeneratedMessage {
  factory From_PegOutAmount_Amounts({
    $fixnum.Int64? sendAmount,
    $fixnum.Int64? recvAmount,
    $core.bool? isSendEntered,
    $core.double? feeRate,
  }) {
    final result = create();
    if (sendAmount != null) result.sendAmount = sendAmount;
    if (recvAmount != null) result.recvAmount = recvAmount;
    if (isSendEntered != null) result.isSendEntered = isSendEntered;
    if (feeRate != null) result.feeRate = feeRate;
    return result;
  }

  From_PegOutAmount_Amounts._();

  factory From_PegOutAmount_Amounts.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory From_PegOutAmount_Amounts.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'From.PegOutAmount.Amounts',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(
        1, _omitFieldNames ? '' : 'sendAmount', $pb.PbFieldType.Q6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        2, _omitFieldNames ? '' : 'recvAmount', $pb.PbFieldType.Q6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.bool>(
        4, _omitFieldNames ? '' : 'isSendEntered', $pb.PbFieldType.QB)
    ..aD(5, _omitFieldNames ? '' : 'feeRate', fieldType: $pb.PbFieldType.QD);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_PegOutAmount_Amounts clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_PegOutAmount_Amounts copyWith(
          void Function(From_PegOutAmount_Amounts) updates) =>
      super.copyWith((message) => updates(message as From_PegOutAmount_Amounts))
          as From_PegOutAmount_Amounts;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_PegOutAmount_Amounts create() => From_PegOutAmount_Amounts._();
  @$core.override
  From_PegOutAmount_Amounts createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static From_PegOutAmount_Amounts getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<From_PegOutAmount_Amounts>(create);
  static From_PegOutAmount_Amounts? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get sendAmount => $_getI64(0);
  @$pb.TagNumber(1)
  set sendAmount($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSendAmount() => $_has(0);
  @$pb.TagNumber(1)
  void clearSendAmount() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get recvAmount => $_getI64(1);
  @$pb.TagNumber(2)
  set recvAmount($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRecvAmount() => $_has(1);
  @$pb.TagNumber(2)
  void clearRecvAmount() => $_clearField(2);

  @$pb.TagNumber(4)
  $core.bool get isSendEntered => $_getBF(2);
  @$pb.TagNumber(4)
  set isSendEntered($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(4)
  $core.bool hasIsSendEntered() => $_has(2);
  @$pb.TagNumber(4)
  void clearIsSendEntered() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get feeRate => $_getN(3);
  @$pb.TagNumber(5)
  set feeRate($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(5)
  $core.bool hasFeeRate() => $_has(3);
  @$pb.TagNumber(5)
  void clearFeeRate() => $_clearField(5);
}

enum From_PegOutAmount_Result { errorMsg, amounts, notSet }

class From_PegOutAmount extends $pb.GeneratedMessage {
  factory From_PegOutAmount({
    $core.String? errorMsg,
    From_PegOutAmount_Amounts? amounts,
  }) {
    final result = create();
    if (errorMsg != null) result.errorMsg = errorMsg;
    if (amounts != null) result.amounts = amounts;
    return result;
  }

  From_PegOutAmount._();

  factory From_PegOutAmount.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory From_PegOutAmount.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, From_PegOutAmount_Result>
      _From_PegOutAmount_ResultByTag = {
    1: From_PegOutAmount_Result.errorMsg,
    2: From_PegOutAmount_Result.amounts,
    0: From_PegOutAmount_Result.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'From.PegOutAmount',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOS(1, _omitFieldNames ? '' : 'errorMsg')
    ..aOM<From_PegOutAmount_Amounts>(2, _omitFieldNames ? '' : 'amounts',
        subBuilder: From_PegOutAmount_Amounts.create);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_PegOutAmount clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_PegOutAmount copyWith(void Function(From_PegOutAmount) updates) =>
      super.copyWith((message) => updates(message as From_PegOutAmount))
          as From_PegOutAmount;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_PegOutAmount create() => From_PegOutAmount._();
  @$core.override
  From_PegOutAmount createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static From_PegOutAmount getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<From_PegOutAmount>(create);
  static From_PegOutAmount? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  From_PegOutAmount_Result whichResult() =>
      _From_PegOutAmount_ResultByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  void clearResult() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get errorMsg => $_getSZ(0);
  @$pb.TagNumber(1)
  set errorMsg($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasErrorMsg() => $_has(0);
  @$pb.TagNumber(1)
  void clearErrorMsg() => $_clearField(1);

  @$pb.TagNumber(2)
  From_PegOutAmount_Amounts get amounts => $_getN(1);
  @$pb.TagNumber(2)
  set amounts(From_PegOutAmount_Amounts value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAmounts() => $_has(1);
  @$pb.TagNumber(2)
  void clearAmounts() => $_clearField(2);
  @$pb.TagNumber(2)
  From_PegOutAmount_Amounts ensureAmounts() => $_ensure(1);
}

class From_RecvAddress extends $pb.GeneratedMessage {
  factory From_RecvAddress({
    Address? addr,
    Account? account,
  }) {
    final result = create();
    if (addr != null) result.addr = addr;
    if (account != null) result.account = account;
    return result;
  }

  From_RecvAddress._();

  factory From_RecvAddress.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory From_RecvAddress.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'From.RecvAddress',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..aQM<Address>(1, _omitFieldNames ? '' : 'addr', subBuilder: Address.create)
    ..aE<Account>(2, _omitFieldNames ? '' : 'account',
        fieldType: $pb.PbFieldType.QE, enumValues: Account.values);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_RecvAddress clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_RecvAddress copyWith(void Function(From_RecvAddress) updates) =>
      super.copyWith((message) => updates(message as From_RecvAddress))
          as From_RecvAddress;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_RecvAddress create() => From_RecvAddress._();
  @$core.override
  From_RecvAddress createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static From_RecvAddress getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<From_RecvAddress>(create);
  static From_RecvAddress? _defaultInstance;

  @$pb.TagNumber(1)
  Address get addr => $_getN(0);
  @$pb.TagNumber(1)
  set addr(Address value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAddr() => $_has(0);
  @$pb.TagNumber(1)
  void clearAddr() => $_clearField(1);
  @$pb.TagNumber(1)
  Address ensureAddr() => $_ensure(0);

  @$pb.TagNumber(2)
  Account get account => $_getN(1);
  @$pb.TagNumber(2)
  set account(Account value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAccount() => $_has(1);
  @$pb.TagNumber(2)
  void clearAccount() => $_clearField(2);
}

class From_LoadUtxos_Utxo extends $pb.GeneratedMessage {
  factory From_LoadUtxos_Utxo({
    $core.String? txid,
    $core.int? vout,
    $core.String? assetId,
    $fixnum.Int64? amount,
    $core.String? address,
    $core.bool? isInternal,
    $core.bool? isConfidential,
  }) {
    final result = create();
    if (txid != null) result.txid = txid;
    if (vout != null) result.vout = vout;
    if (assetId != null) result.assetId = assetId;
    if (amount != null) result.amount = amount;
    if (address != null) result.address = address;
    if (isInternal != null) result.isInternal = isInternal;
    if (isConfidential != null) result.isConfidential = isConfidential;
    return result;
  }

  From_LoadUtxos_Utxo._();

  factory From_LoadUtxos_Utxo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory From_LoadUtxos_Utxo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'From.LoadUtxos.Utxo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'txid')
    ..aI(2, _omitFieldNames ? '' : 'vout', fieldType: $pb.PbFieldType.QU3)
    ..aQS(3, _omitFieldNames ? '' : 'assetId')
    ..a<$fixnum.Int64>(4, _omitFieldNames ? '' : 'amount', $pb.PbFieldType.QU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aQS(5, _omitFieldNames ? '' : 'address')
    ..a<$core.bool>(6, _omitFieldNames ? '' : 'isInternal', $pb.PbFieldType.QB)
    ..a<$core.bool>(
        7, _omitFieldNames ? '' : 'isConfidential', $pb.PbFieldType.QB);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_LoadUtxos_Utxo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_LoadUtxos_Utxo copyWith(void Function(From_LoadUtxos_Utxo) updates) =>
      super.copyWith((message) => updates(message as From_LoadUtxos_Utxo))
          as From_LoadUtxos_Utxo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_LoadUtxos_Utxo create() => From_LoadUtxos_Utxo._();
  @$core.override
  From_LoadUtxos_Utxo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static From_LoadUtxos_Utxo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<From_LoadUtxos_Utxo>(create);
  static From_LoadUtxos_Utxo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get txid => $_getSZ(0);
  @$pb.TagNumber(1)
  set txid($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTxid() => $_has(0);
  @$pb.TagNumber(1)
  void clearTxid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get vout => $_getIZ(1);
  @$pb.TagNumber(2)
  set vout($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVout() => $_has(1);
  @$pb.TagNumber(2)
  void clearVout() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get assetId => $_getSZ(2);
  @$pb.TagNumber(3)
  set assetId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAssetId() => $_has(2);
  @$pb.TagNumber(3)
  void clearAssetId() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get amount => $_getI64(3);
  @$pb.TagNumber(4)
  set amount($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAmount() => $_has(3);
  @$pb.TagNumber(4)
  void clearAmount() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get address => $_getSZ(4);
  @$pb.TagNumber(5)
  set address($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAddress() => $_has(4);
  @$pb.TagNumber(5)
  void clearAddress() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get isInternal => $_getBF(5);
  @$pb.TagNumber(6)
  set isInternal($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasIsInternal() => $_has(5);
  @$pb.TagNumber(6)
  void clearIsInternal() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get isConfidential => $_getBF(6);
  @$pb.TagNumber(7)
  set isConfidential($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasIsConfidential() => $_has(6);
  @$pb.TagNumber(7)
  void clearIsConfidential() => $_clearField(7);
}

class From_LoadUtxos extends $pb.GeneratedMessage {
  factory From_LoadUtxos({
    Account? account,
    $core.Iterable<From_LoadUtxos_Utxo>? utxos,
    $core.String? errorMsg,
  }) {
    final result = create();
    if (account != null) result.account = account;
    if (utxos != null) result.utxos.addAll(utxos);
    if (errorMsg != null) result.errorMsg = errorMsg;
    return result;
  }

  From_LoadUtxos._();

  factory From_LoadUtxos.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory From_LoadUtxos.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'From.LoadUtxos',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..aE<Account>(1, _omitFieldNames ? '' : 'account',
        fieldType: $pb.PbFieldType.QE, enumValues: Account.values)
    ..pPM<From_LoadUtxos_Utxo>(2, _omitFieldNames ? '' : 'utxos',
        subBuilder: From_LoadUtxos_Utxo.create)
    ..aOS(3, _omitFieldNames ? '' : 'errorMsg');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_LoadUtxos clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_LoadUtxos copyWith(void Function(From_LoadUtxos) updates) =>
      super.copyWith((message) => updates(message as From_LoadUtxos))
          as From_LoadUtxos;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_LoadUtxos create() => From_LoadUtxos._();
  @$core.override
  From_LoadUtxos createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static From_LoadUtxos getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<From_LoadUtxos>(create);
  static From_LoadUtxos? _defaultInstance;

  @$pb.TagNumber(1)
  Account get account => $_getN(0);
  @$pb.TagNumber(1)
  set account(Account value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAccount() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccount() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<From_LoadUtxos_Utxo> get utxos => $_getList(1);

  @$pb.TagNumber(3)
  $core.String get errorMsg => $_getSZ(2);
  @$pb.TagNumber(3)
  set errorMsg($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasErrorMsg() => $_has(2);
  @$pb.TagNumber(3)
  void clearErrorMsg() => $_clearField(3);
}

class From_LoadAddresses_Address extends $pb.GeneratedMessage {
  factory From_LoadAddresses_Address({
    $core.String? address,
    $core.int? index,
    $core.bool? isInternal,
    $core.String? unconfidentialAddress,
    ScriptType? scriptType,
  }) {
    final result = create();
    if (address != null) result.address = address;
    if (index != null) result.index = index;
    if (isInternal != null) result.isInternal = isInternal;
    if (unconfidentialAddress != null)
      result.unconfidentialAddress = unconfidentialAddress;
    if (scriptType != null) result.scriptType = scriptType;
    return result;
  }

  From_LoadAddresses_Address._();

  factory From_LoadAddresses_Address.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory From_LoadAddresses_Address.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'From.LoadAddresses.Address',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'address')
    ..aI(2, _omitFieldNames ? '' : 'index', fieldType: $pb.PbFieldType.QU3)
    ..a<$core.bool>(3, _omitFieldNames ? '' : 'isInternal', $pb.PbFieldType.QB)
    ..aQS(4, _omitFieldNames ? '' : 'unconfidentialAddress')
    ..aE<ScriptType>(5, _omitFieldNames ? '' : 'scriptType',
        fieldType: $pb.PbFieldType.QE, enumValues: ScriptType.values);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_LoadAddresses_Address clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_LoadAddresses_Address copyWith(
          void Function(From_LoadAddresses_Address) updates) =>
      super.copyWith(
              (message) => updates(message as From_LoadAddresses_Address))
          as From_LoadAddresses_Address;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_LoadAddresses_Address create() => From_LoadAddresses_Address._();
  @$core.override
  From_LoadAddresses_Address createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static From_LoadAddresses_Address getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<From_LoadAddresses_Address>(create);
  static From_LoadAddresses_Address? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get address => $_getSZ(0);
  @$pb.TagNumber(1)
  set address($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAddress() => $_has(0);
  @$pb.TagNumber(1)
  void clearAddress() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get index => $_getIZ(1);
  @$pb.TagNumber(2)
  set index($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIndex() => $_has(1);
  @$pb.TagNumber(2)
  void clearIndex() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get isInternal => $_getBF(2);
  @$pb.TagNumber(3)
  set isInternal($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIsInternal() => $_has(2);
  @$pb.TagNumber(3)
  void clearIsInternal() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get unconfidentialAddress => $_getSZ(3);
  @$pb.TagNumber(4)
  set unconfidentialAddress($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUnconfidentialAddress() => $_has(3);
  @$pb.TagNumber(4)
  void clearUnconfidentialAddress() => $_clearField(4);

  @$pb.TagNumber(5)
  ScriptType get scriptType => $_getN(4);
  @$pb.TagNumber(5)
  set scriptType(ScriptType value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasScriptType() => $_has(4);
  @$pb.TagNumber(5)
  void clearScriptType() => $_clearField(5);
}

class From_LoadAddresses extends $pb.GeneratedMessage {
  factory From_LoadAddresses({
    Account? account,
    $core.Iterable<From_LoadAddresses_Address>? addresses,
    $core.String? errorMsg,
  }) {
    final result = create();
    if (account != null) result.account = account;
    if (addresses != null) result.addresses.addAll(addresses);
    if (errorMsg != null) result.errorMsg = errorMsg;
    return result;
  }

  From_LoadAddresses._();

  factory From_LoadAddresses.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory From_LoadAddresses.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'From.LoadAddresses',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..aE<Account>(1, _omitFieldNames ? '' : 'account',
        fieldType: $pb.PbFieldType.QE, enumValues: Account.values)
    ..pPM<From_LoadAddresses_Address>(2, _omitFieldNames ? '' : 'addresses',
        subBuilder: From_LoadAddresses_Address.create)
    ..aOS(3, _omitFieldNames ? '' : 'errorMsg');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_LoadAddresses clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_LoadAddresses copyWith(void Function(From_LoadAddresses) updates) =>
      super.copyWith((message) => updates(message as From_LoadAddresses))
          as From_LoadAddresses;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_LoadAddresses create() => From_LoadAddresses._();
  @$core.override
  From_LoadAddresses createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static From_LoadAddresses getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<From_LoadAddresses>(create);
  static From_LoadAddresses? _defaultInstance;

  @$pb.TagNumber(1)
  Account get account => $_getN(0);
  @$pb.TagNumber(1)
  set account(Account value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAccount() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccount() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<From_LoadAddresses_Address> get addresses => $_getList(1);

  @$pb.TagNumber(3)
  $core.String get errorMsg => $_getSZ(2);
  @$pb.TagNumber(3)
  set errorMsg($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasErrorMsg() => $_has(2);
  @$pb.TagNumber(3)
  void clearErrorMsg() => $_clearField(3);
}

class From_LoadTransactions extends $pb.GeneratedMessage {
  factory From_LoadTransactions({
    $core.Iterable<TransItem>? txs,
    $core.String? errorMsg,
  }) {
    final result = create();
    if (txs != null) result.txs.addAll(txs);
    if (errorMsg != null) result.errorMsg = errorMsg;
    return result;
  }

  From_LoadTransactions._();

  factory From_LoadTransactions.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory From_LoadTransactions.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'From.LoadTransactions',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..pPM<TransItem>(1, _omitFieldNames ? '' : 'txs',
        subBuilder: TransItem.create)
    ..aOS(3, _omitFieldNames ? '' : 'errorMsg');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_LoadTransactions clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_LoadTransactions copyWith(
          void Function(From_LoadTransactions) updates) =>
      super.copyWith((message) => updates(message as From_LoadTransactions))
          as From_LoadTransactions;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_LoadTransactions create() => From_LoadTransactions._();
  @$core.override
  From_LoadTransactions createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static From_LoadTransactions getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<From_LoadTransactions>(create);
  static From_LoadTransactions? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<TransItem> get txs => $_getList(0);

  @$pb.TagNumber(3)
  $core.String get errorMsg => $_getSZ(1);
  @$pb.TagNumber(3)
  set errorMsg($core.String value) => $_setString(1, value);
  @$pb.TagNumber(3)
  $core.bool hasErrorMsg() => $_has(1);
  @$pb.TagNumber(3)
  void clearErrorMsg() => $_clearField(3);
}

class From_ShowTransaction extends $pb.GeneratedMessage {
  factory From_ShowTransaction({
    TransItem? tx,
  }) {
    final result = create();
    if (tx != null) result.tx = tx;
    return result;
  }

  From_ShowTransaction._();

  factory From_ShowTransaction.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory From_ShowTransaction.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'From.ShowTransaction',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..aQM<TransItem>(1, _omitFieldNames ? '' : 'tx',
        subBuilder: TransItem.create);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_ShowTransaction clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_ShowTransaction copyWith(void Function(From_ShowTransaction) updates) =>
      super.copyWith((message) => updates(message as From_ShowTransaction))
          as From_ShowTransaction;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_ShowTransaction create() => From_ShowTransaction._();
  @$core.override
  From_ShowTransaction createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static From_ShowTransaction getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<From_ShowTransaction>(create);
  static From_ShowTransaction? _defaultInstance;

  @$pb.TagNumber(1)
  TransItem get tx => $_getN(0);
  @$pb.TagNumber(1)
  set tx(TransItem value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTx() => $_has(0);
  @$pb.TagNumber(1)
  void clearTx() => $_clearField(1);
  @$pb.TagNumber(1)
  TransItem ensureTx() => $_ensure(0);
}

enum From_CreateTxResult_Result { errorMsg, createdTx, notSet }

class From_CreateTxResult extends $pb.GeneratedMessage {
  factory From_CreateTxResult({
    $core.String? errorMsg,
    CreatedTx? createdTx,
  }) {
    final result = create();
    if (errorMsg != null) result.errorMsg = errorMsg;
    if (createdTx != null) result.createdTx = createdTx;
    return result;
  }

  From_CreateTxResult._();

  factory From_CreateTxResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory From_CreateTxResult.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, From_CreateTxResult_Result>
      _From_CreateTxResult_ResultByTag = {
    1: From_CreateTxResult_Result.errorMsg,
    2: From_CreateTxResult_Result.createdTx,
    0: From_CreateTxResult_Result.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'From.CreateTxResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOS(1, _omitFieldNames ? '' : 'errorMsg')
    ..aOM<CreatedTx>(2, _omitFieldNames ? '' : 'createdTx',
        subBuilder: CreatedTx.create);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_CreateTxResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_CreateTxResult copyWith(void Function(From_CreateTxResult) updates) =>
      super.copyWith((message) => updates(message as From_CreateTxResult))
          as From_CreateTxResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_CreateTxResult create() => From_CreateTxResult._();
  @$core.override
  From_CreateTxResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static From_CreateTxResult getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<From_CreateTxResult>(create);
  static From_CreateTxResult? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  From_CreateTxResult_Result whichResult() =>
      _From_CreateTxResult_ResultByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  void clearResult() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get errorMsg => $_getSZ(0);
  @$pb.TagNumber(1)
  set errorMsg($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasErrorMsg() => $_has(0);
  @$pb.TagNumber(1)
  void clearErrorMsg() => $_clearField(1);

  @$pb.TagNumber(2)
  CreatedTx get createdTx => $_getN(1);
  @$pb.TagNumber(2)
  set createdTx(CreatedTx value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasCreatedTx() => $_has(1);
  @$pb.TagNumber(2)
  void clearCreatedTx() => $_clearField(2);
  @$pb.TagNumber(2)
  CreatedTx ensureCreatedTx() => $_ensure(1);
}

enum From_SendResult_Result { errorMsg, txItem, notSet }

class From_SendResult extends $pb.GeneratedMessage {
  factory From_SendResult({
    $core.String? errorMsg,
    TransItem? txItem,
  }) {
    final result = create();
    if (errorMsg != null) result.errorMsg = errorMsg;
    if (txItem != null) result.txItem = txItem;
    return result;
  }

  From_SendResult._();

  factory From_SendResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory From_SendResult.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, From_SendResult_Result>
      _From_SendResult_ResultByTag = {
    1: From_SendResult_Result.errorMsg,
    2: From_SendResult_Result.txItem,
    0: From_SendResult_Result.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'From.SendResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOS(1, _omitFieldNames ? '' : 'errorMsg')
    ..aOM<TransItem>(2, _omitFieldNames ? '' : 'txItem',
        subBuilder: TransItem.create);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_SendResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_SendResult copyWith(void Function(From_SendResult) updates) =>
      super.copyWith((message) => updates(message as From_SendResult))
          as From_SendResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_SendResult create() => From_SendResult._();
  @$core.override
  From_SendResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static From_SendResult getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<From_SendResult>(create);
  static From_SendResult? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  From_SendResult_Result whichResult() =>
      _From_SendResult_ResultByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  void clearResult() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get errorMsg => $_getSZ(0);
  @$pb.TagNumber(1)
  set errorMsg($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasErrorMsg() => $_has(0);
  @$pb.TagNumber(1)
  void clearErrorMsg() => $_clearField(1);

  @$pb.TagNumber(2)
  TransItem get txItem => $_getN(1);
  @$pb.TagNumber(2)
  set txItem(TransItem value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasTxItem() => $_has(1);
  @$pb.TagNumber(2)
  void clearTxItem() => $_clearField(2);
  @$pb.TagNumber(2)
  TransItem ensureTxItem() => $_ensure(1);
}

enum From_BlindedValues_Result { errorMsg, blindedValues, notSet }

class From_BlindedValues extends $pb.GeneratedMessage {
  factory From_BlindedValues({
    $core.String? txid,
    $core.String? errorMsg,
    $core.String? blindedValues,
  }) {
    final result = create();
    if (txid != null) result.txid = txid;
    if (errorMsg != null) result.errorMsg = errorMsg;
    if (blindedValues != null) result.blindedValues = blindedValues;
    return result;
  }

  From_BlindedValues._();

  factory From_BlindedValues.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory From_BlindedValues.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, From_BlindedValues_Result>
      _From_BlindedValues_ResultByTag = {
    2: From_BlindedValues_Result.errorMsg,
    3: From_BlindedValues_Result.blindedValues,
    0: From_BlindedValues_Result.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'From.BlindedValues',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..oo(0, [2, 3])
    ..aQS(1, _omitFieldNames ? '' : 'txid')
    ..aOS(2, _omitFieldNames ? '' : 'errorMsg')
    ..aOS(3, _omitFieldNames ? '' : 'blindedValues');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_BlindedValues clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_BlindedValues copyWith(void Function(From_BlindedValues) updates) =>
      super.copyWith((message) => updates(message as From_BlindedValues))
          as From_BlindedValues;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_BlindedValues create() => From_BlindedValues._();
  @$core.override
  From_BlindedValues createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static From_BlindedValues getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<From_BlindedValues>(create);
  static From_BlindedValues? _defaultInstance;

  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  From_BlindedValues_Result whichResult() =>
      _From_BlindedValues_ResultByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  void clearResult() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get txid => $_getSZ(0);
  @$pb.TagNumber(1)
  set txid($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTxid() => $_has(0);
  @$pb.TagNumber(1)
  void clearTxid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get errorMsg => $_getSZ(1);
  @$pb.TagNumber(2)
  set errorMsg($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasErrorMsg() => $_has(1);
  @$pb.TagNumber(2)
  void clearErrorMsg() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get blindedValues => $_getSZ(2);
  @$pb.TagNumber(3)
  set blindedValues($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBlindedValues() => $_has(2);
  @$pb.TagNumber(3)
  void clearBlindedValues() => $_clearField(3);
}

class From_PriceUpdate extends $pb.GeneratedMessage {
  factory From_PriceUpdate({
    $core.String? asset,
    $core.double? bid,
    $core.double? ask,
  }) {
    final result = create();
    if (asset != null) result.asset = asset;
    if (bid != null) result.bid = bid;
    if (ask != null) result.ask = ask;
    return result;
  }

  From_PriceUpdate._();

  factory From_PriceUpdate.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory From_PriceUpdate.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'From.PriceUpdate',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'asset')
    ..aD(2, _omitFieldNames ? '' : 'bid', fieldType: $pb.PbFieldType.QD)
    ..aD(3, _omitFieldNames ? '' : 'ask', fieldType: $pb.PbFieldType.QD);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_PriceUpdate clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_PriceUpdate copyWith(void Function(From_PriceUpdate) updates) =>
      super.copyWith((message) => updates(message as From_PriceUpdate))
          as From_PriceUpdate;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_PriceUpdate create() => From_PriceUpdate._();
  @$core.override
  From_PriceUpdate createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static From_PriceUpdate getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<From_PriceUpdate>(create);
  static From_PriceUpdate? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get asset => $_getSZ(0);
  @$pb.TagNumber(1)
  set asset($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAsset() => $_has(0);
  @$pb.TagNumber(1)
  void clearAsset() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get bid => $_getN(1);
  @$pb.TagNumber(2)
  set bid($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBid() => $_has(1);
  @$pb.TagNumber(2)
  void clearBid() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get ask => $_getN(2);
  @$pb.TagNumber(3)
  set ask($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAsk() => $_has(2);
  @$pb.TagNumber(3)
  void clearAsk() => $_clearField(3);
}

enum From_SubscribedValue_Result {
  pegInMinAmount,
  pegInWalletBalance,
  pegOutMinAmount,
  pegOutWalletBalance,
  pegOutNextBlockFeeRate,
  notSet
}

class From_SubscribedValue extends $pb.GeneratedMessage {
  factory From_SubscribedValue({
    $fixnum.Int64? pegInMinAmount,
    $fixnum.Int64? pegInWalletBalance,
    $fixnum.Int64? pegOutMinAmount,
    $fixnum.Int64? pegOutWalletBalance,
    $core.double? pegOutNextBlockFeeRate,
  }) {
    final result = create();
    if (pegInMinAmount != null) result.pegInMinAmount = pegInMinAmount;
    if (pegInWalletBalance != null)
      result.pegInWalletBalance = pegInWalletBalance;
    if (pegOutMinAmount != null) result.pegOutMinAmount = pegOutMinAmount;
    if (pegOutWalletBalance != null)
      result.pegOutWalletBalance = pegOutWalletBalance;
    if (pegOutNextBlockFeeRate != null)
      result.pegOutNextBlockFeeRate = pegOutNextBlockFeeRate;
    return result;
  }

  From_SubscribedValue._();

  factory From_SubscribedValue.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory From_SubscribedValue.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, From_SubscribedValue_Result>
      _From_SubscribedValue_ResultByTag = {
    1: From_SubscribedValue_Result.pegInMinAmount,
    2: From_SubscribedValue_Result.pegInWalletBalance,
    3: From_SubscribedValue_Result.pegOutMinAmount,
    4: From_SubscribedValue_Result.pegOutWalletBalance,
    5: From_SubscribedValue_Result.pegOutNextBlockFeeRate,
    0: From_SubscribedValue_Result.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'From.SubscribedValue',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4, 5])
    ..a<$fixnum.Int64>(
        1, _omitFieldNames ? '' : 'pegInMinAmount', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        2, _omitFieldNames ? '' : 'pegInWalletBalance', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        3, _omitFieldNames ? '' : 'pegOutMinAmount', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        4, _omitFieldNames ? '' : 'pegOutWalletBalance', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aD(5, _omitFieldNames ? '' : 'pegOutNextBlockFeeRate')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_SubscribedValue clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_SubscribedValue copyWith(void Function(From_SubscribedValue) updates) =>
      super.copyWith((message) => updates(message as From_SubscribedValue))
          as From_SubscribedValue;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_SubscribedValue create() => From_SubscribedValue._();
  @$core.override
  From_SubscribedValue createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static From_SubscribedValue getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<From_SubscribedValue>(create);
  static From_SubscribedValue? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  From_SubscribedValue_Result whichResult() =>
      _From_SubscribedValue_ResultByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  void clearResult() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $fixnum.Int64 get pegInMinAmount => $_getI64(0);
  @$pb.TagNumber(1)
  set pegInMinAmount($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPegInMinAmount() => $_has(0);
  @$pb.TagNumber(1)
  void clearPegInMinAmount() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get pegInWalletBalance => $_getI64(1);
  @$pb.TagNumber(2)
  set pegInWalletBalance($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPegInWalletBalance() => $_has(1);
  @$pb.TagNumber(2)
  void clearPegInWalletBalance() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get pegOutMinAmount => $_getI64(2);
  @$pb.TagNumber(3)
  set pegOutMinAmount($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPegOutMinAmount() => $_has(2);
  @$pb.TagNumber(3)
  void clearPegOutMinAmount() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get pegOutWalletBalance => $_getI64(3);
  @$pb.TagNumber(4)
  set pegOutWalletBalance($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPegOutWalletBalance() => $_has(3);
  @$pb.TagNumber(4)
  void clearPegOutWalletBalance() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get pegOutNextBlockFeeRate => $_getN(4);
  @$pb.TagNumber(5)
  set pegOutNextBlockFeeRate($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPegOutNextBlockFeeRate() => $_has(4);
  @$pb.TagNumber(5)
  void clearPegOutNextBlockFeeRate() => $_clearField(5);
}

class From_ShowMessage extends $pb.GeneratedMessage {
  factory From_ShowMessage({
    $core.String? text,
  }) {
    final result = create();
    if (text != null) result.text = text;
    return result;
  }

  From_ShowMessage._();

  factory From_ShowMessage.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory From_ShowMessage.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'From.ShowMessage',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'text');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_ShowMessage clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_ShowMessage copyWith(void Function(From_ShowMessage) updates) =>
      super.copyWith((message) => updates(message as From_ShowMessage))
          as From_ShowMessage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_ShowMessage create() => From_ShowMessage._();
  @$core.override
  From_ShowMessage createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static From_ShowMessage getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<From_ShowMessage>(create);
  static From_ShowMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get text => $_getSZ(0);
  @$pb.TagNumber(1)
  set text($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasText() => $_has(0);
  @$pb.TagNumber(1)
  void clearText() => $_clearField(1);
}

class From_ShowInsufficientFunds extends $pb.GeneratedMessage {
  factory From_ShowInsufficientFunds({
    $core.String? assetId,
    $fixnum.Int64? available,
    $fixnum.Int64? required,
  }) {
    final result = create();
    if (assetId != null) result.assetId = assetId;
    if (available != null) result.available = available;
    if (required != null) result.required = required;
    return result;
  }

  From_ShowInsufficientFunds._();

  factory From_ShowInsufficientFunds.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory From_ShowInsufficientFunds.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'From.ShowInsufficientFunds',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'assetId')
    ..a<$fixnum.Int64>(
        2, _omitFieldNames ? '' : 'available', $pb.PbFieldType.Q6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(3, _omitFieldNames ? '' : 'required', $pb.PbFieldType.Q6,
        defaultOrMaker: $fixnum.Int64.ZERO);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_ShowInsufficientFunds clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_ShowInsufficientFunds copyWith(
          void Function(From_ShowInsufficientFunds) updates) =>
      super.copyWith(
              (message) => updates(message as From_ShowInsufficientFunds))
          as From_ShowInsufficientFunds;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_ShowInsufficientFunds create() => From_ShowInsufficientFunds._();
  @$core.override
  From_ShowInsufficientFunds createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static From_ShowInsufficientFunds getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<From_ShowInsufficientFunds>(create);
  static From_ShowInsufficientFunds? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assetId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get available => $_getI64(1);
  @$pb.TagNumber(2)
  set available($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAvailable() => $_has(1);
  @$pb.TagNumber(2)
  void clearAvailable() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get required => $_getI64(2);
  @$pb.TagNumber(3)
  set required($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRequired() => $_has(2);
  @$pb.TagNumber(3)
  void clearRequired() => $_clearField(3);
}

class From_AssetDetails_Stats extends $pb.GeneratedMessage {
  factory From_AssetDetails_Stats({
    $fixnum.Int64? issuedAmount,
    $fixnum.Int64? burnedAmount,
    $core.bool? hasBlindedIssuances,
    $fixnum.Int64? offlineAmount,
  }) {
    final result = create();
    if (issuedAmount != null) result.issuedAmount = issuedAmount;
    if (burnedAmount != null) result.burnedAmount = burnedAmount;
    if (hasBlindedIssuances != null)
      result.hasBlindedIssuances = hasBlindedIssuances;
    if (offlineAmount != null) result.offlineAmount = offlineAmount;
    return result;
  }

  From_AssetDetails_Stats._();

  factory From_AssetDetails_Stats.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory From_AssetDetails_Stats.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'From.AssetDetails.Stats',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(
        1, _omitFieldNames ? '' : 'issuedAmount', $pb.PbFieldType.Q6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        2, _omitFieldNames ? '' : 'burnedAmount', $pb.PbFieldType.Q6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.bool>(
        3, _omitFieldNames ? '' : 'hasBlindedIssuances', $pb.PbFieldType.QB)
    ..a<$fixnum.Int64>(
        4, _omitFieldNames ? '' : 'offlineAmount', $pb.PbFieldType.Q6,
        defaultOrMaker: $fixnum.Int64.ZERO);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_AssetDetails_Stats clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_AssetDetails_Stats copyWith(
          void Function(From_AssetDetails_Stats) updates) =>
      super.copyWith((message) => updates(message as From_AssetDetails_Stats))
          as From_AssetDetails_Stats;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_AssetDetails_Stats create() => From_AssetDetails_Stats._();
  @$core.override
  From_AssetDetails_Stats createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static From_AssetDetails_Stats getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<From_AssetDetails_Stats>(create);
  static From_AssetDetails_Stats? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get issuedAmount => $_getI64(0);
  @$pb.TagNumber(1)
  set issuedAmount($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIssuedAmount() => $_has(0);
  @$pb.TagNumber(1)
  void clearIssuedAmount() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get burnedAmount => $_getI64(1);
  @$pb.TagNumber(2)
  set burnedAmount($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBurnedAmount() => $_has(1);
  @$pb.TagNumber(2)
  void clearBurnedAmount() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get hasBlindedIssuances => $_getBF(2);
  @$pb.TagNumber(3)
  set hasBlindedIssuances($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasHasBlindedIssuances() => $_has(2);
  @$pb.TagNumber(3)
  void clearHasBlindedIssuances() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get offlineAmount => $_getI64(3);
  @$pb.TagNumber(4)
  set offlineAmount($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOfflineAmount() => $_has(3);
  @$pb.TagNumber(4)
  void clearOfflineAmount() => $_clearField(4);
}

class From_AssetDetails extends $pb.GeneratedMessage {
  factory From_AssetDetails({
    $core.String? assetId,
    From_AssetDetails_Stats? stats,
    $core.String? chartUrl,
  }) {
    final result = create();
    if (assetId != null) result.assetId = assetId;
    if (stats != null) result.stats = stats;
    if (chartUrl != null) result.chartUrl = chartUrl;
    return result;
  }

  From_AssetDetails._();

  factory From_AssetDetails.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory From_AssetDetails.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'From.AssetDetails',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'assetId')
    ..aOM<From_AssetDetails_Stats>(2, _omitFieldNames ? '' : 'stats',
        subBuilder: From_AssetDetails_Stats.create)
    ..aOS(3, _omitFieldNames ? '' : 'chartUrl');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_AssetDetails clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_AssetDetails copyWith(void Function(From_AssetDetails) updates) =>
      super.copyWith((message) => updates(message as From_AssetDetails))
          as From_AssetDetails;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_AssetDetails create() => From_AssetDetails._();
  @$core.override
  From_AssetDetails createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static From_AssetDetails getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<From_AssetDetails>(create);
  static From_AssetDetails? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assetId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetId() => $_clearField(1);

  @$pb.TagNumber(2)
  From_AssetDetails_Stats get stats => $_getN(1);
  @$pb.TagNumber(2)
  set stats(From_AssetDetails_Stats value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStats() => $_has(1);
  @$pb.TagNumber(2)
  void clearStats() => $_clearField(2);
  @$pb.TagNumber(2)
  From_AssetDetails_Stats ensureStats() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get chartUrl => $_getSZ(2);
  @$pb.TagNumber(3)
  set chartUrl($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasChartUrl() => $_has(2);
  @$pb.TagNumber(3)
  void clearChartUrl() => $_clearField(3);
}

class From_LocalMessage extends $pb.GeneratedMessage {
  factory From_LocalMessage({
    $core.String? title,
    $core.String? body,
  }) {
    final result = create();
    if (title != null) result.title = title;
    if (body != null) result.body = body;
    return result;
  }

  From_LocalMessage._();

  factory From_LocalMessage.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory From_LocalMessage.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'From.LocalMessage',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'title')
    ..aQS(2, _omitFieldNames ? '' : 'body');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_LocalMessage clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_LocalMessage copyWith(void Function(From_LocalMessage) updates) =>
      super.copyWith((message) => updates(message as From_LocalMessage))
          as From_LocalMessage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_LocalMessage create() => From_LocalMessage._();
  @$core.override
  From_LocalMessage createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static From_LocalMessage getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<From_LocalMessage>(create);
  static From_LocalMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get body => $_getSZ(1);
  @$pb.TagNumber(2)
  set body($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBody() => $_has(1);
  @$pb.TagNumber(2)
  void clearBody() => $_clearField(2);
}

class From_PortfolioPrices extends $pb.GeneratedMessage {
  factory From_PortfolioPrices({
    $core.Iterable<$core.MapEntry<$core.String, $core.double>>? pricesUsd,
  }) {
    final result = create();
    if (pricesUsd != null) result.pricesUsd.addEntries(pricesUsd);
    return result;
  }

  From_PortfolioPrices._();

  factory From_PortfolioPrices.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory From_PortfolioPrices.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'From.PortfolioPrices',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..m<$core.String, $core.double>(1, _omitFieldNames ? '' : 'pricesUsd',
        entryClassName: 'From.PortfolioPrices.PricesUsdEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OD,
        packageName: const $pb.PackageName('sideswap.proto'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_PortfolioPrices clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_PortfolioPrices copyWith(void Function(From_PortfolioPrices) updates) =>
      super.copyWith((message) => updates(message as From_PortfolioPrices))
          as From_PortfolioPrices;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_PortfolioPrices create() => From_PortfolioPrices._();
  @$core.override
  From_PortfolioPrices createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static From_PortfolioPrices getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<From_PortfolioPrices>(create);
  static From_PortfolioPrices? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbMap<$core.String, $core.double> get pricesUsd => $_getMap(0);
}

class From_ConversionRates extends $pb.GeneratedMessage {
  factory From_ConversionRates({
    $core.Iterable<$core.MapEntry<$core.String, $core.double>>?
        usdConversionRates,
  }) {
    final result = create();
    if (usdConversionRates != null)
      result.usdConversionRates.addEntries(usdConversionRates);
    return result;
  }

  From_ConversionRates._();

  factory From_ConversionRates.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory From_ConversionRates.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'From.ConversionRates',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..m<$core.String, $core.double>(
        1, _omitFieldNames ? '' : 'usdConversionRates',
        entryClassName: 'From.ConversionRates.UsdConversionRatesEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OD,
        packageName: const $pb.PackageName('sideswap.proto'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_ConversionRates clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_ConversionRates copyWith(void Function(From_ConversionRates) updates) =>
      super.copyWith((message) => updates(message as From_ConversionRates))
          as From_ConversionRates;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_ConversionRates create() => From_ConversionRates._();
  @$core.override
  From_ConversionRates createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static From_ConversionRates getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<From_ConversionRates>(create);
  static From_ConversionRates? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbMap<$core.String, $core.double> get usdConversionRates => $_getMap(0);
}

class From_JadePorts_Port extends $pb.GeneratedMessage {
  factory From_JadePorts_Port({
    $core.String? jadeId,
    $core.String? port,
  }) {
    final result = create();
    if (jadeId != null) result.jadeId = jadeId;
    if (port != null) result.port = port;
    return result;
  }

  From_JadePorts_Port._();

  factory From_JadePorts_Port.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory From_JadePorts_Port.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'From.JadePorts.Port',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'jadeId')
    ..aQS(2, _omitFieldNames ? '' : 'port');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_JadePorts_Port clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_JadePorts_Port copyWith(void Function(From_JadePorts_Port) updates) =>
      super.copyWith((message) => updates(message as From_JadePorts_Port))
          as From_JadePorts_Port;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_JadePorts_Port create() => From_JadePorts_Port._();
  @$core.override
  From_JadePorts_Port createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static From_JadePorts_Port getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<From_JadePorts_Port>(create);
  static From_JadePorts_Port? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get jadeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set jadeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasJadeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearJadeId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get port => $_getSZ(1);
  @$pb.TagNumber(2)
  set port($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPort() => $_has(1);
  @$pb.TagNumber(2)
  void clearPort() => $_clearField(2);
}

class From_JadePorts extends $pb.GeneratedMessage {
  factory From_JadePorts({
    $core.Iterable<From_JadePorts_Port>? ports,
  }) {
    final result = create();
    if (ports != null) result.ports.addAll(ports);
    return result;
  }

  From_JadePorts._();

  factory From_JadePorts.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory From_JadePorts.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'From.JadePorts',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..pPM<From_JadePorts_Port>(1, _omitFieldNames ? '' : 'ports',
        subBuilder: From_JadePorts_Port.create);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_JadePorts clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_JadePorts copyWith(void Function(From_JadePorts) updates) =>
      super.copyWith((message) => updates(message as From_JadePorts))
          as From_JadePorts;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_JadePorts create() => From_JadePorts._();
  @$core.override
  From_JadePorts createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static From_JadePorts getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<From_JadePorts>(create);
  static From_JadePorts? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<From_JadePorts_Port> get ports => $_getList(0);
}

class From_JadeStatus extends $pb.GeneratedMessage {
  factory From_JadeStatus({
    From_JadeStatus_Status? status,
  }) {
    final result = create();
    if (status != null) result.status = status;
    return result;
  }

  From_JadeStatus._();

  factory From_JadeStatus.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory From_JadeStatus.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'From.JadeStatus',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..aE<From_JadeStatus_Status>(1, _omitFieldNames ? '' : 'status',
        fieldType: $pb.PbFieldType.QE,
        enumValues: From_JadeStatus_Status.values);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_JadeStatus clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_JadeStatus copyWith(void Function(From_JadeStatus) updates) =>
      super.copyWith((message) => updates(message as From_JadeStatus))
          as From_JadeStatus;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_JadeStatus create() => From_JadeStatus._();
  @$core.override
  From_JadeStatus createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static From_JadeStatus getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<From_JadeStatus>(create);
  static From_JadeStatus? _defaultInstance;

  @$pb.TagNumber(1)
  From_JadeStatus_Status get status => $_getN(0);
  @$pb.TagNumber(1)
  set status(From_JadeStatus_Status value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => $_clearField(1);
}

class From_GaidStatus extends $pb.GeneratedMessage {
  factory From_GaidStatus({
    $core.String? gaid,
    $core.String? assetId,
    $core.String? error,
  }) {
    final result = create();
    if (gaid != null) result.gaid = gaid;
    if (assetId != null) result.assetId = assetId;
    if (error != null) result.error = error;
    return result;
  }

  From_GaidStatus._();

  factory From_GaidStatus.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory From_GaidStatus.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'From.GaidStatus',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'gaid')
    ..aQS(2, _omitFieldNames ? '' : 'assetId')
    ..aOS(3, _omitFieldNames ? '' : 'error');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_GaidStatus clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_GaidStatus copyWith(void Function(From_GaidStatus) updates) =>
      super.copyWith((message) => updates(message as From_GaidStatus))
          as From_GaidStatus;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_GaidStatus create() => From_GaidStatus._();
  @$core.override
  From_GaidStatus createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static From_GaidStatus getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<From_GaidStatus>(create);
  static From_GaidStatus? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get gaid => $_getSZ(0);
  @$pb.TagNumber(1)
  set gaid($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasGaid() => $_has(0);
  @$pb.TagNumber(1)
  void clearGaid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get assetId => $_getSZ(1);
  @$pb.TagNumber(2)
  set assetId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAssetId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAssetId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get error => $_getSZ(2);
  @$pb.TagNumber(3)
  set error($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasError() => $_has(2);
  @$pb.TagNumber(3)
  void clearError() => $_clearField(3);
}

class From_MarketList extends $pb.GeneratedMessage {
  factory From_MarketList({
    $core.Iterable<MarketInfo>? markets,
  }) {
    final result = create();
    if (markets != null) result.markets.addAll(markets);
    return result;
  }

  From_MarketList._();

  factory From_MarketList.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory From_MarketList.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'From.MarketList',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..pPM<MarketInfo>(1, _omitFieldNames ? '' : 'markets',
        subBuilder: MarketInfo.create);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_MarketList clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_MarketList copyWith(void Function(From_MarketList) updates) =>
      super.copyWith((message) => updates(message as From_MarketList))
          as From_MarketList;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_MarketList create() => From_MarketList._();
  @$core.override
  From_MarketList createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static From_MarketList getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<From_MarketList>(create);
  static From_MarketList? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<MarketInfo> get markets => $_getList(0);
}

class From_PublicOrders extends $pb.GeneratedMessage {
  factory From_PublicOrders({
    AssetPair? assetPair,
    $core.Iterable<PublicOrder>? list,
  }) {
    final result = create();
    if (assetPair != null) result.assetPair = assetPair;
    if (list != null) result.list.addAll(list);
    return result;
  }

  From_PublicOrders._();

  factory From_PublicOrders.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory From_PublicOrders.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'From.PublicOrders',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..aQM<AssetPair>(1, _omitFieldNames ? '' : 'assetPair',
        subBuilder: AssetPair.create)
    ..pPM<PublicOrder>(2, _omitFieldNames ? '' : 'list',
        subBuilder: PublicOrder.create);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_PublicOrders clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_PublicOrders copyWith(void Function(From_PublicOrders) updates) =>
      super.copyWith((message) => updates(message as From_PublicOrders))
          as From_PublicOrders;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_PublicOrders create() => From_PublicOrders._();
  @$core.override
  From_PublicOrders createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static From_PublicOrders getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<From_PublicOrders>(create);
  static From_PublicOrders? _defaultInstance;

  @$pb.TagNumber(1)
  AssetPair get assetPair => $_getN(0);
  @$pb.TagNumber(1)
  set assetPair(AssetPair value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAssetPair() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetPair() => $_clearField(1);
  @$pb.TagNumber(1)
  AssetPair ensureAssetPair() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<PublicOrder> get list => $_getList(1);
}

class From_MinMarketAmounts extends $pb.GeneratedMessage {
  factory From_MinMarketAmounts({
    $fixnum.Int64? lbtc,
    $fixnum.Int64? usdt,
    $fixnum.Int64? eurx,
  }) {
    final result = create();
    if (lbtc != null) result.lbtc = lbtc;
    if (usdt != null) result.usdt = usdt;
    if (eurx != null) result.eurx = eurx;
    return result;
  }

  From_MinMarketAmounts._();

  factory From_MinMarketAmounts.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory From_MinMarketAmounts.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'From.MinMarketAmounts',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'lbtc', $pb.PbFieldType.QU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'usdt', $pb.PbFieldType.QU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(3, _omitFieldNames ? '' : 'eurx', $pb.PbFieldType.QU6,
        defaultOrMaker: $fixnum.Int64.ZERO);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_MinMarketAmounts clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_MinMarketAmounts copyWith(
          void Function(From_MinMarketAmounts) updates) =>
      super.copyWith((message) => updates(message as From_MinMarketAmounts))
          as From_MinMarketAmounts;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_MinMarketAmounts create() => From_MinMarketAmounts._();
  @$core.override
  From_MinMarketAmounts createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static From_MinMarketAmounts getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<From_MinMarketAmounts>(create);
  static From_MinMarketAmounts? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get lbtc => $_getI64(0);
  @$pb.TagNumber(1)
  set lbtc($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLbtc() => $_has(0);
  @$pb.TagNumber(1)
  void clearLbtc() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get usdt => $_getI64(1);
  @$pb.TagNumber(2)
  set usdt($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUsdt() => $_has(1);
  @$pb.TagNumber(2)
  void clearUsdt() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get eurx => $_getI64(2);
  @$pb.TagNumber(3)
  set eurx($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEurx() => $_has(2);
  @$pb.TagNumber(3)
  void clearEurx() => $_clearField(3);
}

class From_OwnOrders extends $pb.GeneratedMessage {
  factory From_OwnOrders({
    $core.Iterable<OwnOrder>? list,
  }) {
    final result = create();
    if (list != null) result.list.addAll(list);
    return result;
  }

  From_OwnOrders._();

  factory From_OwnOrders.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory From_OwnOrders.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'From.OwnOrders',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..pPM<OwnOrder>(1, _omitFieldNames ? '' : 'list',
        subBuilder: OwnOrder.create);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_OwnOrders clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_OwnOrders copyWith(void Function(From_OwnOrders) updates) =>
      super.copyWith((message) => updates(message as From_OwnOrders))
          as From_OwnOrders;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_OwnOrders create() => From_OwnOrders._();
  @$core.override
  From_OwnOrders createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static From_OwnOrders getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<From_OwnOrders>(create);
  static From_OwnOrders? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<OwnOrder> get list => $_getList(0);
}

class From_MarketPrice extends $pb.GeneratedMessage {
  factory From_MarketPrice({
    AssetPair? assetPair,
    $core.double? indPrice,
    $core.double? lastPrice,
  }) {
    final result = create();
    if (assetPair != null) result.assetPair = assetPair;
    if (indPrice != null) result.indPrice = indPrice;
    if (lastPrice != null) result.lastPrice = lastPrice;
    return result;
  }

  From_MarketPrice._();

  factory From_MarketPrice.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory From_MarketPrice.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'From.MarketPrice',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..aQM<AssetPair>(1, _omitFieldNames ? '' : 'assetPair',
        subBuilder: AssetPair.create)
    ..aD(2, _omitFieldNames ? '' : 'indPrice')
    ..aD(3, _omitFieldNames ? '' : 'lastPrice');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_MarketPrice clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_MarketPrice copyWith(void Function(From_MarketPrice) updates) =>
      super.copyWith((message) => updates(message as From_MarketPrice))
          as From_MarketPrice;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_MarketPrice create() => From_MarketPrice._();
  @$core.override
  From_MarketPrice createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static From_MarketPrice getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<From_MarketPrice>(create);
  static From_MarketPrice? _defaultInstance;

  @$pb.TagNumber(1)
  AssetPair get assetPair => $_getN(0);
  @$pb.TagNumber(1)
  set assetPair(AssetPair value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAssetPair() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetPair() => $_clearField(1);
  @$pb.TagNumber(1)
  AssetPair ensureAssetPair() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.double get indPrice => $_getN(1);
  @$pb.TagNumber(2)
  set indPrice($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIndPrice() => $_has(1);
  @$pb.TagNumber(2)
  void clearIndPrice() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get lastPrice => $_getN(2);
  @$pb.TagNumber(3)
  set lastPrice($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLastPrice() => $_has(2);
  @$pb.TagNumber(3)
  void clearLastPrice() => $_clearField(3);
}

class From_OrderSubmit_UnregisteredGaid extends $pb.GeneratedMessage {
  factory From_OrderSubmit_UnregisteredGaid({
    $core.String? domainAgent,
  }) {
    final result = create();
    if (domainAgent != null) result.domainAgent = domainAgent;
    return result;
  }

  From_OrderSubmit_UnregisteredGaid._();

  factory From_OrderSubmit_UnregisteredGaid.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory From_OrderSubmit_UnregisteredGaid.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'From.OrderSubmit.UnregisteredGaid',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'domainAgent');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_OrderSubmit_UnregisteredGaid clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_OrderSubmit_UnregisteredGaid copyWith(
          void Function(From_OrderSubmit_UnregisteredGaid) updates) =>
      super.copyWith((message) =>
              updates(message as From_OrderSubmit_UnregisteredGaid))
          as From_OrderSubmit_UnregisteredGaid;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_OrderSubmit_UnregisteredGaid create() =>
      From_OrderSubmit_UnregisteredGaid._();
  @$core.override
  From_OrderSubmit_UnregisteredGaid createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static From_OrderSubmit_UnregisteredGaid getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<From_OrderSubmit_UnregisteredGaid>(
          create);
  static From_OrderSubmit_UnregisteredGaid? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get domainAgent => $_getSZ(0);
  @$pb.TagNumber(1)
  set domainAgent($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDomainAgent() => $_has(0);
  @$pb.TagNumber(1)
  void clearDomainAgent() => $_clearField(1);
}

enum From_OrderSubmit_Result { submitSucceed, error, unregisteredGaid, notSet }

class From_OrderSubmit extends $pb.GeneratedMessage {
  factory From_OrderSubmit({
    OwnOrder? submitSucceed,
    $core.String? error,
    From_OrderSubmit_UnregisteredGaid? unregisteredGaid,
  }) {
    final result = create();
    if (submitSucceed != null) result.submitSucceed = submitSucceed;
    if (error != null) result.error = error;
    if (unregisteredGaid != null) result.unregisteredGaid = unregisteredGaid;
    return result;
  }

  From_OrderSubmit._();

  factory From_OrderSubmit.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory From_OrderSubmit.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, From_OrderSubmit_Result>
      _From_OrderSubmit_ResultByTag = {
    1: From_OrderSubmit_Result.submitSucceed,
    2: From_OrderSubmit_Result.error,
    3: From_OrderSubmit_Result.unregisteredGaid,
    0: From_OrderSubmit_Result.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'From.OrderSubmit',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3])
    ..aOM<OwnOrder>(1, _omitFieldNames ? '' : 'submitSucceed',
        subBuilder: OwnOrder.create)
    ..aOS(2, _omitFieldNames ? '' : 'error')
    ..aOM<From_OrderSubmit_UnregisteredGaid>(
        3, _omitFieldNames ? '' : 'unregisteredGaid',
        subBuilder: From_OrderSubmit_UnregisteredGaid.create);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_OrderSubmit clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_OrderSubmit copyWith(void Function(From_OrderSubmit) updates) =>
      super.copyWith((message) => updates(message as From_OrderSubmit))
          as From_OrderSubmit;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_OrderSubmit create() => From_OrderSubmit._();
  @$core.override
  From_OrderSubmit createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static From_OrderSubmit getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<From_OrderSubmit>(create);
  static From_OrderSubmit? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  From_OrderSubmit_Result whichResult() =>
      _From_OrderSubmit_ResultByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  void clearResult() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  OwnOrder get submitSucceed => $_getN(0);
  @$pb.TagNumber(1)
  set submitSucceed(OwnOrder value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSubmitSucceed() => $_has(0);
  @$pb.TagNumber(1)
  void clearSubmitSucceed() => $_clearField(1);
  @$pb.TagNumber(1)
  OwnOrder ensureSubmitSucceed() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get error => $_getSZ(1);
  @$pb.TagNumber(2)
  set error($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasError() => $_has(1);
  @$pb.TagNumber(2)
  void clearError() => $_clearField(2);

  @$pb.TagNumber(3)
  From_OrderSubmit_UnregisteredGaid get unregisteredGaid => $_getN(2);
  @$pb.TagNumber(3)
  set unregisteredGaid(From_OrderSubmit_UnregisteredGaid value) =>
      $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasUnregisteredGaid() => $_has(2);
  @$pb.TagNumber(3)
  void clearUnregisteredGaid() => $_clearField(3);
  @$pb.TagNumber(3)
  From_OrderSubmit_UnregisteredGaid ensureUnregisteredGaid() => $_ensure(2);
}

class From_StartOrder_Success extends $pb.GeneratedMessage {
  factory From_StartOrder_Success({
    AssetPair? assetPair,
    TradeDir? tradeDir,
    $fixnum.Int64? amount,
    $core.double? price,
    AssetType? feeAsset,
    $core.bool? twoStep,
  }) {
    final result = create();
    if (assetPair != null) result.assetPair = assetPair;
    if (tradeDir != null) result.tradeDir = tradeDir;
    if (amount != null) result.amount = amount;
    if (price != null) result.price = price;
    if (feeAsset != null) result.feeAsset = feeAsset;
    if (twoStep != null) result.twoStep = twoStep;
    return result;
  }

  From_StartOrder_Success._();

  factory From_StartOrder_Success.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory From_StartOrder_Success.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'From.StartOrder.Success',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..aQM<AssetPair>(1, _omitFieldNames ? '' : 'assetPair',
        subBuilder: AssetPair.create)
    ..aE<TradeDir>(2, _omitFieldNames ? '' : 'tradeDir',
        fieldType: $pb.PbFieldType.QE, enumValues: TradeDir.values)
    ..a<$fixnum.Int64>(3, _omitFieldNames ? '' : 'amount', $pb.PbFieldType.QU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aD(4, _omitFieldNames ? '' : 'price', fieldType: $pb.PbFieldType.QD)
    ..aE<AssetType>(5, _omitFieldNames ? '' : 'feeAsset',
        fieldType: $pb.PbFieldType.QE, enumValues: AssetType.values)
    ..a<$core.bool>(6, _omitFieldNames ? '' : 'twoStep', $pb.PbFieldType.QB);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_StartOrder_Success clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_StartOrder_Success copyWith(
          void Function(From_StartOrder_Success) updates) =>
      super.copyWith((message) => updates(message as From_StartOrder_Success))
          as From_StartOrder_Success;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_StartOrder_Success create() => From_StartOrder_Success._();
  @$core.override
  From_StartOrder_Success createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static From_StartOrder_Success getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<From_StartOrder_Success>(create);
  static From_StartOrder_Success? _defaultInstance;

  @$pb.TagNumber(1)
  AssetPair get assetPair => $_getN(0);
  @$pb.TagNumber(1)
  set assetPair(AssetPair value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAssetPair() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetPair() => $_clearField(1);
  @$pb.TagNumber(1)
  AssetPair ensureAssetPair() => $_ensure(0);

  @$pb.TagNumber(2)
  TradeDir get tradeDir => $_getN(1);
  @$pb.TagNumber(2)
  set tradeDir(TradeDir value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasTradeDir() => $_has(1);
  @$pb.TagNumber(2)
  void clearTradeDir() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get amount => $_getI64(2);
  @$pb.TagNumber(3)
  set amount($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAmount() => $_has(2);
  @$pb.TagNumber(3)
  void clearAmount() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get price => $_getN(3);
  @$pb.TagNumber(4)
  set price($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPrice() => $_has(3);
  @$pb.TagNumber(4)
  void clearPrice() => $_clearField(4);

  @$pb.TagNumber(5)
  AssetType get feeAsset => $_getN(4);
  @$pb.TagNumber(5)
  set feeAsset(AssetType value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasFeeAsset() => $_has(4);
  @$pb.TagNumber(5)
  void clearFeeAsset() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get twoStep => $_getBF(5);
  @$pb.TagNumber(6)
  set twoStep($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTwoStep() => $_has(5);
  @$pb.TagNumber(6)
  void clearTwoStep() => $_clearField(6);
}

enum From_StartOrder_Result { success, error, notSet }

class From_StartOrder extends $pb.GeneratedMessage {
  factory From_StartOrder({
    From_StartOrder_Success? success,
    $core.String? error,
    $fixnum.Int64? orderId,
  }) {
    final result = create();
    if (success != null) result.success = success;
    if (error != null) result.error = error;
    if (orderId != null) result.orderId = orderId;
    return result;
  }

  From_StartOrder._();

  factory From_StartOrder.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory From_StartOrder.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, From_StartOrder_Result>
      _From_StartOrder_ResultByTag = {
    1: From_StartOrder_Result.success,
    2: From_StartOrder_Result.error,
    0: From_StartOrder_Result.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'From.StartOrder',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOM<From_StartOrder_Success>(1, _omitFieldNames ? '' : 'success',
        subBuilder: From_StartOrder_Success.create)
    ..aOS(2, _omitFieldNames ? '' : 'error')
    ..a<$fixnum.Int64>(5, _omitFieldNames ? '' : 'orderId', $pb.PbFieldType.QU6,
        defaultOrMaker: $fixnum.Int64.ZERO);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_StartOrder clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_StartOrder copyWith(void Function(From_StartOrder) updates) =>
      super.copyWith((message) => updates(message as From_StartOrder))
          as From_StartOrder;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_StartOrder create() => From_StartOrder._();
  @$core.override
  From_StartOrder createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static From_StartOrder getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<From_StartOrder>(create);
  static From_StartOrder? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  From_StartOrder_Result whichResult() =>
      _From_StartOrder_ResultByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  void clearResult() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  From_StartOrder_Success get success => $_getN(0);
  @$pb.TagNumber(1)
  set success(From_StartOrder_Success value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
  @$pb.TagNumber(1)
  From_StartOrder_Success ensureSuccess() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get error => $_getSZ(1);
  @$pb.TagNumber(2)
  set error($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasError() => $_has(1);
  @$pb.TagNumber(2)
  void clearError() => $_clearField(2);

  @$pb.TagNumber(5)
  $fixnum.Int64 get orderId => $_getI64(2);
  @$pb.TagNumber(5)
  set orderId($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(5)
  $core.bool hasOrderId() => $_has(2);
  @$pb.TagNumber(5)
  void clearOrderId() => $_clearField(5);
}

class From_Quote_Success extends $pb.GeneratedMessage {
  factory From_Quote_Success({
    $fixnum.Int64? quoteId,
    $fixnum.Int64? baseAmount,
    $fixnum.Int64? quoteAmount,
    $fixnum.Int64? serverFee,
    $fixnum.Int64? fixedFee,
    $fixnum.Int64? ttlMilliseconds,
    $core.double? priceTaker,
    $fixnum.Int64? sendAmount,
    $fixnum.Int64? recvAmount,
  }) {
    final result = create();
    if (quoteId != null) result.quoteId = quoteId;
    if (baseAmount != null) result.baseAmount = baseAmount;
    if (quoteAmount != null) result.quoteAmount = quoteAmount;
    if (serverFee != null) result.serverFee = serverFee;
    if (fixedFee != null) result.fixedFee = fixedFee;
    if (ttlMilliseconds != null) result.ttlMilliseconds = ttlMilliseconds;
    if (priceTaker != null) result.priceTaker = priceTaker;
    if (sendAmount != null) result.sendAmount = sendAmount;
    if (recvAmount != null) result.recvAmount = recvAmount;
    return result;
  }

  From_Quote_Success._();

  factory From_Quote_Success.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory From_Quote_Success.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'From.Quote.Success',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'quoteId', $pb.PbFieldType.QU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        2, _omitFieldNames ? '' : 'baseAmount', $pb.PbFieldType.QU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        3, _omitFieldNames ? '' : 'quoteAmount', $pb.PbFieldType.QU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        4, _omitFieldNames ? '' : 'serverFee', $pb.PbFieldType.QU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        5, _omitFieldNames ? '' : 'fixedFee', $pb.PbFieldType.QU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        6, _omitFieldNames ? '' : 'ttlMilliseconds', $pb.PbFieldType.QU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aD(7, _omitFieldNames ? '' : 'priceTaker', fieldType: $pb.PbFieldType.QD)
    ..a<$fixnum.Int64>(
        8, _omitFieldNames ? '' : 'sendAmount', $pb.PbFieldType.QU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        9, _omitFieldNames ? '' : 'recvAmount', $pb.PbFieldType.QU6,
        defaultOrMaker: $fixnum.Int64.ZERO);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_Quote_Success clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_Quote_Success copyWith(void Function(From_Quote_Success) updates) =>
      super.copyWith((message) => updates(message as From_Quote_Success))
          as From_Quote_Success;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_Quote_Success create() => From_Quote_Success._();
  @$core.override
  From_Quote_Success createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static From_Quote_Success getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<From_Quote_Success>(create);
  static From_Quote_Success? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get quoteId => $_getI64(0);
  @$pb.TagNumber(1)
  set quoteId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasQuoteId() => $_has(0);
  @$pb.TagNumber(1)
  void clearQuoteId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get baseAmount => $_getI64(1);
  @$pb.TagNumber(2)
  set baseAmount($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBaseAmount() => $_has(1);
  @$pb.TagNumber(2)
  void clearBaseAmount() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get quoteAmount => $_getI64(2);
  @$pb.TagNumber(3)
  set quoteAmount($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasQuoteAmount() => $_has(2);
  @$pb.TagNumber(3)
  void clearQuoteAmount() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get serverFee => $_getI64(3);
  @$pb.TagNumber(4)
  set serverFee($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasServerFee() => $_has(3);
  @$pb.TagNumber(4)
  void clearServerFee() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get fixedFee => $_getI64(4);
  @$pb.TagNumber(5)
  set fixedFee($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasFixedFee() => $_has(4);
  @$pb.TagNumber(5)
  void clearFixedFee() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get ttlMilliseconds => $_getI64(5);
  @$pb.TagNumber(6)
  set ttlMilliseconds($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTtlMilliseconds() => $_has(5);
  @$pb.TagNumber(6)
  void clearTtlMilliseconds() => $_clearField(6);

  /// The price that includes `server_fee` but excludes `fixed_fee`
  @$pb.TagNumber(7)
  $core.double get priceTaker => $_getN(6);
  @$pb.TagNumber(7)
  set priceTaker($core.double value) => $_setDouble(6, value);
  @$pb.TagNumber(7)
  $core.bool hasPriceTaker() => $_has(6);
  @$pb.TagNumber(7)
  void clearPriceTaker() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get sendAmount => $_getI64(7);
  @$pb.TagNumber(8)
  set sendAmount($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasSendAmount() => $_has(7);
  @$pb.TagNumber(8)
  void clearSendAmount() => $_clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get recvAmount => $_getI64(8);
  @$pb.TagNumber(9)
  set recvAmount($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasRecvAmount() => $_has(8);
  @$pb.TagNumber(9)
  void clearRecvAmount() => $_clearField(9);
}

class From_Quote_LowBalance extends $pb.GeneratedMessage {
  factory From_Quote_LowBalance({
    $fixnum.Int64? baseAmount,
    $fixnum.Int64? quoteAmount,
    $fixnum.Int64? serverFee,
    $fixnum.Int64? fixedFee,
    $fixnum.Int64? available,
    $core.double? priceTaker,
    $fixnum.Int64? sendAmount,
    $fixnum.Int64? recvAmount,
  }) {
    final result = create();
    if (baseAmount != null) result.baseAmount = baseAmount;
    if (quoteAmount != null) result.quoteAmount = quoteAmount;
    if (serverFee != null) result.serverFee = serverFee;
    if (fixedFee != null) result.fixedFee = fixedFee;
    if (available != null) result.available = available;
    if (priceTaker != null) result.priceTaker = priceTaker;
    if (sendAmount != null) result.sendAmount = sendAmount;
    if (recvAmount != null) result.recvAmount = recvAmount;
    return result;
  }

  From_Quote_LowBalance._();

  factory From_Quote_LowBalance.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory From_Quote_LowBalance.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'From.Quote.LowBalance',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(
        1, _omitFieldNames ? '' : 'baseAmount', $pb.PbFieldType.QU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        2, _omitFieldNames ? '' : 'quoteAmount', $pb.PbFieldType.QU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        3, _omitFieldNames ? '' : 'serverFee', $pb.PbFieldType.QU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        4, _omitFieldNames ? '' : 'fixedFee', $pb.PbFieldType.QU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        5, _omitFieldNames ? '' : 'available', $pb.PbFieldType.QU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aD(6, _omitFieldNames ? '' : 'priceTaker', fieldType: $pb.PbFieldType.QD)
    ..a<$fixnum.Int64>(
        7, _omitFieldNames ? '' : 'sendAmount', $pb.PbFieldType.QU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        8, _omitFieldNames ? '' : 'recvAmount', $pb.PbFieldType.QU6,
        defaultOrMaker: $fixnum.Int64.ZERO);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_Quote_LowBalance clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_Quote_LowBalance copyWith(
          void Function(From_Quote_LowBalance) updates) =>
      super.copyWith((message) => updates(message as From_Quote_LowBalance))
          as From_Quote_LowBalance;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_Quote_LowBalance create() => From_Quote_LowBalance._();
  @$core.override
  From_Quote_LowBalance createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static From_Quote_LowBalance getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<From_Quote_LowBalance>(create);
  static From_Quote_LowBalance? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get baseAmount => $_getI64(0);
  @$pb.TagNumber(1)
  set baseAmount($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasBaseAmount() => $_has(0);
  @$pb.TagNumber(1)
  void clearBaseAmount() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get quoteAmount => $_getI64(1);
  @$pb.TagNumber(2)
  set quoteAmount($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasQuoteAmount() => $_has(1);
  @$pb.TagNumber(2)
  void clearQuoteAmount() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get serverFee => $_getI64(2);
  @$pb.TagNumber(3)
  set serverFee($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasServerFee() => $_has(2);
  @$pb.TagNumber(3)
  void clearServerFee() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get fixedFee => $_getI64(3);
  @$pb.TagNumber(4)
  set fixedFee($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFixedFee() => $_has(3);
  @$pb.TagNumber(4)
  void clearFixedFee() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get available => $_getI64(4);
  @$pb.TagNumber(5)
  set available($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAvailable() => $_has(4);
  @$pb.TagNumber(5)
  void clearAvailable() => $_clearField(5);

  /// The price that includes `server_fee` but excludes `fixed_fee`
  @$pb.TagNumber(6)
  $core.double get priceTaker => $_getN(5);
  @$pb.TagNumber(6)
  set priceTaker($core.double value) => $_setDouble(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPriceTaker() => $_has(5);
  @$pb.TagNumber(6)
  void clearPriceTaker() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get sendAmount => $_getI64(6);
  @$pb.TagNumber(7)
  set sendAmount($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSendAmount() => $_has(6);
  @$pb.TagNumber(7)
  void clearSendAmount() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get recvAmount => $_getI64(7);
  @$pb.TagNumber(8)
  set recvAmount($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasRecvAmount() => $_has(7);
  @$pb.TagNumber(8)
  void clearRecvAmount() => $_clearField(8);
}

class From_Quote_IndPrice extends $pb.GeneratedMessage {
  factory From_Quote_IndPrice({
    $core.double? priceTaker,
  }) {
    final result = create();
    if (priceTaker != null) result.priceTaker = priceTaker;
    return result;
  }

  From_Quote_IndPrice._();

  factory From_Quote_IndPrice.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory From_Quote_IndPrice.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'From.Quote.IndPrice',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'priceTaker', fieldType: $pb.PbFieldType.QD);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_Quote_IndPrice clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_Quote_IndPrice copyWith(void Function(From_Quote_IndPrice) updates) =>
      super.copyWith((message) => updates(message as From_Quote_IndPrice))
          as From_Quote_IndPrice;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_Quote_IndPrice create() => From_Quote_IndPrice._();
  @$core.override
  From_Quote_IndPrice createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static From_Quote_IndPrice getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<From_Quote_IndPrice>(create);
  static From_Quote_IndPrice? _defaultInstance;

  /// The price that includes `server_fee` but excludes `fixed_fee` for some small amount
  @$pb.TagNumber(1)
  $core.double get priceTaker => $_getN(0);
  @$pb.TagNumber(1)
  set priceTaker($core.double value) => $_setDouble(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPriceTaker() => $_has(0);
  @$pb.TagNumber(1)
  void clearPriceTaker() => $_clearField(1);
}

class From_Quote_UnregisteredGaid extends $pb.GeneratedMessage {
  factory From_Quote_UnregisteredGaid({
    $core.String? domainAgent,
  }) {
    final result = create();
    if (domainAgent != null) result.domainAgent = domainAgent;
    return result;
  }

  From_Quote_UnregisteredGaid._();

  factory From_Quote_UnregisteredGaid.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory From_Quote_UnregisteredGaid.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'From.Quote.UnregisteredGaid',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'domainAgent');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_Quote_UnregisteredGaid clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_Quote_UnregisteredGaid copyWith(
          void Function(From_Quote_UnregisteredGaid) updates) =>
      super.copyWith(
              (message) => updates(message as From_Quote_UnregisteredGaid))
          as From_Quote_UnregisteredGaid;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_Quote_UnregisteredGaid create() =>
      From_Quote_UnregisteredGaid._();
  @$core.override
  From_Quote_UnregisteredGaid createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static From_Quote_UnregisteredGaid getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<From_Quote_UnregisteredGaid>(create);
  static From_Quote_UnregisteredGaid? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get domainAgent => $_getSZ(0);
  @$pb.TagNumber(1)
  set domainAgent($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDomainAgent() => $_has(0);
  @$pb.TagNumber(1)
  void clearDomainAgent() => $_clearField(1);
}

enum From_Quote_Result {
  success,
  lowBalance,
  error,
  unregisteredGaid,
  indPrice,
  notSet
}

class From_Quote extends $pb.GeneratedMessage {
  factory From_Quote({
    AssetPair? assetPair,
    AssetType? assetType,
    $fixnum.Int64? amount,
    TradeDir? tradeDir,
    $fixnum.Int64? orderId,
    $fixnum.Int64? clientSubId,
    From_Quote_Success? success,
    From_Quote_LowBalance? lowBalance,
    $core.String? error,
    From_Quote_UnregisteredGaid? unregisteredGaid,
    From_Quote_IndPrice? indPrice,
  }) {
    final result = create();
    if (assetPair != null) result.assetPair = assetPair;
    if (assetType != null) result.assetType = assetType;
    if (amount != null) result.amount = amount;
    if (tradeDir != null) result.tradeDir = tradeDir;
    if (orderId != null) result.orderId = orderId;
    if (clientSubId != null) result.clientSubId = clientSubId;
    if (success != null) result.success = success;
    if (lowBalance != null) result.lowBalance = lowBalance;
    if (error != null) result.error = error;
    if (unregisteredGaid != null) result.unregisteredGaid = unregisteredGaid;
    if (indPrice != null) result.indPrice = indPrice;
    return result;
  }

  From_Quote._();

  factory From_Quote.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory From_Quote.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, From_Quote_Result> _From_Quote_ResultByTag =
      {
    10: From_Quote_Result.success,
    11: From_Quote_Result.lowBalance,
    12: From_Quote_Result.error,
    13: From_Quote_Result.unregisteredGaid,
    14: From_Quote_Result.indPrice,
    0: From_Quote_Result.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'From.Quote',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..oo(0, [10, 11, 12, 13, 14])
    ..aQM<AssetPair>(1, _omitFieldNames ? '' : 'assetPair',
        subBuilder: AssetPair.create)
    ..aE<AssetType>(2, _omitFieldNames ? '' : 'assetType',
        fieldType: $pb.PbFieldType.QE, enumValues: AssetType.values)
    ..a<$fixnum.Int64>(3, _omitFieldNames ? '' : 'amount', $pb.PbFieldType.QU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aE<TradeDir>(4, _omitFieldNames ? '' : 'tradeDir',
        fieldType: $pb.PbFieldType.QE, enumValues: TradeDir.values)
    ..a<$fixnum.Int64>(5, _omitFieldNames ? '' : 'orderId', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aInt64(6, _omitFieldNames ? '' : 'clientSubId')
    ..aOM<From_Quote_Success>(10, _omitFieldNames ? '' : 'success',
        subBuilder: From_Quote_Success.create)
    ..aOM<From_Quote_LowBalance>(11, _omitFieldNames ? '' : 'lowBalance',
        subBuilder: From_Quote_LowBalance.create)
    ..aOS(12, _omitFieldNames ? '' : 'error')
    ..aOM<From_Quote_UnregisteredGaid>(
        13, _omitFieldNames ? '' : 'unregisteredGaid',
        subBuilder: From_Quote_UnregisteredGaid.create)
    ..aOM<From_Quote_IndPrice>(14, _omitFieldNames ? '' : 'indPrice',
        subBuilder: From_Quote_IndPrice.create);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_Quote clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_Quote copyWith(void Function(From_Quote) updates) =>
      super.copyWith((message) => updates(message as From_Quote)) as From_Quote;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_Quote create() => From_Quote._();
  @$core.override
  From_Quote createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static From_Quote getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<From_Quote>(create);
  static From_Quote? _defaultInstance;

  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  @$pb.TagNumber(13)
  @$pb.TagNumber(14)
  From_Quote_Result whichResult() => _From_Quote_ResultByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  @$pb.TagNumber(13)
  @$pb.TagNumber(14)
  void clearResult() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  AssetPair get assetPair => $_getN(0);
  @$pb.TagNumber(1)
  set assetPair(AssetPair value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAssetPair() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetPair() => $_clearField(1);
  @$pb.TagNumber(1)
  AssetPair ensureAssetPair() => $_ensure(0);

  @$pb.TagNumber(2)
  AssetType get assetType => $_getN(1);
  @$pb.TagNumber(2)
  set assetType(AssetType value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAssetType() => $_has(1);
  @$pb.TagNumber(2)
  void clearAssetType() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get amount => $_getI64(2);
  @$pb.TagNumber(3)
  set amount($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAmount() => $_has(2);
  @$pb.TagNumber(3)
  void clearAmount() => $_clearField(3);

  @$pb.TagNumber(4)
  TradeDir get tradeDir => $_getN(3);
  @$pb.TagNumber(4)
  set tradeDir(TradeDir value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasTradeDir() => $_has(3);
  @$pb.TagNumber(4)
  void clearTradeDir() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get orderId => $_getI64(4);
  @$pb.TagNumber(5)
  set orderId($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasOrderId() => $_has(4);
  @$pb.TagNumber(5)
  void clearOrderId() => $_clearField(5);

  /// Client generated from the StartQuotes message
  @$pb.TagNumber(6)
  $fixnum.Int64 get clientSubId => $_getI64(5);
  @$pb.TagNumber(6)
  set clientSubId($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasClientSubId() => $_has(5);
  @$pb.TagNumber(6)
  void clearClientSubId() => $_clearField(6);

  @$pb.TagNumber(10)
  From_Quote_Success get success => $_getN(6);
  @$pb.TagNumber(10)
  set success(From_Quote_Success value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasSuccess() => $_has(6);
  @$pb.TagNumber(10)
  void clearSuccess() => $_clearField(10);
  @$pb.TagNumber(10)
  From_Quote_Success ensureSuccess() => $_ensure(6);

  @$pb.TagNumber(11)
  From_Quote_LowBalance get lowBalance => $_getN(7);
  @$pb.TagNumber(11)
  set lowBalance(From_Quote_LowBalance value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasLowBalance() => $_has(7);
  @$pb.TagNumber(11)
  void clearLowBalance() => $_clearField(11);
  @$pb.TagNumber(11)
  From_Quote_LowBalance ensureLowBalance() => $_ensure(7);

  @$pb.TagNumber(12)
  $core.String get error => $_getSZ(8);
  @$pb.TagNumber(12)
  set error($core.String value) => $_setString(8, value);
  @$pb.TagNumber(12)
  $core.bool hasError() => $_has(8);
  @$pb.TagNumber(12)
  void clearError() => $_clearField(12);

  @$pb.TagNumber(13)
  From_Quote_UnregisteredGaid get unregisteredGaid => $_getN(9);
  @$pb.TagNumber(13)
  set unregisteredGaid(From_Quote_UnregisteredGaid value) =>
      $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasUnregisteredGaid() => $_has(9);
  @$pb.TagNumber(13)
  void clearUnregisteredGaid() => $_clearField(13);
  @$pb.TagNumber(13)
  From_Quote_UnregisteredGaid ensureUnregisteredGaid() => $_ensure(9);

  @$pb.TagNumber(14)
  From_Quote_IndPrice get indPrice => $_getN(10);
  @$pb.TagNumber(14)
  set indPrice(From_Quote_IndPrice value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasIndPrice() => $_has(10);
  @$pb.TagNumber(14)
  void clearIndPrice() => $_clearField(14);
  @$pb.TagNumber(14)
  From_Quote_IndPrice ensureIndPrice() => $_ensure(10);
}

class From_AcceptQuote_Success extends $pb.GeneratedMessage {
  factory From_AcceptQuote_Success({
    $core.String? txid,
  }) {
    final result = create();
    if (txid != null) result.txid = txid;
    return result;
  }

  From_AcceptQuote_Success._();

  factory From_AcceptQuote_Success.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory From_AcceptQuote_Success.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'From.AcceptQuote.Success',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'txid');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_AcceptQuote_Success clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_AcceptQuote_Success copyWith(
          void Function(From_AcceptQuote_Success) updates) =>
      super.copyWith((message) => updates(message as From_AcceptQuote_Success))
          as From_AcceptQuote_Success;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_AcceptQuote_Success create() => From_AcceptQuote_Success._();
  @$core.override
  From_AcceptQuote_Success createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static From_AcceptQuote_Success getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<From_AcceptQuote_Success>(create);
  static From_AcceptQuote_Success? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get txid => $_getSZ(0);
  @$pb.TagNumber(1)
  set txid($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTxid() => $_has(0);
  @$pb.TagNumber(1)
  void clearTxid() => $_clearField(1);
}

enum From_AcceptQuote_Result { success, error, notSet }

class From_AcceptQuote extends $pb.GeneratedMessage {
  factory From_AcceptQuote({
    From_AcceptQuote_Success? success,
    $core.String? error,
    $fixnum.Int64? quoteId,
  }) {
    final result = create();
    if (success != null) result.success = success;
    if (error != null) result.error = error;
    if (quoteId != null) result.quoteId = quoteId;
    return result;
  }

  From_AcceptQuote._();

  factory From_AcceptQuote.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory From_AcceptQuote.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, From_AcceptQuote_Result>
      _From_AcceptQuote_ResultByTag = {
    1: From_AcceptQuote_Result.success,
    2: From_AcceptQuote_Result.error,
    0: From_AcceptQuote_Result.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'From.AcceptQuote',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOM<From_AcceptQuote_Success>(1, _omitFieldNames ? '' : 'success',
        subBuilder: From_AcceptQuote_Success.create)
    ..aOS(2, _omitFieldNames ? '' : 'error')
    ..a<$fixnum.Int64>(3, _omitFieldNames ? '' : 'quoteId', $pb.PbFieldType.QU6,
        defaultOrMaker: $fixnum.Int64.ZERO);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_AcceptQuote clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_AcceptQuote copyWith(void Function(From_AcceptQuote) updates) =>
      super.copyWith((message) => updates(message as From_AcceptQuote))
          as From_AcceptQuote;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_AcceptQuote create() => From_AcceptQuote._();
  @$core.override
  From_AcceptQuote createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static From_AcceptQuote getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<From_AcceptQuote>(create);
  static From_AcceptQuote? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  From_AcceptQuote_Result whichResult() =>
      _From_AcceptQuote_ResultByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  void clearResult() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  From_AcceptQuote_Success get success => $_getN(0);
  @$pb.TagNumber(1)
  set success(From_AcceptQuote_Success value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
  @$pb.TagNumber(1)
  From_AcceptQuote_Success ensureSuccess() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get error => $_getSZ(1);
  @$pb.TagNumber(2)
  set error($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasError() => $_has(1);
  @$pb.TagNumber(2)
  void clearError() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get quoteId => $_getI64(2);
  @$pb.TagNumber(3)
  set quoteId($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasQuoteId() => $_has(2);
  @$pb.TagNumber(3)
  void clearQuoteId() => $_clearField(3);
}

class From_ChartsSubscribe extends $pb.GeneratedMessage {
  factory From_ChartsSubscribe({
    AssetPair? assetPair,
    $core.Iterable<ChartPoint>? data,
  }) {
    final result = create();
    if (assetPair != null) result.assetPair = assetPair;
    if (data != null) result.data.addAll(data);
    return result;
  }

  From_ChartsSubscribe._();

  factory From_ChartsSubscribe.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory From_ChartsSubscribe.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'From.ChartsSubscribe',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..aQM<AssetPair>(1, _omitFieldNames ? '' : 'assetPair',
        subBuilder: AssetPair.create)
    ..pPM<ChartPoint>(2, _omitFieldNames ? '' : 'data',
        subBuilder: ChartPoint.create);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_ChartsSubscribe clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_ChartsSubscribe copyWith(void Function(From_ChartsSubscribe) updates) =>
      super.copyWith((message) => updates(message as From_ChartsSubscribe))
          as From_ChartsSubscribe;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_ChartsSubscribe create() => From_ChartsSubscribe._();
  @$core.override
  From_ChartsSubscribe createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static From_ChartsSubscribe getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<From_ChartsSubscribe>(create);
  static From_ChartsSubscribe? _defaultInstance;

  @$pb.TagNumber(1)
  AssetPair get assetPair => $_getN(0);
  @$pb.TagNumber(1)
  set assetPair(AssetPair value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAssetPair() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetPair() => $_clearField(1);
  @$pb.TagNumber(1)
  AssetPair ensureAssetPair() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<ChartPoint> get data => $_getList(1);
}

class From_ChartsUpdate extends $pb.GeneratedMessage {
  factory From_ChartsUpdate({
    AssetPair? assetPair,
    ChartPoint? update,
  }) {
    final result = create();
    if (assetPair != null) result.assetPair = assetPair;
    if (update != null) result.update = update;
    return result;
  }

  From_ChartsUpdate._();

  factory From_ChartsUpdate.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory From_ChartsUpdate.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'From.ChartsUpdate',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..aQM<AssetPair>(1, _omitFieldNames ? '' : 'assetPair',
        subBuilder: AssetPair.create)
    ..aQM<ChartPoint>(2, _omitFieldNames ? '' : 'update',
        subBuilder: ChartPoint.create);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_ChartsUpdate clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_ChartsUpdate copyWith(void Function(From_ChartsUpdate) updates) =>
      super.copyWith((message) => updates(message as From_ChartsUpdate))
          as From_ChartsUpdate;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_ChartsUpdate create() => From_ChartsUpdate._();
  @$core.override
  From_ChartsUpdate createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static From_ChartsUpdate getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<From_ChartsUpdate>(create);
  static From_ChartsUpdate? _defaultInstance;

  @$pb.TagNumber(1)
  AssetPair get assetPair => $_getN(0);
  @$pb.TagNumber(1)
  set assetPair(AssetPair value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAssetPair() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetPair() => $_clearField(1);
  @$pb.TagNumber(1)
  AssetPair ensureAssetPair() => $_ensure(0);

  @$pb.TagNumber(2)
  ChartPoint get update => $_getN(1);
  @$pb.TagNumber(2)
  set update(ChartPoint value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasUpdate() => $_has(1);
  @$pb.TagNumber(2)
  void clearUpdate() => $_clearField(2);
  @$pb.TagNumber(2)
  ChartPoint ensureUpdate() => $_ensure(1);
}

class From_LoadHistory extends $pb.GeneratedMessage {
  factory From_LoadHistory({
    $core.Iterable<HistoryOrder>? list,
    $core.int? total,
  }) {
    final result = create();
    if (list != null) result.list.addAll(list);
    if (total != null) result.total = total;
    return result;
  }

  From_LoadHistory._();

  factory From_LoadHistory.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory From_LoadHistory.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'From.LoadHistory',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..pPM<HistoryOrder>(1, _omitFieldNames ? '' : 'list',
        subBuilder: HistoryOrder.create)
    ..aI(2, _omitFieldNames ? '' : 'total', fieldType: $pb.PbFieldType.QU3);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_LoadHistory clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_LoadHistory copyWith(void Function(From_LoadHistory) updates) =>
      super.copyWith((message) => updates(message as From_LoadHistory))
          as From_LoadHistory;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_LoadHistory create() => From_LoadHistory._();
  @$core.override
  From_LoadHistory createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static From_LoadHistory getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<From_LoadHistory>(create);
  static From_LoadHistory? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<HistoryOrder> get list => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get total => $_getIZ(1);
  @$pb.TagNumber(2)
  set total($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotal() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotal() => $_clearField(2);
}

class From_HistoryUpdated extends $pb.GeneratedMessage {
  factory From_HistoryUpdated({
    HistoryOrder? order,
    $core.bool? isNew,
  }) {
    final result = create();
    if (order != null) result.order = order;
    if (isNew != null) result.isNew = isNew;
    return result;
  }

  From_HistoryUpdated._();

  factory From_HistoryUpdated.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory From_HistoryUpdated.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'From.HistoryUpdated',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..aQM<HistoryOrder>(1, _omitFieldNames ? '' : 'order',
        subBuilder: HistoryOrder.create)
    ..a<$core.bool>(2, _omitFieldNames ? '' : 'isNew', $pb.PbFieldType.QB);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_HistoryUpdated clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_HistoryUpdated copyWith(void Function(From_HistoryUpdated) updates) =>
      super.copyWith((message) => updates(message as From_HistoryUpdated))
          as From_HistoryUpdated;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_HistoryUpdated create() => From_HistoryUpdated._();
  @$core.override
  From_HistoryUpdated createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static From_HistoryUpdated getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<From_HistoryUpdated>(create);
  static From_HistoryUpdated? _defaultInstance;

  @$pb.TagNumber(1)
  HistoryOrder get order => $_getN(0);
  @$pb.TagNumber(1)
  set order(HistoryOrder value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOrder() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrder() => $_clearField(1);
  @$pb.TagNumber(1)
  HistoryOrder ensureOrder() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.bool get isNew => $_getBF(1);
  @$pb.TagNumber(2)
  set isNew($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIsNew() => $_has(1);
  @$pb.TagNumber(2)
  void clearIsNew() => $_clearField(2);
}

class From_SignerRequest_Sign extends $pb.GeneratedMessage {
  factory From_SignerRequest_Sign({
    $core.Iterable<Balance>? balances,
    $core.Iterable<AddressAmount>? recipients,
    $fixnum.Int64? networkFee,
  }) {
    final result = create();
    if (balances != null) result.balances.addAll(balances);
    if (recipients != null) result.recipients.addAll(recipients);
    if (networkFee != null) result.networkFee = networkFee;
    return result;
  }

  From_SignerRequest_Sign._();

  factory From_SignerRequest_Sign.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory From_SignerRequest_Sign.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'From.SignerRequest.Sign',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..pPM<Balance>(1, _omitFieldNames ? '' : 'balances',
        subBuilder: Balance.create)
    ..pPM<AddressAmount>(2, _omitFieldNames ? '' : 'recipients',
        subBuilder: AddressAmount.create)
    ..a<$fixnum.Int64>(
        3, _omitFieldNames ? '' : 'networkFee', $pb.PbFieldType.QU6,
        defaultOrMaker: $fixnum.Int64.ZERO);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_SignerRequest_Sign clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_SignerRequest_Sign copyWith(
          void Function(From_SignerRequest_Sign) updates) =>
      super.copyWith((message) => updates(message as From_SignerRequest_Sign))
          as From_SignerRequest_Sign;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_SignerRequest_Sign create() => From_SignerRequest_Sign._();
  @$core.override
  From_SignerRequest_Sign createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static From_SignerRequest_Sign getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<From_SignerRequest_Sign>(create);
  static From_SignerRequest_Sign? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Balance> get balances => $_getList(0);

  @$pb.TagNumber(2)
  $pb.PbList<AddressAmount> get recipients => $_getList(1);

  @$pb.TagNumber(3)
  $fixnum.Int64 get networkFee => $_getI64(2);
  @$pb.TagNumber(3)
  set networkFee($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNetworkFee() => $_has(2);
  @$pb.TagNumber(3)
  void clearNetworkFee() => $_clearField(3);
}

enum From_SignerRequest_Msg { connect, sign, notSet }

class From_SignerRequest extends $pb.GeneratedMessage {
  factory From_SignerRequest({
    $core.String? reqId,
    $core.String? origin,
    $fixnum.Int64? ttlMilliseconds,
    Empty? connect,
    From_SignerRequest_Sign? sign,
  }) {
    final result = create();
    if (reqId != null) result.reqId = reqId;
    if (origin != null) result.origin = origin;
    if (ttlMilliseconds != null) result.ttlMilliseconds = ttlMilliseconds;
    if (connect != null) result.connect = connect;
    if (sign != null) result.sign = sign;
    return result;
  }

  From_SignerRequest._();

  factory From_SignerRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory From_SignerRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, From_SignerRequest_Msg>
      _From_SignerRequest_MsgByTag = {
    10: From_SignerRequest_Msg.connect,
    11: From_SignerRequest_Msg.sign,
    0: From_SignerRequest_Msg.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'From.SignerRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..oo(0, [10, 11])
    ..aQS(1, _omitFieldNames ? '' : 'reqId')
    ..aQS(2, _omitFieldNames ? '' : 'origin')
    ..a<$fixnum.Int64>(
        3, _omitFieldNames ? '' : 'ttlMilliseconds', $pb.PbFieldType.QU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOM<Empty>(10, _omitFieldNames ? '' : 'connect', subBuilder: Empty.create)
    ..aOM<From_SignerRequest_Sign>(11, _omitFieldNames ? '' : 'sign',
        subBuilder: From_SignerRequest_Sign.create);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_SignerRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_SignerRequest copyWith(void Function(From_SignerRequest) updates) =>
      super.copyWith((message) => updates(message as From_SignerRequest))
          as From_SignerRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_SignerRequest create() => From_SignerRequest._();
  @$core.override
  From_SignerRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static From_SignerRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<From_SignerRequest>(create);
  static From_SignerRequest? _defaultInstance;

  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  From_SignerRequest_Msg whichMsg() =>
      _From_SignerRequest_MsgByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  void clearMsg() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get reqId => $_getSZ(0);
  @$pb.TagNumber(1)
  set reqId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReqId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReqId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get origin => $_getSZ(1);
  @$pb.TagNumber(2)
  set origin($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOrigin() => $_has(1);
  @$pb.TagNumber(2)
  void clearOrigin() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get ttlMilliseconds => $_getI64(2);
  @$pb.TagNumber(3)
  set ttlMilliseconds($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTtlMilliseconds() => $_has(2);
  @$pb.TagNumber(3)
  void clearTtlMilliseconds() => $_clearField(3);

  @$pb.TagNumber(10)
  Empty get connect => $_getN(3);
  @$pb.TagNumber(10)
  set connect(Empty value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasConnect() => $_has(3);
  @$pb.TagNumber(10)
  void clearConnect() => $_clearField(10);
  @$pb.TagNumber(10)
  Empty ensureConnect() => $_ensure(3);

  @$pb.TagNumber(11)
  From_SignerRequest_Sign get sign => $_getN(4);
  @$pb.TagNumber(11)
  set sign(From_SignerRequest_Sign value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasSign() => $_has(4);
  @$pb.TagNumber(11)
  void clearSign() => $_clearField(11);
  @$pb.TagNumber(11)
  From_SignerRequest_Sign ensureSign() => $_ensure(4);
}

class From_SignerCancel extends $pb.GeneratedMessage {
  factory From_SignerCancel({
    $core.String? reqId,
  }) {
    final result = create();
    if (reqId != null) result.reqId = reqId;
    return result;
  }

  From_SignerCancel._();

  factory From_SignerCancel.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory From_SignerCancel.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'From.SignerCancel',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'reqId');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_SignerCancel clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_SignerCancel copyWith(void Function(From_SignerCancel) updates) =>
      super.copyWith((message) => updates(message as From_SignerCancel))
          as From_SignerCancel;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_SignerCancel create() => From_SignerCancel._();
  @$core.override
  From_SignerCancel createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static From_SignerCancel getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<From_SignerCancel>(create);
  static From_SignerCancel? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reqId => $_getSZ(0);
  @$pb.TagNumber(1)
  set reqId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReqId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReqId() => $_clearField(1);
}

class From_SessionList extends $pb.GeneratedMessage {
  factory From_SessionList({
    $core.Iterable<Session>? sessions,
  }) {
    final result = create();
    if (sessions != null) result.sessions.addAll(sessions);
    return result;
  }

  From_SessionList._();

  factory From_SessionList.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory From_SessionList.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'From.SessionList',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..pPM<Session>(1, _omitFieldNames ? '' : 'sessions',
        subBuilder: Session.create);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_SessionList clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_SessionList copyWith(void Function(From_SessionList) updates) =>
      super.copyWith((message) => updates(message as From_SessionList))
          as From_SessionList;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_SessionList create() => From_SessionList._();
  @$core.override
  From_SessionList createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static From_SessionList getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<From_SessionList>(create);
  static From_SessionList? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Session> get sessions => $_getList(0);
}

class From_SessionAdded extends $pb.GeneratedMessage {
  factory From_SessionAdded({
    Session? session,
  }) {
    final result = create();
    if (session != null) result.session = session;
    return result;
  }

  From_SessionAdded._();

  factory From_SessionAdded.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory From_SessionAdded.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'From.SessionAdded',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..aQM<Session>(1, _omitFieldNames ? '' : 'session',
        subBuilder: Session.create);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_SessionAdded clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_SessionAdded copyWith(void Function(From_SessionAdded) updates) =>
      super.copyWith((message) => updates(message as From_SessionAdded))
          as From_SessionAdded;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_SessionAdded create() => From_SessionAdded._();
  @$core.override
  From_SessionAdded createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static From_SessionAdded getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<From_SessionAdded>(create);
  static From_SessionAdded? _defaultInstance;

  @$pb.TagNumber(1)
  Session get session => $_getN(0);
  @$pb.TagNumber(1)
  set session(Session value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSession() => $_has(0);
  @$pb.TagNumber(1)
  void clearSession() => $_clearField(1);
  @$pb.TagNumber(1)
  Session ensureSession() => $_ensure(0);
}

class From_SessionRemoved extends $pb.GeneratedMessage {
  factory From_SessionRemoved({
    $core.String? sessionId,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    return result;
  }

  From_SessionRemoved._();

  factory From_SessionRemoved.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory From_SessionRemoved.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'From.SessionRemoved',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'sessionId');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_SessionRemoved clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From_SessionRemoved copyWith(void Function(From_SessionRemoved) updates) =>
      super.copyWith((message) => updates(message as From_SessionRemoved))
          as From_SessionRemoved;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_SessionRemoved create() => From_SessionRemoved._();
  @$core.override
  From_SessionRemoved createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static From_SessionRemoved getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<From_SessionRemoved>(create);
  static From_SessionRemoved? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);
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
  subscribedValue,
  logout,
  login,
  peginWaitTx,
  swapSucceed,
  swapFailed,
  pegOutAmount,
  pegEdit,
  recvAddress,
  createTxResult,
  sendResult,
  blindedValues,
  loadUtxos,
  loadAddresses,
  loadTransactions,
  showTransaction,
  showMessage,
  insufficientFunds,
  serverConnected,
  serverDisconnected,
  newBlock,
  newTx,
  assetDetails,
  localMessage,
  portfolioPrices,
  conversionRates,
  jadePorts,
  jadeUnlock,
  jadeVerifyAddress,
  jadeStatus,
  gaidStatus,
  marketList,
  marketAdded,
  marketRemoved,
  publicOrders,
  publicOrderCreated,
  publicOrderRemoved,
  marketPrice,
  minMarketAmounts,
  ownOrders,
  ownOrderCreated,
  ownOrderRemoved,
  orderSubmit,
  orderEdit,
  orderCancel,
  quote,
  acceptQuote,
  startOrder,
  chartsSubscribe,
  chartsUpdate,
  loadHistory,
  historyUpdated,
  signerRequest,
  signerReturn,
  signerCancel,
  sessionList,
  sessionAdded,
  sessionRemoved,
  notSet
}

class From extends $pb.GeneratedMessage {
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
    From_SubscribedValue? subscribedValue,
    Empty? logout,
    From_Login? login,
    From_PeginWaitTx? peginWaitTx,
    TransItem? swapSucceed,
    $core.String? swapFailed,
    From_PegOutAmount? pegOutAmount,
    GenericResponse? pegEdit,
    From_RecvAddress? recvAddress,
    From_CreateTxResult? createTxResult,
    From_SendResult? sendResult,
    From_BlindedValues? blindedValues,
    From_LoadUtxos? loadUtxos,
    From_LoadAddresses? loadAddresses,
    From_LoadTransactions? loadTransactions,
    From_ShowTransaction? showTransaction,
    From_ShowMessage? showMessage,
    From_ShowInsufficientFunds? insufficientFunds,
    Empty? serverConnected,
    Empty? serverDisconnected,
    Empty? newBlock,
    Empty? newTx,
    From_AssetDetails? assetDetails,
    From_LocalMessage? localMessage,
    From_PortfolioPrices? portfolioPrices,
    From_ConversionRates? conversionRates,
    From_JadePorts? jadePorts,
    GenericResponse? jadeUnlock,
    GenericResponse? jadeVerifyAddress,
    From_JadeStatus? jadeStatus,
    From_GaidStatus? gaidStatus,
    From_MarketList? marketList,
    MarketInfo? marketAdded,
    AssetPair? marketRemoved,
    From_PublicOrders? publicOrders,
    PublicOrder? publicOrderCreated,
    OrderId? publicOrderRemoved,
    From_MarketPrice? marketPrice,
    From_MinMarketAmounts? minMarketAmounts,
    From_OwnOrders? ownOrders,
    OwnOrder? ownOrderCreated,
    OrderId? ownOrderRemoved,
    From_OrderSubmit? orderSubmit,
    GenericResponse? orderEdit,
    GenericResponse? orderCancel,
    From_Quote? quote,
    From_AcceptQuote? acceptQuote,
    From_StartOrder? startOrder,
    From_ChartsSubscribe? chartsSubscribe,
    From_ChartsUpdate? chartsUpdate,
    From_LoadHistory? loadHistory,
    From_HistoryUpdated? historyUpdated,
    From_SignerRequest? signerRequest,
    Empty? signerReturn,
    From_SignerCancel? signerCancel,
    From_SessionList? sessionList,
    From_SessionAdded? sessionAdded,
    From_SessionRemoved? sessionRemoved,
  }) {
    final result = create();
    if (updatedTxs != null) result.updatedTxs = updatedTxs;
    if (updatedPegs != null) result.updatedPegs = updatedPegs;
    if (newAsset != null) result.newAsset = newAsset;
    if (balanceUpdate != null) result.balanceUpdate = balanceUpdate;
    if (serverStatus != null) result.serverStatus = serverStatus;
    if (priceUpdate != null) result.priceUpdate = priceUpdate;
    if (walletLoaded != null) result.walletLoaded = walletLoaded;
    if (registerAmp != null) result.registerAmp = registerAmp;
    if (ampAssets != null) result.ampAssets = ampAssets;
    if (encryptPin != null) result.encryptPin = encryptPin;
    if (decryptPin != null) result.decryptPin = decryptPin;
    if (removedTxs != null) result.removedTxs = removedTxs;
    if (envSettings != null) result.envSettings = envSettings;
    if (syncComplete != null) result.syncComplete = syncComplete;
    if (subscribedValue != null) result.subscribedValue = subscribedValue;
    if (logout != null) result.logout = logout;
    if (login != null) result.login = login;
    if (peginWaitTx != null) result.peginWaitTx = peginWaitTx;
    if (swapSucceed != null) result.swapSucceed = swapSucceed;
    if (swapFailed != null) result.swapFailed = swapFailed;
    if (pegOutAmount != null) result.pegOutAmount = pegOutAmount;
    if (pegEdit != null) result.pegEdit = pegEdit;
    if (recvAddress != null) result.recvAddress = recvAddress;
    if (createTxResult != null) result.createTxResult = createTxResult;
    if (sendResult != null) result.sendResult = sendResult;
    if (blindedValues != null) result.blindedValues = blindedValues;
    if (loadUtxos != null) result.loadUtxos = loadUtxos;
    if (loadAddresses != null) result.loadAddresses = loadAddresses;
    if (loadTransactions != null) result.loadTransactions = loadTransactions;
    if (showTransaction != null) result.showTransaction = showTransaction;
    if (showMessage != null) result.showMessage = showMessage;
    if (insufficientFunds != null) result.insufficientFunds = insufficientFunds;
    if (serverConnected != null) result.serverConnected = serverConnected;
    if (serverDisconnected != null)
      result.serverDisconnected = serverDisconnected;
    if (newBlock != null) result.newBlock = newBlock;
    if (newTx != null) result.newTx = newTx;
    if (assetDetails != null) result.assetDetails = assetDetails;
    if (localMessage != null) result.localMessage = localMessage;
    if (portfolioPrices != null) result.portfolioPrices = portfolioPrices;
    if (conversionRates != null) result.conversionRates = conversionRates;
    if (jadePorts != null) result.jadePorts = jadePorts;
    if (jadeUnlock != null) result.jadeUnlock = jadeUnlock;
    if (jadeVerifyAddress != null) result.jadeVerifyAddress = jadeVerifyAddress;
    if (jadeStatus != null) result.jadeStatus = jadeStatus;
    if (gaidStatus != null) result.gaidStatus = gaidStatus;
    if (marketList != null) result.marketList = marketList;
    if (marketAdded != null) result.marketAdded = marketAdded;
    if (marketRemoved != null) result.marketRemoved = marketRemoved;
    if (publicOrders != null) result.publicOrders = publicOrders;
    if (publicOrderCreated != null)
      result.publicOrderCreated = publicOrderCreated;
    if (publicOrderRemoved != null)
      result.publicOrderRemoved = publicOrderRemoved;
    if (marketPrice != null) result.marketPrice = marketPrice;
    if (minMarketAmounts != null) result.minMarketAmounts = minMarketAmounts;
    if (ownOrders != null) result.ownOrders = ownOrders;
    if (ownOrderCreated != null) result.ownOrderCreated = ownOrderCreated;
    if (ownOrderRemoved != null) result.ownOrderRemoved = ownOrderRemoved;
    if (orderSubmit != null) result.orderSubmit = orderSubmit;
    if (orderEdit != null) result.orderEdit = orderEdit;
    if (orderCancel != null) result.orderCancel = orderCancel;
    if (quote != null) result.quote = quote;
    if (acceptQuote != null) result.acceptQuote = acceptQuote;
    if (startOrder != null) result.startOrder = startOrder;
    if (chartsSubscribe != null) result.chartsSubscribe = chartsSubscribe;
    if (chartsUpdate != null) result.chartsUpdate = chartsUpdate;
    if (loadHistory != null) result.loadHistory = loadHistory;
    if (historyUpdated != null) result.historyUpdated = historyUpdated;
    if (signerRequest != null) result.signerRequest = signerRequest;
    if (signerReturn != null) result.signerReturn = signerReturn;
    if (signerCancel != null) result.signerCancel = signerCancel;
    if (sessionList != null) result.sessionList = sessionList;
    if (sessionAdded != null) result.sessionAdded = sessionAdded;
    if (sessionRemoved != null) result.sessionRemoved = sessionRemoved;
    return result;
  }

  From._();

  factory From.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory From.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, From_Msg> _From_MsgByTag = {
    1: From_Msg.updatedTxs,
    2: From_Msg.updatedPegs,
    3: From_Msg.newAsset,
    4: From_Msg.balanceUpdate,
    5: From_Msg.serverStatus,
    6: From_Msg.priceUpdate,
    7: From_Msg.walletLoaded,
    8: From_Msg.registerAmp,
    9: From_Msg.ampAssets,
    10: From_Msg.encryptPin,
    11: From_Msg.decryptPin,
    12: From_Msg.removedTxs,
    13: From_Msg.envSettings,
    14: From_Msg.syncComplete,
    15: From_Msg.subscribedValue,
    16: From_Msg.logout,
    17: From_Msg.login,
    21: From_Msg.peginWaitTx,
    22: From_Msg.swapSucceed,
    23: From_Msg.swapFailed,
    24: From_Msg.pegOutAmount,
    25: From_Msg.pegEdit,
    30: From_Msg.recvAddress,
    31: From_Msg.createTxResult,
    32: From_Msg.sendResult,
    33: From_Msg.blindedValues,
    35: From_Msg.loadUtxos,
    36: From_Msg.loadAddresses,
    37: From_Msg.loadTransactions,
    38: From_Msg.showTransaction,
    50: From_Msg.showMessage,
    55: From_Msg.insufficientFunds,
    60: From_Msg.serverConnected,
    61: From_Msg.serverDisconnected,
    62: From_Msg.newBlock,
    63: From_Msg.newTx,
    65: From_Msg.assetDetails,
    68: From_Msg.localMessage,
    72: From_Msg.portfolioPrices,
    73: From_Msg.conversionRates,
    80: From_Msg.jadePorts,
    81: From_Msg.jadeUnlock,
    82: From_Msg.jadeVerifyAddress,
    83: From_Msg.jadeStatus,
    91: From_Msg.gaidStatus,
    100: From_Msg.marketList,
    101: From_Msg.marketAdded,
    102: From_Msg.marketRemoved,
    105: From_Msg.publicOrders,
    106: From_Msg.publicOrderCreated,
    107: From_Msg.publicOrderRemoved,
    110: From_Msg.marketPrice,
    119: From_Msg.minMarketAmounts,
    120: From_Msg.ownOrders,
    121: From_Msg.ownOrderCreated,
    122: From_Msg.ownOrderRemoved,
    130: From_Msg.orderSubmit,
    131: From_Msg.orderEdit,
    132: From_Msg.orderCancel,
    140: From_Msg.quote,
    141: From_Msg.acceptQuote,
    142: From_Msg.startOrder,
    150: From_Msg.chartsSubscribe,
    151: From_Msg.chartsUpdate,
    160: From_Msg.loadHistory,
    161: From_Msg.historyUpdated,
    170: From_Msg.signerRequest,
    171: From_Msg.signerReturn,
    172: From_Msg.signerCancel,
    180: From_Msg.sessionList,
    181: From_Msg.sessionAdded,
    182: From_Msg.sessionRemoved,
    0: From_Msg.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'From',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..oo(0, [
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8,
      9,
      10,
      11,
      12,
      13,
      14,
      15,
      16,
      17,
      21,
      22,
      23,
      24,
      25,
      30,
      31,
      32,
      33,
      35,
      36,
      37,
      38,
      50,
      55,
      60,
      61,
      62,
      63,
      65,
      68,
      72,
      73,
      80,
      81,
      82,
      83,
      91,
      100,
      101,
      102,
      105,
      106,
      107,
      110,
      119,
      120,
      121,
      122,
      130,
      131,
      132,
      140,
      141,
      142,
      150,
      151,
      160,
      161,
      170,
      171,
      172,
      180,
      181,
      182
    ])
    ..aOM<From_UpdatedTxs>(1, _omitFieldNames ? '' : 'updatedTxs',
        subBuilder: From_UpdatedTxs.create)
    ..aOM<From_UpdatedPegs>(2, _omitFieldNames ? '' : 'updatedPegs',
        subBuilder: From_UpdatedPegs.create)
    ..aOM<Asset>(3, _omitFieldNames ? '' : 'newAsset', subBuilder: Asset.create)
    ..aOM<From_BalanceUpdate>(4, _omitFieldNames ? '' : 'balanceUpdate',
        subBuilder: From_BalanceUpdate.create)
    ..aOM<ServerStatus>(5, _omitFieldNames ? '' : 'serverStatus',
        subBuilder: ServerStatus.create)
    ..aOM<From_PriceUpdate>(6, _omitFieldNames ? '' : 'priceUpdate',
        subBuilder: From_PriceUpdate.create)
    ..aOM<Empty>(7, _omitFieldNames ? '' : 'walletLoaded',
        subBuilder: Empty.create)
    ..aOM<From_RegisterAmp>(8, _omitFieldNames ? '' : 'registerAmp',
        subBuilder: From_RegisterAmp.create)
    ..aOM<From_AmpAssets>(9, _omitFieldNames ? '' : 'ampAssets',
        subBuilder: From_AmpAssets.create)
    ..aOM<From_EncryptPin>(10, _omitFieldNames ? '' : 'encryptPin',
        subBuilder: From_EncryptPin.create)
    ..aOM<From_DecryptPin>(11, _omitFieldNames ? '' : 'decryptPin',
        subBuilder: From_DecryptPin.create)
    ..aOM<From_RemovedTxs>(12, _omitFieldNames ? '' : 'removedTxs',
        subBuilder: From_RemovedTxs.create)
    ..aOM<From_EnvSettings>(13, _omitFieldNames ? '' : 'envSettings',
        subBuilder: From_EnvSettings.create)
    ..aOM<Empty>(14, _omitFieldNames ? '' : 'syncComplete',
        subBuilder: Empty.create)
    ..aOM<From_SubscribedValue>(15, _omitFieldNames ? '' : 'subscribedValue',
        subBuilder: From_SubscribedValue.create)
    ..aOM<Empty>(16, _omitFieldNames ? '' : 'logout', subBuilder: Empty.create)
    ..aOM<From_Login>(17, _omitFieldNames ? '' : 'login',
        subBuilder: From_Login.create)
    ..aOM<From_PeginWaitTx>(21, _omitFieldNames ? '' : 'peginWaitTx',
        subBuilder: From_PeginWaitTx.create)
    ..aOM<TransItem>(22, _omitFieldNames ? '' : 'swapSucceed',
        subBuilder: TransItem.create)
    ..aOS(23, _omitFieldNames ? '' : 'swapFailed')
    ..aOM<From_PegOutAmount>(24, _omitFieldNames ? '' : 'pegOutAmount',
        subBuilder: From_PegOutAmount.create)
    ..aOM<GenericResponse>(25, _omitFieldNames ? '' : 'pegEdit',
        subBuilder: GenericResponse.create)
    ..aOM<From_RecvAddress>(30, _omitFieldNames ? '' : 'recvAddress',
        subBuilder: From_RecvAddress.create)
    ..aOM<From_CreateTxResult>(31, _omitFieldNames ? '' : 'createTxResult',
        subBuilder: From_CreateTxResult.create)
    ..aOM<From_SendResult>(32, _omitFieldNames ? '' : 'sendResult',
        subBuilder: From_SendResult.create)
    ..aOM<From_BlindedValues>(33, _omitFieldNames ? '' : 'blindedValues',
        subBuilder: From_BlindedValues.create)
    ..aOM<From_LoadUtxos>(35, _omitFieldNames ? '' : 'loadUtxos',
        subBuilder: From_LoadUtxos.create)
    ..aOM<From_LoadAddresses>(36, _omitFieldNames ? '' : 'loadAddresses',
        subBuilder: From_LoadAddresses.create)
    ..aOM<From_LoadTransactions>(37, _omitFieldNames ? '' : 'loadTransactions',
        subBuilder: From_LoadTransactions.create)
    ..aOM<From_ShowTransaction>(38, _omitFieldNames ? '' : 'showTransaction',
        subBuilder: From_ShowTransaction.create)
    ..aOM<From_ShowMessage>(50, _omitFieldNames ? '' : 'showMessage',
        subBuilder: From_ShowMessage.create)
    ..aOM<From_ShowInsufficientFunds>(
        55, _omitFieldNames ? '' : 'insufficientFunds',
        subBuilder: From_ShowInsufficientFunds.create)
    ..aOM<Empty>(60, _omitFieldNames ? '' : 'serverConnected',
        subBuilder: Empty.create)
    ..aOM<Empty>(61, _omitFieldNames ? '' : 'serverDisconnected',
        subBuilder: Empty.create)
    ..aOM<Empty>(62, _omitFieldNames ? '' : 'newBlock',
        subBuilder: Empty.create)
    ..aOM<Empty>(63, _omitFieldNames ? '' : 'newTx', subBuilder: Empty.create)
    ..aOM<From_AssetDetails>(65, _omitFieldNames ? '' : 'assetDetails',
        subBuilder: From_AssetDetails.create)
    ..aOM<From_LocalMessage>(68, _omitFieldNames ? '' : 'localMessage',
        subBuilder: From_LocalMessage.create)
    ..aOM<From_PortfolioPrices>(72, _omitFieldNames ? '' : 'portfolioPrices',
        subBuilder: From_PortfolioPrices.create)
    ..aOM<From_ConversionRates>(73, _omitFieldNames ? '' : 'conversionRates',
        subBuilder: From_ConversionRates.create)
    ..aOM<From_JadePorts>(80, _omitFieldNames ? '' : 'jadePorts',
        subBuilder: From_JadePorts.create)
    ..aOM<GenericResponse>(81, _omitFieldNames ? '' : 'jadeUnlock',
        subBuilder: GenericResponse.create)
    ..aOM<GenericResponse>(82, _omitFieldNames ? '' : 'jadeVerifyAddress',
        subBuilder: GenericResponse.create)
    ..aOM<From_JadeStatus>(83, _omitFieldNames ? '' : 'jadeStatus',
        subBuilder: From_JadeStatus.create)
    ..aOM<From_GaidStatus>(91, _omitFieldNames ? '' : 'gaidStatus',
        subBuilder: From_GaidStatus.create)
    ..aOM<From_MarketList>(100, _omitFieldNames ? '' : 'marketList',
        subBuilder: From_MarketList.create)
    ..aOM<MarketInfo>(101, _omitFieldNames ? '' : 'marketAdded',
        subBuilder: MarketInfo.create)
    ..aOM<AssetPair>(102, _omitFieldNames ? '' : 'marketRemoved',
        subBuilder: AssetPair.create)
    ..aOM<From_PublicOrders>(105, _omitFieldNames ? '' : 'publicOrders',
        subBuilder: From_PublicOrders.create)
    ..aOM<PublicOrder>(106, _omitFieldNames ? '' : 'publicOrderCreated',
        subBuilder: PublicOrder.create)
    ..aOM<OrderId>(107, _omitFieldNames ? '' : 'publicOrderRemoved',
        subBuilder: OrderId.create)
    ..aOM<From_MarketPrice>(110, _omitFieldNames ? '' : 'marketPrice',
        subBuilder: From_MarketPrice.create)
    ..aOM<From_MinMarketAmounts>(119, _omitFieldNames ? '' : 'minMarketAmounts',
        subBuilder: From_MinMarketAmounts.create)
    ..aOM<From_OwnOrders>(120, _omitFieldNames ? '' : 'ownOrders',
        subBuilder: From_OwnOrders.create)
    ..aOM<OwnOrder>(121, _omitFieldNames ? '' : 'ownOrderCreated',
        subBuilder: OwnOrder.create)
    ..aOM<OrderId>(122, _omitFieldNames ? '' : 'ownOrderRemoved',
        subBuilder: OrderId.create)
    ..aOM<From_OrderSubmit>(130, _omitFieldNames ? '' : 'orderSubmit',
        subBuilder: From_OrderSubmit.create)
    ..aOM<GenericResponse>(131, _omitFieldNames ? '' : 'orderEdit',
        subBuilder: GenericResponse.create)
    ..aOM<GenericResponse>(132, _omitFieldNames ? '' : 'orderCancel',
        subBuilder: GenericResponse.create)
    ..aOM<From_Quote>(140, _omitFieldNames ? '' : 'quote',
        subBuilder: From_Quote.create)
    ..aOM<From_AcceptQuote>(141, _omitFieldNames ? '' : 'acceptQuote',
        subBuilder: From_AcceptQuote.create)
    ..aOM<From_StartOrder>(142, _omitFieldNames ? '' : 'startOrder',
        subBuilder: From_StartOrder.create)
    ..aOM<From_ChartsSubscribe>(150, _omitFieldNames ? '' : 'chartsSubscribe',
        subBuilder: From_ChartsSubscribe.create)
    ..aOM<From_ChartsUpdate>(151, _omitFieldNames ? '' : 'chartsUpdate',
        subBuilder: From_ChartsUpdate.create)
    ..aOM<From_LoadHistory>(160, _omitFieldNames ? '' : 'loadHistory',
        subBuilder: From_LoadHistory.create)
    ..aOM<From_HistoryUpdated>(161, _omitFieldNames ? '' : 'historyUpdated',
        subBuilder: From_HistoryUpdated.create)
    ..aOM<From_SignerRequest>(170, _omitFieldNames ? '' : 'signerRequest',
        subBuilder: From_SignerRequest.create)
    ..aOM<Empty>(171, _omitFieldNames ? '' : 'signerReturn',
        subBuilder: Empty.create)
    ..aOM<From_SignerCancel>(172, _omitFieldNames ? '' : 'signerCancel',
        subBuilder: From_SignerCancel.create)
    ..aOM<From_SessionList>(180, _omitFieldNames ? '' : 'sessionList',
        subBuilder: From_SessionList.create)
    ..aOM<From_SessionAdded>(181, _omitFieldNames ? '' : 'sessionAdded',
        subBuilder: From_SessionAdded.create)
    ..aOM<From_SessionRemoved>(182, _omitFieldNames ? '' : 'sessionRemoved',
        subBuilder: From_SessionRemoved.create);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  From copyWith(void Function(From) updates) =>
      super.copyWith((message) => updates(message as From)) as From;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From create() => From._();
  @$core.override
  From createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static From getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From>(create);
  static From? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  @$pb.TagNumber(13)
  @$pb.TagNumber(14)
  @$pb.TagNumber(15)
  @$pb.TagNumber(16)
  @$pb.TagNumber(17)
  @$pb.TagNumber(21)
  @$pb.TagNumber(22)
  @$pb.TagNumber(23)
  @$pb.TagNumber(24)
  @$pb.TagNumber(25)
  @$pb.TagNumber(30)
  @$pb.TagNumber(31)
  @$pb.TagNumber(32)
  @$pb.TagNumber(33)
  @$pb.TagNumber(35)
  @$pb.TagNumber(36)
  @$pb.TagNumber(37)
  @$pb.TagNumber(38)
  @$pb.TagNumber(50)
  @$pb.TagNumber(55)
  @$pb.TagNumber(60)
  @$pb.TagNumber(61)
  @$pb.TagNumber(62)
  @$pb.TagNumber(63)
  @$pb.TagNumber(65)
  @$pb.TagNumber(68)
  @$pb.TagNumber(72)
  @$pb.TagNumber(73)
  @$pb.TagNumber(80)
  @$pb.TagNumber(81)
  @$pb.TagNumber(82)
  @$pb.TagNumber(83)
  @$pb.TagNumber(91)
  @$pb.TagNumber(100)
  @$pb.TagNumber(101)
  @$pb.TagNumber(102)
  @$pb.TagNumber(105)
  @$pb.TagNumber(106)
  @$pb.TagNumber(107)
  @$pb.TagNumber(110)
  @$pb.TagNumber(119)
  @$pb.TagNumber(120)
  @$pb.TagNumber(121)
  @$pb.TagNumber(122)
  @$pb.TagNumber(130)
  @$pb.TagNumber(131)
  @$pb.TagNumber(132)
  @$pb.TagNumber(140)
  @$pb.TagNumber(141)
  @$pb.TagNumber(142)
  @$pb.TagNumber(150)
  @$pb.TagNumber(151)
  @$pb.TagNumber(160)
  @$pb.TagNumber(161)
  @$pb.TagNumber(170)
  @$pb.TagNumber(171)
  @$pb.TagNumber(172)
  @$pb.TagNumber(180)
  @$pb.TagNumber(181)
  @$pb.TagNumber(182)
  From_Msg whichMsg() => _From_MsgByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  @$pb.TagNumber(13)
  @$pb.TagNumber(14)
  @$pb.TagNumber(15)
  @$pb.TagNumber(16)
  @$pb.TagNumber(17)
  @$pb.TagNumber(21)
  @$pb.TagNumber(22)
  @$pb.TagNumber(23)
  @$pb.TagNumber(24)
  @$pb.TagNumber(25)
  @$pb.TagNumber(30)
  @$pb.TagNumber(31)
  @$pb.TagNumber(32)
  @$pb.TagNumber(33)
  @$pb.TagNumber(35)
  @$pb.TagNumber(36)
  @$pb.TagNumber(37)
  @$pb.TagNumber(38)
  @$pb.TagNumber(50)
  @$pb.TagNumber(55)
  @$pb.TagNumber(60)
  @$pb.TagNumber(61)
  @$pb.TagNumber(62)
  @$pb.TagNumber(63)
  @$pb.TagNumber(65)
  @$pb.TagNumber(68)
  @$pb.TagNumber(72)
  @$pb.TagNumber(73)
  @$pb.TagNumber(80)
  @$pb.TagNumber(81)
  @$pb.TagNumber(82)
  @$pb.TagNumber(83)
  @$pb.TagNumber(91)
  @$pb.TagNumber(100)
  @$pb.TagNumber(101)
  @$pb.TagNumber(102)
  @$pb.TagNumber(105)
  @$pb.TagNumber(106)
  @$pb.TagNumber(107)
  @$pb.TagNumber(110)
  @$pb.TagNumber(119)
  @$pb.TagNumber(120)
  @$pb.TagNumber(121)
  @$pb.TagNumber(122)
  @$pb.TagNumber(130)
  @$pb.TagNumber(131)
  @$pb.TagNumber(132)
  @$pb.TagNumber(140)
  @$pb.TagNumber(141)
  @$pb.TagNumber(142)
  @$pb.TagNumber(150)
  @$pb.TagNumber(151)
  @$pb.TagNumber(160)
  @$pb.TagNumber(161)
  @$pb.TagNumber(170)
  @$pb.TagNumber(171)
  @$pb.TagNumber(172)
  @$pb.TagNumber(180)
  @$pb.TagNumber(181)
  @$pb.TagNumber(182)
  void clearMsg() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  From_UpdatedTxs get updatedTxs => $_getN(0);
  @$pb.TagNumber(1)
  set updatedTxs(From_UpdatedTxs value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasUpdatedTxs() => $_has(0);
  @$pb.TagNumber(1)
  void clearUpdatedTxs() => $_clearField(1);
  @$pb.TagNumber(1)
  From_UpdatedTxs ensureUpdatedTxs() => $_ensure(0);

  @$pb.TagNumber(2)
  From_UpdatedPegs get updatedPegs => $_getN(1);
  @$pb.TagNumber(2)
  set updatedPegs(From_UpdatedPegs value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasUpdatedPegs() => $_has(1);
  @$pb.TagNumber(2)
  void clearUpdatedPegs() => $_clearField(2);
  @$pb.TagNumber(2)
  From_UpdatedPegs ensureUpdatedPegs() => $_ensure(1);

  @$pb.TagNumber(3)
  Asset get newAsset => $_getN(2);
  @$pb.TagNumber(3)
  set newAsset(Asset value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasNewAsset() => $_has(2);
  @$pb.TagNumber(3)
  void clearNewAsset() => $_clearField(3);
  @$pb.TagNumber(3)
  Asset ensureNewAsset() => $_ensure(2);

  @$pb.TagNumber(4)
  From_BalanceUpdate get balanceUpdate => $_getN(3);
  @$pb.TagNumber(4)
  set balanceUpdate(From_BalanceUpdate value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasBalanceUpdate() => $_has(3);
  @$pb.TagNumber(4)
  void clearBalanceUpdate() => $_clearField(4);
  @$pb.TagNumber(4)
  From_BalanceUpdate ensureBalanceUpdate() => $_ensure(3);

  @$pb.TagNumber(5)
  ServerStatus get serverStatus => $_getN(4);
  @$pb.TagNumber(5)
  set serverStatus(ServerStatus value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasServerStatus() => $_has(4);
  @$pb.TagNumber(5)
  void clearServerStatus() => $_clearField(5);
  @$pb.TagNumber(5)
  ServerStatus ensureServerStatus() => $_ensure(4);

  @$pb.TagNumber(6)
  From_PriceUpdate get priceUpdate => $_getN(5);
  @$pb.TagNumber(6)
  set priceUpdate(From_PriceUpdate value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasPriceUpdate() => $_has(5);
  @$pb.TagNumber(6)
  void clearPriceUpdate() => $_clearField(6);
  @$pb.TagNumber(6)
  From_PriceUpdate ensurePriceUpdate() => $_ensure(5);

  @$pb.TagNumber(7)
  Empty get walletLoaded => $_getN(6);
  @$pb.TagNumber(7)
  set walletLoaded(Empty value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasWalletLoaded() => $_has(6);
  @$pb.TagNumber(7)
  void clearWalletLoaded() => $_clearField(7);
  @$pb.TagNumber(7)
  Empty ensureWalletLoaded() => $_ensure(6);

  @$pb.TagNumber(8)
  From_RegisterAmp get registerAmp => $_getN(7);
  @$pb.TagNumber(8)
  set registerAmp(From_RegisterAmp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasRegisterAmp() => $_has(7);
  @$pb.TagNumber(8)
  void clearRegisterAmp() => $_clearField(8);
  @$pb.TagNumber(8)
  From_RegisterAmp ensureRegisterAmp() => $_ensure(7);

  @$pb.TagNumber(9)
  From_AmpAssets get ampAssets => $_getN(8);
  @$pb.TagNumber(9)
  set ampAssets(From_AmpAssets value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasAmpAssets() => $_has(8);
  @$pb.TagNumber(9)
  void clearAmpAssets() => $_clearField(9);
  @$pb.TagNumber(9)
  From_AmpAssets ensureAmpAssets() => $_ensure(8);

  @$pb.TagNumber(10)
  From_EncryptPin get encryptPin => $_getN(9);
  @$pb.TagNumber(10)
  set encryptPin(From_EncryptPin value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasEncryptPin() => $_has(9);
  @$pb.TagNumber(10)
  void clearEncryptPin() => $_clearField(10);
  @$pb.TagNumber(10)
  From_EncryptPin ensureEncryptPin() => $_ensure(9);

  @$pb.TagNumber(11)
  From_DecryptPin get decryptPin => $_getN(10);
  @$pb.TagNumber(11)
  set decryptPin(From_DecryptPin value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasDecryptPin() => $_has(10);
  @$pb.TagNumber(11)
  void clearDecryptPin() => $_clearField(11);
  @$pb.TagNumber(11)
  From_DecryptPin ensureDecryptPin() => $_ensure(10);

  @$pb.TagNumber(12)
  From_RemovedTxs get removedTxs => $_getN(11);
  @$pb.TagNumber(12)
  set removedTxs(From_RemovedTxs value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasRemovedTxs() => $_has(11);
  @$pb.TagNumber(12)
  void clearRemovedTxs() => $_clearField(12);
  @$pb.TagNumber(12)
  From_RemovedTxs ensureRemovedTxs() => $_ensure(11);

  @$pb.TagNumber(13)
  From_EnvSettings get envSettings => $_getN(12);
  @$pb.TagNumber(13)
  set envSettings(From_EnvSettings value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasEnvSettings() => $_has(12);
  @$pb.TagNumber(13)
  void clearEnvSettings() => $_clearField(13);
  @$pb.TagNumber(13)
  From_EnvSettings ensureEnvSettings() => $_ensure(12);

  @$pb.TagNumber(14)
  Empty get syncComplete => $_getN(13);
  @$pb.TagNumber(14)
  set syncComplete(Empty value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasSyncComplete() => $_has(13);
  @$pb.TagNumber(14)
  void clearSyncComplete() => $_clearField(14);
  @$pb.TagNumber(14)
  Empty ensureSyncComplete() => $_ensure(13);

  @$pb.TagNumber(15)
  From_SubscribedValue get subscribedValue => $_getN(14);
  @$pb.TagNumber(15)
  set subscribedValue(From_SubscribedValue value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasSubscribedValue() => $_has(14);
  @$pb.TagNumber(15)
  void clearSubscribedValue() => $_clearField(15);
  @$pb.TagNumber(15)
  From_SubscribedValue ensureSubscribedValue() => $_ensure(14);

  @$pb.TagNumber(16)
  Empty get logout => $_getN(15);
  @$pb.TagNumber(16)
  set logout(Empty value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasLogout() => $_has(15);
  @$pb.TagNumber(16)
  void clearLogout() => $_clearField(16);
  @$pb.TagNumber(16)
  Empty ensureLogout() => $_ensure(15);

  @$pb.TagNumber(17)
  From_Login get login => $_getN(16);
  @$pb.TagNumber(17)
  set login(From_Login value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasLogin() => $_has(16);
  @$pb.TagNumber(17)
  void clearLogin() => $_clearField(17);
  @$pb.TagNumber(17)
  From_Login ensureLogin() => $_ensure(16);

  @$pb.TagNumber(21)
  From_PeginWaitTx get peginWaitTx => $_getN(17);
  @$pb.TagNumber(21)
  set peginWaitTx(From_PeginWaitTx value) => $_setField(21, value);
  @$pb.TagNumber(21)
  $core.bool hasPeginWaitTx() => $_has(17);
  @$pb.TagNumber(21)
  void clearPeginWaitTx() => $_clearField(21);
  @$pb.TagNumber(21)
  From_PeginWaitTx ensurePeginWaitTx() => $_ensure(17);

  @$pb.TagNumber(22)
  TransItem get swapSucceed => $_getN(18);
  @$pb.TagNumber(22)
  set swapSucceed(TransItem value) => $_setField(22, value);
  @$pb.TagNumber(22)
  $core.bool hasSwapSucceed() => $_has(18);
  @$pb.TagNumber(22)
  void clearSwapSucceed() => $_clearField(22);
  @$pb.TagNumber(22)
  TransItem ensureSwapSucceed() => $_ensure(18);

  @$pb.TagNumber(23)
  $core.String get swapFailed => $_getSZ(19);
  @$pb.TagNumber(23)
  set swapFailed($core.String value) => $_setString(19, value);
  @$pb.TagNumber(23)
  $core.bool hasSwapFailed() => $_has(19);
  @$pb.TagNumber(23)
  void clearSwapFailed() => $_clearField(23);

  @$pb.TagNumber(24)
  From_PegOutAmount get pegOutAmount => $_getN(20);
  @$pb.TagNumber(24)
  set pegOutAmount(From_PegOutAmount value) => $_setField(24, value);
  @$pb.TagNumber(24)
  $core.bool hasPegOutAmount() => $_has(20);
  @$pb.TagNumber(24)
  void clearPegOutAmount() => $_clearField(24);
  @$pb.TagNumber(24)
  From_PegOutAmount ensurePegOutAmount() => $_ensure(20);

  @$pb.TagNumber(25)
  GenericResponse get pegEdit => $_getN(21);
  @$pb.TagNumber(25)
  set pegEdit(GenericResponse value) => $_setField(25, value);
  @$pb.TagNumber(25)
  $core.bool hasPegEdit() => $_has(21);
  @$pb.TagNumber(25)
  void clearPegEdit() => $_clearField(25);
  @$pb.TagNumber(25)
  GenericResponse ensurePegEdit() => $_ensure(21);

  @$pb.TagNumber(30)
  From_RecvAddress get recvAddress => $_getN(22);
  @$pb.TagNumber(30)
  set recvAddress(From_RecvAddress value) => $_setField(30, value);
  @$pb.TagNumber(30)
  $core.bool hasRecvAddress() => $_has(22);
  @$pb.TagNumber(30)
  void clearRecvAddress() => $_clearField(30);
  @$pb.TagNumber(30)
  From_RecvAddress ensureRecvAddress() => $_ensure(22);

  @$pb.TagNumber(31)
  From_CreateTxResult get createTxResult => $_getN(23);
  @$pb.TagNumber(31)
  set createTxResult(From_CreateTxResult value) => $_setField(31, value);
  @$pb.TagNumber(31)
  $core.bool hasCreateTxResult() => $_has(23);
  @$pb.TagNumber(31)
  void clearCreateTxResult() => $_clearField(31);
  @$pb.TagNumber(31)
  From_CreateTxResult ensureCreateTxResult() => $_ensure(23);

  @$pb.TagNumber(32)
  From_SendResult get sendResult => $_getN(24);
  @$pb.TagNumber(32)
  set sendResult(From_SendResult value) => $_setField(32, value);
  @$pb.TagNumber(32)
  $core.bool hasSendResult() => $_has(24);
  @$pb.TagNumber(32)
  void clearSendResult() => $_clearField(32);
  @$pb.TagNumber(32)
  From_SendResult ensureSendResult() => $_ensure(24);

  @$pb.TagNumber(33)
  From_BlindedValues get blindedValues => $_getN(25);
  @$pb.TagNumber(33)
  set blindedValues(From_BlindedValues value) => $_setField(33, value);
  @$pb.TagNumber(33)
  $core.bool hasBlindedValues() => $_has(25);
  @$pb.TagNumber(33)
  void clearBlindedValues() => $_clearField(33);
  @$pb.TagNumber(33)
  From_BlindedValues ensureBlindedValues() => $_ensure(25);

  @$pb.TagNumber(35)
  From_LoadUtxos get loadUtxos => $_getN(26);
  @$pb.TagNumber(35)
  set loadUtxos(From_LoadUtxos value) => $_setField(35, value);
  @$pb.TagNumber(35)
  $core.bool hasLoadUtxos() => $_has(26);
  @$pb.TagNumber(35)
  void clearLoadUtxos() => $_clearField(35);
  @$pb.TagNumber(35)
  From_LoadUtxos ensureLoadUtxos() => $_ensure(26);

  @$pb.TagNumber(36)
  From_LoadAddresses get loadAddresses => $_getN(27);
  @$pb.TagNumber(36)
  set loadAddresses(From_LoadAddresses value) => $_setField(36, value);
  @$pb.TagNumber(36)
  $core.bool hasLoadAddresses() => $_has(27);
  @$pb.TagNumber(36)
  void clearLoadAddresses() => $_clearField(36);
  @$pb.TagNumber(36)
  From_LoadAddresses ensureLoadAddresses() => $_ensure(27);

  @$pb.TagNumber(37)
  From_LoadTransactions get loadTransactions => $_getN(28);
  @$pb.TagNumber(37)
  set loadTransactions(From_LoadTransactions value) => $_setField(37, value);
  @$pb.TagNumber(37)
  $core.bool hasLoadTransactions() => $_has(28);
  @$pb.TagNumber(37)
  void clearLoadTransactions() => $_clearField(37);
  @$pb.TagNumber(37)
  From_LoadTransactions ensureLoadTransactions() => $_ensure(28);

  @$pb.TagNumber(38)
  From_ShowTransaction get showTransaction => $_getN(29);
  @$pb.TagNumber(38)
  set showTransaction(From_ShowTransaction value) => $_setField(38, value);
  @$pb.TagNumber(38)
  $core.bool hasShowTransaction() => $_has(29);
  @$pb.TagNumber(38)
  void clearShowTransaction() => $_clearField(38);
  @$pb.TagNumber(38)
  From_ShowTransaction ensureShowTransaction() => $_ensure(29);

  @$pb.TagNumber(50)
  From_ShowMessage get showMessage => $_getN(30);
  @$pb.TagNumber(50)
  set showMessage(From_ShowMessage value) => $_setField(50, value);
  @$pb.TagNumber(50)
  $core.bool hasShowMessage() => $_has(30);
  @$pb.TagNumber(50)
  void clearShowMessage() => $_clearField(50);
  @$pb.TagNumber(50)
  From_ShowMessage ensureShowMessage() => $_ensure(30);

  @$pb.TagNumber(55)
  From_ShowInsufficientFunds get insufficientFunds => $_getN(31);
  @$pb.TagNumber(55)
  set insufficientFunds(From_ShowInsufficientFunds value) =>
      $_setField(55, value);
  @$pb.TagNumber(55)
  $core.bool hasInsufficientFunds() => $_has(31);
  @$pb.TagNumber(55)
  void clearInsufficientFunds() => $_clearField(55);
  @$pb.TagNumber(55)
  From_ShowInsufficientFunds ensureInsufficientFunds() => $_ensure(31);

  @$pb.TagNumber(60)
  Empty get serverConnected => $_getN(32);
  @$pb.TagNumber(60)
  set serverConnected(Empty value) => $_setField(60, value);
  @$pb.TagNumber(60)
  $core.bool hasServerConnected() => $_has(32);
  @$pb.TagNumber(60)
  void clearServerConnected() => $_clearField(60);
  @$pb.TagNumber(60)
  Empty ensureServerConnected() => $_ensure(32);

  @$pb.TagNumber(61)
  Empty get serverDisconnected => $_getN(33);
  @$pb.TagNumber(61)
  set serverDisconnected(Empty value) => $_setField(61, value);
  @$pb.TagNumber(61)
  $core.bool hasServerDisconnected() => $_has(33);
  @$pb.TagNumber(61)
  void clearServerDisconnected() => $_clearField(61);
  @$pb.TagNumber(61)
  Empty ensureServerDisconnected() => $_ensure(33);

  @$pb.TagNumber(62)
  Empty get newBlock => $_getN(34);
  @$pb.TagNumber(62)
  set newBlock(Empty value) => $_setField(62, value);
  @$pb.TagNumber(62)
  $core.bool hasNewBlock() => $_has(34);
  @$pb.TagNumber(62)
  void clearNewBlock() => $_clearField(62);
  @$pb.TagNumber(62)
  Empty ensureNewBlock() => $_ensure(34);

  @$pb.TagNumber(63)
  Empty get newTx => $_getN(35);
  @$pb.TagNumber(63)
  set newTx(Empty value) => $_setField(63, value);
  @$pb.TagNumber(63)
  $core.bool hasNewTx() => $_has(35);
  @$pb.TagNumber(63)
  void clearNewTx() => $_clearField(63);
  @$pb.TagNumber(63)
  Empty ensureNewTx() => $_ensure(35);

  @$pb.TagNumber(65)
  From_AssetDetails get assetDetails => $_getN(36);
  @$pb.TagNumber(65)
  set assetDetails(From_AssetDetails value) => $_setField(65, value);
  @$pb.TagNumber(65)
  $core.bool hasAssetDetails() => $_has(36);
  @$pb.TagNumber(65)
  void clearAssetDetails() => $_clearField(65);
  @$pb.TagNumber(65)
  From_AssetDetails ensureAssetDetails() => $_ensure(36);

  @$pb.TagNumber(68)
  From_LocalMessage get localMessage => $_getN(37);
  @$pb.TagNumber(68)
  set localMessage(From_LocalMessage value) => $_setField(68, value);
  @$pb.TagNumber(68)
  $core.bool hasLocalMessage() => $_has(37);
  @$pb.TagNumber(68)
  void clearLocalMessage() => $_clearField(68);
  @$pb.TagNumber(68)
  From_LocalMessage ensureLocalMessage() => $_ensure(37);

  @$pb.TagNumber(72)
  From_PortfolioPrices get portfolioPrices => $_getN(38);
  @$pb.TagNumber(72)
  set portfolioPrices(From_PortfolioPrices value) => $_setField(72, value);
  @$pb.TagNumber(72)
  $core.bool hasPortfolioPrices() => $_has(38);
  @$pb.TagNumber(72)
  void clearPortfolioPrices() => $_clearField(72);
  @$pb.TagNumber(72)
  From_PortfolioPrices ensurePortfolioPrices() => $_ensure(38);

  @$pb.TagNumber(73)
  From_ConversionRates get conversionRates => $_getN(39);
  @$pb.TagNumber(73)
  set conversionRates(From_ConversionRates value) => $_setField(73, value);
  @$pb.TagNumber(73)
  $core.bool hasConversionRates() => $_has(39);
  @$pb.TagNumber(73)
  void clearConversionRates() => $_clearField(73);
  @$pb.TagNumber(73)
  From_ConversionRates ensureConversionRates() => $_ensure(39);

  @$pb.TagNumber(80)
  From_JadePorts get jadePorts => $_getN(40);
  @$pb.TagNumber(80)
  set jadePorts(From_JadePorts value) => $_setField(80, value);
  @$pb.TagNumber(80)
  $core.bool hasJadePorts() => $_has(40);
  @$pb.TagNumber(80)
  void clearJadePorts() => $_clearField(80);
  @$pb.TagNumber(80)
  From_JadePorts ensureJadePorts() => $_ensure(40);

  @$pb.TagNumber(81)
  GenericResponse get jadeUnlock => $_getN(41);
  @$pb.TagNumber(81)
  set jadeUnlock(GenericResponse value) => $_setField(81, value);
  @$pb.TagNumber(81)
  $core.bool hasJadeUnlock() => $_has(41);
  @$pb.TagNumber(81)
  void clearJadeUnlock() => $_clearField(81);
  @$pb.TagNumber(81)
  GenericResponse ensureJadeUnlock() => $_ensure(41);

  @$pb.TagNumber(82)
  GenericResponse get jadeVerifyAddress => $_getN(42);
  @$pb.TagNumber(82)
  set jadeVerifyAddress(GenericResponse value) => $_setField(82, value);
  @$pb.TagNumber(82)
  $core.bool hasJadeVerifyAddress() => $_has(42);
  @$pb.TagNumber(82)
  void clearJadeVerifyAddress() => $_clearField(82);
  @$pb.TagNumber(82)
  GenericResponse ensureJadeVerifyAddress() => $_ensure(42);

  @$pb.TagNumber(83)
  From_JadeStatus get jadeStatus => $_getN(43);
  @$pb.TagNumber(83)
  set jadeStatus(From_JadeStatus value) => $_setField(83, value);
  @$pb.TagNumber(83)
  $core.bool hasJadeStatus() => $_has(43);
  @$pb.TagNumber(83)
  void clearJadeStatus() => $_clearField(83);
  @$pb.TagNumber(83)
  From_JadeStatus ensureJadeStatus() => $_ensure(43);

  @$pb.TagNumber(91)
  From_GaidStatus get gaidStatus => $_getN(44);
  @$pb.TagNumber(91)
  set gaidStatus(From_GaidStatus value) => $_setField(91, value);
  @$pb.TagNumber(91)
  $core.bool hasGaidStatus() => $_has(44);
  @$pb.TagNumber(91)
  void clearGaidStatus() => $_clearField(91);
  @$pb.TagNumber(91)
  From_GaidStatus ensureGaidStatus() => $_ensure(44);

  @$pb.TagNumber(100)
  From_MarketList get marketList => $_getN(45);
  @$pb.TagNumber(100)
  set marketList(From_MarketList value) => $_setField(100, value);
  @$pb.TagNumber(100)
  $core.bool hasMarketList() => $_has(45);
  @$pb.TagNumber(100)
  void clearMarketList() => $_clearField(100);
  @$pb.TagNumber(100)
  From_MarketList ensureMarketList() => $_ensure(45);

  @$pb.TagNumber(101)
  MarketInfo get marketAdded => $_getN(46);
  @$pb.TagNumber(101)
  set marketAdded(MarketInfo value) => $_setField(101, value);
  @$pb.TagNumber(101)
  $core.bool hasMarketAdded() => $_has(46);
  @$pb.TagNumber(101)
  void clearMarketAdded() => $_clearField(101);
  @$pb.TagNumber(101)
  MarketInfo ensureMarketAdded() => $_ensure(46);

  @$pb.TagNumber(102)
  AssetPair get marketRemoved => $_getN(47);
  @$pb.TagNumber(102)
  set marketRemoved(AssetPair value) => $_setField(102, value);
  @$pb.TagNumber(102)
  $core.bool hasMarketRemoved() => $_has(47);
  @$pb.TagNumber(102)
  void clearMarketRemoved() => $_clearField(102);
  @$pb.TagNumber(102)
  AssetPair ensureMarketRemoved() => $_ensure(47);

  @$pb.TagNumber(105)
  From_PublicOrders get publicOrders => $_getN(48);
  @$pb.TagNumber(105)
  set publicOrders(From_PublicOrders value) => $_setField(105, value);
  @$pb.TagNumber(105)
  $core.bool hasPublicOrders() => $_has(48);
  @$pb.TagNumber(105)
  void clearPublicOrders() => $_clearField(105);
  @$pb.TagNumber(105)
  From_PublicOrders ensurePublicOrders() => $_ensure(48);

  @$pb.TagNumber(106)
  PublicOrder get publicOrderCreated => $_getN(49);
  @$pb.TagNumber(106)
  set publicOrderCreated(PublicOrder value) => $_setField(106, value);
  @$pb.TagNumber(106)
  $core.bool hasPublicOrderCreated() => $_has(49);
  @$pb.TagNumber(106)
  void clearPublicOrderCreated() => $_clearField(106);
  @$pb.TagNumber(106)
  PublicOrder ensurePublicOrderCreated() => $_ensure(49);

  @$pb.TagNumber(107)
  OrderId get publicOrderRemoved => $_getN(50);
  @$pb.TagNumber(107)
  set publicOrderRemoved(OrderId value) => $_setField(107, value);
  @$pb.TagNumber(107)
  $core.bool hasPublicOrderRemoved() => $_has(50);
  @$pb.TagNumber(107)
  void clearPublicOrderRemoved() => $_clearField(107);
  @$pb.TagNumber(107)
  OrderId ensurePublicOrderRemoved() => $_ensure(50);

  @$pb.TagNumber(110)
  From_MarketPrice get marketPrice => $_getN(51);
  @$pb.TagNumber(110)
  set marketPrice(From_MarketPrice value) => $_setField(110, value);
  @$pb.TagNumber(110)
  $core.bool hasMarketPrice() => $_has(51);
  @$pb.TagNumber(110)
  void clearMarketPrice() => $_clearField(110);
  @$pb.TagNumber(110)
  From_MarketPrice ensureMarketPrice() => $_ensure(51);

  @$pb.TagNumber(119)
  From_MinMarketAmounts get minMarketAmounts => $_getN(52);
  @$pb.TagNumber(119)
  set minMarketAmounts(From_MinMarketAmounts value) => $_setField(119, value);
  @$pb.TagNumber(119)
  $core.bool hasMinMarketAmounts() => $_has(52);
  @$pb.TagNumber(119)
  void clearMinMarketAmounts() => $_clearField(119);
  @$pb.TagNumber(119)
  From_MinMarketAmounts ensureMinMarketAmounts() => $_ensure(52);

  @$pb.TagNumber(120)
  From_OwnOrders get ownOrders => $_getN(53);
  @$pb.TagNumber(120)
  set ownOrders(From_OwnOrders value) => $_setField(120, value);
  @$pb.TagNumber(120)
  $core.bool hasOwnOrders() => $_has(53);
  @$pb.TagNumber(120)
  void clearOwnOrders() => $_clearField(120);
  @$pb.TagNumber(120)
  From_OwnOrders ensureOwnOrders() => $_ensure(53);

  @$pb.TagNumber(121)
  OwnOrder get ownOrderCreated => $_getN(54);
  @$pb.TagNumber(121)
  set ownOrderCreated(OwnOrder value) => $_setField(121, value);
  @$pb.TagNumber(121)
  $core.bool hasOwnOrderCreated() => $_has(54);
  @$pb.TagNumber(121)
  void clearOwnOrderCreated() => $_clearField(121);
  @$pb.TagNumber(121)
  OwnOrder ensureOwnOrderCreated() => $_ensure(54);

  @$pb.TagNumber(122)
  OrderId get ownOrderRemoved => $_getN(55);
  @$pb.TagNumber(122)
  set ownOrderRemoved(OrderId value) => $_setField(122, value);
  @$pb.TagNumber(122)
  $core.bool hasOwnOrderRemoved() => $_has(55);
  @$pb.TagNumber(122)
  void clearOwnOrderRemoved() => $_clearField(122);
  @$pb.TagNumber(122)
  OrderId ensureOwnOrderRemoved() => $_ensure(55);

  @$pb.TagNumber(130)
  From_OrderSubmit get orderSubmit => $_getN(56);
  @$pb.TagNumber(130)
  set orderSubmit(From_OrderSubmit value) => $_setField(130, value);
  @$pb.TagNumber(130)
  $core.bool hasOrderSubmit() => $_has(56);
  @$pb.TagNumber(130)
  void clearOrderSubmit() => $_clearField(130);
  @$pb.TagNumber(130)
  From_OrderSubmit ensureOrderSubmit() => $_ensure(56);

  @$pb.TagNumber(131)
  GenericResponse get orderEdit => $_getN(57);
  @$pb.TagNumber(131)
  set orderEdit(GenericResponse value) => $_setField(131, value);
  @$pb.TagNumber(131)
  $core.bool hasOrderEdit() => $_has(57);
  @$pb.TagNumber(131)
  void clearOrderEdit() => $_clearField(131);
  @$pb.TagNumber(131)
  GenericResponse ensureOrderEdit() => $_ensure(57);

  @$pb.TagNumber(132)
  GenericResponse get orderCancel => $_getN(58);
  @$pb.TagNumber(132)
  set orderCancel(GenericResponse value) => $_setField(132, value);
  @$pb.TagNumber(132)
  $core.bool hasOrderCancel() => $_has(58);
  @$pb.TagNumber(132)
  void clearOrderCancel() => $_clearField(132);
  @$pb.TagNumber(132)
  GenericResponse ensureOrderCancel() => $_ensure(58);

  @$pb.TagNumber(140)
  From_Quote get quote => $_getN(59);
  @$pb.TagNumber(140)
  set quote(From_Quote value) => $_setField(140, value);
  @$pb.TagNumber(140)
  $core.bool hasQuote() => $_has(59);
  @$pb.TagNumber(140)
  void clearQuote() => $_clearField(140);
  @$pb.TagNumber(140)
  From_Quote ensureQuote() => $_ensure(59);

  @$pb.TagNumber(141)
  From_AcceptQuote get acceptQuote => $_getN(60);
  @$pb.TagNumber(141)
  set acceptQuote(From_AcceptQuote value) => $_setField(141, value);
  @$pb.TagNumber(141)
  $core.bool hasAcceptQuote() => $_has(60);
  @$pb.TagNumber(141)
  void clearAcceptQuote() => $_clearField(141);
  @$pb.TagNumber(141)
  From_AcceptQuote ensureAcceptQuote() => $_ensure(60);

  @$pb.TagNumber(142)
  From_StartOrder get startOrder => $_getN(61);
  @$pb.TagNumber(142)
  set startOrder(From_StartOrder value) => $_setField(142, value);
  @$pb.TagNumber(142)
  $core.bool hasStartOrder() => $_has(61);
  @$pb.TagNumber(142)
  void clearStartOrder() => $_clearField(142);
  @$pb.TagNumber(142)
  From_StartOrder ensureStartOrder() => $_ensure(61);

  @$pb.TagNumber(150)
  From_ChartsSubscribe get chartsSubscribe => $_getN(62);
  @$pb.TagNumber(150)
  set chartsSubscribe(From_ChartsSubscribe value) => $_setField(150, value);
  @$pb.TagNumber(150)
  $core.bool hasChartsSubscribe() => $_has(62);
  @$pb.TagNumber(150)
  void clearChartsSubscribe() => $_clearField(150);
  @$pb.TagNumber(150)
  From_ChartsSubscribe ensureChartsSubscribe() => $_ensure(62);

  @$pb.TagNumber(151)
  From_ChartsUpdate get chartsUpdate => $_getN(63);
  @$pb.TagNumber(151)
  set chartsUpdate(From_ChartsUpdate value) => $_setField(151, value);
  @$pb.TagNumber(151)
  $core.bool hasChartsUpdate() => $_has(63);
  @$pb.TagNumber(151)
  void clearChartsUpdate() => $_clearField(151);
  @$pb.TagNumber(151)
  From_ChartsUpdate ensureChartsUpdate() => $_ensure(63);

  @$pb.TagNumber(160)
  From_LoadHistory get loadHistory => $_getN(64);
  @$pb.TagNumber(160)
  set loadHistory(From_LoadHistory value) => $_setField(160, value);
  @$pb.TagNumber(160)
  $core.bool hasLoadHistory() => $_has(64);
  @$pb.TagNumber(160)
  void clearLoadHistory() => $_clearField(160);
  @$pb.TagNumber(160)
  From_LoadHistory ensureLoadHistory() => $_ensure(64);

  @$pb.TagNumber(161)
  From_HistoryUpdated get historyUpdated => $_getN(65);
  @$pb.TagNumber(161)
  set historyUpdated(From_HistoryUpdated value) => $_setField(161, value);
  @$pb.TagNumber(161)
  $core.bool hasHistoryUpdated() => $_has(65);
  @$pb.TagNumber(161)
  void clearHistoryUpdated() => $_clearField(161);
  @$pb.TagNumber(161)
  From_HistoryUpdated ensureHistoryUpdated() => $_ensure(65);

  @$pb.TagNumber(170)
  From_SignerRequest get signerRequest => $_getN(66);
  @$pb.TagNumber(170)
  set signerRequest(From_SignerRequest value) => $_setField(170, value);
  @$pb.TagNumber(170)
  $core.bool hasSignerRequest() => $_has(66);
  @$pb.TagNumber(170)
  void clearSignerRequest() => $_clearField(170);
  @$pb.TagNumber(170)
  From_SignerRequest ensureSignerRequest() => $_ensure(66);

  @$pb.TagNumber(171)
  Empty get signerReturn => $_getN(67);
  @$pb.TagNumber(171)
  set signerReturn(Empty value) => $_setField(171, value);
  @$pb.TagNumber(171)
  $core.bool hasSignerReturn() => $_has(67);
  @$pb.TagNumber(171)
  void clearSignerReturn() => $_clearField(171);
  @$pb.TagNumber(171)
  Empty ensureSignerReturn() => $_ensure(67);

  @$pb.TagNumber(172)
  From_SignerCancel get signerCancel => $_getN(68);
  @$pb.TagNumber(172)
  set signerCancel(From_SignerCancel value) => $_setField(172, value);
  @$pb.TagNumber(172)
  $core.bool hasSignerCancel() => $_has(68);
  @$pb.TagNumber(172)
  void clearSignerCancel() => $_clearField(172);
  @$pb.TagNumber(172)
  From_SignerCancel ensureSignerCancel() => $_ensure(68);

  @$pb.TagNumber(180)
  From_SessionList get sessionList => $_getN(69);
  @$pb.TagNumber(180)
  set sessionList(From_SessionList value) => $_setField(180, value);
  @$pb.TagNumber(180)
  $core.bool hasSessionList() => $_has(69);
  @$pb.TagNumber(180)
  void clearSessionList() => $_clearField(180);
  @$pb.TagNumber(180)
  From_SessionList ensureSessionList() => $_ensure(69);

  @$pb.TagNumber(181)
  From_SessionAdded get sessionAdded => $_getN(70);
  @$pb.TagNumber(181)
  set sessionAdded(From_SessionAdded value) => $_setField(181, value);
  @$pb.TagNumber(181)
  $core.bool hasSessionAdded() => $_has(70);
  @$pb.TagNumber(181)
  void clearSessionAdded() => $_clearField(181);
  @$pb.TagNumber(181)
  From_SessionAdded ensureSessionAdded() => $_ensure(70);

  @$pb.TagNumber(182)
  From_SessionRemoved get sessionRemoved => $_getN(71);
  @$pb.TagNumber(182)
  set sessionRemoved(From_SessionRemoved value) => $_setField(182, value);
  @$pb.TagNumber(182)
  $core.bool hasSessionRemoved() => $_has(71);
  @$pb.TagNumber(182)
  void clearSessionRemoved() => $_clearField(182);
  @$pb.TagNumber(182)
  From_SessionRemoved ensureSessionRemoved() => $_ensure(71);
}

class Settings_AccountAsset extends $pb.GeneratedMessage {
  factory Settings_AccountAsset({
    Account? account,
    $core.String? assetId,
  }) {
    final result = create();
    if (account != null) result.account = account;
    if (assetId != null) result.assetId = assetId;
    return result;
  }

  Settings_AccountAsset._();

  factory Settings_AccountAsset.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Settings_AccountAsset.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Settings.AccountAsset',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..aE<Account>(1, _omitFieldNames ? '' : 'account',
        fieldType: $pb.PbFieldType.QE, enumValues: Account.values)
    ..aQS(2, _omitFieldNames ? '' : 'assetId');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Settings_AccountAsset clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Settings_AccountAsset copyWith(
          void Function(Settings_AccountAsset) updates) =>
      super.copyWith((message) => updates(message as Settings_AccountAsset))
          as Settings_AccountAsset;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Settings_AccountAsset create() => Settings_AccountAsset._();
  @$core.override
  Settings_AccountAsset createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Settings_AccountAsset getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Settings_AccountAsset>(create);
  static Settings_AccountAsset? _defaultInstance;

  @$pb.TagNumber(1)
  Account get account => $_getN(0);
  @$pb.TagNumber(1)
  set account(Account value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAccount() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccount() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get assetId => $_getSZ(1);
  @$pb.TagNumber(2)
  set assetId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAssetId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAssetId() => $_clearField(2);
}

class Settings extends $pb.GeneratedMessage {
  factory Settings({
    $core.Iterable<Settings_AccountAsset>? disabledAccounts,
  }) {
    final result = create();
    if (disabledAccounts != null)
      result.disabledAccounts.addAll(disabledAccounts);
    return result;
  }

  Settings._();

  factory Settings.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Settings.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Settings',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'),
      createEmptyInstance: create)
    ..pPM<Settings_AccountAsset>(1, _omitFieldNames ? '' : 'disabledAccounts',
        subBuilder: Settings_AccountAsset.create);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Settings clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Settings copyWith(void Function(Settings) updates) =>
      super.copyWith((message) => updates(message as Settings)) as Settings;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Settings create() => Settings._();
  @$core.override
  Settings createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Settings getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Settings>(create);
  static Settings? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Settings_AccountAsset> get disabledAccounts => $_getList(0);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
