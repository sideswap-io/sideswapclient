import 'dart:async';
import 'dart:convert';
import 'dart:ffi' as ffi;
import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

import 'package:decimal/decimal.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ffi/ffi.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pedantic/pedantic.dart';
import 'package:rxdart/subjects.dart';
import 'package:sideswap/models/balances_provider.dart';
import 'package:sideswap/models/markets_provider.dart';
import 'package:sideswap/models/request_order_provider.dart';
import 'package:sideswap/models/token_market_provider.dart';
import 'package:vibration/vibration.dart';
import 'package:move_to_background/move_to_background.dart';

import 'package:sideswap/common/bitmap_helper.dart';
import 'package:sideswap/common/encryption.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/utils/custom_logger.dart';
import 'package:sideswap/common/utils/decimal_text_input_formatter.dart';
import 'package:sideswap/common/widgets/insufficient_balance_dialog.dart';
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

  createOrderEntry,
  createOrder,
  createOrderSuccess,
  orderRequestView,
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

  PinData({
    this.salt = '',
    this.encryptedData = '',
    this.pinIdentifier = '',
    this.error = '',
  });

  @override
  String toString() {
    return 'PinData(salt: $salt, encryptedData: $encryptedData, pinIdentifier: $pinIdentifier, error: $error)';
  }
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
  return WalletChangeNotifier(ref.read);
});

class WalletChangeNotifier with ChangeNotifier {
  final Reader read;
  int _client = 0;

  final _encryption = Encryption();

  String _mnemonic = '';
  final enabledAssetIds = <String>[];

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

  String selectedWalletAsset = '';
  String recvAddress = '';

  Map<int, List<String>> backupCheckAllWords = {};
  Map<int, int> backupCheckSelectedWords = {};

  final _assetIds = <String>[];
  var assets = <String, Asset>{};
  var assetImagesBig = <String, Image>{};
  var assetImagesSmall = <String, Image>{};

  final allTxs = <String, TransItem>{};
  final newTransItemSubject = BehaviorSubject<TransItem>();
  StreamSubscription<TransItem>? txDetailsSubscription;

  final serverConnection = BehaviorSubject<bool>();

  final _recvSubject = PublishSubject<From>();

  // Cached version of allTxs
  final allAssets = <String, List<TxItem>>{};
  Map<String, List<TxItem>> txItemMap = {};

  // Toggle assets page
  var filteredToggleAssetIds = <String>[];

  var pendingPushMessages = <String>[];

  var clientReady = false;

  late TransItem txDetails;

  final _txMemoUpdates = <String, String>{};
  String _currentTxMemoUpdate = '';

  bool settingsBiometricAvailable = false;

  OrderDetailsData orderDetailsData = OrderDetailsData.empty();
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
    // final pointer = allocate<ffi.Uint8>(count: buf.length);
    final pointer = calloc<ffi.Uint8>(buf.length);
    for (var i = 0; i < buf.length; i++) {
      pointer[i] = buf[i];
    }
    Lib.lib.sideswap_send_request(_client, pointer.cast(), buf.length);
    calloc.free(pointer);
  }

  WalletChangeNotifier(this.read);

  late ReceivePort _receivePort;

  Future<void> startClient() async {
    _recvSubject.listen((value) async {
      await _recvMsg(value);
    });

    final storeDartPostCObject = Lib.dynLib
        .lookupFunction<DartPostCObject, DartPostCObject>(
            'store_dart_post_cobject');
    storeDartPostCObject(ffi.NativeApi.postCObject);

    _receivePort = ReceivePort();

    final env = read(configProvider).env;

    final workDir = await getApplicationSupportDirectory();
    final workPath = workDir.absolute.path.toNativeUtf8();

    final packageInfo =
        !Platform.isLinux ? await PackageInfo.fromPlatform() : null;
    final version = packageInfo != null
        ? '${packageInfo.version}+${packageInfo.buildNumber}'
        : '';

    _client = Lib.lib.sideswap_client_start(env, workPath.cast(),
        version.toNativeUtf8().cast(), _receivePort.sendPort.nativePort);

    await _addBtcAsset();

    _receivePort.listen((dynamic msgPtr) async {
      final ptr = Lib.lib.sideswap_msg_ptr(msgPtr as int);
      final len = Lib.lib.sideswap_msg_len(msgPtr);
      final msg = From.fromBuffer(ptr.asTypedList(len));
      Lib.lib.sideswap_msg_free(msgPtr);
      _recvSubject.add(msg);
    });

    clientReady = true;
    processPendingPushMessages();

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

  @override
  void notifyListeners() {
    logger.d('notifyListeners()');
    super.notifyListeners();
  }

  void _addTxItem(TransItem item, String? assetId) {
    if (assetId == null) {
      logger.e('AssetId is null for txitem: $item');
      return;
    }

    if (allAssets[assetId] == null) {
      allAssets[assetId] = [];
    }
    allAssets[assetId]?.add(TxItem(item: item));
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
        read(balancesProvider.notifier).updateBalance(
            key: from.balanceUpdate.assetId,
            value: from.balanceUpdate.amount.toInt());
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
        await read(utilsProvider)
            .showErrorDialog(read(swapProvider).swapNetworkError);
        break;

      case From_Msg.swapSucceed:
        var txItem = from.swapSucceed;
        await addTxItem(txItem);
        showSwapTxDetails(txItem);
        read(swapProvider).swapReset();
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
            final balance = read(balancesProvider).balances[liquidAssetId()];
            if (selectedWalletAsset != liquidAssetId() && balance == 0) {
              showInsufficientBalanceDialog(
                  navigatorKey.currentContext, kLiquidBitcoinTicker);
            } else {
              await read(utilsProvider)
                  .showErrorDialog(from.createTxResult.errorMsg);
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
          from.blindedValues.txid,
          true,
          blindedValues: from.blindedValues.blindedValues,
        );
        explorerUrlSubject.add(url);
        break;

      case From_Msg.serverStatus:
        _serverStatus = from.serverStatus;
        // TODO: Allow pegs only after that
        notifyListeners();
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
        await read(utilsProvider).showErrorDialog(from.showMessage.text,
            buttonText: 'CONTINUE'.tr());
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

      case From_Msg.submitReview:
        final sellBitcoin = from.submitReview.sellBitcoin;

        var orderType = OrderDetailsDataType.submit;
        switch (from.submitReview.step) {
          case (From_SubmitReview_Step.SUBMIT):
            orderType = OrderDetailsDataType.submit;
            break;
          case (From_SubmitReview_Step.QUOTE):
            orderType = OrderDetailsDataType.quote;
            break;
          case (From_SubmitReview_Step.SIGN):
            orderType = OrderDetailsDataType.sign;
            break;
        }

        final fromSr = from.submitReview;

        if (!fromSr.internal) {
          read(requestOrderProvider).insertExternalOrder(fromSr.orderId);
        }

        final assetAmount = fromSr.assetAmount;
        final assetId = fromSr.asset;
        final bitcoinAmount = fromSr.bitcoinAmount;
        final assetPrecision = getPrecisionForAssetId(assetId: assetId);
        final bitcoinPrecision =
            getPrecisionForTicker(ticker: kLiquidBitcoinTicker);
        final orderId = fromSr.orderId;
        var price = fromSr.price;
        final serverFee = from.submitReview.serverFee;
        final fee = amountStr(from.submitReview.serverFee.toInt(),
            precision: bitcoinPrecision);
        final indexPrice = from.submitReview.indexPrice;
        const autoSign = true;

        final isToken = read(requestOrderProvider).isAssetToken(assetId);
        if (isToken) {
          price = bitcoinAmount.toInt() / assetAmount.toInt();
        }

        final priceStr = DecimalCutterTextInputFormatter(
          decimalRange: 2,
        )
            .formatEditUpdate(TextEditingValue(text: price.toString()),
                TextEditingValue(text: price.toString()))
            .text;

        orderDetailsData = OrderDetailsData(
          bitcoinAmount: amountStr(
              sellBitcoin
                  ? bitcoinAmount.toInt() + serverFee.toInt()
                  : bitcoinAmount.toInt() - serverFee.toInt(),
              precision: bitcoinPrecision),
          priceAmount: priceStr,
          assetAmount:
              amountStr(assetAmount.toInt(), precision: assetPrecision),
          assetId: assetId,
          orderId: orderId,
          orderType: orderType,
          sellBitcoin: sellBitcoin,
          fee: fee.toString(),
          isTracking: indexPrice,
          autoSign: autoSign,
        );

        if (read(requestOrderProvider).isOrderExternal(orderId) ||
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
            await addTxItem(txItem);
            showSwapTxDetails(txItem);
            break;

          case From_SubmitResult_Result.error:
            await read(utilsProvider).showErrorDialog(from.submitResult.error,
                buttonText: 'CONTINUE'.tr());
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
        final initialUri = read(universalLinkProvider).initialUri;
        if (initialUri != null) {
          logger.d('Initial uri found: $initialUri');
          read(universalLinkProvider).handleUri(initialUri);
        }

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
          read(utilsProvider).showErrorDialog(from.editOrder.errorMsg,
              buttonText: 'CLOSE'.tr());
        }
        break;
      case From_Msg.cancelOrder:
        if (!from.cancelOrder.success) {
          read(utilsProvider).showErrorDialog(from.cancelOrder.errorMsg,
              buttonText: 'CLOSE'.tr());
        }
        break;
      case From_Msg.serverConnected:
        serverConnection.add(true);
        break;
      case From_Msg.serverDisconnected:
        serverConnection.add(false);
        break;
      case From_Msg.orderCreated:
        final oc = from.orderCreated;
        final sendBitcoins = !oc.order.sendBitcoins;
        final isToken =
            read(requestOrderProvider).isAssetToken(oc.order.assetId);
        var price = oc.order.price;
        if (isToken) {
          price = oc.order.bitcoinAmount.toInt() / oc.order.assetAmount.toInt();
        }

        final order = RequestOrder(
          orderId: oc.order.orderId,
          assetId: oc.order.assetId,
          bitcoinAmount: sendBitcoins
              ? oc.order.bitcoinAmount.toInt() + oc.order.serverFee.toInt()
              : oc.order.bitcoinAmount.toInt() - oc.order.serverFee.toInt(),
          serverFee: oc.order.serverFee.toInt(),
          assetAmount: oc.order.assetAmount.toInt(),
          price: price,
          createdAt: oc.order.createdAt.toInt(),
          expiresAt: oc.order.expiresAt.toInt(),
          private: oc.order.private,
          sendBitcoins: sendBitcoins,
          autoSign: oc.order.autoSign,
          own: oc.order.own,
          tokenMarket: oc.order.tokenMarket,
          isNew: oc.order.new_14,
          indexPrice: oc.order.indexPrice,
        );

        if (order.isNew && order.own) {
          orderDetailsData = OrderDetailsData.fromRequestOrder(order, read);
          read(walletProvider).setCreateOrderSuccess();
        }

        read(marketsProvider).insertOrder(order);

        break;
      case From_Msg.orderRemoved:
        read(marketsProvider).removeOrder(from.orderRemoved.orderId);
        break;

      case From_Msg.notSet:
        throw Exception('invalid empty message');
      case From_Msg.indexPrice:
        final ticker = read(requestOrderProvider)
            .tickerForAssetId(from.indexPrice.assetId);
        logger.d(
            'INDEX PRICE: ${ticker.isEmpty ? from.indexPrice.assetId : ticker} ${from.indexPrice.ind}');
        read(marketsProvider)
            .setIndexPrice(from.indexPrice.assetId, from.indexPrice.ind);
        break;
      case From_Msg.assetDetails:
        logger.d("Asset details: ${from.assetDetails}");
        final hasStats = from.assetDetails.hasStats();
        final assetDetailsData = AssetDetailsData(
          assetId: from.assetDetails.assetId,
          stats: hasStats
              ? AssetDetailsStats(
                  issuedAmount: from.assetDetails.stats.issuedAmount.toInt(),
                  burnedAmount: from.assetDetails.stats.burnedAmount.toInt(),
                  hasBlindedIssuances:
                      from.assetDetails.stats.hasBlindedIssuances,
                )
              : null,
        );
        read(tokenMarketProvider).insertAssetDetails(assetDetailsData);
        break;
    }
  }

  void openTxUrl(String txid, bool isLiquid, bool unblinded) {
    if (!isLiquid || !unblinded) {
      final url = generateTxidUrl(txid, isLiquid);
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
      if (asset.ticker == kEurxTicker) {
        _eurxAssetId = asset.assetId;
      }
      updateEnabledAssetIds();
    }
    // Make sure we don't have null values
    if (read(balancesProvider).balances[asset.assetId] == null) {
      read(balancesProvider.notifier)
          .updateBalance(key: asset.assetId, value: 0);
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
    return _mnemonic.split(' ');
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
    if (_mnemonic.isEmpty) {
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
      if (read(configProvider).mnemonicEncrypted.isEmpty) {
        return false;
      }

      await read(configProvider).setUseBiometricProtection(false);
    }

    return true;
  }

  Future<void> loginAndLoadMainPage() async {
    _login(_mnemonic);
    read(swapProvider).checkSelectedAsset();
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
      case Status.orderSuccess:
      case Status.orderResponseSuccess:
        status = Status.registered;
        final uiStateArgs = read(uiStateArgsProvider);
        uiStateArgs.walletMainArguments =
            uiStateArgs.walletMainArguments.copyWith(
          currentIndex: 0,
          navigationItem: WalletMainNavigationItem.home,
        );

        break;
      case Status.orderPopup:
        status = Status.registered;
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
    final msg = To();
    msg.login = To_Login();
    msg.login.mnemonic = mnemonic;
    if (read(configProvider).phoneKey.isNotEmpty) {
      msg.login.phoneKey = read(configProvider).phoneKey;
    }
    sendMsg(msg);

    status = Status.walletLoading;
    notifyListeners();
  }

  void _logout() {
    read(balancesProvider.notifier).clear();
    read(swapProvider).swapSendAsset = '';
    read(swapProvider).swapRecvAsset = '';

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
    recvAddress = '';

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
      final asset = assets[assetId];
      if (asset == null) {
        continue;
      }

      if (_showAsset(asset, filterLowerCase)) {
        filteredToggleAssetIdsNew.add(assetId);
      }
    }
    if (!listEquals(filteredToggleAssetIdsNew, filteredToggleAssetIds)) {
      filteredToggleAssetIds = filteredToggleAssetIdsNew;
      notifyListeners();
    }
  }

  Future<void> toggleAssetVisibility(String? assetId) async {
    if (assetId == null) {
      return;
    }

    final disableAssetIds = read(configProvider).disabledAssetIds;
    if (disableAssetIds.contains(assetId)) {
      disableAssetIds.remove(assetId);
    } else {
      disableAssetIds.add(assetId);
    }
    await read(configProvider).setDisabledAssetIds(disableAssetIds);
    updateEnabledAssetIds();
  }

  void editTxMemo(Object arguments) {
    status = Status.txEditMemo;
    _currentTxMemoUpdate;
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
    msg.setMemo.txid = txid;
    msg.setMemo.memo = _currentTxMemoUpdate;
    sendMsg(msg);

    _currentTxMemoUpdate;
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
    if (mnemonic == _mnemonic && validateMnemonic(mnemonic)) {
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

  void settingsNetwork() {
    status = Status.settingsNetwork;
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
    unregisterPhone();
    _logout();
    await read(configProvider).deleteConfig();
    read(phoneProvider).clearData();
    allTxs.clear();
    refreshTxs();
    status = Status.noWallet;
    notifyListeners();
  }

  Future<void> unlockWallet() async {
    if (read(configProvider).usePinProtection) {
      if (await read(pinProtectionProvider).pinBlockadeUnlocked()) {
        _login(_mnemonic);
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
        .decryptFallback(read(configProvider).mnemonicEncrypted);

    if (mnemonic.isEmpty) {
      return;
    }

    final mnemonicEncrypted = await _encryption.encryptBiometric(mnemonic);
    if (mnemonicEncrypted.isEmpty) {
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
    if (mnemonic.isEmpty) {
      return;
    }

    final mnemonicEncrypted = await _encryption.encryptFallback(mnemonic);
    if (mnemonicEncrypted.isEmpty) {
      return;
    }

    await read(configProvider).setMnemonicEncrypted(mnemonicEncrypted);
    _mnemonic = mnemonic;
    await read(configProvider).setUseBiometricProtection(false);
    notifyListeners();
  }

  Future<void> buildTxList(Map<String, List<TxItem>> value) async {
    final _dateFormat = DateFormat('yyyy-MM-dd');

    for (var key in value.keys) {
      final listItems = value[key];
      if (listItems != null) {
        value[key] = listItems..sort((a, b) => b.compareTo(a));

        final tempAssets = <TxItem>[];
        for (var item in listItems) {
          if (tempAssets.isEmpty) {
            tempAssets.add(item.copyWith(showDate: true));
          } else {
            final last = DateTime.parse(_dateFormat.format(
                DateTime.fromMillisecondsSinceEpoch(
                    tempAssets.last.createdAt)));
            final current = DateTime.parse(_dateFormat
                .format(DateTime.fromMillisecondsSinceEpoch(item.createdAt)));
            final diff = last.difference(current).inDays;
            tempAssets.add(item.copyWith(showDate: diff != 0));
          }
        }

        value[key] = tempAssets;
      }
    }

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
      await loginAndLoadMainPage();
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
    final _priceNum = _getPriceBitcoin(priceNum);
    final _priceDen = _getPriceBitcoin(priceDen);
    if (_priceDen == 0 || _priceNum == 0) {
      return 0;
    }
    return _priceNum / _priceDen;
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

  Asset? getAssetByTicker(String ticker) {
    for (var asset in assets.values) {
      if (asset.ticker == ticker) {
        return asset;
      }
    }
    return null;
  }

  Asset? getAssetById(String assetId) {
    for (var asset in assets.values) {
      if (asset.assetId == assetId) {
        return asset;
      }
    }
    return null;
  }

  String? _liquidAssetId;
  String? liquidAssetId() {
    return _liquidAssetId;
  }

  String? _bitcoinAssetId;
  String? bitcoinAssetId() {
    return _bitcoinAssetId;
  }

  String? _tetherAssetId;
  String? tetherAssetId() {
    return _tetherAssetId;
  }

  String? _eurxAssetId;
  String? eurxAssetId() {
    return _eurxAssetId;
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

  Future<void> setOrder() async {
    status = Status.registered;
    notifyListeners();

    Future.microtask(() {
      status = Status.orderPopup;
      notifyListeners();

      final instance = WidgetsBinding.instance;
      if (orderDetailsData.orderType == OrderDetailsDataType.sign &&
          instance != null &&
          instance.lifecycleState == AppLifecycleState.resumed) {
        unawaited(FlutterRingtonePlayer.playNotification());
        unawaited(Vibration.vibrate());
      }
    });
  }

  void setSubmitDecision({
    required bool autosign,
    bool accept = false,
    bool private = true,
    int ttlSeconds = kTenMinutes,
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
    msg.submitDecision.private = orderDetailsData.private;
    msg.submitDecision.ttlSeconds = Int64(ttlSeconds);
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
    String? sessionId,
    double? indexPrice,
  }) {
    final msg = To();
    msg.submitOrder = To_SubmitOrder();
    if (sessionId != null) {
      msg.submitOrder.sessionId = sessionId;
    }
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

    sendMsg(msg);
  }

  void linkOrder(String? orderId) {
    if (orderId == null || orderId.isEmpty) {
      return;
    }

    read(requestOrderProvider).insertExternalOrder(orderId);

    final msg = To();
    msg.linkOrder = To_LinkOrder();
    msg.linkOrder.orderId = orderId;
    sendMsg(msg);
  }

  void uploadDeviceContacts(To_UploadContacts uploadContacts) {
    uploadContacts.phoneKey = read(configProvider).phoneKey;
    final msg = To();
    msg.uploadContacts = uploadContacts;
    sendMsg(msg);
  }

  void uploadAvatar({required String avatar}) {
    final uploadAvatar = To_UploadAvatar();
    uploadAvatar.phoneKey = read(configProvider).phoneKey;
    uploadAvatar.image = avatar;

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

  Future<void> setPinWelcome() async {
    if (await _encryption.canAuthenticate()) {
      await setImportWalletBiometricPrompt();
      return;
    }
    status = Status.pinWelcome;
    notifyListeners();
  }

  void setPinSetup({
    required void Function(BuildContext context) onSuccessCallback,
    required void Function(BuildContext context) onBackCallback,
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
    if (!read(configProvider).usePinProtection) {
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
    await pinDecryptedSubscription.cancel();

    return ret;
  }

  Future<void> enablePinProtection() async {
    await read(configProvider).setUsePinProtection(true);
    notifyListeners();
  }

  int getPrecisionForAssetId({String? assetId}) {
    if (assetId == null) {
      return 8;
    }

    return assets[assetId]?.precision ?? 8;
  }

  int getPrecisionForTicker({String ticker = ''}) {
    var precision = 8;
    try {
      final asset =
          assets.values.firstWhere((e) => e.ticker == kLiquidBitcoinTicker);
      precision = asset.precision;
    } on StateError {
      logger.w('Cant set precision for ticker: $ticker');
    }

    return precision;
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
    status = Status.createOrderEntry;
    notifyListeners();
  }

  void setCreateOrder() {
    status = Status.createOrder;
    notifyListeners();
  }

  void setCreateOrderSuccess() {
    status = Status.createOrderSuccess;
    notifyListeners();
  }

  void unregisterPhone() {
    final phoneKey = read(configProvider).phoneKey;
    if (phoneKey.isNotEmpty) {
      var msg = To();
      msg.unregisterPhone = To_UnregisterPhone();
      msg.unregisterPhone.phoneKey = phoneKey;
      sendMsg(msg);

      removePhoneKey();
    }
  }

  void removePhoneKey() {
    read(configProvider).setPhoneKey('');
    read(configProvider).setPhoneNumber('');
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

  void setOrderRequestView(RequestOrder requestOrder) {
    read(requestOrderProvider).currentRequestOrderView = requestOrder;
    status = Status.orderRequestView;
    notifyListeners();
  }
}
