import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:sideswap/common/sideswap_colors.dart';

class SettingsSecurity extends StatelessWidget {
  const SettingsSecurity({
    super.key,
    this.value = false,
    this.onTap,
    this.icon = Icons.fingerprint,
    this.description = '',
  });

  final bool value;
  final VoidCallback? onTap;
  final IconData icon;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: InkWell(
        onTap: onTap,
        child: AbsorbPointer(
          child: SizedBox(
            height: 60,
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: SideSwapColors.chathamsBlue,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                side: const BorderSide(
                  color: SideSwapColors.chathamsBlue,
                  width: 1,
                  style: BorderStyle.solid,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Icon(
                      icon,
                      size: 24,
                      color: SideSwapColors.brightTurquoise,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      description,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 19),
                    child: FlutterSwitch(
                      value: value,
                      onToggle: (val) {},
                      width: 51,
                      height: 31,
                      toggleSize: 27,
                      padding: 2,
                      activeColor: SideSwapColors.brightTurquoise,
                      inactiveColor: const Color(0xFF164D6A),
                      toggleColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
