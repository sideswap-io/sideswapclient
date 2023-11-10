import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/onboarding/d_pegx_login_dialog.dart';
import 'package:sideswap/desktop/onboarding/widgets/d_amp_background_page.dart';
import 'package:sideswap/desktop/onboarding/widgets/d_pegx_submit_amp_dialog_body.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart';

class DPegxSubmitAmp extends HookConsumerWidget {
  const DPegxSubmitAmp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DAmpBackgroundPage(content: [
      DPegxLoginDialog(
        onClose: () {
          ref
              .read(pageStatusStateProvider.notifier)
              .setStatus(Status.ampRegister);
        },
        content: const DPegxSubmitAmpDialogBody(),
      )
    ]);
  }
}
