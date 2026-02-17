import 'dart:async';
import 'dart:convert';
import 'dart:ffi' as ffi;
import 'dart:io';
import 'dart:isolate';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:ffi/ffi.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/subjects.dart';
import 'package:sideswap/app_version.dart';
import 'package:sideswap/common/enums.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/listeners/sideswap_notification_listener.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/models/connection_models.dart';
import 'package:sideswap/models/jade_model.dart';
import 'package:sideswap/models/pegx_model.dart';
import 'package:sideswap/models/pin_models.dart';
import 'package:sideswap/models/stokr_model.dart';
import 'package:sideswap/providers/addresses_providers.dart';
import 'package:sideswap/providers/amp_id_provider.dart';
import 'package:sideswap/providers/amp_register_provider.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/providers/chart_providers.dart';
import 'package:sideswap/providers/common_providers.dart';
import 'package:sideswap/providers/currency_rates_provider.dart';
import 'package:sideswap/providers/desktop_dialog_providers.dart';
import 'package:sideswap/providers/encryption_providers.dart';
import 'package:sideswap/providers/env_provider.dart';
import 'package:sideswap/providers/first_launch_providers.dart';
import 'package:sideswap/providers/jade_provider.dart';
import 'package:sideswap/providers/local_notifications_service.dart';
import 'package:sideswap/providers/login_provider.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/network_settings_providers.dart';
import 'package:sideswap/providers/new_block_providers.dart';
import 'package:sideswap/providers/new_tx_providers.dart';
import 'package:sideswap/providers/notifications_provider.dart';
import 'package:sideswap/providers/pegs_provider.dart';
import 'package:sideswap/providers/pegx_provider.dart';
import 'package:sideswap/providers/portfolio_prices_providers.dart';
import 'package:sideswap/providers/proxy_provider.dart';
import 'package:sideswap/providers/quote_event_providers.dart';
import 'package:sideswap/providers/receive_address_providers.dart';
import 'package:sideswap/providers/server_status_providers.dart';
import 'package:sideswap/providers/swaption_session_providers.dart';
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

import 'package:sideswap/common/bitmap_helper.dart';
import 'package:sideswap/common/encryption.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/payment_provider.dart';
import 'package:sideswap/providers/pin_protection_provider.dart';
import 'package:sideswap/providers/pin_setup_provider.dart';
import 'package:sideswap/providers/swap_providers.dart';
import 'package:sideswap/providers/ui_state_args_provider.dart';
import 'package:sideswap/providers/universal_link_provider.dart';
import 'package:sideswap/providers/utils_provider.dart';
import 'package:sideswap/models/client_ffi.dart';
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
  return [SIDESWAP_ENV_PROD, SIDESWAP_ENV_TESTNET];
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

class PinDecryptedData {
  final From_DecryptPin_Error? error;
  final bool success;
  final String mnemonic;

  PinDecryptedData(this.success, {this.mnemonic = '', this.error});

  @override
  String toString() =>
      'PinDecryptedData(error: $error, success: $success, mnemonic: $mnemonic)';
}

typedef DartPostCObject =
    ffi.Pointer Function(
      ffi.Pointer<
        ffi.NativeFunction<
          ffi.Int8 Function(ffi.Int64, ffi.Pointer<ffi.Dart_CObject>)
        >
      >,
    );

const kBackupCheckLineCount = 4;
const kBackupCheckWordCount = 3;

class MnemonicRepository {
  String _mnemonic = '';

  bool get isEmpty => _mnemonic.isEmpty;
  List<String> get split => _mnemonic.split(' ');

  String mnemonic() {
    return _mnemonic;
  }

  void setMnemonic(String value) {
    _mnemonic = value;
  }

  void clear() {
    _mnemonic = '';
  }
}

@Riverpod(keepAlive: true)
SideswapWallet wallet(Ref ref) {
  final encryptionRepository = ref.watch(encryptionRepositoryProvider);
  return SideswapWallet(ref, encryptionRepository);
}

class SideswapWallet {
  SideswapWallet(this.ref, this._encryption);

  final Ref ref;

  final AbstractEncryptionRepository _encryption;

  final mnemonicRepository = MnemonicRepository();

  Map<int, List<String>> backupCheckAllWords = {};
  Map<int, int> backupCheckSelectedWords = {};

  final _recvSubject = PublishSubject<From>();
  StreamSubscription<From>? _recvSubscription;

  // Toggle assets page
  var filteredToggleAccounts = <AccountAsset>[];

  var pendingPushMessages = <String>[];

  var clientReady = false;

  PublishSubject<String> explorerUrlSubject = PublishSubject<String>();

  bool swapPromptWaitingTx = false;

  void sendMsg(To to) {
    if (kDebugMode) {
      logger.d('SideswapWallet::sendMsg: ${to.toDebugString()}');
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

  late ReceivePort _receivePort;
  StreamSubscription<dynamic>? _receivePortSubscription;

  Future<void> startClient() async {
    logger.d('SideswapWallet::startClient() called');

    ref.invalidate(defaultAccountsStateProvider);
    ref.invalidate(assetsStateProvider);
    ref.invalidate(serverConnectionProvider);

    ref.read(pageStatusProvider.notifier).setStatus(Status.walletLoading);

    await _recvSubscription?.cancel();
    await _receivePortSubscription?.cancel();

    _recvSubscription = _recvSubject.listen((value) async {
      try {
        await _recvMsg(value);
      } catch (e) {
        logger.e(e);
      }
    });

    final storeDartPostCObject = Lib.dynLib
        .lookupFunction<DartPostCObject, DartPostCObject>(
          'store_dart_post_cobject',
        );
    storeDartPostCObject(ffi.NativeApi.postCObject);

    _receivePort = ReceivePort();

    final env = ref.read(envProvider);

    final workDir = await getApplicationSupportDirectory();
    final workPath = workDir.absolute.path.toNativeUtf8();

    final clientId = Lib.lib.sideswap_client_start(
      env,
      workPath.cast(),
      appVersionFull.toNativeUtf8().cast(),
      _receivePort.sendPort.nativePort,
    );
    ref.read(libClientIdProvider.notifier).setClientId(clientId);

    await _addBtcAsset();

    _receivePortSubscription = _receivePort.listen((dynamic msgPtr) {
      final ptr = Lib.lib.sideswap_msg_ptr(msgPtr as int);
      final len = Lib.lib.sideswap_msg_len(msgPtr);
      final msg = From.fromBuffer(ptr.asTypedList(len));
      Lib.lib.sideswap_msg_free(msgPtr);
      _recvSubject.add(msg);
    });

    clientReady = true;
    processPendingPushMessages();

    final appResetRequired = await _encryption.appResetRequired(
      hasEncryptedMnemonic: ref
          .read(configurationProvider)
          .mnemonicEncrypted
          .isNotEmpty,
      usePinProtection: ref.read(configurationProvider).usePinProtection,
    );
    if (appResetRequired) {
      await ref.read(configurationProvider.notifier).deleteConfig();
    }

    if (ref.read(configurationProvider).jadeId.isNotEmpty) {
      jadeLogin(ref.read(configurationProvider).jadeId);
    } else if (ref.read(configurationProvider).mnemonicEncrypted.isNotEmpty) {
      if (await _encryption.canAuthenticate() &&
          ref.read(configurationProvider).useBiometricProtection) {
        ref.read(pageStatusProvider.notifier).setStatus(Status.lockedWalet);
      } else {
        await unlockWallet();
      }
    } else {
      if (ref.read(configurationProvider).usePinProtection) {
        await unlockWallet();
      } else {
        ref.read(pageStatusProvider.notifier).setStatus(Status.noWallet);
        notifyListeners();
      }
    }

    // Initiate wallet unlock after startup
    final status = ref.read(pageStatusProvider);
    if (status == Status.lockedWalet) {
      await unlockWallet();
    }

    final plugin = SideswapNotificationsPlugin(
      androidPlatform: FlavorConfig.isFdroid
          ? AndroidPlatformEnum.fdroid
          : AndroidPlatformEnum.android,
    );
    await plugin.firebaseRefreshToken(
      refreshTokenCallback: (token) {
        updatePushToken(token);
      },
    );
  }

  void notifyListeners() {
    logger.d('SideswapWallet::notifyListeners() called');
    ref.notifyListeners();
  }

  void updateTxs(From_UpdatedTxs txs) {
    ref.read(updatedTxsProvider.notifier).update(txs);
  }

  void removedTxs(From_RemovedTxs txs) {
    ref.read(updatedTxsProvider.notifier).remove(txs);
    ref.read(allTxsProvider.notifier).remove(txs);
  }

  void updatePegs(From_UpdatedPegs pegs) {
    ref.read(allPegsProvider.notifier).update(pegs: pegs);
    ref.read(pegOrderFeesProvider.notifier).setState(pegs);
  }

  Future<void> _recvMsg(From from) async {
    if (kDebugMode) {
      logger.d('SideswapWallet::_recvMsg: ${from.whichMsg()}');
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

        ref
            .read(defaultAccountsStateProvider.notifier)
            .insertAccountAsset(
              accountAsset: AccountAsset(
                Account.REG,
                from.envSettings.policyAssetId,
              ),
            );
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
            .read(ampAssetIdsProvider.notifier)
            .insertAmpAssets(ampAssetIds: from.ampAssets.assets);
        break;
      case From_Msg.balanceUpdate:
        ref.read(balancesProvider.notifier).updateBalances(from.balanceUpdate);
        notifyListeners();
        break;

      case From_Msg.swapFailed:
        logger.w('Swap failed: ${from.swapFailed}');
        ref.read(swapNetworkErrorProvider.notifier).setState(from.swapFailed);
        notifyListeners();
        await ref.read(utilsProvider).showErrorDialog(from.swapFailed);
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
            .read(swapPegAddressServerProvider.notifier)
            .setState(from.peginWaitTx.pegAddr);
        ref
            .read(swapRecvAddressExternalProvider.notifier)
            .setState(from.peginWaitTx.recvAddr);
        ref.invalidate(swapStateProvider);
        if (!FlavorConfig.isDesktop) {
          ref.read(pageStatusProvider.notifier).setStatus(Status.swapWaitPegTx);
        }
        break;

      case From_Msg.recvAddress:
        final receiveAddress = ReceiveAddress(
          account: from.recvAddress.account,
          recvAddress: from.recvAddress.addr.addr,
        );
        ref
            .read(currentReceiveAddressProvider.notifier)
            .setRecvAddress(receiveAddress);
        break;

      case From_Msg.createTxResult:
        (switch (from.createTxResult.whichResult()) {
          From_CreateTxResult_Result.errorMsg => () {
            logger.e(
              'From_CreateTxResult_Result.errorMsg: ${from.createTxResult.errorMsg}',
            );
            ref
                .read(createTxStateProvider.notifier)
                .setCreateTxState(
                  CreateTxStateError(errorMsg: from.createTxResult.errorMsg),
                );
          }(),
          From_CreateTxResult_Result.createdTx =>
            ref
                .read(createTxStateProvider.notifier)
                .setCreateTxState(
                  CreateTxStateCreated(from.createTxResult.createdTx),
                ),
          From_CreateTxResult_Result.notSet => () {
            throw Exception('invalid send result message');
          }(),
        });
        break;

      case From_Msg.sendResult:
        ref
            .read(sendTxStateProvider.notifier)
            .setSendTxState(const SendTxStateEmpty());

        if (!FlavorConfig.isDesktop) {
          ref.read(pageStatusProvider.notifier).setStatus(Status.assetDetails);
        }
        switch (from.sendResult.whichResult()) {
          case From_SendResult_Result.errorMsg:
            await ref
                .read(utilsProvider)
                .showErrorDialog(
                  from.sendResult.errorMsg,
                  buttonText: 'CONTINUE'.tr(),
                );
            notifyListeners();
            break;
          case From_SendResult_Result.txItem:
            var transItem = from.sendResult.txItem;
            if (!FlavorConfig.isDesktop) {
              showTxDetails(transItem);
            } else {
              final allPegsById = ref.read(allPegsByIdProvider);
              await ref
                  .read(desktopDialogProvider)
                  .showTx(
                    transItem,
                    isPeg: transItem.hasPeg()
                        ? allPegsById.containsKey(
                            transItem.peg.isPegIn
                                ? transItem.peg.txidRecv
                                : transItem.peg.txidSend,
                          )
                        : false,
                  );
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
            await ref
                .read(utilsProvider)
                .showErrorDialog(
                  from.blindedValues.errorMsg,
                  buttonText: 'CONTINUE'.tr(),
                );
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
        _handleServerStatus(from.serverStatus);
        break;

      case From_Msg.priceUpdate:
        logger.d('from.priceupdate: ${from.priceUpdate}');
        break;

      case From_Msg.showMessage:
        await ref
            .read(utilsProvider)
            .showErrorDialog(
              from.showMessage.text,
              buttonText: 'CONTINUE'.tr(),
            );
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
            hmac: data.hmac,
          );
          ref.read(configurationProvider.notifier).setPinData(pinData);
          ref.read(pinHelperProvider).onPinData(pinData);
        }
        break;

      case From_Msg.decryptPin:
        if (from.decryptPin.hasError()) {
          await ref
              .read(pinProtectionHelperProvider)
              .onPinDecrypted(
                PinDecryptedData(false, error: from.decryptPin.error),
              );
        } else {
          mnemonicRepository.setMnemonic(from.decryptPin.mnemonic);
          await ref
              .read(pinProtectionHelperProvider)
              .onPinDecrypted(
                PinDecryptedData(true, mnemonic: mnemonicRepository.mnemonic()),
              );
        }

        break;

      case From_Msg.walletLoaded:
        final showAmpOnboarding = ref
            .read(configurationProvider)
            .showAmpOnboarding;
        if (showAmpOnboarding) {
          // wallet is loaded but we need to display onboarding amp setup
          ref.read(pageStatusProvider.notifier).setStatus(Status.ampRegister);
          return;
        }

        ref.read(pageStatusProvider.notifier).setStatus(Status.registered);

        // check initial deep link
        // process links before login request for loading screen to work properly
        final initialUri = ref.read(universalLinkProvider).initialUri;
        if (initialUri != null) {
          logger.d(
            'SideswapWallet::walletLoaded: initial uri found: $initialUri',
          );
          final linkResultState = ref
              .read(universalLinkProvider)
              .handleAppUri(initialUri);
          logger.d(
            'SideswapWallet::walletLoaded: link result state $linkResultState',
          );
          ref
              .read(universalLinkResultStateProvider.notifier)
              .setState(linkResultState);
        }
        break;

      case From_Msg.syncComplete:
        ref.read(syncCompleteStateProvider.notifier).setState(true);
        break;

      case From_Msg.serverConnected:
        ref
            .read(serverConnectionProvider.notifier)
            .setServerConnectionState(true);
        ref.read(sideswapNotificationProvider).requestTxFromBackend();
        break;
      case From_Msg.serverDisconnected:
        ref.invalidate(serverConnectionProvider);
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
          chartStats: null,
        );
        ref
            .read(tokenMarketProvider.notifier)
            .insertAssetDetails(assetDetailsData);
        break;
      case From_Msg.registerAmp:
        await _processRegisterAmpResult(from.registerAmp);
        break;
      case From_Msg.localMessage:
        logger.w('local message: ${from.localMessage}');
        await ref
            .read(localNotificationsProvider)
            .showNotification(
              from.localMessage.title,
              from.localMessage.body,
              payload: from.localMessage.body,
            );
        break;
      case From_Msg.jadePorts:
        final jadePorts = from.jadePorts.ports.toList();
        if (jadePorts.isNotEmpty) {
          ref
              .read(jadeDeviceProvider.notifier)
              .setState(JadeDevicesStateAvailable(devices: jadePorts));
          return;
        }

        ref
            .read(jadeDeviceProvider.notifier)
            .setState(const JadeDevicesStateUnavailable());

        break;
      case From_Msg.logout:
        cleanupConnectionStates();
        ref.read(pageStatusProvider.notifier).setStatus(Status.noWallet);
        break;
      case From_Msg.jadeStatus:
        final status = JadeStatus.fromStatus(from.jadeStatus.status);
        ref.read(jadeStatusProvider.notifier).setJadeStatus(status);
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
                .read(stokrGaidProvider.notifier)
                .setStokrGaidState(const StokrGaidStateRegistered());
            return;
          }
          if (pegxDetected) {
            ref
                .read(pegxGaidProvider.notifier)
                .setState(const PegxGaidStateRegistered());
            return;
          }
        }

        if (stokrDetected) {
          ref
              .read(stokrGaidProvider.notifier)
              .setStokrGaidState(const StokrGaidStateUnregistered());
          return;
        }

        if (pegxDetected) {
          ref
              .read(pegxGaidProvider.notifier)
              .setState(const PegxGaidStateUnregistered());
          return;
        }

        break;
      case From_Msg.login:
        _handleLogin(from.login);
        break;
      case From_Msg.portfolioPrices:
        ref
            .read(portfolioPricesProvider.notifier)
            .setPortfolioPrices(from.portfolioPrices.pricesUsd);
        break;
      case From_Msg.conversionRates:
        ref
            .read(conversionRatesProvider.notifier)
            .setConversionRates(from.conversionRates);
        break;
      case From_Msg.loadAddresses:
        _handleLoadAddresses(from.loadAddresses);
        break;
      case From_Msg.loadUtxos:
        _handleLoadUtxos(from.loadUtxos);
        break;
      case From_Msg.marketAdded:
        _handleMarketAdded(from.marketAdded);
        break;
      case From_Msg.marketRemoved:
        _handleMarketRemoved(from.marketRemoved);
        break;
      case From_Msg.marketList:
        _handleMarketList(from.marketList);
        break;
      case From_Msg.publicOrders:
        _handlePublicOrders(from.publicOrders);
        break;
      case From_Msg.publicOrderCreated:
        _handlePublicOrderCreated(from.publicOrderCreated);
        break;
      case From_Msg.publicOrderRemoved:
        _handlePublicOrderRemoved(from.publicOrderRemoved);
        break;
      case From_Msg.marketPrice:
        _handleMarketPrice(from.marketPrice);
        break;
      case From_Msg.ownOrders:
        _handleOwnOrders(from.ownOrders);
        break;
      case From_Msg.ownOrderCreated:
        _handleOwnOrderCreated(from.ownOrderCreated);
        break;
      case From_Msg.ownOrderRemoved:
        _handleOwnOrderRemoved(from.ownOrderRemoved);
        break;
      case From_Msg.quote:
        _handleQuote(from.quote);
        break;
      case From_Msg.acceptQuote:
        _handleAcceptQuote(from.acceptQuote);
        break;
      case From_Msg.orderSubmit:
        _handleOrderSubmit(from.orderSubmit);
        break;
      case From_Msg.chartsSubscribe:
        _handleChartsSubscribe(from.chartsSubscribe);
        break;
      case From_Msg.chartsUpdate:
        _handleChartsUpdate(from.chartsUpdate);
        break;
      case From_Msg.loadHistory:
        _handleLoadHistory(from.loadHistory);
        break;
      case From_Msg.historyUpdated:
        _handleHistoryUpdated(from.historyUpdated);
        break;
      case From_Msg.orderEdit:
        _handleEditOrder(from.orderEdit);
        break;
      case From_Msg.startOrder:
        _handleStartOrder(from.startOrder);
        break;
      case From_Msg.minMarketAmounts:
        _handleMinMarketAmounts(from.minMarketAmounts);
        break;
      case From_Msg.subscribedValue:
        _handleSubscribedValue(from.subscribedValue);
        break;
      case From_Msg.jadeUnlock:
        _handleJadeUnlock(from.jadeUnlock);
        break;
      case From_Msg.loadTransactions:
        _handleLoadTransactions(from.loadTransactions);
        break;
      case From_Msg.newBlock:
        _handleNewBlock(from.newBlock);
        break;
      case From_Msg.newTx:
        _handleNewTx(from.newTx);
        break;
      case From_Msg.jadeVerifyAddress:
        _handleJadeVerifyAddress(from.jadeVerifyAddress);
        break;
      case From_Msg.showTransaction:
        _handleShowTransaction(from.showTransaction);
        break;
      // TODO: Handle this cases
      case From_Msg.orderCancel:
        logger.w('OrderCancel: ${from.orderCancel}');
        break;
      case From_Msg.pegEdit:
        _handlePegEdit(from.pegEdit);
        break;
      case From_Msg.signerRequest:
        _handleSignerRequest(from.signerRequest);
        break;
      case From_Msg.sessionList:
        _handleSessionList(from.sessionList);
        break;
      case From_Msg.sessionAdded:
        _handleSessionAdded(from.sessionAdded);
        break;
      case From_Msg.sessionRemoved:
        _handleSessionRemoved(from.sessionRemoved);
        break;
      case From_Msg.signerReturn:
        _handleSignerReturn();
        break;
      case From_Msg.signerCancel:
        _handleSignerCancel(from.signerCancel);
        break;
      case From_Msg.notSet:
        throw UnimplementedError('invalid message: $from');
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
      'assets/btc_logo.svg',
      300,
      300,
    );
    bitcoinAsset.icon = base64Encode(icon);
    // TODO: fix icon
    _addAsset(bitcoinAsset, icon);
  }

  void _addAsset(Asset asset, Uint8List assetIcon) {
    logger.d('ASSET: ${asset.ticker} id: ${asset.assetId}');
    if (asset.swapMarket) {
      ref
          .read(defaultAccountsStateProvider.notifier)
          .insertAccountAsset(
            accountAsset: AccountAsset(Account.REG, asset.assetId),
          );
    }
    if (asset.ampMarket) {
      ref
          .read(defaultAccountsStateProvider.notifier)
          .insertAccountAsset(
            accountAsset: AccountAsset(Account.AMP_, asset.assetId),
          );
    }

    // Always update asset here as they might change
    // (amp_market could be set if server is down when app is started).
    ref.read(assetsStateProvider.notifier).addAsset(asset.assetId, asset);
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
    if (mnemonicRepository.isEmpty) {
      return [];
    }

    return mnemonicRepository.split;
  }

  Future<void> setReviewLicenseCreateWallet() async {
    if (ref.read(configurationProvider).licenseAccepted) {
      if (await _encryption.canAuthenticate()) {
        await newWalletBiometricPrompt();
        return;
      }

      setNewWalletPinWelcome();
    } else {
      ref.read(pageStatusProvider.notifier).setStatus(Status.reviewLicense);
    }
    notifyListeners();
  }

  void setReviewLicenseImportWallet() {
    if (ref.read(configurationProvider).licenseAccepted) {
      startMnemonicImport();
    } else {
      ref.read(pageStatusProvider.notifier).setStatus(Status.reviewLicense);
    }
    notifyListeners();
  }

  void setLicenseAccepted() {
    ref.read(configurationProvider.notifier).setLicenseAccepted(true);
    notifyListeners();
  }

  Future<void> newWalletBiometricPrompt() async {
    assert(ref.read(configurationProvider).licenseAccepted == true);
    mnemonicRepository.setMnemonic(getNewMnemonic());
    if (await _encryption.canAuthenticate()) {
      ref
          .read(pageStatusProvider.notifier)
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
        .read(pageStatusProvider.notifier)
        .setStatus(Status.newWalletBackupPrompt);
  }

  void startMnemonicImport() {
    final status = ref.read(pageStatusProvider);
    assert(
      status == Status.noWallet ||
          status == Status.importWallet ||
          status == Status.importWalletError ||
          status == Status.reviewLicense,
    );
    ref.read(pageStatusProvider.notifier).setStatus(Status.importWallet);
  }

  void importMnemonic(String mnemonic) {
    final status = ref.read(pageStatusProvider);
    assert(
      status == Status.importWallet ||
          status == Status.importWalletSuccess ||
          status == Status.newWalletPinWelcome,
    );

    mnemonicRepository.setMnemonic(mnemonic);

    if (FlavorConfig.isDesktop) {
      ref
          .read(pageStatusProvider.notifier)
          .setStatus(Status.newWalletPinWelcome);
      return;
    }

    setImportWalletResult(true);
  }

  void backupNewWalletEnable() {
    ref.read(pageStatusProvider.notifier).setStatus(Status.newWalletBackupView);
  }

  Future<bool> walletBiometricEnable() async {
    return await _registerWallet(true);
  }

  Future<bool> walletPinEnable() async {
    if (await _registerWallet(false)) {
      ref.read(pinHelperProvider).enablePinProtection();
      return true;
    }

    return false;
  }

  Future<bool> walletBiometricSkip() async {
    return await _registerWallet(false);
  }

  Future<bool> _registerWallet(bool enableBiometric) async {
    if (mnemonicRepository.isEmpty) {
      logger.e('Mnemonic is empty!');
      return false;
    }

    if (enableBiometric) {
      ref
          .read(configurationProvider.notifier)
          .setMnemonicEncrypted(
            await _encryption.encryptBiometric(mnemonicRepository.mnemonic()),
          );

      if (ref.read(configurationProvider).mnemonicEncrypted.isEmpty) {
        return false;
      }
      ref.read(configurationProvider.notifier).setUseBiometricProtection(true);
      ref.read(configurationProvider.notifier).setUsePinProtection(false);
    } else {
      ref
          .read(configurationProvider.notifier)
          .setMnemonicEncrypted(
            await _encryption.encryptFallback(mnemonicRepository.mnemonic()),
          );
      // Should not happen, something is very wrong
      if (ref.read(configurationProvider).mnemonicEncrypted.isEmpty) {
        return false;
      }

      ref.read(configurationProvider.notifier).setUseBiometricProtection(false);
    }

    return true;
  }

  void loginAndLoadMainPage() {
    _login(mnemonic: mnemonicRepository.mnemonic());
    // ref.read(swapProvider).checkSelectedAsset();
  }

  void login() {
    _login(mnemonic: mnemonicRepository.mnemonic());
  }

  void acceptLicense() {
    ref.read(configurationProvider.notifier).setLicenseAccepted(true);
    ref.read(pageStatusProvider.notifier).setStatus(Status.noWallet);
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
      final otherWords = remainingWords
          .take(kBackupCheckWordCount - 1)
          .toList();
      otherWords.add(selectedWord);
      otherWords.shuffle(r);
      backupCheckAllWords[selectedIndex] = otherWords;
    }
    ref
        .read(pageStatusProvider.notifier)
        .setStatus(Status.newWalletBackupCheck);
    notifyListeners();
  }

  void backupNewWalletSelect(int wordIndex, int selectedIndex) {
    backupCheckSelectedWords[wordIndex] = selectedIndex;
    notifyListeners();
  }

  bool _validSelectedWords() {
    final allWords = mnemonicRepository.split;
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
          .read(pageStatusProvider.notifier)
          .setStatus(Status.newWalletBackupCheckSucceed);
      return;
    }
    ref
        .read(pageStatusProvider.notifier)
        .setStatus(Status.newWalletBackupCheckFailed);
    notifyListeners();
  }

  bool goBack() {
    var status = ref.read(pageStatusProvider);

    return switch (status) {
      Status.newWalletBackupCheck ||
      Status.newWalletBackupCheckFailed ||
      Status.newWalletBackupCheckSucceed => () {
        ref
            .read(pageStatusProvider.notifier)
            .setStatus(Status.newWalletBackupView);
        return false;
      }(),
      Status.importWalletError => () {
        ref.read(pageStatusProvider.notifier).setStatus(Status.importWallet);
        return false;
      }(),
      Status.importWalletSuccess ||
      Status.importWallet ||
      Status.selectEnv ||
      Status.reviewLicense ||
      Status.jadeImport ||
      Status.jadeBluetoothPermission ||
      Status.networkAccessOnboarding ||
      Status.newWalletBiometricPrompt ||
      Status.importWalletBiometricPrompt => () {
        ref.read(pageStatusProvider.notifier).setStatus(Status.noWallet);
        return false;
      }(),
      Status.assetsSelect ||
      Status.transactions ||
      Status.settingsPage ||
      Status.registered ||
      Status.generateWalletAddress ||
      Status.stokrRestrictionsInfo ||
      Status.stokrNeedRegister => () {
        ref.read(pageStatusProvider.notifier).setStatus(Status.registered);
        return false;
      }(),
      Status.paymentSend => () {
        ref
            .read(pageStatusProvider.notifier)
            .setStatus(Status.paymentAmountPage);
        return false;
      }(),
      Status.paymentAmountPage => () {
        ref.read(pageStatusProvider.notifier).setStatus(Status.paymentPage);
        return false;
      }(),
      Status.paymentPage => () {
        ref.read(pageStatusProvider.notifier).setStatus(Status.assetDetails);
        return false;
      }(),
      Status.swapTxDetails ||
      Status.assetReceiveFromWalletMain ||
      Status.assetDetails => () {
        ref.read(pageStatusProvider.notifier).setStatus(Status.registered);
        ref.invalidate(uiStateArgsProvider);
        return false;
      }(),
      Status.txDetails => () {
        ref.read(pageStatusProvider.notifier).setStatus(Status.transactions);
        return false;
      }(),
      Status.txEditMemo => () {
        ref.read(pageStatusProvider.notifier).setStatus(Status.txDetails);
        return false;
      }(),
      Status.assetReceive => () {
        ref
            .read(uiStateArgsProvider.notifier)
            .setWalletMainArguments(
              WalletMainArguments(
                currentIndex: 1,
                navigationItemEnum: WalletMainNavigationItemEnum.assetDetails,
              ),
            );
        ref.read(pageStatusProvider.notifier).setStatus(Status.assetDetails);
        return false;
      }(),
      Status.swapWaitPegTx => () {
        ref
            .read(uiStateArgsProvider.notifier)
            .setWalletMainArguments(
              WalletMainArguments(
                currentIndex: 4,
                navigationItemEnum: WalletMainNavigationItemEnum.pegs,
              ),
            );
        ref.read(swapHelperProvider).pegStop();
        ref.read(pageStatusProvider.notifier).setStatus(Status.registered);
        return false;
      }(),
      Status.settingsBackup ||
      Status.settingsSecurity ||
      Status.settingsAboutUs ||
      Status.settingsNetwork ||
      Status.settingsLogs ||
      Status.settingsCurrency => () {
        ref.read(pageStatusProvider.notifier).setStatus(Status.settingsPage);
        return false;
      }(),
      Status.newWalletBackupView => () {
        ref
            .read(pageStatusProvider.notifier)
            .setStatus(Status.newWalletBackupPrompt);
        return false;
      }(),
      Status.walletLoading || Status.noWallet || Status.lockedWalet => true,
      Status.stokrLogin ||
      Status.pegxRegister ||
      Status.pegxSubmitAmp ||
      Status.pegxSubmitFinish => () {
        ref.read(pageStatusProvider.notifier).setStatus(Status.ampRegister);
        return false;
      }(),
      Status.walletAddressDetail => () {
        ref
            .read(pageStatusProvider.notifier)
            .setStatus(Status.generateWalletAddress);
        return false;
      }(),
      Status.jadeDevices => () {
        ref.invalidate(jadeDeviceProvider);
        ref
            .read(pageStatusProvider.notifier)
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
    ref
        .read(serverLoginProvider.notifier)
        .setServerLoginState(ServerLoginStateLoginProcessing());

    final msg = To();
    msg.login = To_Login();
    if (mnemonic.isNotEmpty) {
      msg.login.mnemonic = mnemonic;
    }
    if (jadeId.isNotEmpty) {
      msg.login.jadeId = jadeId;
      ref
          .read(jadeOnboardingRegistrationProvider.notifier)
          .setState(const JadeOnboardingRegistrationStateProcessing());
    }

    final proxySettingsRepository = ref.read(proxySettingsRepositoryProvider);
    sendProxySettings(proxySettingsRepository.getProxySettings());
    sendNetworkSettings();

    if (ref.read(configurationProvider).phoneKey.isNotEmpty) {
      msg.login.phoneKey = ref.read(configurationProvider).phoneKey;
    }

    sendMsg(msg);

    ref
        .read(loginStateProvider.notifier)
        .setState(
          LoginState.login(
            mnemonic: mnemonic.isEmpty ? null : mnemonic,
            jadeId: jadeId.isEmpty ? null : jadeId,
          ),
        );

    notifyListeners();
  }

  Future<void> _logout() async {
    final msg = To();
    msg.logout = Empty();
    sendMsg(msg);
  }

  void selectAssetReceive(Account account) {
    toggleRecvAddrType(account);

    ref.read(pageStatusProvider.notifier).setStatus(Status.assetReceive);
    notifyListeners();
  }

  void startAssetReceiveAddr() {
    toggleRecvAddrType(Account.REG);
  }

  void toggleRecvAddrType(Account account) {
    final msg = To();
    msg.getRecvAddress = account;
    sendMsg(msg);
  }

  void selectPaymentPage() {
    ref.read(pageStatusProvider.notifier).setStatus(Status.paymentPage);
  }

  void showTxDetails(TransItem transItem) {
    ref
        .read(currentTxPopupItemProvider.notifier)
        .setCurrentTxId(
          transItem.hasPeg()
              ? transItem.peg.isPegIn
                    ? transItem.peg.txidRecv
                    : transItem.peg.txidSend
              : transItem.tx.txid,
        );
    ref.read(pageStatusProvider.notifier).setStatus(Status.txDetails);
  }

  void showSwapTxDetails(TransItem transItem) {
    ref
        .read(currentTxPopupItemProvider.notifier)
        .setCurrentTxId(
          transItem.hasPeg()
              ? transItem.peg.isPegIn
                    ? transItem.peg.txidRecv
                    : transItem.peg.txidSend
              : transItem.tx.txid,
        );

    if (!FlavorConfig.isDesktop) {
      ref.read(pageStatusProvider.notifier).setStatus(Status.swapTxDetails);
      return;
    }

    final allPegsById = ref.read(allPegsByIdProvider);
    ref
        .read(desktopDialogProvider)
        .showTx(
          transItem,
          isPeg: transItem.hasPeg()
              ? allPegsById.containsKey(
                  transItem.peg.isPegIn
                      ? transItem.peg.txidRecv
                      : transItem.peg.txidSend,
                )
              : false,
        );
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
        .read(createTxStateProvider.notifier)
        .setCreateTxState(const CreateTxStateCreating());
    notifyListeners();
  }

  void assetSendConfirmCommon(CreatedTx createdTx) {
    final msg = To();
    msg.sendTx = To_SendTx();
    msg.sendTx.id = createdTx.id;
    sendMsg(msg);
    ref
        .read(sendTxStateProvider.notifier)
        .setSendTxState(const SendTxStateSending());
    notifyListeners();
  }

  void selectAvailableAssets() {
    setToggleAssetFilter('');
    ref.read(pageStatusProvider.notifier).setStatus(Status.assetsSelect);
  }

  bool _showAsset(Asset asset, String filterLowerCase) {
    if (asset.ticker == kBitcoinTicker) {
      return false;
    }
    if (filterLowerCase.isEmpty) {
      return true;
    }
    final assetText = '${asset.ticker}\n${asset.name}\n${asset.assetId}'
        .toLowerCase();
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
    ref.read(pageStatusProvider.notifier).setStatus(Status.txEditMemo);
  }

  Future<void> settingsViewBackup() async {
    if (ref.read(configurationProvider).usePinProtection) {
      if (await ref.read(pinProtectionHelperProvider).pinBlockadeUnlocked()) {
        ref.read(pageStatusProvider.notifier).setStatus(Status.settingsBackup);
        return;
      }

      return;
    }

    final mnemonic = ref.read(configurationProvider).useBiometricProtection
        ? await _encryption.decryptBiometric(
            ref.read(configurationProvider).mnemonicEncrypted,
          )
        : await _encryption.decryptFallback(
            ref.read(configurationProvider).mnemonicEncrypted,
          );
    if (mnemonic == mnemonicRepository.mnemonic() &&
        validateMnemonic(mnemonic)) {
      ref.read(pageStatusProvider.notifier).setStatus(Status.settingsBackup);
    }
  }

  void settingsViewPage() {
    ref.read(pageStatusProvider.notifier).setStatus(Status.settingsPage);
  }

  void settingsViewAboutUs() {
    ref.read(pageStatusProvider.notifier).setStatus(Status.settingsAboutUs);
  }

  Future<void> settingsViewSecurity() async {
    await _encryption.canAuthenticate();
    ref.read(pageStatusProvider.notifier).setStatus(Status.settingsSecurity);
    notifyListeners();
  }

  Future<void> settingsDeletePromptConfirm() async {
    final navigatorKey = ref.read(navigatorKeyProvider);

    Navigator.of(
      navigatorKey.currentContext!,
    ).popUntil((route) => route.isFirst);

    if (FlavorConfig.isDesktop) {
      Navigator.of(
        navigatorKey.currentContext!,
      ).popUntil((route) => route.isFirst);
    }

    ref.read(pageStatusProvider.notifier).setStatus(Status.noWallet);

    await deleteWalletAndCleanup();
  }

  void cleanupConnectionStates() {
    logger.w('Clean connection states');
    ref.invalidate(serverLoginProvider);
    ref.invalidate(serverConnectionProvider);
    cleanAppStates();
  }

  void cleanAppStates() {
    logger.w('Clean app states');
    ref.invalidate(balancesProvider);
    ref.invalidate(uiStateArgsProvider);
    ref.read(pinProtectionHelperProvider).resetCounter();
    ref.invalidate(allTxsProvider);
    ref.invalidate(allPegsProvider);
    ref.invalidate(pegOrderFeesProvider);
    ref.invalidate(ampIdProvider);
    ref.invalidate(jadeOnboardingRegistrationProvider);
    ref.invalidate(firstLaunchStateProvider);
    mnemonicRepository.clear();
    notifyListeners();
  }

  Future<void> deleteWalletAndCleanup() async {
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
        _login(mnemonic: mnemonicRepository.mnemonic());
        return;
      }

      ref.read(pageStatusProvider.notifier).setStatus(Status.lockedWalet);
      return;
    }

    if (ref.read(configurationProvider).useBiometricProtection) {
      mnemonicRepository.setMnemonic(
        await _encryption.decryptBiometric(
          ref.read(configurationProvider).mnemonicEncrypted,
        ),
      );
    } else {
      mnemonicRepository.setMnemonic(
        await _encryption.decryptFallback(
          ref.read(configurationProvider).mnemonicEncrypted,
        ),
      );
    }

    if (validateMnemonic(mnemonicRepository.mnemonic())) {
      _login(mnemonic: mnemonicRepository.mnemonic());
    }
  }

  Future<void> settingsEnableBiometric() async {
    final mnemonic = await _encryption.decryptFallback(
      ref.read(configurationProvider).mnemonicEncrypted,
    );

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
    mnemonicRepository.setMnemonic(mnemonic);
    ref.read(configurationProvider.notifier).setUseBiometricProtection(true);
    notifyListeners();
  }

  Future<void> settingsDisableBiometric() async {
    final mnemonic = await _encryption.decryptBiometric(
      ref.read(configurationProvider).mnemonicEncrypted,
    );
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
    mnemonicRepository.setMnemonic(mnemonic);
    ref.read(configurationProvider.notifier).setUseBiometricProtection(false);
    notifyListeners();
  }

  Future<bool> isAuthenticated() async {
    if (ref.read(configurationProvider).usePinProtection) {
      return ref.read(pinProtectionHelperProvider).pinBlockadeUnlocked();
    }

    if (ref.read(configurationProvider).useBiometricProtection) {
      mnemonicRepository.setMnemonic(
        await _encryption.decryptBiometric(
          ref.read(configurationProvider).mnemonicEncrypted,
        ),
      );
    } else {
      final mnemonicEncrypted = ref
          .read(configurationProvider)
          .mnemonicEncrypted;
      // Temporary workaround for Jade
      if (mnemonicEncrypted.isEmpty) {
        return true;
      }
      mnemonicRepository.setMnemonic(
        await _encryption.decryptFallback(mnemonicEncrypted),
      );
    }

    if (validateMnemonic(mnemonicRepository.mnemonic())) {
      return true;
    }

    return false;
  }

  void setImportWalletResult(bool success) {
    if (success) {
      ref
          .read(pageStatusProvider.notifier)
          .setStatus(Status.importWalletSuccess);
    } else {
      ref.read(pageStatusProvider.notifier).setStatus(Status.importWalletError);
    }

    notifyListeners();
  }

  Future<void> setImportWalletBiometricPrompt() async {
    final canAuthenticate = await _encryption.canAuthenticate();
    if (canAuthenticate) {
      ref
          .read(pageStatusProvider.notifier)
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
        'Client lib is not initialized. Are you trying to send message too early?',
      );
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

  void setNewWalletPinWelcome() {
    mnemonicRepository.setMnemonic(getNewMnemonic());
    ref.read(pageStatusProvider.notifier).setStatus(Status.newWalletPinWelcome);
  }

  Future<void> setPinWelcome() async {
    if (await _encryption.canAuthenticate()) {
      await setImportWalletBiometricPrompt();
      return;
    }
    ref.read(pageStatusProvider.notifier).setStatus(Status.pinWelcome);
  }

  bool sendEncryptPin(String pin) {
    if (mnemonicRepository.isEmpty) {
      return false;
    }

    final msg = To();
    msg.encryptPin = To_EncryptPin();
    msg.encryptPin.pin = pin;
    msg.encryptPin.mnemonic = mnemonicRepository.mnemonic();
    sendMsg(msg);

    return true;
  }

  void sendDecryptPin(String pin) {
    final pinData = ref.read(configurationProvider).pinDataState;

    if (pinData == null || pinData is! PinDataStateData) {
      logger.w('pinData is empty!');
      return;
    }

    final proxySettingsRepository = ref.read(proxySettingsRepositoryProvider);
    sendProxySettings(proxySettingsRepository.getProxySettings());

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

    final ret = await ref
        .read(pinProtectionHelperProvider)
        .pinBlockadeUnlocked(
          iconType: PinKeyboardAcceptType.disable,
          title: 'Disable PIN protection'.tr(),
        );

    if (ret) {
      final pinDecryptedData = ref.read(pinDecryptedDataProvider);
      if (pinDecryptedData.success) {
        // turn off pin and save encrypted mnemonic
        ref.read(configurationProvider.notifier).setUsePinProtection(false);

        ref
            .read(configurationProvider.notifier)
            .setMnemonicEncrypted(
              await _encryption.encryptFallback(pinDecryptedData.mnemonic),
            );
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

  void getPegOutAmount(int? sendAmount, int? recvAmount, double feeRate) {
    assert((sendAmount == null) != (recvAmount == null));
    final msg = To();
    msg.pegOutAmount = To_PegOutAmount();
    msg.pegOutAmount.feeRate = feeRate;
    msg.pegOutAmount.isSendEntered = sendAmount != null;
    msg.pegOutAmount.amount = sendAmount != null
        ? Int64(sendAmount)
        : Int64(recvAmount!);
    sendMsg(msg);
  }

  Future<void> _processRegisterAmpResult(From_RegisterAmp msg) async {
    switch (msg.whichResult()) {
      case From_RegisterAmp_Result.ampId:
        ref.read(ampIdProvider.notifier).setAmpId(msg.ampId);
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
    final initializedState = ref.read(libClientStateProvider);
    if (initializedState != const LibClientState.initialized()) {
      return;
    }

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

  void sendNetworkSettings() {
    final msg = To();
    msg.networkSettings = getNetworkSettings();
    sendMsg(msg);
  }

  void sendProxySettings(To_ProxySettings toProxySettings) {
    final msg = To();
    msg.proxySettings = toProxySettings;
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
    Future.microtask(
      () => ref
          .read(loadAddressesStateProvider.notifier)
          .setLoadAddressesState(const LoadAddressesState.loading()),
    );

    final msg = To();
    msg.loadAddresses = account;
    sendMsg(msg);
  }

  void _handleLoadAddresses(From_LoadAddresses loadAddresses) {
    if (loadAddresses.errorMsg.isNotEmpty) {
      ref
          .read(loadAddressesStateProvider.notifier)
          .setLoadAddressesState(
            LoadAddressesState.error(loadAddresses.errorMsg),
          );
      return;
    }

    ref
        .read(loadAddressesStateProvider.notifier)
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
          .read(loadUtxosStateProvider.notifier)
          .setLoadUtxosState(LoadUtxosState.error(loadUtxos.errorMsg));
      return;
    }

    ref
        .read(loadUtxosStateProvider.notifier)
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
          ref
              .read(serverLoginProvider.notifier)
              .setServerLoginState(
                ServerLoginStateError(message: login.errorMsg),
              );
        }(),
      From_Login_Result.errorMsg => () {
        ref
            .read(serverLoginProvider.notifier)
            .setServerLoginState(
              ServerLoginStateError(message: login.errorMsg),
            );
      }(),
      From_Login_Result.success => () {
        // save jadeId once, when logged in
        final loginState = ref.read(loginStateProvider);
        (switch (loginState) {
          LoginStateLogin(:final jadeId)
              when jadeId != null &&
                  jadeId.isNotEmpty &&
                  ref.read(configurationProvider).jadeId.isEmpty =>
            ref.read(configurationProvider.notifier).setJadeId(jadeId),
          _ => () {}(),
        });

        ref
            .read(serverLoginProvider.notifier)
            .setServerLoginState(const ServerLoginStateLogin());
        ref
            .read(firstLaunchStateProvider.notifier)
            .setFirstLaunchState(const FirstLaunchStateTypeEmpty());
      }(),
      From_Login_Result.notSet => () {
        ref
            .read(serverLoginProvider.notifier)
            .setServerLoginState(const ServerLoginStateError());
      }(),
    });
  }

  void _handleMarketList(From_MarketList marketList) {
    ref.read(marketsProvider.notifier).setState(marketList.markets);
  }

  void _handleMarketAdded(MarketInfo marketInfo) {
    ref.read(marketsProvider.notifier).addMarketInfo(marketInfo);
  }

  void _handleMarketRemoved(AssetPair assetPair) {
    ref.read(marketsProvider.notifier).removeAssetPair(assetPair);
  }

  void _handlePublicOrders(From_PublicOrders publicOrders) {
    ref
        .read(marketPublicOrdersProvider.notifier)
        .setOrders(publicOrders.assetPair, publicOrders.list);
  }

  void _handlePublicOrderCreated(PublicOrder publicOrder) {
    ref.read(marketPublicOrdersProvider.notifier).orderCreated(publicOrder);
  }

  void _handlePublicOrderRemoved(OrderId orderId) {
    ref.read(marketPublicOrdersProvider.notifier).removeOrder(orderId);
  }

  void _handleMarketPrice(From_MarketPrice marketPrice) {
    logger.d(marketPrice);
    ref.read(marketPriceProvider.notifier).setState(marketPrice);
  }

  void _handleOwnOrders(From_OwnOrders ownOrders) {
    ref.read(marketOwnOrdersProvider.notifier).setState(ownOrders.list);
  }

  void _handleOwnOrderCreated(OwnOrder ownOrder) {
    ref.read(marketOwnOrdersProvider.notifier).orderCreated(ownOrder);
  }

  void _handleOwnOrderRemoved(OrderId orderId) {
    ref.read(marketOwnOrdersProvider.notifier).removeOrder(orderId);
  }

  void _handleQuote(From_Quote quote) {
    logger.d('From_Quote: $quote');
    ref.read(quoteEventProvider.notifier).setQuote(quote);
  }

  void _handleAcceptQuote(From_AcceptQuote acceptQuote) {
    ref.read(acceptQuoteProvider.notifier).setState(acceptQuote);
  }

  void _handleOrderSubmit(From_OrderSubmit orderSubmit) {
    ref.read(orderSubmitProvider.notifier).setState(orderSubmit);
  }

  void _handleChartsSubscribe(From_ChartsSubscribe chartsSubscribe) {
    ref.read(chartsProvider.notifier).setChartsData(chartsSubscribe);
  }

  void _handleChartsUpdate(From_ChartsUpdate chartsUpdate) {
    ref.read(chartsProvider.notifier).updateChartsData(chartsUpdate);
  }

  void _handleLoadHistory(From_LoadHistory loadHistory) {
    ref.read(marketHistoryTotalProvider.notifier).setState(loadHistory.total);
    ref.read(marketHistoryOrderProvider.notifier).loadHistory(loadHistory);
  }

  void _handleHistoryUpdated(From_HistoryUpdated historyUpdated) {
    ref
        .read(marketHistoryOrderProvider.notifier)
        .historyUpdated(historyUpdated);
  }

  void _handleEditOrder(GenericResponse orderEdit) {
    if (orderEdit.success) {
      return;
    }

    ref
        .read(marketEditOrderErrorProvider.notifier)
        .setState(orderEdit.errorMsg);
  }

  void _handleStartOrder(From_StartOrder startOrder) {
    logger.d('Start order: $startOrder');
    ref.invalidate(previewOrderQuoteSuccessProvider);
    ref.invalidate(marketStartOrderProvider);
    ref.read(marketStartOrderProvider.notifier).setState(startOrder);

    if (startOrder.hasSuccess()) {
      return;
    }

    if (!startOrder.hasError()) {
      return;
    }

    logger.w('Start order error: $startOrder');
    ref
        .read(marketStartOrderErrorProvider.notifier)
        .setState(
          StartOrderError(
            error: startOrder.error,
            orderId: startOrder.orderId.toInt(),
          ),
        );
  }

  void _handleMinMarketAmounts(From_MinMarketAmounts minMarketAmounts) {
    ref
        .read(marketMinimalAmountsNotfierProvider.notifier)
        .setState(minMarketAmounts);
  }

  void _handleSubscribedValue(From_SubscribedValue subscribedValue) {
    logger.d('Subscribed value: $subscribedValue');
    ref.read(pegSubscribedValueProvider.notifier).setState(subscribedValue);
  }

  void _handleJadeUnlock(GenericResponse value) {
    if (value.hasErrorMsg()) {
      ref
          .read(jadeLockStateProvider.notifier)
          .setState(JadeLockState.error(message: value.errorMsg));
      return;
    }

    ref
        .read(jadeLockStateProvider.notifier)
        .setState(
          value.success ? JadeLockState.unlocked() : JadeLockState.locked(),
        );
  }

  void _handleServerStatus(ServerStatus serverStatus) {
    logger.d('Server status: $serverStatus');

    if (serverStatus.hasMinPegInAmount()) {
      ref
          .read(pegInMinimumAmountProvider.notifier)
          .setState(serverStatus.minPegInAmount.toInt());
    }

    if (serverStatus.hasServerFeePercentPegIn()) {
      ref
          .read(pegInServerFeePercentProvider.notifier)
          .setState(serverStatus.serverFeePercentPegIn);
    }

    if (serverStatus.hasMinPegOutAmount()) {
      ref
          .read(pegOutMinimumAmountProvider.notifier)
          .setState(serverStatus.minPegOutAmount.toInt());
    }

    if (serverStatus.hasServerFeePercentPegOut()) {
      ref
          .read(pegOutServerFeePercentProvider.notifier)
          .setState(serverStatus.serverFeePercentPegOut);
    }

    ref
        .read(bitcoinFeeRatesProvider.notifier)
        .setState(serverStatus.bitcoinFeeRates);

    final pegRepository = ref.read(pegRepositoryProvider);
    pegRepository.getPegOutAmount();
  }

  void _handleLoadTransactions(From_LoadTransactions loadTransactions) {
    if (loadTransactions.hasErrorMsg()) {
      ref
          .read(loadTransactionsStateProvider.notifier)
          .setState(
            LoadTransactionsState.error(errorMsg: loadTransactions.errorMsg),
          );
      return;
    }
    ref.read(allTxsProvider.notifier).updateList(txs: loadTransactions.txs);
    ref.invalidate(loadTransactionsStateProvider);
  }

  void _handleNewBlock(Empty newBlock) {
    ref.read(newBlockProvider.notifier).update();
  }

  void _handleNewTx(Empty newTx) {
    ref.read(newTxProvider.notifier).update();
  }

  void _handleJadeVerifyAddress(GenericResponse jadeVerifyAddress) {
    if (jadeVerifyAddress.hasErrorMsg()) {
      ref
          .read(jadeVerifyAddressStateProvider.notifier)
          .setState(
            JadeVerifyAddressState.error(message: jadeVerifyAddress.errorMsg),
          );
      return;
    }

    ref
        .read(jadeVerifyAddressStateProvider.notifier)
        .setState(JadeVerifyAddressState.success());
  }

  void _handleShowTransaction(From_ShowTransaction showTransaction) {
    ref.read(showTransactionProvider.notifier).setState(showTransaction.tx);
  }

  void _handlePegEdit(GenericResponse pegEdit) {
    pegEdit.success
        ? ref
              .read(pegOutEditFeeRateResultStreamProvider.notifier)
              .setResult(PegOutEditFeeRateResult.success())
        : ref
              .read(pegOutEditFeeRateResultStreamProvider.notifier)
              .setResult(PegOutEditFeeRateResult.failure(pegEdit.errorMsg));
  }

  void _handleSignerRequest(From_SignerRequest signerRequest) {
    ref.read(notificationsProvider.notifier).addNotification(signerRequest);
  }

  void _handleSignerReturn() async {
    if (Platform.isAndroid) {
      final platform = MethodChannel('app.sideswap.io/minimize');
      await platform.invokeMethod<void>('minimizeApp');
    }
    // There is nothing we can do on iOS
  }

  void _handleSessionList(From_SessionList sessionList) {
    ref
        .read(swaptionSessionProvider.notifier)
        .replaceSessions(sessionList.sessions);
  }

  void _handleSessionAdded(From_SessionAdded sessionAdded) {
    ref.read(swaptionSessionProvider.notifier).addSession(sessionAdded.session);
  }

  void _handleSessionRemoved(From_SessionRemoved sessionRemoved) {
    ref
        .read(swaptionSessionProvider.notifier)
        .removeSessions(sessionRemoved.sessionId);
  }

  void _handleSignerCancel(From_SignerCancel signerCancel) {
    ref
        .read(notificationsProvider.notifier)
        .cancelNotification(signerCancel.reqId);
  }
}
