import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/onboarding/d_pegx_login_dialog.dart';
import 'package:sideswap/desktop/onboarding/widgets/d_amp_background_page.dart';
import 'package:sideswap/desktop/onboarding/widgets/d_pegx_submit_finish_dialog_body.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart';

class DPegxSubmitFinishDialog extends HookConsumerWidget {
  const DPegxSubmitFinishDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DAmpBackgroundPage(content: [
      DPegxLoginDialog(
        onClose: () {
          ref
              .read(pageStatusStateProvider.notifier)
              .setStatus(Status.ampRegister);
        },
        content: const DPegxSubmitFinishDialogBody(),
      ),
    ]);
  }
}
