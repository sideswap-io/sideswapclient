//
//  Generated code. Do not modify.
//  source: sideswap.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use accountDescriptor instead')
const Account$json = {
  '1': 'Account',
  '2': [
    {'1': 'REG', '2': 1},
    {'1': 'AMP_', '2': 2},
  ],
};

/// Descriptor for `Account`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List accountDescriptor = $convert.base64Decode(
    'CgdBY2NvdW50EgcKA1JFRxABEggKBEFNUF8QAg==');

@$core.Deprecated('Use scriptTypeDescriptor instead')
const ScriptType$json = {
  '1': 'ScriptType',
  '2': [
    {'1': 'P2WPKH', '2': 1},
    {'1': 'P2SH', '2': 2},
  ],
};

/// Descriptor for `ScriptType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List scriptTypeDescriptor = $convert.base64Decode(
    'CgpTY3JpcHRUeXBlEgoKBlAyV1BLSBABEggKBFAyU0gQAg==');

@$core.Deprecated('Use activePageDescriptor instead')
const ActivePage$json = {
  '1': 'ActivePage',
  '2': [
    {'1': 'OTHER', '2': 0},
    {'1': 'PEG_IN', '2': 1},
    {'1': 'PEG_OUT', '2': 2},
  ],
};

/// Descriptor for `ActivePage`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List activePageDescriptor = $convert.base64Decode(
    'CgpBY3RpdmVQYWdlEgkKBU9USEVSEAASCgoGUEVHX0lOEAESCwoHUEVHX09VVBAC');

@$core.Deprecated('Use assetTypeDescriptor instead')
const AssetType$json = {
  '1': 'AssetType',
  '2': [
    {'1': 'BASE', '2': 1},
    {'1': 'QUOTE', '2': 2},
  ],
};

/// Descriptor for `AssetType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List assetTypeDescriptor = $convert.base64Decode(
    'CglBc3NldFR5cGUSCAoEQkFTRRABEgkKBVFVT1RFEAI=');

@$core.Deprecated('Use marketType_Descriptor instead')
const MarketType_$json = {
  '1': 'MarketType_',
  '2': [
    {'1': 'STABLECOIN', '2': 1},
    {'1': 'AMP', '2': 2},
    {'1': 'TOKEN', '2': 3},
  ],
};

/// Descriptor for `MarketType_`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List marketType_Descriptor = $convert.base64Decode(
    'CgtNYXJrZXRUeXBlXxIOCgpTVEFCTEVDT0lOEAESBwoDQU1QEAISCQoFVE9LRU4QAw==');

@$core.Deprecated('Use tradeDirDescriptor instead')
const TradeDir$json = {
  '1': 'TradeDir',
  '2': [
    {'1': 'SELL', '2': 1},
    {'1': 'BUY', '2': 2},
  ],
};

/// Descriptor for `TradeDir`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List tradeDirDescriptor = $convert.base64Decode(
    'CghUcmFkZURpchIICgRTRUxMEAESBwoDQlVZEAI=');

@$core.Deprecated('Use histStatusDescriptor instead')
const HistStatus$json = {
  '1': 'HistStatus',
  '2': [
    {'1': 'MEMPOOL', '2': 1},
    {'1': 'CONFIRMED', '2': 2},
    {'1': 'TX_CONFLICT', '2': 3},
    {'1': 'TX_NOT_FOUND', '2': 4},
    {'1': 'ELAPSED', '2': 5},
    {'1': 'CANCELLED', '2': 6},
    {'1': 'UTXO_INVALIDATED', '2': 7},
    {'1': 'REPLACED', '2': 8},
  ],
};

/// Descriptor for `HistStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List histStatusDescriptor = $convert.base64Decode(
    'CgpIaXN0U3RhdHVzEgsKB01FTVBPT0wQARINCglDT05GSVJNRUQQAhIPCgtUWF9DT05GTElDVB'
    'ADEhAKDFRYX05PVF9GT1VORBAEEgsKB0VMQVBTRUQQBRINCglDQU5DRUxMRUQQBhIUChBVVFhP'
    'X0lOVkFMSURBVEVEEAcSDAoIUkVQTEFDRUQQCA==');

@$core.Deprecated('Use emptyDescriptor instead')
const Empty$json = {
  '1': 'Empty',
};

/// Descriptor for `Empty`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List emptyDescriptor = $convert.base64Decode(
    'CgVFbXB0eQ==');

@$core.Deprecated('Use addressDescriptor instead')
const Address$json = {
  '1': 'Address',
  '2': [
    {'1': 'addr', '3': 1, '4': 2, '5': 9, '10': 'addr'},
  ],
};

/// Descriptor for `Address`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addressDescriptor = $convert.base64Decode(
    'CgdBZGRyZXNzEhIKBGFkZHIYASACKAlSBGFkZHI=');

@$core.Deprecated('Use addressAmountDescriptor instead')
const AddressAmount$json = {
  '1': 'AddressAmount',
  '2': [
    {'1': 'address', '3': 1, '4': 2, '5': 9, '10': 'address'},
    {'1': 'amount', '3': 2, '4': 2, '5': 3, '10': 'amount'},
    {'1': 'asset_id', '3': 3, '4': 2, '5': 9, '10': 'assetId'},
  ],
};

/// Descriptor for `AddressAmount`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addressAmountDescriptor = $convert.base64Decode(
    'Cg1BZGRyZXNzQW1vdW50EhgKB2FkZHJlc3MYASACKAlSB2FkZHJlc3MSFgoGYW1vdW50GAIgAi'
    'gDUgZhbW91bnQSGQoIYXNzZXRfaWQYAyACKAlSB2Fzc2V0SWQ=');

@$core.Deprecated('Use balanceDescriptor instead')
const Balance$json = {
  '1': 'Balance',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 2, '5': 9, '10': 'assetId'},
    {'1': 'amount', '3': 2, '4': 2, '5': 3, '10': 'amount'},
  ],
};

/// Descriptor for `Balance`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List balanceDescriptor = $convert.base64Decode(
    'CgdCYWxhbmNlEhkKCGFzc2V0X2lkGAEgAigJUgdhc3NldElkEhYKBmFtb3VudBgCIAIoA1IGYW'
    '1vdW50');

@$core.Deprecated('Use ampAssetRestrictionsDescriptor instead')
const AmpAssetRestrictions$json = {
  '1': 'AmpAssetRestrictions',
  '2': [
    {'1': 'allowed_countries', '3': 1, '4': 3, '5': 9, '10': 'allowedCountries'},
  ],
};

/// Descriptor for `AmpAssetRestrictions`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ampAssetRestrictionsDescriptor = $convert.base64Decode(
    'ChRBbXBBc3NldFJlc3RyaWN0aW9ucxIrChFhbGxvd2VkX2NvdW50cmllcxgBIAMoCVIQYWxsb3'
    'dlZENvdW50cmllcw==');

@$core.Deprecated('Use assetDescriptor instead')
const Asset$json = {
  '1': 'Asset',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 2, '5': 9, '10': 'assetId'},
    {'1': 'name', '3': 2, '4': 2, '5': 9, '10': 'name'},
    {'1': 'ticker', '3': 3, '4': 2, '5': 9, '10': 'ticker'},
    {'1': 'icon', '3': 4, '4': 2, '5': 9, '10': 'icon'},
    {'1': 'precision', '3': 5, '4': 2, '5': 13, '10': 'precision'},
    {'1': 'instant_swaps', '3': 11, '4': 2, '5': 8, '10': 'instantSwaps'},
    {'1': 'swap_market', '3': 6, '4': 2, '5': 8, '10': 'swapMarket'},
    {'1': 'amp_market', '3': 9, '4': 2, '5': 8, '10': 'ampMarket'},
    {'1': 'unregistered', '3': 8, '4': 2, '5': 8, '10': 'unregistered'},
    {'1': 'domain', '3': 7, '4': 1, '5': 9, '10': 'domain'},
    {'1': 'domain_agent', '3': 10, '4': 1, '5': 9, '10': 'domainAgent'},
    {'1': 'domain_agent_link', '3': 13, '4': 1, '5': 9, '10': 'domainAgentLink'},
    {'1': 'always_show', '3': 12, '4': 1, '5': 8, '10': 'alwaysShow'},
    {'1': 'payjoin', '3': 15, '4': 1, '5': 8, '10': 'payjoin'},
    {'1': 'amp_asset_restrictions', '3': 14, '4': 1, '5': 11, '6': '.sideswap.proto.AmpAssetRestrictions', '10': 'ampAssetRestrictions'},
  ],
};

/// Descriptor for `Asset`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assetDescriptor = $convert.base64Decode(
    'CgVBc3NldBIZCghhc3NldF9pZBgBIAIoCVIHYXNzZXRJZBISCgRuYW1lGAIgAigJUgRuYW1lEh'
    'YKBnRpY2tlchgDIAIoCVIGdGlja2VyEhIKBGljb24YBCACKAlSBGljb24SHAoJcHJlY2lzaW9u'
    'GAUgAigNUglwcmVjaXNpb24SIwoNaW5zdGFudF9zd2FwcxgLIAIoCFIMaW5zdGFudFN3YXBzEh'
    '8KC3N3YXBfbWFya2V0GAYgAigIUgpzd2FwTWFya2V0Eh0KCmFtcF9tYXJrZXQYCSACKAhSCWFt'
    'cE1hcmtldBIiCgx1bnJlZ2lzdGVyZWQYCCACKAhSDHVucmVnaXN0ZXJlZBIWCgZkb21haW4YBy'
    'ABKAlSBmRvbWFpbhIhCgxkb21haW5fYWdlbnQYCiABKAlSC2RvbWFpbkFnZW50EioKEWRvbWFp'
    'bl9hZ2VudF9saW5rGA0gASgJUg9kb21haW5BZ2VudExpbmsSHwoLYWx3YXlzX3Nob3cYDCABKA'
    'hSCmFsd2F5c1Nob3cSGAoHcGF5am9pbhgPIAEoCFIHcGF5am9pbhJaChZhbXBfYXNzZXRfcmVz'
    'dHJpY3Rpb25zGA4gASgLMiQuc2lkZXN3YXAucHJvdG8uQW1wQXNzZXRSZXN0cmljdGlvbnNSFG'
    'FtcEFzc2V0UmVzdHJpY3Rpb25z');

@$core.Deprecated('Use txDescriptor instead')
const Tx$json = {
  '1': 'Tx',
  '2': [
    {'1': 'balances', '3': 1, '4': 3, '5': 11, '6': '.sideswap.proto.Balance', '10': 'balances'},
    {'1': 'txid', '3': 2, '4': 2, '5': 9, '10': 'txid'},
    {'1': 'network_fee', '3': 3, '4': 2, '5': 3, '10': 'networkFee'},
    {'1': 'vsize', '3': 6, '4': 2, '5': 3, '10': 'vsize'},
    {'1': 'memo', '3': 4, '4': 2, '5': 9, '10': 'memo'},
    {'1': 'balances_all', '3': 7, '4': 3, '5': 11, '6': '.sideswap.proto.Balance', '10': 'balancesAll'},
  ],
};

/// Descriptor for `Tx`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List txDescriptor = $convert.base64Decode(
    'CgJUeBIzCghiYWxhbmNlcxgBIAMoCzIXLnNpZGVzd2FwLnByb3RvLkJhbGFuY2VSCGJhbGFuY2'
    'VzEhIKBHR4aWQYAiACKAlSBHR4aWQSHwoLbmV0d29ya19mZWUYAyACKANSCm5ldHdvcmtGZWUS'
    'FAoFdnNpemUYBiACKANSBXZzaXplEhIKBG1lbW8YBCACKAlSBG1lbW8SOgoMYmFsYW5jZXNfYW'
    'xsGAcgAygLMhcuc2lkZXN3YXAucHJvdG8uQmFsYW5jZVILYmFsYW5jZXNBbGw=');

@$core.Deprecated('Use pegDescriptor instead')
const Peg$json = {
  '1': 'Peg',
  '2': [
    {'1': 'is_peg_in', '3': 1, '4': 2, '5': 8, '10': 'isPegIn'},
    {'1': 'amount_send', '3': 2, '4': 2, '5': 3, '10': 'amountSend'},
    {'1': 'amount_recv', '3': 3, '4': 2, '5': 3, '10': 'amountRecv'},
    {'1': 'addr_send', '3': 4, '4': 2, '5': 9, '10': 'addrSend'},
    {'1': 'addr_recv', '3': 5, '4': 2, '5': 9, '10': 'addrRecv'},
    {'1': 'txid_send', '3': 6, '4': 2, '5': 9, '10': 'txidSend'},
    {'1': 'txid_recv', '3': 8, '4': 1, '5': 9, '10': 'txidRecv'},
  ],
};

/// Descriptor for `Peg`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pegDescriptor = $convert.base64Decode(
    'CgNQZWcSGgoJaXNfcGVnX2luGAEgAigIUgdpc1BlZ0luEh8KC2Ftb3VudF9zZW5kGAIgAigDUg'
    'phbW91bnRTZW5kEh8KC2Ftb3VudF9yZWN2GAMgAigDUgphbW91bnRSZWN2EhsKCWFkZHJfc2Vu'
    'ZBgEIAIoCVIIYWRkclNlbmQSGwoJYWRkcl9yZWN2GAUgAigJUghhZGRyUmVjdhIbCgl0eGlkX3'
    'NlbmQYBiACKAlSCHR4aWRTZW5kEhsKCXR4aWRfcmVjdhgIIAEoCVIIdHhpZFJlY3Y=');

@$core.Deprecated('Use confsDescriptor instead')
const Confs$json = {
  '1': 'Confs',
  '2': [
    {'1': 'count', '3': 1, '4': 2, '5': 13, '10': 'count'},
    {'1': 'total', '3': 2, '4': 2, '5': 13, '10': 'total'},
  ],
};

/// Descriptor for `Confs`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List confsDescriptor = $convert.base64Decode(
    'CgVDb25mcxIUCgVjb3VudBgBIAIoDVIFY291bnQSFAoFdG90YWwYAiACKA1SBXRvdGFs');

@$core.Deprecated('Use transItemDescriptor instead')
const TransItem$json = {
  '1': 'TransItem',
  '2': [
    {'1': 'id', '3': 1, '4': 2, '5': 9, '10': 'id'},
    {'1': 'created_at', '3': 2, '4': 2, '5': 3, '10': 'createdAt'},
    {'1': 'confs', '3': 3, '4': 1, '5': 11, '6': '.sideswap.proto.Confs', '10': 'confs'},
    {'1': 'tx', '3': 10, '4': 1, '5': 11, '6': '.sideswap.proto.Tx', '9': 0, '10': 'tx'},
    {'1': 'peg', '3': 11, '4': 1, '5': 11, '6': '.sideswap.proto.Peg', '9': 0, '10': 'peg'},
  ],
  '8': [
    {'1': 'item'},
  ],
};

/// Descriptor for `TransItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List transItemDescriptor = $convert.base64Decode(
    'CglUcmFuc0l0ZW0SDgoCaWQYASACKAlSAmlkEh0KCmNyZWF0ZWRfYXQYAiACKANSCWNyZWF0ZW'
    'RBdBIrCgVjb25mcxgDIAEoCzIVLnNpZGVzd2FwLnByb3RvLkNvbmZzUgVjb25mcxIkCgJ0eBgK'
    'IAEoCzISLnNpZGVzd2FwLnByb3RvLlR4SABSAnR4EicKA3BlZxgLIAEoCzITLnNpZGVzd2FwLn'
    'Byb3RvLlBlZ0gAUgNwZWdCBgoEaXRlbQ==');

@$core.Deprecated('Use assetIdDescriptor instead')
const AssetId$json = {
  '1': 'AssetId',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 2, '5': 9, '10': 'assetId'},
  ],
};

/// Descriptor for `AssetId`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assetIdDescriptor = $convert.base64Decode(
    'CgdBc3NldElkEhkKCGFzc2V0X2lkGAEgAigJUgdhc3NldElk');

@$core.Deprecated('Use genericResponseDescriptor instead')
const GenericResponse$json = {
  '1': 'GenericResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 2, '5': 8, '10': 'success'},
    {'1': 'error_msg', '3': 2, '4': 1, '5': 9, '10': 'errorMsg'},
  ],
};

/// Descriptor for `GenericResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List genericResponseDescriptor = $convert.base64Decode(
    'Cg9HZW5lcmljUmVzcG9uc2USGAoHc3VjY2VzcxgBIAIoCFIHc3VjY2VzcxIbCgllcnJvcl9tc2'
    'cYAiABKAlSCGVycm9yTXNn');

@$core.Deprecated('Use feeRateDescriptor instead')
const FeeRate$json = {
  '1': 'FeeRate',
  '2': [
    {'1': 'blocks', '3': 1, '4': 2, '5': 5, '10': 'blocks'},
    {'1': 'value', '3': 2, '4': 2, '5': 1, '10': 'value'},
  ],
};

/// Descriptor for `FeeRate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List feeRateDescriptor = $convert.base64Decode(
    'CgdGZWVSYXRlEhYKBmJsb2NrcxgBIAIoBVIGYmxvY2tzEhQKBXZhbHVlGAIgAigBUgV2YWx1ZQ'
    '==');

@$core.Deprecated('Use serverStatusDescriptor instead')
const ServerStatus$json = {
  '1': 'ServerStatus',
  '2': [
    {'1': 'min_peg_in_amount', '3': 1, '4': 2, '5': 3, '10': 'minPegInAmount'},
    {'1': 'min_peg_out_amount', '3': 2, '4': 2, '5': 3, '10': 'minPegOutAmount'},
    {'1': 'server_fee_percent_peg_in', '3': 3, '4': 2, '5': 1, '10': 'serverFeePercentPegIn'},
    {'1': 'server_fee_percent_peg_out', '3': 4, '4': 2, '5': 1, '10': 'serverFeePercentPegOut'},
    {'1': 'bitcoin_fee_rates', '3': 5, '4': 3, '5': 11, '6': '.sideswap.proto.FeeRate', '10': 'bitcoinFeeRates'},
  ],
};

/// Descriptor for `ServerStatus`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serverStatusDescriptor = $convert.base64Decode(
    'CgxTZXJ2ZXJTdGF0dXMSKQoRbWluX3BlZ19pbl9hbW91bnQYASACKANSDm1pblBlZ0luQW1vdW'
    '50EisKEm1pbl9wZWdfb3V0X2Ftb3VudBgCIAIoA1IPbWluUGVnT3V0QW1vdW50EjgKGXNlcnZl'
    'cl9mZWVfcGVyY2VudF9wZWdfaW4YAyACKAFSFXNlcnZlckZlZVBlcmNlbnRQZWdJbhI6ChpzZX'
    'J2ZXJfZmVlX3BlcmNlbnRfcGVnX291dBgEIAIoAVIWc2VydmVyRmVlUGVyY2VudFBlZ091dBJD'
    'ChFiaXRjb2luX2ZlZV9yYXRlcxgFIAMoCzIXLnNpZGVzd2FwLnByb3RvLkZlZVJhdGVSD2JpdG'
    'NvaW5GZWVSYXRlcw==');

@$core.Deprecated('Use outPointDescriptor instead')
const OutPoint$json = {
  '1': 'OutPoint',
  '2': [
    {'1': 'txid', '3': 1, '4': 2, '5': 9, '10': 'txid'},
    {'1': 'vout', '3': 2, '4': 2, '5': 13, '10': 'vout'},
  ],
};

/// Descriptor for `OutPoint`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List outPointDescriptor = $convert.base64Decode(
    'CghPdXRQb2ludBISCgR0eGlkGAEgAigJUgR0eGlkEhIKBHZvdXQYAiACKA1SBHZvdXQ=');

@$core.Deprecated('Use createTxDescriptor instead')
const CreateTx$json = {
  '1': 'CreateTx',
  '2': [
    {'1': 'addressees', '3': 1, '4': 3, '5': 11, '6': '.sideswap.proto.AddressAmount', '10': 'addressees'},
    {'1': 'utxos', '3': 3, '4': 3, '5': 11, '6': '.sideswap.proto.OutPoint', '10': 'utxos'},
    {'1': 'fee_asset_id', '3': 4, '4': 1, '5': 9, '10': 'feeAssetId'},
    {'1': 'deduct_fee_output', '3': 5, '4': 1, '5': 13, '10': 'deductFeeOutput'},
  ],
};

/// Descriptor for `CreateTx`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createTxDescriptor = $convert.base64Decode(
    'CghDcmVhdGVUeBI9CgphZGRyZXNzZWVzGAEgAygLMh0uc2lkZXN3YXAucHJvdG8uQWRkcmVzc0'
    'Ftb3VudFIKYWRkcmVzc2VlcxIuCgV1dHhvcxgDIAMoCzIYLnNpZGVzd2FwLnByb3RvLk91dFBv'
    'aW50UgV1dHhvcxIgCgxmZWVfYXNzZXRfaWQYBCABKAlSCmZlZUFzc2V0SWQSKgoRZGVkdWN0X2'
    'ZlZV9vdXRwdXQYBSABKA1SD2RlZHVjdEZlZU91dHB1dA==');

@$core.Deprecated('Use createdTxDescriptor instead')
const CreatedTx$json = {
  '1': 'CreatedTx',
  '2': [
    {'1': 'id', '3': 9, '4': 2, '5': 9, '10': 'id'},
    {'1': 'req', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.CreateTx', '10': 'req'},
    {'1': 'input_count', '3': 2, '4': 2, '5': 5, '10': 'inputCount'},
    {'1': 'output_count', '3': 3, '4': 2, '5': 5, '10': 'outputCount'},
    {'1': 'size', '3': 4, '4': 2, '5': 3, '10': 'size'},
    {'1': 'vsize', '3': 7, '4': 2, '5': 3, '10': 'vsize'},
    {'1': 'discount_vsize', '3': 11, '4': 2, '5': 3, '10': 'discountVsize'},
    {'1': 'network_fee', '3': 5, '4': 2, '5': 3, '10': 'networkFee'},
    {'1': 'server_fee', '3': 10, '4': 1, '5': 3, '10': 'serverFee'},
    {'1': 'fee_per_byte', '3': 6, '4': 2, '5': 1, '10': 'feePerByte'},
    {'1': 'addressees', '3': 8, '4': 3, '5': 11, '6': '.sideswap.proto.AddressAmount', '10': 'addressees'},
  ],
};

/// Descriptor for `CreatedTx`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createdTxDescriptor = $convert.base64Decode(
    'CglDcmVhdGVkVHgSDgoCaWQYCSACKAlSAmlkEioKA3JlcRgBIAIoCzIYLnNpZGVzd2FwLnByb3'
    'RvLkNyZWF0ZVR4UgNyZXESHwoLaW5wdXRfY291bnQYAiACKAVSCmlucHV0Q291bnQSIQoMb3V0'
    'cHV0X2NvdW50GAMgAigFUgtvdXRwdXRDb3VudBISCgRzaXplGAQgAigDUgRzaXplEhQKBXZzaX'
    'plGAcgAigDUgV2c2l6ZRIlCg5kaXNjb3VudF92c2l6ZRgLIAIoA1INZGlzY291bnRWc2l6ZRIf'
    'CgtuZXR3b3JrX2ZlZRgFIAIoA1IKbmV0d29ya0ZlZRIdCgpzZXJ2ZXJfZmVlGAogASgDUglzZX'
    'J2ZXJGZWUSIAoMZmVlX3Blcl9ieXRlGAYgAigBUgpmZWVQZXJCeXRlEj0KCmFkZHJlc3NlZXMY'
    'CCADKAsyHS5zaWRlc3dhcC5wcm90by5BZGRyZXNzQW1vdW50UgphZGRyZXNzZWVz');

@$core.Deprecated('Use chartPointDescriptor instead')
const ChartPoint$json = {
  '1': 'ChartPoint',
  '2': [
    {'1': 'time', '3': 1, '4': 2, '5': 9, '10': 'time'},
    {'1': 'open', '3': 2, '4': 2, '5': 1, '10': 'open'},
    {'1': 'close', '3': 3, '4': 2, '5': 1, '10': 'close'},
    {'1': 'high', '3': 4, '4': 2, '5': 1, '10': 'high'},
    {'1': 'low', '3': 5, '4': 2, '5': 1, '10': 'low'},
    {'1': 'volume', '3': 6, '4': 2, '5': 1, '10': 'volume'},
  ],
};

/// Descriptor for `ChartPoint`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chartPointDescriptor = $convert.base64Decode(
    'CgpDaGFydFBvaW50EhIKBHRpbWUYASACKAlSBHRpbWUSEgoEb3BlbhgCIAIoAVIEb3BlbhIUCg'
    'VjbG9zZRgDIAIoAVIFY2xvc2USEgoEaGlnaBgEIAIoAVIEaGlnaBIQCgNsb3cYBSACKAFSA2xv'
    'dxIWCgZ2b2x1bWUYBiACKAFSBnZvbHVtZQ==');

@$core.Deprecated('Use assetPairDescriptor instead')
const AssetPair$json = {
  '1': 'AssetPair',
  '2': [
    {'1': 'base', '3': 1, '4': 2, '5': 9, '10': 'base'},
    {'1': 'quote', '3': 2, '4': 2, '5': 9, '10': 'quote'},
  ],
};

/// Descriptor for `AssetPair`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assetPairDescriptor = $convert.base64Decode(
    'CglBc3NldFBhaXISEgoEYmFzZRgBIAIoCVIEYmFzZRIUCgVxdW90ZRgCIAIoCVIFcXVvdGU=');

@$core.Deprecated('Use marketInfoDescriptor instead')
const MarketInfo$json = {
  '1': 'MarketInfo',
  '2': [
    {'1': 'asset_pair', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.AssetPair', '10': 'assetPair'},
    {'1': 'fee_asset', '3': 2, '4': 2, '5': 14, '6': '.sideswap.proto.AssetType', '10': 'feeAsset'},
    {'1': 'type', '3': 3, '4': 2, '5': 14, '6': '.sideswap.proto.MarketType_', '10': 'type'},
  ],
};

/// Descriptor for `MarketInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List marketInfoDescriptor = $convert.base64Decode(
    'CgpNYXJrZXRJbmZvEjgKCmFzc2V0X3BhaXIYASACKAsyGS5zaWRlc3dhcC5wcm90by5Bc3NldF'
    'BhaXJSCWFzc2V0UGFpchI2CglmZWVfYXNzZXQYAiACKA4yGS5zaWRlc3dhcC5wcm90by5Bc3Nl'
    'dFR5cGVSCGZlZUFzc2V0Ei8KBHR5cGUYAyACKA4yGy5zaWRlc3dhcC5wcm90by5NYXJrZXRUeX'
    'BlX1IEdHlwZQ==');

@$core.Deprecated('Use orderIdDescriptor instead')
const OrderId$json = {
  '1': 'OrderId',
  '2': [
    {'1': 'id', '3': 1, '4': 2, '5': 4, '10': 'id'},
  ],
};

/// Descriptor for `OrderId`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List orderIdDescriptor = $convert.base64Decode(
    'CgdPcmRlcklkEg4KAmlkGAEgAigEUgJpZA==');

@$core.Deprecated('Use publicOrderDescriptor instead')
const PublicOrder$json = {
  '1': 'PublicOrder',
  '2': [
    {'1': 'order_id', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.OrderId', '10': 'orderId'},
    {'1': 'asset_pair', '3': 2, '4': 2, '5': 11, '6': '.sideswap.proto.AssetPair', '10': 'assetPair'},
    {'1': 'trade_dir', '3': 3, '4': 2, '5': 14, '6': '.sideswap.proto.TradeDir', '10': 'tradeDir'},
    {'1': 'amount', '3': 4, '4': 2, '5': 4, '10': 'amount'},
    {'1': 'price', '3': 5, '4': 2, '5': 1, '10': 'price'},
    {'1': 'two_step', '3': 6, '4': 2, '5': 8, '10': 'twoStep'},
  ],
};

/// Descriptor for `PublicOrder`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List publicOrderDescriptor = $convert.base64Decode(
    'CgtQdWJsaWNPcmRlchIyCghvcmRlcl9pZBgBIAIoCzIXLnNpZGVzd2FwLnByb3RvLk9yZGVySW'
    'RSB29yZGVySWQSOAoKYXNzZXRfcGFpchgCIAIoCzIZLnNpZGVzd2FwLnByb3RvLkFzc2V0UGFp'
    'clIJYXNzZXRQYWlyEjUKCXRyYWRlX2RpchgDIAIoDjIYLnNpZGVzd2FwLnByb3RvLlRyYWRlRG'
    'lyUgh0cmFkZURpchIWCgZhbW91bnQYBCACKARSBmFtb3VudBIUCgVwcmljZRgFIAIoAVIFcHJp'
    'Y2USGQoIdHdvX3N0ZXAYBiACKAhSB3R3b1N0ZXA=');

@$core.Deprecated('Use ownOrderDescriptor instead')
const OwnOrder$json = {
  '1': 'OwnOrder',
  '2': [
    {'1': 'order_id', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.OrderId', '10': 'orderId'},
    {'1': 'asset_pair', '3': 2, '4': 2, '5': 11, '6': '.sideswap.proto.AssetPair', '10': 'assetPair'},
    {'1': 'trade_dir', '3': 3, '4': 2, '5': 14, '6': '.sideswap.proto.TradeDir', '10': 'tradeDir'},
    {'1': 'orig_amount', '3': 4, '4': 2, '5': 4, '10': 'origAmount'},
    {'1': 'active_amount', '3': 5, '4': 2, '5': 4, '10': 'activeAmount'},
    {'1': 'price', '3': 6, '4': 2, '5': 1, '10': 'price'},
    {'1': 'price_tracking', '3': 10, '4': 1, '5': 1, '10': 'priceTracking'},
    {'1': 'private_id', '3': 7, '4': 1, '5': 9, '10': 'privateId'},
    {'1': 'ttl_seconds', '3': 8, '4': 1, '5': 4, '10': 'ttlSeconds'},
    {'1': 'two_step', '3': 9, '4': 2, '5': 8, '10': 'twoStep'},
  ],
};

/// Descriptor for `OwnOrder`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ownOrderDescriptor = $convert.base64Decode(
    'CghPd25PcmRlchIyCghvcmRlcl9pZBgBIAIoCzIXLnNpZGVzd2FwLnByb3RvLk9yZGVySWRSB2'
    '9yZGVySWQSOAoKYXNzZXRfcGFpchgCIAIoCzIZLnNpZGVzd2FwLnByb3RvLkFzc2V0UGFpclIJ'
    'YXNzZXRQYWlyEjUKCXRyYWRlX2RpchgDIAIoDjIYLnNpZGVzd2FwLnByb3RvLlRyYWRlRGlyUg'
    'h0cmFkZURpchIfCgtvcmlnX2Ftb3VudBgEIAIoBFIKb3JpZ0Ftb3VudBIjCg1hY3RpdmVfYW1v'
    'dW50GAUgAigEUgxhY3RpdmVBbW91bnQSFAoFcHJpY2UYBiACKAFSBXByaWNlEiUKDnByaWNlX3'
    'RyYWNraW5nGAogASgBUg1wcmljZVRyYWNraW5nEh0KCnByaXZhdGVfaWQYByABKAlSCXByaXZh'
    'dGVJZBIfCgt0dGxfc2Vjb25kcxgIIAEoBFIKdHRsU2Vjb25kcxIZCgh0d29fc3RlcBgJIAIoCF'
    'IHdHdvU3RlcA==');

@$core.Deprecated('Use historyOrderDescriptor instead')
const HistoryOrder$json = {
  '1': 'HistoryOrder',
  '2': [
    {'1': 'id', '3': 1, '4': 2, '5': 4, '10': 'id'},
    {'1': 'order_id', '3': 2, '4': 2, '5': 11, '6': '.sideswap.proto.OrderId', '10': 'orderId'},
    {'1': 'asset_pair', '3': 3, '4': 2, '5': 11, '6': '.sideswap.proto.AssetPair', '10': 'assetPair'},
    {'1': 'trade_dir', '3': 4, '4': 2, '5': 14, '6': '.sideswap.proto.TradeDir', '10': 'tradeDir'},
    {'1': 'base_amount', '3': 5, '4': 2, '5': 4, '10': 'baseAmount'},
    {'1': 'quote_amount', '3': 6, '4': 2, '5': 4, '10': 'quoteAmount'},
    {'1': 'price', '3': 7, '4': 2, '5': 1, '10': 'price'},
    {'1': 'status', '3': 8, '4': 2, '5': 14, '6': '.sideswap.proto.HistStatus', '10': 'status'},
    {'1': 'txid', '3': 9, '4': 1, '5': 9, '10': 'txid'},
  ],
};

/// Descriptor for `HistoryOrder`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List historyOrderDescriptor = $convert.base64Decode(
    'CgxIaXN0b3J5T3JkZXISDgoCaWQYASACKARSAmlkEjIKCG9yZGVyX2lkGAIgAigLMhcuc2lkZX'
    'N3YXAucHJvdG8uT3JkZXJJZFIHb3JkZXJJZBI4Cgphc3NldF9wYWlyGAMgAigLMhkuc2lkZXN3'
    'YXAucHJvdG8uQXNzZXRQYWlyUglhc3NldFBhaXISNQoJdHJhZGVfZGlyGAQgAigOMhguc2lkZX'
    'N3YXAucHJvdG8uVHJhZGVEaXJSCHRyYWRlRGlyEh8KC2Jhc2VfYW1vdW50GAUgAigEUgpiYXNl'
    'QW1vdW50EiEKDHF1b3RlX2Ftb3VudBgGIAIoBFILcXVvdGVBbW91bnQSFAoFcHJpY2UYByACKA'
    'FSBXByaWNlEjIKBnN0YXR1cxgIIAIoDjIaLnNpZGVzd2FwLnByb3RvLkhpc3RTdGF0dXNSBnN0'
    'YXR1cxISCgR0eGlkGAkgASgJUgR0eGlk');

@$core.Deprecated('Use toDescriptor instead')
const To$json = {
  '1': 'To',
  '2': [
    {'1': 'login', '3': 1, '4': 1, '5': 11, '6': '.sideswap.proto.To.Login', '9': 0, '10': 'login'},
    {'1': 'logout', '3': 2, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'logout'},
    {'1': 'network_settings', '3': 9, '4': 1, '5': 11, '6': '.sideswap.proto.To.NetworkSettings', '9': 0, '10': 'networkSettings'},
    {'1': 'proxy_settings', '3': 7, '4': 1, '5': 11, '6': '.sideswap.proto.To.ProxySettings', '9': 0, '10': 'proxySettings'},
    {'1': 'update_push_token', '3': 3, '4': 1, '5': 11, '6': '.sideswap.proto.To.UpdatePushToken', '9': 0, '10': 'updatePushToken'},
    {'1': 'encrypt_pin', '3': 4, '4': 1, '5': 11, '6': '.sideswap.proto.To.EncryptPin', '9': 0, '10': 'encryptPin'},
    {'1': 'decrypt_pin', '3': 5, '4': 1, '5': 11, '6': '.sideswap.proto.To.DecryptPin', '9': 0, '10': 'decryptPin'},
    {'1': 'push_message', '3': 6, '4': 1, '5': 9, '9': 0, '10': 'pushMessage'},
    {'1': 'app_state', '3': 8, '4': 1, '5': 11, '6': '.sideswap.proto.To.AppState', '9': 0, '10': 'appState'},
    {'1': 'active_page', '3': 19, '4': 1, '5': 14, '6': '.sideswap.proto.ActivePage', '9': 0, '10': 'activePage'},
    {'1': 'set_memo', '3': 10, '4': 1, '5': 11, '6': '.sideswap.proto.To.SetMemo', '9': 0, '10': 'setMemo'},
    {'1': 'get_recv_address', '3': 11, '4': 1, '5': 14, '6': '.sideswap.proto.Account', '9': 0, '10': 'getRecvAddress'},
    {'1': 'create_tx', '3': 12, '4': 1, '5': 11, '6': '.sideswap.proto.CreateTx', '9': 0, '10': 'createTx'},
    {'1': 'send_tx', '3': 13, '4': 1, '5': 11, '6': '.sideswap.proto.To.SendTx', '9': 0, '10': 'sendTx'},
    {'1': 'blinded_values', '3': 14, '4': 1, '5': 11, '6': '.sideswap.proto.To.BlindedValues', '9': 0, '10': 'blindedValues'},
    {'1': 'load_utxos', '3': 17, '4': 1, '5': 14, '6': '.sideswap.proto.Account', '9': 0, '10': 'loadUtxos'},
    {'1': 'load_addresses', '3': 18, '4': 1, '5': 14, '6': '.sideswap.proto.Account', '9': 0, '10': 'loadAddresses'},
    {'1': 'load_transactions', '3': 20, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'loadTransactions'},
    {'1': 'show_transaction', '3': 15, '4': 1, '5': 11, '6': '.sideswap.proto.To.ShowTransaction', '9': 0, '10': 'showTransaction'},
    {'1': 'peg_in_request', '3': 21, '4': 1, '5': 11, '6': '.sideswap.proto.To.PegInRequest', '9': 0, '10': 'pegInRequest'},
    {'1': 'peg_out_amount', '3': 24, '4': 1, '5': 11, '6': '.sideswap.proto.To.PegOutAmount', '9': 0, '10': 'pegOutAmount'},
    {'1': 'peg_out_request', '3': 22, '4': 1, '5': 11, '6': '.sideswap.proto.To.PegOutRequest', '9': 0, '10': 'pegOutRequest'},
    {'1': 'asset_details', '3': 57, '4': 1, '5': 11, '6': '.sideswap.proto.AssetId', '9': 0, '10': 'assetDetails'},
    {'1': 'portfolio_prices', '3': 62, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'portfolioPrices'},
    {'1': 'conversion_rates', '3': 63, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'conversionRates'},
    {'1': 'jade_rescan', '3': 71, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'jadeRescan'},
    {'1': 'jade_unlock', '3': 72, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'jadeUnlock'},
    {'1': 'jade_verify_address', '3': 73, '4': 1, '5': 11, '6': '.sideswap.proto.Address', '9': 0, '10': 'jadeVerifyAddress'},
    {'1': 'gaid_status', '3': 81, '4': 1, '5': 11, '6': '.sideswap.proto.To.GaidStatus', '9': 0, '10': 'gaidStatus'},
    {'1': 'market_subscribe', '3': 100, '4': 1, '5': 11, '6': '.sideswap.proto.AssetPair', '9': 0, '10': 'marketSubscribe'},
    {'1': 'market_unsubscribe', '3': 101, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'marketUnsubscribe'},
    {'1': 'order_submit', '3': 102, '4': 1, '5': 11, '6': '.sideswap.proto.To.OrderSubmit', '9': 0, '10': 'orderSubmit'},
    {'1': 'order_edit', '3': 103, '4': 1, '5': 11, '6': '.sideswap.proto.To.OrderEdit', '9': 0, '10': 'orderEdit'},
    {'1': 'order_cancel', '3': 104, '4': 1, '5': 11, '6': '.sideswap.proto.To.OrderCancel', '9': 0, '10': 'orderCancel'},
    {'1': 'start_quotes', '3': 110, '4': 1, '5': 11, '6': '.sideswap.proto.To.StartQuotes', '9': 0, '10': 'startQuotes'},
    {'1': 'start_order', '3': 113, '4': 1, '5': 11, '6': '.sideswap.proto.To.StartOrder', '9': 0, '10': 'startOrder'},
    {'1': 'stop_quotes', '3': 111, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'stopQuotes'},
    {'1': 'accept_quote', '3': 112, '4': 1, '5': 11, '6': '.sideswap.proto.To.AcceptQuote', '9': 0, '10': 'acceptQuote'},
    {'1': 'charts_subscribe', '3': 120, '4': 1, '5': 11, '6': '.sideswap.proto.AssetPair', '9': 0, '10': 'chartsSubscribe'},
    {'1': 'charts_unsubscribe', '3': 121, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'chartsUnsubscribe'},
    {'1': 'load_history', '3': 130, '4': 1, '5': 11, '6': '.sideswap.proto.To.LoadHistory', '9': 0, '10': 'loadHistory'},
  ],
  '3': [To_Login$json, To_NetworkSettings$json, To_ProxySettings$json, To_EncryptPin$json, To_DecryptPin$json, To_AppState$json, To_PegInRequest$json, To_PegOutAmount$json, To_PegOutRequest$json, To_SetMemo$json, To_SendTx$json, To_BlindedValues$json, To_ShowTransaction$json, To_UpdatePushToken$json, To_GaidStatus$json, To_OrderSubmit$json, To_OrderEdit$json, To_OrderCancel$json, To_StartQuotes$json, To_StartOrder$json, To_AcceptQuote$json, To_LoadHistory$json],
  '8': [
    {'1': 'msg'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_Login$json = {
  '1': 'Login',
  '2': [
    {'1': 'mnemonic', '3': 1, '4': 1, '5': 9, '9': 0, '10': 'mnemonic'},
    {'1': 'jade_id', '3': 7, '4': 1, '5': 9, '9': 0, '10': 'jadeId'},
    {'1': 'phone_key', '3': 2, '4': 1, '5': 9, '10': 'phoneKey'},
  ],
  '8': [
    {'1': 'wallet'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_NetworkSettings$json = {
  '1': 'NetworkSettings',
  '2': [
    {'1': 'blockstream', '3': 1, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'blockstream'},
    {'1': 'sideswap', '3': 2, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'sideswap'},
    {'1': 'sideswap_cn', '3': 3, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'sideswapCn'},
    {'1': 'custom', '3': 4, '4': 1, '5': 11, '6': '.sideswap.proto.To.NetworkSettings.Custom', '9': 0, '10': 'custom'},
  ],
  '3': [To_NetworkSettings_Custom$json],
  '8': [
    {'1': 'selected'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_NetworkSettings_Custom$json = {
  '1': 'Custom',
  '2': [
    {'1': 'host', '3': 1, '4': 2, '5': 9, '10': 'host'},
    {'1': 'port', '3': 2, '4': 2, '5': 5, '10': 'port'},
    {'1': 'use_tls', '3': 3, '4': 2, '5': 8, '10': 'useTls'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_ProxySettings$json = {
  '1': 'ProxySettings',
  '2': [
    {'1': 'proxy', '3': 1, '4': 1, '5': 11, '6': '.sideswap.proto.To.ProxySettings.Proxy', '10': 'proxy'},
  ],
  '3': [To_ProxySettings_Proxy$json],
};

@$core.Deprecated('Use toDescriptor instead')
const To_ProxySettings_Proxy$json = {
  '1': 'Proxy',
  '2': [
    {'1': 'host', '3': 1, '4': 2, '5': 9, '10': 'host'},
    {'1': 'port', '3': 2, '4': 2, '5': 5, '10': 'port'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_EncryptPin$json = {
  '1': 'EncryptPin',
  '2': [
    {'1': 'pin', '3': 1, '4': 2, '5': 9, '10': 'pin'},
    {'1': 'mnemonic', '3': 2, '4': 2, '5': 9, '10': 'mnemonic'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_DecryptPin$json = {
  '1': 'DecryptPin',
  '2': [
    {'1': 'pin', '3': 1, '4': 2, '5': 9, '10': 'pin'},
    {'1': 'salt', '3': 2, '4': 2, '5': 9, '10': 'salt'},
    {'1': 'encrypted_data', '3': 3, '4': 2, '5': 9, '10': 'encryptedData'},
    {'1': 'pin_identifier', '3': 4, '4': 2, '5': 9, '10': 'pinIdentifier'},
    {'1': 'hmac', '3': 5, '4': 1, '5': 9, '10': 'hmac'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_AppState$json = {
  '1': 'AppState',
  '2': [
    {'1': 'active', '3': 1, '4': 2, '5': 8, '10': 'active'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_PegInRequest$json = {
  '1': 'PegInRequest',
};

@$core.Deprecated('Use toDescriptor instead')
const To_PegOutAmount$json = {
  '1': 'PegOutAmount',
  '2': [
    {'1': 'amount', '3': 1, '4': 2, '5': 3, '10': 'amount'},
    {'1': 'is_send_entered', '3': 2, '4': 2, '5': 8, '10': 'isSendEntered'},
    {'1': 'fee_rate', '3': 3, '4': 2, '5': 1, '10': 'feeRate'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_PegOutRequest$json = {
  '1': 'PegOutRequest',
  '2': [
    {'1': 'send_amount', '3': 1, '4': 2, '5': 3, '10': 'sendAmount'},
    {'1': 'recv_amount', '3': 2, '4': 2, '5': 3, '10': 'recvAmount'},
    {'1': 'is_send_entered', '3': 4, '4': 2, '5': 8, '10': 'isSendEntered'},
    {'1': 'fee_rate', '3': 5, '4': 2, '5': 1, '10': 'feeRate'},
    {'1': 'recv_addr', '3': 6, '4': 2, '5': 9, '10': 'recvAddr'},
    {'1': 'blocks', '3': 7, '4': 2, '5': 5, '10': 'blocks'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_SetMemo$json = {
  '1': 'SetMemo',
  '2': [
    {'1': 'account', '3': 1, '4': 2, '5': 14, '6': '.sideswap.proto.Account', '10': 'account'},
    {'1': 'txid', '3': 2, '4': 2, '5': 9, '10': 'txid'},
    {'1': 'memo', '3': 3, '4': 2, '5': 9, '10': 'memo'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_SendTx$json = {
  '1': 'SendTx',
  '2': [
    {'1': 'id', '3': 2, '4': 2, '5': 9, '10': 'id'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_BlindedValues$json = {
  '1': 'BlindedValues',
  '2': [
    {'1': 'txid', '3': 1, '4': 2, '5': 9, '10': 'txid'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_ShowTransaction$json = {
  '1': 'ShowTransaction',
  '2': [
    {'1': 'txid', '3': 1, '4': 1, '5': 9, '10': 'txid'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_UpdatePushToken$json = {
  '1': 'UpdatePushToken',
  '2': [
    {'1': 'token', '3': 1, '4': 2, '5': 9, '10': 'token'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_GaidStatus$json = {
  '1': 'GaidStatus',
  '2': [
    {'1': 'gaid', '3': 1, '4': 2, '5': 9, '10': 'gaid'},
    {'1': 'asset_id', '3': 2, '4': 2, '5': 9, '10': 'assetId'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_OrderSubmit$json = {
  '1': 'OrderSubmit',
  '2': [
    {'1': 'asset_pair', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.AssetPair', '10': 'assetPair'},
    {'1': 'base_amount', '3': 2, '4': 2, '5': 4, '10': 'baseAmount'},
    {'1': 'price', '3': 3, '4': 1, '5': 1, '10': 'price'},
    {'1': 'price_tracking', '3': 9, '4': 1, '5': 1, '10': 'priceTracking'},
    {'1': 'trade_dir', '3': 4, '4': 2, '5': 14, '6': '.sideswap.proto.TradeDir', '10': 'tradeDir'},
    {'1': 'ttl_seconds', '3': 5, '4': 1, '5': 4, '10': 'ttlSeconds'},
    {'1': 'two_step', '3': 6, '4': 2, '5': 8, '10': 'twoStep'},
    {'1': 'private', '3': 8, '4': 2, '5': 8, '10': 'private'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_OrderEdit$json = {
  '1': 'OrderEdit',
  '2': [
    {'1': 'order_id', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.OrderId', '10': 'orderId'},
    {'1': 'base_amount', '3': 2, '4': 1, '5': 4, '10': 'baseAmount'},
    {'1': 'price', '3': 3, '4': 1, '5': 1, '10': 'price'},
    {'1': 'price_tracking', '3': 4, '4': 1, '5': 1, '10': 'priceTracking'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_OrderCancel$json = {
  '1': 'OrderCancel',
  '2': [
    {'1': 'order_id', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.OrderId', '10': 'orderId'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_StartQuotes$json = {
  '1': 'StartQuotes',
  '2': [
    {'1': 'asset_pair', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.AssetPair', '10': 'assetPair'},
    {'1': 'asset_type', '3': 2, '4': 2, '5': 14, '6': '.sideswap.proto.AssetType', '10': 'assetType'},
    {'1': 'amount', '3': 3, '4': 2, '5': 4, '10': 'amount'},
    {'1': 'trade_dir', '3': 4, '4': 2, '5': 14, '6': '.sideswap.proto.TradeDir', '10': 'tradeDir'},
    {'1': 'instant_swap', '3': 5, '4': 2, '5': 8, '10': 'instantSwap'},
    {'1': 'client_sub_id', '3': 6, '4': 1, '5': 3, '10': 'clientSubId'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_StartOrder$json = {
  '1': 'StartOrder',
  '2': [
    {'1': 'order_id', '3': 1, '4': 2, '5': 4, '10': 'orderId'},
    {'1': 'private_id', '3': 2, '4': 1, '5': 9, '10': 'privateId'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_AcceptQuote$json = {
  '1': 'AcceptQuote',
  '2': [
    {'1': 'quote_id', '3': 1, '4': 2, '5': 4, '10': 'quoteId'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_LoadHistory$json = {
  '1': 'LoadHistory',
  '2': [
    {'1': 'start_time', '3': 1, '4': 1, '5': 4, '10': 'startTime'},
    {'1': 'end_time', '3': 2, '4': 1, '5': 4, '10': 'endTime'},
    {'1': 'skip', '3': 3, '4': 1, '5': 13, '10': 'skip'},
    {'1': 'count', '3': 4, '4': 1, '5': 13, '10': 'count'},
  ],
};

/// Descriptor for `To`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List toDescriptor = $convert.base64Decode(
    'CgJUbxIwCgVsb2dpbhgBIAEoCzIYLnNpZGVzd2FwLnByb3RvLlRvLkxvZ2luSABSBWxvZ2luEi'
    '8KBmxvZ291dBgCIAEoCzIVLnNpZGVzd2FwLnByb3RvLkVtcHR5SABSBmxvZ291dBJPChBuZXR3'
    'b3JrX3NldHRpbmdzGAkgASgLMiIuc2lkZXN3YXAucHJvdG8uVG8uTmV0d29ya1NldHRpbmdzSA'
    'BSD25ldHdvcmtTZXR0aW5ncxJJCg5wcm94eV9zZXR0aW5ncxgHIAEoCzIgLnNpZGVzd2FwLnBy'
    'b3RvLlRvLlByb3h5U2V0dGluZ3NIAFINcHJveHlTZXR0aW5ncxJQChF1cGRhdGVfcHVzaF90b2'
    'tlbhgDIAEoCzIiLnNpZGVzd2FwLnByb3RvLlRvLlVwZGF0ZVB1c2hUb2tlbkgAUg91cGRhdGVQ'
    'dXNoVG9rZW4SQAoLZW5jcnlwdF9waW4YBCABKAsyHS5zaWRlc3dhcC5wcm90by5Uby5FbmNyeX'
    'B0UGluSABSCmVuY3J5cHRQaW4SQAoLZGVjcnlwdF9waW4YBSABKAsyHS5zaWRlc3dhcC5wcm90'
    'by5Uby5EZWNyeXB0UGluSABSCmRlY3J5cHRQaW4SIwoMcHVzaF9tZXNzYWdlGAYgASgJSABSC3'
    'B1c2hNZXNzYWdlEjoKCWFwcF9zdGF0ZRgIIAEoCzIbLnNpZGVzd2FwLnByb3RvLlRvLkFwcFN0'
    'YXRlSABSCGFwcFN0YXRlEj0KC2FjdGl2ZV9wYWdlGBMgASgOMhouc2lkZXN3YXAucHJvdG8uQW'
    'N0aXZlUGFnZUgAUgphY3RpdmVQYWdlEjcKCHNldF9tZW1vGAogASgLMhouc2lkZXN3YXAucHJv'
    'dG8uVG8uU2V0TWVtb0gAUgdzZXRNZW1vEkMKEGdldF9yZWN2X2FkZHJlc3MYCyABKA4yFy5zaW'
    'Rlc3dhcC5wcm90by5BY2NvdW50SABSDmdldFJlY3ZBZGRyZXNzEjcKCWNyZWF0ZV90eBgMIAEo'
    'CzIYLnNpZGVzd2FwLnByb3RvLkNyZWF0ZVR4SABSCGNyZWF0ZVR4EjQKB3NlbmRfdHgYDSABKA'
    'syGS5zaWRlc3dhcC5wcm90by5Uby5TZW5kVHhIAFIGc2VuZFR4EkkKDmJsaW5kZWRfdmFsdWVz'
    'GA4gASgLMiAuc2lkZXN3YXAucHJvdG8uVG8uQmxpbmRlZFZhbHVlc0gAUg1ibGluZGVkVmFsdW'
    'VzEjgKCmxvYWRfdXR4b3MYESABKA4yFy5zaWRlc3dhcC5wcm90by5BY2NvdW50SABSCWxvYWRV'
    'dHhvcxJACg5sb2FkX2FkZHJlc3NlcxgSIAEoDjIXLnNpZGVzd2FwLnByb3RvLkFjY291bnRIAF'
    'INbG9hZEFkZHJlc3NlcxJEChFsb2FkX3RyYW5zYWN0aW9ucxgUIAEoCzIVLnNpZGVzd2FwLnBy'
    'b3RvLkVtcHR5SABSEGxvYWRUcmFuc2FjdGlvbnMSTwoQc2hvd190cmFuc2FjdGlvbhgPIAEoCz'
    'IiLnNpZGVzd2FwLnByb3RvLlRvLlNob3dUcmFuc2FjdGlvbkgAUg9zaG93VHJhbnNhY3Rpb24S'
    'RwoOcGVnX2luX3JlcXVlc3QYFSABKAsyHy5zaWRlc3dhcC5wcm90by5Uby5QZWdJblJlcXVlc3'
    'RIAFIMcGVnSW5SZXF1ZXN0EkcKDnBlZ19vdXRfYW1vdW50GBggASgLMh8uc2lkZXN3YXAucHJv'
    'dG8uVG8uUGVnT3V0QW1vdW50SABSDHBlZ091dEFtb3VudBJKCg9wZWdfb3V0X3JlcXVlc3QYFi'
    'ABKAsyIC5zaWRlc3dhcC5wcm90by5Uby5QZWdPdXRSZXF1ZXN0SABSDXBlZ091dFJlcXVlc3QS'
    'PgoNYXNzZXRfZGV0YWlscxg5IAEoCzIXLnNpZGVzd2FwLnByb3RvLkFzc2V0SWRIAFIMYXNzZX'
    'REZXRhaWxzEkIKEHBvcnRmb2xpb19wcmljZXMYPiABKAsyFS5zaWRlc3dhcC5wcm90by5FbXB0'
    'eUgAUg9wb3J0Zm9saW9QcmljZXMSQgoQY29udmVyc2lvbl9yYXRlcxg/IAEoCzIVLnNpZGVzd2'
    'FwLnByb3RvLkVtcHR5SABSD2NvbnZlcnNpb25SYXRlcxI4CgtqYWRlX3Jlc2NhbhhHIAEoCzIV'
    'LnNpZGVzd2FwLnByb3RvLkVtcHR5SABSCmphZGVSZXNjYW4SOAoLamFkZV91bmxvY2sYSCABKA'
    'syFS5zaWRlc3dhcC5wcm90by5FbXB0eUgAUgpqYWRlVW5sb2NrEkkKE2phZGVfdmVyaWZ5X2Fk'
    'ZHJlc3MYSSABKAsyFy5zaWRlc3dhcC5wcm90by5BZGRyZXNzSABSEWphZGVWZXJpZnlBZGRyZX'
    'NzEkAKC2dhaWRfc3RhdHVzGFEgASgLMh0uc2lkZXN3YXAucHJvdG8uVG8uR2FpZFN0YXR1c0gA'
    'UgpnYWlkU3RhdHVzEkYKEG1hcmtldF9zdWJzY3JpYmUYZCABKAsyGS5zaWRlc3dhcC5wcm90by'
    '5Bc3NldFBhaXJIAFIPbWFya2V0U3Vic2NyaWJlEkYKEm1hcmtldF91bnN1YnNjcmliZRhlIAEo'
    'CzIVLnNpZGVzd2FwLnByb3RvLkVtcHR5SABSEW1hcmtldFVuc3Vic2NyaWJlEkMKDG9yZGVyX3'
    'N1Ym1pdBhmIAEoCzIeLnNpZGVzd2FwLnByb3RvLlRvLk9yZGVyU3VibWl0SABSC29yZGVyU3Vi'
    'bWl0Ej0KCm9yZGVyX2VkaXQYZyABKAsyHC5zaWRlc3dhcC5wcm90by5Uby5PcmRlckVkaXRIAF'
    'IJb3JkZXJFZGl0EkMKDG9yZGVyX2NhbmNlbBhoIAEoCzIeLnNpZGVzd2FwLnByb3RvLlRvLk9y'
    'ZGVyQ2FuY2VsSABSC29yZGVyQ2FuY2VsEkMKDHN0YXJ0X3F1b3RlcxhuIAEoCzIeLnNpZGVzd2'
    'FwLnByb3RvLlRvLlN0YXJ0UXVvdGVzSABSC3N0YXJ0UXVvdGVzEkAKC3N0YXJ0X29yZGVyGHEg'
    'ASgLMh0uc2lkZXN3YXAucHJvdG8uVG8uU3RhcnRPcmRlckgAUgpzdGFydE9yZGVyEjgKC3N0b3'
    'BfcXVvdGVzGG8gASgLMhUuc2lkZXN3YXAucHJvdG8uRW1wdHlIAFIKc3RvcFF1b3RlcxJDCgxh'
    'Y2NlcHRfcXVvdGUYcCABKAsyHi5zaWRlc3dhcC5wcm90by5Uby5BY2NlcHRRdW90ZUgAUgthY2'
    'NlcHRRdW90ZRJGChBjaGFydHNfc3Vic2NyaWJlGHggASgLMhkuc2lkZXN3YXAucHJvdG8uQXNz'
    'ZXRQYWlySABSD2NoYXJ0c1N1YnNjcmliZRJGChJjaGFydHNfdW5zdWJzY3JpYmUYeSABKAsyFS'
    '5zaWRlc3dhcC5wcm90by5FbXB0eUgAUhFjaGFydHNVbnN1YnNjcmliZRJECgxsb2FkX2hpc3Rv'
    'cnkYggEgASgLMh4uc2lkZXN3YXAucHJvdG8uVG8uTG9hZEhpc3RvcnlIAFILbG9hZEhpc3Rvcn'
    'kaZwoFTG9naW4SHAoIbW5lbW9uaWMYASABKAlIAFIIbW5lbW9uaWMSGQoHamFkZV9pZBgHIAEo'
    'CUgAUgZqYWRlSWQSGwoJcGhvbmVfa2V5GAIgASgJUghwaG9uZUtleUIICgZ3YWxsZXQa1wIKD0'
    '5ldHdvcmtTZXR0aW5ncxI5CgtibG9ja3N0cmVhbRgBIAEoCzIVLnNpZGVzd2FwLnByb3RvLkVt'
    'cHR5SABSC2Jsb2Nrc3RyZWFtEjMKCHNpZGVzd2FwGAIgASgLMhUuc2lkZXN3YXAucHJvdG8uRW'
    '1wdHlIAFIIc2lkZXN3YXASOAoLc2lkZXN3YXBfY24YAyABKAsyFS5zaWRlc3dhcC5wcm90by5F'
    'bXB0eUgAUgpzaWRlc3dhcENuEkMKBmN1c3RvbRgEIAEoCzIpLnNpZGVzd2FwLnByb3RvLlRvLk'
    '5ldHdvcmtTZXR0aW5ncy5DdXN0b21IAFIGY3VzdG9tGkkKBkN1c3RvbRISCgRob3N0GAEgAigJ'
    'UgRob3N0EhIKBHBvcnQYAiACKAVSBHBvcnQSFwoHdXNlX3RscxgDIAIoCFIGdXNlVGxzQgoKCH'
    'NlbGVjdGVkGn4KDVByb3h5U2V0dGluZ3MSPAoFcHJveHkYASABKAsyJi5zaWRlc3dhcC5wcm90'
    'by5Uby5Qcm94eVNldHRpbmdzLlByb3h5UgVwcm94eRovCgVQcm94eRISCgRob3N0GAEgAigJUg'
    'Rob3N0EhIKBHBvcnQYAiACKAVSBHBvcnQaOgoKRW5jcnlwdFBpbhIQCgNwaW4YASACKAlSA3Bp'
    'bhIaCghtbmVtb25pYxgCIAIoCVIIbW5lbW9uaWMalAEKCkRlY3J5cHRQaW4SEAoDcGluGAEgAi'
    'gJUgNwaW4SEgoEc2FsdBgCIAIoCVIEc2FsdBIlCg5lbmNyeXB0ZWRfZGF0YRgDIAIoCVINZW5j'
    'cnlwdGVkRGF0YRIlCg5waW5faWRlbnRpZmllchgEIAIoCVINcGluSWRlbnRpZmllchISCgRobW'
    'FjGAUgASgJUgRobWFjGiIKCEFwcFN0YXRlEhYKBmFjdGl2ZRgBIAIoCFIGYWN0aXZlGg4KDFBl'
    'Z0luUmVxdWVzdBppCgxQZWdPdXRBbW91bnQSFgoGYW1vdW50GAEgAigDUgZhbW91bnQSJgoPaX'
    'Nfc2VuZF9lbnRlcmVkGAIgAigIUg1pc1NlbmRFbnRlcmVkEhkKCGZlZV9yYXRlGAMgAigBUgdm'
    'ZWVSYXRlGskBCg1QZWdPdXRSZXF1ZXN0Eh8KC3NlbmRfYW1vdW50GAEgAigDUgpzZW5kQW1vdW'
    '50Eh8KC3JlY3ZfYW1vdW50GAIgAigDUgpyZWN2QW1vdW50EiYKD2lzX3NlbmRfZW50ZXJlZBgE'
    'IAIoCFINaXNTZW5kRW50ZXJlZBIZCghmZWVfcmF0ZRgFIAIoAVIHZmVlUmF0ZRIbCglyZWN2X2'
    'FkZHIYBiACKAlSCHJlY3ZBZGRyEhYKBmJsb2NrcxgHIAIoBVIGYmxvY2tzGmQKB1NldE1lbW8S'
    'MQoHYWNjb3VudBgBIAIoDjIXLnNpZGVzd2FwLnByb3RvLkFjY291bnRSB2FjY291bnQSEgoEdH'
    'hpZBgCIAIoCVIEdHhpZBISCgRtZW1vGAMgAigJUgRtZW1vGhgKBlNlbmRUeBIOCgJpZBgCIAIo'
    'CVICaWQaIwoNQmxpbmRlZFZhbHVlcxISCgR0eGlkGAEgAigJUgR0eGlkGiUKD1Nob3dUcmFuc2'
    'FjdGlvbhISCgR0eGlkGAEgASgJUgR0eGlkGicKD1VwZGF0ZVB1c2hUb2tlbhIUCgV0b2tlbhgB'
    'IAIoCVIFdG9rZW4aOwoKR2FpZFN0YXR1cxISCgRnYWlkGAEgAigJUgRnYWlkEhkKCGFzc2V0X2'
    'lkGAIgAigJUgdhc3NldElkGrICCgtPcmRlclN1Ym1pdBI4Cgphc3NldF9wYWlyGAEgAigLMhku'
    'c2lkZXN3YXAucHJvdG8uQXNzZXRQYWlyUglhc3NldFBhaXISHwoLYmFzZV9hbW91bnQYAiACKA'
    'RSCmJhc2VBbW91bnQSFAoFcHJpY2UYAyABKAFSBXByaWNlEiUKDnByaWNlX3RyYWNraW5nGAkg'
    'ASgBUg1wcmljZVRyYWNraW5nEjUKCXRyYWRlX2RpchgEIAIoDjIYLnNpZGVzd2FwLnByb3RvLl'
    'RyYWRlRGlyUgh0cmFkZURpchIfCgt0dGxfc2Vjb25kcxgFIAEoBFIKdHRsU2Vjb25kcxIZCgh0'
    'd29fc3RlcBgGIAIoCFIHdHdvU3RlcBIYCgdwcml2YXRlGAggAigIUgdwcml2YXRlGp0BCglPcm'
    'RlckVkaXQSMgoIb3JkZXJfaWQYASACKAsyFy5zaWRlc3dhcC5wcm90by5PcmRlcklkUgdvcmRl'
    'cklkEh8KC2Jhc2VfYW1vdW50GAIgASgEUgpiYXNlQW1vdW50EhQKBXByaWNlGAMgASgBUgVwcm'
    'ljZRIlCg5wcmljZV90cmFja2luZxgEIAEoAVINcHJpY2VUcmFja2luZxpBCgtPcmRlckNhbmNl'
    'bBIyCghvcmRlcl9pZBgBIAIoCzIXLnNpZGVzd2FwLnByb3RvLk9yZGVySWRSB29yZGVySWQalw'
    'IKC1N0YXJ0UXVvdGVzEjgKCmFzc2V0X3BhaXIYASACKAsyGS5zaWRlc3dhcC5wcm90by5Bc3Nl'
    'dFBhaXJSCWFzc2V0UGFpchI4Cgphc3NldF90eXBlGAIgAigOMhkuc2lkZXN3YXAucHJvdG8uQX'
    'NzZXRUeXBlUglhc3NldFR5cGUSFgoGYW1vdW50GAMgAigEUgZhbW91bnQSNQoJdHJhZGVfZGly'
    'GAQgAigOMhguc2lkZXN3YXAucHJvdG8uVHJhZGVEaXJSCHRyYWRlRGlyEiEKDGluc3RhbnRfc3'
    'dhcBgFIAIoCFILaW5zdGFudFN3YXASIgoNY2xpZW50X3N1Yl9pZBgGIAEoA1ILY2xpZW50U3Vi'
    'SWQaRgoKU3RhcnRPcmRlchIZCghvcmRlcl9pZBgBIAIoBFIHb3JkZXJJZBIdCgpwcml2YXRlX2'
    'lkGAIgASgJUglwcml2YXRlSWQaKAoLQWNjZXB0UXVvdGUSGQoIcXVvdGVfaWQYASACKARSB3F1'
    'b3RlSWQacQoLTG9hZEhpc3RvcnkSHQoKc3RhcnRfdGltZRgBIAEoBFIJc3RhcnRUaW1lEhkKCG'
    'VuZF90aW1lGAIgASgEUgdlbmRUaW1lEhIKBHNraXAYAyABKA1SBHNraXASFAoFY291bnQYBCAB'
    'KA1SBWNvdW50QgUKA21zZw==');

@$core.Deprecated('Use fromDescriptor instead')
const From$json = {
  '1': 'From',
  '2': [
    {'1': 'login', '3': 17, '4': 1, '5': 11, '6': '.sideswap.proto.From.Login', '9': 0, '10': 'login'},
    {'1': 'logout', '3': 16, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'logout'},
    {'1': 'env_settings', '3': 13, '4': 1, '5': 11, '6': '.sideswap.proto.From.EnvSettings', '9': 0, '10': 'envSettings'},
    {'1': 'register_amp', '3': 8, '4': 1, '5': 11, '6': '.sideswap.proto.From.RegisterAmp', '9': 0, '10': 'registerAmp'},
    {'1': 'updated_txs', '3': 1, '4': 1, '5': 11, '6': '.sideswap.proto.From.UpdatedTxs', '9': 0, '10': 'updatedTxs'},
    {'1': 'removed_txs', '3': 12, '4': 1, '5': 11, '6': '.sideswap.proto.From.RemovedTxs', '9': 0, '10': 'removedTxs'},
    {'1': 'updated_pegs', '3': 2, '4': 1, '5': 11, '6': '.sideswap.proto.From.UpdatedPegs', '9': 0, '10': 'updatedPegs'},
    {'1': 'new_asset', '3': 3, '4': 1, '5': 11, '6': '.sideswap.proto.Asset', '9': 0, '10': 'newAsset'},
    {'1': 'amp_assets', '3': 9, '4': 1, '5': 11, '6': '.sideswap.proto.From.AmpAssets', '9': 0, '10': 'ampAssets'},
    {'1': 'balance_update', '3': 4, '4': 1, '5': 11, '6': '.sideswap.proto.From.BalanceUpdate', '9': 0, '10': 'balanceUpdate'},
    {'1': 'server_status', '3': 5, '4': 1, '5': 11, '6': '.sideswap.proto.ServerStatus', '9': 0, '10': 'serverStatus'},
    {'1': 'price_update', '3': 6, '4': 1, '5': 11, '6': '.sideswap.proto.From.PriceUpdate', '9': 0, '10': 'priceUpdate'},
    {'1': 'wallet_loaded', '3': 7, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'walletLoaded'},
    {'1': 'sync_complete', '3': 14, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'syncComplete'},
    {'1': 'subscribed_value', '3': 15, '4': 1, '5': 11, '6': '.sideswap.proto.From.SubscribedValue', '9': 0, '10': 'subscribedValue'},
    {'1': 'encrypt_pin', '3': 10, '4': 1, '5': 11, '6': '.sideswap.proto.From.EncryptPin', '9': 0, '10': 'encryptPin'},
    {'1': 'decrypt_pin', '3': 11, '4': 1, '5': 11, '6': '.sideswap.proto.From.DecryptPin', '9': 0, '10': 'decryptPin'},
    {'1': 'pegin_wait_tx', '3': 21, '4': 1, '5': 11, '6': '.sideswap.proto.From.PeginWaitTx', '9': 0, '10': 'peginWaitTx'},
    {'1': 'peg_out_amount', '3': 24, '4': 1, '5': 11, '6': '.sideswap.proto.From.PegOutAmount', '9': 0, '10': 'pegOutAmount'},
    {'1': 'swap_succeed', '3': 22, '4': 1, '5': 11, '6': '.sideswap.proto.TransItem', '9': 0, '10': 'swapSucceed'},
    {'1': 'swap_failed', '3': 23, '4': 1, '5': 9, '9': 0, '10': 'swapFailed'},
    {'1': 'recv_address', '3': 30, '4': 1, '5': 11, '6': '.sideswap.proto.From.RecvAddress', '9': 0, '10': 'recvAddress'},
    {'1': 'create_tx_result', '3': 31, '4': 1, '5': 11, '6': '.sideswap.proto.From.CreateTxResult', '9': 0, '10': 'createTxResult'},
    {'1': 'send_result', '3': 32, '4': 1, '5': 11, '6': '.sideswap.proto.From.SendResult', '9': 0, '10': 'sendResult'},
    {'1': 'blinded_values', '3': 33, '4': 1, '5': 11, '6': '.sideswap.proto.From.BlindedValues', '9': 0, '10': 'blindedValues'},
    {'1': 'load_utxos', '3': 35, '4': 1, '5': 11, '6': '.sideswap.proto.From.LoadUtxos', '9': 0, '10': 'loadUtxos'},
    {'1': 'load_addresses', '3': 36, '4': 1, '5': 11, '6': '.sideswap.proto.From.LoadAddresses', '9': 0, '10': 'loadAddresses'},
    {'1': 'load_transactions', '3': 37, '4': 1, '5': 11, '6': '.sideswap.proto.From.LoadTransactions', '9': 0, '10': 'loadTransactions'},
    {'1': 'show_transaction', '3': 38, '4': 1, '5': 11, '6': '.sideswap.proto.From.ShowTransaction', '9': 0, '10': 'showTransaction'},
    {'1': 'show_message', '3': 50, '4': 1, '5': 11, '6': '.sideswap.proto.From.ShowMessage', '9': 0, '10': 'showMessage'},
    {'1': 'insufficient_funds', '3': 55, '4': 1, '5': 11, '6': '.sideswap.proto.From.ShowInsufficientFunds', '9': 0, '10': 'insufficientFunds'},
    {'1': 'server_connected', '3': 60, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'serverConnected'},
    {'1': 'server_disconnected', '3': 61, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'serverDisconnected'},
    {'1': 'asset_details', '3': 65, '4': 1, '5': 11, '6': '.sideswap.proto.From.AssetDetails', '9': 0, '10': 'assetDetails'},
    {'1': 'new_block', '3': 62, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'newBlock'},
    {'1': 'new_tx', '3': 63, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'newTx'},
    {'1': 'local_message', '3': 68, '4': 1, '5': 11, '6': '.sideswap.proto.From.LocalMessage', '9': 0, '10': 'localMessage'},
    {'1': 'portfolio_prices', '3': 72, '4': 1, '5': 11, '6': '.sideswap.proto.From.PortfolioPrices', '9': 0, '10': 'portfolioPrices'},
    {'1': 'conversion_rates', '3': 73, '4': 1, '5': 11, '6': '.sideswap.proto.From.ConversionRates', '9': 0, '10': 'conversionRates'},
    {'1': 'jade_ports', '3': 80, '4': 1, '5': 11, '6': '.sideswap.proto.From.JadePorts', '9': 0, '10': 'jadePorts'},
    {'1': 'jade_status', '3': 83, '4': 1, '5': 11, '6': '.sideswap.proto.From.JadeStatus', '9': 0, '10': 'jadeStatus'},
    {'1': 'jade_unlock', '3': 81, '4': 1, '5': 11, '6': '.sideswap.proto.GenericResponse', '9': 0, '10': 'jadeUnlock'},
    {'1': 'jade_verify_address', '3': 82, '4': 1, '5': 11, '6': '.sideswap.proto.GenericResponse', '9': 0, '10': 'jadeVerifyAddress'},
    {'1': 'gaid_status', '3': 91, '4': 1, '5': 11, '6': '.sideswap.proto.From.GaidStatus', '9': 0, '10': 'gaidStatus'},
    {'1': 'market_list', '3': 100, '4': 1, '5': 11, '6': '.sideswap.proto.From.MarketList', '9': 0, '10': 'marketList'},
    {'1': 'market_added', '3': 101, '4': 1, '5': 11, '6': '.sideswap.proto.MarketInfo', '9': 0, '10': 'marketAdded'},
    {'1': 'market_removed', '3': 102, '4': 1, '5': 11, '6': '.sideswap.proto.AssetPair', '9': 0, '10': 'marketRemoved'},
    {'1': 'public_orders', '3': 105, '4': 1, '5': 11, '6': '.sideswap.proto.From.PublicOrders', '9': 0, '10': 'publicOrders'},
    {'1': 'public_order_created', '3': 106, '4': 1, '5': 11, '6': '.sideswap.proto.PublicOrder', '9': 0, '10': 'publicOrderCreated'},
    {'1': 'public_order_removed', '3': 107, '4': 1, '5': 11, '6': '.sideswap.proto.OrderId', '9': 0, '10': 'publicOrderRemoved'},
    {'1': 'market_price', '3': 110, '4': 1, '5': 11, '6': '.sideswap.proto.From.MarketPrice', '9': 0, '10': 'marketPrice'},
    {'1': 'min_market_amounts', '3': 119, '4': 1, '5': 11, '6': '.sideswap.proto.From.MinMarketAmounts', '9': 0, '10': 'minMarketAmounts'},
    {'1': 'own_orders', '3': 120, '4': 1, '5': 11, '6': '.sideswap.proto.From.OwnOrders', '9': 0, '10': 'ownOrders'},
    {'1': 'own_order_created', '3': 121, '4': 1, '5': 11, '6': '.sideswap.proto.OwnOrder', '9': 0, '10': 'ownOrderCreated'},
    {'1': 'own_order_removed', '3': 122, '4': 1, '5': 11, '6': '.sideswap.proto.OrderId', '9': 0, '10': 'ownOrderRemoved'},
    {'1': 'order_submit', '3': 130, '4': 1, '5': 11, '6': '.sideswap.proto.From.OrderSubmit', '9': 0, '10': 'orderSubmit'},
    {'1': 'order_edit', '3': 131, '4': 1, '5': 11, '6': '.sideswap.proto.GenericResponse', '9': 0, '10': 'orderEdit'},
    {'1': 'order_cancel', '3': 132, '4': 1, '5': 11, '6': '.sideswap.proto.GenericResponse', '9': 0, '10': 'orderCancel'},
    {'1': 'start_order', '3': 142, '4': 1, '5': 11, '6': '.sideswap.proto.From.StartOrder', '9': 0, '10': 'startOrder'},
    {'1': 'quote', '3': 140, '4': 1, '5': 11, '6': '.sideswap.proto.From.Quote', '9': 0, '10': 'quote'},
    {'1': 'accept_quote', '3': 141, '4': 1, '5': 11, '6': '.sideswap.proto.From.AcceptQuote', '9': 0, '10': 'acceptQuote'},
    {'1': 'charts_subscribe', '3': 150, '4': 1, '5': 11, '6': '.sideswap.proto.From.ChartsSubscribe', '9': 0, '10': 'chartsSubscribe'},
    {'1': 'charts_update', '3': 151, '4': 1, '5': 11, '6': '.sideswap.proto.From.ChartsUpdate', '9': 0, '10': 'chartsUpdate'},
    {'1': 'load_history', '3': 160, '4': 1, '5': 11, '6': '.sideswap.proto.From.LoadHistory', '9': 0, '10': 'loadHistory'},
    {'1': 'history_updated', '3': 161, '4': 1, '5': 11, '6': '.sideswap.proto.From.HistoryUpdated', '9': 0, '10': 'historyUpdated'},
  ],
  '3': [From_Login$json, From_EnvSettings$json, From_EncryptPin$json, From_DecryptPin$json, From_RegisterAmp$json, From_AmpAssets$json, From_UpdatedTxs$json, From_RemovedTxs$json, From_UpdatedPegs$json, From_BalanceUpdate$json, From_PeginWaitTx$json, From_PegOutAmount$json, From_RecvAddress$json, From_LoadUtxos$json, From_LoadAddresses$json, From_LoadTransactions$json, From_ShowTransaction$json, From_CreateTxResult$json, From_SendResult$json, From_BlindedValues$json, From_PriceUpdate$json, From_SubscribedValue$json, From_ShowMessage$json, From_ShowInsufficientFunds$json, From_AssetDetails$json, From_LocalMessage$json, From_PortfolioPrices$json, From_ConversionRates$json, From_JadePorts$json, From_JadeStatus$json, From_GaidStatus$json, From_MarketList$json, From_PublicOrders$json, From_MinMarketAmounts$json, From_OwnOrders$json, From_MarketPrice$json, From_OrderSubmit$json, From_StartOrder$json, From_Quote$json, From_AcceptQuote$json, From_ChartsSubscribe$json, From_ChartsUpdate$json, From_LoadHistory$json, From_HistoryUpdated$json],
  '8': [
    {'1': 'msg'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_Login$json = {
  '1': 'Login',
  '2': [
    {'1': 'error_msg', '3': 1, '4': 1, '5': 9, '9': 0, '10': 'errorMsg'},
    {'1': 'success', '3': 2, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'success'},
  ],
  '8': [
    {'1': 'result'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_EnvSettings$json = {
  '1': 'EnvSettings',
  '2': [
    {'1': 'policy_asset_id', '3': 1, '4': 2, '5': 9, '10': 'policyAssetId'},
    {'1': 'usdt_asset_id', '3': 2, '4': 2, '5': 9, '10': 'usdtAssetId'},
    {'1': 'eurx_asset_id', '3': 3, '4': 2, '5': 9, '10': 'eurxAssetId'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_EncryptPin$json = {
  '1': 'EncryptPin',
  '2': [
    {'1': 'error', '3': 1, '4': 1, '5': 9, '9': 0, '10': 'error'},
    {'1': 'data', '3': 2, '4': 1, '5': 11, '6': '.sideswap.proto.From.EncryptPin.Data', '9': 0, '10': 'data'},
  ],
  '3': [From_EncryptPin_Data$json],
  '8': [
    {'1': 'result'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_EncryptPin_Data$json = {
  '1': 'Data',
  '2': [
    {'1': 'salt', '3': 2, '4': 2, '5': 9, '10': 'salt'},
    {'1': 'encrypted_data', '3': 3, '4': 2, '5': 9, '10': 'encryptedData'},
    {'1': 'pin_identifier', '3': 4, '4': 2, '5': 9, '10': 'pinIdentifier'},
    {'1': 'hmac', '3': 5, '4': 1, '5': 9, '10': 'hmac'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_DecryptPin$json = {
  '1': 'DecryptPin',
  '2': [
    {'1': 'error', '3': 1, '4': 1, '5': 11, '6': '.sideswap.proto.From.DecryptPin.Error', '9': 0, '10': 'error'},
    {'1': 'mnemonic', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'mnemonic'},
  ],
  '3': [From_DecryptPin_Error$json],
  '4': [From_DecryptPin_ErrorCode$json],
  '8': [
    {'1': 'result'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_DecryptPin_Error$json = {
  '1': 'Error',
  '2': [
    {'1': 'error_msg', '3': 1, '4': 2, '5': 9, '10': 'errorMsg'},
    {'1': 'error_code', '3': 2, '4': 2, '5': 14, '6': '.sideswap.proto.From.DecryptPin.ErrorCode', '10': 'errorCode'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_DecryptPin_ErrorCode$json = {
  '1': 'ErrorCode',
  '2': [
    {'1': 'WRONG_PIN', '2': 1},
    {'1': 'NETWORK_ERROR', '2': 2},
    {'1': 'INVALID_DATA', '2': 3},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_RegisterAmp$json = {
  '1': 'RegisterAmp',
  '2': [
    {'1': 'amp_id', '3': 1, '4': 1, '5': 9, '9': 0, '10': 'ampId'},
    {'1': 'error_msg', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'errorMsg'},
  ],
  '8': [
    {'1': 'result'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_AmpAssets$json = {
  '1': 'AmpAssets',
  '2': [
    {'1': 'assets', '3': 1, '4': 3, '5': 9, '10': 'assets'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_UpdatedTxs$json = {
  '1': 'UpdatedTxs',
  '2': [
    {'1': 'items', '3': 1, '4': 3, '5': 11, '6': '.sideswap.proto.TransItem', '10': 'items'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_RemovedTxs$json = {
  '1': 'RemovedTxs',
  '2': [
    {'1': 'txids', '3': 1, '4': 3, '5': 9, '10': 'txids'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_UpdatedPegs$json = {
  '1': 'UpdatedPegs',
  '2': [
    {'1': 'order_id', '3': 1, '4': 2, '5': 9, '10': 'orderId'},
    {'1': 'items', '3': 2, '4': 3, '5': 11, '6': '.sideswap.proto.TransItem', '10': 'items'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_BalanceUpdate$json = {
  '1': 'BalanceUpdate',
  '2': [
    {'1': 'account', '3': 1, '4': 2, '5': 14, '6': '.sideswap.proto.Account', '10': 'account'},
    {'1': 'balances', '3': 2, '4': 3, '5': 11, '6': '.sideswap.proto.Balance', '10': 'balances'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_PeginWaitTx$json = {
  '1': 'PeginWaitTx',
  '2': [
    {'1': 'order_id', '3': 1, '4': 2, '5': 9, '10': 'orderId'},
    {'1': 'peg_addr', '3': 5, '4': 2, '5': 9, '10': 'pegAddr'},
    {'1': 'recv_addr', '3': 6, '4': 2, '5': 9, '10': 'recvAddr'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_PegOutAmount$json = {
  '1': 'PegOutAmount',
  '2': [
    {'1': 'error_msg', '3': 1, '4': 1, '5': 9, '9': 0, '10': 'errorMsg'},
    {'1': 'amounts', '3': 2, '4': 1, '5': 11, '6': '.sideswap.proto.From.PegOutAmount.Amounts', '9': 0, '10': 'amounts'},
  ],
  '3': [From_PegOutAmount_Amounts$json],
  '8': [
    {'1': 'result'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_PegOutAmount_Amounts$json = {
  '1': 'Amounts',
  '2': [
    {'1': 'send_amount', '3': 1, '4': 2, '5': 3, '10': 'sendAmount'},
    {'1': 'recv_amount', '3': 2, '4': 2, '5': 3, '10': 'recvAmount'},
    {'1': 'is_send_entered', '3': 4, '4': 2, '5': 8, '10': 'isSendEntered'},
    {'1': 'fee_rate', '3': 5, '4': 2, '5': 1, '10': 'feeRate'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_RecvAddress$json = {
  '1': 'RecvAddress',
  '2': [
    {'1': 'addr', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.Address', '10': 'addr'},
    {'1': 'account', '3': 2, '4': 2, '5': 14, '6': '.sideswap.proto.Account', '10': 'account'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_LoadUtxos$json = {
  '1': 'LoadUtxos',
  '2': [
    {'1': 'account', '3': 1, '4': 2, '5': 14, '6': '.sideswap.proto.Account', '10': 'account'},
    {'1': 'utxos', '3': 2, '4': 3, '5': 11, '6': '.sideswap.proto.From.LoadUtxos.Utxo', '10': 'utxos'},
    {'1': 'error_msg', '3': 3, '4': 1, '5': 9, '10': 'errorMsg'},
  ],
  '3': [From_LoadUtxos_Utxo$json],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_LoadUtxos_Utxo$json = {
  '1': 'Utxo',
  '2': [
    {'1': 'txid', '3': 1, '4': 2, '5': 9, '10': 'txid'},
    {'1': 'vout', '3': 2, '4': 2, '5': 13, '10': 'vout'},
    {'1': 'asset_id', '3': 3, '4': 2, '5': 9, '10': 'assetId'},
    {'1': 'amount', '3': 4, '4': 2, '5': 4, '10': 'amount'},
    {'1': 'address', '3': 5, '4': 2, '5': 9, '10': 'address'},
    {'1': 'is_internal', '3': 6, '4': 2, '5': 8, '10': 'isInternal'},
    {'1': 'is_confidential', '3': 7, '4': 2, '5': 8, '10': 'isConfidential'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_LoadAddresses$json = {
  '1': 'LoadAddresses',
  '2': [
    {'1': 'account', '3': 1, '4': 2, '5': 14, '6': '.sideswap.proto.Account', '10': 'account'},
    {'1': 'addresses', '3': 2, '4': 3, '5': 11, '6': '.sideswap.proto.From.LoadAddresses.Address', '10': 'addresses'},
    {'1': 'error_msg', '3': 3, '4': 1, '5': 9, '10': 'errorMsg'},
  ],
  '3': [From_LoadAddresses_Address$json],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_LoadAddresses_Address$json = {
  '1': 'Address',
  '2': [
    {'1': 'address', '3': 1, '4': 2, '5': 9, '10': 'address'},
    {'1': 'unconfidential_address', '3': 4, '4': 2, '5': 9, '10': 'unconfidentialAddress'},
    {'1': 'index', '3': 2, '4': 2, '5': 13, '10': 'index'},
    {'1': 'is_internal', '3': 3, '4': 2, '5': 8, '10': 'isInternal'},
    {'1': 'script_type', '3': 5, '4': 2, '5': 14, '6': '.sideswap.proto.ScriptType', '10': 'scriptType'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_LoadTransactions$json = {
  '1': 'LoadTransactions',
  '2': [
    {'1': 'txs', '3': 1, '4': 3, '5': 11, '6': '.sideswap.proto.TransItem', '10': 'txs'},
    {'1': 'error_msg', '3': 3, '4': 1, '5': 9, '10': 'errorMsg'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_ShowTransaction$json = {
  '1': 'ShowTransaction',
  '2': [
    {'1': 'tx', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.TransItem', '10': 'tx'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_CreateTxResult$json = {
  '1': 'CreateTxResult',
  '2': [
    {'1': 'error_msg', '3': 1, '4': 1, '5': 9, '9': 0, '10': 'errorMsg'},
    {'1': 'created_tx', '3': 2, '4': 1, '5': 11, '6': '.sideswap.proto.CreatedTx', '9': 0, '10': 'createdTx'},
  ],
  '8': [
    {'1': 'result'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_SendResult$json = {
  '1': 'SendResult',
  '2': [
    {'1': 'error_msg', '3': 1, '4': 1, '5': 9, '9': 0, '10': 'errorMsg'},
    {'1': 'tx_item', '3': 2, '4': 1, '5': 11, '6': '.sideswap.proto.TransItem', '9': 0, '10': 'txItem'},
  ],
  '8': [
    {'1': 'result'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_BlindedValues$json = {
  '1': 'BlindedValues',
  '2': [
    {'1': 'txid', '3': 1, '4': 2, '5': 9, '10': 'txid'},
    {'1': 'error_msg', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'errorMsg'},
    {'1': 'blinded_values', '3': 3, '4': 1, '5': 9, '9': 0, '10': 'blindedValues'},
  ],
  '8': [
    {'1': 'result'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_PriceUpdate$json = {
  '1': 'PriceUpdate',
  '2': [
    {'1': 'asset', '3': 1, '4': 2, '5': 9, '10': 'asset'},
    {'1': 'bid', '3': 2, '4': 2, '5': 1, '10': 'bid'},
    {'1': 'ask', '3': 3, '4': 2, '5': 1, '10': 'ask'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_SubscribedValue$json = {
  '1': 'SubscribedValue',
  '2': [
    {'1': 'peg_in_min_amount', '3': 1, '4': 1, '5': 4, '9': 0, '10': 'pegInMinAmount'},
    {'1': 'peg_in_wallet_balance', '3': 2, '4': 1, '5': 4, '9': 0, '10': 'pegInWalletBalance'},
    {'1': 'peg_out_min_amount', '3': 3, '4': 1, '5': 4, '9': 0, '10': 'pegOutMinAmount'},
    {'1': 'peg_out_wallet_balance', '3': 4, '4': 1, '5': 4, '9': 0, '10': 'pegOutWalletBalance'},
  ],
  '8': [
    {'1': 'result'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_ShowMessage$json = {
  '1': 'ShowMessage',
  '2': [
    {'1': 'text', '3': 1, '4': 2, '5': 9, '10': 'text'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_ShowInsufficientFunds$json = {
  '1': 'ShowInsufficientFunds',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 2, '5': 9, '10': 'assetId'},
    {'1': 'available', '3': 2, '4': 2, '5': 3, '10': 'available'},
    {'1': 'required', '3': 3, '4': 2, '5': 3, '10': 'required'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_AssetDetails$json = {
  '1': 'AssetDetails',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 2, '5': 9, '10': 'assetId'},
    {'1': 'stats', '3': 2, '4': 1, '5': 11, '6': '.sideswap.proto.From.AssetDetails.Stats', '10': 'stats'},
    {'1': 'chart_url', '3': 3, '4': 1, '5': 9, '10': 'chartUrl'},
  ],
  '3': [From_AssetDetails_Stats$json],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_AssetDetails_Stats$json = {
  '1': 'Stats',
  '2': [
    {'1': 'issued_amount', '3': 1, '4': 2, '5': 3, '10': 'issuedAmount'},
    {'1': 'burned_amount', '3': 2, '4': 2, '5': 3, '10': 'burnedAmount'},
    {'1': 'offline_amount', '3': 4, '4': 2, '5': 3, '10': 'offlineAmount'},
    {'1': 'has_blinded_issuances', '3': 3, '4': 2, '5': 8, '10': 'hasBlindedIssuances'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_LocalMessage$json = {
  '1': 'LocalMessage',
  '2': [
    {'1': 'title', '3': 1, '4': 2, '5': 9, '10': 'title'},
    {'1': 'body', '3': 2, '4': 2, '5': 9, '10': 'body'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_PortfolioPrices$json = {
  '1': 'PortfolioPrices',
  '2': [
    {'1': 'prices_usd', '3': 1, '4': 3, '5': 11, '6': '.sideswap.proto.From.PortfolioPrices.PricesUsdEntry', '10': 'pricesUsd'},
  ],
  '3': [From_PortfolioPrices_PricesUsdEntry$json],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_PortfolioPrices_PricesUsdEntry$json = {
  '1': 'PricesUsdEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 1, '10': 'value'},
  ],
  '7': {'7': true},
};

@$core.Deprecated('Use fromDescriptor instead')
const From_ConversionRates$json = {
  '1': 'ConversionRates',
  '2': [
    {'1': 'usd_conversion_rates', '3': 1, '4': 3, '5': 11, '6': '.sideswap.proto.From.ConversionRates.UsdConversionRatesEntry', '10': 'usdConversionRates'},
  ],
  '3': [From_ConversionRates_UsdConversionRatesEntry$json],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_ConversionRates_UsdConversionRatesEntry$json = {
  '1': 'UsdConversionRatesEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 1, '10': 'value'},
  ],
  '7': {'7': true},
};

@$core.Deprecated('Use fromDescriptor instead')
const From_JadePorts$json = {
  '1': 'JadePorts',
  '2': [
    {'1': 'ports', '3': 1, '4': 3, '5': 11, '6': '.sideswap.proto.From.JadePorts.Port', '10': 'ports'},
  ],
  '3': [From_JadePorts_Port$json],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_JadePorts_Port$json = {
  '1': 'Port',
  '2': [
    {'1': 'jade_id', '3': 1, '4': 2, '5': 9, '10': 'jadeId'},
    {'1': 'port', '3': 2, '4': 2, '5': 9, '10': 'port'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_JadeStatus$json = {
  '1': 'JadeStatus',
  '2': [
    {'1': 'status', '3': 1, '4': 2, '5': 14, '6': '.sideswap.proto.From.JadeStatus.Status', '10': 'status'},
  ],
  '4': [From_JadeStatus_Status$json],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_JadeStatus_Status$json = {
  '1': 'Status',
  '2': [
    {'1': 'CONNECTING', '2': 9},
    {'1': 'IDLE', '2': 1},
    {'1': 'READ_STATUS', '2': 2},
    {'1': 'AUTH_USER', '2': 3},
    {'1': 'MASTER_BLINDING_KEY', '2': 5},
    {'1': 'SIGN_MESSAGE', '2': 10},
    {'1': 'SIGN_TX', '2': 4},
    {'1': 'SIGN_SWAP', '2': 8},
    {'1': 'SIGN_SWAP_OUTPUT', '2': 6},
    {'1': 'SIGN_OFFLINE_SWAP', '2': 7},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_GaidStatus$json = {
  '1': 'GaidStatus',
  '2': [
    {'1': 'gaid', '3': 1, '4': 2, '5': 9, '10': 'gaid'},
    {'1': 'asset_id', '3': 2, '4': 2, '5': 9, '10': 'assetId'},
    {'1': 'error', '3': 3, '4': 1, '5': 9, '10': 'error'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_MarketList$json = {
  '1': 'MarketList',
  '2': [
    {'1': 'markets', '3': 1, '4': 3, '5': 11, '6': '.sideswap.proto.MarketInfo', '10': 'markets'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_PublicOrders$json = {
  '1': 'PublicOrders',
  '2': [
    {'1': 'asset_pair', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.AssetPair', '10': 'assetPair'},
    {'1': 'list', '3': 2, '4': 3, '5': 11, '6': '.sideswap.proto.PublicOrder', '10': 'list'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_MinMarketAmounts$json = {
  '1': 'MinMarketAmounts',
  '2': [
    {'1': 'lbtc', '3': 1, '4': 2, '5': 4, '10': 'lbtc'},
    {'1': 'usdt', '3': 2, '4': 2, '5': 4, '10': 'usdt'},
    {'1': 'eurx', '3': 3, '4': 2, '5': 4, '10': 'eurx'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_OwnOrders$json = {
  '1': 'OwnOrders',
  '2': [
    {'1': 'list', '3': 1, '4': 3, '5': 11, '6': '.sideswap.proto.OwnOrder', '10': 'list'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_MarketPrice$json = {
  '1': 'MarketPrice',
  '2': [
    {'1': 'asset_pair', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.AssetPair', '10': 'assetPair'},
    {'1': 'ind_price', '3': 2, '4': 1, '5': 1, '10': 'indPrice'},
    {'1': 'last_price', '3': 3, '4': 1, '5': 1, '10': 'lastPrice'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_OrderSubmit$json = {
  '1': 'OrderSubmit',
  '2': [
    {'1': 'submit_succeed', '3': 1, '4': 1, '5': 11, '6': '.sideswap.proto.OwnOrder', '9': 0, '10': 'submitSucceed'},
    {'1': 'error', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'error'},
    {'1': 'unregistered_gaid', '3': 3, '4': 1, '5': 11, '6': '.sideswap.proto.From.OrderSubmit.UnregisteredGaid', '9': 0, '10': 'unregisteredGaid'},
  ],
  '3': [From_OrderSubmit_UnregisteredGaid$json],
  '8': [
    {'1': 'result'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_OrderSubmit_UnregisteredGaid$json = {
  '1': 'UnregisteredGaid',
  '2': [
    {'1': 'domain_agent', '3': 1, '4': 2, '5': 9, '10': 'domainAgent'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_StartOrder$json = {
  '1': 'StartOrder',
  '2': [
    {'1': 'order_id', '3': 5, '4': 2, '5': 4, '10': 'orderId'},
    {'1': 'success', '3': 1, '4': 1, '5': 11, '6': '.sideswap.proto.From.StartOrder.Success', '9': 0, '10': 'success'},
    {'1': 'error', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'error'},
  ],
  '3': [From_StartOrder_Success$json],
  '8': [
    {'1': 'result'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_StartOrder_Success$json = {
  '1': 'Success',
  '2': [
    {'1': 'asset_pair', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.AssetPair', '10': 'assetPair'},
    {'1': 'trade_dir', '3': 2, '4': 2, '5': 14, '6': '.sideswap.proto.TradeDir', '10': 'tradeDir'},
    {'1': 'amount', '3': 3, '4': 2, '5': 4, '10': 'amount'},
    {'1': 'price', '3': 4, '4': 2, '5': 1, '10': 'price'},
    {'1': 'fee_asset', '3': 5, '4': 2, '5': 14, '6': '.sideswap.proto.AssetType', '10': 'feeAsset'},
    {'1': 'two_step', '3': 6, '4': 2, '5': 8, '10': 'twoStep'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_Quote$json = {
  '1': 'Quote',
  '2': [
    {'1': 'asset_pair', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.AssetPair', '10': 'assetPair'},
    {'1': 'asset_type', '3': 2, '4': 2, '5': 14, '6': '.sideswap.proto.AssetType', '10': 'assetType'},
    {'1': 'amount', '3': 3, '4': 2, '5': 4, '10': 'amount'},
    {'1': 'trade_dir', '3': 4, '4': 2, '5': 14, '6': '.sideswap.proto.TradeDir', '10': 'tradeDir'},
    {'1': 'order_id', '3': 5, '4': 1, '5': 4, '10': 'orderId'},
    {'1': 'client_sub_id', '3': 6, '4': 1, '5': 3, '10': 'clientSubId'},
    {'1': 'success', '3': 10, '4': 1, '5': 11, '6': '.sideswap.proto.From.Quote.Success', '9': 0, '10': 'success'},
    {'1': 'low_balance', '3': 11, '4': 1, '5': 11, '6': '.sideswap.proto.From.Quote.LowBalance', '9': 0, '10': 'lowBalance'},
    {'1': 'error', '3': 12, '4': 1, '5': 9, '9': 0, '10': 'error'},
    {'1': 'unregistered_gaid', '3': 13, '4': 1, '5': 11, '6': '.sideswap.proto.From.Quote.UnregisteredGaid', '9': 0, '10': 'unregisteredGaid'},
    {'1': 'ind_price', '3': 14, '4': 1, '5': 11, '6': '.sideswap.proto.From.Quote.IndPrice', '9': 0, '10': 'indPrice'},
  ],
  '3': [From_Quote_Success$json, From_Quote_LowBalance$json, From_Quote_IndPrice$json, From_Quote_UnregisteredGaid$json],
  '8': [
    {'1': 'result'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_Quote_Success$json = {
  '1': 'Success',
  '2': [
    {'1': 'quote_id', '3': 1, '4': 2, '5': 4, '10': 'quoteId'},
    {'1': 'base_amount', '3': 2, '4': 2, '5': 4, '10': 'baseAmount'},
    {'1': 'quote_amount', '3': 3, '4': 2, '5': 4, '10': 'quoteAmount'},
    {'1': 'server_fee', '3': 4, '4': 2, '5': 4, '10': 'serverFee'},
    {'1': 'fixed_fee', '3': 5, '4': 2, '5': 4, '10': 'fixedFee'},
    {'1': 'ttl_milliseconds', '3': 6, '4': 2, '5': 4, '10': 'ttlMilliseconds'},
    {'1': 'price_taker', '3': 7, '4': 2, '5': 1, '10': 'priceTaker'},
    {'1': 'send_amount', '3': 8, '4': 2, '5': 4, '10': 'sendAmount'},
    {'1': 'recv_amount', '3': 9, '4': 2, '5': 4, '10': 'recvAmount'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_Quote_LowBalance$json = {
  '1': 'LowBalance',
  '2': [
    {'1': 'base_amount', '3': 1, '4': 2, '5': 4, '10': 'baseAmount'},
    {'1': 'quote_amount', '3': 2, '4': 2, '5': 4, '10': 'quoteAmount'},
    {'1': 'server_fee', '3': 3, '4': 2, '5': 4, '10': 'serverFee'},
    {'1': 'fixed_fee', '3': 4, '4': 2, '5': 4, '10': 'fixedFee'},
    {'1': 'available', '3': 5, '4': 2, '5': 4, '10': 'available'},
    {'1': 'price_taker', '3': 6, '4': 2, '5': 1, '10': 'priceTaker'},
    {'1': 'send_amount', '3': 7, '4': 2, '5': 4, '10': 'sendAmount'},
    {'1': 'recv_amount', '3': 8, '4': 2, '5': 4, '10': 'recvAmount'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_Quote_IndPrice$json = {
  '1': 'IndPrice',
  '2': [
    {'1': 'price_taker', '3': 1, '4': 2, '5': 1, '10': 'priceTaker'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_Quote_UnregisteredGaid$json = {
  '1': 'UnregisteredGaid',
  '2': [
    {'1': 'domain_agent', '3': 1, '4': 2, '5': 9, '10': 'domainAgent'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_AcceptQuote$json = {
  '1': 'AcceptQuote',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 11, '6': '.sideswap.proto.From.AcceptQuote.Success', '9': 0, '10': 'success'},
    {'1': 'error', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'error'},
  ],
  '3': [From_AcceptQuote_Success$json],
  '8': [
    {'1': 'result'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_AcceptQuote_Success$json = {
  '1': 'Success',
  '2': [
    {'1': 'txid', '3': 1, '4': 2, '5': 9, '10': 'txid'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_ChartsSubscribe$json = {
  '1': 'ChartsSubscribe',
  '2': [
    {'1': 'asset_pair', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.AssetPair', '10': 'assetPair'},
    {'1': 'data', '3': 2, '4': 3, '5': 11, '6': '.sideswap.proto.ChartPoint', '10': 'data'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_ChartsUpdate$json = {
  '1': 'ChartsUpdate',
  '2': [
    {'1': 'asset_pair', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.AssetPair', '10': 'assetPair'},
    {'1': 'update', '3': 2, '4': 2, '5': 11, '6': '.sideswap.proto.ChartPoint', '10': 'update'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_LoadHistory$json = {
  '1': 'LoadHistory',
  '2': [
    {'1': 'list', '3': 1, '4': 3, '5': 11, '6': '.sideswap.proto.HistoryOrder', '10': 'list'},
    {'1': 'total', '3': 2, '4': 2, '5': 13, '10': 'total'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_HistoryUpdated$json = {
  '1': 'HistoryUpdated',
  '2': [
    {'1': 'order', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.HistoryOrder', '10': 'order'},
    {'1': 'is_new', '3': 2, '4': 2, '5': 8, '10': 'isNew'},
  ],
};

/// Descriptor for `From`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fromDescriptor = $convert.base64Decode(
    'CgRGcm9tEjIKBWxvZ2luGBEgASgLMhouc2lkZXN3YXAucHJvdG8uRnJvbS5Mb2dpbkgAUgVsb2'
    'dpbhIvCgZsb2dvdXQYECABKAsyFS5zaWRlc3dhcC5wcm90by5FbXB0eUgAUgZsb2dvdXQSRQoM'
    'ZW52X3NldHRpbmdzGA0gASgLMiAuc2lkZXN3YXAucHJvdG8uRnJvbS5FbnZTZXR0aW5nc0gAUg'
    'tlbnZTZXR0aW5ncxJFCgxyZWdpc3Rlcl9hbXAYCCABKAsyIC5zaWRlc3dhcC5wcm90by5Gcm9t'
    'LlJlZ2lzdGVyQW1wSABSC3JlZ2lzdGVyQW1wEkIKC3VwZGF0ZWRfdHhzGAEgASgLMh8uc2lkZX'
    'N3YXAucHJvdG8uRnJvbS5VcGRhdGVkVHhzSABSCnVwZGF0ZWRUeHMSQgoLcmVtb3ZlZF90eHMY'
    'DCABKAsyHy5zaWRlc3dhcC5wcm90by5Gcm9tLlJlbW92ZWRUeHNIAFIKcmVtb3ZlZFR4cxJFCg'
    'x1cGRhdGVkX3BlZ3MYAiABKAsyIC5zaWRlc3dhcC5wcm90by5Gcm9tLlVwZGF0ZWRQZWdzSABS'
    'C3VwZGF0ZWRQZWdzEjQKCW5ld19hc3NldBgDIAEoCzIVLnNpZGVzd2FwLnByb3RvLkFzc2V0SA'
    'BSCG5ld0Fzc2V0Ej8KCmFtcF9hc3NldHMYCSABKAsyHi5zaWRlc3dhcC5wcm90by5Gcm9tLkFt'
    'cEFzc2V0c0gAUglhbXBBc3NldHMSSwoOYmFsYW5jZV91cGRhdGUYBCABKAsyIi5zaWRlc3dhcC'
    '5wcm90by5Gcm9tLkJhbGFuY2VVcGRhdGVIAFINYmFsYW5jZVVwZGF0ZRJDCg1zZXJ2ZXJfc3Rh'
    'dHVzGAUgASgLMhwuc2lkZXN3YXAucHJvdG8uU2VydmVyU3RhdHVzSABSDHNlcnZlclN0YXR1cx'
    'JFCgxwcmljZV91cGRhdGUYBiABKAsyIC5zaWRlc3dhcC5wcm90by5Gcm9tLlByaWNlVXBkYXRl'
    'SABSC3ByaWNlVXBkYXRlEjwKDXdhbGxldF9sb2FkZWQYByABKAsyFS5zaWRlc3dhcC5wcm90by'
    '5FbXB0eUgAUgx3YWxsZXRMb2FkZWQSPAoNc3luY19jb21wbGV0ZRgOIAEoCzIVLnNpZGVzd2Fw'
    'LnByb3RvLkVtcHR5SABSDHN5bmNDb21wbGV0ZRJRChBzdWJzY3JpYmVkX3ZhbHVlGA8gASgLMi'
    'Quc2lkZXN3YXAucHJvdG8uRnJvbS5TdWJzY3JpYmVkVmFsdWVIAFIPc3Vic2NyaWJlZFZhbHVl'
    'EkIKC2VuY3J5cHRfcGluGAogASgLMh8uc2lkZXN3YXAucHJvdG8uRnJvbS5FbmNyeXB0UGluSA'
    'BSCmVuY3J5cHRQaW4SQgoLZGVjcnlwdF9waW4YCyABKAsyHy5zaWRlc3dhcC5wcm90by5Gcm9t'
    'LkRlY3J5cHRQaW5IAFIKZGVjcnlwdFBpbhJGCg1wZWdpbl93YWl0X3R4GBUgASgLMiAuc2lkZX'
    'N3YXAucHJvdG8uRnJvbS5QZWdpbldhaXRUeEgAUgtwZWdpbldhaXRUeBJJCg5wZWdfb3V0X2Ft'
    'b3VudBgYIAEoCzIhLnNpZGVzd2FwLnByb3RvLkZyb20uUGVnT3V0QW1vdW50SABSDHBlZ091dE'
    'Ftb3VudBI+Cgxzd2FwX3N1Y2NlZWQYFiABKAsyGS5zaWRlc3dhcC5wcm90by5UcmFuc0l0ZW1I'
    'AFILc3dhcFN1Y2NlZWQSIQoLc3dhcF9mYWlsZWQYFyABKAlIAFIKc3dhcEZhaWxlZBJFCgxyZW'
    'N2X2FkZHJlc3MYHiABKAsyIC5zaWRlc3dhcC5wcm90by5Gcm9tLlJlY3ZBZGRyZXNzSABSC3Jl'
    'Y3ZBZGRyZXNzEk8KEGNyZWF0ZV90eF9yZXN1bHQYHyABKAsyIy5zaWRlc3dhcC5wcm90by5Gcm'
    '9tLkNyZWF0ZVR4UmVzdWx0SABSDmNyZWF0ZVR4UmVzdWx0EkIKC3NlbmRfcmVzdWx0GCAgASgL'
    'Mh8uc2lkZXN3YXAucHJvdG8uRnJvbS5TZW5kUmVzdWx0SABSCnNlbmRSZXN1bHQSSwoOYmxpbm'
    'RlZF92YWx1ZXMYISABKAsyIi5zaWRlc3dhcC5wcm90by5Gcm9tLkJsaW5kZWRWYWx1ZXNIAFIN'
    'YmxpbmRlZFZhbHVlcxI/Cgpsb2FkX3V0eG9zGCMgASgLMh4uc2lkZXN3YXAucHJvdG8uRnJvbS'
    '5Mb2FkVXR4b3NIAFIJbG9hZFV0eG9zEksKDmxvYWRfYWRkcmVzc2VzGCQgASgLMiIuc2lkZXN3'
    'YXAucHJvdG8uRnJvbS5Mb2FkQWRkcmVzc2VzSABSDWxvYWRBZGRyZXNzZXMSVAoRbG9hZF90cm'
    'Fuc2FjdGlvbnMYJSABKAsyJS5zaWRlc3dhcC5wcm90by5Gcm9tLkxvYWRUcmFuc2FjdGlvbnNI'
    'AFIQbG9hZFRyYW5zYWN0aW9ucxJRChBzaG93X3RyYW5zYWN0aW9uGCYgASgLMiQuc2lkZXN3YX'
    'AucHJvdG8uRnJvbS5TaG93VHJhbnNhY3Rpb25IAFIPc2hvd1RyYW5zYWN0aW9uEkUKDHNob3df'
    'bWVzc2FnZRgyIAEoCzIgLnNpZGVzd2FwLnByb3RvLkZyb20uU2hvd01lc3NhZ2VIAFILc2hvd0'
    '1lc3NhZ2USWwoSaW5zdWZmaWNpZW50X2Z1bmRzGDcgASgLMiouc2lkZXN3YXAucHJvdG8uRnJv'
    'bS5TaG93SW5zdWZmaWNpZW50RnVuZHNIAFIRaW5zdWZmaWNpZW50RnVuZHMSQgoQc2VydmVyX2'
    'Nvbm5lY3RlZBg8IAEoCzIVLnNpZGVzd2FwLnByb3RvLkVtcHR5SABSD3NlcnZlckNvbm5lY3Rl'
    'ZBJIChNzZXJ2ZXJfZGlzY29ubmVjdGVkGD0gASgLMhUuc2lkZXN3YXAucHJvdG8uRW1wdHlIAF'
    'ISc2VydmVyRGlzY29ubmVjdGVkEkgKDWFzc2V0X2RldGFpbHMYQSABKAsyIS5zaWRlc3dhcC5w'
    'cm90by5Gcm9tLkFzc2V0RGV0YWlsc0gAUgxhc3NldERldGFpbHMSNAoJbmV3X2Jsb2NrGD4gAS'
    'gLMhUuc2lkZXN3YXAucHJvdG8uRW1wdHlIAFIIbmV3QmxvY2sSLgoGbmV3X3R4GD8gASgLMhUu'
    'c2lkZXN3YXAucHJvdG8uRW1wdHlIAFIFbmV3VHgSSAoNbG9jYWxfbWVzc2FnZRhEIAEoCzIhLn'
    'NpZGVzd2FwLnByb3RvLkZyb20uTG9jYWxNZXNzYWdlSABSDGxvY2FsTWVzc2FnZRJRChBwb3J0'
    'Zm9saW9fcHJpY2VzGEggASgLMiQuc2lkZXN3YXAucHJvdG8uRnJvbS5Qb3J0Zm9saW9QcmljZX'
    'NIAFIPcG9ydGZvbGlvUHJpY2VzElEKEGNvbnZlcnNpb25fcmF0ZXMYSSABKAsyJC5zaWRlc3dh'
    'cC5wcm90by5Gcm9tLkNvbnZlcnNpb25SYXRlc0gAUg9jb252ZXJzaW9uUmF0ZXMSPwoKamFkZV'
    '9wb3J0cxhQIAEoCzIeLnNpZGVzd2FwLnByb3RvLkZyb20uSmFkZVBvcnRzSABSCWphZGVQb3J0'
    'cxJCCgtqYWRlX3N0YXR1cxhTIAEoCzIfLnNpZGVzd2FwLnByb3RvLkZyb20uSmFkZVN0YXR1c0'
    'gAUgpqYWRlU3RhdHVzEkIKC2phZGVfdW5sb2NrGFEgASgLMh8uc2lkZXN3YXAucHJvdG8uR2Vu'
    'ZXJpY1Jlc3BvbnNlSABSCmphZGVVbmxvY2sSUQoTamFkZV92ZXJpZnlfYWRkcmVzcxhSIAEoCz'
    'IfLnNpZGVzd2FwLnByb3RvLkdlbmVyaWNSZXNwb25zZUgAUhFqYWRlVmVyaWZ5QWRkcmVzcxJC'
    'CgtnYWlkX3N0YXR1cxhbIAEoCzIfLnNpZGVzd2FwLnByb3RvLkZyb20uR2FpZFN0YXR1c0gAUg'
    'pnYWlkU3RhdHVzEkIKC21hcmtldF9saXN0GGQgASgLMh8uc2lkZXN3YXAucHJvdG8uRnJvbS5N'
    'YXJrZXRMaXN0SABSCm1hcmtldExpc3QSPwoMbWFya2V0X2FkZGVkGGUgASgLMhouc2lkZXN3YX'
    'AucHJvdG8uTWFya2V0SW5mb0gAUgttYXJrZXRBZGRlZBJCCg5tYXJrZXRfcmVtb3ZlZBhmIAEo'
    'CzIZLnNpZGVzd2FwLnByb3RvLkFzc2V0UGFpckgAUg1tYXJrZXRSZW1vdmVkEkgKDXB1YmxpY1'
    '9vcmRlcnMYaSABKAsyIS5zaWRlc3dhcC5wcm90by5Gcm9tLlB1YmxpY09yZGVyc0gAUgxwdWJs'
    'aWNPcmRlcnMSTwoUcHVibGljX29yZGVyX2NyZWF0ZWQYaiABKAsyGy5zaWRlc3dhcC5wcm90by'
    '5QdWJsaWNPcmRlckgAUhJwdWJsaWNPcmRlckNyZWF0ZWQSSwoUcHVibGljX29yZGVyX3JlbW92'
    'ZWQYayABKAsyFy5zaWRlc3dhcC5wcm90by5PcmRlcklkSABSEnB1YmxpY09yZGVyUmVtb3ZlZB'
    'JFCgxtYXJrZXRfcHJpY2UYbiABKAsyIC5zaWRlc3dhcC5wcm90by5Gcm9tLk1hcmtldFByaWNl'
    'SABSC21hcmtldFByaWNlElUKEm1pbl9tYXJrZXRfYW1vdW50cxh3IAEoCzIlLnNpZGVzd2FwLn'
    'Byb3RvLkZyb20uTWluTWFya2V0QW1vdW50c0gAUhBtaW5NYXJrZXRBbW91bnRzEj8KCm93bl9v'
    'cmRlcnMYeCABKAsyHi5zaWRlc3dhcC5wcm90by5Gcm9tLk93bk9yZGVyc0gAUglvd25PcmRlcn'
    'MSRgoRb3duX29yZGVyX2NyZWF0ZWQYeSABKAsyGC5zaWRlc3dhcC5wcm90by5Pd25PcmRlckgA'
    'Ug9vd25PcmRlckNyZWF0ZWQSRQoRb3duX29yZGVyX3JlbW92ZWQYeiABKAsyFy5zaWRlc3dhcC'
    '5wcm90by5PcmRlcklkSABSD293bk9yZGVyUmVtb3ZlZBJGCgxvcmRlcl9zdWJtaXQYggEgASgL'
    'MiAuc2lkZXN3YXAucHJvdG8uRnJvbS5PcmRlclN1Ym1pdEgAUgtvcmRlclN1Ym1pdBJBCgpvcm'
    'Rlcl9lZGl0GIMBIAEoCzIfLnNpZGVzd2FwLnByb3RvLkdlbmVyaWNSZXNwb25zZUgAUglvcmRl'
    'ckVkaXQSRQoMb3JkZXJfY2FuY2VsGIQBIAEoCzIfLnNpZGVzd2FwLnByb3RvLkdlbmVyaWNSZX'
    'Nwb25zZUgAUgtvcmRlckNhbmNlbBJDCgtzdGFydF9vcmRlchiOASABKAsyHy5zaWRlc3dhcC5w'
    'cm90by5Gcm9tLlN0YXJ0T3JkZXJIAFIKc3RhcnRPcmRlchIzCgVxdW90ZRiMASABKAsyGi5zaW'
    'Rlc3dhcC5wcm90by5Gcm9tLlF1b3RlSABSBXF1b3RlEkYKDGFjY2VwdF9xdW90ZRiNASABKAsy'
    'IC5zaWRlc3dhcC5wcm90by5Gcm9tLkFjY2VwdFF1b3RlSABSC2FjY2VwdFF1b3RlElIKEGNoYX'
    'J0c19zdWJzY3JpYmUYlgEgASgLMiQuc2lkZXN3YXAucHJvdG8uRnJvbS5DaGFydHNTdWJzY3Jp'
    'YmVIAFIPY2hhcnRzU3Vic2NyaWJlEkkKDWNoYXJ0c191cGRhdGUYlwEgASgLMiEuc2lkZXN3YX'
    'AucHJvdG8uRnJvbS5DaGFydHNVcGRhdGVIAFIMY2hhcnRzVXBkYXRlEkYKDGxvYWRfaGlzdG9y'
    'eRigASABKAsyIC5zaWRlc3dhcC5wcm90by5Gcm9tLkxvYWRIaXN0b3J5SABSC2xvYWRIaXN0b3'
    'J5Ek8KD2hpc3RvcnlfdXBkYXRlZBihASABKAsyIy5zaWRlc3dhcC5wcm90by5Gcm9tLkhpc3Rv'
    'cnlVcGRhdGVkSABSDmhpc3RvcnlVcGRhdGVkGmMKBUxvZ2luEh0KCWVycm9yX21zZxgBIAEoCU'
    'gAUghlcnJvck1zZxIxCgdzdWNjZXNzGAIgASgLMhUuc2lkZXN3YXAucHJvdG8uRW1wdHlIAFIH'
    'c3VjY2Vzc0IICgZyZXN1bHQafQoLRW52U2V0dGluZ3MSJgoPcG9saWN5X2Fzc2V0X2lkGAEgAi'
    'gJUg1wb2xpY3lBc3NldElkEiIKDXVzZHRfYXNzZXRfaWQYAiACKAlSC3VzZHRBc3NldElkEiIK'
    'DWV1cnhfYXNzZXRfaWQYAyACKAlSC2V1cnhBc3NldElkGugBCgpFbmNyeXB0UGluEhYKBWVycm'
    '9yGAEgASgJSABSBWVycm9yEjoKBGRhdGEYAiABKAsyJC5zaWRlc3dhcC5wcm90by5Gcm9tLkVu'
    'Y3J5cHRQaW4uRGF0YUgAUgRkYXRhGnwKBERhdGESEgoEc2FsdBgCIAIoCVIEc2FsdBIlCg5lbm'
    'NyeXB0ZWRfZGF0YRgDIAIoCVINZW5jcnlwdGVkRGF0YRIlCg5waW5faWRlbnRpZmllchgEIAIo'
    'CVINcGluSWRlbnRpZmllchISCgRobWFjGAUgASgJUgRobWFjQggKBnJlc3VsdBqkAgoKRGVjcn'
    'lwdFBpbhI9CgVlcnJvchgBIAEoCzIlLnNpZGVzd2FwLnByb3RvLkZyb20uRGVjcnlwdFBpbi5F'
    'cnJvckgAUgVlcnJvchIcCghtbmVtb25pYxgCIAEoCUgAUghtbmVtb25pYxpuCgVFcnJvchIbCg'
    'llcnJvcl9tc2cYASACKAlSCGVycm9yTXNnEkgKCmVycm9yX2NvZGUYAiACKA4yKS5zaWRlc3dh'
    'cC5wcm90by5Gcm9tLkRlY3J5cHRQaW4uRXJyb3JDb2RlUgllcnJvckNvZGUiPwoJRXJyb3JDb2'
    'RlEg0KCVdST05HX1BJThABEhEKDU5FVFdPUktfRVJST1IQAhIQCgxJTlZBTElEX0RBVEEQA0II'
    'CgZyZXN1bHQaTwoLUmVnaXN0ZXJBbXASFwoGYW1wX2lkGAEgASgJSABSBWFtcElkEh0KCWVycm'
    '9yX21zZxgCIAEoCUgAUghlcnJvck1zZ0IICgZyZXN1bHQaIwoJQW1wQXNzZXRzEhYKBmFzc2V0'
    'cxgBIAMoCVIGYXNzZXRzGj0KClVwZGF0ZWRUeHMSLwoFaXRlbXMYASADKAsyGS5zaWRlc3dhcC'
    '5wcm90by5UcmFuc0l0ZW1SBWl0ZW1zGiIKClJlbW92ZWRUeHMSFAoFdHhpZHMYASADKAlSBXR4'
    'aWRzGlkKC1VwZGF0ZWRQZWdzEhkKCG9yZGVyX2lkGAEgAigJUgdvcmRlcklkEi8KBWl0ZW1zGA'
    'IgAygLMhkuc2lkZXN3YXAucHJvdG8uVHJhbnNJdGVtUgVpdGVtcxp3Cg1CYWxhbmNlVXBkYXRl'
    'EjEKB2FjY291bnQYASACKA4yFy5zaWRlc3dhcC5wcm90by5BY2NvdW50UgdhY2NvdW50EjMKCG'
    'JhbGFuY2VzGAIgAygLMhcuc2lkZXN3YXAucHJvdG8uQmFsYW5jZVIIYmFsYW5jZXMaYAoLUGVn'
    'aW5XYWl0VHgSGQoIb3JkZXJfaWQYASACKAlSB29yZGVySWQSGQoIcGVnX2FkZHIYBSACKAlSB3'
    'BlZ0FkZHISGwoJcmVjdl9hZGRyGAYgAigJUghyZWN2QWRkchqPAgoMUGVnT3V0QW1vdW50Eh0K'
    'CWVycm9yX21zZxgBIAEoCUgAUghlcnJvck1zZxJFCgdhbW91bnRzGAIgASgLMikuc2lkZXN3YX'
    'AucHJvdG8uRnJvbS5QZWdPdXRBbW91bnQuQW1vdW50c0gAUgdhbW91bnRzGo4BCgdBbW91bnRz'
    'Eh8KC3NlbmRfYW1vdW50GAEgAigDUgpzZW5kQW1vdW50Eh8KC3JlY3ZfYW1vdW50GAIgAigDUg'
    'pyZWN2QW1vdW50EiYKD2lzX3NlbmRfZW50ZXJlZBgEIAIoCFINaXNTZW5kRW50ZXJlZBIZCghm'
    'ZWVfcmF0ZRgFIAIoAVIHZmVlUmF0ZUIICgZyZXN1bHQabQoLUmVjdkFkZHJlc3MSKwoEYWRkch'
    'gBIAIoCzIXLnNpZGVzd2FwLnByb3RvLkFkZHJlc3NSBGFkZHISMQoHYWNjb3VudBgCIAIoDjIX'
    'LnNpZGVzd2FwLnByb3RvLkFjY291bnRSB2FjY291bnQa3gIKCUxvYWRVdHhvcxIxCgdhY2NvdW'
    '50GAEgAigOMhcuc2lkZXN3YXAucHJvdG8uQWNjb3VudFIHYWNjb3VudBI5CgV1dHhvcxgCIAMo'
    'CzIjLnNpZGVzd2FwLnByb3RvLkZyb20uTG9hZFV0eG9zLlV0eG9SBXV0eG9zEhsKCWVycm9yX2'
    '1zZxgDIAEoCVIIZXJyb3JNc2caxQEKBFV0eG8SEgoEdHhpZBgBIAIoCVIEdHhpZBISCgR2b3V0'
    'GAIgAigNUgR2b3V0EhkKCGFzc2V0X2lkGAMgAigJUgdhc3NldElkEhYKBmFtb3VudBgEIAIoBF'
    'IGYW1vdW50EhgKB2FkZHJlc3MYBSACKAlSB2FkZHJlc3MSHwoLaXNfaW50ZXJuYWwYBiACKAhS'
    'CmlzSW50ZXJuYWwSJwoPaXNfY29uZmlkZW50aWFsGAcgAigIUg5pc0NvbmZpZGVudGlhbBr6Ag'
    'oNTG9hZEFkZHJlc3NlcxIxCgdhY2NvdW50GAEgAigOMhcuc2lkZXN3YXAucHJvdG8uQWNjb3Vu'
    'dFIHYWNjb3VudBJICglhZGRyZXNzZXMYAiADKAsyKi5zaWRlc3dhcC5wcm90by5Gcm9tLkxvYW'
    'RBZGRyZXNzZXMuQWRkcmVzc1IJYWRkcmVzc2VzEhsKCWVycm9yX21zZxgDIAEoCVIIZXJyb3JN'
    'c2cazgEKB0FkZHJlc3MSGAoHYWRkcmVzcxgBIAIoCVIHYWRkcmVzcxI1ChZ1bmNvbmZpZGVudG'
    'lhbF9hZGRyZXNzGAQgAigJUhV1bmNvbmZpZGVudGlhbEFkZHJlc3MSFAoFaW5kZXgYAiACKA1S'
    'BWluZGV4Eh8KC2lzX2ludGVybmFsGAMgAigIUgppc0ludGVybmFsEjsKC3NjcmlwdF90eXBlGA'
    'UgAigOMhouc2lkZXN3YXAucHJvdG8uU2NyaXB0VHlwZVIKc2NyaXB0VHlwZRpcChBMb2FkVHJh'
    'bnNhY3Rpb25zEisKA3R4cxgBIAMoCzIZLnNpZGVzd2FwLnByb3RvLlRyYW5zSXRlbVIDdHhzEh'
    'sKCWVycm9yX21zZxgDIAEoCVIIZXJyb3JNc2caPAoPU2hvd1RyYW5zYWN0aW9uEikKAnR4GAEg'
    'AigLMhkuc2lkZXN3YXAucHJvdG8uVHJhbnNJdGVtUgJ0eBp1Cg5DcmVhdGVUeFJlc3VsdBIdCg'
    'llcnJvcl9tc2cYASABKAlIAFIIZXJyb3JNc2cSOgoKY3JlYXRlZF90eBgCIAEoCzIZLnNpZGVz'
    'd2FwLnByb3RvLkNyZWF0ZWRUeEgAUgljcmVhdGVkVHhCCAoGcmVzdWx0GmsKClNlbmRSZXN1bH'
    'QSHQoJZXJyb3JfbXNnGAEgASgJSABSCGVycm9yTXNnEjQKB3R4X2l0ZW0YAiABKAsyGS5zaWRl'
    'c3dhcC5wcm90by5UcmFuc0l0ZW1IAFIGdHhJdGVtQggKBnJlc3VsdBp1Cg1CbGluZGVkVmFsdW'
    'VzEhIKBHR4aWQYASACKAlSBHR4aWQSHQoJZXJyb3JfbXNnGAIgASgJSABSCGVycm9yTXNnEicK'
    'DmJsaW5kZWRfdmFsdWVzGAMgASgJSABSDWJsaW5kZWRWYWx1ZXNCCAoGcmVzdWx0GkcKC1ByaW'
    'NlVXBkYXRlEhQKBWFzc2V0GAEgAigJUgVhc3NldBIQCgNiaWQYAiACKAFSA2JpZBIQCgNhc2sY'
    'AyACKAFSA2FzaxrjAQoPU3Vic2NyaWJlZFZhbHVlEisKEXBlZ19pbl9taW5fYW1vdW50GAEgAS'
    'gESABSDnBlZ0luTWluQW1vdW50EjMKFXBlZ19pbl93YWxsZXRfYmFsYW5jZRgCIAEoBEgAUhJw'
    'ZWdJbldhbGxldEJhbGFuY2USLQoScGVnX291dF9taW5fYW1vdW50GAMgASgESABSD3BlZ091dE'
    '1pbkFtb3VudBI1ChZwZWdfb3V0X3dhbGxldF9iYWxhbmNlGAQgASgESABSE3BlZ091dFdhbGxl'
    'dEJhbGFuY2VCCAoGcmVzdWx0GiEKC1Nob3dNZXNzYWdlEhIKBHRleHQYASACKAlSBHRleHQabA'
    'oVU2hvd0luc3VmZmljaWVudEZ1bmRzEhkKCGFzc2V0X2lkGAEgAigJUgdhc3NldElkEhwKCWF2'
    'YWlsYWJsZRgCIAIoA1IJYXZhaWxhYmxlEhoKCHJlcXVpcmVkGAMgAigDUghyZXF1aXJlZBq0Ag'
    'oMQXNzZXREZXRhaWxzEhkKCGFzc2V0X2lkGAEgAigJUgdhc3NldElkEj0KBXN0YXRzGAIgASgL'
    'Micuc2lkZXN3YXAucHJvdG8uRnJvbS5Bc3NldERldGFpbHMuU3RhdHNSBXN0YXRzEhsKCWNoYX'
    'J0X3VybBgDIAEoCVIIY2hhcnRVcmwarAEKBVN0YXRzEiMKDWlzc3VlZF9hbW91bnQYASACKANS'
    'DGlzc3VlZEFtb3VudBIjCg1idXJuZWRfYW1vdW50GAIgAigDUgxidXJuZWRBbW91bnQSJQoOb2'
    'ZmbGluZV9hbW91bnQYBCACKANSDW9mZmxpbmVBbW91bnQSMgoVaGFzX2JsaW5kZWRfaXNzdWFu'
    'Y2VzGAMgAigIUhNoYXNCbGluZGVkSXNzdWFuY2VzGjgKDExvY2FsTWVzc2FnZRIUCgV0aXRsZR'
    'gBIAIoCVIFdGl0bGUSEgoEYm9keRgCIAIoCVIEYm9keRqjAQoPUG9ydGZvbGlvUHJpY2VzElIK'
    'CnByaWNlc191c2QYASADKAsyMy5zaWRlc3dhcC5wcm90by5Gcm9tLlBvcnRmb2xpb1ByaWNlcy'
    '5QcmljZXNVc2RFbnRyeVIJcHJpY2VzVXNkGjwKDlByaWNlc1VzZEVudHJ5EhAKA2tleRgBIAEo'
    'CVIDa2V5EhQKBXZhbHVlGAIgASgBUgV2YWx1ZToCOAEayAEKD0NvbnZlcnNpb25SYXRlcxJuCh'
    'R1c2RfY29udmVyc2lvbl9yYXRlcxgBIAMoCzI8LnNpZGVzd2FwLnByb3RvLkZyb20uQ29udmVy'
    'c2lvblJhdGVzLlVzZENvbnZlcnNpb25SYXRlc0VudHJ5UhJ1c2RDb252ZXJzaW9uUmF0ZXMaRQ'
    'oXVXNkQ29udmVyc2lvblJhdGVzRW50cnkSEAoDa2V5GAEgASgJUgNrZXkSFAoFdmFsdWUYAiAB'
    'KAFSBXZhbHVlOgI4ARp7CglKYWRlUG9ydHMSOQoFcG9ydHMYASADKAsyIy5zaWRlc3dhcC5wcm'
    '90by5Gcm9tLkphZGVQb3J0cy5Qb3J0UgVwb3J0cxozCgRQb3J0EhcKB2phZGVfaWQYASACKAlS'
    'BmphZGVJZBISCgRwb3J0GAIgAigJUgRwb3J0GoUCCgpKYWRlU3RhdHVzEj4KBnN0YXR1cxgBIA'
    'IoDjImLnNpZGVzd2FwLnByb3RvLkZyb20uSmFkZVN0YXR1cy5TdGF0dXNSBnN0YXR1cyK2AQoG'
    'U3RhdHVzEg4KCkNPTk5FQ1RJTkcQCRIICgRJRExFEAESDwoLUkVBRF9TVEFUVVMQAhINCglBVV'
    'RIX1VTRVIQAxIXChNNQVNURVJfQkxJTkRJTkdfS0VZEAUSEAoMU0lHTl9NRVNTQUdFEAoSCwoH'
    'U0lHTl9UWBAEEg0KCVNJR05fU1dBUBAIEhQKEFNJR05fU1dBUF9PVVRQVVQQBhIVChFTSUdOX0'
    '9GRkxJTkVfU1dBUBAHGlEKCkdhaWRTdGF0dXMSEgoEZ2FpZBgBIAIoCVIEZ2FpZBIZCghhc3Nl'
    'dF9pZBgCIAIoCVIHYXNzZXRJZBIUCgVlcnJvchgDIAEoCVIFZXJyb3IaQgoKTWFya2V0TGlzdB'
    'I0CgdtYXJrZXRzGAEgAygLMhouc2lkZXN3YXAucHJvdG8uTWFya2V0SW5mb1IHbWFya2V0cxp5'
    'CgxQdWJsaWNPcmRlcnMSOAoKYXNzZXRfcGFpchgBIAIoCzIZLnNpZGVzd2FwLnByb3RvLkFzc2'
    'V0UGFpclIJYXNzZXRQYWlyEi8KBGxpc3QYAiADKAsyGy5zaWRlc3dhcC5wcm90by5QdWJsaWNP'
    'cmRlclIEbGlzdBpOChBNaW5NYXJrZXRBbW91bnRzEhIKBGxidGMYASACKARSBGxidGMSEgoEdX'
    'NkdBgCIAIoBFIEdXNkdBISCgRldXJ4GAMgAigEUgRldXJ4GjkKCU93bk9yZGVycxIsCgRsaXN0'
    'GAEgAygLMhguc2lkZXN3YXAucHJvdG8uT3duT3JkZXJSBGxpc3QagwEKC01hcmtldFByaWNlEj'
    'gKCmFzc2V0X3BhaXIYASACKAsyGS5zaWRlc3dhcC5wcm90by5Bc3NldFBhaXJSCWFzc2V0UGFp'
    'chIbCglpbmRfcHJpY2UYAiABKAFSCGluZFByaWNlEh0KCmxhc3RfcHJpY2UYAyABKAFSCWxhc3'
    'RQcmljZRqLAgoLT3JkZXJTdWJtaXQSQQoOc3VibWl0X3N1Y2NlZWQYASABKAsyGC5zaWRlc3dh'
    'cC5wcm90by5Pd25PcmRlckgAUg1zdWJtaXRTdWNjZWVkEhYKBWVycm9yGAIgASgJSABSBWVycm'
    '9yEmAKEXVucmVnaXN0ZXJlZF9nYWlkGAMgASgLMjEuc2lkZXN3YXAucHJvdG8uRnJvbS5PcmRl'
    'clN1Ym1pdC5VbnJlZ2lzdGVyZWRHYWlkSABSEHVucmVnaXN0ZXJlZEdhaWQaNQoQVW5yZWdpc3'
    'RlcmVkR2FpZBIhCgxkb21haW5fYWdlbnQYASACKAlSC2RvbWFpbkFnZW50QggKBnJlc3VsdBqM'
    'AwoKU3RhcnRPcmRlchIZCghvcmRlcl9pZBgFIAIoBFIHb3JkZXJJZBJDCgdzdWNjZXNzGAEgAS'
    'gLMicuc2lkZXN3YXAucHJvdG8uRnJvbS5TdGFydE9yZGVyLlN1Y2Nlc3NIAFIHc3VjY2VzcxIW'
    'CgVlcnJvchgCIAEoCUgAUgVlcnJvchr7AQoHU3VjY2VzcxI4Cgphc3NldF9wYWlyGAEgAigLMh'
    'kuc2lkZXN3YXAucHJvdG8uQXNzZXRQYWlyUglhc3NldFBhaXISNQoJdHJhZGVfZGlyGAIgAigO'
    'Mhguc2lkZXN3YXAucHJvdG8uVHJhZGVEaXJSCHRyYWRlRGlyEhYKBmFtb3VudBgDIAIoBFIGYW'
    '1vdW50EhQKBXByaWNlGAQgAigBUgVwcmljZRI2CglmZWVfYXNzZXQYBSACKA4yGS5zaWRlc3dh'
    'cC5wcm90by5Bc3NldFR5cGVSCGZlZUFzc2V0EhkKCHR3b19zdGVwGAYgAigIUgd0d29TdGVwQg'
    'gKBnJlc3VsdBr+CQoFUXVvdGUSOAoKYXNzZXRfcGFpchgBIAIoCzIZLnNpZGVzd2FwLnByb3Rv'
    'LkFzc2V0UGFpclIJYXNzZXRQYWlyEjgKCmFzc2V0X3R5cGUYAiACKA4yGS5zaWRlc3dhcC5wcm'
    '90by5Bc3NldFR5cGVSCWFzc2V0VHlwZRIWCgZhbW91bnQYAyACKARSBmFtb3VudBI1Cgl0cmFk'
    'ZV9kaXIYBCACKA4yGC5zaWRlc3dhcC5wcm90by5UcmFkZURpclIIdHJhZGVEaXISGQoIb3JkZX'
    'JfaWQYBSABKARSB29yZGVySWQSIgoNY2xpZW50X3N1Yl9pZBgGIAEoA1ILY2xpZW50U3ViSWQS'
    'PgoHc3VjY2VzcxgKIAEoCzIiLnNpZGVzd2FwLnByb3RvLkZyb20uUXVvdGUuU3VjY2Vzc0gAUg'
    'dzdWNjZXNzEkgKC2xvd19iYWxhbmNlGAsgASgLMiUuc2lkZXN3YXAucHJvdG8uRnJvbS5RdW90'
    'ZS5Mb3dCYWxhbmNlSABSCmxvd0JhbGFuY2USFgoFZXJyb3IYDCABKAlIAFIFZXJyb3ISWgoRdW'
    '5yZWdpc3RlcmVkX2dhaWQYDSABKAsyKy5zaWRlc3dhcC5wcm90by5Gcm9tLlF1b3RlLlVucmVn'
    'aXN0ZXJlZEdhaWRIAFIQdW5yZWdpc3RlcmVkR2FpZBJCCglpbmRfcHJpY2UYDiABKAsyIy5zaW'
    'Rlc3dhcC5wcm90by5Gcm9tLlF1b3RlLkluZFByaWNlSABSCGluZFByaWNlGrICCgdTdWNjZXNz'
    'EhkKCHF1b3RlX2lkGAEgAigEUgdxdW90ZUlkEh8KC2Jhc2VfYW1vdW50GAIgAigEUgpiYXNlQW'
    '1vdW50EiEKDHF1b3RlX2Ftb3VudBgDIAIoBFILcXVvdGVBbW91bnQSHQoKc2VydmVyX2ZlZRgE'
    'IAIoBFIJc2VydmVyRmVlEhsKCWZpeGVkX2ZlZRgFIAIoBFIIZml4ZWRGZWUSKQoQdHRsX21pbG'
    'xpc2Vjb25kcxgGIAIoBFIPdHRsTWlsbGlzZWNvbmRzEh8KC3ByaWNlX3Rha2VyGAcgAigBUgpw'
    'cmljZVRha2VyEh8KC3NlbmRfYW1vdW50GAggAigEUgpzZW5kQW1vdW50Eh8KC3JlY3ZfYW1vdW'
    '50GAkgAigEUgpyZWN2QW1vdW50Go0CCgpMb3dCYWxhbmNlEh8KC2Jhc2VfYW1vdW50GAEgAigE'
    'UgpiYXNlQW1vdW50EiEKDHF1b3RlX2Ftb3VudBgCIAIoBFILcXVvdGVBbW91bnQSHQoKc2Vydm'
    'VyX2ZlZRgDIAIoBFIJc2VydmVyRmVlEhsKCWZpeGVkX2ZlZRgEIAIoBFIIZml4ZWRGZWUSHAoJ'
    'YXZhaWxhYmxlGAUgAigEUglhdmFpbGFibGUSHwoLcHJpY2VfdGFrZXIYBiACKAFSCnByaWNlVG'
    'FrZXISHwoLc2VuZF9hbW91bnQYByACKARSCnNlbmRBbW91bnQSHwoLcmVjdl9hbW91bnQYCCAC'
    'KARSCnJlY3ZBbW91bnQaKwoISW5kUHJpY2USHwoLcHJpY2VfdGFrZXIYASACKAFSCnByaWNlVG'
    'FrZXIaNQoQVW5yZWdpc3RlcmVkR2FpZBIhCgxkb21haW5fYWdlbnQYASACKAlSC2RvbWFpbkFn'
    'ZW50QggKBnJlc3VsdBqUAQoLQWNjZXB0UXVvdGUSRAoHc3VjY2VzcxgBIAEoCzIoLnNpZGVzd2'
    'FwLnByb3RvLkZyb20uQWNjZXB0UXVvdGUuU3VjY2Vzc0gAUgdzdWNjZXNzEhYKBWVycm9yGAIg'
    'ASgJSABSBWVycm9yGh0KB1N1Y2Nlc3MSEgoEdHhpZBgBIAIoCVIEdHhpZEIICgZyZXN1bHQaew'
    'oPQ2hhcnRzU3Vic2NyaWJlEjgKCmFzc2V0X3BhaXIYASACKAsyGS5zaWRlc3dhcC5wcm90by5B'
    'c3NldFBhaXJSCWFzc2V0UGFpchIuCgRkYXRhGAIgAygLMhouc2lkZXN3YXAucHJvdG8uQ2hhcn'
    'RQb2ludFIEZGF0YRp8CgxDaGFydHNVcGRhdGUSOAoKYXNzZXRfcGFpchgBIAIoCzIZLnNpZGVz'
    'd2FwLnByb3RvLkFzc2V0UGFpclIJYXNzZXRQYWlyEjIKBnVwZGF0ZRgCIAIoCzIaLnNpZGVzd2'
    'FwLnByb3RvLkNoYXJ0UG9pbnRSBnVwZGF0ZRpVCgtMb2FkSGlzdG9yeRIwCgRsaXN0GAEgAygL'
    'Mhwuc2lkZXN3YXAucHJvdG8uSGlzdG9yeU9yZGVyUgRsaXN0EhQKBXRvdGFsGAIgAigNUgV0b3'
    'RhbBpbCg5IaXN0b3J5VXBkYXRlZBIyCgVvcmRlchgBIAIoCzIcLnNpZGVzd2FwLnByb3RvLkhp'
    'c3RvcnlPcmRlclIFb3JkZXISFQoGaXNfbmV3GAIgAigIUgVpc05ld0IFCgNtc2c=');

@$core.Deprecated('Use settingsDescriptor instead')
const Settings$json = {
  '1': 'Settings',
  '2': [
    {'1': 'disabled_accounts', '3': 1, '4': 3, '5': 11, '6': '.sideswap.proto.Settings.AccountAsset', '10': 'disabledAccounts'},
  ],
  '3': [Settings_AccountAsset$json],
};

@$core.Deprecated('Use settingsDescriptor instead')
const Settings_AccountAsset$json = {
  '1': 'AccountAsset',
  '2': [
    {'1': 'account', '3': 1, '4': 2, '5': 14, '6': '.sideswap.proto.Account', '10': 'account'},
    {'1': 'asset_id', '3': 2, '4': 2, '5': 9, '10': 'assetId'},
  ],
};

/// Descriptor for `Settings`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List settingsDescriptor = $convert.base64Decode(
    'CghTZXR0aW5ncxJSChFkaXNhYmxlZF9hY2NvdW50cxgBIAMoCzIlLnNpZGVzd2FwLnByb3RvLl'
    'NldHRpbmdzLkFjY291bnRBc3NldFIQZGlzYWJsZWRBY2NvdW50cxpcCgxBY2NvdW50QXNzZXQS'
    'MQoHYWNjb3VudBgBIAIoDjIXLnNpZGVzd2FwLnByb3RvLkFjY291bnRSB2FjY291bnQSGQoIYX'
    'NzZXRfaWQYAiACKAlSB2Fzc2V0SWQ=');

