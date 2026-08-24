import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/markets/widgets/d_preview_order_dialog.dart';
import 'package:sideswap/providers/jade_provider.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/preview_order_dialog_providers.dart';
import 'package:sideswap/providers/quote_event_providers.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap/screens/markets/market_swap_page.dart';

Future<void> showSwapTradeDialog(
  BuildContext context,
  WidgetRef ref, {
  required Option<QuoteSuccess> optionQuoteSuccess,
  Option<PreviewOrderDialogModifiers> optionModifiers = const Option.none(),
}) async {
  ref.read(marketTradeProvider.notifier).prepareSwapTrade(
    optionQuoteSuccess: optionQuoteSuccess,
    optionModifiers: optionModifiers,
  );

  if (optionQuoteSuccess.isNone()) return;
  if (!context.mounted) return;

  await showDialog<void>(
    context: context,
    builder: (_) => FlavorConfig.isDesktop
        ? DPreviewOrderDialog()
        : MobileOrderPreviewDialog(),
    routeSettings: RouteSettings(
      name: FlavorConfig.isDesktop
          ? desktopOrderPreviewRouteName
          : mobileOrderPreviewRouteName,
    ),
    useRootNavigator: false,
  );

  if (ref.read(isJadeWalletProvider)) return;

  ref.read(marketTradeProvider.notifier).cleanupAfterDialog();
}
