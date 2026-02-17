import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/side_swap_popup.dart';
import 'package:sideswap/desktop/widgets/d_swaption_connections_button.dart';
import 'package:sideswap/providers/swaption_session_providers.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class SwaptionSessionsDialog extends HookConsumerWidget {
  const SwaptionSessionsDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final swaptionSessions = ref.watch(swaptionSessionProvider);
    final scrollController = useScrollController();

    final onClose = useCallback(() {
      Navigator.of(context, rootNavigator: true).pop();
    }, []);

    return SideSwapPopup(
      enableInsideHorizontalPadding: false,
      onClose: () {
        onClose();
      },
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          onClose();
        }
      },
      child: Center(
        child: Column(
          children: [
            Text(
              'Active sessions'.tr(),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            if (swaptionSessions.isEmpty) ...[
              const SizedBox(height: 64),
              Text(
                'No active sessions'.tr(),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: SideSwapColors.cornFlower,
                ),
              ),
            ] else ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 48),
                    CustomBigButton(
                      width: double.infinity,
                      height: 54,
                      backgroundColor: SideSwapColors.brightTurquoise,
                      onPressed: () {
                        for (final swaptionSession in swaptionSessions) {
                          final msg = To();
                          msg.stopSession = To_StopSession(
                            sessionId: swaptionSession.sessionId,
                          );
                          ref.read(walletProvider).sendMsg(msg);
                        }
                      },
                      child: Text('Disconnect all'.tr()),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            Flexible(
              child: Scrollbar(
                thumbVisibility: true,
                controller: scrollController,
                child: CustomScrollView(
                  controller: scrollController,
                  slivers: [
                    SliverList.builder(
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SwaptionDomainItem(
                                swaptionSession: swaptionSessions[index],
                              ),
                              index < swaptionSessions.length - 1
                                  ? const SizedBox(height: 10)
                                  : const SizedBox.shrink(),
                            ],
                          ),
                        );
                      },
                      itemCount: swaptionSessions.length,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
