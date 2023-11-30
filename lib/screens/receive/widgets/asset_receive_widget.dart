import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/receive_address_providers.dart';
import 'package:sideswap/providers/swap_provider.dart';
import 'package:sideswap/providers/universal_link_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap/screens/home/widgets/rounded_button.dart';
import 'package:sideswap/screens/home/widgets/rounded_button_with_label.dart';
import 'package:sideswap/screens/swap/widgets/rounded_text_label.dart';

class AssetReceiveWidget extends StatefulWidget {
  const AssetReceiveWidget({
    super.key,
    this.isPegIn = false,
    this.showShare = true,
  });

  final bool isPegIn;
  final bool showShare;

  @override
  AssetReceivePopupState createState() => AssetReceivePopupState();
}

class AssetReceivePopupState extends State<AssetReceiveWidget> {
  bool _isCopyDescVisible = false;
  Timer? _copyVisibilityTimer;

  void showCopyInfo() {
    if (_copyVisibilityTimer?.isActive ?? false) {
      _copyVisibilityTimer?.cancel();
    }

    _copyVisibilityTimer = Timer(const Duration(milliseconds: 1500), () {
      setState(() {
        _isCopyDescVisible = false;
      });
    });

    setState(() {
      _isCopyDescVisible = true;
    });
  }

  @override
  void dispose() {
    _copyVisibilityTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final receiveAddress = ref.watch(currentReceiveAddressProvider);
        final recvAddress = widget.isPegIn
            ? ref.watch(swapProvider.select((p) => p.swapPegAddressServer))
            : receiveAddress.recvAddress;
        final swapRecvAddr =
            ref.watch(swapProvider.select((p) => p.swapRecvAddressExternal));
        final minPegIn = ref.watch(walletProvider
            .select((p) => p.serverStatus?.minPegInAmount.toInt() ?? 0));

        final assetSend =
            ref.watch(swapProvider.select((p) => p.swapSendAsset));
        final serverFeePercentPegIn = ref.watch(walletProvider
            .select((p) => p.serverStatus?.serverFeePercentPegIn));
        final serverFeePercentPegOut = ref.watch(walletProvider
            .select((p) => p.serverStatus?.serverFeePercentPegOut));
        final liquidAssetId = ref.watch(liquidAssetIdStateProvider);
        var percentConversion =
            (serverFeePercentPegIn == null || serverFeePercentPegOut == null)
                ? 0
                : assetSend?.assetId == liquidAssetId
                    ? 100 - serverFeePercentPegOut
                    : 100 - serverFeePercentPegIn;

        final conversionStr = percentConversion.toStringAsFixed(2);
        final conversionText = 'Conversion rate $conversionStr%';

        return recvAddress == null || recvAddress.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: widget.isPegIn ? 24 : 29),
                    child: Container(
                      width: widget.isPegIn ? 151 : 263,
                      height: widget.isPegIn ? 151 : 263,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          16,
                        ),
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
                  ),
                  if (widget.isPegIn && minPegIn != 0) ...[
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Consumer(
                        builder: (context, ref, child) {
                          final amountProvider =
                              ref.watch(amountToStringProvider);
                          final minAmountStr = amountProvider.amountToString(
                              AmountToStringParameters(amount: minPegIn));
                          return Text(
                            'Min amount: $minAmountStr BTC',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                  if (!widget.isPegIn) ...[
                    Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: const Text(
                        'Receiving address',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF00B4E9),
                        ),
                      ).tr(),
                    ),
                  ],
                  Padding(
                    padding: EdgeInsets.only(top: widget.isPegIn ? 16 : 10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onLongPress: () async {
                            await copyToClipboard(context, recvAddress,
                                displaySnackbar: false);
                            showCopyInfo();
                          },
                          child: SizedBox(
                            width: FlavorConfig.isDesktop ? 400 : 311,
                            height: 70,
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
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RoundedButtonWithLabel(
                            iconHeight: 48,
                            iconWidth: 48,
                            onTap: () async {
                              await copyToClipboard(context, recvAddress,
                                  displaySnackbar: false);
                              showCopyInfo();
                            },
                            label: 'Copy'.tr(),
                            buttonBackground: Colors.white,
                            labelTextStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                            ),
                            child: SvgPicture.asset(
                              'assets/copy.svg',
                              width: 22,
                              height: 22,
                            )),
                        if (widget.showShare)
                          Padding(
                            padding: const EdgeInsets.only(left: 32),
                            child: RoundedButtonWithLabel(
                              iconHeight: 48,
                              iconWidth: 48,
                              onTap: () async {
                                final shortUri = getSendLinkUrl(recvAddress);
                                await shareAddress(
                                    'Liquid address:\n$recvAddress\n\nYou can open directly in app clicking this url: ${shortUri.toString()}');
                              },
                              label: 'Share'.tr(),
                              buttonBackground: Colors.white,
                              child: SvgPicture.asset(
                                'assets/share.svg',
                                width: 22,
                                height: 22,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (widget.isPegIn) ...[
                    Flexible(
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 45),
                            child: Container(
                              height: double.maxFinite,
                              width: double.maxFinite,
                              color: SideSwapColors.chathamsBlue,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 45 - 26 / 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 200,
                                  child: RoundedTextLabel(
                                    text: conversionText,
                                    allRectRadius: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 90),
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Text(
                                'Your SideSwap wallet:',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: SideSwapColors.brightTurquoise,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 196),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: AnimatedOpacity(
                                opacity: _isCopyDescVisible ? 1.0 : 0.0,
                                duration: const Duration(milliseconds: 500),
                                child: RoundedButton(
                                  color: const Color(0xFF002336),
                                  width: double.infinity,
                                  heigh: 39,
                                  borderRadius: BorderRadius.circular(8),
                                  child: const Text(
                                    'Bitcoin address copied',
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
                          Padding(
                            padding: const EdgeInsets.only(top: 120),
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: SizedBox(
                                width: FlavorConfig.isDesktop ? 400 : 311,
                                height: 65,
                                child: Text(
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
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (!widget.isPegIn) ...[
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: AnimatedOpacity(
                          opacity: _isCopyDescVisible ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 500),
                          child: RoundedButton(
                            color: const Color(0xFF002336),
                            width: double.infinity,
                            heigh: 39,
                            borderRadius: BorderRadius.circular(8),
                            child: Consumer(
                              builder: (context, ref, child) {
                                final receiveAddress =
                                    ref.watch(currentReceiveAddressProvider);
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
                    ),
                  ],
                ],
              );
      },
    );
  }
}
