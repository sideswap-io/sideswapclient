import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/common/button/d_custom_button.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog.dart';
import 'package:sideswap/providers/network_settings_providers.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart';

class DNeedRestartPopupDialog extends ConsumerWidget {
  const DNeedRestartPopupDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DContentDialog(
      constraints: const BoxConstraints(maxWidth: 580, maxHeight: 360),
      title: DContentDialogTitle(
        onClose: () {
          Navigator.of(context).pop();
          ref
              .read(pageStatusNotifierProvider.notifier)
              .setStatus(Status.registered);
        },
        content: SvgPicture.asset(
          'assets/restart.svg',
          width: 64,
          height: 64,
          colorFilter: const ColorFilter.mode(
              SideSwapColors.brightTurquoise, BlendMode.srcIn),
        ),
      ),
      content: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            Text(
              'Network changes will take effect on restart'.tr(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 60),
            Consumer(builder: (context, ref, _) {
              return DCustomButton(
                width: 266,
                height: 54,
                isFilled: true,
                onPressed: () {
                  Navigator.of(context).pop();
                  ref.read(networkSettingsNotifierProvider.notifier).save();
                  ref
                      .read(pageStatusNotifierProvider.notifier)
                      .setStatus(Status.registered);
                },
                child: Text('OK'.tr()),
              );
            }),
          ],
        ),
      ),
    );
  }
}
