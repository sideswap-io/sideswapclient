import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/peg_in_info_lines.dart';
import 'package:sideswap/desktop/common/button/d_custom_filled_big_button.dart';
import 'package:sideswap/desktop/common/button/d_custom_text_big_button.dart';
import 'package:sideswap/providers/pegs_provider.dart';
import 'package:sideswap/providers/swap_providers.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/screens/swap/widgets/swap_bottom_button.dart';
import 'package:sideswap/screens/swap/widgets/swap_button.dart';
import 'package:sideswap/screens/swap/widgets/swap_deliver_amount.dart';
import 'package:sideswap/screens/swap/widgets/swap_middle_icon.dart';
import 'package:sideswap/screens/swap/widgets/swap_receive_amount.dart';
import 'package:sideswap/screens/tx/widgets/empty_tx_list_item.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class DPegInOut extends HookConsumerWidget {
  const DPegInOut({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final swapType = ref.watch(swapTypeProvider);
    final pegRepository = ref.watch(pegRepositoryProvider);

    useEffect(() {
      Future.microtask(() => ref.invalidate(swapPegAddressServerProvider));

      pegRepository.setActivePage(activePage: ActivePage.PEG_IN);

      pegRepository.getPegOutAmount();
      return;
    }, const []);

    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 570,
              height: 680,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: SideSwapColors.prussianBlue,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 18),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: TopPegButtons(),
                  ),
                  const SizedBox(height: 24),
                  swapType == SwapType.pegIn()
                      ? Flexible(child: const DPegIn())
                      : Flexible(child: const DPegOut()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TopPegButtons extends HookConsumerWidget {
  const TopPegButtons({super.key});

  final _colorToggleOn = const Color(0xFF1F7EB1);
  final _colorToggleTextOn = const Color(0xFFFFFFFF);
  final _colorToggleTextOff = SideSwapColors.ceruleanFrost;
  final _colorToggleBackground = SideSwapColors.maastrichtBlue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final swapType = ref.watch(swapTypeProvider);
    final bitcoinAssetId = ref.watch(bitcoinAssetIdProvider);
    final liquidAssetId = ref.watch(liquidAssetIdStateProvider);
    final pegRepository = ref.watch(pegRepositoryProvider);

    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: _colorToggleBackground,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SwapButton(
              color: swapType == const SwapType.pegIn()
                  ? _colorToggleOn
                  : _colorToggleBackground,
              text: 'Peg-In'.tr(),
              textColor: swapType == const SwapType.pegIn()
                  ? _colorToggleTextOn
                  : _colorToggleTextOff,
              onPressed: () {
                pegRepository.setActivePage(activePage: ActivePage.PEG_IN);
                ref
                    .read(swapSendAssetIdProvider.notifier)
                    .setState(bitcoinAssetId);
              },
            ),
          ),
          Expanded(
            child: SwapButton(
              color: swapType == const SwapType.pegOut()
                  ? _colorToggleOn
                  : _colorToggleBackground,
              text: 'Peg-Out'.tr(),
              textColor: swapType == const SwapType.pegOut()
                  ? _colorToggleTextOn
                  : _colorToggleTextOff,
              onPressed: () {
                pegRepository.setActivePage(activePage: ActivePage.PEG_OUT);
                ref
                    .read(swapSendAssetIdProvider.notifier)
                    .setState(liquidAssetId);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DPegIn extends HookConsumerWidget {
  const DPegIn({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final swapHelper = ref.watch(swapHelperProvider);

    useEffect(() {
      Future.microtask(() => swapHelper.switchToPegs());

      return;
    }, const []);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: Column(
        children: [
          Text(
            'Send BTC to this address'.tr(),
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 15,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          DPegInAddressBox(),
          const SizedBox(height: 32),
          DPegInDescription(),
        ],
      ),
    );
  }
}

class DPegInAddressBox extends HookConsumerWidget {
  const DPegInAddressBox({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pegRepository = ref.watch(pegRepositoryProvider);
    final recvAddress = ref.watch(swapPegAddressServerProvider);
    final swapState = ref.watch(swapStateProvider);

    ref.listen(swapNetworkErrorProvider, (_, next) {
      if (next.isNotEmpty) {
        ref.invalidate(swapStateProvider);
      }
    });

    return Container(
      height: 174,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: SideSwapColors.maastrichtBlue,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 142,
              height: 142,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: recvAddress == null
                    ? SideSwapColors.prussianBlue
                    : Colors.white,
              ),
              child: recvAddress == null
                  ? Padding(
                      padding: const EdgeInsets.all(11.0),
                      child: SvgPicture.asset(
                        'assets/peg_qr_code.svg',
                        width: 142,
                        height: 142,
                      ),
                    )
                  : QrImageView(
                      padding: const EdgeInsets.all(11.0),
                      data: recvAddress,
                      version: QrVersions.auto,
                      size: 142,
                      eyeStyle: const QrEyeStyle(
                        eyeShape: QrEyeShape.square,
                        color: Colors.black,
                      ),
                      dataModuleStyle: const QrDataModuleStyle(
                        dataModuleShape: QrDataModuleShape.square,
                        color: Colors.black,
                      ),
                    ),
            ),
            const SizedBox(width: 16),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PEGIN_MINIMUM_BTC_AMOUNT'.tr(
                      args: [pegRepository.pegInMinAmount()],
                    ),
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontSize: 13,
                      color: SideSwapColors.ceruleanFrost,
                    ),
                  ),
                  const SizedBox(height: 10),
                  recvAddress == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            EmptyTextContainer(
                              width: 300,
                              height: 18,
                              color: SideSwapColors.prussianBlue,
                            ),
                            const SizedBox(height: 10),
                            EmptyTextContainer(
                              width: 240,
                              height: 18,
                              color: SideSwapColors.prussianBlue,
                            ),
                          ],
                        )
                      : Flexible(
                          child: SelectableText(
                            recvAddress,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                  const SizedBox(height: 16),
                  recvAddress == null
                      ? Row(
                          children: [
                            DCustomFilledBigButton(
                              width: 123,
                              height: 32,
                              onPressed: swapState == const SwapState.sent()
                                  ? null
                                  : () {
                                      final msg = To();
                                      msg.pegInRequest = To_PegInRequest();
                                      ref.read(walletProvider).sendMsg(msg);
                                      ref
                                          .read(swapStateProvider.notifier)
                                          .setState(const SwapState.sent());
                                    },
                              child: Text(
                                'Generate address'.tr(),
                                style: Theme.of(
                                  context,
                                ).textTheme.labelMedium?.copyWith(fontSize: 13),
                              ),
                            ),
                            if (swapState == const SwapState.sent()) ...[
                              const SizedBox(width: 16),
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator.adaptive(),
                              ),
                            ],
                          ],
                        )
                      : DCustomTextBigButton(
                          height: 32,
                          onPressed: () async {
                            await copyToClipboard(
                              context,
                              recvAddress,
                              displaySnackbar: false,
                            );
                            if (context.mounted) {
                              await copyToClipboard(
                                context,
                                recvAddress,
                                suffix: recvAddress,
                              );
                            }
                          },
                          child: Row(
                            children: [
                              SvgPicture.asset('assets/copy3.svg', width: 16),
                              const SizedBox(width: 8),
                              Text(
                                'Copy address'.tr(),
                                style: Theme.of(
                                  context,
                                ).textTheme.labelMedium?.copyWith(fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DPegInDescription extends StatelessWidget {
  const DPegInDescription({super.key});
  @override
  Widget build(BuildContext context) {
    // The shared widget owns the conversion-rate rule (100 - peg-in server fee
    // percent, hidden at zero); this caller only sets the desktop bullet gap.
    return const PegInInfoLines(bulletSpacing: 11);
  }
}

class DPegOut extends HookConsumerWidget {
  const DPegOut({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(swapHelperProvider, (_, _) {});
    final deliverFocusNode = useFocusNode();

    final pegRepository = ref.watch(pegRepositoryProvider);
    final swapHelper = ref.watch(swapHelperProvider);

    ref.listen(bitcoinCurrentFeeRateProvider, (_, _) {});

    useEffect(() {
      pegRepository.setActivePage(activePage: ActivePage.PEG_OUT);
      Future.microtask(() {
        swapHelper.switchToPegs();
        swapHelper.toggleAssets();
      });

      return;
    }, const []);

    FocusScope.of(context).requestFocus(deliverFocusNode);

    return Stack(
      children: [
        Column(
          children: [
            const SizedBox(height: 137),
            Flexible(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: SideSwapColors.blumine,
                ),
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
