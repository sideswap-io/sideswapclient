import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:sideswap/common/enums.dart';
import 'package:sideswap/common/utils/build_config.dart';
import 'package:sideswap/common/utils/enum_as_string.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/providers/bip32_providers.dart';
import 'package:sideswap/providers/payment_provider.dart';
import 'package:sideswap/providers/qrcode_provider.dart';
import 'package:sideswap/providers/ui_state_args_provider.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart';
import 'package:sideswap/screens/pay/payment_amount_page.dart';

part 'universal_link_provider.freezed.dart';
part 'universal_link_provider.g.dart';

typedef SwapLinkResultCallback = void Function(Int64 orderId, String privateId);

@freezed
sealed class LinkResultDetails with _$LinkResultDetails {
  const factory LinkResultDetails.swap({String? orderId, String? privateId}) =
      LinkResultDetailsSwap;
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
  final walletMainArguments = ref.watch(uiStateArgsNotifierProvider);
  return UniversalLink(walletMainArguments, ref);
}

String getSendLinkUrl(String address) {
  return 'https://app.sideswap.io/send/?address=$address';
}

class UniversalLink {
  final Ref ref;
  final WalletMainArguments walletMainArguments;

  final _appLinks = AppLinks();

  UniversalLink(this.walletMainArguments, this.ref);

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
      uriLinkSubscription = _appLinks.uriLinkStream.listen(
        (Uri? uri) {
          logger.d('got uri: $uri');
          latestUri = uri;
          if (uri != null) {
            final linkResultState = handleAppUri(uri);
            ref
                .read(universalLinkResultStateNotifierProvider.notifier)
                .setState(linkResultState);
          }
        },
        onError: (Object err) {
          logger.e('got err: $err');
          latestUri = null;
        },
      );
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

  LinkResultState handleAppUrlStr(String uri) {
    final parsedUri = Uri.tryParse(uri);
    if (parsedUri == null) {
      return const LinkResultState.unknownUri();
    }

    if (parsedUri.scheme != 'https') {
      return const LinkResultState.unknownScheme();
    }

    return handleAppUri(parsedUri);
  }

  LinkResultState handleAppUri(Uri uri) {
    if (uri.host != 'app.sideswap.io') {
      return const LinkResultState.unknownHost();
    }

    return switch (uri.path) {
      '/submit/' => handleSubmitOrder(uri),
      '/app2app/' => handleApp2App(uri),
      '/swap/' => handleSwapPrompt(uri),
      '/send/' => handleSendLink(uri),
      _ => const LinkResultState.failedUriPath(),
    };
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
          .read(paymentAmountPageArgumentsNotifierProvider.notifier)
          .setPaymentAmountPageArguments(
            PaymentAmountPageArguments(result: QrCodeResult(address: address)),
          );
      ref
          .read(pageStatusNotifierProvider.notifier)
          .setStatus(Status.paymentAmountPage);

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
          .read(paymentAmountPageArgumentsNotifierProvider.notifier)
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
      ref
          .read(pageStatusNotifierProvider.notifier)
          .setStatus(Status.paymentAmountPage);

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

    if (details == null ||
        details.orderId == null ||
        details.privateId == null) {
      return false;
    }

    final orderId = Int64.tryParseInt(details.orderId!);

    if (orderId == null) {
      return false;
    }

    callback.call(orderId, details.privateId!);
    return true;
  }
}
