import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/models/balances_provider.dart';
import 'package:sideswap/models/swap_models.dart';
import 'package:sideswap/models/swap_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap/screens/swap/widgets/swap_bottom_background.dart';
import 'package:sideswap/screens/swap/widgets/swap_middle_icon.dart';
import 'package:sideswap/screens/swap/widgets/swap_side_amount.dart';
import 'package:sideswap/screens/swap/widgets/top_swap_buttons.dart';

class SwapMain extends ConsumerStatefulWidget {
  const SwapMain({
    super.key,
    this.isDesktop = false,
  });

  final bool isDesktop;

  @override
  SwapMainState createState() => SwapMainState();
}

class SwapMainState extends ConsumerState<SwapMain> {
  TextEditingController? swapSendAmountController;
  TextEditingController? swapRecvAmountController;
  TextEditingController? swapAddressRecvController;

  late FocusNode deliverFocusNode;
  late FocusNode receiveFocusNode;

  bool pegInInfoDisplayed = false;
  bool pegOutInfoDisplayed = false;

  @override
  void initState() {
    super.initState();

    swapSendAmountController = TextEditingController();
    swapRecvAmountController = TextEditingController();
    swapAddressRecvController = TextEditingController();
    deliverFocusNode = FocusNode();
    receiveFocusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(deliverFocusNode);
    });

    ref
        .read(priceStreamSubscribeChangeNotifierProvider)
        .subscribeToPriceStream();
  }

  @override
  void dispose() {
    swapSendAmountController?.dispose();
    swapRecvAmountController?.dispose();
    swapAddressRecvController?.dispose();
    deliverFocusNode.dispose();
    receiveFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<bool>(showAddressLabelStateProvider, (_, next) {
      final errorText = ref.read(swapAddressErrorStateProvider);
      if (next && errorText == null) {
        FocusManager.instance.primaryFocus?.unfocus();
      }
    });
    ref.listen(swapSendAmountChangeNotifierProvider, (_, __) {});
    ref.listen(swapRecvAmountChangeNotifierProvider, (_, __) {});
    ref.listen(satoshiSendAmountStateNotifierProvider, (_, __) {});
    ref.listen(satoshiRecvAmountStateNotifierProvider, (_, __) {});
    ref.listen<String>(swapNetworkErrorStateProvider, (_, next) {
      if (next.isNotEmpty) {
        ref.read(swapStateProvider.notifier).state = SwapState.idle;
      }
    });
    ref.listen<PriceStreamSubscribeProvider>(
        priceStreamSubscribeChangeNotifierProvider, (_, next) {
      if (next.msg.hasPrice()) {
        final swapState = ref.read(swapStateProvider);
        if (swapState == SwapState.idle) {
          ref
              .read(swapPriceStateNotifierProvider.notifier)
              .setPrice(next.msg.price);
        }
      }
    });

    ref.listen<SwapRecvAmountPriceStream>(recvAmountPriceStreamWatcherProvider,
        (_, next) {
      if (next is SwapRecvAmountPriceStreamData) {
        ref
            .read(swapRecvAmountChangeNotifierProvider.notifier)
            .setAmount(next.value);
      }
    });
    ref.listen<SwapSendAmountPriceStream>(sendAmountPriceStreamWatcherProvider,
        (_, next) {
      if (next is SwapSendAmountPriceStreamData) {
        ref
            .read(swapSendAmountChangeNotifierProvider.notifier)
            .setAmount(next.value);
      }
    });

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
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: constraints.maxWidth,
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Stack(
                  children: [
                    const SwapBottomBackground(),
                    SwapMiddleIcon(
                      visibleToggles: false,
                      onTap: ref.read(swapProvider).toggleAssets,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              top: FlavorConfig.isDesktop ? 305.h : 237.h),
                          child: buildReceiveAmount(),
                        ),
                        const Spacer(),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: buildBottomButton(),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16.h),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Visibility(
                              visible: !widget.isDesktop,
                              child: TopSwapButtons(
                                onSwapPressed:
                                    ref.read(swapProvider).switchToSwaps,
                                onPegPressed:
                                    ref.read(swapProvider).switchToPegs,
                                isDesktop: widget.isDesktop,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 8.h),
                            child: buildDeliverAmount(),
                          ),
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

  bool swapEnabled() {
    final swapType = ref.watch(swapProvider).swapType();
    final sendSatoshiAmount =
        ref.watch(swapSendAmountChangeNotifierProvider).satoshiAmount;
    final recvSatoshiAmount =
        ref.watch(swapRecvAmountChangeNotifierProvider).satoshiAmount;
    final insufficientFunds = ref.watch(showInsufficientFundsProvider);
    final addressErrorText = ref.watch(swapAddressErrorStateProvider);
    final addressRecvExternal = ref.watch(swapProvider).swapRecvAddressExternal;

    bool enabled;
    switch (swapType) {
      case SwapType.atomic:
        enabled = sendSatoshiAmount > 0 &&
            recvSatoshiAmount > 0 &&
            !insufficientFunds;
        break;
      case SwapType.pegIn:
        enabled = true;
        break;
      case SwapType.pegOut:
        enabled = sendSatoshiAmount > 0 &&
            !insufficientFunds &&
            addressRecvExternal.isNotEmpty &&
            addressErrorText == null;
        break;
    }

    final swapState = ref.watch(swapStateProvider);

    enabled = enabled && swapState == SwapState.idle;
    return enabled;
  }

  Widget buildBottomButton() {
    return Padding(
      padding: EdgeInsets.only(top: 16.h, bottom: 24.h),
      child: Consumer(
        builder: (context, ref, _) {
          final swapType = ref.watch(swapProvider).swapType();
          final swapTypeStr =
              ref.watch(swapProvider).swapTypeStr(swapType).toUpperCase();

          if (swapType == SwapType.pegIn && !pegInInfoDisplayed) {
            ref.watch(swapProvider).showPegInInformation();
            pegInInfoDisplayed = true;
          }

          if (swapType == SwapType.pegOut && !pegOutInfoDisplayed) {
            ref.watch(swapProvider).showPegOutInformation();
            pegOutInfoDisplayed = true;
          }

          final swapState = ref.watch(swapStateProvider);
          final enabled = swapEnabled();

          return CustomBigButton(
            width: double.infinity,
            height: 54.h,
            enabled: enabled,
            backgroundColor: const Color(0xFF00C5FF),
            onPressed:
                enabled ? () => ref.read(swapProvider).swapAccept() : null,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  swapTypeStr,
                  style: GoogleFonts.roboto(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
                if (swapState == SwapState.sent) ...[
                  Padding(
                    padding: EdgeInsets.only(left: 84.w),
                    child: SizedBox(
                      width: 32.w,
                      height: 32.w,
                      child: SpinKitCircle(
                        color: Colors.white,
                        size: 32.w,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildReceiveAmount() {
    return Consumer(
      builder: (context, ref, _) {
        final swapRecvAssets =
            ref.watch(swapProvider).swapRecvAssets().toList();
        final swapRecvAsset =
            ref.watch(swapProvider.select((p) => p.swapRecvAsset!));
        final swapRecvWallet =
            ref.watch(swapProvider.select((p) => p.swapRecvWallet));
        final precision = ref
            .watch(walletProvider)
            .getPrecisionForAssetId(assetId: swapRecvAsset.asset);
        final swapRecvAccount =
            AccountAsset(AccountType.regular, swapRecvAsset.asset);
        final balance = ref
            .watch(balancesProvider.select((p) => p.balances[swapRecvAccount]));
        final balanceStr = amountStr(balance ?? 0, precision: precision);
        final swapType = ref.watch(swapProvider).swapType();
        final swapState = ref.watch(swapStateProvider);

        // Show error in one place only
        final subscribe = ref.watch(swapPriceSubscribeStateNotifierProvider);
        final serverError = subscribe != const SwapPriceSubscribeStateRecv()
            ? ''
            : ref.watch(swapNetworkErrorStateProvider);
        final feeRates = ref.watch(bitcoinFeeRatesProvider).feeRates;
        final addressErrorText = ref.watch(swapAddressErrorStateProvider);
        final showAddressLabel = ref.watch(showAddressLabelStateProvider);

        ref.listen<SwapRecvAmountProvider>(swapRecvAmountChangeNotifierProvider,
            (previous, next) {
          final newValue = replaceCharacterOnPosition(
            input: next.amount,
          );

          swapRecvAmountController!.value = fixCursorPosition(
              controller: swapRecvAmountController!, newValue: newValue);
        });

        ref.listen<SwapChangeNotifierProvider>(swapProvider, (_, next) {
          final externalAddress = swapAddressRecvController?.text ?? '';
          if (externalAddress != next.swapRecvAddressExternal) {
            swapAddressRecvController!.text = next.swapRecvAddressExternal;
          }
        });

        return SwapSideAmount(
          text: 'Receive'.tr(),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          controller: swapRecvAmountController!,
          addressController: swapAddressRecvController!,
          isMaxVisible: false,
          readOnly: swapType != SwapType.atomic || swapState != SwapState.idle,
          hintText: '0.0',
          showHintText: swapType == SwapType.atomic,
          dropdownReadOnly:
              swapType == SwapType.atomic && swapRecvAssets.length > 1
                  ? false
                  : true,
          onEditingCompleted: () {
            if (swapEnabled()) {
              ref.read(swapProvider).swapAccept();
            }
          },
          feeRates: feeRates,
          visibleToggles: false,
          balance: balanceStr,
          dropdownValue: swapRecvAsset,
          availableAssets: swapRecvAssets,
          labelGroupValue: swapRecvWallet,
          addressErrorText: addressErrorText,
          focusNode: receiveFocusNode,
          isAddressLabelVisible: showAddressLabel,
          swapType: swapType,
          showInsufficientFunds: false,
          errorDescription: serverError,
          localLabelOnChanged: (value) =>
              ref.read(swapProvider).setRecvRadioCb(SwapWallet.local),
          externalLabelOnChanged: (value) =>
              ref.read(swapProvider).setRecvRadioCb(SwapWallet.extern),
          onDropdownChanged: ref.read(swapProvider).setReceiveAsset,
          onChanged: (value) {
            ref.read(swapStateProvider.notifier).state = SwapState.idle;
            ref
                .read(swapSendAmountChangeNotifierProvider.notifier)
                .setAmount('0');

            ref
                .read(swapRecvAmountChangeNotifierProvider.notifier)
                .setAmount(value);

            ref
                .read(swapPriceSubscribeStateNotifierProvider.notifier)
                .setRecv();
            ref
                .read(priceStreamSubscribeChangeNotifierProvider)
                .subscribeToPriceStream();
          },
          onAddressEditingCompleted: () async {
            ref.read(swapProvider).swapRecvAddressExternal =
                swapAddressRecvController?.text ?? '';
            FocusScope.of(context).requestFocus(FocusNode());
          },
          onAddressChanged: (text) {
            ref.read(swapProvider).swapRecvAddressExternal = text;
          },
          onAddressLabelClose: () {
            ref.read(showAddressLabelStateProvider.notifier).state = false;
            ref.read(swapProvider).swapRecvAddressExternal = '';
          },
          showAccountsInPopup: true,
        );
      },
    );
  }

  Widget buildDeliverAmount() {
    return Consumer(
      builder: (context, ref, _) {
        final swapSendAsset =
            ref.watch(swapProvider.select((p) => p.swapSendAsset!));
        final balance = ref.watch(
            balancesProvider.select((p) => p.balances[swapSendAsset] ?? 0));
        final precision = ref
            .watch(walletProvider)
            .getPrecisionForAssetId(assetId: swapSendAsset.asset);
        final balanceStr = amountStr(balance, precision: precision);
        final swapSendAssets =
            ref.watch(swapProvider).swapSendAssets().toList();
        final swapSendWallet =
            ref.watch(swapProvider.select((p) => p.swapSendWallet));
        final swapState = ref.watch(swapStateProvider);
        final swapType = ref.watch(swapProvider).swapType();
        final subscribe = ref.watch(swapPriceSubscribeStateNotifierProvider);
        final serverError = subscribe == const SwapPriceSubscribeState.recv()
            ? ''
            : ref.watch(swapNetworkErrorStateProvider);
        final showInsufficientFunds = ref.watch(showInsufficientFundsProvider);

        ref.listen<SwapSendAmountProvider>(swapSendAmountChangeNotifierProvider,
            (previous, next) {
          final newValue = replaceCharacterOnPosition(
            input: next.amount,
          );
          swapSendAmountController!.value = fixCursorPosition(
              controller: swapSendAmountController!, newValue: newValue);
        });

        return SwapSideAmount(
          text: 'Deliver'.tr(),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          controller: swapSendAmountController!,
          focusNode: deliverFocusNode,
          isMaxVisible: true,
          balance: balanceStr,
          readOnly: swapSendWallet == SwapWallet.extern ||
              swapState != SwapState.idle,
          onEditingCompleted: () {
            if (swapEnabled()) {
              ref.read(swapProvider).swapAccept();
            }
          },
          hintText: '0.0',
          showHintText: true,
          visibleToggles: false,
          dropdownValue: swapSendAsset,
          availableAssets: swapSendAssets,
          labelGroupValue: swapSendWallet,
          swapType: swapType,
          showInsufficientFunds: showInsufficientFunds,
          errorDescription: serverError,
          localLabelOnChanged: (value) =>
              ref.read(swapProvider).setSendRadioCb(SwapWallet.local),
          externalLabelOnChanged: (value) =>
              ref.read(swapProvider).setSendRadioCb(SwapWallet.extern),
          onDropdownChanged: ref.read(swapProvider).setDeliverAsset,
          onChanged: (value) {
            ref.read(swapStateProvider.notifier).state = SwapState.idle;
            ref
                .read(swapRecvAmountChangeNotifierProvider.notifier)
                .setAmount('0');

            ref
                .read(swapSendAmountChangeNotifierProvider.notifier)
                .setAmount(value);

            ref
                .read(swapPriceSubscribeStateNotifierProvider.notifier)
                .setSend();
            ref
                .read(priceStreamSubscribeChangeNotifierProvider)
                .subscribeToPriceStream();
          },
          onMaxPressed: ref.read(swapProvider).onMaxSendPressed,
          showAccountsInPopup: true,
        );
      },
    );
  }
}
