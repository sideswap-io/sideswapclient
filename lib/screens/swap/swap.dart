import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/models/swap_models.dart';
import 'package:sideswap/providers/subscribe_price_providers.dart';
import 'package:sideswap/providers/swap_provider.dart';
import 'package:sideswap/screens/swap/widgets/swap_bottom_background.dart';
import 'package:sideswap/screens/swap/widgets/swap_bottom_button.dart';
import 'package:sideswap/screens/swap/widgets/swap_deliver_amount.dart';
import 'package:sideswap/screens/swap/widgets/swap_middle_icon.dart';
import 'package:sideswap/screens/swap/widgets/swap_receive_amount.dart';
import 'package:sideswap/screens/swap/widgets/top_swap_buttons.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class SwapMain extends HookConsumerWidget {
  const SwapMain({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<bool>(showAddressLabelProvider, (_, next) {
      final errorText = ref.read(swapAddressErrorProvider);
      if (next && errorText == null) {
        FocusManager.instance.primaryFocus?.unfocus();
      }
    });
    ref.listen(swapSendTextAmountNotifierProvider, (_, __) {});
    ref.listen(swapRecvTextAmountNotifierProvider, (_, __) {});
    ref.listen(satoshiSendAmountStateNotifierProvider, (_, __) {});
    ref.listen(satoshiRecvAmountStateNotifierProvider, (_, __) {});
    ref.listen<String>(swapNetworkErrorNotifierProvider, (_, next) {
      if (next.isNotEmpty) {
        ref.invalidate(swapStateNotifierProvider);
      }
    });
    ref.listen(subscribePriceStreamNotifierProvider, (_, next) {
      next.maybeWhen(
          data: (From_UpdatePriceStream priceStream) {
            if (priceStream.hasPrice()) {
              final swapState = ref.read(swapStateNotifierProvider);
              if (swapState == const SwapState.idle()) {
                ref
                    .read(swapPriceStateNotifierProvider.notifier)
                    .setPrice(priceStream.price);
              }
            }
          },
          orElse: () {});
    });

    ref.listen<SwapRecvAmountPriceStream>(recvAmountPriceStreamWatcherProvider,
        (_, next) {
      if (next is SwapRecvAmountPriceStreamData) {
        ref
            .read(swapRecvTextAmountNotifierProvider.notifier)
            .setAmount(next.value);
      }
    });
    ref.listen<SwapSendAmountPriceStream>(sendAmountPriceStreamWatcherProvider,
        (_, next) {
      if (next is SwapSendAmountPriceStreamData) {
        ref
            .read(swapSendTextAmountNotifierProvider.notifier)
            .setAmount(next.value);
      }
    });

    final swapType = ref.watch(swapTypeProvider);

    // Popups disabled for now
    final pegInInfoDisplayed = useState(true);
    final pegOutInfoDisplayed = useState(true);

    useEffect(() {
      if (swapType == const SwapType.pegIn() && !pegInInfoDisplayed.value) {
        Future.microtask(() {
          ref.read(swapHelperProvider).showPegInInformation();
          pegInInfoDisplayed.value = true;
        });
      }

      if (swapType == const SwapType.pegOut() && !pegOutInfoDisplayed.value) {
        Future.microtask(() {
          ref.read(swapHelperProvider).showPegOutInformation();
          pegOutInfoDisplayed.value = true;
        });
      }

      return;
    }, [swapType, pegInInfoDisplayed, pegOutInfoDisplayed]);

    useEffect(() {
      ref
          .read(subscribePriceStreamNotifierProvider.notifier)
          .subscribeToPriceStream();

      return;
    }, const []);

    final deliverFocusNode = useFocusNode();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        final currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final middle = swapType == const SwapType.atomic() ? 191.0 : 191.0;

          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: constraints.maxWidth,
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Stack(
                  children: [
                    SwapBottomBackground(
                      middle: middle,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 18),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Visibility(
                              visible: swapType != const SwapType.atomic(),
                              child: TopSwapButtons(
                                onPegInPressed: () {
                                  ref.read(swapHelperProvider).switchToPegs();
                                  deliverFocusNode.unfocus();
                                },
                                onPegOutPressed: () {
                                  ref.read(swapHelperProvider).switchToPegs();
                                  ref.read(swapHelperProvider).toggleAssets();
                                  deliverFocusNode.requestFocus();
                                },
                              ),
                            ),
                          ),
                          if (swapType == const SwapType.atomic()) ...[
                            SizedBox(
                              height: 36,
                              child: Text(
                                'Instant Swap'.tr(),
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                          const SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            height: 109,
                            child: SwapDeliverAmount(
                              deliverFocusNode: deliverFocusNode,
                            ),
                          ),
                          SwapMiddleIcon(
                            visibleToggles: false,
                            onTap: ref.read(swapHelperProvider).toggleAssets,
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          const SwapReceiveAmount(),
                          const Spacer(),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: SwapBottomButton(),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
