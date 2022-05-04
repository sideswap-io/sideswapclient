import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sideswap/common/widgets/side_swap_popup.dart';
import 'package:sideswap/models/pin_setup_provider.dart';
import 'package:sideswap/screens/onboarding/widgets/result_page.dart';

class PinSuccess extends ConsumerWidget {
  const PinSuccess({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SideSwapPopup(
      onWillPop: () async {
        return false;
      },
      hideCloseButton: true,
      child: ResultPage(
        resultType: ResultPageType.success,
        header: 'Wallet is protected'.tr(),
        description: 'PIN added successfully'.tr(),
        buttonText: 'CONTINUE'.tr(),
        onPressed: () {
          ref.read(pinSetupProvider).onSuccess();
        },
      ),
    );
  }
}
