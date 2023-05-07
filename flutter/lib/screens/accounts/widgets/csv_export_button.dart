import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/providers/csv_provider.dart';

class CsvExportButton extends HookConsumerWidget {
  const CsvExportButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final csvStateProvider = ref.watch(csvStateNotifierProvider.notifier);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          final box = context.findRenderObject() as RenderBox?;
          await csvStateProvider.share(box);
        },
        borderRadius: BorderRadius.circular(21),
        child: Container(
          width: 42,
          height: 42,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Row(
            children: [
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: SvgPicture.asset(
                  'assets/export.svg',
                  width: 22,
                  height: 21,
                  colorFilter:
                      const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
