import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/screens/settings/widgets/settings_checkbox.dart';

class SettingsCheckboxButton extends ConsumerWidget {
  const SettingsCheckboxButton({
    super.key,
    this.checked = false,
    this.onChanged,
    this.content,
    this.trailingIconVisible = false,
  });

  final bool checked;
  final void Function(bool value)? onChanged;
  final Widget? content;
  final bool trailingIconVisible;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 54,
      width: double.infinity,
      child: TextButton(
        onPressed: () {
          onChanged?.call(!checked);
        },
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: SideSwapColors.chathamsBlue,
          padding: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          side: const BorderSide(
            color: SideSwapColors.chathamsBlue,
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IgnorePointer(
                child: SettingsCheckbox(
                  value: checked,
                  onChanged: (value) {},
                  title: content ?? const SizedBox(),
                ),
              ),
              const Spacer(),
              if (trailingIconVisible) ...[
                const Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Icon(Icons.keyboard_arrow_right),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
