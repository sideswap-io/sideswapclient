import 'dart:async';
import 'dart:math';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/prompt_allow_tx_chaining.dart';
import 'package:sideswap/desktop/common/button/d_custom_filled_big_button.dart';
import 'package:sideswap/desktop/common/button/d_custom_text_big_button.dart';
import 'package:sideswap/desktop/common/button/d_hover_button.dart';
import 'package:sideswap/desktop/main/d_ttl_popup.dart';
import 'package:sideswap/desktop/markets/d_enter_tracking_price.dart';
import 'package:sideswap/desktop/markets/d_order_amount_enter.dart';
import 'package:sideswap/desktop/widgets/d_popup_with_close.dart';
import 'package:sideswap/desktop/widgets/d_toggle_button.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/jade_provider.dart';
import 'package:sideswap/providers/request_order_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';

const signTotalTime = 60;

enum ReviewScreen {
  submitStart,
  submitSucceed,
  quote,
  sign,
  edit,
}

enum ReviewState {
  idle,
  disabled,
}

String getTitle(
    ReviewScreen screen, ReviewState state, bool twoStep, bool isTracking) {
  return switch (screen) {
    ReviewScreen.submitStart => 'Create order'.tr(),
    ReviewScreen.submitSucceed => 'Order successfully created'.tr(),
    ReviewScreen.quote when state == ReviewState.disabled =>
      'Order signed'.tr(),
    ReviewScreen.quote => 'Accept order'.tr(),
    ReviewScreen.sign => 'Countersign order'.tr(),
    ReviewScreen.edit when twoStep && !isTracking => 'Review order'.tr(),
    ReviewScreen.edit => 'Modify price'.tr(),
  };
}

String getButtonTitle(
    ReviewScreen screen, ReviewState state, bool twoStep, bool isTracking) {
  return switch (screen) {
    ReviewScreen.submitStart => 'Create order'.tr(),
    ReviewScreen.submitSucceed => 'Order successfully created'.tr(),
    ReviewScreen.quote when state == ReviewState.disabled && twoStep =>
      'Awaiting swap broadcast'.tr(),
    ReviewScreen.quote when state == ReviewState.disabled =>
      'Awaiting countersigning'.tr(),
    ReviewScreen.quote => 'Accept order'.tr(),
    ReviewScreen.sign => 'Manual acceptance signing'.tr(),
    ReviewScreen.edit when twoStep && !isTracking => 'Cancel order',
    ReviewScreen.edit => 'Save'.tr(),
  };
}

String getTtlDescription(int? seconds) {
  if (seconds == null || seconds == 0) {
    return unlimitedTtl;
  }
  final sec = Duration(seconds: seconds);
  if (sec.inHours >= 1) {
    return 'HOURS'.plural(sec.inHours, args: ['${sec.inHours}']);
  }

  return 'MINUTES'.plural(sec.inMinutes, args: ['${sec.inMinutes}']);
}

class DOrderReview extends ConsumerStatefulWidget {
  const DOrderReview({
    super.key,
    required this.screen,
  });

  final ReviewScreen screen;

  @override
  ConsumerState<DOrderReview> createState() => DOrderReviewState();
}

class DOrderReviewState extends ConsumerState<DOrderReview> {
  ReviewState state = ReviewState.idle;

  bool autoSign = true;
  bool autoSignOld = true;
  bool public = true;
  int ttl = kInfTtl;
  bool twoStep = true;

  // Edit order values
  bool isTracking = false;
  double price = 0;
  double priceTrackerValue = 0;
  TextEditingController controllerPrice = TextEditingController();

  @override
  void initState() {
    super.initState();
    // TODO: Update default ttl depending on order type here
    final wallet = ref.read(walletProvider);
    if (widget.screen == ReviewScreen.edit) {
      final order = wallet.orderDetailsData;
      final asset = ref.read(assetsStateProvider)[order.assetId];
      final pricedInLiquid =
          ref.read(assetUtilsProvider).isPricedInLiquid(asset: asset);

      isTracking = order.isTracking;
      autoSign = order.autoSign;
      autoSignOld = order.autoSign;
      twoStep = order.twoStep;
      price = order.priceAmount;
      priceTrackerValue =
          indexPriceToTrackerValue(wallet.orderDetailsData.indexPrice);
      controllerPrice.text = priceStr(order.priceAmount, pricedInLiquid);
    } else {
      twoStep = !wallet.orderDetailsData.isTracking;
    }
  }

  @override
  void dispose() {
    controllerPrice.dispose();
    super.dispose();
  }

  Future<void> handleSubmit() async {
    final wallet = ref.read(walletProvider);

    // old modify price for offline orders
    if (widget.screen == ReviewScreen.edit && twoStep && !isTracking) {
      ref.read(walletProvider).cancelOrder(wallet.orderDetailsData.orderId);
      handleClose();
      return;
    }

    if (widget.screen == ReviewScreen.edit) {
      if (autoSign &&
          !autoSignOld &&
          !await ref.read(walletProvider).isAuthenticated()) {
        return;
      }

      final orderId = wallet.orderDetailsData.orderId;
      final price =
          isTracking ? null : (double.tryParse(controllerPrice.text) ?? 0.0);
      final indexPrice =
          isTracking ? trackerValueToIndexPrice(priceTrackerValue) : null;
      wallet.modifyOrderAutoSign(orderId, autoSign);
      wallet.modifyOrderPrice(orderId, price: price, indexPrice: indexPrice);
      handleClose();
      return;
    }

    bool allowChaining = false;
    if (widget.screen == ReviewScreen.submitStart &&
        twoStep &&
        wallet.orderDetailsData.txChainingRequired) {
      allowChaining = await allowTxChaining(context);
      if (!allowChaining) {
        return;
      }
    }

    if (!await ref.read(walletProvider).isAuthenticated()) {
      return;
    }

    ref.read(walletProvider).setSubmitDecision(
          autosign: autoSign,
          twoStep: twoStep,
          accept: true,
          private: !public,
          ttlSeconds: ttl,
          allowTxChaining: allowChaining,
        );

    switch (widget.screen) {
      case ReviewScreen.submitStart:
      case ReviewScreen.submitSucceed:
      case ReviewScreen.sign:
        setState(() {
          state = ReviewState.disabled;
        });
        break;
      case ReviewScreen.quote:
        setState(() {
          state = ReviewState.disabled;
        });
        break;
      case ReviewScreen.edit:
        break;
    }
  }

  void handleClose() {
    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  Widget build(BuildContext context) {
    final wallet = ref.watch(walletProvider);
    final order = wallet.orderDetailsData;
    final sendAmount = order.sellBitcoin
        ? (order.bitcoinAmount + order.fee)
        : order.assetAmount;
    final liquidAssetId = ref.watch(liquidAssetIdStateProvider);
    final sendAssetId = order.sellBitcoin ? liquidAssetId : order.assetId;
    final recvAmount = order.sellBitcoin
        ? order.assetAmount
        : (order.bitcoinAmount - order.fee);
    final recvAssetId = order.sellBitcoin ? order.assetId : liquidAssetId;
    // FIXME: This might crash sometimes when dialog is closed (order.assetId become empty)
    final asset =
        ref.watch(assetsStateProvider.select((value) => value[order.assetId]));
    final priceInLiquid =
        ref.watch(assetUtilsProvider).isPricedInLiquid(asset: asset);
    final price = priceStr(order.priceAmount, priceInLiquid);
    final priceTicker = priceInLiquid ? kLiquidBitcoinTicker : asset?.ticker;
    final priceValue = '$price $priceTicker';
    final amountProvider = ref.watch(amountToStringProvider);
    final feeValue = amountProvider.amountToStringNamed(
        AmountToStringNamedParameters(
            amount: order.fee, ticker: kLiquidBitcoinTicker));
    final autoSignValue = order.autoSign ? 'On'.tr() : 'Off'.tr();
    final orderTypeValue = order.private ? 'Private'.tr() : 'Public'.tr();
    final ttlSeconds = order.expiresAt != null
        ? ((order.expiresAt! - order.createdAt) / 1000).round()
        : null;
    final ttlValue = getTtlDescription(ttlSeconds);
    final shareUrl = ref.watch(addressToShareByOrderIdProvider(order.orderId));
    final isSell = order.sellBitcoin == asset?.swapMarket;
    final dollarConversionPrice = priceInLiquid
        ? ref.watch(dollarConversionProvider(liquidAssetId, order.priceAmount))
        : '';
    final orderType = order.twoStep ? 'Offline'.tr() : 'Online'.tr();

    return DPopupWithClose(
      width: 580,
      height: 692,
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(40, 40, 40, 0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.screen == ReviewScreen.submitSucceed)
                        Padding(
                          padding: const EdgeInsets.only(right: 11),
                          child: SvgPicture.asset(
                            'assets/success2.svg',
                            width: 24,
                            height: 24,
                          ),
                        ),
                      Text(
                        getTitle(widget.screen, state, twoStep, isTracking),
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  if (widget.screen == ReviewScreen.edit && !isTracking)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: DOrderAmountEnter(
                        assetId: priceInLiquid ? liquidAssetId : asset?.assetId,
                        isPriceField: true,
                        caption: isSell ? 'Bid price'.tr() : 'Offer price'.tr(),
                        controller: controllerPrice,
                        autofocus: widget.screen == ReviewScreen.edit,
                        onEditingComplete: handleSubmit,
                        readonly: widget.screen == ReviewScreen.edit &&
                            twoStep &&
                            !isTracking,
                      ),
                    ),
                  if (widget.screen == ReviewScreen.edit && isTracking)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: DEnterTrackingPrice(
                        invertColors: !isSell,
                        onTrackingChanged: (double value) {
                          setState(() {
                            priceTrackerValue = value;
                          });
                        },
                        onTrackingToggle: null,
                        trackingToggled: isTracking,
                        trackingValue: priceTrackerValue,
                      ),
                    ),
                  const SizedBox(height: 4),
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: SideSwapColors.chathamsBlue,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 12),
                        DOrderReviewBalance(
                          amount: sendAmount,
                          assetId: sendAssetId,
                          hint: 'Deliver'.tr(),
                        ),
                        const SizedBox(height: 8),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 14),
                          child: DOrderReviewSeparator(),
                        ),
                        const SizedBox(height: 8),
                        DOrderReviewBalance(
                          amount: recvAmount,
                          assetId: recvAssetId,
                          hint: 'Receive'.tr(),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                  ...(widget.screen == ReviewScreen.submitStart ||
                          widget.screen == ReviewScreen.submitSucceed ||
                          widget.screen == ReviewScreen.quote ||
                          widget.screen == ReviewScreen.sign)
                      ? [
                          const SizedBox(height: 10),
                          DOrderReviewField(
                              name: 'Price per unit'.tr(),
                              value: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(priceValue),
                                  if (dollarConversionPrice.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(
                                        '≈ $dollarConversionPrice',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFF709EBA),
                                        ),
                                      ),
                                    ),
                                ],
                              )),
                          DOrderReviewField(
                              name: 'Fee'.tr(), value: Text(feeValue)),
                        ]
                      : [],
                  if (widget.screen == ReviewScreen.quote)
                    DOrderReviewField(
                        name: 'Order Type'.tr(), value: Text(orderType)),
                  Consumer(
                    builder: (context, ref, child) {
                      final isJadeWallet = ref.watch(isJadeWalletProvider);

                      if (widget.screen == ReviewScreen.edit) {
                        return DOrderReviewSignTypeControls(
                          twoStep: twoStep,
                          onTwoStepChanged: null,
                        );
                      }

                      // turn off online for jade wallet
                      if (isJadeWallet &&
                          widget.screen == ReviewScreen.submitStart) {
                        return const DOrderReviewSignTypeControls(
                          twoStep: true,
                          onTwoStepChanged: null,
                        );
                      }

                      if (widget.screen == ReviewScreen.submitStart) {
                        return DOrderReviewSignTypeControls(
                          twoStep: twoStep,
                          onTwoStepChanged: (bool value) {
                            setState(() {
                              twoStep = value;
                              if (twoStep) {
                                autoSign = true;
                              } else if (ttl == kInfTtl) {
                                ttl = kOneWeek;
                              }
                            });
                          },
                        );
                      }

                      return Container();
                    },
                  ),
                  if (widget.screen == ReviewScreen.submitStart ||
                      widget.screen == ReviewScreen.edit)
                    DOrderReviewAutoSignOrderControls(
                      autoSign: autoSign,
                      onAutoSignChanged: twoStep
                          ? null
                          : (bool value) {
                              setState(() {
                                autoSign = value;
                              });
                            },
                    ),
                  if (widget.screen == ReviewScreen.submitStart)
                    DOrderReviewCreateOrderControls(
                      public: public,
                      ttl: ttl,
                      twoStep: twoStep,
                      onPublicChanged: (bool value) {
                        setState(() {
                          public = value;
                        });
                      },
                      onTwoStepChanged: (bool value) {
                        setState(() {
                          public = value;
                        });
                      },
                      onTtlChanged: (int value) {
                        setState(() {
                          ttl = value;
                        });
                      },
                    ),
                  ...(widget.screen == ReviewScreen.submitSucceed)
                      ? [
                          DOrderReviewField(
                              name: 'Auto-sign'.tr(),
                              value: Text(autoSignValue)),
                          DOrderReviewField(
                              name: 'Order type'.tr(),
                              value: Text(orderTypeValue)),
                          DOrderReviewField(
                              name: 'TTL'.tr(), value: Text(ttlValue)),
                        ]
                      : [],
                  const Spacer(),
                ],
              ),
            ),
          ),
          if (widget.screen == ReviewScreen.sign)
            DOrderReviewTimer(
              stopped: state == ReviewState.disabled,
            ),
          if (widget.screen == ReviewScreen.quote &&
              state == ReviewState.disabled)
            Consumer(
              builder: (context, ref, child) {
                final isJadeWallet = ref.watch(isJadeWalletProvider);
                final timerOrderId =
                    ref.watch(jadeOrderIdTimerNotifierProvider);

                if (isJadeWallet) {
                  // run timer when BE approve signing by jade
                  final stopped =
                      !(wallet.orderDetailsData.orderId == timerOrderId);
                  return DOrderReviewTimer(
                    stopped: stopped,
                  );
                }

                return const DOrderReviewTimer(
                  stopped: false,
                );
              },
            ),
          if (widget.screen == ReviewScreen.submitStart ||
              widget.screen == ReviewScreen.quote ||
              widget.screen == ReviewScreen.sign ||
              widget.screen == ReviewScreen.edit)
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: DCustomFilledBigButton(
                width: 500,
                height: 44,
                onPressed: (state == ReviewState.idle) ? handleSubmit : null,
                autofocus: widget.screen != ReviewScreen.edit,
                child: Text(getButtonTitle(
                        widget.screen, state, order.twoStep, isTracking)
                    .toUpperCase()),
              ),
            ),
          if (widget.screen == ReviewScreen.submitSucceed && !order.private)
            Container(
              padding: const EdgeInsets.only(top: 40, bottom: 40),
              color: SideSwapColors.chathamsBlue,
              child: Center(
                child: DCustomTextBigButton(
                  width: 260,
                  height: 44,
                  onPressed: handleClose,
                  child: Text('OK'.tr()),
                ),
              ),
            ),
          if (widget.screen == ReviewScreen.submitSucceed && order.private)
            Container(
              padding: const EdgeInsets.only(top: 32, bottom: 32),
              color: SideSwapColors.chathamsBlue,
              child: Center(
                child: Column(
                  children: [
                    Text(
                      'Share the following link with your trade counterpart:'
                          .tr(),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 350,
                      child: Text(
                        shareUrl,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        style: const TextStyle(
                          color: SideSwapColors.brightTurquoise,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DCustomFilledBigButton(
                      width: 135,
                      height: 44,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/copy2.svg',
                            colorFilter: const ColorFilter.mode(
                                Colors.white, BlendMode.srcIn),
                          ),
                          const SizedBox(width: 15),
                          Text('Copy'.tr()),
                        ],
                      ),
                      onPressed: () {
                        copyToClipboard(context, shareUrl);
                      },
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      onClose: () {
        ref.read(walletProvider).setSubmitDecision(
              autosign: false,
              accept: false,
            );
      },
    );
  }
}

class DOrderReviewBalance extends ConsumerWidget {
  const DOrderReviewBalance({
    super.key,
    required this.assetId,
    required this.amount,
    required this.hint,
  });

  final String assetId;
  final int amount;
  final String hint;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asset =
        ref.watch(assetsStateProvider.select((value) => value[assetId]));
    final icon = ref.watch(assetImageProvider).getVerySmallImage(assetId);
    final assetPrecision =
        ref.watch(assetUtilsProvider).getPrecisionForAssetId(assetId: assetId);
    final amountProvider = ref.watch(amountToStringProvider);
    final amountSt = amountProvider.amountToString(
        AmountToStringParameters(amount: amount, precision: assetPrecision));
    final liquidAssetId = ref.watch(liquidAssetIdStateProvider);
    final dollarConversion = assetId == liquidAssetId
        ? ref.watch(dollarConversionFromStringProvider(assetId, amountSt))
        : '';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Center(
        child: Row(
          children: [
            const SizedBox(width: 12),
            icon,
            const SizedBox(width: 4),
            Text(
              hint,
              style: const TextStyle(
                color: SideSwapColors.hippieBlue,
              ),
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Text(amountSt),
                    const SizedBox(width: 4),
                    Text(asset?.ticker ?? ''),
                  ],
                ),
                const SizedBox(height: 4),
                if (dollarConversion.isNotEmpty)
                  Text(
                    '≈ $dollarConversion',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF709EBA),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}

class DOrderReviewSeparator extends StatelessWidget {
  const DOrderReviewSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: const Color(0x805294B9),
    );
  }
}

class DOrderReviewField extends StatelessWidget {
  const DOrderReviewField({
    super.key,
    required this.name,
    required this.value,
  });

  final String name;
  final Widget value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Row(
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    color: SideSwapColors.brightTurquoise,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                value,
              ],
            ),
          ),
          const DOrderReviewSeparator(),
        ],
      ),
    );
  }
}

// Not used currently
class _WaitSign extends StatefulWidget {
  @override
  State<_WaitSign> createState() => _WaitSignState();
}

class _WaitSignState extends State<_WaitSign> {
  late Timer timer;

  int remainingTime = signTotalTime;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        remainingTime -= 1;
        if (remainingTime < 0) {
          remainingTime = 0;
        }
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DPopupWithClose(
      width: 580,
      height: 605,
      child: Center(
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Text(
                    'Waiting for counterparty to sign'.tr(),
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 200,
              height: 200,
              child: CustomPaint(
                painter: ArcProgressPainter(
                  progress: remainingTime.toDouble() / signTotalTime.toDouble(),
                  backgroundColor: SideSwapColors.chathamsBlue,
                  progressColor: SideSwapColors.brightTurquoise,
                ),
                child: Center(
                  child: Text(
                    '${remainingTime}s',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: SideSwapColors.brightTurquoise,
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class ArcProgressPainter extends CustomPainter {
  const ArcProgressPainter({
    required this.progress,
    required this.backgroundColor,
    required this.progressColor,
  });

  final double progress;
  final Color backgroundColor;
  final Color progressColor;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTRB(0, 0, size.width, size.height);

    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    canvas.drawOval(rect, backgroundPaint);

    const startAngle = -pi / 2;
    final sweepAngle = -2 * pi * progress;
    const useCenter = false;
    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawArc(rect, startAngle, sweepAngle, useCenter, progressPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class DOrderReviewCreateOrderControls extends StatelessWidget {
  const DOrderReviewCreateOrderControls({
    super.key,
    required this.public,
    required this.twoStep,
    required this.ttl,
    required this.onPublicChanged,
    required this.onTwoStepChanged,
    required this.onTtlChanged,
  });

  final bool public;
  final bool twoStep;
  final int ttl;
  final ValueChanged<bool> onPublicChanged;
  final ValueChanged<bool> onTwoStepChanged;
  final ValueChanged<int> onTtlChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: SideSwapColors.chathamsBlue,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Order type'.tr()),
              SizedBox(
                width: 142,
                height: 32,
                child: DToggleButton(
                  offText: 'Private'.tr(),
                  onText: 'Public'.tr(),
                  value: public,
                  onChanged: onPublicChanged,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.fromLTRB(12, 15, 12, 15),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: SideSwapColors.chathamsBlue,
          ),
          child: Row(
            children: [
              Text('Time-to-live'.tr()),
              const Spacer(),
              DHoverButton(
                builder: (context, states) {
                  return Row(
                    children: [
                      Text(getTtlDescription(ttl)),
                      const SizedBox(width: 7),
                      SvgPicture.asset('assets/arrow_down.svg'),
                    ],
                  );
                },
                onPressed: () async {
                  final result = await showDialog<int>(
                    context: context,
                    builder: (context) {
                      return DTtlPopup(
                        selected: ttl,
                        offline: twoStep,
                      );
                    },
                  );
                  if (result != null) {
                    onTtlChanged(result);
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DOrderReviewSignTypeControls extends StatelessWidget {
  const DOrderReviewSignTypeControls({
    super.key,
    required this.twoStep,
    required this.onTwoStepChanged,
  });

  final bool twoStep;
  final ValueChanged<bool>? onTwoStepChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: SideSwapColors.chathamsBlue,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Sign type'.tr()),
              SizedBox(
                width: 142,
                height: 32,
                child: DToggleButton(
                  offText: 'Offline'.tr(),
                  onText: 'Online'.tr(),
                  value: !twoStep,
                  onChanged: onTwoStepChanged != null
                      ? (value) {
                          onTwoStepChanged!(!value);
                        }
                      : null,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DOrderReviewAutoSignOrderControls extends StatelessWidget {
  const DOrderReviewAutoSignOrderControls({
    super.key,
    required this.autoSign,
    required this.onAutoSignChanged,
  });

  final bool autoSign;
  final ValueChanged<bool>? onAutoSignChanged;

  @override
  Widget build(BuildContext context) {
    final autoSignHelp =
        'If someone confirms your order in the order book, SideSwap will automatically confirm the order'
            .tr();

    return Column(
      children: [
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: SideSwapColors.chathamsBlue,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text('Auto-sign'.tr()),
                    const SizedBox(height: 6),
                    Text(autoSignHelp,
                        style: const TextStyle(
                          fontSize: 13,
                          color: SideSwapColors.hippieBlue,
                        )),
                  ],
                ),
              ),
              SizedBox(
                width: 142,
                height: 32,
                child: DToggleButton(
                  offText: 'Off'.tr(),
                  onText: 'On'.tr(),
                  value: autoSign,
                  onChanged: onAutoSignChanged,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DOrderReviewTimer extends StatefulWidget {
  const DOrderReviewTimer({
    super.key,
    required this.stopped,
  });

  final bool stopped;

  @override
  State<DOrderReviewTimer> createState() => DOrderReviewTimerState();
}

class DOrderReviewTimerState extends State<DOrderReviewTimer> {
  late Timer timer;

  int remainingTime = signTotalTime;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!widget.stopped) {
        setState(() {
          remainingTime -= 1;
          if (remainingTime < 0) {
            remainingTime = 0;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: LinearProgressIndicator(
        value: remainingTime / signTotalTime,
        backgroundColor: SideSwapColors.chathamsBlue,
        color: SideSwapColors.brightTurquoise,
      ),
    );
  }
}
