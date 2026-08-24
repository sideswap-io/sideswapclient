import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/providers/pegs_provider.dart';
import 'package:sideswap/providers/swap_providers.dart';
import 'package:sideswap/screens/swap/widgets/swap_bottom_button.dart';
import 'package:sideswap/screens/swap/widgets/swap_deliver_amount.dart';
import 'package:sideswap/screens/swap/widgets/swap_middle_icon.dart';
import 'package:sideswap/screens/swap/widgets/swap_receive_amount.dart';
import 'package:sideswap/screens/swap/widgets/top_swap_buttons.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class PegInOut extends HookConsumerWidget {
  const PegInOut({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final swapType = ref.watch(swapTypeProvider);
    final pegRepository = ref.watch(pegRepositoryProvider);
    final deliverFocusNode = useFocusNode();

    useEffect(() {
      final swapHelper = ref.read(swapHelperProvider);
      Future.microtask(() => swapHelper.switchToPegs());
      pegRepository.setActivePage(activePage: ActivePage.PEG_IN);
      pegRepository.getPegOutAmount();
      return;
    }, const []);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        final currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: Column(
        children: [
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TopSwapButtons(
              onPegInPressed: () {
                ref.read(swapHelperProvider).switchToPegs();
                pegRepository.setActivePage(activePage: ActivePage.PEG_IN);
                deliverFocusNode.unfocus();
              },
              onPegOutPressed: () {
                final swapHelper = ref.read(swapHelperProvider);
                swapHelper.switchToPegs();
                swapHelper.toggleAssets();
                pegRepository.setActivePage(activePage: ActivePage.PEG_OUT);
                deliverFocusNode.requestFocus();
              },
            ),
          ),
          Expanded(
            child: swapType == const SwapType.pegOut()
                ? PegOut(deliverFocusNode: deliverFocusNode)
                : PegIn(deliverFocusNode: deliverFocusNode),
          ),
        ],
      ),
    );
  }
}

class PegOut extends HookConsumerWidget {
  const PegOut({super.key, required this.deliverFocusNode});

  final FocusNode deliverFocusNode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(swapHelperProvider, (_, _) {});

    final pegRepository = ref.watch(pegRepositoryProvider);

    useEffect(() {
      pegRepository.setActivePage(activePage: ActivePage.PEG_OUT);
      Future.microtask(() {
        final swapHelper = ref.read(swapHelperProvider);
        swapHelper.switchToPegs();
        swapHelper.toggleAssets();
      });
      return;
    }, const []);

    return _PegContent(deliverFocusNode: deliverFocusNode);
  }
}

class PegIn extends HookConsumerWidget {
  const PegIn({super.key, required this.deliverFocusNode});

  final FocusNode deliverFocusNode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(swapHelperProvider, (_, _) {});

    useEffect(() {
      Future.microtask(() => ref.read(swapHelperProvider).switchToPegs());
      return;
    }, const []);

    return _PegContent(deliverFocusNode: deliverFocusNode);
  }
}

class _PegContent extends ConsumerWidget {
  const _PegContent({required this.deliverFocusNode});

  final FocusNode deliverFocusNode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        Column(
          children: [
            const SizedBox(height: 137),
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: SideSwapColors.blumine,
                ),
                child: const SizedBox.expand(),
              ),
            ),
          ],
        ),
        Column(
          children: [
            const SizedBox(height: 5),
            SizedBox(
              height: 109,
              child: SwapDeliverAmount(deliverFocusNode: deliverFocusNode),
            ),
            SwapMiddleIcon(onTap: ref.read(swapHelperProvider).toggleAssets),
            const SizedBox(height: 6),
            const SwapReceiveAmount(),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SwapBottomButton(),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ],
    );
  }
}
