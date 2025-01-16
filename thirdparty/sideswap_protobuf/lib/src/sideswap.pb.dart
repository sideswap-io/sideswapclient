//
//  Generated code. Do not modify.
//  source: sideswap.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'sideswap.pbenum.dart';

export 'sideswap.pbenum.dart';

class Empty extends $pb.GeneratedMessage {
  factory Empty() => create();
  Empty._() : super();
  factory Empty.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Empty.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Empty', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Empty clone() => Empty()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Empty copyWith(void Function(Empty) updates) => super.copyWith((message) => updates(message as Empty)) as Empty;

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
  factory Account({
    $core.int? id,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  Account._() : super();
  factory Account.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Account.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Account', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.Q3)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Account clone() => Account()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Account copyWith(void Function(Account) updates) => super.copyWith((message) => updates(message as Account)) as Account;

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
  factory Address({
    $core.String? addr,
  }) {
    final $result = create();
    if (addr != null) {
      $result.addr = addr;
    }
    return $result;
  }
  Address._() : super();
  factory Address.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Address.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Address', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'addr')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Address clone() => Address()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Address copyWith(void Function(Address) updates) => super.copyWith((message) => updates(message as Address)) as Address;

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
  factory AddressAmount({
    $core.String? address,
    $fixnum.Int64? amount,
    $core.String? assetId,
  }) {
    final $result = create();
    if (address != null) {
      $result.address = address;
    }
    if (amount != null) {
      $result.amount = amount;
    }
    if (assetId != null) {
      $result.assetId = assetId;
    }
    return $result;
  }
  AddressAmount._() : super();
  factory AddressAmount.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AddressAmount.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AddressAmount', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'address')
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'amount', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aQS(3, _omitFieldNames ? '' : 'assetId')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AddressAmount clone() => AddressAmount()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AddressAmount copyWith(void Function(AddressAmount) updates) => super.copyWith((message) => updates(message as AddressAmount)) as AddressAmount;

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
  factory Balance({
    $core.String? assetId,
    $fixnum.Int64? amount,
  }) {
    final $result = create();
    if (assetId != null) {
      $result.assetId = assetId;
    }
    if (amount != null) {
      $result.amount = amount;
    }
    return $result;
  }
  Balance._() : super();
  factory Balance.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Balance.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Balance', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'assetId')
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'amount', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Balance clone() => Balance()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Balance copyWith(void Function(Balance) updates) => super.copyWith((message) => updates(message as Balance)) as Balance;

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

class AmpAssetRestrictions extends $pb.GeneratedMessage {
  factory AmpAssetRestrictions({
    $core.Iterable<$core.String>? allowedCountries,
  }) {
    final $result = create();
    if (allowedCountries != null) {
      $result.allowedCountries.addAll(allowedCountries);
    }
    return $result;
  }
  AmpAssetRestrictions._() : super();
  factory AmpAssetRestrictions.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AmpAssetRestrictions.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AmpAssetRestrictions', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'allowedCountries')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AmpAssetRestrictions clone() => AmpAssetRestrictions()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AmpAssetRestrictions copyWith(void Function(AmpAssetRestrictions) updates) => super.copyWith((message) => updates(message as AmpAssetRestrictions)) as AmpAssetRestrictions;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AmpAssetRestrictions create() => AmpAssetRestrictions._();
  AmpAssetRestrictions createEmptyInstance() => create();
  static $pb.PbList<AmpAssetRestrictions> createRepeated() => $pb.PbList<AmpAssetRestrictions>();
  @$core.pragma('dart2js:noInline')
  static AmpAssetRestrictions getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AmpAssetRestrictions>(create);
  static AmpAssetRestrictions? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.String> get allowedCountries => $_getList(0);
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
    final $result = create();
    if (assetId != null) {
      $result.assetId = assetId;
    }
    if (name != null) {
      $result.name = name;
    }
    if (ticker != null) {
      $result.ticker = ticker;
    }
    if (icon != null) {
      $result.icon = icon;
    }
    if (precision != null) {
      $result.precision = precision;
    }
    if (swapMarket != null) {
      $result.swapMarket = swapMarket;
    }
    if (domain != null) {
      $result.domain = domain;
    }
    if (unregistered != null) {
      $result.unregistered = unregistered;
    }
    if (ampMarket != null) {
      $result.ampMarket = ampMarket;
    }
    if (domainAgent != null) {
      $result.domainAgent = domainAgent;
    }
    if (instantSwaps != null) {
      $result.instantSwaps = instantSwaps;
    }
    if (alwaysShow != null) {
      $result.alwaysShow = alwaysShow;
    }
    if (domainAgentLink != null) {
      $result.domainAgentLink = domainAgentLink;
    }
    if (ampAssetRestrictions != null) {
      $result.ampAssetRestrictions = ampAssetRestrictions;
    }
    if (payjoin != null) {
      $result.payjoin = payjoin;
    }
    return $result;
  }
  Asset._() : super();
  factory Asset.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Asset.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Asset', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'assetId')
    ..aQS(2, _omitFieldNames ? '' : 'name')
    ..aQS(3, _omitFieldNames ? '' : 'ticker')
    ..aQS(4, _omitFieldNames ? '' : 'icon')
    ..a<$core.int>(5, _omitFieldNames ? '' : 'precision', $pb.PbFieldType.QU3)
    ..a<$core.bool>(6, _omitFieldNames ? '' : 'swapMarket', $pb.PbFieldType.QB)
    ..aOS(7, _omitFieldNames ? '' : 'domain')
    ..a<$core.bool>(8, _omitFieldNames ? '' : 'unregistered', $pb.PbFieldType.QB)
    ..a<$core.bool>(9, _omitFieldNames ? '' : 'ampMarket', $pb.PbFieldType.QB)
    ..aOS(10, _omitFieldNames ? '' : 'domainAgent')
    ..a<$core.bool>(11, _omitFieldNames ? '' : 'instantSwaps', $pb.PbFieldType.QB)
    ..aOB(12, _omitFieldNames ? '' : 'alwaysShow')
    ..aOS(13, _omitFieldNames ? '' : 'domainAgentLink')
    ..aOM<AmpAssetRestrictions>(14, _omitFieldNames ? '' : 'ampAssetRestrictions', subBuilder: AmpAssetRestrictions.create)
    ..aOB(15, _omitFieldNames ? '' : 'payjoin')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Asset clone() => Asset()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Asset copyWith(void Function(Asset) updates) => super.copyWith((message) => updates(message as Asset)) as Asset;

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

  @$pb.TagNumber(11)
  $core.bool get instantSwaps => $_getBF(10);
  @$pb.TagNumber(11)
  set instantSwaps($core.bool v) { $_setBool(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasInstantSwaps() => $_has(10);
  @$pb.TagNumber(11)
  void clearInstantSwaps() => clearField(11);

  @$pb.TagNumber(12)
  $core.bool get alwaysShow => $_getBF(11);
  @$pb.TagNumber(12)
  set alwaysShow($core.bool v) { $_setBool(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasAlwaysShow() => $_has(11);
  @$pb.TagNumber(12)
  void clearAlwaysShow() => clearField(12);

  @$pb.TagNumber(13)
  $core.String get domainAgentLink => $_getSZ(12);
  @$pb.TagNumber(13)
  set domainAgentLink($core.String v) { $_setString(12, v); }
  @$pb.TagNumber(13)
  $core.bool hasDomainAgentLink() => $_has(12);
  @$pb.TagNumber(13)
  void clearDomainAgentLink() => clearField(13);

  @$pb.TagNumber(14)
  AmpAssetRestrictions get ampAssetRestrictions => $_getN(13);
  @$pb.TagNumber(14)
  set ampAssetRestrictions(AmpAssetRestrictions v) { setField(14, v); }
  @$pb.TagNumber(14)
  $core.bool hasAmpAssetRestrictions() => $_has(13);
  @$pb.TagNumber(14)
  void clearAmpAssetRestrictions() => clearField(14);
  @$pb.TagNumber(14)
  AmpAssetRestrictions ensureAmpAssetRestrictions() => $_ensure(13);

  @$pb.TagNumber(15)
  $core.bool get payjoin => $_getBF(14);
  @$pb.TagNumber(15)
  set payjoin($core.bool v) { $_setBool(14, v); }
  @$pb.TagNumber(15)
  $core.bool hasPayjoin() => $_has(14);
  @$pb.TagNumber(15)
  void clearPayjoin() => clearField(15);
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
    final $result = create();
    if (balances != null) {
      $result.balances.addAll(balances);
    }
    if (txid != null) {
      $result.txid = txid;
    }
    if (networkFee != null) {
      $result.networkFee = networkFee;
    }
    if (memo != null) {
      $result.memo = memo;
    }
    if (vsize != null) {
      $result.vsize = vsize;
    }
    if (balancesAll != null) {
      $result.balancesAll.addAll(balancesAll);
    }
    return $result;
  }
  Tx._() : super();
  factory Tx.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Tx.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Tx', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..pc<Balance>(1, _omitFieldNames ? '' : 'balances', $pb.PbFieldType.PM, subBuilder: Balance.create)
    ..aQS(2, _omitFieldNames ? '' : 'txid')
    ..a<$fixnum.Int64>(3, _omitFieldNames ? '' : 'networkFee', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aQS(4, _omitFieldNames ? '' : 'memo')
    ..a<$fixnum.Int64>(6, _omitFieldNames ? '' : 'vsize', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..pc<Balance>(7, _omitFieldNames ? '' : 'balancesAll', $pb.PbFieldType.PM, subBuilder: Balance.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Tx clone() => Tx()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Tx copyWith(void Function(Tx) updates) => super.copyWith((message) => updates(message as Tx)) as Tx;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Tx create() => Tx._();
  Tx createEmptyInstance() => create();
  static $pb.PbList<Tx> createRepeated() => $pb.PbList<Tx>();
  @$core.pragma('dart2js:noInline')
  static Tx getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Tx>(create);
  static Tx? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<Balance> get balances => $_getList(0);

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

  @$pb.TagNumber(6)
  $fixnum.Int64 get vsize => $_getI64(4);
  @$pb.TagNumber(6)
  set vsize($fixnum.Int64 v) { $_setInt64(4, v); }
  @$pb.TagNumber(6)
  $core.bool hasVsize() => $_has(4);
  @$pb.TagNumber(6)
  void clearVsize() => clearField(6);

  @$pb.TagNumber(7)
  $core.List<Balance> get balancesAll => $_getList(5);
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
    final $result = create();
    if (isPegIn != null) {
      $result.isPegIn = isPegIn;
    }
    if (amountSend != null) {
      $result.amountSend = amountSend;
    }
    if (amountRecv != null) {
      $result.amountRecv = amountRecv;
    }
    if (addrSend != null) {
      $result.addrSend = addrSend;
    }
    if (addrRecv != null) {
      $result.addrRecv = addrRecv;
    }
    if (txidSend != null) {
      $result.txidSend = txidSend;
    }
    if (txidRecv != null) {
      $result.txidRecv = txidRecv;
    }
    return $result;
  }
  Peg._() : super();
  factory Peg.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Peg.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Peg', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..a<$core.bool>(1, _omitFieldNames ? '' : 'isPegIn', $pb.PbFieldType.QB)
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'amountSend', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(3, _omitFieldNames ? '' : 'amountRecv', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aQS(4, _omitFieldNames ? '' : 'addrSend')
    ..aQS(5, _omitFieldNames ? '' : 'addrRecv')
    ..aQS(6, _omitFieldNames ? '' : 'txidSend')
    ..aOS(8, _omitFieldNames ? '' : 'txidRecv')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Peg clone() => Peg()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Peg copyWith(void Function(Peg) updates) => super.copyWith((message) => updates(message as Peg)) as Peg;

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
  factory Confs({
    $core.int? count,
    $core.int? total,
  }) {
    final $result = create();
    if (count != null) {
      $result.count = count;
    }
    if (total != null) {
      $result.total = total;
    }
    return $result;
  }
  Confs._() : super();
  factory Confs.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Confs.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Confs', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'count', $pb.PbFieldType.QU3)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'total', $pb.PbFieldType.QU3)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Confs clone() => Confs()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Confs copyWith(void Function(Confs) updates) => super.copyWith((message) => updates(message as Confs)) as Confs;

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
  factory TransItem({
    $core.String? id,
    $fixnum.Int64? createdAt,
    Confs? confs,
    Account? account,
    Tx? tx,
    Peg? peg,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (createdAt != null) {
      $result.createdAt = createdAt;
    }
    if (confs != null) {
      $result.confs = confs;
    }
    if (account != null) {
      $result.account = account;
    }
    if (tx != null) {
      $result.tx = tx;
    }
    if (peg != null) {
      $result.peg = peg;
    }
    return $result;
  }
  TransItem._() : super();
  factory TransItem.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TransItem.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, TransItem_Item> _TransItem_ItemByTag = {
    10 : TransItem_Item.tx,
    11 : TransItem_Item.peg,
    0 : TransItem_Item.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TransItem', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..oo(0, [10, 11])
    ..aQS(1, _omitFieldNames ? '' : 'id')
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'createdAt', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOM<Confs>(3, _omitFieldNames ? '' : 'confs', subBuilder: Confs.create)
    ..aQM<Account>(4, _omitFieldNames ? '' : 'account', subBuilder: Account.create)
    ..aOM<Tx>(10, _omitFieldNames ? '' : 'tx', subBuilder: Tx.create)
    ..aOM<Peg>(11, _omitFieldNames ? '' : 'peg', subBuilder: Peg.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TransItem clone() => TransItem()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TransItem copyWith(void Function(TransItem) updates) => super.copyWith((message) => updates(message as TransItem)) as TransItem;

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

  @$pb.TagNumber(10)
  Tx get tx => $_getN(4);
  @$pb.TagNumber(10)
  set tx(Tx v) { setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasTx() => $_has(4);
  @$pb.TagNumber(10)
  void clearTx() => clearField(10);
  @$pb.TagNumber(10)
  Tx ensureTx() => $_ensure(4);

  @$pb.TagNumber(11)
  Peg get peg => $_getN(5);
  @$pb.TagNumber(11)
  set peg(Peg v) { setField(11, v); }
  @$pb.TagNumber(11)
  $core.bool hasPeg() => $_has(5);
  @$pb.TagNumber(11)
  void clearPeg() => clearField(11);
  @$pb.TagNumber(11)
  Peg ensurePeg() => $_ensure(5);
}

class AssetId extends $pb.GeneratedMessage {
  factory AssetId({
    $core.String? assetId,
  }) {
    final $result = create();
    if (assetId != null) {
      $result.assetId = assetId;
    }
    return $result;
  }
  AssetId._() : super();
  factory AssetId.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AssetId.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AssetId', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'assetId')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AssetId clone() => AssetId()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AssetId copyWith(void Function(AssetId) updates) => super.copyWith((message) => updates(message as AssetId)) as AssetId;

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
  factory GenericResponse({
    $core.bool? success,
    $core.String? errorMsg,
  }) {
    final $result = create();
    if (success != null) {
      $result.success = success;
    }
    if (errorMsg != null) {
      $result.errorMsg = errorMsg;
    }
    return $result;
  }
  GenericResponse._() : super();
  factory GenericResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GenericResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GenericResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..a<$core.bool>(1, _omitFieldNames ? '' : 'success', $pb.PbFieldType.QB)
    ..aOS(2, _omitFieldNames ? '' : 'errorMsg')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GenericResponse clone() => GenericResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GenericResponse copyWith(void Function(GenericResponse) updates) => super.copyWith((message) => updates(message as GenericResponse)) as GenericResponse;

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
  factory FeeRate({
    $core.int? blocks,
    $core.double? value,
  }) {
    final $result = create();
    if (blocks != null) {
      $result.blocks = blocks;
    }
    if (value != null) {
      $result.value = value;
    }
    return $result;
  }
  FeeRate._() : super();
  factory FeeRate.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FeeRate.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FeeRate', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'blocks', $pb.PbFieldType.Q3)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'value', $pb.PbFieldType.QD)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FeeRate clone() => FeeRate()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FeeRate copyWith(void Function(FeeRate) updates) => super.copyWith((message) => updates(message as FeeRate)) as FeeRate;

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
  factory ServerStatus({
    $fixnum.Int64? minPegInAmount,
    $fixnum.Int64? minPegOutAmount,
    $core.double? serverFeePercentPegIn,
    $core.double? serverFeePercentPegOut,
    $core.Iterable<FeeRate>? bitcoinFeeRates,
  }) {
    final $result = create();
    if (minPegInAmount != null) {
      $result.minPegInAmount = minPegInAmount;
    }
    if (minPegOutAmount != null) {
      $result.minPegOutAmount = minPegOutAmount;
    }
    if (serverFeePercentPegIn != null) {
      $result.serverFeePercentPegIn = serverFeePercentPegIn;
    }
    if (serverFeePercentPegOut != null) {
      $result.serverFeePercentPegOut = serverFeePercentPegOut;
    }
    if (bitcoinFeeRates != null) {
      $result.bitcoinFeeRates.addAll(bitcoinFeeRates);
    }
    return $result;
  }
  ServerStatus._() : super();
  factory ServerStatus.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ServerStatus.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ServerStatus', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'minPegInAmount', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'minPegOutAmount', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'serverFeePercentPegIn', $pb.PbFieldType.QD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'serverFeePercentPegOut', $pb.PbFieldType.QD)
    ..pc<FeeRate>(5, _omitFieldNames ? '' : 'bitcoinFeeRates', $pb.PbFieldType.PM, subBuilder: FeeRate.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ServerStatus clone() => ServerStatus()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ServerStatus copyWith(void Function(ServerStatus) updates) => super.copyWith((message) => updates(message as ServerStatus)) as ServerStatus;

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

class OutPoint extends $pb.GeneratedMessage {
  factory OutPoint({
    $core.String? txid,
    $core.int? vout,
  }) {
    final $result = create();
    if (txid != null) {
      $result.txid = txid;
    }
    if (vout != null) {
      $result.vout = vout;
    }
    return $result;
  }
  OutPoint._() : super();
  factory OutPoint.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory OutPoint.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'OutPoint', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'txid')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'vout', $pb.PbFieldType.QU3)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  OutPoint clone() => OutPoint()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  OutPoint copyWith(void Function(OutPoint) updates) => super.copyWith((message) => updates(message as OutPoint)) as OutPoint;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OutPoint create() => OutPoint._();
  OutPoint createEmptyInstance() => create();
  static $pb.PbList<OutPoint> createRepeated() => $pb.PbList<OutPoint>();
  @$core.pragma('dart2js:noInline')
  static OutPoint getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OutPoint>(create);
  static OutPoint? _defaultInstance;

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
}

class CreateTx extends $pb.GeneratedMessage {
  factory CreateTx({
    $core.Iterable<AddressAmount>? addressees,
    Account? account,
    $core.Iterable<OutPoint>? utxos,
    $core.String? feeAssetId,
    $core.int? deductFeeOutput,
  }) {
    final $result = create();
    if (addressees != null) {
      $result.addressees.addAll(addressees);
    }
    if (account != null) {
      $result.account = account;
    }
    if (utxos != null) {
      $result.utxos.addAll(utxos);
    }
    if (feeAssetId != null) {
      $result.feeAssetId = feeAssetId;
    }
    if (deductFeeOutput != null) {
      $result.deductFeeOutput = deductFeeOutput;
    }
    return $result;
  }
  CreateTx._() : super();
  factory CreateTx.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateTx.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CreateTx', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..pc<AddressAmount>(1, _omitFieldNames ? '' : 'addressees', $pb.PbFieldType.PM, subBuilder: AddressAmount.create)
    ..aQM<Account>(2, _omitFieldNames ? '' : 'account', subBuilder: Account.create)
    ..pc<OutPoint>(3, _omitFieldNames ? '' : 'utxos', $pb.PbFieldType.PM, subBuilder: OutPoint.create)
    ..aOS(4, _omitFieldNames ? '' : 'feeAssetId')
    ..a<$core.int>(5, _omitFieldNames ? '' : 'deductFeeOutput', $pb.PbFieldType.OU3)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateTx clone() => CreateTx()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateTx copyWith(void Function(CreateTx) updates) => super.copyWith((message) => updates(message as CreateTx)) as CreateTx;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateTx create() => CreateTx._();
  CreateTx createEmptyInstance() => create();
  static $pb.PbList<CreateTx> createRepeated() => $pb.PbList<CreateTx>();
  @$core.pragma('dart2js:noInline')
  static CreateTx getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateTx>(create);
  static CreateTx? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<AddressAmount> get addressees => $_getList(0);

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

  @$pb.TagNumber(3)
  $core.List<OutPoint> get utxos => $_getList(2);

  @$pb.TagNumber(4)
  $core.String get feeAssetId => $_getSZ(3);
  @$pb.TagNumber(4)
  set feeAssetId($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasFeeAssetId() => $_has(3);
  @$pb.TagNumber(4)
  void clearFeeAssetId() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get deductFeeOutput => $_getIZ(4);
  @$pb.TagNumber(5)
  set deductFeeOutput($core.int v) { $_setUnsignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasDeductFeeOutput() => $_has(4);
  @$pb.TagNumber(5)
  void clearDeductFeeOutput() => clearField(5);
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
  }) {
    final $result = create();
    if (req != null) {
      $result.req = req;
    }
    if (inputCount != null) {
      $result.inputCount = inputCount;
    }
    if (outputCount != null) {
      $result.outputCount = outputCount;
    }
    if (size != null) {
      $result.size = size;
    }
    if (networkFee != null) {
      $result.networkFee = networkFee;
    }
    if (feePerByte != null) {
      $result.feePerByte = feePerByte;
    }
    if (vsize != null) {
      $result.vsize = vsize;
    }
    if (addressees != null) {
      $result.addressees.addAll(addressees);
    }
    if (id != null) {
      $result.id = id;
    }
    if (serverFee != null) {
      $result.serverFee = serverFee;
    }
    return $result;
  }
  CreatedTx._() : super();
  factory CreatedTx.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreatedTx.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CreatedTx', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQM<CreateTx>(1, _omitFieldNames ? '' : 'req', subBuilder: CreateTx.create)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'inputCount', $pb.PbFieldType.Q3)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'outputCount', $pb.PbFieldType.Q3)
    ..a<$fixnum.Int64>(4, _omitFieldNames ? '' : 'size', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(5, _omitFieldNames ? '' : 'networkFee', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'feePerByte', $pb.PbFieldType.QD)
    ..a<$fixnum.Int64>(7, _omitFieldNames ? '' : 'vsize', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..pc<AddressAmount>(8, _omitFieldNames ? '' : 'addressees', $pb.PbFieldType.PM, subBuilder: AddressAmount.create)
    ..aQS(9, _omitFieldNames ? '' : 'id')
    ..aInt64(10, _omitFieldNames ? '' : 'serverFee')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreatedTx clone() => CreatedTx()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreatedTx copyWith(void Function(CreatedTx) updates) => super.copyWith((message) => updates(message as CreatedTx)) as CreatedTx;

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

  @$pb.TagNumber(9)
  $core.String get id => $_getSZ(8);
  @$pb.TagNumber(9)
  set id($core.String v) { $_setString(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasId() => $_has(8);
  @$pb.TagNumber(9)
  void clearId() => clearField(9);

  @$pb.TagNumber(10)
  $fixnum.Int64 get serverFee => $_getI64(9);
  @$pb.TagNumber(10)
  set serverFee($fixnum.Int64 v) { $_setInt64(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasServerFee() => $_has(9);
  @$pb.TagNumber(10)
  void clearServerFee() => clearField(10);
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
    final $result = create();
    if (time != null) {
      $result.time = time;
    }
    if (open != null) {
      $result.open = open;
    }
    if (close != null) {
      $result.close = close;
    }
    if (high != null) {
      $result.high = high;
    }
    if (low != null) {
      $result.low = low;
    }
    if (volume != null) {
      $result.volume = volume;
    }
    return $result;
  }
  ChartPoint._() : super();
  factory ChartPoint.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ChartPoint.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ChartPoint', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'time')
    ..a<$core.double>(2, _omitFieldNames ? '' : 'open', $pb.PbFieldType.QD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'close', $pb.PbFieldType.QD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'high', $pb.PbFieldType.QD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'low', $pb.PbFieldType.QD)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'volume', $pb.PbFieldType.QD)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ChartPoint clone() => ChartPoint()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ChartPoint copyWith(void Function(ChartPoint) updates) => super.copyWith((message) => updates(message as ChartPoint)) as ChartPoint;

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

class AssetPair extends $pb.GeneratedMessage {
  factory AssetPair({
    $core.String? base,
    $core.String? quote,
  }) {
    final $result = create();
    if (base != null) {
      $result.base = base;
    }
    if (quote != null) {
      $result.quote = quote;
    }
    return $result;
  }
  AssetPair._() : super();
  factory AssetPair.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AssetPair.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AssetPair', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'base')
    ..aQS(2, _omitFieldNames ? '' : 'quote')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AssetPair clone() => AssetPair()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AssetPair copyWith(void Function(AssetPair) updates) => super.copyWith((message) => updates(message as AssetPair)) as AssetPair;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AssetPair create() => AssetPair._();
  AssetPair createEmptyInstance() => create();
  static $pb.PbList<AssetPair> createRepeated() => $pb.PbList<AssetPair>();
  @$core.pragma('dart2js:noInline')
  static AssetPair getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AssetPair>(create);
  static AssetPair? _defaultInstance;

  /// Base asset id
  @$pb.TagNumber(1)
  $core.String get base => $_getSZ(0);
  @$pb.TagNumber(1)
  set base($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasBase() => $_has(0);
  @$pb.TagNumber(1)
  void clearBase() => clearField(1);

  /// Quote asset id
  @$pb.TagNumber(2)
  $core.String get quote => $_getSZ(1);
  @$pb.TagNumber(2)
  set quote($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasQuote() => $_has(1);
  @$pb.TagNumber(2)
  void clearQuote() => clearField(2);
}

class MarketInfo extends $pb.GeneratedMessage {
  factory MarketInfo({
    AssetPair? assetPair,
    AssetType? feeAsset,
    MarketType_? type,
  }) {
    final $result = create();
    if (assetPair != null) {
      $result.assetPair = assetPair;
    }
    if (feeAsset != null) {
      $result.feeAsset = feeAsset;
    }
    if (type != null) {
      $result.type = type;
    }
    return $result;
  }
  MarketInfo._() : super();
  factory MarketInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MarketInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MarketInfo', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQM<AssetPair>(1, _omitFieldNames ? '' : 'assetPair', subBuilder: AssetPair.create)
    ..e<AssetType>(2, _omitFieldNames ? '' : 'feeAsset', $pb.PbFieldType.QE, defaultOrMaker: AssetType.BASE, valueOf: AssetType.valueOf, enumValues: AssetType.values)
    ..e<MarketType_>(3, _omitFieldNames ? '' : 'type', $pb.PbFieldType.QE, defaultOrMaker: MarketType_.STABLECOIN, valueOf: MarketType_.valueOf, enumValues: MarketType_.values)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MarketInfo clone() => MarketInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MarketInfo copyWith(void Function(MarketInfo) updates) => super.copyWith((message) => updates(message as MarketInfo)) as MarketInfo;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MarketInfo create() => MarketInfo._();
  MarketInfo createEmptyInstance() => create();
  static $pb.PbList<MarketInfo> createRepeated() => $pb.PbList<MarketInfo>();
  @$core.pragma('dart2js:noInline')
  static MarketInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MarketInfo>(create);
  static MarketInfo? _defaultInstance;

  @$pb.TagNumber(1)
  AssetPair get assetPair => $_getN(0);
  @$pb.TagNumber(1)
  set assetPair(AssetPair v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasAssetPair() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetPair() => clearField(1);
  @$pb.TagNumber(1)
  AssetPair ensureAssetPair() => $_ensure(0);

  @$pb.TagNumber(2)
  AssetType get feeAsset => $_getN(1);
  @$pb.TagNumber(2)
  set feeAsset(AssetType v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasFeeAsset() => $_has(1);
  @$pb.TagNumber(2)
  void clearFeeAsset() => clearField(2);

  @$pb.TagNumber(3)
  MarketType_ get type => $_getN(2);
  @$pb.TagNumber(3)
  set type(MarketType_ v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasType() => $_has(2);
  @$pb.TagNumber(3)
  void clearType() => clearField(3);
}

class OrderId extends $pb.GeneratedMessage {
  factory OrderId({
    $fixnum.Int64? id,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  OrderId._() : super();
  factory OrderId.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory OrderId.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'OrderId', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.QU6, defaultOrMaker: $fixnum.Int64.ZERO)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  OrderId clone() => OrderId()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  OrderId copyWith(void Function(OrderId) updates) => super.copyWith((message) => updates(message as OrderId)) as OrderId;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OrderId create() => OrderId._();
  OrderId createEmptyInstance() => create();
  static $pb.PbList<OrderId> createRepeated() => $pb.PbList<OrderId>();
  @$core.pragma('dart2js:noInline')
  static OrderId getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OrderId>(create);
  static OrderId? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);
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
    final $result = create();
    if (orderId != null) {
      $result.orderId = orderId;
    }
    if (assetPair != null) {
      $result.assetPair = assetPair;
    }
    if (tradeDir != null) {
      $result.tradeDir = tradeDir;
    }
    if (amount != null) {
      $result.amount = amount;
    }
    if (price != null) {
      $result.price = price;
    }
    if (twoStep != null) {
      $result.twoStep = twoStep;
    }
    return $result;
  }
  PublicOrder._() : super();
  factory PublicOrder.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PublicOrder.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PublicOrder', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQM<OrderId>(1, _omitFieldNames ? '' : 'orderId', subBuilder: OrderId.create)
    ..aQM<AssetPair>(2, _omitFieldNames ? '' : 'assetPair', subBuilder: AssetPair.create)
    ..e<TradeDir>(3, _omitFieldNames ? '' : 'tradeDir', $pb.PbFieldType.QE, defaultOrMaker: TradeDir.SELL, valueOf: TradeDir.valueOf, enumValues: TradeDir.values)
    ..a<$fixnum.Int64>(4, _omitFieldNames ? '' : 'amount', $pb.PbFieldType.QU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'price', $pb.PbFieldType.QD)
    ..a<$core.bool>(6, _omitFieldNames ? '' : 'twoStep', $pb.PbFieldType.QB)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PublicOrder clone() => PublicOrder()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PublicOrder copyWith(void Function(PublicOrder) updates) => super.copyWith((message) => updates(message as PublicOrder)) as PublicOrder;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PublicOrder create() => PublicOrder._();
  PublicOrder createEmptyInstance() => create();
  static $pb.PbList<PublicOrder> createRepeated() => $pb.PbList<PublicOrder>();
  @$core.pragma('dart2js:noInline')
  static PublicOrder getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PublicOrder>(create);
  static PublicOrder? _defaultInstance;

  @$pb.TagNumber(1)
  OrderId get orderId => $_getN(0);
  @$pb.TagNumber(1)
  set orderId(OrderId v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrderId() => clearField(1);
  @$pb.TagNumber(1)
  OrderId ensureOrderId() => $_ensure(0);

  @$pb.TagNumber(2)
  AssetPair get assetPair => $_getN(1);
  @$pb.TagNumber(2)
  set assetPair(AssetPair v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasAssetPair() => $_has(1);
  @$pb.TagNumber(2)
  void clearAssetPair() => clearField(2);
  @$pb.TagNumber(2)
  AssetPair ensureAssetPair() => $_ensure(1);

  @$pb.TagNumber(3)
  TradeDir get tradeDir => $_getN(2);
  @$pb.TagNumber(3)
  set tradeDir(TradeDir v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasTradeDir() => $_has(2);
  @$pb.TagNumber(3)
  void clearTradeDir() => clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get amount => $_getI64(3);
  @$pb.TagNumber(4)
  set amount($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasAmount() => $_has(3);
  @$pb.TagNumber(4)
  void clearAmount() => clearField(4);

  @$pb.TagNumber(5)
  $core.double get price => $_getN(4);
  @$pb.TagNumber(5)
  set price($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasPrice() => $_has(4);
  @$pb.TagNumber(5)
  void clearPrice() => clearField(5);

  @$pb.TagNumber(6)
  $core.bool get twoStep => $_getBF(5);
  @$pb.TagNumber(6)
  set twoStep($core.bool v) { $_setBool(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasTwoStep() => $_has(5);
  @$pb.TagNumber(6)
  void clearTwoStep() => clearField(6);
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
  }) {
    final $result = create();
    if (orderId != null) {
      $result.orderId = orderId;
    }
    if (assetPair != null) {
      $result.assetPair = assetPair;
    }
    if (tradeDir != null) {
      $result.tradeDir = tradeDir;
    }
    if (origAmount != null) {
      $result.origAmount = origAmount;
    }
    if (activeAmount != null) {
      $result.activeAmount = activeAmount;
    }
    if (price != null) {
      $result.price = price;
    }
    if (privateId != null) {
      $result.privateId = privateId;
    }
    if (ttlSeconds != null) {
      $result.ttlSeconds = ttlSeconds;
    }
    if (twoStep != null) {
      $result.twoStep = twoStep;
    }
    return $result;
  }
  OwnOrder._() : super();
  factory OwnOrder.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory OwnOrder.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'OwnOrder', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQM<OrderId>(1, _omitFieldNames ? '' : 'orderId', subBuilder: OrderId.create)
    ..aQM<AssetPair>(2, _omitFieldNames ? '' : 'assetPair', subBuilder: AssetPair.create)
    ..e<TradeDir>(3, _omitFieldNames ? '' : 'tradeDir', $pb.PbFieldType.QE, defaultOrMaker: TradeDir.SELL, valueOf: TradeDir.valueOf, enumValues: TradeDir.values)
    ..a<$fixnum.Int64>(4, _omitFieldNames ? '' : 'origAmount', $pb.PbFieldType.QU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(5, _omitFieldNames ? '' : 'activeAmount', $pb.PbFieldType.QU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'price', $pb.PbFieldType.QD)
    ..aOS(7, _omitFieldNames ? '' : 'privateId')
    ..a<$fixnum.Int64>(8, _omitFieldNames ? '' : 'ttlSeconds', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.bool>(9, _omitFieldNames ? '' : 'twoStep', $pb.PbFieldType.QB)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  OwnOrder clone() => OwnOrder()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  OwnOrder copyWith(void Function(OwnOrder) updates) => super.copyWith((message) => updates(message as OwnOrder)) as OwnOrder;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OwnOrder create() => OwnOrder._();
  OwnOrder createEmptyInstance() => create();
  static $pb.PbList<OwnOrder> createRepeated() => $pb.PbList<OwnOrder>();
  @$core.pragma('dart2js:noInline')
  static OwnOrder getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OwnOrder>(create);
  static OwnOrder? _defaultInstance;

  @$pb.TagNumber(1)
  OrderId get orderId => $_getN(0);
  @$pb.TagNumber(1)
  set orderId(OrderId v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrderId() => clearField(1);
  @$pb.TagNumber(1)
  OrderId ensureOrderId() => $_ensure(0);

  @$pb.TagNumber(2)
  AssetPair get assetPair => $_getN(1);
  @$pb.TagNumber(2)
  set assetPair(AssetPair v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasAssetPair() => $_has(1);
  @$pb.TagNumber(2)
  void clearAssetPair() => clearField(2);
  @$pb.TagNumber(2)
  AssetPair ensureAssetPair() => $_ensure(1);

  @$pb.TagNumber(3)
  TradeDir get tradeDir => $_getN(2);
  @$pb.TagNumber(3)
  set tradeDir(TradeDir v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasTradeDir() => $_has(2);
  @$pb.TagNumber(3)
  void clearTradeDir() => clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get origAmount => $_getI64(3);
  @$pb.TagNumber(4)
  set origAmount($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasOrigAmount() => $_has(3);
  @$pb.TagNumber(4)
  void clearOrigAmount() => clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get activeAmount => $_getI64(4);
  @$pb.TagNumber(5)
  set activeAmount($fixnum.Int64 v) { $_setInt64(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasActiveAmount() => $_has(4);
  @$pb.TagNumber(5)
  void clearActiveAmount() => clearField(5);

  @$pb.TagNumber(6)
  $core.double get price => $_getN(5);
  @$pb.TagNumber(6)
  set price($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasPrice() => $_has(5);
  @$pb.TagNumber(6)
  void clearPrice() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get privateId => $_getSZ(6);
  @$pb.TagNumber(7)
  set privateId($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasPrivateId() => $_has(6);
  @$pb.TagNumber(7)
  void clearPrivateId() => clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get ttlSeconds => $_getI64(7);
  @$pb.TagNumber(8)
  set ttlSeconds($fixnum.Int64 v) { $_setInt64(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasTtlSeconds() => $_has(7);
  @$pb.TagNumber(8)
  void clearTtlSeconds() => clearField(8);

  @$pb.TagNumber(9)
  $core.bool get twoStep => $_getBF(8);
  @$pb.TagNumber(9)
  set twoStep($core.bool v) { $_setBool(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasTwoStep() => $_has(8);
  @$pb.TagNumber(9)
  void clearTwoStep() => clearField(9);
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
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (orderId != null) {
      $result.orderId = orderId;
    }
    if (assetPair != null) {
      $result.assetPair = assetPair;
    }
    if (tradeDir != null) {
      $result.tradeDir = tradeDir;
    }
    if (baseAmount != null) {
      $result.baseAmount = baseAmount;
    }
    if (quoteAmount != null) {
      $result.quoteAmount = quoteAmount;
    }
    if (price != null) {
      $result.price = price;
    }
    if (status != null) {
      $result.status = status;
    }
    if (txid != null) {
      $result.txid = txid;
    }
    return $result;
  }
  HistoryOrder._() : super();
  factory HistoryOrder.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory HistoryOrder.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'HistoryOrder', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.QU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aQM<OrderId>(2, _omitFieldNames ? '' : 'orderId', subBuilder: OrderId.create)
    ..aQM<AssetPair>(3, _omitFieldNames ? '' : 'assetPair', subBuilder: AssetPair.create)
    ..e<TradeDir>(4, _omitFieldNames ? '' : 'tradeDir', $pb.PbFieldType.QE, defaultOrMaker: TradeDir.SELL, valueOf: TradeDir.valueOf, enumValues: TradeDir.values)
    ..a<$fixnum.Int64>(5, _omitFieldNames ? '' : 'baseAmount', $pb.PbFieldType.QU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(6, _omitFieldNames ? '' : 'quoteAmount', $pb.PbFieldType.QU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.double>(7, _omitFieldNames ? '' : 'price', $pb.PbFieldType.QD)
    ..e<HistStatus>(8, _omitFieldNames ? '' : 'status', $pb.PbFieldType.QE, defaultOrMaker: HistStatus.MEMPOOL, valueOf: HistStatus.valueOf, enumValues: HistStatus.values)
    ..aOS(9, _omitFieldNames ? '' : 'txid')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  HistoryOrder clone() => HistoryOrder()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  HistoryOrder copyWith(void Function(HistoryOrder) updates) => super.copyWith((message) => updates(message as HistoryOrder)) as HistoryOrder;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HistoryOrder create() => HistoryOrder._();
  HistoryOrder createEmptyInstance() => create();
  static $pb.PbList<HistoryOrder> createRepeated() => $pb.PbList<HistoryOrder>();
  @$core.pragma('dart2js:noInline')
  static HistoryOrder getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<HistoryOrder>(create);
  static HistoryOrder? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  OrderId get orderId => $_getN(1);
  @$pb.TagNumber(2)
  set orderId(OrderId v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasOrderId() => $_has(1);
  @$pb.TagNumber(2)
  void clearOrderId() => clearField(2);
  @$pb.TagNumber(2)
  OrderId ensureOrderId() => $_ensure(1);

  @$pb.TagNumber(3)
  AssetPair get assetPair => $_getN(2);
  @$pb.TagNumber(3)
  set assetPair(AssetPair v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasAssetPair() => $_has(2);
  @$pb.TagNumber(3)
  void clearAssetPair() => clearField(3);
  @$pb.TagNumber(3)
  AssetPair ensureAssetPair() => $_ensure(2);

  @$pb.TagNumber(4)
  TradeDir get tradeDir => $_getN(3);
  @$pb.TagNumber(4)
  set tradeDir(TradeDir v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasTradeDir() => $_has(3);
  @$pb.TagNumber(4)
  void clearTradeDir() => clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get baseAmount => $_getI64(4);
  @$pb.TagNumber(5)
  set baseAmount($fixnum.Int64 v) { $_setInt64(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasBaseAmount() => $_has(4);
  @$pb.TagNumber(5)
  void clearBaseAmount() => clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get quoteAmount => $_getI64(5);
  @$pb.TagNumber(6)
  set quoteAmount($fixnum.Int64 v) { $_setInt64(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasQuoteAmount() => $_has(5);
  @$pb.TagNumber(6)
  void clearQuoteAmount() => clearField(6);

  @$pb.TagNumber(7)
  $core.double get price => $_getN(6);
  @$pb.TagNumber(7)
  set price($core.double v) { $_setDouble(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasPrice() => $_has(6);
  @$pb.TagNumber(7)
  void clearPrice() => clearField(7);

  @$pb.TagNumber(8)
  HistStatus get status => $_getN(7);
  @$pb.TagNumber(8)
  set status(HistStatus v) { setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasStatus() => $_has(7);
  @$pb.TagNumber(8)
  void clearStatus() => clearField(8);

  @$pb.TagNumber(9)
  $core.String get txid => $_getSZ(8);
  @$pb.TagNumber(9)
  set txid($core.String v) { $_setString(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasTxid() => $_has(8);
  @$pb.TagNumber(9)
  void clearTxid() => clearField(9);
}

enum To_Login_Wallet {
  mnemonic, 
  jadeId, 
  notSet
}

class To_Login extends $pb.GeneratedMessage {
  factory To_Login({
    $core.String? mnemonic,
    $core.String? phoneKey,
    $core.String? jadeId,
  }) {
    final $result = create();
    if (mnemonic != null) {
      $result.mnemonic = mnemonic;
    }
    if (phoneKey != null) {
      $result.phoneKey = phoneKey;
    }
    if (jadeId != null) {
      $result.jadeId = jadeId;
    }
    return $result;
  }
  To_Login._() : super();
  factory To_Login.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory To_Login.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, To_Login_Wallet> _To_Login_WalletByTag = {
    1 : To_Login_Wallet.mnemonic,
    7 : To_Login_Wallet.jadeId,
    0 : To_Login_Wallet.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'To.Login', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..oo(0, [1, 7])
    ..aOS(1, _omitFieldNames ? '' : 'mnemonic')
    ..aOS(2, _omitFieldNames ? '' : 'phoneKey')
    ..aOS(7, _omitFieldNames ? '' : 'jadeId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  To_Login clone() => To_Login()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  To_Login copyWith(void Function(To_Login) updates) => super.copyWith((message) => updates(message as To_Login)) as To_Login;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static To_Login create() => To_Login._();
  To_Login createEmptyInstance() => create();
  static $pb.PbList<To_Login> createRepeated() => $pb.PbList<To_Login>();
  @$core.pragma('dart2js:noInline')
  static To_Login getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<To_Login>(create);
  static To_Login? _defaultInstance;

  To_Login_Wallet whichWallet() => _To_Login_WalletByTag[$_whichOneof(0)]!;
  void clearWallet() => clearField($_whichOneof(0));

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

  @$pb.TagNumber(7)
  $core.String get jadeId => $_getSZ(2);
  @$pb.TagNumber(7)
  set jadeId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(7)
  $core.bool hasJadeId() => $_has(2);
  @$pb.TagNumber(7)
  void clearJadeId() => clearField(7);
}

class To_NetworkSettings_Custom extends $pb.GeneratedMessage {
  factory To_NetworkSettings_Custom({
    $core.String? host,
    $core.int? port,
    $core.bool? useTls,
  }) {
    final $result = create();
    if (host != null) {
      $result.host = host;
    }
    if (port != null) {
      $result.port = port;
    }
    if (useTls != null) {
      $result.useTls = useTls;
    }
    return $result;
  }
  To_NetworkSettings_Custom._() : super();
  factory To_NetworkSettings_Custom.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory To_NetworkSettings_Custom.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'To.NetworkSettings.Custom', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'host')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'port', $pb.PbFieldType.Q3)
    ..a<$core.bool>(3, _omitFieldNames ? '' : 'useTls', $pb.PbFieldType.QB)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  To_NetworkSettings_Custom clone() => To_NetworkSettings_Custom()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  To_NetworkSettings_Custom copyWith(void Function(To_NetworkSettings_Custom) updates) => super.copyWith((message) => updates(message as To_NetworkSettings_Custom)) as To_NetworkSettings_Custom;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static To_NetworkSettings_Custom create() => To_NetworkSettings_Custom._();
  To_NetworkSettings_Custom createEmptyInstance() => create();
  static $pb.PbList<To_NetworkSettings_Custom> createRepeated() => $pb.PbList<To_NetworkSettings_Custom>();
  @$core.pragma('dart2js:noInline')
  static To_NetworkSettings_Custom getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<To_NetworkSettings_Custom>(create);
  static To_NetworkSettings_Custom? _defaultInstance;

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
    final $result = create();
    if (blockstream != null) {
      $result.blockstream = blockstream;
    }
    if (sideswap != null) {
      $result.sideswap = sideswap;
    }
    if (sideswapCn != null) {
      $result.sideswapCn = sideswapCn;
    }
    if (custom != null) {
      $result.custom = custom;
    }
    return $result;
  }
  To_NetworkSettings._() : super();
  factory To_NetworkSettings.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory To_NetworkSettings.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, To_NetworkSettings_Selected> _To_NetworkSettings_SelectedByTag = {
    1 : To_NetworkSettings_Selected.blockstream,
    2 : To_NetworkSettings_Selected.sideswap,
    3 : To_NetworkSettings_Selected.sideswapCn,
    4 : To_NetworkSettings_Selected.custom,
    0 : To_NetworkSettings_Selected.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'To.NetworkSettings', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4])
    ..aOM<Empty>(1, _omitFieldNames ? '' : 'blockstream', subBuilder: Empty.create)
    ..aOM<Empty>(2, _omitFieldNames ? '' : 'sideswap', subBuilder: Empty.create)
    ..aOM<Empty>(3, _omitFieldNames ? '' : 'sideswapCn', subBuilder: Empty.create)
    ..aOM<To_NetworkSettings_Custom>(4, _omitFieldNames ? '' : 'custom', subBuilder: To_NetworkSettings_Custom.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  To_NetworkSettings clone() => To_NetworkSettings()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  To_NetworkSettings copyWith(void Function(To_NetworkSettings) updates) => super.copyWith((message) => updates(message as To_NetworkSettings)) as To_NetworkSettings;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static To_NetworkSettings create() => To_NetworkSettings._();
  To_NetworkSettings createEmptyInstance() => create();
  static $pb.PbList<To_NetworkSettings> createRepeated() => $pb.PbList<To_NetworkSettings>();
  @$core.pragma('dart2js:noInline')
  static To_NetworkSettings getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<To_NetworkSettings>(create);
  static To_NetworkSettings? _defaultInstance;

  To_NetworkSettings_Selected whichSelected() => _To_NetworkSettings_SelectedByTag[$_whichOneof(0)]!;
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
  Empty get sideswapCn => $_getN(2);
  @$pb.TagNumber(3)
  set sideswapCn(Empty v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasSideswapCn() => $_has(2);
  @$pb.TagNumber(3)
  void clearSideswapCn() => clearField(3);
  @$pb.TagNumber(3)
  Empty ensureSideswapCn() => $_ensure(2);

  @$pb.TagNumber(4)
  To_NetworkSettings_Custom get custom => $_getN(3);
  @$pb.TagNumber(4)
  set custom(To_NetworkSettings_Custom v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasCustom() => $_has(3);
  @$pb.TagNumber(4)
  void clearCustom() => clearField(4);
  @$pb.TagNumber(4)
  To_NetworkSettings_Custom ensureCustom() => $_ensure(3);
}

class To_ProxySettings_Proxy extends $pb.GeneratedMessage {
  factory To_ProxySettings_Proxy({
    $core.String? host,
    $core.int? port,
  }) {
    final $result = create();
    if (host != null) {
      $result.host = host;
    }
    if (port != null) {
      $result.port = port;
    }
    return $result;
  }
  To_ProxySettings_Proxy._() : super();
  factory To_ProxySettings_Proxy.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory To_ProxySettings_Proxy.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'To.ProxySettings.Proxy', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'host')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'port', $pb.PbFieldType.Q3)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  To_ProxySettings_Proxy clone() => To_ProxySettings_Proxy()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  To_ProxySettings_Proxy copyWith(void Function(To_ProxySettings_Proxy) updates) => super.copyWith((message) => updates(message as To_ProxySettings_Proxy)) as To_ProxySettings_Proxy;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static To_ProxySettings_Proxy create() => To_ProxySettings_Proxy._();
  To_ProxySettings_Proxy createEmptyInstance() => create();
  static $pb.PbList<To_ProxySettings_Proxy> createRepeated() => $pb.PbList<To_ProxySettings_Proxy>();
  @$core.pragma('dart2js:noInline')
  static To_ProxySettings_Proxy getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<To_ProxySettings_Proxy>(create);
  static To_ProxySettings_Proxy? _defaultInstance;

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
}

class To_ProxySettings extends $pb.GeneratedMessage {
  factory To_ProxySettings({
    To_ProxySettings_Proxy? proxy,
  }) {
    final $result = create();
    if (proxy != null) {
      $result.proxy = proxy;
    }
    return $result;
  }
  To_ProxySettings._() : super();
  factory To_ProxySettings.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory To_ProxySettings.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'To.ProxySettings', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aOM<To_ProxySettings_Proxy>(1, _omitFieldNames ? '' : 'proxy', subBuilder: To_ProxySettings_Proxy.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  To_ProxySettings clone() => To_ProxySettings()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  To_ProxySettings copyWith(void Function(To_ProxySettings) updates) => super.copyWith((message) => updates(message as To_ProxySettings)) as To_ProxySettings;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static To_ProxySettings create() => To_ProxySettings._();
  To_ProxySettings createEmptyInstance() => create();
  static $pb.PbList<To_ProxySettings> createRepeated() => $pb.PbList<To_ProxySettings>();
  @$core.pragma('dart2js:noInline')
  static To_ProxySettings getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<To_ProxySettings>(create);
  static To_ProxySettings? _defaultInstance;

  @$pb.TagNumber(1)
  To_ProxySettings_Proxy get proxy => $_getN(0);
  @$pb.TagNumber(1)
  set proxy(To_ProxySettings_Proxy v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasProxy() => $_has(0);
  @$pb.TagNumber(1)
  void clearProxy() => clearField(1);
  @$pb.TagNumber(1)
  To_ProxySettings_Proxy ensureProxy() => $_ensure(0);
}

class To_EncryptPin extends $pb.GeneratedMessage {
  factory To_EncryptPin({
    $core.String? pin,
    $core.String? mnemonic,
  }) {
    final $result = create();
    if (pin != null) {
      $result.pin = pin;
    }
    if (mnemonic != null) {
      $result.mnemonic = mnemonic;
    }
    return $result;
  }
  To_EncryptPin._() : super();
  factory To_EncryptPin.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory To_EncryptPin.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'To.EncryptPin', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'pin')
    ..aQS(2, _omitFieldNames ? '' : 'mnemonic')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  To_EncryptPin clone() => To_EncryptPin()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  To_EncryptPin copyWith(void Function(To_EncryptPin) updates) => super.copyWith((message) => updates(message as To_EncryptPin)) as To_EncryptPin;

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
  factory To_DecryptPin({
    $core.String? pin,
    $core.String? salt,
    $core.String? encryptedData,
    $core.String? pinIdentifier,
    $core.String? hmac,
  }) {
    final $result = create();
    if (pin != null) {
      $result.pin = pin;
    }
    if (salt != null) {
      $result.salt = salt;
    }
    if (encryptedData != null) {
      $result.encryptedData = encryptedData;
    }
    if (pinIdentifier != null) {
      $result.pinIdentifier = pinIdentifier;
    }
    if (hmac != null) {
      $result.hmac = hmac;
    }
    return $result;
  }
  To_DecryptPin._() : super();
  factory To_DecryptPin.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory To_DecryptPin.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'To.DecryptPin', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'pin')
    ..aQS(2, _omitFieldNames ? '' : 'salt')
    ..aQS(3, _omitFieldNames ? '' : 'encryptedData')
    ..aQS(4, _omitFieldNames ? '' : 'pinIdentifier')
    ..aOS(5, _omitFieldNames ? '' : 'hmac')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  To_DecryptPin clone() => To_DecryptPin()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  To_DecryptPin copyWith(void Function(To_DecryptPin) updates) => super.copyWith((message) => updates(message as To_DecryptPin)) as To_DecryptPin;

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

  @$pb.TagNumber(5)
  $core.String get hmac => $_getSZ(4);
  @$pb.TagNumber(5)
  set hmac($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasHmac() => $_has(4);
  @$pb.TagNumber(5)
  void clearHmac() => clearField(5);
}

class To_AppState extends $pb.GeneratedMessage {
  factory To_AppState({
    $core.bool? active,
  }) {
    final $result = create();
    if (active != null) {
      $result.active = active;
    }
    return $result;
  }
  To_AppState._() : super();
  factory To_AppState.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory To_AppState.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'To.AppState', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..a<$core.bool>(1, _omitFieldNames ? '' : 'active', $pb.PbFieldType.QB)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  To_AppState clone() => To_AppState()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  To_AppState copyWith(void Function(To_AppState) updates) => super.copyWith((message) => updates(message as To_AppState)) as To_AppState;

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
  factory To_SwapRequest({
    $core.bool? sendBitcoins,
    $core.String? asset,
    $fixnum.Int64? sendAmount,
    $fixnum.Int64? recvAmount,
    $core.double? price,
  }) {
    final $result = create();
    if (sendBitcoins != null) {
      $result.sendBitcoins = sendBitcoins;
    }
    if (asset != null) {
      $result.asset = asset;
    }
    if (sendAmount != null) {
      $result.sendAmount = sendAmount;
    }
    if (recvAmount != null) {
      $result.recvAmount = recvAmount;
    }
    if (price != null) {
      $result.price = price;
    }
    return $result;
  }
  To_SwapRequest._() : super();
  factory To_SwapRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory To_SwapRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'To.SwapRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..a<$core.bool>(1, _omitFieldNames ? '' : 'sendBitcoins', $pb.PbFieldType.QB)
    ..aQS(2, _omitFieldNames ? '' : 'asset')
    ..a<$fixnum.Int64>(3, _omitFieldNames ? '' : 'sendAmount', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(4, _omitFieldNames ? '' : 'recvAmount', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'price', $pb.PbFieldType.QD)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  To_SwapRequest clone() => To_SwapRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  To_SwapRequest copyWith(void Function(To_SwapRequest) updates) => super.copyWith((message) => updates(message as To_SwapRequest)) as To_SwapRequest;

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
  factory To_PegInRequest() => create();
  To_PegInRequest._() : super();
  factory To_PegInRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory To_PegInRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'To.PegInRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  To_PegInRequest clone() => To_PegInRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  To_PegInRequest copyWith(void Function(To_PegInRequest) updates) => super.copyWith((message) => updates(message as To_PegInRequest)) as To_PegInRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static To_PegInRequest create() => To_PegInRequest._();
  To_PegInRequest createEmptyInstance() => create();
  static $pb.PbList<To_PegInRequest> createRepeated() => $pb.PbList<To_PegInRequest>();
  @$core.pragma('dart2js:noInline')
  static To_PegInRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<To_PegInRequest>(create);
  static To_PegInRequest? _defaultInstance;
}

class To_PegOutAmount extends $pb.GeneratedMessage {
  factory To_PegOutAmount({
    $fixnum.Int64? amount,
    $core.bool? isSendEntered,
    $core.double? feeRate,
    Account? account,
  }) {
    final $result = create();
    if (amount != null) {
      $result.amount = amount;
    }
    if (isSendEntered != null) {
      $result.isSendEntered = isSendEntered;
    }
    if (feeRate != null) {
      $result.feeRate = feeRate;
    }
    if (account != null) {
      $result.account = account;
    }
    return $result;
  }
  To_PegOutAmount._() : super();
  factory To_PegOutAmount.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory To_PegOutAmount.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'To.PegOutAmount', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'amount', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.bool>(2, _omitFieldNames ? '' : 'isSendEntered', $pb.PbFieldType.QB)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'feeRate', $pb.PbFieldType.QD)
    ..aQM<Account>(4, _omitFieldNames ? '' : 'account', subBuilder: Account.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  To_PegOutAmount clone() => To_PegOutAmount()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  To_PegOutAmount copyWith(void Function(To_PegOutAmount) updates) => super.copyWith((message) => updates(message as To_PegOutAmount)) as To_PegOutAmount;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static To_PegOutAmount create() => To_PegOutAmount._();
  To_PegOutAmount createEmptyInstance() => create();
  static $pb.PbList<To_PegOutAmount> createRepeated() => $pb.PbList<To_PegOutAmount>();
  @$core.pragma('dart2js:noInline')
  static To_PegOutAmount getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<To_PegOutAmount>(create);
  static To_PegOutAmount? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get amount => $_getI64(0);
  @$pb.TagNumber(1)
  set amount($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAmount() => $_has(0);
  @$pb.TagNumber(1)
  void clearAmount() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get isSendEntered => $_getBF(1);
  @$pb.TagNumber(2)
  set isSendEntered($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasIsSendEntered() => $_has(1);
  @$pb.TagNumber(2)
  void clearIsSendEntered() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get feeRate => $_getN(2);
  @$pb.TagNumber(3)
  set feeRate($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasFeeRate() => $_has(2);
  @$pb.TagNumber(3)
  void clearFeeRate() => clearField(3);

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

class To_PegOutRequest extends $pb.GeneratedMessage {
  factory To_PegOutRequest({
    $fixnum.Int64? sendAmount,
    $fixnum.Int64? recvAmount,
    $core.bool? isSendEntered,
    $core.double? feeRate,
    $core.String? recvAddr,
    $core.int? blocks,
    Account? account,
  }) {
    final $result = create();
    if (sendAmount != null) {
      $result.sendAmount = sendAmount;
    }
    if (recvAmount != null) {
      $result.recvAmount = recvAmount;
    }
    if (isSendEntered != null) {
      $result.isSendEntered = isSendEntered;
    }
    if (feeRate != null) {
      $result.feeRate = feeRate;
    }
    if (recvAddr != null) {
      $result.recvAddr = recvAddr;
    }
    if (blocks != null) {
      $result.blocks = blocks;
    }
    if (account != null) {
      $result.account = account;
    }
    return $result;
  }
  To_PegOutRequest._() : super();
  factory To_PegOutRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory To_PegOutRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'To.PegOutRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'sendAmount', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'recvAmount', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.bool>(4, _omitFieldNames ? '' : 'isSendEntered', $pb.PbFieldType.QB)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'feeRate', $pb.PbFieldType.QD)
    ..aQS(6, _omitFieldNames ? '' : 'recvAddr')
    ..a<$core.int>(7, _omitFieldNames ? '' : 'blocks', $pb.PbFieldType.Q3)
    ..aQM<Account>(8, _omitFieldNames ? '' : 'account', subBuilder: Account.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  To_PegOutRequest clone() => To_PegOutRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  To_PegOutRequest copyWith(void Function(To_PegOutRequest) updates) => super.copyWith((message) => updates(message as To_PegOutRequest)) as To_PegOutRequest;

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
  $fixnum.Int64 get recvAmount => $_getI64(1);
  @$pb.TagNumber(2)
  set recvAmount($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasRecvAmount() => $_has(1);
  @$pb.TagNumber(2)
  void clearRecvAmount() => clearField(2);

  @$pb.TagNumber(4)
  $core.bool get isSendEntered => $_getBF(2);
  @$pb.TagNumber(4)
  set isSendEntered($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(4)
  $core.bool hasIsSendEntered() => $_has(2);
  @$pb.TagNumber(4)
  void clearIsSendEntered() => clearField(4);

  @$pb.TagNumber(5)
  $core.double get feeRate => $_getN(3);
  @$pb.TagNumber(5)
  set feeRate($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(5)
  $core.bool hasFeeRate() => $_has(3);
  @$pb.TagNumber(5)
  void clearFeeRate() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get recvAddr => $_getSZ(4);
  @$pb.TagNumber(6)
  set recvAddr($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(6)
  $core.bool hasRecvAddr() => $_has(4);
  @$pb.TagNumber(6)
  void clearRecvAddr() => clearField(6);

  @$pb.TagNumber(7)
  $core.int get blocks => $_getIZ(5);
  @$pb.TagNumber(7)
  set blocks($core.int v) { $_setSignedInt32(5, v); }
  @$pb.TagNumber(7)
  $core.bool hasBlocks() => $_has(5);
  @$pb.TagNumber(7)
  void clearBlocks() => clearField(7);

  @$pb.TagNumber(8)
  Account get account => $_getN(6);
  @$pb.TagNumber(8)
  set account(Account v) { setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasAccount() => $_has(6);
  @$pb.TagNumber(8)
  void clearAccount() => clearField(8);
  @$pb.TagNumber(8)
  Account ensureAccount() => $_ensure(6);
}

class To_SetMemo extends $pb.GeneratedMessage {
  factory To_SetMemo({
    Account? account,
    $core.String? txid,
    $core.String? memo,
  }) {
    final $result = create();
    if (account != null) {
      $result.account = account;
    }
    if (txid != null) {
      $result.txid = txid;
    }
    if (memo != null) {
      $result.memo = memo;
    }
    return $result;
  }
  To_SetMemo._() : super();
  factory To_SetMemo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory To_SetMemo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'To.SetMemo', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQM<Account>(1, _omitFieldNames ? '' : 'account', subBuilder: Account.create)
    ..aQS(2, _omitFieldNames ? '' : 'txid')
    ..aQS(3, _omitFieldNames ? '' : 'memo')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  To_SetMemo clone() => To_SetMemo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  To_SetMemo copyWith(void Function(To_SetMemo) updates) => super.copyWith((message) => updates(message as To_SetMemo)) as To_SetMemo;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static To_SetMemo create() => To_SetMemo._();
  To_SetMemo createEmptyInstance() => create();
  static $pb.PbList<To_SetMemo> createRepeated() => $pb.PbList<To_SetMemo>();
  @$core.pragma('dart2js:noInline')
  static To_SetMemo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<To_SetMemo>(create);
  static To_SetMemo? _defaultInstance;

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
  $core.String get txid => $_getSZ(1);
  @$pb.TagNumber(2)
  set txid($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTxid() => $_has(1);
  @$pb.TagNumber(2)
  void clearTxid() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get memo => $_getSZ(2);
  @$pb.TagNumber(3)
  set memo($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasMemo() => $_has(2);
  @$pb.TagNumber(3)
  void clearMemo() => clearField(3);
}

class To_SendTx extends $pb.GeneratedMessage {
  factory To_SendTx({
    Account? account,
    $core.String? id,
  }) {
    final $result = create();
    if (account != null) {
      $result.account = account;
    }
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  To_SendTx._() : super();
  factory To_SendTx.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory To_SendTx.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'To.SendTx', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQM<Account>(1, _omitFieldNames ? '' : 'account', subBuilder: Account.create)
    ..aQS(2, _omitFieldNames ? '' : 'id')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  To_SendTx clone() => To_SendTx()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  To_SendTx copyWith(void Function(To_SendTx) updates) => super.copyWith((message) => updates(message as To_SendTx)) as To_SendTx;

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

  @$pb.TagNumber(2)
  $core.String get id => $_getSZ(1);
  @$pb.TagNumber(2)
  set id($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasId() => $_has(1);
  @$pb.TagNumber(2)
  void clearId() => clearField(2);
}

class To_BlindedValues extends $pb.GeneratedMessage {
  factory To_BlindedValues({
    $core.String? txid,
  }) {
    final $result = create();
    if (txid != null) {
      $result.txid = txid;
    }
    return $result;
  }
  To_BlindedValues._() : super();
  factory To_BlindedValues.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory To_BlindedValues.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'To.BlindedValues', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'txid')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  To_BlindedValues clone() => To_BlindedValues()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  To_BlindedValues copyWith(void Function(To_BlindedValues) updates) => super.copyWith((message) => updates(message as To_BlindedValues)) as To_BlindedValues;

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
  factory To_UpdatePushToken({
    $core.String? token,
  }) {
    final $result = create();
    if (token != null) {
      $result.token = token;
    }
    return $result;
  }
  To_UpdatePushToken._() : super();
  factory To_UpdatePushToken.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory To_UpdatePushToken.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'To.UpdatePushToken', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'token')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  To_UpdatePushToken clone() => To_UpdatePushToken()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  To_UpdatePushToken copyWith(void Function(To_UpdatePushToken) updates) => super.copyWith((message) => updates(message as To_UpdatePushToken)) as To_UpdatePushToken;

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

class To_SubscribePriceStream extends $pb.GeneratedMessage {
  factory To_SubscribePriceStream({
    $core.String? assetId,
    $core.bool? sendBitcoins,
    $fixnum.Int64? sendAmount,
    $fixnum.Int64? recvAmount,
  }) {
    final $result = create();
    if (assetId != null) {
      $result.assetId = assetId;
    }
    if (sendBitcoins != null) {
      $result.sendBitcoins = sendBitcoins;
    }
    if (sendAmount != null) {
      $result.sendAmount = sendAmount;
    }
    if (recvAmount != null) {
      $result.recvAmount = recvAmount;
    }
    return $result;
  }
  To_SubscribePriceStream._() : super();
  factory To_SubscribePriceStream.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory To_SubscribePriceStream.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'To.SubscribePriceStream', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'assetId')
    ..a<$core.bool>(2, _omitFieldNames ? '' : 'sendBitcoins', $pb.PbFieldType.QB)
    ..aInt64(3, _omitFieldNames ? '' : 'sendAmount')
    ..aInt64(4, _omitFieldNames ? '' : 'recvAmount')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  To_SubscribePriceStream clone() => To_SubscribePriceStream()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  To_SubscribePriceStream copyWith(void Function(To_SubscribePriceStream) updates) => super.copyWith((message) => updates(message as To_SubscribePriceStream)) as To_SubscribePriceStream;

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

class To_GaidStatus extends $pb.GeneratedMessage {
  factory To_GaidStatus({
    $core.String? gaid,
    $core.String? assetId,
  }) {
    final $result = create();
    if (gaid != null) {
      $result.gaid = gaid;
    }
    if (assetId != null) {
      $result.assetId = assetId;
    }
    return $result;
  }
  To_GaidStatus._() : super();
  factory To_GaidStatus.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory To_GaidStatus.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'To.GaidStatus', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'gaid')
    ..aQS(2, _omitFieldNames ? '' : 'assetId')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  To_GaidStatus clone() => To_GaidStatus()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  To_GaidStatus copyWith(void Function(To_GaidStatus) updates) => super.copyWith((message) => updates(message as To_GaidStatus)) as To_GaidStatus;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static To_GaidStatus create() => To_GaidStatus._();
  To_GaidStatus createEmptyInstance() => create();
  static $pb.PbList<To_GaidStatus> createRepeated() => $pb.PbList<To_GaidStatus>();
  @$core.pragma('dart2js:noInline')
  static To_GaidStatus getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<To_GaidStatus>(create);
  static To_GaidStatus? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get gaid => $_getSZ(0);
  @$pb.TagNumber(1)
  set gaid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasGaid() => $_has(0);
  @$pb.TagNumber(1)
  void clearGaid() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get assetId => $_getSZ(1);
  @$pb.TagNumber(2)
  set assetId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAssetId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAssetId() => clearField(2);
}

class To_OrderSubmit extends $pb.GeneratedMessage {
  factory To_OrderSubmit({
    AssetPair? assetPair,
    $fixnum.Int64? baseAmount,
    $core.double? price,
    TradeDir? tradeDir,
    $fixnum.Int64? ttlSeconds,
    $core.bool? twoStep,
    $core.bool? txChainingAllowed,
    $core.bool? private,
  }) {
    final $result = create();
    if (assetPair != null) {
      $result.assetPair = assetPair;
    }
    if (baseAmount != null) {
      $result.baseAmount = baseAmount;
    }
    if (price != null) {
      $result.price = price;
    }
    if (tradeDir != null) {
      $result.tradeDir = tradeDir;
    }
    if (ttlSeconds != null) {
      $result.ttlSeconds = ttlSeconds;
    }
    if (twoStep != null) {
      $result.twoStep = twoStep;
    }
    if (txChainingAllowed != null) {
      $result.txChainingAllowed = txChainingAllowed;
    }
    if (private != null) {
      $result.private = private;
    }
    return $result;
  }
  To_OrderSubmit._() : super();
  factory To_OrderSubmit.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory To_OrderSubmit.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'To.OrderSubmit', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQM<AssetPair>(1, _omitFieldNames ? '' : 'assetPair', subBuilder: AssetPair.create)
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'baseAmount', $pb.PbFieldType.QU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'price', $pb.PbFieldType.QD)
    ..e<TradeDir>(4, _omitFieldNames ? '' : 'tradeDir', $pb.PbFieldType.QE, defaultOrMaker: TradeDir.SELL, valueOf: TradeDir.valueOf, enumValues: TradeDir.values)
    ..a<$fixnum.Int64>(5, _omitFieldNames ? '' : 'ttlSeconds', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.bool>(6, _omitFieldNames ? '' : 'twoStep', $pb.PbFieldType.QB)
    ..aOB(7, _omitFieldNames ? '' : 'txChainingAllowed')
    ..a<$core.bool>(8, _omitFieldNames ? '' : 'private', $pb.PbFieldType.QB)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  To_OrderSubmit clone() => To_OrderSubmit()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  To_OrderSubmit copyWith(void Function(To_OrderSubmit) updates) => super.copyWith((message) => updates(message as To_OrderSubmit)) as To_OrderSubmit;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static To_OrderSubmit create() => To_OrderSubmit._();
  To_OrderSubmit createEmptyInstance() => create();
  static $pb.PbList<To_OrderSubmit> createRepeated() => $pb.PbList<To_OrderSubmit>();
  @$core.pragma('dart2js:noInline')
  static To_OrderSubmit getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<To_OrderSubmit>(create);
  static To_OrderSubmit? _defaultInstance;

  @$pb.TagNumber(1)
  AssetPair get assetPair => $_getN(0);
  @$pb.TagNumber(1)
  set assetPair(AssetPair v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasAssetPair() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetPair() => clearField(1);
  @$pb.TagNumber(1)
  AssetPair ensureAssetPair() => $_ensure(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get baseAmount => $_getI64(1);
  @$pb.TagNumber(2)
  set baseAmount($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasBaseAmount() => $_has(1);
  @$pb.TagNumber(2)
  void clearBaseAmount() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get price => $_getN(2);
  @$pb.TagNumber(3)
  set price($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPrice() => $_has(2);
  @$pb.TagNumber(3)
  void clearPrice() => clearField(3);

  @$pb.TagNumber(4)
  TradeDir get tradeDir => $_getN(3);
  @$pb.TagNumber(4)
  set tradeDir(TradeDir v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasTradeDir() => $_has(3);
  @$pb.TagNumber(4)
  void clearTradeDir() => clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get ttlSeconds => $_getI64(4);
  @$pb.TagNumber(5)
  set ttlSeconds($fixnum.Int64 v) { $_setInt64(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasTtlSeconds() => $_has(4);
  @$pb.TagNumber(5)
  void clearTtlSeconds() => clearField(5);

  @$pb.TagNumber(6)
  $core.bool get twoStep => $_getBF(5);
  @$pb.TagNumber(6)
  set twoStep($core.bool v) { $_setBool(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasTwoStep() => $_has(5);
  @$pb.TagNumber(6)
  void clearTwoStep() => clearField(6);

  @$pb.TagNumber(7)
  $core.bool get txChainingAllowed => $_getBF(6);
  @$pb.TagNumber(7)
  set txChainingAllowed($core.bool v) { $_setBool(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasTxChainingAllowed() => $_has(6);
  @$pb.TagNumber(7)
  void clearTxChainingAllowed() => clearField(7);

  @$pb.TagNumber(8)
  $core.bool get private => $_getBF(7);
  @$pb.TagNumber(8)
  set private($core.bool v) { $_setBool(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasPrivate() => $_has(7);
  @$pb.TagNumber(8)
  void clearPrivate() => clearField(8);
}

class To_OrderEdit extends $pb.GeneratedMessage {
  factory To_OrderEdit({
    OrderId? orderId,
    $fixnum.Int64? baseAmount,
    $core.double? price,
  }) {
    final $result = create();
    if (orderId != null) {
      $result.orderId = orderId;
    }
    if (baseAmount != null) {
      $result.baseAmount = baseAmount;
    }
    if (price != null) {
      $result.price = price;
    }
    return $result;
  }
  To_OrderEdit._() : super();
  factory To_OrderEdit.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory To_OrderEdit.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'To.OrderEdit', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQM<OrderId>(1, _omitFieldNames ? '' : 'orderId', subBuilder: OrderId.create)
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'baseAmount', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'price', $pb.PbFieldType.OD)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  To_OrderEdit clone() => To_OrderEdit()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  To_OrderEdit copyWith(void Function(To_OrderEdit) updates) => super.copyWith((message) => updates(message as To_OrderEdit)) as To_OrderEdit;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static To_OrderEdit create() => To_OrderEdit._();
  To_OrderEdit createEmptyInstance() => create();
  static $pb.PbList<To_OrderEdit> createRepeated() => $pb.PbList<To_OrderEdit>();
  @$core.pragma('dart2js:noInline')
  static To_OrderEdit getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<To_OrderEdit>(create);
  static To_OrderEdit? _defaultInstance;

  @$pb.TagNumber(1)
  OrderId get orderId => $_getN(0);
  @$pb.TagNumber(1)
  set orderId(OrderId v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrderId() => clearField(1);
  @$pb.TagNumber(1)
  OrderId ensureOrderId() => $_ensure(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get baseAmount => $_getI64(1);
  @$pb.TagNumber(2)
  set baseAmount($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasBaseAmount() => $_has(1);
  @$pb.TagNumber(2)
  void clearBaseAmount() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get price => $_getN(2);
  @$pb.TagNumber(3)
  set price($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPrice() => $_has(2);
  @$pb.TagNumber(3)
  void clearPrice() => clearField(3);
}

class To_OrderCancel extends $pb.GeneratedMessage {
  factory To_OrderCancel({
    OrderId? orderId,
  }) {
    final $result = create();
    if (orderId != null) {
      $result.orderId = orderId;
    }
    return $result;
  }
  To_OrderCancel._() : super();
  factory To_OrderCancel.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory To_OrderCancel.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'To.OrderCancel', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQM<OrderId>(1, _omitFieldNames ? '' : 'orderId', subBuilder: OrderId.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  To_OrderCancel clone() => To_OrderCancel()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  To_OrderCancel copyWith(void Function(To_OrderCancel) updates) => super.copyWith((message) => updates(message as To_OrderCancel)) as To_OrderCancel;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static To_OrderCancel create() => To_OrderCancel._();
  To_OrderCancel createEmptyInstance() => create();
  static $pb.PbList<To_OrderCancel> createRepeated() => $pb.PbList<To_OrderCancel>();
  @$core.pragma('dart2js:noInline')
  static To_OrderCancel getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<To_OrderCancel>(create);
  static To_OrderCancel? _defaultInstance;

  @$pb.TagNumber(1)
  OrderId get orderId => $_getN(0);
  @$pb.TagNumber(1)
  set orderId(OrderId v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrderId() => clearField(1);
  @$pb.TagNumber(1)
  OrderId ensureOrderId() => $_ensure(0);
}

class To_StartQuotes extends $pb.GeneratedMessage {
  factory To_StartQuotes({
    AssetPair? assetPair,
    AssetType? assetType,
    $fixnum.Int64? amount,
    TradeDir? tradeDir,
  }) {
    final $result = create();
    if (assetPair != null) {
      $result.assetPair = assetPair;
    }
    if (assetType != null) {
      $result.assetType = assetType;
    }
    if (amount != null) {
      $result.amount = amount;
    }
    if (tradeDir != null) {
      $result.tradeDir = tradeDir;
    }
    return $result;
  }
  To_StartQuotes._() : super();
  factory To_StartQuotes.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory To_StartQuotes.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'To.StartQuotes', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQM<AssetPair>(1, _omitFieldNames ? '' : 'assetPair', subBuilder: AssetPair.create)
    ..e<AssetType>(2, _omitFieldNames ? '' : 'assetType', $pb.PbFieldType.QE, defaultOrMaker: AssetType.BASE, valueOf: AssetType.valueOf, enumValues: AssetType.values)
    ..a<$fixnum.Int64>(3, _omitFieldNames ? '' : 'amount', $pb.PbFieldType.QU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..e<TradeDir>(4, _omitFieldNames ? '' : 'tradeDir', $pb.PbFieldType.QE, defaultOrMaker: TradeDir.SELL, valueOf: TradeDir.valueOf, enumValues: TradeDir.values)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  To_StartQuotes clone() => To_StartQuotes()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  To_StartQuotes copyWith(void Function(To_StartQuotes) updates) => super.copyWith((message) => updates(message as To_StartQuotes)) as To_StartQuotes;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static To_StartQuotes create() => To_StartQuotes._();
  To_StartQuotes createEmptyInstance() => create();
  static $pb.PbList<To_StartQuotes> createRepeated() => $pb.PbList<To_StartQuotes>();
  @$core.pragma('dart2js:noInline')
  static To_StartQuotes getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<To_StartQuotes>(create);
  static To_StartQuotes? _defaultInstance;

  @$pb.TagNumber(1)
  AssetPair get assetPair => $_getN(0);
  @$pb.TagNumber(1)
  set assetPair(AssetPair v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasAssetPair() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetPair() => clearField(1);
  @$pb.TagNumber(1)
  AssetPair ensureAssetPair() => $_ensure(0);

  @$pb.TagNumber(2)
  AssetType get assetType => $_getN(1);
  @$pb.TagNumber(2)
  set assetType(AssetType v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasAssetType() => $_has(1);
  @$pb.TagNumber(2)
  void clearAssetType() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get amount => $_getI64(2);
  @$pb.TagNumber(3)
  set amount($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAmount() => $_has(2);
  @$pb.TagNumber(3)
  void clearAmount() => clearField(3);

  @$pb.TagNumber(4)
  TradeDir get tradeDir => $_getN(3);
  @$pb.TagNumber(4)
  set tradeDir(TradeDir v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasTradeDir() => $_has(3);
  @$pb.TagNumber(4)
  void clearTradeDir() => clearField(4);
}

class To_StartOrder extends $pb.GeneratedMessage {
  factory To_StartOrder({
    $fixnum.Int64? orderId,
    $core.String? privateId,
  }) {
    final $result = create();
    if (orderId != null) {
      $result.orderId = orderId;
    }
    if (privateId != null) {
      $result.privateId = privateId;
    }
    return $result;
  }
  To_StartOrder._() : super();
  factory To_StartOrder.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory To_StartOrder.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'To.StartOrder', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'orderId', $pb.PbFieldType.QU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(2, _omitFieldNames ? '' : 'privateId')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  To_StartOrder clone() => To_StartOrder()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  To_StartOrder copyWith(void Function(To_StartOrder) updates) => super.copyWith((message) => updates(message as To_StartOrder)) as To_StartOrder;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static To_StartOrder create() => To_StartOrder._();
  To_StartOrder createEmptyInstance() => create();
  static $pb.PbList<To_StartOrder> createRepeated() => $pb.PbList<To_StartOrder>();
  @$core.pragma('dart2js:noInline')
  static To_StartOrder getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<To_StartOrder>(create);
  static To_StartOrder? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get orderId => $_getI64(0);
  @$pb.TagNumber(1)
  set orderId($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrderId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get privateId => $_getSZ(1);
  @$pb.TagNumber(2)
  set privateId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPrivateId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPrivateId() => clearField(2);
}

class To_AcceptQuote extends $pb.GeneratedMessage {
  factory To_AcceptQuote({
    $fixnum.Int64? quoteId,
  }) {
    final $result = create();
    if (quoteId != null) {
      $result.quoteId = quoteId;
    }
    return $result;
  }
  To_AcceptQuote._() : super();
  factory To_AcceptQuote.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory To_AcceptQuote.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'To.AcceptQuote', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'quoteId', $pb.PbFieldType.QU6, defaultOrMaker: $fixnum.Int64.ZERO)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  To_AcceptQuote clone() => To_AcceptQuote()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  To_AcceptQuote copyWith(void Function(To_AcceptQuote) updates) => super.copyWith((message) => updates(message as To_AcceptQuote)) as To_AcceptQuote;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static To_AcceptQuote create() => To_AcceptQuote._();
  To_AcceptQuote createEmptyInstance() => create();
  static $pb.PbList<To_AcceptQuote> createRepeated() => $pb.PbList<To_AcceptQuote>();
  @$core.pragma('dart2js:noInline')
  static To_AcceptQuote getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<To_AcceptQuote>(create);
  static To_AcceptQuote? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get quoteId => $_getI64(0);
  @$pb.TagNumber(1)
  set quoteId($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasQuoteId() => $_has(0);
  @$pb.TagNumber(1)
  void clearQuoteId() => clearField(1);
}

class To_LoadHistory extends $pb.GeneratedMessage {
  factory To_LoadHistory({
    $fixnum.Int64? startTime,
    $fixnum.Int64? endTime,
    $core.int? skip,
    $core.int? count,
  }) {
    final $result = create();
    if (startTime != null) {
      $result.startTime = startTime;
    }
    if (endTime != null) {
      $result.endTime = endTime;
    }
    if (skip != null) {
      $result.skip = skip;
    }
    if (count != null) {
      $result.count = count;
    }
    return $result;
  }
  To_LoadHistory._() : super();
  factory To_LoadHistory.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory To_LoadHistory.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'To.LoadHistory', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'startTime', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'endTime', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'skip', $pb.PbFieldType.OU3)
    ..a<$core.int>(4, _omitFieldNames ? '' : 'count', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  To_LoadHistory clone() => To_LoadHistory()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  To_LoadHistory copyWith(void Function(To_LoadHistory) updates) => super.copyWith((message) => updates(message as To_LoadHistory)) as To_LoadHistory;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static To_LoadHistory create() => To_LoadHistory._();
  To_LoadHistory createEmptyInstance() => create();
  static $pb.PbList<To_LoadHistory> createRepeated() => $pb.PbList<To_LoadHistory>();
  @$core.pragma('dart2js:noInline')
  static To_LoadHistory getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<To_LoadHistory>(create);
  static To_LoadHistory? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get startTime => $_getI64(0);
  @$pb.TagNumber(1)
  set startTime($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasStartTime() => $_has(0);
  @$pb.TagNumber(1)
  void clearStartTime() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get endTime => $_getI64(1);
  @$pb.TagNumber(2)
  set endTime($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasEndTime() => $_has(1);
  @$pb.TagNumber(2)
  void clearEndTime() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get skip => $_getIZ(2);
  @$pb.TagNumber(3)
  set skip($core.int v) { $_setUnsignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSkip() => $_has(2);
  @$pb.TagNumber(3)
  void clearSkip() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get count => $_getIZ(3);
  @$pb.TagNumber(4)
  set count($core.int v) { $_setUnsignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasCount() => $_has(3);
  @$pb.TagNumber(4)
  void clearCount() => clearField(4);
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
  loadUtxos, 
  loadAddresses, 
  swapRequest, 
  pegInRequest, 
  pegOutRequest, 
  pegOutAmount, 
  assetDetails, 
  subscribePriceStream, 
  unsubscribePriceStream, 
  portfolioPrices, 
  conversionRates, 
  jadeRescan, 
  gaidStatus, 
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
    Account? loadUtxos,
    Account? loadAddresses,
    To_SwapRequest? swapRequest,
    To_PegInRequest? pegInRequest,
    To_PegOutRequest? pegOutRequest,
    To_PegOutAmount? pegOutAmount,
    AssetId? assetDetails,
    To_SubscribePriceStream? subscribePriceStream,
    Empty? unsubscribePriceStream,
    Empty? portfolioPrices,
    Empty? conversionRates,
    Empty? jadeRescan,
    To_GaidStatus? gaidStatus,
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
  }) {
    final $result = create();
    if (login != null) {
      $result.login = login;
    }
    if (logout != null) {
      $result.logout = logout;
    }
    if (updatePushToken != null) {
      $result.updatePushToken = updatePushToken;
    }
    if (encryptPin != null) {
      $result.encryptPin = encryptPin;
    }
    if (decryptPin != null) {
      $result.decryptPin = decryptPin;
    }
    if (pushMessage != null) {
      $result.pushMessage = pushMessage;
    }
    if (proxySettings != null) {
      $result.proxySettings = proxySettings;
    }
    if (appState != null) {
      $result.appState = appState;
    }
    if (networkSettings != null) {
      $result.networkSettings = networkSettings;
    }
    if (setMemo != null) {
      $result.setMemo = setMemo;
    }
    if (getRecvAddress != null) {
      $result.getRecvAddress = getRecvAddress;
    }
    if (createTx != null) {
      $result.createTx = createTx;
    }
    if (sendTx != null) {
      $result.sendTx = sendTx;
    }
    if (blindedValues != null) {
      $result.blindedValues = blindedValues;
    }
    if (loadUtxos != null) {
      $result.loadUtxos = loadUtxos;
    }
    if (loadAddresses != null) {
      $result.loadAddresses = loadAddresses;
    }
    if (swapRequest != null) {
      $result.swapRequest = swapRequest;
    }
    if (pegInRequest != null) {
      $result.pegInRequest = pegInRequest;
    }
    if (pegOutRequest != null) {
      $result.pegOutRequest = pegOutRequest;
    }
    if (pegOutAmount != null) {
      $result.pegOutAmount = pegOutAmount;
    }
    if (assetDetails != null) {
      $result.assetDetails = assetDetails;
    }
    if (subscribePriceStream != null) {
      $result.subscribePriceStream = subscribePriceStream;
    }
    if (unsubscribePriceStream != null) {
      $result.unsubscribePriceStream = unsubscribePriceStream;
    }
    if (portfolioPrices != null) {
      $result.portfolioPrices = portfolioPrices;
    }
    if (conversionRates != null) {
      $result.conversionRates = conversionRates;
    }
    if (jadeRescan != null) {
      $result.jadeRescan = jadeRescan;
    }
    if (gaidStatus != null) {
      $result.gaidStatus = gaidStatus;
    }
    if (marketSubscribe != null) {
      $result.marketSubscribe = marketSubscribe;
    }
    if (marketUnsubscribe != null) {
      $result.marketUnsubscribe = marketUnsubscribe;
    }
    if (orderSubmit != null) {
      $result.orderSubmit = orderSubmit;
    }
    if (orderEdit != null) {
      $result.orderEdit = orderEdit;
    }
    if (orderCancel != null) {
      $result.orderCancel = orderCancel;
    }
    if (startQuotes != null) {
      $result.startQuotes = startQuotes;
    }
    if (stopQuotes != null) {
      $result.stopQuotes = stopQuotes;
    }
    if (acceptQuote != null) {
      $result.acceptQuote = acceptQuote;
    }
    if (startOrder != null) {
      $result.startOrder = startOrder;
    }
    if (chartsSubscribe != null) {
      $result.chartsSubscribe = chartsSubscribe;
    }
    if (chartsUnsubscribe != null) {
      $result.chartsUnsubscribe = chartsUnsubscribe;
    }
    if (loadHistory != null) {
      $result.loadHistory = loadHistory;
    }
    return $result;
  }
  To._() : super();
  factory To.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory To.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, To_Msg> _To_MsgByTag = {
    1 : To_Msg.login,
    2 : To_Msg.logout,
    3 : To_Msg.updatePushToken,
    4 : To_Msg.encryptPin,
    5 : To_Msg.decryptPin,
    6 : To_Msg.pushMessage,
    7 : To_Msg.proxySettings,
    8 : To_Msg.appState,
    9 : To_Msg.networkSettings,
    10 : To_Msg.setMemo,
    11 : To_Msg.getRecvAddress,
    12 : To_Msg.createTx,
    13 : To_Msg.sendTx,
    14 : To_Msg.blindedValues,
    17 : To_Msg.loadUtxos,
    18 : To_Msg.loadAddresses,
    20 : To_Msg.swapRequest,
    21 : To_Msg.pegInRequest,
    22 : To_Msg.pegOutRequest,
    24 : To_Msg.pegOutAmount,
    57 : To_Msg.assetDetails,
    58 : To_Msg.subscribePriceStream,
    59 : To_Msg.unsubscribePriceStream,
    62 : To_Msg.portfolioPrices,
    63 : To_Msg.conversionRates,
    71 : To_Msg.jadeRescan,
    81 : To_Msg.gaidStatus,
    100 : To_Msg.marketSubscribe,
    101 : To_Msg.marketUnsubscribe,
    102 : To_Msg.orderSubmit,
    103 : To_Msg.orderEdit,
    104 : To_Msg.orderCancel,
    110 : To_Msg.startQuotes,
    111 : To_Msg.stopQuotes,
    112 : To_Msg.acceptQuote,
    113 : To_Msg.startOrder,
    120 : To_Msg.chartsSubscribe,
    121 : To_Msg.chartsUnsubscribe,
    130 : To_Msg.loadHistory,
    0 : To_Msg.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'To', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 17, 18, 20, 21, 22, 24, 57, 58, 59, 62, 63, 71, 81, 100, 101, 102, 103, 104, 110, 111, 112, 113, 120, 121, 130])
    ..aOM<To_Login>(1, _omitFieldNames ? '' : 'login', subBuilder: To_Login.create)
    ..aOM<Empty>(2, _omitFieldNames ? '' : 'logout', subBuilder: Empty.create)
    ..aOM<To_UpdatePushToken>(3, _omitFieldNames ? '' : 'updatePushToken', subBuilder: To_UpdatePushToken.create)
    ..aOM<To_EncryptPin>(4, _omitFieldNames ? '' : 'encryptPin', subBuilder: To_EncryptPin.create)
    ..aOM<To_DecryptPin>(5, _omitFieldNames ? '' : 'decryptPin', subBuilder: To_DecryptPin.create)
    ..aOS(6, _omitFieldNames ? '' : 'pushMessage')
    ..aOM<To_ProxySettings>(7, _omitFieldNames ? '' : 'proxySettings', subBuilder: To_ProxySettings.create)
    ..aOM<To_AppState>(8, _omitFieldNames ? '' : 'appState', subBuilder: To_AppState.create)
    ..aOM<To_NetworkSettings>(9, _omitFieldNames ? '' : 'networkSettings', subBuilder: To_NetworkSettings.create)
    ..aOM<To_SetMemo>(10, _omitFieldNames ? '' : 'setMemo', subBuilder: To_SetMemo.create)
    ..aOM<Account>(11, _omitFieldNames ? '' : 'getRecvAddress', subBuilder: Account.create)
    ..aOM<CreateTx>(12, _omitFieldNames ? '' : 'createTx', subBuilder: CreateTx.create)
    ..aOM<To_SendTx>(13, _omitFieldNames ? '' : 'sendTx', subBuilder: To_SendTx.create)
    ..aOM<To_BlindedValues>(14, _omitFieldNames ? '' : 'blindedValues', subBuilder: To_BlindedValues.create)
    ..aOM<Account>(17, _omitFieldNames ? '' : 'loadUtxos', subBuilder: Account.create)
    ..aOM<Account>(18, _omitFieldNames ? '' : 'loadAddresses', subBuilder: Account.create)
    ..aOM<To_SwapRequest>(20, _omitFieldNames ? '' : 'swapRequest', subBuilder: To_SwapRequest.create)
    ..aOM<To_PegInRequest>(21, _omitFieldNames ? '' : 'pegInRequest', subBuilder: To_PegInRequest.create)
    ..aOM<To_PegOutRequest>(22, _omitFieldNames ? '' : 'pegOutRequest', subBuilder: To_PegOutRequest.create)
    ..aOM<To_PegOutAmount>(24, _omitFieldNames ? '' : 'pegOutAmount', subBuilder: To_PegOutAmount.create)
    ..aOM<AssetId>(57, _omitFieldNames ? '' : 'assetDetails', subBuilder: AssetId.create)
    ..aOM<To_SubscribePriceStream>(58, _omitFieldNames ? '' : 'subscribePriceStream', subBuilder: To_SubscribePriceStream.create)
    ..aOM<Empty>(59, _omitFieldNames ? '' : 'unsubscribePriceStream', subBuilder: Empty.create)
    ..aOM<Empty>(62, _omitFieldNames ? '' : 'portfolioPrices', subBuilder: Empty.create)
    ..aOM<Empty>(63, _omitFieldNames ? '' : 'conversionRates', subBuilder: Empty.create)
    ..aOM<Empty>(71, _omitFieldNames ? '' : 'jadeRescan', subBuilder: Empty.create)
    ..aOM<To_GaidStatus>(81, _omitFieldNames ? '' : 'gaidStatus', subBuilder: To_GaidStatus.create)
    ..aOM<AssetPair>(100, _omitFieldNames ? '' : 'marketSubscribe', subBuilder: AssetPair.create)
    ..aOM<Empty>(101, _omitFieldNames ? '' : 'marketUnsubscribe', subBuilder: Empty.create)
    ..aOM<To_OrderSubmit>(102, _omitFieldNames ? '' : 'orderSubmit', subBuilder: To_OrderSubmit.create)
    ..aOM<To_OrderEdit>(103, _omitFieldNames ? '' : 'orderEdit', subBuilder: To_OrderEdit.create)
    ..aOM<To_OrderCancel>(104, _omitFieldNames ? '' : 'orderCancel', subBuilder: To_OrderCancel.create)
    ..aOM<To_StartQuotes>(110, _omitFieldNames ? '' : 'startQuotes', subBuilder: To_StartQuotes.create)
    ..aOM<Empty>(111, _omitFieldNames ? '' : 'stopQuotes', subBuilder: Empty.create)
    ..aOM<To_AcceptQuote>(112, _omitFieldNames ? '' : 'acceptQuote', subBuilder: To_AcceptQuote.create)
    ..aOM<To_StartOrder>(113, _omitFieldNames ? '' : 'startOrder', subBuilder: To_StartOrder.create)
    ..aOM<AssetPair>(120, _omitFieldNames ? '' : 'chartsSubscribe', subBuilder: AssetPair.create)
    ..aOM<Empty>(121, _omitFieldNames ? '' : 'chartsUnsubscribe', subBuilder: Empty.create)
    ..aOM<To_LoadHistory>(130, _omitFieldNames ? '' : 'loadHistory', subBuilder: To_LoadHistory.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  To clone() => To()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  To copyWith(void Function(To) updates) => super.copyWith((message) => updates(message as To)) as To;

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

  @$pb.TagNumber(7)
  To_ProxySettings get proxySettings => $_getN(6);
  @$pb.TagNumber(7)
  set proxySettings(To_ProxySettings v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasProxySettings() => $_has(6);
  @$pb.TagNumber(7)
  void clearProxySettings() => clearField(7);
  @$pb.TagNumber(7)
  To_ProxySettings ensureProxySettings() => $_ensure(6);

  @$pb.TagNumber(8)
  To_AppState get appState => $_getN(7);
  @$pb.TagNumber(8)
  set appState(To_AppState v) { setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasAppState() => $_has(7);
  @$pb.TagNumber(8)
  void clearAppState() => clearField(8);
  @$pb.TagNumber(8)
  To_AppState ensureAppState() => $_ensure(7);

  @$pb.TagNumber(9)
  To_NetworkSettings get networkSettings => $_getN(8);
  @$pb.TagNumber(9)
  set networkSettings(To_NetworkSettings v) { setField(9, v); }
  @$pb.TagNumber(9)
  $core.bool hasNetworkSettings() => $_has(8);
  @$pb.TagNumber(9)
  void clearNetworkSettings() => clearField(9);
  @$pb.TagNumber(9)
  To_NetworkSettings ensureNetworkSettings() => $_ensure(8);

  @$pb.TagNumber(10)
  To_SetMemo get setMemo => $_getN(9);
  @$pb.TagNumber(10)
  set setMemo(To_SetMemo v) { setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasSetMemo() => $_has(9);
  @$pb.TagNumber(10)
  void clearSetMemo() => clearField(10);
  @$pb.TagNumber(10)
  To_SetMemo ensureSetMemo() => $_ensure(9);

  @$pb.TagNumber(11)
  Account get getRecvAddress => $_getN(10);
  @$pb.TagNumber(11)
  set getRecvAddress(Account v) { setField(11, v); }
  @$pb.TagNumber(11)
  $core.bool hasGetRecvAddress() => $_has(10);
  @$pb.TagNumber(11)
  void clearGetRecvAddress() => clearField(11);
  @$pb.TagNumber(11)
  Account ensureGetRecvAddress() => $_ensure(10);

  @$pb.TagNumber(12)
  CreateTx get createTx => $_getN(11);
  @$pb.TagNumber(12)
  set createTx(CreateTx v) { setField(12, v); }
  @$pb.TagNumber(12)
  $core.bool hasCreateTx() => $_has(11);
  @$pb.TagNumber(12)
  void clearCreateTx() => clearField(12);
  @$pb.TagNumber(12)
  CreateTx ensureCreateTx() => $_ensure(11);

  @$pb.TagNumber(13)
  To_SendTx get sendTx => $_getN(12);
  @$pb.TagNumber(13)
  set sendTx(To_SendTx v) { setField(13, v); }
  @$pb.TagNumber(13)
  $core.bool hasSendTx() => $_has(12);
  @$pb.TagNumber(13)
  void clearSendTx() => clearField(13);
  @$pb.TagNumber(13)
  To_SendTx ensureSendTx() => $_ensure(12);

  @$pb.TagNumber(14)
  To_BlindedValues get blindedValues => $_getN(13);
  @$pb.TagNumber(14)
  set blindedValues(To_BlindedValues v) { setField(14, v); }
  @$pb.TagNumber(14)
  $core.bool hasBlindedValues() => $_has(13);
  @$pb.TagNumber(14)
  void clearBlindedValues() => clearField(14);
  @$pb.TagNumber(14)
  To_BlindedValues ensureBlindedValues() => $_ensure(13);

  @$pb.TagNumber(17)
  Account get loadUtxos => $_getN(14);
  @$pb.TagNumber(17)
  set loadUtxos(Account v) { setField(17, v); }
  @$pb.TagNumber(17)
  $core.bool hasLoadUtxos() => $_has(14);
  @$pb.TagNumber(17)
  void clearLoadUtxos() => clearField(17);
  @$pb.TagNumber(17)
  Account ensureLoadUtxos() => $_ensure(14);

  @$pb.TagNumber(18)
  Account get loadAddresses => $_getN(15);
  @$pb.TagNumber(18)
  set loadAddresses(Account v) { setField(18, v); }
  @$pb.TagNumber(18)
  $core.bool hasLoadAddresses() => $_has(15);
  @$pb.TagNumber(18)
  void clearLoadAddresses() => clearField(18);
  @$pb.TagNumber(18)
  Account ensureLoadAddresses() => $_ensure(15);

  @$pb.TagNumber(20)
  To_SwapRequest get swapRequest => $_getN(16);
  @$pb.TagNumber(20)
  set swapRequest(To_SwapRequest v) { setField(20, v); }
  @$pb.TagNumber(20)
  $core.bool hasSwapRequest() => $_has(16);
  @$pb.TagNumber(20)
  void clearSwapRequest() => clearField(20);
  @$pb.TagNumber(20)
  To_SwapRequest ensureSwapRequest() => $_ensure(16);

  @$pb.TagNumber(21)
  To_PegInRequest get pegInRequest => $_getN(17);
  @$pb.TagNumber(21)
  set pegInRequest(To_PegInRequest v) { setField(21, v); }
  @$pb.TagNumber(21)
  $core.bool hasPegInRequest() => $_has(17);
  @$pb.TagNumber(21)
  void clearPegInRequest() => clearField(21);
  @$pb.TagNumber(21)
  To_PegInRequest ensurePegInRequest() => $_ensure(17);

  @$pb.TagNumber(22)
  To_PegOutRequest get pegOutRequest => $_getN(18);
  @$pb.TagNumber(22)
  set pegOutRequest(To_PegOutRequest v) { setField(22, v); }
  @$pb.TagNumber(22)
  $core.bool hasPegOutRequest() => $_has(18);
  @$pb.TagNumber(22)
  void clearPegOutRequest() => clearField(22);
  @$pb.TagNumber(22)
  To_PegOutRequest ensurePegOutRequest() => $_ensure(18);

  @$pb.TagNumber(24)
  To_PegOutAmount get pegOutAmount => $_getN(19);
  @$pb.TagNumber(24)
  set pegOutAmount(To_PegOutAmount v) { setField(24, v); }
  @$pb.TagNumber(24)
  $core.bool hasPegOutAmount() => $_has(19);
  @$pb.TagNumber(24)
  void clearPegOutAmount() => clearField(24);
  @$pb.TagNumber(24)
  To_PegOutAmount ensurePegOutAmount() => $_ensure(19);

  @$pb.TagNumber(57)
  AssetId get assetDetails => $_getN(20);
  @$pb.TagNumber(57)
  set assetDetails(AssetId v) { setField(57, v); }
  @$pb.TagNumber(57)
  $core.bool hasAssetDetails() => $_has(20);
  @$pb.TagNumber(57)
  void clearAssetDetails() => clearField(57);
  @$pb.TagNumber(57)
  AssetId ensureAssetDetails() => $_ensure(20);

  @$pb.TagNumber(58)
  To_SubscribePriceStream get subscribePriceStream => $_getN(21);
  @$pb.TagNumber(58)
  set subscribePriceStream(To_SubscribePriceStream v) { setField(58, v); }
  @$pb.TagNumber(58)
  $core.bool hasSubscribePriceStream() => $_has(21);
  @$pb.TagNumber(58)
  void clearSubscribePriceStream() => clearField(58);
  @$pb.TagNumber(58)
  To_SubscribePriceStream ensureSubscribePriceStream() => $_ensure(21);

  @$pb.TagNumber(59)
  Empty get unsubscribePriceStream => $_getN(22);
  @$pb.TagNumber(59)
  set unsubscribePriceStream(Empty v) { setField(59, v); }
  @$pb.TagNumber(59)
  $core.bool hasUnsubscribePriceStream() => $_has(22);
  @$pb.TagNumber(59)
  void clearUnsubscribePriceStream() => clearField(59);
  @$pb.TagNumber(59)
  Empty ensureUnsubscribePriceStream() => $_ensure(22);

  @$pb.TagNumber(62)
  Empty get portfolioPrices => $_getN(23);
  @$pb.TagNumber(62)
  set portfolioPrices(Empty v) { setField(62, v); }
  @$pb.TagNumber(62)
  $core.bool hasPortfolioPrices() => $_has(23);
  @$pb.TagNumber(62)
  void clearPortfolioPrices() => clearField(62);
  @$pb.TagNumber(62)
  Empty ensurePortfolioPrices() => $_ensure(23);

  @$pb.TagNumber(63)
  Empty get conversionRates => $_getN(24);
  @$pb.TagNumber(63)
  set conversionRates(Empty v) { setField(63, v); }
  @$pb.TagNumber(63)
  $core.bool hasConversionRates() => $_has(24);
  @$pb.TagNumber(63)
  void clearConversionRates() => clearField(63);
  @$pb.TagNumber(63)
  Empty ensureConversionRates() => $_ensure(24);

  @$pb.TagNumber(71)
  Empty get jadeRescan => $_getN(25);
  @$pb.TagNumber(71)
  set jadeRescan(Empty v) { setField(71, v); }
  @$pb.TagNumber(71)
  $core.bool hasJadeRescan() => $_has(25);
  @$pb.TagNumber(71)
  void clearJadeRescan() => clearField(71);
  @$pb.TagNumber(71)
  Empty ensureJadeRescan() => $_ensure(25);

  @$pb.TagNumber(81)
  To_GaidStatus get gaidStatus => $_getN(26);
  @$pb.TagNumber(81)
  set gaidStatus(To_GaidStatus v) { setField(81, v); }
  @$pb.TagNumber(81)
  $core.bool hasGaidStatus() => $_has(26);
  @$pb.TagNumber(81)
  void clearGaidStatus() => clearField(81);
  @$pb.TagNumber(81)
  To_GaidStatus ensureGaidStatus() => $_ensure(26);

  @$pb.TagNumber(100)
  AssetPair get marketSubscribe => $_getN(27);
  @$pb.TagNumber(100)
  set marketSubscribe(AssetPair v) { setField(100, v); }
  @$pb.TagNumber(100)
  $core.bool hasMarketSubscribe() => $_has(27);
  @$pb.TagNumber(100)
  void clearMarketSubscribe() => clearField(100);
  @$pb.TagNumber(100)
  AssetPair ensureMarketSubscribe() => $_ensure(27);

  @$pb.TagNumber(101)
  Empty get marketUnsubscribe => $_getN(28);
  @$pb.TagNumber(101)
  set marketUnsubscribe(Empty v) { setField(101, v); }
  @$pb.TagNumber(101)
  $core.bool hasMarketUnsubscribe() => $_has(28);
  @$pb.TagNumber(101)
  void clearMarketUnsubscribe() => clearField(101);
  @$pb.TagNumber(101)
  Empty ensureMarketUnsubscribe() => $_ensure(28);

  @$pb.TagNumber(102)
  To_OrderSubmit get orderSubmit => $_getN(29);
  @$pb.TagNumber(102)
  set orderSubmit(To_OrderSubmit v) { setField(102, v); }
  @$pb.TagNumber(102)
  $core.bool hasOrderSubmit() => $_has(29);
  @$pb.TagNumber(102)
  void clearOrderSubmit() => clearField(102);
  @$pb.TagNumber(102)
  To_OrderSubmit ensureOrderSubmit() => $_ensure(29);

  @$pb.TagNumber(103)
  To_OrderEdit get orderEdit => $_getN(30);
  @$pb.TagNumber(103)
  set orderEdit(To_OrderEdit v) { setField(103, v); }
  @$pb.TagNumber(103)
  $core.bool hasOrderEdit() => $_has(30);
  @$pb.TagNumber(103)
  void clearOrderEdit() => clearField(103);
  @$pb.TagNumber(103)
  To_OrderEdit ensureOrderEdit() => $_ensure(30);

  @$pb.TagNumber(104)
  To_OrderCancel get orderCancel => $_getN(31);
  @$pb.TagNumber(104)
  set orderCancel(To_OrderCancel v) { setField(104, v); }
  @$pb.TagNumber(104)
  $core.bool hasOrderCancel() => $_has(31);
  @$pb.TagNumber(104)
  void clearOrderCancel() => clearField(104);
  @$pb.TagNumber(104)
  To_OrderCancel ensureOrderCancel() => $_ensure(31);

  @$pb.TagNumber(110)
  To_StartQuotes get startQuotes => $_getN(32);
  @$pb.TagNumber(110)
  set startQuotes(To_StartQuotes v) { setField(110, v); }
  @$pb.TagNumber(110)
  $core.bool hasStartQuotes() => $_has(32);
  @$pb.TagNumber(110)
  void clearStartQuotes() => clearField(110);
  @$pb.TagNumber(110)
  To_StartQuotes ensureStartQuotes() => $_ensure(32);

  @$pb.TagNumber(111)
  Empty get stopQuotes => $_getN(33);
  @$pb.TagNumber(111)
  set stopQuotes(Empty v) { setField(111, v); }
  @$pb.TagNumber(111)
  $core.bool hasStopQuotes() => $_has(33);
  @$pb.TagNumber(111)
  void clearStopQuotes() => clearField(111);
  @$pb.TagNumber(111)
  Empty ensureStopQuotes() => $_ensure(33);

  @$pb.TagNumber(112)
  To_AcceptQuote get acceptQuote => $_getN(34);
  @$pb.TagNumber(112)
  set acceptQuote(To_AcceptQuote v) { setField(112, v); }
  @$pb.TagNumber(112)
  $core.bool hasAcceptQuote() => $_has(34);
  @$pb.TagNumber(112)
  void clearAcceptQuote() => clearField(112);
  @$pb.TagNumber(112)
  To_AcceptQuote ensureAcceptQuote() => $_ensure(34);

  @$pb.TagNumber(113)
  To_StartOrder get startOrder => $_getN(35);
  @$pb.TagNumber(113)
  set startOrder(To_StartOrder v) { setField(113, v); }
  @$pb.TagNumber(113)
  $core.bool hasStartOrder() => $_has(35);
  @$pb.TagNumber(113)
  void clearStartOrder() => clearField(113);
  @$pb.TagNumber(113)
  To_StartOrder ensureStartOrder() => $_ensure(35);

  @$pb.TagNumber(120)
  AssetPair get chartsSubscribe => $_getN(36);
  @$pb.TagNumber(120)
  set chartsSubscribe(AssetPair v) { setField(120, v); }
  @$pb.TagNumber(120)
  $core.bool hasChartsSubscribe() => $_has(36);
  @$pb.TagNumber(120)
  void clearChartsSubscribe() => clearField(120);
  @$pb.TagNumber(120)
  AssetPair ensureChartsSubscribe() => $_ensure(36);

  @$pb.TagNumber(121)
  Empty get chartsUnsubscribe => $_getN(37);
  @$pb.TagNumber(121)
  set chartsUnsubscribe(Empty v) { setField(121, v); }
  @$pb.TagNumber(121)
  $core.bool hasChartsUnsubscribe() => $_has(37);
  @$pb.TagNumber(121)
  void clearChartsUnsubscribe() => clearField(121);
  @$pb.TagNumber(121)
  Empty ensureChartsUnsubscribe() => $_ensure(37);

  @$pb.TagNumber(130)
  To_LoadHistory get loadHistory => $_getN(38);
  @$pb.TagNumber(130)
  set loadHistory(To_LoadHistory v) { setField(130, v); }
  @$pb.TagNumber(130)
  $core.bool hasLoadHistory() => $_has(38);
  @$pb.TagNumber(130)
  void clearLoadHistory() => clearField(130);
  @$pb.TagNumber(130)
  To_LoadHistory ensureLoadHistory() => $_ensure(38);
}

enum From_Login_Result {
  errorMsg, 
  success, 
  notSet
}

class From_Login extends $pb.GeneratedMessage {
  factory From_Login({
    $core.String? errorMsg,
    Empty? success,
  }) {
    final $result = create();
    if (errorMsg != null) {
      $result.errorMsg = errorMsg;
    }
    if (success != null) {
      $result.success = success;
    }
    return $result;
  }
  From_Login._() : super();
  factory From_Login.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_Login.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, From_Login_Result> _From_Login_ResultByTag = {
    1 : From_Login_Result.errorMsg,
    2 : From_Login_Result.success,
    0 : From_Login_Result.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.Login', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOS(1, _omitFieldNames ? '' : 'errorMsg')
    ..aOM<Empty>(2, _omitFieldNames ? '' : 'success', subBuilder: Empty.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_Login clone() => From_Login()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_Login copyWith(void Function(From_Login) updates) => super.copyWith((message) => updates(message as From_Login)) as From_Login;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_Login create() => From_Login._();
  From_Login createEmptyInstance() => create();
  static $pb.PbList<From_Login> createRepeated() => $pb.PbList<From_Login>();
  @$core.pragma('dart2js:noInline')
  static From_Login getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_Login>(create);
  static From_Login? _defaultInstance;

  From_Login_Result whichResult() => _From_Login_ResultByTag[$_whichOneof(0)]!;
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
  Empty get success => $_getN(1);
  @$pb.TagNumber(2)
  set success(Empty v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasSuccess() => $_has(1);
  @$pb.TagNumber(2)
  void clearSuccess() => clearField(2);
  @$pb.TagNumber(2)
  Empty ensureSuccess() => $_ensure(1);
}

class From_EnvSettings extends $pb.GeneratedMessage {
  factory From_EnvSettings({
    $core.String? policyAssetId,
    $core.String? usdtAssetId,
    $core.String? eurxAssetId,
  }) {
    final $result = create();
    if (policyAssetId != null) {
      $result.policyAssetId = policyAssetId;
    }
    if (usdtAssetId != null) {
      $result.usdtAssetId = usdtAssetId;
    }
    if (eurxAssetId != null) {
      $result.eurxAssetId = eurxAssetId;
    }
    return $result;
  }
  From_EnvSettings._() : super();
  factory From_EnvSettings.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_EnvSettings.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.EnvSettings', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'policyAssetId')
    ..aQS(2, _omitFieldNames ? '' : 'usdtAssetId')
    ..aQS(3, _omitFieldNames ? '' : 'eurxAssetId')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_EnvSettings clone() => From_EnvSettings()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_EnvSettings copyWith(void Function(From_EnvSettings) updates) => super.copyWith((message) => updates(message as From_EnvSettings)) as From_EnvSettings;

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
  factory From_EncryptPin_Data({
    $core.String? salt,
    $core.String? encryptedData,
    $core.String? pinIdentifier,
    $core.String? hmac,
  }) {
    final $result = create();
    if (salt != null) {
      $result.salt = salt;
    }
    if (encryptedData != null) {
      $result.encryptedData = encryptedData;
    }
    if (pinIdentifier != null) {
      $result.pinIdentifier = pinIdentifier;
    }
    if (hmac != null) {
      $result.hmac = hmac;
    }
    return $result;
  }
  From_EncryptPin_Data._() : super();
  factory From_EncryptPin_Data.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_EncryptPin_Data.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.EncryptPin.Data', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(2, _omitFieldNames ? '' : 'salt')
    ..aQS(3, _omitFieldNames ? '' : 'encryptedData')
    ..aQS(4, _omitFieldNames ? '' : 'pinIdentifier')
    ..aOS(5, _omitFieldNames ? '' : 'hmac')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_EncryptPin_Data clone() => From_EncryptPin_Data()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_EncryptPin_Data copyWith(void Function(From_EncryptPin_Data) updates) => super.copyWith((message) => updates(message as From_EncryptPin_Data)) as From_EncryptPin_Data;

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

  @$pb.TagNumber(5)
  $core.String get hmac => $_getSZ(3);
  @$pb.TagNumber(5)
  set hmac($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(5)
  $core.bool hasHmac() => $_has(3);
  @$pb.TagNumber(5)
  void clearHmac() => clearField(5);
}

enum From_EncryptPin_Result {
  error, 
  data, 
  notSet
}

class From_EncryptPin extends $pb.GeneratedMessage {
  factory From_EncryptPin({
    $core.String? error,
    From_EncryptPin_Data? data,
  }) {
    final $result = create();
    if (error != null) {
      $result.error = error;
    }
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  From_EncryptPin._() : super();
  factory From_EncryptPin.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_EncryptPin.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, From_EncryptPin_Result> _From_EncryptPin_ResultByTag = {
    1 : From_EncryptPin_Result.error,
    2 : From_EncryptPin_Result.data,
    0 : From_EncryptPin_Result.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.EncryptPin', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOS(1, _omitFieldNames ? '' : 'error')
    ..aOM<From_EncryptPin_Data>(2, _omitFieldNames ? '' : 'data', subBuilder: From_EncryptPin_Data.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_EncryptPin clone() => From_EncryptPin()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_EncryptPin copyWith(void Function(From_EncryptPin) updates) => super.copyWith((message) => updates(message as From_EncryptPin)) as From_EncryptPin;

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

class From_DecryptPin_Error extends $pb.GeneratedMessage {
  factory From_DecryptPin_Error({
    $core.String? errorMsg,
    From_DecryptPin_ErrorCode? errorCode,
  }) {
    final $result = create();
    if (errorMsg != null) {
      $result.errorMsg = errorMsg;
    }
    if (errorCode != null) {
      $result.errorCode = errorCode;
    }
    return $result;
  }
  From_DecryptPin_Error._() : super();
  factory From_DecryptPin_Error.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_DecryptPin_Error.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.DecryptPin.Error', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'errorMsg')
    ..e<From_DecryptPin_ErrorCode>(2, _omitFieldNames ? '' : 'errorCode', $pb.PbFieldType.QE, defaultOrMaker: From_DecryptPin_ErrorCode.WRONG_PIN, valueOf: From_DecryptPin_ErrorCode.valueOf, enumValues: From_DecryptPin_ErrorCode.values)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_DecryptPin_Error clone() => From_DecryptPin_Error()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_DecryptPin_Error copyWith(void Function(From_DecryptPin_Error) updates) => super.copyWith((message) => updates(message as From_DecryptPin_Error)) as From_DecryptPin_Error;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_DecryptPin_Error create() => From_DecryptPin_Error._();
  From_DecryptPin_Error createEmptyInstance() => create();
  static $pb.PbList<From_DecryptPin_Error> createRepeated() => $pb.PbList<From_DecryptPin_Error>();
  @$core.pragma('dart2js:noInline')
  static From_DecryptPin_Error getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_DecryptPin_Error>(create);
  static From_DecryptPin_Error? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get errorMsg => $_getSZ(0);
  @$pb.TagNumber(1)
  set errorMsg($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasErrorMsg() => $_has(0);
  @$pb.TagNumber(1)
  void clearErrorMsg() => clearField(1);

  @$pb.TagNumber(2)
  From_DecryptPin_ErrorCode get errorCode => $_getN(1);
  @$pb.TagNumber(2)
  set errorCode(From_DecryptPin_ErrorCode v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasErrorCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearErrorCode() => clearField(2);
}

enum From_DecryptPin_Result {
  error, 
  mnemonic, 
  notSet
}

class From_DecryptPin extends $pb.GeneratedMessage {
  factory From_DecryptPin({
    From_DecryptPin_Error? error,
    $core.String? mnemonic,
  }) {
    final $result = create();
    if (error != null) {
      $result.error = error;
    }
    if (mnemonic != null) {
      $result.mnemonic = mnemonic;
    }
    return $result;
  }
  From_DecryptPin._() : super();
  factory From_DecryptPin.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_DecryptPin.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, From_DecryptPin_Result> _From_DecryptPin_ResultByTag = {
    1 : From_DecryptPin_Result.error,
    2 : From_DecryptPin_Result.mnemonic,
    0 : From_DecryptPin_Result.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.DecryptPin', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOM<From_DecryptPin_Error>(1, _omitFieldNames ? '' : 'error', subBuilder: From_DecryptPin_Error.create)
    ..aOS(2, _omitFieldNames ? '' : 'mnemonic')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_DecryptPin clone() => From_DecryptPin()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_DecryptPin copyWith(void Function(From_DecryptPin) updates) => super.copyWith((message) => updates(message as From_DecryptPin)) as From_DecryptPin;

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
  From_DecryptPin_Error get error => $_getN(0);
  @$pb.TagNumber(1)
  set error(From_DecryptPin_Error v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasError() => $_has(0);
  @$pb.TagNumber(1)
  void clearError() => clearField(1);
  @$pb.TagNumber(1)
  From_DecryptPin_Error ensureError() => $_ensure(0);

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
  factory From_RegisterAmp({
    $core.String? ampId,
    $core.String? errorMsg,
  }) {
    final $result = create();
    if (ampId != null) {
      $result.ampId = ampId;
    }
    if (errorMsg != null) {
      $result.errorMsg = errorMsg;
    }
    return $result;
  }
  From_RegisterAmp._() : super();
  factory From_RegisterAmp.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_RegisterAmp.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, From_RegisterAmp_Result> _From_RegisterAmp_ResultByTag = {
    1 : From_RegisterAmp_Result.ampId,
    2 : From_RegisterAmp_Result.errorMsg,
    0 : From_RegisterAmp_Result.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.RegisterAmp', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOS(1, _omitFieldNames ? '' : 'ampId')
    ..aOS(2, _omitFieldNames ? '' : 'errorMsg')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_RegisterAmp clone() => From_RegisterAmp()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_RegisterAmp copyWith(void Function(From_RegisterAmp) updates) => super.copyWith((message) => updates(message as From_RegisterAmp)) as From_RegisterAmp;

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
  factory From_AmpAssets({
    $core.Iterable<$core.String>? assets,
  }) {
    final $result = create();
    if (assets != null) {
      $result.assets.addAll(assets);
    }
    return $result;
  }
  From_AmpAssets._() : super();
  factory From_AmpAssets.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_AmpAssets.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.AmpAssets', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'assets')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_AmpAssets clone() => From_AmpAssets()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_AmpAssets copyWith(void Function(From_AmpAssets) updates) => super.copyWith((message) => updates(message as From_AmpAssets)) as From_AmpAssets;

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
  factory From_UpdatedTxs({
    $core.Iterable<TransItem>? items,
  }) {
    final $result = create();
    if (items != null) {
      $result.items.addAll(items);
    }
    return $result;
  }
  From_UpdatedTxs._() : super();
  factory From_UpdatedTxs.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_UpdatedTxs.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.UpdatedTxs', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..pc<TransItem>(1, _omitFieldNames ? '' : 'items', $pb.PbFieldType.PM, subBuilder: TransItem.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_UpdatedTxs clone() => From_UpdatedTxs()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_UpdatedTxs copyWith(void Function(From_UpdatedTxs) updates) => super.copyWith((message) => updates(message as From_UpdatedTxs)) as From_UpdatedTxs;

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
  factory From_RemovedTxs({
    $core.Iterable<$core.String>? txids,
  }) {
    final $result = create();
    if (txids != null) {
      $result.txids.addAll(txids);
    }
    return $result;
  }
  From_RemovedTxs._() : super();
  factory From_RemovedTxs.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_RemovedTxs.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.RemovedTxs', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'txids')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_RemovedTxs clone() => From_RemovedTxs()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_RemovedTxs copyWith(void Function(From_RemovedTxs) updates) => super.copyWith((message) => updates(message as From_RemovedTxs)) as From_RemovedTxs;

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
  factory From_UpdatedPegs({
    $core.String? orderId,
    $core.Iterable<TransItem>? items,
  }) {
    final $result = create();
    if (orderId != null) {
      $result.orderId = orderId;
    }
    if (items != null) {
      $result.items.addAll(items);
    }
    return $result;
  }
  From_UpdatedPegs._() : super();
  factory From_UpdatedPegs.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_UpdatedPegs.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.UpdatedPegs', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'orderId')
    ..pc<TransItem>(2, _omitFieldNames ? '' : 'items', $pb.PbFieldType.PM, subBuilder: TransItem.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_UpdatedPegs clone() => From_UpdatedPegs()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_UpdatedPegs copyWith(void Function(From_UpdatedPegs) updates) => super.copyWith((message) => updates(message as From_UpdatedPegs)) as From_UpdatedPegs;

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
  factory From_BalanceUpdate({
    Account? account,
    $core.Iterable<Balance>? balances,
  }) {
    final $result = create();
    if (account != null) {
      $result.account = account;
    }
    if (balances != null) {
      $result.balances.addAll(balances);
    }
    return $result;
  }
  From_BalanceUpdate._() : super();
  factory From_BalanceUpdate.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_BalanceUpdate.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.BalanceUpdate', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQM<Account>(1, _omitFieldNames ? '' : 'account', subBuilder: Account.create)
    ..pc<Balance>(2, _omitFieldNames ? '' : 'balances', $pb.PbFieldType.PM, subBuilder: Balance.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_BalanceUpdate clone() => From_BalanceUpdate()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_BalanceUpdate copyWith(void Function(From_BalanceUpdate) updates) => super.copyWith((message) => updates(message as From_BalanceUpdate)) as From_BalanceUpdate;

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

class From_PeginWaitTx extends $pb.GeneratedMessage {
  factory From_PeginWaitTx({
    $core.String? pegAddr,
    $core.String? recvAddr,
  }) {
    final $result = create();
    if (pegAddr != null) {
      $result.pegAddr = pegAddr;
    }
    if (recvAddr != null) {
      $result.recvAddr = recvAddr;
    }
    return $result;
  }
  From_PeginWaitTx._() : super();
  factory From_PeginWaitTx.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_PeginWaitTx.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.PeginWaitTx', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(5, _omitFieldNames ? '' : 'pegAddr')
    ..aQS(6, _omitFieldNames ? '' : 'recvAddr')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_PeginWaitTx clone() => From_PeginWaitTx()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_PeginWaitTx copyWith(void Function(From_PeginWaitTx) updates) => super.copyWith((message) => updates(message as From_PeginWaitTx)) as From_PeginWaitTx;

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

class From_PegOutAmount_Amounts extends $pb.GeneratedMessage {
  factory From_PegOutAmount_Amounts({
    $fixnum.Int64? sendAmount,
    $fixnum.Int64? recvAmount,
    $core.bool? isSendEntered,
    $core.double? feeRate,
    Account? account,
  }) {
    final $result = create();
    if (sendAmount != null) {
      $result.sendAmount = sendAmount;
    }
    if (recvAmount != null) {
      $result.recvAmount = recvAmount;
    }
    if (isSendEntered != null) {
      $result.isSendEntered = isSendEntered;
    }
    if (feeRate != null) {
      $result.feeRate = feeRate;
    }
    if (account != null) {
      $result.account = account;
    }
    return $result;
  }
  From_PegOutAmount_Amounts._() : super();
  factory From_PegOutAmount_Amounts.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_PegOutAmount_Amounts.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.PegOutAmount.Amounts', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'sendAmount', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'recvAmount', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.bool>(4, _omitFieldNames ? '' : 'isSendEntered', $pb.PbFieldType.QB)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'feeRate', $pb.PbFieldType.QD)
    ..aQM<Account>(6, _omitFieldNames ? '' : 'account', subBuilder: Account.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_PegOutAmount_Amounts clone() => From_PegOutAmount_Amounts()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_PegOutAmount_Amounts copyWith(void Function(From_PegOutAmount_Amounts) updates) => super.copyWith((message) => updates(message as From_PegOutAmount_Amounts)) as From_PegOutAmount_Amounts;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_PegOutAmount_Amounts create() => From_PegOutAmount_Amounts._();
  From_PegOutAmount_Amounts createEmptyInstance() => create();
  static $pb.PbList<From_PegOutAmount_Amounts> createRepeated() => $pb.PbList<From_PegOutAmount_Amounts>();
  @$core.pragma('dart2js:noInline')
  static From_PegOutAmount_Amounts getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_PegOutAmount_Amounts>(create);
  static From_PegOutAmount_Amounts? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get sendAmount => $_getI64(0);
  @$pb.TagNumber(1)
  set sendAmount($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSendAmount() => $_has(0);
  @$pb.TagNumber(1)
  void clearSendAmount() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get recvAmount => $_getI64(1);
  @$pb.TagNumber(2)
  set recvAmount($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasRecvAmount() => $_has(1);
  @$pb.TagNumber(2)
  void clearRecvAmount() => clearField(2);

  @$pb.TagNumber(4)
  $core.bool get isSendEntered => $_getBF(2);
  @$pb.TagNumber(4)
  set isSendEntered($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(4)
  $core.bool hasIsSendEntered() => $_has(2);
  @$pb.TagNumber(4)
  void clearIsSendEntered() => clearField(4);

  @$pb.TagNumber(5)
  $core.double get feeRate => $_getN(3);
  @$pb.TagNumber(5)
  set feeRate($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(5)
  $core.bool hasFeeRate() => $_has(3);
  @$pb.TagNumber(5)
  void clearFeeRate() => clearField(5);

  @$pb.TagNumber(6)
  Account get account => $_getN(4);
  @$pb.TagNumber(6)
  set account(Account v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasAccount() => $_has(4);
  @$pb.TagNumber(6)
  void clearAccount() => clearField(6);
  @$pb.TagNumber(6)
  Account ensureAccount() => $_ensure(4);
}

enum From_PegOutAmount_Result {
  errorMsg, 
  amounts, 
  notSet
}

class From_PegOutAmount extends $pb.GeneratedMessage {
  factory From_PegOutAmount({
    $core.String? errorMsg,
    From_PegOutAmount_Amounts? amounts,
  }) {
    final $result = create();
    if (errorMsg != null) {
      $result.errorMsg = errorMsg;
    }
    if (amounts != null) {
      $result.amounts = amounts;
    }
    return $result;
  }
  From_PegOutAmount._() : super();
  factory From_PegOutAmount.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_PegOutAmount.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, From_PegOutAmount_Result> _From_PegOutAmount_ResultByTag = {
    1 : From_PegOutAmount_Result.errorMsg,
    2 : From_PegOutAmount_Result.amounts,
    0 : From_PegOutAmount_Result.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.PegOutAmount', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOS(1, _omitFieldNames ? '' : 'errorMsg')
    ..aOM<From_PegOutAmount_Amounts>(2, _omitFieldNames ? '' : 'amounts', subBuilder: From_PegOutAmount_Amounts.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_PegOutAmount clone() => From_PegOutAmount()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_PegOutAmount copyWith(void Function(From_PegOutAmount) updates) => super.copyWith((message) => updates(message as From_PegOutAmount)) as From_PegOutAmount;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_PegOutAmount create() => From_PegOutAmount._();
  From_PegOutAmount createEmptyInstance() => create();
  static $pb.PbList<From_PegOutAmount> createRepeated() => $pb.PbList<From_PegOutAmount>();
  @$core.pragma('dart2js:noInline')
  static From_PegOutAmount getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_PegOutAmount>(create);
  static From_PegOutAmount? _defaultInstance;

  From_PegOutAmount_Result whichResult() => _From_PegOutAmount_ResultByTag[$_whichOneof(0)]!;
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
  From_PegOutAmount_Amounts get amounts => $_getN(1);
  @$pb.TagNumber(2)
  set amounts(From_PegOutAmount_Amounts v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasAmounts() => $_has(1);
  @$pb.TagNumber(2)
  void clearAmounts() => clearField(2);
  @$pb.TagNumber(2)
  From_PegOutAmount_Amounts ensureAmounts() => $_ensure(1);
}

class From_RecvAddress extends $pb.GeneratedMessage {
  factory From_RecvAddress({
    Address? addr,
    Account? account,
  }) {
    final $result = create();
    if (addr != null) {
      $result.addr = addr;
    }
    if (account != null) {
      $result.account = account;
    }
    return $result;
  }
  From_RecvAddress._() : super();
  factory From_RecvAddress.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_RecvAddress.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.RecvAddress', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQM<Address>(1, _omitFieldNames ? '' : 'addr', subBuilder: Address.create)
    ..aQM<Account>(2, _omitFieldNames ? '' : 'account', subBuilder: Account.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_RecvAddress clone() => From_RecvAddress()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_RecvAddress copyWith(void Function(From_RecvAddress) updates) => super.copyWith((message) => updates(message as From_RecvAddress)) as From_RecvAddress;

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
    final $result = create();
    if (txid != null) {
      $result.txid = txid;
    }
    if (vout != null) {
      $result.vout = vout;
    }
    if (assetId != null) {
      $result.assetId = assetId;
    }
    if (amount != null) {
      $result.amount = amount;
    }
    if (address != null) {
      $result.address = address;
    }
    if (isInternal != null) {
      $result.isInternal = isInternal;
    }
    if (isConfidential != null) {
      $result.isConfidential = isConfidential;
    }
    return $result;
  }
  From_LoadUtxos_Utxo._() : super();
  factory From_LoadUtxos_Utxo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_LoadUtxos_Utxo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.LoadUtxos.Utxo', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'txid')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'vout', $pb.PbFieldType.QU3)
    ..aQS(3, _omitFieldNames ? '' : 'assetId')
    ..a<$fixnum.Int64>(4, _omitFieldNames ? '' : 'amount', $pb.PbFieldType.QU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aQS(5, _omitFieldNames ? '' : 'address')
    ..a<$core.bool>(6, _omitFieldNames ? '' : 'isInternal', $pb.PbFieldType.QB)
    ..a<$core.bool>(7, _omitFieldNames ? '' : 'isConfidential', $pb.PbFieldType.QB)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_LoadUtxos_Utxo clone() => From_LoadUtxos_Utxo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_LoadUtxos_Utxo copyWith(void Function(From_LoadUtxos_Utxo) updates) => super.copyWith((message) => updates(message as From_LoadUtxos_Utxo)) as From_LoadUtxos_Utxo;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_LoadUtxos_Utxo create() => From_LoadUtxos_Utxo._();
  From_LoadUtxos_Utxo createEmptyInstance() => create();
  static $pb.PbList<From_LoadUtxos_Utxo> createRepeated() => $pb.PbList<From_LoadUtxos_Utxo>();
  @$core.pragma('dart2js:noInline')
  static From_LoadUtxos_Utxo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_LoadUtxos_Utxo>(create);
  static From_LoadUtxos_Utxo? _defaultInstance;

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

  @$pb.TagNumber(5)
  $core.String get address => $_getSZ(4);
  @$pb.TagNumber(5)
  set address($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasAddress() => $_has(4);
  @$pb.TagNumber(5)
  void clearAddress() => clearField(5);

  @$pb.TagNumber(6)
  $core.bool get isInternal => $_getBF(5);
  @$pb.TagNumber(6)
  set isInternal($core.bool v) { $_setBool(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasIsInternal() => $_has(5);
  @$pb.TagNumber(6)
  void clearIsInternal() => clearField(6);

  @$pb.TagNumber(7)
  $core.bool get isConfidential => $_getBF(6);
  @$pb.TagNumber(7)
  set isConfidential($core.bool v) { $_setBool(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasIsConfidential() => $_has(6);
  @$pb.TagNumber(7)
  void clearIsConfidential() => clearField(7);
}

class From_LoadUtxos extends $pb.GeneratedMessage {
  factory From_LoadUtxos({
    Account? account,
    $core.Iterable<From_LoadUtxos_Utxo>? utxos,
    $core.String? errorMsg,
  }) {
    final $result = create();
    if (account != null) {
      $result.account = account;
    }
    if (utxos != null) {
      $result.utxos.addAll(utxos);
    }
    if (errorMsg != null) {
      $result.errorMsg = errorMsg;
    }
    return $result;
  }
  From_LoadUtxos._() : super();
  factory From_LoadUtxos.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_LoadUtxos.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.LoadUtxos', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQM<Account>(1, _omitFieldNames ? '' : 'account', subBuilder: Account.create)
    ..pc<From_LoadUtxos_Utxo>(2, _omitFieldNames ? '' : 'utxos', $pb.PbFieldType.PM, subBuilder: From_LoadUtxos_Utxo.create)
    ..aOS(3, _omitFieldNames ? '' : 'errorMsg')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_LoadUtxos clone() => From_LoadUtxos()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_LoadUtxos copyWith(void Function(From_LoadUtxos) updates) => super.copyWith((message) => updates(message as From_LoadUtxos)) as From_LoadUtxos;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_LoadUtxos create() => From_LoadUtxos._();
  From_LoadUtxos createEmptyInstance() => create();
  static $pb.PbList<From_LoadUtxos> createRepeated() => $pb.PbList<From_LoadUtxos>();
  @$core.pragma('dart2js:noInline')
  static From_LoadUtxos getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_LoadUtxos>(create);
  static From_LoadUtxos? _defaultInstance;

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
  $core.List<From_LoadUtxos_Utxo> get utxos => $_getList(1);

  @$pb.TagNumber(3)
  $core.String get errorMsg => $_getSZ(2);
  @$pb.TagNumber(3)
  set errorMsg($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasErrorMsg() => $_has(2);
  @$pb.TagNumber(3)
  void clearErrorMsg() => clearField(3);
}

class From_LoadAddresses_Address extends $pb.GeneratedMessage {
  factory From_LoadAddresses_Address({
    $core.String? address,
    $core.int? index,
    $core.bool? isInternal,
    $core.String? unconfidentialAddress,
  }) {
    final $result = create();
    if (address != null) {
      $result.address = address;
    }
    if (index != null) {
      $result.index = index;
    }
    if (isInternal != null) {
      $result.isInternal = isInternal;
    }
    if (unconfidentialAddress != null) {
      $result.unconfidentialAddress = unconfidentialAddress;
    }
    return $result;
  }
  From_LoadAddresses_Address._() : super();
  factory From_LoadAddresses_Address.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_LoadAddresses_Address.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.LoadAddresses.Address', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'address')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'index', $pb.PbFieldType.QU3)
    ..a<$core.bool>(3, _omitFieldNames ? '' : 'isInternal', $pb.PbFieldType.QB)
    ..aQS(4, _omitFieldNames ? '' : 'unconfidentialAddress')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_LoadAddresses_Address clone() => From_LoadAddresses_Address()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_LoadAddresses_Address copyWith(void Function(From_LoadAddresses_Address) updates) => super.copyWith((message) => updates(message as From_LoadAddresses_Address)) as From_LoadAddresses_Address;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_LoadAddresses_Address create() => From_LoadAddresses_Address._();
  From_LoadAddresses_Address createEmptyInstance() => create();
  static $pb.PbList<From_LoadAddresses_Address> createRepeated() => $pb.PbList<From_LoadAddresses_Address>();
  @$core.pragma('dart2js:noInline')
  static From_LoadAddresses_Address getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_LoadAddresses_Address>(create);
  static From_LoadAddresses_Address? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get address => $_getSZ(0);
  @$pb.TagNumber(1)
  set address($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAddress() => $_has(0);
  @$pb.TagNumber(1)
  void clearAddress() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get index => $_getIZ(1);
  @$pb.TagNumber(2)
  set index($core.int v) { $_setUnsignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasIndex() => $_has(1);
  @$pb.TagNumber(2)
  void clearIndex() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get isInternal => $_getBF(2);
  @$pb.TagNumber(3)
  set isInternal($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasIsInternal() => $_has(2);
  @$pb.TagNumber(3)
  void clearIsInternal() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get unconfidentialAddress => $_getSZ(3);
  @$pb.TagNumber(4)
  set unconfidentialAddress($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasUnconfidentialAddress() => $_has(3);
  @$pb.TagNumber(4)
  void clearUnconfidentialAddress() => clearField(4);
}

class From_LoadAddresses extends $pb.GeneratedMessage {
  factory From_LoadAddresses({
    Account? account,
    $core.Iterable<From_LoadAddresses_Address>? addresses,
    $core.String? errorMsg,
  }) {
    final $result = create();
    if (account != null) {
      $result.account = account;
    }
    if (addresses != null) {
      $result.addresses.addAll(addresses);
    }
    if (errorMsg != null) {
      $result.errorMsg = errorMsg;
    }
    return $result;
  }
  From_LoadAddresses._() : super();
  factory From_LoadAddresses.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_LoadAddresses.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.LoadAddresses', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQM<Account>(1, _omitFieldNames ? '' : 'account', subBuilder: Account.create)
    ..pc<From_LoadAddresses_Address>(2, _omitFieldNames ? '' : 'addresses', $pb.PbFieldType.PM, subBuilder: From_LoadAddresses_Address.create)
    ..aOS(3, _omitFieldNames ? '' : 'errorMsg')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_LoadAddresses clone() => From_LoadAddresses()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_LoadAddresses copyWith(void Function(From_LoadAddresses) updates) => super.copyWith((message) => updates(message as From_LoadAddresses)) as From_LoadAddresses;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_LoadAddresses create() => From_LoadAddresses._();
  From_LoadAddresses createEmptyInstance() => create();
  static $pb.PbList<From_LoadAddresses> createRepeated() => $pb.PbList<From_LoadAddresses>();
  @$core.pragma('dart2js:noInline')
  static From_LoadAddresses getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_LoadAddresses>(create);
  static From_LoadAddresses? _defaultInstance;

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
  $core.List<From_LoadAddresses_Address> get addresses => $_getList(1);

  @$pb.TagNumber(3)
  $core.String get errorMsg => $_getSZ(2);
  @$pb.TagNumber(3)
  set errorMsg($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasErrorMsg() => $_has(2);
  @$pb.TagNumber(3)
  void clearErrorMsg() => clearField(3);
}

enum From_CreateTxResult_Result {
  errorMsg, 
  createdTx, 
  notSet
}

class From_CreateTxResult extends $pb.GeneratedMessage {
  factory From_CreateTxResult({
    $core.String? errorMsg,
    CreatedTx? createdTx,
  }) {
    final $result = create();
    if (errorMsg != null) {
      $result.errorMsg = errorMsg;
    }
    if (createdTx != null) {
      $result.createdTx = createdTx;
    }
    return $result;
  }
  From_CreateTxResult._() : super();
  factory From_CreateTxResult.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_CreateTxResult.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, From_CreateTxResult_Result> _From_CreateTxResult_ResultByTag = {
    1 : From_CreateTxResult_Result.errorMsg,
    2 : From_CreateTxResult_Result.createdTx,
    0 : From_CreateTxResult_Result.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.CreateTxResult', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOS(1, _omitFieldNames ? '' : 'errorMsg')
    ..aOM<CreatedTx>(2, _omitFieldNames ? '' : 'createdTx', subBuilder: CreatedTx.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_CreateTxResult clone() => From_CreateTxResult()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_CreateTxResult copyWith(void Function(From_CreateTxResult) updates) => super.copyWith((message) => updates(message as From_CreateTxResult)) as From_CreateTxResult;

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
  factory From_SendResult({
    $core.String? errorMsg,
    TransItem? txItem,
  }) {
    final $result = create();
    if (errorMsg != null) {
      $result.errorMsg = errorMsg;
    }
    if (txItem != null) {
      $result.txItem = txItem;
    }
    return $result;
  }
  From_SendResult._() : super();
  factory From_SendResult.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_SendResult.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, From_SendResult_Result> _From_SendResult_ResultByTag = {
    1 : From_SendResult_Result.errorMsg,
    2 : From_SendResult_Result.txItem,
    0 : From_SendResult_Result.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.SendResult', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOS(1, _omitFieldNames ? '' : 'errorMsg')
    ..aOM<TransItem>(2, _omitFieldNames ? '' : 'txItem', subBuilder: TransItem.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_SendResult clone() => From_SendResult()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_SendResult copyWith(void Function(From_SendResult) updates) => super.copyWith((message) => updates(message as From_SendResult)) as From_SendResult;

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
  factory From_BlindedValues({
    $core.String? txid,
    $core.String? errorMsg,
    $core.String? blindedValues,
  }) {
    final $result = create();
    if (txid != null) {
      $result.txid = txid;
    }
    if (errorMsg != null) {
      $result.errorMsg = errorMsg;
    }
    if (blindedValues != null) {
      $result.blindedValues = blindedValues;
    }
    return $result;
  }
  From_BlindedValues._() : super();
  factory From_BlindedValues.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_BlindedValues.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, From_BlindedValues_Result> _From_BlindedValues_ResultByTag = {
    2 : From_BlindedValues_Result.errorMsg,
    3 : From_BlindedValues_Result.blindedValues,
    0 : From_BlindedValues_Result.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.BlindedValues', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..oo(0, [2, 3])
    ..aQS(1, _omitFieldNames ? '' : 'txid')
    ..aOS(2, _omitFieldNames ? '' : 'errorMsg')
    ..aOS(3, _omitFieldNames ? '' : 'blindedValues')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_BlindedValues clone() => From_BlindedValues()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_BlindedValues copyWith(void Function(From_BlindedValues) updates) => super.copyWith((message) => updates(message as From_BlindedValues)) as From_BlindedValues;

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
  factory From_PriceUpdate({
    $core.String? asset,
    $core.double? bid,
    $core.double? ask,
  }) {
    final $result = create();
    if (asset != null) {
      $result.asset = asset;
    }
    if (bid != null) {
      $result.bid = bid;
    }
    if (ask != null) {
      $result.ask = ask;
    }
    return $result;
  }
  From_PriceUpdate._() : super();
  factory From_PriceUpdate.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_PriceUpdate.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.PriceUpdate', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'asset')
    ..a<$core.double>(2, _omitFieldNames ? '' : 'bid', $pb.PbFieldType.QD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'ask', $pb.PbFieldType.QD)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_PriceUpdate clone() => From_PriceUpdate()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_PriceUpdate copyWith(void Function(From_PriceUpdate) updates) => super.copyWith((message) => updates(message as From_PriceUpdate)) as From_PriceUpdate;

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
  factory From_RegisterPhone({
    $core.String? phoneKey,
    $core.String? errorMsg,
  }) {
    final $result = create();
    if (phoneKey != null) {
      $result.phoneKey = phoneKey;
    }
    if (errorMsg != null) {
      $result.errorMsg = errorMsg;
    }
    return $result;
  }
  From_RegisterPhone._() : super();
  factory From_RegisterPhone.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_RegisterPhone.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, From_RegisterPhone_Result> _From_RegisterPhone_ResultByTag = {
    1 : From_RegisterPhone_Result.phoneKey,
    2 : From_RegisterPhone_Result.errorMsg,
    0 : From_RegisterPhone_Result.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.RegisterPhone', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOS(1, _omitFieldNames ? '' : 'phoneKey')
    ..aOS(2, _omitFieldNames ? '' : 'errorMsg')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_RegisterPhone clone() => From_RegisterPhone()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_RegisterPhone copyWith(void Function(From_RegisterPhone) updates) => super.copyWith((message) => updates(message as From_RegisterPhone)) as From_RegisterPhone;

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
  factory From_VerifyPhone({
    Empty? success,
    $core.String? errorMsg,
  }) {
    final $result = create();
    if (success != null) {
      $result.success = success;
    }
    if (errorMsg != null) {
      $result.errorMsg = errorMsg;
    }
    return $result;
  }
  From_VerifyPhone._() : super();
  factory From_VerifyPhone.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_VerifyPhone.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, From_VerifyPhone_Result> _From_VerifyPhone_ResultByTag = {
    1 : From_VerifyPhone_Result.success,
    2 : From_VerifyPhone_Result.errorMsg,
    0 : From_VerifyPhone_Result.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.VerifyPhone', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOM<Empty>(1, _omitFieldNames ? '' : 'success', subBuilder: Empty.create)
    ..aOS(2, _omitFieldNames ? '' : 'errorMsg')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_VerifyPhone clone() => From_VerifyPhone()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_VerifyPhone copyWith(void Function(From_VerifyPhone) updates) => super.copyWith((message) => updates(message as From_VerifyPhone)) as From_VerifyPhone;

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
  factory From_ShowMessage({
    $core.String? text,
  }) {
    final $result = create();
    if (text != null) {
      $result.text = text;
    }
    return $result;
  }
  From_ShowMessage._() : super();
  factory From_ShowMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_ShowMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.ShowMessage', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'text')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_ShowMessage clone() => From_ShowMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_ShowMessage copyWith(void Function(From_ShowMessage) updates) => super.copyWith((message) => updates(message as From_ShowMessage)) as From_ShowMessage;

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
  factory From_ShowInsufficientFunds({
    $core.String? assetId,
    $fixnum.Int64? available,
    $fixnum.Int64? required,
  }) {
    final $result = create();
    if (assetId != null) {
      $result.assetId = assetId;
    }
    if (available != null) {
      $result.available = available;
    }
    if (required != null) {
      $result.required = required;
    }
    return $result;
  }
  From_ShowInsufficientFunds._() : super();
  factory From_ShowInsufficientFunds.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_ShowInsufficientFunds.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.ShowInsufficientFunds', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'assetId')
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'available', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(3, _omitFieldNames ? '' : 'required', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_ShowInsufficientFunds clone() => From_ShowInsufficientFunds()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_ShowInsufficientFunds copyWith(void Function(From_ShowInsufficientFunds) updates) => super.copyWith((message) => updates(message as From_ShowInsufficientFunds)) as From_ShowInsufficientFunds;

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

class From_AssetDetails_Stats extends $pb.GeneratedMessage {
  factory From_AssetDetails_Stats({
    $fixnum.Int64? issuedAmount,
    $fixnum.Int64? burnedAmount,
    $core.bool? hasBlindedIssuances,
    $fixnum.Int64? offlineAmount,
  }) {
    final $result = create();
    if (issuedAmount != null) {
      $result.issuedAmount = issuedAmount;
    }
    if (burnedAmount != null) {
      $result.burnedAmount = burnedAmount;
    }
    if (hasBlindedIssuances != null) {
      $result.hasBlindedIssuances = hasBlindedIssuances;
    }
    if (offlineAmount != null) {
      $result.offlineAmount = offlineAmount;
    }
    return $result;
  }
  From_AssetDetails_Stats._() : super();
  factory From_AssetDetails_Stats.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_AssetDetails_Stats.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.AssetDetails.Stats', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'issuedAmount', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'burnedAmount', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.bool>(3, _omitFieldNames ? '' : 'hasBlindedIssuances', $pb.PbFieldType.QB)
    ..a<$fixnum.Int64>(4, _omitFieldNames ? '' : 'offlineAmount', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_AssetDetails_Stats clone() => From_AssetDetails_Stats()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_AssetDetails_Stats copyWith(void Function(From_AssetDetails_Stats) updates) => super.copyWith((message) => updates(message as From_AssetDetails_Stats)) as From_AssetDetails_Stats;

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

class From_AssetDetails extends $pb.GeneratedMessage {
  factory From_AssetDetails({
    $core.String? assetId,
    From_AssetDetails_Stats? stats,
    $core.String? chartUrl,
  }) {
    final $result = create();
    if (assetId != null) {
      $result.assetId = assetId;
    }
    if (stats != null) {
      $result.stats = stats;
    }
    if (chartUrl != null) {
      $result.chartUrl = chartUrl;
    }
    return $result;
  }
  From_AssetDetails._() : super();
  factory From_AssetDetails.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_AssetDetails.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.AssetDetails', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'assetId')
    ..aOM<From_AssetDetails_Stats>(2, _omitFieldNames ? '' : 'stats', subBuilder: From_AssetDetails_Stats.create)
    ..aOS(3, _omitFieldNames ? '' : 'chartUrl')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_AssetDetails clone() => From_AssetDetails()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_AssetDetails copyWith(void Function(From_AssetDetails) updates) => super.copyWith((message) => updates(message as From_AssetDetails)) as From_AssetDetails;

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
}

class From_UpdatePriceStream extends $pb.GeneratedMessage {
  factory From_UpdatePriceStream({
    $core.String? assetId,
    $core.bool? sendBitcoins,
    $fixnum.Int64? sendAmount,
    $fixnum.Int64? recvAmount,
    $core.double? price,
    $core.String? errorMsg,
  }) {
    final $result = create();
    if (assetId != null) {
      $result.assetId = assetId;
    }
    if (sendBitcoins != null) {
      $result.sendBitcoins = sendBitcoins;
    }
    if (sendAmount != null) {
      $result.sendAmount = sendAmount;
    }
    if (recvAmount != null) {
      $result.recvAmount = recvAmount;
    }
    if (price != null) {
      $result.price = price;
    }
    if (errorMsg != null) {
      $result.errorMsg = errorMsg;
    }
    return $result;
  }
  From_UpdatePriceStream._() : super();
  factory From_UpdatePriceStream.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_UpdatePriceStream.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.UpdatePriceStream', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'assetId')
    ..a<$core.bool>(2, _omitFieldNames ? '' : 'sendBitcoins', $pb.PbFieldType.QB)
    ..aInt64(3, _omitFieldNames ? '' : 'sendAmount')
    ..aInt64(4, _omitFieldNames ? '' : 'recvAmount')
    ..a<$core.double>(5, _omitFieldNames ? '' : 'price', $pb.PbFieldType.OD)
    ..aOS(6, _omitFieldNames ? '' : 'errorMsg')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_UpdatePriceStream clone() => From_UpdatePriceStream()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_UpdatePriceStream copyWith(void Function(From_UpdatePriceStream) updates) => super.copyWith((message) => updates(message as From_UpdatePriceStream)) as From_UpdatePriceStream;

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
  factory From_LocalMessage({
    $core.String? title,
    $core.String? body,
  }) {
    final $result = create();
    if (title != null) {
      $result.title = title;
    }
    if (body != null) {
      $result.body = body;
    }
    return $result;
  }
  From_LocalMessage._() : super();
  factory From_LocalMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_LocalMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.LocalMessage', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'title')
    ..aQS(2, _omitFieldNames ? '' : 'body')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_LocalMessage clone() => From_LocalMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_LocalMessage copyWith(void Function(From_LocalMessage) updates) => super.copyWith((message) => updates(message as From_LocalMessage)) as From_LocalMessage;

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

class From_PortfolioPrices extends $pb.GeneratedMessage {
  factory From_PortfolioPrices({
    $core.Map<$core.String, $core.double>? pricesUsd,
  }) {
    final $result = create();
    if (pricesUsd != null) {
      $result.pricesUsd.addAll(pricesUsd);
    }
    return $result;
  }
  From_PortfolioPrices._() : super();
  factory From_PortfolioPrices.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_PortfolioPrices.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.PortfolioPrices', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..m<$core.String, $core.double>(1, _omitFieldNames ? '' : 'pricesUsd', entryClassName: 'From.PortfolioPrices.PricesUsdEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OD, packageName: const $pb.PackageName('sideswap.proto'))
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_PortfolioPrices clone() => From_PortfolioPrices()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_PortfolioPrices copyWith(void Function(From_PortfolioPrices) updates) => super.copyWith((message) => updates(message as From_PortfolioPrices)) as From_PortfolioPrices;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_PortfolioPrices create() => From_PortfolioPrices._();
  From_PortfolioPrices createEmptyInstance() => create();
  static $pb.PbList<From_PortfolioPrices> createRepeated() => $pb.PbList<From_PortfolioPrices>();
  @$core.pragma('dart2js:noInline')
  static From_PortfolioPrices getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_PortfolioPrices>(create);
  static From_PortfolioPrices? _defaultInstance;

  @$pb.TagNumber(1)
  $core.Map<$core.String, $core.double> get pricesUsd => $_getMap(0);
}

class From_ConversionRates extends $pb.GeneratedMessage {
  factory From_ConversionRates({
    $core.Map<$core.String, $core.double>? usdConversionRates,
  }) {
    final $result = create();
    if (usdConversionRates != null) {
      $result.usdConversionRates.addAll(usdConversionRates);
    }
    return $result;
  }
  From_ConversionRates._() : super();
  factory From_ConversionRates.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_ConversionRates.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.ConversionRates', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..m<$core.String, $core.double>(1, _omitFieldNames ? '' : 'usdConversionRates', entryClassName: 'From.ConversionRates.UsdConversionRatesEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OD, packageName: const $pb.PackageName('sideswap.proto'))
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_ConversionRates clone() => From_ConversionRates()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_ConversionRates copyWith(void Function(From_ConversionRates) updates) => super.copyWith((message) => updates(message as From_ConversionRates)) as From_ConversionRates;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_ConversionRates create() => From_ConversionRates._();
  From_ConversionRates createEmptyInstance() => create();
  static $pb.PbList<From_ConversionRates> createRepeated() => $pb.PbList<From_ConversionRates>();
  @$core.pragma('dart2js:noInline')
  static From_ConversionRates getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_ConversionRates>(create);
  static From_ConversionRates? _defaultInstance;

  @$pb.TagNumber(1)
  $core.Map<$core.String, $core.double> get usdConversionRates => $_getMap(0);
}

class From_JadePorts_Port extends $pb.GeneratedMessage {
  factory From_JadePorts_Port({
    $core.String? jadeId,
    $core.String? port,
  }) {
    final $result = create();
    if (jadeId != null) {
      $result.jadeId = jadeId;
    }
    if (port != null) {
      $result.port = port;
    }
    return $result;
  }
  From_JadePorts_Port._() : super();
  factory From_JadePorts_Port.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_JadePorts_Port.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.JadePorts.Port', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'jadeId')
    ..aQS(2, _omitFieldNames ? '' : 'port')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_JadePorts_Port clone() => From_JadePorts_Port()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_JadePorts_Port copyWith(void Function(From_JadePorts_Port) updates) => super.copyWith((message) => updates(message as From_JadePorts_Port)) as From_JadePorts_Port;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_JadePorts_Port create() => From_JadePorts_Port._();
  From_JadePorts_Port createEmptyInstance() => create();
  static $pb.PbList<From_JadePorts_Port> createRepeated() => $pb.PbList<From_JadePorts_Port>();
  @$core.pragma('dart2js:noInline')
  static From_JadePorts_Port getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_JadePorts_Port>(create);
  static From_JadePorts_Port? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get jadeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set jadeId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasJadeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearJadeId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get port => $_getSZ(1);
  @$pb.TagNumber(2)
  set port($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPort() => $_has(1);
  @$pb.TagNumber(2)
  void clearPort() => clearField(2);
}

class From_JadePorts extends $pb.GeneratedMessage {
  factory From_JadePorts({
    $core.Iterable<From_JadePorts_Port>? ports,
  }) {
    final $result = create();
    if (ports != null) {
      $result.ports.addAll(ports);
    }
    return $result;
  }
  From_JadePorts._() : super();
  factory From_JadePorts.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_JadePorts.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.JadePorts', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..pc<From_JadePorts_Port>(1, _omitFieldNames ? '' : 'ports', $pb.PbFieldType.PM, subBuilder: From_JadePorts_Port.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_JadePorts clone() => From_JadePorts()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_JadePorts copyWith(void Function(From_JadePorts) updates) => super.copyWith((message) => updates(message as From_JadePorts)) as From_JadePorts;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_JadePorts create() => From_JadePorts._();
  From_JadePorts createEmptyInstance() => create();
  static $pb.PbList<From_JadePorts> createRepeated() => $pb.PbList<From_JadePorts>();
  @$core.pragma('dart2js:noInline')
  static From_JadePorts getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_JadePorts>(create);
  static From_JadePorts? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<From_JadePorts_Port> get ports => $_getList(0);
}

class From_JadeStatus extends $pb.GeneratedMessage {
  factory From_JadeStatus({
    From_JadeStatus_Status? status,
  }) {
    final $result = create();
    if (status != null) {
      $result.status = status;
    }
    return $result;
  }
  From_JadeStatus._() : super();
  factory From_JadeStatus.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_JadeStatus.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.JadeStatus', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..e<From_JadeStatus_Status>(1, _omitFieldNames ? '' : 'status', $pb.PbFieldType.QE, defaultOrMaker: From_JadeStatus_Status.CONNECTING, valueOf: From_JadeStatus_Status.valueOf, enumValues: From_JadeStatus_Status.values)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_JadeStatus clone() => From_JadeStatus()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_JadeStatus copyWith(void Function(From_JadeStatus) updates) => super.copyWith((message) => updates(message as From_JadeStatus)) as From_JadeStatus;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_JadeStatus create() => From_JadeStatus._();
  From_JadeStatus createEmptyInstance() => create();
  static $pb.PbList<From_JadeStatus> createRepeated() => $pb.PbList<From_JadeStatus>();
  @$core.pragma('dart2js:noInline')
  static From_JadeStatus getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_JadeStatus>(create);
  static From_JadeStatus? _defaultInstance;

  @$pb.TagNumber(1)
  From_JadeStatus_Status get status => $_getN(0);
  @$pb.TagNumber(1)
  set status(From_JadeStatus_Status v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => clearField(1);
}

class From_GaidStatus extends $pb.GeneratedMessage {
  factory From_GaidStatus({
    $core.String? gaid,
    $core.String? assetId,
    $core.String? error,
  }) {
    final $result = create();
    if (gaid != null) {
      $result.gaid = gaid;
    }
    if (assetId != null) {
      $result.assetId = assetId;
    }
    if (error != null) {
      $result.error = error;
    }
    return $result;
  }
  From_GaidStatus._() : super();
  factory From_GaidStatus.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_GaidStatus.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.GaidStatus', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'gaid')
    ..aQS(2, _omitFieldNames ? '' : 'assetId')
    ..aOS(3, _omitFieldNames ? '' : 'error')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_GaidStatus clone() => From_GaidStatus()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_GaidStatus copyWith(void Function(From_GaidStatus) updates) => super.copyWith((message) => updates(message as From_GaidStatus)) as From_GaidStatus;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_GaidStatus create() => From_GaidStatus._();
  From_GaidStatus createEmptyInstance() => create();
  static $pb.PbList<From_GaidStatus> createRepeated() => $pb.PbList<From_GaidStatus>();
  @$core.pragma('dart2js:noInline')
  static From_GaidStatus getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_GaidStatus>(create);
  static From_GaidStatus? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get gaid => $_getSZ(0);
  @$pb.TagNumber(1)
  set gaid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasGaid() => $_has(0);
  @$pb.TagNumber(1)
  void clearGaid() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get assetId => $_getSZ(1);
  @$pb.TagNumber(2)
  set assetId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAssetId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAssetId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get error => $_getSZ(2);
  @$pb.TagNumber(3)
  set error($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasError() => $_has(2);
  @$pb.TagNumber(3)
  void clearError() => clearField(3);
}

class From_MarketList extends $pb.GeneratedMessage {
  factory From_MarketList({
    $core.Iterable<MarketInfo>? markets,
  }) {
    final $result = create();
    if (markets != null) {
      $result.markets.addAll(markets);
    }
    return $result;
  }
  From_MarketList._() : super();
  factory From_MarketList.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_MarketList.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.MarketList', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..pc<MarketInfo>(1, _omitFieldNames ? '' : 'markets', $pb.PbFieldType.PM, subBuilder: MarketInfo.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_MarketList clone() => From_MarketList()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_MarketList copyWith(void Function(From_MarketList) updates) => super.copyWith((message) => updates(message as From_MarketList)) as From_MarketList;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_MarketList create() => From_MarketList._();
  From_MarketList createEmptyInstance() => create();
  static $pb.PbList<From_MarketList> createRepeated() => $pb.PbList<From_MarketList>();
  @$core.pragma('dart2js:noInline')
  static From_MarketList getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_MarketList>(create);
  static From_MarketList? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<MarketInfo> get markets => $_getList(0);
}

class From_PublicOrders extends $pb.GeneratedMessage {
  factory From_PublicOrders({
    AssetPair? assetPair,
    $core.Iterable<PublicOrder>? list,
  }) {
    final $result = create();
    if (assetPair != null) {
      $result.assetPair = assetPair;
    }
    if (list != null) {
      $result.list.addAll(list);
    }
    return $result;
  }
  From_PublicOrders._() : super();
  factory From_PublicOrders.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_PublicOrders.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.PublicOrders', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQM<AssetPair>(1, _omitFieldNames ? '' : 'assetPair', subBuilder: AssetPair.create)
    ..pc<PublicOrder>(2, _omitFieldNames ? '' : 'list', $pb.PbFieldType.PM, subBuilder: PublicOrder.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_PublicOrders clone() => From_PublicOrders()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_PublicOrders copyWith(void Function(From_PublicOrders) updates) => super.copyWith((message) => updates(message as From_PublicOrders)) as From_PublicOrders;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_PublicOrders create() => From_PublicOrders._();
  From_PublicOrders createEmptyInstance() => create();
  static $pb.PbList<From_PublicOrders> createRepeated() => $pb.PbList<From_PublicOrders>();
  @$core.pragma('dart2js:noInline')
  static From_PublicOrders getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_PublicOrders>(create);
  static From_PublicOrders? _defaultInstance;

  @$pb.TagNumber(1)
  AssetPair get assetPair => $_getN(0);
  @$pb.TagNumber(1)
  set assetPair(AssetPair v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasAssetPair() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetPair() => clearField(1);
  @$pb.TagNumber(1)
  AssetPair ensureAssetPair() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.List<PublicOrder> get list => $_getList(1);
}

class From_OwnOrders extends $pb.GeneratedMessage {
  factory From_OwnOrders({
    $core.Iterable<OwnOrder>? list,
  }) {
    final $result = create();
    if (list != null) {
      $result.list.addAll(list);
    }
    return $result;
  }
  From_OwnOrders._() : super();
  factory From_OwnOrders.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_OwnOrders.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.OwnOrders', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..pc<OwnOrder>(1, _omitFieldNames ? '' : 'list', $pb.PbFieldType.PM, subBuilder: OwnOrder.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_OwnOrders clone() => From_OwnOrders()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_OwnOrders copyWith(void Function(From_OwnOrders) updates) => super.copyWith((message) => updates(message as From_OwnOrders)) as From_OwnOrders;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_OwnOrders create() => From_OwnOrders._();
  From_OwnOrders createEmptyInstance() => create();
  static $pb.PbList<From_OwnOrders> createRepeated() => $pb.PbList<From_OwnOrders>();
  @$core.pragma('dart2js:noInline')
  static From_OwnOrders getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_OwnOrders>(create);
  static From_OwnOrders? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<OwnOrder> get list => $_getList(0);
}

class From_MarketPrice extends $pb.GeneratedMessage {
  factory From_MarketPrice({
    AssetPair? assetPair,
    $core.double? indPrice,
    $core.double? lastPrice,
  }) {
    final $result = create();
    if (assetPair != null) {
      $result.assetPair = assetPair;
    }
    if (indPrice != null) {
      $result.indPrice = indPrice;
    }
    if (lastPrice != null) {
      $result.lastPrice = lastPrice;
    }
    return $result;
  }
  From_MarketPrice._() : super();
  factory From_MarketPrice.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_MarketPrice.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.MarketPrice', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQM<AssetPair>(1, _omitFieldNames ? '' : 'assetPair', subBuilder: AssetPair.create)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'indPrice', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'lastPrice', $pb.PbFieldType.OD)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_MarketPrice clone() => From_MarketPrice()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_MarketPrice copyWith(void Function(From_MarketPrice) updates) => super.copyWith((message) => updates(message as From_MarketPrice)) as From_MarketPrice;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_MarketPrice create() => From_MarketPrice._();
  From_MarketPrice createEmptyInstance() => create();
  static $pb.PbList<From_MarketPrice> createRepeated() => $pb.PbList<From_MarketPrice>();
  @$core.pragma('dart2js:noInline')
  static From_MarketPrice getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_MarketPrice>(create);
  static From_MarketPrice? _defaultInstance;

  @$pb.TagNumber(1)
  AssetPair get assetPair => $_getN(0);
  @$pb.TagNumber(1)
  set assetPair(AssetPair v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasAssetPair() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetPair() => clearField(1);
  @$pb.TagNumber(1)
  AssetPair ensureAssetPair() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.double get indPrice => $_getN(1);
  @$pb.TagNumber(2)
  set indPrice($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasIndPrice() => $_has(1);
  @$pb.TagNumber(2)
  void clearIndPrice() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get lastPrice => $_getN(2);
  @$pb.TagNumber(3)
  set lastPrice($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasLastPrice() => $_has(2);
  @$pb.TagNumber(3)
  void clearLastPrice() => clearField(3);
}

class From_OrderSubmit_UnregisteredGaid extends $pb.GeneratedMessage {
  factory From_OrderSubmit_UnregisteredGaid({
    $core.String? domainAgent,
  }) {
    final $result = create();
    if (domainAgent != null) {
      $result.domainAgent = domainAgent;
    }
    return $result;
  }
  From_OrderSubmit_UnregisteredGaid._() : super();
  factory From_OrderSubmit_UnregisteredGaid.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_OrderSubmit_UnregisteredGaid.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.OrderSubmit.UnregisteredGaid', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'domainAgent')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_OrderSubmit_UnregisteredGaid clone() => From_OrderSubmit_UnregisteredGaid()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_OrderSubmit_UnregisteredGaid copyWith(void Function(From_OrderSubmit_UnregisteredGaid) updates) => super.copyWith((message) => updates(message as From_OrderSubmit_UnregisteredGaid)) as From_OrderSubmit_UnregisteredGaid;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_OrderSubmit_UnregisteredGaid create() => From_OrderSubmit_UnregisteredGaid._();
  From_OrderSubmit_UnregisteredGaid createEmptyInstance() => create();
  static $pb.PbList<From_OrderSubmit_UnregisteredGaid> createRepeated() => $pb.PbList<From_OrderSubmit_UnregisteredGaid>();
  @$core.pragma('dart2js:noInline')
  static From_OrderSubmit_UnregisteredGaid getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_OrderSubmit_UnregisteredGaid>(create);
  static From_OrderSubmit_UnregisteredGaid? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get domainAgent => $_getSZ(0);
  @$pb.TagNumber(1)
  set domainAgent($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDomainAgent() => $_has(0);
  @$pb.TagNumber(1)
  void clearDomainAgent() => clearField(1);
}

enum From_OrderSubmit_Result {
  submitSucceed, 
  error, 
  unregisteredGaid, 
  notSet
}

class From_OrderSubmit extends $pb.GeneratedMessage {
  factory From_OrderSubmit({
    OwnOrder? submitSucceed,
    $core.String? error,
    From_OrderSubmit_UnregisteredGaid? unregisteredGaid,
  }) {
    final $result = create();
    if (submitSucceed != null) {
      $result.submitSucceed = submitSucceed;
    }
    if (error != null) {
      $result.error = error;
    }
    if (unregisteredGaid != null) {
      $result.unregisteredGaid = unregisteredGaid;
    }
    return $result;
  }
  From_OrderSubmit._() : super();
  factory From_OrderSubmit.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_OrderSubmit.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, From_OrderSubmit_Result> _From_OrderSubmit_ResultByTag = {
    1 : From_OrderSubmit_Result.submitSucceed,
    2 : From_OrderSubmit_Result.error,
    3 : From_OrderSubmit_Result.unregisteredGaid,
    0 : From_OrderSubmit_Result.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.OrderSubmit', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..oo(0, [1, 2, 3])
    ..aOM<OwnOrder>(1, _omitFieldNames ? '' : 'submitSucceed', subBuilder: OwnOrder.create)
    ..aOS(2, _omitFieldNames ? '' : 'error')
    ..aOM<From_OrderSubmit_UnregisteredGaid>(3, _omitFieldNames ? '' : 'unregisteredGaid', subBuilder: From_OrderSubmit_UnregisteredGaid.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_OrderSubmit clone() => From_OrderSubmit()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_OrderSubmit copyWith(void Function(From_OrderSubmit) updates) => super.copyWith((message) => updates(message as From_OrderSubmit)) as From_OrderSubmit;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_OrderSubmit create() => From_OrderSubmit._();
  From_OrderSubmit createEmptyInstance() => create();
  static $pb.PbList<From_OrderSubmit> createRepeated() => $pb.PbList<From_OrderSubmit>();
  @$core.pragma('dart2js:noInline')
  static From_OrderSubmit getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_OrderSubmit>(create);
  static From_OrderSubmit? _defaultInstance;

  From_OrderSubmit_Result whichResult() => _From_OrderSubmit_ResultByTag[$_whichOneof(0)]!;
  void clearResult() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  OwnOrder get submitSucceed => $_getN(0);
  @$pb.TagNumber(1)
  set submitSucceed(OwnOrder v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasSubmitSucceed() => $_has(0);
  @$pb.TagNumber(1)
  void clearSubmitSucceed() => clearField(1);
  @$pb.TagNumber(1)
  OwnOrder ensureSubmitSucceed() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get error => $_getSZ(1);
  @$pb.TagNumber(2)
  set error($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasError() => $_has(1);
  @$pb.TagNumber(2)
  void clearError() => clearField(2);

  @$pb.TagNumber(3)
  From_OrderSubmit_UnregisteredGaid get unregisteredGaid => $_getN(2);
  @$pb.TagNumber(3)
  set unregisteredGaid(From_OrderSubmit_UnregisteredGaid v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasUnregisteredGaid() => $_has(2);
  @$pb.TagNumber(3)
  void clearUnregisteredGaid() => clearField(3);
  @$pb.TagNumber(3)
  From_OrderSubmit_UnregisteredGaid ensureUnregisteredGaid() => $_ensure(2);
}

class From_Quote_Success extends $pb.GeneratedMessage {
  factory From_Quote_Success({
    $fixnum.Int64? quoteId,
    $fixnum.Int64? baseAmount,
    $fixnum.Int64? quoteAmount,
    $fixnum.Int64? serverFee,
    $fixnum.Int64? fixedFee,
    $fixnum.Int64? ttlMilliseconds,
  }) {
    final $result = create();
    if (quoteId != null) {
      $result.quoteId = quoteId;
    }
    if (baseAmount != null) {
      $result.baseAmount = baseAmount;
    }
    if (quoteAmount != null) {
      $result.quoteAmount = quoteAmount;
    }
    if (serverFee != null) {
      $result.serverFee = serverFee;
    }
    if (fixedFee != null) {
      $result.fixedFee = fixedFee;
    }
    if (ttlMilliseconds != null) {
      $result.ttlMilliseconds = ttlMilliseconds;
    }
    return $result;
  }
  From_Quote_Success._() : super();
  factory From_Quote_Success.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_Quote_Success.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.Quote.Success', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'quoteId', $pb.PbFieldType.QU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'baseAmount', $pb.PbFieldType.QU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(3, _omitFieldNames ? '' : 'quoteAmount', $pb.PbFieldType.QU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(4, _omitFieldNames ? '' : 'serverFee', $pb.PbFieldType.QU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(5, _omitFieldNames ? '' : 'fixedFee', $pb.PbFieldType.QU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(6, _omitFieldNames ? '' : 'ttlMilliseconds', $pb.PbFieldType.QU6, defaultOrMaker: $fixnum.Int64.ZERO)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_Quote_Success clone() => From_Quote_Success()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_Quote_Success copyWith(void Function(From_Quote_Success) updates) => super.copyWith((message) => updates(message as From_Quote_Success)) as From_Quote_Success;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_Quote_Success create() => From_Quote_Success._();
  From_Quote_Success createEmptyInstance() => create();
  static $pb.PbList<From_Quote_Success> createRepeated() => $pb.PbList<From_Quote_Success>();
  @$core.pragma('dart2js:noInline')
  static From_Quote_Success getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_Quote_Success>(create);
  static From_Quote_Success? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get quoteId => $_getI64(0);
  @$pb.TagNumber(1)
  set quoteId($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasQuoteId() => $_has(0);
  @$pb.TagNumber(1)
  void clearQuoteId() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get baseAmount => $_getI64(1);
  @$pb.TagNumber(2)
  set baseAmount($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasBaseAmount() => $_has(1);
  @$pb.TagNumber(2)
  void clearBaseAmount() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get quoteAmount => $_getI64(2);
  @$pb.TagNumber(3)
  set quoteAmount($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasQuoteAmount() => $_has(2);
  @$pb.TagNumber(3)
  void clearQuoteAmount() => clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get serverFee => $_getI64(3);
  @$pb.TagNumber(4)
  set serverFee($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasServerFee() => $_has(3);
  @$pb.TagNumber(4)
  void clearServerFee() => clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get fixedFee => $_getI64(4);
  @$pb.TagNumber(5)
  set fixedFee($fixnum.Int64 v) { $_setInt64(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasFixedFee() => $_has(4);
  @$pb.TagNumber(5)
  void clearFixedFee() => clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get ttlMilliseconds => $_getI64(5);
  @$pb.TagNumber(6)
  set ttlMilliseconds($fixnum.Int64 v) { $_setInt64(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasTtlMilliseconds() => $_has(5);
  @$pb.TagNumber(6)
  void clearTtlMilliseconds() => clearField(6);
}

class From_Quote_LowBalance extends $pb.GeneratedMessage {
  factory From_Quote_LowBalance({
    $fixnum.Int64? baseAmount,
    $fixnum.Int64? quoteAmount,
    $fixnum.Int64? serverFee,
    $fixnum.Int64? fixedFee,
    $fixnum.Int64? available,
  }) {
    final $result = create();
    if (baseAmount != null) {
      $result.baseAmount = baseAmount;
    }
    if (quoteAmount != null) {
      $result.quoteAmount = quoteAmount;
    }
    if (serverFee != null) {
      $result.serverFee = serverFee;
    }
    if (fixedFee != null) {
      $result.fixedFee = fixedFee;
    }
    if (available != null) {
      $result.available = available;
    }
    return $result;
  }
  From_Quote_LowBalance._() : super();
  factory From_Quote_LowBalance.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_Quote_LowBalance.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.Quote.LowBalance', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'baseAmount', $pb.PbFieldType.QU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'quoteAmount', $pb.PbFieldType.QU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(3, _omitFieldNames ? '' : 'serverFee', $pb.PbFieldType.QU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(4, _omitFieldNames ? '' : 'fixedFee', $pb.PbFieldType.QU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(5, _omitFieldNames ? '' : 'available', $pb.PbFieldType.QU6, defaultOrMaker: $fixnum.Int64.ZERO)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_Quote_LowBalance clone() => From_Quote_LowBalance()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_Quote_LowBalance copyWith(void Function(From_Quote_LowBalance) updates) => super.copyWith((message) => updates(message as From_Quote_LowBalance)) as From_Quote_LowBalance;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_Quote_LowBalance create() => From_Quote_LowBalance._();
  From_Quote_LowBalance createEmptyInstance() => create();
  static $pb.PbList<From_Quote_LowBalance> createRepeated() => $pb.PbList<From_Quote_LowBalance>();
  @$core.pragma('dart2js:noInline')
  static From_Quote_LowBalance getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_Quote_LowBalance>(create);
  static From_Quote_LowBalance? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get baseAmount => $_getI64(0);
  @$pb.TagNumber(1)
  set baseAmount($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasBaseAmount() => $_has(0);
  @$pb.TagNumber(1)
  void clearBaseAmount() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get quoteAmount => $_getI64(1);
  @$pb.TagNumber(2)
  set quoteAmount($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasQuoteAmount() => $_has(1);
  @$pb.TagNumber(2)
  void clearQuoteAmount() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get serverFee => $_getI64(2);
  @$pb.TagNumber(3)
  set serverFee($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasServerFee() => $_has(2);
  @$pb.TagNumber(3)
  void clearServerFee() => clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get fixedFee => $_getI64(3);
  @$pb.TagNumber(4)
  set fixedFee($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasFixedFee() => $_has(3);
  @$pb.TagNumber(4)
  void clearFixedFee() => clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get available => $_getI64(4);
  @$pb.TagNumber(5)
  set available($fixnum.Int64 v) { $_setInt64(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasAvailable() => $_has(4);
  @$pb.TagNumber(5)
  void clearAvailable() => clearField(5);
}

class From_Quote_UnregisteredGaid extends $pb.GeneratedMessage {
  factory From_Quote_UnregisteredGaid({
    $core.String? domainAgent,
  }) {
    final $result = create();
    if (domainAgent != null) {
      $result.domainAgent = domainAgent;
    }
    return $result;
  }
  From_Quote_UnregisteredGaid._() : super();
  factory From_Quote_UnregisteredGaid.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_Quote_UnregisteredGaid.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.Quote.UnregisteredGaid', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'domainAgent')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_Quote_UnregisteredGaid clone() => From_Quote_UnregisteredGaid()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_Quote_UnregisteredGaid copyWith(void Function(From_Quote_UnregisteredGaid) updates) => super.copyWith((message) => updates(message as From_Quote_UnregisteredGaid)) as From_Quote_UnregisteredGaid;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_Quote_UnregisteredGaid create() => From_Quote_UnregisteredGaid._();
  From_Quote_UnregisteredGaid createEmptyInstance() => create();
  static $pb.PbList<From_Quote_UnregisteredGaid> createRepeated() => $pb.PbList<From_Quote_UnregisteredGaid>();
  @$core.pragma('dart2js:noInline')
  static From_Quote_UnregisteredGaid getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_Quote_UnregisteredGaid>(create);
  static From_Quote_UnregisteredGaid? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get domainAgent => $_getSZ(0);
  @$pb.TagNumber(1)
  set domainAgent($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDomainAgent() => $_has(0);
  @$pb.TagNumber(1)
  void clearDomainAgent() => clearField(1);
}

enum From_Quote_Result {
  success, 
  lowBalance, 
  error, 
  unregisteredGaid, 
  notSet
}

class From_Quote extends $pb.GeneratedMessage {
  factory From_Quote({
    AssetPair? assetPair,
    AssetType? assetType,
    $fixnum.Int64? amount,
    TradeDir? tradeDir,
    $fixnum.Int64? orderId,
    From_Quote_Success? success,
    From_Quote_LowBalance? lowBalance,
    $core.String? error,
    From_Quote_UnregisteredGaid? unregisteredGaid,
  }) {
    final $result = create();
    if (assetPair != null) {
      $result.assetPair = assetPair;
    }
    if (assetType != null) {
      $result.assetType = assetType;
    }
    if (amount != null) {
      $result.amount = amount;
    }
    if (tradeDir != null) {
      $result.tradeDir = tradeDir;
    }
    if (orderId != null) {
      $result.orderId = orderId;
    }
    if (success != null) {
      $result.success = success;
    }
    if (lowBalance != null) {
      $result.lowBalance = lowBalance;
    }
    if (error != null) {
      $result.error = error;
    }
    if (unregisteredGaid != null) {
      $result.unregisteredGaid = unregisteredGaid;
    }
    return $result;
  }
  From_Quote._() : super();
  factory From_Quote.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_Quote.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, From_Quote_Result> _From_Quote_ResultByTag = {
    10 : From_Quote_Result.success,
    11 : From_Quote_Result.lowBalance,
    12 : From_Quote_Result.error,
    13 : From_Quote_Result.unregisteredGaid,
    0 : From_Quote_Result.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.Quote', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..oo(0, [10, 11, 12, 13])
    ..aQM<AssetPair>(1, _omitFieldNames ? '' : 'assetPair', subBuilder: AssetPair.create)
    ..e<AssetType>(2, _omitFieldNames ? '' : 'assetType', $pb.PbFieldType.QE, defaultOrMaker: AssetType.BASE, valueOf: AssetType.valueOf, enumValues: AssetType.values)
    ..a<$fixnum.Int64>(3, _omitFieldNames ? '' : 'amount', $pb.PbFieldType.QU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..e<TradeDir>(4, _omitFieldNames ? '' : 'tradeDir', $pb.PbFieldType.QE, defaultOrMaker: TradeDir.SELL, valueOf: TradeDir.valueOf, enumValues: TradeDir.values)
    ..a<$fixnum.Int64>(5, _omitFieldNames ? '' : 'orderId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOM<From_Quote_Success>(10, _omitFieldNames ? '' : 'success', subBuilder: From_Quote_Success.create)
    ..aOM<From_Quote_LowBalance>(11, _omitFieldNames ? '' : 'lowBalance', subBuilder: From_Quote_LowBalance.create)
    ..aOS(12, _omitFieldNames ? '' : 'error')
    ..aOM<From_Quote_UnregisteredGaid>(13, _omitFieldNames ? '' : 'unregisteredGaid', subBuilder: From_Quote_UnregisteredGaid.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_Quote clone() => From_Quote()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_Quote copyWith(void Function(From_Quote) updates) => super.copyWith((message) => updates(message as From_Quote)) as From_Quote;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_Quote create() => From_Quote._();
  From_Quote createEmptyInstance() => create();
  static $pb.PbList<From_Quote> createRepeated() => $pb.PbList<From_Quote>();
  @$core.pragma('dart2js:noInline')
  static From_Quote getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_Quote>(create);
  static From_Quote? _defaultInstance;

  From_Quote_Result whichResult() => _From_Quote_ResultByTag[$_whichOneof(0)]!;
  void clearResult() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  AssetPair get assetPair => $_getN(0);
  @$pb.TagNumber(1)
  set assetPair(AssetPair v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasAssetPair() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetPair() => clearField(1);
  @$pb.TagNumber(1)
  AssetPair ensureAssetPair() => $_ensure(0);

  @$pb.TagNumber(2)
  AssetType get assetType => $_getN(1);
  @$pb.TagNumber(2)
  set assetType(AssetType v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasAssetType() => $_has(1);
  @$pb.TagNumber(2)
  void clearAssetType() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get amount => $_getI64(2);
  @$pb.TagNumber(3)
  set amount($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAmount() => $_has(2);
  @$pb.TagNumber(3)
  void clearAmount() => clearField(3);

  @$pb.TagNumber(4)
  TradeDir get tradeDir => $_getN(3);
  @$pb.TagNumber(4)
  set tradeDir(TradeDir v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasTradeDir() => $_has(3);
  @$pb.TagNumber(4)
  void clearTradeDir() => clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get orderId => $_getI64(4);
  @$pb.TagNumber(5)
  set orderId($fixnum.Int64 v) { $_setInt64(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasOrderId() => $_has(4);
  @$pb.TagNumber(5)
  void clearOrderId() => clearField(5);

  @$pb.TagNumber(10)
  From_Quote_Success get success => $_getN(5);
  @$pb.TagNumber(10)
  set success(From_Quote_Success v) { setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasSuccess() => $_has(5);
  @$pb.TagNumber(10)
  void clearSuccess() => clearField(10);
  @$pb.TagNumber(10)
  From_Quote_Success ensureSuccess() => $_ensure(5);

  @$pb.TagNumber(11)
  From_Quote_LowBalance get lowBalance => $_getN(6);
  @$pb.TagNumber(11)
  set lowBalance(From_Quote_LowBalance v) { setField(11, v); }
  @$pb.TagNumber(11)
  $core.bool hasLowBalance() => $_has(6);
  @$pb.TagNumber(11)
  void clearLowBalance() => clearField(11);
  @$pb.TagNumber(11)
  From_Quote_LowBalance ensureLowBalance() => $_ensure(6);

  @$pb.TagNumber(12)
  $core.String get error => $_getSZ(7);
  @$pb.TagNumber(12)
  set error($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(12)
  $core.bool hasError() => $_has(7);
  @$pb.TagNumber(12)
  void clearError() => clearField(12);

  @$pb.TagNumber(13)
  From_Quote_UnregisteredGaid get unregisteredGaid => $_getN(8);
  @$pb.TagNumber(13)
  set unregisteredGaid(From_Quote_UnregisteredGaid v) { setField(13, v); }
  @$pb.TagNumber(13)
  $core.bool hasUnregisteredGaid() => $_has(8);
  @$pb.TagNumber(13)
  void clearUnregisteredGaid() => clearField(13);
  @$pb.TagNumber(13)
  From_Quote_UnregisteredGaid ensureUnregisteredGaid() => $_ensure(8);
}

class From_AcceptQuote_Success extends $pb.GeneratedMessage {
  factory From_AcceptQuote_Success({
    $core.String? txid,
  }) {
    final $result = create();
    if (txid != null) {
      $result.txid = txid;
    }
    return $result;
  }
  From_AcceptQuote_Success._() : super();
  factory From_AcceptQuote_Success.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_AcceptQuote_Success.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.AcceptQuote.Success', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'txid')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_AcceptQuote_Success clone() => From_AcceptQuote_Success()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_AcceptQuote_Success copyWith(void Function(From_AcceptQuote_Success) updates) => super.copyWith((message) => updates(message as From_AcceptQuote_Success)) as From_AcceptQuote_Success;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_AcceptQuote_Success create() => From_AcceptQuote_Success._();
  From_AcceptQuote_Success createEmptyInstance() => create();
  static $pb.PbList<From_AcceptQuote_Success> createRepeated() => $pb.PbList<From_AcceptQuote_Success>();
  @$core.pragma('dart2js:noInline')
  static From_AcceptQuote_Success getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_AcceptQuote_Success>(create);
  static From_AcceptQuote_Success? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get txid => $_getSZ(0);
  @$pb.TagNumber(1)
  set txid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTxid() => $_has(0);
  @$pb.TagNumber(1)
  void clearTxid() => clearField(1);
}

enum From_AcceptQuote_Result {
  success, 
  error, 
  notSet
}

class From_AcceptQuote extends $pb.GeneratedMessage {
  factory From_AcceptQuote({
    From_AcceptQuote_Success? success,
    $core.String? error,
  }) {
    final $result = create();
    if (success != null) {
      $result.success = success;
    }
    if (error != null) {
      $result.error = error;
    }
    return $result;
  }
  From_AcceptQuote._() : super();
  factory From_AcceptQuote.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_AcceptQuote.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, From_AcceptQuote_Result> _From_AcceptQuote_ResultByTag = {
    1 : From_AcceptQuote_Result.success,
    2 : From_AcceptQuote_Result.error,
    0 : From_AcceptQuote_Result.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.AcceptQuote', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOM<From_AcceptQuote_Success>(1, _omitFieldNames ? '' : 'success', subBuilder: From_AcceptQuote_Success.create)
    ..aOS(2, _omitFieldNames ? '' : 'error')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_AcceptQuote clone() => From_AcceptQuote()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_AcceptQuote copyWith(void Function(From_AcceptQuote) updates) => super.copyWith((message) => updates(message as From_AcceptQuote)) as From_AcceptQuote;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_AcceptQuote create() => From_AcceptQuote._();
  From_AcceptQuote createEmptyInstance() => create();
  static $pb.PbList<From_AcceptQuote> createRepeated() => $pb.PbList<From_AcceptQuote>();
  @$core.pragma('dart2js:noInline')
  static From_AcceptQuote getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_AcceptQuote>(create);
  static From_AcceptQuote? _defaultInstance;

  From_AcceptQuote_Result whichResult() => _From_AcceptQuote_ResultByTag[$_whichOneof(0)]!;
  void clearResult() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  From_AcceptQuote_Success get success => $_getN(0);
  @$pb.TagNumber(1)
  set success(From_AcceptQuote_Success v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => clearField(1);
  @$pb.TagNumber(1)
  From_AcceptQuote_Success ensureSuccess() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get error => $_getSZ(1);
  @$pb.TagNumber(2)
  set error($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasError() => $_has(1);
  @$pb.TagNumber(2)
  void clearError() => clearField(2);
}

class From_ChartsSubscribe extends $pb.GeneratedMessage {
  factory From_ChartsSubscribe({
    AssetPair? assetPair,
    $core.Iterable<ChartPoint>? data,
  }) {
    final $result = create();
    if (assetPair != null) {
      $result.assetPair = assetPair;
    }
    if (data != null) {
      $result.data.addAll(data);
    }
    return $result;
  }
  From_ChartsSubscribe._() : super();
  factory From_ChartsSubscribe.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_ChartsSubscribe.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.ChartsSubscribe', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQM<AssetPair>(1, _omitFieldNames ? '' : 'assetPair', subBuilder: AssetPair.create)
    ..pc<ChartPoint>(2, _omitFieldNames ? '' : 'data', $pb.PbFieldType.PM, subBuilder: ChartPoint.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_ChartsSubscribe clone() => From_ChartsSubscribe()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_ChartsSubscribe copyWith(void Function(From_ChartsSubscribe) updates) => super.copyWith((message) => updates(message as From_ChartsSubscribe)) as From_ChartsSubscribe;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_ChartsSubscribe create() => From_ChartsSubscribe._();
  From_ChartsSubscribe createEmptyInstance() => create();
  static $pb.PbList<From_ChartsSubscribe> createRepeated() => $pb.PbList<From_ChartsSubscribe>();
  @$core.pragma('dart2js:noInline')
  static From_ChartsSubscribe getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_ChartsSubscribe>(create);
  static From_ChartsSubscribe? _defaultInstance;

  @$pb.TagNumber(1)
  AssetPair get assetPair => $_getN(0);
  @$pb.TagNumber(1)
  set assetPair(AssetPair v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasAssetPair() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetPair() => clearField(1);
  @$pb.TagNumber(1)
  AssetPair ensureAssetPair() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.List<ChartPoint> get data => $_getList(1);
}

class From_ChartsUpdate extends $pb.GeneratedMessage {
  factory From_ChartsUpdate({
    AssetPair? assetPair,
    ChartPoint? update,
  }) {
    final $result = create();
    if (assetPair != null) {
      $result.assetPair = assetPair;
    }
    if (update != null) {
      $result.update = update;
    }
    return $result;
  }
  From_ChartsUpdate._() : super();
  factory From_ChartsUpdate.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_ChartsUpdate.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.ChartsUpdate', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQM<AssetPair>(1, _omitFieldNames ? '' : 'assetPair', subBuilder: AssetPair.create)
    ..aQM<ChartPoint>(2, _omitFieldNames ? '' : 'update', subBuilder: ChartPoint.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_ChartsUpdate clone() => From_ChartsUpdate()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_ChartsUpdate copyWith(void Function(From_ChartsUpdate) updates) => super.copyWith((message) => updates(message as From_ChartsUpdate)) as From_ChartsUpdate;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_ChartsUpdate create() => From_ChartsUpdate._();
  From_ChartsUpdate createEmptyInstance() => create();
  static $pb.PbList<From_ChartsUpdate> createRepeated() => $pb.PbList<From_ChartsUpdate>();
  @$core.pragma('dart2js:noInline')
  static From_ChartsUpdate getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_ChartsUpdate>(create);
  static From_ChartsUpdate? _defaultInstance;

  @$pb.TagNumber(1)
  AssetPair get assetPair => $_getN(0);
  @$pb.TagNumber(1)
  set assetPair(AssetPair v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasAssetPair() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetPair() => clearField(1);
  @$pb.TagNumber(1)
  AssetPair ensureAssetPair() => $_ensure(0);

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

class From_LoadHistory extends $pb.GeneratedMessage {
  factory From_LoadHistory({
    $core.Iterable<HistoryOrder>? list,
    $core.int? total,
  }) {
    final $result = create();
    if (list != null) {
      $result.list.addAll(list);
    }
    if (total != null) {
      $result.total = total;
    }
    return $result;
  }
  From_LoadHistory._() : super();
  factory From_LoadHistory.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_LoadHistory.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.LoadHistory', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..pc<HistoryOrder>(1, _omitFieldNames ? '' : 'list', $pb.PbFieldType.PM, subBuilder: HistoryOrder.create)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'total', $pb.PbFieldType.QU3)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_LoadHistory clone() => From_LoadHistory()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_LoadHistory copyWith(void Function(From_LoadHistory) updates) => super.copyWith((message) => updates(message as From_LoadHistory)) as From_LoadHistory;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_LoadHistory create() => From_LoadHistory._();
  From_LoadHistory createEmptyInstance() => create();
  static $pb.PbList<From_LoadHistory> createRepeated() => $pb.PbList<From_LoadHistory>();
  @$core.pragma('dart2js:noInline')
  static From_LoadHistory getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_LoadHistory>(create);
  static From_LoadHistory? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<HistoryOrder> get list => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get total => $_getIZ(1);
  @$pb.TagNumber(2)
  set total($core.int v) { $_setUnsignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTotal() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotal() => clearField(2);
}

class From_HistoryUpdated extends $pb.GeneratedMessage {
  factory From_HistoryUpdated({
    HistoryOrder? order,
    $core.bool? isNew,
  }) {
    final $result = create();
    if (order != null) {
      $result.order = order;
    }
    if (isNew != null) {
      $result.isNew = isNew;
    }
    return $result;
  }
  From_HistoryUpdated._() : super();
  factory From_HistoryUpdated.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_HistoryUpdated.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.HistoryUpdated', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQM<HistoryOrder>(1, _omitFieldNames ? '' : 'order', subBuilder: HistoryOrder.create)
    ..a<$core.bool>(2, _omitFieldNames ? '' : 'isNew', $pb.PbFieldType.QB)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_HistoryUpdated clone() => From_HistoryUpdated()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_HistoryUpdated copyWith(void Function(From_HistoryUpdated) updates) => super.copyWith((message) => updates(message as From_HistoryUpdated)) as From_HistoryUpdated;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_HistoryUpdated create() => From_HistoryUpdated._();
  From_HistoryUpdated createEmptyInstance() => create();
  static $pb.PbList<From_HistoryUpdated> createRepeated() => $pb.PbList<From_HistoryUpdated>();
  @$core.pragma('dart2js:noInline')
  static From_HistoryUpdated getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_HistoryUpdated>(create);
  static From_HistoryUpdated? _defaultInstance;

  @$pb.TagNumber(1)
  HistoryOrder get order => $_getN(0);
  @$pb.TagNumber(1)
  set order(HistoryOrder v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasOrder() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrder() => clearField(1);
  @$pb.TagNumber(1)
  HistoryOrder ensureOrder() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.bool get isNew => $_getBF(1);
  @$pb.TagNumber(2)
  set isNew($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasIsNew() => $_has(1);
  @$pb.TagNumber(2)
  void clearIsNew() => clearField(2);
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
  logout, 
  login, 
  peginWaitTx, 
  swapSucceed, 
  swapFailed, 
  pegOutAmount, 
  recvAddress, 
  createTxResult, 
  sendResult, 
  blindedValues, 
  loadUtxos, 
  loadAddresses, 
  showMessage, 
  insufficientFunds, 
  serverConnected, 
  serverDisconnected, 
  assetDetails, 
  updatePriceStream, 
  localMessage, 
  portfolioPrices, 
  conversionRates, 
  jadePorts, 
  jadeStatus, 
  gaidStatus, 
  marketList, 
  marketAdded, 
  marketRemoved, 
  publicOrders, 
  publicOrderCreated, 
  publicOrderRemoved, 
  marketPrice, 
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
    Empty? logout,
    From_Login? login,
    From_PeginWaitTx? peginWaitTx,
    TransItem? swapSucceed,
    $core.String? swapFailed,
    From_PegOutAmount? pegOutAmount,
    From_RecvAddress? recvAddress,
    From_CreateTxResult? createTxResult,
    From_SendResult? sendResult,
    From_BlindedValues? blindedValues,
    From_LoadUtxos? loadUtxos,
    From_LoadAddresses? loadAddresses,
    From_ShowMessage? showMessage,
    From_ShowInsufficientFunds? insufficientFunds,
    Empty? serverConnected,
    Empty? serverDisconnected,
    From_AssetDetails? assetDetails,
    From_UpdatePriceStream? updatePriceStream,
    From_LocalMessage? localMessage,
    From_PortfolioPrices? portfolioPrices,
    From_ConversionRates? conversionRates,
    From_JadePorts? jadePorts,
    From_JadeStatus? jadeStatus,
    From_GaidStatus? gaidStatus,
    From_MarketList? marketList,
    MarketInfo? marketAdded,
    AssetPair? marketRemoved,
    From_PublicOrders? publicOrders,
    PublicOrder? publicOrderCreated,
    OrderId? publicOrderRemoved,
    From_MarketPrice? marketPrice,
    From_OwnOrders? ownOrders,
    OwnOrder? ownOrderCreated,
    OrderId? ownOrderRemoved,
    From_OrderSubmit? orderSubmit,
    GenericResponse? orderEdit,
    GenericResponse? orderCancel,
    From_Quote? quote,
    From_AcceptQuote? acceptQuote,
    GenericResponse? startOrder,
    From_ChartsSubscribe? chartsSubscribe,
    From_ChartsUpdate? chartsUpdate,
    From_LoadHistory? loadHistory,
    From_HistoryUpdated? historyUpdated,
  }) {
    final $result = create();
    if (updatedTxs != null) {
      $result.updatedTxs = updatedTxs;
    }
    if (updatedPegs != null) {
      $result.updatedPegs = updatedPegs;
    }
    if (newAsset != null) {
      $result.newAsset = newAsset;
    }
    if (balanceUpdate != null) {
      $result.balanceUpdate = balanceUpdate;
    }
    if (serverStatus != null) {
      $result.serverStatus = serverStatus;
    }
    if (priceUpdate != null) {
      $result.priceUpdate = priceUpdate;
    }
    if (walletLoaded != null) {
      $result.walletLoaded = walletLoaded;
    }
    if (registerAmp != null) {
      $result.registerAmp = registerAmp;
    }
    if (ampAssets != null) {
      $result.ampAssets = ampAssets;
    }
    if (encryptPin != null) {
      $result.encryptPin = encryptPin;
    }
    if (decryptPin != null) {
      $result.decryptPin = decryptPin;
    }
    if (removedTxs != null) {
      $result.removedTxs = removedTxs;
    }
    if (envSettings != null) {
      $result.envSettings = envSettings;
    }
    if (syncComplete != null) {
      $result.syncComplete = syncComplete;
    }
    if (logout != null) {
      $result.logout = logout;
    }
    if (login != null) {
      $result.login = login;
    }
    if (peginWaitTx != null) {
      $result.peginWaitTx = peginWaitTx;
    }
    if (swapSucceed != null) {
      $result.swapSucceed = swapSucceed;
    }
    if (swapFailed != null) {
      $result.swapFailed = swapFailed;
    }
    if (pegOutAmount != null) {
      $result.pegOutAmount = pegOutAmount;
    }
    if (recvAddress != null) {
      $result.recvAddress = recvAddress;
    }
    if (createTxResult != null) {
      $result.createTxResult = createTxResult;
    }
    if (sendResult != null) {
      $result.sendResult = sendResult;
    }
    if (blindedValues != null) {
      $result.blindedValues = blindedValues;
    }
    if (loadUtxos != null) {
      $result.loadUtxos = loadUtxos;
    }
    if (loadAddresses != null) {
      $result.loadAddresses = loadAddresses;
    }
    if (showMessage != null) {
      $result.showMessage = showMessage;
    }
    if (insufficientFunds != null) {
      $result.insufficientFunds = insufficientFunds;
    }
    if (serverConnected != null) {
      $result.serverConnected = serverConnected;
    }
    if (serverDisconnected != null) {
      $result.serverDisconnected = serverDisconnected;
    }
    if (assetDetails != null) {
      $result.assetDetails = assetDetails;
    }
    if (updatePriceStream != null) {
      $result.updatePriceStream = updatePriceStream;
    }
    if (localMessage != null) {
      $result.localMessage = localMessage;
    }
    if (portfolioPrices != null) {
      $result.portfolioPrices = portfolioPrices;
    }
    if (conversionRates != null) {
      $result.conversionRates = conversionRates;
    }
    if (jadePorts != null) {
      $result.jadePorts = jadePorts;
    }
    if (jadeStatus != null) {
      $result.jadeStatus = jadeStatus;
    }
    if (gaidStatus != null) {
      $result.gaidStatus = gaidStatus;
    }
    if (marketList != null) {
      $result.marketList = marketList;
    }
    if (marketAdded != null) {
      $result.marketAdded = marketAdded;
    }
    if (marketRemoved != null) {
      $result.marketRemoved = marketRemoved;
    }
    if (publicOrders != null) {
      $result.publicOrders = publicOrders;
    }
    if (publicOrderCreated != null) {
      $result.publicOrderCreated = publicOrderCreated;
    }
    if (publicOrderRemoved != null) {
      $result.publicOrderRemoved = publicOrderRemoved;
    }
    if (marketPrice != null) {
      $result.marketPrice = marketPrice;
    }
    if (ownOrders != null) {
      $result.ownOrders = ownOrders;
    }
    if (ownOrderCreated != null) {
      $result.ownOrderCreated = ownOrderCreated;
    }
    if (ownOrderRemoved != null) {
      $result.ownOrderRemoved = ownOrderRemoved;
    }
    if (orderSubmit != null) {
      $result.orderSubmit = orderSubmit;
    }
    if (orderEdit != null) {
      $result.orderEdit = orderEdit;
    }
    if (orderCancel != null) {
      $result.orderCancel = orderCancel;
    }
    if (quote != null) {
      $result.quote = quote;
    }
    if (acceptQuote != null) {
      $result.acceptQuote = acceptQuote;
    }
    if (startOrder != null) {
      $result.startOrder = startOrder;
    }
    if (chartsSubscribe != null) {
      $result.chartsSubscribe = chartsSubscribe;
    }
    if (chartsUpdate != null) {
      $result.chartsUpdate = chartsUpdate;
    }
    if (loadHistory != null) {
      $result.loadHistory = loadHistory;
    }
    if (historyUpdated != null) {
      $result.historyUpdated = historyUpdated;
    }
    return $result;
  }
  From._() : super();
  factory From.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

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
    16 : From_Msg.logout,
    17 : From_Msg.login,
    21 : From_Msg.peginWaitTx,
    22 : From_Msg.swapSucceed,
    23 : From_Msg.swapFailed,
    24 : From_Msg.pegOutAmount,
    30 : From_Msg.recvAddress,
    31 : From_Msg.createTxResult,
    32 : From_Msg.sendResult,
    33 : From_Msg.blindedValues,
    35 : From_Msg.loadUtxos,
    36 : From_Msg.loadAddresses,
    50 : From_Msg.showMessage,
    55 : From_Msg.insufficientFunds,
    60 : From_Msg.serverConnected,
    61 : From_Msg.serverDisconnected,
    65 : From_Msg.assetDetails,
    66 : From_Msg.updatePriceStream,
    68 : From_Msg.localMessage,
    72 : From_Msg.portfolioPrices,
    73 : From_Msg.conversionRates,
    80 : From_Msg.jadePorts,
    83 : From_Msg.jadeStatus,
    91 : From_Msg.gaidStatus,
    100 : From_Msg.marketList,
    101 : From_Msg.marketAdded,
    102 : From_Msg.marketRemoved,
    105 : From_Msg.publicOrders,
    106 : From_Msg.publicOrderCreated,
    107 : From_Msg.publicOrderRemoved,
    110 : From_Msg.marketPrice,
    120 : From_Msg.ownOrders,
    121 : From_Msg.ownOrderCreated,
    122 : From_Msg.ownOrderRemoved,
    130 : From_Msg.orderSubmit,
    131 : From_Msg.orderEdit,
    132 : From_Msg.orderCancel,
    140 : From_Msg.quote,
    141 : From_Msg.acceptQuote,
    142 : From_Msg.startOrder,
    150 : From_Msg.chartsSubscribe,
    151 : From_Msg.chartsUpdate,
    160 : From_Msg.loadHistory,
    161 : From_Msg.historyUpdated,
    0 : From_Msg.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 16, 17, 21, 22, 23, 24, 30, 31, 32, 33, 35, 36, 50, 55, 60, 61, 65, 66, 68, 72, 73, 80, 83, 91, 100, 101, 102, 105, 106, 107, 110, 120, 121, 122, 130, 131, 132, 140, 141, 142, 150, 151, 160, 161])
    ..aOM<From_UpdatedTxs>(1, _omitFieldNames ? '' : 'updatedTxs', subBuilder: From_UpdatedTxs.create)
    ..aOM<From_UpdatedPegs>(2, _omitFieldNames ? '' : 'updatedPegs', subBuilder: From_UpdatedPegs.create)
    ..aOM<Asset>(3, _omitFieldNames ? '' : 'newAsset', subBuilder: Asset.create)
    ..aOM<From_BalanceUpdate>(4, _omitFieldNames ? '' : 'balanceUpdate', subBuilder: From_BalanceUpdate.create)
    ..aOM<ServerStatus>(5, _omitFieldNames ? '' : 'serverStatus', subBuilder: ServerStatus.create)
    ..aOM<From_PriceUpdate>(6, _omitFieldNames ? '' : 'priceUpdate', subBuilder: From_PriceUpdate.create)
    ..aOM<Empty>(7, _omitFieldNames ? '' : 'walletLoaded', subBuilder: Empty.create)
    ..aOM<From_RegisterAmp>(8, _omitFieldNames ? '' : 'registerAmp', subBuilder: From_RegisterAmp.create)
    ..aOM<From_AmpAssets>(9, _omitFieldNames ? '' : 'ampAssets', subBuilder: From_AmpAssets.create)
    ..aOM<From_EncryptPin>(10, _omitFieldNames ? '' : 'encryptPin', subBuilder: From_EncryptPin.create)
    ..aOM<From_DecryptPin>(11, _omitFieldNames ? '' : 'decryptPin', subBuilder: From_DecryptPin.create)
    ..aOM<From_RemovedTxs>(12, _omitFieldNames ? '' : 'removedTxs', subBuilder: From_RemovedTxs.create)
    ..aOM<From_EnvSettings>(13, _omitFieldNames ? '' : 'envSettings', subBuilder: From_EnvSettings.create)
    ..aOM<Empty>(14, _omitFieldNames ? '' : 'syncComplete', subBuilder: Empty.create)
    ..aOM<Empty>(16, _omitFieldNames ? '' : 'logout', subBuilder: Empty.create)
    ..aOM<From_Login>(17, _omitFieldNames ? '' : 'login', subBuilder: From_Login.create)
    ..aOM<From_PeginWaitTx>(21, _omitFieldNames ? '' : 'peginWaitTx', subBuilder: From_PeginWaitTx.create)
    ..aOM<TransItem>(22, _omitFieldNames ? '' : 'swapSucceed', subBuilder: TransItem.create)
    ..aOS(23, _omitFieldNames ? '' : 'swapFailed')
    ..aOM<From_PegOutAmount>(24, _omitFieldNames ? '' : 'pegOutAmount', subBuilder: From_PegOutAmount.create)
    ..aOM<From_RecvAddress>(30, _omitFieldNames ? '' : 'recvAddress', subBuilder: From_RecvAddress.create)
    ..aOM<From_CreateTxResult>(31, _omitFieldNames ? '' : 'createTxResult', subBuilder: From_CreateTxResult.create)
    ..aOM<From_SendResult>(32, _omitFieldNames ? '' : 'sendResult', subBuilder: From_SendResult.create)
    ..aOM<From_BlindedValues>(33, _omitFieldNames ? '' : 'blindedValues', subBuilder: From_BlindedValues.create)
    ..aOM<From_LoadUtxos>(35, _omitFieldNames ? '' : 'loadUtxos', subBuilder: From_LoadUtxos.create)
    ..aOM<From_LoadAddresses>(36, _omitFieldNames ? '' : 'loadAddresses', subBuilder: From_LoadAddresses.create)
    ..aOM<From_ShowMessage>(50, _omitFieldNames ? '' : 'showMessage', subBuilder: From_ShowMessage.create)
    ..aOM<From_ShowInsufficientFunds>(55, _omitFieldNames ? '' : 'insufficientFunds', subBuilder: From_ShowInsufficientFunds.create)
    ..aOM<Empty>(60, _omitFieldNames ? '' : 'serverConnected', subBuilder: Empty.create)
    ..aOM<Empty>(61, _omitFieldNames ? '' : 'serverDisconnected', subBuilder: Empty.create)
    ..aOM<From_AssetDetails>(65, _omitFieldNames ? '' : 'assetDetails', subBuilder: From_AssetDetails.create)
    ..aOM<From_UpdatePriceStream>(66, _omitFieldNames ? '' : 'updatePriceStream', subBuilder: From_UpdatePriceStream.create)
    ..aOM<From_LocalMessage>(68, _omitFieldNames ? '' : 'localMessage', subBuilder: From_LocalMessage.create)
    ..aOM<From_PortfolioPrices>(72, _omitFieldNames ? '' : 'portfolioPrices', subBuilder: From_PortfolioPrices.create)
    ..aOM<From_ConversionRates>(73, _omitFieldNames ? '' : 'conversionRates', subBuilder: From_ConversionRates.create)
    ..aOM<From_JadePorts>(80, _omitFieldNames ? '' : 'jadePorts', subBuilder: From_JadePorts.create)
    ..aOM<From_JadeStatus>(83, _omitFieldNames ? '' : 'jadeStatus', subBuilder: From_JadeStatus.create)
    ..aOM<From_GaidStatus>(91, _omitFieldNames ? '' : 'gaidStatus', subBuilder: From_GaidStatus.create)
    ..aOM<From_MarketList>(100, _omitFieldNames ? '' : 'marketList', subBuilder: From_MarketList.create)
    ..aOM<MarketInfo>(101, _omitFieldNames ? '' : 'marketAdded', subBuilder: MarketInfo.create)
    ..aOM<AssetPair>(102, _omitFieldNames ? '' : 'marketRemoved', subBuilder: AssetPair.create)
    ..aOM<From_PublicOrders>(105, _omitFieldNames ? '' : 'publicOrders', subBuilder: From_PublicOrders.create)
    ..aOM<PublicOrder>(106, _omitFieldNames ? '' : 'publicOrderCreated', subBuilder: PublicOrder.create)
    ..aOM<OrderId>(107, _omitFieldNames ? '' : 'publicOrderRemoved', subBuilder: OrderId.create)
    ..aOM<From_MarketPrice>(110, _omitFieldNames ? '' : 'marketPrice', subBuilder: From_MarketPrice.create)
    ..aOM<From_OwnOrders>(120, _omitFieldNames ? '' : 'ownOrders', subBuilder: From_OwnOrders.create)
    ..aOM<OwnOrder>(121, _omitFieldNames ? '' : 'ownOrderCreated', subBuilder: OwnOrder.create)
    ..aOM<OrderId>(122, _omitFieldNames ? '' : 'ownOrderRemoved', subBuilder: OrderId.create)
    ..aOM<From_OrderSubmit>(130, _omitFieldNames ? '' : 'orderSubmit', subBuilder: From_OrderSubmit.create)
    ..aOM<GenericResponse>(131, _omitFieldNames ? '' : 'orderEdit', subBuilder: GenericResponse.create)
    ..aOM<GenericResponse>(132, _omitFieldNames ? '' : 'orderCancel', subBuilder: GenericResponse.create)
    ..aOM<From_Quote>(140, _omitFieldNames ? '' : 'quote', subBuilder: From_Quote.create)
    ..aOM<From_AcceptQuote>(141, _omitFieldNames ? '' : 'acceptQuote', subBuilder: From_AcceptQuote.create)
    ..aOM<GenericResponse>(142, _omitFieldNames ? '' : 'startOrder', subBuilder: GenericResponse.create)
    ..aOM<From_ChartsSubscribe>(150, _omitFieldNames ? '' : 'chartsSubscribe', subBuilder: From_ChartsSubscribe.create)
    ..aOM<From_ChartsUpdate>(151, _omitFieldNames ? '' : 'chartsUpdate', subBuilder: From_ChartsUpdate.create)
    ..aOM<From_LoadHistory>(160, _omitFieldNames ? '' : 'loadHistory', subBuilder: From_LoadHistory.create)
    ..aOM<From_HistoryUpdated>(161, _omitFieldNames ? '' : 'historyUpdated', subBuilder: From_HistoryUpdated.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From clone() => From()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From copyWith(void Function(From) updates) => super.copyWith((message) => updates(message as From)) as From;

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

  @$pb.TagNumber(16)
  Empty get logout => $_getN(14);
  @$pb.TagNumber(16)
  set logout(Empty v) { setField(16, v); }
  @$pb.TagNumber(16)
  $core.bool hasLogout() => $_has(14);
  @$pb.TagNumber(16)
  void clearLogout() => clearField(16);
  @$pb.TagNumber(16)
  Empty ensureLogout() => $_ensure(14);

  @$pb.TagNumber(17)
  From_Login get login => $_getN(15);
  @$pb.TagNumber(17)
  set login(From_Login v) { setField(17, v); }
  @$pb.TagNumber(17)
  $core.bool hasLogin() => $_has(15);
  @$pb.TagNumber(17)
  void clearLogin() => clearField(17);
  @$pb.TagNumber(17)
  From_Login ensureLogin() => $_ensure(15);

  @$pb.TagNumber(21)
  From_PeginWaitTx get peginWaitTx => $_getN(16);
  @$pb.TagNumber(21)
  set peginWaitTx(From_PeginWaitTx v) { setField(21, v); }
  @$pb.TagNumber(21)
  $core.bool hasPeginWaitTx() => $_has(16);
  @$pb.TagNumber(21)
  void clearPeginWaitTx() => clearField(21);
  @$pb.TagNumber(21)
  From_PeginWaitTx ensurePeginWaitTx() => $_ensure(16);

  @$pb.TagNumber(22)
  TransItem get swapSucceed => $_getN(17);
  @$pb.TagNumber(22)
  set swapSucceed(TransItem v) { setField(22, v); }
  @$pb.TagNumber(22)
  $core.bool hasSwapSucceed() => $_has(17);
  @$pb.TagNumber(22)
  void clearSwapSucceed() => clearField(22);
  @$pb.TagNumber(22)
  TransItem ensureSwapSucceed() => $_ensure(17);

  @$pb.TagNumber(23)
  $core.String get swapFailed => $_getSZ(18);
  @$pb.TagNumber(23)
  set swapFailed($core.String v) { $_setString(18, v); }
  @$pb.TagNumber(23)
  $core.bool hasSwapFailed() => $_has(18);
  @$pb.TagNumber(23)
  void clearSwapFailed() => clearField(23);

  @$pb.TagNumber(24)
  From_PegOutAmount get pegOutAmount => $_getN(19);
  @$pb.TagNumber(24)
  set pegOutAmount(From_PegOutAmount v) { setField(24, v); }
  @$pb.TagNumber(24)
  $core.bool hasPegOutAmount() => $_has(19);
  @$pb.TagNumber(24)
  void clearPegOutAmount() => clearField(24);
  @$pb.TagNumber(24)
  From_PegOutAmount ensurePegOutAmount() => $_ensure(19);

  @$pb.TagNumber(30)
  From_RecvAddress get recvAddress => $_getN(20);
  @$pb.TagNumber(30)
  set recvAddress(From_RecvAddress v) { setField(30, v); }
  @$pb.TagNumber(30)
  $core.bool hasRecvAddress() => $_has(20);
  @$pb.TagNumber(30)
  void clearRecvAddress() => clearField(30);
  @$pb.TagNumber(30)
  From_RecvAddress ensureRecvAddress() => $_ensure(20);

  @$pb.TagNumber(31)
  From_CreateTxResult get createTxResult => $_getN(21);
  @$pb.TagNumber(31)
  set createTxResult(From_CreateTxResult v) { setField(31, v); }
  @$pb.TagNumber(31)
  $core.bool hasCreateTxResult() => $_has(21);
  @$pb.TagNumber(31)
  void clearCreateTxResult() => clearField(31);
  @$pb.TagNumber(31)
  From_CreateTxResult ensureCreateTxResult() => $_ensure(21);

  @$pb.TagNumber(32)
  From_SendResult get sendResult => $_getN(22);
  @$pb.TagNumber(32)
  set sendResult(From_SendResult v) { setField(32, v); }
  @$pb.TagNumber(32)
  $core.bool hasSendResult() => $_has(22);
  @$pb.TagNumber(32)
  void clearSendResult() => clearField(32);
  @$pb.TagNumber(32)
  From_SendResult ensureSendResult() => $_ensure(22);

  @$pb.TagNumber(33)
  From_BlindedValues get blindedValues => $_getN(23);
  @$pb.TagNumber(33)
  set blindedValues(From_BlindedValues v) { setField(33, v); }
  @$pb.TagNumber(33)
  $core.bool hasBlindedValues() => $_has(23);
  @$pb.TagNumber(33)
  void clearBlindedValues() => clearField(33);
  @$pb.TagNumber(33)
  From_BlindedValues ensureBlindedValues() => $_ensure(23);

  @$pb.TagNumber(35)
  From_LoadUtxos get loadUtxos => $_getN(24);
  @$pb.TagNumber(35)
  set loadUtxos(From_LoadUtxos v) { setField(35, v); }
  @$pb.TagNumber(35)
  $core.bool hasLoadUtxos() => $_has(24);
  @$pb.TagNumber(35)
  void clearLoadUtxos() => clearField(35);
  @$pb.TagNumber(35)
  From_LoadUtxos ensureLoadUtxos() => $_ensure(24);

  @$pb.TagNumber(36)
  From_LoadAddresses get loadAddresses => $_getN(25);
  @$pb.TagNumber(36)
  set loadAddresses(From_LoadAddresses v) { setField(36, v); }
  @$pb.TagNumber(36)
  $core.bool hasLoadAddresses() => $_has(25);
  @$pb.TagNumber(36)
  void clearLoadAddresses() => clearField(36);
  @$pb.TagNumber(36)
  From_LoadAddresses ensureLoadAddresses() => $_ensure(25);

  @$pb.TagNumber(50)
  From_ShowMessage get showMessage => $_getN(26);
  @$pb.TagNumber(50)
  set showMessage(From_ShowMessage v) { setField(50, v); }
  @$pb.TagNumber(50)
  $core.bool hasShowMessage() => $_has(26);
  @$pb.TagNumber(50)
  void clearShowMessage() => clearField(50);
  @$pb.TagNumber(50)
  From_ShowMessage ensureShowMessage() => $_ensure(26);

  @$pb.TagNumber(55)
  From_ShowInsufficientFunds get insufficientFunds => $_getN(27);
  @$pb.TagNumber(55)
  set insufficientFunds(From_ShowInsufficientFunds v) { setField(55, v); }
  @$pb.TagNumber(55)
  $core.bool hasInsufficientFunds() => $_has(27);
  @$pb.TagNumber(55)
  void clearInsufficientFunds() => clearField(55);
  @$pb.TagNumber(55)
  From_ShowInsufficientFunds ensureInsufficientFunds() => $_ensure(27);

  @$pb.TagNumber(60)
  Empty get serverConnected => $_getN(28);
  @$pb.TagNumber(60)
  set serverConnected(Empty v) { setField(60, v); }
  @$pb.TagNumber(60)
  $core.bool hasServerConnected() => $_has(28);
  @$pb.TagNumber(60)
  void clearServerConnected() => clearField(60);
  @$pb.TagNumber(60)
  Empty ensureServerConnected() => $_ensure(28);

  @$pb.TagNumber(61)
  Empty get serverDisconnected => $_getN(29);
  @$pb.TagNumber(61)
  set serverDisconnected(Empty v) { setField(61, v); }
  @$pb.TagNumber(61)
  $core.bool hasServerDisconnected() => $_has(29);
  @$pb.TagNumber(61)
  void clearServerDisconnected() => clearField(61);
  @$pb.TagNumber(61)
  Empty ensureServerDisconnected() => $_ensure(29);

  @$pb.TagNumber(65)
  From_AssetDetails get assetDetails => $_getN(30);
  @$pb.TagNumber(65)
  set assetDetails(From_AssetDetails v) { setField(65, v); }
  @$pb.TagNumber(65)
  $core.bool hasAssetDetails() => $_has(30);
  @$pb.TagNumber(65)
  void clearAssetDetails() => clearField(65);
  @$pb.TagNumber(65)
  From_AssetDetails ensureAssetDetails() => $_ensure(30);

  @$pb.TagNumber(66)
  From_UpdatePriceStream get updatePriceStream => $_getN(31);
  @$pb.TagNumber(66)
  set updatePriceStream(From_UpdatePriceStream v) { setField(66, v); }
  @$pb.TagNumber(66)
  $core.bool hasUpdatePriceStream() => $_has(31);
  @$pb.TagNumber(66)
  void clearUpdatePriceStream() => clearField(66);
  @$pb.TagNumber(66)
  From_UpdatePriceStream ensureUpdatePriceStream() => $_ensure(31);

  @$pb.TagNumber(68)
  From_LocalMessage get localMessage => $_getN(32);
  @$pb.TagNumber(68)
  set localMessage(From_LocalMessage v) { setField(68, v); }
  @$pb.TagNumber(68)
  $core.bool hasLocalMessage() => $_has(32);
  @$pb.TagNumber(68)
  void clearLocalMessage() => clearField(68);
  @$pb.TagNumber(68)
  From_LocalMessage ensureLocalMessage() => $_ensure(32);

  @$pb.TagNumber(72)
  From_PortfolioPrices get portfolioPrices => $_getN(33);
  @$pb.TagNumber(72)
  set portfolioPrices(From_PortfolioPrices v) { setField(72, v); }
  @$pb.TagNumber(72)
  $core.bool hasPortfolioPrices() => $_has(33);
  @$pb.TagNumber(72)
  void clearPortfolioPrices() => clearField(72);
  @$pb.TagNumber(72)
  From_PortfolioPrices ensurePortfolioPrices() => $_ensure(33);

  @$pb.TagNumber(73)
  From_ConversionRates get conversionRates => $_getN(34);
  @$pb.TagNumber(73)
  set conversionRates(From_ConversionRates v) { setField(73, v); }
  @$pb.TagNumber(73)
  $core.bool hasConversionRates() => $_has(34);
  @$pb.TagNumber(73)
  void clearConversionRates() => clearField(73);
  @$pb.TagNumber(73)
  From_ConversionRates ensureConversionRates() => $_ensure(34);

  @$pb.TagNumber(80)
  From_JadePorts get jadePorts => $_getN(35);
  @$pb.TagNumber(80)
  set jadePorts(From_JadePorts v) { setField(80, v); }
  @$pb.TagNumber(80)
  $core.bool hasJadePorts() => $_has(35);
  @$pb.TagNumber(80)
  void clearJadePorts() => clearField(80);
  @$pb.TagNumber(80)
  From_JadePorts ensureJadePorts() => $_ensure(35);

  @$pb.TagNumber(83)
  From_JadeStatus get jadeStatus => $_getN(36);
  @$pb.TagNumber(83)
  set jadeStatus(From_JadeStatus v) { setField(83, v); }
  @$pb.TagNumber(83)
  $core.bool hasJadeStatus() => $_has(36);
  @$pb.TagNumber(83)
  void clearJadeStatus() => clearField(83);
  @$pb.TagNumber(83)
  From_JadeStatus ensureJadeStatus() => $_ensure(36);

  @$pb.TagNumber(91)
  From_GaidStatus get gaidStatus => $_getN(37);
  @$pb.TagNumber(91)
  set gaidStatus(From_GaidStatus v) { setField(91, v); }
  @$pb.TagNumber(91)
  $core.bool hasGaidStatus() => $_has(37);
  @$pb.TagNumber(91)
  void clearGaidStatus() => clearField(91);
  @$pb.TagNumber(91)
  From_GaidStatus ensureGaidStatus() => $_ensure(37);

  @$pb.TagNumber(100)
  From_MarketList get marketList => $_getN(38);
  @$pb.TagNumber(100)
  set marketList(From_MarketList v) { setField(100, v); }
  @$pb.TagNumber(100)
  $core.bool hasMarketList() => $_has(38);
  @$pb.TagNumber(100)
  void clearMarketList() => clearField(100);
  @$pb.TagNumber(100)
  From_MarketList ensureMarketList() => $_ensure(38);

  @$pb.TagNumber(101)
  MarketInfo get marketAdded => $_getN(39);
  @$pb.TagNumber(101)
  set marketAdded(MarketInfo v) { setField(101, v); }
  @$pb.TagNumber(101)
  $core.bool hasMarketAdded() => $_has(39);
  @$pb.TagNumber(101)
  void clearMarketAdded() => clearField(101);
  @$pb.TagNumber(101)
  MarketInfo ensureMarketAdded() => $_ensure(39);

  @$pb.TagNumber(102)
  AssetPair get marketRemoved => $_getN(40);
  @$pb.TagNumber(102)
  set marketRemoved(AssetPair v) { setField(102, v); }
  @$pb.TagNumber(102)
  $core.bool hasMarketRemoved() => $_has(40);
  @$pb.TagNumber(102)
  void clearMarketRemoved() => clearField(102);
  @$pb.TagNumber(102)
  AssetPair ensureMarketRemoved() => $_ensure(40);

  @$pb.TagNumber(105)
  From_PublicOrders get publicOrders => $_getN(41);
  @$pb.TagNumber(105)
  set publicOrders(From_PublicOrders v) { setField(105, v); }
  @$pb.TagNumber(105)
  $core.bool hasPublicOrders() => $_has(41);
  @$pb.TagNumber(105)
  void clearPublicOrders() => clearField(105);
  @$pb.TagNumber(105)
  From_PublicOrders ensurePublicOrders() => $_ensure(41);

  @$pb.TagNumber(106)
  PublicOrder get publicOrderCreated => $_getN(42);
  @$pb.TagNumber(106)
  set publicOrderCreated(PublicOrder v) { setField(106, v); }
  @$pb.TagNumber(106)
  $core.bool hasPublicOrderCreated() => $_has(42);
  @$pb.TagNumber(106)
  void clearPublicOrderCreated() => clearField(106);
  @$pb.TagNumber(106)
  PublicOrder ensurePublicOrderCreated() => $_ensure(42);

  @$pb.TagNumber(107)
  OrderId get publicOrderRemoved => $_getN(43);
  @$pb.TagNumber(107)
  set publicOrderRemoved(OrderId v) { setField(107, v); }
  @$pb.TagNumber(107)
  $core.bool hasPublicOrderRemoved() => $_has(43);
  @$pb.TagNumber(107)
  void clearPublicOrderRemoved() => clearField(107);
  @$pb.TagNumber(107)
  OrderId ensurePublicOrderRemoved() => $_ensure(43);

  @$pb.TagNumber(110)
  From_MarketPrice get marketPrice => $_getN(44);
  @$pb.TagNumber(110)
  set marketPrice(From_MarketPrice v) { setField(110, v); }
  @$pb.TagNumber(110)
  $core.bool hasMarketPrice() => $_has(44);
  @$pb.TagNumber(110)
  void clearMarketPrice() => clearField(110);
  @$pb.TagNumber(110)
  From_MarketPrice ensureMarketPrice() => $_ensure(44);

  @$pb.TagNumber(120)
  From_OwnOrders get ownOrders => $_getN(45);
  @$pb.TagNumber(120)
  set ownOrders(From_OwnOrders v) { setField(120, v); }
  @$pb.TagNumber(120)
  $core.bool hasOwnOrders() => $_has(45);
  @$pb.TagNumber(120)
  void clearOwnOrders() => clearField(120);
  @$pb.TagNumber(120)
  From_OwnOrders ensureOwnOrders() => $_ensure(45);

  @$pb.TagNumber(121)
  OwnOrder get ownOrderCreated => $_getN(46);
  @$pb.TagNumber(121)
  set ownOrderCreated(OwnOrder v) { setField(121, v); }
  @$pb.TagNumber(121)
  $core.bool hasOwnOrderCreated() => $_has(46);
  @$pb.TagNumber(121)
  void clearOwnOrderCreated() => clearField(121);
  @$pb.TagNumber(121)
  OwnOrder ensureOwnOrderCreated() => $_ensure(46);

  @$pb.TagNumber(122)
  OrderId get ownOrderRemoved => $_getN(47);
  @$pb.TagNumber(122)
  set ownOrderRemoved(OrderId v) { setField(122, v); }
  @$pb.TagNumber(122)
  $core.bool hasOwnOrderRemoved() => $_has(47);
  @$pb.TagNumber(122)
  void clearOwnOrderRemoved() => clearField(122);
  @$pb.TagNumber(122)
  OrderId ensureOwnOrderRemoved() => $_ensure(47);

  @$pb.TagNumber(130)
  From_OrderSubmit get orderSubmit => $_getN(48);
  @$pb.TagNumber(130)
  set orderSubmit(From_OrderSubmit v) { setField(130, v); }
  @$pb.TagNumber(130)
  $core.bool hasOrderSubmit() => $_has(48);
  @$pb.TagNumber(130)
  void clearOrderSubmit() => clearField(130);
  @$pb.TagNumber(130)
  From_OrderSubmit ensureOrderSubmit() => $_ensure(48);

  @$pb.TagNumber(131)
  GenericResponse get orderEdit => $_getN(49);
  @$pb.TagNumber(131)
  set orderEdit(GenericResponse v) { setField(131, v); }
  @$pb.TagNumber(131)
  $core.bool hasOrderEdit() => $_has(49);
  @$pb.TagNumber(131)
  void clearOrderEdit() => clearField(131);
  @$pb.TagNumber(131)
  GenericResponse ensureOrderEdit() => $_ensure(49);

  @$pb.TagNumber(132)
  GenericResponse get orderCancel => $_getN(50);
  @$pb.TagNumber(132)
  set orderCancel(GenericResponse v) { setField(132, v); }
  @$pb.TagNumber(132)
  $core.bool hasOrderCancel() => $_has(50);
  @$pb.TagNumber(132)
  void clearOrderCancel() => clearField(132);
  @$pb.TagNumber(132)
  GenericResponse ensureOrderCancel() => $_ensure(50);

  @$pb.TagNumber(140)
  From_Quote get quote => $_getN(51);
  @$pb.TagNumber(140)
  set quote(From_Quote v) { setField(140, v); }
  @$pb.TagNumber(140)
  $core.bool hasQuote() => $_has(51);
  @$pb.TagNumber(140)
  void clearQuote() => clearField(140);
  @$pb.TagNumber(140)
  From_Quote ensureQuote() => $_ensure(51);

  @$pb.TagNumber(141)
  From_AcceptQuote get acceptQuote => $_getN(52);
  @$pb.TagNumber(141)
  set acceptQuote(From_AcceptQuote v) { setField(141, v); }
  @$pb.TagNumber(141)
  $core.bool hasAcceptQuote() => $_has(52);
  @$pb.TagNumber(141)
  void clearAcceptQuote() => clearField(141);
  @$pb.TagNumber(141)
  From_AcceptQuote ensureAcceptQuote() => $_ensure(52);

  @$pb.TagNumber(142)
  GenericResponse get startOrder => $_getN(53);
  @$pb.TagNumber(142)
  set startOrder(GenericResponse v) { setField(142, v); }
  @$pb.TagNumber(142)
  $core.bool hasStartOrder() => $_has(53);
  @$pb.TagNumber(142)
  void clearStartOrder() => clearField(142);
  @$pb.TagNumber(142)
  GenericResponse ensureStartOrder() => $_ensure(53);

  @$pb.TagNumber(150)
  From_ChartsSubscribe get chartsSubscribe => $_getN(54);
  @$pb.TagNumber(150)
  set chartsSubscribe(From_ChartsSubscribe v) { setField(150, v); }
  @$pb.TagNumber(150)
  $core.bool hasChartsSubscribe() => $_has(54);
  @$pb.TagNumber(150)
  void clearChartsSubscribe() => clearField(150);
  @$pb.TagNumber(150)
  From_ChartsSubscribe ensureChartsSubscribe() => $_ensure(54);

  @$pb.TagNumber(151)
  From_ChartsUpdate get chartsUpdate => $_getN(55);
  @$pb.TagNumber(151)
  set chartsUpdate(From_ChartsUpdate v) { setField(151, v); }
  @$pb.TagNumber(151)
  $core.bool hasChartsUpdate() => $_has(55);
  @$pb.TagNumber(151)
  void clearChartsUpdate() => clearField(151);
  @$pb.TagNumber(151)
  From_ChartsUpdate ensureChartsUpdate() => $_ensure(55);

  @$pb.TagNumber(160)
  From_LoadHistory get loadHistory => $_getN(56);
  @$pb.TagNumber(160)
  set loadHistory(From_LoadHistory v) { setField(160, v); }
  @$pb.TagNumber(160)
  $core.bool hasLoadHistory() => $_has(56);
  @$pb.TagNumber(160)
  void clearLoadHistory() => clearField(160);
  @$pb.TagNumber(160)
  From_LoadHistory ensureLoadHistory() => $_ensure(56);

  @$pb.TagNumber(161)
  From_HistoryUpdated get historyUpdated => $_getN(57);
  @$pb.TagNumber(161)
  set historyUpdated(From_HistoryUpdated v) { setField(161, v); }
  @$pb.TagNumber(161)
  $core.bool hasHistoryUpdated() => $_has(57);
  @$pb.TagNumber(161)
  void clearHistoryUpdated() => clearField(161);
  @$pb.TagNumber(161)
  From_HistoryUpdated ensureHistoryUpdated() => $_ensure(57);
}

class Settings_AccountAsset extends $pb.GeneratedMessage {
  factory Settings_AccountAsset({
    Account? account,
    $core.String? assetId,
  }) {
    final $result = create();
    if (account != null) {
      $result.account = account;
    }
    if (assetId != null) {
      $result.assetId = assetId;
    }
    return $result;
  }
  Settings_AccountAsset._() : super();
  factory Settings_AccountAsset.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Settings_AccountAsset.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Settings.AccountAsset', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQM<Account>(1, _omitFieldNames ? '' : 'account', subBuilder: Account.create)
    ..aQS(2, _omitFieldNames ? '' : 'assetId')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Settings_AccountAsset clone() => Settings_AccountAsset()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Settings_AccountAsset copyWith(void Function(Settings_AccountAsset) updates) => super.copyWith((message) => updates(message as Settings_AccountAsset)) as Settings_AccountAsset;

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
  factory Settings({
    $core.Iterable<Settings_AccountAsset>? disabledAccounts,
  }) {
    final $result = create();
    if (disabledAccounts != null) {
      $result.disabledAccounts.addAll(disabledAccounts);
    }
    return $result;
  }
  Settings._() : super();
  factory Settings.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Settings.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Settings', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..pc<Settings_AccountAsset>(1, _omitFieldNames ? '' : 'disabledAccounts', $pb.PbFieldType.PM, subBuilder: Settings_AccountAsset.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Settings clone() => Settings()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Settings copyWith(void Function(Settings) updates) => super.copyWith((message) => updates(message as Settings)) as Settings;

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


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
