import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/common/button/d_button.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/desktop/widgets/amp_id_panel.dart';
import 'package:sideswap/providers/amp_id_provider.dart';
import 'package:sideswap/providers/csv_provider.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart';

class DTopOverviewToolbar extends HookConsumerWidget {
  const DTopOverviewToolbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        SvgPicture.asset('assets/liquid_logo.svg', width: 24, height: 24),
        const SizedBox(width: 4),
        const Text(
          'Liquid',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const Spacer(),
        Consumer(
          builder: (context, ref, child) {
            final ampId = ref.watch(ampIdNotifierProvider);

            if (ampId.isNotEmpty) {
              return AmpIdPanel(
                ampId: ampId,
                prefixTextStyle: Theme.of(context).textTheme.titleSmall
                    ?.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                onTap: () {
                  ref
                      .read(pageStatusNotifierProvider.notifier)
                      .setStatus(Status.ampRegister);
                },
              );
            }

            return const SizedBox();
          },
        ),
        const SizedBox(width: 16),
        Consumer(
          builder: (context, ref, child) {
            final buttonStyle = ref
                .watch(desktopAppThemeNotifierProvider)
                .mainBottomNavigationBarButtonStyle;

            final csvNotifier = ref.watch(csvNotifierProvider);
            final disabled = switch (csvNotifier) {
              AsyncData(hasValue: true) => false,
              AsyncError() => false,
              _ => true,
            };

            return SizedBox(
              width: 32,
              height: 32,
              child: DButton(
                style: buttonStyle,
                onPressed: disabled
                    ? null
                    : () async {
                        await ref.read(csvNotifierProvider.notifier).save();
                      },
                child: Center(
                  child: SvgPicture.asset(
                    'assets/export.svg',
                    colorFilter: ColorFilter.mode(
                      disabled ? SideSwapColors.jellyBean : Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
