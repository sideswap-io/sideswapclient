import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sideswap/desktop/widgets/sideswap_scaffold_page.dart';

class DAmpBackgroundPage extends StatelessWidget {
  final List<Widget> content;
  const DAmpBackgroundPage({Key? key, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SideSwapScaffoldPage(
        content: Stack(
          alignment: Alignment.topCenter,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 100),
              child: SizedBox(
                width: 375,
                height: 202,
                child: SvgPicture.asset('assets/amp_image.svg'),
              ),
            ),
            Container(
              color: Colors.black.withOpacity(0.5),
            ),
            ...content,
          ],
        ),
      ),
    );
  }
}
