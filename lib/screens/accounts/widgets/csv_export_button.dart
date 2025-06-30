import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/providers/csv_provider.dart';

class CsvExportButton extends HookConsumerWidget {
  const CsvExportButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exportCsvState = ref.watch(exportCsvStateNotifierProvider);

    final disabled = switch (exportCsvState) {
      ExportCsvStateLoaded() => false,
      _ => true,
    };

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: disabled
            ? null
            : () async {
                final box = context.findRenderObject() as RenderBox?;
                await ref.read(csvNotifierProvider.notifier).share(box);
              },
        borderRadius: BorderRadius.circular(21),
        child: Container(
          width: 42,
          height: 42,
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: Center(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: SvgPicture.asset(
                    'assets/export2.svg',
                    width: 23,
                    height: 23,
                    colorFilter: disabled
                        ? const ColorFilter.mode(
                            SideSwapColors.jellyBean,
                            BlendMode.srcIn,
                          )
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
