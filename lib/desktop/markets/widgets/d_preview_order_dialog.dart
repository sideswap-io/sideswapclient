import 'package:easy_localization/easy_localization.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/common/button/d_custom_filled_big_button.dart';
import 'package:sideswap/desktop/common/button/d_custom_text_big_button.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog_theme.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/providers/jade_provider.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/preview_order_dialog_providers.dart';
import 'package:sideswap/providers/quote_event_providers.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/screens/markets/widgets/market_preview_order_dialog_common_body.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

const desktopOrderPreviewRouteName = '/desktopOrderPreview';

class DPreviewOrderDialog extends HookConsumerWidget {
  const DPreviewOrderDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final defaultDialogTheme = ref
        .watch(desktopAppThemeNotifierProvider)
        .dialogTheme
        .merge(
          const DContentDialogThemeData(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              color: SideSwapColors.blumine,
            ),
          ),
        );

    final acceptButtonClicked = useState(false);

    final optionQuoteSuccess = ref.watch(
      previewOrderQuoteSuccessNotifierProvider,
    );
    final orderSignTtl = ref.watch(orderSignTtlProvider);

    final closeCallback = useCallback(() {
      Navigator.of(context, rootNavigator: false).popUntil((route) {
        return route.settings.name != desktopOrderPreviewRouteName;
      });

      Future.microtask(() {
        ref.invalidate(previewOrderQuoteSuccessNotifierProvider);
      });
    });

    ref.listen(previewOrderDialogAcceptStateProvider, (_, state) {
      (switch (state) {
        PreviewOrderDialogAcceptStateAccepted() => () {
          closeCallback();
        },
        _ => () {},
      })();
    });

    final optionAccepQuoteSuccess = ref.watch(marketAcceptQuoteSuccessProvider);
    final optionAcceptQuoteError = ref.watch(marketAcceptQuoteErrorProvider);

    useEffect(() {
      optionAccepQuoteSuccess.match(() {}, (txid) {
        ref.read(quoteEventNotifierProvider.notifier).stopQuotes();
        ref.invalidate(quoteEventNotifierProvider);
        ref.invalidate(marketQuoteNotifierProvider);
      });

      return;
    }, [optionAccepQuoteSuccess]);

    useEffect(() {
      optionAcceptQuoteError.match(() {}, (error) {
        ref.read(quoteEventNotifierProvider.notifier).stopQuotes();
        ref.invalidate(quoteEventNotifierProvider);
        ref.invalidate(marketQuoteNotifierProvider);
        closeCallback();
      });

      return;
    }, [optionAcceptQuoteError]);

    useEffect(() {
      if (orderSignTtl != 0) {
        return;
      }

      Future.microtask(() => closeCallback());

      return;
    }, [orderSignTtl]);

    final previewOrderDialogAcceptState = ref.watch(
      previewOrderDialogAcceptStateProvider,
    );

    return DContentDialog(
      constraints: const BoxConstraints(maxWidth: 580, maxHeight: 605),
      style: defaultDialogTheme,
      title: DContentDialogTitle(
        content: Text('Swap proposal'.tr()),
        onClose: () {
          closeCallback();
        },
      ),
      content: SizedBox(
        width: 580,
        height: 485,
        child: optionQuoteSuccess.match(
          () => () {
            return SizedBox();
          },
          (quoteSuccess) => () {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  MarketPreviewOrderDialogCommonBody(),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DCustomTextBigButton(
                        width: 245,
                        height: 44,
                        onPressed: () {
                          closeCallback();
                        },
                        child: switch (previewOrderDialogAcceptState) {
                          PreviewOrderDialogAcceptStateAccepting() => Text(
                            'Close'.tr(),
                          ),
                          _ => Text('Cancel'.tr()),
                        },
                      ),
                      DCustomFilledBigButton(
                        width: 245,
                        height: 44,
                        onPressed:
                            !acceptButtonClicked.value &&
                                previewOrderDialogAcceptState
                                    is PreviewOrderDialogAcceptStateEmpty
                            ? () async {
                                var authorized = ref.read(
                                  jadeOneTimeAuthorizationProvider,
                                );

                                if (!ref.read(
                                  jadeOneTimeAuthorizationProvider,
                                )) {
                                  authorized = await ref
                                      .read(
                                        jadeOneTimeAuthorizationProvider
                                            .notifier,
                                      )
                                      .authorize();
                                }

                                if (!authorized) {
                                  return;
                                }

                                final msg = To();
                                msg.acceptQuote = To_AcceptQuote(
                                  quoteId: Int64(quoteSuccess.quoteId),
                                );
                                ref.read(walletProvider).sendMsg(msg);

                                // now app will wait for market accept quote success or error provider
                                acceptButtonClicked.value = true;
                              }
                            : null,
                        child: Row(
                          children: [
                            Spacer(),
                            Text('Accept'.tr()),
                            Expanded(
                              child: Row(
                                children: [
                                  const SizedBox(width: 4),
                                  switch (previewOrderDialogAcceptState) {
                                    PreviewOrderDialogAcceptStateAccepting() =>
                                      const SpinKitCircle(
                                        color: Colors.white,
                                        size: 32,
                                      ),
                                    _ => const SizedBox(),
                                  },
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        )(),
      ),
    );
  }
}
