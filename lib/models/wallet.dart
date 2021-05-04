import 'dart:async';
import 'dart:convert';
import 'dart:ffi' as ffi;
import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/subjects.dart';

import 'package:sideswap/common/bitmap_helper.dart';
import 'package:sideswap/common/encryption.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/utils/custom_logger.dart';
import 'package:sideswap/common/widgets/insufficient_balance_dialog.dart';
import 'package:sideswap/models/assets_precache.dart';
import 'package:sideswap/models/config_provider.dart';
import 'package:sideswap/models/contact_provider.dart';
import 'package:sideswap/models/notifications_service.dart';
import 'package:sideswap/models/payment_provider.dart';
import 'package:sideswap/models/phone_provider.dart';
import 'package:sideswap/models/pin_protection_provider.dart';
import 'package:sideswap/models/pin_setup_provider.dart';
import 'package:sideswap/models/swap_provider.dart';
import 'package:sideswap/models/tx_item.dart';
import 'package:sideswap/models/ui_state_args_provider.dart';
import 'package:sideswap/models/utils_provider.dart';
import 'package:sideswap/protobuf/sideswap.pb.dart';
import 'package:sideswap/screens/order/widgets/order_details.dart';
import 'package:sideswap/side_swap_client_ffi.dart';

enum Status {
  loading,
  reviewLicenseCreateWallet,
  reviewLicenseImportWallet,
  noWallet,
  selectEnv,
  lockedWalet,

  newWalletBackupPrompt,
  newWalletBackupView,
  newWalletBackupCheck,
  newWalletBackupCheckFailed,
  newWalletBackupCheckSucceed,
  newWalletBiometricPrompt,
  importWallet,
  importWalletBiometricPrompt,
  importWalletError,
  importWalletSuccess,
  importAvatar,
  importAvatarSuccess,
  associatePhoneWelcome,
  confirmPhone,
  confirmPhoneSuccess,
  importContacts,
  importContactsSuccess,
  newWalletPinWelcome,
  pinWelcome,
  pinSetup,
  pinSuccess,

  registered,
  assetsSelect,
  assetDetails,
  txDetails,
  txEditMemo,

  assetReceive,
  assetReceiveFromWalletMain,

  swapWaitPegTx,
  swapTxDetails,

  settingsPage,
  settingsBackup,
  settingsAboutUs,
  settingsSecurity,
  settingsUserDetails,

  paymentPage,
  paymentAmountPage,
  paymentSend,

  orderPopup,
  orderSuccess,
}

enum AddrType {
  bitcoin,
  elements,
}

const envValues = [
  SIDESWAP_ENV_PROD,
  SIDESWAP_ENV_STAGING,
  SIDESWAP_ENV_REGTEST,
  SIDESWAP_ENV_LOCAL
];

String envName(int env) {
  switch (env) {
    case SIDESWAP_ENV_PROD:
      return 'Prod';
    case SIDESWAP_ENV_STAGING:
      return 'Staging';
    case SIDESWAP_ENV_REGTEST:
      return 'Regtest';
    case SIDESWAP_ENV_LOCAL:
      return 'Local';
  }
  throw Exception('unexpected env value');
}

class PinData {
  final String salt;
  final String encryptedData;
  final String pinIdentifier;
  final String error;

  PinData({this.salt, this.encryptedData, this.pinIdentifier, this.error});

  @override
  String toString() {
    return 'PinData(salt: $salt, encryptedData: $encryptedData, pinIdentifier: $pinIdentifier, error: $error)';
  }
}

class PinDecryptedData {
  final String error;
  final bool success;
  final String mnemonic;

  PinDecryptedData(this.success, {this.mnemonic, this.error});

  @override
  String toString() =>
      'PinDecryptedData(error: $error, success: $success, mnemonic: $mnemonic)';
}

class Lib {
  static var dynLib = (Platform.isIOS || Platform.isMacOS)
      ? ffi.DynamicLibrary.process()
      : ffi.DynamicLibrary.open('libsideswap_client.so');
  static var lib = NativeLibrary(Lib.dynLib);
}

typedef dartPostCObject = ffi.Pointer Function(
    ffi.Pointer<
        ffi.NativeFunction<
            ffi.Int8 Function(ffi.Int64, ffi.Pointer<ffi.Dart_CObject>)>>);

const kBackupCheckLineCount = 4;
const kBackupCheckWordCount = 3;

final walletProvider = ChangeNotifierProvider<WalletChangeNotifier>((ref) {
  return WalletChangeNotifier(ref.read);
});

class WalletChangeNotifier with ChangeNotifier {
  final Reader read;
  int _client = 0;

  final _encryption = Encryption();

  String _mnemonic;
  final enabledAssetIds = <String>[];

  GlobalKey<NavigatorState> navigatorKey;

  Status _status = Status.loading;
  Status get status => _status;
  set status(Status value) {
    logger.d('status: $value');
    _status = value;
    notifyListeners();
  }

  ServerStatus _serverStatus;
  ServerStatus get serverStatus => _serverStatus;

  final Map<String, From_PriceUpdate> _prices = {};
  Map<String, From_PriceUpdate> get prices => _prices;

  String selectedWalletAsset;
  String recvAddress;

  Map<int, List<String>> backupCheckAllWords;
  Map<int, int> backupCheckSelectedWords;

  final _assetIds = <String>[];
  var assets = <String, Asset>{};
  var assetImagesBig = <String, Image>{};
  var assetImagesSmall = <String, Image>{};

  final allTxs = <String, TransItem>{};
  final newTransItemSubject = BehaviorSubject<TransItem>();
  StreamSubscription<TransItem> txDetailsSubscription;

  // Cached version of allTxs
  final allAssets = <String, List<TxItem>>{};
  Map<String, List<TxItem>> txItemMap = {};

  var balances = <String, int>{};

  // Toggle assets page
  var filteredToggleAssetIds = <String>[];

  TransItem txDetails;

  final _txMemoUpdates = <String, String>{};
  String _currentTxMemoUpdate;

  bool settingsBiometricAvailable = false;

  OrderDetailsData orderDetailsData;
  PublishSubject<String> explorerUrlSubject = PublishSubject<String>();

  PublishSubject<PinData> pinEncryptDataSubject = PublishSubject<PinData>();
  PublishSubject<PinDecryptedData> pinDecryptDataSubject =
      PublishSubject<PinDecryptedData>();

  void sendMsg(To to) {
    if (kDebugMode) {
      logger.d('send: $to');
    }
    if (_client == 0) {
      throw ErrorDescription('client is not initialized');
    }
    final buf = to.writeToBuffer();
    final pointer = allocate<ffi.Uint8>(count: buf.length);
    for (var i = 0; i < buf.length; i++) {
      pointer[i] = buf[i];
    }
    Lib.lib.sideswap_send_request(_client, pointer.cast(), buf.length);
    free(pointer);
  }

  WalletChangeNotifier(this.read) {
    Future.microtask(() async {
      await read(configProvider).init();

      // TODO: temporary commented
      // final savedTxs = read(configProvider).allTxs;
      // for (var key in savedTxs.keys) {
      //   allTxs[key] = savedTxs[key];
      // }

      await read(assetsPrecacheChangeNotifier).precache();
      Future.delayed(Duration(seconds: 1), () {
        startClient();
      });
    });
  }

  ReceivePort _receivePort;

  Future<void> startClient() async {
    final storeDartPostCObject = Lib.dynLib
        .lookupFunction<dartPostCObject, dartPostCObject>(
            'store_dart_post_cobject');
    assert(storeDartPostCObject != null);
    storeDartPostCObject(ffi.NativeApi.postCObject);

    final env = read(configProvider).env;
    _client = Lib.lib.sideswap_client_create(env);

    await _addBtcAsset();

    _receivePort = ReceivePort();

    final workDir = await getApplicationSupportDirectory();
    final workPath = Utf8.toUtf8(workDir.absolute.path);

    final packageInfo =
        !Platform.isLinux ? await PackageInfo.fromPlatform() : null;
    final version = packageInfo != null
        ? '${packageInfo.version}+${packageInfo.buildNumber}'
        : '';

    Lib.lib.sideswap_client_start(_client, workPath.cast(),
        Utf8.toUtf8(version).cast(), _receivePort.sendPort.nativePort);

    _receivePort.listen((dynamic msgPtr) async {
      final ptr = Lib.lib.sideswap_msg_ptr(msgPtr as int);
      final len = Lib.lib.sideswap_msg_len(msgPtr as int);
      final msg = From.fromBuffer(ptr.asTypedList(len));
      Lib.lib.sideswap_msg_free(msgPtr as int);
      await _recvMsg(msg);
    });

    if (read(configProvider).mnemonicEncrypted.isNotEmpty) {
      if (await _encryption.canAuthenticate() &&
          read(configProvider).useBiometricProtection) {
        status = Status.lockedWalet;
      } else {
        await unlockWallet();
      }
    } else {
      if (read(configProvider).usePinProtection) {
        await unlockWallet();
      } else {
        status = Status.noWallet;
        notifyListeners();
      }
    }

    if (status == Status.lockedWalet) {
      await unlockWallet();
    }

    await notificationService.refreshToken();
    await notificationService.handleDynamicLinks();
  }

  void _addTxItem(TransItem item, String assetId) {
    if (allAssets[assetId] == null) {
      allAssets[assetId] = [];
    }
    allAssets[assetId].add(TxItem(item: item));
  }

  void refreshTxs() {
    allAssets.clear();
    for (var item in allTxs.values) {
      switch (item.whichItem()) {
        case TransItem_Item.tx:
          var tx = item.tx;
          for (var balance in tx.balances) {
            _addTxItem(item, balance.assetId);
          }
          break;
        case TransItem_Item.peg:
          _addTxItem(item, liquidAssetId());
          break;
        case TransItem_Item.notSet:
          throw Exception('invalid message');
      }
    }

    Future.microtask(() async => await buildTxList(allAssets));
  }

  // TODO: temporary commented
  Future<void> addTxItem(TransItem item) async {
    allTxs[item.id] = item;
    newTransItemSubject.add(item);
    refreshTxs();
  }

  Future<void> _recvMsg(From from) async {
    if (kDebugMode) {
      logger.d('recv: $from');
    }
    // Process message here
    switch (from.whichMsg()) {
      case From_Msg.updatedTx:
        await addTxItem(from.updatedTx);
        break;
      case From_Msg.removedTx:
        var id = from.removedTx.id;
        allTxs.remove(id);
        refreshTxs();
        break;
      case From_Msg.newAsset:
        final assetIcon = base64Decode(from.newAsset.icon);
        _addAsset(from.newAsset, assetIcon);
        break;
      case From_Msg.balanceUpdate:
        balances[from.balanceUpdate.assetId] =
            from.balanceUpdate.amount.toInt();
        notifyListeners();
        break;

      case From_Msg.swapReview:
        if (read(swapProvider).swapActive) {
          read(swapProvider).swapSendAsset = from.swapReview.sendAsset;
          read(swapProvider).swapRecvAsset = from.swapReview.recvAsset;
          read(swapProvider).swapSendAmount =
              from.swapReview.sendAmount.toInt();
          read(swapProvider).swapRecvAmount =
              from.swapReview.recvAmount.toInt();
          read(swapProvider).swapNetworkFee =
              from.swapReview.networkFee.toInt();
          read(swapProvider).swapNetworkError = from.swapReview.error;
          notifyListeners();
        }
        break;

      case From_Msg.swapFailed:
        logger.w('Swap failed: ${from.swapFailed}');
        read(swapProvider).swapNetworkError = from.swapFailed;
        read(utilsProvider)
            .showErrorDialog(read(swapProvider).swapNetworkError);
        break;

      case From_Msg.swapSucceed:
        var txItem = from.swapSucceed;
        await addTxItem(txItem);
        showSwapTxDetails(txItem);
        break;

      case From_Msg.swapWaitTx:
        status = Status.swapWaitPegTx;
        read(swapProvider).swapPegAddressServer = from.swapWaitTx.pegAddr;
        read(swapProvider).swapRecvAddressExternal = from.swapWaitTx.recvAddr;
        //read(swapProvider).swapSendAmount = from.swapWaitTx.sendAmount.toInt();
        //read(swapProvider).swapRecvAmount = from.swapWaitTx.recvAmount.toInt();
        read(swapProvider).swapSendAsset = from.swapWaitTx.sendAsset;
        read(swapProvider).swapRecvAsset = from.swapWaitTx.recvAsset;
        notifyListeners();
        break;

      case From_Msg.recvAddress:
        recvAddress = from.recvAddress.addr;
        notifyListeners();
        break;

      case From_Msg.createTxResult:
        switch (from.createTxResult.whichResult()) {
          case From_CreateTxResult_Result.errorMsg:
            final balance = balances[liquidAssetId()];
            if (selectedWalletAsset != liquidAssetId() && balance == 0) {
              showInsufficientBalanceDialog(
                  navigatorKey.currentContext, kLiquidBitcoinTicker);
            } else {
              read(utilsProvider).showErrorDialog(from.createTxResult.errorMsg);
            }
            break;
          case From_CreateTxResult_Result.networkFee:
            read(paymentProvider).sendResultError = '';
            read(paymentProvider).sendNetworkFee =
                from.createTxResult.networkFee.toInt();
            status = Status.paymentSend;
            break;
          case From_CreateTxResult_Result.notSet:
            throw Exception('invalid send result message');
        }
        notifyListeners();
        break;

      case From_Msg.sendResult:
        status = Status.assetDetails;
        switch (from.sendResult.whichResult()) {
          case From_SendResult_Result.errorMsg:
            read(paymentProvider).sendResultError = from.sendResult.errorMsg;
            notifyListeners();
            break;
          case From_SendResult_Result.txItem:
            var item = from.sendResult.txItem;
            await addTxItem(item);
            showTxDetails(item);
            break;
          case From_SendResult_Result.notSet:
            throw Exception('invalid send result message');
        }
        break;

      case From_Msg.blindedValues:
        final url = generateTxidUrl(
            from.blindedValues.txid, true, from.blindedValues.blindedValues);
        explorerUrlSubject.add(url);
        break;

      case From_Msg.serverStatus:
        _serverStatus = from.serverStatus;
        // TODO: Allow pegs only after that
        notifyListeners();
        break;

      case From_Msg.priceUpdate:
        _prices[from.priceUpdate.asset] = from.priceUpdate;
        notifyListeners();
        break;

      case From_Msg.registerPhone:
        switch (from.registerPhone.whichResult()) {
          case From_RegisterPhone_Result.phoneKey:
            var phoneKey = From_RegisterPhone_Result.phoneKey;
            logger.d('got phone key: $phoneKey');
            await read(phoneProvider)
                .receivedRegisterState(phoneKey: from.registerPhone.phoneKey);
            break;
          case From_RegisterPhone_Result.errorMsg:
            var errorMsg = From_RegisterPhone_Result.errorMsg;
            logger.d('registration failed: $errorMsg');
            await read(phoneProvider)
                .receivedRegisterState(errorMsg: from.registerPhone.errorMsg);
            break;
          case From_RegisterPhone_Result.notSet:
            throw Exception('invalid registerPhone message');
        }
        break;

      case From_Msg.verifyPhone:
        switch (from.verifyPhone.whichResult()) {
          case From_VerifyPhone_Result.success:
            logger.d('phone verification succeed');
            read(phoneProvider).receivedVerifyState();
            break;
          case From_VerifyPhone_Result.errorMsg:
            var errorMsg = From_VerifyPhone_Result.errorMsg;
            logger.d('verification failed: $errorMsg');
            read(phoneProvider)
                .receivedVerifyState(errorMsg: from.verifyPhone.errorMsg);
            break;
          case From_VerifyPhone_Result.notSet:
            throw Exception('invalid verifyPhone message');
        }
        break;

      case From_Msg.uploadAvatar:
        if (from.uploadAvatar.success) {
          logger.d('Upload avatar success');
        } else {
          logger.e('Upload avatar error: ${from.uploadAvatar.errorMsg}');
        }
        break;
      case From_Msg.uploadContacts:
        if (from.uploadContacts.success) {
          read(contactProvider).onDone();
        } else {
          read(contactProvider).onError(error: from.uploadContacts.errorMsg);
        }
        break;

      case From_Msg.showMessage:
        read(utilsProvider).showErrorDialog(from.showMessage.text);
        break;

      case From_Msg.encryptPin:
        if (from.encryptPin.hasError()) {
          final pinData = PinData(error: from.encryptPin.error);
          pinEncryptDataSubject.add(pinData);
        } else {
          final data = from.encryptPin.data;
          final pinData = PinData(
              salt: data.salt,
              encryptedData: data.encryptedData,
              pinIdentifier: data.pinIdentifier);
          await read(configProvider).setPinData(pinData);
          pinEncryptDataSubject.add(pinData);
        }
        break;

      case From_Msg.decryptPin:
        if (from.decryptPin.hasError()) {
          pinDecryptDataSubject
              .add(PinDecryptedData(false, error: from.decryptPin.error));
        } else {
          _mnemonic = from.decryptPin.mnemonic;
          pinDecryptDataSubject
              .add(PinDecryptedData(true, mnemonic: _mnemonic));
        }

        break;

      case From_Msg.notSet:
        throw Exception('invalid empty message');
    }
  }

  void openTxUrl(String txid, bool isLiquid, bool unblinded) {
    if (!isLiquid || !unblinded) {
      final url = generateTxidUrl(txid, isLiquid, null);
      explorerUrlSubject.add(url);
      return;
    }
    final msg = To();
    msg.blindedValues = To_BlindedValues();
    msg.blindedValues.txid = txid;
    sendMsg(msg);
  }

  Future<void> _addBtcAsset() async {
    final bitcoinAsset = Asset();
    bitcoinAsset.name = 'Bitcoin';
    bitcoinAsset.assetId =
        '0000000000000000000000000000000000000000000000000000000000000000';
    bitcoinAsset.ticker = kBitcoinTicker;
    bitcoinAsset.precision = kDefaultPrecision;
    final icon = await BitmapHelper.getPngBufferFromSvgAsset(
        'assets/btc_logo.svg', 75, 75);
    _addAsset(bitcoinAsset, icon);
  }

  void _addAsset(Asset asset, Uint8List assetIcon) {
    if (assets[asset.assetId] == null) {
      _assetIds.add(asset.assetId);
      assets[asset.assetId] = asset;
      assetImagesBig[asset.assetId] = Image.memory(
        assetIcon,
        width: 75,
        height: 75,
        filterQuality: FilterQuality.high,
      );
      assetImagesSmall[asset.assetId] = Image.memory(
        assetIcon,
        width: 32,
        height: 32,
        filterQuality: FilterQuality.high,
      );
      if (asset.ticker == kLiquidBitcoinTicker) {
        _liquidAssetId = asset.assetId;
      }
      if (asset.ticker == kBitcoinTicker) {
        _bitcoinAssetId = asset.assetId;
      }
      if (asset.ticker == kTetherTicker) {
        _tetherAssetId = asset.assetId;
      }
      updateEnabledAssetIds();
    }
    // Make sure we don't have null values
    if (balances[asset.assetId] == null) {
      balances[asset.assetId] = 0;
    }
    read(swapProvider).checkSelectedAsset();
    notifyListeners();
  }

  void registerPhone(String number) {
    final msg = To();
    msg.registerPhone = To_RegisterPhone();
    msg.registerPhone.number = number;
    sendMsg(msg);
  }

  void verifyPhone(String phoneKey, String code) {
    final msg = To();
    msg.verifyPhone = To_VerifyPhone();
    msg.verifyPhone.phoneKey = phoneKey;
    msg.verifyPhone.code = code;
    sendMsg(msg);
  }

  int parseBitcoinAmount(String value) {
    if (value == null) {
      return null;
    }

    final amount =
        Lib.lib.sideswap_parse_bitcoin_amount(Utf8.toUtf8(value).cast());
    if (!Lib.lib.sideswap_parsed_amount_valid(amount)) {
      return null;
    }
    return amount;
  }

  String getNewMnemonic() {
    final mnemonicPtr = Lib.lib.sideswap_generate_mnemonic12();
    final mnemonic = Utf8.fromUtf8(mnemonicPtr.cast());
    Lib.lib.sideswap_string_free(mnemonicPtr);
    return mnemonic;
  }

  bool validateMnemonic(String mnemonic) {
    return Lib.lib.sideswap_verify_mnemonic(Utf8.toUtf8(mnemonic).cast());
  }

  void updateEnabledAssetIds() {
    enabledAssetIds.clear();
    for (var assetId in _assetIds) {
      if (!read(configProvider).disabledAssetIds.contains(assetId) &&
          assetId != bitcoinAssetId()) {
        enabledAssetIds.add(assetId);
      }
    }
    notifyListeners();
  }

  List<String> getMnemonicWords() {
    return _mnemonic?.split(' ');
  }

  Future<void> setReviewLicenseCreateWallet() async {
    if (read(configProvider).licenseAccepted) {
      if (await _encryption.canAuthenticate()) {
        await newWalletBiometricPrompt();
        return;
      }

      await setNewWalletPinWelcome();
    } else {
      status = Status.reviewLicenseCreateWallet;
    }
    notifyListeners();
  }

  void setReviewLicenseImportWallet() {
    if (read(configProvider).licenseAccepted) {
      startMnemonicImport();
    } else {
      status = Status.reviewLicenseImportWallet;
    }
    notifyListeners();
  }

  Future<void> setLicenseAccepted() async {
    await read(configProvider).setLicenseAccepted(true);
    notifyListeners();
  }

  Future<void> newWalletBiometricPrompt() async {
    assert(read(configProvider).licenseAccepted == true);
    _mnemonic = getNewMnemonic();
    if (await _encryption.canAuthenticate()) {
      status = Status.newWalletBiometricPrompt;
      notifyListeners();
      return;
    } else {
      await walletBiometricSkip();
      newWalletBackupPrompt();
      return;
    }
  }

  void newWalletBackupPrompt() {
    status = Status.newWalletBackupPrompt;
    notifyListeners();
  }

  void startMnemonicImport() {
    assert(status == Status.noWallet ||
        status == Status.importWallet ||
        status == Status.importWalletError ||
        status == Status.reviewLicenseImportWallet);
    status = Status.importWallet;
    notifyListeners();
  }

  void importMnemonic(String mnemonic) {
    assert(
        status == Status.importWallet || status == Status.importWalletSuccess);
    _mnemonic = mnemonic;

    setImportWalletResult(true);
  }

  void backupNewWalletEnable() {
    status = Status.newWalletBackupView;
    notifyListeners();
  }

  Future<bool> walletBiometricEnable() async {
    return _registerWallet(true);
  }

  Future<bool> walletPinEnable() async {
    if (await _registerWallet(false)) {
      await enablePinProtection();
      return true;
    }

    return false;
  }

  Future<bool> walletBiometricSkip() async {
    return _registerWallet(false);
  }

  Future<bool> _registerWallet(bool enableBiometric) async {
    if (_mnemonic == null || _mnemonic.isEmpty) {
      logger.e('Mnemonic is empty!');
      return false;
    }

    if (enableBiometric) {
      await read(configProvider)
          .setMnemonicEncrypted(await _encryption.encryptBiometric(_mnemonic));

      if (read(configProvider).mnemonicEncrypted.isEmpty) {
        return false;
      }
      await read(configProvider).setUseBiometricProtection(true);
      await read(configProvider).setUsePinProtection(false);
    } else {
      await read(configProvider)
          .setMnemonicEncrypted(await _encryption.encryptFallback(_mnemonic));
      // Should not happen, something is very wrong
      if (read(configProvider).mnemonicEncrypted == null) {
        return false;
      }
      await read(configProvider).setUseBiometricProtection(false);
    }

    return true;
  }

  Future<void> loginAndLoadMainPage() async {
    _login(_mnemonic);
    read(swapProvider).checkSelectedAsset();
    status = Status.registered;
    notifyListeners();
  }

  Future<void> acceptLicense() async {
    await read(configProvider).setLicenseAccepted(true);
    status = Status.noWallet;
    notifyListeners();
  }

  void backupNewWalletCheck() {
    backupCheckAllWords = {};
    backupCheckSelectedWords = {};
    final r = Random();
    final allWords = getMnemonicWords();
    assert(allWords.length == 12);
    final allIndices = List<int>.generate(12, (index) => index);
    allIndices.shuffle(r);
    final selectedIndices = allIndices.take(kBackupCheckLineCount).toList();
    selectedIndices.sort();
    for (var selectedIndex in selectedIndices) {
      final selectedWord = allWords[selectedIndex];
      final uniqueWords = allWords.toSet();
      uniqueWords.remove(selectedWord);
      final remainingWords = uniqueWords.toList();
      remainingWords.shuffle(r);
      final otherWords =
          remainingWords.take(kBackupCheckWordCount - 1).toList();
      otherWords.add(selectedWord);
      otherWords.shuffle(r);
      backupCheckAllWords[selectedIndex] = otherWords;
    }
    status = Status.newWalletBackupCheck;
    notifyListeners();
  }

  void backupNewWalletSelect(int wordIndex, int selectedIndex) {
    backupCheckSelectedWords[wordIndex] = selectedIndex;
    notifyListeners();
  }

  bool _validSelectedWords() {
    final allWords = _mnemonic.split(' ');
    for (var wordIndex in backupCheckAllWords.keys) {
      final correctWord = allWords[wordIndex];
      assert(correctWord != null);
      final selectedWordIndex = backupCheckSelectedWords[wordIndex];
      if (selectedWordIndex == null) {
        return false;
      }
      final wordList = backupCheckAllWords[wordIndex];
      final selectedWord = wordList[selectedWordIndex];
      if (selectedWord != correctWord) {
        return false;
      }
    }
    return true;
  }

  void backupNewWalletVerify() {
    if (_validSelectedWords()) {
      status = Status.newWalletBackupCheckSucceed;
      return;
    }
    status = Status.newWalletBackupCheckFailed;
    notifyListeners();
  }

  bool goBack() {
    switch (status) {
      case Status.newWalletBackupCheck:
        status = Status.newWalletBackupView;
        break;
      case Status.newWalletBackupCheckFailed:
      case Status.newWalletBackupCheckSucceed:
        status = Status.newWalletBackupView;
        break;
      case Status.importWalletError:
        status = Status.importWallet;
        break;
      case Status.importWalletSuccess:
      case Status.importWallet:
      case Status.selectEnv:
      case Status.importAvatar:
      case Status.associatePhoneWelcome:
      case Status.reviewLicenseImportWallet:
      case Status.newWalletBackupPrompt:
        status = Status.noWallet;
        break;

      // pages without back
      case Status.confirmPhoneSuccess:
      case Status.importAvatarSuccess:
      case Status.importContacts:
      case Status.importContactsSuccess:
      case Status.pinWelcome:
      case Status.newWalletPinWelcome:
      case Status.pinSetup:
      case Status.pinSuccess:
        return false;
        break;

      case Status.confirmPhone:
        status = Status.associatePhoneWelcome;
        break;
      case Status.assetsSelect:
        status = Status.registered;
        break;
      case Status.assetDetails:
        status = Status.registered;
        final uiStateArgs = read(uiStateArgsProvider);
        uiStateArgs.walletMainArguments =
            uiStateArgs.walletMainArguments.copyWith(
          currentIndex: 0,
          navigationItem: WalletMainNavigationItem.home,
        );
        break;
      case Status.txDetails:
        status = Status.assetDetails;
        break;
      case Status.txEditMemo:
        _applyTxMemoChange();
        status = Status.txDetails;
        break;
      case Status.assetReceive:
        status = Status.assetDetails;
        final uiStateArgs = read(uiStateArgsProvider);
        uiStateArgs.walletMainArguments =
            uiStateArgs.walletMainArguments.copyWith(
          currentIndex: 1,
          navigationItem: WalletMainNavigationItem.assetDetails,
        );
        break;
      case Status.swapTxDetails:
      case Status.assetReceiveFromWalletMain:
      case Status.orderPopup:
      case Status.orderSuccess:
        status = Status.registered;
        final uiStateArgs = read(uiStateArgsProvider);
        uiStateArgs.walletMainArguments =
            uiStateArgs.walletMainArguments.copyWith(
          currentIndex: 0,
          navigationItem: WalletMainNavigationItem.home,
        );

        break;
      case Status.swapWaitPegTx:
        final uiStateArgs = read(uiStateArgsProvider);
        uiStateArgs.walletMainArguments =
            uiStateArgs.walletMainArguments.copyWith(
          currentIndex: 0,
          navigationItem: WalletMainNavigationItem.home,
        );
        read(swapProvider).pegStop();
        break;
      case Status.settingsBackup:
      case Status.settingsSecurity:
      case Status.settingsAboutUs:
      case Status.settingsUserDetails:
        status = Status.settingsPage;
        break;
      case Status.settingsPage:
        status = Status.registered;
        break;
      case Status.newWalletBackupView:
        status = Status.newWalletBackupPrompt;
        break;
      case Status.newWalletBiometricPrompt:
      case Status.importWalletBiometricPrompt:
        // don't use Status.importWallet here as it breaks text fields
        // user will need to start over
        status = Status.noWallet;
        break;
      case Status.reviewLicenseCreateWallet:
        status = Status.noWallet;
        break;
      case Status.registered:
        status = Status.registered;
        break;
      case Status.loading:
      case Status.noWallet:
      case Status.lockedWalet:
        return true;
      case Status.paymentPage:
        status = Status.assetDetails;
        break;
      case Status.paymentAmountPage:
        status = Status.paymentPage;
        break;
      case Status.paymentSend:
        status = Status.paymentAmountPage;
        break;
    }

    notifyListeners();
    return false;
  }

  void _login(String mnemonic) {
    final msg = To();
    msg.login = To_Login();
    msg.login.mnemonic = mnemonic;
    sendMsg(msg);
  }

  void _logout() {
    balances = {};
    read(swapProvider).swapSendAsset = null;
    read(swapProvider).swapRecvAsset = null;

    final msg = To();
    msg.logout = Empty();
    sendMsg(msg);
  }

  void selectAssetDetails(String value) {
    status = Status.assetDetails;
    selectedWalletAsset = value;
    notifyListeners();
  }

  void prepareAssetReceive() {
    recvAddress = null;

    final msg = To();
    msg.getRecvAddress = Empty();
    sendMsg(msg);
  }

  void selectAssetReceive() {
    prepareAssetReceive();

    status = Status.assetReceive;

    final uiStateArgs = read(uiStateArgsProvider);
    uiStateArgs.walletMainArguments = uiStateArgs.walletMainArguments
        .copyWith(navigationItem: WalletMainNavigationItem.homeAssetReceive);

    notifyListeners();
  }

  void selectAssetReceiveFromWalletMain() {
    prepareAssetReceive();

    status = Status.assetReceiveFromWalletMain;

    final uiStateArgs = read(uiStateArgsProvider);
    uiStateArgs.walletMainArguments = uiStateArgs.walletMainArguments
        .copyWith(navigationItem: WalletMainNavigationItem.homeAssetReceive);

    notifyListeners();
  }

  void selectPaymentPage() {
    status = Status.paymentPage;
    notifyListeners();
  }

  void showTxDetails(TransItem tx) {
    status = Status.txDetails;
    txDetails = tx;

    _listenTxDetailsChanges();

    notifyListeners();
  }

  void showSwapTxDetails(TransItem tx) {
    status = Status.swapTxDetails;
    txDetails = tx;

    _listenTxDetailsChanges();

    notifyListeners();
  }

  void _listenTxDetailsChanges() {
    txDetailsSubscription?.cancel();
    txDetailsSubscription = newTransItemSubject.listen((value) {
      if (value.id == txDetails.id) {
        txDetails = value;
        notifyListeners();
      }
    });
  }

  static int convertAddrType(AddrType type) {
    switch (type) {
      case AddrType.bitcoin:
        return SIDESWAP_BITCOIN;
      case AddrType.elements:
        return SIDESWAP_ELEMENTS;
    }
    throw Exception('unexpected value');
  }

  bool isAddrValid(String addr, AddrType addrType) {
    if (addr == null || addr.isEmpty || _client == 0) {
      return false;
    }

    final addrPtr = Utf8.toUtf8(addr);
    return Lib.lib.sideswap_check_addr(
        _client, addrPtr.cast(), convertAddrType(addrType));
  }

  String commonAddrErrorStr(String addr, AddrType addrType) {
    if (addr == null || addr == '') {
      return null;
    }

    return isAddrValid(addr, addrType) ? null : 'Invalid address'.tr();
  }

  String elementsAddrErrorStr(String addr) {
    return commonAddrErrorStr(addr, AddrType.elements);
  }

  String bitcoinAddrErrorStr(String addr) {
    return commonAddrErrorStr(addr, AddrType.bitcoin);
  }

  String amountErrorStr(String value, int min, int max) {
    if (value == null || value == '') {
      return null;
    }

    var amount = parseBitcoinAmount(value);
    if (amount == null) {
      return 'Invalid amount'.tr();
    }

    if (amount < min) {
      return 'Amount is too low'.tr();
    }

    if (amount > max) {
      return 'Amount is too high'.tr();
    }

    return null;
  }

  void assetSendConfirm() {
    final msg = To();
    msg.sendTx = To_SendTx();
    sendMsg(msg);
  }

  void selectAvailableAssets() {
    setToggleAssetFilter('');
    status = Status.assetsSelect;
    notifyListeners();
  }

  bool _showAsset(Asset asset, String filterLowerCase) {
    if (asset.ticker == kBitcoinTicker) {
      return false;
    }
    if (filterLowerCase.isEmpty) {
      return true;
    }
    final assetText =
        '${asset.ticker}\n${asset.name}\n${asset.assetId}'.toLowerCase();
    return assetText.contains(filterLowerCase);
  }

  void setToggleAssetFilter(String filter) {
    final filterLowerCase = filter.toLowerCase();
    final filteredToggleAssetIdsNew = <String>[];
    for (var assetId in _assetIds) {
      if (_showAsset(assets[assetId], filterLowerCase)) {
        filteredToggleAssetIdsNew.add(assetId);
      }
    }
    if (!listEquals(filteredToggleAssetIdsNew, filteredToggleAssetIds)) {
      filteredToggleAssetIds = filteredToggleAssetIdsNew;
      notifyListeners();
    }
  }

  Future<void> toggleAssetVisibility(String assetId) async {
    final disableAssetIds = read(configProvider).disabledAssetIds;
    if (disableAssetIds.contains(assetId)) {
      disableAssetIds.remove(assetId);
    } else {
      disableAssetIds.add(assetId);
    }
    await read(configProvider).setDisabledAssetIds(disableAssetIds);
    updateEnabledAssetIds();
    notifyListeners();
  }

  void editTxMemo(Object arguments) {
    status = Status.txEditMemo;
    _currentTxMemoUpdate;
    notifyListeners();
  }

  String txMemo(Tx tx) {
    final updatedMemo = _txMemoUpdates[tx?.txid];
    if (updatedMemo != null) {
      return updatedMemo;
    }
    return tx?.memo;
  }

  void onTxMemoChanged(String value) {
    _currentTxMemoUpdate = value;
  }

  void _applyTxMemoChange() {
    if (_currentTxMemoUpdate != null && txDetails.tx != null) {
      _txMemoUpdates[txDetails.tx.txid] = _currentTxMemoUpdate;

      var msg = To();
      msg.setMemo = To_SetMemo();
      msg.setMemo.txid = txDetails.tx.txid;
      msg.setMemo.memo = _currentTxMemoUpdate;
      sendMsg(msg);

      _currentTxMemoUpdate;
    }
  }

  Future<void> settingsViewBackup() async {
    if (read(configProvider).usePinProtection) {
      if (await read(pinProtectionProvider).pinBlockadeUnlocked()) {
        status = Status.settingsBackup;
        notifyListeners();
        return;
      }

      return;
    }

    final mnemonic = read(configProvider).useBiometricProtection
        ? await _encryption
            .decryptBiometric(read(configProvider).mnemonicEncrypted)
        : await _encryption
            .decryptFallback(read(configProvider).mnemonicEncrypted);
    if (mnemonic != null &&
        mnemonic == _mnemonic &&
        validateMnemonic(mnemonic)) {
      status = Status.settingsBackup;
      notifyListeners();
    }
  }

  Future<void> settingsUserDetails() async {
    status = Status.settingsUserDetails;
    notifyListeners();
  }

  void settingsViewPage() {
    status = Status.settingsPage;
    notifyListeners();
  }

  void settingsViewAboutUs() {
    status = Status.settingsAboutUs;
    notifyListeners();
  }

  Future<void> settingsViewSecurity() async {
    settingsBiometricAvailable = await _encryption.canAuthenticate();
    status = Status.settingsSecurity;
    notifyListeners();
  }

  bool isBiometricEnabled() {
    return read(configProvider).useBiometricProtection;
  }

  bool isPinEnabled() {
    return read(configProvider).usePinProtection;
  }

  Future<bool> isBiometricAvailable() async {
    settingsBiometricAvailable = await _encryption.canAuthenticate();
    return settingsBiometricAvailable;
  }

  Future<void> settingsDeletePromptConfirm() async {
    _logout();
    await read(configProvider).deleteConfig();
    allTxs.clear();
    refreshTxs();
    status = Status.noWallet;
    notifyListeners();
  }

  Future<void> unlockWallet() async {
    if (read(configProvider).usePinProtection) {
      if (await read(pinProtectionProvider).pinBlockadeUnlocked()) {
        _login(_mnemonic);
        status = Status.registered;
        notifyListeners();
        return;
      }

      status = Status.lockedWalet;
      notifyListeners();
      return;
    }

    if (read(configProvider).useBiometricProtection) {
      _mnemonic = await _encryption
          .decryptBiometric(read(configProvider).mnemonicEncrypted);
    } else {
      _mnemonic = await _encryption
          .decryptFallback(read(configProvider).mnemonicEncrypted);
    }
    if (_mnemonic != null && validateMnemonic(_mnemonic)) {
      _login(_mnemonic);
      status = Status.registered;
    } else {
      // TODO: Show error
      status = Status.lockedWalet;
    }
    notifyListeners();
  }

  Future<void> settingsEnableBiometric() async {
    final mnemonic = await _encryption
        .decryptFallback(read(configProvider).mnemonicEncrypted);
    if (mnemonic == null) {
      return;
    }
    final mnemonicEncrypted = await _encryption.encryptBiometric(mnemonic);
    if (mnemonicEncrypted == null) {
      return;
    }
    await read(configProvider).setMnemonicEncrypted(mnemonicEncrypted);
    _mnemonic = mnemonic;
    await read(configProvider).setUseBiometricProtection(true);
    notifyListeners();
  }

  Future<void> settingsDisableBiometric() async {
    final mnemonic = await _encryption
        .decryptBiometric(read(configProvider).mnemonicEncrypted);
    if (mnemonic == null) {
      return;
    }
    final mnemonicEncrypted = await _encryption.encryptFallback(mnemonic);
    if (mnemonicEncrypted == null) {
      return;
    }
    await read(configProvider).setMnemonicEncrypted(mnemonicEncrypted);
    _mnemonic = mnemonic;
    await read(configProvider).setUseBiometricProtection(false);
    notifyListeners();
  }

  Future<void> buildTxList(Map<String, List<TxItem>> value) async {
    final _dateFormat = DateFormat('yyyy-MM-dd');

    value.keys.forEach((key) {
      value[key] = value[key]
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

      final tempAssets = <TxItem>[];
      value[key].forEach((e) {
        if (tempAssets.isEmpty) {
          tempAssets.add(e.copyWith(showDate: true));
        } else {
          final last = DateTime.parse(_dateFormat.format(
              DateTime.fromMillisecondsSinceEpoch(tempAssets.last.createdAt)));
          final current = DateTime.parse(_dateFormat
              .format(DateTime.fromMillisecondsSinceEpoch(e.createdAt)));
          final diff = last.difference(current).inDays;
          tempAssets.add(e.copyWith(showDate: diff != 0));
        }
      });

      value[key] = tempAssets;
    });

    txItemMap = value;
    notifyListeners();
  }

  int env() {
    return read(configProvider).env;
  }

  Future<void> setEnv(int e) async {
    if (read(configProvider).env == e) {
      status = Status.noWallet;
      notifyListeners();
      return;
    }

    await read(configProvider).setEnv(e);
    exit(0);
  }

  void selectEnv() {
    assert(status == Status.noWallet);
    status = Status.selectEnv;
    notifyListeners();
  }

  Future<bool> isAuthenticated() async {
    if (read(configProvider).usePinProtection) {
      return read(pinProtectionProvider).pinBlockadeUnlocked();
    }

    if (read(configProvider).useBiometricProtection) {
      _mnemonic = await _encryption
          .decryptBiometric(read(configProvider).mnemonicEncrypted);
    } else {
      _mnemonic = await _encryption
          .decryptFallback(read(configProvider).mnemonicEncrypted);
    }

    if (_mnemonic != null && validateMnemonic(_mnemonic)) {
      return true;
    }

    return false;
  }

  void setImportWalletResult(bool success) {
    if (success) {
      status = Status.importWalletSuccess;
    } else {
      status = Status.importWalletError;
    }

    notifyListeners();
  }

  Future<void> setImportWalletBiometricPrompt() async {
    final canAuthenticate = await _encryption.canAuthenticate();
    if (canAuthenticate) {
      status = Status.importWalletBiometricPrompt;
      notifyListeners();
      return;
    }

    if (await _registerWallet(false)) {
      await loginAndLoadMainPage();
    }
  }

  void setRegistered() {
    status = Status.registered;
    notifyListeners();
  }

  void updatePushToken(String token) {
    var msg = To();
    msg.updatePushToken = To_UpdatePushToken();
    msg.updatePushToken.token = token;
    sendMsg(msg);
  }

  double _getPriceBitcoin(String assetId) {
    if (assetId == liquidAssetId()) {
      return 1;
    }
    final price = _prices[assetId];
    if (price == null) {
      return 0;
    }
    return (price.bid + price.ask) / 2;
  }

  double _getPrice(String num, String den) {
    final priceNum = _getPriceBitcoin(num);
    final priceDen = _getPriceBitcoin(den);
    if (priceDen == 0 || priceNum == 0) {
      return 0;
    }
    return priceNum / priceDen;
  }

  double _getPriceUsd(String den) {
    return _getPrice(tetherAssetId(), den);
  }

  double getAmountUsd(String assetId, double amount) {
    return amount * _getPriceUsd(assetId);
  }

  Asset getAssetByTicker(String ticker) {
    for (var asset in assets.values) {
      if (asset.ticker == ticker) {
        return asset;
      }
    }
    return null;
  }

  Asset getAssetById(String assetId) {
    for (var asset in assets.values) {
      if (asset.assetId == assetId) {
        return asset;
      }
    }
    return null;
  }

  String _liquidAssetId;
  String liquidAssetId() {
    return _liquidAssetId;
  }

  String _bitcoinAssetId;
  String bitcoinAssetId() {
    return _bitcoinAssetId;
  }

  String _tetherAssetId;
  String tetherAssetId() {
    return _tetherAssetId;
  }

  List<String> sendAssets() {
    return assets.keys.where((element) => element != bitcoinAssetId()).toList();
  }

  void setImportAvatar() {
    status = Status.importAvatar;
    notifyListeners();
  }

  void setImportAvatarSuccess() {
    status = Status.importAvatarSuccess;
    notifyListeners();
  }

  void setAssociatePhoneWelcome() {
    status = Status.associatePhoneWelcome;
    notifyListeners();
  }

  void setConfirmPhone() {
    status = Status.confirmPhone;
    notifyListeners();
  }

  void setConfirmPhoneSuccess() {
    status = Status.confirmPhoneSuccess;
    notifyListeners();
  }

  void setImportContacts() {
    status = Status.importContacts;
    notifyListeners();
  }

  void setImportContactsSuccess() {
    status = Status.importContactsSuccess;
    notifyListeners();
  }

  void setOrder({@required OrderDetailsData orderDetailsData}) {
    status = Status.orderPopup;
    this.orderDetailsData = orderDetailsData;
    notifyListeners();
  }

  void setPlaceOrderSuccess() {
    status = Status.orderSuccess;
    notifyListeners();
  }

  void setExecuteOrderSuccess() {
    // TODO: add code
    status = Status.registered;
    notifyListeners();
  }

  void linkOrder(String orderId) {
    final msg = To();
    msg.linkOrder = To_LinkOrder();
    msg.linkOrder.orderId = orderId;
    sendMsg(msg);
  }

  void uploadDeviceContacts({@required List<Contact> contacts}) {
    final uploadContacts = To_UploadContacts();
    uploadContacts.phoneKey = read(configProvider).phoneKey;
    final serverContactList = uploadContacts.contacts;
    for (var c in contacts) {
      serverContactList.add(c);
    }

    final msg = To();
    msg.uploadContacts = uploadContacts;
    sendMsg(msg);
  }

  void uploadAvatar({@required String avatar}) {
    final uploadAvatar = To_UploadAvatar();
    uploadAvatar.phoneKey = read(configProvider).phoneKey;
    uploadAvatar.text = avatar;

    final msg = To();
    msg.uploadAvatar = uploadAvatar;
    sendMsg(msg);
  }

  Future<void> setNewWalletPinWelcome() async {
    _mnemonic = getNewMnemonic();
    read(pinSetupProvider).isNewWallet = true;
    status = Status.newWalletPinWelcome;
    notifyListeners();
  }

  void setPinWelcome() async {
    if (await _encryption.canAuthenticate()) {
      await setImportWalletBiometricPrompt();
      return;
    }
    status = Status.pinWelcome;
    notifyListeners();
  }

  void setPinSetup({
    @required void Function(BuildContext context) onSuccessCallback,
    @required void Function(BuildContext context) onBackCallback,
  }) {
    read(pinSetupProvider).init(
      onSuccessCallback: onSuccessCallback,
      onBackCallback: onBackCallback,
    );
    status = Status.pinSetup;
    notifyListeners();
  }

  void sendEncryptPin(String pin) async {
    final msg = To();
    msg.encryptPin = To_EncryptPin();
    msg.encryptPin.pin = pin;
    msg.encryptPin.mnemonic = _mnemonic;
    sendMsg(msg);
  }

  void sendDecryptPin(String pin) {
    final pinData = read(configProvider).pinData;

    final msg = To();
    msg.decryptPin = To_DecryptPin();
    msg.decryptPin.pin = pin;
    msg.decryptPin.salt = pinData.salt;
    msg.decryptPin.encryptedData = pinData.encryptedData;
    msg.decryptPin.pinIdentifier = pinData.pinIdentifier;
    sendMsg(msg);
  }

  Future<void> setPinSuccess() async {
    await enablePinProtection();
    status = Status.pinSuccess;
    notifyListeners();
  }

  Future<bool> disablePinProtection() async {
    if (!await read(configProvider).usePinProtection) {
      // already disabled
      return true;
    }

    final pinDecryptedSubscription = read(walletProvider)
        .pinDecryptDataSubject
        .listen((pinDecryptedData) async {
      if (pinDecryptedData.success) {
        // turn off pin and save encrypted mnemonic
        await read(configProvider).setUsePinProtection(false);
        notifyListeners();

        await read(configProvider).setMnemonicEncrypted(
            await _encryption.encryptFallback(pinDecryptedData.mnemonic));
      }
    });

    final ret = await read(pinProtectionProvider).pinBlockadeUnlocked();
    await pinDecryptedSubscription?.cancel();

    return ret;
  }

  Future<void> enablePinProtection() async {
    await read(configProvider).setUsePinProtection(true);
    notifyListeners();
  }
}
