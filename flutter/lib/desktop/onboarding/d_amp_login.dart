import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/onboarding/d_pegx_login_dialog.dart';
import 'package:sideswap/desktop/onboarding/widgets/d_amp_background_page.dart';
import 'package:sideswap/desktop/onboarding/widgets/d_pegx_login_dialog_body.dart';
import 'package:sideswap/desktop/onboarding/widgets/d_stokr_login_dialog.dart';
import 'package:sideswap/desktop/onboarding/widgets/d_stokr_login_dialog_body.dart';
import 'package:sideswap/providers/pegx_provider.dart';
import 'package:sideswap/providers/wallet.dart';

import '../../providers/wallet_page_status_provider.dart';

enum AmpLoginEnum {
  stokr,
  pegx,
}

class DAmpLogin extends HookConsumerWidget {
  final AmpLoginEnum ampLoginEnum;
  const DAmpLogin({
    Key? key,
    required this.ampLoginEnum,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(pegxWebsocketClientProvider, (previous, next) {});

    final pegxLoginState = ref.watch(pegxLoginStateProvider);

    useEffect(() {
      Future.microtask(
        () => pegxLoginState.maybeWhen(
          logged: () {
            ref
                .read(pageStatusStateProvider.notifier)
                .setStatus(Status.pegxSubmitAmp);
          },
          gaidAdded: () {
            ref
                .read(pageStatusStateProvider.notifier)
                .setStatus(Status.pegxSubmitFinish);
          },
          orElse: () {},
        ),
      );

      return;
    }, [pegxLoginState]);

    useEffect(() {
      ref.read(pegxWebsocketClientProvider).connectToSocket();
      ref.read(pegxWebsocketClientProvider).login();

      return;
    }, const []);

    return DAmpBackgroundPage(content: [
      if (ampLoginEnum == AmpLoginEnum.stokr) ...[
        DStokrLoginDialog(
          onClose: () {
            // ref.read(stokrLoginStateProvider.notifier).state =
            //     const StokrLoginStateEmpty();
            ref.read(walletProvider).goBack();
          },
          content: const DStokrLoginDialogBody(),
        ),
      ],
      if (ampLoginEnum == AmpLoginEnum.pegx) ...[
        DPegxLoginDialog(
          onClose: () {
            ref.read(walletProvider).goBack();
          },
          content: const DPegxLoginDialogBody(),
        )
      ],
    ]);
  }
}
