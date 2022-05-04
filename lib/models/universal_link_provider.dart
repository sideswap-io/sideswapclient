import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sideswap/common/utils/enum_as_string.dart';
import 'package:sideswap/models/payment_provider.dart';
import 'package:sideswap/models/qrcode_provider.dart';
import 'package:sideswap/protobuf/sideswap.pb.dart';
import 'package:sideswap/screens/pay/payment_amount_page.dart';
import 'package:sideswap/common/utils/build_config.dart';
import 'package:uni_links/uni_links.dart';
import 'package:sideswap/common/utils/custom_logger.dart';
import 'package:sideswap/models/wallet.dart';

final universalLinkProvider = ChangeNotifierProvider<UniversalLinkProvider>(
    (ref) => UniversalLinkProvider(ref));

enum HandleResult {
  unknown,
  failed,
  success,
}

class UniversalLinkProvider with ChangeNotifier {
  final Ref ref;

  UniversalLinkProvider(this.ref);

  bool _initialUriIsHandled = false;
  StreamSubscription? uriLinkSubscription;
  Uri? initialUri;
  Uri? latestUri;

  void handleIncomingLinks() {
    if (!universalLinksAvailable()) {
      return;
    }
    if (!kIsWeb) {
      // It will handle app links while the app is already started - be it in
      // the foreground or in the background.
      uriLinkSubscription = uriLinkStream.listen((Uri? uri) {
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
      return HandleResult.unknown;
    }
    return handleAppUri(parsedUri);
  }

  HandleResult handleAppUri(Uri uri) {
    if (uri.host != 'app.sideswap.io') {
      return HandleResult.unknown;
    }

    switch (uri.path) {
      case '/submit/':
        return handleSubmitOrder(uri);
      case '/app2app/':
        return handleApp2App(uri);
      case '/swap/':
        return handleSwapPrompt(uri);
    }

    return HandleResult.failed;
  }

  HandleResult handleSubmitOrder(Uri uri) {
    final orderId = uri.queryParameters['order_id'];
    if (orderId != null) {
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

  // use qr scanner parser here to keep parseBIP21 code in one place
  HandleResult handleApp2App(Uri uri) {
    final addressTypeParameter = uri.queryParameters['addressType'];
    if (addressTypeParameter == null) {
      logger.w('uri address type is wrong');
      return HandleResult.failed;
    }

    final addressType =
        enumValueFromString(addressTypeParameter, QrCodeAddressType.values);

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

    final result = ref
        .read(qrcodeProvider)
        .parseBIP21(qrCode: fakeAddress, addressType: addressType);

    ref.read(paymentProvider).selectPaymentAmountPage(
          PaymentAmountPageArguments(
            result: result,
          ),
        );
    return HandleResult.success;
  }
}
