import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/utils/country_code.dart';
import 'package:sideswap/common/utils/custom_logger.dart';
import 'package:sideswap/models/config_provider.dart';
import 'package:sideswap/models/countries_provider.dart';
import 'package:sideswap/models/utils_provider.dart';
import 'package:sideswap/models/wallet.dart';

// TODO: fix this provider

typedef OnBack = Future<void> Function(BuildContext context);
typedef OnSuccess = OnBack;
typedef OnDone = OnBack;

class ConfirmPhoneData {
  ConfirmPhoneData({
    this.onConfirmPhoneBack,
    this.onConfirmPhoneSuccess,
    this.onConfirmPhoneDone,
    this.onImportContactsBack,
    this.onImportContactsSuccess,
    this.onImportContactsDone,
  }) {
    onConfirmPhoneBack ??= defaultConfirmPhoneBack;
    onConfirmPhoneSuccess ??= defaultConfirmPhoneSuccess;
    onConfirmPhoneDone ??= defaultConfirmPhoneDone;
    onImportContactsBack ??= defaultImportContactsBack;
    onImportContactsSuccess ??= defaultImportContactsSuccess;
    onImportContactsDone ??= defaultImportContactsDone;
  }

  OnBack? onConfirmPhoneBack;
  OnSuccess? onConfirmPhoneSuccess;
  OnDone? onConfirmPhoneDone;

  OnBack? onImportContactsBack;
  OnSuccess? onImportContactsSuccess;
  OnDone? onImportContactsDone;

  Future<void> defaultConfirmPhoneBack(BuildContext context) async {
    // TODO: fix
    // context.read(walletProvider).setAssociatePhoneWelcome();
  }

  Future<void> defaultConfirmPhoneSuccess(BuildContext context) async {
    // TODO: fix
    // context.read(walletProvider).setConfirmPhoneSuccess();
  }

  Future<void> defaultConfirmPhoneDone(BuildContext context) async {
    // TODO: fix
    // context.read(walletProvider).setImportContacts();
  }

  Future<void> defaultImportContactsBack(BuildContext context) async {}
  Future<void> defaultImportContactsSuccess(BuildContext context) async {
    // TODO: fix
    // context.read(walletProvider).setImportContactsSuccess();
  }

  Future<void> defaultImportContactsDone(BuildContext context) async {
    // TODO: fix
    // await context.read(walletProvider).loginAndLoadMainPage();
  }
}

enum PhoneRegisterStep {
  init,
  numberEntered,
  phoneNumberSent,
  phoneNumberError,
  phoneNumberAccepted,
}

enum SmsCodeStep {
  hidden,
  visible,
  partlyEntered,
  fullyEntered,
  sent,
  codeAccepted,
  wrongCode,
}

final phoneProvider = ChangeNotifierProvider<PhoneProvider>((ref) {
  logger.d('Init phone provider');
  return PhoneProvider(ref, ConfirmPhoneData());
});

class PhoneProvider with ChangeNotifier {
  PhoneProvider(
    this.ref,
    this._confirmPhoneData,
  ) {
    _countryCode = ref.read(countriesProvider).getSystemDefaultCountry();
  }

  final Ref ref;

  String _phoneNumber = '';
  CountryCode _countryCode = const CountryCode();
  String _smsCode = '';
  PhoneRegisterStep _phoneRegisterStep = PhoneRegisterStep.init;
  SmsCodeStep _smsCodeStep = SmsCodeStep.hidden;
  DateTime? _phoneRegisterTime;
  bool barier = false;
  String _phoneKey = '';
  ConfirmPhoneData _confirmPhoneData;

  String get countryPhoneNumber {
    if (_phoneNumber.isNotEmpty) {
      return '+${_countryCode.dialCode}$_phoneNumber';
    }

    return '';
  }

  String get phoneNumber => _phoneNumber;
  CountryCode get countryCode => _countryCode;

  PhoneRegisterStep get phoneRegisterStep {
    return _phoneRegisterStep;
  }

  SmsCodeStep get smsCodeStep {
    return _smsCodeStep;
  }

  void setConfirmPhoneData({required ConfirmPhoneData confirmPhoneData}) {
    _confirmPhoneData = confirmPhoneData;
  }

  ConfirmPhoneData getConfirmPhoneData() {
    return _confirmPhoneData;
  }

  void setPhoneNumber(CountryCode countryCode, [String phoneNumber = '']) {
    _countryCode = countryCode;
    _phoneNumber = phoneNumber;

    if (_phoneNumber.isNotEmpty) {
      setNumberEntered();
      return;
    } else {
      setInit();
    }
  }

  void setInit() {
    _phoneRegisterStep = PhoneRegisterStep.init;
    notifyListeners();
  }

  void setNumberEntered() {
    _phoneRegisterStep = PhoneRegisterStep.numberEntered;
    _smsCodeStep = SmsCodeStep.hidden;
    notifyListeners();
  }

  void sendPhoneNumber() {
    ref.read(walletProvider).registerPhone(countryPhoneNumber);
    _phoneRegisterStep = PhoneRegisterStep.phoneNumberSent;
    _phoneRegisterTime = DateTime.now();
    barier = true;
    notifyListeners();
  }

  int getSmsDelay() {
    final now = DateTime.now();
    final maxDelay =
        _phoneRegisterTime?.add(const Duration(seconds: 11)) ?? now;
    if (now.isAfter(maxDelay) || now == maxDelay) {
      return 0;
    }
    return maxDelay.difference(now).inSeconds;
  }

  void setBarier(bool value) {
    barier = value;
    notifyListeners();
  }

  void setSmsCode(String code) {
    _smsCode = code;
    if (_smsCode.length == 4) {
      _smsCodeStep = SmsCodeStep.fullyEntered;
    } else {
      _smsCodeStep = SmsCodeStep.partlyEntered;
    }

    notifyListeners();
  }

  void verifySmsCode() {
    ref.read(walletProvider).verifyPhone(_phoneKey, _smsCode);
    _smsCodeStep = SmsCodeStep.sent;
    notifyListeners();
  }

  Future<void> receivedRegisterState(
      {String phoneKey = '', String errorMsg = ''}) async {
    if (phoneKey.isNotEmpty) {
      _phoneKey = phoneKey;
      await ref.read(configProvider).setPhoneKey(phoneKey);
      await ref.read(configProvider).setPhoneNumber(countryPhoneNumber);
      _phoneRegisterStep = PhoneRegisterStep.phoneNumberAccepted;
      _smsCodeStep = SmsCodeStep.visible;
      notifyListeners();
      return;
    }

    if (errorMsg.isNotEmpty) {
      await ref
          .read(utilsProvider)
          .showErrorDialog('Wrong phone number: $errorMsg'.tr());
      _phoneRegisterStep = PhoneRegisterStep.phoneNumberError;
      _smsCodeStep = SmsCodeStep.hidden;
      notifyListeners();
    }
  }

  void receivedVerifyState({String errorMsg = ''}) {
    if (errorMsg.isNotEmpty) {
      _smsCodeStep = SmsCodeStep.wrongCode;
      notifyListeners();
      return;
    }

    _phoneRegisterStep = PhoneRegisterStep.init;
    _smsCodeStep = SmsCodeStep.hidden;
    barier = false;
    notifyListeners();
    final context = ref.read(walletProvider).navigatorKey.currentContext;
    if (context == null) {
      return;
    }

    _confirmPhoneData.onConfirmPhoneSuccess!(context);
  }

  void clearData() {
    _phoneNumber = '';
    _countryCode = const CountryCode();
    _smsCode = '';
    _phoneRegisterStep = PhoneRegisterStep.init;
    _smsCodeStep = SmsCodeStep.hidden;
    _phoneRegisterTime = null;
    barier = false;
    _phoneKey = '';
    _confirmPhoneData;
  }
}
