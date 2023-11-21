import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:fixnum/fixnum.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/models/pegx_model.dart';
import 'package:sideswap/providers/amp_id_provider.dart';
import 'package:sideswap/providers/config_provider.dart';
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

@riverpod
class PegxGaidNotifier extends _$PegxGaidNotifier {
  @override
  PegxGaidState build() {
    return const PegxGaidStateEmpty();
  }

  void setState(PegxGaidState pegxGaidState) {
    state = pegxGaidState;
  }
}

@riverpod
class PegxRegisterFailedNotifier extends _$PegxRegisterFailedNotifier {
  @override
  String build() {
    ref.keepAlive();
    return '';
  }

  void setState(String value) {
    state = value;
  }
}

final pegxWebsocketClientProvider = AutoDisposeProvider((ref) {
  final env = ref.watch(configProvider).env;
  final client = PegxWebsocketClient(ref, env);

  ref.keepAlive();

  client.connectToSocket();

  return client;
});

class PegxWebsocketClient {
  final Ref ref;
  final int _env;

  IOWebSocketChannel? _client;
  bool _isConnected = false;
  final _heartbeatInterval = 10;
  final _reconnectIntervalMs = 5000;
  int _reconnectCount = 120;
  final _sendBuffer = Queue<Req>();
  Timer? _heartBeatTimer, _reconnectTimer;

  String? _token;
  String? _accountKey;

  Int64 _lastAddGaidId = Int64();

  PegxWebsocketClient(this.ref, this._env);

  // TODO (malcolmpl): disconnect from websocket when server serverLoginStateProvider change to ServerLoginStateLogout
  Future<void> connectToSocket() async {
    if (!_isConnected) {
      _lastAddGaidId = Int64();
      final apiUrl = switch (_env) {
        SIDESWAP_ENV_TESTNET || SIDESWAP_ENV_LOCAL_TESTNET => testnetPegxApiUrl,
        _ => pegxApiUrl,
      };

      logger.d('Pegx API endpoint: $apiUrl');
      WebSocket.connect(apiUrl).then((ws) {
        ws.pingInterval = Duration(seconds: _heartbeatInterval);
        _client = IOWebSocketChannel(ws);
        if (_client != null) {
          _reconnectTimer?.cancel();
          _listenToMessage();
          _isConnected = true;
          _startHeartBeatTimer();
          while (_sendBuffer.isNotEmpty) {
            Req buffer = _sendBuffer.first;
            _sendBuffer.remove(buffer);
            _send(buffer);
          }
        }
      }).onError((error, stackTrace) {
        logger.e(error);
        logger.e(stackTrace);
        disconnect();
        _reconnect();
      });
    }
  }

  void _listenToMessage() {
    _client?.stream.listen(
      (dynamic message) {
        final response = Res.fromBuffer(message as Uint8List);
        logger.d("Pegx RESPONSE: $response");
        switch (response.whichBody()) {
          case Res_Body.resp:
            handleResp(response.resp);
            break;
          case Res_Body.notif:
            handleNotif(response.notif);
            break;
          case Res_Body.error:
            handleError(response.error);
            break;
          case Res_Body.notSet:
            break;
        }
      },
      onDone: () {
        disconnect();
        _reconnect();
      },
    );
  }

  void handleNotif(Notif notif) async {
    switch (notif.whichBody()) {
      case Notif_Body.loginOrRegisterFailed:
        // logger.d('Pegx <= $notif');
        // logger.w("Notify register failed: ${notif.registerFailed.text}");
        ref
            .read(pegxRegisterFailedNotifierProvider.notifier)
            .setState(notif.loginOrRegisterFailed.text);
        break;
      case Notif_Body.loginOrRegisterSucceed:
        // logger.d('Pegx <= $notif');
        // logger.w('Notify register succeed');
        _token = notif.loginOrRegisterSucceed.token;
        _accountKey = notif.loginOrRegisterSucceed.accountKey;
        resume(token: _token, accountKey: _accountKey);

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
      case Notif_Body.issuedAmounts:
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
        ref.read(pegxLoginStateNotifierProvider.notifier).setState(
            PegxLoginStateLogin(requestId: resp.loginOrRegister.requestId));

        break;
      case Resp_Body.resume:
        // logger.d('Pegx <= $resp');
        // logger.w("Resp resume");
        final accountState = resp.resume.account.details.accountState;
        if (accountState != AccountState.ACTIVE) {
          errorAndGoBack('Auth eID account isn\'t activated'.tr());
          return;
        }

        final gaids = resp.resume.account.gaids;
        final ampId = ref.read(ampIdProvider);
        if (gaids.contains(ampId)) {
          ref
              .read(pegxLoginStateNotifierProvider.notifier)
              .setState(const PegxLoginStateGaidAdded());
          return;
        }

        ref
            .read(pegxLoginStateNotifierProvider.notifier)
            .setState(const PegxLoginStateLogged());
        break;
      case Resp_Body.logout:
        break;
      case Resp_Body.registerIssuer:
        break;
      case Resp_Body.addGaid:
        _lastAddGaidId = Int64();
        // logger.d('Pegx <= $resp');
        final ampId = ref.read(ampIdProvider);
        if (resp.addGaid.account.gaids.contains(ampId)) {
          ref
              .read(pegxLoginStateNotifierProvider.notifier)
              .setState(const PegxLoginStateGaidAdded());
        } else {
          ref
              .read(pegxLoginStateNotifierProvider.notifier)
              .setState(const PegxLoginStateGaidError());
        }
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
          .read(pegxLoginStateNotifierProvider.notifier)
          .setState(const PegxLoginStateGaidError());
      return;
    }
  }

  Future<void> _reconnect() async {
    if ((_reconnectTimer == null || !(_reconnectTimer?.isActive == true)) &&
        _reconnectCount > 0) {
      _reconnectTimer = Timer.periodic(
          Duration(milliseconds: _reconnectIntervalMs), (Timer timer) async {
        logger.d('Pegx reconnecting...');
        if (_reconnectCount == 0) {
          _reconnectTimer?.cancel();
          return;
        }
        await connectToSocket();
        _reconnectCount--;
      });
    }
  }

  void disconnect() {
    if (_isConnected) {
      ref
          .read(pegxLoginStateNotifierProvider.notifier)
          .setState(const PegxLoginStateLoading());
      logger.d('Pegx disconnected.');
      _client?.sink.close(status.goingAway);
      _heartBeatTimer?.cancel();
      _reconnectTimer?.cancel();
      _isConnected = false;
    }
  }

  void _startHeartBeatTimer() {
    _heartBeatTimer =
        Timer.periodic(Duration(seconds: _heartbeatInterval), (Timer timer) {
      final buffer = Req(loadAssets: Req_LoadAssets());
      _send(buffer);
    });
  }

  void _send(Req buffer) {
    if (_isConnected) {
      logger.d('Pegx => $buffer');
      _client?.sink.add(buffer.writeToBuffer());
      return;
    }

    _sendBuffer.add(buffer);
  }

  void login() {
    final reqLogin = Req(
      loginOrRegister: Req_LoginOrRegister(),
      id: _randomId(),
    );
    _send(reqLogin);
  }

  void resume({String? token, String? accountKey}) {
    final reqResume =
        Req(resume: Req_Resume(token: token, accountKey: accountKey));
    _send(reqResume);
  }

  void addGaid() {
    if (_lastAddGaidId != 0) {
      return;
    }

    ref
        .read(pegxLoginStateNotifierProvider.notifier)
        .setState(const PegxLoginStateGaidWaiting());

    final ampId = ref.read(ampIdProvider);
    // handle amp error
    if (ampId.isEmpty) {
      errorAndGoBack('Adding AMP ID failed. Try again.'.tr());
      return;
    }

    _lastAddGaidId = _randomId();
    final reqAddGaid = Req(
      addGaid: Req_AddGaid(
        gaid: ampId,
      ),
      id: _lastAddGaidId,
    );
    _send(reqAddGaid);
  }

  void errorAndGoBack(String error) {
    ref.read(pegxRegisterFailedNotifierProvider.notifier).setState(error);

    disconnect();

    ref.read(pageStatusStateProvider.notifier).setStatus(Status.ampRegister);
  }

  /// generates a random Int64 whose value falls between [min] (inclusive) and [max] (exclusive)
  Int64 _randomId({int min = 0, int? max}) {
    // -- force default even if `null` is explicitly passed
    max ??= Int64.MAX_VALUE.toInt();

    if (min > max) {
      throw ArgumentError(
          'Value passed for `min` ($min) must be less than value passed for `max` ($max)');
    }

    final rng = math.Random();
    var multiplier = rng.nextDouble();

    return Int64((multiplier * (max - min)).toInt() + min);
  }
}
