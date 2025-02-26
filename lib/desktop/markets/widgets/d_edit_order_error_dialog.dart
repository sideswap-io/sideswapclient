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
import 'package:sideswap/screens/onboarding/widgets/error_icon.dart';

const editOrderErrorRouteName = '/desktopEditOrderError';

class EditOrderErrorDialog extends HookConsumerWidget {
  const EditOrderErrorDialog({super.key});

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

    final closeCallback = useCallback(() {
      Navigator.of(context, rootNavigator: false).popUntil((route) {
        return route.settings.name != editOrderErrorRouteName;
      });
    });

    return DContentDialog(
      constraints: const BoxConstraints(maxWidth: 580, maxHeight: 605),
      style: defaultDialogTheme.merge(
        DContentDialogThemeData(titlePadding: EdgeInsets.zero),
      ),
      title: DContentDialogTitle(
        onClose: () {
          closeCallback();
        },
      ),
      content: SizedBox(
        width: 580,
        height: 485,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              ErrorIcon(
                width: 102,
                height: 102,
                iconColor: Colors.white,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: SideSwapColors.bitterSweet,
                    style: BorderStyle.solid,
                    width: 8,
                  ),
                ),
              ),
              SizedBox(height: 28),
              Text(
                'Order edit error'.tr(),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 12),
              Consumer(
                builder: (context, ref, child) {
                  final editOrderError = ref.watch(
                    marketEditOrderErrorNotifierProvider,
                  );

                  return editOrderError.match(
                    () => SizedBox(),
                    (error) => Text(error, textAlign: TextAlign.center),
                  );
                },
              ),
              Spacer(),
              DCustomFilledBigButton(
                onPressed: () {
                  closeCallback();
                },
                child: Text('Close'.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
