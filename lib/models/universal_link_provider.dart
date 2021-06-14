import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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
          handleSubmitOrder(uri);
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

  void handleSubmitOrder(Uri uri) {
    if (uri.host != 'app.sideswap.io' || uri.path != '/submit/') {
      logger.w('unexpected host or path: $uri');
      return;
    }

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
      read(walletProvider)
          .submitOrder(sessionId, assetId, bitcoinAmount, price, indexPrice);
      return;
    }

    logger.w('Invalid URI: $uri');
  }
}
