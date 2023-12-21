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

@$core.Deprecated('Use emptyDescriptor instead')
const Empty$json = {
  '1': 'Empty',
};

/// Descriptor for `Empty`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List emptyDescriptor = $convert.base64Decode(
    'CgVFbXB0eQ==');

@$core.Deprecated('Use accountDescriptor instead')
const Account$json = {
  '1': 'Account',
  '2': [
    {'1': 'id', '3': 1, '4': 2, '5': 5, '10': 'id'},
  ],
};

/// Descriptor for `Account`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List accountDescriptor = $convert.base64Decode(
    'CgdBY2NvdW50Eg4KAmlkGAEgAigFUgJpZA==');

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
    {'1': 'always_show', '3': 12, '4': 1, '5': 8, '10': 'alwaysShow'},
  ],
};

/// Descriptor for `Asset`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assetDescriptor = $convert.base64Decode(
    'CgVBc3NldBIZCghhc3NldF9pZBgBIAIoCVIHYXNzZXRJZBISCgRuYW1lGAIgAigJUgRuYW1lEh'
    'YKBnRpY2tlchgDIAIoCVIGdGlja2VyEhIKBGljb24YBCACKAlSBGljb24SHAoJcHJlY2lzaW9u'
    'GAUgAigNUglwcmVjaXNpb24SIwoNaW5zdGFudF9zd2FwcxgLIAIoCFIMaW5zdGFudFN3YXBzEh'
    '8KC3N3YXBfbWFya2V0GAYgAigIUgpzd2FwTWFya2V0Eh0KCmFtcF9tYXJrZXQYCSACKAhSCWFt'
    'cE1hcmtldBIiCgx1bnJlZ2lzdGVyZWQYCCACKAhSDHVucmVnaXN0ZXJlZBIWCgZkb21haW4YBy'
    'ABKAlSBmRvbWFpbhIhCgxkb21haW5fYWdlbnQYCiABKAlSC2RvbWFpbkFnZW50Eh8KC2Fsd2F5'
    'c19zaG93GAwgASgIUgphbHdheXNTaG93');

@$core.Deprecated('Use txDescriptor instead')
const Tx$json = {
  '1': 'Tx',
  '2': [
    {'1': 'balances', '3': 1, '4': 3, '5': 11, '6': '.sideswap.proto.Balance', '10': 'balances'},
    {'1': 'txid', '3': 2, '4': 2, '5': 9, '10': 'txid'},
    {'1': 'network_fee', '3': 3, '4': 2, '5': 3, '10': 'networkFee'},
    {'1': 'size', '3': 5, '4': 2, '5': 3, '10': 'size'},
    {'1': 'vsize', '3': 6, '4': 2, '5': 3, '10': 'vsize'},
    {'1': 'memo', '3': 4, '4': 2, '5': 9, '10': 'memo'},
    {'1': 'balances_all', '3': 7, '4': 3, '5': 11, '6': '.sideswap.proto.Balance', '10': 'balancesAll'},
  ],
};

/// Descriptor for `Tx`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List txDescriptor = $convert.base64Decode(
    'CgJUeBIzCghiYWxhbmNlcxgBIAMoCzIXLnNpZGVzd2FwLnByb3RvLkJhbGFuY2VSCGJhbGFuY2'
    'VzEhIKBHR4aWQYAiACKAlSBHR4aWQSHwoLbmV0d29ya19mZWUYAyACKANSCm5ldHdvcmtGZWUS'
    'EgoEc2l6ZRgFIAIoA1IEc2l6ZRIUCgV2c2l6ZRgGIAIoA1IFdnNpemUSEgoEbWVtbxgEIAIoCV'
    'IEbWVtbxI6CgxiYWxhbmNlc19hbGwYByADKAsyFy5zaWRlc3dhcC5wcm90by5CYWxhbmNlUgti'
    'YWxhbmNlc0FsbA==');

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
    {'1': 'account', '3': 4, '4': 2, '5': 11, '6': '.sideswap.proto.Account', '10': 'account'},
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
    'RBdBIrCgVjb25mcxgDIAEoCzIVLnNpZGVzd2FwLnByb3RvLkNvbmZzUgVjb25mcxIxCgdhY2Nv'
    'dW50GAQgAigLMhcuc2lkZXN3YXAucHJvdG8uQWNjb3VudFIHYWNjb3VudBIkCgJ0eBgKIAEoCz'
    'ISLnNpZGVzd2FwLnByb3RvLlR4SABSAnR4EicKA3BlZxgLIAEoCzITLnNpZGVzd2FwLnByb3Rv'
    'LlBlZ0gAUgNwZWdCBgoEaXRlbQ==');

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

@$core.Deprecated('Use uploadContactDescriptor instead')
const UploadContact$json = {
  '1': 'UploadContact',
  '2': [
    {'1': 'identifier', '3': 1, '4': 2, '5': 9, '10': 'identifier'},
    {'1': 'name', '3': 2, '4': 2, '5': 9, '10': 'name'},
    {'1': 'phones', '3': 3, '4': 3, '5': 9, '10': 'phones'},
  ],
};

/// Descriptor for `UploadContact`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List uploadContactDescriptor = $convert.base64Decode(
    'Cg1VcGxvYWRDb250YWN0Eh4KCmlkZW50aWZpZXIYASACKAlSCmlkZW50aWZpZXISEgoEbmFtZR'
    'gCIAIoCVIEbmFtZRIWCgZwaG9uZXMYAyADKAlSBnBob25lcw==');

@$core.Deprecated('Use contactDescriptor instead')
const Contact$json = {
  '1': 'Contact',
  '2': [
    {'1': 'contact_key', '3': 1, '4': 2, '5': 9, '10': 'contactKey'},
    {'1': 'name', '3': 2, '4': 2, '5': 9, '10': 'name'},
    {'1': 'phone', '3': 3, '4': 2, '5': 9, '10': 'phone'},
  ],
};

/// Descriptor for `Contact`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List contactDescriptor = $convert.base64Decode(
    'CgdDb250YWN0Eh8KC2NvbnRhY3Rfa2V5GAEgAigJUgpjb250YWN0S2V5EhIKBG5hbWUYAiACKA'
    'lSBG5hbWUSFAoFcGhvbmUYAyACKAlSBXBob25l');

@$core.Deprecated('Use contactTransactionDescriptor instead')
const ContactTransaction$json = {
  '1': 'ContactTransaction',
  '2': [
    {'1': 'txid', '3': 1, '4': 2, '5': 9, '10': 'txid'},
    {'1': 'contact_key', '3': 2, '4': 2, '5': 9, '10': 'contactKey'},
  ],
};

/// Descriptor for `ContactTransaction`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List contactTransactionDescriptor = $convert.base64Decode(
    'ChJDb250YWN0VHJhbnNhY3Rpb24SEgoEdHhpZBgBIAIoCVIEdHhpZBIfCgtjb250YWN0X2tleR'
    'gCIAIoCVIKY29udGFjdEtleQ==');

@$core.Deprecated('Use orderDescriptor instead')
const Order$json = {
  '1': 'Order',
  '2': [
    {'1': 'order_id', '3': 1, '4': 2, '5': 9, '10': 'orderId'},
    {'1': 'asset_id', '3': 2, '4': 2, '5': 9, '10': 'assetId'},
    {'1': 'bitcoin_amount', '3': 3, '4': 2, '5': 3, '10': 'bitcoinAmount'},
    {'1': 'send_bitcoins', '3': 10, '4': 2, '5': 8, '10': 'sendBitcoins'},
    {'1': 'server_fee', '3': 4, '4': 2, '5': 3, '10': 'serverFee'},
    {'1': 'asset_amount', '3': 5, '4': 2, '5': 3, '10': 'assetAmount'},
    {'1': 'price', '3': 6, '4': 2, '5': 1, '10': 'price'},
    {'1': 'created_at', '3': 7, '4': 2, '5': 3, '10': 'createdAt'},
    {'1': 'expires_at', '3': 8, '4': 1, '5': 3, '10': 'expiresAt'},
    {'1': 'private', '3': 9, '4': 2, '5': 8, '10': 'private'},
    {'1': 'two_step', '3': 17, '4': 2, '5': 8, '10': 'twoStep'},
    {'1': 'auto_sign', '3': 11, '4': 2, '5': 8, '10': 'autoSign'},
    {'1': 'own', '3': 12, '4': 2, '5': 8, '10': 'own'},
    {'1': 'token_market', '3': 16, '4': 2, '5': 8, '10': 'tokenMarket'},
    {'1': 'from_notification', '3': 13, '4': 2, '5': 8, '10': 'fromNotification'},
    {'1': 'index_price', '3': 15, '4': 1, '5': 1, '10': 'indexPrice'},
  ],
};

/// Descriptor for `Order`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List orderDescriptor = $convert.base64Decode(
    'CgVPcmRlchIZCghvcmRlcl9pZBgBIAIoCVIHb3JkZXJJZBIZCghhc3NldF9pZBgCIAIoCVIHYX'
    'NzZXRJZBIlCg5iaXRjb2luX2Ftb3VudBgDIAIoA1INYml0Y29pbkFtb3VudBIjCg1zZW5kX2Jp'
    'dGNvaW5zGAogAigIUgxzZW5kQml0Y29pbnMSHQoKc2VydmVyX2ZlZRgEIAIoA1IJc2VydmVyRm'
    'VlEiEKDGFzc2V0X2Ftb3VudBgFIAIoA1ILYXNzZXRBbW91bnQSFAoFcHJpY2UYBiACKAFSBXBy'
    'aWNlEh0KCmNyZWF0ZWRfYXQYByACKANSCWNyZWF0ZWRBdBIdCgpleHBpcmVzX2F0GAggASgDUg'
    'lleHBpcmVzQXQSGAoHcHJpdmF0ZRgJIAIoCFIHcHJpdmF0ZRIZCgh0d29fc3RlcBgRIAIoCFIH'
    'dHdvU3RlcBIbCglhdXRvX3NpZ24YCyACKAhSCGF1dG9TaWduEhAKA293bhgMIAIoCFIDb3duEi'
    'EKDHRva2VuX21hcmtldBgQIAIoCFILdG9rZW5NYXJrZXQSKwoRZnJvbV9ub3RpZmljYXRpb24Y'
    'DSACKAhSEGZyb21Ob3RpZmljYXRpb24SHwoLaW5kZXhfcHJpY2UYDyABKAFSCmluZGV4UHJpY2'
    'U=');

@$core.Deprecated('Use swapDetailsDescriptor instead')
const SwapDetails$json = {
  '1': 'SwapDetails',
  '2': [
    {'1': 'order_id', '3': 1, '4': 2, '5': 9, '10': 'orderId'},
    {'1': 'send_asset', '3': 2, '4': 2, '5': 9, '10': 'sendAsset'},
    {'1': 'recv_asset', '3': 3, '4': 2, '5': 9, '10': 'recvAsset'},
    {'1': 'send_amount', '3': 4, '4': 2, '5': 3, '10': 'sendAmount'},
    {'1': 'recv_amount', '3': 5, '4': 2, '5': 3, '10': 'recvAmount'},
    {'1': 'upload_url', '3': 6, '4': 2, '5': 9, '10': 'uploadUrl'},
  ],
};

/// Descriptor for `SwapDetails`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List swapDetailsDescriptor = $convert.base64Decode(
    'CgtTd2FwRGV0YWlscxIZCghvcmRlcl9pZBgBIAIoCVIHb3JkZXJJZBIdCgpzZW5kX2Fzc2V0GA'
    'IgAigJUglzZW5kQXNzZXQSHQoKcmVjdl9hc3NldBgDIAIoCVIJcmVjdkFzc2V0Eh8KC3NlbmRf'
    'YW1vdW50GAQgAigDUgpzZW5kQW1vdW50Eh8KC3JlY3ZfYW1vdW50GAUgAigDUgpyZWN2QW1vdW'
    '50Eh0KCnVwbG9hZF91cmwYBiACKAlSCXVwbG9hZFVybA==');

@$core.Deprecated('Use networkSettingsDescriptor instead')
const NetworkSettings$json = {
  '1': 'NetworkSettings',
  '2': [
    {'1': 'blockstream', '3': 1, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'blockstream'},
    {'1': 'sideswap', '3': 2, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'sideswap'},
    {'1': 'sideswap_cn', '3': 4, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'sideswapCn'},
    {'1': 'custom', '3': 3, '4': 1, '5': 11, '6': '.sideswap.proto.NetworkSettings.Custom', '9': 0, '10': 'custom'},
  ],
  '3': [NetworkSettings_Custom$json],
  '8': [
    {'1': 'selected'},
  ],
};

@$core.Deprecated('Use networkSettingsDescriptor instead')
const NetworkSettings_Custom$json = {
  '1': 'Custom',
  '2': [
    {'1': 'host', '3': 1, '4': 2, '5': 9, '10': 'host'},
    {'1': 'port', '3': 2, '4': 2, '5': 5, '10': 'port'},
    {'1': 'use_tls', '3': 3, '4': 2, '5': 8, '10': 'useTls'},
  ],
};

/// Descriptor for `NetworkSettings`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List networkSettingsDescriptor = $convert.base64Decode(
    'Cg9OZXR3b3JrU2V0dGluZ3MSOQoLYmxvY2tzdHJlYW0YASABKAsyFS5zaWRlc3dhcC5wcm90by'
    '5FbXB0eUgAUgtibG9ja3N0cmVhbRIzCghzaWRlc3dhcBgCIAEoCzIVLnNpZGVzd2FwLnByb3Rv'
    'LkVtcHR5SABSCHNpZGVzd2FwEjgKC3NpZGVzd2FwX2NuGAQgASgLMhUuc2lkZXN3YXAucHJvdG'
    '8uRW1wdHlIAFIKc2lkZXN3YXBDbhJACgZjdXN0b20YAyABKAsyJi5zaWRlc3dhcC5wcm90by5O'
    'ZXR3b3JrU2V0dGluZ3MuQ3VzdG9tSABSBmN1c3RvbRpJCgZDdXN0b20SEgoEaG9zdBgBIAIoCV'
    'IEaG9zdBISCgRwb3J0GAIgAigFUgRwb3J0EhcKB3VzZV90bHMYAyACKAhSBnVzZVRsc0IKCghz'
    'ZWxlY3RlZA==');

@$core.Deprecated('Use createTxDescriptor instead')
const CreateTx$json = {
  '1': 'CreateTx',
  '2': [
    {'1': 'addr', '3': 1, '4': 2, '5': 9, '10': 'addr'},
    {'1': 'balance', '3': 2, '4': 2, '5': 11, '6': '.sideswap.proto.Balance', '10': 'balance'},
    {'1': 'is_contact', '3': 3, '4': 2, '5': 8, '10': 'isContact'},
    {'1': 'account', '3': 4, '4': 2, '5': 11, '6': '.sideswap.proto.Account', '10': 'account'},
  ],
};

/// Descriptor for `CreateTx`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createTxDescriptor = $convert.base64Decode(
    'CghDcmVhdGVUeBISCgRhZGRyGAEgAigJUgRhZGRyEjEKB2JhbGFuY2UYAiACKAsyFy5zaWRlc3'
    'dhcC5wcm90by5CYWxhbmNlUgdiYWxhbmNlEh0KCmlzX2NvbnRhY3QYAyACKAhSCWlzQ29udGFj'
    'dBIxCgdhY2NvdW50GAQgAigLMhcuc2lkZXN3YXAucHJvdG8uQWNjb3VudFIHYWNjb3VudA==');

@$core.Deprecated('Use createdTxDescriptor instead')
const CreatedTx$json = {
  '1': 'CreatedTx',
  '2': [
    {'1': 'req', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.CreateTx', '10': 'req'},
    {'1': 'input_count', '3': 2, '4': 2, '5': 5, '10': 'inputCount'},
    {'1': 'output_count', '3': 3, '4': 2, '5': 5, '10': 'outputCount'},
    {'1': 'size', '3': 4, '4': 2, '5': 3, '10': 'size'},
    {'1': 'vsize', '3': 7, '4': 2, '5': 3, '10': 'vsize'},
    {'1': 'network_fee', '3': 5, '4': 2, '5': 3, '10': 'networkFee'},
    {'1': 'fee_per_byte', '3': 6, '4': 2, '5': 1, '10': 'feePerByte'},
    {'1': 'addressees', '3': 8, '4': 3, '5': 11, '6': '.sideswap.proto.AddressAmount', '10': 'addressees'},
  ],
};

/// Descriptor for `CreatedTx`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createdTxDescriptor = $convert.base64Decode(
    'CglDcmVhdGVkVHgSKgoDcmVxGAEgAigLMhguc2lkZXN3YXAucHJvdG8uQ3JlYXRlVHhSA3JlcR'
    'IfCgtpbnB1dF9jb3VudBgCIAIoBVIKaW5wdXRDb3VudBIhCgxvdXRwdXRfY291bnQYAyACKAVS'
    'C291dHB1dENvdW50EhIKBHNpemUYBCACKANSBHNpemUSFAoFdnNpemUYByACKANSBXZzaXplEh'
    '8KC25ldHdvcmtfZmVlGAUgAigDUgpuZXR3b3JrRmVlEiAKDGZlZV9wZXJfYnl0ZRgGIAIoAVIK'
    'ZmVlUGVyQnl0ZRI9CgphZGRyZXNzZWVzGAggAygLMh0uc2lkZXN3YXAucHJvdG8uQWRkcmVzc0'
    'Ftb3VudFIKYWRkcmVzc2Vlcw==');

@$core.Deprecated('Use createPayjoinDescriptor instead')
const CreatePayjoin$json = {
  '1': 'CreatePayjoin',
  '2': [
    {'1': 'account', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.Account', '10': 'account'},
    {'1': 'addr', '3': 2, '4': 2, '5': 9, '10': 'addr'},
    {'1': 'balance', '3': 3, '4': 2, '5': 11, '6': '.sideswap.proto.Balance', '10': 'balance'},
  ],
};

/// Descriptor for `CreatePayjoin`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createPayjoinDescriptor = $convert.base64Decode(
    'Cg1DcmVhdGVQYXlqb2luEjEKB2FjY291bnQYASACKAsyFy5zaWRlc3dhcC5wcm90by5BY2NvdW'
    '50UgdhY2NvdW50EhIKBGFkZHIYAiACKAlSBGFkZHISMQoHYmFsYW5jZRgDIAIoCzIXLnNpZGVz'
    'd2FwLnByb3RvLkJhbGFuY2VSB2JhbGFuY2U=');

@$core.Deprecated('Use createdPayjoinDescriptor instead')
const CreatedPayjoin$json = {
  '1': 'CreatedPayjoin',
  '2': [
    {'1': 'req', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.CreatePayjoin', '10': 'req'},
    {'1': 'pset', '3': 2, '4': 2, '5': 9, '10': 'pset'},
    {'1': 'asset_fee', '3': 3, '4': 2, '5': 3, '10': 'assetFee'},
  ],
};

/// Descriptor for `CreatedPayjoin`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createdPayjoinDescriptor = $convert.base64Decode(
    'Cg5DcmVhdGVkUGF5am9pbhIvCgNyZXEYASACKAsyHS5zaWRlc3dhcC5wcm90by5DcmVhdGVQYX'
    'lqb2luUgNyZXESEgoEcHNldBgCIAIoCVIEcHNldBIbCglhc3NldF9mZWUYAyACKANSCGFzc2V0'
    'RmVl');

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

@$core.Deprecated('Use toDescriptor instead')
const To$json = {
  '1': 'To',
  '2': [
    {'1': 'login', '3': 1, '4': 1, '5': 11, '6': '.sideswap.proto.To.Login', '9': 0, '10': 'login'},
    {'1': 'logout', '3': 2, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'logout'},
    {'1': 'change_network', '3': 9, '4': 1, '5': 11, '6': '.sideswap.proto.To.ChangeNetwork', '9': 0, '10': 'changeNetwork'},
    {'1': 'update_push_token', '3': 3, '4': 1, '5': 11, '6': '.sideswap.proto.To.UpdatePushToken', '9': 0, '10': 'updatePushToken'},
    {'1': 'encrypt_pin', '3': 4, '4': 1, '5': 11, '6': '.sideswap.proto.To.EncryptPin', '9': 0, '10': 'encryptPin'},
    {'1': 'decrypt_pin', '3': 5, '4': 1, '5': 11, '6': '.sideswap.proto.To.DecryptPin', '9': 0, '10': 'decryptPin'},
    {'1': 'push_message', '3': 6, '4': 1, '5': 9, '9': 0, '10': 'pushMessage'},
    {'1': 'app_state', '3': 8, '4': 1, '5': 11, '6': '.sideswap.proto.To.AppState', '9': 0, '10': 'appState'},
    {'1': 'set_memo', '3': 10, '4': 1, '5': 11, '6': '.sideswap.proto.To.SetMemo', '9': 0, '10': 'setMemo'},
    {'1': 'get_recv_address', '3': 11, '4': 1, '5': 11, '6': '.sideswap.proto.Account', '9': 0, '10': 'getRecvAddress'},
    {'1': 'create_tx', '3': 12, '4': 1, '5': 11, '6': '.sideswap.proto.CreateTx', '9': 0, '10': 'createTx'},
    {'1': 'send_tx', '3': 13, '4': 1, '5': 11, '6': '.sideswap.proto.To.SendTx', '9': 0, '10': 'sendTx'},
    {'1': 'create_payjoin', '3': 15, '4': 1, '5': 11, '6': '.sideswap.proto.CreatePayjoin', '9': 0, '10': 'createPayjoin'},
    {'1': 'send_payjoin', '3': 16, '4': 1, '5': 11, '6': '.sideswap.proto.CreatedPayjoin', '9': 0, '10': 'sendPayjoin'},
    {'1': 'blinded_values', '3': 14, '4': 1, '5': 11, '6': '.sideswap.proto.To.BlindedValues', '9': 0, '10': 'blindedValues'},
    {'1': 'swap_request', '3': 20, '4': 1, '5': 11, '6': '.sideswap.proto.To.SwapRequest', '9': 0, '10': 'swapRequest'},
    {'1': 'peg_in_request', '3': 21, '4': 1, '5': 11, '6': '.sideswap.proto.To.PegInRequest', '9': 0, '10': 'pegInRequest'},
    {'1': 'peg_out_amount', '3': 24, '4': 1, '5': 11, '6': '.sideswap.proto.To.PegOutAmount', '9': 0, '10': 'pegOutAmount'},
    {'1': 'peg_out_request', '3': 22, '4': 1, '5': 11, '6': '.sideswap.proto.To.PegOutRequest', '9': 0, '10': 'pegOutRequest'},
    {'1': 'swap_accept', '3': 23, '4': 1, '5': 11, '6': '.sideswap.proto.SwapDetails', '9': 0, '10': 'swapAccept'},
    {'1': 'register_phone', '3': 40, '4': 1, '5': 11, '6': '.sideswap.proto.To.RegisterPhone', '9': 0, '10': 'registerPhone'},
    {'1': 'verify_phone', '3': 41, '4': 1, '5': 11, '6': '.sideswap.proto.To.VerifyPhone', '9': 0, '10': 'verifyPhone'},
    {'1': 'unregister_phone', '3': 44, '4': 1, '5': 11, '6': '.sideswap.proto.To.UnregisterPhone', '9': 0, '10': 'unregisterPhone'},
    {'1': 'upload_avatar', '3': 42, '4': 1, '5': 11, '6': '.sideswap.proto.To.UploadAvatar', '9': 0, '10': 'uploadAvatar'},
    {'1': 'upload_contacts', '3': 43, '4': 1, '5': 11, '6': '.sideswap.proto.To.UploadContacts', '9': 0, '10': 'uploadContacts'},
    {'1': 'submit_order', '3': 49, '4': 1, '5': 11, '6': '.sideswap.proto.To.SubmitOrder', '9': 0, '10': 'submitOrder'},
    {'1': 'link_order', '3': 50, '4': 1, '5': 11, '6': '.sideswap.proto.To.LinkOrder', '9': 0, '10': 'linkOrder'},
    {'1': 'submit_decision', '3': 51, '4': 1, '5': 11, '6': '.sideswap.proto.To.SubmitDecision', '9': 0, '10': 'submitDecision'},
    {'1': 'edit_order', '3': 52, '4': 1, '5': 11, '6': '.sideswap.proto.To.EditOrder', '9': 0, '10': 'editOrder'},
    {'1': 'cancel_order', '3': 53, '4': 1, '5': 11, '6': '.sideswap.proto.To.CancelOrder', '9': 0, '10': 'cancelOrder'},
    {'1': 'subscribe', '3': 54, '4': 1, '5': 11, '6': '.sideswap.proto.To.Subscribe', '9': 0, '10': 'subscribe'},
    {'1': 'asset_details', '3': 57, '4': 1, '5': 11, '6': '.sideswap.proto.AssetId', '9': 0, '10': 'assetDetails'},
    {'1': 'subscribe_price', '3': 55, '4': 1, '5': 11, '6': '.sideswap.proto.AssetId', '9': 0, '10': 'subscribePrice'},
    {'1': 'unsubscribe_price', '3': 56, '4': 1, '5': 11, '6': '.sideswap.proto.AssetId', '9': 0, '10': 'unsubscribePrice'},
    {'1': 'subscribe_price_stream', '3': 58, '4': 1, '5': 11, '6': '.sideswap.proto.To.SubscribePriceStream', '9': 0, '10': 'subscribePriceStream'},
    {'1': 'unsubscribe_price_stream', '3': 59, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'unsubscribePriceStream'},
    {'1': 'market_data_subscribe', '3': 60, '4': 1, '5': 11, '6': '.sideswap.proto.To.MarketDataSubscribe', '9': 0, '10': 'marketDataSubscribe'},
    {'1': 'market_data_unsubscribe', '3': 61, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'marketDataUnsubscribe'},
    {'1': 'portfolio_prices', '3': 62, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'portfolioPrices'},
    {'1': 'jade_rescan', '3': 71, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'jadeRescan'},
    {'1': 'gaid_status', '3': 81, '4': 1, '5': 11, '6': '.sideswap.proto.To.GaidStatus', '9': 0, '10': 'gaidStatus'},
  ],
  '3': [To_Login$json, To_ChangeNetwork$json, To_EncryptPin$json, To_DecryptPin$json, To_AppState$json, To_SwapRequest$json, To_PegInRequest$json, To_PegOutAmount$json, To_PegOutRequest$json, To_SetMemo$json, To_SendTx$json, To_BlindedValues$json, To_UpdatePushToken$json, To_RegisterPhone$json, To_VerifyPhone$json, To_UnregisterPhone$json, To_UploadAvatar$json, To_UploadContacts$json, To_SubmitOrder$json, To_LinkOrder$json, To_SubmitDecision$json, To_EditOrder$json, To_CancelOrder$json, To_Subscribe$json, To_SubscribePriceStream$json, To_MarketDataSubscribe$json, To_GaidStatus$json],
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
    {'1': 'network', '3': 4, '4': 2, '5': 11, '6': '.sideswap.proto.NetworkSettings', '10': 'network'},
    {'1': 'send_utxo_updates', '3': 6, '4': 1, '5': 8, '10': 'sendUtxoUpdates'},
    {'1': 'force_auto_sign_maker', '3': 8, '4': 1, '5': 8, '10': 'forceAutoSignMaker'},
  ],
  '8': [
    {'1': 'wallet'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_ChangeNetwork$json = {
  '1': 'ChangeNetwork',
  '2': [
    {'1': 'network', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.NetworkSettings', '10': 'network'},
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
const To_SwapRequest$json = {
  '1': 'SwapRequest',
  '2': [
    {'1': 'send_bitcoins', '3': 1, '4': 2, '5': 8, '10': 'sendBitcoins'},
    {'1': 'asset', '3': 2, '4': 2, '5': 9, '10': 'asset'},
    {'1': 'send_amount', '3': 3, '4': 2, '5': 3, '10': 'sendAmount'},
    {'1': 'recv_amount', '3': 4, '4': 2, '5': 3, '10': 'recvAmount'},
    {'1': 'price', '3': 5, '4': 2, '5': 1, '10': 'price'},
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
    {'1': 'account', '3': 4, '4': 2, '5': 11, '6': '.sideswap.proto.Account', '10': 'account'},
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
    {'1': 'account', '3': 8, '4': 2, '5': 11, '6': '.sideswap.proto.Account', '10': 'account'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_SetMemo$json = {
  '1': 'SetMemo',
  '2': [
    {'1': 'account', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.Account', '10': 'account'},
    {'1': 'txid', '3': 2, '4': 2, '5': 9, '10': 'txid'},
    {'1': 'memo', '3': 3, '4': 2, '5': 9, '10': 'memo'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_SendTx$json = {
  '1': 'SendTx',
  '2': [
    {'1': 'account', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.Account', '10': 'account'},
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
const To_RegisterPhone$json = {
  '1': 'RegisterPhone',
  '2': [
    {'1': 'number', '3': 1, '4': 2, '5': 9, '10': 'number'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_VerifyPhone$json = {
  '1': 'VerifyPhone',
  '2': [
    {'1': 'phone_key', '3': 1, '4': 2, '5': 9, '10': 'phoneKey'},
    {'1': 'code', '3': 2, '4': 2, '5': 9, '10': 'code'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_UnregisterPhone$json = {
  '1': 'UnregisterPhone',
  '2': [
    {'1': 'phone_key', '3': 1, '4': 2, '5': 9, '10': 'phoneKey'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_UploadAvatar$json = {
  '1': 'UploadAvatar',
  '2': [
    {'1': 'phone_key', '3': 1, '4': 2, '5': 9, '10': 'phoneKey'},
    {'1': 'image', '3': 2, '4': 2, '5': 9, '10': 'image'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_UploadContacts$json = {
  '1': 'UploadContacts',
  '2': [
    {'1': 'phone_key', '3': 1, '4': 2, '5': 9, '10': 'phoneKey'},
    {'1': 'contacts', '3': 2, '4': 3, '5': 11, '6': '.sideswap.proto.UploadContact', '10': 'contacts'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_SubmitOrder$json = {
  '1': 'SubmitOrder',
  '2': [
    {'1': 'account', '3': 7, '4': 2, '5': 11, '6': '.sideswap.proto.Account', '10': 'account'},
    {'1': 'asset_id', '3': 2, '4': 2, '5': 9, '10': 'assetId'},
    {'1': 'bitcoin_amount', '3': 3, '4': 1, '5': 1, '10': 'bitcoinAmount'},
    {'1': 'asset_amount', '3': 4, '4': 1, '5': 1, '10': 'assetAmount'},
    {'1': 'price', '3': 5, '4': 2, '5': 1, '10': 'price'},
    {'1': 'index_price', '3': 6, '4': 1, '5': 1, '10': 'indexPrice'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_LinkOrder$json = {
  '1': 'LinkOrder',
  '2': [
    {'1': 'order_id', '3': 1, '4': 2, '5': 9, '10': 'orderId'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_SubmitDecision$json = {
  '1': 'SubmitDecision',
  '2': [
    {'1': 'order_id', '3': 1, '4': 2, '5': 9, '10': 'orderId'},
    {'1': 'accept', '3': 2, '4': 2, '5': 8, '10': 'accept'},
    {'1': 'auto_sign', '3': 3, '4': 1, '5': 8, '10': 'autoSign'},
    {'1': 'private', '3': 4, '4': 1, '5': 8, '10': 'private'},
    {'1': 'two_step', '3': 6, '4': 1, '5': 8, '10': 'twoStep'},
    {'1': 'ttl_seconds', '3': 5, '4': 1, '5': 4, '10': 'ttlSeconds'},
    {'1': 'tx_chaining_allowed', '3': 7, '4': 1, '5': 8, '10': 'txChainingAllowed'},
    {'1': 'only_unused_utxos', '3': 8, '4': 1, '5': 8, '10': 'onlyUnusedUtxos'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_EditOrder$json = {
  '1': 'EditOrder',
  '2': [
    {'1': 'order_id', '3': 1, '4': 2, '5': 9, '10': 'orderId'},
    {'1': 'price', '3': 2, '4': 1, '5': 1, '9': 0, '10': 'price'},
    {'1': 'index_price', '3': 3, '4': 1, '5': 1, '9': 0, '10': 'indexPrice'},
    {'1': 'auto_sign', '3': 4, '4': 1, '5': 8, '9': 0, '10': 'autoSign'},
  ],
  '8': [
    {'1': 'data'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_CancelOrder$json = {
  '1': 'CancelOrder',
  '2': [
    {'1': 'order_id', '3': 1, '4': 2, '5': 9, '10': 'orderId'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_Subscribe$json = {
  '1': 'Subscribe',
  '2': [
    {'1': 'markets', '3': 1, '4': 3, '5': 11, '6': '.sideswap.proto.To.Subscribe.Market', '10': 'markets'},
  ],
  '3': [To_Subscribe_Market$json],
};

@$core.Deprecated('Use toDescriptor instead')
const To_Subscribe_Market$json = {
  '1': 'Market',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 1, '5': 9, '10': 'assetId'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_SubscribePriceStream$json = {
  '1': 'SubscribePriceStream',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 2, '5': 9, '10': 'assetId'},
    {'1': 'send_bitcoins', '3': 2, '4': 2, '5': 8, '10': 'sendBitcoins'},
    {'1': 'send_amount', '3': 3, '4': 1, '5': 3, '10': 'sendAmount'},
    {'1': 'recv_amount', '3': 4, '4': 1, '5': 3, '10': 'recvAmount'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_MarketDataSubscribe$json = {
  '1': 'MarketDataSubscribe',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 2, '5': 9, '10': 'assetId'},
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

/// Descriptor for `To`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List toDescriptor = $convert.base64Decode(
    'CgJUbxIwCgVsb2dpbhgBIAEoCzIYLnNpZGVzd2FwLnByb3RvLlRvLkxvZ2luSABSBWxvZ2luEi'
    '8KBmxvZ291dBgCIAEoCzIVLnNpZGVzd2FwLnByb3RvLkVtcHR5SABSBmxvZ291dBJJCg5jaGFu'
    'Z2VfbmV0d29yaxgJIAEoCzIgLnNpZGVzd2FwLnByb3RvLlRvLkNoYW5nZU5ldHdvcmtIAFINY2'
    'hhbmdlTmV0d29yaxJQChF1cGRhdGVfcHVzaF90b2tlbhgDIAEoCzIiLnNpZGVzd2FwLnByb3Rv'
    'LlRvLlVwZGF0ZVB1c2hUb2tlbkgAUg91cGRhdGVQdXNoVG9rZW4SQAoLZW5jcnlwdF9waW4YBC'
    'ABKAsyHS5zaWRlc3dhcC5wcm90by5Uby5FbmNyeXB0UGluSABSCmVuY3J5cHRQaW4SQAoLZGVj'
    'cnlwdF9waW4YBSABKAsyHS5zaWRlc3dhcC5wcm90by5Uby5EZWNyeXB0UGluSABSCmRlY3J5cH'
    'RQaW4SIwoMcHVzaF9tZXNzYWdlGAYgASgJSABSC3B1c2hNZXNzYWdlEjoKCWFwcF9zdGF0ZRgI'
    'IAEoCzIbLnNpZGVzd2FwLnByb3RvLlRvLkFwcFN0YXRlSABSCGFwcFN0YXRlEjcKCHNldF9tZW'
    '1vGAogASgLMhouc2lkZXN3YXAucHJvdG8uVG8uU2V0TWVtb0gAUgdzZXRNZW1vEkMKEGdldF9y'
    'ZWN2X2FkZHJlc3MYCyABKAsyFy5zaWRlc3dhcC5wcm90by5BY2NvdW50SABSDmdldFJlY3ZBZG'
    'RyZXNzEjcKCWNyZWF0ZV90eBgMIAEoCzIYLnNpZGVzd2FwLnByb3RvLkNyZWF0ZVR4SABSCGNy'
    'ZWF0ZVR4EjQKB3NlbmRfdHgYDSABKAsyGS5zaWRlc3dhcC5wcm90by5Uby5TZW5kVHhIAFIGc2'
    'VuZFR4EkYKDmNyZWF0ZV9wYXlqb2luGA8gASgLMh0uc2lkZXN3YXAucHJvdG8uQ3JlYXRlUGF5'
    'am9pbkgAUg1jcmVhdGVQYXlqb2luEkMKDHNlbmRfcGF5am9pbhgQIAEoCzIeLnNpZGVzd2FwLn'
    'Byb3RvLkNyZWF0ZWRQYXlqb2luSABSC3NlbmRQYXlqb2luEkkKDmJsaW5kZWRfdmFsdWVzGA4g'
    'ASgLMiAuc2lkZXN3YXAucHJvdG8uVG8uQmxpbmRlZFZhbHVlc0gAUg1ibGluZGVkVmFsdWVzEk'
    'MKDHN3YXBfcmVxdWVzdBgUIAEoCzIeLnNpZGVzd2FwLnByb3RvLlRvLlN3YXBSZXF1ZXN0SABS'
    'C3N3YXBSZXF1ZXN0EkcKDnBlZ19pbl9yZXF1ZXN0GBUgASgLMh8uc2lkZXN3YXAucHJvdG8uVG'
    '8uUGVnSW5SZXF1ZXN0SABSDHBlZ0luUmVxdWVzdBJHCg5wZWdfb3V0X2Ftb3VudBgYIAEoCzIf'
    'LnNpZGVzd2FwLnByb3RvLlRvLlBlZ091dEFtb3VudEgAUgxwZWdPdXRBbW91bnQSSgoPcGVnX2'
    '91dF9yZXF1ZXN0GBYgASgLMiAuc2lkZXN3YXAucHJvdG8uVG8uUGVnT3V0UmVxdWVzdEgAUg1w'
    'ZWdPdXRSZXF1ZXN0Ej4KC3N3YXBfYWNjZXB0GBcgASgLMhsuc2lkZXN3YXAucHJvdG8uU3dhcE'
    'RldGFpbHNIAFIKc3dhcEFjY2VwdBJJCg5yZWdpc3Rlcl9waG9uZRgoIAEoCzIgLnNpZGVzd2Fw'
    'LnByb3RvLlRvLlJlZ2lzdGVyUGhvbmVIAFINcmVnaXN0ZXJQaG9uZRJDCgx2ZXJpZnlfcGhvbm'
    'UYKSABKAsyHi5zaWRlc3dhcC5wcm90by5Uby5WZXJpZnlQaG9uZUgAUgt2ZXJpZnlQaG9uZRJP'
    'ChB1bnJlZ2lzdGVyX3Bob25lGCwgASgLMiIuc2lkZXN3YXAucHJvdG8uVG8uVW5yZWdpc3Rlcl'
    'Bob25lSABSD3VucmVnaXN0ZXJQaG9uZRJGCg11cGxvYWRfYXZhdGFyGCogASgLMh8uc2lkZXN3'
    'YXAucHJvdG8uVG8uVXBsb2FkQXZhdGFySABSDHVwbG9hZEF2YXRhchJMCg91cGxvYWRfY29udG'
    'FjdHMYKyABKAsyIS5zaWRlc3dhcC5wcm90by5Uby5VcGxvYWRDb250YWN0c0gAUg51cGxvYWRD'
    'b250YWN0cxJDCgxzdWJtaXRfb3JkZXIYMSABKAsyHi5zaWRlc3dhcC5wcm90by5Uby5TdWJtaX'
    'RPcmRlckgAUgtzdWJtaXRPcmRlchI9CgpsaW5rX29yZGVyGDIgASgLMhwuc2lkZXN3YXAucHJv'
    'dG8uVG8uTGlua09yZGVySABSCWxpbmtPcmRlchJMCg9zdWJtaXRfZGVjaXNpb24YMyABKAsyIS'
    '5zaWRlc3dhcC5wcm90by5Uby5TdWJtaXREZWNpc2lvbkgAUg5zdWJtaXREZWNpc2lvbhI9Cgpl'
    'ZGl0X29yZGVyGDQgASgLMhwuc2lkZXN3YXAucHJvdG8uVG8uRWRpdE9yZGVySABSCWVkaXRPcm'
    'RlchJDCgxjYW5jZWxfb3JkZXIYNSABKAsyHi5zaWRlc3dhcC5wcm90by5Uby5DYW5jZWxPcmRl'
    'ckgAUgtjYW5jZWxPcmRlchI8CglzdWJzY3JpYmUYNiABKAsyHC5zaWRlc3dhcC5wcm90by5Uby'
    '5TdWJzY3JpYmVIAFIJc3Vic2NyaWJlEj4KDWFzc2V0X2RldGFpbHMYOSABKAsyFy5zaWRlc3dh'
    'cC5wcm90by5Bc3NldElkSABSDGFzc2V0RGV0YWlscxJCCg9zdWJzY3JpYmVfcHJpY2UYNyABKA'
    'syFy5zaWRlc3dhcC5wcm90by5Bc3NldElkSABSDnN1YnNjcmliZVByaWNlEkYKEXVuc3Vic2Ny'
    'aWJlX3ByaWNlGDggASgLMhcuc2lkZXN3YXAucHJvdG8uQXNzZXRJZEgAUhB1bnN1YnNjcmliZV'
    'ByaWNlEl8KFnN1YnNjcmliZV9wcmljZV9zdHJlYW0YOiABKAsyJy5zaWRlc3dhcC5wcm90by5U'
    'by5TdWJzY3JpYmVQcmljZVN0cmVhbUgAUhRzdWJzY3JpYmVQcmljZVN0cmVhbRJRChh1bnN1Yn'
    'NjcmliZV9wcmljZV9zdHJlYW0YOyABKAsyFS5zaWRlc3dhcC5wcm90by5FbXB0eUgAUhZ1bnN1'
    'YnNjcmliZVByaWNlU3RyZWFtElwKFW1hcmtldF9kYXRhX3N1YnNjcmliZRg8IAEoCzImLnNpZG'
    'Vzd2FwLnByb3RvLlRvLk1hcmtldERhdGFTdWJzY3JpYmVIAFITbWFya2V0RGF0YVN1YnNjcmli'
    'ZRJPChdtYXJrZXRfZGF0YV91bnN1YnNjcmliZRg9IAEoCzIVLnNpZGVzd2FwLnByb3RvLkVtcH'
    'R5SABSFW1hcmtldERhdGFVbnN1YnNjcmliZRJCChBwb3J0Zm9saW9fcHJpY2VzGD4gASgLMhUu'
    'c2lkZXN3YXAucHJvdG8uRW1wdHlIAFIPcG9ydGZvbGlvUHJpY2VzEjgKC2phZGVfcmVzY2FuGE'
    'cgASgLMhUuc2lkZXN3YXAucHJvdG8uRW1wdHlIAFIKamFkZVJlc2NhbhJACgtnYWlkX3N0YXR1'
    'cxhRIAEoCzIdLnNpZGVzd2FwLnByb3RvLlRvLkdhaWRTdGF0dXNIAFIKZ2FpZFN0YXR1cxqBAg'
    'oFTG9naW4SHAoIbW5lbW9uaWMYASABKAlIAFIIbW5lbW9uaWMSGQoHamFkZV9pZBgHIAEoCUgA'
    'UgZqYWRlSWQSGwoJcGhvbmVfa2V5GAIgASgJUghwaG9uZUtleRI5CgduZXR3b3JrGAQgAigLMh'
    '8uc2lkZXN3YXAucHJvdG8uTmV0d29ya1NldHRpbmdzUgduZXR3b3JrEioKEXNlbmRfdXR4b191'
    'cGRhdGVzGAYgASgIUg9zZW5kVXR4b1VwZGF0ZXMSMQoVZm9yY2VfYXV0b19zaWduX21ha2VyGA'
    'ggASgIUhJmb3JjZUF1dG9TaWduTWFrZXJCCAoGd2FsbGV0GkoKDUNoYW5nZU5ldHdvcmsSOQoH'
    'bmV0d29yaxgBIAIoCzIfLnNpZGVzd2FwLnByb3RvLk5ldHdvcmtTZXR0aW5nc1IHbmV0d29yax'
    'o6CgpFbmNyeXB0UGluEhAKA3BpbhgBIAIoCVIDcGluEhoKCG1uZW1vbmljGAIgAigJUghtbmVt'
    'b25pYxqAAQoKRGVjcnlwdFBpbhIQCgNwaW4YASACKAlSA3BpbhISCgRzYWx0GAIgAigJUgRzYW'
    'x0EiUKDmVuY3J5cHRlZF9kYXRhGAMgAigJUg1lbmNyeXB0ZWREYXRhEiUKDnBpbl9pZGVudGlm'
    'aWVyGAQgAigJUg1waW5JZGVudGlmaWVyGiIKCEFwcFN0YXRlEhYKBmFjdGl2ZRgBIAIoCFIGYW'
    'N0aXZlGqABCgtTd2FwUmVxdWVzdBIjCg1zZW5kX2JpdGNvaW5zGAEgAigIUgxzZW5kQml0Y29p'
    'bnMSFAoFYXNzZXQYAiACKAlSBWFzc2V0Eh8KC3NlbmRfYW1vdW50GAMgAigDUgpzZW5kQW1vdW'
    '50Eh8KC3JlY3ZfYW1vdW50GAQgAigDUgpyZWN2QW1vdW50EhQKBXByaWNlGAUgAigBUgVwcmlj'
    'ZRoOCgxQZWdJblJlcXVlc3QanAEKDFBlZ091dEFtb3VudBIWCgZhbW91bnQYASACKANSBmFtb3'
    'VudBImCg9pc19zZW5kX2VudGVyZWQYAiACKAhSDWlzU2VuZEVudGVyZWQSGQoIZmVlX3JhdGUY'
    'AyACKAFSB2ZlZVJhdGUSMQoHYWNjb3VudBgEIAIoCzIXLnNpZGVzd2FwLnByb3RvLkFjY291bn'
    'RSB2FjY291bnQa/AEKDVBlZ091dFJlcXVlc3QSHwoLc2VuZF9hbW91bnQYASACKANSCnNlbmRB'
    'bW91bnQSHwoLcmVjdl9hbW91bnQYAiACKANSCnJlY3ZBbW91bnQSJgoPaXNfc2VuZF9lbnRlcm'
    'VkGAQgAigIUg1pc1NlbmRFbnRlcmVkEhkKCGZlZV9yYXRlGAUgAigBUgdmZWVSYXRlEhsKCXJl'
    'Y3ZfYWRkchgGIAIoCVIIcmVjdkFkZHISFgoGYmxvY2tzGAcgAigFUgZibG9ja3MSMQoHYWNjb3'
    'VudBgIIAIoCzIXLnNpZGVzd2FwLnByb3RvLkFjY291bnRSB2FjY291bnQaZAoHU2V0TWVtbxIx'
    'CgdhY2NvdW50GAEgAigLMhcuc2lkZXN3YXAucHJvdG8uQWNjb3VudFIHYWNjb3VudBISCgR0eG'
    'lkGAIgAigJUgR0eGlkEhIKBG1lbW8YAyACKAlSBG1lbW8aOwoGU2VuZFR4EjEKB2FjY291bnQY'
    'ASACKAsyFy5zaWRlc3dhcC5wcm90by5BY2NvdW50UgdhY2NvdW50GiMKDUJsaW5kZWRWYWx1ZX'
    'MSEgoEdHhpZBgBIAIoCVIEdHhpZBonCg9VcGRhdGVQdXNoVG9rZW4SFAoFdG9rZW4YASACKAlS'
    'BXRva2VuGicKDVJlZ2lzdGVyUGhvbmUSFgoGbnVtYmVyGAEgAigJUgZudW1iZXIaPgoLVmVyaW'
    'Z5UGhvbmUSGwoJcGhvbmVfa2V5GAEgAigJUghwaG9uZUtleRISCgRjb2RlGAIgAigJUgRjb2Rl'
    'Gi4KD1VucmVnaXN0ZXJQaG9uZRIbCglwaG9uZV9rZXkYASACKAlSCHBob25lS2V5GkEKDFVwbG'
    '9hZEF2YXRhchIbCglwaG9uZV9rZXkYASACKAlSCHBob25lS2V5EhQKBWltYWdlGAIgAigJUgVp'
    'bWFnZRpoCg5VcGxvYWRDb250YWN0cxIbCglwaG9uZV9rZXkYASACKAlSCHBob25lS2V5EjkKCG'
    'NvbnRhY3RzGAIgAygLMh0uc2lkZXN3YXAucHJvdG8uVXBsb2FkQ29udGFjdFIIY29udGFjdHMa'
    '3AEKC1N1Ym1pdE9yZGVyEjEKB2FjY291bnQYByACKAsyFy5zaWRlc3dhcC5wcm90by5BY2NvdW'
    '50UgdhY2NvdW50EhkKCGFzc2V0X2lkGAIgAigJUgdhc3NldElkEiUKDmJpdGNvaW5fYW1vdW50'
    'GAMgASgBUg1iaXRjb2luQW1vdW50EiEKDGFzc2V0X2Ftb3VudBgEIAEoAVILYXNzZXRBbW91bn'
    'QSFAoFcHJpY2UYBSACKAFSBXByaWNlEh8KC2luZGV4X3ByaWNlGAYgASgBUgppbmRleFByaWNl'
    'GiYKCUxpbmtPcmRlchIZCghvcmRlcl9pZBgBIAIoCVIHb3JkZXJJZBqSAgoOU3VibWl0RGVjaX'
    'Npb24SGQoIb3JkZXJfaWQYASACKAlSB29yZGVySWQSFgoGYWNjZXB0GAIgAigIUgZhY2NlcHQS'
    'GwoJYXV0b19zaWduGAMgASgIUghhdXRvU2lnbhIYCgdwcml2YXRlGAQgASgIUgdwcml2YXRlEh'
    'kKCHR3b19zdGVwGAYgASgIUgd0d29TdGVwEh8KC3R0bF9zZWNvbmRzGAUgASgEUgp0dGxTZWNv'
    'bmRzEi4KE3R4X2NoYWluaW5nX2FsbG93ZWQYByABKAhSEXR4Q2hhaW5pbmdBbGxvd2VkEioKEW'
    '9ubHlfdW51c2VkX3V0eG9zGAggASgIUg9vbmx5VW51c2VkVXR4b3MaiAEKCUVkaXRPcmRlchIZ'
    'CghvcmRlcl9pZBgBIAIoCVIHb3JkZXJJZBIWCgVwcmljZRgCIAEoAUgAUgVwcmljZRIhCgtpbm'
    'RleF9wcmljZRgDIAEoAUgAUgppbmRleFByaWNlEh0KCWF1dG9fc2lnbhgEIAEoCEgAUghhdXRv'
    'U2lnbkIGCgRkYXRhGigKC0NhbmNlbE9yZGVyEhkKCG9yZGVyX2lkGAEgAigJUgdvcmRlcklkGm'
    '8KCVN1YnNjcmliZRI9CgdtYXJrZXRzGAEgAygLMiMuc2lkZXN3YXAucHJvdG8uVG8uU3Vic2Ny'
    'aWJlLk1hcmtldFIHbWFya2V0cxojCgZNYXJrZXQSGQoIYXNzZXRfaWQYASABKAlSB2Fzc2V0SW'
    'QamAEKFFN1YnNjcmliZVByaWNlU3RyZWFtEhkKCGFzc2V0X2lkGAEgAigJUgdhc3NldElkEiMK'
    'DXNlbmRfYml0Y29pbnMYAiACKAhSDHNlbmRCaXRjb2lucxIfCgtzZW5kX2Ftb3VudBgDIAEoA1'
    'IKc2VuZEFtb3VudBIfCgtyZWN2X2Ftb3VudBgEIAEoA1IKcmVjdkFtb3VudBowChNNYXJrZXRE'
    'YXRhU3Vic2NyaWJlEhkKCGFzc2V0X2lkGAEgAigJUgdhc3NldElkGjsKCkdhaWRTdGF0dXMSEg'
    'oEZ2FpZBgBIAIoCVIEZ2FpZBIZCghhc3NldF9pZBgCIAIoCVIHYXNzZXRJZEIFCgNtc2c=');

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
    {'1': 'utxo_update', '3': 15, '4': 1, '5': 11, '6': '.sideswap.proto.From.UtxoUpdate', '9': 0, '10': 'utxoUpdate'},
    {'1': 'server_status', '3': 5, '4': 1, '5': 11, '6': '.sideswap.proto.ServerStatus', '9': 0, '10': 'serverStatus'},
    {'1': 'price_update', '3': 6, '4': 1, '5': 11, '6': '.sideswap.proto.From.PriceUpdate', '9': 0, '10': 'priceUpdate'},
    {'1': 'wallet_loaded', '3': 7, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'walletLoaded'},
    {'1': 'sync_complete', '3': 14, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'syncComplete'},
    {'1': 'encrypt_pin', '3': 10, '4': 1, '5': 11, '6': '.sideswap.proto.From.EncryptPin', '9': 0, '10': 'encryptPin'},
    {'1': 'decrypt_pin', '3': 11, '4': 1, '5': 11, '6': '.sideswap.proto.From.DecryptPin', '9': 0, '10': 'decryptPin'},
    {'1': 'pegin_wait_tx', '3': 21, '4': 1, '5': 11, '6': '.sideswap.proto.From.PeginWaitTx', '9': 0, '10': 'peginWaitTx'},
    {'1': 'peg_out_amount', '3': 24, '4': 1, '5': 11, '6': '.sideswap.proto.From.PegOutAmount', '9': 0, '10': 'pegOutAmount'},
    {'1': 'swap_succeed', '3': 22, '4': 1, '5': 11, '6': '.sideswap.proto.TransItem', '9': 0, '10': 'swapSucceed'},
    {'1': 'swap_failed', '3': 23, '4': 1, '5': 9, '9': 0, '10': 'swapFailed'},
    {'1': 'recv_address', '3': 30, '4': 1, '5': 11, '6': '.sideswap.proto.From.RecvAddress', '9': 0, '10': 'recvAddress'},
    {'1': 'create_tx_result', '3': 31, '4': 1, '5': 11, '6': '.sideswap.proto.From.CreateTxResult', '9': 0, '10': 'createTxResult'},
    {'1': 'create_payjoin_result', '3': 34, '4': 1, '5': 11, '6': '.sideswap.proto.From.CreatePayjoinResult', '9': 0, '10': 'createPayjoinResult'},
    {'1': 'send_result', '3': 32, '4': 1, '5': 11, '6': '.sideswap.proto.From.SendResult', '9': 0, '10': 'sendResult'},
    {'1': 'blinded_values', '3': 33, '4': 1, '5': 11, '6': '.sideswap.proto.From.BlindedValues', '9': 0, '10': 'blindedValues'},
    {'1': 'register_phone', '3': 40, '4': 1, '5': 11, '6': '.sideswap.proto.From.RegisterPhone', '9': 0, '10': 'registerPhone'},
    {'1': 'verify_phone', '3': 41, '4': 1, '5': 11, '6': '.sideswap.proto.From.VerifyPhone', '9': 0, '10': 'verifyPhone'},
    {'1': 'upload_avatar', '3': 42, '4': 1, '5': 11, '6': '.sideswap.proto.GenericResponse', '9': 0, '10': 'uploadAvatar'},
    {'1': 'upload_contacts', '3': 43, '4': 1, '5': 11, '6': '.sideswap.proto.GenericResponse', '9': 0, '10': 'uploadContacts'},
    {'1': 'contact_created', '3': 44, '4': 1, '5': 11, '6': '.sideswap.proto.Contact', '9': 0, '10': 'contactCreated'},
    {'1': 'contact_removed', '3': 45, '4': 1, '5': 11, '6': '.sideswap.proto.From.ContactRemoved', '9': 0, '10': 'contactRemoved'},
    {'1': 'contact_transaction', '3': 46, '4': 1, '5': 11, '6': '.sideswap.proto.ContactTransaction', '9': 0, '10': 'contactTransaction'},
    {'1': 'account_status', '3': 47, '4': 1, '5': 11, '6': '.sideswap.proto.From.AccountStatus', '9': 0, '10': 'accountStatus'},
    {'1': 'show_message', '3': 50, '4': 1, '5': 11, '6': '.sideswap.proto.From.ShowMessage', '9': 0, '10': 'showMessage'},
    {'1': 'insufficient_funds', '3': 55, '4': 1, '5': 11, '6': '.sideswap.proto.From.ShowInsufficientFunds', '9': 0, '10': 'insufficientFunds'},
    {'1': 'submit_review', '3': 51, '4': 1, '5': 11, '6': '.sideswap.proto.From.SubmitReview', '9': 0, '10': 'submitReview'},
    {'1': 'submit_result', '3': 52, '4': 1, '5': 11, '6': '.sideswap.proto.From.SubmitResult', '9': 0, '10': 'submitResult'},
    {'1': 'edit_order', '3': 53, '4': 1, '5': 11, '6': '.sideswap.proto.GenericResponse', '9': 0, '10': 'editOrder'},
    {'1': 'cancel_order', '3': 54, '4': 1, '5': 11, '6': '.sideswap.proto.GenericResponse', '9': 0, '10': 'cancelOrder'},
    {'1': 'start_timer', '3': 56, '4': 1, '5': 11, '6': '.sideswap.proto.From.StartTimer', '9': 0, '10': 'startTimer'},
    {'1': 'server_connected', '3': 60, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'serverConnected'},
    {'1': 'server_disconnected', '3': 61, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'serverDisconnected'},
    {'1': 'order_created', '3': 62, '4': 1, '5': 11, '6': '.sideswap.proto.From.OrderCreated', '9': 0, '10': 'orderCreated'},
    {'1': 'order_removed', '3': 63, '4': 1, '5': 11, '6': '.sideswap.proto.From.OrderRemoved', '9': 0, '10': 'orderRemoved'},
    {'1': 'order_complete', '3': 67, '4': 1, '5': 11, '6': '.sideswap.proto.From.OrderComplete', '9': 0, '10': 'orderComplete'},
    {'1': 'index_price', '3': 64, '4': 1, '5': 11, '6': '.sideswap.proto.From.IndexPrice', '9': 0, '10': 'indexPrice'},
    {'1': 'asset_details', '3': 65, '4': 1, '5': 11, '6': '.sideswap.proto.From.AssetDetails', '9': 0, '10': 'assetDetails'},
    {'1': 'update_price_stream', '3': 66, '4': 1, '5': 11, '6': '.sideswap.proto.From.UpdatePriceStream', '9': 0, '10': 'updatePriceStream'},
    {'1': 'local_message', '3': 68, '4': 1, '5': 11, '6': '.sideswap.proto.From.LocalMessage', '9': 0, '10': 'localMessage'},
    {'1': 'market_data_subscribe', '3': 70, '4': 1, '5': 11, '6': '.sideswap.proto.From.MarketDataSubscribe', '9': 0, '10': 'marketDataSubscribe'},
    {'1': 'market_data_update', '3': 71, '4': 1, '5': 11, '6': '.sideswap.proto.From.MarketDataUpdate', '9': 0, '10': 'marketDataUpdate'},
    {'1': 'portfolio_prices', '3': 72, '4': 1, '5': 11, '6': '.sideswap.proto.From.PortfolioPrices', '9': 0, '10': 'portfolioPrices'},
    {'1': 'jade_ports', '3': 80, '4': 1, '5': 11, '6': '.sideswap.proto.From.JadePorts', '9': 0, '10': 'jadePorts'},
    {'1': 'jade_status', '3': 83, '4': 1, '5': 11, '6': '.sideswap.proto.From.JadeStatus', '9': 0, '10': 'jadeStatus'},
    {'1': 'gaid_status', '3': 91, '4': 1, '5': 11, '6': '.sideswap.proto.From.GaidStatus', '9': 0, '10': 'gaidStatus'},
  ],
  '3': [From_Login$json, From_EnvSettings$json, From_EncryptPin$json, From_DecryptPin$json, From_RegisterAmp$json, From_AmpAssets$json, From_UpdatedTxs$json, From_RemovedTxs$json, From_UpdatedPegs$json, From_BalanceUpdate$json, From_UtxoUpdate$json, From_PeginWaitTx$json, From_PegOutAmount$json, From_RecvAddress$json, From_CreateTxResult$json, From_CreatePayjoinResult$json, From_SendResult$json, From_BlindedValues$json, From_PriceUpdate$json, From_RegisterPhone$json, From_VerifyPhone$json, From_ShowMessage$json, From_ShowInsufficientFunds$json, From_SubmitReview$json, From_SubmitResult$json, From_StartTimer$json, From_OrderCreated$json, From_OrderRemoved$json, From_OrderComplete$json, From_IndexPrice$json, From_ContactRemoved$json, From_AccountStatus$json, From_AssetDetails$json, From_UpdatePriceStream$json, From_LocalMessage$json, From_MarketDataSubscribe$json, From_MarketDataUpdate$json, From_PortfolioPrices$json, From_JadePorts$json, From_JadeStatus$json, From_GaidStatus$json],
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
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_DecryptPin$json = {
  '1': 'DecryptPin',
  '2': [
    {'1': 'error', '3': 1, '4': 1, '5': 9, '9': 0, '10': 'error'},
    {'1': 'mnemonic', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'mnemonic'},
  ],
  '8': [
    {'1': 'result'},
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
    {'1': 'account', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.Account', '10': 'account'},
    {'1': 'balances', '3': 2, '4': 3, '5': 11, '6': '.sideswap.proto.Balance', '10': 'balances'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_UtxoUpdate$json = {
  '1': 'UtxoUpdate',
  '2': [
    {'1': 'account', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.Account', '10': 'account'},
    {'1': 'utxos', '3': 2, '4': 3, '5': 11, '6': '.sideswap.proto.From.UtxoUpdate.Utxo', '10': 'utxos'},
  ],
  '3': [From_UtxoUpdate_Utxo$json],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_UtxoUpdate_Utxo$json = {
  '1': 'Utxo',
  '2': [
    {'1': 'txid', '3': 1, '4': 2, '5': 9, '10': 'txid'},
    {'1': 'vout', '3': 2, '4': 2, '5': 13, '10': 'vout'},
    {'1': 'asset_id', '3': 3, '4': 2, '5': 9, '10': 'assetId'},
    {'1': 'amount', '3': 4, '4': 2, '5': 4, '10': 'amount'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_PeginWaitTx$json = {
  '1': 'PeginWaitTx',
  '2': [
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
    {'1': 'account', '3': 6, '4': 2, '5': 11, '6': '.sideswap.proto.Account', '10': 'account'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_RecvAddress$json = {
  '1': 'RecvAddress',
  '2': [
    {'1': 'addr', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.Address', '10': 'addr'},
    {'1': 'account', '3': 2, '4': 2, '5': 11, '6': '.sideswap.proto.Account', '10': 'account'},
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
const From_CreatePayjoinResult$json = {
  '1': 'CreatePayjoinResult',
  '2': [
    {'1': 'error_msg', '3': 1, '4': 1, '5': 9, '9': 0, '10': 'errorMsg'},
    {'1': 'created_payjoin', '3': 2, '4': 1, '5': 11, '6': '.sideswap.proto.CreatedPayjoin', '9': 0, '10': 'createdPayjoin'},
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
const From_RegisterPhone$json = {
  '1': 'RegisterPhone',
  '2': [
    {'1': 'phone_key', '3': 1, '4': 1, '5': 9, '9': 0, '10': 'phoneKey'},
    {'1': 'error_msg', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'errorMsg'},
  ],
  '8': [
    {'1': 'result'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_VerifyPhone$json = {
  '1': 'VerifyPhone',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'success'},
    {'1': 'error_msg', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'errorMsg'},
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
const From_SubmitReview$json = {
  '1': 'SubmitReview',
  '2': [
    {'1': 'order_id', '3': 1, '4': 2, '5': 9, '10': 'orderId'},
    {'1': 'asset', '3': 2, '4': 2, '5': 9, '10': 'asset'},
    {'1': 'bitcoin_amount', '3': 3, '4': 2, '5': 3, '10': 'bitcoinAmount'},
    {'1': 'server_fee', '3': 8, '4': 2, '5': 3, '10': 'serverFee'},
    {'1': 'asset_amount', '3': 4, '4': 2, '5': 3, '10': 'assetAmount'},
    {'1': 'price', '3': 5, '4': 2, '5': 1, '10': 'price'},
    {'1': 'sell_bitcoin', '3': 6, '4': 2, '5': 8, '10': 'sellBitcoin'},
    {'1': 'step', '3': 7, '4': 2, '5': 14, '6': '.sideswap.proto.From.SubmitReview.Step', '10': 'step'},
    {'1': 'index_price', '3': 9, '4': 2, '5': 8, '10': 'indexPrice'},
    {'1': 'auto_sign', '3': 11, '4': 2, '5': 8, '10': 'autoSign'},
    {'1': 'two_step', '3': 12, '4': 1, '5': 8, '10': 'twoStep'},
    {'1': 'tx_chaining_required', '3': 13, '4': 1, '5': 8, '10': 'txChainingRequired'},
  ],
  '4': [From_SubmitReview_Step$json],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_SubmitReview_Step$json = {
  '1': 'Step',
  '2': [
    {'1': 'SUBMIT', '2': 1},
    {'1': 'QUOTE', '2': 2},
    {'1': 'SIGN', '2': 3},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_SubmitResult$json = {
  '1': 'SubmitResult',
  '2': [
    {'1': 'submit_succeed', '3': 1, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'submitSucceed'},
    {'1': 'swap_succeed', '3': 2, '4': 1, '5': 11, '6': '.sideswap.proto.TransItem', '9': 0, '10': 'swapSucceed'},
    {'1': 'error', '3': 3, '4': 1, '5': 9, '9': 0, '10': 'error'},
    {'1': 'unregistered_gaid', '3': 4, '4': 1, '5': 11, '6': '.sideswap.proto.From.SubmitResult.UnregisteredGaid', '9': 0, '10': 'unregisteredGaid'},
  ],
  '3': [From_SubmitResult_UnregisteredGaid$json],
  '8': [
    {'1': 'result'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_SubmitResult_UnregisteredGaid$json = {
  '1': 'UnregisteredGaid',
  '2': [
    {'1': 'domain_agent', '3': 1, '4': 2, '5': 9, '10': 'domainAgent'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_StartTimer$json = {
  '1': 'StartTimer',
  '2': [
    {'1': 'order_id', '3': 1, '4': 2, '5': 9, '10': 'orderId'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_OrderCreated$json = {
  '1': 'OrderCreated',
  '2': [
    {'1': 'order', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.Order', '10': 'order'},
    {'1': 'new', '3': 2, '4': 2, '5': 8, '10': 'new'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_OrderRemoved$json = {
  '1': 'OrderRemoved',
  '2': [
    {'1': 'order_id', '3': 1, '4': 2, '5': 9, '10': 'orderId'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_OrderComplete$json = {
  '1': 'OrderComplete',
  '2': [
    {'1': 'order_id', '3': 1, '4': 2, '5': 9, '10': 'orderId'},
    {'1': 'txid', '3': 2, '4': 1, '5': 9, '10': 'txid'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_IndexPrice$json = {
  '1': 'IndexPrice',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 2, '5': 9, '10': 'assetId'},
    {'1': 'ind', '3': 2, '4': 1, '5': 1, '10': 'ind'},
    {'1': 'last', '3': 3, '4': 1, '5': 1, '10': 'last'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_ContactRemoved$json = {
  '1': 'ContactRemoved',
  '2': [
    {'1': 'contact_key', '3': 1, '4': 2, '5': 9, '10': 'contactKey'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_AccountStatus$json = {
  '1': 'AccountStatus',
  '2': [
    {'1': 'registered', '3': 1, '4': 2, '5': 8, '10': 'registered'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_AssetDetails$json = {
  '1': 'AssetDetails',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 2, '5': 9, '10': 'assetId'},
    {'1': 'stats', '3': 2, '4': 1, '5': 11, '6': '.sideswap.proto.From.AssetDetails.Stats', '10': 'stats'},
    {'1': 'chart_url', '3': 3, '4': 1, '5': 9, '10': 'chartUrl'},
    {'1': 'chart_stats', '3': 4, '4': 1, '5': 11, '6': '.sideswap.proto.From.AssetDetails.ChartStats', '10': 'chartStats'},
  ],
  '3': [From_AssetDetails_Stats$json, From_AssetDetails_ChartStats$json],
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
const From_AssetDetails_ChartStats$json = {
  '1': 'ChartStats',
  '2': [
    {'1': 'low', '3': 1, '4': 2, '5': 1, '10': 'low'},
    {'1': 'high', '3': 2, '4': 2, '5': 1, '10': 'high'},
    {'1': 'last', '3': 3, '4': 2, '5': 1, '10': 'last'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_UpdatePriceStream$json = {
  '1': 'UpdatePriceStream',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 2, '5': 9, '10': 'assetId'},
    {'1': 'send_bitcoins', '3': 2, '4': 2, '5': 8, '10': 'sendBitcoins'},
    {'1': 'send_amount', '3': 3, '4': 1, '5': 3, '10': 'sendAmount'},
    {'1': 'recv_amount', '3': 4, '4': 1, '5': 3, '10': 'recvAmount'},
    {'1': 'price', '3': 5, '4': 1, '5': 1, '10': 'price'},
    {'1': 'error_msg', '3': 6, '4': 1, '5': 9, '10': 'errorMsg'},
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
const From_MarketDataSubscribe$json = {
  '1': 'MarketDataSubscribe',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 2, '5': 9, '10': 'assetId'},
    {'1': 'data', '3': 2, '4': 3, '5': 11, '6': '.sideswap.proto.ChartPoint', '10': 'data'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_MarketDataUpdate$json = {
  '1': 'MarketDataUpdate',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 2, '5': 9, '10': 'assetId'},
    {'1': 'update', '3': 2, '4': 2, '5': 11, '6': '.sideswap.proto.ChartPoint', '10': 'update'},
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
const From_JadePorts$json = {
  '1': 'JadePorts',
  '2': [
    {'1': 'ports', '3': 1, '4': 3, '5': 11, '6': '.sideswap.proto.From.JadePorts.Port', '10': 'ports'},
  ],
  '3': [From_JadePorts_Port$json],
  '4': [From_JadePorts_State$json],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_JadePorts_Port$json = {
  '1': 'Port',
  '2': [
    {'1': 'jade_id', '3': 1, '4': 2, '5': 9, '10': 'jadeId'},
    {'1': 'port', '3': 2, '4': 2, '5': 9, '10': 'port'},
    {'1': 'serial', '3': 3, '4': 2, '5': 9, '10': 'serial'},
    {'1': 'version', '3': 4, '4': 2, '5': 9, '10': 'version'},
    {'1': 'state', '3': 5, '4': 2, '5': 14, '6': '.sideswap.proto.From.JadePorts.State', '10': 'state'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_JadePorts_State$json = {
  '1': 'State',
  '2': [
    {'1': 'UNINIT', '2': 0},
    {'1': 'MAIN', '2': 1},
    {'1': 'TEST', '2': 2},
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
    {'1': 'IDLE', '2': 1},
    {'1': 'READ_STATUS', '2': 2},
    {'1': 'AUTH_USER', '2': 3},
    {'1': 'MASTER_BLINDING_KEY', '2': 5},
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
    '5wcm90by5Gcm9tLkJhbGFuY2VVcGRhdGVIAFINYmFsYW5jZVVwZGF0ZRJCCgt1dHhvX3VwZGF0'
    'ZRgPIAEoCzIfLnNpZGVzd2FwLnByb3RvLkZyb20uVXR4b1VwZGF0ZUgAUgp1dHhvVXBkYXRlEk'
    'MKDXNlcnZlcl9zdGF0dXMYBSABKAsyHC5zaWRlc3dhcC5wcm90by5TZXJ2ZXJTdGF0dXNIAFIM'
    'c2VydmVyU3RhdHVzEkUKDHByaWNlX3VwZGF0ZRgGIAEoCzIgLnNpZGVzd2FwLnByb3RvLkZyb2'
    '0uUHJpY2VVcGRhdGVIAFILcHJpY2VVcGRhdGUSPAoNd2FsbGV0X2xvYWRlZBgHIAEoCzIVLnNp'
    'ZGVzd2FwLnByb3RvLkVtcHR5SABSDHdhbGxldExvYWRlZBI8Cg1zeW5jX2NvbXBsZXRlGA4gAS'
    'gLMhUuc2lkZXN3YXAucHJvdG8uRW1wdHlIAFIMc3luY0NvbXBsZXRlEkIKC2VuY3J5cHRfcGlu'
    'GAogASgLMh8uc2lkZXN3YXAucHJvdG8uRnJvbS5FbmNyeXB0UGluSABSCmVuY3J5cHRQaW4SQg'
    'oLZGVjcnlwdF9waW4YCyABKAsyHy5zaWRlc3dhcC5wcm90by5Gcm9tLkRlY3J5cHRQaW5IAFIK'
    'ZGVjcnlwdFBpbhJGCg1wZWdpbl93YWl0X3R4GBUgASgLMiAuc2lkZXN3YXAucHJvdG8uRnJvbS'
    '5QZWdpbldhaXRUeEgAUgtwZWdpbldhaXRUeBJJCg5wZWdfb3V0X2Ftb3VudBgYIAEoCzIhLnNp'
    'ZGVzd2FwLnByb3RvLkZyb20uUGVnT3V0QW1vdW50SABSDHBlZ091dEFtb3VudBI+Cgxzd2FwX3'
    'N1Y2NlZWQYFiABKAsyGS5zaWRlc3dhcC5wcm90by5UcmFuc0l0ZW1IAFILc3dhcFN1Y2NlZWQS'
    'IQoLc3dhcF9mYWlsZWQYFyABKAlIAFIKc3dhcEZhaWxlZBJFCgxyZWN2X2FkZHJlc3MYHiABKA'
    'syIC5zaWRlc3dhcC5wcm90by5Gcm9tLlJlY3ZBZGRyZXNzSABSC3JlY3ZBZGRyZXNzEk8KEGNy'
    'ZWF0ZV90eF9yZXN1bHQYHyABKAsyIy5zaWRlc3dhcC5wcm90by5Gcm9tLkNyZWF0ZVR4UmVzdW'
    'x0SABSDmNyZWF0ZVR4UmVzdWx0El4KFWNyZWF0ZV9wYXlqb2luX3Jlc3VsdBgiIAEoCzIoLnNp'
    'ZGVzd2FwLnByb3RvLkZyb20uQ3JlYXRlUGF5am9pblJlc3VsdEgAUhNjcmVhdGVQYXlqb2luUm'
    'VzdWx0EkIKC3NlbmRfcmVzdWx0GCAgASgLMh8uc2lkZXN3YXAucHJvdG8uRnJvbS5TZW5kUmVz'
    'dWx0SABSCnNlbmRSZXN1bHQSSwoOYmxpbmRlZF92YWx1ZXMYISABKAsyIi5zaWRlc3dhcC5wcm'
    '90by5Gcm9tLkJsaW5kZWRWYWx1ZXNIAFINYmxpbmRlZFZhbHVlcxJLCg5yZWdpc3Rlcl9waG9u'
    'ZRgoIAEoCzIiLnNpZGVzd2FwLnByb3RvLkZyb20uUmVnaXN0ZXJQaG9uZUgAUg1yZWdpc3Rlcl'
    'Bob25lEkUKDHZlcmlmeV9waG9uZRgpIAEoCzIgLnNpZGVzd2FwLnByb3RvLkZyb20uVmVyaWZ5'
    'UGhvbmVIAFILdmVyaWZ5UGhvbmUSRgoNdXBsb2FkX2F2YXRhchgqIAEoCzIfLnNpZGVzd2FwLn'
    'Byb3RvLkdlbmVyaWNSZXNwb25zZUgAUgx1cGxvYWRBdmF0YXISSgoPdXBsb2FkX2NvbnRhY3Rz'
    'GCsgASgLMh8uc2lkZXN3YXAucHJvdG8uR2VuZXJpY1Jlc3BvbnNlSABSDnVwbG9hZENvbnRhY3'
    'RzEkIKD2NvbnRhY3RfY3JlYXRlZBgsIAEoCzIXLnNpZGVzd2FwLnByb3RvLkNvbnRhY3RIAFIO'
    'Y29udGFjdENyZWF0ZWQSTgoPY29udGFjdF9yZW1vdmVkGC0gASgLMiMuc2lkZXN3YXAucHJvdG'
    '8uRnJvbS5Db250YWN0UmVtb3ZlZEgAUg5jb250YWN0UmVtb3ZlZBJVChNjb250YWN0X3RyYW5z'
    'YWN0aW9uGC4gASgLMiIuc2lkZXN3YXAucHJvdG8uQ29udGFjdFRyYW5zYWN0aW9uSABSEmNvbn'
    'RhY3RUcmFuc2FjdGlvbhJLCg5hY2NvdW50X3N0YXR1cxgvIAEoCzIiLnNpZGVzd2FwLnByb3Rv'
    'LkZyb20uQWNjb3VudFN0YXR1c0gAUg1hY2NvdW50U3RhdHVzEkUKDHNob3dfbWVzc2FnZRgyIA'
    'EoCzIgLnNpZGVzd2FwLnByb3RvLkZyb20uU2hvd01lc3NhZ2VIAFILc2hvd01lc3NhZ2USWwoS'
    'aW5zdWZmaWNpZW50X2Z1bmRzGDcgASgLMiouc2lkZXN3YXAucHJvdG8uRnJvbS5TaG93SW5zdW'
    'ZmaWNpZW50RnVuZHNIAFIRaW5zdWZmaWNpZW50RnVuZHMSSAoNc3VibWl0X3JldmlldxgzIAEo'
    'CzIhLnNpZGVzd2FwLnByb3RvLkZyb20uU3VibWl0UmV2aWV3SABSDHN1Ym1pdFJldmlldxJICg'
    '1zdWJtaXRfcmVzdWx0GDQgASgLMiEuc2lkZXN3YXAucHJvdG8uRnJvbS5TdWJtaXRSZXN1bHRI'
    'AFIMc3VibWl0UmVzdWx0EkAKCmVkaXRfb3JkZXIYNSABKAsyHy5zaWRlc3dhcC5wcm90by5HZW'
    '5lcmljUmVzcG9uc2VIAFIJZWRpdE9yZGVyEkQKDGNhbmNlbF9vcmRlchg2IAEoCzIfLnNpZGVz'
    'd2FwLnByb3RvLkdlbmVyaWNSZXNwb25zZUgAUgtjYW5jZWxPcmRlchJCCgtzdGFydF90aW1lch'
    'g4IAEoCzIfLnNpZGVzd2FwLnByb3RvLkZyb20uU3RhcnRUaW1lckgAUgpzdGFydFRpbWVyEkIK'
    'EHNlcnZlcl9jb25uZWN0ZWQYPCABKAsyFS5zaWRlc3dhcC5wcm90by5FbXB0eUgAUg9zZXJ2ZX'
    'JDb25uZWN0ZWQSSAoTc2VydmVyX2Rpc2Nvbm5lY3RlZBg9IAEoCzIVLnNpZGVzd2FwLnByb3Rv'
    'LkVtcHR5SABSEnNlcnZlckRpc2Nvbm5lY3RlZBJICg1vcmRlcl9jcmVhdGVkGD4gASgLMiEuc2'
    'lkZXN3YXAucHJvdG8uRnJvbS5PcmRlckNyZWF0ZWRIAFIMb3JkZXJDcmVhdGVkEkgKDW9yZGVy'
    'X3JlbW92ZWQYPyABKAsyIS5zaWRlc3dhcC5wcm90by5Gcm9tLk9yZGVyUmVtb3ZlZEgAUgxvcm'
    'RlclJlbW92ZWQSSwoOb3JkZXJfY29tcGxldGUYQyABKAsyIi5zaWRlc3dhcC5wcm90by5Gcm9t'
    'Lk9yZGVyQ29tcGxldGVIAFINb3JkZXJDb21wbGV0ZRJCCgtpbmRleF9wcmljZRhAIAEoCzIfLn'
    'NpZGVzd2FwLnByb3RvLkZyb20uSW5kZXhQcmljZUgAUgppbmRleFByaWNlEkgKDWFzc2V0X2Rl'
    'dGFpbHMYQSABKAsyIS5zaWRlc3dhcC5wcm90by5Gcm9tLkFzc2V0RGV0YWlsc0gAUgxhc3NldE'
    'RldGFpbHMSWAoTdXBkYXRlX3ByaWNlX3N0cmVhbRhCIAEoCzImLnNpZGVzd2FwLnByb3RvLkZy'
    'b20uVXBkYXRlUHJpY2VTdHJlYW1IAFIRdXBkYXRlUHJpY2VTdHJlYW0SSAoNbG9jYWxfbWVzc2'
    'FnZRhEIAEoCzIhLnNpZGVzd2FwLnByb3RvLkZyb20uTG9jYWxNZXNzYWdlSABSDGxvY2FsTWVz'
    'c2FnZRJeChVtYXJrZXRfZGF0YV9zdWJzY3JpYmUYRiABKAsyKC5zaWRlc3dhcC5wcm90by5Gcm'
    '9tLk1hcmtldERhdGFTdWJzY3JpYmVIAFITbWFya2V0RGF0YVN1YnNjcmliZRJVChJtYXJrZXRf'
    'ZGF0YV91cGRhdGUYRyABKAsyJS5zaWRlc3dhcC5wcm90by5Gcm9tLk1hcmtldERhdGFVcGRhdG'
    'VIAFIQbWFya2V0RGF0YVVwZGF0ZRJRChBwb3J0Zm9saW9fcHJpY2VzGEggASgLMiQuc2lkZXN3'
    'YXAucHJvdG8uRnJvbS5Qb3J0Zm9saW9QcmljZXNIAFIPcG9ydGZvbGlvUHJpY2VzEj8KCmphZG'
    'VfcG9ydHMYUCABKAsyHi5zaWRlc3dhcC5wcm90by5Gcm9tLkphZGVQb3J0c0gAUglqYWRlUG9y'
    'dHMSQgoLamFkZV9zdGF0dXMYUyABKAsyHy5zaWRlc3dhcC5wcm90by5Gcm9tLkphZGVTdGF0dX'
    'NIAFIKamFkZVN0YXR1cxJCCgtnYWlkX3N0YXR1cxhbIAEoCzIfLnNpZGVzd2FwLnByb3RvLkZy'
    'b20uR2FpZFN0YXR1c0gAUgpnYWlkU3RhdHVzGmMKBUxvZ2luEh0KCWVycm9yX21zZxgBIAEoCU'
    'gAUghlcnJvck1zZxIxCgdzdWNjZXNzGAIgASgLMhUuc2lkZXN3YXAucHJvdG8uRW1wdHlIAFIH'
    'c3VjY2Vzc0IICgZyZXN1bHQafQoLRW52U2V0dGluZ3MSJgoPcG9saWN5X2Fzc2V0X2lkGAEgAi'
    'gJUg1wb2xpY3lBc3NldElkEiIKDXVzZHRfYXNzZXRfaWQYAiACKAlSC3VzZHRBc3NldElkEiIK'
    'DWV1cnhfYXNzZXRfaWQYAyACKAlSC2V1cnhBc3NldElkGtQBCgpFbmNyeXB0UGluEhYKBWVycm'
    '9yGAEgASgJSABSBWVycm9yEjoKBGRhdGEYAiABKAsyJC5zaWRlc3dhcC5wcm90by5Gcm9tLkVu'
    'Y3J5cHRQaW4uRGF0YUgAUgRkYXRhGmgKBERhdGESEgoEc2FsdBgCIAIoCVIEc2FsdBIlCg5lbm'
    'NyeXB0ZWRfZGF0YRgDIAIoCVINZW5jcnlwdGVkRGF0YRIlCg5waW5faWRlbnRpZmllchgEIAIo'
    'CVINcGluSWRlbnRpZmllckIICgZyZXN1bHQaTAoKRGVjcnlwdFBpbhIWCgVlcnJvchgBIAEoCU'
    'gAUgVlcnJvchIcCghtbmVtb25pYxgCIAEoCUgAUghtbmVtb25pY0IICgZyZXN1bHQaTwoLUmVn'
    'aXN0ZXJBbXASFwoGYW1wX2lkGAEgASgJSABSBWFtcElkEh0KCWVycm9yX21zZxgCIAEoCUgAUg'
    'hlcnJvck1zZ0IICgZyZXN1bHQaIwoJQW1wQXNzZXRzEhYKBmFzc2V0cxgBIAMoCVIGYXNzZXRz'
    'Gj0KClVwZGF0ZWRUeHMSLwoFaXRlbXMYASADKAsyGS5zaWRlc3dhcC5wcm90by5UcmFuc0l0ZW'
    '1SBWl0ZW1zGiIKClJlbW92ZWRUeHMSFAoFdHhpZHMYASADKAlSBXR4aWRzGlkKC1VwZGF0ZWRQ'
    'ZWdzEhkKCG9yZGVyX2lkGAEgAigJUgdvcmRlcklkEi8KBWl0ZW1zGAIgAygLMhkuc2lkZXN3YX'
    'AucHJvdG8uVHJhbnNJdGVtUgVpdGVtcxp3Cg1CYWxhbmNlVXBkYXRlEjEKB2FjY291bnQYASAC'
    'KAsyFy5zaWRlc3dhcC5wcm90by5BY2NvdW50UgdhY2NvdW50EjMKCGJhbGFuY2VzGAIgAygLMh'
    'cuc2lkZXN3YXAucHJvdG8uQmFsYW5jZVIIYmFsYW5jZXMa3gEKClV0eG9VcGRhdGUSMQoHYWNj'
    'b3VudBgBIAIoCzIXLnNpZGVzd2FwLnByb3RvLkFjY291bnRSB2FjY291bnQSOgoFdXR4b3MYAi'
    'ADKAsyJC5zaWRlc3dhcC5wcm90by5Gcm9tLlV0eG9VcGRhdGUuVXR4b1IFdXR4b3MaYQoEVXR4'
    'bxISCgR0eGlkGAEgAigJUgR0eGlkEhIKBHZvdXQYAiACKA1SBHZvdXQSGQoIYXNzZXRfaWQYAy'
    'ACKAlSB2Fzc2V0SWQSFgoGYW1vdW50GAQgAigEUgZhbW91bnQaRQoLUGVnaW5XYWl0VHgSGQoI'
    'cGVnX2FkZHIYBSACKAlSB3BlZ0FkZHISGwoJcmVjdl9hZGRyGAYgAigJUghyZWN2QWRkchrCAg'
    'oMUGVnT3V0QW1vdW50Eh0KCWVycm9yX21zZxgBIAEoCUgAUghlcnJvck1zZxJFCgdhbW91bnRz'
    'GAIgASgLMikuc2lkZXN3YXAucHJvdG8uRnJvbS5QZWdPdXRBbW91bnQuQW1vdW50c0gAUgdhbW'
    '91bnRzGsEBCgdBbW91bnRzEh8KC3NlbmRfYW1vdW50GAEgAigDUgpzZW5kQW1vdW50Eh8KC3Jl'
    'Y3ZfYW1vdW50GAIgAigDUgpyZWN2QW1vdW50EiYKD2lzX3NlbmRfZW50ZXJlZBgEIAIoCFINaX'
    'NTZW5kRW50ZXJlZBIZCghmZWVfcmF0ZRgFIAIoAVIHZmVlUmF0ZRIxCgdhY2NvdW50GAYgAigL'
    'Mhcuc2lkZXN3YXAucHJvdG8uQWNjb3VudFIHYWNjb3VudEIICgZyZXN1bHQabQoLUmVjdkFkZH'
    'Jlc3MSKwoEYWRkchgBIAIoCzIXLnNpZGVzd2FwLnByb3RvLkFkZHJlc3NSBGFkZHISMQoHYWNj'
    'b3VudBgCIAIoCzIXLnNpZGVzd2FwLnByb3RvLkFjY291bnRSB2FjY291bnQadQoOQ3JlYXRlVH'
    'hSZXN1bHQSHQoJZXJyb3JfbXNnGAEgASgJSABSCGVycm9yTXNnEjoKCmNyZWF0ZWRfdHgYAiAB'
    'KAsyGS5zaWRlc3dhcC5wcm90by5DcmVhdGVkVHhIAFIJY3JlYXRlZFR4QggKBnJlc3VsdBqJAQ'
    'oTQ3JlYXRlUGF5am9pblJlc3VsdBIdCgllcnJvcl9tc2cYASABKAlIAFIIZXJyb3JNc2cSSQoP'
    'Y3JlYXRlZF9wYXlqb2luGAIgASgLMh4uc2lkZXN3YXAucHJvdG8uQ3JlYXRlZFBheWpvaW5IAF'
    'IOY3JlYXRlZFBheWpvaW5CCAoGcmVzdWx0GmsKClNlbmRSZXN1bHQSHQoJZXJyb3JfbXNnGAEg'
    'ASgJSABSCGVycm9yTXNnEjQKB3R4X2l0ZW0YAiABKAsyGS5zaWRlc3dhcC5wcm90by5UcmFuc0'
    'l0ZW1IAFIGdHhJdGVtQggKBnJlc3VsdBp1Cg1CbGluZGVkVmFsdWVzEhIKBHR4aWQYASACKAlS'
    'BHR4aWQSHQoJZXJyb3JfbXNnGAIgASgJSABSCGVycm9yTXNnEicKDmJsaW5kZWRfdmFsdWVzGA'
    'MgASgJSABSDWJsaW5kZWRWYWx1ZXNCCAoGcmVzdWx0GkcKC1ByaWNlVXBkYXRlEhQKBWFzc2V0'
    'GAEgAigJUgVhc3NldBIQCgNiaWQYAiACKAFSA2JpZBIQCgNhc2sYAyACKAFSA2FzaxpXCg1SZW'
    'dpc3RlclBob25lEh0KCXBob25lX2tleRgBIAEoCUgAUghwaG9uZUtleRIdCgllcnJvcl9tc2cY'
    'AiABKAlIAFIIZXJyb3JNc2dCCAoGcmVzdWx0GmkKC1ZlcmlmeVBob25lEjEKB3N1Y2Nlc3MYAS'
    'ABKAsyFS5zaWRlc3dhcC5wcm90by5FbXB0eUgAUgdzdWNjZXNzEh0KCWVycm9yX21zZxgCIAEo'
    'CUgAUghlcnJvck1zZ0IICgZyZXN1bHQaIQoLU2hvd01lc3NhZ2USEgoEdGV4dBgBIAIoCVIEdG'
    'V4dBpsChVTaG93SW5zdWZmaWNpZW50RnVuZHMSGQoIYXNzZXRfaWQYASACKAlSB2Fzc2V0SWQS'
    'HAoJYXZhaWxhYmxlGAIgAigDUglhdmFpbGFibGUSGgoIcmVxdWlyZWQYAyACKANSCHJlcXVpcm'
    'VkGtEDCgxTdWJtaXRSZXZpZXcSGQoIb3JkZXJfaWQYASACKAlSB29yZGVySWQSFAoFYXNzZXQY'
    'AiACKAlSBWFzc2V0EiUKDmJpdGNvaW5fYW1vdW50GAMgAigDUg1iaXRjb2luQW1vdW50Eh0KCn'
    'NlcnZlcl9mZWUYCCACKANSCXNlcnZlckZlZRIhCgxhc3NldF9hbW91bnQYBCACKANSC2Fzc2V0'
    'QW1vdW50EhQKBXByaWNlGAUgAigBUgVwcmljZRIhCgxzZWxsX2JpdGNvaW4YBiACKAhSC3NlbG'
    'xCaXRjb2luEjoKBHN0ZXAYByACKA4yJi5zaWRlc3dhcC5wcm90by5Gcm9tLlN1Ym1pdFJldmll'
    'dy5TdGVwUgRzdGVwEh8KC2luZGV4X3ByaWNlGAkgAigIUgppbmRleFByaWNlEhsKCWF1dG9fc2'
    'lnbhgLIAIoCFIIYXV0b1NpZ24SGQoIdHdvX3N0ZXAYDCABKAhSB3R3b1N0ZXASMAoUdHhfY2hh'
    'aW5pbmdfcmVxdWlyZWQYDSABKAhSEnR4Q2hhaW5pbmdSZXF1aXJlZCInCgRTdGVwEgoKBlNVQk'
    '1JVBABEgkKBVFVT1RFEAISCAoEU0lHThADGsoCCgxTdWJtaXRSZXN1bHQSPgoOc3VibWl0X3N1'
    'Y2NlZWQYASABKAsyFS5zaWRlc3dhcC5wcm90by5FbXB0eUgAUg1zdWJtaXRTdWNjZWVkEj4KDH'
    'N3YXBfc3VjY2VlZBgCIAEoCzIZLnNpZGVzd2FwLnByb3RvLlRyYW5zSXRlbUgAUgtzd2FwU3Vj'
    'Y2VlZBIWCgVlcnJvchgDIAEoCUgAUgVlcnJvchJhChF1bnJlZ2lzdGVyZWRfZ2FpZBgEIAEoCz'
    'IyLnNpZGVzd2FwLnByb3RvLkZyb20uU3VibWl0UmVzdWx0LlVucmVnaXN0ZXJlZEdhaWRIAFIQ'
    'dW5yZWdpc3RlcmVkR2FpZBo1ChBVbnJlZ2lzdGVyZWRHYWlkEiEKDGRvbWFpbl9hZ2VudBgBIA'
    'IoCVILZG9tYWluQWdlbnRCCAoGcmVzdWx0GicKClN0YXJ0VGltZXISGQoIb3JkZXJfaWQYASAC'
    'KAlSB29yZGVySWQaTQoMT3JkZXJDcmVhdGVkEisKBW9yZGVyGAEgAigLMhUuc2lkZXN3YXAucH'
    'JvdG8uT3JkZXJSBW9yZGVyEhAKA25ldxgCIAIoCFIDbmV3GikKDE9yZGVyUmVtb3ZlZBIZCghv'
    'cmRlcl9pZBgBIAIoCVIHb3JkZXJJZBo+Cg1PcmRlckNvbXBsZXRlEhkKCG9yZGVyX2lkGAEgAi'
    'gJUgdvcmRlcklkEhIKBHR4aWQYAiABKAlSBHR4aWQaTQoKSW5kZXhQcmljZRIZCghhc3NldF9p'
    'ZBgBIAIoCVIHYXNzZXRJZBIQCgNpbmQYAiABKAFSA2luZBISCgRsYXN0GAMgASgBUgRsYXN0Gj'
    'EKDkNvbnRhY3RSZW1vdmVkEh8KC2NvbnRhY3Rfa2V5GAEgAigJUgpjb250YWN0S2V5Gi8KDUFj'
    'Y291bnRTdGF0dXMSHgoKcmVnaXN0ZXJlZBgBIAIoCFIKcmVnaXN0ZXJlZBrLAwoMQXNzZXREZX'
    'RhaWxzEhkKCGFzc2V0X2lkGAEgAigJUgdhc3NldElkEj0KBXN0YXRzGAIgASgLMicuc2lkZXN3'
    'YXAucHJvdG8uRnJvbS5Bc3NldERldGFpbHMuU3RhdHNSBXN0YXRzEhsKCWNoYXJ0X3VybBgDIA'
    'EoCVIIY2hhcnRVcmwSTQoLY2hhcnRfc3RhdHMYBCABKAsyLC5zaWRlc3dhcC5wcm90by5Gcm9t'
    'LkFzc2V0RGV0YWlscy5DaGFydFN0YXRzUgpjaGFydFN0YXRzGqwBCgVTdGF0cxIjCg1pc3N1ZW'
    'RfYW1vdW50GAEgAigDUgxpc3N1ZWRBbW91bnQSIwoNYnVybmVkX2Ftb3VudBgCIAIoA1IMYnVy'
    'bmVkQW1vdW50EiUKDm9mZmxpbmVfYW1vdW50GAQgAigDUg1vZmZsaW5lQW1vdW50EjIKFWhhc1'
    '9ibGluZGVkX2lzc3VhbmNlcxgDIAIoCFITaGFzQmxpbmRlZElzc3VhbmNlcxpGCgpDaGFydFN0'
    'YXRzEhAKA2xvdxgBIAIoAVIDbG93EhIKBGhpZ2gYAiACKAFSBGhpZ2gSEgoEbGFzdBgDIAIoAV'
    'IEbGFzdBrIAQoRVXBkYXRlUHJpY2VTdHJlYW0SGQoIYXNzZXRfaWQYASACKAlSB2Fzc2V0SWQS'
    'IwoNc2VuZF9iaXRjb2lucxgCIAIoCFIMc2VuZEJpdGNvaW5zEh8KC3NlbmRfYW1vdW50GAMgAS'
    'gDUgpzZW5kQW1vdW50Eh8KC3JlY3ZfYW1vdW50GAQgASgDUgpyZWN2QW1vdW50EhQKBXByaWNl'
    'GAUgASgBUgVwcmljZRIbCgllcnJvcl9tc2cYBiABKAlSCGVycm9yTXNnGjgKDExvY2FsTWVzc2'
    'FnZRIUCgV0aXRsZRgBIAIoCVIFdGl0bGUSEgoEYm9keRgCIAIoCVIEYm9keRpgChNNYXJrZXRE'
    'YXRhU3Vic2NyaWJlEhkKCGFzc2V0X2lkGAEgAigJUgdhc3NldElkEi4KBGRhdGEYAiADKAsyGi'
    '5zaWRlc3dhcC5wcm90by5DaGFydFBvaW50UgRkYXRhGmEKEE1hcmtldERhdGFVcGRhdGUSGQoI'
    'YXNzZXRfaWQYASACKAlSB2Fzc2V0SWQSMgoGdXBkYXRlGAIgAigLMhouc2lkZXN3YXAucHJvdG'
    '8uQ2hhcnRQb2ludFIGdXBkYXRlGqMBCg9Qb3J0Zm9saW9QcmljZXMSUgoKcHJpY2VzX3VzZBgB'
    'IAMoCzIzLnNpZGVzd2FwLnByb3RvLkZyb20uUG9ydGZvbGlvUHJpY2VzLlByaWNlc1VzZEVudH'
    'J5UglwcmljZXNVc2QaPAoOUHJpY2VzVXNkRW50cnkSEAoDa2V5GAEgASgJUgNrZXkSFAoFdmFs'
    'dWUYAiABKAFSBXZhbHVlOgI4ARqTAgoJSmFkZVBvcnRzEjkKBXBvcnRzGAEgAygLMiMuc2lkZX'
    'N3YXAucHJvdG8uRnJvbS5KYWRlUG9ydHMuUG9ydFIFcG9ydHMaoQEKBFBvcnQSFwoHamFkZV9p'
    'ZBgBIAIoCVIGamFkZUlkEhIKBHBvcnQYAiACKAlSBHBvcnQSFgoGc2VyaWFsGAMgAigJUgZzZX'
    'JpYWwSGAoHdmVyc2lvbhgEIAIoCVIHdmVyc2lvbhI6CgVzdGF0ZRgFIAIoDjIkLnNpZGVzd2Fw'
    'LnByb3RvLkZyb20uSmFkZVBvcnRzLlN0YXRlUgVzdGF0ZSInCgVTdGF0ZRIKCgZVTklOSVQQAB'
    'IICgRNQUlOEAESCAoEVEVTVBACGuMBCgpKYWRlU3RhdHVzEj4KBnN0YXR1cxgBIAIoDjImLnNp'
    'ZGVzd2FwLnByb3RvLkZyb20uSmFkZVN0YXR1cy5TdGF0dXNSBnN0YXR1cyKUAQoGU3RhdHVzEg'
    'gKBElETEUQARIPCgtSRUFEX1NUQVRVUxACEg0KCUFVVEhfVVNFUhADEhcKE01BU1RFUl9CTElO'
    'RElOR19LRVkQBRILCgdTSUdOX1RYEAQSDQoJU0lHTl9TV0FQEAgSFAoQU0lHTl9TV0FQX09VVF'
    'BVVBAGEhUKEVNJR05fT0ZGTElORV9TV0FQEAcaUQoKR2FpZFN0YXR1cxISCgRnYWlkGAEgAigJ'
    'UgRnYWlkEhkKCGFzc2V0X2lkGAIgAigJUgdhc3NldElkEhQKBWVycm9yGAMgASgJUgVlcnJvck'
    'IFCgNtc2c=');

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
    {'1': 'account', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.Account', '10': 'account'},
    {'1': 'asset_id', '3': 2, '4': 2, '5': 9, '10': 'assetId'},
  ],
};

/// Descriptor for `Settings`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List settingsDescriptor = $convert.base64Decode(
    'CghTZXR0aW5ncxJSChFkaXNhYmxlZF9hY2NvdW50cxgBIAMoCzIlLnNpZGVzd2FwLnByb3RvLl'
    'NldHRpbmdzLkFjY291bnRBc3NldFIQZGlzYWJsZWRBY2NvdW50cxpcCgxBY2NvdW50QXNzZXQS'
    'MQoHYWNjb3VudBgBIAIoCzIXLnNpZGVzd2FwLnByb3RvLkFjY291bnRSB2FjY291bnQSGQoIYX'
    'NzZXRfaWQYAiACKAlSB2Fzc2V0SWQ=');

