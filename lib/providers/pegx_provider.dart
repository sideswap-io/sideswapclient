import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:fixnum/fixnum.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/providers/env_provider.dart';
import 'package:sideswap/providers/pegx_connection.dart';

import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/models/pegx_model.dart';
import 'package:sideswap/providers/amp_id_provider.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart';
import 'package:sideswap/side_swap_client_ffi.dart';
import 'package:sideswap_protobuf/pegx_api.dart';

part 'pegx_provider.g.dart';

const String pegxAuthIdUrl = 'https://autheid.com/app/requests/?request_id=';
const String pegxStagingAuthIdUrl =
    'https://autheid.com/app/requests/?request_id=';
// const String pegxStagingAuthIdUrl =
//     'https://staging.autheid.com/app/requests/?request_id=';

const String pegxIntraAutheIdUrl =
    'autheid://autheid.com/app/requests/?request_id=';

// const String testnetPegxApiUrl = 'wss://api-staging.pegx.io/protobuf';
const String testnetPegxApiUrl = 'wss://testnet.pegx.io/api';
const String pegxApiUrl = 'wss://pegx.io/api';

@riverpod
class PegxLoginStateNotifier extends _$PegxLoginStateNotifier {
  @override
  PegxLoginState build() {
    return const PegxLoginStateLoading();
  }

  void setState(PegxLoginState pegxLoginState) {
    state = pegxLoginState;
  }
}

// (malcolmpl): it must maintain state for the entire life of the application!
@Riverpod(keepAlive: true)
class PegxGaidNotifier extends _$PegxGaidNotifier {
  @override
  PegxGaidState build() {
    return const PegxGaidStateEmpty();
  }

  void setState(PegxGaidState pegxGaidState) {
    state = pegxGaidState;
  }
}

@Riverpod(keepAlive: true)
class PegxRegisterFailedNotifier extends _$PegxRegisterFailedNotifier {
  @override
  String build() {
    return '';
  }

  void setState(String value) {
    state = value;
  }
}

/// Generates random Int64 in range [min, max).
Int64 pegxRandomId({int min = 0, int? max}) {
  max ??= Int64.MAX_VALUE.toInt();
  if (min > max) {
    throw ArgumentError(
      'Value passed for `min` ($min) must be less than value passed for `max` ($max)',
    );
  }
  final rng = math.Random();
  return Int64((rng.nextDouble() * (max - min)).toInt() + min);
}

@Riverpod(keepAlive: true)
PegxProtocolHandler pegxWebsocketClient(Ref ref) {
  final env = ref.watch(envProvider);
  return PegxProtocolHandler(ref, env);
}

class PegxProtocolHandler {
  final Ref ref;
  final int _env;
  final PegxConnection _connection;
  final Int64 Function() _idGenerator;

  Timer? _heartBeatTimer, _reconnectTimer;
  int _reconnectCount = 120;
  final int _heartbeatInterval = 10;
  final int _reconnectIntervalMs = 5000;

  String? _token;
  String? _accountKey;
  Int64 _lastAddGaidId = Int64();

  PegxProtocolHandler(
    this.ref,
    this._env, {
    PegxConnection? connection,
    Int64 Function()? idGenerator,
  }) : _connection = connection ?? PegxConnection(),
       _idGenerator = idGenerator ?? pegxRandomId;

  // TODO (malcolmpl): disconnect from websocket when server serverLoginStateProvider change to ServerLoginStateLogout
  Future<void> connectToSocket() async {
    if (_connection.isConnected) return;
    _lastAddGaidId = Int64();
    final apiUrl = switch (_env) {
      SIDESWAP_ENV_TESTNET || SIDESWAP_ENV_LOCAL_TESTNET => testnetPegxApiUrl,
      _ => pegxApiUrl,
    };
    logger.d('Pegx API endpoint: $apiUrl');
    try {
      await _connection.connect(apiUrl);
      _reconnectTimer?.cancel();
      _listenToMessage();
      _connection.drainBuffer();
      _startHeartBeatTimer();
    } catch (error, stackTrace) {
      logger.e(error);
      logger.e(stackTrace);
      disconnect();
      unawaited(_reconnect());
    }
  }

  void _listenToMessage() {
    _connection.stream?.listen(
      (dynamic message) {
        final response = Res.fromBuffer(message as Uint8List);
        switch (response.whichBody()) {
          case Res_Body.resp:
            handleResp(response.resp);
          case Res_Body.notif:
            handleNotif(response.notif);
          case Res_Body.error:
            handleError(response.error);
          case Res_Body.notSet:
            break;
        }
      },
      onDone: () {
        disconnect();
        unawaited(_reconnect());
      },
    );
  }

  void handleNotif(Notif notif) {
    switch (notif.whichBody()) {
      case Notif_Body.loginOrRegisterFailed:
        // logger.d('Pegx <= $notif');
        // logger.w("Notify register failed: ${notif.registerFailed.text}");
        ref
            .read(pegxRegisterFailedProvider.notifier)
            .setState(notif.loginOrRegisterFailed.text);
        break;
      case Notif_Body.loginOrRegisterSucceed:
        // logger.d('Pegx <= $notif');
        // logger.w('Notify register succeed');
        _token = notif.loginOrRegisterSucceed.token;
        resume(token: _token);

        break;
      case Notif_Body.freeShares:
        break;
      case Notif_Body.buyShares:
        break;
      case Notif_Body.soldShares:
        break;
      case Notif_Body.userShares:
        break;
      case Notif_Body.updatePrices:
        break;
      case Notif_Body.updateMarketData:
        break;
      case Notif_Body.updateBalances:
        break;
      case Notif_Body.notSet:
        break;
    }
  }

  void handleResp(Resp resp) {
    switch (resp.whichBody()) {
      case Resp_Body.loginOrRegister:
        // logger.d('Pegx <= $resp');
        // logger.w('Resp login');
        ref
            .read(pegxLoginStateProvider.notifier)
            .setState(
              PegxLoginStateLogin(requestId: resp.loginOrRegister.requestId),
            );

        break;
      case Resp_Body.resume:
        // logger.d('Pegx <= $resp');
        // logger.w("Resp resume");

        final gaids = resp.resume.accounts[0].gaids;
        final ampId = ref.read(ampIdProvider);
        if (gaids.contains(ampId)) {
          ref
              .read(pegxLoginStateProvider.notifier)
              .setState(const PegxLoginStateGaidAdded());
          return;
        }

        ref
            .read(pegxLoginStateProvider.notifier)
            .setState(const PegxLoginStateLogged());
        _accountKey = resp.resume.accounts[0].accountKey;

        break;
      case Resp_Body.logout:
        break;
      case Resp_Body.registerIssuer:
        break;
      case Resp_Body.addGaid:
        _lastAddGaidId = Int64();
        // logger.d('Pegx <= $resp');
        ref
            .read(pegxLoginStateProvider.notifier)
            .setState(const PegxLoginStateGaidAdded());
        break;
      case Resp_Body.loadAssets:
        break;
      case Resp_Body.buyShares:
        break;
      case Resp_Body.loadCountries:
        break;
      case Resp_Body.loadRegs:
        break;
      case Resp_Body.updateReg:
        break;
      case Resp_Body.loadFile:
        break;
      case Resp_Body.listAllTransactions:
        break;
      case Resp_Body.listOwnTransactions:
        break;
      case Resp_Body.listAllBalances:
        break;
      case Resp_Body.listAllSeries:
        break;
      case Resp_Body.notSet:
        break;
    }
  }

  void handleError(Err error) {
    logger.e("Pegx error ${error.id}: ${error.text}");

    if (error.id == _lastAddGaidId) {
      _lastAddGaidId = Int64();
      ref
          .read(pegxLoginStateProvider.notifier)
          .setState(const PegxLoginStateGaidError());
      return;
    }
  }

  Future<void> _reconnect() async {
    if ((_reconnectTimer == null || !(_reconnectTimer?.isActive == true)) &&
        _reconnectCount > 0) {
      _reconnectTimer = Timer.periodic(
        Duration(milliseconds: _reconnectIntervalMs),
        (Timer timer) async {
          logger.d('Pegx reconnecting...');
          if (_reconnectCount == 0) {
            _reconnectTimer?.cancel();
            return;
          }
          await connectToSocket();
          _reconnectCount--;
        },
      );
    }
  }

  void disconnect() {
    if (_connection.isConnected) {
      ref
          .read(pegxLoginStateProvider.notifier)
          .setState(const PegxLoginStateLoading());
      logger.d('Pegx disconnected.');
      _connection.close();
      _heartBeatTimer?.cancel();
      _reconnectTimer?.cancel();
    }
  }

  void _startHeartBeatTimer() {
    _heartBeatTimer = Timer.periodic(Duration(seconds: _heartbeatInterval), (
      Timer timer,
    ) {
      final buffer = Req(loadAssets: Req_LoadAssets());
      _connection.send(buffer.writeToBuffer());
    });
  }

  void login() {
    final reqLogin = Req(
      loginOrRegister: Req_LoginOrRegister(),
      id: _idGenerator(),
    );
    _connection.send(reqLogin.writeToBuffer());
  }

  void resume({String? token}) {
    final reqResume = Req(resume: Req_Resume(token: token));
    _connection.send(reqResume.writeToBuffer());
  }

  void addGaid() {
    if (_lastAddGaidId != 0) {
      return;
    }

    ref
        .read(pegxLoginStateProvider.notifier)
        .setState(const PegxLoginStateGaidWaiting());

    final ampId = ref.read(ampIdProvider);
    // handle amp error
    if (ampId.isEmpty) {
      errorAndGoBack('Adding AMP ID failed. Try again.'.tr());
      return;
    }

    _lastAddGaidId = _idGenerator();
    final reqAddGaid = Req(
      addGaid: Req_AddGaid(gaid: ampId, accountKey: _accountKey),
      id: _lastAddGaidId,
    );
    _connection.send(reqAddGaid.writeToBuffer());
  }

  void errorAndGoBack(String error) {
    ref.read(pegxRegisterFailedProvider.notifier).setState(error);

    disconnect();

    ref.read(pageStatusProvider.notifier).setStatus(Status.ampRegister);
  }
}
