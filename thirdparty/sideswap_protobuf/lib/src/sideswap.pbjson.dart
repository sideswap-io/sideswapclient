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
  '3': [To_Login$json, To_NetworkSettings$json, To_ProxySettings$json, To_EncryptPin$json, To_DecryptPin$json, To_AppState$json, To_PegInRequest$json, To_PegOutAmount$json, To_PegOutRequest$json, To_SetMemo$json, To_SendTx$json, To_BlindedValues$json, To_UpdatePushToken$json, To_GaidStatus$json, To_OrderSubmit$json, To_OrderEdit$json, To_OrderCancel$json, To_StartQuotes$json, To_StartOrder$json, To_AcceptQuote$json, To_LoadHistory$json],
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
    'b3RvLkVtcHR5SABSEGxvYWRUcmFuc2FjdGlvbnMSRwoOcGVnX2luX3JlcXVlc3QYFSABKAsyHy'
    '5zaWRlc3dhcC5wcm90by5Uby5QZWdJblJlcXVlc3RIAFIMcGVnSW5SZXF1ZXN0EkcKDnBlZ19v'
    'dXRfYW1vdW50GBggASgLMh8uc2lkZXN3YXAucHJvdG8uVG8uUGVnT3V0QW1vdW50SABSDHBlZ0'
    '91dEFtb3VudBJKCg9wZWdfb3V0X3JlcXVlc3QYFiABKAsyIC5zaWRlc3dhcC5wcm90by5Uby5Q'
    'ZWdPdXRSZXF1ZXN0SABSDXBlZ091dFJlcXVlc3QSPgoNYXNzZXRfZGV0YWlscxg5IAEoCzIXLn'
    'NpZGVzd2FwLnByb3RvLkFzc2V0SWRIAFIMYXNzZXREZXRhaWxzEkIKEHBvcnRmb2xpb19wcmlj'
    'ZXMYPiABKAsyFS5zaWRlc3dhcC5wcm90by5FbXB0eUgAUg9wb3J0Zm9saW9QcmljZXMSQgoQY2'
    '9udmVyc2lvbl9yYXRlcxg/IAEoCzIVLnNpZGVzd2FwLnByb3RvLkVtcHR5SABSD2NvbnZlcnNp'
    'b25SYXRlcxI4CgtqYWRlX3Jlc2NhbhhHIAEoCzIVLnNpZGVzd2FwLnByb3RvLkVtcHR5SABSCm'
    'phZGVSZXNjYW4SOAoLamFkZV91bmxvY2sYSCABKAsyFS5zaWRlc3dhcC5wcm90by5FbXB0eUgA'
    'UgpqYWRlVW5sb2NrEkkKE2phZGVfdmVyaWZ5X2FkZHJlc3MYSSABKAsyFy5zaWRlc3dhcC5wcm'
    '90by5BZGRyZXNzSABSEWphZGVWZXJpZnlBZGRyZXNzEkAKC2dhaWRfc3RhdHVzGFEgASgLMh0u'
    'c2lkZXN3YXAucHJvdG8uVG8uR2FpZFN0YXR1c0gAUgpnYWlkU3RhdHVzEkYKEG1hcmtldF9zdW'
    'JzY3JpYmUYZCABKAsyGS5zaWRlc3dhcC5wcm90by5Bc3NldFBhaXJIAFIPbWFya2V0U3Vic2Ny'
    'aWJlEkYKEm1hcmtldF91bnN1YnNjcmliZRhlIAEoCzIVLnNpZGVzd2FwLnByb3RvLkVtcHR5SA'
    'BSEW1hcmtldFVuc3Vic2NyaWJlEkMKDG9yZGVyX3N1Ym1pdBhmIAEoCzIeLnNpZGVzd2FwLnBy'
    'b3RvLlRvLk9yZGVyU3VibWl0SABSC29yZGVyU3VibWl0Ej0KCm9yZGVyX2VkaXQYZyABKAsyHC'
    '5zaWRlc3dhcC5wcm90by5Uby5PcmRlckVkaXRIAFIJb3JkZXJFZGl0EkMKDG9yZGVyX2NhbmNl'
    'bBhoIAEoCzIeLnNpZGVzd2FwLnByb3RvLlRvLk9yZGVyQ2FuY2VsSABSC29yZGVyQ2FuY2VsEk'
    'MKDHN0YXJ0X3F1b3RlcxhuIAEoCzIeLnNpZGVzd2FwLnByb3RvLlRvLlN0YXJ0UXVvdGVzSABS'
    'C3N0YXJ0UXVvdGVzEkAKC3N0YXJ0X29yZGVyGHEgASgLMh0uc2lkZXN3YXAucHJvdG8uVG8uU3'
    'RhcnRPcmRlckgAUgpzdGFydE9yZGVyEjgKC3N0b3BfcXVvdGVzGG8gASgLMhUuc2lkZXN3YXAu'
    'cHJvdG8uRW1wdHlIAFIKc3RvcFF1b3RlcxJDCgxhY2NlcHRfcXVvdGUYcCABKAsyHi5zaWRlc3'
    'dhcC5wcm90by5Uby5BY2NlcHRRdW90ZUgAUgthY2NlcHRRdW90ZRJGChBjaGFydHNfc3Vic2Ny'
    'aWJlGHggASgLMhkuc2lkZXN3YXAucHJvdG8uQXNzZXRQYWlySABSD2NoYXJ0c1N1YnNjcmliZR'
    'JGChJjaGFydHNfdW5zdWJzY3JpYmUYeSABKAsyFS5zaWRlc3dhcC5wcm90by5FbXB0eUgAUhFj'
    'aGFydHNVbnN1YnNjcmliZRJECgxsb2FkX2hpc3RvcnkYggEgASgLMh4uc2lkZXN3YXAucHJvdG'
    '8uVG8uTG9hZEhpc3RvcnlIAFILbG9hZEhpc3RvcnkaZwoFTG9naW4SHAoIbW5lbW9uaWMYASAB'
    'KAlIAFIIbW5lbW9uaWMSGQoHamFkZV9pZBgHIAEoCUgAUgZqYWRlSWQSGwoJcGhvbmVfa2V5GA'
    'IgASgJUghwaG9uZUtleUIICgZ3YWxsZXQa1wIKD05ldHdvcmtTZXR0aW5ncxI5CgtibG9ja3N0'
    'cmVhbRgBIAEoCzIVLnNpZGVzd2FwLnByb3RvLkVtcHR5SABSC2Jsb2Nrc3RyZWFtEjMKCHNpZG'
    'Vzd2FwGAIgASgLMhUuc2lkZXN3YXAucHJvdG8uRW1wdHlIAFIIc2lkZXN3YXASOAoLc2lkZXN3'
    'YXBfY24YAyABKAsyFS5zaWRlc3dhcC5wcm90by5FbXB0eUgAUgpzaWRlc3dhcENuEkMKBmN1c3'
    'RvbRgEIAEoCzIpLnNpZGVzd2FwLnByb3RvLlRvLk5ldHdvcmtTZXR0aW5ncy5DdXN0b21IAFIG'
    'Y3VzdG9tGkkKBkN1c3RvbRISCgRob3N0GAEgAigJUgRob3N0EhIKBHBvcnQYAiACKAVSBHBvcn'
    'QSFwoHdXNlX3RscxgDIAIoCFIGdXNlVGxzQgoKCHNlbGVjdGVkGn4KDVByb3h5U2V0dGluZ3MS'
    'PAoFcHJveHkYASABKAsyJi5zaWRlc3dhcC5wcm90by5Uby5Qcm94eVNldHRpbmdzLlByb3h5Ug'
    'Vwcm94eRovCgVQcm94eRISCgRob3N0GAEgAigJUgRob3N0EhIKBHBvcnQYAiACKAVSBHBvcnQa'
    'OgoKRW5jcnlwdFBpbhIQCgNwaW4YASACKAlSA3BpbhIaCghtbmVtb25pYxgCIAIoCVIIbW5lbW'
    '9uaWMalAEKCkRlY3J5cHRQaW4SEAoDcGluGAEgAigJUgNwaW4SEgoEc2FsdBgCIAIoCVIEc2Fs'
    'dBIlCg5lbmNyeXB0ZWRfZGF0YRgDIAIoCVINZW5jcnlwdGVkRGF0YRIlCg5waW5faWRlbnRpZm'
    'llchgEIAIoCVINcGluSWRlbnRpZmllchISCgRobWFjGAUgASgJUgRobWFjGiIKCEFwcFN0YXRl'
    'EhYKBmFjdGl2ZRgBIAIoCFIGYWN0aXZlGg4KDFBlZ0luUmVxdWVzdBppCgxQZWdPdXRBbW91bn'
    'QSFgoGYW1vdW50GAEgAigDUgZhbW91bnQSJgoPaXNfc2VuZF9lbnRlcmVkGAIgAigIUg1pc1Nl'
    'bmRFbnRlcmVkEhkKCGZlZV9yYXRlGAMgAigBUgdmZWVSYXRlGskBCg1QZWdPdXRSZXF1ZXN0Eh'
    '8KC3NlbmRfYW1vdW50GAEgAigDUgpzZW5kQW1vdW50Eh8KC3JlY3ZfYW1vdW50GAIgAigDUgpy'
    'ZWN2QW1vdW50EiYKD2lzX3NlbmRfZW50ZXJlZBgEIAIoCFINaXNTZW5kRW50ZXJlZBIZCghmZW'
    'VfcmF0ZRgFIAIoAVIHZmVlUmF0ZRIbCglyZWN2X2FkZHIYBiACKAlSCHJlY3ZBZGRyEhYKBmJs'
    'b2NrcxgHIAIoBVIGYmxvY2tzGmQKB1NldE1lbW8SMQoHYWNjb3VudBgBIAIoDjIXLnNpZGVzd2'
    'FwLnByb3RvLkFjY291bnRSB2FjY291bnQSEgoEdHhpZBgCIAIoCVIEdHhpZBISCgRtZW1vGAMg'
    'AigJUgRtZW1vGhgKBlNlbmRUeBIOCgJpZBgCIAIoCVICaWQaIwoNQmxpbmRlZFZhbHVlcxISCg'
    'R0eGlkGAEgAigJUgR0eGlkGicKD1VwZGF0ZVB1c2hUb2tlbhIUCgV0b2tlbhgBIAIoCVIFdG9r'
    'ZW4aOwoKR2FpZFN0YXR1cxISCgRnYWlkGAEgAigJUgRnYWlkEhkKCGFzc2V0X2lkGAIgAigJUg'
    'dhc3NldElkGrICCgtPcmRlclN1Ym1pdBI4Cgphc3NldF9wYWlyGAEgAigLMhkuc2lkZXN3YXAu'
    'cHJvdG8uQXNzZXRQYWlyUglhc3NldFBhaXISHwoLYmFzZV9hbW91bnQYAiACKARSCmJhc2VBbW'
    '91bnQSFAoFcHJpY2UYAyABKAFSBXByaWNlEiUKDnByaWNlX3RyYWNraW5nGAkgASgBUg1wcmlj'
    'ZVRyYWNraW5nEjUKCXRyYWRlX2RpchgEIAIoDjIYLnNpZGVzd2FwLnByb3RvLlRyYWRlRGlyUg'
    'h0cmFkZURpchIfCgt0dGxfc2Vjb25kcxgFIAEoBFIKdHRsU2Vjb25kcxIZCgh0d29fc3RlcBgG'
    'IAIoCFIHdHdvU3RlcBIYCgdwcml2YXRlGAggAigIUgdwcml2YXRlGp0BCglPcmRlckVkaXQSMg'
    'oIb3JkZXJfaWQYASACKAsyFy5zaWRlc3dhcC5wcm90by5PcmRlcklkUgdvcmRlcklkEh8KC2Jh'
    'c2VfYW1vdW50GAIgASgEUgpiYXNlQW1vdW50EhQKBXByaWNlGAMgASgBUgVwcmljZRIlCg5wcm'
    'ljZV90cmFja2luZxgEIAEoAVINcHJpY2VUcmFja2luZxpBCgtPcmRlckNhbmNlbBIyCghvcmRl'
    'cl9pZBgBIAIoCzIXLnNpZGVzd2FwLnByb3RvLk9yZGVySWRSB29yZGVySWQalwIKC1N0YXJ0UX'
    'VvdGVzEjgKCmFzc2V0X3BhaXIYASACKAsyGS5zaWRlc3dhcC5wcm90by5Bc3NldFBhaXJSCWFz'
    'c2V0UGFpchI4Cgphc3NldF90eXBlGAIgAigOMhkuc2lkZXN3YXAucHJvdG8uQXNzZXRUeXBlUg'
    'lhc3NldFR5cGUSFgoGYW1vdW50GAMgAigEUgZhbW91bnQSNQoJdHJhZGVfZGlyGAQgAigOMhgu'
    'c2lkZXN3YXAucHJvdG8uVHJhZGVEaXJSCHRyYWRlRGlyEiEKDGluc3RhbnRfc3dhcBgFIAIoCF'
    'ILaW5zdGFudFN3YXASIgoNY2xpZW50X3N1Yl9pZBgGIAEoA1ILY2xpZW50U3ViSWQaRgoKU3Rh'
    'cnRPcmRlchIZCghvcmRlcl9pZBgBIAIoBFIHb3JkZXJJZBIdCgpwcml2YXRlX2lkGAIgASgJUg'
    'lwcml2YXRlSWQaKAoLQWNjZXB0UXVvdGUSGQoIcXVvdGVfaWQYASACKARSB3F1b3RlSWQacQoL'
    'TG9hZEhpc3RvcnkSHQoKc3RhcnRfdGltZRgBIAEoBFIJc3RhcnRUaW1lEhkKCGVuZF90aW1lGA'
    'IgASgEUgdlbmRUaW1lEhIKBHNraXAYAyABKA1SBHNraXASFAoFY291bnQYBCABKA1SBWNvdW50'
    'QgUKA21zZw==');

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
  '3': [From_Login$json, From_EnvSettings$json, From_EncryptPin$json, From_DecryptPin$json, From_RegisterAmp$json, From_AmpAssets$json, From_UpdatedTxs$json, From_RemovedTxs$json, From_UpdatedPegs$json, From_BalanceUpdate$json, From_PeginWaitTx$json, From_PegOutAmount$json, From_RecvAddress$json, From_LoadUtxos$json, From_LoadAddresses$json, From_LoadTransactions$json, From_CreateTxResult$json, From_SendResult$json, From_BlindedValues$json, From_PriceUpdate$json, From_SubscribedValue$json, From_ShowMessage$json, From_ShowInsufficientFunds$json, From_AssetDetails$json, From_LocalMessage$json, From_PortfolioPrices$json, From_ConversionRates$json, From_JadePorts$json, From_JadeStatus$json, From_GaidStatus$json, From_MarketList$json, From_PublicOrders$json, From_MinMarketAmounts$json, From_OwnOrders$json, From_MarketPrice$json, From_OrderSubmit$json, From_StartOrder$json, From_Quote$json, From_AcceptQuote$json, From_ChartsSubscribe$json, From_ChartsUpdate$json, From_LoadHistory$json, From_HistoryUpdated$json],
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
    'AFIQbG9hZFRyYW5zYWN0aW9ucxJFCgxzaG93X21lc3NhZ2UYMiABKAsyIC5zaWRlc3dhcC5wcm'
    '90by5Gcm9tLlNob3dNZXNzYWdlSABSC3Nob3dNZXNzYWdlElsKEmluc3VmZmljaWVudF9mdW5k'
    'cxg3IAEoCzIqLnNpZGVzd2FwLnByb3RvLkZyb20uU2hvd0luc3VmZmljaWVudEZ1bmRzSABSEW'
    'luc3VmZmljaWVudEZ1bmRzEkIKEHNlcnZlcl9jb25uZWN0ZWQYPCABKAsyFS5zaWRlc3dhcC5w'
    'cm90by5FbXB0eUgAUg9zZXJ2ZXJDb25uZWN0ZWQSSAoTc2VydmVyX2Rpc2Nvbm5lY3RlZBg9IA'
    'EoCzIVLnNpZGVzd2FwLnByb3RvLkVtcHR5SABSEnNlcnZlckRpc2Nvbm5lY3RlZBJICg1hc3Nl'
    'dF9kZXRhaWxzGEEgASgLMiEuc2lkZXN3YXAucHJvdG8uRnJvbS5Bc3NldERldGFpbHNIAFIMYX'
    'NzZXREZXRhaWxzEjQKCW5ld19ibG9jaxg+IAEoCzIVLnNpZGVzd2FwLnByb3RvLkVtcHR5SABS'
    'CG5ld0Jsb2NrEi4KBm5ld190eBg/IAEoCzIVLnNpZGVzd2FwLnByb3RvLkVtcHR5SABSBW5ld1'
    'R4EkgKDWxvY2FsX21lc3NhZ2UYRCABKAsyIS5zaWRlc3dhcC5wcm90by5Gcm9tLkxvY2FsTWVz'
    'c2FnZUgAUgxsb2NhbE1lc3NhZ2USUQoQcG9ydGZvbGlvX3ByaWNlcxhIIAEoCzIkLnNpZGVzd2'
    'FwLnByb3RvLkZyb20uUG9ydGZvbGlvUHJpY2VzSABSD3BvcnRmb2xpb1ByaWNlcxJRChBjb252'
    'ZXJzaW9uX3JhdGVzGEkgASgLMiQuc2lkZXN3YXAucHJvdG8uRnJvbS5Db252ZXJzaW9uUmF0ZX'
    'NIAFIPY29udmVyc2lvblJhdGVzEj8KCmphZGVfcG9ydHMYUCABKAsyHi5zaWRlc3dhcC5wcm90'
    'by5Gcm9tLkphZGVQb3J0c0gAUglqYWRlUG9ydHMSQgoLamFkZV9zdGF0dXMYUyABKAsyHy5zaW'
    'Rlc3dhcC5wcm90by5Gcm9tLkphZGVTdGF0dXNIAFIKamFkZVN0YXR1cxJCCgtqYWRlX3VubG9j'
    'axhRIAEoCzIfLnNpZGVzd2FwLnByb3RvLkdlbmVyaWNSZXNwb25zZUgAUgpqYWRlVW5sb2NrEl'
    'EKE2phZGVfdmVyaWZ5X2FkZHJlc3MYUiABKAsyHy5zaWRlc3dhcC5wcm90by5HZW5lcmljUmVz'
    'cG9uc2VIAFIRamFkZVZlcmlmeUFkZHJlc3MSQgoLZ2FpZF9zdGF0dXMYWyABKAsyHy5zaWRlc3'
    'dhcC5wcm90by5Gcm9tLkdhaWRTdGF0dXNIAFIKZ2FpZFN0YXR1cxJCCgttYXJrZXRfbGlzdBhk'
    'IAEoCzIfLnNpZGVzd2FwLnByb3RvLkZyb20uTWFya2V0TGlzdEgAUgptYXJrZXRMaXN0Ej8KDG'
    '1hcmtldF9hZGRlZBhlIAEoCzIaLnNpZGVzd2FwLnByb3RvLk1hcmtldEluZm9IAFILbWFya2V0'
    'QWRkZWQSQgoObWFya2V0X3JlbW92ZWQYZiABKAsyGS5zaWRlc3dhcC5wcm90by5Bc3NldFBhaX'
    'JIAFINbWFya2V0UmVtb3ZlZBJICg1wdWJsaWNfb3JkZXJzGGkgASgLMiEuc2lkZXN3YXAucHJv'
    'dG8uRnJvbS5QdWJsaWNPcmRlcnNIAFIMcHVibGljT3JkZXJzEk8KFHB1YmxpY19vcmRlcl9jcm'
    'VhdGVkGGogASgLMhsuc2lkZXN3YXAucHJvdG8uUHVibGljT3JkZXJIAFIScHVibGljT3JkZXJD'
    'cmVhdGVkEksKFHB1YmxpY19vcmRlcl9yZW1vdmVkGGsgASgLMhcuc2lkZXN3YXAucHJvdG8uT3'
    'JkZXJJZEgAUhJwdWJsaWNPcmRlclJlbW92ZWQSRQoMbWFya2V0X3ByaWNlGG4gASgLMiAuc2lk'
    'ZXN3YXAucHJvdG8uRnJvbS5NYXJrZXRQcmljZUgAUgttYXJrZXRQcmljZRJVChJtaW5fbWFya2'
    'V0X2Ftb3VudHMYdyABKAsyJS5zaWRlc3dhcC5wcm90by5Gcm9tLk1pbk1hcmtldEFtb3VudHNI'
    'AFIQbWluTWFya2V0QW1vdW50cxI/Cgpvd25fb3JkZXJzGHggASgLMh4uc2lkZXN3YXAucHJvdG'
    '8uRnJvbS5Pd25PcmRlcnNIAFIJb3duT3JkZXJzEkYKEW93bl9vcmRlcl9jcmVhdGVkGHkgASgL'
    'Mhguc2lkZXN3YXAucHJvdG8uT3duT3JkZXJIAFIPb3duT3JkZXJDcmVhdGVkEkUKEW93bl9vcm'
    'Rlcl9yZW1vdmVkGHogASgLMhcuc2lkZXN3YXAucHJvdG8uT3JkZXJJZEgAUg9vd25PcmRlclJl'
    'bW92ZWQSRgoMb3JkZXJfc3VibWl0GIIBIAEoCzIgLnNpZGVzd2FwLnByb3RvLkZyb20uT3JkZX'
    'JTdWJtaXRIAFILb3JkZXJTdWJtaXQSQQoKb3JkZXJfZWRpdBiDASABKAsyHy5zaWRlc3dhcC5w'
    'cm90by5HZW5lcmljUmVzcG9uc2VIAFIJb3JkZXJFZGl0EkUKDG9yZGVyX2NhbmNlbBiEASABKA'
    'syHy5zaWRlc3dhcC5wcm90by5HZW5lcmljUmVzcG9uc2VIAFILb3JkZXJDYW5jZWwSQwoLc3Rh'
    'cnRfb3JkZXIYjgEgASgLMh8uc2lkZXN3YXAucHJvdG8uRnJvbS5TdGFydE9yZGVySABSCnN0YX'
    'J0T3JkZXISMwoFcXVvdGUYjAEgASgLMhouc2lkZXN3YXAucHJvdG8uRnJvbS5RdW90ZUgAUgVx'
    'dW90ZRJGCgxhY2NlcHRfcXVvdGUYjQEgASgLMiAuc2lkZXN3YXAucHJvdG8uRnJvbS5BY2NlcH'
    'RRdW90ZUgAUgthY2NlcHRRdW90ZRJSChBjaGFydHNfc3Vic2NyaWJlGJYBIAEoCzIkLnNpZGVz'
    'd2FwLnByb3RvLkZyb20uQ2hhcnRzU3Vic2NyaWJlSABSD2NoYXJ0c1N1YnNjcmliZRJJCg1jaG'
    'FydHNfdXBkYXRlGJcBIAEoCzIhLnNpZGVzd2FwLnByb3RvLkZyb20uQ2hhcnRzVXBkYXRlSABS'
    'DGNoYXJ0c1VwZGF0ZRJGCgxsb2FkX2hpc3RvcnkYoAEgASgLMiAuc2lkZXN3YXAucHJvdG8uRn'
    'JvbS5Mb2FkSGlzdG9yeUgAUgtsb2FkSGlzdG9yeRJPCg9oaXN0b3J5X3VwZGF0ZWQYoQEgASgL'
    'MiMuc2lkZXN3YXAucHJvdG8uRnJvbS5IaXN0b3J5VXBkYXRlZEgAUg5oaXN0b3J5VXBkYXRlZB'
    'pjCgVMb2dpbhIdCgllcnJvcl9tc2cYASABKAlIAFIIZXJyb3JNc2cSMQoHc3VjY2VzcxgCIAEo'
    'CzIVLnNpZGVzd2FwLnByb3RvLkVtcHR5SABSB3N1Y2Nlc3NCCAoGcmVzdWx0Gn0KC0VudlNldH'
    'RpbmdzEiYKD3BvbGljeV9hc3NldF9pZBgBIAIoCVINcG9saWN5QXNzZXRJZBIiCg11c2R0X2Fz'
    'c2V0X2lkGAIgAigJUgt1c2R0QXNzZXRJZBIiCg1ldXJ4X2Fzc2V0X2lkGAMgAigJUgtldXJ4QX'
    'NzZXRJZBroAQoKRW5jcnlwdFBpbhIWCgVlcnJvchgBIAEoCUgAUgVlcnJvchI6CgRkYXRhGAIg'
    'ASgLMiQuc2lkZXN3YXAucHJvdG8uRnJvbS5FbmNyeXB0UGluLkRhdGFIAFIEZGF0YRp8CgREYX'
    'RhEhIKBHNhbHQYAiACKAlSBHNhbHQSJQoOZW5jcnlwdGVkX2RhdGEYAyACKAlSDWVuY3J5cHRl'
    'ZERhdGESJQoOcGluX2lkZW50aWZpZXIYBCACKAlSDXBpbklkZW50aWZpZXISEgoEaG1hYxgFIA'
    'EoCVIEaG1hY0IICgZyZXN1bHQapAIKCkRlY3J5cHRQaW4SPQoFZXJyb3IYASABKAsyJS5zaWRl'
    'c3dhcC5wcm90by5Gcm9tLkRlY3J5cHRQaW4uRXJyb3JIAFIFZXJyb3ISHAoIbW5lbW9uaWMYAi'
    'ABKAlIAFIIbW5lbW9uaWMabgoFRXJyb3ISGwoJZXJyb3JfbXNnGAEgAigJUghlcnJvck1zZxJI'
    'CgplcnJvcl9jb2RlGAIgAigOMikuc2lkZXN3YXAucHJvdG8uRnJvbS5EZWNyeXB0UGluLkVycm'
    '9yQ29kZVIJZXJyb3JDb2RlIj8KCUVycm9yQ29kZRINCglXUk9OR19QSU4QARIRCg1ORVRXT1JL'
    'X0VSUk9SEAISEAoMSU5WQUxJRF9EQVRBEANCCAoGcmVzdWx0Gk8KC1JlZ2lzdGVyQW1wEhcKBm'
    'FtcF9pZBgBIAEoCUgAUgVhbXBJZBIdCgllcnJvcl9tc2cYAiABKAlIAFIIZXJyb3JNc2dCCAoG'
    'cmVzdWx0GiMKCUFtcEFzc2V0cxIWCgZhc3NldHMYASADKAlSBmFzc2V0cxo9CgpVcGRhdGVkVH'
    'hzEi8KBWl0ZW1zGAEgAygLMhkuc2lkZXN3YXAucHJvdG8uVHJhbnNJdGVtUgVpdGVtcxoiCgpS'
    'ZW1vdmVkVHhzEhQKBXR4aWRzGAEgAygJUgV0eGlkcxpZCgtVcGRhdGVkUGVncxIZCghvcmRlcl'
    '9pZBgBIAIoCVIHb3JkZXJJZBIvCgVpdGVtcxgCIAMoCzIZLnNpZGVzd2FwLnByb3RvLlRyYW5z'
    'SXRlbVIFaXRlbXMadwoNQmFsYW5jZVVwZGF0ZRIxCgdhY2NvdW50GAEgAigOMhcuc2lkZXN3YX'
    'AucHJvdG8uQWNjb3VudFIHYWNjb3VudBIzCghiYWxhbmNlcxgCIAMoCzIXLnNpZGVzd2FwLnBy'
    'b3RvLkJhbGFuY2VSCGJhbGFuY2VzGmAKC1BlZ2luV2FpdFR4EhkKCG9yZGVyX2lkGAEgAigJUg'
    'dvcmRlcklkEhkKCHBlZ19hZGRyGAUgAigJUgdwZWdBZGRyEhsKCXJlY3ZfYWRkchgGIAIoCVII'
    'cmVjdkFkZHIajwIKDFBlZ091dEFtb3VudBIdCgllcnJvcl9tc2cYASABKAlIAFIIZXJyb3JNc2'
    'cSRQoHYW1vdW50cxgCIAEoCzIpLnNpZGVzd2FwLnByb3RvLkZyb20uUGVnT3V0QW1vdW50LkFt'
    'b3VudHNIAFIHYW1vdW50cxqOAQoHQW1vdW50cxIfCgtzZW5kX2Ftb3VudBgBIAIoA1IKc2VuZE'
    'Ftb3VudBIfCgtyZWN2X2Ftb3VudBgCIAIoA1IKcmVjdkFtb3VudBImCg9pc19zZW5kX2VudGVy'
    'ZWQYBCACKAhSDWlzU2VuZEVudGVyZWQSGQoIZmVlX3JhdGUYBSACKAFSB2ZlZVJhdGVCCAoGcm'
    'VzdWx0Gm0KC1JlY3ZBZGRyZXNzEisKBGFkZHIYASACKAsyFy5zaWRlc3dhcC5wcm90by5BZGRy'
    'ZXNzUgRhZGRyEjEKB2FjY291bnQYAiACKA4yFy5zaWRlc3dhcC5wcm90by5BY2NvdW50UgdhY2'
    'NvdW50Gt4CCglMb2FkVXR4b3MSMQoHYWNjb3VudBgBIAIoDjIXLnNpZGVzd2FwLnByb3RvLkFj'
    'Y291bnRSB2FjY291bnQSOQoFdXR4b3MYAiADKAsyIy5zaWRlc3dhcC5wcm90by5Gcm9tLkxvYW'
    'RVdHhvcy5VdHhvUgV1dHhvcxIbCgllcnJvcl9tc2cYAyABKAlSCGVycm9yTXNnGsUBCgRVdHhv'
    'EhIKBHR4aWQYASACKAlSBHR4aWQSEgoEdm91dBgCIAIoDVIEdm91dBIZCghhc3NldF9pZBgDIA'
    'IoCVIHYXNzZXRJZBIWCgZhbW91bnQYBCACKARSBmFtb3VudBIYCgdhZGRyZXNzGAUgAigJUgdh'
    'ZGRyZXNzEh8KC2lzX2ludGVybmFsGAYgAigIUgppc0ludGVybmFsEicKD2lzX2NvbmZpZGVudG'
    'lhbBgHIAIoCFIOaXNDb25maWRlbnRpYWwa+gIKDUxvYWRBZGRyZXNzZXMSMQoHYWNjb3VudBgB'
    'IAIoDjIXLnNpZGVzd2FwLnByb3RvLkFjY291bnRSB2FjY291bnQSSAoJYWRkcmVzc2VzGAIgAy'
    'gLMiouc2lkZXN3YXAucHJvdG8uRnJvbS5Mb2FkQWRkcmVzc2VzLkFkZHJlc3NSCWFkZHJlc3Nl'
    'cxIbCgllcnJvcl9tc2cYAyABKAlSCGVycm9yTXNnGs4BCgdBZGRyZXNzEhgKB2FkZHJlc3MYAS'
    'ACKAlSB2FkZHJlc3MSNQoWdW5jb25maWRlbnRpYWxfYWRkcmVzcxgEIAIoCVIVdW5jb25maWRl'
    'bnRpYWxBZGRyZXNzEhQKBWluZGV4GAIgAigNUgVpbmRleBIfCgtpc19pbnRlcm5hbBgDIAIoCF'
    'IKaXNJbnRlcm5hbBI7CgtzY3JpcHRfdHlwZRgFIAIoDjIaLnNpZGVzd2FwLnByb3RvLlNjcmlw'
    'dFR5cGVSCnNjcmlwdFR5cGUaXAoQTG9hZFRyYW5zYWN0aW9ucxIrCgN0eHMYASADKAsyGS5zaW'
    'Rlc3dhcC5wcm90by5UcmFuc0l0ZW1SA3R4cxIbCgllcnJvcl9tc2cYAyABKAlSCGVycm9yTXNn'
    'GnUKDkNyZWF0ZVR4UmVzdWx0Eh0KCWVycm9yX21zZxgBIAEoCUgAUghlcnJvck1zZxI6Cgpjcm'
    'VhdGVkX3R4GAIgASgLMhkuc2lkZXN3YXAucHJvdG8uQ3JlYXRlZFR4SABSCWNyZWF0ZWRUeEII'
    'CgZyZXN1bHQaawoKU2VuZFJlc3VsdBIdCgllcnJvcl9tc2cYASABKAlIAFIIZXJyb3JNc2cSNA'
    'oHdHhfaXRlbRgCIAEoCzIZLnNpZGVzd2FwLnByb3RvLlRyYW5zSXRlbUgAUgZ0eEl0ZW1CCAoG'
    'cmVzdWx0GnUKDUJsaW5kZWRWYWx1ZXMSEgoEdHhpZBgBIAIoCVIEdHhpZBIdCgllcnJvcl9tc2'
    'cYAiABKAlIAFIIZXJyb3JNc2cSJwoOYmxpbmRlZF92YWx1ZXMYAyABKAlIAFINYmxpbmRlZFZh'
    'bHVlc0IICgZyZXN1bHQaRwoLUHJpY2VVcGRhdGUSFAoFYXNzZXQYASACKAlSBWFzc2V0EhAKA2'
    'JpZBgCIAIoAVIDYmlkEhAKA2FzaxgDIAIoAVIDYXNrGuMBCg9TdWJzY3JpYmVkVmFsdWUSKwoR'
    'cGVnX2luX21pbl9hbW91bnQYASABKARIAFIOcGVnSW5NaW5BbW91bnQSMwoVcGVnX2luX3dhbG'
    'xldF9iYWxhbmNlGAIgASgESABSEnBlZ0luV2FsbGV0QmFsYW5jZRItChJwZWdfb3V0X21pbl9h'
    'bW91bnQYAyABKARIAFIPcGVnT3V0TWluQW1vdW50EjUKFnBlZ19vdXRfd2FsbGV0X2JhbGFuY2'
    'UYBCABKARIAFITcGVnT3V0V2FsbGV0QmFsYW5jZUIICgZyZXN1bHQaIQoLU2hvd01lc3NhZ2US'
    'EgoEdGV4dBgBIAIoCVIEdGV4dBpsChVTaG93SW5zdWZmaWNpZW50RnVuZHMSGQoIYXNzZXRfaW'
    'QYASACKAlSB2Fzc2V0SWQSHAoJYXZhaWxhYmxlGAIgAigDUglhdmFpbGFibGUSGgoIcmVxdWly'
    'ZWQYAyACKANSCHJlcXVpcmVkGrQCCgxBc3NldERldGFpbHMSGQoIYXNzZXRfaWQYASACKAlSB2'
    'Fzc2V0SWQSPQoFc3RhdHMYAiABKAsyJy5zaWRlc3dhcC5wcm90by5Gcm9tLkFzc2V0RGV0YWls'
    'cy5TdGF0c1IFc3RhdHMSGwoJY2hhcnRfdXJsGAMgASgJUghjaGFydFVybBqsAQoFU3RhdHMSIw'
    'oNaXNzdWVkX2Ftb3VudBgBIAIoA1IMaXNzdWVkQW1vdW50EiMKDWJ1cm5lZF9hbW91bnQYAiAC'
    'KANSDGJ1cm5lZEFtb3VudBIlCg5vZmZsaW5lX2Ftb3VudBgEIAIoA1INb2ZmbGluZUFtb3VudB'
    'IyChVoYXNfYmxpbmRlZF9pc3N1YW5jZXMYAyACKAhSE2hhc0JsaW5kZWRJc3N1YW5jZXMaOAoM'
    'TG9jYWxNZXNzYWdlEhQKBXRpdGxlGAEgAigJUgV0aXRsZRISCgRib2R5GAIgAigJUgRib2R5Gq'
    'MBCg9Qb3J0Zm9saW9QcmljZXMSUgoKcHJpY2VzX3VzZBgBIAMoCzIzLnNpZGVzd2FwLnByb3Rv'
    'LkZyb20uUG9ydGZvbGlvUHJpY2VzLlByaWNlc1VzZEVudHJ5UglwcmljZXNVc2QaPAoOUHJpY2'
    'VzVXNkRW50cnkSEAoDa2V5GAEgASgJUgNrZXkSFAoFdmFsdWUYAiABKAFSBXZhbHVlOgI4ARrI'
    'AQoPQ29udmVyc2lvblJhdGVzEm4KFHVzZF9jb252ZXJzaW9uX3JhdGVzGAEgAygLMjwuc2lkZX'
    'N3YXAucHJvdG8uRnJvbS5Db252ZXJzaW9uUmF0ZXMuVXNkQ29udmVyc2lvblJhdGVzRW50cnlS'
    'EnVzZENvbnZlcnNpb25SYXRlcxpFChdVc2RDb252ZXJzaW9uUmF0ZXNFbnRyeRIQCgNrZXkYAS'
    'ABKAlSA2tleRIUCgV2YWx1ZRgCIAEoAVIFdmFsdWU6AjgBGnsKCUphZGVQb3J0cxI5CgVwb3J0'
    'cxgBIAMoCzIjLnNpZGVzd2FwLnByb3RvLkZyb20uSmFkZVBvcnRzLlBvcnRSBXBvcnRzGjMKBF'
    'BvcnQSFwoHamFkZV9pZBgBIAIoCVIGamFkZUlkEhIKBHBvcnQYAiACKAlSBHBvcnQahQIKCkph'
    'ZGVTdGF0dXMSPgoGc3RhdHVzGAEgAigOMiYuc2lkZXN3YXAucHJvdG8uRnJvbS5KYWRlU3RhdH'
    'VzLlN0YXR1c1IGc3RhdHVzIrYBCgZTdGF0dXMSDgoKQ09OTkVDVElORxAJEggKBElETEUQARIP'
    'CgtSRUFEX1NUQVRVUxACEg0KCUFVVEhfVVNFUhADEhcKE01BU1RFUl9CTElORElOR19LRVkQBR'
    'IQCgxTSUdOX01FU1NBR0UQChILCgdTSUdOX1RYEAQSDQoJU0lHTl9TV0FQEAgSFAoQU0lHTl9T'
    'V0FQX09VVFBVVBAGEhUKEVNJR05fT0ZGTElORV9TV0FQEAcaUQoKR2FpZFN0YXR1cxISCgRnYW'
    'lkGAEgAigJUgRnYWlkEhkKCGFzc2V0X2lkGAIgAigJUgdhc3NldElkEhQKBWVycm9yGAMgASgJ'
    'UgVlcnJvchpCCgpNYXJrZXRMaXN0EjQKB21hcmtldHMYASADKAsyGi5zaWRlc3dhcC5wcm90by'
    '5NYXJrZXRJbmZvUgdtYXJrZXRzGnkKDFB1YmxpY09yZGVycxI4Cgphc3NldF9wYWlyGAEgAigL'
    'Mhkuc2lkZXN3YXAucHJvdG8uQXNzZXRQYWlyUglhc3NldFBhaXISLwoEbGlzdBgCIAMoCzIbLn'
    'NpZGVzd2FwLnByb3RvLlB1YmxpY09yZGVyUgRsaXN0Gk4KEE1pbk1hcmtldEFtb3VudHMSEgoE'
    'bGJ0YxgBIAIoBFIEbGJ0YxISCgR1c2R0GAIgAigEUgR1c2R0EhIKBGV1cngYAyACKARSBGV1cn'
    'gaOQoJT3duT3JkZXJzEiwKBGxpc3QYASADKAsyGC5zaWRlc3dhcC5wcm90by5Pd25PcmRlclIE'
    'bGlzdBqDAQoLTWFya2V0UHJpY2USOAoKYXNzZXRfcGFpchgBIAIoCzIZLnNpZGVzd2FwLnByb3'
    'RvLkFzc2V0UGFpclIJYXNzZXRQYWlyEhsKCWluZF9wcmljZRgCIAEoAVIIaW5kUHJpY2USHQoK'
    'bGFzdF9wcmljZRgDIAEoAVIJbGFzdFByaWNlGosCCgtPcmRlclN1Ym1pdBJBCg5zdWJtaXRfc3'
    'VjY2VlZBgBIAEoCzIYLnNpZGVzd2FwLnByb3RvLk93bk9yZGVySABSDXN1Ym1pdFN1Y2NlZWQS'
    'FgoFZXJyb3IYAiABKAlIAFIFZXJyb3ISYAoRdW5yZWdpc3RlcmVkX2dhaWQYAyABKAsyMS5zaW'
    'Rlc3dhcC5wcm90by5Gcm9tLk9yZGVyU3VibWl0LlVucmVnaXN0ZXJlZEdhaWRIAFIQdW5yZWdp'
    'c3RlcmVkR2FpZBo1ChBVbnJlZ2lzdGVyZWRHYWlkEiEKDGRvbWFpbl9hZ2VudBgBIAIoCVILZG'
    '9tYWluQWdlbnRCCAoGcmVzdWx0GowDCgpTdGFydE9yZGVyEhkKCG9yZGVyX2lkGAUgAigEUgdv'
    'cmRlcklkEkMKB3N1Y2Nlc3MYASABKAsyJy5zaWRlc3dhcC5wcm90by5Gcm9tLlN0YXJ0T3JkZX'
    'IuU3VjY2Vzc0gAUgdzdWNjZXNzEhYKBWVycm9yGAIgASgJSABSBWVycm9yGvsBCgdTdWNjZXNz'
    'EjgKCmFzc2V0X3BhaXIYASACKAsyGS5zaWRlc3dhcC5wcm90by5Bc3NldFBhaXJSCWFzc2V0UG'
    'FpchI1Cgl0cmFkZV9kaXIYAiACKA4yGC5zaWRlc3dhcC5wcm90by5UcmFkZURpclIIdHJhZGVE'
    'aXISFgoGYW1vdW50GAMgAigEUgZhbW91bnQSFAoFcHJpY2UYBCACKAFSBXByaWNlEjYKCWZlZV'
    '9hc3NldBgFIAIoDjIZLnNpZGVzd2FwLnByb3RvLkFzc2V0VHlwZVIIZmVlQXNzZXQSGQoIdHdv'
    'X3N0ZXAYBiACKAhSB3R3b1N0ZXBCCAoGcmVzdWx0GvoICgVRdW90ZRI4Cgphc3NldF9wYWlyGA'
    'EgAigLMhkuc2lkZXN3YXAucHJvdG8uQXNzZXRQYWlyUglhc3NldFBhaXISOAoKYXNzZXRfdHlw'
    'ZRgCIAIoDjIZLnNpZGVzd2FwLnByb3RvLkFzc2V0VHlwZVIJYXNzZXRUeXBlEhYKBmFtb3VudB'
    'gDIAIoBFIGYW1vdW50EjUKCXRyYWRlX2RpchgEIAIoDjIYLnNpZGVzd2FwLnByb3RvLlRyYWRl'
    'RGlyUgh0cmFkZURpchIZCghvcmRlcl9pZBgFIAEoBFIHb3JkZXJJZBIiCg1jbGllbnRfc3ViX2'
    'lkGAYgASgDUgtjbGllbnRTdWJJZBI+CgdzdWNjZXNzGAogASgLMiIuc2lkZXN3YXAucHJvdG8u'
    'RnJvbS5RdW90ZS5TdWNjZXNzSABSB3N1Y2Nlc3MSSAoLbG93X2JhbGFuY2UYCyABKAsyJS5zaW'
    'Rlc3dhcC5wcm90by5Gcm9tLlF1b3RlLkxvd0JhbGFuY2VIAFIKbG93QmFsYW5jZRIWCgVlcnJv'
    'chgMIAEoCUgAUgVlcnJvchJaChF1bnJlZ2lzdGVyZWRfZ2FpZBgNIAEoCzIrLnNpZGVzd2FwLn'
    'Byb3RvLkZyb20uUXVvdGUuVW5yZWdpc3RlcmVkR2FpZEgAUhB1bnJlZ2lzdGVyZWRHYWlkEkIK'
    'CWluZF9wcmljZRgOIAEoCzIjLnNpZGVzd2FwLnByb3RvLkZyb20uUXVvdGUuSW5kUHJpY2VIAF'
    'IIaW5kUHJpY2Ua8AEKB1N1Y2Nlc3MSGQoIcXVvdGVfaWQYASACKARSB3F1b3RlSWQSHwoLYmFz'
    'ZV9hbW91bnQYAiACKARSCmJhc2VBbW91bnQSIQoMcXVvdGVfYW1vdW50GAMgAigEUgtxdW90ZU'
    'Ftb3VudBIdCgpzZXJ2ZXJfZmVlGAQgAigEUglzZXJ2ZXJGZWUSGwoJZml4ZWRfZmVlGAUgAigE'
    'UghmaXhlZEZlZRIpChB0dGxfbWlsbGlzZWNvbmRzGAYgAigEUg90dGxNaWxsaXNlY29uZHMSHw'
    'oLcHJpY2VfdGFrZXIYByACKAFSCnByaWNlVGFrZXIaywEKCkxvd0JhbGFuY2USHwoLYmFzZV9h'
    'bW91bnQYASACKARSCmJhc2VBbW91bnQSIQoMcXVvdGVfYW1vdW50GAIgAigEUgtxdW90ZUFtb3'
    'VudBIdCgpzZXJ2ZXJfZmVlGAMgAigEUglzZXJ2ZXJGZWUSGwoJZml4ZWRfZmVlGAQgAigEUghm'
    'aXhlZEZlZRIcCglhdmFpbGFibGUYBSACKARSCWF2YWlsYWJsZRIfCgtwcmljZV90YWtlchgGIA'
    'IoAVIKcHJpY2VUYWtlchorCghJbmRQcmljZRIfCgtwcmljZV90YWtlchgBIAIoAVIKcHJpY2VU'
    'YWtlcho1ChBVbnJlZ2lzdGVyZWRHYWlkEiEKDGRvbWFpbl9hZ2VudBgBIAIoCVILZG9tYWluQW'
    'dlbnRCCAoGcmVzdWx0GpQBCgtBY2NlcHRRdW90ZRJECgdzdWNjZXNzGAEgASgLMiguc2lkZXN3'
    'YXAucHJvdG8uRnJvbS5BY2NlcHRRdW90ZS5TdWNjZXNzSABSB3N1Y2Nlc3MSFgoFZXJyb3IYAi'
    'ABKAlIAFIFZXJyb3IaHQoHU3VjY2VzcxISCgR0eGlkGAEgAigJUgR0eGlkQggKBnJlc3VsdBp7'
    'Cg9DaGFydHNTdWJzY3JpYmUSOAoKYXNzZXRfcGFpchgBIAIoCzIZLnNpZGVzd2FwLnByb3RvLk'
    'Fzc2V0UGFpclIJYXNzZXRQYWlyEi4KBGRhdGEYAiADKAsyGi5zaWRlc3dhcC5wcm90by5DaGFy'
    'dFBvaW50UgRkYXRhGnwKDENoYXJ0c1VwZGF0ZRI4Cgphc3NldF9wYWlyGAEgAigLMhkuc2lkZX'
    'N3YXAucHJvdG8uQXNzZXRQYWlyUglhc3NldFBhaXISMgoGdXBkYXRlGAIgAigLMhouc2lkZXN3'
    'YXAucHJvdG8uQ2hhcnRQb2ludFIGdXBkYXRlGlUKC0xvYWRIaXN0b3J5EjAKBGxpc3QYASADKA'
    'syHC5zaWRlc3dhcC5wcm90by5IaXN0b3J5T3JkZXJSBGxpc3QSFAoFdG90YWwYAiACKA1SBXRv'
    'dGFsGlsKDkhpc3RvcnlVcGRhdGVkEjIKBW9yZGVyGAEgAigLMhwuc2lkZXN3YXAucHJvdG8uSG'
    'lzdG9yeU9yZGVyUgVvcmRlchIVCgZpc19uZXcYAiACKAhSBWlzTmV3QgUKA21zZw==');

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

