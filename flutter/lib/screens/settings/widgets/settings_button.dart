import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum SettingsButtonType {
  recovery,
  shield,
  about,
  delete,
  userDetails,
  network,
  language,
}

class SettingsButton extends StatefulWidget {
  const SettingsButton({
    super.key,
    this.transparent = false,
    this.type = SettingsButtonType.recovery,
    required this.text,
    this.onPressed,
  });

  final bool transparent;
  final SettingsButtonType type;
  final String text;
  final VoidCallback? onPressed;

  @override
  SettingsButtonState createState() => SettingsButtonState();
}

class SettingsButtonState extends State<SettingsButton> {
  late Widget _icon;

  @override
  void initState() {
    super.initState();

    switch (widget.type) {
      case SettingsButtonType.recovery:
        _icon = SvgPicture.asset(
          'assets/recovery.svg',
          width: 24,
          height: 24,
        );
        break;
      case SettingsButtonType.shield:
        _icon = SvgPicture.asset(
          'assets/shield.svg',
          width: 24,
          height: 24,
        );
        break;
      case SettingsButtonType.about:
        _icon = SvgPicture.asset(
          'assets/about.svg',
          width: 24,
          height: 24,
        );
        break;
      case SettingsButtonType.delete:
        _icon = SvgPicture.asset(
          'assets/delete.svg',
          width: 24,
          height: 24,
        );
        break;
      case SettingsButtonType.userDetails:
        _icon = SvgPicture.asset(
          'assets/user_details.svg',
          width: 24,
          height: 24,
        );
        break;
      case SettingsButtonType.network:
        _icon = SvgPicture.asset(
          'assets/network.svg',
          width: 24,
          height: 24,
        );
        break;
      case SettingsButtonType.language:
        _icon = SvgPicture.asset(
          'assets/language.svg',
          width: 24,
          height: 24,
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: TextButton(
        onPressed: widget.onPressed,
        style: TextButton.styleFrom(
          primary: Colors.white,
          backgroundColor:
              widget.transparent ? Colors.transparent : const Color(0xFF135579),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          side: const BorderSide(
            color: Color(0xFF135579),
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 17),
              child: _icon,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text(
                widget.text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
              ),
            ),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(Icons.keyboard_arrow_right),
            ),
          ],
        ),
      ),
    );
  }
}
