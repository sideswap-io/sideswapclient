import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/providers/locales_provider.dart';

class LangSelector extends ConsumerWidget {
  const LangSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localesNotifierProvider);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: SizedBox(
        width: 170,
        height: 39,
        child: DecoratedBox(
          decoration: const ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1.0,
                style: BorderStyle.solid,
                color: SideSwapColors.brightTurquoise,
              ),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
          child: DropdownButton<String>(
            underline: const SizedBox(),
            isExpanded: true,
            icon: const Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(Icons.keyboard_arrow_down, color: Color(0xFF00B4E9)),
            ),
            dropdownColor: const Color(0xFF2B6F95),
            onChanged: (value) {
              ref
                  .read(localesNotifierProvider.notifier)
                  .setSelectedLang(value!);
            },
            value: locale,
            items:
                supportedLanguages()
                    .map(
                      (e) => DropdownMenuItem<String>(
                        value: e,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Row(
                            children: [
                              localeIconFile(e),
                              const SizedBox(width: 8),
                              Text(
                                localeName(e),
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
          ),
        ),
      ),
    );
  }
}
