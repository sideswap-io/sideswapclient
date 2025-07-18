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

import 'package:protobuf/protobuf.dart' as $pb;

class Account extends $pb.ProtobufEnum {
  static const Account REG = Account._(1, _omitEnumNames ? '' : 'REG');
  static const Account AMP_ = Account._(2, _omitEnumNames ? '' : 'AMP_');

  static const $core.List<Account> values = <Account> [
    REG,
    AMP_,
  ];

  static final $core.Map<$core.int, Account> _byValue = $pb.ProtobufEnum.initByValue(values);
  static Account? valueOf($core.int value) => _byValue[value];

  const Account._($core.int v, $core.String n) : super(v, n);
}

class ScriptType extends $pb.ProtobufEnum {
  static const ScriptType P2WPKH = ScriptType._(1, _omitEnumNames ? '' : 'P2WPKH');
  static const ScriptType P2SH = ScriptType._(2, _omitEnumNames ? '' : 'P2SH');

  static const $core.List<ScriptType> values = <ScriptType> [
    P2WPKH,
    P2SH,
  ];

  static final $core.Map<$core.int, ScriptType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ScriptType? valueOf($core.int value) => _byValue[value];

  const ScriptType._($core.int v, $core.String n) : super(v, n);
}

class ActivePage extends $pb.ProtobufEnum {
  static const ActivePage OTHER = ActivePage._(0, _omitEnumNames ? '' : 'OTHER');
  static const ActivePage PEG_IN = ActivePage._(1, _omitEnumNames ? '' : 'PEG_IN');
  static const ActivePage PEG_OUT = ActivePage._(2, _omitEnumNames ? '' : 'PEG_OUT');

  static const $core.List<ActivePage> values = <ActivePage> [
    OTHER,
    PEG_IN,
    PEG_OUT,
  ];

  static final $core.Map<$core.int, ActivePage> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ActivePage? valueOf($core.int value) => _byValue[value];

  const ActivePage._($core.int v, $core.String n) : super(v, n);
}

class AssetType extends $pb.ProtobufEnum {
  static const AssetType BASE = AssetType._(1, _omitEnumNames ? '' : 'BASE');
  static const AssetType QUOTE = AssetType._(2, _omitEnumNames ? '' : 'QUOTE');

  static const $core.List<AssetType> values = <AssetType> [
    BASE,
    QUOTE,
  ];

  static final $core.Map<$core.int, AssetType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static AssetType? valueOf($core.int value) => _byValue[value];

  const AssetType._($core.int v, $core.String n) : super(v, n);
}

class MarketType_ extends $pb.ProtobufEnum {
  static const MarketType_ STABLECOIN = MarketType_._(1, _omitEnumNames ? '' : 'STABLECOIN');
  static const MarketType_ AMP = MarketType_._(2, _omitEnumNames ? '' : 'AMP');
  static const MarketType_ TOKEN = MarketType_._(3, _omitEnumNames ? '' : 'TOKEN');

  static const $core.List<MarketType_> values = <MarketType_> [
    STABLECOIN,
    AMP,
    TOKEN,
  ];

  static final $core.Map<$core.int, MarketType_> _byValue = $pb.ProtobufEnum.initByValue(values);
  static MarketType_? valueOf($core.int value) => _byValue[value];

  const MarketType_._($core.int v, $core.String n) : super(v, n);
}

class TradeDir extends $pb.ProtobufEnum {
  static const TradeDir SELL = TradeDir._(1, _omitEnumNames ? '' : 'SELL');
  static const TradeDir BUY = TradeDir._(2, _omitEnumNames ? '' : 'BUY');

  static const $core.List<TradeDir> values = <TradeDir> [
    SELL,
    BUY,
  ];

  static final $core.Map<$core.int, TradeDir> _byValue = $pb.ProtobufEnum.initByValue(values);
  static TradeDir? valueOf($core.int value) => _byValue[value];

  const TradeDir._($core.int v, $core.String n) : super(v, n);
}

class HistStatus extends $pb.ProtobufEnum {
  static const HistStatus MEMPOOL = HistStatus._(1, _omitEnumNames ? '' : 'MEMPOOL');
  static const HistStatus CONFIRMED = HistStatus._(2, _omitEnumNames ? '' : 'CONFIRMED');
  static const HistStatus TX_CONFLICT = HistStatus._(3, _omitEnumNames ? '' : 'TX_CONFLICT');
  static const HistStatus TX_NOT_FOUND = HistStatus._(4, _omitEnumNames ? '' : 'TX_NOT_FOUND');
  static const HistStatus ELAPSED = HistStatus._(5, _omitEnumNames ? '' : 'ELAPSED');
  static const HistStatus CANCELLED = HistStatus._(6, _omitEnumNames ? '' : 'CANCELLED');
  static const HistStatus UTXO_INVALIDATED = HistStatus._(7, _omitEnumNames ? '' : 'UTXO_INVALIDATED');
  static const HistStatus REPLACED = HistStatus._(8, _omitEnumNames ? '' : 'REPLACED');

  static const $core.List<HistStatus> values = <HistStatus> [
    MEMPOOL,
    CONFIRMED,
    TX_CONFLICT,
    TX_NOT_FOUND,
    ELAPSED,
    CANCELLED,
    UTXO_INVALIDATED,
    REPLACED,
  ];

  static final $core.Map<$core.int, HistStatus> _byValue = $pb.ProtobufEnum.initByValue(values);
  static HistStatus? valueOf($core.int value) => _byValue[value];

  const HistStatus._($core.int v, $core.String n) : super(v, n);
}

class From_DecryptPin_ErrorCode extends $pb.ProtobufEnum {
  static const From_DecryptPin_ErrorCode WRONG_PIN = From_DecryptPin_ErrorCode._(1, _omitEnumNames ? '' : 'WRONG_PIN');
  static const From_DecryptPin_ErrorCode NETWORK_ERROR = From_DecryptPin_ErrorCode._(2, _omitEnumNames ? '' : 'NETWORK_ERROR');
  static const From_DecryptPin_ErrorCode INVALID_DATA = From_DecryptPin_ErrorCode._(3, _omitEnumNames ? '' : 'INVALID_DATA');

  static const $core.List<From_DecryptPin_ErrorCode> values = <From_DecryptPin_ErrorCode> [
    WRONG_PIN,
    NETWORK_ERROR,
    INVALID_DATA,
  ];

  static final $core.Map<$core.int, From_DecryptPin_ErrorCode> _byValue = $pb.ProtobufEnum.initByValue(values);
  static From_DecryptPin_ErrorCode? valueOf($core.int value) => _byValue[value];

  const From_DecryptPin_ErrorCode._($core.int v, $core.String n) : super(v, n);
}

class From_JadeStatus_Status extends $pb.ProtobufEnum {
  static const From_JadeStatus_Status CONNECTING = From_JadeStatus_Status._(9, _omitEnumNames ? '' : 'CONNECTING');
  static const From_JadeStatus_Status IDLE = From_JadeStatus_Status._(1, _omitEnumNames ? '' : 'IDLE');
  static const From_JadeStatus_Status READ_STATUS = From_JadeStatus_Status._(2, _omitEnumNames ? '' : 'READ_STATUS');
  static const From_JadeStatus_Status AUTH_USER = From_JadeStatus_Status._(3, _omitEnumNames ? '' : 'AUTH_USER');
  static const From_JadeStatus_Status MASTER_BLINDING_KEY = From_JadeStatus_Status._(5, _omitEnumNames ? '' : 'MASTER_BLINDING_KEY');
  static const From_JadeStatus_Status SIGN_MESSAGE = From_JadeStatus_Status._(10, _omitEnumNames ? '' : 'SIGN_MESSAGE');
  static const From_JadeStatus_Status SIGN_TX = From_JadeStatus_Status._(4, _omitEnumNames ? '' : 'SIGN_TX');
  static const From_JadeStatus_Status SIGN_SWAP = From_JadeStatus_Status._(8, _omitEnumNames ? '' : 'SIGN_SWAP');
  static const From_JadeStatus_Status SIGN_SWAP_OUTPUT = From_JadeStatus_Status._(6, _omitEnumNames ? '' : 'SIGN_SWAP_OUTPUT');
  static const From_JadeStatus_Status SIGN_OFFLINE_SWAP = From_JadeStatus_Status._(7, _omitEnumNames ? '' : 'SIGN_OFFLINE_SWAP');

  static const $core.List<From_JadeStatus_Status> values = <From_JadeStatus_Status> [
    CONNECTING,
    IDLE,
    READ_STATUS,
    AUTH_USER,
    MASTER_BLINDING_KEY,
    SIGN_MESSAGE,
    SIGN_TX,
    SIGN_SWAP,
    SIGN_SWAP_OUTPUT,
    SIGN_OFFLINE_SWAP,
  ];

  static final $core.Map<$core.int, From_JadeStatus_Status> _byValue = $pb.ProtobufEnum.initByValue(values);
  static From_JadeStatus_Status? valueOf($core.int value) => _byValue[value];

  const From_JadeStatus_Status._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
