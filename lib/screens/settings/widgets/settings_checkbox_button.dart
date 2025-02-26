import 'package:flutter/material.dart';
import 'package:sideswap/common/sideswap_colors.dart';

import 'package:sideswap/screens/settings/widgets/settings_checkbox.dart';

class SettingsCheckboxButton extends StatefulWidget {
  const SettingsCheckboxButton({
    super.key,
    required this.checked,
    required this.onChanged,
    required this.content,
    this.trailingIconVisible = false,
  });

  final bool checked;
  final ValueChanged<bool> onChanged;
  final Widget content;
  final bool trailingIconVisible;

  @override
  SettingsCheckboxButtonState createState() => SettingsCheckboxButtonState();
}

class SettingsCheckboxButtonState extends State<SettingsCheckboxButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      width: double.infinity,
      child: TextButton(
        onPressed: () {
          widget.onChanged(!widget.checked);
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
                  value: widget.checked,
                  onChanged: (value) {},
                  title: widget.content,
                ),
              ),
              const Spacer(),
              if (widget.trailingIconVisible) ...[
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
