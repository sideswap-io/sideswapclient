import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/providers/swaption_session_providers.dart';
import 'package:sideswap/screens/home/widgets/rounded_button.dart';
import 'package:sideswap/screens/home/widgets/swaption_sessions_dialog.dart';

class SwaptionConnectionsButton extends HookConsumerWidget {
  const SwaptionConnectionsButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final swaptionSessions = ref.watch(swaptionSessionProvider);

    return RoundedButton(
      color: Colors.transparent,
      onTap: swaptionSessions.isNotEmpty
          ? () async {
              await showDialog<bool>(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return SwaptionSessionsDialog();
                },
              );
            }
          : null,
      child: swaptionSessions.isNotEmpty
          ? Badge.count(
              count: swaptionSessions.length,
              maxCount: 99,
              backgroundColor: SideSwapColors.bitterSweet,
              child: SvgPicture.asset(
                'assets/swaption_connections.svg',
                width: 36,
                height: 36,
              ),
            )
          : SvgPicture.asset(
              'assets/swaption_connections.svg',
              width: 36,
              height: 36,
              colorFilter: ColorFilter.mode(
                SideSwapColors.pewterBlue,
                BlendMode.srcIn,
              ),
            ),
    );
  }
}
