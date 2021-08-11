import 'package:flutter/material.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/screens/settings/widgets/settings_network_checkbox.dart';

class SettingsNetworkButton extends StatefulWidget {
  const SettingsNetworkButton({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.title,
    this.trailingIconVisible = false,
  }) : super(key: key);

  final bool value;
  final ValueChanged<bool> onChanged;
  final Widget title;
  final bool trailingIconVisible;

  @override
  _SettingsNetworkButtonState createState() => _SettingsNetworkButtonState();
}

class _SettingsNetworkButtonState extends State<SettingsNetworkButton> {
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
          primary: Colors.white,
          backgroundColor: const Color(0xFF135579),
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8.w),
            ),
          ),
          side: const BorderSide(
            color: Color(0xFF135579),
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
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
                Padding(
                  padding: EdgeInsets.only(right: 16.w),
                  child: const Icon(Icons.keyboard_arrow_right),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
