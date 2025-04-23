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
import 'package:sideswap/providers/receive_address_providers.dart';
import 'package:sideswap/providers/server_status_providers.dart';
import 'package:sideswap/providers/swap_providers.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap/screens/home/widgets/rounded_button.dart';
import 'package:sideswap/screens/home/widgets/rounded_button_with_label.dart';
import 'package:sideswap/screens/swap/widgets/rounded_text_label.dart';

class AssetReceiveWidget extends HookConsumerWidget {
  const AssetReceiveWidget({
    this.isPegIn = false,
    this.showShare = true,
    super.key,
  });

  final bool isPegIn;
  final bool showShare;

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

    final receiveAddress = ref.watch(currentReceiveAddressProvider);
    final recvAddress =
        isPegIn
            ? ref.watch(swapPegAddressServerNotifierProvider)
            : receiveAddress.recvAddress;
    final swapRecvAddr = ref.watch(swapRecvAddressExternalNotifierProvider);

    final swapDeliverAsset = ref.watch(swapDeliverAssetProvider);
    final pegOutServerFeePercent = ref.watch(pegOutServerFeePercentProvider);
    final pegInServerFeePercent = ref.watch(pegInServerFeePercentProvider);

    final liquidAssetId = ref.watch(liquidAssetIdStateProvider);
    var percentConversion =
        (pegInServerFeePercent == 0 || pegInServerFeePercent == 0)
            ? 0
            : swapDeliverAsset.asset.assetId == liquidAssetId
            ? 100 - pegOutServerFeePercent
            : 100 - pegInServerFeePercent;

    final conversionStr = percentConversion.toStringAsFixed(2);

    if (recvAddress == null || recvAddress.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final pegRepository = ref.watch(pegRepositoryProvider);

    final smallFontStyle =
        FlavorConfig.isDesktop
            ? Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14)
            : Theme.of(context).textTheme.bodyMedium;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 16),
        Container(
          width: isPegIn ? 151 : 263,
          height: isPegIn ? 151 : 263,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
          ),
          child: Center(
            child: QrImageView(
              data: recvAddress,
              version: QrVersions.auto,
              size: 223,
            ),
          ),
        ),
        ...switch (isPegIn) {
          true => [
            SizedBox(height: 16),
            Text(
              'PEGIN_MINIMUM_BTC_AMOUNT'.tr(
                args: [pegRepository.pegInMinAmount()],
              ),
              style: smallFontStyle,
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: SideSwapColors.chathamsBlue,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                        text: TextSpan(
                          text: 'PEGIN_LESS'.tr(),
                          style: smallFontStyle,
                          children: [
                            TextSpan(
                              text: 'PEGIN_LESS_AMOUNT'.tr(
                                args: [pegRepository.pegInWalletBalance()],
                              ),
                              style: smallFontStyle?.copyWith(
                                color: SideSwapColors.brightTurquoise,
                              ),
                            ),
                            TextSpan(
                              text: 'PEGIN_LESS_END'.tr(),
                              style: smallFontStyle,
                            ),
                            TextSpan(
                              text: 'PEGIN_GREATER'.tr(),
                              style: smallFontStyle,
                            ),
                            TextSpan(
                              text: 'PEGIN_GREATER_AMOUNT'.tr(
                                args: [pegRepository.pegInWalletBalance()],
                              ),
                              style: smallFontStyle?.copyWith(
                                color: SideSwapColors.brightTurquoise,
                              ),
                            ),
                            TextSpan(
                              text: 'PEGIN_GREATER_END'.tr(),
                              style: smallFontStyle,
                            ),
                            TextSpan(
                              text: 'PEGIN_RELEASED'.tr(),
                              style: smallFontStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          false => [
            SizedBox(height: 24),
            Text(
              'Receiving address'.tr(),
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Color(0xFF00B4E9),
              ),
            ).tr(),
          ],
        },
        SizedBox(height: isPegIn ? 16 : 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onLongPress: () async {
                await copyToClipboard(
                  context,
                  recvAddress,
                  displaySnackbar: false,
                );
                showCopyInfo();
              },
              child: Text(
                recvAddress,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
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
            ...switch (showShare) {
              true => [
                SizedBox(width: 32),
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
              ],
              _ => [SizedBox()],
            },
          ],
        ),
        ...switch (isPegIn) {
          true => [
            Flexible(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: Container(
                      height: double.maxFinite,
                      width: double.maxFinite,
                      color: SideSwapColors.chathamsBlue,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 200,
                          child: RoundedTextLabel(
                            text: 'CONVERSION_RATE'.tr(args: [conversionStr]),
                            allRectRadius: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        'Your SideSwap wallet:'.tr(),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: SideSwapColors.brightTurquoise,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 90),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SelectableText(
                        swapRecvAddr,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: FlavorConfig.isDesktop ? 95 : 130,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: AnimatedOpacity(
                        opacity: copyInfoState.value ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        child: RoundedButton(
                          color: SideSwapColors.maastrichtBlue,
                          width: double.infinity,
                          heigh: 39,
                          borderRadius: BorderRadius.circular(8),
                          child:
                              Text(
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
                  ),
                ],
              ),
            ),
          ],
          _ => [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AnimatedOpacity(
                opacity: copyInfoState.value ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: RoundedButton(
                  color: const Color(0xFF002336),
                  width: double.infinity,
                  heigh: 39,
                  borderRadius: BorderRadius.circular(8),
                  child: Consumer(
                    builder: (context, ref, child) {
                      final receiveAddress = ref.watch(
                        currentReceiveAddressProvider,
                      );
                      return Text(
                        receiveAddress.accountType.isAmp
                            ? 'AMP address copied'.tr()
                            : 'Liquid address copied'.tr(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        },
      ],
    );
  }
}
