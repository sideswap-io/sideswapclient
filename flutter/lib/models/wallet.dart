import 'dart:async';
import 'dart:convert';
import 'dart:ffi' as ffi;
import 'dart:io';
import 'dart:isolate';
import 'dart:math';

import 'package:decimal/decimal.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ffi/ffi.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/subjects.dart';
import 'package:sideswap/app_version.dart';
import 'package:sideswap/common_platform.dart';
import 'package:sideswap/desktop/desktop_helpers.dart';
import 'package:sideswap/desktop/main/d_order_review.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/models/balances_provider.dart';
import 'package:sideswap/models/local_notifications_service.dart';
import 'package:sideswap/models/market_data_provider.dart';
import 'package:sideswap/models/markets_provider.dart';
import 'package:sideswap/models/network_access_provider.dart';
import 'package:sideswap/models/request_order_provider.dart';
import 'package:sideswap/models/token_market_provider.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:vibration/vibration.dart';
import 'package:move_to_background/move_to_background.dart';

import 'package:sideswap/common/bitmap_helper.dart';
import 'package:sideswap/common/encryption.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/utils/custom_logger.dart';
import 'package:sideswap/models/config_provider.dart';
import 'package:sideswap/models/contact_provider.dart';
import 'package:sideswap/models/payment_provider.dart';
import 'package:sideswap/models/phone_provider.dart';
import 'package:sideswap/models/pin_protection_provider.dart';
import 'package:sideswap/models/pin_setup_provider.dart';
import 'package:sideswap/models/swap_provider.dart';
import 'package:sideswap/models/tx_item.dart';
import 'package:sideswap/models/ui_state_args_provider.dart';
import 'package:sideswap/models/universal_link_provider.dart';
import 'package:sideswap/models/utils_provider.dart';
import 'package:sideswap/models/client_ffi.dart';
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
  walletLoading,

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
  settingsNetwork,

  paymentPage,
  paymentAmountPage,
  paymentSend,

  orderPopup,
  orderSuccess,
  orderResponseSuccess,
  swapPrompt,

  createOrderEntry,
  createOrder,
  createOrderSuccess,
  orderRequestView,
}

enum AddrType {
  bitcoin,
  elements,
}

List<int> envValues() {
  if (kDebugMode) {
    return [
      SIDESWAP_ENV_PROD,
      SIDESWAP_ENV_TESTNET,
      SIDESWAP_ENV_REGTEST,
      SIDESWAP_ENV_LOCAL_LIQUID,
      SIDESWAP_ENV_LOCAL_TESTNET,
      SIDESWAP_ENV_LOCAL,
    ];
  }
  return [
    SIDESWAP_ENV_PROD,
    SIDESWAP_ENV_TESTNET,
  ];
}

String envName(int env) {
  switch (env) {
    case SIDESWAP_ENV_PROD:
      return 'Liquid';
    case SIDESWAP_ENV_TESTNET:
      return 'Testnet';
    case SIDESWAP_ENV_REGTEST:
      return 'Regtest';
    case SIDESWAP_ENV_LOCAL_LIQUID:
      return 'Local Liquid';
    case SIDESWAP_ENV_LOCAL_TESTNET:
      return 'Local Testnet';
    case SIDESWAP_ENV_LOCAL:
      return 'Local Regtest';
  }
  throw Exception('unexpected env value');
}

Account getAccount(AccountType accountType) {
  final account = Account();
  account.id = accountType.id;
  return account;
}

AccountType getAccountType(Account account) {
  return AccountType(account.id);
}

class PinData {
  final String salt;
  final String encryptedData;
  final String pinIdentifier;
  final String error;

  PinData({
    this.salt = '',
    this.encryptedData = '',
    this.pinIdentifier = '',
    this.error = '',
  });

  @override
  String toString() {
    return 'PinData(salt: $salt, encryptedData: <redacted>, pinIdentifier: $pinIdentifier, error: $error)';
  }
}

MarketType getMarketType(Asset asset) {
  if (asset.swapMarket) {
    return MarketType.stablecoin;
  }
  if (asset.ampMarket) {
    return MarketType.amp;
  }
  return MarketType.token;
}

class PinDecryptedData {
  final String error;
  final bool success;
  final String mnemonic;

  PinDecryptedData(this.success, {this.mnemonic = '', this.error = ''});

  @override
  String toString() =>
      'PinDecryptedData(error: $error, success: $success, mnemonic: $mnemonic)';
}

typedef DartPostCObject = ffi.Pointer Function(
    ffi.Pointer<
        ffi.NativeFunction<
            ffi.Int8 Function(ffi.Int64, ffi.Pointer<ffi.Dart_CObject>)>>);

const kBackupCheckLineCount = 4;
const kBackupCheckWordCount = 3;

final walletProvider = ChangeNotifierProvider<WalletChangeNotifier>((ref) {
  return WalletChangeNotifier(ref);
});

class WalletChangeNotifier with ChangeNotifier {
  final Ref ref;
  int _client = 0;

  final _encryption = Encryption();

  String _mnemonic = '';

  // Used only to differentiate import and new wallet startup flows
  // when same states are used (for example newWalletPinWelcome)
  bool walletImporting = false;

  bool loggedIn = false;

  final disabledAccounts = <AccountAsset>{};

  late GlobalKey<NavigatorState> navigatorKey;

  Status _status = Status.loading;
  Status get status => _status;
  set status(Status value) {
    logger.d('status: $value');
    _status = value;
    notifyListeners();
  }

  ServerStatus? _serverStatus;
  ServerStatus? get serverStatus => _serverStatus;

  final Map<String, From_PriceUpdate> _prices = {};
  Map<String, From_PriceUpdate> get prices => _prices;

  AccountAsset? selectedWalletAsset;

  final recvAddresses = <AccountType, String>{};
  AccountType recvAddressAccount = AccountType.reg;

  Map<int, List<String>> backupCheckAllWords = {};
  Map<int, int> backupCheckSelectedWords = {};

  final assetsList = <String>[];
  final assets = <String, Asset>{};
  final assetImagesBig = <String, Image>{};
  final assetImagesSmall = <String, Image>{};
  final assetImagesVerySmall = <String, Image>{};
  var ampAssets = <String>[];
  // List of accounts that are always visible in desktop wallet view
  Set<AccountAsset> defaultAccounts = {};

  final allTxs = <String, TransItem>{};
  final allPegs = <String, List<TransItem>>{};
  final allPegsById = <String, TransItem>{};
  // Cached version of allTxs and allPegs
  final _allAssets = <AccountAsset, List<TxItem>>{};
  var _allAssetsNeedUpdate = false;

  var _allAccounts = <AccountAsset>[];
  var _allAccountsNeedUpdate = false;

  var _allTxsSorted = <TransItem>[];
  var _allTxsSortedNeedUpdate = false;

  var _allNewTxsSorted = <TransItem>[];
  var _allNewTxsSortedNeedUpdate = false;

  final newTransItemSubject = BehaviorSubject<TransItem>();
  StreamSubscription<TransItem>? txDetailsSubscription;

  final serverConnection = BehaviorSubject<bool>.seeded(false);

  final _recvSubject = PublishSubject<From>();
  StreamSubscription<From>? _recvSubscription;

  String? ampId;

  var syncComplete = false;

  var isCreatingTx = false;
  var isSendingTx = false;

  // Toggle assets page
  var filteredToggleAccounts = <AccountAsset>[];

  var pendingPushMessages = <String>[];

  var clientReady = false;

  late TransItem txDetails;

  final _txMemoUpdates = <String, String>{};
  String _currentTxMemoUpdate = '';

  bool settingsBiometricAvailable = false;

  OrderDetailsData orderDetailsData = OrderDetailsData.empty();
  PublishSubject<String> explorerUrlSubject = PublishSubject<String>();

  SwapDetails? swapDetails;
  bool swapPromptWaitingTx = false;

  PublishSubject<PinData> pinEncryptDataSubject = PublishSubject<PinData>();
  PublishSubject<PinDecryptedData> pinDecryptDataSubject =
      PublishSubject<PinDecryptedData>();

  var jades = <From_JadePorts_Port>[];

  void sendMsg(To to) {
    if (kDebugMode) {
      logger.d('send: $to');
    }
    if (_client == 0) {
      throw ErrorDescription('client is not initialized');
    }
    final buf = to.writeToBuffer();
    // final pointer = allocate<ffi.Uint8>(count: buf.length);
    final pointer = calloc<ffi.Uint8>(buf.length);
    for (var i = 0; i < buf.length; i++) {
      pointer[i] = buf[i];
    }
    Lib.lib.sideswap_send_request(_client, pointer.cast(), buf.length);
    calloc.free(pointer);
  }

  WalletChangeNotifier(this.ref);

  late ReceivePort _receivePort;
  StreamSubscription<dynamic>? _receivePortSubscription;

  Future<void> startClient() async {
    logger.d('startClient');

    _recvSubscription?.cancel();
    _receivePortSubscription?.cancel();

    _recvSubscription = _recvSubject.listen((value) async {
      await _recvMsg(value);
    });

    final storeDartPostCObject = Lib.dynLib
        .lookupFunction<DartPostCObject, DartPostCObject>(
            'store_dart_post_cobject');
    storeDartPostCObject(ffi.NativeApi.postCObject);

    _receivePort = ReceivePort();

    final env = ref.read(configProvider).env;

    final workDir = await getApplicationSupportDirectory();
    final workPath = workDir.absolute.path.toNativeUtf8();

    _client = Lib.lib.sideswap_client_start(env, workPath.cast(),
        appVersionFull.toNativeUtf8().cast(), _receivePort.sendPort.nativePort);

    await _addBtcAsset();

    _receivePortSubscription = _receivePort.listen((dynamic msgPtr) async {
      final ptr = Lib.lib.sideswap_msg_ptr(msgPtr as int);
      final len = Lib.lib.sideswap_msg_len(msgPtr);
      final msg = From.fromBuffer(ptr.asTypedList(len));
      Lib.lib.sideswap_msg_free(msgPtr);
      _recvSubject.add(msg);
    });

    clientReady = true;
    processPendingPushMessages();

    final config = ref.read(configProvider);
    final appResetRequired = await _encryption.appResetRequired(
        hasEncryptedMnemonic: config.mnemonicEncrypted.isNotEmpty,
        usePinProtection: config.usePinProtection);
    if (appResetRequired) {
      config.deleteConfig();
    }

    if (config.mnemonicEncrypted.isNotEmpty) {
      if (await _encryption.canAuthenticate() &&
          config.useBiometricProtection) {
        status = Status.lockedWalet;
      } else {
        await unlockWallet();
      }
    } else {
      if (config.usePinProtection) {
        await unlockWallet();
      } else {
        status = Status.noWallet;
        notifyListeners();
      }
    }

    // Initiate wallet unlock after startup
    if (status == Status.lockedWalet) {
      await unlockWallet();
    }

    await commonPlatform.firebaseRefreshToken(ref);
  }

  @override
  void notifyListeners() {
    logger.d('notifyListeners()');
    super.notifyListeners();
  }

  void _addTxItem(Map<AccountAsset, List<TxItem>> list, AccountType account,
      String assetId, TransItem item) {
    final accountAsset = AccountAsset(account, assetId);
    if (list[accountAsset] == null) {
      list[accountAsset] = [];
    }
    list[accountAsset]!.add(TxItem(item: item));
  }

  List<AccountAsset> getAllAccounts() {
    if (_allAccountsNeedUpdate) {
      // Use array to show registered on the server assets first
      final newList = <AccountAsset>[];
      newList.add(AccountAsset(AccountType.reg, liquidAssetId()));
      //newList.add(AccountAsset(AccountType.amp, liquidAssetId()));
      for (final asset in assets.values) {
        if (asset.swapMarket) {
          newList.add(AccountAsset(AccountType.reg, asset.assetId));
        } else if (asset.ampMarket) {
          newList.add(AccountAsset(AccountType.amp, asset.assetId));
        }
      }
      final remainingAccounts =
          getAllAssets().keys.toSet().difference(newList.toSet());
      for (final account in remainingAccounts) {
        newList.add(account);
      }
      _allAccounts = newList;
      _allAccountsNeedUpdate = false;
    }
    return _allAccounts;
  }

  List<TransItem> getAllTxsSorted() {
    if (_allTxsSortedNeedUpdate) {
      _allTxsSorted = allTxs.values.toList()..addAll(allPegsById.values);
      _allTxsSorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      _allTxsSortedNeedUpdate = false;
    }
    return _allTxsSorted;
  }

  List<TransItem> getAllNewTxsSorted() {
    if (_allNewTxsSortedNeedUpdate) {
      _allNewTxsSorted = allTxs.values.where((e) => e.hasConfs()).toList()
        ..addAll(allPegsById.values.where((e) => e.hasConfs()));
      _allNewTxsSorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      _allNewTxsSortedNeedUpdate = false;
    }
    return _allNewTxsSorted;
  }

  Map<AccountAsset, List<TxItem>> getAllAssets() {
    if (_allAssetsNeedUpdate) {
      final list = <AccountAsset, List<TxItem>>{};

      for (final item in allTxs.values) {
        final tx = item.tx;
        for (final balance in tx.balances) {
          final account = getAccountType(item.account);
          _addTxItem(list, account, balance.assetId, item);
        }
      }

      for (final order in allPegs.entries) {
        for (final item in order.value) {
          _addTxItem(list, AccountType.reg, liquidAssetId(), item);
        }
      }

      _allAssets.clear();
      final dateFormat = DateFormat('yyyy-MM-dd');
      for (var item in list.entries) {
        item.value.sort((a, b) => b.compareTo(a));

        final tempAssets = <TxItem>[];
        for (var item in item.value) {
          if (tempAssets.isEmpty) {
            tempAssets.add(item.copyWith(showDate: true));
          } else {
            final last = DateTime.parse(dateFormat.format(
                DateTime.fromMillisecondsSinceEpoch(
                    tempAssets.last.createdAt)));
            final current = DateTime.parse(dateFormat
                .format(DateTime.fromMillisecondsSinceEpoch(item.createdAt)));
            final diff = last.difference(current).inDays;
            tempAssets.add(item.copyWith(showDate: diff != 0));
          }
        }

        _allAssetsNeedUpdate = false;
        _allAssets[item.key] = tempAssets;
      }
    }
    return _allAssets;
  }

  void refreshTxs() {
    _allAssetsNeedUpdate = true;
    _allAccountsNeedUpdate = true;
    _allTxsSortedNeedUpdate = true;
    _allNewTxsSortedNeedUpdate = true;
    notifyListeners();
  }

  void updateTxs(From_UpdatedTxs txs) {
    for (final item in txs.items) {
      allTxs[item.id] = item;
      newTransItemSubject.add(item);
    }
    refreshTxs();
  }

  void removedTxs(From_RemovedTxs txs) {
    for (final txid in txs.txids) {
      allTxs.remove(txid);
    }
    refreshTxs();
  }

  void updatePegs(From_UpdatedPegs pegs) {
    allPegs[pegs.orderId] = pegs.items;
    for (final item in pegs.items) {
      newTransItemSubject.add(item);
      allPegsById[item.id] = item;
    }
    refreshTxs();
  }

  Future<void> _recvMsg(From from) async {
    if (kDebugMode) {
      logger.d('recv: $from');
    }
    // Process message here
    switch (from.whichMsg()) {
      case From_Msg.envSettings:
        _liquidAssetId = from.envSettings.policyAssetId;
        _tetherAssetId = from.envSettings.usdtAssetId;
        _eurxAssetId = from.envSettings.eurxAssetId;
        _liquidAssetId = from.envSettings.policyAssetId;
        AccountAsset.liquidAssetId = _liquidAssetId;
        defaultAccounts.add(AccountAsset(AccountType.reg, _liquidAssetId));
        break;
      case From_Msg.updatedTxs:
        updateTxs(from.updatedTxs);
        break;
      case From_Msg.removedTxs:
        removedTxs(from.removedTxs);
        break;
      case From_Msg.updatedPegs:
        updatePegs(from.updatedPegs);
        break;
      case From_Msg.newAsset:
        final assetIcon = base64Decode(from.newAsset.icon);
        _addAsset(from.newAsset, assetIcon);
        break;
      case From_Msg.ampAssets:
        ampAssets = from.ampAssets.assets;
        notifyListeners();
        break;
      case From_Msg.balanceUpdate:
        ref.read(balancesProvider.notifier).updateBalances(from.balanceUpdate);
        notifyListeners();
        break;

      case From_Msg.swapFailed:
        logger.w('Swap failed: ${from.swapFailed}');
        ref.read(swapNetworkErrorStateProvider.notifier).state =
            from.swapFailed;
        notifyListeners();
        await ref.read(utilsProvider).showErrorDialog(from.swapFailed);
        if (status == Status.swapPrompt) {
          status = Status.registered;
          notifyListeners();
        }
        break;

      case From_Msg.swapSucceed:
        var txItem = from.swapSucceed;
        showSwapTxDetails(txItem);
        ref.read(swapProvider).swapReset();
        ref.read(swapProvider).clearAmounts();
        break;

      case From_Msg.pegOutAmount:
        ref.read(swapProvider).onPegOutAmountReceived(from.pegOutAmount);
        break;

      case From_Msg.peginWaitTx:
        ref.read(swapProvider).swapPegAddressServer = from.peginWaitTx.pegAddr;
        ref.read(swapProvider).swapRecvAddressExternal =
            from.peginWaitTx.recvAddr;
        ref.read(swapStateProvider.notifier).state = SwapState.idle;
        if (!FlavorConfig.isDesktop) {
          status = Status.swapWaitPegTx;
          notifyListeners();
        } else {
          desktopWaitPegin(navigatorKey.currentContext!);
        }
        break;

      case From_Msg.recvAddress:
        final accountType = getAccountType(from.recvAddress.account);
        recvAddresses[accountType] = from.recvAddress.addr.addr;
        notifyListeners();
        break;

      case From_Msg.createTxResult:
        isCreatingTx = false;
        switch (from.createTxResult.whichResult()) {
          case From_CreateTxResult_Result.errorMsg:
            await ref
                .read(utilsProvider)
                .showErrorDialog(from.createTxResult.errorMsg);
            break;
          case From_CreateTxResult_Result.createdTx:
            ref.read(paymentProvider).createdTx = from.createTxResult.createdTx;
            if (!FlavorConfig.isDesktop) {
              status = Status.paymentSend;
            }
            break;
          case From_CreateTxResult_Result.notSet:
            throw Exception('invalid send result message');
        }
        notifyListeners();
        break;

      case From_Msg.sendResult:
        isSendingTx = false;
        if (!FlavorConfig.isDesktop) {
          status = Status.assetDetails;
        }
        switch (from.sendResult.whichResult()) {
          case From_SendResult_Result.errorMsg:
            await ref.read(utilsProvider).showErrorDialog(
                from.sendResult.errorMsg,
                buttonText: 'CONTINUE'.tr());
            notifyListeners();
            break;
          case From_SendResult_Result.txItem:
            var item = from.sendResult.txItem;
            if (!FlavorConfig.isDesktop) {
              showTxDetails(item);
            } else {
              desktopShowTx(navigatorKey.currentContext!, item.id,
                  isPeg: allPegsById.containsKey(item.id));
            }
            break;
          case From_SendResult_Result.notSet:
            throw Exception('invalid send result message');
        }
        notifyListeners();
        break;

      case From_Msg.blindedValues:
        switch (from.blindedValues.whichResult()) {
          case From_BlindedValues_Result.errorMsg:
            await ref.read(utilsProvider).showErrorDialog(
                from.blindedValues.errorMsg,
                buttonText: 'CONTINUE'.tr());
            break;
          case From_BlindedValues_Result.blindedValues:
            final url = generateTxidUrl(
              from.blindedValues.txid,
              true,
              blindedValues: from.blindedValues.blindedValues,
              testnet: isTestnet(),
            );
            explorerUrlSubject.add(url);
            break;
          case From_BlindedValues_Result.notSet:
            throw Exception('invalid blinded values message');
        }
        break;

      case From_Msg.serverStatus:
        _serverStatus = from.serverStatus;
        notifyListeners();
        // Refresh peg-out amounts
        ref
            .read(priceStreamSubscribeChangeNotifierProvider)
            .subscribeToPriceStream();
        break;

      case From_Msg.priceUpdate:
        final oldPrice = _prices[from.priceUpdate.asset];
        final newPrice = from.priceUpdate;
        if (oldPrice == null ||
            oldPrice.ask != newPrice.ask ||
            oldPrice.bid != newPrice.bid) {
          _prices[from.priceUpdate.asset] = from.priceUpdate;
          notifyListeners();
        }
        break;

      case From_Msg.registerPhone:
        switch (from.registerPhone.whichResult()) {
          case From_RegisterPhone_Result.phoneKey:
            var phoneKey = From_RegisterPhone_Result.phoneKey;
            logger.d('got phone key: $phoneKey');
            await ref
                .read(phoneProvider)
                .receivedRegisterState(phoneKey: from.registerPhone.phoneKey);
            break;
          case From_RegisterPhone_Result.errorMsg:
            var errorMsg = From_RegisterPhone_Result.errorMsg;
            logger.d('registration failed: $errorMsg');
            await ref
                .read(phoneProvider)
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
            ref.read(phoneProvider).receivedVerifyState();
            break;
          case From_VerifyPhone_Result.errorMsg:
            var errorMsg = From_VerifyPhone_Result.errorMsg;
            logger.d('verification failed: $errorMsg');
            ref
                .read(phoneProvider)
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
          ref.read(contactProvider).onDone();
        } else {
          ref
              .read(contactProvider)
              .onError(error: from.uploadContacts.errorMsg);
        }
        break;

      case From_Msg.showMessage:
        await ref.read(utilsProvider).showErrorDialog(from.showMessage.text,
            buttonText: 'CONTINUE'.tr());
        break;

      case From_Msg.insufficientFunds:
        await ref
            .read(utilsProvider)
            .showInsufficienFunds(from.insufficientFunds);
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
          await ref.read(configProvider).setPinData(pinData);
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

      case From_Msg.submitReview:
        final sellBitcoin = from.submitReview.sellBitcoin;

        var orderType = OrderDetailsDataType.submit;
        switch (from.submitReview.step) {
          case From_SubmitReview_Step.SUBMIT:
            orderType = OrderDetailsDataType.submit;
            break;
          case From_SubmitReview_Step.QUOTE:
            orderType = OrderDetailsDataType.quote;
            break;
          case From_SubmitReview_Step.SIGN:
            orderType = OrderDetailsDataType.sign;
            break;
        }

        final fromSr = from.submitReview;

        final assetAmount = fromSr.assetAmount;
        final assetId = fromSr.asset;
        final bitcoinAmount = fromSr.bitcoinAmount;
        final assetPrecision = getPrecisionForAssetId(assetId: assetId);
        const bitcoinPrecision = 8;
        final orderId = fromSr.orderId;
        final indexPrice = from.submitReview.indexPrice;
        const autoSign = true;
        final asset = assets[fromSr.asset]!;

        orderDetailsData = OrderDetailsData(
          bitcoinAmount: bitcoinAmount.toInt(),
          bitcoinPrecision: bitcoinPrecision,
          priceAmount: fromSr.price,
          assetAmount: assetAmount.toInt(),
          assetPrecision: assetPrecision,
          assetId: assetId,
          orderId: orderId,
          orderType: orderType,
          sellBitcoin: sellBitcoin,
          fee: from.submitReview.serverFee.toInt(),
          isTracking: indexPrice,
          autoSign: autoSign,
          marketType: getMarketType(asset),
          twoStep: fromSr.twoStep,
          txChainingRequired: fromSr.txChainingRequired,
        );
        if (orderType == OrderDetailsDataType.quote ||
            orderType == OrderDetailsDataType.sign) {
          await setOrder();
        } else {
          setCreateOrder();
        }
        break;

      case From_Msg.submitResult:
        switch (from.submitResult.whichResult()) {
          case From_SubmitResult_Result.submitSucceed:
            if (!orderDetailsData.accept) {
              return;
            }

            if (orderDetailsData.orderType == OrderDetailsDataType.submit) {
              setRegistered();
            } else if (orderDetailsData.orderType ==
                OrderDetailsDataType.quote) {
              setResponseSuccess();
            } else if (orderDetailsData.orderType ==
                OrderDetailsDataType.sign) {
              setRegistered();
            }
            break;

          case From_SubmitResult_Result.swapSucceed:
            var txItem = from.submitResult.swapSucceed;
            showSwapTxDetails(txItem);
            break;

          case From_SubmitResult_Result.error:
          case From_SubmitResult_Result.unregisteredGaid:
            if (FlavorConfig.isDesktop) {
              desktopClosePopups(navigatorKey.currentContext!);
            }
            if (from.submitResult.whichResult() ==
                From_SubmitResult_Result.error) {
              final errorText =
                  from.submitResult.error == 'id_insufficient_funds'
                      ? 'Insufficient LBTC in AMP wallet'.tr()
                      : from.submitResult.error;
              await ref
                  .read(utilsProvider)
                  .showErrorDialog(errorText, buttonText: 'CONTINUE'.tr());
            } else {
              await ref
                  .read(utilsProvider)
                  .showUnregisteredGaid(from.submitResult.unregisteredGaid);
            }
            setRegistered();
            break;
          case From_SubmitResult_Result.notSet:
            throw Exception('invalid SubmitResult message');
        }
        break;

      case From_Msg.walletLoaded:
        setRegistered();

        // check initial deep link
        // process links before login request for loading screen to work properly
        final initialUri = ref.read(universalLinkProvider).initialUri;
        if (initialUri != null) {
          logger.d('Initial uri found: $initialUri');
          ref.read(universalLinkProvider).handleAppUri(initialUri);
        }
        break;

      case From_Msg.syncComplete:
        syncComplete = true;
        notifyListeners();
        break;

      case From_Msg.contactCreated:
        // TODO: Handle this case.
        break;
      case From_Msg.contactRemoved:
        // TODO: Handle this case.
        break;
      case From_Msg.contactTransaction:
        // TODO: Handle this case.
        break;
      case From_Msg.accountStatus:
        if (!from.accountStatus.registered) {
          removePhoneKey();
        }
        // TODO: Handle this case.
        break;
      case From_Msg.editOrder:
        if (!from.editOrder.success) {
          ref.read(utilsProvider).showErrorDialog(from.editOrder.errorMsg,
              buttonText: 'CLOSE'.tr());
        }
        break;
      case From_Msg.cancelOrder:
        if (!from.cancelOrder.success) {
          ref.read(utilsProvider).showErrorDialog(from.cancelOrder.errorMsg,
              buttonText: 'CLOSE'.tr());
        }
        break;
      case From_Msg.serverConnected:
        serverConnection.add(true);
        break;
      case From_Msg.serverDisconnected:
        serverConnection.add(false);
        ref.read(marketsProvider).clearOrders();
        break;
      case From_Msg.orderCreated:
        final oc = from.orderCreated;
        final sendBitcoins = !oc.order.sendBitcoins;
        var price = oc.order.price;
        final asset = assets[oc.order.assetId]!;

        final order = RequestOrder(
          orderId: oc.order.orderId,
          assetId: oc.order.assetId,
          bitcoinAmount: oc.order.bitcoinAmount.toInt(),
          serverFee: oc.order.serverFee.toInt(),
          assetAmount: oc.order.assetAmount.toInt(),
          price: price,
          createdAt: oc.order.createdAt.toInt(),
          expiresAt:
              oc.order.hasExpiresAt() ? oc.order.expiresAt.toInt() : null,
          private: oc.order.private,
          sendBitcoins: sendBitcoins,
          twoStep: oc.order.twoStep,
          autoSign: oc.order.autoSign,
          own: oc.order.own,
          isNew: oc.new_2,
          indexPrice: oc.order.indexPrice,
          marketType: getMarketType(asset),
        );

        if (order.isNew && order.own) {
          final assetPrecision = getPrecisionForAssetId(assetId: order.assetId);
          orderDetailsData =
              OrderDetailsData.fromRequestOrder(order, assetPrecision);
          setCreateOrderSuccess();
        }

        ref.read(marketsProvider).insertOrder(order);

        break;
      case From_Msg.orderRemoved:
        ref.read(marketsProvider).removeOrder(from.orderRemoved.orderId);
        break;
      case From_Msg.orderComplete:
        // Used with headless client only
        break;

      case From_Msg.notSet:
        throw Exception('invalid empty message');

      case From_Msg.indexPrice:
        final ticker = ref
            .read(requestOrderProvider)
            .tickerForAssetId(from.indexPrice.assetId);
        logger.d(
            'INDEX PRICE: ${ticker.isEmpty ? from.indexPrice.assetId : ticker} ${from.indexPrice.ind}');
        ref.read(marketsProvider).setIndexLastPrice(
              from.indexPrice.assetId,
              from.indexPrice.hasInd() ? from.indexPrice.ind : null,
              from.indexPrice.hasLast() ? from.indexPrice.last : null,
            );
        break;
      case From_Msg.assetDetails:
        logger.d("Asset details: ${from.assetDetails}");
        final assetDetailsData = AssetDetailsData(
          assetId: from.assetDetails.assetId,
          stats: from.assetDetails.hasStats()
              ? AssetDetailsStats(
                  issuedAmount: from.assetDetails.stats.issuedAmount.toInt(),
                  burnedAmount: from.assetDetails.stats.burnedAmount.toInt(),
                  offlineAmount: from.assetDetails.stats.offlineAmount.toInt(),
                  hasBlindedIssuances:
                      from.assetDetails.stats.hasBlindedIssuances,
                )
              : null,
          chartUrl: from.assetDetails.hasChartUrl()
              ? from.assetDetails.chartUrl
              : null,
          chartStats: from.assetDetails.hasChartStats()
              ? AssetChartStats(
                  high: from.assetDetails.chartStats.high,
                  low: from.assetDetails.chartStats.low,
                  last: from.assetDetails.chartStats.last,
                )
              : null,
        );
        ref.read(tokenMarketProvider).insertAssetDetails(assetDetailsData);
        break;
      case From_Msg.updatePriceStream:
        _processSubscribeUpdate(from.updatePriceStream);
        break;
      case From_Msg.registerAmp:
        _processRegisterAmpResult(from.registerAmp);
        break;
      case From_Msg.localMessage:
        ref
            .read(localNotificationsProvider)
            .showNotification(from.localMessage.title, from.localMessage.body);
        break;
      case From_Msg.marketDataSubscribe:
        ref
            .read(marketDataProvider)
            .marketDataResponse(from.marketDataSubscribe);
        break;
      case From_Msg.marketDataUpdate:
        ref.read(marketDataProvider).marketDataUpdate(from.marketDataUpdate);
        break;
      case From_Msg.utxoUpdate:
        // Not used.
        break;

      case From_Msg.jadePorts:
        jades = from.jadePorts.ports.toList();
        final connected =
            jades.any((jade) => jade.state == From_JadePorts_State.CONNECTED);
        if (connected) {
          desktopClosePopups(navigatorKey.currentContext!);
          status = Status.walletLoading;
          loggedIn = true;
        }
        notifyListeners();
        break;
      case From_Msg.logout:
        logoutComplete();
        break;
    }
  }

  void openTxUrl(String txid, bool isLiquid, bool unblinded) {
    if (!isLiquid || !unblinded) {
      final url = generateTxidUrl(
        txid,
        isLiquid,
        testnet: isTestnet(),
      );
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
    bitcoinAsset.assetId = bitcoinAssetId();
    bitcoinAsset.ticker = kBitcoinTicker;
    bitcoinAsset.precision = kDefaultPrecision;
    final icon = await BitmapHelper.getPngBufferFromSvgAsset(
        'assets/btc_logo.svg', 75, 75);
    _addAsset(bitcoinAsset, icon);
  }

  void _addAsset(Asset asset, Uint8List assetIcon) {
    if (assets[asset.assetId] == null) {
      assetsList.add(asset.assetId);
    }
    if (asset.swapMarket) {
      defaultAccounts.add(AccountAsset(AccountType.reg, asset.assetId));
    }
    if (asset.ampMarket) {
      defaultAccounts.add(AccountAsset(AccountType.amp, asset.assetId));
    }
    // Always update asset here as they might change
    // (amp_market could be set if server is down when app is started).
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
    assetImagesVerySmall[asset.assetId] = Image.memory(
      assetIcon,
      width: 20,
      height: 20,
      filterQuality: FilterQuality.high,
    );
    ref.read(swapProvider).checkSelectedAsset();
    // Make sure that new fixed accounts are added
    _allAccountsNeedUpdate = true;
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

  int? parseAssetAmount(String value, {required int precision}) {
    if (precision < 0 || precision > 8) {
      return null;
    }

    final newValue = value.replaceAll(' ', '');
    final amount = Decimal.tryParse(newValue);

    if (amount == null) {
      return null;
    }

    final amountDec = amount * Decimal.fromInt(pow(10, precision).toInt());

    final amountInt = amountDec.toInt();

    if (Decimal.fromInt(amountInt) != amountDec) {
      return null;
    }

    return amountInt;
  }

  int getSatoshiForAmount(String asset, String value) {
    final precision = getPrecisionForAssetId(assetId: asset);
    final amount = parseAssetAmount(value, precision: precision) ?? 0;
    return amount;
  }

  String getNewMnemonic() {
    final mnemonicPtr = Lib.lib.sideswap_generate_mnemonic12();
    final mnemonic = mnemonicPtr.cast<Utf8>().toDartString();
    Lib.lib.sideswap_string_free(mnemonicPtr);
    return mnemonic;
  }

  bool validateMnemonic(String mnemonic) {
    if (mnemonic.isEmpty) {
      return false;
    }

    return Lib.lib.sideswap_verify_mnemonic(mnemonic.toNativeUtf8().cast());
  }

  List<String> getMnemonicWords() {
    return _mnemonic.split(' ');
  }

  Future<void> setReviewLicenseCreateWallet() async {
    walletImporting = false;
    if (ref.read(configProvider).licenseAccepted) {
      if (await _encryption.canAuthenticate()) {
        await newWalletBiometricPrompt();
        return;
      }

      setNewWalletPinWelcome();
    } else {
      status = Status.reviewLicenseCreateWallet;
    }
    notifyListeners();
  }

  void setReviewLicenseImportWallet() {
    walletImporting = true;
    if (ref.read(configProvider).licenseAccepted) {
      startMnemonicImport();
    } else {
      status = Status.reviewLicenseImportWallet;
    }
    notifyListeners();
  }

  Future<void> setLicenseAccepted() async {
    await ref.read(configProvider).setLicenseAccepted(true);
    notifyListeners();
  }

  Future<void> newWalletBiometricPrompt() async {
    assert(ref.read(configProvider).licenseAccepted == true);
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
    assert(status == Status.importWallet ||
        status == Status.importWalletSuccess ||
        status == Status.newWalletPinWelcome);

    _mnemonic = mnemonic;

    if (FlavorConfig.isDesktop) {
      ref.read(pinSetupProvider).isNewWallet = true;
      status = Status.newWalletPinWelcome;
      notifyListeners();
      return;
    }

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
    if (_mnemonic.isEmpty) {
      logger.e('Mnemonic is empty!');
      return false;
    }

    if (enableBiometric) {
      await ref
          .read(configProvider)
          .setMnemonicEncrypted(await _encryption.encryptBiometric(_mnemonic));

      if (ref.read(configProvider).mnemonicEncrypted.isEmpty) {
        return false;
      }
      await ref.read(configProvider).setUseBiometricProtection(true);
      await ref.read(configProvider).setUsePinProtection(false);
    } else {
      await ref
          .read(configProvider)
          .setMnemonicEncrypted(await _encryption.encryptFallback(_mnemonic));
      // Should not happen, something is very wrong
      if (ref.read(configProvider).mnemonicEncrypted.isEmpty) {
        return false;
      }

      await ref.read(configProvider).setUseBiometricProtection(false);
    }

    return true;
  }

  void loginAndLoadMainPage() {
    _login(_mnemonic);
    ref.read(swapProvider).checkSelectedAsset();
  }

  Future<void> acceptLicense() async {
    await ref.read(configProvider).setLicenseAccepted(true);
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
      final selectedWordIndex = backupCheckSelectedWords[wordIndex];
      if (selectedWordIndex == null) {
        return false;
      }

      final wordList = backupCheckAllWords[wordIndex];
      if (wordList == null) {
        return false;
      }

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
      case Status.createOrderSuccess:
        return false;

      case Status.confirmPhone:
        status = Status.associatePhoneWelcome;
        break;
      case Status.assetsSelect:
        status = Status.registered;
        break;
      case Status.assetDetails:
        status = Status.registered;
        final uiStateArgs = ref.read(uiStateArgsProvider);
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
        final uiStateArgs = ref.read(uiStateArgsProvider);
        uiStateArgs.walletMainArguments =
            uiStateArgs.walletMainArguments.copyWith(
          currentIndex: 1,
          navigationItem: WalletMainNavigationItem.assetDetails,
        );
        break;
      case Status.swapTxDetails:
      case Status.assetReceiveFromWalletMain:
      case Status.orderSuccess:
      case Status.orderResponseSuccess:
        status = Status.registered;
        final uiStateArgs = ref.read(uiStateArgsProvider);
        uiStateArgs.walletMainArguments =
            uiStateArgs.walletMainArguments.copyWith(
          currentIndex: 0,
          navigationItem: WalletMainNavigationItem.home,
        );

        break;
      case Status.orderPopup:
      case Status.swapPrompt:
        status = Status.registered;
        break;
      case Status.swapWaitPegTx:
        final uiStateArgs = ref.read(uiStateArgsProvider);
        uiStateArgs.walletMainArguments =
            uiStateArgs.walletMainArguments.copyWith(
          currentIndex: 0,
          navigationItem: WalletMainNavigationItem.home,
        );
        ref.read(swapProvider).pegStop();
        break;
      case Status.settingsBackup:
      case Status.settingsSecurity:
      case Status.settingsAboutUs:
      case Status.settingsUserDetails:
      case Status.settingsNetwork:
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
      case Status.walletLoading:
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
      case Status.createOrderEntry:
      case Status.orderRequestView:
        status = Status.registered;
        break;
      case Status.createOrder:
        status = Status.createOrderEntry;
        break;
    }

    notifyListeners();
    return false;
  }

  void _login(String mnemonic) {
    final config = ref.read(configProvider);

    final msg = To();
    msg.login = To_Login();
    msg.login.mnemonic = mnemonic;
    msg.login.network = getNetworkSettings();
    msg.login.desktop = FlavorConfig.isDesktop;

    if (config.phoneKey.isNotEmpty) {
      msg.login.phoneKey = config.phoneKey;
    }

    sendMsg(msg);

    loadSettings();

    status = Status.walletLoading;
    loggedIn = true;
    notifyListeners();
  }

  Future<void> _logout() async {
    final msg = To();
    msg.logout = Empty();
    sendMsg(msg);

    resetSettings();

    loggedIn = false;
  }

  void selectAssetDetails(AccountAsset value) {
    status = Status.assetDetails;
    selectedWalletAsset = value;
    notifyListeners();
  }

  void selectAssetReceive(AccountType accountType) {
    recvAddresses.clear();
    recvAddressAccount = accountType;
    toggleRecvAddrType(accountType);

    status = Status.assetReceive;

    final uiStateArgs = ref.read(uiStateArgsProvider);
    uiStateArgs.walletMainArguments = uiStateArgs.walletMainArguments
        .copyWith(navigationItem: WalletMainNavigationItem.homeAssetReceive);

    notifyListeners();
  }

  void startAssetReceiveAddr() {
    recvAddresses.clear();
    recvAddressAccount = AccountType.reg;
    toggleRecvAddrType(AccountType.reg);
  }

  void selectAssetReceiveFromWalletMain() {
    startAssetReceiveAddr();

    status = Status.assetReceiveFromWalletMain;

    final uiStateArgs = ref.read(uiStateArgsProvider);
    uiStateArgs.walletMainArguments = uiStateArgs.walletMainArguments
        .copyWith(navigationItem: WalletMainNavigationItem.homeAssetReceive);

    notifyListeners();
  }

  void toggleRecvAddrType(AccountType accountType) {
    if (recvAddresses[accountType] == null) {
      final msg = To();
      msg.getRecvAddress = getAccount(accountType);
      sendMsg(msg);
    }
    recvAddressAccount = accountType;
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
    if (!FlavorConfig.isDesktop) {
      status = Status.swapTxDetails;
      txDetails = tx;

      _listenTxDetailsChanges();

      notifyListeners();
    } else {
      desktopShowTx(navigatorKey.currentContext!, tx.id,
          isPeg: allPegsById.containsKey(tx.id));
    }
  }

  void _listenTxDetailsChanges() {
    txDetailsSubscription?.cancel();
    txDetailsSubscription = newTransItemSubject.listen((value) {
      if (value.id == txDetails.id) {
        // FIXME: Check that correct account is used here
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
  }

  bool isAddrValid(String addr, AddrType addrType) {
    if (addr.isEmpty || _client == 0) {
      return false;
    }

    final addrPtr = addr.toNativeUtf8();
    return Lib.lib.sideswap_check_addr(
        _client, addrPtr.cast(), convertAddrType(addrType));
  }

  String commonAddrErrorStr(String addr, AddrType addrType) {
    if (addr.isEmpty) {
      return addr;
    }

    return isAddrValid(addr, addrType) ? '' : 'Invalid address'.tr();
  }

  String elementsAddrErrorStr(String addr) {
    return commonAddrErrorStr(addr, AddrType.elements);
  }

  String bitcoinAddrErrorStr(String addr) {
    return commonAddrErrorStr(addr, AddrType.bitcoin);
  }

  void createTx(CreateTx createTx) {
    final msg = To();
    msg.createTx = createTx;
    sendMsg(msg);
    isCreatingTx = true;
    notifyListeners();
  }

  void assetSendConfirmMobile() {
    assetSendConfirmCommon(getAccount(selectedWalletAsset!.account));
  }

  void assetSendConfirmCommon(Account account) {
    final msg = To();
    msg.sendTx = To_SendTx();
    msg.sendTx.account = account;
    sendMsg(msg);
    isSendingTx = true;
    notifyListeners();
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
    final filteredToggleAccountsNew = <AccountAsset>[];
    for (final account in getAllAccounts()) {
      final asset = assets[account.asset]!;
      if (_showAsset(asset, filterLowerCase)) {
        filteredToggleAccountsNew.add(account);
      }
    }
    if (!listEquals(filteredToggleAccountsNew, filteredToggleAccounts)) {
      filteredToggleAccounts = filteredToggleAccountsNew;
      notifyListeners();
    }
  }

  bool disabledAssetAccount(AccountAsset account) {
    return disabledAccounts.contains(account);
  }

  void loadSettings() {
    var settings = Settings();
    final settingsStr = ref.read(configProvider).settings;
    if (settingsStr != null) {
      settings = Settings.fromJson(settingsStr);
    }
    disabledAccounts.clear();
    for (final v in settings.disabledAccounts) {
      disabledAccounts.add(AccountAsset(getAccountType(v.account), v.assetId));
    }
  }

  Future<void> saveSettings() async {
    final settings = Settings();
    for (var v in disabledAccounts) {
      settings.disabledAccounts.add(Settings_AccountAsset(
          account: getAccount(v.account), assetId: v.asset));
    }
    await ref.read(configProvider).setSettings(settings.writeToJson());
  }

  Future<void> resetSettings() async {
    await ref.read(configProvider).clearSettings();
    loadSettings();
  }

  Future<void> toggleAssetVisibility(AccountAsset account) async {
    if (disabledAssetAccount(account)) {
      disabledAccounts.remove(account);
    } else {
      disabledAccounts.add(account);
    }
    await saveSettings();
    notifyListeners();
  }

  void editTxMemo(Object arguments) {
    status = Status.txEditMemo;
    notifyListeners();
  }

  String txMemo(Tx? tx) {
    if (tx == null) {
      return '';
    }

    final updatedMemo = _txMemoUpdates[tx.txid];
    if (updatedMemo != null) {
      return updatedMemo;
    }
    return tx.memo;
  }

  void onTxMemoChanged(String value) {
    _currentTxMemoUpdate = value;
  }

  void _applyTxMemoChange() {
    final txid = txDetails.tx.txid;
    _txMemoUpdates[txid] = _currentTxMemoUpdate;

    var msg = To();
    msg.setMemo = To_SetMemo();
    // FIXME: Use correct account type here
    msg.setMemo.account = getAccount(AccountType.reg);
    msg.setMemo.txid = txid;
    msg.setMemo.memo = _currentTxMemoUpdate;
    sendMsg(msg);
  }

  Future<void> settingsViewBackup() async {
    if (ref.read(configProvider).usePinProtection) {
      if (await ref.read(pinProtectionProvider).pinBlockadeUnlocked()) {
        status = Status.settingsBackup;
        notifyListeners();
        return;
      }

      return;
    }

    final mnemonic = ref.read(configProvider).useBiometricProtection
        ? await _encryption
            .decryptBiometric(ref.read(configProvider).mnemonicEncrypted)
        : await _encryption
            .decryptFallback(ref.read(configProvider).mnemonicEncrypted);
    if (mnemonic == _mnemonic && validateMnemonic(mnemonic)) {
      status = Status.settingsBackup;
      notifyListeners();
    }
  }

  void settingsUserDetails() {
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

  void settingsNetwork() {
    status = Status.settingsNetwork;
    notifyListeners();
  }

  Future<void> settingsViewSecurity() async {
    settingsBiometricAvailable = await _encryption.canAuthenticate();
    status = Status.settingsSecurity;
    notifyListeners();
  }

  Future<bool> isBiometricAvailable() async {
    settingsBiometricAvailable = await _encryption.canAuthenticate();
    return settingsBiometricAvailable;
  }

  Future<void> settingsDeletePromptConfirm() async {
    if (FlavorConfig.isDesktop) {
      Navigator.of(navigatorKey.currentContext!, rootNavigator: true)
          .popUntil((route) => route.isFirst);
      Navigator.of(navigatorKey.currentContext!)
          .popUntil((route) => route.isFirst);
    }
    if (loggedIn) {
      unregisterPhone();
      await _logout();
      status = Status.loading;
      notifyListeners();
    } else {
      await logoutComplete();
    }
  }

  Future<void> logoutComplete() async {
    await ref.read(configProvider).deleteConfig();
    ref.read(balancesProvider.notifier).clear();
    ref.read(uiStateArgsProvider).clear();
    ref.read(phoneProvider).clearData();
    ref.read(pinProtectionProvider).reset();
    allTxs.clear();
    allPegs.clear();
    allPegsById.clear();
    refreshTxs();
    status = Status.noWallet;
    ampId = null;
    notifyListeners();
  }

  Future<void> unlockWallet() async {
    if (ref.read(configProvider).usePinProtection) {
      if (await ref
          .read(pinProtectionProvider)
          .pinBlockadeUnlocked(showBackButton: false)) {
        _login(_mnemonic);
        return;
      }

      status = Status.lockedWalet;
      notifyListeners();
      return;
    }

    if (ref.read(configProvider).useBiometricProtection) {
      _mnemonic = await _encryption
          .decryptBiometric(ref.read(configProvider).mnemonicEncrypted);
    } else {
      _mnemonic = await _encryption
          .decryptFallback(ref.read(configProvider).mnemonicEncrypted);
    }
    if (validateMnemonic(_mnemonic)) {
      _login(_mnemonic);
    } else {
      // TODO: Show error
      status = Status.lockedWalet;
    }

    notifyListeners();
  }

  Future<void> settingsEnableBiometric() async {
    final mnemonic = await _encryption
        .decryptFallback(ref.read(configProvider).mnemonicEncrypted);

    if (mnemonic.isEmpty) {
      return;
    }

    final mnemonicEncrypted = await _encryption.encryptBiometric(mnemonic);
    if (mnemonicEncrypted.isEmpty) {
      return;
    }

    await ref.read(configProvider).setMnemonicEncrypted(mnemonicEncrypted);
    _mnemonic = mnemonic;
    await ref.read(configProvider).setUseBiometricProtection(true);
    notifyListeners();
  }

  Future<void> settingsDisableBiometric() async {
    final mnemonic = await _encryption
        .decryptBiometric(ref.read(configProvider).mnemonicEncrypted);
    if (mnemonic.isEmpty) {
      return;
    }

    final mnemonicEncrypted = await _encryption.encryptFallback(mnemonic);
    if (mnemonicEncrypted.isEmpty) {
      return;
    }

    await ref.read(configProvider).setMnemonicEncrypted(mnemonicEncrypted);
    _mnemonic = mnemonic;
    await ref.read(configProvider).setUseBiometricProtection(false);
    notifyListeners();
  }

  int env() {
    return ref.read(configProvider).env;
  }

  Future<void> setEnv(int e, {bool restart = true}) async {
    if (ref.read(configProvider).env == e) {
      status = Status.noWallet;
      notifyListeners();
      return;
    }

    await ref.read(configProvider).setEnv(e);

    if (restart) {
      exit(0);
    }
  }

  void selectEnv() {
    assert(status == Status.noWallet);
    status = Status.selectEnv;
    notifyListeners();
  }

  Future<bool> isAuthenticated() async {
    if (ref.read(configProvider).usePinProtection) {
      return ref.read(pinProtectionProvider).pinBlockadeUnlocked();
    }

    if (ref.read(configProvider).useBiometricProtection) {
      _mnemonic = await _encryption
          .decryptBiometric(ref.read(configProvider).mnemonicEncrypted);
    } else {
      final mnemonicEncrypted = ref.read(configProvider).mnemonicEncrypted;
      // Temporary workaround for Jade
      if (mnemonicEncrypted.isEmpty) {
        return true;
      }
      _mnemonic = await _encryption.decryptFallback(mnemonicEncrypted);
    }

    if (validateMnemonic(_mnemonic)) {
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
      loginAndLoadMainPage();
    }
  }

  void setRegistered() {
    logger.d('REGISTERED');
    status = Status.registered;
    notifyListeners();
  }

  void updatePushToken(String? token) {
    if (token == null) {
      return;
    }

    var msg = To();
    msg.updatePushToken = To_UpdatePushToken();
    msg.updatePushToken.token = token;
    sendMsg(msg);
  }

  double _getPriceBitcoin(String? assetId) {
    if (assetId == liquidAssetId()) {
      return 1;
    }
    final price = _prices[assetId];
    if (price == null) {
      return 0;
    }
    return (price.bid + price.ask) / 2;
  }

  double _getPrice(String? priceNum, String priceDen) {
    final internalPriceNum = _getPriceBitcoin(priceNum);
    final internalPriceDen = _getPriceBitcoin(priceDen);
    if (internalPriceDen == 0 || internalPriceNum == 0) {
      return 0;
    }
    return internalPriceNum / internalPriceDen;
  }

  double _getPriceUsd(String assetId) {
    return _getPrice(tetherAssetId(), assetId);
  }

  double getAmountUsd(String? assetId, num amount) {
    if (assetId == null) {
      return 0;
    }

    return amount * _getPriceUsd(assetId);
  }

  bool isAmountUsdAvailable(String? assetId) {
    if (assetId == liquidAssetId()) {
      return true;
    }

    if (_prices[assetId] != null) {
      return true;
    }

    return false;
  }

  Asset? getAssetById(String assetId) {
    for (var asset in assets.values) {
      if (asset.assetId == assetId) {
        return asset;
      }
    }
    return null;
  }

  final _bitcoinAssetId =
      '0000000000000000000000000000000000000000000000000000000000000000';
  String bitcoinAssetId() => _bitcoinAssetId;

  late String _liquidAssetId;
  String liquidAssetId() => _liquidAssetId;

  late String _tetherAssetId;
  String tetherAssetId() => _tetherAssetId;

  late String _eurxAssetId;
  String eurxAssetId() => _eurxAssetId;

  List<AccountAsset> sendAssets() {
    return sendAssetsWithBalance();
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

  Future<void> setOrder() async {
    if (FlavorConfig.isDesktop) {
      desktopOrderReview(
        navigatorKey.currentContext!,
        orderDetailsData.orderType == OrderDetailsDataType.sign
            ? ReviewScreen.sign
            : ReviewScreen.quote,
      );
      return;
    }

    status = Status.registered;
    notifyListeners();

    Future.microtask(() {
      status = Status.orderPopup;
      notifyListeners();

      final instance = WidgetsBinding.instance;
      if (orderDetailsData.orderType == OrderDetailsDataType.sign &&
          instance.lifecycleState == AppLifecycleState.resumed) {
        unawaited(FlutterRingtonePlayer.playNotification());
        unawaited(Vibration.vibrate());
      }
    });
  }

  void setSubmitDecision({
    required bool autosign,
    bool twoStep = false,
    bool accept = false,
    bool private = true,
    int ttlSeconds = kOneWeek,
    bool allowTxChaining = false,
  }) {
    orderDetailsData =
        orderDetailsData.copyWith(accept: accept, private: private);
    if (orderDetailsData.orderId.isEmpty) {
      return;
    }

    final msg = To();
    msg.submitDecision = To_SubmitDecision();
    msg.submitDecision.orderId = orderDetailsData.orderId;
    msg.submitDecision.accept = accept;
    msg.submitDecision.autoSign = autosign;
    msg.submitDecision.twoStep = twoStep;
    msg.submitDecision.private = orderDetailsData.private;
    msg.submitDecision.ttlSeconds = Int64(ttlSeconds);
    msg.submitDecision.txChainingAllowed = allowTxChaining;
    sendMsg(msg);
  }

  void setOrderSuccess() {
    status = Status.orderSuccess;
    notifyListeners();
  }

  void setResponseSuccess() {
    status = Status.orderResponseSuccess;
    notifyListeners();
  }

  void submitOrder(
    String assetId,
    double amount,
    double price, {
    bool isAssetAmount = false,
    double? indexPrice,
    AccountType account = const AccountType(0),
  }) {
    final msg = To();
    msg.submitOrder = To_SubmitOrder();
    msg.submitOrder.assetId = assetId;

    if (isAssetAmount) {
      msg.submitOrder.assetAmount = amount;
    } else {
      msg.submitOrder.bitcoinAmount = amount;
    }
    msg.submitOrder.price = price;

    if (indexPrice != null) {
      msg.submitOrder.indexPrice = indexPrice;
    }
    msg.submitOrder.account = getAccount(account);

    sendMsg(msg);
  }

  void linkOrder(String? orderId) {
    if (orderId == null || orderId.isEmpty) {
      return;
    }

    final msg = To();
    msg.linkOrder = To_LinkOrder();
    msg.linkOrder.orderId = orderId;
    sendMsg(msg);
  }

  void uploadDeviceContacts(To_UploadContacts uploadContacts) {
    uploadContacts.phoneKey = ref.read(configProvider).phoneKey;
    final msg = To();
    msg.uploadContacts = uploadContacts;
    sendMsg(msg);
  }

  void uploadAvatar({required String avatar}) {
    final uploadAvatar = To_UploadAvatar();
    uploadAvatar.phoneKey = ref.read(configProvider).phoneKey;
    uploadAvatar.image = avatar;

    final msg = To();
    msg.uploadAvatar = uploadAvatar;
    sendMsg(msg);
  }

  void setNewWalletPinWelcome() {
    _mnemonic = getNewMnemonic();
    ref.read(pinSetupProvider).isNewWallet = true;
    status = Status.newWalletPinWelcome;
    notifyListeners();
  }

  Future<void> setPinWelcome() async {
    if (await _encryption.canAuthenticate()) {
      await setImportWalletBiometricPrompt();
      return;
    }
    status = Status.pinWelcome;
    notifyListeners();
  }

  void setPinSetup() {
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
    final pinData = ref.read(configProvider).pinData;

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
    if (!ref.read(configProvider).usePinProtection) {
      // already disabled
      return true;
    }

    final pinDecryptedSubscription =
        pinDecryptDataSubject.listen((pinDecryptedData) async {
      if (pinDecryptedData.success) {
        // turn off pin and save encrypted mnemonic
        await ref.read(configProvider).setUsePinProtection(false);
        notifyListeners();

        await ref.read(configProvider).setMnemonicEncrypted(
            await _encryption.encryptFallback(pinDecryptedData.mnemonic));
      }
    });

    final ret = await ref.read(pinProtectionProvider).pinBlockadeUnlocked(
        iconType: PinKeyboardAcceptType.disable,
        title: 'Disable PIN protection'.tr());
    await pinDecryptedSubscription.cancel();

    return ret;
  }

  Future<void> enablePinProtection() async {
    await ref.read(configProvider).setUsePinProtection(true);
    notifyListeners();
  }

  int getPrecisionForAssetId({String? assetId}) {
    if (assetId == null) {
      return 8;
    }

    return assets[assetId]?.precision ?? 8;
  }

  void processPendingPushMessages() {
    // Delay processing until client is started.
    // Fix "Unhandled Exception: client is not initialized" error
    // openning push notification when app is stopped.
    if (!clientReady) {
      return;
    }

    for (final details in pendingPushMessages) {
      final msg = To();
      msg.pushMessage = details;
      sendMsg(msg);
    }
    pendingPushMessages.clear();
  }

  void gotPushMessage(String details) {
    logger.d('got push notification: $details');
    pendingPushMessages.add(details);
    processPendingPushMessages();
  }

  void minimizeApp() {
    if (Platform.isAndroid) {
      unawaited(MoveToBackground.moveTaskToBack());
    }
  }

  void setCreateOrderEntry() {
    ref.read(requestOrderProvider).validateDeliverAsset();
    status = Status.createOrderEntry;
    notifyListeners();
  }

  void setCreateOrder() {
    if (FlavorConfig.isDesktop) {
      desktopOrderReview(
          navigatorKey.currentContext!, ReviewScreen.submitStart);
      return;
    }

    status = Status.createOrder;
    notifyListeners();
  }

  void setCreateOrderSuccess() {
    if (FlavorConfig.isDesktop) {
      if (orderDetailsData.private) {
        desktopOrderReview(
            navigatorKey.currentContext!, ReviewScreen.submitSucceed);
      } else {
        desktopClosePopups(navigatorKey.currentContext!);
      }
      return;
    }

    status = Status.createOrderSuccess;
    notifyListeners();
  }

  void unregisterPhone() {
    final phoneKey = ref.read(configProvider).phoneKey;
    if (phoneKey.isNotEmpty) {
      var msg = To();
      msg.unregisterPhone = To_UnregisterPhone();
      msg.unregisterPhone.phoneKey = phoneKey;
      sendMsg(msg);

      removePhoneKey();
    }
  }

  void removePhoneKey() {
    ref.read(configProvider).setPhoneKey('');
    ref.read(configProvider).setPhoneNumber('');
  }

  void cancelOrder(String orderId) {
    final msg = To();
    msg.cancelOrder = To_CancelOrder();
    msg.cancelOrder.orderId = orderId;
    sendMsg(msg);
  }

  void modifyOrderPrice(
    String orderId, {
    double? price,
    double? indexPrice,
  }) {
    orderDetailsData = OrderDetailsData.empty();
    final msg = To();
    msg.editOrder = To_EditOrder();
    msg.editOrder.orderId = orderId;

    if (indexPrice != null) {
      msg.editOrder.indexPrice = indexPrice;
    }

    if (price != null) {
      msg.editOrder.price = price;
    }

    sendMsg(msg);
  }

  void modifyOrderAutoSign(String orderId, bool autoSign) {
    orderDetailsData = OrderDetailsData.empty();
    final msg = To();
    msg.editOrder = To_EditOrder();
    msg.editOrder.orderId = orderId;
    msg.editOrder.autoSign = autoSign;
    sendMsg(msg);
  }

  List<AccountAsset> sendAssetsWithBalance() {
    final allAssets = ref
        .read(balancesProvider)
        .balances
        .entries
        .where((e) => e.value > 0)
        .map((e) => e.key)
        .toList();
    if (allAssets.isEmpty) {
      return [AccountAsset(AccountType.reg, liquidAssetId())];
    }
    return allAssets;
  }

  void setOrderRequestView(RequestOrder requestOrder) {
    ref.read(requestOrderProvider).currentRequestOrderView = requestOrder;

    if (FlavorConfig.isDesktop) {
      final orderAsset = assets[requestOrder.assetId]!;
      orderDetailsData =
          OrderDetailsData.fromRequestOrder(requestOrder, orderAsset.precision);
      notifyListeners();
      desktopOrderReview(navigatorKey.currentContext!, ReviewScreen.edit);
      return;
    }

    status = Status.orderRequestView;
    notifyListeners();
  }

  String? subscribedAsset;
  bool? subscribedSendBitcoins;
  int? subscribedSendAmount;
  int? subscribedRecvAmount;

  final updatePriceStream = PublishSubject<From_UpdatePriceStream>();

  void _resetSubscribedData() {
    subscribedAsset = null;
    subscribedSendBitcoins = null;
    subscribedSendAmount = null;
    subscribedRecvAmount = null;
  }

  void _processSubscribeUpdate(From_UpdatePriceStream msg) {
    // Ignore old updates
    final subscribedSendAmountCopy = subscribedSendAmount;
    final subscribedRecvAmountCopy = subscribedRecvAmount;
    if (msg.assetId != subscribedAsset ||
        msg.sendBitcoins != subscribedSendBitcoins) {
      return;
    }

    // Ignore old updates
    final expectedPriceMsg = subscribedSendAmount == null &&
        subscribedRecvAmount == null &&
        !msg.hasSendAmount() &&
        !msg.hasRecvAmount();
    final expectedSendAmountMsg = subscribedSendAmountCopy != null &&
        subscribedSendAmountCopy.toInt() == msg.sendAmount.toInt();
    final expectedRecvAmountMsg = subscribedRecvAmountCopy != null &&
        subscribedRecvAmountCopy.toInt() == msg.recvAmount.toInt();

    if (expectedPriceMsg || expectedSendAmountMsg || expectedRecvAmountMsg) {
      updatePriceStream.add(msg);
    }
  }

  void subscribeToPriceStream(
    String asset,
    bool sendBitcoins,
    int? sendAmount,
    int? recvAmount,
  ) {
    assert(asset.isNotEmpty);
    _resetSubscribedData();

    subscribedAsset = asset;
    subscribedSendBitcoins = sendBitcoins;
    subscribedSendAmount = sendAmount;
    subscribedRecvAmount = recvAmount;

    final msg = To();
    msg.subscribePriceStream = To_SubscribePriceStream();
    msg.subscribePriceStream.assetId = asset;
    msg.subscribePriceStream.sendBitcoins = sendBitcoins;
    if (sendAmount != null && sendAmount != 0) {
      msg.subscribePriceStream.sendAmount = Int64(sendAmount);
    }
    if (recvAmount != null && recvAmount != 0) {
      msg.subscribePriceStream.recvAmount = Int64(recvAmount);
    }
    sendMsg(msg);
  }

  void unsubscribeFromPriceStream() {
    if (subscribedAsset != null) {
      final msg = To();
      msg.unsubscribePriceStream = Empty();
      sendMsg(msg);

      _resetSubscribedData();
    }
  }

  void verifySwap(SwapDetails swap) {
    if (swap.sendAmount <= 0) {
      throw ErrorDescription('Invalid send amount: $swap.sendAmount');
    }
    if (swap.recvAmount <= 0) {
      throw ErrorDescription('Invalid recv amount: $swap.recvAmount');
    }
    if (swap.orderId.isEmpty) {
      throw ErrorDescription('Order ID is empty');
    }
    if (swap.uploadUrl.isEmpty) {
      throw ErrorDescription('Upload URL is empty');
    }
    if (swap.sendAsset == swap.recvAsset) {
      throw ErrorDescription('Swap assets are same');
    }
    if (assets[swap.sendAsset] == null) {
      throw ErrorDescription('Asset is not known: $swap.sendAsset');
    }
    if (assets[swap.recvAsset] == null) {
      throw ErrorDescription('Asset is not known: $swap.recvAsset');
    }
  }

  void startSwapPrompt(SwapDetails swap) {
    verifySwap(swap);
    swapDetails = swap;
    swapPromptWaitingTx = false;
    status = Status.swapPrompt;
    notifyListeners();
  }

  void swapReviewAccept() {
    swapPromptWaitingTx = true;
    status = Status.swapPrompt;
    notifyListeners();

    final msg = To();
    msg.swapAccept = swapDetails!;
    sendMsg(msg);
  }

  void getPegOutAmount(
    int? sendAmount,
    int? recvAmount,
    double feeRate,
    AccountType accountType,
  ) {
    assert((sendAmount == null) != (recvAmount == null));
    final msg = To();
    msg.pegOutAmount = To_PegOutAmount();
    msg.pegOutAmount.feeRate = feeRate;
    msg.pegOutAmount.isSendEntered = sendAmount != null;
    msg.pegOutAmount.amount =
        sendAmount != null ? Int64(sendAmount) : Int64(recvAmount!);
    msg.pegOutAmount.account = getAccount(accountType);
    sendMsg(msg);
  }

  Future<void> _processRegisterAmpResult(From_RegisterAmp msg) async {
    switch (msg.whichResult()) {
      case From_RegisterAmp_Result.ampId:
        ampId = msg.ampId;
        break;
      case From_RegisterAmp_Result.errorMsg:
        await ref.read(utilsProvider).showErrorDialog(msg.errorMsg);
        break;
      case From_RegisterAmp_Result.notSet:
        assert(false);
    }
    notifyListeners();
  }

  void handleAppStateChange(AppLifecycleState state) {
    bool active = state == AppLifecycleState.resumed;
    bool paused = state == AppLifecycleState.paused;
    if (active || paused) {
      final msg = To();
      msg.appState = To_AppState();
      msg.appState.active = active;
      sendMsg(msg);
    }
  }

  NetworkSettings getNetworkSettings() {
    final config = ref.read(configProvider);
    final network = NetworkSettings();
    switch (config.settingsNetworkType) {
      case SettingsNetworkType.blockstream:
        network.blockstream = Empty();
        break;
      case SettingsNetworkType.sideswap:
        network.sideswap = Empty();
        break;
      case SettingsNetworkType.custom:
        network.custom = NetworkSettings_Custom();
        network.custom.host = config.settingsHost;
        network.custom.port = config.settingsPort;
        network.custom.useTls = config.settingsUseTLS;
        break;
    }
    return network;
  }

  void applyNetworkChange() {
    final msg = To();
    msg.changeNetwork = To_ChangeNetwork();
    msg.changeNetwork.network = getNetworkSettings();
    sendMsg(msg);
  }

  bool isTestnet() {
    return env() == SIDESWAP_ENV_TESTNET || env() == SIDESWAP_ENV_LOCAL_TESTNET;
  }

  void jadeLogin(String port) {
    final msg = To();
    msg.jadeLogin = To_JadeLogin();
    msg.jadeLogin.port = port;
    sendMsg(msg);
  }
}
