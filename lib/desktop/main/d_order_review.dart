import 'dart:async';
import 'dart:math';
import 'package:decimal/decimal.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
import 'package:sideswap/listeners/order_review_listeners.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/providers/jade_provider.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/order_details_provider.dart';
import 'package:sideswap/providers/request_order_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_account_providers.dart';
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

class DOrderReview extends HookConsumerWidget {
  const DOrderReview({super.key, required this.screen});

  final ReviewScreen screen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = ref.watch(orderDetailsDataNotifierProvider);
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
    final defaultCurrencyPrice = priceInLiquid
        ? ref.watch(amountUsdInDefaultCurrencyProvider(
            liquidAssetId, order.priceAmount))
        : Decimal.zero;
    final defaultCurrencyTicker = ref.watch(defaultCurrencyTickerProvider);
    final orderType = order.twoStep ? 'Offline'.tr() : 'Online'.tr();

    final reviewState = useState(ReviewState.idle);
    final autoSign = useState(true);
    final autoSignPrev = useState(true);
    final isTracking = useState(order.isTracking);
    final controllerPrice = useTextEditingController();
    final priceTrackerValue = useState(.0);

    useEffect(() {
      if (screen == ReviewScreen.edit) {
        Future.microtask(() => ref
            .read(orderReviewTwoStepProvider.notifier)
            .setTwoStep(order.twoStep));
        return;
      }

      final twoStep = !order.isTracking;
      Future.microtask(() =>
          ref.read(orderReviewTwoStepProvider.notifier).setTwoStep(twoStep));

      return;
    }, const []);

    final handleCloseCallback = useCallback(() {
      Navigator.of(context, rootNavigator: true).pop();
    });

    final handleSubmitCallback = useCallback(() async {
      final twoStep = ref.read(orderReviewTwoStepProvider);

      // old modify price for offline orders
      if (screen == ReviewScreen.edit && twoStep && !isTracking.value) {
        ref.read(walletProvider).cancelOrder(order.orderId);
        handleCloseCallback();
        return;
      }

      if (screen == ReviewScreen.edit) {
        if (autoSign.value &&
            !autoSignPrev.value &&
            !await ref.read(walletProvider).isAuthenticated()) {
          return;
        }

        final orderId = order.orderId;
        final price = isTracking.value
            ? null
            : (double.tryParse(controllerPrice.text) ?? 0.0);
        final indexPrice = isTracking.value
            ? trackerValueToIndexPrice(priceTrackerValue.value)
            : null;
        ref.read(walletProvider).modifyOrderAutoSign(orderId, autoSign.value);
        ref
            .read(walletProvider)
            .modifyOrderPrice(orderId, price: price, indexPrice: indexPrice);
        handleCloseCallback();
        return;
      }

      bool allowChaining = false;
      if (screen == ReviewScreen.submitStart &&
          twoStep &&
          order.txChainingRequired) {
        allowChaining = await allowTxChaining(context, ref);
        if (!allowChaining) {
          return;
        }
      }

      if (!await ref.read(walletProvider).isAuthenticated()) {
        return;
      }

      final public = ref.read(orderReviewPublicProvider);
      final ttl = ref.read(orderReviewTtlProvider);

      ref.read(walletProvider).setSubmitDecision(
            autosign: autoSign.value,
            twoStep: twoStep,
            accept: true,
            private: !public,
            ttlSeconds: ttl,
            allowTxChaining: allowChaining,
          );

      (switch (screen) {
        ReviewScreen.submitStart ||
        ReviewScreen.submitSucceed ||
        ReviewScreen.sign ||
        ReviewScreen.quote =>
          reviewState.value = ReviewState.disabled,
        _ => () {}(),
      });
    }, []);

    return DPopupWithClose(
      width: 580,
      height: 733,
      child: Column(
        children: [
          const OrderReviewTtlChangedFlagListener(),
          const OrderReviewTwoStepListener(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(40, 40, 40, 0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (screen == ReviewScreen.submitSucceed)
                        Padding(
                          padding: const EdgeInsets.only(right: 11),
                          child: SvgPicture.asset(
                            'assets/success2.svg',
                            width: 24,
                            height: 24,
                          ),
                        ),
                      Consumer(
                        builder: (context, ref, _) {
                          final twoStep = ref.watch(orderReviewTwoStepProvider);

                          return Text(
                            getTitle(screen, reviewState.value, twoStep,
                                isTracking.value),
                            style: Theme.of(context).textTheme.displaySmall,
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  if (screen == ReviewScreen.edit && !isTracking.value)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: Consumer(
                        builder: (context, ref, _) {
                          final twoStep = ref.watch(orderReviewTwoStepProvider);
                          final liquidAccountAsset =
                              ref.watch(makeOrderLiquidAccountAssetProvider);
                          final allAccountAssets =
                              ref.watch(allAccountAssetsProvider);
                          final accountAsset = allAccountAssets
                              .where((e) => e.assetId == asset?.assetId)
                              .firstOrNull;

                          return DOrderAmountEnter(
                            accountAsset: priceInLiquid
                                ? liquidAccountAsset
                                : accountAsset,
                            isPriceField: true,
                            caption:
                                isSell ? 'Bid price'.tr() : 'Offer price'.tr(),
                            controller: controllerPrice,
                            autofocus: screen == ReviewScreen.edit,
                            onEditingComplete: handleSubmitCallback,
                            readonly: screen == ReviewScreen.edit &&
                                twoStep &&
                                !isTracking.value,
                          );
                        },
                      ),
                    ),
                  if (screen == ReviewScreen.edit && isTracking.value)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: DEnterTrackingPrice(
                        invertColors: !isSell,
                        onTrackingChanged: (double value) {
                          priceTrackerValue.value = value;
                        },
                        onTrackingToggle: null,
                        trackingToggled: isTracking.value,
                        trackingValue: priceTrackerValue.value,
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
                  ...(screen == ReviewScreen.submitStart ||
                          screen == ReviewScreen.submitSucceed ||
                          screen == ReviewScreen.quote ||
                          screen == ReviewScreen.sign)
                      ? [
                          const SizedBox(height: 10),
                          DOrderReviewField(
                              name: 'Price per unit'.tr(),
                              value: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(priceValue),
                                  if (defaultCurrencyPrice != Decimal.zero)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(
                                        '≈ $defaultCurrencyPrice $defaultCurrencyTicker',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color:
                                              SideSwapColors.airSuperiorityBlue,
                                        ),
                                      ),
                                    ),
                                ],
                              )),
                          DOrderReviewField(
                              name: 'Fee'.tr(), value: Text(feeValue)),
                        ]
                      : [],
                  if (screen == ReviewScreen.quote)
                    DOrderReviewField(
                        name: 'Order type'.tr(), value: Text(orderType)),
                  Consumer(
                    builder: (context, ref, child) {
                      final isJadeWallet = ref.watch(isJadeWalletProvider);

                      if (screen == ReviewScreen.edit) {
                        return const DOrderReviewSignTypeControls(
                          onTwoStepChanged: null,
                        );
                      }

                      // turn off online for jade wallet
                      if (isJadeWallet && screen == ReviewScreen.submitStart) {
                        return const DOrderReviewSignTypeControls(
                          onTwoStepChanged: null,
                        );
                      }

                      if (screen == ReviewScreen.submitStart) {
                        return DOrderReviewSignTypeControls(
                          onTwoStepChanged: (bool value) {
                            ref
                                .read(orderReviewTwoStepProvider.notifier)
                                .setTwoStep(value);

                            if (value) {
                              autoSign.value = true;
                            }
                          },
                        );
                      }

                      return const SizedBox();
                    },
                  ),
                  if (screen == ReviewScreen.submitStart ||
                      screen == ReviewScreen.edit)
                    Consumer(
                      builder: (context, ref, _) {
                        final twoStep = ref.watch(orderReviewTwoStepProvider);

                        return DOrderReviewAutoSignOrderControls(
                          autoSign: autoSign.value,
                          onAutoSignChanged: twoStep
                              ? null
                              : (bool value) {
                                  autoSign.value = value;
                                },
                        );
                      },
                    ),
                  if (screen == ReviewScreen.submitStart)
                    Consumer(builder: (context, ref, _) {
                      return DOrderReviewCreateOrderControls(
                        onPublicChanged: (bool value) {
                          ref
                              .read(orderReviewPublicProvider.notifier)
                              .setPublic(value);
                        },
                        onTwoStepChanged: (bool value) {
                          ref
                              .read(orderReviewPublicProvider.notifier)
                              .setPublic(value);
                        },
                        onTtlChanged: (int value) {
                          ref
                              .read(orderReviewTtlProvider.notifier)
                              .setTtl(value);
                        },
                      );
                    }),
                  ...(screen == ReviewScreen.submitSucceed)
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
          if (screen == ReviewScreen.sign)
            DOrderReviewTimer(
              stopped: reviewState.value == ReviewState.disabled,
            ),
          if (screen == ReviewScreen.quote &&
              reviewState.value == ReviewState.disabled)
            Consumer(
              builder: (context, ref, child) {
                final isJadeWallet = ref.watch(isJadeWalletProvider);
                final timerOrderId =
                    ref.watch(jadeOrderIdTimerNotifierProvider);

                if (isJadeWallet) {
                  // run timer when BE approve signing by jade
                  final stopped = !(order.orderId == timerOrderId);
                  return DOrderReviewTimer(
                    stopped: stopped,
                  );
                }

                return const DOrderReviewTimer(
                  stopped: false,
                );
              },
            ),
          if (screen == ReviewScreen.submitStart ||
              screen == ReviewScreen.quote ||
              screen == ReviewScreen.sign ||
              screen == ReviewScreen.edit)
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: DCustomFilledBigButton(
                width: 500,
                height: 44,
                onPressed: (reviewState.value == ReviewState.idle)
                    ? handleSubmitCallback
                    : null,
                autofocus: screen != ReviewScreen.edit,
                child: Text(getButtonTitle(screen, reviewState.value,
                        order.twoStep, isTracking.value)
                    .toUpperCase()),
              ),
            ),
          if (screen == ReviewScreen.submitSucceed && !order.private)
            Container(
              padding: const EdgeInsets.only(top: 40, bottom: 40),
              color: SideSwapColors.chathamsBlue,
              child: Center(
                child: DCustomTextBigButton(
                  width: 260,
                  height: 44,
                  onPressed: handleCloseCallback,
                  child: Text('OK'.tr()),
                ),
              ),
            ),
          if (screen == ReviewScreen.submitSucceed && order.private)
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
        Navigator.of(context).pop();
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
    final defaultCurrencyConversion = assetId == liquidAssetId
        ? ref.watch(
            defaultCurrencyConversionFromStringProvider(assetId, amountSt))
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
                if (defaultCurrencyConversion.isNotEmpty)
                  Text(
                    '≈ $defaultCurrencyConversion',
                    style: const TextStyle(
                      fontSize: 13,
                      color: SideSwapColors.airSuperiorityBlue,
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
    required this.onPublicChanged,
    required this.onTwoStepChanged,
    required this.onTtlChanged,
  });

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
                child: Consumer(
                  builder: (context, ref, _) {
                    final public = ref.watch(orderReviewPublicProvider);

                    return DToggleButton(
                      offText: 'Private'.tr(),
                      onText: 'Public'.tr(),
                      value: public,
                      onChanged: onPublicChanged,
                    );
                  },
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
                      Consumer(
                        builder: (context, ref, _) {
                          final ttl = ref.watch(orderReviewTtlProvider);

                          return Text(getTtlDescription(ttl));
                        },
                      ),
                      const SizedBox(width: 7),
                      SvgPicture.asset('assets/arrow_down.svg'),
                    ],
                  );
                },
                onPressed: () async {
                  final result = await showDialog<int>(
                    context: context,
                    builder: (context) {
                      return Consumer(
                        builder: (context, ref, _) {
                          final ttl = ref.watch(orderReviewTtlProvider);
                          return DTtlPopup(selected: ttl);
                        },
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
    required this.onTwoStepChanged,
  });

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
                child: Consumer(
                  builder: (context, ref, _) {
                    final twoStep = ref.watch(orderReviewTwoStepProvider);

                    return DToggleButton(
                      offText: 'Offline'.tr(),
                      onText: 'Online'.tr(),
                      value: !twoStep,
                      onChanged: onTwoStepChanged != null
                          ? (value) {
                              onTwoStepChanged!(!value);
                            }
                          : null,
                    );
                  },
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
