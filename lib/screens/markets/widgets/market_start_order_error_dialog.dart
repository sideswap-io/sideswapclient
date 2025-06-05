import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/markets/widgets/d_start_order_error_dialog.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/quote_event_providers.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap/screens/markets/widgets/mobile_start_order_error_dialog.dart';

const marketStartOrderErrorRouteName = '/startOrderErrorDialog';
const marketStartOrderQuoteErrorRouteName = '/startOrderQuoteErrorDialog';
const marketStartOrderLowBalanceErrorRouteName =
    '/startOrderLowBalanceErrorDialog';
const marketStartOrderUnregisteredGaidRouteName =
    '/startOrderUnregisteredGaidDialog';

class MarketStartOrderErrorDialog extends HookConsumerWidget {
  const MarketStartOrderErrorDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final closeCallback = useCallback(() {
      // clear order submit state
      ref.invalidate(marketStartOrderErrorNotifierProvider);

      Navigator.of(context, rootNavigator: false).popUntil((route) {
        return route.settings.name != marketStartOrderErrorRouteName;
      });
    });

    return switch (FlavorConfig.isDesktop) {
      true => DStartOrderErrorDialog(onClose: closeCallback),
      _ => MobileStartOrderErrorDialog(onClose: closeCallback),
    };
  }
}

class MarketStartOrderQuoteErrorDialog extends HookConsumerWidget {
  const MarketStartOrderQuoteErrorDialog({
    super.key,
    required this.optionStartOrderQuoteError,
  });

  final Option<QuoteError> optionStartOrderQuoteError;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final closeCallback = useCallback(() {
      Navigator.of(context, rootNavigator: false).popUntil((route) {
        return route.settings.name != marketStartOrderQuoteErrorRouteName;
      });
    });

    return DStartOrderQuoteErrorDialog(
      onClose: closeCallback,
      optionStartOrderQuoteError: optionStartOrderQuoteError,
    );
  }
}

class MarketStartOrderLowBalanceErrorDialog extends HookConsumerWidget {
  const MarketStartOrderLowBalanceErrorDialog({
    super.key,
    required this.optionStartOrderQuoteLowBalance,
  });

  final Option<QuoteLowBalance> optionStartOrderQuoteLowBalance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final closeCallback = useCallback(() {
      ref.read(quoteEventNotifierProvider.notifier).stopQuotes();
      Navigator.of(context, rootNavigator: false).popUntil((route) {
        return route.settings.name != marketStartOrderLowBalanceErrorRouteName;
      });
    });

    return DStartOrderLowBalanceErrorDialog(
      onClose: closeCallback,
      optionStartOrderQuoteLowBalance: optionStartOrderQuoteLowBalance,
    );
  }
}

class MarketStartOrderUnregisteredGaidDialog extends HookConsumerWidget {
  const MarketStartOrderUnregisteredGaidDialog({
    required this.optionStartOrderUnregisteredGaid,
    super.key,
  });

  final Option<QuoteUnregisteredGaid> optionStartOrderUnregisteredGaid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final closeCallback = useCallback(() {
      ref.read(quoteEventNotifierProvider.notifier).stopQuotes();
      Navigator.of(context, rootNavigator: false).popUntil((route) {
        return route.settings.name != marketStartOrderUnregisteredGaidRouteName;
      });
    });

    return DStartOrderUnregisteredGaidDialog(
      onClose: closeCallback,
      optionStartOrderUnregisteredGaid: optionStartOrderUnregisteredGaid,
    );
  }
}
