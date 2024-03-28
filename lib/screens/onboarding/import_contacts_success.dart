import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/widgets/side_swap_popup.dart';
import 'package:sideswap/providers/phone_provider.dart';
import 'package:sideswap/screens/onboarding/widgets/result_page.dart';

class ImportContactsSuccess extends ConsumerWidget {
  const ImportContactsSuccess({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SideSwapPopup(
      canPop: false,
      hideCloseButton: true,
      child: ResultPage(
        resultType: ResultPageType.success,
        header: 'Success!'.tr(),
        descriptionWidget: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Your contacts has been successfully linked to the wallet'.tr(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Colors.white,
            ),
          ),
        ),
        buttonText: 'CONTINUE'.tr(),
        onPressed: () async {
          final confirmPhoneData =
              ref.read(phoneProvider).getConfirmPhoneData();
          await confirmPhoneData?.onImportContactsDone!(context);
        },
      ),
    );
  }
}
