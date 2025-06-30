import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/common/button/d_custom_button.dart';
import 'package:sideswap/desktop/widgets/d_popup_with_close.dart';
import 'package:sideswap/providers/csv_provider.dart';

class DExportCsvPopup extends HookConsumerWidget {
  const DExportCsvPopup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(csvNotifierProvider, (_, next) {
      final cvsState = switch (next) {
        AsyncValue(hasValue: true, :final CvsState value) => value,
        _ => CvsState.empty(),
      };

      if (cvsState is CvsStateSuccess) {
        Navigator.of(context).pop();
      }
    });

    final exportCsvState = ref.watch(exportCsvStateNotifierProvider);

    return DPopupWithClose(
      width: 580,
      height: 230,
      alignment: AlignmentDirectional.topCenter,
      onClose: () {
        Navigator.of(context).pop();
      },
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                'Export CSV'.tr(),
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ),
            const SizedBox(height: 16),
            ...switch (exportCsvState) {
              ExportCsvStateLoaded() => [
                Text(
                  'Transactions loaded: {}'.tr(
                    args: ['${exportCsvState.txs?.length ?? 0}'],
                  ),
                ),
              ],
              ExportCsvStateError() => [
                Text(
                  'Error loading transactions: {}'.tr(
                    args: [exportCsvState.errorMsg ?? 'unknown'],
                  ),
                ),
              ],
              _ => [
                Text('Loading transactions...'.tr()),
                LinearProgressIndicator(
                  semanticsLabel: 'Loading transactions indicator',
                ),
              ],
            },
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DCustomButton(
                  width: 245,
                  height: 44,
                  onPressed: exportCsvState is ExportCsvStateLoaded
                      ? () async {
                          await ref.read(csvNotifierProvider.notifier).save();
                        }
                      : null,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/export.svg',
                        colorFilter: ColorFilter.mode(
                          exportCsvState is ExportCsvStateLoaded
                              ? Colors.white
                              : SideSwapColors.jellyBean,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text('Export'.tr()),
                    ],
                  ),
                ),
                DCustomButton(
                  width: 245,
                  height: 44,
                  isFilled: true,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text('Close'.tr())],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
