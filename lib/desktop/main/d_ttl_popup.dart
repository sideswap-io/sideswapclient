import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/common/button/d_custom_text_big_button.dart';
import 'package:sideswap/desktop/common/button/d_hover_button.dart';
import 'package:sideswap/desktop/main/d_order_review.dart';
import 'package:sideswap/desktop/widgets/d_popup_with_close.dart';
import 'package:sideswap/providers/request_order_provider.dart';

class DTtlPopup extends ConsumerWidget {
  const DTtlPopup({
    super.key,
    this.selected,
  });

  final int? selected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DPopupWithClose(
      width: 580,
      height: 670,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 40),
          Center(
            child: Text(
              'Choose the Time-to-live'.tr(),
              style: Theme.of(context).textTheme.displaySmall,
            ),
          ),
          const SizedBox(height: 23),
          Consumer(builder: (context, ref, _) {
            final twoStep = ref.watch(orderReviewTwoStepProvider);

            return Column(
              children: availableTtlValues(twoStep)
                  .map((e) => DTtlPopupTtlValue(
                        ttl: e,
                        selected: selected == e,
                      ))
                  .toList(),
            );
          }),
          const Spacer(),
          Container(
            color: SideSwapColors.chathamsBlue,
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: DCustomTextBigButton(
                width: 260,
                height: 44,
                child: Text(
                  'Back'.tr().toUpperCase(),
                ),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DTtlPopupTtlValue extends ConsumerWidget {
  const DTtlPopupTtlValue({
    super.key,
    required this.ttl,
    required this.selected,
  });

  final int ttl;
  final bool selected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: DHoverButton(
        builder: (context, states) {
          return Container(
            width: 344,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              color: states.isHovering
                  ? const Color(0xFF26739E)
                  : SideSwapColors.chathamsBlue,
            ),
            padding: const EdgeInsets.only(left: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                getTtlDescription(ttl),
                style:
                    TextStyle(color: selected ? const Color(0xFF89AABC) : null),
              ),
            ),
          );
        },
        onPressed: () {
          ref.read(orderReviewTtlChangedFlagProvider.notifier).setTtlChanged();

          Navigator.of(context, rootNavigator: true).pop(ttl);
        },
      ),
    );
  }
}
