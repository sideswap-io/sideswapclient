import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/utils/enum_as_string.dart';
import 'package:sideswap/models/payment_provider.dart';
import 'package:sideswap/models/qrcode_provider.dart';
import 'package:sideswap/screens/pay/payment_amount_page.dart';
import 'package:uni_links/uni_links.dart';

import 'package:sideswap/common/utils/custom_logger.dart';
import 'package:sideswap/models/wallet.dart';

final universalLinkProvider = ChangeNotifierProvider<UniversalLinkProvider>(
    (ref) => UniversalLinkProvider(ref.read));

class UniversalLinkProvider with ChangeNotifier {
  final Reader read;

  UniversalLinkProvider(this.read);

  bool _initialUriIsHandled = false;
  StreamSubscription? uriLinkSubscription;
  Uri? initialUri;
  Uri? latestUri;

  void handleIncomingLinks() {
    if (!kIsWeb) {
      // It will handle app links while the app is already started - be it in
      // the foreground or in the background.
      uriLinkSubscription = uriLinkStream.listen((Uri? uri) {
        logger.d('got uri: $uri');
        latestUri = uri;
        if (uri != null) {
          handleUri(uri);
        }
      }, onError: (Object err) {
        logger.e('got err: $err');
        latestUri = null;
      });
    }
  }

  Future<void> handleInitialUri() async {
    if (!_initialUriIsHandled) {
      _initialUriIsHandled = true;

      try {
        final uri = await getInitialUri();
        if (uri == null) {
          logger.d('no initial uri');
          return;
        } else {
          logger.d('got initial uri: $uri');
        }
        initialUri = uri;
      } on PlatformException catch (err) {
        // Platform messages may fail but we ignore the exception
        logger.e('falied to get initial uri: $err');
      } on FormatException catch (err) {
        logger.e('malformed initial uri: $err');
      }
    }
  }

  double? getDouble(Uri uri, String name) {
    return double.tryParse(uri.queryParameters[name] ?? '');
  }

  void handleUri(Uri uri) {
    if (uri.host != 'app.sideswap.io') {
      logger.w('unexpected host: $uri');
      return;
    }

    switch (uri.path) {
      case '/submit/':
        handleSubmitOrder(uri);
        return;
      case '/app2app/':
        handleApp2App(uri);
        return;
    }

    logger.w('Invalid URI: $uri');
  }

  void handleSubmitOrder(Uri uri) {
    final orderId = uri.queryParameters['order_id'];
    if (orderId != null) {
      read(walletProvider).linkOrder(orderId);
      return;
    }

    final sessionId = uri.queryParameters['session_id'];
    if (sessionId != null) {
      final assetId = uri.queryParameters['asset_id'] ?? '';
      final bitcoinAmount = getDouble(uri, 'bitcoin_amount') ?? 0;
      final price = getDouble(uri, 'price') ?? 0;
      final indexPrice = getDouble(uri, 'index_price');
      read(walletProvider).submitOrder(
        assetId,
        bitcoinAmount,
        price,
        sessionId: sessionId,
        indexPrice: indexPrice,
      );
      return;
    }
  }

  // use qr scanner parser here to keep parseBIP21 code in one place
  void handleApp2App(Uri uri) {
    final addressTypeParameter = uri.queryParameters['addressType'];
    if (addressTypeParameter == null) {
      logger.w('uri address type is wrong');
      return;
    }

    final addressType =
        enumValueFromString(addressTypeParameter, QrCodeAddressType.values);

    if (addressType == null) {
      logger.w('cannot convert uri address type');
      return;
    }

    final query = uri.queryParameters;

    final address = query['address'];
    if (address == null) {
      logger.w('uri address is empty');
      return;
    }

    var fakeAddress = '${addressType.asString()}:$address?';

    for (var key in query.keys) {
      if (key == 'address' || key == 'addressType') {
        continue;
      }

      fakeAddress = '$fakeAddress&$key=${query[key]}';
    }

    final result = read(qrcodeProvider)
        .parseBIP21(qrCode: fakeAddress, addressType: addressType);

    read(paymentProvider).selectPaymentAmountPage(
      PaymentAmountPageArguments(
        result: result,
      ),
    );
  }
}
