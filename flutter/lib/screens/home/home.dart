import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/screens/home/widgets/home_bottom_panel.dart';
import 'package:sideswap/screens/home/widgets/rounded_button.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: constraints.maxWidth,
              minHeight: constraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: RoundedButton(
                            onTap: () {
                              ref.read(walletProvider).settingsViewPage();
                            },
                            child: SvgPicture.asset(
                              'assets/settings.svg',
                              width: 24,
                              height: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 34),
                    child: SizedBox(
                      width: 156,
                      height: 152,
                      child: SvgPicture.asset('assets/logo.svg'),
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  const HomeBottomPanel()
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
