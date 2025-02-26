import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/common/button/d_custom_filled_big_button.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog_theme.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/providers/markets_provider.dart';

const quoteErrorRouteName = '/desktopQuoteError';

class DAcceptQuoteErrorDialog extends HookConsumerWidget {
  const DAcceptQuoteErrorDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final optionAcceptQuoteError = ref.watch(acceptQuoteErrorProvider);

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

    final closeCallback = useCallback(() {
      Navigator.of(context, rootNavigator: false).popUntil((route) {
        return route.settings.name != quoteErrorRouteName;
      });
    });

    return DContentDialog(
      constraints: const BoxConstraints(maxWidth: 450, maxHeight: 260),
      style: defaultDialogTheme,
      title: DContentDialogTitle(
        content: Text('Quote error'.tr()),
        onClose: () {
          closeCallback();
        },
      ),
      content: SizedBox(
        width: 450,
        height: 160,
        child:
            optionAcceptQuoteError.match(
              () => () {
                return SizedBox();
              },
              (error) => () {
                return Column(
                  children: [
                    Text(error),
                    Spacer(),
                    DCustomFilledBigButton(
                      onPressed: () {
                        closeCallback();
                      },
                      child: Text('Close'.tr()),
                    ),
                  ],
                );
              },
            )(),
      ),
    );
  }
}
