///
//  Generated code. Do not modify.
//  source: sideswap.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use emptyDescriptor instead')
const Empty$json = const {
  '1': 'Empty',
};

/// Descriptor for `Empty`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List emptyDescriptor = $convert.base64Decode('CgVFbXB0eQ==');
@$core.Deprecated('Use accountDescriptor instead')
const Account$json = const {
  '1': 'Account',
  '2': const [
    const {'1': 'id', '3': 1, '4': 2, '5': 5, '10': 'id'},
  ],
};

/// Descriptor for `Account`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List accountDescriptor = $convert.base64Decode('CgdBY2NvdW50Eg4KAmlkGAEgAigFUgJpZA==');
@$core.Deprecated('Use addressDescriptor instead')
const Address$json = const {
  '1': 'Address',
  '2': const [
    const {'1': 'addr', '3': 1, '4': 2, '5': 9, '10': 'addr'},
  ],
};

/// Descriptor for `Address`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addressDescriptor = $convert.base64Decode('CgdBZGRyZXNzEhIKBGFkZHIYASACKAlSBGFkZHI=');
@$core.Deprecated('Use addressAmountDescriptor instead')
const AddressAmount$json = const {
  '1': 'AddressAmount',
  '2': const [
    const {'1': 'address', '3': 1, '4': 2, '5': 9, '10': 'address'},
    const {'1': 'amount', '3': 2, '4': 2, '5': 3, '10': 'amount'},
    const {'1': 'asset_id', '3': 3, '4': 2, '5': 9, '10': 'assetId'},
  ],
};

/// Descriptor for `AddressAmount`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addressAmountDescriptor = $convert.base64Decode('Cg1BZGRyZXNzQW1vdW50EhgKB2FkZHJlc3MYASACKAlSB2FkZHJlc3MSFgoGYW1vdW50GAIgAigDUgZhbW91bnQSGQoIYXNzZXRfaWQYAyACKAlSB2Fzc2V0SWQ=');
@$core.Deprecated('Use balanceDescriptor instead')
const Balance$json = const {
  '1': 'Balance',
  '2': const [
    const {'1': 'asset_id', '3': 1, '4': 2, '5': 9, '10': 'assetId'},
    const {'1': 'amount', '3': 2, '4': 2, '5': 3, '10': 'amount'},
  ],
};

/// Descriptor for `Balance`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List balanceDescriptor = $convert.base64Decode('CgdCYWxhbmNlEhkKCGFzc2V0X2lkGAEgAigJUgdhc3NldElkEhYKBmFtb3VudBgCIAIoA1IGYW1vdW50');
@$core.Deprecated('Use txBalanceDescriptor instead')
const TxBalance$json = const {
  '1': 'TxBalance',
  '2': const [
    const {'1': 'asset_id', '3': 1, '4': 2, '5': 9, '10': 'assetId'},
    const {'1': 'amount', '3': 2, '4': 2, '5': 3, '10': 'amount'},
    const {'1': 'account', '3': 3, '4': 2, '5': 11, '6': '.sideswap.proto.Account', '10': 'account'},
  ],
};

/// Descriptor for `TxBalance`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List txBalanceDescriptor = $convert.base64Decode('CglUeEJhbGFuY2USGQoIYXNzZXRfaWQYASACKAlSB2Fzc2V0SWQSFgoGYW1vdW50GAIgAigDUgZhbW91bnQSMQoHYWNjb3VudBgDIAIoCzIXLnNpZGVzd2FwLnByb3RvLkFjY291bnRSB2FjY291bnQ=');
@$core.Deprecated('Use assetDescriptor instead')
const Asset$json = const {
  '1': 'Asset',
  '2': const [
    const {'1': 'asset_id', '3': 1, '4': 2, '5': 9, '10': 'assetId'},
    const {'1': 'name', '3': 2, '4': 2, '5': 9, '10': 'name'},
    const {'1': 'ticker', '3': 3, '4': 2, '5': 9, '10': 'ticker'},
    const {'1': 'icon', '3': 4, '4': 2, '5': 9, '10': 'icon'},
    const {'1': 'precision', '3': 5, '4': 2, '5': 13, '10': 'precision'},
    const {'1': 'swap_market', '3': 6, '4': 2, '5': 8, '10': 'swapMarket'},
    const {'1': 'amp_market', '3': 9, '4': 2, '5': 8, '10': 'ampMarket'},
    const {'1': 'unregistered', '3': 8, '4': 2, '5': 8, '10': 'unregistered'},
    const {'1': 'domain', '3': 7, '4': 1, '5': 9, '10': 'domain'},
    const {'1': 'domain_agent', '3': 10, '4': 1, '5': 9, '10': 'domainAgent'},
  ],
};

/// Descriptor for `Asset`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assetDescriptor = $convert.base64Decode('CgVBc3NldBIZCghhc3NldF9pZBgBIAIoCVIHYXNzZXRJZBISCgRuYW1lGAIgAigJUgRuYW1lEhYKBnRpY2tlchgDIAIoCVIGdGlja2VyEhIKBGljb24YBCACKAlSBGljb24SHAoJcHJlY2lzaW9uGAUgAigNUglwcmVjaXNpb24SHwoLc3dhcF9tYXJrZXQYBiACKAhSCnN3YXBNYXJrZXQSHQoKYW1wX21hcmtldBgJIAIoCFIJYW1wTWFya2V0EiIKDHVucmVnaXN0ZXJlZBgIIAIoCFIMdW5yZWdpc3RlcmVkEhYKBmRvbWFpbhgHIAEoCVIGZG9tYWluEiEKDGRvbWFpbl9hZ2VudBgKIAEoCVILZG9tYWluQWdlbnQ=');
@$core.Deprecated('Use txDescriptor instead')
const Tx$json = const {
  '1': 'Tx',
  '2': const [
    const {'1': 'balances', '3': 1, '4': 3, '5': 11, '6': '.sideswap.proto.TxBalance', '10': 'balances'},
    const {'1': 'txid', '3': 2, '4': 2, '5': 9, '10': 'txid'},
    const {'1': 'network_fee', '3': 3, '4': 2, '5': 3, '10': 'networkFee'},
    const {'1': 'size', '3': 5, '4': 2, '5': 3, '10': 'size'},
    const {'1': 'vsize', '3': 6, '4': 2, '5': 3, '10': 'vsize'},
    const {'1': 'memo', '3': 4, '4': 2, '5': 9, '10': 'memo'},
  ],
};

/// Descriptor for `Tx`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List txDescriptor = $convert.base64Decode('CgJUeBI1CghiYWxhbmNlcxgBIAMoCzIZLnNpZGVzd2FwLnByb3RvLlR4QmFsYW5jZVIIYmFsYW5jZXMSEgoEdHhpZBgCIAIoCVIEdHhpZBIfCgtuZXR3b3JrX2ZlZRgDIAIoA1IKbmV0d29ya0ZlZRISCgRzaXplGAUgAigDUgRzaXplEhQKBXZzaXplGAYgAigDUgV2c2l6ZRISCgRtZW1vGAQgAigJUgRtZW1v');
@$core.Deprecated('Use pegDescriptor instead')
const Peg$json = const {
  '1': 'Peg',
  '2': const [
    const {'1': 'is_peg_in', '3': 1, '4': 2, '5': 8, '10': 'isPegIn'},
    const {'1': 'amount_send', '3': 2, '4': 2, '5': 3, '10': 'amountSend'},
    const {'1': 'amount_recv', '3': 3, '4': 2, '5': 3, '10': 'amountRecv'},
    const {'1': 'addr_send', '3': 4, '4': 2, '5': 9, '10': 'addrSend'},
    const {'1': 'addr_recv', '3': 5, '4': 2, '5': 9, '10': 'addrRecv'},
    const {'1': 'txid_send', '3': 6, '4': 2, '5': 9, '10': 'txidSend'},
    const {'1': 'txid_recv', '3': 8, '4': 1, '5': 9, '10': 'txidRecv'},
  ],
};

/// Descriptor for `Peg`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pegDescriptor = $convert.base64Decode('CgNQZWcSGgoJaXNfcGVnX2luGAEgAigIUgdpc1BlZ0luEh8KC2Ftb3VudF9zZW5kGAIgAigDUgphbW91bnRTZW5kEh8KC2Ftb3VudF9yZWN2GAMgAigDUgphbW91bnRSZWN2EhsKCWFkZHJfc2VuZBgEIAIoCVIIYWRkclNlbmQSGwoJYWRkcl9yZWN2GAUgAigJUghhZGRyUmVjdhIbCgl0eGlkX3NlbmQYBiACKAlSCHR4aWRTZW5kEhsKCXR4aWRfcmVjdhgIIAEoCVIIdHhpZFJlY3Y=');
@$core.Deprecated('Use confsDescriptor instead')
const Confs$json = const {
  '1': 'Confs',
  '2': const [
    const {'1': 'count', '3': 1, '4': 2, '5': 13, '10': 'count'},
    const {'1': 'total', '3': 2, '4': 2, '5': 13, '10': 'total'},
  ],
};

/// Descriptor for `Confs`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List confsDescriptor = $convert.base64Decode('CgVDb25mcxIUCgVjb3VudBgBIAIoDVIFY291bnQSFAoFdG90YWwYAiACKA1SBXRvdGFs');
@$core.Deprecated('Use transItemDescriptor instead')
const TransItem$json = const {
  '1': 'TransItem',
  '2': const [
    const {'1': 'id', '3': 1, '4': 2, '5': 9, '10': 'id'},
    const {'1': 'created_at', '3': 2, '4': 2, '5': 3, '10': 'createdAt'},
    const {'1': 'confs', '3': 3, '4': 1, '5': 11, '6': '.sideswap.proto.Confs', '10': 'confs'},
    const {'1': 'tx', '3': 10, '4': 1, '5': 11, '6': '.sideswap.proto.Tx', '9': 0, '10': 'tx'},
    const {'1': 'peg', '3': 11, '4': 1, '5': 11, '6': '.sideswap.proto.Peg', '9': 0, '10': 'peg'},
  ],
  '8': const [
    const {'1': 'item'},
  ],
};

/// Descriptor for `TransItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List transItemDescriptor = $convert.base64Decode('CglUcmFuc0l0ZW0SDgoCaWQYASACKAlSAmlkEh0KCmNyZWF0ZWRfYXQYAiACKANSCWNyZWF0ZWRBdBIrCgVjb25mcxgDIAEoCzIVLnNpZGVzd2FwLnByb3RvLkNvbmZzUgVjb25mcxIkCgJ0eBgKIAEoCzISLnNpZGVzd2FwLnByb3RvLlR4SABSAnR4EicKA3BlZxgLIAEoCzITLnNpZGVzd2FwLnByb3RvLlBlZ0gAUgNwZWdCBgoEaXRlbQ==');
@$core.Deprecated('Use assetIdDescriptor instead')
const AssetId$json = const {
  '1': 'AssetId',
  '2': const [
    const {'1': 'asset_id', '3': 1, '4': 2, '5': 9, '10': 'assetId'},
  ],
};

/// Descriptor for `AssetId`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assetIdDescriptor = $convert.base64Decode('CgdBc3NldElkEhkKCGFzc2V0X2lkGAEgAigJUgdhc3NldElk');
@$core.Deprecated('Use genericResponseDescriptor instead')
const GenericResponse$json = const {
  '1': 'GenericResponse',
  '2': const [
    const {'1': 'success', '3': 1, '4': 2, '5': 8, '10': 'success'},
    const {'1': 'error_msg', '3': 2, '4': 1, '5': 9, '10': 'errorMsg'},
  ],
};

/// Descriptor for `GenericResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List genericResponseDescriptor = $convert.base64Decode('Cg9HZW5lcmljUmVzcG9uc2USGAoHc3VjY2VzcxgBIAIoCFIHc3VjY2VzcxIbCgllcnJvcl9tc2cYAiABKAlSCGVycm9yTXNn');
@$core.Deprecated('Use feeRateDescriptor instead')
const FeeRate$json = const {
  '1': 'FeeRate',
  '2': const [
    const {'1': 'blocks', '3': 1, '4': 2, '5': 5, '10': 'blocks'},
    const {'1': 'value', '3': 2, '4': 2, '5': 1, '10': 'value'},
  ],
};

/// Descriptor for `FeeRate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List feeRateDescriptor = $convert.base64Decode('CgdGZWVSYXRlEhYKBmJsb2NrcxgBIAIoBVIGYmxvY2tzEhQKBXZhbHVlGAIgAigBUgV2YWx1ZQ==');
@$core.Deprecated('Use serverStatusDescriptor instead')
const ServerStatus$json = const {
  '1': 'ServerStatus',
  '2': const [
    const {'1': 'min_peg_in_amount', '3': 1, '4': 2, '5': 3, '10': 'minPegInAmount'},
    const {'1': 'min_peg_out_amount', '3': 2, '4': 2, '5': 3, '10': 'minPegOutAmount'},
    const {'1': 'server_fee_percent_peg_in', '3': 3, '4': 2, '5': 1, '10': 'serverFeePercentPegIn'},
    const {'1': 'server_fee_percent_peg_out', '3': 4, '4': 2, '5': 1, '10': 'serverFeePercentPegOut'},
    const {'1': 'bitcoin_fee_rates', '3': 5, '4': 3, '5': 11, '6': '.sideswap.proto.FeeRate', '10': 'bitcoinFeeRates'},
  ],
};

/// Descriptor for `ServerStatus`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serverStatusDescriptor = $convert.base64Decode('CgxTZXJ2ZXJTdGF0dXMSKQoRbWluX3BlZ19pbl9hbW91bnQYASACKANSDm1pblBlZ0luQW1vdW50EisKEm1pbl9wZWdfb3V0X2Ftb3VudBgCIAIoA1IPbWluUGVnT3V0QW1vdW50EjgKGXNlcnZlcl9mZWVfcGVyY2VudF9wZWdfaW4YAyACKAFSFXNlcnZlckZlZVBlcmNlbnRQZWdJbhI6ChpzZXJ2ZXJfZmVlX3BlcmNlbnRfcGVnX291dBgEIAIoAVIWc2VydmVyRmVlUGVyY2VudFBlZ091dBJDChFiaXRjb2luX2ZlZV9yYXRlcxgFIAMoCzIXLnNpZGVzd2FwLnByb3RvLkZlZVJhdGVSD2JpdGNvaW5GZWVSYXRlcw==');
@$core.Deprecated('Use uploadContactDescriptor instead')
const UploadContact$json = const {
  '1': 'UploadContact',
  '2': const [
    const {'1': 'identifier', '3': 1, '4': 2, '5': 9, '10': 'identifier'},
    const {'1': 'name', '3': 2, '4': 2, '5': 9, '10': 'name'},
    const {'1': 'phones', '3': 3, '4': 3, '5': 9, '10': 'phones'},
  ],
};

/// Descriptor for `UploadContact`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List uploadContactDescriptor = $convert.base64Decode('Cg1VcGxvYWRDb250YWN0Eh4KCmlkZW50aWZpZXIYASACKAlSCmlkZW50aWZpZXISEgoEbmFtZRgCIAIoCVIEbmFtZRIWCgZwaG9uZXMYAyADKAlSBnBob25lcw==');
@$core.Deprecated('Use contactDescriptor instead')
const Contact$json = const {
  '1': 'Contact',
  '2': const [
    const {'1': 'contact_key', '3': 1, '4': 2, '5': 9, '10': 'contactKey'},
    const {'1': 'name', '3': 2, '4': 2, '5': 9, '10': 'name'},
    const {'1': 'phone', '3': 3, '4': 2, '5': 9, '10': 'phone'},
  ],
};

/// Descriptor for `Contact`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List contactDescriptor = $convert.base64Decode('CgdDb250YWN0Eh8KC2NvbnRhY3Rfa2V5GAEgAigJUgpjb250YWN0S2V5EhIKBG5hbWUYAiACKAlSBG5hbWUSFAoFcGhvbmUYAyACKAlSBXBob25l');
@$core.Deprecated('Use contactTransactionDescriptor instead')
const ContactTransaction$json = const {
  '1': 'ContactTransaction',
  '2': const [
    const {'1': 'txid', '3': 1, '4': 2, '5': 9, '10': 'txid'},
    const {'1': 'contact_key', '3': 2, '4': 2, '5': 9, '10': 'contactKey'},
  ],
};

/// Descriptor for `ContactTransaction`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List contactTransactionDescriptor = $convert.base64Decode('ChJDb250YWN0VHJhbnNhY3Rpb24SEgoEdHhpZBgBIAIoCVIEdHhpZBIfCgtjb250YWN0X2tleRgCIAIoCVIKY29udGFjdEtleQ==');
@$core.Deprecated('Use orderDescriptor instead')
const Order$json = const {
  '1': 'Order',
  '2': const [
    const {'1': 'order_id', '3': 1, '4': 2, '5': 9, '10': 'orderId'},
    const {'1': 'asset_id', '3': 2, '4': 2, '5': 9, '10': 'assetId'},
    const {'1': 'bitcoin_amount', '3': 3, '4': 2, '5': 3, '10': 'bitcoinAmount'},
    const {'1': 'send_bitcoins', '3': 10, '4': 2, '5': 8, '10': 'sendBitcoins'},
    const {'1': 'server_fee', '3': 4, '4': 2, '5': 3, '10': 'serverFee'},
    const {'1': 'asset_amount', '3': 5, '4': 2, '5': 3, '10': 'assetAmount'},
    const {'1': 'price', '3': 6, '4': 2, '5': 1, '10': 'price'},
    const {'1': 'created_at', '3': 7, '4': 2, '5': 3, '10': 'createdAt'},
    const {'1': 'expires_at', '3': 8, '4': 2, '5': 3, '10': 'expiresAt'},
    const {'1': 'private', '3': 9, '4': 2, '5': 8, '10': 'private'},
    const {'1': 'two_step', '3': 17, '4': 2, '5': 8, '10': 'twoStep'},
    const {'1': 'auto_sign', '3': 11, '4': 2, '5': 8, '10': 'autoSign'},
    const {'1': 'own', '3': 12, '4': 2, '5': 8, '10': 'own'},
    const {'1': 'token_market', '3': 16, '4': 2, '5': 8, '10': 'tokenMarket'},
    const {'1': 'from_notification', '3': 13, '4': 2, '5': 8, '10': 'fromNotification'},
    const {'1': 'index_price', '3': 15, '4': 1, '5': 1, '10': 'indexPrice'},
  ],
};

/// Descriptor for `Order`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List orderDescriptor = $convert.base64Decode('CgVPcmRlchIZCghvcmRlcl9pZBgBIAIoCVIHb3JkZXJJZBIZCghhc3NldF9pZBgCIAIoCVIHYXNzZXRJZBIlCg5iaXRjb2luX2Ftb3VudBgDIAIoA1INYml0Y29pbkFtb3VudBIjCg1zZW5kX2JpdGNvaW5zGAogAigIUgxzZW5kQml0Y29pbnMSHQoKc2VydmVyX2ZlZRgEIAIoA1IJc2VydmVyRmVlEiEKDGFzc2V0X2Ftb3VudBgFIAIoA1ILYXNzZXRBbW91bnQSFAoFcHJpY2UYBiACKAFSBXByaWNlEh0KCmNyZWF0ZWRfYXQYByACKANSCWNyZWF0ZWRBdBIdCgpleHBpcmVzX2F0GAggAigDUglleHBpcmVzQXQSGAoHcHJpdmF0ZRgJIAIoCFIHcHJpdmF0ZRIZCgh0d29fc3RlcBgRIAIoCFIHdHdvU3RlcBIbCglhdXRvX3NpZ24YCyACKAhSCGF1dG9TaWduEhAKA293bhgMIAIoCFIDb3duEiEKDHRva2VuX21hcmtldBgQIAIoCFILdG9rZW5NYXJrZXQSKwoRZnJvbV9ub3RpZmljYXRpb24YDSACKAhSEGZyb21Ob3RpZmljYXRpb24SHwoLaW5kZXhfcHJpY2UYDyABKAFSCmluZGV4UHJpY2U=');
@$core.Deprecated('Use swapDetailsDescriptor instead')
const SwapDetails$json = const {
  '1': 'SwapDetails',
  '2': const [
    const {'1': 'order_id', '3': 1, '4': 2, '5': 9, '10': 'orderId'},
    const {'1': 'send_asset', '3': 2, '4': 2, '5': 9, '10': 'sendAsset'},
    const {'1': 'recv_asset', '3': 3, '4': 2, '5': 9, '10': 'recvAsset'},
    const {'1': 'send_amount', '3': 4, '4': 2, '5': 3, '10': 'sendAmount'},
    const {'1': 'recv_amount', '3': 5, '4': 2, '5': 3, '10': 'recvAmount'},
    const {'1': 'upload_url', '3': 6, '4': 2, '5': 9, '10': 'uploadUrl'},
  ],
};

/// Descriptor for `SwapDetails`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List swapDetailsDescriptor = $convert.base64Decode('CgtTd2FwRGV0YWlscxIZCghvcmRlcl9pZBgBIAIoCVIHb3JkZXJJZBIdCgpzZW5kX2Fzc2V0GAIgAigJUglzZW5kQXNzZXQSHQoKcmVjdl9hc3NldBgDIAIoCVIJcmVjdkFzc2V0Eh8KC3NlbmRfYW1vdW50GAQgAigDUgpzZW5kQW1vdW50Eh8KC3JlY3ZfYW1vdW50GAUgAigDUgpyZWN2QW1vdW50Eh0KCnVwbG9hZF91cmwYBiACKAlSCXVwbG9hZFVybA==');
@$core.Deprecated('Use networkSettingsDescriptor instead')
const NetworkSettings$json = const {
  '1': 'NetworkSettings',
  '2': const [
    const {'1': 'blockstream', '3': 1, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'blockstream'},
    const {'1': 'sideswap', '3': 2, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'sideswap'},
    const {'1': 'custom', '3': 3, '4': 1, '5': 11, '6': '.sideswap.proto.NetworkSettings.Custom', '9': 0, '10': 'custom'},
  ],
  '3': const [NetworkSettings_Custom$json],
  '8': const [
    const {'1': 'selected'},
  ],
};

@$core.Deprecated('Use networkSettingsDescriptor instead')
const NetworkSettings_Custom$json = const {
  '1': 'Custom',
  '2': const [
    const {'1': 'host', '3': 1, '4': 2, '5': 9, '10': 'host'},
    const {'1': 'port', '3': 2, '4': 2, '5': 5, '10': 'port'},
    const {'1': 'use_tls', '3': 3, '4': 2, '5': 8, '10': 'useTls'},
  ],
};

/// Descriptor for `NetworkSettings`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List networkSettingsDescriptor = $convert.base64Decode('Cg9OZXR3b3JrU2V0dGluZ3MSOQoLYmxvY2tzdHJlYW0YASABKAsyFS5zaWRlc3dhcC5wcm90by5FbXB0eUgAUgtibG9ja3N0cmVhbRIzCghzaWRlc3dhcBgCIAEoCzIVLnNpZGVzd2FwLnByb3RvLkVtcHR5SABSCHNpZGVzd2FwEkAKBmN1c3RvbRgDIAEoCzImLnNpZGVzd2FwLnByb3RvLk5ldHdvcmtTZXR0aW5ncy5DdXN0b21IAFIGY3VzdG9tGkkKBkN1c3RvbRISCgRob3N0GAEgAigJUgRob3N0EhIKBHBvcnQYAiACKAVSBHBvcnQSFwoHdXNlX3RscxgDIAIoCFIGdXNlVGxzQgoKCHNlbGVjdGVk');
@$core.Deprecated('Use createTxDescriptor instead')
const CreateTx$json = const {
  '1': 'CreateTx',
  '2': const [
    const {'1': 'addr', '3': 1, '4': 2, '5': 9, '10': 'addr'},
    const {'1': 'balance', '3': 2, '4': 2, '5': 11, '6': '.sideswap.proto.Balance', '10': 'balance'},
    const {'1': 'is_contact', '3': 3, '4': 2, '5': 8, '10': 'isContact'},
    const {'1': 'account', '3': 4, '4': 2, '5': 11, '6': '.sideswap.proto.Account', '10': 'account'},
  ],
};

/// Descriptor for `CreateTx`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createTxDescriptor = $convert.base64Decode('CghDcmVhdGVUeBISCgRhZGRyGAEgAigJUgRhZGRyEjEKB2JhbGFuY2UYAiACKAsyFy5zaWRlc3dhcC5wcm90by5CYWxhbmNlUgdiYWxhbmNlEh0KCmlzX2NvbnRhY3QYAyACKAhSCWlzQ29udGFjdBIxCgdhY2NvdW50GAQgAigLMhcuc2lkZXN3YXAucHJvdG8uQWNjb3VudFIHYWNjb3VudA==');
@$core.Deprecated('Use createdTxDescriptor instead')
const CreatedTx$json = const {
  '1': 'CreatedTx',
  '2': const [
    const {'1': 'req', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.CreateTx', '10': 'req'},
    const {'1': 'input_count', '3': 2, '4': 2, '5': 5, '10': 'inputCount'},
    const {'1': 'output_count', '3': 3, '4': 2, '5': 5, '10': 'outputCount'},
    const {'1': 'size', '3': 4, '4': 2, '5': 3, '10': 'size'},
    const {'1': 'vsize', '3': 7, '4': 2, '5': 3, '10': 'vsize'},
    const {'1': 'network_fee', '3': 5, '4': 2, '5': 3, '10': 'networkFee'},
    const {'1': 'fee_per_byte', '3': 6, '4': 2, '5': 1, '10': 'feePerByte'},
    const {'1': 'addressees', '3': 8, '4': 3, '5': 11, '6': '.sideswap.proto.AddressAmount', '10': 'addressees'},
  ],
};

/// Descriptor for `CreatedTx`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createdTxDescriptor = $convert.base64Decode('CglDcmVhdGVkVHgSKgoDcmVxGAEgAigLMhguc2lkZXN3YXAucHJvdG8uQ3JlYXRlVHhSA3JlcRIfCgtpbnB1dF9jb3VudBgCIAIoBVIKaW5wdXRDb3VudBIhCgxvdXRwdXRfY291bnQYAyACKAVSC291dHB1dENvdW50EhIKBHNpemUYBCACKANSBHNpemUSFAoFdnNpemUYByACKANSBXZzaXplEh8KC25ldHdvcmtfZmVlGAUgAigDUgpuZXR3b3JrRmVlEiAKDGZlZV9wZXJfYnl0ZRgGIAIoAVIKZmVlUGVyQnl0ZRI9CgphZGRyZXNzZWVzGAggAygLMh0uc2lkZXN3YXAucHJvdG8uQWRkcmVzc0Ftb3VudFIKYWRkcmVzc2Vlcw==');
@$core.Deprecated('Use chartPointDescriptor instead')
const ChartPoint$json = const {
  '1': 'ChartPoint',
  '2': const [
    const {'1': 'time', '3': 1, '4': 2, '5': 9, '10': 'time'},
    const {'1': 'open', '3': 2, '4': 2, '5': 1, '10': 'open'},
    const {'1': 'close', '3': 3, '4': 2, '5': 1, '10': 'close'},
    const {'1': 'high', '3': 4, '4': 2, '5': 1, '10': 'high'},
    const {'1': 'low', '3': 5, '4': 2, '5': 1, '10': 'low'},
    const {'1': 'volume', '3': 6, '4': 2, '5': 1, '10': 'volume'},
  ],
};

/// Descriptor for `ChartPoint`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chartPointDescriptor = $convert.base64Decode('CgpDaGFydFBvaW50EhIKBHRpbWUYASACKAlSBHRpbWUSEgoEb3BlbhgCIAIoAVIEb3BlbhIUCgVjbG9zZRgDIAIoAVIFY2xvc2USEgoEaGlnaBgEIAIoAVIEaGlnaBIQCgNsb3cYBSACKAFSA2xvdxIWCgZ2b2x1bWUYBiACKAFSBnZvbHVtZQ==');
@$core.Deprecated('Use toDescriptor instead')
const To$json = const {
  '1': 'To',
  '2': const [
    const {'1': 'login', '3': 1, '4': 1, '5': 11, '6': '.sideswap.proto.To.Login', '9': 0, '10': 'login'},
    const {'1': 'logout', '3': 2, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'logout'},
    const {'1': 'change_network', '3': 9, '4': 1, '5': 11, '6': '.sideswap.proto.To.ChangeNetwork', '9': 0, '10': 'changeNetwork'},
    const {'1': 'update_push_token', '3': 3, '4': 1, '5': 11, '6': '.sideswap.proto.To.UpdatePushToken', '9': 0, '10': 'updatePushToken'},
    const {'1': 'encrypt_pin', '3': 4, '4': 1, '5': 11, '6': '.sideswap.proto.To.EncryptPin', '9': 0, '10': 'encryptPin'},
    const {'1': 'decrypt_pin', '3': 5, '4': 1, '5': 11, '6': '.sideswap.proto.To.DecryptPin', '9': 0, '10': 'decryptPin'},
    const {'1': 'push_message', '3': 6, '4': 1, '5': 9, '9': 0, '10': 'pushMessage'},
    const {'1': 'app_state', '3': 8, '4': 1, '5': 11, '6': '.sideswap.proto.To.AppState', '9': 0, '10': 'appState'},
    const {'1': 'set_memo', '3': 10, '4': 1, '5': 11, '6': '.sideswap.proto.To.SetMemo', '9': 0, '10': 'setMemo'},
    const {'1': 'get_recv_address', '3': 11, '4': 1, '5': 11, '6': '.sideswap.proto.Account', '9': 0, '10': 'getRecvAddress'},
    const {'1': 'create_tx', '3': 12, '4': 1, '5': 11, '6': '.sideswap.proto.CreateTx', '9': 0, '10': 'createTx'},
    const {'1': 'send_tx', '3': 13, '4': 1, '5': 11, '6': '.sideswap.proto.To.SendTx', '9': 0, '10': 'sendTx'},
    const {'1': 'blinded_values', '3': 14, '4': 1, '5': 11, '6': '.sideswap.proto.To.BlindedValues', '9': 0, '10': 'blindedValues'},
    const {'1': 'swap_request', '3': 20, '4': 1, '5': 11, '6': '.sideswap.proto.To.SwapRequest', '9': 0, '10': 'swapRequest'},
    const {'1': 'peg_in_request', '3': 21, '4': 1, '5': 11, '6': '.sideswap.proto.To.PegInRequest', '9': 0, '10': 'pegInRequest'},
    const {'1': 'peg_out_request', '3': 22, '4': 1, '5': 11, '6': '.sideswap.proto.To.PegOutRequest', '9': 0, '10': 'pegOutRequest'},
    const {'1': 'swap_accept', '3': 23, '4': 1, '5': 11, '6': '.sideswap.proto.SwapDetails', '9': 0, '10': 'swapAccept'},
    const {'1': 'register_phone', '3': 40, '4': 1, '5': 11, '6': '.sideswap.proto.To.RegisterPhone', '9': 0, '10': 'registerPhone'},
    const {'1': 'verify_phone', '3': 41, '4': 1, '5': 11, '6': '.sideswap.proto.To.VerifyPhone', '9': 0, '10': 'verifyPhone'},
    const {'1': 'unregister_phone', '3': 44, '4': 1, '5': 11, '6': '.sideswap.proto.To.UnregisterPhone', '9': 0, '10': 'unregisterPhone'},
    const {'1': 'upload_avatar', '3': 42, '4': 1, '5': 11, '6': '.sideswap.proto.To.UploadAvatar', '9': 0, '10': 'uploadAvatar'},
    const {'1': 'upload_contacts', '3': 43, '4': 1, '5': 11, '6': '.sideswap.proto.To.UploadContacts', '9': 0, '10': 'uploadContacts'},
    const {'1': 'submit_order', '3': 49, '4': 1, '5': 11, '6': '.sideswap.proto.To.SubmitOrder', '9': 0, '10': 'submitOrder'},
    const {'1': 'link_order', '3': 50, '4': 1, '5': 11, '6': '.sideswap.proto.To.LinkOrder', '9': 0, '10': 'linkOrder'},
    const {'1': 'submit_decision', '3': 51, '4': 1, '5': 11, '6': '.sideswap.proto.To.SubmitDecision', '9': 0, '10': 'submitDecision'},
    const {'1': 'edit_order', '3': 52, '4': 1, '5': 11, '6': '.sideswap.proto.To.EditOrder', '9': 0, '10': 'editOrder'},
    const {'1': 'cancel_order', '3': 53, '4': 1, '5': 11, '6': '.sideswap.proto.To.CancelOrder', '9': 0, '10': 'cancelOrder'},
    const {'1': 'subscribe', '3': 54, '4': 1, '5': 11, '6': '.sideswap.proto.To.Subscribe', '9': 0, '10': 'subscribe'},
    const {'1': 'asset_details', '3': 57, '4': 1, '5': 11, '6': '.sideswap.proto.AssetId', '9': 0, '10': 'assetDetails'},
    const {'1': 'subscribe_price', '3': 55, '4': 1, '5': 11, '6': '.sideswap.proto.AssetId', '9': 0, '10': 'subscribePrice'},
    const {'1': 'unsubscribe_price', '3': 56, '4': 1, '5': 11, '6': '.sideswap.proto.AssetId', '9': 0, '10': 'unsubscribePrice'},
    const {'1': 'subscribe_price_stream', '3': 58, '4': 1, '5': 11, '6': '.sideswap.proto.To.SubscribePriceStream', '9': 0, '10': 'subscribePriceStream'},
    const {'1': 'unsubscribe_price_stream', '3': 59, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'unsubscribePriceStream'},
    const {'1': 'market_data_subscribe', '3': 60, '4': 1, '5': 11, '6': '.sideswap.proto.To.MarketDataSubscribe', '9': 0, '10': 'marketDataSubscribe'},
    const {'1': 'market_data_unsubscribe', '3': 61, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'marketDataUnsubscribe'},
    const {'1': 'jade_action', '3': 70, '4': 1, '5': 11, '6': '.sideswap.proto.To.JadeAction', '9': 0, '10': 'jadeAction'},
  ],
  '3': const [To_Login$json, To_ChangeNetwork$json, To_EncryptPin$json, To_DecryptPin$json, To_AppState$json, To_SwapRequest$json, To_PegInRequest$json, To_PegOutRequest$json, To_SetMemo$json, To_SendTx$json, To_BlindedValues$json, To_UpdatePushToken$json, To_RegisterPhone$json, To_VerifyPhone$json, To_UnregisterPhone$json, To_UploadAvatar$json, To_UploadContacts$json, To_SubmitOrder$json, To_LinkOrder$json, To_SubmitDecision$json, To_EditOrder$json, To_CancelOrder$json, To_Subscribe$json, To_SubscribePriceStream$json, To_MarketDataSubscribe$json, To_JadeAction$json],
  '8': const [
    const {'1': 'msg'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_Login$json = const {
  '1': 'Login',
  '2': const [
    const {'1': 'mnemonic', '3': 1, '4': 2, '5': 9, '10': 'mnemonic'},
    const {'1': 'phone_key', '3': 2, '4': 1, '5': 9, '10': 'phoneKey'},
    const {'1': 'network', '3': 4, '4': 2, '5': 11, '6': '.sideswap.proto.NetworkSettings', '10': 'network'},
    const {'1': 'desktop', '3': 5, '4': 2, '5': 8, '10': 'desktop'},
    const {'1': 'send_utxo_updates', '3': 6, '4': 1, '5': 8, '10': 'sendUtxoUpdates'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_ChangeNetwork$json = const {
  '1': 'ChangeNetwork',
  '2': const [
    const {'1': 'network', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.NetworkSettings', '10': 'network'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_EncryptPin$json = const {
  '1': 'EncryptPin',
  '2': const [
    const {'1': 'pin', '3': 1, '4': 2, '5': 9, '10': 'pin'},
    const {'1': 'mnemonic', '3': 2, '4': 2, '5': 9, '10': 'mnemonic'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_DecryptPin$json = const {
  '1': 'DecryptPin',
  '2': const [
    const {'1': 'pin', '3': 1, '4': 2, '5': 9, '10': 'pin'},
    const {'1': 'salt', '3': 2, '4': 2, '5': 9, '10': 'salt'},
    const {'1': 'encrypted_data', '3': 3, '4': 2, '5': 9, '10': 'encryptedData'},
    const {'1': 'pin_identifier', '3': 4, '4': 2, '5': 9, '10': 'pinIdentifier'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_AppState$json = const {
  '1': 'AppState',
  '2': const [
    const {'1': 'active', '3': 1, '4': 2, '5': 8, '10': 'active'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_SwapRequest$json = const {
  '1': 'SwapRequest',
  '2': const [
    const {'1': 'send_bitcoins', '3': 1, '4': 2, '5': 8, '10': 'sendBitcoins'},
    const {'1': 'asset', '3': 2, '4': 2, '5': 9, '10': 'asset'},
    const {'1': 'send_amount', '3': 3, '4': 2, '5': 3, '10': 'sendAmount'},
    const {'1': 'recv_amount', '3': 4, '4': 2, '5': 3, '10': 'recvAmount'},
    const {'1': 'price', '3': 5, '4': 2, '5': 1, '10': 'price'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_PegInRequest$json = const {
  '1': 'PegInRequest',
};

@$core.Deprecated('Use toDescriptor instead')
const To_PegOutRequest$json = const {
  '1': 'PegOutRequest',
  '2': const [
    const {'1': 'send_amount', '3': 1, '4': 2, '5': 3, '10': 'sendAmount'},
    const {'1': 'recv_addr', '3': 2, '4': 2, '5': 9, '10': 'recvAddr'},
    const {'1': 'blocks', '3': 3, '4': 2, '5': 5, '10': 'blocks'},
    const {'1': 'account', '3': 4, '4': 2, '5': 11, '6': '.sideswap.proto.Account', '10': 'account'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_SetMemo$json = const {
  '1': 'SetMemo',
  '2': const [
    const {'1': 'txid', '3': 1, '4': 2, '5': 9, '10': 'txid'},
    const {'1': 'memo', '3': 2, '4': 2, '5': 9, '10': 'memo'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_SendTx$json = const {
  '1': 'SendTx',
  '2': const [
    const {'1': 'account', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.Account', '10': 'account'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_BlindedValues$json = const {
  '1': 'BlindedValues',
  '2': const [
    const {'1': 'txid', '3': 1, '4': 2, '5': 9, '10': 'txid'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_UpdatePushToken$json = const {
  '1': 'UpdatePushToken',
  '2': const [
    const {'1': 'token', '3': 1, '4': 2, '5': 9, '10': 'token'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_RegisterPhone$json = const {
  '1': 'RegisterPhone',
  '2': const [
    const {'1': 'number', '3': 1, '4': 2, '5': 9, '10': 'number'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_VerifyPhone$json = const {
  '1': 'VerifyPhone',
  '2': const [
    const {'1': 'phone_key', '3': 1, '4': 2, '5': 9, '10': 'phoneKey'},
    const {'1': 'code', '3': 2, '4': 2, '5': 9, '10': 'code'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_UnregisterPhone$json = const {
  '1': 'UnregisterPhone',
  '2': const [
    const {'1': 'phone_key', '3': 1, '4': 2, '5': 9, '10': 'phoneKey'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_UploadAvatar$json = const {
  '1': 'UploadAvatar',
  '2': const [
    const {'1': 'phone_key', '3': 1, '4': 2, '5': 9, '10': 'phoneKey'},
    const {'1': 'image', '3': 2, '4': 2, '5': 9, '10': 'image'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_UploadContacts$json = const {
  '1': 'UploadContacts',
  '2': const [
    const {'1': 'phone_key', '3': 1, '4': 2, '5': 9, '10': 'phoneKey'},
    const {'1': 'contacts', '3': 2, '4': 3, '5': 11, '6': '.sideswap.proto.UploadContact', '10': 'contacts'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_SubmitOrder$json = const {
  '1': 'SubmitOrder',
  '2': const [
    const {'1': 'account', '3': 7, '4': 2, '5': 11, '6': '.sideswap.proto.Account', '10': 'account'},
    const {'1': 'asset_id', '3': 2, '4': 2, '5': 9, '10': 'assetId'},
    const {'1': 'bitcoin_amount', '3': 3, '4': 1, '5': 1, '10': 'bitcoinAmount'},
    const {'1': 'asset_amount', '3': 4, '4': 1, '5': 1, '10': 'assetAmount'},
    const {'1': 'price', '3': 5, '4': 2, '5': 1, '10': 'price'},
    const {'1': 'index_price', '3': 6, '4': 1, '5': 1, '10': 'indexPrice'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_LinkOrder$json = const {
  '1': 'LinkOrder',
  '2': const [
    const {'1': 'order_id', '3': 1, '4': 2, '5': 9, '10': 'orderId'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_SubmitDecision$json = const {
  '1': 'SubmitDecision',
  '2': const [
    const {'1': 'order_id', '3': 1, '4': 2, '5': 9, '10': 'orderId'},
    const {'1': 'accept', '3': 2, '4': 2, '5': 8, '10': 'accept'},
    const {'1': 'auto_sign', '3': 3, '4': 1, '5': 8, '10': 'autoSign'},
    const {'1': 'private', '3': 4, '4': 1, '5': 8, '10': 'private'},
    const {'1': 'two_step', '3': 6, '4': 1, '5': 8, '10': 'twoStep'},
    const {'1': 'ttl_seconds', '3': 5, '4': 1, '5': 4, '10': 'ttlSeconds'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_EditOrder$json = const {
  '1': 'EditOrder',
  '2': const [
    const {'1': 'order_id', '3': 1, '4': 2, '5': 9, '10': 'orderId'},
    const {'1': 'price', '3': 2, '4': 1, '5': 1, '9': 0, '10': 'price'},
    const {'1': 'index_price', '3': 3, '4': 1, '5': 1, '9': 0, '10': 'indexPrice'},
    const {'1': 'auto_sign', '3': 4, '4': 1, '5': 8, '9': 0, '10': 'autoSign'},
  ],
  '8': const [
    const {'1': 'data'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_CancelOrder$json = const {
  '1': 'CancelOrder',
  '2': const [
    const {'1': 'order_id', '3': 1, '4': 2, '5': 9, '10': 'orderId'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_Subscribe$json = const {
  '1': 'Subscribe',
  '2': const [
    const {'1': 'markets', '3': 1, '4': 3, '5': 11, '6': '.sideswap.proto.To.Subscribe.Market', '10': 'markets'},
  ],
  '3': const [To_Subscribe_Market$json],
};

@$core.Deprecated('Use toDescriptor instead')
const To_Subscribe_Market$json = const {
  '1': 'Market',
  '2': const [
    const {'1': 'asset_id', '3': 1, '4': 1, '5': 9, '10': 'assetId'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_SubscribePriceStream$json = const {
  '1': 'SubscribePriceStream',
  '2': const [
    const {'1': 'asset_id', '3': 1, '4': 2, '5': 9, '10': 'assetId'},
    const {'1': 'send_bitcoins', '3': 2, '4': 2, '5': 8, '10': 'sendBitcoins'},
    const {'1': 'send_amount', '3': 3, '4': 1, '5': 3, '10': 'sendAmount'},
    const {'1': 'recv_amount', '3': 4, '4': 1, '5': 3, '10': 'recvAmount'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_MarketDataSubscribe$json = const {
  '1': 'MarketDataSubscribe',
  '2': const [
    const {'1': 'asset_id', '3': 1, '4': 2, '5': 9, '10': 'assetId'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_JadeAction$json = const {
  '1': 'JadeAction',
  '2': const [
    const {'1': 'account', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.Account', '10': 'account'},
    const {'1': 'action', '3': 2, '4': 2, '5': 14, '6': '.sideswap.proto.To.JadeAction.Action', '10': 'action'},
  ],
  '4': const [To_JadeAction_Action$json],
};

@$core.Deprecated('Use toDescriptor instead')
const To_JadeAction_Action$json = const {
  '1': 'Action',
  '2': const [
    const {'1': 'UNLOCK', '2': 1},
    const {'1': 'LOGIN', '2': 2},
  ],
};

/// Descriptor for `To`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List toDescriptor = $convert.base64Decode('CgJUbxIwCgVsb2dpbhgBIAEoCzIYLnNpZGVzd2FwLnByb3RvLlRvLkxvZ2luSABSBWxvZ2luEi8KBmxvZ291dBgCIAEoCzIVLnNpZGVzd2FwLnByb3RvLkVtcHR5SABSBmxvZ291dBJJCg5jaGFuZ2VfbmV0d29yaxgJIAEoCzIgLnNpZGVzd2FwLnByb3RvLlRvLkNoYW5nZU5ldHdvcmtIAFINY2hhbmdlTmV0d29yaxJQChF1cGRhdGVfcHVzaF90b2tlbhgDIAEoCzIiLnNpZGVzd2FwLnByb3RvLlRvLlVwZGF0ZVB1c2hUb2tlbkgAUg91cGRhdGVQdXNoVG9rZW4SQAoLZW5jcnlwdF9waW4YBCABKAsyHS5zaWRlc3dhcC5wcm90by5Uby5FbmNyeXB0UGluSABSCmVuY3J5cHRQaW4SQAoLZGVjcnlwdF9waW4YBSABKAsyHS5zaWRlc3dhcC5wcm90by5Uby5EZWNyeXB0UGluSABSCmRlY3J5cHRQaW4SIwoMcHVzaF9tZXNzYWdlGAYgASgJSABSC3B1c2hNZXNzYWdlEjoKCWFwcF9zdGF0ZRgIIAEoCzIbLnNpZGVzd2FwLnByb3RvLlRvLkFwcFN0YXRlSABSCGFwcFN0YXRlEjcKCHNldF9tZW1vGAogASgLMhouc2lkZXN3YXAucHJvdG8uVG8uU2V0TWVtb0gAUgdzZXRNZW1vEkMKEGdldF9yZWN2X2FkZHJlc3MYCyABKAsyFy5zaWRlc3dhcC5wcm90by5BY2NvdW50SABSDmdldFJlY3ZBZGRyZXNzEjcKCWNyZWF0ZV90eBgMIAEoCzIYLnNpZGVzd2FwLnByb3RvLkNyZWF0ZVR4SABSCGNyZWF0ZVR4EjQKB3NlbmRfdHgYDSABKAsyGS5zaWRlc3dhcC5wcm90by5Uby5TZW5kVHhIAFIGc2VuZFR4EkkKDmJsaW5kZWRfdmFsdWVzGA4gASgLMiAuc2lkZXN3YXAucHJvdG8uVG8uQmxpbmRlZFZhbHVlc0gAUg1ibGluZGVkVmFsdWVzEkMKDHN3YXBfcmVxdWVzdBgUIAEoCzIeLnNpZGVzd2FwLnByb3RvLlRvLlN3YXBSZXF1ZXN0SABSC3N3YXBSZXF1ZXN0EkcKDnBlZ19pbl9yZXF1ZXN0GBUgASgLMh8uc2lkZXN3YXAucHJvdG8uVG8uUGVnSW5SZXF1ZXN0SABSDHBlZ0luUmVxdWVzdBJKCg9wZWdfb3V0X3JlcXVlc3QYFiABKAsyIC5zaWRlc3dhcC5wcm90by5Uby5QZWdPdXRSZXF1ZXN0SABSDXBlZ091dFJlcXVlc3QSPgoLc3dhcF9hY2NlcHQYFyABKAsyGy5zaWRlc3dhcC5wcm90by5Td2FwRGV0YWlsc0gAUgpzd2FwQWNjZXB0EkkKDnJlZ2lzdGVyX3Bob25lGCggASgLMiAuc2lkZXN3YXAucHJvdG8uVG8uUmVnaXN0ZXJQaG9uZUgAUg1yZWdpc3RlclBob25lEkMKDHZlcmlmeV9waG9uZRgpIAEoCzIeLnNpZGVzd2FwLnByb3RvLlRvLlZlcmlmeVBob25lSABSC3ZlcmlmeVBob25lEk8KEHVucmVnaXN0ZXJfcGhvbmUYLCABKAsyIi5zaWRlc3dhcC5wcm90by5Uby5VbnJlZ2lzdGVyUGhvbmVIAFIPdW5yZWdpc3RlclBob25lEkYKDXVwbG9hZF9hdmF0YXIYKiABKAsyHy5zaWRlc3dhcC5wcm90by5Uby5VcGxvYWRBdmF0YXJIAFIMdXBsb2FkQXZhdGFyEkwKD3VwbG9hZF9jb250YWN0cxgrIAEoCzIhLnNpZGVzd2FwLnByb3RvLlRvLlVwbG9hZENvbnRhY3RzSABSDnVwbG9hZENvbnRhY3RzEkMKDHN1Ym1pdF9vcmRlchgxIAEoCzIeLnNpZGVzd2FwLnByb3RvLlRvLlN1Ym1pdE9yZGVySABSC3N1Ym1pdE9yZGVyEj0KCmxpbmtfb3JkZXIYMiABKAsyHC5zaWRlc3dhcC5wcm90by5Uby5MaW5rT3JkZXJIAFIJbGlua09yZGVyEkwKD3N1Ym1pdF9kZWNpc2lvbhgzIAEoCzIhLnNpZGVzd2FwLnByb3RvLlRvLlN1Ym1pdERlY2lzaW9uSABSDnN1Ym1pdERlY2lzaW9uEj0KCmVkaXRfb3JkZXIYNCABKAsyHC5zaWRlc3dhcC5wcm90by5Uby5FZGl0T3JkZXJIAFIJZWRpdE9yZGVyEkMKDGNhbmNlbF9vcmRlchg1IAEoCzIeLnNpZGVzd2FwLnByb3RvLlRvLkNhbmNlbE9yZGVySABSC2NhbmNlbE9yZGVyEjwKCXN1YnNjcmliZRg2IAEoCzIcLnNpZGVzd2FwLnByb3RvLlRvLlN1YnNjcmliZUgAUglzdWJzY3JpYmUSPgoNYXNzZXRfZGV0YWlscxg5IAEoCzIXLnNpZGVzd2FwLnByb3RvLkFzc2V0SWRIAFIMYXNzZXREZXRhaWxzEkIKD3N1YnNjcmliZV9wcmljZRg3IAEoCzIXLnNpZGVzd2FwLnByb3RvLkFzc2V0SWRIAFIOc3Vic2NyaWJlUHJpY2USRgoRdW5zdWJzY3JpYmVfcHJpY2UYOCABKAsyFy5zaWRlc3dhcC5wcm90by5Bc3NldElkSABSEHVuc3Vic2NyaWJlUHJpY2USXwoWc3Vic2NyaWJlX3ByaWNlX3N0cmVhbRg6IAEoCzInLnNpZGVzd2FwLnByb3RvLlRvLlN1YnNjcmliZVByaWNlU3RyZWFtSABSFHN1YnNjcmliZVByaWNlU3RyZWFtElEKGHVuc3Vic2NyaWJlX3ByaWNlX3N0cmVhbRg7IAEoCzIVLnNpZGVzd2FwLnByb3RvLkVtcHR5SABSFnVuc3Vic2NyaWJlUHJpY2VTdHJlYW0SXAoVbWFya2V0X2RhdGFfc3Vic2NyaWJlGDwgASgLMiYuc2lkZXN3YXAucHJvdG8uVG8uTWFya2V0RGF0YVN1YnNjcmliZUgAUhNtYXJrZXREYXRhU3Vic2NyaWJlEk8KF21hcmtldF9kYXRhX3Vuc3Vic2NyaWJlGD0gASgLMhUuc2lkZXN3YXAucHJvdG8uRW1wdHlIAFIVbWFya2V0RGF0YVVuc3Vic2NyaWJlEkAKC2phZGVfYWN0aW9uGEYgASgLMh0uc2lkZXN3YXAucHJvdG8uVG8uSmFkZUFjdGlvbkgAUgpqYWRlQWN0aW9uGsEBCgVMb2dpbhIaCghtbmVtb25pYxgBIAIoCVIIbW5lbW9uaWMSGwoJcGhvbmVfa2V5GAIgASgJUghwaG9uZUtleRI5CgduZXR3b3JrGAQgAigLMh8uc2lkZXN3YXAucHJvdG8uTmV0d29ya1NldHRpbmdzUgduZXR3b3JrEhgKB2Rlc2t0b3AYBSACKAhSB2Rlc2t0b3ASKgoRc2VuZF91dHhvX3VwZGF0ZXMYBiABKAhSD3NlbmRVdHhvVXBkYXRlcxpKCg1DaGFuZ2VOZXR3b3JrEjkKB25ldHdvcmsYASACKAsyHy5zaWRlc3dhcC5wcm90by5OZXR3b3JrU2V0dGluZ3NSB25ldHdvcmsaOgoKRW5jcnlwdFBpbhIQCgNwaW4YASACKAlSA3BpbhIaCghtbmVtb25pYxgCIAIoCVIIbW5lbW9uaWMagAEKCkRlY3J5cHRQaW4SEAoDcGluGAEgAigJUgNwaW4SEgoEc2FsdBgCIAIoCVIEc2FsdBIlCg5lbmNyeXB0ZWRfZGF0YRgDIAIoCVINZW5jcnlwdGVkRGF0YRIlCg5waW5faWRlbnRpZmllchgEIAIoCVINcGluSWRlbnRpZmllchoiCghBcHBTdGF0ZRIWCgZhY3RpdmUYASACKAhSBmFjdGl2ZRqgAQoLU3dhcFJlcXVlc3QSIwoNc2VuZF9iaXRjb2lucxgBIAIoCFIMc2VuZEJpdGNvaW5zEhQKBWFzc2V0GAIgAigJUgVhc3NldBIfCgtzZW5kX2Ftb3VudBgDIAIoA1IKc2VuZEFtb3VudBIfCgtyZWN2X2Ftb3VudBgEIAIoA1IKcmVjdkFtb3VudBIUCgVwcmljZRgFIAIoAVIFcHJpY2UaDgoMUGVnSW5SZXF1ZXN0GpgBCg1QZWdPdXRSZXF1ZXN0Eh8KC3NlbmRfYW1vdW50GAEgAigDUgpzZW5kQW1vdW50EhsKCXJlY3ZfYWRkchgCIAIoCVIIcmVjdkFkZHISFgoGYmxvY2tzGAMgAigFUgZibG9ja3MSMQoHYWNjb3VudBgEIAIoCzIXLnNpZGVzd2FwLnByb3RvLkFjY291bnRSB2FjY291bnQaMQoHU2V0TWVtbxISCgR0eGlkGAEgAigJUgR0eGlkEhIKBG1lbW8YAiACKAlSBG1lbW8aOwoGU2VuZFR4EjEKB2FjY291bnQYASACKAsyFy5zaWRlc3dhcC5wcm90by5BY2NvdW50UgdhY2NvdW50GiMKDUJsaW5kZWRWYWx1ZXMSEgoEdHhpZBgBIAIoCVIEdHhpZBonCg9VcGRhdGVQdXNoVG9rZW4SFAoFdG9rZW4YASACKAlSBXRva2VuGicKDVJlZ2lzdGVyUGhvbmUSFgoGbnVtYmVyGAEgAigJUgZudW1iZXIaPgoLVmVyaWZ5UGhvbmUSGwoJcGhvbmVfa2V5GAEgAigJUghwaG9uZUtleRISCgRjb2RlGAIgAigJUgRjb2RlGi4KD1VucmVnaXN0ZXJQaG9uZRIbCglwaG9uZV9rZXkYASACKAlSCHBob25lS2V5GkEKDFVwbG9hZEF2YXRhchIbCglwaG9uZV9rZXkYASACKAlSCHBob25lS2V5EhQKBWltYWdlGAIgAigJUgVpbWFnZRpoCg5VcGxvYWRDb250YWN0cxIbCglwaG9uZV9rZXkYASACKAlSCHBob25lS2V5EjkKCGNvbnRhY3RzGAIgAygLMh0uc2lkZXN3YXAucHJvdG8uVXBsb2FkQ29udGFjdFIIY29udGFjdHMa3AEKC1N1Ym1pdE9yZGVyEjEKB2FjY291bnQYByACKAsyFy5zaWRlc3dhcC5wcm90by5BY2NvdW50UgdhY2NvdW50EhkKCGFzc2V0X2lkGAIgAigJUgdhc3NldElkEiUKDmJpdGNvaW5fYW1vdW50GAMgASgBUg1iaXRjb2luQW1vdW50EiEKDGFzc2V0X2Ftb3VudBgEIAEoAVILYXNzZXRBbW91bnQSFAoFcHJpY2UYBSACKAFSBXByaWNlEh8KC2luZGV4X3ByaWNlGAYgASgBUgppbmRleFByaWNlGiYKCUxpbmtPcmRlchIZCghvcmRlcl9pZBgBIAIoCVIHb3JkZXJJZBq2AQoOU3VibWl0RGVjaXNpb24SGQoIb3JkZXJfaWQYASACKAlSB29yZGVySWQSFgoGYWNjZXB0GAIgAigIUgZhY2NlcHQSGwoJYXV0b19zaWduGAMgASgIUghhdXRvU2lnbhIYCgdwcml2YXRlGAQgASgIUgdwcml2YXRlEhkKCHR3b19zdGVwGAYgASgIUgd0d29TdGVwEh8KC3R0bF9zZWNvbmRzGAUgASgEUgp0dGxTZWNvbmRzGogBCglFZGl0T3JkZXISGQoIb3JkZXJfaWQYASACKAlSB29yZGVySWQSFgoFcHJpY2UYAiABKAFIAFIFcHJpY2USIQoLaW5kZXhfcHJpY2UYAyABKAFIAFIKaW5kZXhQcmljZRIdCglhdXRvX3NpZ24YBCABKAhIAFIIYXV0b1NpZ25CBgoEZGF0YRooCgtDYW5jZWxPcmRlchIZCghvcmRlcl9pZBgBIAIoCVIHb3JkZXJJZBpvCglTdWJzY3JpYmUSPQoHbWFya2V0cxgBIAMoCzIjLnNpZGVzd2FwLnByb3RvLlRvLlN1YnNjcmliZS5NYXJrZXRSB21hcmtldHMaIwoGTWFya2V0EhkKCGFzc2V0X2lkGAEgASgJUgdhc3NldElkGpgBChRTdWJzY3JpYmVQcmljZVN0cmVhbRIZCghhc3NldF9pZBgBIAIoCVIHYXNzZXRJZBIjCg1zZW5kX2JpdGNvaW5zGAIgAigIUgxzZW5kQml0Y29pbnMSHwoLc2VuZF9hbW91bnQYAyABKANSCnNlbmRBbW91bnQSHwoLcmVjdl9hbW91bnQYBCABKANSCnJlY3ZBbW91bnQaMAoTTWFya2V0RGF0YVN1YnNjcmliZRIZCghhc3NldF9pZBgBIAIoCVIHYXNzZXRJZBqeAQoKSmFkZUFjdGlvbhIxCgdhY2NvdW50GAEgAigLMhcuc2lkZXN3YXAucHJvdG8uQWNjb3VudFIHYWNjb3VudBI8CgZhY3Rpb24YAiACKA4yJC5zaWRlc3dhcC5wcm90by5Uby5KYWRlQWN0aW9uLkFjdGlvblIGYWN0aW9uIh8KBkFjdGlvbhIKCgZVTkxPQ0sQARIJCgVMT0dJThACQgUKA21zZw==');
@$core.Deprecated('Use fromDescriptor instead')
const From$json = const {
  '1': 'From',
  '2': const [
    const {'1': 'env_settings', '3': 13, '4': 1, '5': 11, '6': '.sideswap.proto.From.EnvSettings', '9': 0, '10': 'envSettings'},
    const {'1': 'register_amp', '3': 8, '4': 1, '5': 11, '6': '.sideswap.proto.From.RegisterAmp', '9': 0, '10': 'registerAmp'},
    const {'1': 'updated_txs', '3': 1, '4': 1, '5': 11, '6': '.sideswap.proto.From.UpdatedTxs', '9': 0, '10': 'updatedTxs'},
    const {'1': 'removed_txs', '3': 12, '4': 1, '5': 11, '6': '.sideswap.proto.From.RemovedTxs', '9': 0, '10': 'removedTxs'},
    const {'1': 'updated_pegs', '3': 2, '4': 1, '5': 11, '6': '.sideswap.proto.From.UpdatedPegs', '9': 0, '10': 'updatedPegs'},
    const {'1': 'new_asset', '3': 3, '4': 1, '5': 11, '6': '.sideswap.proto.Asset', '9': 0, '10': 'newAsset'},
    const {'1': 'amp_assets', '3': 9, '4': 1, '5': 11, '6': '.sideswap.proto.From.AmpAssets', '9': 0, '10': 'ampAssets'},
    const {'1': 'balance_update', '3': 4, '4': 1, '5': 11, '6': '.sideswap.proto.From.BalanceUpdate', '9': 0, '10': 'balanceUpdate'},
    const {'1': 'utxo_update', '3': 15, '4': 1, '5': 11, '6': '.sideswap.proto.From.UtxoUpdate', '9': 0, '10': 'utxoUpdate'},
    const {'1': 'server_status', '3': 5, '4': 1, '5': 11, '6': '.sideswap.proto.ServerStatus', '9': 0, '10': 'serverStatus'},
    const {'1': 'price_update', '3': 6, '4': 1, '5': 11, '6': '.sideswap.proto.From.PriceUpdate', '9': 0, '10': 'priceUpdate'},
    const {'1': 'wallet_loaded', '3': 7, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'walletLoaded'},
    const {'1': 'sync_complete', '3': 14, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'syncComplete'},
    const {'1': 'encrypt_pin', '3': 10, '4': 1, '5': 11, '6': '.sideswap.proto.From.EncryptPin', '9': 0, '10': 'encryptPin'},
    const {'1': 'decrypt_pin', '3': 11, '4': 1, '5': 11, '6': '.sideswap.proto.From.DecryptPin', '9': 0, '10': 'decryptPin'},
    const {'1': 'pegin_wait_tx', '3': 21, '4': 1, '5': 11, '6': '.sideswap.proto.From.PeginWaitTx', '9': 0, '10': 'peginWaitTx'},
    const {'1': 'swap_succeed', '3': 22, '4': 1, '5': 11, '6': '.sideswap.proto.TransItem', '9': 0, '10': 'swapSucceed'},
    const {'1': 'swap_failed', '3': 23, '4': 1, '5': 9, '9': 0, '10': 'swapFailed'},
    const {'1': 'recv_address', '3': 30, '4': 1, '5': 11, '6': '.sideswap.proto.From.RecvAddress', '9': 0, '10': 'recvAddress'},
    const {'1': 'create_tx_result', '3': 31, '4': 1, '5': 11, '6': '.sideswap.proto.From.CreateTxResult', '9': 0, '10': 'createTxResult'},
    const {'1': 'send_result', '3': 32, '4': 1, '5': 11, '6': '.sideswap.proto.From.SendResult', '9': 0, '10': 'sendResult'},
    const {'1': 'blinded_values', '3': 33, '4': 1, '5': 11, '6': '.sideswap.proto.From.BlindedValues', '9': 0, '10': 'blindedValues'},
    const {'1': 'register_phone', '3': 40, '4': 1, '5': 11, '6': '.sideswap.proto.From.RegisterPhone', '9': 0, '10': 'registerPhone'},
    const {'1': 'verify_phone', '3': 41, '4': 1, '5': 11, '6': '.sideswap.proto.From.VerifyPhone', '9': 0, '10': 'verifyPhone'},
    const {'1': 'upload_avatar', '3': 42, '4': 1, '5': 11, '6': '.sideswap.proto.GenericResponse', '9': 0, '10': 'uploadAvatar'},
    const {'1': 'upload_contacts', '3': 43, '4': 1, '5': 11, '6': '.sideswap.proto.GenericResponse', '9': 0, '10': 'uploadContacts'},
    const {'1': 'contact_created', '3': 44, '4': 1, '5': 11, '6': '.sideswap.proto.Contact', '9': 0, '10': 'contactCreated'},
    const {'1': 'contact_removed', '3': 45, '4': 1, '5': 11, '6': '.sideswap.proto.From.ContactRemoved', '9': 0, '10': 'contactRemoved'},
    const {'1': 'contact_transaction', '3': 46, '4': 1, '5': 11, '6': '.sideswap.proto.ContactTransaction', '9': 0, '10': 'contactTransaction'},
    const {'1': 'account_status', '3': 47, '4': 1, '5': 11, '6': '.sideswap.proto.From.AccountStatus', '9': 0, '10': 'accountStatus'},
    const {'1': 'show_message', '3': 50, '4': 1, '5': 11, '6': '.sideswap.proto.From.ShowMessage', '9': 0, '10': 'showMessage'},
    const {'1': 'insufficient_funds', '3': 55, '4': 1, '5': 11, '6': '.sideswap.proto.From.ShowInsufficientFunds', '9': 0, '10': 'insufficientFunds'},
    const {'1': 'submit_review', '3': 51, '4': 1, '5': 11, '6': '.sideswap.proto.From.SubmitReview', '9': 0, '10': 'submitReview'},
    const {'1': 'submit_result', '3': 52, '4': 1, '5': 11, '6': '.sideswap.proto.From.SubmitResult', '9': 0, '10': 'submitResult'},
    const {'1': 'edit_order', '3': 53, '4': 1, '5': 11, '6': '.sideswap.proto.GenericResponse', '9': 0, '10': 'editOrder'},
    const {'1': 'cancel_order', '3': 54, '4': 1, '5': 11, '6': '.sideswap.proto.GenericResponse', '9': 0, '10': 'cancelOrder'},
    const {'1': 'server_connected', '3': 60, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'serverConnected'},
    const {'1': 'server_disconnected', '3': 61, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'serverDisconnected'},
    const {'1': 'order_created', '3': 62, '4': 1, '5': 11, '6': '.sideswap.proto.From.OrderCreated', '9': 0, '10': 'orderCreated'},
    const {'1': 'order_removed', '3': 63, '4': 1, '5': 11, '6': '.sideswap.proto.From.OrderRemoved', '9': 0, '10': 'orderRemoved'},
    const {'1': 'order_complete', '3': 67, '4': 1, '5': 11, '6': '.sideswap.proto.From.OrderComplete', '9': 0, '10': 'orderComplete'},
    const {'1': 'index_price', '3': 64, '4': 1, '5': 11, '6': '.sideswap.proto.From.IndexPrice', '9': 0, '10': 'indexPrice'},
    const {'1': 'asset_details', '3': 65, '4': 1, '5': 11, '6': '.sideswap.proto.From.AssetDetails', '9': 0, '10': 'assetDetails'},
    const {'1': 'update_price_stream', '3': 66, '4': 1, '5': 11, '6': '.sideswap.proto.From.UpdatePriceStream', '9': 0, '10': 'updatePriceStream'},
    const {'1': 'local_message', '3': 68, '4': 1, '5': 11, '6': '.sideswap.proto.From.LocalMessage', '9': 0, '10': 'localMessage'},
    const {'1': 'market_data_subscribe', '3': 70, '4': 1, '5': 11, '6': '.sideswap.proto.From.MarketDataSubscribe', '9': 0, '10': 'marketDataSubscribe'},
    const {'1': 'market_data_update', '3': 71, '4': 1, '5': 11, '6': '.sideswap.proto.From.MarketDataUpdate', '9': 0, '10': 'marketDataUpdate'},
    const {'1': 'jade_updated', '3': 80, '4': 1, '5': 11, '6': '.sideswap.proto.From.JadeUpdated', '9': 0, '10': 'jadeUpdated'},
    const {'1': 'jade_removed', '3': 81, '4': 1, '5': 11, '6': '.sideswap.proto.From.JadeRemoved', '9': 0, '10': 'jadeRemoved'},
  ],
  '3': const [From_EnvSettings$json, From_EncryptPin$json, From_DecryptPin$json, From_RegisterAmp$json, From_AmpAssets$json, From_UpdatedTxs$json, From_RemovedTxs$json, From_UpdatedPegs$json, From_BalanceUpdate$json, From_UtxoUpdate$json, From_PeginWaitTx$json, From_RecvAddress$json, From_CreateTxResult$json, From_SendResult$json, From_BlindedValues$json, From_PriceUpdate$json, From_RegisterPhone$json, From_VerifyPhone$json, From_ShowMessage$json, From_ShowInsufficientFunds$json, From_SubmitReview$json, From_SubmitResult$json, From_OrderCreated$json, From_OrderRemoved$json, From_OrderComplete$json, From_IndexPrice$json, From_ContactRemoved$json, From_AccountStatus$json, From_AssetDetails$json, From_UpdatePriceStream$json, From_LocalMessage$json, From_MarketDataSubscribe$json, From_MarketDataUpdate$json, From_JadeUpdated$json, From_JadeRemoved$json],
  '8': const [
    const {'1': 'msg'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_EnvSettings$json = const {
  '1': 'EnvSettings',
  '2': const [
    const {'1': 'policy_asset_id', '3': 1, '4': 2, '5': 9, '10': 'policyAssetId'},
    const {'1': 'usdt_asset_id', '3': 2, '4': 2, '5': 9, '10': 'usdtAssetId'},
    const {'1': 'eurx_asset_id', '3': 3, '4': 2, '5': 9, '10': 'eurxAssetId'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_EncryptPin$json = const {
  '1': 'EncryptPin',
  '2': const [
    const {'1': 'error', '3': 1, '4': 1, '5': 9, '9': 0, '10': 'error'},
    const {'1': 'data', '3': 2, '4': 1, '5': 11, '6': '.sideswap.proto.From.EncryptPin.Data', '9': 0, '10': 'data'},
  ],
  '3': const [From_EncryptPin_Data$json],
  '8': const [
    const {'1': 'result'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_EncryptPin_Data$json = const {
  '1': 'Data',
  '2': const [
    const {'1': 'salt', '3': 2, '4': 2, '5': 9, '10': 'salt'},
    const {'1': 'encrypted_data', '3': 3, '4': 2, '5': 9, '10': 'encryptedData'},
    const {'1': 'pin_identifier', '3': 4, '4': 2, '5': 9, '10': 'pinIdentifier'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_DecryptPin$json = const {
  '1': 'DecryptPin',
  '2': const [
    const {'1': 'error', '3': 1, '4': 1, '5': 9, '9': 0, '10': 'error'},
    const {'1': 'mnemonic', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'mnemonic'},
  ],
  '8': const [
    const {'1': 'result'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_RegisterAmp$json = const {
  '1': 'RegisterAmp',
  '2': const [
    const {'1': 'amp_id', '3': 1, '4': 1, '5': 9, '9': 0, '10': 'ampId'},
    const {'1': 'error_msg', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'errorMsg'},
  ],
  '8': const [
    const {'1': 'result'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_AmpAssets$json = const {
  '1': 'AmpAssets',
  '2': const [
    const {'1': 'assets', '3': 1, '4': 3, '5': 9, '10': 'assets'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_UpdatedTxs$json = const {
  '1': 'UpdatedTxs',
  '2': const [
    const {'1': 'items', '3': 1, '4': 3, '5': 11, '6': '.sideswap.proto.TransItem', '10': 'items'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_RemovedTxs$json = const {
  '1': 'RemovedTxs',
  '2': const [
    const {'1': 'txids', '3': 1, '4': 3, '5': 9, '10': 'txids'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_UpdatedPegs$json = const {
  '1': 'UpdatedPegs',
  '2': const [
    const {'1': 'order_id', '3': 1, '4': 2, '5': 9, '10': 'orderId'},
    const {'1': 'items', '3': 2, '4': 3, '5': 11, '6': '.sideswap.proto.TransItem', '10': 'items'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_BalanceUpdate$json = const {
  '1': 'BalanceUpdate',
  '2': const [
    const {'1': 'account', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.Account', '10': 'account'},
    const {'1': 'balances', '3': 2, '4': 3, '5': 11, '6': '.sideswap.proto.Balance', '10': 'balances'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_UtxoUpdate$json = const {
  '1': 'UtxoUpdate',
  '2': const [
    const {'1': 'account', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.Account', '10': 'account'},
    const {'1': 'utxos', '3': 2, '4': 3, '5': 11, '6': '.sideswap.proto.From.UtxoUpdate.Utxo', '10': 'utxos'},
  ],
  '3': const [From_UtxoUpdate_Utxo$json],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_UtxoUpdate_Utxo$json = const {
  '1': 'Utxo',
  '2': const [
    const {'1': 'txid', '3': 1, '4': 2, '5': 9, '10': 'txid'},
    const {'1': 'vout', '3': 2, '4': 2, '5': 13, '10': 'vout'},
    const {'1': 'asset_id', '3': 3, '4': 2, '5': 9, '10': 'assetId'},
    const {'1': 'amount', '3': 4, '4': 2, '5': 4, '10': 'amount'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_PeginWaitTx$json = const {
  '1': 'PeginWaitTx',
  '2': const [
    const {'1': 'peg_addr', '3': 5, '4': 2, '5': 9, '10': 'pegAddr'},
    const {'1': 'recv_addr', '3': 6, '4': 2, '5': 9, '10': 'recvAddr'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_RecvAddress$json = const {
  '1': 'RecvAddress',
  '2': const [
    const {'1': 'addr', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.Address', '10': 'addr'},
    const {'1': 'account', '3': 2, '4': 2, '5': 11, '6': '.sideswap.proto.Account', '10': 'account'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_CreateTxResult$json = const {
  '1': 'CreateTxResult',
  '2': const [
    const {'1': 'error_msg', '3': 1, '4': 1, '5': 9, '9': 0, '10': 'errorMsg'},
    const {'1': 'created_tx', '3': 2, '4': 1, '5': 11, '6': '.sideswap.proto.CreatedTx', '9': 0, '10': 'createdTx'},
  ],
  '8': const [
    const {'1': 'result'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_SendResult$json = const {
  '1': 'SendResult',
  '2': const [
    const {'1': 'error_msg', '3': 1, '4': 1, '5': 9, '9': 0, '10': 'errorMsg'},
    const {'1': 'tx_item', '3': 2, '4': 1, '5': 11, '6': '.sideswap.proto.TransItem', '9': 0, '10': 'txItem'},
  ],
  '8': const [
    const {'1': 'result'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_BlindedValues$json = const {
  '1': 'BlindedValues',
  '2': const [
    const {'1': 'txid', '3': 1, '4': 2, '5': 9, '10': 'txid'},
    const {'1': 'error_msg', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'errorMsg'},
    const {'1': 'blinded_values', '3': 3, '4': 1, '5': 9, '9': 0, '10': 'blindedValues'},
  ],
  '8': const [
    const {'1': 'result'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_PriceUpdate$json = const {
  '1': 'PriceUpdate',
  '2': const [
    const {'1': 'asset', '3': 1, '4': 2, '5': 9, '10': 'asset'},
    const {'1': 'bid', '3': 2, '4': 2, '5': 1, '10': 'bid'},
    const {'1': 'ask', '3': 3, '4': 2, '5': 1, '10': 'ask'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_RegisterPhone$json = const {
  '1': 'RegisterPhone',
  '2': const [
    const {'1': 'phone_key', '3': 1, '4': 1, '5': 9, '9': 0, '10': 'phoneKey'},
    const {'1': 'error_msg', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'errorMsg'},
  ],
  '8': const [
    const {'1': 'result'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_VerifyPhone$json = const {
  '1': 'VerifyPhone',
  '2': const [
    const {'1': 'success', '3': 1, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'success'},
    const {'1': 'error_msg', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'errorMsg'},
  ],
  '8': const [
    const {'1': 'result'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_ShowMessage$json = const {
  '1': 'ShowMessage',
  '2': const [
    const {'1': 'text', '3': 1, '4': 2, '5': 9, '10': 'text'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_ShowInsufficientFunds$json = const {
  '1': 'ShowInsufficientFunds',
  '2': const [
    const {'1': 'asset_id', '3': 1, '4': 2, '5': 9, '10': 'assetId'},
    const {'1': 'available', '3': 2, '4': 2, '5': 3, '10': 'available'},
    const {'1': 'required', '3': 3, '4': 2, '5': 3, '10': 'required'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_SubmitReview$json = const {
  '1': 'SubmitReview',
  '2': const [
    const {'1': 'order_id', '3': 1, '4': 2, '5': 9, '10': 'orderId'},
    const {'1': 'asset', '3': 2, '4': 2, '5': 9, '10': 'asset'},
    const {'1': 'bitcoin_amount', '3': 3, '4': 2, '5': 3, '10': 'bitcoinAmount'},
    const {'1': 'server_fee', '3': 8, '4': 2, '5': 3, '10': 'serverFee'},
    const {'1': 'asset_amount', '3': 4, '4': 2, '5': 3, '10': 'assetAmount'},
    const {'1': 'price', '3': 5, '4': 2, '5': 1, '10': 'price'},
    const {'1': 'sell_bitcoin', '3': 6, '4': 2, '5': 8, '10': 'sellBitcoin'},
    const {'1': 'step', '3': 7, '4': 2, '5': 14, '6': '.sideswap.proto.From.SubmitReview.Step', '10': 'step'},
    const {'1': 'index_price', '3': 9, '4': 2, '5': 8, '10': 'indexPrice'},
    const {'1': 'auto_sign', '3': 11, '4': 2, '5': 8, '10': 'autoSign'},
  ],
  '4': const [From_SubmitReview_Step$json],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_SubmitReview_Step$json = const {
  '1': 'Step',
  '2': const [
    const {'1': 'SUBMIT', '2': 1},
    const {'1': 'QUOTE', '2': 2},
    const {'1': 'SIGN', '2': 3},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_SubmitResult$json = const {
  '1': 'SubmitResult',
  '2': const [
    const {'1': 'submit_succeed', '3': 1, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'submitSucceed'},
    const {'1': 'swap_succeed', '3': 2, '4': 1, '5': 11, '6': '.sideswap.proto.TransItem', '9': 0, '10': 'swapSucceed'},
    const {'1': 'error', '3': 3, '4': 1, '5': 9, '9': 0, '10': 'error'},
    const {'1': 'unregistered_gaid', '3': 4, '4': 1, '5': 11, '6': '.sideswap.proto.From.SubmitResult.UnregisteredGaid', '9': 0, '10': 'unregisteredGaid'},
  ],
  '3': const [From_SubmitResult_UnregisteredGaid$json],
  '8': const [
    const {'1': 'result'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_SubmitResult_UnregisteredGaid$json = const {
  '1': 'UnregisteredGaid',
  '2': const [
    const {'1': 'domain_agent', '3': 1, '4': 2, '5': 9, '10': 'domainAgent'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_OrderCreated$json = const {
  '1': 'OrderCreated',
  '2': const [
    const {'1': 'order', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.Order', '10': 'order'},
    const {'1': 'new', '3': 2, '4': 2, '5': 8, '10': 'new'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_OrderRemoved$json = const {
  '1': 'OrderRemoved',
  '2': const [
    const {'1': 'order_id', '3': 1, '4': 2, '5': 9, '10': 'orderId'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_OrderComplete$json = const {
  '1': 'OrderComplete',
  '2': const [
    const {'1': 'order_id', '3': 1, '4': 2, '5': 9, '10': 'orderId'},
    const {'1': 'txid', '3': 2, '4': 1, '5': 9, '10': 'txid'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_IndexPrice$json = const {
  '1': 'IndexPrice',
  '2': const [
    const {'1': 'asset_id', '3': 1, '4': 2, '5': 9, '10': 'assetId'},
    const {'1': 'ind', '3': 2, '4': 1, '5': 1, '10': 'ind'},
    const {'1': 'last', '3': 3, '4': 1, '5': 1, '10': 'last'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_ContactRemoved$json = const {
  '1': 'ContactRemoved',
  '2': const [
    const {'1': 'contact_key', '3': 1, '4': 2, '5': 9, '10': 'contactKey'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_AccountStatus$json = const {
  '1': 'AccountStatus',
  '2': const [
    const {'1': 'registered', '3': 1, '4': 2, '5': 8, '10': 'registered'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_AssetDetails$json = const {
  '1': 'AssetDetails',
  '2': const [
    const {'1': 'asset_id', '3': 1, '4': 2, '5': 9, '10': 'assetId'},
    const {'1': 'stats', '3': 2, '4': 1, '5': 11, '6': '.sideswap.proto.From.AssetDetails.Stats', '10': 'stats'},
    const {'1': 'chart_url', '3': 3, '4': 1, '5': 9, '10': 'chartUrl'},
    const {'1': 'chart_stats', '3': 4, '4': 1, '5': 11, '6': '.sideswap.proto.From.AssetDetails.ChartStats', '10': 'chartStats'},
  ],
  '3': const [From_AssetDetails_Stats$json, From_AssetDetails_ChartStats$json],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_AssetDetails_Stats$json = const {
  '1': 'Stats',
  '2': const [
    const {'1': 'issued_amount', '3': 1, '4': 2, '5': 3, '10': 'issuedAmount'},
    const {'1': 'burned_amount', '3': 2, '4': 2, '5': 3, '10': 'burnedAmount'},
    const {'1': 'offline_amount', '3': 4, '4': 2, '5': 3, '10': 'offlineAmount'},
    const {'1': 'has_blinded_issuances', '3': 3, '4': 2, '5': 8, '10': 'hasBlindedIssuances'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_AssetDetails_ChartStats$json = const {
  '1': 'ChartStats',
  '2': const [
    const {'1': 'low', '3': 1, '4': 2, '5': 1, '10': 'low'},
    const {'1': 'high', '3': 2, '4': 2, '5': 1, '10': 'high'},
    const {'1': 'last', '3': 3, '4': 2, '5': 1, '10': 'last'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_UpdatePriceStream$json = const {
  '1': 'UpdatePriceStream',
  '2': const [
    const {'1': 'asset_id', '3': 1, '4': 2, '5': 9, '10': 'assetId'},
    const {'1': 'send_bitcoins', '3': 2, '4': 2, '5': 8, '10': 'sendBitcoins'},
    const {'1': 'send_amount', '3': 3, '4': 1, '5': 3, '10': 'sendAmount'},
    const {'1': 'recv_amount', '3': 4, '4': 1, '5': 3, '10': 'recvAmount'},
    const {'1': 'price', '3': 5, '4': 1, '5': 1, '10': 'price'},
    const {'1': 'error_msg', '3': 6, '4': 1, '5': 9, '10': 'errorMsg'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_LocalMessage$json = const {
  '1': 'LocalMessage',
  '2': const [
    const {'1': 'title', '3': 1, '4': 2, '5': 9, '10': 'title'},
    const {'1': 'body', '3': 2, '4': 2, '5': 9, '10': 'body'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_MarketDataSubscribe$json = const {
  '1': 'MarketDataSubscribe',
  '2': const [
    const {'1': 'asset_id', '3': 1, '4': 2, '5': 9, '10': 'assetId'},
    const {'1': 'data', '3': 2, '4': 3, '5': 11, '6': '.sideswap.proto.ChartPoint', '10': 'data'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_MarketDataUpdate$json = const {
  '1': 'MarketDataUpdate',
  '2': const [
    const {'1': 'asset_id', '3': 1, '4': 2, '5': 9, '10': 'assetId'},
    const {'1': 'update', '3': 2, '4': 2, '5': 11, '6': '.sideswap.proto.ChartPoint', '10': 'update'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_JadeUpdated$json = const {
  '1': 'JadeUpdated',
  '2': const [
    const {'1': 'account', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.Account', '10': 'account'},
    const {'1': 'status', '3': 2, '4': 2, '5': 14, '6': '.sideswap.proto.From.JadeUpdated.Status', '10': 'status'},
    const {'1': 'name', '3': 3, '4': 2, '5': 9, '10': 'name'},
  ],
  '4': const [From_JadeUpdated_Status$json],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_JadeUpdated_Status$json = const {
  '1': 'Status',
  '2': const [
    const {'1': 'UNKNOWN', '2': 0},
    const {'1': 'UNINIT', '2': 1},
    const {'1': 'LOCKED', '2': 2},
    const {'1': 'UNLOCKED', '2': 3},
    const {'1': 'CONNECTED', '2': 4},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_JadeRemoved$json = const {
  '1': 'JadeRemoved',
  '2': const [
    const {'1': 'account', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.Account', '10': 'account'},
  ],
};

/// Descriptor for `From`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fromDescriptor = $convert.base64Decode('CgRGcm9tEkUKDGVudl9zZXR0aW5ncxgNIAEoCzIgLnNpZGVzd2FwLnByb3RvLkZyb20uRW52U2V0dGluZ3NIAFILZW52U2V0dGluZ3MSRQoMcmVnaXN0ZXJfYW1wGAggASgLMiAuc2lkZXN3YXAucHJvdG8uRnJvbS5SZWdpc3RlckFtcEgAUgtyZWdpc3RlckFtcBJCCgt1cGRhdGVkX3R4cxgBIAEoCzIfLnNpZGVzd2FwLnByb3RvLkZyb20uVXBkYXRlZFR4c0gAUgp1cGRhdGVkVHhzEkIKC3JlbW92ZWRfdHhzGAwgASgLMh8uc2lkZXN3YXAucHJvdG8uRnJvbS5SZW1vdmVkVHhzSABSCnJlbW92ZWRUeHMSRQoMdXBkYXRlZF9wZWdzGAIgASgLMiAuc2lkZXN3YXAucHJvdG8uRnJvbS5VcGRhdGVkUGVnc0gAUgt1cGRhdGVkUGVncxI0CgluZXdfYXNzZXQYAyABKAsyFS5zaWRlc3dhcC5wcm90by5Bc3NldEgAUghuZXdBc3NldBI/CgphbXBfYXNzZXRzGAkgASgLMh4uc2lkZXN3YXAucHJvdG8uRnJvbS5BbXBBc3NldHNIAFIJYW1wQXNzZXRzEksKDmJhbGFuY2VfdXBkYXRlGAQgASgLMiIuc2lkZXN3YXAucHJvdG8uRnJvbS5CYWxhbmNlVXBkYXRlSABSDWJhbGFuY2VVcGRhdGUSQgoLdXR4b191cGRhdGUYDyABKAsyHy5zaWRlc3dhcC5wcm90by5Gcm9tLlV0eG9VcGRhdGVIAFIKdXR4b1VwZGF0ZRJDCg1zZXJ2ZXJfc3RhdHVzGAUgASgLMhwuc2lkZXN3YXAucHJvdG8uU2VydmVyU3RhdHVzSABSDHNlcnZlclN0YXR1cxJFCgxwcmljZV91cGRhdGUYBiABKAsyIC5zaWRlc3dhcC5wcm90by5Gcm9tLlByaWNlVXBkYXRlSABSC3ByaWNlVXBkYXRlEjwKDXdhbGxldF9sb2FkZWQYByABKAsyFS5zaWRlc3dhcC5wcm90by5FbXB0eUgAUgx3YWxsZXRMb2FkZWQSPAoNc3luY19jb21wbGV0ZRgOIAEoCzIVLnNpZGVzd2FwLnByb3RvLkVtcHR5SABSDHN5bmNDb21wbGV0ZRJCCgtlbmNyeXB0X3BpbhgKIAEoCzIfLnNpZGVzd2FwLnByb3RvLkZyb20uRW5jcnlwdFBpbkgAUgplbmNyeXB0UGluEkIKC2RlY3J5cHRfcGluGAsgASgLMh8uc2lkZXN3YXAucHJvdG8uRnJvbS5EZWNyeXB0UGluSABSCmRlY3J5cHRQaW4SRgoNcGVnaW5fd2FpdF90eBgVIAEoCzIgLnNpZGVzd2FwLnByb3RvLkZyb20uUGVnaW5XYWl0VHhIAFILcGVnaW5XYWl0VHgSPgoMc3dhcF9zdWNjZWVkGBYgASgLMhkuc2lkZXN3YXAucHJvdG8uVHJhbnNJdGVtSABSC3N3YXBTdWNjZWVkEiEKC3N3YXBfZmFpbGVkGBcgASgJSABSCnN3YXBGYWlsZWQSRQoMcmVjdl9hZGRyZXNzGB4gASgLMiAuc2lkZXN3YXAucHJvdG8uRnJvbS5SZWN2QWRkcmVzc0gAUgtyZWN2QWRkcmVzcxJPChBjcmVhdGVfdHhfcmVzdWx0GB8gASgLMiMuc2lkZXN3YXAucHJvdG8uRnJvbS5DcmVhdGVUeFJlc3VsdEgAUg5jcmVhdGVUeFJlc3VsdBJCCgtzZW5kX3Jlc3VsdBggIAEoCzIfLnNpZGVzd2FwLnByb3RvLkZyb20uU2VuZFJlc3VsdEgAUgpzZW5kUmVzdWx0EksKDmJsaW5kZWRfdmFsdWVzGCEgASgLMiIuc2lkZXN3YXAucHJvdG8uRnJvbS5CbGluZGVkVmFsdWVzSABSDWJsaW5kZWRWYWx1ZXMSSwoOcmVnaXN0ZXJfcGhvbmUYKCABKAsyIi5zaWRlc3dhcC5wcm90by5Gcm9tLlJlZ2lzdGVyUGhvbmVIAFINcmVnaXN0ZXJQaG9uZRJFCgx2ZXJpZnlfcGhvbmUYKSABKAsyIC5zaWRlc3dhcC5wcm90by5Gcm9tLlZlcmlmeVBob25lSABSC3ZlcmlmeVBob25lEkYKDXVwbG9hZF9hdmF0YXIYKiABKAsyHy5zaWRlc3dhcC5wcm90by5HZW5lcmljUmVzcG9uc2VIAFIMdXBsb2FkQXZhdGFyEkoKD3VwbG9hZF9jb250YWN0cxgrIAEoCzIfLnNpZGVzd2FwLnByb3RvLkdlbmVyaWNSZXNwb25zZUgAUg51cGxvYWRDb250YWN0cxJCCg9jb250YWN0X2NyZWF0ZWQYLCABKAsyFy5zaWRlc3dhcC5wcm90by5Db250YWN0SABSDmNvbnRhY3RDcmVhdGVkEk4KD2NvbnRhY3RfcmVtb3ZlZBgtIAEoCzIjLnNpZGVzd2FwLnByb3RvLkZyb20uQ29udGFjdFJlbW92ZWRIAFIOY29udGFjdFJlbW92ZWQSVQoTY29udGFjdF90cmFuc2FjdGlvbhguIAEoCzIiLnNpZGVzd2FwLnByb3RvLkNvbnRhY3RUcmFuc2FjdGlvbkgAUhJjb250YWN0VHJhbnNhY3Rpb24SSwoOYWNjb3VudF9zdGF0dXMYLyABKAsyIi5zaWRlc3dhcC5wcm90by5Gcm9tLkFjY291bnRTdGF0dXNIAFINYWNjb3VudFN0YXR1cxJFCgxzaG93X21lc3NhZ2UYMiABKAsyIC5zaWRlc3dhcC5wcm90by5Gcm9tLlNob3dNZXNzYWdlSABSC3Nob3dNZXNzYWdlElsKEmluc3VmZmljaWVudF9mdW5kcxg3IAEoCzIqLnNpZGVzd2FwLnByb3RvLkZyb20uU2hvd0luc3VmZmljaWVudEZ1bmRzSABSEWluc3VmZmljaWVudEZ1bmRzEkgKDXN1Ym1pdF9yZXZpZXcYMyABKAsyIS5zaWRlc3dhcC5wcm90by5Gcm9tLlN1Ym1pdFJldmlld0gAUgxzdWJtaXRSZXZpZXcSSAoNc3VibWl0X3Jlc3VsdBg0IAEoCzIhLnNpZGVzd2FwLnByb3RvLkZyb20uU3VibWl0UmVzdWx0SABSDHN1Ym1pdFJlc3VsdBJACgplZGl0X29yZGVyGDUgASgLMh8uc2lkZXN3YXAucHJvdG8uR2VuZXJpY1Jlc3BvbnNlSABSCWVkaXRPcmRlchJECgxjYW5jZWxfb3JkZXIYNiABKAsyHy5zaWRlc3dhcC5wcm90by5HZW5lcmljUmVzcG9uc2VIAFILY2FuY2VsT3JkZXISQgoQc2VydmVyX2Nvbm5lY3RlZBg8IAEoCzIVLnNpZGVzd2FwLnByb3RvLkVtcHR5SABSD3NlcnZlckNvbm5lY3RlZBJIChNzZXJ2ZXJfZGlzY29ubmVjdGVkGD0gASgLMhUuc2lkZXN3YXAucHJvdG8uRW1wdHlIAFISc2VydmVyRGlzY29ubmVjdGVkEkgKDW9yZGVyX2NyZWF0ZWQYPiABKAsyIS5zaWRlc3dhcC5wcm90by5Gcm9tLk9yZGVyQ3JlYXRlZEgAUgxvcmRlckNyZWF0ZWQSSAoNb3JkZXJfcmVtb3ZlZBg/IAEoCzIhLnNpZGVzd2FwLnByb3RvLkZyb20uT3JkZXJSZW1vdmVkSABSDG9yZGVyUmVtb3ZlZBJLCg5vcmRlcl9jb21wbGV0ZRhDIAEoCzIiLnNpZGVzd2FwLnByb3RvLkZyb20uT3JkZXJDb21wbGV0ZUgAUg1vcmRlckNvbXBsZXRlEkIKC2luZGV4X3ByaWNlGEAgASgLMh8uc2lkZXN3YXAucHJvdG8uRnJvbS5JbmRleFByaWNlSABSCmluZGV4UHJpY2USSAoNYXNzZXRfZGV0YWlscxhBIAEoCzIhLnNpZGVzd2FwLnByb3RvLkZyb20uQXNzZXREZXRhaWxzSABSDGFzc2V0RGV0YWlscxJYChN1cGRhdGVfcHJpY2Vfc3RyZWFtGEIgASgLMiYuc2lkZXN3YXAucHJvdG8uRnJvbS5VcGRhdGVQcmljZVN0cmVhbUgAUhF1cGRhdGVQcmljZVN0cmVhbRJICg1sb2NhbF9tZXNzYWdlGEQgASgLMiEuc2lkZXN3YXAucHJvdG8uRnJvbS5Mb2NhbE1lc3NhZ2VIAFIMbG9jYWxNZXNzYWdlEl4KFW1hcmtldF9kYXRhX3N1YnNjcmliZRhGIAEoCzIoLnNpZGVzd2FwLnByb3RvLkZyb20uTWFya2V0RGF0YVN1YnNjcmliZUgAUhNtYXJrZXREYXRhU3Vic2NyaWJlElUKEm1hcmtldF9kYXRhX3VwZGF0ZRhHIAEoCzIlLnNpZGVzd2FwLnByb3RvLkZyb20uTWFya2V0RGF0YVVwZGF0ZUgAUhBtYXJrZXREYXRhVXBkYXRlEkUKDGphZGVfdXBkYXRlZBhQIAEoCzIgLnNpZGVzd2FwLnByb3RvLkZyb20uSmFkZVVwZGF0ZWRIAFILamFkZVVwZGF0ZWQSRQoMamFkZV9yZW1vdmVkGFEgASgLMiAuc2lkZXN3YXAucHJvdG8uRnJvbS5KYWRlUmVtb3ZlZEgAUgtqYWRlUmVtb3ZlZBp9CgtFbnZTZXR0aW5ncxImCg9wb2xpY3lfYXNzZXRfaWQYASACKAlSDXBvbGljeUFzc2V0SWQSIgoNdXNkdF9hc3NldF9pZBgCIAIoCVILdXNkdEFzc2V0SWQSIgoNZXVyeF9hc3NldF9pZBgDIAIoCVILZXVyeEFzc2V0SWQa1AEKCkVuY3J5cHRQaW4SFgoFZXJyb3IYASABKAlIAFIFZXJyb3ISOgoEZGF0YRgCIAEoCzIkLnNpZGVzd2FwLnByb3RvLkZyb20uRW5jcnlwdFBpbi5EYXRhSABSBGRhdGEaaAoERGF0YRISCgRzYWx0GAIgAigJUgRzYWx0EiUKDmVuY3J5cHRlZF9kYXRhGAMgAigJUg1lbmNyeXB0ZWREYXRhEiUKDnBpbl9pZGVudGlmaWVyGAQgAigJUg1waW5JZGVudGlmaWVyQggKBnJlc3VsdBpMCgpEZWNyeXB0UGluEhYKBWVycm9yGAEgASgJSABSBWVycm9yEhwKCG1uZW1vbmljGAIgASgJSABSCG1uZW1vbmljQggKBnJlc3VsdBpPCgtSZWdpc3RlckFtcBIXCgZhbXBfaWQYASABKAlIAFIFYW1wSWQSHQoJZXJyb3JfbXNnGAIgASgJSABSCGVycm9yTXNnQggKBnJlc3VsdBojCglBbXBBc3NldHMSFgoGYXNzZXRzGAEgAygJUgZhc3NldHMaPQoKVXBkYXRlZFR4cxIvCgVpdGVtcxgBIAMoCzIZLnNpZGVzd2FwLnByb3RvLlRyYW5zSXRlbVIFaXRlbXMaIgoKUmVtb3ZlZFR4cxIUCgV0eGlkcxgBIAMoCVIFdHhpZHMaWQoLVXBkYXRlZFBlZ3MSGQoIb3JkZXJfaWQYASACKAlSB29yZGVySWQSLwoFaXRlbXMYAiADKAsyGS5zaWRlc3dhcC5wcm90by5UcmFuc0l0ZW1SBWl0ZW1zGncKDUJhbGFuY2VVcGRhdGUSMQoHYWNjb3VudBgBIAIoCzIXLnNpZGVzd2FwLnByb3RvLkFjY291bnRSB2FjY291bnQSMwoIYmFsYW5jZXMYAiADKAsyFy5zaWRlc3dhcC5wcm90by5CYWxhbmNlUghiYWxhbmNlcxreAQoKVXR4b1VwZGF0ZRIxCgdhY2NvdW50GAEgAigLMhcuc2lkZXN3YXAucHJvdG8uQWNjb3VudFIHYWNjb3VudBI6CgV1dHhvcxgCIAMoCzIkLnNpZGVzd2FwLnByb3RvLkZyb20uVXR4b1VwZGF0ZS5VdHhvUgV1dHhvcxphCgRVdHhvEhIKBHR4aWQYASACKAlSBHR4aWQSEgoEdm91dBgCIAIoDVIEdm91dBIZCghhc3NldF9pZBgDIAIoCVIHYXNzZXRJZBIWCgZhbW91bnQYBCACKARSBmFtb3VudBpFCgtQZWdpbldhaXRUeBIZCghwZWdfYWRkchgFIAIoCVIHcGVnQWRkchIbCglyZWN2X2FkZHIYBiACKAlSCHJlY3ZBZGRyGm0KC1JlY3ZBZGRyZXNzEisKBGFkZHIYASACKAsyFy5zaWRlc3dhcC5wcm90by5BZGRyZXNzUgRhZGRyEjEKB2FjY291bnQYAiACKAsyFy5zaWRlc3dhcC5wcm90by5BY2NvdW50UgdhY2NvdW50GnUKDkNyZWF0ZVR4UmVzdWx0Eh0KCWVycm9yX21zZxgBIAEoCUgAUghlcnJvck1zZxI6CgpjcmVhdGVkX3R4GAIgASgLMhkuc2lkZXN3YXAucHJvdG8uQ3JlYXRlZFR4SABSCWNyZWF0ZWRUeEIICgZyZXN1bHQaawoKU2VuZFJlc3VsdBIdCgllcnJvcl9tc2cYASABKAlIAFIIZXJyb3JNc2cSNAoHdHhfaXRlbRgCIAEoCzIZLnNpZGVzd2FwLnByb3RvLlRyYW5zSXRlbUgAUgZ0eEl0ZW1CCAoGcmVzdWx0GnUKDUJsaW5kZWRWYWx1ZXMSEgoEdHhpZBgBIAIoCVIEdHhpZBIdCgllcnJvcl9tc2cYAiABKAlIAFIIZXJyb3JNc2cSJwoOYmxpbmRlZF92YWx1ZXMYAyABKAlIAFINYmxpbmRlZFZhbHVlc0IICgZyZXN1bHQaRwoLUHJpY2VVcGRhdGUSFAoFYXNzZXQYASACKAlSBWFzc2V0EhAKA2JpZBgCIAIoAVIDYmlkEhAKA2FzaxgDIAIoAVIDYXNrGlcKDVJlZ2lzdGVyUGhvbmUSHQoJcGhvbmVfa2V5GAEgASgJSABSCHBob25lS2V5Eh0KCWVycm9yX21zZxgCIAEoCUgAUghlcnJvck1zZ0IICgZyZXN1bHQaaQoLVmVyaWZ5UGhvbmUSMQoHc3VjY2VzcxgBIAEoCzIVLnNpZGVzd2FwLnByb3RvLkVtcHR5SABSB3N1Y2Nlc3MSHQoJZXJyb3JfbXNnGAIgASgJSABSCGVycm9yTXNnQggKBnJlc3VsdBohCgtTaG93TWVzc2FnZRISCgR0ZXh0GAEgAigJUgR0ZXh0GmwKFVNob3dJbnN1ZmZpY2llbnRGdW5kcxIZCghhc3NldF9pZBgBIAIoCVIHYXNzZXRJZBIcCglhdmFpbGFibGUYAiACKANSCWF2YWlsYWJsZRIaCghyZXF1aXJlZBgDIAIoA1IIcmVxdWlyZWQahAMKDFN1Ym1pdFJldmlldxIZCghvcmRlcl9pZBgBIAIoCVIHb3JkZXJJZBIUCgVhc3NldBgCIAIoCVIFYXNzZXQSJQoOYml0Y29pbl9hbW91bnQYAyACKANSDWJpdGNvaW5BbW91bnQSHQoKc2VydmVyX2ZlZRgIIAIoA1IJc2VydmVyRmVlEiEKDGFzc2V0X2Ftb3VudBgEIAIoA1ILYXNzZXRBbW91bnQSFAoFcHJpY2UYBSACKAFSBXByaWNlEiEKDHNlbGxfYml0Y29pbhgGIAIoCFILc2VsbEJpdGNvaW4SOgoEc3RlcBgHIAIoDjImLnNpZGVzd2FwLnByb3RvLkZyb20uU3VibWl0UmV2aWV3LlN0ZXBSBHN0ZXASHwoLaW5kZXhfcHJpY2UYCSACKAhSCmluZGV4UHJpY2USGwoJYXV0b19zaWduGAsgAigIUghhdXRvU2lnbiInCgRTdGVwEgoKBlNVQk1JVBABEgkKBVFVT1RFEAISCAoEU0lHThADGsoCCgxTdWJtaXRSZXN1bHQSPgoOc3VibWl0X3N1Y2NlZWQYASABKAsyFS5zaWRlc3dhcC5wcm90by5FbXB0eUgAUg1zdWJtaXRTdWNjZWVkEj4KDHN3YXBfc3VjY2VlZBgCIAEoCzIZLnNpZGVzd2FwLnByb3RvLlRyYW5zSXRlbUgAUgtzd2FwU3VjY2VlZBIWCgVlcnJvchgDIAEoCUgAUgVlcnJvchJhChF1bnJlZ2lzdGVyZWRfZ2FpZBgEIAEoCzIyLnNpZGVzd2FwLnByb3RvLkZyb20uU3VibWl0UmVzdWx0LlVucmVnaXN0ZXJlZEdhaWRIAFIQdW5yZWdpc3RlcmVkR2FpZBo1ChBVbnJlZ2lzdGVyZWRHYWlkEiEKDGRvbWFpbl9hZ2VudBgBIAIoCVILZG9tYWluQWdlbnRCCAoGcmVzdWx0Gk0KDE9yZGVyQ3JlYXRlZBIrCgVvcmRlchgBIAIoCzIVLnNpZGVzd2FwLnByb3RvLk9yZGVyUgVvcmRlchIQCgNuZXcYAiACKAhSA25ldxopCgxPcmRlclJlbW92ZWQSGQoIb3JkZXJfaWQYASACKAlSB29yZGVySWQaPgoNT3JkZXJDb21wbGV0ZRIZCghvcmRlcl9pZBgBIAIoCVIHb3JkZXJJZBISCgR0eGlkGAIgASgJUgR0eGlkGk0KCkluZGV4UHJpY2USGQoIYXNzZXRfaWQYASACKAlSB2Fzc2V0SWQSEAoDaW5kGAIgASgBUgNpbmQSEgoEbGFzdBgDIAEoAVIEbGFzdBoxCg5Db250YWN0UmVtb3ZlZBIfCgtjb250YWN0X2tleRgBIAIoCVIKY29udGFjdEtleRovCg1BY2NvdW50U3RhdHVzEh4KCnJlZ2lzdGVyZWQYASACKAhSCnJlZ2lzdGVyZWQaywMKDEFzc2V0RGV0YWlscxIZCghhc3NldF9pZBgBIAIoCVIHYXNzZXRJZBI9CgVzdGF0cxgCIAEoCzInLnNpZGVzd2FwLnByb3RvLkZyb20uQXNzZXREZXRhaWxzLlN0YXRzUgVzdGF0cxIbCgljaGFydF91cmwYAyABKAlSCGNoYXJ0VXJsEk0KC2NoYXJ0X3N0YXRzGAQgASgLMiwuc2lkZXN3YXAucHJvdG8uRnJvbS5Bc3NldERldGFpbHMuQ2hhcnRTdGF0c1IKY2hhcnRTdGF0cxqsAQoFU3RhdHMSIwoNaXNzdWVkX2Ftb3VudBgBIAIoA1IMaXNzdWVkQW1vdW50EiMKDWJ1cm5lZF9hbW91bnQYAiACKANSDGJ1cm5lZEFtb3VudBIlCg5vZmZsaW5lX2Ftb3VudBgEIAIoA1INb2ZmbGluZUFtb3VudBIyChVoYXNfYmxpbmRlZF9pc3N1YW5jZXMYAyACKAhSE2hhc0JsaW5kZWRJc3N1YW5jZXMaRgoKQ2hhcnRTdGF0cxIQCgNsb3cYASACKAFSA2xvdxISCgRoaWdoGAIgAigBUgRoaWdoEhIKBGxhc3QYAyACKAFSBGxhc3QayAEKEVVwZGF0ZVByaWNlU3RyZWFtEhkKCGFzc2V0X2lkGAEgAigJUgdhc3NldElkEiMKDXNlbmRfYml0Y29pbnMYAiACKAhSDHNlbmRCaXRjb2lucxIfCgtzZW5kX2Ftb3VudBgDIAEoA1IKc2VuZEFtb3VudBIfCgtyZWN2X2Ftb3VudBgEIAEoA1IKcmVjdkFtb3VudBIUCgVwcmljZRgFIAEoAVIFcHJpY2USGwoJZXJyb3JfbXNnGAYgASgJUghlcnJvck1zZxo4CgxMb2NhbE1lc3NhZ2USFAoFdGl0bGUYASACKAlSBXRpdGxlEhIKBGJvZHkYAiACKAlSBGJvZHkaYAoTTWFya2V0RGF0YVN1YnNjcmliZRIZCghhc3NldF9pZBgBIAIoCVIHYXNzZXRJZBIuCgRkYXRhGAIgAygLMhouc2lkZXN3YXAucHJvdG8uQ2hhcnRQb2ludFIEZGF0YRphChBNYXJrZXREYXRhVXBkYXRlEhkKCGFzc2V0X2lkGAEgAigJUgdhc3NldElkEjIKBnVwZGF0ZRgCIAIoCzIaLnNpZGVzd2FwLnByb3RvLkNoYXJ0UG9pbnRSBnVwZGF0ZRrhAQoLSmFkZVVwZGF0ZWQSMQoHYWNjb3VudBgBIAIoCzIXLnNpZGVzd2FwLnByb3RvLkFjY291bnRSB2FjY291bnQSPwoGc3RhdHVzGAIgAigOMicuc2lkZXN3YXAucHJvdG8uRnJvbS5KYWRlVXBkYXRlZC5TdGF0dXNSBnN0YXR1cxISCgRuYW1lGAMgAigJUgRuYW1lIkoKBlN0YXR1cxILCgdVTktOT1dOEAASCgoGVU5JTklUEAESCgoGTE9DS0VEEAISDAoIVU5MT0NLRUQQAxINCglDT05ORUNURUQQBBpACgtKYWRlUmVtb3ZlZBIxCgdhY2NvdW50GAEgAigLMhcuc2lkZXN3YXAucHJvdG8uQWNjb3VudFIHYWNjb3VudEIFCgNtc2c=');
@$core.Deprecated('Use settingsDescriptor instead')
const Settings$json = const {
  '1': 'Settings',
  '2': const [
    const {'1': 'disabled_accounts', '3': 1, '4': 3, '5': 11, '6': '.sideswap.proto.Settings.AccountAsset', '10': 'disabledAccounts'},
  ],
  '3': const [Settings_AccountAsset$json],
};

@$core.Deprecated('Use settingsDescriptor instead')
const Settings_AccountAsset$json = const {
  '1': 'AccountAsset',
  '2': const [
    const {'1': 'account', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.Account', '10': 'account'},
    const {'1': 'asset_id', '3': 2, '4': 2, '5': 9, '10': 'assetId'},
  ],
};

/// Descriptor for `Settings`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List settingsDescriptor = $convert.base64Decode('CghTZXR0aW5ncxJSChFkaXNhYmxlZF9hY2NvdW50cxgBIAMoCzIlLnNpZGVzd2FwLnByb3RvLlNldHRpbmdzLkFjY291bnRBc3NldFIQZGlzYWJsZWRBY2NvdW50cxpcCgxBY2NvdW50QXNzZXQSMQoHYWNjb3VudBgBIAIoCzIXLnNpZGVzd2FwLnByb3RvLkFjY291bnRSB2FjY291bnQSGQoIYXNzZXRfaWQYAiACKAlSB2Fzc2V0SWQ=');
