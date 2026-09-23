import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/middle_elipsis_text.dart';
import 'package:sideswap/common/widgets/side_swap_popup.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/asset_image_providers.dart';
import 'package:sideswap/providers/notification_removal_reason.dart';
import 'package:sideswap/providers/notifications_provider.dart';
import 'package:sideswap/providers/signer_acceptance_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

/// Puts the user's answer to a Liquid Connect request on the wire.
///
/// Synchronous, and it has to stay that way: every call site records the
/// resolution in the statement that follows, and an `await` opened between the
/// two would let the widget unmount in the gap — leaving an acceptance sent to
/// the origin and never recorded. ADR-0006 decision 4.
void _sendSignerResponse(
  WidgetRef ref, {
  required String reqId,
  required bool accept,
}) {
  final msg = To();
  msg.signerResponse = To_SignerResponse(reqId: reqId, accept: accept);
  ref.read(walletProvider).sendMsg(msg);
}

/// The handler that asks for a Liquid Connect request to be accepted, or `null`
/// while an attempt for that request is outstanding.
///
/// An adapter over [SignerAcceptance.accept]: the single-flight guard, the
/// authentication gate, the pending re-check and the send-and-record pair moved
/// there, so an attempt belongs to the request it answers rather than to the
/// dialog the press came from. Mobile has never had the defect that motivated
/// the move — it presents one request at a time, bound to an immutable
/// `(notificationId, reqId)` — so nothing here changes but where the sequence
/// lives. Two mechanisms would mean the next person to change the acceptance
/// path has to find and change both. ADR-0009 decision 2.
///
/// Still named `_use…` and still called from `build`, because it watches: the
/// busy half of the single-flight rule is read back from the same set the
/// guard is kept in, by *this* request's id.
///
/// No pop, and nothing to await: the window is taken away by [SwaptionDialog]
/// removing its own route once the acceptance takes the request out of the
/// pending set. ADR-0006 decision 3.
VoidCallback? _useAcceptRequest(
  WidgetRef ref, {
  required int notificationId,
  required String reqId,
}) {
  final accepting = ref.watch(
    signerAcceptanceProvider.select((inFlight) => inFlight.contains(reqId)),
  );

  return accepting
      ? null
      : () {
          unawaited(
            ref
                .read(signerAcceptanceProvider.notifier)
                .accept(notificationId: notificationId, reqId: reqId),
          );
        };
}

/// The window one Liquid Connect request is presented in.
///
/// Bound to the `(notificationId, reqId)` it was opened for and never to the
/// global selection, which is repointed at every arriving request: a second
/// request would otherwise silently change what an open dialog is showing.
/// The identity is fixed; the entry behind it stays live, so the countdown
/// keeps running. ADR-0006 decisions 3 and 4.
class SwaptionDialog extends HookConsumerWidget {
  const SwaptionDialog({
    required this.notificationId,
    required this.reqId,
    super.key,
  });

  final int notificationId;
  final String reqId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingRequest = pendingRequestProvider(notificationId, reqId);
    final optionPending = ref.watch(pendingRequest);

    // The route this dialog was pushed onto, captured while it is certainly
    // still there. Teardown removes *this* route rather than popping the
    // navigator's top one, because wallet authentication is itself a route on
    // the same root navigator: a pop raised while a PIN prompt is up would take
    // the prompt and leave this dialog behind. ADR-0006 decision 3, and the one
    // place programmatic teardown lives.
    final route = ModalRoute.of(context);

    void tearDownWhenResolved(Option<NotificationData> pending) {
      if (pending.isSome()) {
        return;
      }

      // Deferred because this runs inside the build phase, and the navigator
      // may not be mutated from there.
      Future.microtask(() {
        if (!context.mounted) {
          return;
        }

        // Already gone by another path — the close affordance, or an
        // acceptance that popped before the entry left the pending set.
        if (route == null || !route.isActive) {
          return;
        }

        Navigator.of(context, rootNavigator: true).removeRoute(route);
      });
    }

    // Listened to rather than derived from the `watch` above, because the two
    // reach this widget by different means: a rebuild is what carries a `watch`,
    // and this dialog stops being rebuilt as soon as an opaque route covers it
    // — which is precisely when a request resolves underneath a wallet
    // authentication prompt. A listener is called whatever is on top.
    ref.listen(pendingRequest, (_, pending) {
      tearDownWhenResolved(pending);
    });

    // The listener above only speaks to changes, so the case where the request
    // is already gone by the time the dialog is built is handled here.
    useEffect(() {
      tearDownWhenResolved(optionPending);
      return null;
    }, const []);

    // The narrowed entry is handed to the child rather than looked up again:
    // a child is built only while the request is pending, so it never has to
    // answer for an absent one.
    return switch (optionPending.toNullable()?.type) {
      final NotificationTypeConnect connect => SwaptionConnectDialog(
        notificationId: notificationId,
        notification: connect,
      ),
      final NotificationTypeSignRequest signRequest =>
        SwaptionSignRequestDialog(
          notificationId: notificationId,
          notification: signRequest,
        ),
      // The request is no longer pending and the route is on its way out.
      null => const SizedBox.shrink(),
    };
  }
}

class SwaptionConnectDialog extends HookConsumerWidget {
  const SwaptionConnectDialog({
    required this.notificationId,
    required this.notification,
    super.key,
  });

  final int notificationId;
  final NotificationTypeConnect notification;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // The rejection goes on the wire and the resolution is recorded in one
    // synchronous block, in that order, and only then does the window go. Every
    // path records its reason before its window closes — that ordering is what
    // lets the listener treat any remaining pending request behind a closed
    // window as a rejection. ADR-0006 decision 4.
    //
    // Reachable only while this dialog is on top — it is the close affordance
    // and the device back button — so it crossed no await and may close its own
    // window directly. ADR-0006 decision 3.
    final onClose = useCallback(() {
      _sendSignerResponse(ref, reqId: notification.reqId, accept: false);

      ref
          .read(notificationsProvider.notifier)
          .removeNotification(
            notificationId,
            reason: NotificationRemovalReason.rejectedByUser,
          );

      Navigator.of(context, rootNavigator: true).pop();
    }, [notification, notificationId]);

    final onAllow = _useAcceptRequest(
      ref,
      notificationId: notificationId,
      reqId: notification.reqId,
    );

    final optionTtl = ref.watch(
      signRequestNotificationTtlProvider(notificationId),
    );

    return SideSwapPopup(
      enableInsideHorizontalPadding: false,
      onClose: onClose,
      // The device back button reaches this dialog here rather than through the
      // tree, and takes the same path the close affordance does: `canPop: false`
      // keeps the framework from popping the route out from under it first, so
      // the resolution is recorded before the window goes.
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          onClose();
        }
      },
      child: Center(
        child: Column(
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Text(
                      'Liquid Connect'.tr(),
                      style: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Do you want to connect to this website?'.tr(),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 18),
                    SwaptionConnectBox(notification: notification),
                    const SizedBox(height: 16),
                    Text(
                      "This site can see balances, assets, and history for the accounts you share. It can't spend or sign."
                          .tr(),
                      style: Theme.of(context).textTheme.titleSmall,
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(),
                    RichText(
                      text: TextSpan(
                        text: 'Privacy note: '.tr(),
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: SideSwapColors.halfBaked,
                            ),
                        children: [
                          TextSpan(
                            text: 'Sharing watch-only access (descriptor/xpub and Liquid master blinding key) reveals your full past and future activity for the selected accounts to this site. Only connect to sites you trust.'
                                .tr(),
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(color: SideSwapColors.halfBaked),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    optionTtl.match(() => const SizedBox(), (ttl) {
                      return Text(
                        'Time-to-live: {} seconds'.plural(ttl, args: ['$ttl']),
                        style: Theme.of(context).textTheme.titleSmall
                            ?.copyWith(fontSize: 13),
                      );
                    }),
                    const SizedBox(height: 32),
                    CustomBigButton(
                      width: double.infinity,
                      height: 54,
                      text: 'Allow'.tr(),
                      backgroundColor: SideSwapColors.brightTurquoise,
                      // Null — and so disabled — while an authentication is
                      // outstanding, so the control shows the attempt is in
                      // progress rather than silently swallowing further
                      // presses. ADR-0006 decision 4.
                      onPressed: onAllow,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(color: SideSwapColors.chathamsBlueDark),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/web_icon_transparent.svg',
                        width: 20,
                        height: 20,
                      ),
                      const SizedBox(width: 6),
                      Text(notification.origin),
                    ],
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

class SwaptionConnectBox extends ConsumerWidget {
  const SwaptionConnectBox({required this.notification, super.key});

  final NotificationTypeConnect notification;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        color: SideSwapColors.chathamsBlueDark,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Site:'.tr(),
                  style: Theme.of(context).textTheme.titleSmall
                      ?.copyWith(color: SideSwapColors.brightTurquoise),
                ),
                Text(
                  notification.origin,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Scope:'.tr(),
                  style: Theme.of(context).textTheme.titleSmall
                      ?.copyWith(color: SideSwapColors.brightTurquoise),
                ),
                Text(
                  'read-only (watch-only)'.tr(),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SwaptionSignRequestDialog extends HookConsumerWidget {
  const SwaptionSignRequestDialog({
    required this.notificationId,
    required this.notification,
    super.key,
  });

  final int notificationId;
  final NotificationTypeSignRequest notification;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Send, record, then close — see the connect twin above for why that order
    // is a standing condition and not an accident.
    final onClose = useCallback(() {
      _sendSignerResponse(ref, reqId: notification.reqId, accept: false);

      ref
          .read(notificationsProvider.notifier)
          .removeNotification(
            notificationId,
            reason: NotificationRemovalReason.rejectedByUser,
          );

      Navigator.of(context, rootNavigator: true).pop();
    }, [notification, notificationId]);

    final onAllow = _useAcceptRequest(
      ref,
      notificationId: notificationId,
      reqId: notification.reqId,
    );

    final optionTtl = ref.watch(
      signRequestNotificationTtlProvider(notificationId),
    );

    return SideSwapPopup(
      enableInsideHorizontalPadding: false,
      onClose: onClose,
      // `canPop: false` for the device back button — see the connect twin above.
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          onClose();
        }
      },
      child: Center(
        child: Column(
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Text(
                      'Liquid Connect: Signature Required'.tr(),
                      style: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      notification.origin,
                      style: Theme.of(context).textTheme.titleSmall
                          ?.copyWith(fontSize: 13),
                    ),
                    Column(
                      children: [
                        const SizedBox(height: 10),
                        NotificationSignBalances(
                          balances: notification.sign.balances,
                        ),
                        const SizedBox(height: 8),
                        NotificationsSignRecipients(
                          recipients: notification.sign.recipients,
                        ),
                        const SizedBox(height: 8),
                        NotificationsNetworkFee(
                          networkFee: notification.sign.networkFee.toInt(),
                        ),
                        const SizedBox(height: 8),
                        optionTtl.match(() => const SizedBox(), (ttl) {
                          return Text(
                            'Time-to-live: {} seconds'.plural(
                              ttl,
                              args: ['$ttl'],
                            ),
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(fontSize: 13),
                          );
                        }),
                      ],
                    ),
                    const Spacer(),
                    CustomBigButton(
                      width: double.infinity,
                      height: 54,
                      text: 'Broadcast'.tr(),
                      backgroundColor: SideSwapColors.brightTurquoise,
                      // Null — and so disabled — while an authentication is
                      // outstanding. ADR-0006 decision 4.
                      onPressed: onAllow,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(color: SideSwapColors.chathamsBlueDark),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/web_icon_transparent.svg',
                        width: 20,
                        height: 20,
                      ),
                      const SizedBox(width: 6),
                      Text(notification.origin),
                    ],
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

class NotificationSignBalances extends HookConsumerWidget {
  const NotificationSignBalances({super.key, required this.balances});

  final List<Balance> balances;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Balances:'.tr(),
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w500,
            color: SideSwapColors.brightTurquoise,
          ),
        ),
        const SizedBox(height: 8),
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: SideSwapColors.chathamsBlueDark,
          ),

          child: SizedBox(
            height: 80,
            child: Scrollbar(
              thumbVisibility: true,
              controller: scrollController,
              child: CustomScrollView(
                controller: scrollController,
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        ...balances.mapWithIndex((balance, index) {
                          final assetIcon = ref
                              .watch(assetImageRepositoryProvider)
                              .getCustomImage(
                                balance.assetId,
                                width: 24,
                                height: 24,
                              );
                          final ticker = ref
                              .read(assetUtilsProvider)
                              .tickerForAssetId(balance.assetId);
                          final assetUtils = ref.watch(assetUtilsProvider);
                          final amountToString = ref.watch(
                            amountToStringProvider,
                          );
                          final precision = assetUtils.getPrecisionForAssetId(
                            assetId: balance.assetId,
                          );
                          final amountStr = amountToString.amountToStringNamed(
                            AmountToStringNamedParameters(
                              amount: balance.amount.toInt(),
                              forceSign: false,
                              precision: precision,
                              ticker: '',
                              useNumberFormatter: true,
                            ),
                          );

                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      amountStr,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                    Row(
                                      children: [
                                        assetIcon,
                                        const SizedBox(width: 8),
                                        Text(
                                          ticker,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              if (index < balances.length - 1)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Divider(
                                    color: SideSwapColors.jellyBean,
                                  ),
                                ),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class NotificationsSignRecipients extends HookConsumerWidget {
  const NotificationsSignRecipients({super.key, required this.recipients});

  final List<AddressAmount> recipients;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recipients:'.tr(),
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w500,
            color: SideSwapColors.brightTurquoise,
          ),
        ),
        const SizedBox(height: 8),
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: SideSwapColors.chathamsBlueDark,
          ),
          child: SizedBox(
            height: 160,
            child: Scrollbar(
              thumbVisibility: true,
              controller: scrollController,
              child: CustomScrollView(
                controller: scrollController,
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        ...recipients.mapWithIndex((recipient, index) {
                          final assetIcon = ref
                              .watch(assetImageRepositoryProvider)
                              .getCustomImage(
                                recipient.assetId,
                                width: 24,
                                height: 24,
                              );
                          final ticker = ref
                              .read(assetUtilsProvider)
                              .tickerForAssetId(recipient.assetId);
                          final assetUtils = ref.watch(assetUtilsProvider);
                          final amountToString = ref.watch(
                            amountToStringProvider,
                          );
                          final precision = assetUtils.getPrecisionForAssetId(
                            assetId: recipient.assetId,
                          );
                          final amountStr = amountToString.amountToStringNamed(
                            AmountToStringNamedParameters(
                              amount: recipient.amount.toInt(),
                              forceSign: false,
                              precision: precision,
                              ticker: ticker,
                              useNumberFormatter: true,
                            ),
                          );

                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: SizedBox(
                                        width: 170,
                                        child: MiddleEllipsisText(
                                          text: recipient.address,
                                          textAlign: TextAlign.left,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Row(
                                      children: [
                                        Text(
                                          amountStr,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall,
                                        ),
                                        const SizedBox(width: 8),
                                        assetIcon,
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              if (index < recipients.length - 1)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Divider(
                                    color: SideSwapColors.jellyBean,
                                  ),
                                ),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class NotificationsNetworkFee extends ConsumerWidget {
  const NotificationsNetworkFee({super.key, required this.networkFee});

  final int networkFee;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final amountToString = ref.watch(amountToStringProvider);
    final liquidAssetId = ref.watch(liquidAssetIdStateProvider);
    final assetUtils = ref.watch(assetUtilsProvider);

    final assetIcon = ref
        .watch(assetImageRepositoryProvider)
        .getCustomImage(liquidAssetId, width: 24, height: 24);
    final precision = assetUtils.getPrecisionForAssetId(assetId: liquidAssetId);
    final ticker = ref.read(assetUtilsProvider).tickerForAssetId(liquidAssetId);
    final amountStr = amountToString.amountToStringNamed(
      AmountToStringNamedParameters(
        amount: networkFee,
        forceSign: false,
        precision: precision,
        ticker: '',
        useNumberFormatter: true,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Network fee:'.tr(),
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w500,
            color: SideSwapColors.brightTurquoise,
          ),
        ),
        const SizedBox(height: 8),
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: SideSwapColors.chathamsBlueDark,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(amountStr, style: Theme.of(context).textTheme.titleSmall),
                Row(
                  children: [
                    assetIcon,
                    const SizedBox(width: 8),
                    Text(ticker, style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
