import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/common/button/d_button.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/providers/csv_provider.dart';
import 'package:sideswap/providers/desktop_dialog_providers.dart';

class DExportCsvButton extends ConsumerWidget {
  const DExportCsvButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buttonStyle = ref
        .watch(desktopAppThemeNotifierProvider)
        .mainBottomNavigationBarButtonStyle;

    final csvNotifier = ref.watch(csvNotifierProvider);
    final disabled = switch (csvNotifier) {
      AsyncData(hasValue: true) => false,
      AsyncError() => false,
      _ => true,
    };

    return Tooltip(
      message: 'Export CSV'.tr(),
      waitDuration: Duration(seconds: 1),
      child: SizedBox(
        width: 32,
        height: 32,
        child: DButton(
          style: buttonStyle,
          onPressed: disabled
              ? null
              : () async {
                  await ref.read(desktopDialogProvider).showExportCsv();
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
      ),
    );
  }
}
