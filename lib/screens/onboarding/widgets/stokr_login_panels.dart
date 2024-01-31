import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/common/d_color.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/providers/amp_id_provider.dart';
import 'package:sideswap/screens/flavor_config.dart';

class StokrLoginPanels extends HookConsumerWidget {
  const StokrLoginPanels({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = FlavorConfig.isDesktop
        ? ref.watch(desktopAppThemeNotifierProvider).textTheme
        : Theme.of(context).textTheme;
    final ampId = ref.watch(ampIdNotifierProvider);

    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 65,
          decoration: BoxDecoration(
            color: SideSwapColors.chathamsBlue,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '1. Register an account with STOKR'.tr(),
                  style: textTheme.bodyMedium,
                ),
                Text(
                  'You must complete KYC'.tr(),
                  style: textTheme.titleSmall?.merge(
                    const TextStyle(
                      color: SideSwapColors.glacier,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Container(
            width: double.infinity,
            height: 42,
            decoration: const BoxDecoration(
              color: SideSwapColors.chathamsBlue,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '2. Submit AMP ID through STOKR portal'.tr(),
                    style: textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 1,
        ),
        TextButton(
          style: ButtonStyle(
            padding: const MaterialStatePropertyAll(EdgeInsets.zero),
            backgroundColor: MaterialStateColor.resolveWith(
                (states) => SideSwapColors.chathamsBlue),
            overlayColor: MaterialStateColor.resolveWith((states) =>
                SideSwapColors.chathamsBlue.lerpWith(Colors.white, 0.2)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
            ),
            mouseCursor: MaterialStateMouseCursor.clickable,
          ),
          onPressed: () async {
            await copyToClipboard(
              context,
              ampId,
              suffix: ampId,
            );
          },
          child: SizedBox(
            width: double.infinity,
            height: 57,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'AMP ID: ',
                      style: textTheme.titleSmall?.copyWith(
                        color: SideSwapColors.brightTurquoise,
                        fontWeight: FontWeight.w500,
                      ),
                      children: [
                        TextSpan(
                          text: ampId,
                          style: textTheme.titleSmall?.copyWith(
                            color: SideSwapColors.brightTurquoise,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  SvgPicture.asset(
                    'assets/copy2.svg',
                    width: 22,
                    height: 22,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
