import 'package:another_flushbar/flushbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/desktop/common/button/d_custom_button.dart';
import 'package:sideswap/desktop/widgets/d_popup_with_close.dart';
import 'package:sideswap/providers/desktop_dialog_providers.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/outputs_providers.dart';
import 'package:sideswap/providers/payment_provider.dart';
import 'package:sideswap/providers/ui_state_args_provider.dart';
import 'package:sideswap/providers/universal_link_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class DOpenTxImport extends HookConsumerWidget {
  const DOpenTxImport({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textFieldFocusNode = useFocusNode();
    final textFieldHasFocus = useState(false);
    final walletMainArguments = ref.watch(uiStateArgsNotifierProvider);

    useEffect(() {
      textFieldFocusNode.addListener(() {
        if (textFieldFocusNode.hasFocus) {
          textFieldHasFocus.value = true;
          return;
        }

        textFieldHasFocus.value = false;
      });

      return;
    }, [textFieldFocusNode]);

    final scrollController = useScrollController();
    final textController = useTextEditingController();
    final errorText = useState<String?>(null);
    final continueEnabled = useState(false);

    useEffect(() {
      textController.addListener(() {
        if (textController.text.isEmpty) {
          errorText.value = null;
          continueEnabled.value = false;
          return;
        }

        final linkResultState = ref
            .read(universalLinkProvider)
            .handleAppUrlStr(textController.text);

        (switch (linkResultState) {
          LinkResultStateUnknownScheme() => () {
            // maybe it's only order id?
            if (textController.text.length == 64) {
              logger.e('previously link order was sent to BE');
            }
          }(),
          LinkResultStateSuccess() => () {
            continueEnabled.value = true;
          }(),
          _ => () {
            errorText.value = 'Invalid hash or url';
            continueEnabled.value = false;
          },
        });
      });

      return;
    }, [textController]);

    final onPasteCallback = useCallback(() async {
      final navigatorContext = Navigator.of(context);
      await handlePasteSingleLine(textController);
      final linkResultState = ref
          .read(universalLinkProvider)
          .handleAppUrlStr(textController.text);

      if (linkResultState == const LinkResultState.success()) {
        navigatorContext.pop();
        return;
      }

      errorText.value = 'Invalid hash or url';
      continueEnabled.value = false;
    }, []);

    return DPopupWithClose(
      width: 580,
      height: 321,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Text(
              'Import transaction or paste private swap proposal'.tr(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w700,
                height: 0,
                letterSpacing: 0.10,
              ),
            ),
            const SizedBox(height: 28),
            TextFormField(
              focusNode: textFieldFocusNode,
              scrollController: scrollController,
              controller: textController,
              autocorrect: false,
              keyboardType: TextInputType.multiline,
              minLines: 3,
              maxLines: 3,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                isDense: true,
                fillColor: Colors.white,
                filled: true,
                labelText: 'Paste transaction hash'.tr(),
                labelStyle: const TextStyle(
                  color: SideSwapColors.glacier,
                  fontSize: 16,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
                floatingLabelBehavior: FloatingLabelBehavior.never,
                hintText: '',
                errorText: errorText.value,
                errorStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: SideSwapColors.bitterSweet,
                ),
                suffixIcon:
                    textFieldHasFocus.value
                        ? null
                        : SizedBox(
                          width: 24,
                          height: 24,
                          child: TextButton(
                            onPressed: onPasteCallback,
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            child: const Icon(
                              Icons.paste,
                              size: 24,
                              color: SideSwapColors.brightTurquoise,
                            ),
                          ),
                        ),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                focusedErrorBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(color: SideSwapColors.bitterSweet),
                ),
                errorBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(color: SideSwapColors.bitterSweet),
                ),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Consumer(
                  builder: (context, ref, child) {
                    final paymentHelper = ref.watch(paymentHelperProvider);

                    return DCustomButton(
                      width: 245,
                      height: 44,
                      onPressed: () async {
                        final navigator = Navigator.of(context);
                        const XTypeGroup typeGroup = XTypeGroup(
                          label: 'Outputs json',
                          extensions: <String>['json'],
                        );
                        final XFile? file = await openFile(
                          acceptedTypeGroups: <XTypeGroup>[typeGroup],
                        );
                        final result = await ref
                            .read(outputsReaderNotifierProvider.notifier)
                            .setXFile(file);

                        return switch (result) {
                          true => () async {
                            final errorMessage =
                                paymentHelper.outputsPaymentSend();
                            if (errorMessage != null) {
                              final flushbar = Flushbar<void>(
                                messageText: Text(errorMessage),
                                duration: const Duration(seconds: 5),
                                backgroundColor: SideSwapColors.chathamsBlue,
                              );

                              if (context.mounted) {
                                await flushbar.show(context);
                              }
                              return;
                            }

                            navigator.pop();
                            ref.read(desktopDialogProvider).showSendTx();
                          }(),
                          _ => () {
                            final outputsData = ref.read(
                              outputsReaderNotifierProvider,
                            );
                            return switch (outputsData) {
                              Left(value: final l) => () async {
                                if (l.message != null) {
                                  final flushbar = Flushbar<void>(
                                    messageText: Text(l.message!),
                                    duration: const Duration(seconds: 5),
                                    backgroundColor:
                                        SideSwapColors.chathamsBlue,
                                  );
                                  await flushbar.show(context);
                                }
                              }(),
                              _ => () {}(),
                            };
                          }(),
                        };
                      },
                      child: Text('IMPORT FILE'.tr()),
                    );
                  },
                ),
                DCustomButton(
                  width: 245,
                  height: 44,
                  isFilled: true,
                  onPressed:
                      continueEnabled.value
                          ? () {
                            // import private swap
                            final linkResultState = ref
                                .read(universalLinkProvider)
                                .handleAppUrlStr(textController.text);

                            ref
                                .read(universalLinkProvider)
                                .handleSwapLinkResult(linkResultState, (
                                  orderId,
                                  privateId,
                                ) {
                                  final navigator = Navigator.of(context);
                                  navigator.pop();
                                  ref
                                      .read(
                                        uiStateArgsNotifierProvider.notifier,
                                      )
                                      .setWalletMainArguments(
                                        walletMainArguments.fromIndexDesktop(1),
                                      );

                                  // stop market quotes if any
                                  ref.invalidate(marketQuoteNotifierProvider);

                                  Future.microtask(() {
                                    final msg = To();
                                    msg.startOrder = To_StartOrder(
                                      orderId: orderId,
                                      privateId: privateId,
                                    );
                                    ref.read(walletProvider).sendMsg(msg);
                                  });
                                });

                            // if (linkResultState is! LinkResultStateSuccess) {
                            //   return;
                            // }

                            // final details = linkResultState.details;

                            // if (details == null || details.orderId == null) {
                            //   return;
                            // }

                            // final orderId = Int64.tryParseInt(details.orderId!);

                            // if (orderId == null) {
                            //   return;
                            // }

                            // final navigator = Navigator.of(context);
                            // navigator.pop();
                            // ref
                            //     .read(uiStateArgsNotifierProvider.notifier)
                            //     .setWalletMainArguments(
                            //       walletMainArguments.fromIndexDesktop(1),
                            //     );

                            // // stop market quotes if any
                            // ref.invalidate(marketQuoteNotifierProvider);

                            // Future.microtask(() {
                            //   final msg = To();
                            //   msg.startOrder = To_StartOrder(
                            //     orderId: orderId,
                            //     privateId: details.privateId,
                            //   );
                            //   ref.read(walletProvider).sendMsg(msg);
                            // });
                          }
                          : null,
                  child: Text('CONTINUE'.tr()),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
