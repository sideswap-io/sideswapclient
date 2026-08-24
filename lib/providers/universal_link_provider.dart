import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:sideswap/common/enums.dart';
import 'package:sideswap/common/utils/build_config.dart';
import 'package:sideswap/common/utils/enum_as_string.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/models/connection_models.dart';
import 'package:sideswap/providers/bip32_providers.dart';
import 'package:sideswap/providers/connection_state_providers.dart';
import 'package:sideswap/providers/payment_provider.dart';
import 'package:sideswap/providers/qrcode_provider.dart';
import 'package:sideswap/providers/ui_state_args_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart';
import 'package:sideswap/screens/pay/payment_amount_page.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

part 'universal_link_provider.freezed.dart';
part 'universal_link_provider.g.dart';

typedef SwapLinkResultCallback = void Function(Int64 orderId, String privateId);

@freezed
sealed class LinkResultDetails with _$LinkResultDetails {
  const factory LinkResultDetails.swap({String? orderId, String? privateId}) =
      LinkResultDetailsSwap;
  const factory LinkResultDetails.swaption({Uri? uri}) =
      LinkResultDetailsSwaption;
}

@freezed
sealed class LinkResultState with _$LinkResultState {
  const factory LinkResultState.empty() = LinkResultStateEmpty;
  const factory LinkResultState.unknown() = LinkResultStateUnknown;
  const factory LinkResultState.unknownUri() = LinkResultStateUnknownUri;
  const factory LinkResultState.unknownScheme() = LinkResultStateUnknownScheme;
  const factory LinkResultState.unknownHost() = LinkResultStateUnknownHost;
  const factory LinkResultState.failed() = LinkResultStateFailed;
  const factory LinkResultState.failedUriPath() = LinkResultStateFailedUriPath;
  const factory LinkResultState.success({LinkResultDetails? details}) =
      LinkResultStateSuccess;
}

@Riverpod(keepAlive: true)
class UniversalLinkResultStateNotifier
    extends _$UniversalLinkResultStateNotifier {
  @override
  LinkResultState build() {
    return LinkResultState.empty();
  }

  void setState(LinkResultState linkResultState) {
    state = linkResultState;
  }
}

@Riverpod(keepAlive: true)
UniversalLink universalLink(Ref ref) {
  final walletMainArguments = ref.watch(uiStateArgsProvider);
  return UniversalLink(walletMainArguments, ref);
}

String getSendLinkUrl(String address) {
  return 'https://app.sideswap.io/send/?address=$address';
}

class UniversalLink {
  final Ref ref;
  final WalletMainArguments walletMainArguments;

  final AppLinks _appLinks;

  UniversalLink(this.walletMainArguments, this.ref, {AppLinks? appLinks})
    : _appLinks = appLinks ?? AppLinks();

  bool _initialUriIsHandled = false;
  StreamSubscription<Uri>? uriLinkSubscription;
  Uri? initialUri;
  Uri? latestUri;

  void handleIncomingLinks() {
    logger.d('UniversalLink::handleIncomingLinks() called');

    if (!universalLinksAvailable()) {
      return;
    }
    if (!kIsWeb) {
      // It will handle app links while the app is already started - be it in
      // the foreground or in the background.
      uriLinkSubscription?.cancel();
      uriLinkSubscription = _appLinks.uriLinkStream.listen(
        (Uri? uri) {
          if (!ref.mounted) return;
          logger.d('UniversalLink::handleIncomingLinks: new incoming uri $uri');
          latestUri = uri;
          if (uri != null) {
            // uri incoming too early, we need to store it for later use
            final serverState = ref.read(serverLoginProvider);
            if (serverState is! ServerLoginStateLogin) {
              initialUri = uri;
              logger.d(
                'UniversalLink::handleIncomingLinks: storing initial uri for later use $uri',
              );
              return;
            }

            final linkResultState = handleAppUri(uri);
            logger.d(
              'UniversalLink::handleIncomingLinks: link result state $linkResultState',
            );
            ref
                .read(universalLinkResultStateProvider.notifier)
                .setState(linkResultState);
            return;
          }
          logger.d('UniversalLink::handleIncomingLinks: empty uri');
        },
        onError: (Object err) {
          logger.e('UniversalLink::handleIncomingLinks: error $err');
          latestUri = null;
        },
      );
      ref.onDispose(() => uriLinkSubscription?.cancel());
    }
  }

  Future<void> handleInitialUri() async {
    logger.d('UniversalLink::handleInitialUri() called');

    if (!universalLinksAvailable()) {
      return;
    }
    if (!_initialUriIsHandled) {
      _initialUriIsHandled = true;

      try {
        final uri = await _appLinks.getInitialLink();
        if (uri == null) {
          logger.d('UniversalLink::handleInitialUri: empty initial uri');
          return;
        }

        initialUri = uri;
        logger.d(
          'UniversalLink::handleInitialUri: storing initial uri for later use $uri',
        );
      } on PlatformException catch (err) {
        // Platform messages may fail but we ignore the exception
        logger.e(
          'UniversalLink::handleInitialUri: failed to get initial uri $err',
        );
      } on FormatException catch (err) {
        logger.e('UniversalLink::handleInitialUri: malformed initial uri $err');
      }
    }
  }

  double? getDouble(Uri uri, String name) {
    return double.tryParse(uri.queryParameters[name] ?? '');
  }

  // handleAppUrlStr is used to handle pasted app links from clipboard or from qr code
  // pasted links shouldn't handle swaption urls
  LinkResultState handleAppUrlStr(String uri, {bool handleSwaption = true}) {
    final parsedUri = Uri.tryParse(uri);
    if (parsedUri == null) {
      return const LinkResultState.unknownUri();
    }

    return handleAppUri(parsedUri, handleSwaption: handleSwaption);
  }

  LinkResultState handleAppUri(Uri uri, {bool handleSwaption = true}) {
    logger.d('UniversalLink::handleAppUri: uri $uri');

    return switch (uri.scheme) {
      'https' => () {
        if (uri.host != 'app.sideswap.io') {
          return const LinkResultState.unknownHost();
        }

        return switch (uri.path) {
          '/login/' ||
          '/sign/' => handleSigner(uri, handleSwaption: handleSwaption),
          '/submit/' => handleSubmitOrder(uri),
          '/app2app/' => handleApp2App(uri),
          '/swap/' => handleSwapPrompt(uri),
          '/send/' => handleSendLink(uri),
          _ => const LinkResultState.failedUriPath(),
        };
      },
      'liquidconnect' => () {
        return handleSigner(uri, handleSwaption: handleSwaption);
      },
      _ => () {
        return const LinkResultState.unknownScheme();
      },
    }();
  }

  LinkResultState handleSigner(Uri uri, {bool handleSwaption = true}) {
    if (handleSwaption) {
      final msg = To();
      msg.appLink = To_AppLink(url: uri.toString());
      ref.read(walletProvider).sendMsg(msg);
    }

    return LinkResultState.success(
      details: LinkResultDetails.swaption(uri: uri),
    );
  }

  LinkResultState handleSubmitOrder(Uri uri) {
    return const LinkResultState.failed();
  }

  LinkResultState handleSwapPrompt(Uri uri) {
    final orderId = uri.queryParameters['order_id'] ?? '';
    final privateId = uri.queryParameters['private_id'] ?? '';

    if (orderId.isNotEmpty) {
      return LinkResultState.success(
        details: LinkResultDetails.swap(orderId: orderId, privateId: privateId),
      );
    }

    return LinkResultState.failed();
  }

  LinkResultState handleSendLink(Uri uri) {
    final address = uri.queryParameters['address'];
    if (address != null) {
      ref
          .read(paymentAmountPageArgumentsProvider.notifier)
          .setPaymentAmountPageArguments(
            PaymentAmountPageArguments(result: QrCodeResult(address: address)),
          );
      ref.read(pageStatusProvider.notifier).setStatus(Status.paymentAmountPage);

      return const LinkResultState.success();
    }

    return const LinkResultState.failed();
  }

  // use qr scanner parser here to keep parseBIP21 code in one place
  LinkResultState handleApp2App(Uri uri) {
    final addressTypeParameter = uri.queryParameters['addressType'];
    if (addressTypeParameter == null) {
      logger.w('uri address type is wrong');
      return const LinkResultState.failed();
    }

    final addressType = enumValueFromString(
      addressTypeParameter,
      BIP21AddressTypeEnum.values,
    );

    if (addressType == null) {
      logger.w('cannot convert uri address type');
      return const LinkResultState.failed();
    }

    final query = uri.queryParameters;

    final address = query['address'];
    if (address == null) {
      logger.w('uri address is empty');
      return const LinkResultState.failed();
    }

    var fakeAddress = '${addressType.asString()}:$address?';

    for (var key in query.keys) {
      if (key == 'address' || key == 'addressType') {
        continue;
      }

      fakeAddress = '$fakeAddress&$key=${query[key]}';
    }

    final result = ref.read(parseBIP21Provider(fakeAddress, addressType));

    return result.match((l) => const LinkResultState.unknownScheme(), (r) {
      ref
          .read(paymentAmountPageArgumentsProvider.notifier)
          .setPaymentAmountPageArguments(
            PaymentAmountPageArguments(
              result: QrCodeResult(
                amount: r.amount,
                label: r.label,
                message: r.message,
                assetId: r.assetId,
                ticker: r.ticker,
                address: r.address,
                addressType: r.addressType,
              ),
            ),
          );
      ref.read(pageStatusProvider.notifier).setStatus(Status.paymentAmountPage);

      return const LinkResultState.success();
    });
  }

  bool handleSwapLinkResult(
    LinkResultState linkResultState,
    SwapLinkResultCallback callback,
  ) {
    if (linkResultState is! LinkResultStateSuccess) {
      return false;
    }

    final details = linkResultState.details;

    return switch (details) {
      LinkResultDetailsSwap(:final orderId, :final privateId)
          when orderId != null && privateId != null =>
        () {
          final parsedOrderId = Int64.tryParseInt(orderId);
          if (parsedOrderId == null) {
            logger.e(
              'UniversalLink::handleSwapLinkResult: invalid order id $orderId',
            );
            return false;
          }

          callback.call(parsedOrderId, privateId);
          return true;
        },
      _ => () {
        return false;
      },
    }();
  }
}
