import 'dart:convert';
import 'dart:ffi' as ffi;
import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';
import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/subjects.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sideswap/common/bitmap_helper.dart';
import 'package:sideswap/common/encryption.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/utils/custom_logger.dart';
import 'package:sideswap/common/widgets/insufficient_balance_dialog.dart';
import 'package:sideswap/models/assets_precache.dart';
import 'package:sideswap/models/config_provider.dart';
import 'package:sideswap/models/notifications_service.dart';
import 'package:sideswap/models/payment_provider.dart';
import 'package:sideswap/models/swap_provider.dart';
import 'package:sideswap/models/tx_item.dart';
import 'package:sideswap/models/ui_state_args_provider.dart';
import 'package:sideswap/models/utils_provider.dart';
import 'package:sideswap/protobuf/sideswap.pb.dart';
import 'package:sideswap/side_swap_client_ffi.dart';
import 'package:package_info/package_info.dart';

enum Status {
  loading,
  reviewLicense,
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

  paymentPage,
  paymentAmountPage,
  paymentSend
}

enum AddrType {
  bitcoin,
  elements,
}

const mnemnicEncryptedField = 'mnemonic_encrypted';
const useBiometricProtectionField = 'biometric_protection';
const licenseAcceptedField = 'license_accepted';
const disabledAssetsField = 'disabled_assets';
const envField = 'env';

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
  final enabledAssetTickers = <String>[];

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

  final _assetTickers = <String>[];
  var assets = <String, Asset>{};
  var assetImagesBig = <String, Image>{};
  var assetImagesSmall = <String, Image>{};

  final allTxs = <String, TransItem>{};
  final newTransItemSubject = BehaviorSubject<TransItem>();
  // Cached version of allTxs
  final allAssets = <String, List<TxItem>>{};
  Map<String, List<TxItem>> txItemMap = {};

  var balances = <String, int>{};

  // Toggle assets page
  var filteredToggleTickers = <String>[];

  TransItem txDetails;

  final _txMemoUpdates = <String, String>{};
  String _currentTxMemoUpdate;

  bool settingsBiometricAvailable = false;

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
      await startClient();
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
      status = Status.noWallet;
      notifyListeners();
    }

    if (status == Status.lockedWalet) {
      await unlockWallet();
    }

    await notificationService.refreshToken();
    await notificationService.handleDynamicLinks();
  }

  void _addTxItem(TransItem item, String ticker) {
    if (allAssets[ticker] == null) {
      allAssets[ticker] = [];
    }
    allAssets[ticker].add(TxItem(item: item));
  }

  void refreshTxs() {
    allAssets.clear();
    for (var item in allTxs.values) {
      switch (item.whichItem()) {
        case TransItem_Item.tx:
          var tx = item.tx;
          for (var balance in tx.balances) {
            _addTxItem(item, balance.ticker);
          }
          break;
        case TransItem_Item.peg:
          _addTxItem(item, kLiquidBitcoinTicker);
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
        balances[from.balanceUpdate.ticker] = from.balanceUpdate.amount.toInt();
        notifyListeners();
        break;

      case From_Msg.swapReview:
        if (read(swapProvider).swapActive) {
          read(swapProvider).swapSendAsset = from.swapReview.sendTicker;
          read(swapProvider).swapRecvAsset = from.swapReview.recvTicker;
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
        read(swapProvider).swapSendAsset = from.swapWaitTx.sendTicker;
        read(swapProvider).swapRecvAsset = from.swapWaitTx.recvTicker;
        notifyListeners();
        break;

      case From_Msg.recvAddress:
        recvAddress = from.recvAddress.addr;
        notifyListeners();
        break;

      case From_Msg.createTxResult:
        switch (from.createTxResult.whichResult()) {
          case From_CreateTxResult_Result.errorMsg:
            final balance = balances[kLiquidBitcoinTicker];
            if (selectedWalletAsset != kLiquidBitcoinTicker && balance == 0) {
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

      case From_Msg.serverStatus:
        _serverStatus = from.serverStatus;
        // TODO: Allow pegs only after that
        notifyListeners();
        break;

      case From_Msg.priceUpdate:
        _prices[from.priceUpdate.asset] = from.priceUpdate;
        notifyListeners();
        break;

      case From_Msg.notSet:
        throw Exception('invalid empty message');
    }
  }

  Future<void> _addBtcAsset() async {
    final bitcoinAsset = Asset();
    bitcoinAsset.name = 'Bitcoin';
    bitcoinAsset.ticker = kBitcoinTicker;
    bitcoinAsset.precision = kDefaultPrecision;
    final icon = await BitmapHelper.getPngBufferFromSvgAsset(
        'assets/btc_logo.svg', 75, 75);
    _addAsset(bitcoinAsset, icon);
  }

  void _addAsset(Asset asset, Uint8List assetIcon) {
    if (assets[asset.ticker] == null) {
      _assetTickers.add(asset.ticker);
      assets[asset.ticker] = asset;
      assetImagesBig[asset.ticker] = Image.memory(
        assetIcon,
        width: 75,
        height: 75,
        filterQuality: FilterQuality.high,
      );
      assetImagesSmall[asset.ticker] = Image.memory(
        assetIcon,
        width: 32,
        height: 32,
        filterQuality: FilterQuality.high,
      );
      updateEnabledAssetIds();
    }
    // Make sure we don't have null values
    if (balances[asset.ticker] == null) {
      balances[asset.ticker] = 0;
    }
    read(swapProvider).checkSelectedAsset();
    notifyListeners();
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
    enabledAssetTickers.clear();
    for (var ticker in _assetTickers) {
      if (!read(configProvider).disabledAssetTickers.contains(ticker) &&
          ticker != kBitcoinTicker) {
        enabledAssetTickers.add(ticker);
      }
    }
  }

  List<String> getMnemonicWords() {
    return _mnemonic?.split(' ');
  }

  void selectLicenseAccepted() {
    status = Status.reviewLicense;
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
        status == Status.importWalletError);
    status = Status.importWallet;
    notifyListeners();
  }

  Future<void> importMnemonic(String mnemonic) async {
    assert(status == Status.importWallet);
    _mnemonic = mnemonic;

    setImportWalletResult(true);
  }

  void backupNewWalletEnable() {
    status = Status.newWalletBackupView;
    notifyListeners();
  }

  Future<bool> walletBiometricEnable() async {
    return await _registerWallet(true);
  }

  Future<bool> walletBiometricSkip() async {
    return await _registerWallet(false);
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
        status = Status.noWallet;
        break;
      case Status.assetsSelect:
        status = Status.registered;
        break;
      case Status.assetDetails:
        status = Status.registered;
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
        status = Status.settingsPage;
        break;
      case Status.settingsPage:
        status = Status.registered;
        break;
      case Status.newWalletBackupView:
        status = Status.newWalletBackupPrompt;
        break;
      case Status.newWalletBiometricPrompt:
        status = Status.reviewLicense;
        break;
      case Status.importWalletBiometricPrompt:
        // don't use Status.importWallet here as it breaks text fields
        // user will need to start over
        status = Status.noWallet;
        break;
      case Status.newWalletBackupPrompt:
        status = Status.newWalletBiometricPrompt;
        break;
      case Status.reviewLicense:
        status = Status.noWallet;
        break;

      case Status.loading:
      case Status.noWallet:
      case Status.registered:
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
    notifyListeners();
  }

  void showSwapTxDetails(TransItem tx) {
    status = Status.swapTxDetails;
    txDetails = tx;
    notifyListeners();
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
    final filteredToggleTickersNew = <String>[];
    for (var ticker in _assetTickers) {
      if (_showAsset(assets[ticker], filterLowerCase)) {
        filteredToggleTickersNew.add(ticker);
      }
    }
    if (!listEquals(filteredToggleTickersNew, filteredToggleTickers)) {
      filteredToggleTickers = filteredToggleTickersNew;
      notifyListeners();
    }
  }

  Future<void> toggleAssetVisibility(String ticker) async {
    final disableAssetTickers = read(configProvider).disabledAssetTickers;
    if (disableAssetTickers.contains(ticker)) {
      disableAssetTickers.remove(ticker);
    } else {
      disableAssetTickers.add(ticker);
    }
    await read(configProvider).setDisabledAssetTickers(disableAssetTickers);
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

  void walletSuccessfulyImported() async {
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

  double getPriceBitcoin(String ticker) {
    if (ticker == kLiquidBitcoinTicker) {
      return 1;
    }
    final price = _prices[ticker];
    if (price == null) {
      return 0;
    }
    return (price.bid + price.ask) / 2;
  }

  double getPrice(String num, String den) {
    final priceNum = getPriceBitcoin(num);
    final priceDen = getPriceBitcoin(den);
    if (priceDen == 0 || priceNum == 0) {
      return 0;
    }
    return priceNum / priceDen;
  }

  double getPriceUsd(String den) {
    return getPrice(kTetherTicker, den);
  }

  double getAmountUsd(String den, double amount) {
    return amount * getPriceUsd(den);
  }
}
