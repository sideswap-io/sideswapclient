import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/utils/use_timeout_fn.dart';
import 'package:sideswap/providers/pegs_provider.dart';
import 'package:sideswap/providers/server_status_providers.dart';
import 'package:sideswap/providers/swap_providers.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/screens/home/widgets/rounded_button.dart';
import 'package:sideswap/screens/home/widgets/rounded_button_with_label.dart';

class PegInWidet extends HookConsumerWidget {
  const PegInWidet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final copyInfoState = useState(false);
    final copyTimeoutCallback = useTimeoutFn(() {
      copyInfoState.value = false;
    }, Duration(milliseconds: 1500));

    final showCopyInfo = useCallback(() {
      copyInfoState.value = true;
      copyTimeoutCallback.reset();
    });

    final recvAddress = ref.watch(swapPegAddressServerProvider);

    if (recvAddress == null || recvAddress.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: PegInReceiveAddress(showCopyInfo: showCopyInfo),
        ),
        const SizedBox(height: 32),
        PegInDescription(),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RoundedButtonWithLabel(
              iconHeight: 48,
              iconWidth: 48,
              onTap: () async {
                await copyToClipboard(
                  context,
                  recvAddress,
                  displaySnackbar: false,
                );
                showCopyInfo();
              },
              label: 'Copy'.tr(),
              buttonBackground: Colors.white,
              labelTextStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
              child: SvgPicture.asset('assets/copy.svg', width: 22, height: 22),
            ),
            RoundedButtonWithLabel(
              iconHeight: 48,
              iconWidth: 48,
              onTap: () async {
                await shareAddress(recvAddress);
              },
              label: 'Share'.tr(),
              buttonBackground: Colors.white,
              child: SvgPicture.asset(
                'assets/share.svg',
                width: 22,
                height: 22,
              ),
            ),
            RoundedButtonWithLabel(
              iconHeight: 48,
              iconWidth: 48,
              onTap: () async {
                await showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white,
                      ),
                      width: 300,
                      height: 300,
                      child: Center(
                        child: QrImageView(
                          data: recvAddress,
                          version: QrVersions.auto,
                          size: 260,
                        ),
                      ),
                    ),
                  ),
                );
              },
              label: 'QR code'.tr(),
              buttonBackground: Colors.white,
              child: SvgPicture.asset(
                'assets/qr_code_scan.svg',
                width: 22,
                height: 22,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: AnimatedOpacity(
            opacity: copyInfoState.value ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: RoundedButton(
              color: SideSwapColors.maastrichtBlue,
              width: double.infinity,
              height: 39,
              borderRadius: BorderRadius.circular(8),
              child: Text(
                'Bitcoin address copied'.tr(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ).tr(),
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class PegInReceiveAddress extends HookConsumerWidget {
  const PegInReceiveAddress({super.key, required this.showCopyInfo});

  final Null Function() showCopyInfo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recvAddress = ref.watch(swapPegAddressServerProvider);
    final pegRepository = ref.watch(pegRepositoryProvider);

    return Container(
      decoration: BoxDecoration(
        color: SideSwapColors.chathamsBlue,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),

      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onLongPress: () async {
            await copyToClipboard(
              context,
              recvAddress ?? '',
              displaySnackbar: false,
            );
            showCopyInfo();
          },
          onTap: () async {
            await copyToClipboard(
              context,
              recvAddress ?? '',
              displaySnackbar: false,
            );
            showCopyInfo();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Column(
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        recvAddress ?? '',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SvgPicture.asset(
                          'assets/copy3.svg',
                          width: 16,
                          height: 16,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'PEGIN_MINIMUM_BTC_AMOUNT'.tr(
                    args: [pegRepository.pegInMinAmount().toString()],
                  ),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontSize: 13,
                    color: SideSwapColors.ceruleanFrost,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PegInDescription extends HookConsumerWidget {
  const PegInDescription({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final swapDeliverAsset = ref.watch(swapDeliverAssetProvider);
    final pegOutServerFeePercent = ref.watch(pegOutServerFeePercentProvider);
    final pegInServerFeePercent = ref.watch(pegInServerFeePercentProvider);

    final liquidAssetId = ref.watch(liquidAssetIdStateProvider);
    var percentConversion =
        (pegInServerFeePercent == 0 || pegInServerFeePercent == 0)
        ? 0
        : swapDeliverAsset.assetId == liquidAssetId
        ? 100 - pegOutServerFeePercent
        : 100 - pegInServerFeePercent;

    final conversionStr = percentConversion.toStringAsFixed(2);

    final pegRepository = ref.watch(pegRepositoryProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: SideSwapColors.chathamsBlue,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '•',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontSize: 13,
                      color: SideSwapColors.ceruleanFrost,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: RichText(
                      text: TextSpan(
                        text: 'PEGIN_1STLINE'.tr(),
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              fontSize: 13,
                              color: SideSwapColors.ceruleanFrost,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '•',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontSize: 13,
                      color: SideSwapColors.ceruleanFrost,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'PEGIN_2NDLINE'.tr(),
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontSize: 13,
                        color: SideSwapColors.ceruleanFrost,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '•',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontSize: 13,
                      color: SideSwapColors.ceruleanFrost,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: RichText(
                      text: TextSpan(
                        text: 'PEGIN_CONVERSION_RATE'.tr(args: [conversionStr]),
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              fontSize: 13,
                              color: SideSwapColors.ceruleanFrost,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '•',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontSize: 13,
                      color: SideSwapColors.ceruleanFrost,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: RichText(
                      text: TextSpan(
                        text: 'PEGIN_LESS'.tr(),
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              fontSize: 13,
                              color: SideSwapColors.ceruleanFrost,
                            ),
                        children: [
                          TextSpan(
                            text: 'PEGIN_LESS_AMOUNT'.tr(
                              args: [pegRepository.pegInWalletBalance()],
                            ),
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(
                                  fontSize: 13,
                                  color: SideSwapColors.brightTurquoise,
                                ),
                          ),
                          TextSpan(
                            text: 'PEGIN_LESS_END'.tr(),
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(
                                  fontSize: 13,
                                  color: SideSwapColors.ceruleanFrost,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '•',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontSize: 13,
                      color: SideSwapColors.ceruleanFrost,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: RichText(
                      text: TextSpan(
                        text: 'PEGIN_GREATER'.tr(),
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              fontSize: 13,
                              color: SideSwapColors.ceruleanFrost,
                            ),
                        children: [
                          TextSpan(
                            text: 'PEGIN_GREATER_AMOUNT'.tr(
                              args: [pegRepository.pegInWalletBalance()],
                            ),
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(
                                  fontSize: 13,
                                  color: SideSwapColors.brightTurquoise,
                                ),
                          ),
                          TextSpan(
                            text: 'PEGIN_GREATER_END'.tr(),
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(
                                  fontSize: 13,
                                  color: SideSwapColors.ceruleanFrost,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '•',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontSize: 13,
                      color: SideSwapColors.ceruleanFrost,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: RichText(
                      text: TextSpan(
                        text: 'PEGIN_RELEASED'.tr(),
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              fontSize: 13,
                              color: SideSwapColors.ceruleanFrost,
                            ),
                        children: [
                          TextSpan(
                            text: 'PEGIN_LESS_AMOUNT'.tr(
                              args: [pegRepository.pegInWalletBalance()],
                            ),
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(
                                  fontSize: 13,
                                  color: SideSwapColors.brightTurquoise,
                                ),
                          ),
                          TextSpan(
                            text: 'PEGIN_RELEASED_END'.tr(),
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(
                                  fontSize: 13,
                                  color: SideSwapColors.ceruleanFrost,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
