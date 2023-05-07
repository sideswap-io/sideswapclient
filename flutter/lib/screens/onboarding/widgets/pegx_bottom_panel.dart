import 'package:flutter/material.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/screens/onboarding/widgets/amp_bottom_panel_body.dart';

class PegxBottomPanel extends StatelessWidget {
  const PegxBottomPanel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: SideSwapColors.tarawera,
      child: AmpBottomPanelBody(
        url: 'https://pegx.io',
        urlText: 'pegx.io',
        textStyle: Theme.of(context).textTheme.bodyMedium?.merge(
              const TextStyle(
                fontSize: 14,
              ),
            ),
      ),
    );
  }
}
