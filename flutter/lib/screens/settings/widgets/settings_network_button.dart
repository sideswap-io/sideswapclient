import 'package:flutter/material.dart';
import 'package:sideswap/common/sideswap_colors.dart';

import 'package:sideswap/screens/settings/widgets/settings_network_checkbox.dart';

class SettingsNetworkButton extends StatefulWidget {
  const SettingsNetworkButton({
    super.key,
    required this.value,
    required this.onChanged,
    required this.title,
    this.trailingIconVisible = false,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final Widget title;
  final bool trailingIconVisible;

  @override
  SettingsNetworkButtonState createState() => SettingsNetworkButtonState();
}

class SettingsNetworkButtonState extends State<SettingsNetworkButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      width: double.infinity,
      child: TextButton(
        onPressed: () {
          widget.onChanged(!widget.value);
        },
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: SideSwapColors.chathamsBlue,
          padding: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
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
                child: SettingsNetworkCheckbox(
                  value: widget.value,
                  onChanged: (value) {},
                  title: widget.title,
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
