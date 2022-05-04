import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/models/notifications_service.dart';
import 'package:sideswap/models/swap_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap/screens/home/widgets/rounded_button.dart';
import 'package:sideswap/screens/home/widgets/rounded_button_with_label.dart';
import 'package:sideswap/screens/swap/widgets/rounded_text_label.dart';

class AssetReceiveWidget extends StatefulWidget {
  const AssetReceiveWidget({
    Key? key,
    this.isPegIn = false,
    this.isAmp = false,
    this.showShare = true,
  }) : super(key: key);

  final bool isPegIn;
  final bool isAmp;
  final bool showShare;

  @override
  _AssetReceivePopupState createState() => _AssetReceivePopupState();
}

class _AssetReceivePopupState extends State<AssetReceiveWidget> {
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
        final recvAddressAccount =
            ref.watch(walletProvider.select((p) => p.recvAddressAccount));
        final recvAddresses = ref.watch(
            walletProvider.select((p) => p.recvAddresses[recvAddressAccount]));
        final _recvAddress = widget.isPegIn
            ? ref.watch(swapProvider.select((p) => p.swapPegAddressServer))
            : recvAddresses;
        final _swapRecvAddr =
            ref.watch(swapProvider.select((p) => p.swapRecvAddressExternal));
        final minPegIn = ref.watch(walletProvider
            .select((p) => p.serverStatus?.minPegInAmount.toInt() ?? 0));

        final _assetSend =
            ref.watch(swapProvider.select((p) => p.swapSendAsset ?? ''));
        final serverFeePercentPegIn = ref.watch(walletProvider
            .select((p) => p.serverStatus?.serverFeePercentPegIn));
        final serverFeePercentPegOut = ref.watch(walletProvider
            .select((p) => p.serverStatus?.serverFeePercentPegOut));
        var _percentConversion =
            (serverFeePercentPegIn == null || serverFeePercentPegOut == null)
                ? 0
                : _assetSend == ref.watch(walletProvider).liquidAssetId()
                    ? 100 - serverFeePercentPegOut
                    : 100 - serverFeePercentPegIn;

        final _conversionStr = _percentConversion.toStringAsFixed(2);
        final _conversionText = 'Conversion rate $_conversionStr%';

        return _recvAddress == null || _recvAddress.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: widget.isPegIn ? 24.h : 29.h),
                    child: Container(
                      width: widget.isPegIn ? 151.w : 263.w,
                      height: widget.isPegIn ? 151.w : 263.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          16.w,
                        ),
                        color: Colors.white,
                      ),
                      child: Center(
                        child: QrImage(
                          data: _recvAddress,
                          version: QrVersions.auto,
                          size: 223.w,
                        ),
                      ),
                    ),
                  ),
                  if (widget.isPegIn && minPegIn != 0) ...[
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text('Min amount: ${amountStr(minPegIn)} BTC',
                          style: GoogleFonts.roboto(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.normal,
                          )),
                    ),
                  ],
                  if (!widget.isPegIn) ...[
                    Padding(
                      padding: EdgeInsets.only(top: 24.h),
                      child: Text(
                        'Receiving address',
                        style: GoogleFonts.roboto(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF00B4E9),
                        ),
                      ).tr(),
                    ),
                  ],
                  Padding(
                    padding: EdgeInsets.only(top: widget.isPegIn ? 16.h : 10.h),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32.w),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onLongPress: () async {
                            await copyToClipboard(context, _recvAddress,
                                displaySnackbar: false);
                            showCopyInfo();
                          },
                          child: SizedBox(
                            width: FlavorConfig.isDesktop ? 400.w : 311.w,
                            height: 60.h,
                            child: Text(
                              _recvAddress,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.roboto(
                                fontSize: 16.sp,
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
                    padding: EdgeInsets.only(top: widget.isPegIn ? 16.h : 32.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RoundedButtonWithLabel(
                          onTap: () async {
                            await copyToClipboard(context, _recvAddress,
                                displaySnackbar: false);
                            showCopyInfo();
                          },
                          label: 'Copy'.tr(),
                          buttonBackground: Colors.white,
                          child: SvgPicture.asset(
                            'assets/copy.svg',
                            width: 28.w,
                            height: 28.w,
                          ),
                        ),
                        if (widget.showShare)
                          Padding(
                            padding: EdgeInsets.only(left: 32.w),
                            child: RoundedButtonWithLabel(
                              onTap: () async {
                                final shortUri = await ref
                                    .read(notificationServiceProvider)
                                    .createShortDynamicLink(
                                        address: _recvAddress);
                                await shareAddress(
                                    'Liquid address:\n$_recvAddress\n\nYou can open directly in app clicking this url: ${shortUri.toString()}');
                              },
                              label: 'Share'.tr(),
                              buttonBackground: Colors.white,
                              child: SvgPicture.asset(
                                'assets/share.svg',
                                width: 28.w,
                                height: 28.w,
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
                            padding: EdgeInsets.only(top: 45.h),
                            child: Container(
                              height: double.maxFinite,
                              width: double.maxFinite,
                              color: const Color(0xFF135579),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 45.h - 26.h / 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 200.w,
                                  child: RoundedTextLabel(
                                    text: _conversionText,
                                    allRectRadius: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 90.h),
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Text(
                                'Your SideSwap wallet:',
                                style: GoogleFonts.roboto(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF00C5FF),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 196.h),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: AnimatedOpacity(
                                opacity: _isCopyDescVisible ? 1.0 : 0.0,
                                duration: const Duration(milliseconds: 500),
                                child: RoundedButton(
                                  color: const Color(0xFF002336),
                                  width: double.infinity,
                                  heigh: 39.h,
                                  borderRadius: BorderRadius.circular(8.w),
                                  child: Text(
                                    'Bitcoin address copied',
                                    style: GoogleFonts.roboto(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ).tr(),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 120.h),
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: SizedBox(
                                width: FlavorConfig.isDesktop ? 400.w : 311.w,
                                height: 60.h,
                                child: Text(
                                  _swapRecvAddr,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.roboto(
                                    fontSize: 16.sp,
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
                      padding: EdgeInsets.only(top: 2.h),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: AnimatedOpacity(
                          opacity: _isCopyDescVisible ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 500),
                          child: RoundedButton(
                            color: const Color(0xFF002336),
                            width: double.infinity,
                            heigh: 39.h,
                            borderRadius: BorderRadius.circular(8.w),
                            child: Text(
                              widget.isAmp
                                  ? 'AMP address copied'
                                  : 'Liquid address copied',
                              style: GoogleFonts.roboto(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ).tr(),
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
