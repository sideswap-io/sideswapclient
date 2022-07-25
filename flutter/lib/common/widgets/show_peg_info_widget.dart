import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/custom_check_box.dart';

class ShowPegInfoWidget extends StatefulWidget {
  const ShowPegInfoWidget({
    super.key,
    required this.onChanged,
    required this.text,
  });

  final ValueChanged<bool> onChanged;
  final String text;

  @override
  ShowPegInfoWidgetState createState() => ShowPegInfoWidgetState();
}

class ShowPegInfoWidgetState extends State<ShowPegInfoWidget> {
  bool internalValue = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 343,
      height: 390,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
        color: Color(0xFF1C6086),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 28,
              child: SvgPicture.asset(
                'assets/info.svg',
                width: 13,
                height: 32,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: SizedBox(
                height: 66,
                child: SingleChildScrollView(
                  child: Text(
                    widget.text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 22),
              child: Divider(
                height: 1,
                thickness: 1,
                color: Color(0xFF357CA4),
              ),
            ),
            CustomCheckBox(
              onChanged: (value) {
                widget.onChanged(value);
                setState(() {
                  internalValue = value;
                });
              },
              value: internalValue,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  "Don't show again".tr(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const Divider(
              height: 1,
              thickness: 1,
              color: Color(0xFF357CA4),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(top: 32),
              child: CustomBigButton(
                width: 295,
                height: 54,
                text: 'OK'.tr(),
                backgroundColor: const Color(0xFF00C5FF),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
