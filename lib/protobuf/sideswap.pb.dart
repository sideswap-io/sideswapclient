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

class Asset extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Asset', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'assetId')
    ..aQS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
    ..aQS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ticker')
    ..aQS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'icon')
    ..a<$core.int>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'precision', $pb.PbFieldType.QU3)
  ;

  Asset._() : super();
  factory Asset({
    $core.String? assetId,
    $core.String? name,
    $core.String? ticker,
    $core.String? icon,
    $core.int? precision,
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
}

class Tx extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Tx', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..pc<Balance>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'balances', $pb.PbFieldType.PM, subBuilder: Balance.create)
    ..aQS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'txid')
    ..a<$fixnum.Int64>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'networkFee', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aQS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'memo')
  ;

  Tx._() : super();
  factory Tx({
    $core.Iterable<Balance>? balances,
    $core.String? txid,
    $fixnum.Int64? networkFee,
    $core.String? memo,
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
}

class Peg extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Peg', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..a<$core.bool>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'isPegIn', $pb.PbFieldType.QB)
    ..a<$fixnum.Int64>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'amountSend', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'amountRecv', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aQS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'addrSend')
    ..aQS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'addrRecv')
    ..aQS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'txidSend')
    ..a<$core.int>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'voutSend', $pb.PbFieldType.Q3)
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
    $core.int? voutSend,
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
    if (voutSend != null) {
      _result.voutSend = voutSend;
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

  @$pb.TagNumber(7)
  $core.int get voutSend => $_getIZ(6);
  @$pb.TagNumber(7)
  set voutSend($core.int v) { $_setSignedInt32(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasVoutSend() => $_has(6);
  @$pb.TagNumber(7)
  void clearVoutSend() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get txidRecv => $_getSZ(7);
  @$pb.TagNumber(8)
  set txidRecv($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasTxidRecv() => $_has(7);
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

class Contact extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Contact', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
    ..aQS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'phone')
  ;

  Contact._() : super();
  factory Contact({
    $core.String? name,
    $core.String? phone,
  }) {
    final _result = create();
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
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get phone => $_getSZ(1);
  @$pb.TagNumber(2)
  set phone($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPhone() => $_has(1);
  @$pb.TagNumber(2)
  void clearPhone() => clearField(2);
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
}

class To_Login extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'To.Login', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'mnemonic')
  ;

  To_Login._() : super();
  factory To_Login({
    $core.String? mnemonic,
  }) {
    final _result = create();
    if (mnemonic != null) {
      _result.mnemonic = mnemonic;
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

class To_SwapRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'To.SwapRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sendAsset')
    ..aQS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'recvAsset')
    ..a<$fixnum.Int64>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sendAmount', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.int>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'blocks', $pb.PbFieldType.O3)
  ;

  To_SwapRequest._() : super();
  factory To_SwapRequest({
    $core.String? sendAsset,
    $core.String? recvAsset,
    $fixnum.Int64? sendAmount,
    $core.int? blocks,
  }) {
    final _result = create();
    if (sendAsset != null) {
      _result.sendAsset = sendAsset;
    }
    if (recvAsset != null) {
      _result.recvAsset = recvAsset;
    }
    if (sendAmount != null) {
      _result.sendAmount = sendAmount;
    }
    if (blocks != null) {
      _result.blocks = blocks;
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

  @$pb.TagNumber(2)
  $core.String get sendAsset => $_getSZ(0);
  @$pb.TagNumber(2)
  set sendAsset($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(2)
  $core.bool hasSendAsset() => $_has(0);
  @$pb.TagNumber(2)
  void clearSendAsset() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get recvAsset => $_getSZ(1);
  @$pb.TagNumber(3)
  set recvAsset($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(3)
  $core.bool hasRecvAsset() => $_has(1);
  @$pb.TagNumber(3)
  void clearRecvAsset() => clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get sendAmount => $_getI64(2);
  @$pb.TagNumber(4)
  set sendAmount($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(4)
  $core.bool hasSendAmount() => $_has(2);
  @$pb.TagNumber(4)
  void clearSendAmount() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get blocks => $_getIZ(3);
  @$pb.TagNumber(5)
  set blocks($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(5)
  $core.bool hasBlocks() => $_has(3);
  @$pb.TagNumber(5)
  void clearBlocks() => clearField(5);
}

class To_SwapAccept extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'To.SwapAccept', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'recvAddr')
    ..aInt64(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'recvAmount')
    ..hasRequiredFields = false
  ;

  To_SwapAccept._() : super();
  factory To_SwapAccept({
    $core.String? recvAddr,
    $fixnum.Int64? recvAmount,
  }) {
    final _result = create();
    if (recvAddr != null) {
      _result.recvAddr = recvAddr;
    }
    if (recvAmount != null) {
      _result.recvAmount = recvAmount;
    }
    return _result;
  }
  factory To_SwapAccept.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory To_SwapAccept.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  To_SwapAccept clone() => To_SwapAccept()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  To_SwapAccept copyWith(void Function(To_SwapAccept) updates) => super.copyWith((message) => updates(message as To_SwapAccept)) as To_SwapAccept; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static To_SwapAccept create() => To_SwapAccept._();
  To_SwapAccept createEmptyInstance() => create();
  static $pb.PbList<To_SwapAccept> createRepeated() => $pb.PbList<To_SwapAccept>();
  @$core.pragma('dart2js:noInline')
  static To_SwapAccept getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<To_SwapAccept>(create);
  static To_SwapAccept? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get recvAddr => $_getSZ(0);
  @$pb.TagNumber(1)
  set recvAddr($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasRecvAddr() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecvAddr() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get recvAmount => $_getI64(1);
  @$pb.TagNumber(2)
  set recvAmount($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasRecvAmount() => $_has(1);
  @$pb.TagNumber(2)
  void clearRecvAmount() => clearField(2);
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

class To_CreateTx extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'To.CreateTx', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'addr')
    ..aQM<Balance>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'balance', subBuilder: Balance.create)
  ;

  To_CreateTx._() : super();
  factory To_CreateTx({
    $core.String? addr,
    Balance? balance,
  }) {
    final _result = create();
    if (addr != null) {
      _result.addr = addr;
    }
    if (balance != null) {
      _result.balance = balance;
    }
    return _result;
  }
  factory To_CreateTx.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory To_CreateTx.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  To_CreateTx clone() => To_CreateTx()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  To_CreateTx copyWith(void Function(To_CreateTx) updates) => super.copyWith((message) => updates(message as To_CreateTx)) as To_CreateTx; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static To_CreateTx create() => To_CreateTx._();
  To_CreateTx createEmptyInstance() => create();
  static $pb.PbList<To_CreateTx> createRepeated() => $pb.PbList<To_CreateTx>();
  @$core.pragma('dart2js:noInline')
  static To_CreateTx getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<To_CreateTx>(create);
  static To_CreateTx? _defaultInstance;

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
}

class To_SendTx extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'To.SendTx', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'memo')
  ;

  To_SendTx._() : super();
  factory To_SendTx({
    $core.String? memo,
  }) {
    final _result = create();
    if (memo != null) {
      _result.memo = memo;
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
  $core.String get memo => $_getSZ(0);
  @$pb.TagNumber(1)
  set memo($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMemo() => $_has(0);
  @$pb.TagNumber(1)
  void clearMemo() => clearField(1);
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

class To_UploadAvatar extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'To.UploadAvatar', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'phoneKey')
    ..aQS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'text')
  ;

  To_UploadAvatar._() : super();
  factory To_UploadAvatar({
    $core.String? phoneKey,
    $core.String? text,
  }) {
    final _result = create();
    if (phoneKey != null) {
      _result.phoneKey = phoneKey;
    }
    if (text != null) {
      _result.text = text;
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
  $core.String get text => $_getSZ(1);
  @$pb.TagNumber(2)
  set text($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasText() => $_has(1);
  @$pb.TagNumber(2)
  void clearText() => clearField(2);
}

class To_UploadContacts extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'To.UploadContacts', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'phoneKey')
    ..pc<Contact>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'contacts', $pb.PbFieldType.PM, subBuilder: Contact.create)
  ;

  To_UploadContacts._() : super();
  factory To_UploadContacts({
    $core.String? phoneKey,
    $core.Iterable<Contact>? contacts,
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
  $core.List<Contact> get contacts => $_getList(1);
}

class To_SubmitOrder extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'To.SubmitOrder', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sessionId')
    ..aQS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'assetId')
    ..a<$core.double>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'bitcoinAmount', $pb.PbFieldType.QD)
    ..a<$core.double>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'price', $pb.PbFieldType.QD)
    ..a<$core.double>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'indexPrice', $pb.PbFieldType.OD)
  ;

  To_SubmitOrder._() : super();
  factory To_SubmitOrder({
    $core.String? sessionId,
    $core.String? assetId,
    $core.double? bitcoinAmount,
    $core.double? price,
    $core.double? indexPrice,
  }) {
    final _result = create();
    if (sessionId != null) {
      _result.sessionId = sessionId;
    }
    if (assetId != null) {
      _result.assetId = assetId;
    }
    if (bitcoinAmount != null) {
      _result.bitcoinAmount = bitcoinAmount;
    }
    if (price != null) {
      _result.price = price;
    }
    if (indexPrice != null) {
      _result.indexPrice = indexPrice;
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

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get assetId => $_getSZ(1);
  @$pb.TagNumber(2)
  set assetId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAssetId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAssetId() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get bitcoinAmount => $_getN(2);
  @$pb.TagNumber(3)
  set bitcoinAmount($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasBitcoinAmount() => $_has(2);
  @$pb.TagNumber(3)
  void clearBitcoinAmount() => clearField(3);

  @$pb.TagNumber(4)
  $core.double get price => $_getN(3);
  @$pb.TagNumber(4)
  set price($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasPrice() => $_has(3);
  @$pb.TagNumber(4)
  void clearPrice() => clearField(4);

  @$pb.TagNumber(5)
  $core.double get indexPrice => $_getN(4);
  @$pb.TagNumber(5)
  set indexPrice($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasIndexPrice() => $_has(4);
  @$pb.TagNumber(5)
  void clearIndexPrice() => clearField(5);
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
  ;

  To_SubmitDecision._() : super();
  factory To_SubmitDecision({
    $core.String? orderId,
    $core.bool? accept,
    $core.bool? autoSign,
    $core.bool? private,
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
}

class To_EditOrder extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'To.EditOrder', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'orderId')
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'price', $pb.PbFieldType.QD)
  ;

  To_EditOrder._() : super();
  factory To_EditOrder({
    $core.String? orderId,
    $core.double? price,
  }) {
    final _result = create();
    if (orderId != null) {
      _result.orderId = orderId;
    }
    if (price != null) {
      _result.price = price;
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

enum To_Msg {
  login, 
  logout, 
  updatePushToken, 
  encryptPin, 
  decryptPin, 
  pushMessage, 
  setMemo, 
  getRecvAddress, 
  createTx, 
  sendTx, 
  blindedValues, 
  swapRequest, 
  swapCancel, 
  swapAccept, 
  pegRequest, 
  registerPhone, 
  verifyPhone, 
  uploadAvatar, 
  uploadContacts, 
  submitOrder, 
  linkOrder, 
  submitDecision, 
  editOrder, 
  cancelOrder, 
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
    10 : To_Msg.setMemo,
    11 : To_Msg.getRecvAddress,
    12 : To_Msg.createTx,
    13 : To_Msg.sendTx,
    14 : To_Msg.blindedValues,
    20 : To_Msg.swapRequest,
    21 : To_Msg.swapCancel,
    22 : To_Msg.swapAccept,
    23 : To_Msg.pegRequest,
    40 : To_Msg.registerPhone,
    41 : To_Msg.verifyPhone,
    42 : To_Msg.uploadAvatar,
    43 : To_Msg.uploadContacts,
    49 : To_Msg.submitOrder,
    50 : To_Msg.linkOrder,
    51 : To_Msg.submitDecision,
    52 : To_Msg.editOrder,
    53 : To_Msg.cancelOrder,
    0 : To_Msg.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'To', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4, 5, 6, 10, 11, 12, 13, 14, 20, 21, 22, 23, 40, 41, 42, 43, 49, 50, 51, 52, 53])
    ..aOM<To_Login>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'login', subBuilder: To_Login.create)
    ..aOM<Empty>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'logout', subBuilder: Empty.create)
    ..aOM<To_UpdatePushToken>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'updatePushToken', subBuilder: To_UpdatePushToken.create)
    ..aOM<To_EncryptPin>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'encryptPin', subBuilder: To_EncryptPin.create)
    ..aOM<To_DecryptPin>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'decryptPin', subBuilder: To_DecryptPin.create)
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pushMessage')
    ..aOM<To_SetMemo>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'setMemo', subBuilder: To_SetMemo.create)
    ..aOM<Empty>(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'getRecvAddress', subBuilder: Empty.create)
    ..aOM<To_CreateTx>(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'createTx', subBuilder: To_CreateTx.create)
    ..aOM<To_SendTx>(13, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sendTx', subBuilder: To_SendTx.create)
    ..aOM<To_BlindedValues>(14, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'blindedValues', subBuilder: To_BlindedValues.create)
    ..aOM<To_SwapRequest>(20, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'swapRequest', subBuilder: To_SwapRequest.create)
    ..aOM<Empty>(21, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'swapCancel', subBuilder: Empty.create)
    ..aOM<To_SwapAccept>(22, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'swapAccept', subBuilder: To_SwapAccept.create)
    ..aOM<Empty>(23, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pegRequest', subBuilder: Empty.create)
    ..aOM<To_RegisterPhone>(40, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'registerPhone', subBuilder: To_RegisterPhone.create)
    ..aOM<To_VerifyPhone>(41, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'verifyPhone', subBuilder: To_VerifyPhone.create)
    ..aOM<To_UploadAvatar>(42, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'uploadAvatar', subBuilder: To_UploadAvatar.create)
    ..aOM<To_UploadContacts>(43, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'uploadContacts', subBuilder: To_UploadContacts.create)
    ..aOM<To_SubmitOrder>(49, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'submitOrder', subBuilder: To_SubmitOrder.create)
    ..aOM<To_LinkOrder>(50, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'linkOrder', subBuilder: To_LinkOrder.create)
    ..aOM<To_SubmitDecision>(51, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'submitDecision', subBuilder: To_SubmitDecision.create)
    ..aOM<To_EditOrder>(52, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'editOrder', subBuilder: To_EditOrder.create)
    ..aOM<To_CancelOrder>(53, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'cancelOrder', subBuilder: To_CancelOrder.create)
  ;

  To._() : super();
  factory To({
    To_Login? login,
    Empty? logout,
    To_UpdatePushToken? updatePushToken,
    To_EncryptPin? encryptPin,
    To_DecryptPin? decryptPin,
    $core.String? pushMessage,
    To_SetMemo? setMemo,
    Empty? getRecvAddress,
    To_CreateTx? createTx,
    To_SendTx? sendTx,
    To_BlindedValues? blindedValues,
    To_SwapRequest? swapRequest,
    Empty? swapCancel,
    To_SwapAccept? swapAccept,
    Empty? pegRequest,
    To_RegisterPhone? registerPhone,
    To_VerifyPhone? verifyPhone,
    To_UploadAvatar? uploadAvatar,
    To_UploadContacts? uploadContacts,
    To_SubmitOrder? submitOrder,
    To_LinkOrder? linkOrder,
    To_SubmitDecision? submitDecision,
    To_EditOrder? editOrder,
    To_CancelOrder? cancelOrder,
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
    if (swapCancel != null) {
      _result.swapCancel = swapCancel;
    }
    if (swapAccept != null) {
      _result.swapAccept = swapAccept;
    }
    if (pegRequest != null) {
      _result.pegRequest = pegRequest;
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

  @$pb.TagNumber(10)
  To_SetMemo get setMemo => $_getN(6);
  @$pb.TagNumber(10)
  set setMemo(To_SetMemo v) { setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasSetMemo() => $_has(6);
  @$pb.TagNumber(10)
  void clearSetMemo() => clearField(10);
  @$pb.TagNumber(10)
  To_SetMemo ensureSetMemo() => $_ensure(6);

  @$pb.TagNumber(11)
  Empty get getRecvAddress => $_getN(7);
  @$pb.TagNumber(11)
  set getRecvAddress(Empty v) { setField(11, v); }
  @$pb.TagNumber(11)
  $core.bool hasGetRecvAddress() => $_has(7);
  @$pb.TagNumber(11)
  void clearGetRecvAddress() => clearField(11);
  @$pb.TagNumber(11)
  Empty ensureGetRecvAddress() => $_ensure(7);

  @$pb.TagNumber(12)
  To_CreateTx get createTx => $_getN(8);
  @$pb.TagNumber(12)
  set createTx(To_CreateTx v) { setField(12, v); }
  @$pb.TagNumber(12)
  $core.bool hasCreateTx() => $_has(8);
  @$pb.TagNumber(12)
  void clearCreateTx() => clearField(12);
  @$pb.TagNumber(12)
  To_CreateTx ensureCreateTx() => $_ensure(8);

  @$pb.TagNumber(13)
  To_SendTx get sendTx => $_getN(9);
  @$pb.TagNumber(13)
  set sendTx(To_SendTx v) { setField(13, v); }
  @$pb.TagNumber(13)
  $core.bool hasSendTx() => $_has(9);
  @$pb.TagNumber(13)
  void clearSendTx() => clearField(13);
  @$pb.TagNumber(13)
  To_SendTx ensureSendTx() => $_ensure(9);

  @$pb.TagNumber(14)
  To_BlindedValues get blindedValues => $_getN(10);
  @$pb.TagNumber(14)
  set blindedValues(To_BlindedValues v) { setField(14, v); }
  @$pb.TagNumber(14)
  $core.bool hasBlindedValues() => $_has(10);
  @$pb.TagNumber(14)
  void clearBlindedValues() => clearField(14);
  @$pb.TagNumber(14)
  To_BlindedValues ensureBlindedValues() => $_ensure(10);

  @$pb.TagNumber(20)
  To_SwapRequest get swapRequest => $_getN(11);
  @$pb.TagNumber(20)
  set swapRequest(To_SwapRequest v) { setField(20, v); }
  @$pb.TagNumber(20)
  $core.bool hasSwapRequest() => $_has(11);
  @$pb.TagNumber(20)
  void clearSwapRequest() => clearField(20);
  @$pb.TagNumber(20)
  To_SwapRequest ensureSwapRequest() => $_ensure(11);

  @$pb.TagNumber(21)
  Empty get swapCancel => $_getN(12);
  @$pb.TagNumber(21)
  set swapCancel(Empty v) { setField(21, v); }
  @$pb.TagNumber(21)
  $core.bool hasSwapCancel() => $_has(12);
  @$pb.TagNumber(21)
  void clearSwapCancel() => clearField(21);
  @$pb.TagNumber(21)
  Empty ensureSwapCancel() => $_ensure(12);

  @$pb.TagNumber(22)
  To_SwapAccept get swapAccept => $_getN(13);
  @$pb.TagNumber(22)
  set swapAccept(To_SwapAccept v) { setField(22, v); }
  @$pb.TagNumber(22)
  $core.bool hasSwapAccept() => $_has(13);
  @$pb.TagNumber(22)
  void clearSwapAccept() => clearField(22);
  @$pb.TagNumber(22)
  To_SwapAccept ensureSwapAccept() => $_ensure(13);

  @$pb.TagNumber(23)
  Empty get pegRequest => $_getN(14);
  @$pb.TagNumber(23)
  set pegRequest(Empty v) { setField(23, v); }
  @$pb.TagNumber(23)
  $core.bool hasPegRequest() => $_has(14);
  @$pb.TagNumber(23)
  void clearPegRequest() => clearField(23);
  @$pb.TagNumber(23)
  Empty ensurePegRequest() => $_ensure(14);

  @$pb.TagNumber(40)
  To_RegisterPhone get registerPhone => $_getN(15);
  @$pb.TagNumber(40)
  set registerPhone(To_RegisterPhone v) { setField(40, v); }
  @$pb.TagNumber(40)
  $core.bool hasRegisterPhone() => $_has(15);
  @$pb.TagNumber(40)
  void clearRegisterPhone() => clearField(40);
  @$pb.TagNumber(40)
  To_RegisterPhone ensureRegisterPhone() => $_ensure(15);

  @$pb.TagNumber(41)
  To_VerifyPhone get verifyPhone => $_getN(16);
  @$pb.TagNumber(41)
  set verifyPhone(To_VerifyPhone v) { setField(41, v); }
  @$pb.TagNumber(41)
  $core.bool hasVerifyPhone() => $_has(16);
  @$pb.TagNumber(41)
  void clearVerifyPhone() => clearField(41);
  @$pb.TagNumber(41)
  To_VerifyPhone ensureVerifyPhone() => $_ensure(16);

  @$pb.TagNumber(42)
  To_UploadAvatar get uploadAvatar => $_getN(17);
  @$pb.TagNumber(42)
  set uploadAvatar(To_UploadAvatar v) { setField(42, v); }
  @$pb.TagNumber(42)
  $core.bool hasUploadAvatar() => $_has(17);
  @$pb.TagNumber(42)
  void clearUploadAvatar() => clearField(42);
  @$pb.TagNumber(42)
  To_UploadAvatar ensureUploadAvatar() => $_ensure(17);

  @$pb.TagNumber(43)
  To_UploadContacts get uploadContacts => $_getN(18);
  @$pb.TagNumber(43)
  set uploadContacts(To_UploadContacts v) { setField(43, v); }
  @$pb.TagNumber(43)
  $core.bool hasUploadContacts() => $_has(18);
  @$pb.TagNumber(43)
  void clearUploadContacts() => clearField(43);
  @$pb.TagNumber(43)
  To_UploadContacts ensureUploadContacts() => $_ensure(18);

  @$pb.TagNumber(49)
  To_SubmitOrder get submitOrder => $_getN(19);
  @$pb.TagNumber(49)
  set submitOrder(To_SubmitOrder v) { setField(49, v); }
  @$pb.TagNumber(49)
  $core.bool hasSubmitOrder() => $_has(19);
  @$pb.TagNumber(49)
  void clearSubmitOrder() => clearField(49);
  @$pb.TagNumber(49)
  To_SubmitOrder ensureSubmitOrder() => $_ensure(19);

  @$pb.TagNumber(50)
  To_LinkOrder get linkOrder => $_getN(20);
  @$pb.TagNumber(50)
  set linkOrder(To_LinkOrder v) { setField(50, v); }
  @$pb.TagNumber(50)
  $core.bool hasLinkOrder() => $_has(20);
  @$pb.TagNumber(50)
  void clearLinkOrder() => clearField(50);
  @$pb.TagNumber(50)
  To_LinkOrder ensureLinkOrder() => $_ensure(20);

  @$pb.TagNumber(51)
  To_SubmitDecision get submitDecision => $_getN(21);
  @$pb.TagNumber(51)
  set submitDecision(To_SubmitDecision v) { setField(51, v); }
  @$pb.TagNumber(51)
  $core.bool hasSubmitDecision() => $_has(21);
  @$pb.TagNumber(51)
  void clearSubmitDecision() => clearField(51);
  @$pb.TagNumber(51)
  To_SubmitDecision ensureSubmitDecision() => $_ensure(21);

  @$pb.TagNumber(52)
  To_EditOrder get editOrder => $_getN(22);
  @$pb.TagNumber(52)
  set editOrder(To_EditOrder v) { setField(52, v); }
  @$pb.TagNumber(52)
  $core.bool hasEditOrder() => $_has(22);
  @$pb.TagNumber(52)
  void clearEditOrder() => clearField(52);
  @$pb.TagNumber(52)
  To_EditOrder ensureEditOrder() => $_ensure(22);

  @$pb.TagNumber(53)
  To_CancelOrder get cancelOrder => $_getN(23);
  @$pb.TagNumber(53)
  set cancelOrder(To_CancelOrder v) { setField(53, v); }
  @$pb.TagNumber(53)
  $core.bool hasCancelOrder() => $_has(23);
  @$pb.TagNumber(53)
  void clearCancelOrder() => clearField(53);
  @$pb.TagNumber(53)
  To_CancelOrder ensureCancelOrder() => $_ensure(23);
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

class From_RemovedTx extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'From.RemovedTx', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
  ;

  From_RemovedTx._() : super();
  factory From_RemovedTx({
    $core.String? id,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    return _result;
  }
  factory From_RemovedTx.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_RemovedTx.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_RemovedTx clone() => From_RemovedTx()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_RemovedTx copyWith(void Function(From_RemovedTx) updates) => super.copyWith((message) => updates(message as From_RemovedTx)) as From_RemovedTx; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static From_RemovedTx create() => From_RemovedTx._();
  From_RemovedTx createEmptyInstance() => create();
  static $pb.PbList<From_RemovedTx> createRepeated() => $pb.PbList<From_RemovedTx>();
  @$core.pragma('dart2js:noInline')
  static From_RemovedTx getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_RemovedTx>(create);
  static From_RemovedTx? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);
}

class From_SwapReview extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'From.SwapReview', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sendAsset')
    ..aQS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'recvAsset')
    ..a<$fixnum.Int64>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sendAmount', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aInt64(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'recvAmount')
    ..aInt64(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'networkFee')
    ..aOS(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'error')
  ;

  From_SwapReview._() : super();
  factory From_SwapReview({
    $core.String? sendAsset,
    $core.String? recvAsset,
    $fixnum.Int64? sendAmount,
    $fixnum.Int64? recvAmount,
    $fixnum.Int64? networkFee,
    $core.String? error,
  }) {
    final _result = create();
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
    if (networkFee != null) {
      _result.networkFee = networkFee;
    }
    if (error != null) {
      _result.error = error;
    }
    return _result;
  }
  factory From_SwapReview.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_SwapReview.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_SwapReview clone() => From_SwapReview()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_SwapReview copyWith(void Function(From_SwapReview) updates) => super.copyWith((message) => updates(message as From_SwapReview)) as From_SwapReview; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static From_SwapReview create() => From_SwapReview._();
  From_SwapReview createEmptyInstance() => create();
  static $pb.PbList<From_SwapReview> createRepeated() => $pb.PbList<From_SwapReview>();
  @$core.pragma('dart2js:noInline')
  static From_SwapReview getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_SwapReview>(create);
  static From_SwapReview? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sendAsset => $_getSZ(0);
  @$pb.TagNumber(1)
  set sendAsset($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSendAsset() => $_has(0);
  @$pb.TagNumber(1)
  void clearSendAsset() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get recvAsset => $_getSZ(1);
  @$pb.TagNumber(2)
  set recvAsset($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasRecvAsset() => $_has(1);
  @$pb.TagNumber(2)
  void clearRecvAsset() => clearField(2);

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
  $fixnum.Int64 get networkFee => $_getI64(4);
  @$pb.TagNumber(5)
  set networkFee($fixnum.Int64 v) { $_setInt64(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasNetworkFee() => $_has(4);
  @$pb.TagNumber(5)
  void clearNetworkFee() => clearField(5);

  @$pb.TagNumber(7)
  $core.String get error => $_getSZ(5);
  @$pb.TagNumber(7)
  set error($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(7)
  $core.bool hasError() => $_has(5);
  @$pb.TagNumber(7)
  void clearError() => clearField(7);
}

class From_SwapWaitTx extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'From.SwapWaitTx', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sendAsset')
    ..aQS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'recvAsset')
    ..aQS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pegAddr')
    ..aQS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'recvAddr')
  ;

  From_SwapWaitTx._() : super();
  factory From_SwapWaitTx({
    $core.String? sendAsset,
    $core.String? recvAsset,
    $core.String? pegAddr,
    $core.String? recvAddr,
  }) {
    final _result = create();
    if (sendAsset != null) {
      _result.sendAsset = sendAsset;
    }
    if (recvAsset != null) {
      _result.recvAsset = recvAsset;
    }
    if (pegAddr != null) {
      _result.pegAddr = pegAddr;
    }
    if (recvAddr != null) {
      _result.recvAddr = recvAddr;
    }
    return _result;
  }
  factory From_SwapWaitTx.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory From_SwapWaitTx.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  From_SwapWaitTx clone() => From_SwapWaitTx()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  From_SwapWaitTx copyWith(void Function(From_SwapWaitTx) updates) => super.copyWith((message) => updates(message as From_SwapWaitTx)) as From_SwapWaitTx; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static From_SwapWaitTx create() => From_SwapWaitTx._();
  From_SwapWaitTx createEmptyInstance() => create();
  static $pb.PbList<From_SwapWaitTx> createRepeated() => $pb.PbList<From_SwapWaitTx>();
  @$core.pragma('dart2js:noInline')
  static From_SwapWaitTx getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<From_SwapWaitTx>(create);
  static From_SwapWaitTx? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sendAsset => $_getSZ(0);
  @$pb.TagNumber(1)
  set sendAsset($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSendAsset() => $_has(0);
  @$pb.TagNumber(1)
  void clearSendAsset() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get recvAsset => $_getSZ(1);
  @$pb.TagNumber(2)
  set recvAsset($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasRecvAsset() => $_has(1);
  @$pb.TagNumber(2)
  void clearRecvAsset() => clearField(2);

  @$pb.TagNumber(5)
  $core.String get pegAddr => $_getSZ(2);
  @$pb.TagNumber(5)
  set pegAddr($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(5)
  $core.bool hasPegAddr() => $_has(2);
  @$pb.TagNumber(5)
  void clearPegAddr() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get recvAddr => $_getSZ(3);
  @$pb.TagNumber(6)
  set recvAddr($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(6)
  $core.bool hasRecvAddr() => $_has(3);
  @$pb.TagNumber(6)
  void clearRecvAddr() => clearField(6);
}

enum From_CreateTxResult_Result {
  errorMsg, 
  networkFee, 
  notSet
}

class From_CreateTxResult extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, From_CreateTxResult_Result> _From_CreateTxResult_ResultByTag = {
    1 : From_CreateTxResult_Result.errorMsg,
    2 : From_CreateTxResult_Result.networkFee,
    0 : From_CreateTxResult_Result.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'From.CreateTxResult', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'errorMsg')
    ..aInt64(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'networkFee')
    ..hasRequiredFields = false
  ;

  From_CreateTxResult._() : super();
  factory From_CreateTxResult({
    $core.String? errorMsg,
    $fixnum.Int64? networkFee,
  }) {
    final _result = create();
    if (errorMsg != null) {
      _result.errorMsg = errorMsg;
    }
    if (networkFee != null) {
      _result.networkFee = networkFee;
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
  $fixnum.Int64 get networkFee => $_getI64(1);
  @$pb.TagNumber(2)
  set networkFee($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasNetworkFee() => $_has(1);
  @$pb.TagNumber(2)
  void clearNetworkFee() => clearField(2);
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

class From_BlindedValues extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'From.BlindedValues', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..aQS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'txid')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'blindedValues')
  ;

  From_BlindedValues._() : super();
  factory From_BlindedValues({
    $core.String? txid,
    $core.String? blindedValues,
  }) {
    final _result = create();
    if (txid != null) {
      _result.txid = txid;
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

  @$pb.TagNumber(1)
  $core.String get txid => $_getSZ(0);
  @$pb.TagNumber(1)
  set txid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTxid() => $_has(0);
  @$pb.TagNumber(1)
  void clearTxid() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get blindedValues => $_getSZ(1);
  @$pb.TagNumber(2)
  set blindedValues($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasBlindedValues() => $_has(1);
  @$pb.TagNumber(2)
  void clearBlindedValues() => clearField(2);
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
    ..a<$core.bool>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'minimizeApp', $pb.PbFieldType.QB)
  ;

  From_SubmitResult._() : super();
  factory From_SubmitResult({
    Empty? submitSucceed,
    TransItem? swapSucceed,
    $core.String? error,
    $core.bool? minimizeApp,
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
    if (minimizeApp != null) {
      _result.minimizeApp = minimizeApp;
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

  @$pb.TagNumber(4)
  $core.bool get minimizeApp => $_getBF(3);
  @$pb.TagNumber(4)
  set minimizeApp($core.bool v) { $_setBool(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasMinimizeApp() => $_has(3);
  @$pb.TagNumber(4)
  void clearMinimizeApp() => clearField(4);
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

enum From_Msg {
  updatedTx, 
  removedTx, 
  newAsset, 
  balanceUpdate, 
  serverStatus, 
  priceUpdate, 
  walletLoaded, 
  encryptPin, 
  decryptPin, 
  swapReview, 
  swapWaitTx, 
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
  showMessage, 
  submitReview, 
  submitResult, 
  editOrder, 
  cancelOrder, 
  serverConnected, 
  serverDisconnected, 
  orderCreated, 
  orderRemoved, 
  notSet
}

class From extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, From_Msg> _From_MsgByTag = {
    1 : From_Msg.updatedTx,
    2 : From_Msg.removedTx,
    3 : From_Msg.newAsset,
    4 : From_Msg.balanceUpdate,
    5 : From_Msg.serverStatus,
    6 : From_Msg.priceUpdate,
    7 : From_Msg.walletLoaded,
    10 : From_Msg.encryptPin,
    11 : From_Msg.decryptPin,
    20 : From_Msg.swapReview,
    21 : From_Msg.swapWaitTx,
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
    50 : From_Msg.showMessage,
    51 : From_Msg.submitReview,
    52 : From_Msg.submitResult,
    53 : From_Msg.editOrder,
    54 : From_Msg.cancelOrder,
    60 : From_Msg.serverConnected,
    61 : From_Msg.serverDisconnected,
    62 : From_Msg.orderCreated,
    63 : From_Msg.orderRemoved,
    0 : From_Msg.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'From', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sideswap.proto'), createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4, 5, 6, 7, 10, 11, 20, 21, 22, 23, 30, 31, 32, 33, 40, 41, 42, 43, 50, 51, 52, 53, 54, 60, 61, 62, 63])
    ..aOM<TransItem>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'updatedTx', subBuilder: TransItem.create)
    ..aOM<From_RemovedTx>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'removedTx', subBuilder: From_RemovedTx.create)
    ..aOM<Asset>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'newAsset', subBuilder: Asset.create)
    ..aOM<Balance>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'balanceUpdate', subBuilder: Balance.create)
    ..aOM<ServerStatus>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'serverStatus', subBuilder: ServerStatus.create)
    ..aOM<From_PriceUpdate>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'priceUpdate', subBuilder: From_PriceUpdate.create)
    ..aOM<Empty>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'walletLoaded', subBuilder: Empty.create)
    ..aOM<From_EncryptPin>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'encryptPin', subBuilder: From_EncryptPin.create)
    ..aOM<From_DecryptPin>(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'decryptPin', subBuilder: From_DecryptPin.create)
    ..aOM<From_SwapReview>(20, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'swapReview', subBuilder: From_SwapReview.create)
    ..aOM<From_SwapWaitTx>(21, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'swapWaitTx', subBuilder: From_SwapWaitTx.create)
    ..aOM<TransItem>(22, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'swapSucceed', subBuilder: TransItem.create)
    ..aOS(23, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'swapFailed')
    ..aOM<Address>(30, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'recvAddress', subBuilder: Address.create)
    ..aOM<From_CreateTxResult>(31, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'createTxResult', subBuilder: From_CreateTxResult.create)
    ..aOM<From_SendResult>(32, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sendResult', subBuilder: From_SendResult.create)
    ..aOM<From_BlindedValues>(33, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'blindedValues', subBuilder: From_BlindedValues.create)
    ..aOM<From_RegisterPhone>(40, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'registerPhone', subBuilder: From_RegisterPhone.create)
    ..aOM<From_VerifyPhone>(41, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'verifyPhone', subBuilder: From_VerifyPhone.create)
    ..aOM<GenericResponse>(42, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'uploadAvatar', subBuilder: GenericResponse.create)
    ..aOM<GenericResponse>(43, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'uploadContacts', subBuilder: GenericResponse.create)
    ..aOM<From_ShowMessage>(50, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'showMessage', subBuilder: From_ShowMessage.create)
    ..aOM<From_SubmitReview>(51, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'submitReview', subBuilder: From_SubmitReview.create)
    ..aOM<From_SubmitResult>(52, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'submitResult', subBuilder: From_SubmitResult.create)
    ..aOM<GenericResponse>(53, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'editOrder', subBuilder: GenericResponse.create)
    ..aOM<GenericResponse>(54, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'cancelOrder', subBuilder: GenericResponse.create)
    ..aOM<Empty>(60, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'serverConnected', subBuilder: Empty.create)
    ..aOM<Empty>(61, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'serverDisconnected', subBuilder: Empty.create)
    ..aOM<Order>(62, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'orderCreated', subBuilder: Order.create)
    ..aOM<From_OrderRemoved>(63, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'orderRemoved', subBuilder: From_OrderRemoved.create)
  ;

  From._() : super();
  factory From({
    TransItem? updatedTx,
    From_RemovedTx? removedTx,
    Asset? newAsset,
    Balance? balanceUpdate,
    ServerStatus? serverStatus,
    From_PriceUpdate? priceUpdate,
    Empty? walletLoaded,
    From_EncryptPin? encryptPin,
    From_DecryptPin? decryptPin,
    From_SwapReview? swapReview,
    From_SwapWaitTx? swapWaitTx,
    TransItem? swapSucceed,
    $core.String? swapFailed,
    Address? recvAddress,
    From_CreateTxResult? createTxResult,
    From_SendResult? sendResult,
    From_BlindedValues? blindedValues,
    From_RegisterPhone? registerPhone,
    From_VerifyPhone? verifyPhone,
    GenericResponse? uploadAvatar,
    GenericResponse? uploadContacts,
    From_ShowMessage? showMessage,
    From_SubmitReview? submitReview,
    From_SubmitResult? submitResult,
    GenericResponse? editOrder,
    GenericResponse? cancelOrder,
    Empty? serverConnected,
    Empty? serverDisconnected,
    Order? orderCreated,
    From_OrderRemoved? orderRemoved,
  }) {
    final _result = create();
    if (updatedTx != null) {
      _result.updatedTx = updatedTx;
    }
    if (removedTx != null) {
      _result.removedTx = removedTx;
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
    if (encryptPin != null) {
      _result.encryptPin = encryptPin;
    }
    if (decryptPin != null) {
      _result.decryptPin = decryptPin;
    }
    if (swapReview != null) {
      _result.swapReview = swapReview;
    }
    if (swapWaitTx != null) {
      _result.swapWaitTx = swapWaitTx;
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
  TransItem get updatedTx => $_getN(0);
  @$pb.TagNumber(1)
  set updatedTx(TransItem v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasUpdatedTx() => $_has(0);
  @$pb.TagNumber(1)
  void clearUpdatedTx() => clearField(1);
  @$pb.TagNumber(1)
  TransItem ensureUpdatedTx() => $_ensure(0);

  @$pb.TagNumber(2)
  From_RemovedTx get removedTx => $_getN(1);
  @$pb.TagNumber(2)
  set removedTx(From_RemovedTx v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasRemovedTx() => $_has(1);
  @$pb.TagNumber(2)
  void clearRemovedTx() => clearField(2);
  @$pb.TagNumber(2)
  From_RemovedTx ensureRemovedTx() => $_ensure(1);

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
  Balance get balanceUpdate => $_getN(3);
  @$pb.TagNumber(4)
  set balanceUpdate(Balance v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasBalanceUpdate() => $_has(3);
  @$pb.TagNumber(4)
  void clearBalanceUpdate() => clearField(4);
  @$pb.TagNumber(4)
  Balance ensureBalanceUpdate() => $_ensure(3);

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

  @$pb.TagNumber(10)
  From_EncryptPin get encryptPin => $_getN(7);
  @$pb.TagNumber(10)
  set encryptPin(From_EncryptPin v) { setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasEncryptPin() => $_has(7);
  @$pb.TagNumber(10)
  void clearEncryptPin() => clearField(10);
  @$pb.TagNumber(10)
  From_EncryptPin ensureEncryptPin() => $_ensure(7);

  @$pb.TagNumber(11)
  From_DecryptPin get decryptPin => $_getN(8);
  @$pb.TagNumber(11)
  set decryptPin(From_DecryptPin v) { setField(11, v); }
  @$pb.TagNumber(11)
  $core.bool hasDecryptPin() => $_has(8);
  @$pb.TagNumber(11)
  void clearDecryptPin() => clearField(11);
  @$pb.TagNumber(11)
  From_DecryptPin ensureDecryptPin() => $_ensure(8);

  @$pb.TagNumber(20)
  From_SwapReview get swapReview => $_getN(9);
  @$pb.TagNumber(20)
  set swapReview(From_SwapReview v) { setField(20, v); }
  @$pb.TagNumber(20)
  $core.bool hasSwapReview() => $_has(9);
  @$pb.TagNumber(20)
  void clearSwapReview() => clearField(20);
  @$pb.TagNumber(20)
  From_SwapReview ensureSwapReview() => $_ensure(9);

  @$pb.TagNumber(21)
  From_SwapWaitTx get swapWaitTx => $_getN(10);
  @$pb.TagNumber(21)
  set swapWaitTx(From_SwapWaitTx v) { setField(21, v); }
  @$pb.TagNumber(21)
  $core.bool hasSwapWaitTx() => $_has(10);
  @$pb.TagNumber(21)
  void clearSwapWaitTx() => clearField(21);
  @$pb.TagNumber(21)
  From_SwapWaitTx ensureSwapWaitTx() => $_ensure(10);

  @$pb.TagNumber(22)
  TransItem get swapSucceed => $_getN(11);
  @$pb.TagNumber(22)
  set swapSucceed(TransItem v) { setField(22, v); }
  @$pb.TagNumber(22)
  $core.bool hasSwapSucceed() => $_has(11);
  @$pb.TagNumber(22)
  void clearSwapSucceed() => clearField(22);
  @$pb.TagNumber(22)
  TransItem ensureSwapSucceed() => $_ensure(11);

  @$pb.TagNumber(23)
  $core.String get swapFailed => $_getSZ(12);
  @$pb.TagNumber(23)
  set swapFailed($core.String v) { $_setString(12, v); }
  @$pb.TagNumber(23)
  $core.bool hasSwapFailed() => $_has(12);
  @$pb.TagNumber(23)
  void clearSwapFailed() => clearField(23);

  @$pb.TagNumber(30)
  Address get recvAddress => $_getN(13);
  @$pb.TagNumber(30)
  set recvAddress(Address v) { setField(30, v); }
  @$pb.TagNumber(30)
  $core.bool hasRecvAddress() => $_has(13);
  @$pb.TagNumber(30)
  void clearRecvAddress() => clearField(30);
  @$pb.TagNumber(30)
  Address ensureRecvAddress() => $_ensure(13);

  @$pb.TagNumber(31)
  From_CreateTxResult get createTxResult => $_getN(14);
  @$pb.TagNumber(31)
  set createTxResult(From_CreateTxResult v) { setField(31, v); }
  @$pb.TagNumber(31)
  $core.bool hasCreateTxResult() => $_has(14);
  @$pb.TagNumber(31)
  void clearCreateTxResult() => clearField(31);
  @$pb.TagNumber(31)
  From_CreateTxResult ensureCreateTxResult() => $_ensure(14);

  @$pb.TagNumber(32)
  From_SendResult get sendResult => $_getN(15);
  @$pb.TagNumber(32)
  set sendResult(From_SendResult v) { setField(32, v); }
  @$pb.TagNumber(32)
  $core.bool hasSendResult() => $_has(15);
  @$pb.TagNumber(32)
  void clearSendResult() => clearField(32);
  @$pb.TagNumber(32)
  From_SendResult ensureSendResult() => $_ensure(15);

  @$pb.TagNumber(33)
  From_BlindedValues get blindedValues => $_getN(16);
  @$pb.TagNumber(33)
  set blindedValues(From_BlindedValues v) { setField(33, v); }
  @$pb.TagNumber(33)
  $core.bool hasBlindedValues() => $_has(16);
  @$pb.TagNumber(33)
  void clearBlindedValues() => clearField(33);
  @$pb.TagNumber(33)
  From_BlindedValues ensureBlindedValues() => $_ensure(16);

  @$pb.TagNumber(40)
  From_RegisterPhone get registerPhone => $_getN(17);
  @$pb.TagNumber(40)
  set registerPhone(From_RegisterPhone v) { setField(40, v); }
  @$pb.TagNumber(40)
  $core.bool hasRegisterPhone() => $_has(17);
  @$pb.TagNumber(40)
  void clearRegisterPhone() => clearField(40);
  @$pb.TagNumber(40)
  From_RegisterPhone ensureRegisterPhone() => $_ensure(17);

  @$pb.TagNumber(41)
  From_VerifyPhone get verifyPhone => $_getN(18);
  @$pb.TagNumber(41)
  set verifyPhone(From_VerifyPhone v) { setField(41, v); }
  @$pb.TagNumber(41)
  $core.bool hasVerifyPhone() => $_has(18);
  @$pb.TagNumber(41)
  void clearVerifyPhone() => clearField(41);
  @$pb.TagNumber(41)
  From_VerifyPhone ensureVerifyPhone() => $_ensure(18);

  @$pb.TagNumber(42)
  GenericResponse get uploadAvatar => $_getN(19);
  @$pb.TagNumber(42)
  set uploadAvatar(GenericResponse v) { setField(42, v); }
  @$pb.TagNumber(42)
  $core.bool hasUploadAvatar() => $_has(19);
  @$pb.TagNumber(42)
  void clearUploadAvatar() => clearField(42);
  @$pb.TagNumber(42)
  GenericResponse ensureUploadAvatar() => $_ensure(19);

  @$pb.TagNumber(43)
  GenericResponse get uploadContacts => $_getN(20);
  @$pb.TagNumber(43)
  set uploadContacts(GenericResponse v) { setField(43, v); }
  @$pb.TagNumber(43)
  $core.bool hasUploadContacts() => $_has(20);
  @$pb.TagNumber(43)
  void clearUploadContacts() => clearField(43);
  @$pb.TagNumber(43)
  GenericResponse ensureUploadContacts() => $_ensure(20);

  @$pb.TagNumber(50)
  From_ShowMessage get showMessage => $_getN(21);
  @$pb.TagNumber(50)
  set showMessage(From_ShowMessage v) { setField(50, v); }
  @$pb.TagNumber(50)
  $core.bool hasShowMessage() => $_has(21);
  @$pb.TagNumber(50)
  void clearShowMessage() => clearField(50);
  @$pb.TagNumber(50)
  From_ShowMessage ensureShowMessage() => $_ensure(21);

  @$pb.TagNumber(51)
  From_SubmitReview get submitReview => $_getN(22);
  @$pb.TagNumber(51)
  set submitReview(From_SubmitReview v) { setField(51, v); }
  @$pb.TagNumber(51)
  $core.bool hasSubmitReview() => $_has(22);
  @$pb.TagNumber(51)
  void clearSubmitReview() => clearField(51);
  @$pb.TagNumber(51)
  From_SubmitReview ensureSubmitReview() => $_ensure(22);

  @$pb.TagNumber(52)
  From_SubmitResult get submitResult => $_getN(23);
  @$pb.TagNumber(52)
  set submitResult(From_SubmitResult v) { setField(52, v); }
  @$pb.TagNumber(52)
  $core.bool hasSubmitResult() => $_has(23);
  @$pb.TagNumber(52)
  void clearSubmitResult() => clearField(52);
  @$pb.TagNumber(52)
  From_SubmitResult ensureSubmitResult() => $_ensure(23);

  @$pb.TagNumber(53)
  GenericResponse get editOrder => $_getN(24);
  @$pb.TagNumber(53)
  set editOrder(GenericResponse v) { setField(53, v); }
  @$pb.TagNumber(53)
  $core.bool hasEditOrder() => $_has(24);
  @$pb.TagNumber(53)
  void clearEditOrder() => clearField(53);
  @$pb.TagNumber(53)
  GenericResponse ensureEditOrder() => $_ensure(24);

  @$pb.TagNumber(54)
  GenericResponse get cancelOrder => $_getN(25);
  @$pb.TagNumber(54)
  set cancelOrder(GenericResponse v) { setField(54, v); }
  @$pb.TagNumber(54)
  $core.bool hasCancelOrder() => $_has(25);
  @$pb.TagNumber(54)
  void clearCancelOrder() => clearField(54);
  @$pb.TagNumber(54)
  GenericResponse ensureCancelOrder() => $_ensure(25);

  @$pb.TagNumber(60)
  Empty get serverConnected => $_getN(26);
  @$pb.TagNumber(60)
  set serverConnected(Empty v) { setField(60, v); }
  @$pb.TagNumber(60)
  $core.bool hasServerConnected() => $_has(26);
  @$pb.TagNumber(60)
  void clearServerConnected() => clearField(60);
  @$pb.TagNumber(60)
  Empty ensureServerConnected() => $_ensure(26);

  @$pb.TagNumber(61)
  Empty get serverDisconnected => $_getN(27);
  @$pb.TagNumber(61)
  set serverDisconnected(Empty v) { setField(61, v); }
  @$pb.TagNumber(61)
  $core.bool hasServerDisconnected() => $_has(27);
  @$pb.TagNumber(61)
  void clearServerDisconnected() => clearField(61);
  @$pb.TagNumber(61)
  Empty ensureServerDisconnected() => $_ensure(27);

  @$pb.TagNumber(62)
  Order get orderCreated => $_getN(28);
  @$pb.TagNumber(62)
  set orderCreated(Order v) { setField(62, v); }
  @$pb.TagNumber(62)
  $core.bool hasOrderCreated() => $_has(28);
  @$pb.TagNumber(62)
  void clearOrderCreated() => clearField(62);
  @$pb.TagNumber(62)
  Order ensureOrderCreated() => $_ensure(28);

  @$pb.TagNumber(63)
  From_OrderRemoved get orderRemoved => $_getN(29);
  @$pb.TagNumber(63)
  set orderRemoved(From_OrderRemoved v) { setField(63, v); }
  @$pb.TagNumber(63)
  $core.bool hasOrderRemoved() => $_has(29);
  @$pb.TagNumber(63)
  void clearOrderRemoved() => clearField(63);
  @$pb.TagNumber(63)
  From_OrderRemoved ensureOrderRemoved() => $_ensure(29);
}

