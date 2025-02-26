import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/providers/connection_state_providers.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/ui_state_args_provider.dart';
import 'package:sideswap/providers/universal_link_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class UniversalLinkListener extends HookConsumerWidget {
  const UniversalLinkListener({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(universalLinkProvider);

    final isConnected = ref.watch(serverConnectionNotifierProvider);
    final linkResultState = ref.watch(universalLinkResultStateNotifierProvider);
    final walletMainArguments = ref.watch(uiStateArgsNotifierProvider);

    useEffect(() {
      if (!isConnected) {
        return;
      }

      (switch (linkResultState) {
        LinkResultStateSuccess() => () {
          ref.read(universalLinkProvider).handleSwapLinkResult(
            linkResultState,
            (orderId, privateId) {
              Future.microtask(() {
                ref
                    .read(uiStateArgsNotifierProvider.notifier)
                    .setWalletMainArguments(walletMainArguments.fromIndex(2));

                // stop market quotes if any
                ref.invalidate(marketQuoteNotifierProvider);

                final msg = To();
                msg.startOrder = To_StartOrder(
                  orderId: orderId,
                  privateId: privateId,
                );
                ref.read(walletProvider).sendMsg(msg);
                ref.invalidate(universalLinkResultStateNotifierProvider);
              });
            },
          );
        },
        LinkResultStateEmpty() => () {},
        _ => () {
          logger.w('Unhandled LinkResultState');
        },
      })();

      return;
    }, [linkResultState, isConnected, walletMainArguments]);

    return Container();
  }
}
