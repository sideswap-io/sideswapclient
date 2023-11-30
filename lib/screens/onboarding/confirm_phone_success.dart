import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/widgets/side_swap_popup.dart';
import 'package:sideswap/providers/phone_provider.dart';
import 'package:sideswap/screens/onboarding/widgets/result_page.dart';

class ConfirmPhoneSuccess extends ConsumerWidget {
  const ConfirmPhoneSuccess({
    super.key,
  });

  final _defaultTextStyle = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SideSwapPopup(
      canPop: false,
      hideCloseButton: true,
      child: ResultPage(
        resultType: ResultPageType.success,
        header: 'Success!'.tr(),
        descriptionWidget: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Your number '.tr(),
                style: _defaultTextStyle,
              ),
              TextSpan(
                text: ref.read(phoneProvider).countryPhoneNumber,
                style: _defaultTextStyle.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: ' has been successfully linked to the wallet'.tr(),
                style: _defaultTextStyle,
              ),
            ],
          ),
        ),
        buttonText: 'CONTINUE'.tr(),
        onPressed: () async {
          final confirmPhoneData =
              ref.read(phoneProvider).getConfirmPhoneData();
          await confirmPhoneData.onConfirmPhoneDone!(context);
        },
      ),
    );
  }
}
