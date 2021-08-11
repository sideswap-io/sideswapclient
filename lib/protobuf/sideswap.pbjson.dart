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
@$core.Deprecated('Use addressDescriptor instead')
const Address$json = const {
  '1': 'Address',
  '2': const [
    const {'1': 'addr', '3': 1, '4': 2, '5': 9, '10': 'addr'},
  ],
};

/// Descriptor for `Address`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addressDescriptor = $convert.base64Decode('CgdBZGRyZXNzEhIKBGFkZHIYASACKAlSBGFkZHI=');
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
    const {'1': 'domain', '3': 7, '4': 1, '5': 9, '10': 'domain'},
  ],
};

/// Descriptor for `Asset`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assetDescriptor = $convert.base64Decode('CgVBc3NldBIZCghhc3NldF9pZBgBIAIoCVIHYXNzZXRJZBISCgRuYW1lGAIgAigJUgRuYW1lEhYKBnRpY2tlchgDIAIoCVIGdGlja2VyEhIKBGljb24YBCACKAlSBGljb24SHAoJcHJlY2lzaW9uGAUgAigNUglwcmVjaXNpb24SHwoLc3dhcF9tYXJrZXQYBiACKAhSCnN3YXBNYXJrZXQSFgoGZG9tYWluGAcgASgJUgZkb21haW4=');
@$core.Deprecated('Use txDescriptor instead')
const Tx$json = const {
  '1': 'Tx',
  '2': const [
    const {'1': 'balances', '3': 1, '4': 3, '5': 11, '6': '.sideswap.proto.Balance', '10': 'balances'},
    const {'1': 'txid', '3': 2, '4': 2, '5': 9, '10': 'txid'},
    const {'1': 'network_fee', '3': 3, '4': 2, '5': 3, '10': 'networkFee'},
    const {'1': 'memo', '3': 4, '4': 2, '5': 9, '10': 'memo'},
  ],
};

/// Descriptor for `Tx`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List txDescriptor = $convert.base64Decode('CgJUeBIzCghiYWxhbmNlcxgBIAMoCzIXLnNpZGVzd2FwLnByb3RvLkJhbGFuY2VSCGJhbGFuY2VzEhIKBHR4aWQYAiACKAlSBHR4aWQSHwoLbmV0d29ya19mZWUYAyACKANSCm5ldHdvcmtGZWUSEgoEbWVtbxgEIAIoCVIEbWVtbw==');
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
    const {'1': 'vout_send', '3': 7, '4': 2, '5': 5, '10': 'voutSend'},
    const {'1': 'txid_recv', '3': 8, '4': 1, '5': 9, '10': 'txidRecv'},
  ],
};

/// Descriptor for `Peg`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pegDescriptor = $convert.base64Decode('CgNQZWcSGgoJaXNfcGVnX2luGAEgAigIUgdpc1BlZ0luEh8KC2Ftb3VudF9zZW5kGAIgAigDUgphbW91bnRTZW5kEh8KC2Ftb3VudF9yZWN2GAMgAigDUgphbW91bnRSZWN2EhsKCWFkZHJfc2VuZBgEIAIoCVIIYWRkclNlbmQSGwoJYWRkcl9yZWN2GAUgAigJUghhZGRyUmVjdhIbCgl0eGlkX3NlbmQYBiACKAlSCHR4aWRTZW5kEhsKCXZvdXRfc2VuZBgHIAIoBVIIdm91dFNlbmQSGwoJdHhpZF9yZWN2GAggASgJUgh0eGlkUmVjdg==');
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
    const {'1': 'auto_sign', '3': 11, '4': 2, '5': 8, '10': 'autoSign'},
    const {'1': 'own', '3': 12, '4': 2, '5': 8, '10': 'own'},
    const {'1': 'token_market', '3': 13, '4': 2, '5': 8, '10': 'tokenMarket'},
    const {'1': 'new', '3': 14, '4': 2, '5': 8, '10': 'new'},
    const {'1': 'index_price', '3': 15, '4': 1, '5': 1, '10': 'indexPrice'},
  ],
};

/// Descriptor for `Order`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List orderDescriptor = $convert.base64Decode('CgVPcmRlchIZCghvcmRlcl9pZBgBIAIoCVIHb3JkZXJJZBIZCghhc3NldF9pZBgCIAIoCVIHYXNzZXRJZBIlCg5iaXRjb2luX2Ftb3VudBgDIAIoA1INYml0Y29pbkFtb3VudBIjCg1zZW5kX2JpdGNvaW5zGAogAigIUgxzZW5kQml0Y29pbnMSHQoKc2VydmVyX2ZlZRgEIAIoA1IJc2VydmVyRmVlEiEKDGFzc2V0X2Ftb3VudBgFIAIoA1ILYXNzZXRBbW91bnQSFAoFcHJpY2UYBiACKAFSBXByaWNlEh0KCmNyZWF0ZWRfYXQYByACKANSCWNyZWF0ZWRBdBIdCgpleHBpcmVzX2F0GAggAigDUglleHBpcmVzQXQSGAoHcHJpdmF0ZRgJIAIoCFIHcHJpdmF0ZRIbCglhdXRvX3NpZ24YCyACKAhSCGF1dG9TaWduEhAKA293bhgMIAIoCFIDb3duEiEKDHRva2VuX21hcmtldBgNIAIoCFILdG9rZW5NYXJrZXQSEAoDbmV3GA4gAigIUgNuZXcSHwoLaW5kZXhfcHJpY2UYDyABKAFSCmluZGV4UHJpY2U=');
@$core.Deprecated('Use toDescriptor instead')
const To$json = const {
  '1': 'To',
  '2': const [
    const {'1': 'login', '3': 1, '4': 1, '5': 11, '6': '.sideswap.proto.To.Login', '9': 0, '10': 'login'},
    const {'1': 'logout', '3': 2, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'logout'},
    const {'1': 'update_push_token', '3': 3, '4': 1, '5': 11, '6': '.sideswap.proto.To.UpdatePushToken', '9': 0, '10': 'updatePushToken'},
    const {'1': 'encrypt_pin', '3': 4, '4': 1, '5': 11, '6': '.sideswap.proto.To.EncryptPin', '9': 0, '10': 'encryptPin'},
    const {'1': 'decrypt_pin', '3': 5, '4': 1, '5': 11, '6': '.sideswap.proto.To.DecryptPin', '9': 0, '10': 'decryptPin'},
    const {'1': 'push_message', '3': 6, '4': 1, '5': 9, '9': 0, '10': 'pushMessage'},
    const {'1': 'set_memo', '3': 10, '4': 1, '5': 11, '6': '.sideswap.proto.To.SetMemo', '9': 0, '10': 'setMemo'},
    const {'1': 'get_recv_address', '3': 11, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'getRecvAddress'},
    const {'1': 'create_tx', '3': 12, '4': 1, '5': 11, '6': '.sideswap.proto.To.CreateTx', '9': 0, '10': 'createTx'},
    const {'1': 'send_tx', '3': 13, '4': 1, '5': 11, '6': '.sideswap.proto.To.SendTx', '9': 0, '10': 'sendTx'},
    const {'1': 'blinded_values', '3': 14, '4': 1, '5': 11, '6': '.sideswap.proto.To.BlindedValues', '9': 0, '10': 'blindedValues'},
    const {'1': 'swap_request', '3': 20, '4': 1, '5': 11, '6': '.sideswap.proto.To.SwapRequest', '9': 0, '10': 'swapRequest'},
    const {'1': 'swap_cancel', '3': 21, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'swapCancel'},
    const {'1': 'swap_accept', '3': 22, '4': 1, '5': 11, '6': '.sideswap.proto.To.SwapAccept', '9': 0, '10': 'swapAccept'},
    const {'1': 'peg_request', '3': 23, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'pegRequest'},
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
    const {'1': 'subscribe_price', '3': 55, '4': 1, '5': 11, '6': '.sideswap.proto.To.SubscribePrice', '9': 0, '10': 'subscribePrice'},
    const {'1': 'unsubscribe_price', '3': 56, '4': 1, '5': 11, '6': '.sideswap.proto.To.UnsubscribePrice', '9': 0, '10': 'unsubscribePrice'},
    const {'1': 'asset_details', '3': 57, '4': 1, '5': 11, '6': '.sideswap.proto.To.AssetDetails', '9': 0, '10': 'assetDetails'},
  ],
  '3': const [To_Login$json, To_EncryptPin$json, To_DecryptPin$json, To_SwapRequest$json, To_SwapAccept$json, To_SetMemo$json, To_CreateTx$json, To_SendTx$json, To_BlindedValues$json, To_UpdatePushToken$json, To_RegisterPhone$json, To_VerifyPhone$json, To_UnregisterPhone$json, To_UploadAvatar$json, To_UploadContacts$json, To_SubmitOrder$json, To_LinkOrder$json, To_SubmitDecision$json, To_EditOrder$json, To_CancelOrder$json, To_Subscribe$json, To_SubscribePrice$json, To_UnsubscribePrice$json, To_AssetDetails$json],
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
const To_SwapRequest$json = const {
  '1': 'SwapRequest',
  '2': const [
    const {'1': 'send_asset', '3': 2, '4': 2, '5': 9, '10': 'sendAsset'},
    const {'1': 'recv_asset', '3': 3, '4': 2, '5': 9, '10': 'recvAsset'},
    const {'1': 'send_amount', '3': 4, '4': 2, '5': 3, '10': 'sendAmount'},
    const {'1': 'blocks', '3': 5, '4': 1, '5': 5, '10': 'blocks'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_SwapAccept$json = const {
  '1': 'SwapAccept',
  '2': const [
    const {'1': 'recv_addr', '3': 1, '4': 1, '5': 9, '10': 'recvAddr'},
    const {'1': 'recv_amount', '3': 2, '4': 1, '5': 3, '10': 'recvAmount'},
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
const To_CreateTx$json = const {
  '1': 'CreateTx',
  '2': const [
    const {'1': 'addr', '3': 1, '4': 2, '5': 9, '10': 'addr'},
    const {'1': 'balance', '3': 2, '4': 2, '5': 11, '6': '.sideswap.proto.Balance', '10': 'balance'},
    const {'1': 'is_contact', '3': 3, '4': 2, '5': 8, '10': 'isContact'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_SendTx$json = const {
  '1': 'SendTx',
  '2': const [
    const {'1': 'memo', '3': 1, '4': 2, '5': 9, '10': 'memo'},
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
    const {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
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
    const {'1': 'market', '3': 1, '4': 2, '5': 14, '6': '.sideswap.proto.To.Subscribe.Market', '10': 'market'},
    const {'1': 'asset_id', '3': 2, '4': 1, '5': 9, '10': 'assetId'},
  ],
  '4': const [To_Subscribe_Market$json],
};

@$core.Deprecated('Use toDescriptor instead')
const To_Subscribe_Market$json = const {
  '1': 'Market',
  '2': const [
    const {'1': 'NONE', '2': 0},
    const {'1': 'TOKENS', '2': 1},
    const {'1': 'ASSET', '2': 2},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_SubscribePrice$json = const {
  '1': 'SubscribePrice',
  '2': const [
    const {'1': 'asset_id', '3': 2, '4': 2, '5': 9, '10': 'assetId'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_UnsubscribePrice$json = const {
  '1': 'UnsubscribePrice',
  '2': const [
    const {'1': 'asset_id', '3': 2, '4': 2, '5': 9, '10': 'assetId'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_AssetDetails$json = const {
  '1': 'AssetDetails',
  '2': const [
    const {'1': 'asset_id', '3': 2, '4': 2, '5': 9, '10': 'assetId'},
  ],
};

/// Descriptor for `To`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List toDescriptor = $convert.base64Decode('CgJUbxIwCgVsb2dpbhgBIAEoCzIYLnNpZGVzd2FwLnByb3RvLlRvLkxvZ2luSABSBWxvZ2luEi8KBmxvZ291dBgCIAEoCzIVLnNpZGVzd2FwLnByb3RvLkVtcHR5SABSBmxvZ291dBJQChF1cGRhdGVfcHVzaF90b2tlbhgDIAEoCzIiLnNpZGVzd2FwLnByb3RvLlRvLlVwZGF0ZVB1c2hUb2tlbkgAUg91cGRhdGVQdXNoVG9rZW4SQAoLZW5jcnlwdF9waW4YBCABKAsyHS5zaWRlc3dhcC5wcm90by5Uby5FbmNyeXB0UGluSABSCmVuY3J5cHRQaW4SQAoLZGVjcnlwdF9waW4YBSABKAsyHS5zaWRlc3dhcC5wcm90by5Uby5EZWNyeXB0UGluSABSCmRlY3J5cHRQaW4SIwoMcHVzaF9tZXNzYWdlGAYgASgJSABSC3B1c2hNZXNzYWdlEjcKCHNldF9tZW1vGAogASgLMhouc2lkZXN3YXAucHJvdG8uVG8uU2V0TWVtb0gAUgdzZXRNZW1vEkEKEGdldF9yZWN2X2FkZHJlc3MYCyABKAsyFS5zaWRlc3dhcC5wcm90by5FbXB0eUgAUg5nZXRSZWN2QWRkcmVzcxI6CgljcmVhdGVfdHgYDCABKAsyGy5zaWRlc3dhcC5wcm90by5Uby5DcmVhdGVUeEgAUghjcmVhdGVUeBI0CgdzZW5kX3R4GA0gASgLMhkuc2lkZXN3YXAucHJvdG8uVG8uU2VuZFR4SABSBnNlbmRUeBJJCg5ibGluZGVkX3ZhbHVlcxgOIAEoCzIgLnNpZGVzd2FwLnByb3RvLlRvLkJsaW5kZWRWYWx1ZXNIAFINYmxpbmRlZFZhbHVlcxJDCgxzd2FwX3JlcXVlc3QYFCABKAsyHi5zaWRlc3dhcC5wcm90by5Uby5Td2FwUmVxdWVzdEgAUgtzd2FwUmVxdWVzdBI4Cgtzd2FwX2NhbmNlbBgVIAEoCzIVLnNpZGVzd2FwLnByb3RvLkVtcHR5SABSCnN3YXBDYW5jZWwSQAoLc3dhcF9hY2NlcHQYFiABKAsyHS5zaWRlc3dhcC5wcm90by5Uby5Td2FwQWNjZXB0SABSCnN3YXBBY2NlcHQSOAoLcGVnX3JlcXVlc3QYFyABKAsyFS5zaWRlc3dhcC5wcm90by5FbXB0eUgAUgpwZWdSZXF1ZXN0EkkKDnJlZ2lzdGVyX3Bob25lGCggASgLMiAuc2lkZXN3YXAucHJvdG8uVG8uUmVnaXN0ZXJQaG9uZUgAUg1yZWdpc3RlclBob25lEkMKDHZlcmlmeV9waG9uZRgpIAEoCzIeLnNpZGVzd2FwLnByb3RvLlRvLlZlcmlmeVBob25lSABSC3ZlcmlmeVBob25lEk8KEHVucmVnaXN0ZXJfcGhvbmUYLCABKAsyIi5zaWRlc3dhcC5wcm90by5Uby5VbnJlZ2lzdGVyUGhvbmVIAFIPdW5yZWdpc3RlclBob25lEkYKDXVwbG9hZF9hdmF0YXIYKiABKAsyHy5zaWRlc3dhcC5wcm90by5Uby5VcGxvYWRBdmF0YXJIAFIMdXBsb2FkQXZhdGFyEkwKD3VwbG9hZF9jb250YWN0cxgrIAEoCzIhLnNpZGVzd2FwLnByb3RvLlRvLlVwbG9hZENvbnRhY3RzSABSDnVwbG9hZENvbnRhY3RzEkMKDHN1Ym1pdF9vcmRlchgxIAEoCzIeLnNpZGVzd2FwLnByb3RvLlRvLlN1Ym1pdE9yZGVySABSC3N1Ym1pdE9yZGVyEj0KCmxpbmtfb3JkZXIYMiABKAsyHC5zaWRlc3dhcC5wcm90by5Uby5MaW5rT3JkZXJIAFIJbGlua09yZGVyEkwKD3N1Ym1pdF9kZWNpc2lvbhgzIAEoCzIhLnNpZGVzd2FwLnByb3RvLlRvLlN1Ym1pdERlY2lzaW9uSABSDnN1Ym1pdERlY2lzaW9uEj0KCmVkaXRfb3JkZXIYNCABKAsyHC5zaWRlc3dhcC5wcm90by5Uby5FZGl0T3JkZXJIAFIJZWRpdE9yZGVyEkMKDGNhbmNlbF9vcmRlchg1IAEoCzIeLnNpZGVzd2FwLnByb3RvLlRvLkNhbmNlbE9yZGVySABSC2NhbmNlbE9yZGVyEjwKCXN1YnNjcmliZRg2IAEoCzIcLnNpZGVzd2FwLnByb3RvLlRvLlN1YnNjcmliZUgAUglzdWJzY3JpYmUSTAoPc3Vic2NyaWJlX3ByaWNlGDcgASgLMiEuc2lkZXN3YXAucHJvdG8uVG8uU3Vic2NyaWJlUHJpY2VIAFIOc3Vic2NyaWJlUHJpY2USUgoRdW5zdWJzY3JpYmVfcHJpY2UYOCABKAsyIy5zaWRlc3dhcC5wcm90by5Uby5VbnN1YnNjcmliZVByaWNlSABSEHVuc3Vic2NyaWJlUHJpY2USRgoNYXNzZXRfZGV0YWlscxg5IAEoCzIfLnNpZGVzd2FwLnByb3RvLlRvLkFzc2V0RGV0YWlsc0gAUgxhc3NldERldGFpbHMaQAoFTG9naW4SGgoIbW5lbW9uaWMYASACKAlSCG1uZW1vbmljEhsKCXBob25lX2tleRgCIAEoCVIIcGhvbmVLZXkaOgoKRW5jcnlwdFBpbhIQCgNwaW4YASACKAlSA3BpbhIaCghtbmVtb25pYxgCIAIoCVIIbW5lbW9uaWMagAEKCkRlY3J5cHRQaW4SEAoDcGluGAEgAigJUgNwaW4SEgoEc2FsdBgCIAIoCVIEc2FsdBIlCg5lbmNyeXB0ZWRfZGF0YRgDIAIoCVINZW5jcnlwdGVkRGF0YRIlCg5waW5faWRlbnRpZmllchgEIAIoCVINcGluSWRlbnRpZmllchqEAQoLU3dhcFJlcXVlc3QSHQoKc2VuZF9hc3NldBgCIAIoCVIJc2VuZEFzc2V0Eh0KCnJlY3ZfYXNzZXQYAyACKAlSCXJlY3ZBc3NldBIfCgtzZW5kX2Ftb3VudBgEIAIoA1IKc2VuZEFtb3VudBIWCgZibG9ja3MYBSABKAVSBmJsb2NrcxpKCgpTd2FwQWNjZXB0EhsKCXJlY3ZfYWRkchgBIAEoCVIIcmVjdkFkZHISHwoLcmVjdl9hbW91bnQYAiABKANSCnJlY3ZBbW91bnQaMQoHU2V0TWVtbxISCgR0eGlkGAEgAigJUgR0eGlkEhIKBG1lbW8YAiACKAlSBG1lbW8acAoIQ3JlYXRlVHgSEgoEYWRkchgBIAIoCVIEYWRkchIxCgdiYWxhbmNlGAIgAigLMhcuc2lkZXN3YXAucHJvdG8uQmFsYW5jZVIHYmFsYW5jZRIdCgppc19jb250YWN0GAMgAigIUglpc0NvbnRhY3QaHAoGU2VuZFR4EhIKBG1lbW8YASACKAlSBG1lbW8aIwoNQmxpbmRlZFZhbHVlcxISCgR0eGlkGAEgAigJUgR0eGlkGicKD1VwZGF0ZVB1c2hUb2tlbhIUCgV0b2tlbhgBIAIoCVIFdG9rZW4aJwoNUmVnaXN0ZXJQaG9uZRIWCgZudW1iZXIYASACKAlSBm51bWJlcho+CgtWZXJpZnlQaG9uZRIbCglwaG9uZV9rZXkYASACKAlSCHBob25lS2V5EhIKBGNvZGUYAiACKAlSBGNvZGUaLgoPVW5yZWdpc3RlclBob25lEhsKCXBob25lX2tleRgBIAIoCVIIcGhvbmVLZXkaQQoMVXBsb2FkQXZhdGFyEhsKCXBob25lX2tleRgBIAIoCVIIcGhvbmVLZXkSFAoFaW1hZ2UYAiACKAlSBWltYWdlGmgKDlVwbG9hZENvbnRhY3RzEhsKCXBob25lX2tleRgBIAIoCVIIcGhvbmVLZXkSOQoIY29udGFjdHMYAiADKAsyHS5zaWRlc3dhcC5wcm90by5VcGxvYWRDb250YWN0Ughjb250YWN0cxrIAQoLU3VibWl0T3JkZXISHQoKc2Vzc2lvbl9pZBgBIAEoCVIJc2Vzc2lvbklkEhkKCGFzc2V0X2lkGAIgAigJUgdhc3NldElkEiUKDmJpdGNvaW5fYW1vdW50GAMgASgBUg1iaXRjb2luQW1vdW50EiEKDGFzc2V0X2Ftb3VudBgEIAEoAVILYXNzZXRBbW91bnQSFAoFcHJpY2UYBSACKAFSBXByaWNlEh8KC2luZGV4X3ByaWNlGAYgASgBUgppbmRleFByaWNlGiYKCUxpbmtPcmRlchIZCghvcmRlcl9pZBgBIAIoCVIHb3JkZXJJZBqbAQoOU3VibWl0RGVjaXNpb24SGQoIb3JkZXJfaWQYASACKAlSB29yZGVySWQSFgoGYWNjZXB0GAIgAigIUgZhY2NlcHQSGwoJYXV0b19zaWduGAMgASgIUghhdXRvU2lnbhIYCgdwcml2YXRlGAQgASgIUgdwcml2YXRlEh8KC3R0bF9zZWNvbmRzGAUgASgEUgp0dGxTZWNvbmRzGmkKCUVkaXRPcmRlchIZCghvcmRlcl9pZBgBIAIoCVIHb3JkZXJJZBIWCgVwcmljZRgCIAEoAUgAUgVwcmljZRIhCgtpbmRleF9wcmljZRgDIAEoAUgAUgppbmRleFByaWNlQgYKBGRhdGEaKAoLQ2FuY2VsT3JkZXISGQoIb3JkZXJfaWQYASACKAlSB29yZGVySWQajgEKCVN1YnNjcmliZRI7CgZtYXJrZXQYASACKA4yIy5zaWRlc3dhcC5wcm90by5Uby5TdWJzY3JpYmUuTWFya2V0UgZtYXJrZXQSGQoIYXNzZXRfaWQYAiABKAlSB2Fzc2V0SWQiKQoGTWFya2V0EggKBE5PTkUQABIKCgZUT0tFTlMQARIJCgVBU1NFVBACGisKDlN1YnNjcmliZVByaWNlEhkKCGFzc2V0X2lkGAIgAigJUgdhc3NldElkGi0KEFVuc3Vic2NyaWJlUHJpY2USGQoIYXNzZXRfaWQYAiACKAlSB2Fzc2V0SWQaKQoMQXNzZXREZXRhaWxzEhkKCGFzc2V0X2lkGAIgAigJUgdhc3NldElkQgUKA21zZw==');
@$core.Deprecated('Use fromDescriptor instead')
const From$json = const {
  '1': 'From',
  '2': const [
    const {'1': 'updated_tx', '3': 1, '4': 1, '5': 11, '6': '.sideswap.proto.TransItem', '9': 0, '10': 'updatedTx'},
    const {'1': 'removed_tx', '3': 2, '4': 1, '5': 11, '6': '.sideswap.proto.From.RemovedTx', '9': 0, '10': 'removedTx'},
    const {'1': 'new_asset', '3': 3, '4': 1, '5': 11, '6': '.sideswap.proto.Asset', '9': 0, '10': 'newAsset'},
    const {'1': 'balance_update', '3': 4, '4': 1, '5': 11, '6': '.sideswap.proto.Balance', '9': 0, '10': 'balanceUpdate'},
    const {'1': 'server_status', '3': 5, '4': 1, '5': 11, '6': '.sideswap.proto.ServerStatus', '9': 0, '10': 'serverStatus'},
    const {'1': 'price_update', '3': 6, '4': 1, '5': 11, '6': '.sideswap.proto.From.PriceUpdate', '9': 0, '10': 'priceUpdate'},
    const {'1': 'wallet_loaded', '3': 7, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'walletLoaded'},
    const {'1': 'encrypt_pin', '3': 10, '4': 1, '5': 11, '6': '.sideswap.proto.From.EncryptPin', '9': 0, '10': 'encryptPin'},
    const {'1': 'decrypt_pin', '3': 11, '4': 1, '5': 11, '6': '.sideswap.proto.From.DecryptPin', '9': 0, '10': 'decryptPin'},
    const {'1': 'swap_review', '3': 20, '4': 1, '5': 11, '6': '.sideswap.proto.From.SwapReview', '9': 0, '10': 'swapReview'},
    const {'1': 'swap_wait_tx', '3': 21, '4': 1, '5': 11, '6': '.sideswap.proto.From.SwapWaitTx', '9': 0, '10': 'swapWaitTx'},
    const {'1': 'swap_succeed', '3': 22, '4': 1, '5': 11, '6': '.sideswap.proto.TransItem', '9': 0, '10': 'swapSucceed'},
    const {'1': 'swap_failed', '3': 23, '4': 1, '5': 9, '9': 0, '10': 'swapFailed'},
    const {'1': 'recv_address', '3': 30, '4': 1, '5': 11, '6': '.sideswap.proto.Address', '9': 0, '10': 'recvAddress'},
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
    const {'1': 'submit_review', '3': 51, '4': 1, '5': 11, '6': '.sideswap.proto.From.SubmitReview', '9': 0, '10': 'submitReview'},
    const {'1': 'submit_result', '3': 52, '4': 1, '5': 11, '6': '.sideswap.proto.From.SubmitResult', '9': 0, '10': 'submitResult'},
    const {'1': 'edit_order', '3': 53, '4': 1, '5': 11, '6': '.sideswap.proto.GenericResponse', '9': 0, '10': 'editOrder'},
    const {'1': 'cancel_order', '3': 54, '4': 1, '5': 11, '6': '.sideswap.proto.GenericResponse', '9': 0, '10': 'cancelOrder'},
    const {'1': 'server_connected', '3': 60, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'serverConnected'},
    const {'1': 'server_disconnected', '3': 61, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'serverDisconnected'},
    const {'1': 'order_created', '3': 62, '4': 1, '5': 11, '6': '.sideswap.proto.From.OrderCreated', '9': 0, '10': 'orderCreated'},
    const {'1': 'order_removed', '3': 63, '4': 1, '5': 11, '6': '.sideswap.proto.From.OrderRemoved', '9': 0, '10': 'orderRemoved'},
    const {'1': 'index_price', '3': 64, '4': 1, '5': 11, '6': '.sideswap.proto.From.IndexPrice', '9': 0, '10': 'indexPrice'},
    const {'1': 'asset_details', '3': 65, '4': 1, '5': 11, '6': '.sideswap.proto.From.AssetDetails', '9': 0, '10': 'assetDetails'},
  ],
  '3': const [From_EncryptPin$json, From_DecryptPin$json, From_RemovedTx$json, From_SwapReview$json, From_SwapWaitTx$json, From_CreateTxResult$json, From_SendResult$json, From_BlindedValues$json, From_PriceUpdate$json, From_RegisterPhone$json, From_VerifyPhone$json, From_ShowMessage$json, From_SubmitReview$json, From_SubmitResult$json, From_OrderCreated$json, From_OrderRemoved$json, From_IndexPrice$json, From_ContactRemoved$json, From_AccountStatus$json, From_AssetDetails$json],
  '8': const [
    const {'1': 'msg'},
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
const From_RemovedTx$json = const {
  '1': 'RemovedTx',
  '2': const [
    const {'1': 'id', '3': 1, '4': 2, '5': 9, '10': 'id'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_SwapReview$json = const {
  '1': 'SwapReview',
  '2': const [
    const {'1': 'send_asset', '3': 1, '4': 2, '5': 9, '10': 'sendAsset'},
    const {'1': 'recv_asset', '3': 2, '4': 2, '5': 9, '10': 'recvAsset'},
    const {'1': 'send_amount', '3': 3, '4': 2, '5': 3, '10': 'sendAmount'},
    const {'1': 'recv_amount', '3': 4, '4': 1, '5': 3, '10': 'recvAmount'},
    const {'1': 'network_fee', '3': 5, '4': 1, '5': 3, '10': 'networkFee'},
    const {'1': 'error', '3': 7, '4': 1, '5': 9, '10': 'error'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_SwapWaitTx$json = const {
  '1': 'SwapWaitTx',
  '2': const [
    const {'1': 'send_asset', '3': 1, '4': 2, '5': 9, '10': 'sendAsset'},
    const {'1': 'recv_asset', '3': 2, '4': 2, '5': 9, '10': 'recvAsset'},
    const {'1': 'peg_addr', '3': 5, '4': 2, '5': 9, '10': 'pegAddr'},
    const {'1': 'recv_addr', '3': 6, '4': 2, '5': 9, '10': 'recvAddr'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_CreateTxResult$json = const {
  '1': 'CreateTxResult',
  '2': const [
    const {'1': 'error_msg', '3': 1, '4': 1, '5': 9, '9': 0, '10': 'errorMsg'},
    const {'1': 'network_fee', '3': 2, '4': 1, '5': 3, '9': 0, '10': 'networkFee'},
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
    const {'1': 'blinded_values', '3': 2, '4': 1, '5': 9, '10': 'blindedValues'},
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
    const {'1': 'internal', '3': 10, '4': 2, '5': 8, '10': 'internal'},
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
  ],
  '8': const [
    const {'1': 'result'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_OrderCreated$json = const {
  '1': 'OrderCreated',
  '2': const [
    const {'1': 'order', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.Order', '10': 'order'},
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
const From_IndexPrice$json = const {
  '1': 'IndexPrice',
  '2': const [
    const {'1': 'asset_id', '3': 1, '4': 2, '5': 9, '10': 'assetId'},
    const {'1': 'ind', '3': 2, '4': 1, '5': 1, '10': 'ind'},
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
  ],
  '3': const [From_AssetDetails_Stats$json],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_AssetDetails_Stats$json = const {
  '1': 'Stats',
  '2': const [
    const {'1': 'issued_amount', '3': 1, '4': 2, '5': 3, '10': 'issuedAmount'},
    const {'1': 'burned_amount', '3': 2, '4': 2, '5': 3, '10': 'burnedAmount'},
    const {'1': 'has_blinded_issuances', '3': 3, '4': 2, '5': 8, '10': 'hasBlindedIssuances'},
  ],
};

/// Descriptor for `From`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fromDescriptor = $convert.base64Decode('CgRGcm9tEjoKCnVwZGF0ZWRfdHgYASABKAsyGS5zaWRlc3dhcC5wcm90by5UcmFuc0l0ZW1IAFIJdXBkYXRlZFR4Ej8KCnJlbW92ZWRfdHgYAiABKAsyHi5zaWRlc3dhcC5wcm90by5Gcm9tLlJlbW92ZWRUeEgAUglyZW1vdmVkVHgSNAoJbmV3X2Fzc2V0GAMgASgLMhUuc2lkZXN3YXAucHJvdG8uQXNzZXRIAFIIbmV3QXNzZXQSQAoOYmFsYW5jZV91cGRhdGUYBCABKAsyFy5zaWRlc3dhcC5wcm90by5CYWxhbmNlSABSDWJhbGFuY2VVcGRhdGUSQwoNc2VydmVyX3N0YXR1cxgFIAEoCzIcLnNpZGVzd2FwLnByb3RvLlNlcnZlclN0YXR1c0gAUgxzZXJ2ZXJTdGF0dXMSRQoMcHJpY2VfdXBkYXRlGAYgASgLMiAuc2lkZXN3YXAucHJvdG8uRnJvbS5QcmljZVVwZGF0ZUgAUgtwcmljZVVwZGF0ZRI8Cg13YWxsZXRfbG9hZGVkGAcgASgLMhUuc2lkZXN3YXAucHJvdG8uRW1wdHlIAFIMd2FsbGV0TG9hZGVkEkIKC2VuY3J5cHRfcGluGAogASgLMh8uc2lkZXN3YXAucHJvdG8uRnJvbS5FbmNyeXB0UGluSABSCmVuY3J5cHRQaW4SQgoLZGVjcnlwdF9waW4YCyABKAsyHy5zaWRlc3dhcC5wcm90by5Gcm9tLkRlY3J5cHRQaW5IAFIKZGVjcnlwdFBpbhJCCgtzd2FwX3JldmlldxgUIAEoCzIfLnNpZGVzd2FwLnByb3RvLkZyb20uU3dhcFJldmlld0gAUgpzd2FwUmV2aWV3EkMKDHN3YXBfd2FpdF90eBgVIAEoCzIfLnNpZGVzd2FwLnByb3RvLkZyb20uU3dhcFdhaXRUeEgAUgpzd2FwV2FpdFR4Ej4KDHN3YXBfc3VjY2VlZBgWIAEoCzIZLnNpZGVzd2FwLnByb3RvLlRyYW5zSXRlbUgAUgtzd2FwU3VjY2VlZBIhCgtzd2FwX2ZhaWxlZBgXIAEoCUgAUgpzd2FwRmFpbGVkEjwKDHJlY3ZfYWRkcmVzcxgeIAEoCzIXLnNpZGVzd2FwLnByb3RvLkFkZHJlc3NIAFILcmVjdkFkZHJlc3MSTwoQY3JlYXRlX3R4X3Jlc3VsdBgfIAEoCzIjLnNpZGVzd2FwLnByb3RvLkZyb20uQ3JlYXRlVHhSZXN1bHRIAFIOY3JlYXRlVHhSZXN1bHQSQgoLc2VuZF9yZXN1bHQYICABKAsyHy5zaWRlc3dhcC5wcm90by5Gcm9tLlNlbmRSZXN1bHRIAFIKc2VuZFJlc3VsdBJLCg5ibGluZGVkX3ZhbHVlcxghIAEoCzIiLnNpZGVzd2FwLnByb3RvLkZyb20uQmxpbmRlZFZhbHVlc0gAUg1ibGluZGVkVmFsdWVzEksKDnJlZ2lzdGVyX3Bob25lGCggASgLMiIuc2lkZXN3YXAucHJvdG8uRnJvbS5SZWdpc3RlclBob25lSABSDXJlZ2lzdGVyUGhvbmUSRQoMdmVyaWZ5X3Bob25lGCkgASgLMiAuc2lkZXN3YXAucHJvdG8uRnJvbS5WZXJpZnlQaG9uZUgAUgt2ZXJpZnlQaG9uZRJGCg11cGxvYWRfYXZhdGFyGCogASgLMh8uc2lkZXN3YXAucHJvdG8uR2VuZXJpY1Jlc3BvbnNlSABSDHVwbG9hZEF2YXRhchJKCg91cGxvYWRfY29udGFjdHMYKyABKAsyHy5zaWRlc3dhcC5wcm90by5HZW5lcmljUmVzcG9uc2VIAFIOdXBsb2FkQ29udGFjdHMSQgoPY29udGFjdF9jcmVhdGVkGCwgASgLMhcuc2lkZXN3YXAucHJvdG8uQ29udGFjdEgAUg5jb250YWN0Q3JlYXRlZBJOCg9jb250YWN0X3JlbW92ZWQYLSABKAsyIy5zaWRlc3dhcC5wcm90by5Gcm9tLkNvbnRhY3RSZW1vdmVkSABSDmNvbnRhY3RSZW1vdmVkElUKE2NvbnRhY3RfdHJhbnNhY3Rpb24YLiABKAsyIi5zaWRlc3dhcC5wcm90by5Db250YWN0VHJhbnNhY3Rpb25IAFISY29udGFjdFRyYW5zYWN0aW9uEksKDmFjY291bnRfc3RhdHVzGC8gASgLMiIuc2lkZXN3YXAucHJvdG8uRnJvbS5BY2NvdW50U3RhdHVzSABSDWFjY291bnRTdGF0dXMSRQoMc2hvd19tZXNzYWdlGDIgASgLMiAuc2lkZXN3YXAucHJvdG8uRnJvbS5TaG93TWVzc2FnZUgAUgtzaG93TWVzc2FnZRJICg1zdWJtaXRfcmV2aWV3GDMgASgLMiEuc2lkZXN3YXAucHJvdG8uRnJvbS5TdWJtaXRSZXZpZXdIAFIMc3VibWl0UmV2aWV3EkgKDXN1Ym1pdF9yZXN1bHQYNCABKAsyIS5zaWRlc3dhcC5wcm90by5Gcm9tLlN1Ym1pdFJlc3VsdEgAUgxzdWJtaXRSZXN1bHQSQAoKZWRpdF9vcmRlchg1IAEoCzIfLnNpZGVzd2FwLnByb3RvLkdlbmVyaWNSZXNwb25zZUgAUgllZGl0T3JkZXISRAoMY2FuY2VsX29yZGVyGDYgASgLMh8uc2lkZXN3YXAucHJvdG8uR2VuZXJpY1Jlc3BvbnNlSABSC2NhbmNlbE9yZGVyEkIKEHNlcnZlcl9jb25uZWN0ZWQYPCABKAsyFS5zaWRlc3dhcC5wcm90by5FbXB0eUgAUg9zZXJ2ZXJDb25uZWN0ZWQSSAoTc2VydmVyX2Rpc2Nvbm5lY3RlZBg9IAEoCzIVLnNpZGVzd2FwLnByb3RvLkVtcHR5SABSEnNlcnZlckRpc2Nvbm5lY3RlZBJICg1vcmRlcl9jcmVhdGVkGD4gASgLMiEuc2lkZXN3YXAucHJvdG8uRnJvbS5PcmRlckNyZWF0ZWRIAFIMb3JkZXJDcmVhdGVkEkgKDW9yZGVyX3JlbW92ZWQYPyABKAsyIS5zaWRlc3dhcC5wcm90by5Gcm9tLk9yZGVyUmVtb3ZlZEgAUgxvcmRlclJlbW92ZWQSQgoLaW5kZXhfcHJpY2UYQCABKAsyHy5zaWRlc3dhcC5wcm90by5Gcm9tLkluZGV4UHJpY2VIAFIKaW5kZXhQcmljZRJICg1hc3NldF9kZXRhaWxzGEEgASgLMiEuc2lkZXN3YXAucHJvdG8uRnJvbS5Bc3NldERldGFpbHNIAFIMYXNzZXREZXRhaWxzGtQBCgpFbmNyeXB0UGluEhYKBWVycm9yGAEgASgJSABSBWVycm9yEjoKBGRhdGEYAiABKAsyJC5zaWRlc3dhcC5wcm90by5Gcm9tLkVuY3J5cHRQaW4uRGF0YUgAUgRkYXRhGmgKBERhdGESEgoEc2FsdBgCIAIoCVIEc2FsdBIlCg5lbmNyeXB0ZWRfZGF0YRgDIAIoCVINZW5jcnlwdGVkRGF0YRIlCg5waW5faWRlbnRpZmllchgEIAIoCVINcGluSWRlbnRpZmllckIICgZyZXN1bHQaTAoKRGVjcnlwdFBpbhIWCgVlcnJvchgBIAEoCUgAUgVlcnJvchIcCghtbmVtb25pYxgCIAEoCUgAUghtbmVtb25pY0IICgZyZXN1bHQaGwoJUmVtb3ZlZFR4Eg4KAmlkGAEgAigJUgJpZBrDAQoKU3dhcFJldmlldxIdCgpzZW5kX2Fzc2V0GAEgAigJUglzZW5kQXNzZXQSHQoKcmVjdl9hc3NldBgCIAIoCVIJcmVjdkFzc2V0Eh8KC3NlbmRfYW1vdW50GAMgAigDUgpzZW5kQW1vdW50Eh8KC3JlY3ZfYW1vdW50GAQgASgDUgpyZWN2QW1vdW50Eh8KC25ldHdvcmtfZmVlGAUgASgDUgpuZXR3b3JrRmVlEhQKBWVycm9yGAcgASgJUgVlcnJvchqCAQoKU3dhcFdhaXRUeBIdCgpzZW5kX2Fzc2V0GAEgAigJUglzZW5kQXNzZXQSHQoKcmVjdl9hc3NldBgCIAIoCVIJcmVjdkFzc2V0EhkKCHBlZ19hZGRyGAUgAigJUgdwZWdBZGRyEhsKCXJlY3ZfYWRkchgGIAIoCVIIcmVjdkFkZHIaXAoOQ3JlYXRlVHhSZXN1bHQSHQoJZXJyb3JfbXNnGAEgASgJSABSCGVycm9yTXNnEiEKC25ldHdvcmtfZmVlGAIgASgDSABSCm5ldHdvcmtGZWVCCAoGcmVzdWx0GmsKClNlbmRSZXN1bHQSHQoJZXJyb3JfbXNnGAEgASgJSABSCGVycm9yTXNnEjQKB3R4X2l0ZW0YAiABKAsyGS5zaWRlc3dhcC5wcm90by5UcmFuc0l0ZW1IAFIGdHhJdGVtQggKBnJlc3VsdBpKCg1CbGluZGVkVmFsdWVzEhIKBHR4aWQYASACKAlSBHR4aWQSJQoOYmxpbmRlZF92YWx1ZXMYAiABKAlSDWJsaW5kZWRWYWx1ZXMaRwoLUHJpY2VVcGRhdGUSFAoFYXNzZXQYASACKAlSBWFzc2V0EhAKA2JpZBgCIAIoAVIDYmlkEhAKA2FzaxgDIAIoAVIDYXNrGlcKDVJlZ2lzdGVyUGhvbmUSHQoJcGhvbmVfa2V5GAEgASgJSABSCHBob25lS2V5Eh0KCWVycm9yX21zZxgCIAEoCUgAUghlcnJvck1zZ0IICgZyZXN1bHQaaQoLVmVyaWZ5UGhvbmUSMQoHc3VjY2VzcxgBIAEoCzIVLnNpZGVzd2FwLnByb3RvLkVtcHR5SABSB3N1Y2Nlc3MSHQoJZXJyb3JfbXNnGAIgASgJSABSCGVycm9yTXNnQggKBnJlc3VsdBohCgtTaG93TWVzc2FnZRISCgR0ZXh0GAEgAigJUgR0ZXh0GqADCgxTdWJtaXRSZXZpZXcSGQoIb3JkZXJfaWQYASACKAlSB29yZGVySWQSFAoFYXNzZXQYAiACKAlSBWFzc2V0EiUKDmJpdGNvaW5fYW1vdW50GAMgAigDUg1iaXRjb2luQW1vdW50Eh0KCnNlcnZlcl9mZWUYCCACKANSCXNlcnZlckZlZRIhCgxhc3NldF9hbW91bnQYBCACKANSC2Fzc2V0QW1vdW50EhQKBXByaWNlGAUgAigBUgVwcmljZRIhCgxzZWxsX2JpdGNvaW4YBiACKAhSC3NlbGxCaXRjb2luEjoKBHN0ZXAYByACKA4yJi5zaWRlc3dhcC5wcm90by5Gcm9tLlN1Ym1pdFJldmlldy5TdGVwUgRzdGVwEh8KC2luZGV4X3ByaWNlGAkgAigIUgppbmRleFByaWNlEhoKCGludGVybmFsGAogAigIUghpbnRlcm5hbBIbCglhdXRvX3NpZ24YCyACKAhSCGF1dG9TaWduIicKBFN0ZXASCgoGU1VCTUlUEAESCQoFUVVPVEUQAhIICgRTSUdOEAMasAEKDFN1Ym1pdFJlc3VsdBI+Cg5zdWJtaXRfc3VjY2VlZBgBIAEoCzIVLnNpZGVzd2FwLnByb3RvLkVtcHR5SABSDXN1Ym1pdFN1Y2NlZWQSPgoMc3dhcF9zdWNjZWVkGAIgASgLMhkuc2lkZXN3YXAucHJvdG8uVHJhbnNJdGVtSABSC3N3YXBTdWNjZWVkEhYKBWVycm9yGAMgASgJSABSBWVycm9yQggKBnJlc3VsdBo7CgxPcmRlckNyZWF0ZWQSKwoFb3JkZXIYASACKAsyFS5zaWRlc3dhcC5wcm90by5PcmRlclIFb3JkZXIaKQoMT3JkZXJSZW1vdmVkEhkKCG9yZGVyX2lkGAEgAigJUgdvcmRlcklkGjkKCkluZGV4UHJpY2USGQoIYXNzZXRfaWQYASACKAlSB2Fzc2V0SWQSEAoDaW5kGAIgASgBUgNpbmQaMQoOQ29udGFjdFJlbW92ZWQSHwoLY29udGFjdF9rZXkYASACKAlSCmNvbnRhY3RLZXkaLwoNQWNjb3VudFN0YXR1cxIeCgpyZWdpc3RlcmVkGAEgAigIUgpyZWdpc3RlcmVkGvABCgxBc3NldERldGFpbHMSGQoIYXNzZXRfaWQYASACKAlSB2Fzc2V0SWQSPQoFc3RhdHMYAiABKAsyJy5zaWRlc3dhcC5wcm90by5Gcm9tLkFzc2V0RGV0YWlscy5TdGF0c1IFc3RhdHMahQEKBVN0YXRzEiMKDWlzc3VlZF9hbW91bnQYASACKANSDGlzc3VlZEFtb3VudBIjCg1idXJuZWRfYW1vdW50GAIgAigDUgxidXJuZWRBbW91bnQSMgoVaGFzX2JsaW5kZWRfaXNzdWFuY2VzGAMgAigIUhNoYXNCbGluZGVkSXNzdWFuY2VzQgUKA21zZw==');
