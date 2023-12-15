import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/models/endpoint_internal_model.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/providers/desktop_dialog_providers.dart';
import 'package:sideswap/providers/payment_provider.dart';
import 'package:sideswap/providers/receive_address_providers.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/connection_state_providers.dart';
import 'package:sideswap_websocket/sideswap_endpoint.dart';

part 'endpoint_provider.g.dart';

@riverpod
EndpointServerProvider endpointServer(EndpointServerRef ref) {
  final endpointServerProvider = EndpointServerProvider(ref);
  ref.onDispose(() {
    endpointServerProvider.stop(force: true);
  });

  return endpointServerProvider;
}

class EndpointServerProvider {
  final EndpointServerRef ref;
  EndpointServer? endpointServer;

  EndpointServerProvider(this.ref);

  void _init() {
    endpointServer = EndpointServer(onRequest: onRequest);
  }

  void serve() {
    if (endpointServer == null) {
      _init();
    }
    endpointServer?.serve();
  }

  void stop({bool force = false}) {
    endpointServer?.stop(force: force);
    endpointServer = null;
  }

  void onRequest(
    EndpointRequest request,
    String channelId,
    String id,
  ) {
    logger.d('$channelId $request');

    final isBackendConnected = ref.read(serverConnectionStateProvider);
    if (!isBackendConnected) {
      logger.w(
          'Client requested: $request but SideSwap isn\'t connected to backend yet.');
      endpointServer?.sendError(
          message: 'Unable to execute request right now, try again later',
          channelId: channelId,
          id: id);
      return;
    }

    (
      switch (request.type) {
        EndpointRequestType.newAddress => () {
            ref.read(walletProvider).toggleRecvAddrType(AccountType.reg);
            // wait a bit for backend reply
            // TODO (malcolmpl): fix this - make listener for received address and then call endpoint function
            Future.delayed(const Duration(seconds: 3), () {
              final receiveAddress = ref.read(currentReceiveAddressProvider);

              if (receiveAddress.recvAddress.isNotEmpty) {
                final reply = EndpointReplyModel(
                  reply: EndpointReply(
                    id: id,
                    type: EndpointReplyType.newAddress,
                    data: EndpointReplyDataNewAddress(
                        address: receiveAddress.recvAddress),
                  ),
                );
                endpointServer?.sendEncrypted(reply, channelId);
              }
            });
          }(),
        EndpointRequestType.createTransaction => () {
            final data = request.data;
            (switch (data) {
              EndpointRequestDataCreateTransaction(
                address: final address?,
                assetId: final assetId?,
                amount: final amount?
              ) =>
                () {
                  final accountAsset = AccountAsset(AccountType.reg, assetId);
                  final balance =
                      ref.read(balancesNotifierProvider)[accountAsset] ?? 0;
                  if (balance == 0) {
                    logger.w(
                        'Unable to execute endpoint request. Balance for $assetId is zero');
                    return;
                  }

                  final createTransactionData = EICreateTransactionData(
                      accountAsset: accountAsset,
                      address: address,
                      amount: amount);
                  ref
                      .read(eiCreateTransactionNotifierProvider.notifier)
                      .setState(createTransactionData);

                  ref.read(paymentProvider).createdTx = null;
                  ref.read(paymentProvider).selectPaymentSend(
                      amount, accountAsset,
                      address: address);
                  ref.read(desktopDialogProvider).closePopups();
                  ref.read(desktopDialogProvider).showSendTx();
                }(),
              _ => () {
                  logger.w('Invalid request data: $request');
                }()
            });
          }(),
        _ => () {
            logger.w('Invalid request type: $request');
          }(),
      },
    );
  }
}

@Riverpod(keepAlive: true)
class EiCreateTransactionNotifier extends _$EiCreateTransactionNotifier {
  @override
  EICreateTransaction build() {
    return EICreateTransactionEmpty();
  }

  void setState(EICreateTransaction createTransactionState) {
    state = createTransactionState;
  }
}
