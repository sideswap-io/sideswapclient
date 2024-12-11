import 'dart:async';
import 'dart:convert';
import 'dart:ffi' as ffi;
import 'dart:isolate';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:ffi/ffi.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/subjects.dart';
import 'package:sideswap/app_version.dart';
import 'package:sideswap/common/enums.dart';
import 'package:sideswap/common/utils/market_helpers.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/desktop/main/d_order_review.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/models/connection_models.dart';
import 'package:sideswap/models/jade_model.dart';
import 'package:sideswap/models/pegx_model.dart';
import 'package:sideswap/models/pin_models.dart';
import 'package:sideswap/models/stokr_model.dart';
import 'package:sideswap/providers/addresses_providers.dart';
import 'package:sideswap/providers/amp_id_provider.dart';
import 'package:sideswap/providers/amp_register_provider.dart';
import 'package:sideswap/providers/asset_selector_provider.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/providers/common_providers.dart';
import 'package:sideswap/providers/currency_rates_provider.dart';
import 'package:sideswap/providers/desktop_dialog_providers.dart';
import 'package:sideswap/providers/env_provider.dart';
import 'package:sideswap/providers/first_launch_providers.dart';
import 'package:sideswap/providers/jade_provider.dart';
import 'package:sideswap/providers/local_notifications_service.dart';
import 'package:sideswap/providers/login_provider.dart';
import 'package:sideswap/providers/market_data_provider.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/network_settings_providers.dart';
import 'package:sideswap/providers/order_details_provider.dart';
import 'package:sideswap/providers/pegs_provider.dart';
import 'package:sideswap/providers/pegx_provider.dart';
import 'package:sideswap/providers/portfolio_prices_providers.dart';
import 'package:sideswap/providers/receive_address_providers.dart';
import 'package:sideswap/providers/request_order_provider.dart';
import 'package:sideswap/providers/subscribe_price_providers.dart';
import 'package:sideswap/providers/token_market_provider.dart';
import 'package:sideswap/providers/tx_provider.dart';
import 'package:sideswap/providers/wallet_account_providers.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/providers/connection_state_providers.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart';
import 'package:sideswap/providers/warmup_app_provider.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap_notifications/sideswap_notifications.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';
import 'package:vibration/vibration.dart';

import 'package:sideswap/common/bitmap_helper.dart';
import 'package:sideswap/common/encryption.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/contact_provider.dart';
import 'package:sideswap/providers/payment_provider.dart';
import 'package:sideswap/providers/phone_provider.dart';
import 'package:sideswap/providers/pin_protection_provider.dart';
import 'package:sideswap/providers/pin_setup_provider.dart';
import 'package:sideswap/providers/swap_provider.dart';
import 'package:sideswap/providers/ui_state_args_provider.dart';
import 'package:sideswap/providers/universal_link_provider.dart';
import 'package:sideswap/providers/utils_provider.dart';
import 'package:sideswap/models/client_ffi.dart';
import 'package:sideswap/screens/order/widgets/order_details.dart';
import 'package:sideswap/side_swap_client_ffi.dart';

part 'wallet.g.dart';

@Riverpod(keepAlive: true)
class SyncCompleteState extends _$SyncCompleteState {
  @override
  bool build() {
    return false;
  }

  void setState(bool value) {
    state = value;
  }
}

class SideSwapException implements Exception {
  final String message;

  const SideSwapException(this.message);

  @override
  String toString() => message;
}

class ClientNotInitializedException extends SideSwapException {
  ClientNotInitializedException(super.message);
}

List<int> envValues() {
  if (kDebugMode) {
    return [
      SIDESWAP_ENV_PROD,
      SIDESWAP_ENV_TESTNET,
      SIDESWAP_ENV_LOCAL_LIQUID,
      SIDESWAP_ENV_LOCAL_TESTNET,
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
    case SIDESWAP_ENV_LOCAL_LIQUID:
      return 'Local Liquid';
    case SIDESWAP_ENV_LOCAL_TESTNET:
      return 'Local Testnet';
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

MarketType getMarketType(Asset? asset) {
  if (asset == null) {
    return MarketType.token;
  }

  if (asset.swapMarket) {
    return MarketType.stablecoin;
  }
  if (asset.ampMarket) {
    return MarketType.amp;
  }
  return MarketType.token;
}

class PinDecryptedData {
  final From_DecryptPin_Error? error;
  final bool success;
  final String mnemonic;

  PinDecryptedData(this.success, {this.mnemonic = '', this.error});

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

  final _encryption = Encryption();

  String _mnemonic = '';

  ServerStatus? _serverStatus;
  ServerStatus? get serverStatus => _serverStatus;

  Map<int, List<String>> backupCheckAllWords = {};
  Map<int, int> backupCheckSelectedWords = {};

  final newTransItemSubject = BehaviorSubject<TransItem>();
  StreamSubscription<TransItem>? txDetailsSubscription;

  final _recvSubject = PublishSubject<From>();
  StreamSubscription<From>? _recvSubscription;

  // Toggle assets page
  var filteredToggleAccounts = <AccountAsset>[];

  var pendingPushMessages = <String>[];

  var clientReady = false;

  late TransItem txDetails;

  final _txMemoUpdates = <String, String>{};
  String _currentTxMemoUpdate = '';

  bool settingsBiometricAvailable = false;

  PublishSubject<String> explorerUrlSubject = PublishSubject<String>();

  SwapDetails? swapDetails;
  bool swapPromptWaitingTx = false;

  void sendMsg(To to) {
    if (kDebugMode) {
      logger.d('send: ${to.toDebugString()}');
    }
    final clientId = ref.read(libClientIdProvider);

    if (clientId == 0) {
      throw ClientNotInitializedException('client is not initialized');
    }
    final buf = to.writeToBuffer();

    final pointer = calloc<ffi.Uint8>(buf.length);
    for (var i = 0; i < buf.length; i++) {
      pointer[i] = buf[i];
    }

    Lib.lib.sideswap_send_request(clientId, pointer.cast(), buf.length);
    calloc.free(pointer);
  }

  WalletChangeNotifier(this.ref);

  late ReceivePort _receivePort;
  StreamSubscription<dynamic>? _receivePortSubscription;

  Future<void> startClient() async {
    logger.d('startClient');

    ref.invalidate(defaultAccountsStateProvider);
    ref.invalidate(assetsStateProvider);

    ref
        .read(pageStatusNotifierProvider.notifier)
        .setStatus(Status.walletLoading);

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

    final env = ref.read(envProvider);

    final workDir = await getApplicationSupportDirectory();
    final workPath = workDir.absolute.path.toNativeUtf8();

    final clientId = Lib.lib.sideswap_client_start(env, workPath.cast(),
        appVersionFull.toNativeUtf8().cast(), _receivePort.sendPort.nativePort);
    ref.read(libClientIdProvider.notifier).setClientId(clientId);

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

    final appResetRequired = await _encryption.appResetRequired(
        hasEncryptedMnemonic:
            ref.read(configurationProvider).mnemonicEncrypted.isNotEmpty,
        usePinProtection: ref.read(configurationProvider).usePinProtection);
    if (appResetRequired) {
      await ref.read(configurationProvider.notifier).deleteConfig();
    }

    if (ref.read(configurationProvider).jadeId.isNotEmpty) {
      jadeLogin(ref.read(configurationProvider).jadeId);
    } else if (ref.read(configurationProvider).mnemonicEncrypted.isNotEmpty) {
      if (await _encryption.canAuthenticate() &&
          ref.read(configurationProvider).useBiometricProtection) {
        ref
            .read(pageStatusNotifierProvider.notifier)
            .setStatus(Status.lockedWalet);
      } else {
        await unlockWallet();
      }
    } else {
      if (ref.read(configurationProvider).usePinProtection) {
        await unlockWallet();
      } else {
        ref
            .read(pageStatusNotifierProvider.notifier)
            .setStatus(Status.noWallet);
        notifyListeners();
      }
    }

    // Initiate wallet unlock after startup
    final status = ref.read(pageStatusNotifierProvider);
    if (status == Status.lockedWalet) {
      await unlockWallet();
    }

    final plugin = SideswapNotificationsPlugin(
        androidPlatform: FlavorConfig.isFdroid
            ? AndroidPlatformEnum.fdroid
            : AndroidPlatformEnum.android);
    await plugin.firebaseRefreshToken(
      refreshTokenCallback: (token) {
        updatePushToken(token);
      },
    );
  }

  @override
  void notifyListeners() {
    logger.d('wallet notifyListeners()');
    super.notifyListeners();
  }

  void updateTxs(From_UpdatedTxs txs) {
    for (final item in txs.items) {
      newTransItemSubject.add(item);
    }

    ref.read(allTxsNotifierProvider.notifier).update(txs: txs);
  }

  void removedTxs(From_RemovedTxs txs) {
    ref.read(allTxsNotifierProvider.notifier).remove(txs: txs);
  }

  void updatePegs(From_UpdatedPegs pegs) {
    for (final item in pegs.items) {
      newTransItemSubject.add(item);
    }

    ref.read(allPegsNotifierProvider.notifier).update(pegs: pegs);
  }

  Future<void> _recvMsg(From from) async {
    if (kDebugMode) {
      logger.d('recv: ${from.whichMsg()}');
    }
    // Process message here
    switch (from.whichMsg()) {
      case From_Msg.envSettings:
        ref
            .read(liquidAssetIdStateProvider.notifier)
            .setState(from.envSettings.policyAssetId);
        ref
            .read(tetherAssetIdStateProvider.notifier)
            .setState(from.envSettings.usdtAssetId);
        ref
            .read(eurxAssetIdStateProvider.notifier)
            .setState(from.envSettings.eurxAssetId);
        AccountAsset.liquidAssetId = ref.read(liquidAssetIdStateProvider);
        ref.read(defaultAccountsStateProvider.notifier).insertAccountAsset(
            accountAsset: AccountAsset(
                AccountType.reg, ref.read(liquidAssetIdStateProvider)));
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
        ref
            .read(ampAssetsNotifierProvider.notifier)
            .insertAmpAssets(ampAssetIds: from.ampAssets.assets);
        break;
      case From_Msg.balanceUpdate:
        ref
            .read(balancesNotifierProvider.notifier)
            .updateBalances(from.balanceUpdate);
        notifyListeners();
        break;

      case From_Msg.swapFailed:
        logger.w('Swap failed: ${from.swapFailed}');
        ref
            .read(swapNetworkErrorNotifierProvider.notifier)
            .setState(from.swapFailed);
        notifyListeners();
        await ref.read(utilsProvider).showErrorDialog(from.swapFailed);
        final status = ref.read(pageStatusNotifierProvider);
        if (status == Status.swapPrompt) {
          ref
              .read(pageStatusNotifierProvider.notifier)
              .setStatus(Status.registered);
        }
        break;

      case From_Msg.swapSucceed:
        var txItem = from.swapSucceed;
        showSwapTxDetails(txItem);
        ref.read(swapHelperProvider).swapReset();
        ref.read(swapHelperProvider).clearAmounts();
        break;

      case From_Msg.pegOutAmount:
        ref.read(swapHelperProvider).onPegOutAmountReceived(from.pegOutAmount);
        break;

      case From_Msg.peginWaitTx:
        ref
            .read(swapPegAddressServerNotifierProvider.notifier)
            .setState(from.peginWaitTx.pegAddr);
        ref
            .read(swapRecvAddressExternalNotifierProvider.notifier)
            .setState(from.peginWaitTx.recvAddr);
        ref.invalidate(swapStateNotifierProvider);
        if (!FlavorConfig.isDesktop) {
          ref
              .read(pageStatusNotifierProvider.notifier)
              .setStatus(Status.swapWaitPegTx);
        } else {
          ref.read(desktopDialogProvider).waitPegin();
        }
        break;

      case From_Msg.recvAddress:
        final accountType = getAccountType(from.recvAddress.account);
        final receiveAddress = ReceiveAddress(
            accountType: accountType, recvAddress: from.recvAddress.addr.addr);
        ref
            .read(currentReceiveAddressProvider.notifier)
            .setRecvAddress(receiveAddress);
        break;

      case From_Msg.createTxResult:
        (switch (from.createTxResult.whichResult()) {
          From_CreateTxResult_Result.errorMsg => () async {
              logger.e(from.createTxResult.errorMsg);
              ref.read(createTxStateNotifierProvider.notifier).setCreateTxState(
                  CreateTxStateError(errorMsg: from.createTxResult.errorMsg));
            }(),
          From_CreateTxResult_Result.createdTx => ref
              .read(createTxStateNotifierProvider.notifier)
              .setCreateTxState(
                  CreateTxStateCreated(from.createTxResult.createdTx)),
          From_CreateTxResult_Result.notSet => () {
              throw Exception('invalid send result message');
            }(),
        });
        break;

      case From_Msg.sendResult:
        ref
            .read(sendTxStateNotifierProvider.notifier)
            .setSendTxState(const SendTxStateEmpty());

        if (!FlavorConfig.isDesktop) {
          ref
              .read(pageStatusNotifierProvider.notifier)
              .setStatus(Status.assetDetails);
        }
        switch (from.sendResult.whichResult()) {
          case From_SendResult_Result.errorMsg:
            await ref.read(utilsProvider).showErrorDialog(
                from.sendResult.errorMsg,
                buttonText: 'CONTINUE'.tr());
            notifyListeners();
            break;
          case From_SendResult_Result.txItem:
            var transItem = from.sendResult.txItem;
            if (!FlavorConfig.isDesktop) {
              showTxDetails(transItem);
            } else {
              final allPegsById = ref.read(allPegsByIdProvider);
              ref.read(desktopDialogProvider).showTx(transItem,
                  isPeg: allPegsById.containsKey(transItem.id));
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
              testnet: ref.read(envProvider.notifier).isTestnet(),
            );
            explorerUrlSubject.add(url);
            break;
          case From_BlindedValues_Result.notSet:
            throw Exception('invalid blinded values message');
        }
        break;

      case From_Msg.serverStatus:
        // TODO (malcolmpl): separate server status to providers and remove subscribeToPriceStream here. It cause resubscription.
        _serverStatus = from.serverStatus;
        notifyListeners();
        // Refresh peg-out amounts
        logger.d('Server status: $_serverStatus');
        ref
            .read(subscribePriceStreamNotifierProvider.notifier)
            .subscribeToPriceStream();
        break;

      case From_Msg.priceUpdate:
        logger.d('from.priceupdate: ${from.priceUpdate}');

        ref
            .read(indexPriceSubscriberNotifierProvider.notifier)
            .onPriceUpdate(from.priceUpdate);
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
            logger.e('registration failed: $errorMsg');
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
          final pinData = PinDataState.error(message: from.encryptPin.error);
          ref.read(pinHelperProvider).onPinData(pinData);
        } else {
          final data = from.encryptPin.data;
          final pinData = PinDataStateData(
              salt: data.salt,
              encryptedData: data.encryptedData,
              pinIdentifier: data.pinIdentifier,
              hmac: data.hmac);
          ref.read(configurationProvider.notifier).setPinData(pinData);
          ref.read(pinHelperProvider).onPinData(pinData);
        }
        break;

      case From_Msg.decryptPin:
        if (from.decryptPin.hasError()) {
          ref.read(pinProtectionHelperProvider).onPinDecrypted(
              PinDecryptedData(false, error: from.decryptPin.error));
        } else {
          _mnemonic = from.decryptPin.mnemonic;
          ref
              .read(pinProtectionHelperProvider)
              .onPinDecrypted(PinDecryptedData(true, mnemonic: _mnemonic));
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
        final assetPrecision = ref
            .read(assetUtilsProvider)
            .getPrecisionForAssetId(assetId: assetId);
        const bitcoinPrecision = 8;
        final orderId = fromSr.orderId;
        final indexPrice = from.submitReview.indexPrice;
        const autoSign = true;
        final asset = ref.read(assetsStateProvider)[fromSr.asset]!;

        final orderDetailsData = OrderDetailsData(
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
        ref
            .read(orderDetailsDataNotifierProvider.notifier)
            .setOrderDetailsData(orderDetailsData);

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
            final orderDetailsData = ref.read(orderDetailsDataNotifierProvider);
            if (!orderDetailsData.accept) {
              return;
            }

            if (orderDetailsData.orderType == OrderDetailsDataType.submit) {
              ref
                  .read(pageStatusNotifierProvider.notifier)
                  .setStatus(Status.registered);
            } else if (orderDetailsData.orderType ==
                OrderDetailsDataType.quote) {
              setResponseSuccess();
            } else if (orderDetailsData.orderType ==
                OrderDetailsDataType.sign) {
              ref
                  .read(pageStatusNotifierProvider.notifier)
                  .setStatus(Status.registered);
            }
            break;

          case From_SubmitResult_Result.swapSucceed:
            var txItem = from.submitResult.swapSucceed;
            showSwapTxDetails(txItem);
            break;

          case From_SubmitResult_Result.error:
            if (FlavorConfig.isDesktop) {
              ref.read(desktopDialogProvider).closePopups();
            }

            final errorText = from.submitResult.error == 'id_insufficient_funds'
                ? 'Insufficient L-BTC wallet balance'.tr()
                : from.submitResult.error;
            await ref
                .read(utilsProvider)
                .showErrorDialog(errorText, buttonText: 'CONTINUE'.tr());

            break;
          case From_SubmitResult_Result.unregisteredGaid:
            if (FlavorConfig.isDesktop) {
              ref.read(desktopDialogProvider).closePopups();
            }
            final orderDetailsData = ref.read(orderDetailsDataNotifierProvider);
            final stokrSecurities = ref.read(stokrSecuritiesProvider);
            if (stokrSecurities.any(
                (element) => element.assetId == orderDetailsData.assetId)) {
              // stokr asset
              ref
                  .read(stokrGaidNotifierProvider.notifier)
                  .setStokrGaidState(const StokrGaidState.unregistered());
              ref
                  .read(pageStatusNotifierProvider.notifier)
                  .setStatus(Status.stokrNeedRegister);
            } else {
              // any other amp error
              ref
                  .read(pegxGaidNotifierProvider.notifier)
                  .setState(const PegxGaidState.unregistered());
              await ref
                  .read(utilsProvider)
                  .showUnregisteredGaid(from.submitResult.unregisteredGaid);
            }

            break;
          case From_SubmitResult_Result.notSet:
            throw Exception('invalid SubmitResult message');
        }
        break;

      case From_Msg.walletLoaded:
        final showAmpOnboarding =
            ref.read(configurationProvider).showAmpOnboarding;
        if (showAmpOnboarding) {
          // wallet is loaded but we need to display onboarding amp setup
          ref
              .read(pageStatusNotifierProvider.notifier)
              .setStatus(Status.ampRegister);
          return;
        }

        ref
            .read(pageStatusNotifierProvider.notifier)
            .setStatus(Status.registered);

        // check initial deep link
        // process links before login request for loading screen to work properly
        final initialUri = ref.read(universalLinkProvider).initialUri;
        if (initialUri != null) {
          logger.d('Initial uri found: $initialUri');
          ref.read(universalLinkProvider).handleAppUri(initialUri);
        }
        break;

      case From_Msg.syncComplete:
        ref.read(syncCompleteStateProvider.notifier).setState(true);
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
        ref
            .read(serverConnectionNotifierProvider.notifier)
            .setServerConnectionState(true);
        break;
      case From_Msg.serverDisconnected:
        ref.invalidate(serverConnectionNotifierProvider);
        ref.read(marketsRequestOrdersNotifierProvider.notifier).clearOrders();
        break;
      case From_Msg.orderCreated:
        final oc = from.orderCreated;
        final sendBitcoins = !oc.order.sendBitcoins;
        var price = oc.order.price;
        final asset = ref.read(assetsStateProvider)[oc.order.assetId];

        if (asset == null) {
          logger.w('Asset ${oc.order.assetId} not found!');
          break;
        }

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
          final assetPrecision = ref
              .read(assetUtilsProvider)
              .getPrecisionForAssetId(assetId: order.assetId);
          final orderDetailsData =
              OrderDetailsData.fromRequestOrder(order, assetPrecision);
          ref
              .read(orderDetailsDataNotifierProvider.notifier)
              .setOrderDetailsData(orderDetailsData);
          setCreateOrderSuccess();
        }

        ref
            .read(marketsRequestOrdersNotifierProvider.notifier)
            .insertOrder(order);

        break;
      case From_Msg.orderRemoved:
        ref
            .read(marketsRequestOrdersNotifierProvider.notifier)
            .removeOrder(from.orderRemoved.orderId);
        break;
      case From_Msg.orderComplete:
        // Used with headless client only
        break;

      case From_Msg.notSet:
        throw Exception('invalid empty message');

      case From_Msg.indexPrice:
        final ticker = ref
            .read(assetUtilsProvider)
            .tickerForAssetId(from.indexPrice.assetId);
        logger.d(
            'Index price: ${ticker.isEmpty ? from.indexPrice.assetId : ticker} ${from.indexPrice}');
        ref.read(marketsIndexPriceNotifierProvider.notifier).setIndexPrice(
            from.indexPrice.assetId,
            from.indexPrice.hasInd() ? from.indexPrice.ind : null);
        ref
            .read(marketsLastIndexPriceNotifierProvider.notifier)
            .setLastIndexPrice(from.indexPrice.assetId,
                from.indexPrice.hasLast() ? from.indexPrice.last : null);
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
        ref
            .read(tokenMarketAssetDetailsProvider.notifier)
            .insertAssetDetails(assetDetailsData);
        break;
      case From_Msg.updatePriceStream:
        ref
            .read(subscribePriceStreamNotifierProvider.notifier)
            .onUpdatePriceStreamChanged(from.updatePriceStream);
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

      case From_Msg.jadePorts:
        final jadePorts = from.jadePorts.ports.toList();
        if (jadePorts.isNotEmpty) {
          ref
              .read(jadeDeviceNotifierProvider.notifier)
              .setState(JadeDevicesStateAvailable(devices: jadePorts));
          return;
        }

        ref
            .read(jadeDeviceNotifierProvider.notifier)
            .setState(const JadeDevicesStateUnavailable());

        break;
      case From_Msg.logout:
        cleanupConnectionStates();
        ref
            .read(pageStatusNotifierProvider.notifier)
            .setStatus(Status.noWallet);
        break;
      case From_Msg.jadeStatus:
        final status = JadeStatus.fromStatus(from.jadeStatus.status);
        ref.read(jadeStatusNotifierProvider.notifier).setJadeStatus(status);
        break;
      case From_Msg.gaidStatus:
        final gaidStatus = from.gaidStatus;
        final stokrDetected = ref
            .read(stokrSecuritiesProvider)
            .any((e) => e.assetId == gaidStatus.assetId);
        final pegxDetected = ref
            .read(pegxSecuritiesProvider)
            .any((e) => e.assetId == gaidStatus.assetId);

        if (gaidStatus.error.isEmpty) {
          if (stokrDetected) {
            ref
                .read(stokrGaidNotifierProvider.notifier)
                .setStokrGaidState(const StokrGaidStateRegistered());
            return;
          }
          if (pegxDetected) {
            ref
                .read(pegxGaidNotifierProvider.notifier)
                .setState(const PegxGaidStateRegistered());
            return;
          }
        }

        if (stokrDetected) {
          ref
              .read(stokrGaidNotifierProvider.notifier)
              .setStokrGaidState(const StokrGaidStateUnregistered());
          return;
        }

        if (pegxDetected) {
          ref
              .read(pegxGaidNotifierProvider.notifier)
              .setState(const PegxGaidStateUnregistered());
          return;
        }

        break;
      case From_Msg.login:
        _handleLogin(from.login);
        break;
      case From_Msg.startTimer:
        if (from.startTimer.hasOrderId()) {
          ref
              .read(jadeOrderIdTimerNotifierProvider.notifier)
              .setOrderId(from.startTimer.orderId);
          return;
        }
        break;
      case From_Msg.portfolioPrices:
        ref
            .read(portfolioPricesNotifierProvider.notifier)
            .setPortfolioPrices(from.portfolioPrices.pricesUsd);
        break;
      case From_Msg.tokenMarketOrder:
        ref
            .read(tokenMarketOrderProvider.notifier)
            .setTokenMarketOrder(from.tokenMarketOrder.assetIds);
        break;
      case From_Msg.conversionRates:
        ref
            .read(conversionRatesNotifierProvider.notifier)
            .setConversionRates(from.conversionRates);
        break;
      case From_Msg.loadAddresses:
        _handleLoadAddresses(from.loadAddresses);
        break;
      case From_Msg.loadUtxos:
        _handleLoadUtxos(from.loadUtxos);
        break;
      case From_Msg.marketAdded:
      // TODO: Handle this case.
      case From_Msg.marketRemoved:
      // TODO: Handle this case.
    }
  }

  void openTxUrl(String txid, bool isLiquid, bool unblinded) {
    if (!isLiquid || !unblinded) {
      final url = generateTxidUrl(
        txid,
        isLiquid,
        testnet: ref.read(envProvider.notifier).isTestnet(),
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
    bitcoinAsset.assetId = ref.read(bitcoinAssetIdProvider);
    bitcoinAsset.ticker = kBitcoinTicker;
    bitcoinAsset.precision = kDefaultPrecision;
    final icon = await BitmapHelper.getPngBufferFromSvgAsset(
        'assets/btc_logo.svg', 300, 300);
    bitcoinAsset.icon = base64Encode(icon);
    // TODO: fix icon
    _addAsset(bitcoinAsset, icon);
  }

  void _addAsset(Asset asset, Uint8List assetIcon) {
    logger.d('ASSET: ${asset.ticker} id: ${asset.assetId}');
    if (asset.swapMarket) {
      ref.read(defaultAccountsStateProvider.notifier).insertAccountAsset(
          accountAsset: AccountAsset(AccountType.reg, asset.assetId));
    }
    if (asset.ampMarket) {
      ref.read(defaultAccountsStateProvider.notifier).insertAccountAsset(
          accountAsset: AccountAsset(AccountType.amp, asset.assetId));
    }

    // Always update asset here as they might change
    // (amp_market could be set if server is down when app is started).
    ref.read(assetsStateProvider.notifier).addAsset(asset.assetId, asset);
    // ref.read(swapHelperProvider).checkSelectedAsset();
    // notifyListeners();
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
    if (_mnemonic.isEmpty) {
      return [];
    }

    return _mnemonic.split(' ');
  }

  Future<void> setReviewLicenseCreateWallet() async {
    if (ref.read(configurationProvider).licenseAccepted) {
      if (await _encryption.canAuthenticate()) {
        await newWalletBiometricPrompt();
        return;
      }

      setNewWalletPinWelcome();
    } else {
      ref
          .read(pageStatusNotifierProvider.notifier)
          .setStatus(Status.reviewLicense);
    }
    notifyListeners();
  }

  void setReviewLicenseImportWallet() {
    if (ref.read(configurationProvider).licenseAccepted) {
      startMnemonicImport();
    } else {
      ref
          .read(pageStatusNotifierProvider.notifier)
          .setStatus(Status.reviewLicense);
    }
    notifyListeners();
  }

  void setLicenseAccepted() {
    ref.read(configurationProvider.notifier).setLicenseAccepted(true);
    notifyListeners();
  }

  Future<void> newWalletBiometricPrompt() async {
    assert(ref.read(configurationProvider).licenseAccepted == true);
    _mnemonic = getNewMnemonic();
    if (await _encryption.canAuthenticate()) {
      ref
          .read(pageStatusNotifierProvider.notifier)
          .setStatus(Status.newWalletBiometricPrompt);
      notifyListeners();
      return;
    } else {
      await walletBiometricSkip();
      newWalletBackupPrompt();
      return;
    }
  }

  void newWalletBackupPrompt() {
    ref
        .read(pageStatusNotifierProvider.notifier)
        .setStatus(Status.newWalletBackupPrompt);
  }

  void startMnemonicImport() {
    final status = ref.read(pageStatusNotifierProvider);
    assert(status == Status.noWallet ||
        status == Status.importWallet ||
        status == Status.importWalletError ||
        status == Status.reviewLicense);
    ref
        .read(pageStatusNotifierProvider.notifier)
        .setStatus(Status.importWallet);
  }

  void importMnemonic(String mnemonic) {
    final status = ref.read(pageStatusNotifierProvider);
    assert(status == Status.importWallet ||
        status == Status.importWalletSuccess ||
        status == Status.newWalletPinWelcome);

    _mnemonic = mnemonic;

    if (FlavorConfig.isDesktop) {
      ref
          .read(pageStatusNotifierProvider.notifier)
          .setStatus(Status.newWalletPinWelcome);
      return;
    }

    setImportWalletResult(true);
  }

  void backupNewWalletEnable() {
    ref
        .read(pageStatusNotifierProvider.notifier)
        .setStatus(Status.newWalletBackupView);
  }

  Future<bool> walletBiometricEnable() async {
    return _registerWallet(true);
  }

  Future<bool> walletPinEnable() async {
    if (await _registerWallet(false)) {
      ref.read(pinHelperProvider).enablePinProtection();
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
      ref
          .read(configurationProvider.notifier)
          .setMnemonicEncrypted(await _encryption.encryptBiometric(_mnemonic));

      if (ref.read(configurationProvider).mnemonicEncrypted.isEmpty) {
        return false;
      }
      ref.read(configurationProvider.notifier).setUseBiometricProtection(true);
      ref.read(configurationProvider.notifier).setUsePinProtection(false);
    } else {
      ref
          .read(configurationProvider.notifier)
          .setMnemonicEncrypted(await _encryption.encryptFallback(_mnemonic));
      // Should not happen, something is very wrong
      if (ref.read(configurationProvider).mnemonicEncrypted.isEmpty) {
        return false;
      }

      ref.read(configurationProvider.notifier).setUseBiometricProtection(false);
    }

    return true;
  }

  void loginAndLoadMainPage() {
    _login(mnemonic: _mnemonic);
    // ref.read(swapProvider).checkSelectedAsset();
  }

  void login() {
    _login(mnemonic: _mnemonic);
  }

  void acceptLicense() {
    ref.read(configurationProvider.notifier).setLicenseAccepted(true);
    ref.read(pageStatusNotifierProvider.notifier).setStatus(Status.noWallet);
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
    ref
        .read(pageStatusNotifierProvider.notifier)
        .setStatus(Status.newWalletBackupCheck);
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
      ref
          .read(pageStatusNotifierProvider.notifier)
          .setStatus(Status.newWalletBackupCheckSucceed);
      return;
    }
    ref
        .read(pageStatusNotifierProvider.notifier)
        .setStatus(Status.newWalletBackupCheckFailed);
    notifyListeners();
  }

  bool goBack() {
    var status = ref.read(pageStatusNotifierProvider);

    return switch (status) {
      Status.newWalletBackupCheck ||
      Status.newWalletBackupCheckFailed ||
      Status.newWalletBackupCheckSucceed =>
        () {
          ref
              .read(pageStatusNotifierProvider.notifier)
              .setStatus(Status.newWalletBackupView);
          return false;
        }(),
      Status.importWalletError => () {
          ref
              .read(pageStatusNotifierProvider.notifier)
              .setStatus(Status.importWallet);
          return false;
        }(),
      Status.importWalletSuccess ||
      Status.importWallet ||
      Status.selectEnv ||
      Status.importAvatar ||
      Status.associatePhoneWelcome ||
      Status.reviewLicense ||
      Status.jadeImport ||
      Status.jadeBluetoothPermission ||
      Status.networkAccessOnboarding ||
      Status.newWalletBiometricPrompt ||
      Status.importWalletBiometricPrompt =>
        () {
          ref
              .read(pageStatusNotifierProvider.notifier)
              .setStatus(Status.noWallet);
          return false;
        }(),
      Status.confirmPhone => () {
          ref
              .read(pageStatusNotifierProvider.notifier)
              .setStatus(Status.associatePhoneWelcome);
          return false;
        }(),
      Status.assetsSelect ||
      Status.transactions ||
      Status.orderFilers ||
      Status.orderPopup ||
      Status.swapPrompt ||
      Status.settingsPage ||
      Status.registered ||
      Status.generateWalletAddress ||
      Status.stokrRestrictionsInfo ||
      Status.stokrNeedRegister =>
        () {
          ref
              .read(pageStatusNotifierProvider.notifier)
              .setStatus(Status.registered);
          return false;
        }(),
      Status.paymentSend => () {
          ref
              .read(pageStatusNotifierProvider.notifier)
              .setStatus(Status.paymentAmountPage);
          return false;
        }(),
      Status.paymentAmountPage => () {
          ref
              .read(pageStatusNotifierProvider.notifier)
              .setStatus(Status.paymentPage);
          return false;
        }(),
      Status.paymentPage => () {
          ref
              .read(pageStatusNotifierProvider.notifier)
              .setStatus(Status.assetDetails);
          return false;
        }(),
      Status.swapTxDetails ||
      Status.assetReceiveFromWalletMain ||
      Status.orderSuccess ||
      Status.orderResponseSuccess ||
      Status.createOrderEntry ||
      Status.orderRequestView ||
      Status.assetDetails =>
        () {
          ref
              .read(pageStatusNotifierProvider.notifier)
              .setStatus(Status.registered);
          ref.read(uiStateArgsNotifierProvider.notifier).clear();
          return false;
        }(),
      Status.txDetails => () {
          ref
              .read(pageStatusNotifierProvider.notifier)
              .setStatus(Status.transactions);
          return false;
        }(),
      Status.txEditMemo => () {
          _applyTxMemoChange();
          ref
              .read(pageStatusNotifierProvider.notifier)
              .setStatus(Status.txDetails);
          return false;
        }(),
      Status.assetReceive => () {
          ref.read(uiStateArgsNotifierProvider.notifier).setWalletMainArguments(
                WalletMainArguments(
                  currentIndex: 1,
                  navigationItemEnum: WalletMainNavigationItemEnum.assetDetails,
                ),
              );
          ref
              .read(pageStatusNotifierProvider.notifier)
              .setStatus(Status.assetDetails);
          return false;
        }(),
      Status.swapWaitPegTx => () {
          ref.read(uiStateArgsNotifierProvider.notifier).setWalletMainArguments(
                WalletMainArguments(
                  currentIndex: 4,
                  navigationItemEnum: WalletMainNavigationItemEnum.pegs,
                ),
              );
          ref.read(swapHelperProvider).pegStop();
          ref
              .read(pageStatusNotifierProvider.notifier)
              .setStatus(Status.registered);
          return false;
        }(),
      Status.settingsBackup ||
      Status.settingsSecurity ||
      Status.settingsAboutUs ||
      Status.settingsUserDetails ||
      Status.settingsNetwork ||
      Status.settingsLogs ||
      Status.settingsCurrency =>
        () {
          ref
              .read(pageStatusNotifierProvider.notifier)
              .setStatus(Status.settingsPage);
          return false;
        }(),
      Status.newWalletBackupView => () {
          ref
              .read(pageStatusNotifierProvider.notifier)
              .setStatus(Status.newWalletBackupPrompt);
          return false;
        }(),
      Status.walletLoading || Status.noWallet || Status.lockedWalet => true,
      Status.createOrder => () {
          ref
              .read(pageStatusNotifierProvider.notifier)
              .setStatus(Status.createOrderEntry);
          return false;
        }(),
      Status.stokrLogin ||
      Status.pegxRegister ||
      Status.pegxSubmitAmp ||
      Status.pegxSubmitFinish =>
        () {
          ref
              .read(pageStatusNotifierProvider.notifier)
              .setStatus(Status.ampRegister);
          return false;
        }(),
      Status.walletAddressDetail => () {
          ref
              .read(pageStatusNotifierProvider.notifier)
              .setStatus(Status.generateWalletAddress);
          return false;
        }(),
      Status.jadeDevices => () {
          ref.invalidate(jadeDeviceNotifierProvider);
          ref
              .read(pageStatusNotifierProvider.notifier)
              .setStatus(Status.jadeBluetoothPermission);
          return false;
        }(),
      Status.ampRegister => false,
      _ => () {
          logger.w('Unhandled goBack status $status');
          return false;
        }(),
    };
  }

  void _login({String mnemonic = '', String jadeId = ''}) {
    final msg = To();
    msg.login = To_Login();
    if (mnemonic.isNotEmpty) {
      msg.login.mnemonic = mnemonic;
    }
    if (jadeId.isNotEmpty) {
      msg.login.jadeId = jadeId;
      ref
          .read(jadeOnboardingRegistrationNotifierProvider.notifier)
          .setState(const JadeOnboardingRegistrationStateProcessing());
    }

    sendProxySettings();
    sendNetworkSettings();

    if (ref.read(configurationProvider).phoneKey.isNotEmpty) {
      msg.login.phoneKey = ref.read(configurationProvider).phoneKey;
    }

    sendMsg(msg);

    ref.read(loginStateNotifierProvider.notifier).setState(LoginState.login(
          mnemonic: mnemonic.isEmpty ? null : mnemonic,
          jadeId: jadeId.isEmpty ? null : jadeId,
        ));

    notifyListeners();
  }

  Future<void> _logout() async {
    final msg = To();
    msg.logout = Empty();
    sendMsg(msg);
  }

  void selectAssetDetails(AccountAsset value) {
    ref
        .read(pageStatusNotifierProvider.notifier)
        .setStatus(Status.assetDetails);
    ref
        .read(selectedWalletAccountAssetNotifierProvider.notifier)
        .setAccountAsset(value);
  }

  void selectAssetReceive(AccountType accountType) {
    toggleRecvAddrType(accountType);

    ref
        .read(pageStatusNotifierProvider.notifier)
        .setStatus(Status.assetReceive);
    notifyListeners();
  }

  void startAssetReceiveAddr() {
    toggleRecvAddrType(AccountType.reg);
  }

  void toggleRecvAddrType(AccountType accountType) {
    final msg = To();
    msg.getRecvAddress = getAccount(accountType);
    sendMsg(msg);
  }

  void selectPaymentPage() {
    ref.read(pageStatusNotifierProvider.notifier).setStatus(Status.paymentPage);
  }

  void showTxDetails(TransItem tx) {
    ref.read(pageStatusNotifierProvider.notifier).setStatus(Status.txDetails);
    txDetails = tx;

    _listenTxDetailsChanges();

    notifyListeners();
  }

  void showSwapTxDetails(TransItem transItem) {
    if (!FlavorConfig.isDesktop) {
      ref
          .read(pageStatusNotifierProvider.notifier)
          .setStatus(Status.swapTxDetails);
      txDetails = transItem;

      _listenTxDetailsChanges();

      notifyListeners();
    } else {
      final allPegsById = ref.read(allPegsByIdProvider);
      ref
          .read(desktopDialogProvider)
          .showTx(transItem, isPeg: allPegsById.containsKey(transItem.id));
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

  String commonAddrErrorStr(String addr, AddrType addrType) {
    if (addr.isEmpty) {
      return addr;
    }

    return ref.read(isAddrTypeValidProvider(addr, addrType))
        ? ''
        : 'Invalid address'.tr();
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
    ref
        .read(createTxStateNotifierProvider.notifier)
        .setCreateTxState(const CreateTxStateCreating());
    notifyListeners();
  }

  void assetSendConfirmCommon(CreatedTx createdTx) {
    final msg = To();
    msg.sendTx = To_SendTx();
    msg.sendTx.account = createdTx.req.account;
    msg.sendTx.id = createdTx.id;
    sendMsg(msg);
    ref
        .read(sendTxStateNotifierProvider.notifier)
        .setSendTxState(const SendTxStateSending());
    notifyListeners();
  }

  void selectAvailableAssets() {
    setToggleAssetFilter('');
    ref
        .read(pageStatusNotifierProvider.notifier)
        .setStatus(Status.assetsSelect);
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
    final assets = ref.read(assetsStateProvider);
    final allAccounts = ref.read(allAlwaysShowAccountAssetsProvider);

    for (final account in allAccounts) {
      final asset = assets[account.assetId]!;
      if (_showAsset(asset, filterLowerCase)) {
        filteredToggleAccountsNew.add(account);
      }
    }
    if (!listEquals(filteredToggleAccountsNew, filteredToggleAccounts)) {
      filteredToggleAccounts = filteredToggleAccountsNew;
      notifyListeners();
    }
  }

  void editTxMemo(Object arguments) {
    ref.read(pageStatusNotifierProvider.notifier).setStatus(Status.txEditMemo);
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
    if (ref.read(configurationProvider).usePinProtection) {
      if (await ref.read(pinProtectionHelperProvider).pinBlockadeUnlocked()) {
        ref
            .read(pageStatusNotifierProvider.notifier)
            .setStatus(Status.settingsBackup);
        return;
      }

      return;
    }

    final mnemonic = ref.read(configurationProvider).useBiometricProtection
        ? await _encryption
            .decryptBiometric(ref.read(configurationProvider).mnemonicEncrypted)
        : await _encryption
            .decryptFallback(ref.read(configurationProvider).mnemonicEncrypted);
    if (mnemonic == _mnemonic && validateMnemonic(mnemonic)) {
      ref
          .read(pageStatusNotifierProvider.notifier)
          .setStatus(Status.settingsBackup);
    }
  }

  void settingsUserDetails() {
    ref
        .read(pageStatusNotifierProvider.notifier)
        .setStatus(Status.settingsUserDetails);
  }

  void settingsViewPage() {
    ref
        .read(pageStatusNotifierProvider.notifier)
        .setStatus(Status.settingsPage);
  }

  void settingsViewAboutUs() {
    ref
        .read(pageStatusNotifierProvider.notifier)
        .setStatus(Status.settingsAboutUs);
  }

  Future<void> settingsViewSecurity() async {
    settingsBiometricAvailable = await _encryption.canAuthenticate();
    ref
        .read(pageStatusNotifierProvider.notifier)
        .setStatus(Status.settingsSecurity);
    notifyListeners();
  }

  Future<bool> isBiometricAvailable() async {
    settingsBiometricAvailable = await _encryption.canAuthenticate();
    return settingsBiometricAvailable;
  }

  Future<void> settingsDeletePromptConfirm() async {
    final navigatorKey = ref.read(navigatorKeyProvider);

    Navigator.of(navigatorKey.currentContext!)
        .popUntil((route) => route.isFirst);

    if (FlavorConfig.isDesktop) {
      Navigator.of(navigatorKey.currentContext!)
          .popUntil((route) => route.isFirst);
    }

    ref.read(pageStatusNotifierProvider.notifier).setStatus(Status.noWallet);

    // cancel all orders
    final orders = ref.read(marketOwnRequestOrdersProvider);
    for (var order in orders) {
      cancelOrder(order.orderId);
    }

    unregisterPhone();

    await deleteWalletAndCleanup();
  }

  void cleanupConnectionStates() {
    logger.w('Clean connection states');
    ref.invalidate(serverLoginNotifierProvider);
    ref.invalidate(serverConnectionNotifierProvider);
    cleanAppStates();
  }

  void cleanAppStates() {
    logger.w('Clean app states');
    ref.read(balancesNotifierProvider.notifier).clear();
    ref.read(uiStateArgsNotifierProvider.notifier).clear();
    ref.read(phoneProvider).clearData();
    ref.read(pinProtectionHelperProvider).resetCounter();
    ref.read(allTxsNotifierProvider.notifier).clear();
    ref.read(allPegsNotifierProvider.notifier).clear();
    ref.read(ampIdNotifierProvider.notifier).setAmpId('');
    ref.invalidate(jadeOnboardingRegistrationNotifierProvider);
    ref.invalidate(firstLaunchStateNotifierProvider);
    _mnemonic = "";
    notifyListeners();
  }

  Future<void> deleteWalletAndCleanup() async {
    ref
        .read(subscribePriceStreamNotifierProvider.notifier)
        .unsubscribeFromPriceStream();
    await ref.read(configurationProvider.notifier).deleteConfig();
    await _logout();
    cleanupConnectionStates();
  }

  Future<void> unlockWallet() async {
    final usePinProtection = ref.read(configurationProvider).usePinProtection;
    if (usePinProtection) {
      if (await ref
          .read(pinProtectionHelperProvider)
          .pinBlockadeUnlocked(showBackButton: false)) {
        _login(mnemonic: _mnemonic);
        return;
      }

      ref
          .read(pageStatusNotifierProvider.notifier)
          .setStatus(Status.lockedWalet);
      return;
    }

    if (ref.read(configurationProvider).useBiometricProtection) {
      _mnemonic = await _encryption
          .decryptBiometric(ref.read(configurationProvider).mnemonicEncrypted);
    } else {
      _mnemonic = await _encryption
          .decryptFallback(ref.read(configurationProvider).mnemonicEncrypted);
    }

    if (validateMnemonic(_mnemonic)) {
      _login(mnemonic: _mnemonic);
    } else {
      // TODO: Show error
      ref.read(pageStatusNotifierProvider.notifier).setStatus(Status.noWallet);
    }

    notifyListeners();
  }

  Future<void> settingsEnableBiometric() async {
    final mnemonic = await _encryption
        .decryptFallback(ref.read(configurationProvider).mnemonicEncrypted);

    if (mnemonic.isEmpty) {
      return;
    }

    final mnemonicEncrypted = await _encryption.encryptBiometric(mnemonic);
    if (mnemonicEncrypted.isEmpty) {
      return;
    }

    ref
        .read(configurationProvider.notifier)
        .setMnemonicEncrypted(mnemonicEncrypted);
    _mnemonic = mnemonic;
    ref.read(configurationProvider.notifier).setUseBiometricProtection(true);
    notifyListeners();
  }

  Future<void> settingsDisableBiometric() async {
    final mnemonic = await _encryption
        .decryptBiometric(ref.read(configurationProvider).mnemonicEncrypted);
    if (mnemonic.isEmpty) {
      return;
    }

    final mnemonicEncrypted = await _encryption.encryptFallback(mnemonic);
    if (mnemonicEncrypted.isEmpty) {
      return;
    }

    ref
        .read(configurationProvider.notifier)
        .setMnemonicEncrypted(mnemonicEncrypted);
    _mnemonic = mnemonic;
    ref.read(configurationProvider.notifier).setUseBiometricProtection(false);
    notifyListeners();
  }

  Future<bool> isAuthenticated() async {
    if (ref.read(configurationProvider).usePinProtection) {
      return ref.read(pinProtectionHelperProvider).pinBlockadeUnlocked();
    }

    if (ref.read(configurationProvider).useBiometricProtection) {
      _mnemonic = await _encryption
          .decryptBiometric(ref.read(configurationProvider).mnemonicEncrypted);
    } else {
      final mnemonicEncrypted =
          ref.read(configurationProvider).mnemonicEncrypted;
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
      ref
          .read(pageStatusNotifierProvider.notifier)
          .setStatus(Status.importWalletSuccess);
    } else {
      ref
          .read(pageStatusNotifierProvider.notifier)
          .setStatus(Status.importWalletError);
    }

    notifyListeners();
  }

  Future<void> setImportWalletBiometricPrompt() async {
    final canAuthenticate = await _encryption.canAuthenticate();
    if (canAuthenticate) {
      ref
          .read(pageStatusNotifierProvider.notifier)
          .setStatus(Status.importWalletBiometricPrompt);
      return;
    }

    if (await _registerWallet(false)) {
      loginAndLoadMainPage();
    }
  }

  void updatePushToken(String? token) {
    final clientId = ref.read(libClientIdProvider);
    if (clientId == 0) {
      logger.w(
          'Client lib is not initialized. Are you trying to send message too early?');
      return;
    }

    if (token == null) {
      return;
    }

    var msg = To();
    msg.updatePushToken = To_UpdatePushToken();
    msg.updatePushToken.token = token;
    sendMsg(msg);
  }

  bool isAmountUsdAvailable(String? assetId) {
    if (assetId == ref.read(liquidAssetIdStateProvider)) {
      return true;
    }

    final price = ref.read(walletAssetPricesNotifierProvider)[assetId];
    if (price != null) {
      return true;
    }

    return false;
  }

  List<AccountAsset> sendAssets() {
    return sendAssetsWithBalance();
  }

  void setImportAvatar() {
    ref
        .read(pageStatusNotifierProvider.notifier)
        .setStatus(Status.importAvatar);
  }

  void setImportAvatarSuccess() {
    ref
        .read(pageStatusNotifierProvider.notifier)
        .setStatus(Status.importAvatarSuccess);
  }

  void setAssociatePhoneWelcome() {
    ref
        .read(pageStatusNotifierProvider.notifier)
        .setStatus(Status.associatePhoneWelcome);
  }

  void setConfirmPhone() {
    ref
        .read(pageStatusNotifierProvider.notifier)
        .setStatus(Status.confirmPhone);
  }

  void setConfirmPhoneSuccess() {
    ref
        .read(pageStatusNotifierProvider.notifier)
        .setStatus(Status.confirmPhoneSuccess);
  }

  void setImportContacts() {
    ref
        .read(pageStatusNotifierProvider.notifier)
        .setStatus(Status.importContacts);
  }

  void setImportContactsSuccess() {
    ref
        .read(pageStatusNotifierProvider.notifier)
        .setStatus(Status.importContactsSuccess);
  }

  Future<void> setOrder() async {
    final orderDetailsData = ref.read(orderDetailsDataNotifierProvider);

    if (FlavorConfig.isDesktop) {
      ref.read(desktopDialogProvider).orderReview(
            orderDetailsData.orderType == OrderDetailsDataType.sign
                ? ReviewScreen.sign
                : ReviewScreen.quote,
          );
      return;
    }

    ref.read(pageStatusNotifierProvider.notifier).setStatus(Status.registered);

    Future.microtask(() {
      ref
          .read(pageStatusNotifierProvider.notifier)
          .setStatus(Status.orderPopup);

      final instance = WidgetsBinding.instance;
      if (orderDetailsData.orderType == OrderDetailsDataType.sign &&
          instance.lifecycleState == AppLifecycleState.resumed) {
        unawaited(FlutterRingtonePlayer().playNotification());
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
    final orderDetailsData = ref.read(orderDetailsDataNotifierProvider);
    final newOrderDetailsData =
        orderDetailsData.copyWith(accept: accept, private: private);
    if (newOrderDetailsData.orderId.isEmpty) {
      return;
    }

    final msg = To();
    msg.submitDecision = To_SubmitDecision();
    msg.submitDecision.orderId = newOrderDetailsData.orderId;
    msg.submitDecision.accept = accept;
    msg.submitDecision.autoSign = autosign;
    msg.submitDecision.twoStep = twoStep;
    msg.submitDecision.private = newOrderDetailsData.private;
    msg.submitDecision.ttlSeconds = Int64(ttlSeconds);
    msg.submitDecision.txChainingAllowed = allowTxChaining;
    sendMsg(msg);
  }

  void setOrderSuccess() {
    ref
        .read(pageStatusNotifierProvider.notifier)
        .setStatus(Status.orderSuccess);
  }

  void setResponseSuccess() {
    ref
        .read(pageStatusNotifierProvider.notifier)
        .setStatus(Status.orderResponseSuccess);
  }

  void submitOrder(
    String? assetId,
    double amount,
    double price, {
    bool isAssetAmount = false,
    double? indexPrice,
    AccountType account = const AccountType(0),
  }) {
    if (assetId == null) {
      logger.w('Asset id is null!');
      return;
    }

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
    uploadContacts.phoneKey = ref.read(configurationProvider).phoneKey;
    final msg = To();
    msg.uploadContacts = uploadContacts;
    sendMsg(msg);
  }

  void uploadAvatar({required String avatar}) {
    final uploadAvatar = To_UploadAvatar();
    uploadAvatar.phoneKey = ref.read(configurationProvider).phoneKey;
    uploadAvatar.image = avatar;

    final msg = To();
    msg.uploadAvatar = uploadAvatar;
    sendMsg(msg);
  }

  void setNewWalletPinWelcome() {
    _mnemonic = getNewMnemonic();
    ref
        .read(pageStatusNotifierProvider.notifier)
        .setStatus(Status.newWalletPinWelcome);
  }

  Future<void> setPinWelcome() async {
    if (await _encryption.canAuthenticate()) {
      await setImportWalletBiometricPrompt();
      return;
    }
    ref.read(pageStatusNotifierProvider.notifier).setStatus(Status.pinWelcome);
  }

  bool sendEncryptPin(String pin) {
    if (_mnemonic.isEmpty) {
      return false;
    }

    final msg = To();
    msg.encryptPin = To_EncryptPin();
    msg.encryptPin.pin = pin;
    msg.encryptPin.mnemonic = _mnemonic;
    sendMsg(msg);

    return true;
  }

  void sendDecryptPin(String pin) {
    final pinData = ref.read(configurationProvider).pinDataState;

    if (pinData == null || pinData is! PinDataStateData) {
      logger.w('pinData is empty!');
      return;
    }

    final msg = To();
    msg.decryptPin = To_DecryptPin();
    msg.decryptPin.pin = pin;
    msg.decryptPin.salt = pinData.salt;
    msg.decryptPin.encryptedData = pinData.encryptedData;
    msg.decryptPin.pinIdentifier = pinData.pinIdentifier;
    msg.decryptPin.hmac = pinData.hmac;
    sendMsg(msg);
  }

  Future<bool> disablePinProtection() async {
    if (!ref.read(configurationProvider).usePinProtection) {
      // already disabled
      return true;
    }

    final ret = await ref.read(pinProtectionHelperProvider).pinBlockadeUnlocked(
        iconType: PinKeyboardAcceptType.disable,
        title: 'Disable PIN protection'.tr());

    if (ret) {
      final pinDecryptedData = ref.read(pinDecryptedDataNotifierProvider);
      if (pinDecryptedData.success) {
        // turn off pin and save encrypted mnemonic
        ref.read(configurationProvider.notifier).setUsePinProtection(false);

        ref.read(configurationProvider.notifier).setMnemonicEncrypted(
            await _encryption.encryptFallback(pinDecryptedData.mnemonic));
      }
    }

    return ret;
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

  void setCreateOrderEntry() {
    ref.read(requestOrderProvider).validateDeliverAsset();
    ref
        .read(pageStatusNotifierProvider.notifier)
        .setStatus(Status.createOrderEntry);
  }

  void setCreateOrder() {
    if (FlavorConfig.isDesktop) {
      ref.read(desktopDialogProvider).orderReview(ReviewScreen.submitStart);
      return;
    }

    ref.read(pageStatusNotifierProvider.notifier).setStatus(Status.createOrder);
  }

  void setCreateOrderSuccess() {
    final orderDetailsData = ref.read(orderDetailsDataNotifierProvider);

    if (FlavorConfig.isDesktop) {
      if (orderDetailsData.private) {
        ref.read(desktopDialogProvider).orderReview(ReviewScreen.submitSucceed);
      } else {
        ref.read(desktopDialogProvider).closePopups();
      }
      return;
    }

    // omit create order success screen
    // status = Status.createOrderSuccess;

    if (orderDetailsData.private) {
      ref
          .read(pageStatusNotifierProvider.notifier)
          .setStatus(Status.createOrderSuccess);
    } else {
      ref
          .read(pageStatusNotifierProvider.notifier)
          .setStatus(Status.registered);
    }
  }

  void unregisterPhone() {
    final phoneKey = ref.read(configurationProvider).phoneKey;
    if (phoneKey.isNotEmpty) {
      var msg = To();
      msg.unregisterPhone = To_UnregisterPhone();
      msg.unregisterPhone.phoneKey = phoneKey;
      sendMsg(msg);

      removePhoneKey();
    }
  }

  void removePhoneKey() {
    ref.read(configurationProvider.notifier).setPhoneKey('');
    ref.read(configurationProvider.notifier).setPhoneNumber('');
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
    final orderDetailsData = OrderDetailsData.empty();
    Future.microtask(() => ref
        .read(orderDetailsDataNotifierProvider.notifier)
        .setOrderDetailsData(orderDetailsData));

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
    final msg = To();
    msg.editOrder = To_EditOrder();
    msg.editOrder.orderId = orderId;
    msg.editOrder.autoSign = autoSign;
    sendMsg(msg);
  }

  List<AccountAsset> sendAssetsWithBalance() {
    final allAssets = ref
        .read(balancesNotifierProvider)
        .entries
        .where((e) => e.value > 0)
        .map((e) => e.key)
        .toList();
    if (allAssets.isEmpty) {
      return [
        AccountAsset(AccountType.reg, ref.read(liquidAssetIdStateProvider))
      ];
    }
    return allAssets;
  }

  void setOrderRequestView(RequestOrder requestOrder) {
    ref
        .read(currentRequestOrderViewProvider.notifier)
        .setCurrentRequestOrderView(requestOrder);

    if (FlavorConfig.isDesktop) {
      final orderAsset = ref.read(assetsStateProvider)[requestOrder.assetId]!;
      final orderDetailsData =
          OrderDetailsData.fromRequestOrder(requestOrder, orderAsset.precision);
      ref
          .read(orderDetailsDataNotifierProvider.notifier)
          .setOrderDetailsData(orderDetailsData);
      notifyListeners();
      ref.read(desktopDialogProvider).orderReview(ReviewScreen.edit);
      return;
    }

    ref
        .read(pageStatusNotifierProvider.notifier)
        .setStatus(Status.orderRequestView);
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

    final assets = ref.read(assetsStateProvider);
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
    notifyListeners();
    ref.read(pageStatusNotifierProvider.notifier).setStatus(Status.swapPrompt);
  }

  void swapReviewAccept() {
    swapPromptWaitingTx = true;
    notifyListeners();
    ref.read(pageStatusNotifierProvider.notifier).setStatus(Status.swapPrompt);

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
        ref.read(ampIdNotifierProvider.notifier).setAmpId(msg.ampId);
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

  To_NetworkSettings getNetworkSettings() {
    final network = To_NetworkSettings();
    switch (ref.read(configurationProvider).settingsNetworkType) {
      case SettingsNetworkType.blockstream:
        network.blockstream = Empty();
        break;
      case SettingsNetworkType.sideswap:
        network.sideswap = Empty();
        break;
      case SettingsNetworkType.sideswapChina:
        network.sideswapCn = Empty();
        break;
      case SettingsNetworkType.personal:
        network.custom = To_NetworkSettings_Custom();
        network.custom.host = ref.read(configurationProvider).networkHost;
        network.custom.port = ref.read(configurationProvider).networkPort;
        network.custom.useTls = ref.read(configurationProvider).networkUseTLS;
        break;
    }
    return network;
  }

  To_ProxySettings getProxySettings() {
    final proxy = To_ProxySettings();
    final host = ref.read(configurationProvider).proxySettings?.host;
    final port = ref.read(configurationProvider).proxySettings?.port;
    final useProxy = ref.read(configurationProvider).useProxy;

    if (useProxy &&
        host != null &&
        host.isNotEmpty &&
        port != null &&
        port > 0 &&
        port < 65535) {
      proxy.proxy = To_ProxySettings_Proxy(host: host, port: port);
    }

    return proxy;
  }

  void sendNetworkSettings() {
    final msg = To();
    msg.networkSettings = getNetworkSettings();
    sendMsg(msg);
  }

  void sendProxySettings() {
    final msg = To();
    msg.proxySettings = getProxySettings();
    sendMsg(msg);
  }

  void jadeLogin(String jadeId) {
    _login(jadeId: jadeId);
  }

  void jadeRescan() {
    final msg = To();
    msg.jadeRescan = Empty();
    sendMsg(msg);
  }

  void checkGaidStatus(String ampId, String assetId) {
    logger.d('Checking gaid status for ampId: $ampId and assetId: $assetId');
    final msg = To();
    msg.gaidStatus = To_GaidStatus();
    msg.gaidStatus.gaid = ampId;
    msg.gaidStatus.assetId = assetId;
    sendMsg(msg);
  }

  void loadAddresses(Account account) {
    Future.microtask(() => ref
        .read(loadAddressesStateNotifierProvider.notifier)
        .setLoadAddressesState(const LoadAddressesState.loading()));

    final msg = To();
    msg.loadAddresses = account;
    sendMsg(msg);
  }

  void _handleLoadAddresses(From_LoadAddresses loadAddresses) {
    if (loadAddresses.errorMsg.isNotEmpty) {
      ref
          .read(loadAddressesStateNotifierProvider.notifier)
          .setLoadAddressesState(
              LoadAddressesState.error(loadAddresses.errorMsg));
      return;
    }

    ref
        .read(loadAddressesStateNotifierProvider.notifier)
        .setLoadAddressesState(LoadAddressesState.data(loadAddresses));
  }

  void loadUtxos(Account account) {
    final msg = To();
    msg.loadUtxos = account;
    sendMsg(msg);
  }

  void _handleLoadUtxos(From_LoadUtxos loadUtxos) {
    if (loadUtxos.hasErrorMsg()) {
      ref
          .read(loadUtxosStateNotifierProvider.notifier)
          .setLoadUtxosState(LoadUtxosState.error(loadUtxos.errorMsg));
      return;
    }

    ref
        .read(loadUtxosStateNotifierProvider.notifier)
        .setLoadUtxosState(LoadUtxosState.data(loadUtxos));
  }

  void _handleLogin(From_Login login) {
    logger.d(login);
    (switch (login.whichResult()) {
      From_Login_Result.errorMsg
          when login.errorMsg == 'please initialize Jade first' ||
              login.errorMsg == 'write failed' ||
              login.errorMsg == 'open failed' ||
              login.errorMsg ==
                  'Jade error: Network type inconsistent with prior usage' =>
        () {
          ref.read(configurationProvider.notifier).setJadeId('');
          ref.read(serverLoginNotifierProvider.notifier).setServerLoginState(
              ServerLoginStateError(message: login.errorMsg));
        }(),
      From_Login_Result.errorMsg => () {
          ref.read(serverLoginNotifierProvider.notifier).setServerLoginState(
              ServerLoginStateError(message: login.errorMsg));
        }(),
      From_Login_Result.success => () {
          // save jadeId once, when logged in
          final loginState = ref.read(loginStateNotifierProvider);
          (switch (loginState) {
            LoginStateLogin(:final jadeId)
                when jadeId != null &&
                    jadeId.isNotEmpty &&
                    ref.read(configurationProvider).jadeId.isEmpty =>
              ref.read(configurationProvider.notifier).setJadeId(jadeId),
            _ => () {}(),
          });

          ref
              .read(serverLoginNotifierProvider.notifier)
              .setServerLoginState(const ServerLoginStateLogin());
          ref
              .read(firstLaunchStateNotifierProvider.notifier)
              .setFirstLaunchState(const FirstLaunchStateEmpty());
        }(),
      From_Login_Result.notSet => () {
          ref
              .read(serverLoginNotifierProvider.notifier)
              .setServerLoginState(const ServerLoginStateError());
        }(),
    });
  }
}
