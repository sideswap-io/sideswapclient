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
    $core.bool? isGreedy,
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
    if (isGreedy != null) {
      $result.isGreedy = isGreedy;
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
    ..aOB(4, _omitFieldNames ? '' : 'isGreedy')
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

  @$pb.TagNumber(4)
  $core.bool get isGreedy => $_getBF(3);
  @$pb.TagNumber(4)
  set isGreedy($core.bool v) { $_setBool(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasIsGreedy() => $_has(3);
  @$pb.TagNumber(4)
  void clearIsGreedy() => clearField(4);
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
}

class Tx extends $pb.GeneratedMessage {
  factory Tx({
    $core.Iterable<Balance>? balances,
    $core.String? txid,
    $fixnum.Int64? networkFee,
    $core.String? memo,
    $fixnum.Int64? size,
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
    if (size != null) {
      $result.size = size;
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
    ..a<$fixnum.Int64>(5, _omitFieldNames ? '' : 'size', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
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

  @$pb.TagNumber(7)
  $core.List<Balance> get balancesAll => $_getList(6);
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

class UploadContact extends $pb.GeneratedMessage {
  factory UploadContact({
    $core.String? identifier,
    $core.String? name,
    $core.Iterable<$core.String>? phones,
  }) {
    final $result = create();
    if (identifier != null) {
      $result.identifier = identifier;
    }
    if (name != null) {
      $result.name = name;
    }
    if (phones != null) {
      $result.phones.addAll(phones);
    }
    return $result;
  }
  UploadContact._() : super();
  factory UploadContact.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UploadContact.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UploadContact', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'identifier')
    ..aQS(2, _omitFieldNames ? '' : 'name')
    ..pPS(3, _omitFieldNames ? '' : 'phones')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UploadContact clone() => UploadContact()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UploadContact copyWith(void Function(UploadContact) updates) => super.copyWith((message) => updates(message as UploadContact)) as UploadContact;

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
  factory Contact({
    $core.String? contactKey,
    $core.String? name,
    $core.String? phone,
  }) {
    final $result = create();
    if (contactKey != null) {
      $result.contactKey = contactKey;
    }
    if (name != null) {
      $result.name = name;
    }
    if (phone != null) {
      $result.phone = phone;
    }
    return $result;
  }
  Contact._() : super();
  factory Contact.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Contact.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Contact', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'contactKey')
    ..aQS(2, _omitFieldNames ? '' : 'name')
    ..aQS(3, _omitFieldNames ? '' : 'phone')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Contact clone() => Contact()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Contact copyWith(void Function(Contact) updates) => super.copyWith((message) => updates(message as Contact)) as Contact;

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
  factory ContactTransaction({
    $core.String? txid,
    $core.String? contactKey,
  }) {
    final $result = create();
    if (txid != null) {
      $result.txid = txid;
    }
    if (contactKey != null) {
      $result.contactKey = contactKey;
    }
    return $result;
  }
  ContactTransaction._() : super();
  factory ContactTransaction.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ContactTransaction.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ContactTransaction', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'txid')
    ..aQS(2, _omitFieldNames ? '' : 'contactKey')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ContactTransaction clone() => ContactTransaction()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ContactTransaction copyWith(void Function(ContactTransaction) updates) => super.copyWith((message) => updates(message as ContactTransaction)) as ContactTransaction;

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
    $core.bool? twoStep,
  }) {
    final $result = create();
    if (orderId != null) {
      $result.orderId = orderId;
    }
    if (assetId != null) {
      $result.assetId = assetId;
    }
    if (bitcoinAmount != null) {
      $result.bitcoinAmount = bitcoinAmount;
    }
    if (serverFee != null) {
      $result.serverFee = serverFee;
    }
    if (assetAmount != null) {
      $result.assetAmount = assetAmount;
    }
    if (price != null) {
      $result.price = price;
    }
    if (createdAt != null) {
      $result.createdAt = createdAt;
    }
    if (expiresAt != null) {
      $result.expiresAt = expiresAt;
    }
    if (private != null) {
      $result.private = private;
    }
    if (sendBitcoins != null) {
      $result.sendBitcoins = sendBitcoins;
    }
    if (autoSign != null) {
      $result.autoSign = autoSign;
    }
    if (own != null) {
      $result.own = own;
    }
    if (fromNotification != null) {
      $result.fromNotification = fromNotification;
    }
    if (indexPrice != null) {
      $result.indexPrice = indexPrice;
    }
    if (tokenMarket != null) {
      $result.tokenMarket = tokenMarket;
    }
    if (twoStep != null) {
      $result.twoStep = twoStep;
    }
    return $result;
  }
  Order._() : super();
  factory Order.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Order.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Order', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'orderId')
    ..aQS(2, _omitFieldNames ? '' : 'assetId')
    ..a<$fixnum.Int64>(3, _omitFieldNames ? '' : 'bitcoinAmount', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(4, _omitFieldNames ? '' : 'serverFee', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(5, _omitFieldNames ? '' : 'assetAmount', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'price', $pb.PbFieldType.QD)
    ..a<$fixnum.Int64>(7, _omitFieldNames ? '' : 'createdAt', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aInt64(8, _omitFieldNames ? '' : 'expiresAt')
    ..a<$core.bool>(9, _omitFieldNames ? '' : 'private', $pb.PbFieldType.QB)
    ..a<$core.bool>(10, _omitFieldNames ? '' : 'sendBitcoins', $pb.PbFieldType.QB)
    ..a<$core.bool>(11, _omitFieldNames ? '' : 'autoSign', $pb.PbFieldType.QB)
    ..a<$core.bool>(12, _omitFieldNames ? '' : 'own', $pb.PbFieldType.QB)
    ..a<$core.bool>(13, _omitFieldNames ? '' : 'fromNotification', $pb.PbFieldType.QB)
    ..a<$core.double>(15, _omitFieldNames ? '' : 'indexPrice', $pb.PbFieldType.OD)
    ..a<$core.bool>(16, _omitFieldNames ? '' : 'tokenMarket', $pb.PbFieldType.QB)
    ..a<$core.bool>(17, _omitFieldNames ? '' : 'twoStep', $pb.PbFieldType.QB)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Order clone() => Order()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Order copyWith(void Function(Order) updates) => super.copyWith((message) => updates(message as Order)) as Order;

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

  @$pb.TagNumber(17)
  $core.bool get twoStep => $_getBF(15);
  @$pb.TagNumber(17)
  set twoStep($core.bool v) { $_setBool(15, v); }
  @$pb.TagNumber(17)
  $core.bool hasTwoStep() => $_has(15);
  @$pb.TagNumber(17)
  void clearTwoStep() => clearField(17);
}

class SwapDetails extends $pb.GeneratedMessage {
  factory SwapDetails({
    $core.String? orderId,
    $core.String? sendAsset,
    $core.String? recvAsset,
    $fixnum.Int64? sendAmount,
    $fixnum.Int64? recvAmount,
    $core.String? uploadUrl,
  }) {
    final $result = create();
    if (orderId != null) {
      $result.orderId = orderId;
    }
    if (sendAsset != null) {
      $result.sendAsset = sendAsset;
    }
    if (recvAsset != null) {
      $result.recvAsset = recvAsset;
    }
    if (sendAmount != null) {
      $result.sendAmount = sendAmount;
    }
    if (recvAmount != null) {
      $result.recvAmount = recvAmount;
    }
    if (uploadUrl != null) {
      $result.uploadUrl = uploadUrl;
    }
    return $result;
  }
  SwapDetails._() : super();
  factory SwapDetails.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SwapDetails.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SwapDetails', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'orderId')
    ..aQS(2, _omitFieldNames ? '' : 'sendAsset')
    ..aQS(3, _omitFieldNames ? '' : 'recvAsset')
    ..a<$fixnum.Int64>(4, _omitFieldNames ? '' : 'sendAmount', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(5, _omitFieldNames ? '' : 'recvAmount', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aQS(6, _omitFieldNames ? '' : 'uploadUrl')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SwapDetails clone() => SwapDetails()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SwapDetails copyWith(void Function(SwapDetails) updates) => super.copyWith((message) => updates(message as SwapDetails)) as SwapDetails;

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
    return $result;
  }
  CreateTx._() : super();
  factory CreateTx.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateTx.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CreateTx', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..pc<AddressAmount>(1, _omitFieldNames ? '' : 'addressees', $pb.PbFieldType.PM, subBuilder: AddressAmount.create)
    ..aQM<Account>(2, _omitFieldNames ? '' : 'account', subBuilder: Account.create)
    ..pc<OutPoint>(3, _omitFieldNames ? '' : 'utxos', $pb.PbFieldType.PM, subBuilder: OutPoint.create)
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
}

class CreatePayjoin extends $pb.GeneratedMessage {
  factory CreatePayjoin({
    Account? account,
    $core.String? addr,
    Balance? balance,
  }) {
    final $result = create();
    if (account != null) {
      $result.account = account;
    }
    if (addr != null) {
      $result.addr = addr;
    }
    if (balance != null) {
      $result.balance = balance;
    }
    return $result;
  }
  CreatePayjoin._() : super();
  factory CreatePayjoin.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreatePayjoin.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CreatePayjoin', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQM<Account>(1, _omitFieldNames ? '' : 'account', subBuilder: Account.create)
    ..aQS(2, _omitFieldNames ? '' : 'addr')
    ..aQM<Balance>(3, _omitFieldNames ? '' : 'balance', subBuilder: Balance.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreatePayjoin clone() => CreatePayjoin()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreatePayjoin copyWith(void Function(CreatePayjoin) updates) => super.copyWith((message) => updates(message as CreatePayjoin)) as CreatePayjoin;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreatePayjoin create() => CreatePayjoin._();
  CreatePayjoin createEmptyInstance() => create();
  static $pb.PbList<CreatePayjoin> createRepeated() => $pb.PbList<CreatePayjoin>();
  @$core.pragma('dart2js:noInline')
  static CreatePayjoin getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreatePayjoin>(create);
  static CreatePayjoin? _defaultInstance;

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
  $core.String get addr => $_getSZ(1);
  @$pb.TagNumber(2)
  set addr($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAddr() => $_has(1);
  @$pb.TagNumber(2)
  void clearAddr() => clearField(2);

  @$pb.TagNumber(3)
  Balance get balance => $_getN(2);
  @$pb.TagNumber(3)
  set balance(Balance v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasBalance() => $_has(2);
  @$pb.TagNumber(3)
  void clearBalance() => clearField(3);
  @$pb.TagNumber(3)
  Balance ensureBalance() => $_ensure(2);
}

class CreatedPayjoin extends $pb.GeneratedMessage {
  factory CreatedPayjoin({
    CreatePayjoin? req,
    $core.String? pset,
    $fixnum.Int64? assetFee,
  }) {
    final $result = create();
    if (req != null) {
      $result.req = req;
    }
    if (pset != null) {
      $result.pset = pset;
    }
    if (assetFee != null) {
      $result.assetFee = assetFee;
    }
    return $result;
  }
  CreatedPayjoin._() : super();
  factory CreatedPayjoin.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreatedPayjoin.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CreatedPayjoin', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQM<CreatePayjoin>(1, _omitFieldNames ? '' : 'req', subBuilder: CreatePayjoin.create)
    ..aQS(2, _omitFieldNames ? '' : 'pset')
    ..a<$fixnum.Int64>(3, _omitFieldNames ? '' : 'assetFee', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreatedPayjoin clone() => CreatedPayjoin()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreatedPayjoin copyWith(void Function(CreatedPayjoin) updates) => super.copyWith((message) => updates(message as CreatedPayjoin)) as CreatedPayjoin;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreatedPayjoin create() => CreatedPayjoin._();
  CreatedPayjoin createEmptyInstance() => create();
  static $pb.PbList<CreatedPayjoin> createRepeated() => $pb.PbList<CreatedPayjoin>();
  @$core.pragma('dart2js:noInline')
  static CreatedPayjoin getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreatedPayjoin>(create);
  static CreatedPayjoin? _defaultInstance;

  @$pb.TagNumber(1)
  CreatePayjoin get req => $_getN(0);
  @$pb.TagNumber(1)
  set req(CreatePayjoin v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasReq() => $_has(0);
  @$pb.TagNumber(1)
  void clearReq() => clearField(1);
  @$pb.TagNumber(1)
  CreatePayjoin ensureReq() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get pset => $_getSZ(1);
  @$pb.TagNumber(2)
  set pset($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPset() => $_has(1);
  @$pb.TagNumber(2)
  void clearPset() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get assetFee => $_getI64(2);
  @$pb.TagNumber(3)
  set assetFee($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAssetFee() => $_has(2);
  @$pb.TagNumber(3)
  void clearAssetFee() => clearField(3);
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

enum To_Login_Wallet {
  mnemonic, 
  jadeId, 
  notSet
}

class To_Login extends $pb.GeneratedMessage {
  factory To_Login({
    $core.String? mnemonic,
    $core.String? phoneKey,
    $core.bool? sendUtxoUpdates,
    $core.String? jadeId,
    $core.bool? forceAutoSignMaker,
  }) {
    final $result = create();
    if (mnemonic != null) {
      $result.mnemonic = mnemonic;
    }
    if (phoneKey != null) {
      $result.phoneKey = phoneKey;
    }
    if (sendUtxoUpdates != null) {
      $result.sendUtxoUpdates = sendUtxoUpdates;
    }
    if (jadeId != null) {
      $result.jadeId = jadeId;
    }
    if (forceAutoSignMaker != null) {
      $result.forceAutoSignMaker = forceAutoSignMaker;
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
    ..aOB(6, _omitFieldNames ? '' : 'sendUtxoUpdates')
    ..aOS(7, _omitFieldNames ? '' : 'jadeId')
    ..aOB(8, _omitFieldNames ? '' : 'forceAutoSignMaker')
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

  @$pb.TagNumber(6)
  $core.bool get sendUtxoUpdates => $_getBF(2);
  @$pb.TagNumber(6)
  set sendUtxoUpdates($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(6)
  $core.bool hasSendUtxoUpdates() => $_has(2);
  @$pb.TagNumber(6)
  void clearSendUtxoUpdates() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get jadeId => $_getSZ(3);
  @$pb.TagNumber(7)
  set jadeId($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(7)
  $core.bool hasJadeId() => $_has(3);
  @$pb.TagNumber(7)
  void clearJadeId() => clearField(7);

  @$pb.TagNumber(8)
  $core.bool get forceAutoSignMaker => $_getBF(4);
  @$pb.TagNumber(8)
  set forceAutoSignMaker($core.bool v) { $_setBool(4, v); }
  @$pb.TagNumber(8)
  $core.bool hasForceAutoSignMaker() => $_has(4);
  @$pb.TagNumber(8)
  void clearForceAutoSignMaker() => clearField(8);
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
  }) {
    final $result = create();
    if (account != null) {
      $result.account = account;
    }
    return $result;
  }
  To_SendTx._() : super();
  factory To_SendTx.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory To_SendTx.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'To.SendTx', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQM<Account>(1, _omitFieldNames ? '' : 'account', subBuilder: Account.create)
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

class To_RegisterPhone extends $pb.GeneratedMessage {
  factory To_RegisterPhone({
    $core.String? number,
  }) {
    final $result = create();
    if (number != null) {
      $result.number = number;
    }
    return $result;
  }
  To_RegisterPhone._() : super();
  factory To_RegisterPhone.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory To_RegisterPhone.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'To.RegisterPhone', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'number')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  To_RegisterPhone clone() => To_RegisterPhone()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  To_RegisterPhone copyWith(void Function(To_RegisterPhone) updates) => super.copyWith((message) => updates(message as To_RegisterPhone)) as To_RegisterPhone;

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
  factory To_VerifyPhone({
    $core.String? phoneKey,
    $core.String? code,
  }) {
    final $result = create();
    if (phoneKey != null) {
      $result.phoneKey = phoneKey;
    }
    if (code != null) {
      $result.code = code;
    }
    return $result;
  }
  To_VerifyPhone._() : super();
  factory To_VerifyPhone.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory To_VerifyPhone.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'To.VerifyPhone', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'phoneKey')
    ..aQS(2, _omitFieldNames ? '' : 'code')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  To_VerifyPhone clone() => To_VerifyPhone()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  To_VerifyPhone copyWith(void Function(To_VerifyPhone) updates) => super.copyWith((message) => updates(message as To_VerifyPhone)) as To_VerifyPhone;

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
  factory To_UnregisterPhone({
    $core.String? phoneKey,
  }) {
    final $result = create();
    if (phoneKey != null) {
      $result.phoneKey = phoneKey;
    }
    return $result;
  }
  To_UnregisterPhone._() : super();
  factory To_UnregisterPhone.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory To_UnregisterPhone.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'To.UnregisterPhone', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'phoneKey')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  To_UnregisterPhone clone() => To_UnregisterPhone()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  To_UnregisterPhone copyWith(void Function(To_UnregisterPhone) updates) => super.copyWith((message) => updates(message as To_UnregisterPhone)) as To_UnregisterPhone;

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
  factory To_UploadAvatar({
    $core.String? phoneKey,
    $core.String? image,
  }) {
    final $result = create();
    if (phoneKey != null) {
      $result.phoneKey = phoneKey;
    }
    if (image != null) {
      $result.image = image;
    }
    return $result;
  }
  To_UploadAvatar._() : super();
  factory To_UploadAvatar.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory To_UploadAvatar.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'To.UploadAvatar', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'phoneKey')
    ..aQS(2, _omitFieldNames ? '' : 'image')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  To_UploadAvatar clone() => To_UploadAvatar()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  To_UploadAvatar copyWith(void Function(To_UploadAvatar) updates) => super.copyWith((message) => updates(message as To_UploadAvatar)) as To_UploadAvatar;

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
  factory To_UploadContacts({
    $core.String? phoneKey,
    $core.Iterable<UploadContact>? contacts,
  }) {
    final $result = create();
    if (phoneKey != null) {
      $result.phoneKey = phoneKey;
    }
    if (contacts != null) {
      $result.contacts.addAll(contacts);
    }
    return $result;
  }
  To_UploadContacts._() : super();
  factory To_UploadContacts.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory To_UploadContacts.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'To.UploadContacts', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'phoneKey')
    ..pc<UploadContact>(2, _omitFieldNames ? '' : 'contacts', $pb.PbFieldType.PM, subBuilder: UploadContact.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  To_UploadContacts clone() => To_UploadContacts()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  To_UploadContacts copyWith(void Function(To_UploadContacts) updates) => super.copyWith((message) => updates(message as To_UploadContacts)) as To_UploadContacts;

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
  factory To_SubmitOrder({
    $core.String? assetId,
    $core.double? bitcoinAmount,
    $core.double? assetAmount,
    $core.double? price,
    $core.double? indexPrice,
    Account? account,
  }) {
    final $result = create();
    if (assetId != null) {
      $result.assetId = assetId;
    }
    if (bitcoinAmount != null) {
      $result.bitcoinAmount = bitcoinAmount;
    }
    if (assetAmount != null) {
      $result.assetAmount = assetAmount;
    }
    if (price != null) {
      $result.price = price;
    }
    if (indexPrice != null) {
      $result.indexPrice = indexPrice;
    }
    if (account != null) {
      $result.account = account;
    }
    return $result;
  }
  To_SubmitOrder._() : super();
  factory To_SubmitOrder.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory To_SubmitOrder.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'To.SubmitOrder', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(2, _omitFieldNames ? '' : 'assetId')
    ..a<$core.double>(3, _omitFieldNames ? '' : 'bitcoinAmount', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'assetAmount', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'price', $pb.PbFieldType.QD)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'indexPrice', $pb.PbFieldType.OD)
    ..aQM<Account>(7, _omitFieldNames ? '' : 'account', subBuilder: Account.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  To_SubmitOrder clone() => To_SubmitOrder()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  To_SubmitOrder copyWith(void Function(To_SubmitOrder) updates) => super.copyWith((message) => updates(message as To_SubmitOrder)) as To_SubmitOrder;

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
  factory To_LinkOrder({
    $core.String? orderId,
  }) {
    final $result = create();
    if (orderId != null) {
      $result.orderId = orderId;
    }
    return $result;
  }
  To_LinkOrder._() : super();
  factory To_LinkOrder.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory To_LinkOrder.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'To.LinkOrder', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'orderId')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  To_LinkOrder clone() => To_LinkOrder()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  To_LinkOrder copyWith(void Function(To_LinkOrder) updates) => super.copyWith((message) => updates(message as To_LinkOrder)) as To_LinkOrder;

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
  factory To_SubmitDecision({
    $core.String? orderId,
    $core.bool? accept,
    $core.bool? autoSign,
    $core.bool? private,
    $fixnum.Int64? ttlSeconds,
    $core.bool? twoStep,
    $core.bool? txChainingAllowed,
    $core.bool? onlyUnusedUtxos,
  }) {
    final $result = create();
    if (orderId != null) {
      $result.orderId = orderId;
    }
    if (accept != null) {
      $result.accept = accept;
    }
    if (autoSign != null) {
      $result.autoSign = autoSign;
    }
    if (private != null) {
      $result.private = private;
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
    if (onlyUnusedUtxos != null) {
      $result.onlyUnusedUtxos = onlyUnusedUtxos;
    }
    return $result;
  }
  To_SubmitDecision._() : super();
  factory To_SubmitDecision.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory To_SubmitDecision.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'To.SubmitDecision', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'orderId')
    ..a<$core.bool>(2, _omitFieldNames ? '' : 'accept', $pb.PbFieldType.QB)
    ..aOB(3, _omitFieldNames ? '' : 'autoSign')
    ..aOB(4, _omitFieldNames ? '' : 'private')
    ..a<$fixnum.Int64>(5, _omitFieldNames ? '' : 'ttlSeconds', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOB(6, _omitFieldNames ? '' : 'twoStep')
    ..aOB(7, _omitFieldNames ? '' : 'txChainingAllowed')
    ..aOB(8, _omitFieldNames ? '' : 'onlyUnusedUtxos')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  To_SubmitDecision clone() => To_SubmitDecision()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  To_SubmitDecision copyWith(void Function(To_SubmitDecision) updates) => super.copyWith((message) => updates(message as To_SubmitDecision)) as To_SubmitDecision;

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
  $core.bool get onlyUnusedUtxos => $_getBF(7);
  @$pb.TagNumber(8)
  set onlyUnusedUtxos($core.bool v) { $_setBool(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasOnlyUnusedUtxos() => $_has(7);
  @$pb.TagNumber(8)
  void clearOnlyUnusedUtxos() => clearField(8);
}

enum To_EditOrder_Data {
  price, 
  indexPrice, 
  autoSign, 
  notSet
}

class To_EditOrder extends $pb.GeneratedMessage {
  factory To_EditOrder({
    $core.String? orderId,
    $core.double? price,
    $core.double? indexPrice,
    $core.bool? autoSign,
  }) {
    final $result = create();
    if (orderId != null) {
      $result.orderId = orderId;
    }
    if (price != null) {
      $result.price = price;
    }
    if (indexPrice != null) {
      $result.indexPrice = indexPrice;
    }
    if (autoSign != null) {
      $result.autoSign = autoSign;
    }
    return $result;
  }
  To_EditOrder._() : super();
  factory To_EditOrder.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory To_EditOrder.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, To_EditOrder_Data> _To_EditOrder_DataByTag = {
    2 : To_EditOrder_Data.price,
    3 : To_EditOrder_Data.indexPrice,
    4 : To_EditOrder_Data.autoSign,
    0 : To_EditOrder_Data.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'To.EditOrder', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..oo(0, [2, 3, 4])
    ..aQS(1, _omitFieldNames ? '' : 'orderId')
    ..a<$core.double>(2, _omitFieldNames ? '' : 'price', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'indexPrice', $pb.PbFieldType.OD)
    ..aOB(4, _omitFieldNames ? '' : 'autoSign')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  To_EditOrder clone() => To_EditOrder()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  To_EditOrder copyWith(void Function(To_EditOrder) updates) => super.copyWith((message) => updates(message as To_EditOrder)) as To_EditOrder;

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
  factory To_CancelOrder({
    $core.String? orderId,
  }) {
    final $result = create();
    if (orderId != null) {
      $result.orderId = orderId;
    }
    return $result;
  }
  To_CancelOrder._() : super();
  factory To_CancelOrder.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory To_CancelOrder.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'To.CancelOrder', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'orderId')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  To_CancelOrder clone() => To_CancelOrder()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  To_CancelOrder copyWith(void Function(To_CancelOrder) updates) => super.copyWith((message) => updates(message as To_CancelOrder)) as To_CancelOrder;

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
  factory To_Subscribe_Market({
    $core.String? assetId,
  }) {
    final $result = create();
    if (assetId != null) {
      $result.assetId = assetId;
    }
    return $result;
  }
  To_Subscribe_Market._() : super();
  factory To_Subscribe_Market.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory To_Subscribe_Market.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'To.Subscribe.Market', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'assetId')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  To_Subscribe_Market clone() => To_Subscribe_Market()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  To_Subscribe_Market copyWith(void Function(To_Subscribe_Market) updates) => super.copyWith((message) => updates(message as To_Subscribe_Market)) as To_Subscribe_Market;

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
  factory To_Subscribe({
    $core.Iterable<To_Subscribe_Market>? markets,
  }) {
    final $result = create();
    if (markets != null) {
      $result.markets.addAll(markets);
    }
    return $result;
  }
  To_Subscribe._() : super();
  factory To_Subscribe.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory To_Subscribe.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'To.Subscribe', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..pc<To_Subscribe_Market>(1, _omitFieldNames ? '' : 'markets', $pb.PbFieldType.PM, subBuilder: To_Subscribe_Market.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  To_Subscribe clone() => To_Subscribe()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  To_Subscribe copyWith(void Function(To_Subscribe) updates) => super.copyWith((message) => updates(message as To_Subscribe)) as To_Subscribe;

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

class To_MarketDataSubscribe extends $pb.GeneratedMessage {
  factory To_MarketDataSubscribe({
    $core.String? assetId,
  }) {
    final $result = create();
    if (assetId != null) {
      $result.assetId = assetId;
    }
    return $result;
  }
  To_MarketDataSubscribe._() : super();
  factory To_MarketDataSubscribe.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory To_MarketDataSubscribe.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'To.MarketDataSubscribe', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'assetId')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  To_MarketDataSubscribe clone() => To_MarketDataSubscribe()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  To_MarketDataSubscribe copyWith(void Function(To_MarketDataSubscribe) updates) => super.copyWith((message) => updates(message as To_MarketDataSubscribe)) as To_MarketDataSubscribe;

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
  createPayjoin, 
  sendPayjoin, 
  loadUtxos, 
  loadAddresses, 
  swapRequest, 
  pegInRequest, 
  pegOutRequest, 
  swapAccept, 
  pegOutAmount, 
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
  portfolioPrices, 
  conversionRates, 
  jadeRescan, 
  gaidStatus, 
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
    CreatePayjoin? createPayjoin,
    CreatedPayjoin? sendPayjoin,
    Account? loadUtxos,
    Account? loadAddresses,
    To_SwapRequest? swapRequest,
    To_PegInRequest? pegInRequest,
    To_PegOutRequest? pegOutRequest,
    SwapDetails? swapAccept,
    To_PegOutAmount? pegOutAmount,
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
    Empty? portfolioPrices,
    Empty? conversionRates,
    Empty? jadeRescan,
    To_GaidStatus? gaidStatus,
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
    if (createPayjoin != null) {
      $result.createPayjoin = createPayjoin;
    }
    if (sendPayjoin != null) {
      $result.sendPayjoin = sendPayjoin;
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
    if (swapAccept != null) {
      $result.swapAccept = swapAccept;
    }
    if (pegOutAmount != null) {
      $result.pegOutAmount = pegOutAmount;
    }
    if (registerPhone != null) {
      $result.registerPhone = registerPhone;
    }
    if (verifyPhone != null) {
      $result.verifyPhone = verifyPhone;
    }
    if (uploadAvatar != null) {
      $result.uploadAvatar = uploadAvatar;
    }
    if (uploadContacts != null) {
      $result.uploadContacts = uploadContacts;
    }
    if (unregisterPhone != null) {
      $result.unregisterPhone = unregisterPhone;
    }
    if (submitOrder != null) {
      $result.submitOrder = submitOrder;
    }
    if (linkOrder != null) {
      $result.linkOrder = linkOrder;
    }
    if (submitDecision != null) {
      $result.submitDecision = submitDecision;
    }
    if (editOrder != null) {
      $result.editOrder = editOrder;
    }
    if (cancelOrder != null) {
      $result.cancelOrder = cancelOrder;
    }
    if (subscribe != null) {
      $result.subscribe = subscribe;
    }
    if (subscribePrice != null) {
      $result.subscribePrice = subscribePrice;
    }
    if (unsubscribePrice != null) {
      $result.unsubscribePrice = unsubscribePrice;
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
    if (marketDataSubscribe != null) {
      $result.marketDataSubscribe = marketDataSubscribe;
    }
    if (marketDataUnsubscribe != null) {
      $result.marketDataUnsubscribe = marketDataUnsubscribe;
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
    15 : To_Msg.createPayjoin,
    16 : To_Msg.sendPayjoin,
    17 : To_Msg.loadUtxos,
    18 : To_Msg.loadAddresses,
    20 : To_Msg.swapRequest,
    21 : To_Msg.pegInRequest,
    22 : To_Msg.pegOutRequest,
    23 : To_Msg.swapAccept,
    24 : To_Msg.pegOutAmount,
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
    62 : To_Msg.portfolioPrices,
    63 : To_Msg.conversionRates,
    71 : To_Msg.jadeRescan,
    81 : To_Msg.gaidStatus,
    0 : To_Msg.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'To', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 20, 21, 22, 23, 24, 40, 41, 42, 43, 44, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 71, 81])
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
    ..aOM<CreatePayjoin>(15, _omitFieldNames ? '' : 'createPayjoin', subBuilder: CreatePayjoin.create)
    ..aOM<CreatedPayjoin>(16, _omitFieldNames ? '' : 'sendPayjoin', subBuilder: CreatedPayjoin.create)
    ..aOM<Account>(17, _omitFieldNames ? '' : 'loadUtxos', subBuilder: Account.create)
    ..aOM<Account>(18, _omitFieldNames ? '' : 'loadAddresses', subBuilder: Account.create)
    ..aOM<To_SwapRequest>(20, _omitFieldNames ? '' : 'swapRequest', subBuilder: To_SwapRequest.create)
    ..aOM<To_PegInRequest>(21, _omitFieldNames ? '' : 'pegInRequest', subBuilder: To_PegInRequest.create)
    ..aOM<To_PegOutRequest>(22, _omitFieldNames ? '' : 'pegOutRequest', subBuilder: To_PegOutRequest.create)
    ..aOM<SwapDetails>(23, _omitFieldNames ? '' : 'swapAccept', subBuilder: SwapDetails.create)
    ..aOM<To_PegOutAmount>(24, _omitFieldNames ? '' : 'pegOutAmount', subBuilder: To_PegOutAmount.create)
    ..aOM<To_RegisterPhone>(40, _omitFieldNames ? '' : 'registerPhone', subBuilder: To_RegisterPhone.create)
    ..aOM<To_VerifyPhone>(41, _omitFieldNames ? '' : 'verifyPhone', subBuilder: To_VerifyPhone.create)
    ..aOM<To_UploadAvatar>(42, _omitFieldNames ? '' : 'uploadAvatar', subBuilder: To_UploadAvatar.create)
    ..aOM<To_UploadContacts>(43, _omitFieldNames ? '' : 'uploadContacts', subBuilder: To_UploadContacts.create)
    ..aOM<To_UnregisterPhone>(44, _omitFieldNames ? '' : 'unregisterPhone', subBuilder: To_UnregisterPhone.create)
    ..aOM<To_SubmitOrder>(49, _omitFieldNames ? '' : 'submitOrder', subBuilder: To_SubmitOrder.create)
    ..aOM<To_LinkOrder>(50, _omitFieldNames ? '' : 'linkOrder', subBuilder: To_LinkOrder.create)
    ..aOM<To_SubmitDecision>(51, _omitFieldNames ? '' : 'submitDecision', subBuilder: To_SubmitDecision.create)
    ..aOM<To_EditOrder>(52, _omitFieldNames ? '' : 'editOrder', subBuilder: To_EditOrder.create)
    ..aOM<To_CancelOrder>(53, _omitFieldNames ? '' : 'cancelOrder', subBuilder: To_CancelOrder.create)
    ..aOM<To_Subscribe>(54, _omitFieldNames ? '' : 'subscribe', subBuilder: To_Subscribe.create)
    ..aOM<AssetId>(55, _omitFieldNames ? '' : 'subscribePrice', subBuilder: AssetId.create)
    ..aOM<AssetId>(56, _omitFieldNames ? '' : 'unsubscribePrice', subBuilder: AssetId.create)
    ..aOM<AssetId>(57, _omitFieldNames ? '' : 'assetDetails', subBuilder: AssetId.create)
    ..aOM<To_SubscribePriceStream>(58, _omitFieldNames ? '' : 'subscribePriceStream', subBuilder: To_SubscribePriceStream.create)
    ..aOM<Empty>(59, _omitFieldNames ? '' : 'unsubscribePriceStream', subBuilder: Empty.create)
    ..aOM<To_MarketDataSubscribe>(60, _omitFieldNames ? '' : 'marketDataSubscribe', subBuilder: To_MarketDataSubscribe.create)
    ..aOM<Empty>(61, _omitFieldNames ? '' : 'marketDataUnsubscribe', subBuilder: Empty.create)
    ..aOM<Empty>(62, _omitFieldNames ? '' : 'portfolioPrices', subBuilder: Empty.create)
    ..aOM<Empty>(63, _omitFieldNames ? '' : 'conversionRates', subBuilder: Empty.create)
    ..aOM<Empty>(71, _omitFieldNames ? '' : 'jadeRescan', subBuilder: Empty.create)
    ..aOM<To_GaidStatus>(81, _omitFieldNames ? '' : 'gaidStatus', subBuilder: To_GaidStatus.create)
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

  @$pb.TagNumber(15)
  CreatePayjoin get createPayjoin => $_getN(14);
  @$pb.TagNumber(15)
  set createPayjoin(CreatePayjoin v) { setField(15, v); }
  @$pb.TagNumber(15)
  $core.bool hasCreatePayjoin() => $_has(14);
  @$pb.TagNumber(15)
  void clearCreatePayjoin() => clearField(15);
  @$pb.TagNumber(15)
  CreatePayjoin ensureCreatePayjoin() => $_ensure(14);

  @$pb.TagNumber(16)
  CreatedPayjoin get sendPayjoin => $_getN(15);
  @$pb.TagNumber(16)
  set sendPayjoin(CreatedPayjoin v) { setField(16, v); }
  @$pb.TagNumber(16)
  $core.bool hasSendPayjoin() => $_has(15);
  @$pb.TagNumber(16)
  void clearSendPayjoin() => clearField(16);
  @$pb.TagNumber(16)
  CreatedPayjoin ensureSendPayjoin() => $_ensure(15);

  @$pb.TagNumber(17)
  Account get loadUtxos => $_getN(16);
  @$pb.TagNumber(17)
  set loadUtxos(Account v) { setField(17, v); }
  @$pb.TagNumber(17)
  $core.bool hasLoadUtxos() => $_has(16);
  @$pb.TagNumber(17)
  void clearLoadUtxos() => clearField(17);
  @$pb.TagNumber(17)
  Account ensureLoadUtxos() => $_ensure(16);

  @$pb.TagNumber(18)
  Account get loadAddresses => $_getN(17);
  @$pb.TagNumber(18)
  set loadAddresses(Account v) { setField(18, v); }
  @$pb.TagNumber(18)
  $core.bool hasLoadAddresses() => $_has(17);
  @$pb.TagNumber(18)
  void clearLoadAddresses() => clearField(18);
  @$pb.TagNumber(18)
  Account ensureLoadAddresses() => $_ensure(17);

  @$pb.TagNumber(20)
  To_SwapRequest get swapRequest => $_getN(18);
  @$pb.TagNumber(20)
  set swapRequest(To_SwapRequest v) { setField(20, v); }
  @$pb.TagNumber(20)
  $core.bool hasSwapRequest() => $_has(18);
  @$pb.TagNumber(20)
  void clearSwapRequest() => clearField(20);
  @$pb.TagNumber(20)
  To_SwapRequest ensureSwapRequest() => $_ensure(18);

  @$pb.TagNumber(21)
  To_PegInRequest get pegInRequest => $_getN(19);
  @$pb.TagNumber(21)
  set pegInRequest(To_PegInRequest v) { setField(21, v); }
  @$pb.TagNumber(21)
  $core.bool hasPegInRequest() => $_has(19);
  @$pb.TagNumber(21)
  void clearPegInRequest() => clearField(21);
  @$pb.TagNumber(21)
  To_PegInRequest ensurePegInRequest() => $_ensure(19);

  @$pb.TagNumber(22)
  To_PegOutRequest get pegOutRequest => $_getN(20);
  @$pb.TagNumber(22)
  set pegOutRequest(To_PegOutRequest v) { setField(22, v); }
  @$pb.TagNumber(22)
  $core.bool hasPegOutRequest() => $_has(20);
  @$pb.TagNumber(22)
  void clearPegOutRequest() => clearField(22);
  @$pb.TagNumber(22)
  To_PegOutRequest ensurePegOutRequest() => $_ensure(20);

  @$pb.TagNumber(23)
  SwapDetails get swapAccept => $_getN(21);
  @$pb.TagNumber(23)
  set swapAccept(SwapDetails v) { setField(23, v); }
  @$pb.TagNumber(23)
  $core.bool hasSwapAccept() => $_has(21);
  @$pb.TagNumber(23)
  void clearSwapAccept() => clearField(23);
  @$pb.TagNumber(23)
  SwapDetails ensureSwapAccept() => $_ensure(21);

  @$pb.TagNumber(24)
  To_PegOutAmount get pegOutAmount => $_getN(22);
  @$pb.TagNumber(24)
  set pegOutAmount(To_PegOutAmount v) { setField(24, v); }
  @$pb.TagNumber(24)
  $core.bool hasPegOutAmount() => $_has(22);
  @$pb.TagNumber(24)
  void clearPegOutAmount() => clearField(24);
  @$pb.TagNumber(24)
  To_PegOutAmount ensurePegOutAmount() => $_ensure(22);

  @$pb.TagNumber(40)
  To_RegisterPhone get registerPhone => $_getN(23);
  @$pb.TagNumber(40)
  set registerPhone(To_RegisterPhone v) { setField(40, v); }
  @$pb.TagNumber(40)
  $core.bool hasRegisterPhone() => $_has(23);
  @$pb.TagNumber(40)
  void clearRegisterPhone() => clearField(40);
  @$pb.TagNumber(40)
  To_RegisterPhone ensureRegisterPhone() => $_ensure(23);

  @$pb.TagNumber(41)
  To_VerifyPhone get verifyPhone => $_getN(24);
  @$pb.TagNumber(41)
  set verifyPhone(To_VerifyPhone v) { setField(41, v); }
  @$pb.TagNumber(41)
  $core.bool hasVerifyPhone() => $_has(24);
  @$pb.TagNumber(41)
  void clearVerifyPhone() => clearField(41);
  @$pb.TagNumber(41)
  To_VerifyPhone ensureVerifyPhone() => $_ensure(24);

  @$pb.TagNumber(42)
  To_UploadAvatar get uploadAvatar => $_getN(25);
  @$pb.TagNumber(42)
  set uploadAvatar(To_UploadAvatar v) { setField(42, v); }
  @$pb.TagNumber(42)
  $core.bool hasUploadAvatar() => $_has(25);
  @$pb.TagNumber(42)
  void clearUploadAvatar() => clearField(42);
  @$pb.TagNumber(42)
  To_UploadAvatar ensureUploadAvatar() => $_ensure(25);

  @$pb.TagNumber(43)
  To_UploadContacts get uploadContacts => $_getN(26);
  @$pb.TagNumber(43)
  set uploadContacts(To_UploadContacts v) { setField(43, v); }
  @$pb.TagNumber(43)
  $core.bool hasUploadContacts() => $_has(26);
  @$pb.TagNumber(43)
  void clearUploadContacts() => clearField(43);
  @$pb.TagNumber(43)
  To_UploadContacts ensureUploadContacts() => $_ensure(26);

  @$pb.TagNumber(44)
  To_UnregisterPhone get unregisterPhone => $_getN(27);
  @$pb.TagNumber(44)
  set unregisterPhone(To_UnregisterPhone v) { setField(44, v); }
  @$pb.TagNumber(44)
  $core.bool hasUnregisterPhone() => $_has(27);
  @$pb.TagNumber(44)
  void clearUnregisterPhone() => clearField(44);
  @$pb.TagNumber(44)
  To_UnregisterPhone ensureUnregisterPhone() => $_ensure(27);

  @$pb.TagNumber(49)
  To_SubmitOrder get submitOrder => $_getN(28);
  @$pb.TagNumber(49)
  set submitOrder(To_SubmitOrder v) { setField(49, v); }
  @$pb.TagNumber(49)
  $core.bool hasSubmitOrder() => $_has(28);
  @$pb.TagNumber(49)
  void clearSubmitOrder() => clearField(49);
  @$pb.TagNumber(49)
  To_SubmitOrder ensureSubmitOrder() => $_ensure(28);

  @$pb.TagNumber(50)
  To_LinkOrder get linkOrder => $_getN(29);
  @$pb.TagNumber(50)
  set linkOrder(To_LinkOrder v) { setField(50, v); }
  @$pb.TagNumber(50)
  $core.bool hasLinkOrder() => $_has(29);
  @$pb.TagNumber(50)
  void clearLinkOrder() => clearField(50);
  @$pb.TagNumber(50)
  To_LinkOrder ensureLinkOrder() => $_ensure(29);

  @$pb.TagNumber(51)
  To_SubmitDecision get submitDecision => $_getN(30);
  @$pb.TagNumber(51)
  set submitDecision(To_SubmitDecision v) { setField(51, v); }
  @$pb.TagNumber(51)
  $core.bool hasSubmitDecision() => $_has(30);
  @$pb.TagNumber(51)
  void clearSubmitDecision() => clearField(51);
  @$pb.TagNumber(51)
  To_SubmitDecision ensureSubmitDecision() => $_ensure(30);

  @$pb.TagNumber(52)
  To_EditOrder get editOrder => $_getN(31);
  @$pb.TagNumber(52)
  set editOrder(To_EditOrder v) { setField(52, v); }
  @$pb.TagNumber(52)
  $core.bool hasEditOrder() => $_has(31);
  @$pb.TagNumber(52)
  void clearEditOrder() => clearField(52);
  @$pb.TagNumber(52)
  To_EditOrder ensureEditOrder() => $_ensure(31);

  @$pb.TagNumber(53)
  To_CancelOrder get cancelOrder => $_getN(32);
  @$pb.TagNumber(53)
  set cancelOrder(To_CancelOrder v) { setField(53, v); }
  @$pb.TagNumber(53)
  $core.bool hasCancelOrder() => $_has(32);
  @$pb.TagNumber(53)
  void clearCancelOrder() => clearField(53);
  @$pb.TagNumber(53)
  To_CancelOrder ensureCancelOrder() => $_ensure(32);

  @$pb.TagNumber(54)
  To_Subscribe get subscribe => $_getN(33);
  @$pb.TagNumber(54)
  set subscribe(To_Subscribe v) { setField(54, v); }
  @$pb.TagNumber(54)
  $core.bool hasSubscribe() => $_has(33);
  @$pb.TagNumber(54)
  void clearSubscribe() => clearField(54);
  @$pb.TagNumber(54)
  To_Subscribe ensureSubscribe() => $_ensure(33);

  @$pb.TagNumber(55)
  AssetId get subscribePrice => $_getN(34);
  @$pb.TagNumber(55)
  set subscribePrice(AssetId v) { setField(55, v); }
  @$pb.TagNumber(55)
  $core.bool hasSubscribePrice() => $_has(34);
  @$pb.TagNumber(55)
  void clearSubscribePrice() => clearField(55);
  @$pb.TagNumber(55)
  AssetId ensureSubscribePrice() => $_ensure(34);

  @$pb.TagNumber(56)
  AssetId get unsubscribePrice => $_getN(35);
  @$pb.TagNumber(56)
  set unsubscribePrice(AssetId v) { setField(56, v); }
  @$pb.TagNumber(56)
  $core.bool hasUnsubscribePrice() => $_has(35);
  @$pb.TagNumber(56)
  void clearUnsubscribePrice() => clearField(56);
  @$pb.TagNumber(56)
  AssetId ensureUnsubscribePrice() => $_ensure(35);

  @$pb.TagNumber(57)
  AssetId get assetDetails => $_getN(36);
  @$pb.TagNumber(57)
  set assetDetails(AssetId v) { setField(57, v); }
  @$pb.TagNumber(57)
  $core.bool hasAssetDetails() => $_has(36);
  @$pb.TagNumber(57)
  void clearAssetDetails() => clearField(57);
  @$pb.TagNumber(57)
  AssetId ensureAssetDetails() => $_ensure(36);

  @$pb.TagNumber(58)
  To_SubscribePriceStream get subscribePriceStream => $_getN(37);
  @$pb.TagNumber(58)
  set subscribePriceStream(To_SubscribePriceStream v) { setField(58, v); }
  @$pb.TagNumber(58)
  $core.bool hasSubscribePriceStream() => $_has(37);
  @$pb.TagNumber(58)
  void clearSubscribePriceStream() => clearField(58);
  @$pb.TagNumber(58)
  To_SubscribePriceStream ensureSubscribePriceStream() => $_ensure(37);

  @$pb.TagNumber(59)
  Empty get unsubscribePriceStream => $_getN(38);
  @$pb.TagNumber(59)
  set unsubscribePriceStream(Empty v) { setField(59, v); }
  @$pb.TagNumber(59)
  $core.bool hasUnsubscribePriceStream() => $_has(38);
  @$pb.TagNumber(59)
  void clearUnsubscribePriceStream() => clearField(59);
  @$pb.TagNumber(59)
  Empty ensureUnsubscribePriceStream() => $_ensure(38);

  @$pb.TagNumber(60)
  To_MarketDataSubscribe get marketDataSubscribe => $_getN(39);
  @$pb.TagNumber(60)
  set marketDataSubscribe(To_MarketDataSubscribe v) { setField(60, v); }
  @$pb.TagNumber(60)
  $core.bool hasMarketDataSubscribe() => $_has(39);
  @$pb.TagNumber(60)
  void clearMarketDataSubscribe() => clearField(60);
  @$pb.TagNumber(60)
  To_MarketDataSubscribe ensureMarketDataSubscribe() => $_ensure(39);

  @$pb.TagNumber(61)
  Empty get marketDataUnsubscribe => $_getN(40);
  @$pb.TagNumber(61)
  set marketDataUnsubscribe(Empty v) { setField(61, v); }
  @$pb.TagNumber(61)
  $core.bool hasMarketDataUnsubscribe() => $_has(40);
  @$pb.TagNumber(61)
  void clearMarketDataUnsubscribe() => clearField(61);
  @$pb.TagNumber(61)
  Empty ensureMarketDataUnsubscribe() => $_ensure(40);

  @$pb.TagNumber(62)
  Empty get portfolioPrices => $_getN(41);
  @$pb.TagNumber(62)
  set portfolioPrices(Empty v) { setField(62, v); }
  @$pb.TagNumber(62)
  $core.bool hasPortfolioPrices() => $_has(41);
  @$pb.TagNumber(62)
  void clearPortfolioPrices() => clearField(62);
  @$pb.TagNumber(62)
  Empty ensurePortfolioPrices() => $_ensure(41);

  @$pb.TagNumber(63)
  Empty get conversionRates => $_getN(42);
  @$pb.TagNumber(63)
  set conversionRates(Empty v) { setField(63, v); }
  @$pb.TagNumber(63)
  $core.bool hasConversionRates() => $_has(42);
  @$pb.TagNumber(63)
  void clearConversionRates() => clearField(63);
  @$pb.TagNumber(63)
  Empty ensureConversionRates() => $_ensure(42);

  @$pb.TagNumber(71)
  Empty get jadeRescan => $_getN(43);
  @$pb.TagNumber(71)
  set jadeRescan(Empty v) { setField(71, v); }
  @$pb.TagNumber(71)
  $core.bool hasJadeRescan() => $_has(43);
  @$pb.TagNumber(71)
  void clearJadeRescan() => clearField(71);
  @$pb.TagNumber(71)
  Empty ensureJadeRescan() => $_ensure(43);

  @$pb.TagNumber(81)
  To_GaidStatus get gaidStatus => $_getN(44);
  @$pb.TagNumber(81)
  set gaidStatus(To_GaidStatus v) { setField(81, v); }
  @$pb.TagNumber(81)
  $core.bool hasGaidStatus() => $_has(44);
  @$pb.TagNumber(81)
  void clearGaidStatus() => clearField(81);
  @$pb.TagNumber(81)
  To_GaidStatus ensureGaidStatus() => $_ensure(44);
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
    return $result;
  }
  From_EncryptPin_Data._() : super();
  factory From_EncryptPin_Data.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_EncryptPin_Data.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.EncryptPin.Data', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(2, _omitFieldNames ? '' : 'salt')
    ..aQS(3, _omitFieldNames ? '' : 'encryptedData')
    ..aQS(4, _omitFieldNames ? '' : 'pinIdentifier')
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

enum From_DecryptPin_Result {
  error, 
  mnemonic, 
  notSet
}

class From_DecryptPin extends $pb.GeneratedMessage {
  factory From_DecryptPin({
    $core.String? error,
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
    ..aOS(1, _omitFieldNames ? '' : 'error')
    ..aOS(2, _omitFieldNames ? '' : 'mnemonic')
    ..hasRequiredFields = false
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

class From_TokenMarketOrder extends $pb.GeneratedMessage {
  factory From_TokenMarketOrder({
    $core.Iterable<$core.String>? assetIds,
  }) {
    final $result = create();
    if (assetIds != null) {
      $result.assetIds.addAll(assetIds);
    }
    return $result;
  }
  From_TokenMarketOrder._() : super();
  factory From_TokenMarketOrder.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_TokenMarketOrder.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.TokenMarketOrder', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'assetIds')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_TokenMarketOrder clone() => From_TokenMarketOrder()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_TokenMarketOrder copyWith(void Function(From_TokenMarketOrder) updates) => super.copyWith((message) => updates(message as From_TokenMarketOrder)) as From_TokenMarketOrder;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_TokenMarketOrder create() => From_TokenMarketOrder._();
  From_TokenMarketOrder createEmptyInstance() => create();
  static $pb.PbList<From_TokenMarketOrder> createRepeated() => $pb.PbList<From_TokenMarketOrder>();
  @$core.pragma('dart2js:noInline')
  static From_TokenMarketOrder getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_TokenMarketOrder>(create);
  static From_TokenMarketOrder? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.String> get assetIds => $_getList(0);
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

class From_UtxoUpdate_Utxo extends $pb.GeneratedMessage {
  factory From_UtxoUpdate_Utxo({
    $core.String? txid,
    $core.int? vout,
    $core.String? assetId,
    $fixnum.Int64? amount,
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
    return $result;
  }
  From_UtxoUpdate_Utxo._() : super();
  factory From_UtxoUpdate_Utxo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_UtxoUpdate_Utxo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.UtxoUpdate.Utxo', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'txid')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'vout', $pb.PbFieldType.QU3)
    ..aQS(3, _omitFieldNames ? '' : 'assetId')
    ..a<$fixnum.Int64>(4, _omitFieldNames ? '' : 'amount', $pb.PbFieldType.QU6, defaultOrMaker: $fixnum.Int64.ZERO)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_UtxoUpdate_Utxo clone() => From_UtxoUpdate_Utxo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_UtxoUpdate_Utxo copyWith(void Function(From_UtxoUpdate_Utxo) updates) => super.copyWith((message) => updates(message as From_UtxoUpdate_Utxo)) as From_UtxoUpdate_Utxo;

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
  factory From_UtxoUpdate({
    Account? account,
    $core.Iterable<From_UtxoUpdate_Utxo>? utxos,
  }) {
    final $result = create();
    if (account != null) {
      $result.account = account;
    }
    if (utxos != null) {
      $result.utxos.addAll(utxos);
    }
    return $result;
  }
  From_UtxoUpdate._() : super();
  factory From_UtxoUpdate.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_UtxoUpdate.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.UtxoUpdate', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQM<Account>(1, _omitFieldNames ? '' : 'account', subBuilder: Account.create)
    ..pc<From_UtxoUpdate_Utxo>(2, _omitFieldNames ? '' : 'utxos', $pb.PbFieldType.PM, subBuilder: From_UtxoUpdate_Utxo.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_UtxoUpdate clone() => From_UtxoUpdate()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_UtxoUpdate copyWith(void Function(From_UtxoUpdate) updates) => super.copyWith((message) => updates(message as From_UtxoUpdate)) as From_UtxoUpdate;

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

enum From_CreatePayjoinResult_Result {
  errorMsg, 
  createdPayjoin, 
  notSet
}

class From_CreatePayjoinResult extends $pb.GeneratedMessage {
  factory From_CreatePayjoinResult({
    $core.String? errorMsg,
    CreatedPayjoin? createdPayjoin,
  }) {
    final $result = create();
    if (errorMsg != null) {
      $result.errorMsg = errorMsg;
    }
    if (createdPayjoin != null) {
      $result.createdPayjoin = createdPayjoin;
    }
    return $result;
  }
  From_CreatePayjoinResult._() : super();
  factory From_CreatePayjoinResult.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_CreatePayjoinResult.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, From_CreatePayjoinResult_Result> _From_CreatePayjoinResult_ResultByTag = {
    1 : From_CreatePayjoinResult_Result.errorMsg,
    2 : From_CreatePayjoinResult_Result.createdPayjoin,
    0 : From_CreatePayjoinResult_Result.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.CreatePayjoinResult', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOS(1, _omitFieldNames ? '' : 'errorMsg')
    ..aOM<CreatedPayjoin>(2, _omitFieldNames ? '' : 'createdPayjoin', subBuilder: CreatedPayjoin.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_CreatePayjoinResult clone() => From_CreatePayjoinResult()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_CreatePayjoinResult copyWith(void Function(From_CreatePayjoinResult) updates) => super.copyWith((message) => updates(message as From_CreatePayjoinResult)) as From_CreatePayjoinResult;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_CreatePayjoinResult create() => From_CreatePayjoinResult._();
  From_CreatePayjoinResult createEmptyInstance() => create();
  static $pb.PbList<From_CreatePayjoinResult> createRepeated() => $pb.PbList<From_CreatePayjoinResult>();
  @$core.pragma('dart2js:noInline')
  static From_CreatePayjoinResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_CreatePayjoinResult>(create);
  static From_CreatePayjoinResult? _defaultInstance;

  From_CreatePayjoinResult_Result whichResult() => _From_CreatePayjoinResult_ResultByTag[$_whichOneof(0)]!;
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
  CreatedPayjoin get createdPayjoin => $_getN(1);
  @$pb.TagNumber(2)
  set createdPayjoin(CreatedPayjoin v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasCreatedPayjoin() => $_has(1);
  @$pb.TagNumber(2)
  void clearCreatedPayjoin() => clearField(2);
  @$pb.TagNumber(2)
  CreatedPayjoin ensureCreatedPayjoin() => $_ensure(1);
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

class From_SubmitReview extends $pb.GeneratedMessage {
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
    $core.bool? twoStep,
    $core.bool? txChainingRequired,
  }) {
    final $result = create();
    if (orderId != null) {
      $result.orderId = orderId;
    }
    if (asset != null) {
      $result.asset = asset;
    }
    if (bitcoinAmount != null) {
      $result.bitcoinAmount = bitcoinAmount;
    }
    if (assetAmount != null) {
      $result.assetAmount = assetAmount;
    }
    if (price != null) {
      $result.price = price;
    }
    if (sellBitcoin != null) {
      $result.sellBitcoin = sellBitcoin;
    }
    if (step != null) {
      $result.step = step;
    }
    if (serverFee != null) {
      $result.serverFee = serverFee;
    }
    if (indexPrice != null) {
      $result.indexPrice = indexPrice;
    }
    if (autoSign != null) {
      $result.autoSign = autoSign;
    }
    if (twoStep != null) {
      $result.twoStep = twoStep;
    }
    if (txChainingRequired != null) {
      $result.txChainingRequired = txChainingRequired;
    }
    return $result;
  }
  From_SubmitReview._() : super();
  factory From_SubmitReview.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_SubmitReview.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.SubmitReview', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'orderId')
    ..aQS(2, _omitFieldNames ? '' : 'asset')
    ..a<$fixnum.Int64>(3, _omitFieldNames ? '' : 'bitcoinAmount', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(4, _omitFieldNames ? '' : 'assetAmount', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'price', $pb.PbFieldType.QD)
    ..a<$core.bool>(6, _omitFieldNames ? '' : 'sellBitcoin', $pb.PbFieldType.QB)
    ..e<From_SubmitReview_Step>(7, _omitFieldNames ? '' : 'step', $pb.PbFieldType.QE, defaultOrMaker: From_SubmitReview_Step.SUBMIT, valueOf: From_SubmitReview_Step.valueOf, enumValues: From_SubmitReview_Step.values)
    ..a<$fixnum.Int64>(8, _omitFieldNames ? '' : 'serverFee', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.bool>(9, _omitFieldNames ? '' : 'indexPrice', $pb.PbFieldType.QB)
    ..a<$core.bool>(11, _omitFieldNames ? '' : 'autoSign', $pb.PbFieldType.QB)
    ..aOB(12, _omitFieldNames ? '' : 'twoStep')
    ..aOB(13, _omitFieldNames ? '' : 'txChainingRequired')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_SubmitReview clone() => From_SubmitReview()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_SubmitReview copyWith(void Function(From_SubmitReview) updates) => super.copyWith((message) => updates(message as From_SubmitReview)) as From_SubmitReview;

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

  @$pb.TagNumber(12)
  $core.bool get twoStep => $_getBF(10);
  @$pb.TagNumber(12)
  set twoStep($core.bool v) { $_setBool(10, v); }
  @$pb.TagNumber(12)
  $core.bool hasTwoStep() => $_has(10);
  @$pb.TagNumber(12)
  void clearTwoStep() => clearField(12);

  @$pb.TagNumber(13)
  $core.bool get txChainingRequired => $_getBF(11);
  @$pb.TagNumber(13)
  set txChainingRequired($core.bool v) { $_setBool(11, v); }
  @$pb.TagNumber(13)
  $core.bool hasTxChainingRequired() => $_has(11);
  @$pb.TagNumber(13)
  void clearTxChainingRequired() => clearField(13);
}

class From_SubmitResult_UnregisteredGaid extends $pb.GeneratedMessage {
  factory From_SubmitResult_UnregisteredGaid({
    $core.String? domainAgent,
  }) {
    final $result = create();
    if (domainAgent != null) {
      $result.domainAgent = domainAgent;
    }
    return $result;
  }
  From_SubmitResult_UnregisteredGaid._() : super();
  factory From_SubmitResult_UnregisteredGaid.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_SubmitResult_UnregisteredGaid.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.SubmitResult.UnregisteredGaid', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'domainAgent')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_SubmitResult_UnregisteredGaid clone() => From_SubmitResult_UnregisteredGaid()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_SubmitResult_UnregisteredGaid copyWith(void Function(From_SubmitResult_UnregisteredGaid) updates) => super.copyWith((message) => updates(message as From_SubmitResult_UnregisteredGaid)) as From_SubmitResult_UnregisteredGaid;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_SubmitResult_UnregisteredGaid create() => From_SubmitResult_UnregisteredGaid._();
  From_SubmitResult_UnregisteredGaid createEmptyInstance() => create();
  static $pb.PbList<From_SubmitResult_UnregisteredGaid> createRepeated() => $pb.PbList<From_SubmitResult_UnregisteredGaid>();
  @$core.pragma('dart2js:noInline')
  static From_SubmitResult_UnregisteredGaid getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_SubmitResult_UnregisteredGaid>(create);
  static From_SubmitResult_UnregisteredGaid? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get domainAgent => $_getSZ(0);
  @$pb.TagNumber(1)
  set domainAgent($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDomainAgent() => $_has(0);
  @$pb.TagNumber(1)
  void clearDomainAgent() => clearField(1);
}

enum From_SubmitResult_Result {
  submitSucceed, 
  swapSucceed, 
  error, 
  unregisteredGaid, 
  notSet
}

class From_SubmitResult extends $pb.GeneratedMessage {
  factory From_SubmitResult({
    Empty? submitSucceed,
    TransItem? swapSucceed,
    $core.String? error,
    From_SubmitResult_UnregisteredGaid? unregisteredGaid,
  }) {
    final $result = create();
    if (submitSucceed != null) {
      $result.submitSucceed = submitSucceed;
    }
    if (swapSucceed != null) {
      $result.swapSucceed = swapSucceed;
    }
    if (error != null) {
      $result.error = error;
    }
    if (unregisteredGaid != null) {
      $result.unregisteredGaid = unregisteredGaid;
    }
    return $result;
  }
  From_SubmitResult._() : super();
  factory From_SubmitResult.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_SubmitResult.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, From_SubmitResult_Result> _From_SubmitResult_ResultByTag = {
    1 : From_SubmitResult_Result.submitSucceed,
    2 : From_SubmitResult_Result.swapSucceed,
    3 : From_SubmitResult_Result.error,
    4 : From_SubmitResult_Result.unregisteredGaid,
    0 : From_SubmitResult_Result.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.SubmitResult', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4])
    ..aOM<Empty>(1, _omitFieldNames ? '' : 'submitSucceed', subBuilder: Empty.create)
    ..aOM<TransItem>(2, _omitFieldNames ? '' : 'swapSucceed', subBuilder: TransItem.create)
    ..aOS(3, _omitFieldNames ? '' : 'error')
    ..aOM<From_SubmitResult_UnregisteredGaid>(4, _omitFieldNames ? '' : 'unregisteredGaid', subBuilder: From_SubmitResult_UnregisteredGaid.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_SubmitResult clone() => From_SubmitResult()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_SubmitResult copyWith(void Function(From_SubmitResult) updates) => super.copyWith((message) => updates(message as From_SubmitResult)) as From_SubmitResult;

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

  @$pb.TagNumber(4)
  From_SubmitResult_UnregisteredGaid get unregisteredGaid => $_getN(3);
  @$pb.TagNumber(4)
  set unregisteredGaid(From_SubmitResult_UnregisteredGaid v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasUnregisteredGaid() => $_has(3);
  @$pb.TagNumber(4)
  void clearUnregisteredGaid() => clearField(4);
  @$pb.TagNumber(4)
  From_SubmitResult_UnregisteredGaid ensureUnregisteredGaid() => $_ensure(3);
}

class From_StartTimer extends $pb.GeneratedMessage {
  factory From_StartTimer({
    $core.String? orderId,
  }) {
    final $result = create();
    if (orderId != null) {
      $result.orderId = orderId;
    }
    return $result;
  }
  From_StartTimer._() : super();
  factory From_StartTimer.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_StartTimer.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.StartTimer', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'orderId')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_StartTimer clone() => From_StartTimer()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_StartTimer copyWith(void Function(From_StartTimer) updates) => super.copyWith((message) => updates(message as From_StartTimer)) as From_StartTimer;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static From_StartTimer create() => From_StartTimer._();
  From_StartTimer createEmptyInstance() => create();
  static $pb.PbList<From_StartTimer> createRepeated() => $pb.PbList<From_StartTimer>();
  @$core.pragma('dart2js:noInline')
  static From_StartTimer getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_StartTimer>(create);
  static From_StartTimer? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get orderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set orderId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrderId() => clearField(1);
}

class From_OrderCreated extends $pb.GeneratedMessage {
  factory From_OrderCreated({
    Order? order,
    $core.bool? new_2,
  }) {
    final $result = create();
    if (order != null) {
      $result.order = order;
    }
    if (new_2 != null) {
      $result.new_2 = new_2;
    }
    return $result;
  }
  From_OrderCreated._() : super();
  factory From_OrderCreated.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_OrderCreated.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.OrderCreated', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQM<Order>(1, _omitFieldNames ? '' : 'order', subBuilder: Order.create)
    ..a<$core.bool>(2, _omitFieldNames ? '' : 'new', $pb.PbFieldType.QB)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_OrderCreated clone() => From_OrderCreated()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_OrderCreated copyWith(void Function(From_OrderCreated) updates) => super.copyWith((message) => updates(message as From_OrderCreated)) as From_OrderCreated;

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
  factory From_OrderRemoved({
    $core.String? orderId,
  }) {
    final $result = create();
    if (orderId != null) {
      $result.orderId = orderId;
    }
    return $result;
  }
  From_OrderRemoved._() : super();
  factory From_OrderRemoved.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_OrderRemoved.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.OrderRemoved', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'orderId')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_OrderRemoved clone() => From_OrderRemoved()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_OrderRemoved copyWith(void Function(From_OrderRemoved) updates) => super.copyWith((message) => updates(message as From_OrderRemoved)) as From_OrderRemoved;

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
  factory From_OrderComplete({
    $core.String? orderId,
    $core.String? txid,
  }) {
    final $result = create();
    if (orderId != null) {
      $result.orderId = orderId;
    }
    if (txid != null) {
      $result.txid = txid;
    }
    return $result;
  }
  From_OrderComplete._() : super();
  factory From_OrderComplete.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_OrderComplete.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.OrderComplete', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'orderId')
    ..aOS(2, _omitFieldNames ? '' : 'txid')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_OrderComplete clone() => From_OrderComplete()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_OrderComplete copyWith(void Function(From_OrderComplete) updates) => super.copyWith((message) => updates(message as From_OrderComplete)) as From_OrderComplete;

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
  factory From_IndexPrice({
    $core.String? assetId,
    $core.double? ind,
    $core.double? last,
  }) {
    final $result = create();
    if (assetId != null) {
      $result.assetId = assetId;
    }
    if (ind != null) {
      $result.ind = ind;
    }
    if (last != null) {
      $result.last = last;
    }
    return $result;
  }
  From_IndexPrice._() : super();
  factory From_IndexPrice.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_IndexPrice.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.IndexPrice', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'assetId')
    ..a<$core.double>(2, _omitFieldNames ? '' : 'ind', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'last', $pb.PbFieldType.OD)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_IndexPrice clone() => From_IndexPrice()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_IndexPrice copyWith(void Function(From_IndexPrice) updates) => super.copyWith((message) => updates(message as From_IndexPrice)) as From_IndexPrice;

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
  factory From_ContactRemoved({
    $core.String? contactKey,
  }) {
    final $result = create();
    if (contactKey != null) {
      $result.contactKey = contactKey;
    }
    return $result;
  }
  From_ContactRemoved._() : super();
  factory From_ContactRemoved.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_ContactRemoved.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.ContactRemoved', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'contactKey')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_ContactRemoved clone() => From_ContactRemoved()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_ContactRemoved copyWith(void Function(From_ContactRemoved) updates) => super.copyWith((message) => updates(message as From_ContactRemoved)) as From_ContactRemoved;

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
  factory From_AccountStatus({
    $core.bool? registered,
  }) {
    final $result = create();
    if (registered != null) {
      $result.registered = registered;
    }
    return $result;
  }
  From_AccountStatus._() : super();
  factory From_AccountStatus.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_AccountStatus.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.AccountStatus', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..a<$core.bool>(1, _omitFieldNames ? '' : 'registered', $pb.PbFieldType.QB)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_AccountStatus clone() => From_AccountStatus()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_AccountStatus copyWith(void Function(From_AccountStatus) updates) => super.copyWith((message) => updates(message as From_AccountStatus)) as From_AccountStatus;

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

class From_AssetDetails_ChartStats extends $pb.GeneratedMessage {
  factory From_AssetDetails_ChartStats({
    $core.double? low,
    $core.double? high,
    $core.double? last,
  }) {
    final $result = create();
    if (low != null) {
      $result.low = low;
    }
    if (high != null) {
      $result.high = high;
    }
    if (last != null) {
      $result.last = last;
    }
    return $result;
  }
  From_AssetDetails_ChartStats._() : super();
  factory From_AssetDetails_ChartStats.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_AssetDetails_ChartStats.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.AssetDetails.ChartStats', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'low', $pb.PbFieldType.QD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'high', $pb.PbFieldType.QD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'last', $pb.PbFieldType.QD)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_AssetDetails_ChartStats clone() => From_AssetDetails_ChartStats()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_AssetDetails_ChartStats copyWith(void Function(From_AssetDetails_ChartStats) updates) => super.copyWith((message) => updates(message as From_AssetDetails_ChartStats)) as From_AssetDetails_ChartStats;

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
  factory From_AssetDetails({
    $core.String? assetId,
    From_AssetDetails_Stats? stats,
    $core.String? chartUrl,
    From_AssetDetails_ChartStats? chartStats,
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
    if (chartStats != null) {
      $result.chartStats = chartStats;
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
    ..aOM<From_AssetDetails_ChartStats>(4, _omitFieldNames ? '' : 'chartStats', subBuilder: From_AssetDetails_ChartStats.create)
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

class From_MarketDataSubscribe extends $pb.GeneratedMessage {
  factory From_MarketDataSubscribe({
    $core.String? assetId,
    $core.Iterable<ChartPoint>? data,
  }) {
    final $result = create();
    if (assetId != null) {
      $result.assetId = assetId;
    }
    if (data != null) {
      $result.data.addAll(data);
    }
    return $result;
  }
  From_MarketDataSubscribe._() : super();
  factory From_MarketDataSubscribe.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_MarketDataSubscribe.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.MarketDataSubscribe', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'assetId')
    ..pc<ChartPoint>(2, _omitFieldNames ? '' : 'data', $pb.PbFieldType.PM, subBuilder: ChartPoint.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_MarketDataSubscribe clone() => From_MarketDataSubscribe()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_MarketDataSubscribe copyWith(void Function(From_MarketDataSubscribe) updates) => super.copyWith((message) => updates(message as From_MarketDataSubscribe)) as From_MarketDataSubscribe;

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
  factory From_MarketDataUpdate({
    $core.String? assetId,
    ChartPoint? update,
  }) {
    final $result = create();
    if (assetId != null) {
      $result.assetId = assetId;
    }
    if (update != null) {
      $result.update = update;
    }
    return $result;
  }
  From_MarketDataUpdate._() : super();
  factory From_MarketDataUpdate.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_MarketDataUpdate.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From.MarketDataUpdate', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'assetId')
    ..aQM<ChartPoint>(2, _omitFieldNames ? '' : 'update', subBuilder: ChartPoint.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_MarketDataUpdate clone() => From_MarketDataUpdate()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_MarketDataUpdate copyWith(void Function(From_MarketDataUpdate) updates) => super.copyWith((message) => updates(message as From_MarketDataUpdate)) as From_MarketDataUpdate;

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
    ..e<From_JadeStatus_Status>(1, _omitFieldNames ? '' : 'status', $pb.PbFieldType.QE, defaultOrMaker: From_JadeStatus_Status.IDLE, valueOf: From_JadeStatus_Status.valueOf, enumValues: From_JadeStatus_Status.values)
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
  logout, 
  login, 
  tokenMarketOrder, 
  peginWaitTx, 
  swapSucceed, 
  swapFailed, 
  pegOutAmount, 
  recvAddress, 
  createTxResult, 
  sendResult, 
  blindedValues, 
  createPayjoinResult, 
  loadUtxos, 
  loadAddresses, 
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
  startTimer, 
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
  portfolioPrices, 
  conversionRates, 
  jadePorts, 
  jadeStatus, 
  gaidStatus, 
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
    From_UtxoUpdate? utxoUpdate,
    Empty? logout,
    From_Login? login,
    From_TokenMarketOrder? tokenMarketOrder,
    From_PeginWaitTx? peginWaitTx,
    TransItem? swapSucceed,
    $core.String? swapFailed,
    From_PegOutAmount? pegOutAmount,
    From_RecvAddress? recvAddress,
    From_CreateTxResult? createTxResult,
    From_SendResult? sendResult,
    From_BlindedValues? blindedValues,
    From_CreatePayjoinResult? createPayjoinResult,
    From_LoadUtxos? loadUtxos,
    From_LoadAddresses? loadAddresses,
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
    From_StartTimer? startTimer,
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
    From_PortfolioPrices? portfolioPrices,
    From_ConversionRates? conversionRates,
    From_JadePorts? jadePorts,
    From_JadeStatus? jadeStatus,
    From_GaidStatus? gaidStatus,
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
    if (utxoUpdate != null) {
      $result.utxoUpdate = utxoUpdate;
    }
    if (logout != null) {
      $result.logout = logout;
    }
    if (login != null) {
      $result.login = login;
    }
    if (tokenMarketOrder != null) {
      $result.tokenMarketOrder = tokenMarketOrder;
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
    if (createPayjoinResult != null) {
      $result.createPayjoinResult = createPayjoinResult;
    }
    if (loadUtxos != null) {
      $result.loadUtxos = loadUtxos;
    }
    if (loadAddresses != null) {
      $result.loadAddresses = loadAddresses;
    }
    if (registerPhone != null) {
      $result.registerPhone = registerPhone;
    }
    if (verifyPhone != null) {
      $result.verifyPhone = verifyPhone;
    }
    if (uploadAvatar != null) {
      $result.uploadAvatar = uploadAvatar;
    }
    if (uploadContacts != null) {
      $result.uploadContacts = uploadContacts;
    }
    if (contactCreated != null) {
      $result.contactCreated = contactCreated;
    }
    if (contactRemoved != null) {
      $result.contactRemoved = contactRemoved;
    }
    if (contactTransaction != null) {
      $result.contactTransaction = contactTransaction;
    }
    if (accountStatus != null) {
      $result.accountStatus = accountStatus;
    }
    if (showMessage != null) {
      $result.showMessage = showMessage;
    }
    if (submitReview != null) {
      $result.submitReview = submitReview;
    }
    if (submitResult != null) {
      $result.submitResult = submitResult;
    }
    if (editOrder != null) {
      $result.editOrder = editOrder;
    }
    if (cancelOrder != null) {
      $result.cancelOrder = cancelOrder;
    }
    if (insufficientFunds != null) {
      $result.insufficientFunds = insufficientFunds;
    }
    if (startTimer != null) {
      $result.startTimer = startTimer;
    }
    if (serverConnected != null) {
      $result.serverConnected = serverConnected;
    }
    if (serverDisconnected != null) {
      $result.serverDisconnected = serverDisconnected;
    }
    if (orderCreated != null) {
      $result.orderCreated = orderCreated;
    }
    if (orderRemoved != null) {
      $result.orderRemoved = orderRemoved;
    }
    if (indexPrice != null) {
      $result.indexPrice = indexPrice;
    }
    if (assetDetails != null) {
      $result.assetDetails = assetDetails;
    }
    if (updatePriceStream != null) {
      $result.updatePriceStream = updatePriceStream;
    }
    if (orderComplete != null) {
      $result.orderComplete = orderComplete;
    }
    if (localMessage != null) {
      $result.localMessage = localMessage;
    }
    if (marketDataSubscribe != null) {
      $result.marketDataSubscribe = marketDataSubscribe;
    }
    if (marketDataUpdate != null) {
      $result.marketDataUpdate = marketDataUpdate;
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
    15 : From_Msg.utxoUpdate,
    16 : From_Msg.logout,
    17 : From_Msg.login,
    18 : From_Msg.tokenMarketOrder,
    21 : From_Msg.peginWaitTx,
    22 : From_Msg.swapSucceed,
    23 : From_Msg.swapFailed,
    24 : From_Msg.pegOutAmount,
    30 : From_Msg.recvAddress,
    31 : From_Msg.createTxResult,
    32 : From_Msg.sendResult,
    33 : From_Msg.blindedValues,
    34 : From_Msg.createPayjoinResult,
    35 : From_Msg.loadUtxos,
    36 : From_Msg.loadAddresses,
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
    56 : From_Msg.startTimer,
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
    72 : From_Msg.portfolioPrices,
    73 : From_Msg.conversionRates,
    80 : From_Msg.jadePorts,
    83 : From_Msg.jadeStatus,
    91 : From_Msg.gaidStatus,
    0 : From_Msg.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'From', package: const $pb.PackageName(_omitMessageNames ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 21, 22, 23, 24, 30, 31, 32, 33, 34, 35, 36, 40, 41, 42, 43, 44, 45, 46, 47, 50, 51, 52, 53, 54, 55, 56, 60, 61, 62, 63, 64, 65, 66, 67, 68, 70, 71, 72, 73, 80, 83, 91])
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
    ..aOM<From_UtxoUpdate>(15, _omitFieldNames ? '' : 'utxoUpdate', subBuilder: From_UtxoUpdate.create)
    ..aOM<Empty>(16, _omitFieldNames ? '' : 'logout', subBuilder: Empty.create)
    ..aOM<From_Login>(17, _omitFieldNames ? '' : 'login', subBuilder: From_Login.create)
    ..aOM<From_TokenMarketOrder>(18, _omitFieldNames ? '' : 'tokenMarketOrder', subBuilder: From_TokenMarketOrder.create)
    ..aOM<From_PeginWaitTx>(21, _omitFieldNames ? '' : 'peginWaitTx', subBuilder: From_PeginWaitTx.create)
    ..aOM<TransItem>(22, _omitFieldNames ? '' : 'swapSucceed', subBuilder: TransItem.create)
    ..aOS(23, _omitFieldNames ? '' : 'swapFailed')
    ..aOM<From_PegOutAmount>(24, _omitFieldNames ? '' : 'pegOutAmount', subBuilder: From_PegOutAmount.create)
    ..aOM<From_RecvAddress>(30, _omitFieldNames ? '' : 'recvAddress', subBuilder: From_RecvAddress.create)
    ..aOM<From_CreateTxResult>(31, _omitFieldNames ? '' : 'createTxResult', subBuilder: From_CreateTxResult.create)
    ..aOM<From_SendResult>(32, _omitFieldNames ? '' : 'sendResult', subBuilder: From_SendResult.create)
    ..aOM<From_BlindedValues>(33, _omitFieldNames ? '' : 'blindedValues', subBuilder: From_BlindedValues.create)
    ..aOM<From_CreatePayjoinResult>(34, _omitFieldNames ? '' : 'createPayjoinResult', subBuilder: From_CreatePayjoinResult.create)
    ..aOM<From_LoadUtxos>(35, _omitFieldNames ? '' : 'loadUtxos', subBuilder: From_LoadUtxos.create)
    ..aOM<From_LoadAddresses>(36, _omitFieldNames ? '' : 'loadAddresses', subBuilder: From_LoadAddresses.create)
    ..aOM<From_RegisterPhone>(40, _omitFieldNames ? '' : 'registerPhone', subBuilder: From_RegisterPhone.create)
    ..aOM<From_VerifyPhone>(41, _omitFieldNames ? '' : 'verifyPhone', subBuilder: From_VerifyPhone.create)
    ..aOM<GenericResponse>(42, _omitFieldNames ? '' : 'uploadAvatar', subBuilder: GenericResponse.create)
    ..aOM<GenericResponse>(43, _omitFieldNames ? '' : 'uploadContacts', subBuilder: GenericResponse.create)
    ..aOM<Contact>(44, _omitFieldNames ? '' : 'contactCreated', subBuilder: Contact.create)
    ..aOM<From_ContactRemoved>(45, _omitFieldNames ? '' : 'contactRemoved', subBuilder: From_ContactRemoved.create)
    ..aOM<ContactTransaction>(46, _omitFieldNames ? '' : 'contactTransaction', subBuilder: ContactTransaction.create)
    ..aOM<From_AccountStatus>(47, _omitFieldNames ? '' : 'accountStatus', subBuilder: From_AccountStatus.create)
    ..aOM<From_ShowMessage>(50, _omitFieldNames ? '' : 'showMessage', subBuilder: From_ShowMessage.create)
    ..aOM<From_SubmitReview>(51, _omitFieldNames ? '' : 'submitReview', subBuilder: From_SubmitReview.create)
    ..aOM<From_SubmitResult>(52, _omitFieldNames ? '' : 'submitResult', subBuilder: From_SubmitResult.create)
    ..aOM<GenericResponse>(53, _omitFieldNames ? '' : 'editOrder', subBuilder: GenericResponse.create)
    ..aOM<GenericResponse>(54, _omitFieldNames ? '' : 'cancelOrder', subBuilder: GenericResponse.create)
    ..aOM<From_ShowInsufficientFunds>(55, _omitFieldNames ? '' : 'insufficientFunds', subBuilder: From_ShowInsufficientFunds.create)
    ..aOM<From_StartTimer>(56, _omitFieldNames ? '' : 'startTimer', subBuilder: From_StartTimer.create)
    ..aOM<Empty>(60, _omitFieldNames ? '' : 'serverConnected', subBuilder: Empty.create)
    ..aOM<Empty>(61, _omitFieldNames ? '' : 'serverDisconnected', subBuilder: Empty.create)
    ..aOM<From_OrderCreated>(62, _omitFieldNames ? '' : 'orderCreated', subBuilder: From_OrderCreated.create)
    ..aOM<From_OrderRemoved>(63, _omitFieldNames ? '' : 'orderRemoved', subBuilder: From_OrderRemoved.create)
    ..aOM<From_IndexPrice>(64, _omitFieldNames ? '' : 'indexPrice', subBuilder: From_IndexPrice.create)
    ..aOM<From_AssetDetails>(65, _omitFieldNames ? '' : 'assetDetails', subBuilder: From_AssetDetails.create)
    ..aOM<From_UpdatePriceStream>(66, _omitFieldNames ? '' : 'updatePriceStream', subBuilder: From_UpdatePriceStream.create)
    ..aOM<From_OrderComplete>(67, _omitFieldNames ? '' : 'orderComplete', subBuilder: From_OrderComplete.create)
    ..aOM<From_LocalMessage>(68, _omitFieldNames ? '' : 'localMessage', subBuilder: From_LocalMessage.create)
    ..aOM<From_MarketDataSubscribe>(70, _omitFieldNames ? '' : 'marketDataSubscribe', subBuilder: From_MarketDataSubscribe.create)
    ..aOM<From_MarketDataUpdate>(71, _omitFieldNames ? '' : 'marketDataUpdate', subBuilder: From_MarketDataUpdate.create)
    ..aOM<From_PortfolioPrices>(72, _omitFieldNames ? '' : 'portfolioPrices', subBuilder: From_PortfolioPrices.create)
    ..aOM<From_ConversionRates>(73, _omitFieldNames ? '' : 'conversionRates', subBuilder: From_ConversionRates.create)
    ..aOM<From_JadePorts>(80, _omitFieldNames ? '' : 'jadePorts', subBuilder: From_JadePorts.create)
    ..aOM<From_JadeStatus>(83, _omitFieldNames ? '' : 'jadeStatus', subBuilder: From_JadeStatus.create)
    ..aOM<From_GaidStatus>(91, _omitFieldNames ? '' : 'gaidStatus', subBuilder: From_GaidStatus.create)
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

  @$pb.TagNumber(16)
  Empty get logout => $_getN(15);
  @$pb.TagNumber(16)
  set logout(Empty v) { setField(16, v); }
  @$pb.TagNumber(16)
  $core.bool hasLogout() => $_has(15);
  @$pb.TagNumber(16)
  void clearLogout() => clearField(16);
  @$pb.TagNumber(16)
  Empty ensureLogout() => $_ensure(15);

  @$pb.TagNumber(17)
  From_Login get login => $_getN(16);
  @$pb.TagNumber(17)
  set login(From_Login v) { setField(17, v); }
  @$pb.TagNumber(17)
  $core.bool hasLogin() => $_has(16);
  @$pb.TagNumber(17)
  void clearLogin() => clearField(17);
  @$pb.TagNumber(17)
  From_Login ensureLogin() => $_ensure(16);

  @$pb.TagNumber(18)
  From_TokenMarketOrder get tokenMarketOrder => $_getN(17);
  @$pb.TagNumber(18)
  set tokenMarketOrder(From_TokenMarketOrder v) { setField(18, v); }
  @$pb.TagNumber(18)
  $core.bool hasTokenMarketOrder() => $_has(17);
  @$pb.TagNumber(18)
  void clearTokenMarketOrder() => clearField(18);
  @$pb.TagNumber(18)
  From_TokenMarketOrder ensureTokenMarketOrder() => $_ensure(17);

  @$pb.TagNumber(21)
  From_PeginWaitTx get peginWaitTx => $_getN(18);
  @$pb.TagNumber(21)
  set peginWaitTx(From_PeginWaitTx v) { setField(21, v); }
  @$pb.TagNumber(21)
  $core.bool hasPeginWaitTx() => $_has(18);
  @$pb.TagNumber(21)
  void clearPeginWaitTx() => clearField(21);
  @$pb.TagNumber(21)
  From_PeginWaitTx ensurePeginWaitTx() => $_ensure(18);

  @$pb.TagNumber(22)
  TransItem get swapSucceed => $_getN(19);
  @$pb.TagNumber(22)
  set swapSucceed(TransItem v) { setField(22, v); }
  @$pb.TagNumber(22)
  $core.bool hasSwapSucceed() => $_has(19);
  @$pb.TagNumber(22)
  void clearSwapSucceed() => clearField(22);
  @$pb.TagNumber(22)
  TransItem ensureSwapSucceed() => $_ensure(19);

  @$pb.TagNumber(23)
  $core.String get swapFailed => $_getSZ(20);
  @$pb.TagNumber(23)
  set swapFailed($core.String v) { $_setString(20, v); }
  @$pb.TagNumber(23)
  $core.bool hasSwapFailed() => $_has(20);
  @$pb.TagNumber(23)
  void clearSwapFailed() => clearField(23);

  @$pb.TagNumber(24)
  From_PegOutAmount get pegOutAmount => $_getN(21);
  @$pb.TagNumber(24)
  set pegOutAmount(From_PegOutAmount v) { setField(24, v); }
  @$pb.TagNumber(24)
  $core.bool hasPegOutAmount() => $_has(21);
  @$pb.TagNumber(24)
  void clearPegOutAmount() => clearField(24);
  @$pb.TagNumber(24)
  From_PegOutAmount ensurePegOutAmount() => $_ensure(21);

  @$pb.TagNumber(30)
  From_RecvAddress get recvAddress => $_getN(22);
  @$pb.TagNumber(30)
  set recvAddress(From_RecvAddress v) { setField(30, v); }
  @$pb.TagNumber(30)
  $core.bool hasRecvAddress() => $_has(22);
  @$pb.TagNumber(30)
  void clearRecvAddress() => clearField(30);
  @$pb.TagNumber(30)
  From_RecvAddress ensureRecvAddress() => $_ensure(22);

  @$pb.TagNumber(31)
  From_CreateTxResult get createTxResult => $_getN(23);
  @$pb.TagNumber(31)
  set createTxResult(From_CreateTxResult v) { setField(31, v); }
  @$pb.TagNumber(31)
  $core.bool hasCreateTxResult() => $_has(23);
  @$pb.TagNumber(31)
  void clearCreateTxResult() => clearField(31);
  @$pb.TagNumber(31)
  From_CreateTxResult ensureCreateTxResult() => $_ensure(23);

  @$pb.TagNumber(32)
  From_SendResult get sendResult => $_getN(24);
  @$pb.TagNumber(32)
  set sendResult(From_SendResult v) { setField(32, v); }
  @$pb.TagNumber(32)
  $core.bool hasSendResult() => $_has(24);
  @$pb.TagNumber(32)
  void clearSendResult() => clearField(32);
  @$pb.TagNumber(32)
  From_SendResult ensureSendResult() => $_ensure(24);

  @$pb.TagNumber(33)
  From_BlindedValues get blindedValues => $_getN(25);
  @$pb.TagNumber(33)
  set blindedValues(From_BlindedValues v) { setField(33, v); }
  @$pb.TagNumber(33)
  $core.bool hasBlindedValues() => $_has(25);
  @$pb.TagNumber(33)
  void clearBlindedValues() => clearField(33);
  @$pb.TagNumber(33)
  From_BlindedValues ensureBlindedValues() => $_ensure(25);

  @$pb.TagNumber(34)
  From_CreatePayjoinResult get createPayjoinResult => $_getN(26);
  @$pb.TagNumber(34)
  set createPayjoinResult(From_CreatePayjoinResult v) { setField(34, v); }
  @$pb.TagNumber(34)
  $core.bool hasCreatePayjoinResult() => $_has(26);
  @$pb.TagNumber(34)
  void clearCreatePayjoinResult() => clearField(34);
  @$pb.TagNumber(34)
  From_CreatePayjoinResult ensureCreatePayjoinResult() => $_ensure(26);

  @$pb.TagNumber(35)
  From_LoadUtxos get loadUtxos => $_getN(27);
  @$pb.TagNumber(35)
  set loadUtxos(From_LoadUtxos v) { setField(35, v); }
  @$pb.TagNumber(35)
  $core.bool hasLoadUtxos() => $_has(27);
  @$pb.TagNumber(35)
  void clearLoadUtxos() => clearField(35);
  @$pb.TagNumber(35)
  From_LoadUtxos ensureLoadUtxos() => $_ensure(27);

  @$pb.TagNumber(36)
  From_LoadAddresses get loadAddresses => $_getN(28);
  @$pb.TagNumber(36)
  set loadAddresses(From_LoadAddresses v) { setField(36, v); }
  @$pb.TagNumber(36)
  $core.bool hasLoadAddresses() => $_has(28);
  @$pb.TagNumber(36)
  void clearLoadAddresses() => clearField(36);
  @$pb.TagNumber(36)
  From_LoadAddresses ensureLoadAddresses() => $_ensure(28);

  @$pb.TagNumber(40)
  From_RegisterPhone get registerPhone => $_getN(29);
  @$pb.TagNumber(40)
  set registerPhone(From_RegisterPhone v) { setField(40, v); }
  @$pb.TagNumber(40)
  $core.bool hasRegisterPhone() => $_has(29);
  @$pb.TagNumber(40)
  void clearRegisterPhone() => clearField(40);
  @$pb.TagNumber(40)
  From_RegisterPhone ensureRegisterPhone() => $_ensure(29);

  @$pb.TagNumber(41)
  From_VerifyPhone get verifyPhone => $_getN(30);
  @$pb.TagNumber(41)
  set verifyPhone(From_VerifyPhone v) { setField(41, v); }
  @$pb.TagNumber(41)
  $core.bool hasVerifyPhone() => $_has(30);
  @$pb.TagNumber(41)
  void clearVerifyPhone() => clearField(41);
  @$pb.TagNumber(41)
  From_VerifyPhone ensureVerifyPhone() => $_ensure(30);

  @$pb.TagNumber(42)
  GenericResponse get uploadAvatar => $_getN(31);
  @$pb.TagNumber(42)
  set uploadAvatar(GenericResponse v) { setField(42, v); }
  @$pb.TagNumber(42)
  $core.bool hasUploadAvatar() => $_has(31);
  @$pb.TagNumber(42)
  void clearUploadAvatar() => clearField(42);
  @$pb.TagNumber(42)
  GenericResponse ensureUploadAvatar() => $_ensure(31);

  @$pb.TagNumber(43)
  GenericResponse get uploadContacts => $_getN(32);
  @$pb.TagNumber(43)
  set uploadContacts(GenericResponse v) { setField(43, v); }
  @$pb.TagNumber(43)
  $core.bool hasUploadContacts() => $_has(32);
  @$pb.TagNumber(43)
  void clearUploadContacts() => clearField(43);
  @$pb.TagNumber(43)
  GenericResponse ensureUploadContacts() => $_ensure(32);

  @$pb.TagNumber(44)
  Contact get contactCreated => $_getN(33);
  @$pb.TagNumber(44)
  set contactCreated(Contact v) { setField(44, v); }
  @$pb.TagNumber(44)
  $core.bool hasContactCreated() => $_has(33);
  @$pb.TagNumber(44)
  void clearContactCreated() => clearField(44);
  @$pb.TagNumber(44)
  Contact ensureContactCreated() => $_ensure(33);

  @$pb.TagNumber(45)
  From_ContactRemoved get contactRemoved => $_getN(34);
  @$pb.TagNumber(45)
  set contactRemoved(From_ContactRemoved v) { setField(45, v); }
  @$pb.TagNumber(45)
  $core.bool hasContactRemoved() => $_has(34);
  @$pb.TagNumber(45)
  void clearContactRemoved() => clearField(45);
  @$pb.TagNumber(45)
  From_ContactRemoved ensureContactRemoved() => $_ensure(34);

  @$pb.TagNumber(46)
  ContactTransaction get contactTransaction => $_getN(35);
  @$pb.TagNumber(46)
  set contactTransaction(ContactTransaction v) { setField(46, v); }
  @$pb.TagNumber(46)
  $core.bool hasContactTransaction() => $_has(35);
  @$pb.TagNumber(46)
  void clearContactTransaction() => clearField(46);
  @$pb.TagNumber(46)
  ContactTransaction ensureContactTransaction() => $_ensure(35);

  @$pb.TagNumber(47)
  From_AccountStatus get accountStatus => $_getN(36);
  @$pb.TagNumber(47)
  set accountStatus(From_AccountStatus v) { setField(47, v); }
  @$pb.TagNumber(47)
  $core.bool hasAccountStatus() => $_has(36);
  @$pb.TagNumber(47)
  void clearAccountStatus() => clearField(47);
  @$pb.TagNumber(47)
  From_AccountStatus ensureAccountStatus() => $_ensure(36);

  @$pb.TagNumber(50)
  From_ShowMessage get showMessage => $_getN(37);
  @$pb.TagNumber(50)
  set showMessage(From_ShowMessage v) { setField(50, v); }
  @$pb.TagNumber(50)
  $core.bool hasShowMessage() => $_has(37);
  @$pb.TagNumber(50)
  void clearShowMessage() => clearField(50);
  @$pb.TagNumber(50)
  From_ShowMessage ensureShowMessage() => $_ensure(37);

  @$pb.TagNumber(51)
  From_SubmitReview get submitReview => $_getN(38);
  @$pb.TagNumber(51)
  set submitReview(From_SubmitReview v) { setField(51, v); }
  @$pb.TagNumber(51)
  $core.bool hasSubmitReview() => $_has(38);
  @$pb.TagNumber(51)
  void clearSubmitReview() => clearField(51);
  @$pb.TagNumber(51)
  From_SubmitReview ensureSubmitReview() => $_ensure(38);

  @$pb.TagNumber(52)
  From_SubmitResult get submitResult => $_getN(39);
  @$pb.TagNumber(52)
  set submitResult(From_SubmitResult v) { setField(52, v); }
  @$pb.TagNumber(52)
  $core.bool hasSubmitResult() => $_has(39);
  @$pb.TagNumber(52)
  void clearSubmitResult() => clearField(52);
  @$pb.TagNumber(52)
  From_SubmitResult ensureSubmitResult() => $_ensure(39);

  @$pb.TagNumber(53)
  GenericResponse get editOrder => $_getN(40);
  @$pb.TagNumber(53)
  set editOrder(GenericResponse v) { setField(53, v); }
  @$pb.TagNumber(53)
  $core.bool hasEditOrder() => $_has(40);
  @$pb.TagNumber(53)
  void clearEditOrder() => clearField(53);
  @$pb.TagNumber(53)
  GenericResponse ensureEditOrder() => $_ensure(40);

  @$pb.TagNumber(54)
  GenericResponse get cancelOrder => $_getN(41);
  @$pb.TagNumber(54)
  set cancelOrder(GenericResponse v) { setField(54, v); }
  @$pb.TagNumber(54)
  $core.bool hasCancelOrder() => $_has(41);
  @$pb.TagNumber(54)
  void clearCancelOrder() => clearField(54);
  @$pb.TagNumber(54)
  GenericResponse ensureCancelOrder() => $_ensure(41);

  @$pb.TagNumber(55)
  From_ShowInsufficientFunds get insufficientFunds => $_getN(42);
  @$pb.TagNumber(55)
  set insufficientFunds(From_ShowInsufficientFunds v) { setField(55, v); }
  @$pb.TagNumber(55)
  $core.bool hasInsufficientFunds() => $_has(42);
  @$pb.TagNumber(55)
  void clearInsufficientFunds() => clearField(55);
  @$pb.TagNumber(55)
  From_ShowInsufficientFunds ensureInsufficientFunds() => $_ensure(42);

  @$pb.TagNumber(56)
  From_StartTimer get startTimer => $_getN(43);
  @$pb.TagNumber(56)
  set startTimer(From_StartTimer v) { setField(56, v); }
  @$pb.TagNumber(56)
  $core.bool hasStartTimer() => $_has(43);
  @$pb.TagNumber(56)
  void clearStartTimer() => clearField(56);
  @$pb.TagNumber(56)
  From_StartTimer ensureStartTimer() => $_ensure(43);

  @$pb.TagNumber(60)
  Empty get serverConnected => $_getN(44);
  @$pb.TagNumber(60)
  set serverConnected(Empty v) { setField(60, v); }
  @$pb.TagNumber(60)
  $core.bool hasServerConnected() => $_has(44);
  @$pb.TagNumber(60)
  void clearServerConnected() => clearField(60);
  @$pb.TagNumber(60)
  Empty ensureServerConnected() => $_ensure(44);

  @$pb.TagNumber(61)
  Empty get serverDisconnected => $_getN(45);
  @$pb.TagNumber(61)
  set serverDisconnected(Empty v) { setField(61, v); }
  @$pb.TagNumber(61)
  $core.bool hasServerDisconnected() => $_has(45);
  @$pb.TagNumber(61)
  void clearServerDisconnected() => clearField(61);
  @$pb.TagNumber(61)
  Empty ensureServerDisconnected() => $_ensure(45);

  @$pb.TagNumber(62)
  From_OrderCreated get orderCreated => $_getN(46);
  @$pb.TagNumber(62)
  set orderCreated(From_OrderCreated v) { setField(62, v); }
  @$pb.TagNumber(62)
  $core.bool hasOrderCreated() => $_has(46);
  @$pb.TagNumber(62)
  void clearOrderCreated() => clearField(62);
  @$pb.TagNumber(62)
  From_OrderCreated ensureOrderCreated() => $_ensure(46);

  @$pb.TagNumber(63)
  From_OrderRemoved get orderRemoved => $_getN(47);
  @$pb.TagNumber(63)
  set orderRemoved(From_OrderRemoved v) { setField(63, v); }
  @$pb.TagNumber(63)
  $core.bool hasOrderRemoved() => $_has(47);
  @$pb.TagNumber(63)
  void clearOrderRemoved() => clearField(63);
  @$pb.TagNumber(63)
  From_OrderRemoved ensureOrderRemoved() => $_ensure(47);

  @$pb.TagNumber(64)
  From_IndexPrice get indexPrice => $_getN(48);
  @$pb.TagNumber(64)
  set indexPrice(From_IndexPrice v) { setField(64, v); }
  @$pb.TagNumber(64)
  $core.bool hasIndexPrice() => $_has(48);
  @$pb.TagNumber(64)
  void clearIndexPrice() => clearField(64);
  @$pb.TagNumber(64)
  From_IndexPrice ensureIndexPrice() => $_ensure(48);

  @$pb.TagNumber(65)
  From_AssetDetails get assetDetails => $_getN(49);
  @$pb.TagNumber(65)
  set assetDetails(From_AssetDetails v) { setField(65, v); }
  @$pb.TagNumber(65)
  $core.bool hasAssetDetails() => $_has(49);
  @$pb.TagNumber(65)
  void clearAssetDetails() => clearField(65);
  @$pb.TagNumber(65)
  From_AssetDetails ensureAssetDetails() => $_ensure(49);

  @$pb.TagNumber(66)
  From_UpdatePriceStream get updatePriceStream => $_getN(50);
  @$pb.TagNumber(66)
  set updatePriceStream(From_UpdatePriceStream v) { setField(66, v); }
  @$pb.TagNumber(66)
  $core.bool hasUpdatePriceStream() => $_has(50);
  @$pb.TagNumber(66)
  void clearUpdatePriceStream() => clearField(66);
  @$pb.TagNumber(66)
  From_UpdatePriceStream ensureUpdatePriceStream() => $_ensure(50);

  @$pb.TagNumber(67)
  From_OrderComplete get orderComplete => $_getN(51);
  @$pb.TagNumber(67)
  set orderComplete(From_OrderComplete v) { setField(67, v); }
  @$pb.TagNumber(67)
  $core.bool hasOrderComplete() => $_has(51);
  @$pb.TagNumber(67)
  void clearOrderComplete() => clearField(67);
  @$pb.TagNumber(67)
  From_OrderComplete ensureOrderComplete() => $_ensure(51);

  @$pb.TagNumber(68)
  From_LocalMessage get localMessage => $_getN(52);
  @$pb.TagNumber(68)
  set localMessage(From_LocalMessage v) { setField(68, v); }
  @$pb.TagNumber(68)
  $core.bool hasLocalMessage() => $_has(52);
  @$pb.TagNumber(68)
  void clearLocalMessage() => clearField(68);
  @$pb.TagNumber(68)
  From_LocalMessage ensureLocalMessage() => $_ensure(52);

  @$pb.TagNumber(70)
  From_MarketDataSubscribe get marketDataSubscribe => $_getN(53);
  @$pb.TagNumber(70)
  set marketDataSubscribe(From_MarketDataSubscribe v) { setField(70, v); }
  @$pb.TagNumber(70)
  $core.bool hasMarketDataSubscribe() => $_has(53);
  @$pb.TagNumber(70)
  void clearMarketDataSubscribe() => clearField(70);
  @$pb.TagNumber(70)
  From_MarketDataSubscribe ensureMarketDataSubscribe() => $_ensure(53);

  @$pb.TagNumber(71)
  From_MarketDataUpdate get marketDataUpdate => $_getN(54);
  @$pb.TagNumber(71)
  set marketDataUpdate(From_MarketDataUpdate v) { setField(71, v); }
  @$pb.TagNumber(71)
  $core.bool hasMarketDataUpdate() => $_has(54);
  @$pb.TagNumber(71)
  void clearMarketDataUpdate() => clearField(71);
  @$pb.TagNumber(71)
  From_MarketDataUpdate ensureMarketDataUpdate() => $_ensure(54);

  @$pb.TagNumber(72)
  From_PortfolioPrices get portfolioPrices => $_getN(55);
  @$pb.TagNumber(72)
  set portfolioPrices(From_PortfolioPrices v) { setField(72, v); }
  @$pb.TagNumber(72)
  $core.bool hasPortfolioPrices() => $_has(55);
  @$pb.TagNumber(72)
  void clearPortfolioPrices() => clearField(72);
  @$pb.TagNumber(72)
  From_PortfolioPrices ensurePortfolioPrices() => $_ensure(55);

  @$pb.TagNumber(73)
  From_ConversionRates get conversionRates => $_getN(56);
  @$pb.TagNumber(73)
  set conversionRates(From_ConversionRates v) { setField(73, v); }
  @$pb.TagNumber(73)
  $core.bool hasConversionRates() => $_has(56);
  @$pb.TagNumber(73)
  void clearConversionRates() => clearField(73);
  @$pb.TagNumber(73)
  From_ConversionRates ensureConversionRates() => $_ensure(56);

  @$pb.TagNumber(80)
  From_JadePorts get jadePorts => $_getN(57);
  @$pb.TagNumber(80)
  set jadePorts(From_JadePorts v) { setField(80, v); }
  @$pb.TagNumber(80)
  $core.bool hasJadePorts() => $_has(57);
  @$pb.TagNumber(80)
  void clearJadePorts() => clearField(80);
  @$pb.TagNumber(80)
  From_JadePorts ensureJadePorts() => $_ensure(57);

  @$pb.TagNumber(83)
  From_JadeStatus get jadeStatus => $_getN(58);
  @$pb.TagNumber(83)
  set jadeStatus(From_JadeStatus v) { setField(83, v); }
  @$pb.TagNumber(83)
  $core.bool hasJadeStatus() => $_has(58);
  @$pb.TagNumber(83)
  void clearJadeStatus() => clearField(83);
  @$pb.TagNumber(83)
  From_JadeStatus ensureJadeStatus() => $_ensure(58);

  @$pb.TagNumber(91)
  From_GaidStatus get gaidStatus => $_getN(59);
  @$pb.TagNumber(91)
  set gaidStatus(From_GaidStatus v) { setField(91, v); }
  @$pb.TagNumber(91)
  $core.bool hasGaidStatus() => $_has(59);
  @$pb.TagNumber(91)
  void clearGaidStatus() => clearField(91);
  @$pb.TagNumber(91)
  From_GaidStatus ensureGaidStatus() => $_ensure(59);
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
