import 'package:flutter/widgets.dart';

class AmpFlag extends StatelessWidget {
  final double fontSize;
  const AmpFlag({super.key, this.fontSize = 12});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        color: Color(0x664994BC),
      ),
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(
        vertical: 2,
        horizontal: 6,
      ),
      child: Text('AMP',
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.normal,
            color: const Color(0xFF73A7C6),
          )),
    );
  }
}
