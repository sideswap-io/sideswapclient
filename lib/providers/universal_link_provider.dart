import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:fixnum/fixnum.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/enums.dart';
import 'package:sideswap/common/utils/enum_as_string.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/providers/bip32_providers.dart';
import 'package:sideswap/providers/payment_provider.dart';
import 'package:sideswap/providers/qrcode_provider.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart';
import 'package:sideswap/screens/pay/payment_amount_page.dart';
import 'package:sideswap/common/utils/build_config.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';
import 'package:sideswap/providers/wallet.dart';

final universalLinkProvider = ChangeNotifierProvider<UniversalLinkProvider>(
    (ref) => UniversalLinkProvider(ref));

enum HandleResult {
  unknown,
  unknownUri,
  unknownScheme,
  unknownHost,
  failed,
  failedUriPath,
  success,
}

String getSendLinkUrl(String address) {
  return 'https://app.sideswap.io/send/?address=$address';
}

class UniversalLinkProvider with ChangeNotifier {
  final Ref ref;
  final _appLinks = AppLinks();

  UniversalLinkProvider(this.ref);

  bool _initialUriIsHandled = false;
  StreamSubscription<Uri>? uriLinkSubscription;
  Uri? initialUri;
  Uri? latestUri;

  void handleIncomingLinks() {
    if (!universalLinksAvailable()) {
      return;
    }
    if (!kIsWeb) {
      // It will handle app links while the app is already started - be it in
      // the foreground or in the background.
      uriLinkSubscription?.cancel();
      uriLinkSubscription = _appLinks.uriLinkStream.listen((Uri? uri) {
        logger.d('got uri: $uri');
        latestUri = uri;
        if (uri != null) {
          handleAppUri(uri);
        }
      }, onError: (Object err) {
        logger.e('got err: $err');
        latestUri = null;
      });
    }
  }

  Future<void> handleInitialUri() async {
    if (!universalLinksAvailable()) {
      return;
    }
    if (!_initialUriIsHandled) {
      _initialUriIsHandled = true;

      try {
        final uri = await _appLinks.getInitialLink();
        if (uri == null) {
          logger.d('no initial uri');
          return;
        } else {
          logger.d('got initial uri: $uri');
        }
        initialUri = uri;
      } on PlatformException catch (err) {
        // Platform messages may fail but we ignore the exception
        logger.e('failed to get initial uri: $err');
      } on FormatException catch (err) {
        logger.e('malformed initial uri: $err');
      }
    }
  }

  double? getDouble(Uri uri, String name) {
    return double.tryParse(uri.queryParameters[name] ?? '');
  }

  HandleResult handleAppUrlStr(String uri) {
    final parsedUri = Uri.tryParse(uri);
    if (parsedUri == null) {
      return HandleResult.unknownUri;
    }

    if (parsedUri.scheme != 'https') {
      return HandleResult.unknownScheme;
    }

    return handleAppUri(parsedUri);
  }

  HandleResult handleAppUri(Uri uri) {
    if (uri.host != 'app.sideswap.io') {
      return HandleResult.unknownHost;
    }

    return switch (uri.path) {
      '/submit/' => handleSubmitOrder(uri),
      '/app2app/' => handleApp2App(uri),
      '/swap/' => handleSwapPrompt(uri),
      '/send/' => handleSendLink(uri),
      _ => HandleResult.failedUriPath,
    };
  }

  HandleResult handleSubmitOrder(Uri uri) {
    final orderId = uri.queryParameters['order_id'];
    if (orderId != null && orderId.length == 64) {
      ref.read(walletProvider).linkOrder(orderId);
      return HandleResult.success;
    }

    return HandleResult.failed;
  }

  HandleResult handleSwapPrompt(Uri uri) {
    final market = uri.queryParameters['market'];
    final orderId = uri.queryParameters['order_id'];
    if (orderId is String && orderId.isNotEmpty && market == 'p2p') {
      ref.read(walletProvider).linkOrder(orderId);
      return HandleResult.success;
    }

    try {
      final swap = SwapDetails();
      swap.orderId = uri.queryParameters['order_id']!;
      swap.sendAsset = uri.queryParameters['send_asset']!;
      swap.recvAsset = uri.queryParameters['recv_asset']!;
      swap.sendAmount = Int64(int.parse(uri.queryParameters['send_amount']!));
      swap.recvAmount = Int64(int.parse(uri.queryParameters['recv_amount']!));
      swap.uploadUrl = uri.queryParameters['upload_url']!;

      ref.read(walletProvider).startSwapPrompt(swap);
      return HandleResult.success;
    } on Exception catch (e) {
      logger.w('swap prompt URL parse error: $e');
      return HandleResult.failed;
    }
  }

  HandleResult handleSendLink(Uri uri) {
    final address = uri.queryParameters['address'];
    if (address != null) {
      ref
          .read(paymentAmountPageArgumentsNotifierProvider.notifier)
          .setPaymentAmountPageArguments(PaymentAmountPageArguments(
            result: QrCodeResult(address: address),
          ));
      ref
          .read(pageStatusNotifierProvider.notifier)
          .setStatus(Status.paymentAmountPage);

      return HandleResult.success;
    }

    return HandleResult.failed;
  }

  // use qr scanner parser here to keep parseBIP21 code in one place
  HandleResult handleApp2App(Uri uri) {
    final addressTypeParameter = uri.queryParameters['addressType'];
    if (addressTypeParameter == null) {
      logger.w('uri address type is wrong');
      return HandleResult.failed;
    }

    final addressType =
        enumValueFromString(addressTypeParameter, BIP21AddressTypeEnum.values);

    if (addressType == null) {
      logger.w('cannot convert uri address type');
      return HandleResult.failed;
    }

    final query = uri.queryParameters;

    final address = query['address'];
    if (address == null) {
      logger.w('uri address is empty');
      return HandleResult.failed;
    }

    var fakeAddress = '${addressType.asString()}:$address?';

    for (var key in query.keys) {
      if (key == 'address' || key == 'addressType') {
        continue;
      }

      fakeAddress = '$fakeAddress&$key=${query[key]}';
    }

    final result = ref.read(parseBIP21Provider(fakeAddress, addressType));

    return result.match((l) => HandleResult.unknownScheme, (r) {
      ref
          .read(paymentAmountPageArgumentsNotifierProvider.notifier)
          .setPaymentAmountPageArguments(PaymentAmountPageArguments(
            result: QrCodeResult(
              amount: r.amount,
              label: r.label,
              message: r.message,
              assetId: r.assetId,
              ticker: r.ticker,
              address: r.address,
              addressType: r.addressType,
            ),
          ));
      ref
          .read(pageStatusNotifierProvider.notifier)
          .setStatus(Status.paymentAmountPage);

      return HandleResult.success;
    });
  }
}
