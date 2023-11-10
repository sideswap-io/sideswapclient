import 'package:flutter/material.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/screens/onboarding/widgets/amp_bottom_panel_body.dart';

class StokrBottomPanel extends StatelessWidget {
  const StokrBottomPanel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: SideSwapColors.tarawera,
      child: AmpBottomPanelBody(
        url: 'https://stokr.io',
        urlText: 'stokr.io',
        textStyle: Theme.of(context).textTheme.bodyMedium?.merge(
              const TextStyle(
                fontSize: 14,
              ),
            ),
      ),
    );
  }
}
