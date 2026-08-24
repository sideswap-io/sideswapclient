import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/middle_elipsis_text.dart';
import 'package:sideswap/desktop/common/button/d_custom_filled_big_button.dart';
import 'package:sideswap/desktop/common/button/d_custom_text_big_button.dart';
import 'package:sideswap/desktop/common/button/d_toolbar_button.dart';
import 'package:sideswap/desktop/widgets/d_notifications_style.dart';
import 'package:sideswap/desktop/widgets/d_popup_with_close.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/asset_image_providers.dart';
import 'package:sideswap/providers/jade_provider.dart';
import 'package:sideswap/providers/notification_removal_reason.dart';
import 'package:sideswap/providers/notifications_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/providers/warmup_app_provider.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class DNotificationToolbarButton extends HookConsumerWidget {
  const DNotificationToolbarButton({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationsProvider);
    final activeNotifications = ref.watch(activeNotificationsProvider);
    final optionShowNotificationMenu = ref.watch(showNotificationMenuProvider);

    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 150),
      reverseDuration: const Duration(milliseconds: 75),
      initialValue: 0,
    );

    final Animation<double> heightFactor = useMemoized(() {
      return animationController.drive(CurveTween(curve: Curves.fastOutSlowIn));
    }, [animationController]);

    final expanded = useState(false);
    final entry = useState<OverlayEntry?>(null);
    final overlay = useMemoized(() => Overlay.of(context));
    final buttonKey = useMemoized(() => GlobalKey());
    final size = MediaQuery.of(context).size;

    final showOverlayCallback = useCallback((double left, double top) {
      final navigatorKey = ref.read(navigatorKeyProvider);
      final navigatorRenderBox =
          navigatorKey.currentContext!.findRenderObject() as RenderBox;
      final size = navigatorRenderBox.size;

      final buttonRenderBox =
          buttonKey.currentContext!.findRenderObject() as RenderBox;

      final offset = navigatorRenderBox.localToGlobal(
        Offset(size.width - left, buttonRenderBox.size.height + top),
      );

      entry.value = OverlayEntry(
        builder: (context) {
          return NotificationMenu(
            offset: offset,
            animationController: animationController,
            heightFactor: heightFactor,
            onTap: () {
              expanded.value = !expanded.value;
            },
          );
        },
      );
      overlay.insert(entry.value!);
    }, [context, overlay]);

    useEffect(() {
      // cleanup overlay ondispose widget
      return () {
        entry.value?.remove();
      };
    }, const []);

    useEffect(() {
      if (expanded.value && entry.value == null) {
        Future.microtask(() => showOverlayCallback.call(374, 4));
        return;
      }

      return;
    }, [expanded.value]);

    useEffect(() {
      if (expanded.value) {
        animationController.forward();
        return;
      }

      animationController.reverse();
      return;
    }, [expanded.value]);

    useEffect(() {
      animationController.addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.dismissed) {
          entry.value?.remove();
          entry.value = null;
          return;
        }
      });

      return;
    }, [animationController]);

    useEffect(() {
      if (entry.value != null) {
        entry.value?.remove();
        Future.microtask(() => showOverlayCallback.call(374, 4));
      }
      return;
    }, [size]);

    useEffect(() {
      if (!activeNotifications && expanded.value) {
        expanded.value = false;
      }

      if (activeNotifications && !expanded.value) {
        // Raising the window is not done here: a minimized window produces no
        // frames, so this effect never runs in the case that matters. It lives
        // at the request delivery boundary instead — see ADR-0004 and
        // DesktopWindowService.
        Future.microtask(() => expanded.value = true);
      }

      return;
    }, [activeNotifications]);

    useEffect(() {
      optionShowNotificationMenu.match(() {}, (notificationId) {
        expanded.value = true;
        Future.microtask(() => ref.invalidate(showNotificationMenuProvider));
      });
      return;
    }, [optionShowNotificationMenu]);

    return DTopToolbarButton(
      key: buttonKey,
      name: '',
      icon: SizedBox(
        width: 18,
        height: 18,
        child: Stack(
          children: [
            Icon(
              notifications.isNotEmpty
                  ? Icons.notifications
                  : Icons.notifications_none,
              size: 18,
              color: notifications.isNotEmpty
                  ? SideSwapColors.brightTurquoise
                  : Colors.white,
            ),
            activeNotifications
                ? Positioned(
                    top: 2,
                    left: 10,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: SideSwapColors.bitterSweet,
                        border: Border.all(
                          color: SideSwapColors.maastrichtBlue,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
      onPressed: () {
        expanded.value = !expanded.value;
      },
    );
  }
}

class NotificationMenu extends HookConsumerWidget {
  const NotificationMenu({
    super.key,
    this.offset = Offset.zero,
    this.onTap,
    required this.animationController,
    required this.heightFactor,
    this.style,
  });

  final Offset offset;
  final AnimationController animationController;
  final Animation<double> heightFactor;
  final void Function()? onTap;
  final NotificationMenuStyle? style;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationsProvider);
    final firstChildKey = useMemoized(() => GlobalKey());

    // default size is the size of the empty notification menu
    final size = useState(Size(370, 163));

    final resizeCallback = useCallback(() {
      if (firstChildKey.currentContext != null) {
        final firstChildRenderBox =
            firstChildKey.currentContext!.findRenderObject() as RenderBox;
        size.value = Size(370, firstChildRenderBox.size.height + 58);
      } else {
        size.value = Size(370, 163);
      }
    }, [firstChildKey.currentContext, notifications]);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      resizeCallback();
    });

    useEffect(() {
      resizeCallback();
      return;
    }, [firstChildKey.currentContext, notifications.length]);

    final notificationMenuStyle =
        style ?? Theme.of(context).extension<NotificationMenuStyle>()!;
    final defaultStyle = NotificationMenuStyle(
      decoration: BoxDecoration(
        color: SideSwapColors.maastrichtBlue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      padding: const EdgeInsets.all(10.0),
    );

    return Stack(
      children: [
        Positioned(child: GestureDetector(onTap: onTap)),
        Positioned(
          top: offset.dy,
          left: offset.dx,
          child: SizedBox(
            width: size.value.width,
            height: size.value.height,
            child: AnimatedBuilder(
              animation: animationController.view,
              builder: (context, child) {
                return ClipRect(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    heightFactor: heightFactor.value,
                    child: Container(
                      decoration:
                          notificationMenuStyle.decoration ??
                          defaultStyle.decoration,
                      child: Padding(
                        padding:
                            notificationMenuStyle.padding ??
                            defaultStyle.padding!,
                        child: child,
                      ),
                    ),
                  ),
                );
              },
              child: Column(
                children: [
                  SizedBox(
                    height: 28,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Notifications'.tr(),
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(fontSize: 14),
                        ),
                        notifications.isEmpty
                            ? const SizedBox()
                            : DCustomTextBigButton(
                                onPressed: () {
                                  // Through the notifier, not a bare
                                  // invalidate: clearing the list has to give
                                  // up the raise episode too.
                                  ref
                                      .read(notificationsProvider.notifier)
                                      .clearAll();
                                },
                                child: SizedBox(
                                  width: 72,
                                  height: 24,
                                  child: Center(
                                    child: Text(
                                      'Clear all'.tr(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color:
                                                SideSwapColors.brightTurquoise,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  notifications.isEmpty
                      ? Flexible(child: NotificationItemEmpty())
                      : Flexible(
                          child: CustomScrollView(
                            slivers: [
                              SliverList.builder(
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      notifications[index].type.map(
                                        signRequest: (signRequest) =>
                                            NotificationItemSignRequest(
                                              key: index == 0
                                                  ? firstChildKey
                                                  : null,
                                              notificationId:
                                                  notifications[index].id,
                                              signRequest: signRequest,
                                              onTap: onTap,
                                            ),
                                        connect: (connect) =>
                                            NotificationItemConnectRequest(
                                              key: index == 0
                                                  ? firstChildKey
                                                  : null,
                                              notificationId:
                                                  notifications[index].id,
                                              connect: connect,
                                              onTap: onTap,
                                            ),
                                      ),
                                      index < notifications.length - 1
                                          ? const SizedBox(height: 10)
                                          : const SizedBox.shrink(),
                                    ],
                                  );
                                },
                                itemCount: notifications.length,
                              ),
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

class NotificationItemEmpty extends ConsumerWidget {
  const NotificationItemEmpty({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'No new notifications'.tr(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: SideSwapColors.cornFlower,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class NotificationItemSignRequest extends HookConsumerWidget {
  const NotificationItemSignRequest({
    super.key,
    required this.notificationId,
    required this.signRequest,
    this.onTap,
    this.style,
  });

  final int notificationId;
  final NotificationTypeSignRequest signRequest;
  final void Function()? onTap;
  final NotificationItemSignRequestStyle? style;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemStyle =
        style ??
        Theme.of(context).extension<NotificationItemSignRequestStyle>()!;

    final optionNotification = ref
        .watch(notificationsProvider.notifier)
        .getNotification(notificationId);

    final acceptFocusNode = useFocusNode();

    return optionNotification.match(() => DPopupWithClose(child: SizedBox()), (
      notification,
    ) {
      final sign = (notification.type as NotificationTypeSignRequest).sign;
      final reqId = notification.type.reqId;
      final origin = notification.type.origin;
      final balances = sign.balances;
      final recipients = sign.recipients;
      final networkFee = sign.networkFee.toInt();

      final optionTtl = ref.watch(
        signRequestNotificationTtlProvider(notificationId),
      );

      useEffect(() {
        acceptFocusNode.requestFocus();

        return;
      }, const []);

      // The reason is explicit rather than a `cancel` flag: rejecting and
      // expiring differ both in whether a rejection is sent and in whether the
      // window goes back. Putting the window back is the resolution boundary's
      // job now, not this widget's — see ADR-0004.
      final cancelCallback = useCallback((
        String reqId,
        int notificationId, {
        required NotificationRemovalReason reason,
      }) {
        if (reason == NotificationRemovalReason.rejectedByUser) {
          final msg = To();
          msg.signerResponse = To_SignerResponse(reqId: reqId, accept: false);
          ref.read(walletProvider).sendMsg(msg);
        }

        ref
            .read(notificationsProvider.notifier)
            .removeNotification(notificationId, reason: reason);
      }, [notificationId]);

      useEffect(() {
        if (!context.mounted) {
          return;
        }

        optionTtl.match(() {}, (ttl) {
          if (ttl <= 0) {
            Future.microtask(() {
              cancelCallback(
                reqId,
                notificationId,
                reason: NotificationRemovalReason.expired,
              );
            });
            return;
          }
        });

        return;
      }, [optionTtl]);

      final defaultStyle =
          notification.type.notificationItemState ==
              NotificationItemState.canceled()
          ? NotificationItemSignRequestStyle(
              height: 110,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: SideSwapColors.indigo,
              ),
              titleTextStyle: Theme.of(context).textTheme.bodyMedium,
              dividerColor: SideSwapColors.blumine,
              cancelledTextStyle: Theme.of(context).textTheme.labelMedium
                  ?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: SideSwapColors.bitterSweet,
                  ),
            )
          : NotificationItemSignRequestStyle(
              height: 475,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: SideSwapColors.indigo,
              ),
              titleTextStyle: Theme.of(context).textTheme.bodyMedium,
              dividerColor: SideSwapColors.blumine,
              cancelledTextStyle: Theme.of(context).textTheme.labelMedium
                  ?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: SideSwapColors.bitterSweet,
                  ),
            );

      return Container(
        height: defaultStyle.height ?? itemStyle.height!,
        decoration: defaultStyle.decoration ?? itemStyle.decoration,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Liquid Connect: Signature Required'.tr(),
                style: defaultStyle.titleTextStyle ?? itemStyle.titleTextStyle,
              ),
              const SizedBox(height: 8),
              Text(
                origin,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontSize: 13),
              ),
              if (notification.type.notificationItemState ==
                  NotificationItemState.canceled()) ...[
                const SizedBox(height: 10),
                Divider(
                  thickness: 0,
                  height: 1,
                  color: defaultStyle.dividerColor ?? itemStyle.dividerColor,
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: AlignmentGeometry.centerRight,
                  child: Text(
                    'Cancelled',
                    style:
                        defaultStyle.cancelledTextStyle ??
                        itemStyle.cancelledTextStyle,
                  ),
                ),
              ] else ...[
                const SizedBox(height: 10),
                DNotificationSignBalances(balances: balances),
                const SizedBox(height: 8),
                DNotificationsSignRecipients(recipients: recipients),
                const SizedBox(height: 8),
                DNotificationsNetworkFee(networkFee: networkFee),
                const SizedBox(height: 8),
                optionTtl.match(() => const SizedBox(), (ttl) {
                  return Text(
                    'Time-to-live: {} seconds'.plural(ttl, args: ['$ttl']),
                    style: Theme.of(
                      context,
                    ).textTheme.titleSmall?.copyWith(fontSize: 13),
                  );
                }),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DCustomTextBigButton(
                      width: 160,
                      height: 34,
                      onPressed: () {
                        cancelCallback(
                          reqId,
                          notificationId,
                          reason: NotificationRemovalReason.rejectedByUser,
                        );

                        onTap?.call();
                      },
                      child: Text('Cancel'.tr()),
                    ),
                    DCustomFilledBigButton(
                      width: 160,
                      height: 34,
                      focusNode: acceptFocusNode,
                      onPressed: () async {
                        if (await ref.read(walletProvider).isAuthenticated()) {
                          final msg = To();
                          msg.signerResponse = To_SignerResponse(
                            reqId: reqId,
                            accept: true,
                          );
                          ref.read(walletProvider).sendMsg(msg);

                          ref
                              .read(notificationsProvider.notifier)
                              .removeNotification(
                                notification.id,
                                reason:
                                    NotificationRemovalReason.acceptedByUser,
                              );

                          onTap?.call();
                        }
                      },
                      child: Text('Broadcast'.tr()),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      );
    });
  }
}

class NotificationItemConnectRequest extends HookConsumerWidget {
  const NotificationItemConnectRequest({
    super.key,
    required this.notificationId,
    required this.connect,
    this.onTap,
    this.style,
  });

  final int notificationId;
  final NotificationTypeConnect connect;
  final void Function()? onTap;
  final NotificationItemConnectRequestStyle? style;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemStyle =
        style ??
        Theme.of(context).extension<NotificationItemConnectRequestStyle>()!;

    final optionNotification = ref
        .watch(notificationsProvider.notifier)
        .getNotification(notificationId);

    final acceptFocusNode = useFocusNode();

    return optionNotification.match(() => DPopupWithClose(child: SizedBox()), (
      notification,
    ) {
      final reqId = notification.type.reqId;
      final origin = notification.type.origin;

      final optionTtl = ref.watch(
        signRequestNotificationTtlProvider(notificationId),
      );

      // The reason is explicit rather than a `cancel` flag: rejecting and
      // expiring differ both in whether a rejection is sent and in whether the
      // window goes back. Putting the window back is the resolution boundary's
      // job now, not this widget's — see ADR-0004.
      final cancelCallback = useCallback((
        String reqId,
        int notificationId, {
        required NotificationRemovalReason reason,
      }) {
        if (reason == NotificationRemovalReason.rejectedByUser) {
          final msg = To();
          msg.signerResponse = To_SignerResponse(reqId: reqId, accept: false);
          ref.read(walletProvider).sendMsg(msg);
        }

        ref
            .read(notificationsProvider.notifier)
            .removeNotification(notificationId, reason: reason);
      }, [notificationId]);

      useEffect(() {
        if (!context.mounted) {
          return;
        }

        optionTtl.match(() {}, (ttl) {
          if (ttl <= 0) {
            Future.microtask(() {
              cancelCallback(
                reqId,
                notificationId,
                reason: NotificationRemovalReason.expired,
              );
            });
            return;
          }
          return;
        });
        return;
      }, [optionTtl]);

      useEffect(() {
        acceptFocusNode.requestFocus();

        return;
      }, const []);

      final defaultStyle =
          notification.type.notificationItemState ==
              NotificationItemState.canceled()
          ? NotificationItemConnectRequestStyle(
              height: 182,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: SideSwapColors.indigo.withValues(alpha: 0.5),
              ),
              titleTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.5),
              ),
              dividerColor: SideSwapColors.blumine.withValues(alpha: 0.5),
              subtitleHeaderTextStyle: Theme.of(context).textTheme.labelLarge
                  ?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: SideSwapColors.cerulean.withValues(alpha: 0.5),
                  ),
              subtitleTextStyle: Theme.of(context).textTheme.labelLarge
                  ?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
              descriptionTextStyle: Theme.of(context).textTheme.titleSmall
                  ?.copyWith(color: Colors.white.withValues(alpha: 0.5)),
              privacyHeaderTextStyle: Theme.of(context).textTheme.labelMedium
                  ?.copyWith(
                    color: SideSwapColors.halfBaked.withValues(alpha: 0.5),
                    fontWeight: FontWeight.bold,
                  ),
              privacyTextStyle: Theme.of(context).textTheme.labelMedium
                  ?.copyWith(
                    color: SideSwapColors.halfBaked.withValues(alpha: 0.5),
                  ),
              cancelledTextStyle: Theme.of(context).textTheme.labelMedium
                  ?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: SideSwapColors.bitterSweet.withValues(alpha: 0.5),
                  ),
            )
          : NotificationItemConnectRequestStyle(
              height: 358,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: SideSwapColors.indigo,
              ),
              titleTextStyle: Theme.of(context).textTheme.bodyMedium,
              dividerColor: SideSwapColors.blumine,
              subtitleHeaderTextStyle: Theme.of(context).textTheme.labelLarge
                  ?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: SideSwapColors.cerulean,
                  ),
              subtitleTextStyle: Theme.of(context).textTheme.labelLarge
                  ?.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
              descriptionTextStyle: Theme.of(context).textTheme.titleSmall,
              privacyHeaderTextStyle: Theme.of(context).textTheme.labelMedium
                  ?.copyWith(
                    color: SideSwapColors.halfBaked,
                    fontWeight: FontWeight.bold,
                  ),
              privacyTextStyle: Theme.of(context).textTheme.labelMedium
                  ?.copyWith(color: SideSwapColors.halfBaked),
              cancelledTextStyle: Theme.of(context).textTheme.labelMedium
                  ?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: SideSwapColors.bitterSweet,
                  ),
            );

      return Container(
        height: defaultStyle.height ?? itemStyle.height!,
        decoration: defaultStyle.decoration ?? itemStyle.decoration,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Connect request'.tr(),
                style: defaultStyle.titleTextStyle ?? itemStyle.titleTextStyle,
              ),
              const SizedBox(height: 10),
              Divider(
                thickness: 0,
                height: 1,
                color: defaultStyle.dividerColor ?? itemStyle.dividerColor,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Site:'.tr(),
                    style:
                        defaultStyle.subtitleHeaderTextStyle ??
                        itemStyle.subtitleHeaderTextStyle,
                  ),
                  Text(
                    origin,
                    style:
                        defaultStyle.subtitleTextStyle ??
                        itemStyle.subtitleTextStyle,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Scope:'.tr(),
                    style:
                        defaultStyle.subtitleHeaderTextStyle ??
                        itemStyle.subtitleHeaderTextStyle,
                  ),
                  Text(
                    'read-only (watch-only)'.tr(),
                    style:
                        defaultStyle.subtitleTextStyle ??
                        itemStyle.subtitleTextStyle,
                  ),
                ], // Add the appropriate scope information here
              ),
              const SizedBox(height: 10),
              Divider(
                thickness: 0,
                height: 1,
                color: defaultStyle.dividerColor ?? itemStyle.dividerColor,
              ),
              const SizedBox(height: 10),
              if (notification.type.notificationItemState ==
                  NotificationItemState.canceled()) ...[
                Align(
                  alignment: AlignmentGeometry.centerRight,
                  child: Text(
                    'Cancelled',
                    style:
                        defaultStyle.cancelledTextStyle ??
                        itemStyle.cancelledTextStyle,
                  ),
                ),
              ] else ...[
                Text(
                  "This site can see balances, assets, and history for the accounts you share. It can't spend or sign."
                      .tr(),
                  style:
                      defaultStyle.descriptionTextStyle ??
                      itemStyle.descriptionTextStyle,
                ),
                const SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    text: 'Privacy note: '.tr(),
                    style:
                        defaultStyle.privacyHeaderTextStyle ??
                        itemStyle.privacyHeaderTextStyle,
                    children: [
                      TextSpan(
                        text:
                            'Sharing watch-only access (descriptor/xpub and Liquid master blinding key) reveals your full past and future activity for the selected accounts to this site. Only connect to sites you trust.'
                                .tr(),
                        style:
                            defaultStyle.privacyTextStyle ??
                            itemStyle.privacyTextStyle,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                optionTtl.match(() => const SizedBox(), (ttl) {
                  return Text(
                    'Time-to-live: {} seconds'.plural(ttl, args: ['$ttl']),
                    style: Theme.of(
                      context,
                    ).textTheme.titleSmall?.copyWith(fontSize: 13),
                  );
                }),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DCustomTextBigButton(
                      width: 160,
                      height: 34,
                      onPressed: () {
                        cancelCallback(
                          reqId,
                          notificationId,
                          reason: NotificationRemovalReason.rejectedByUser,
                        );

                        onTap?.call();
                      },
                      child: Text('Cancel'.tr()),
                    ),
                    DCustomFilledBigButton(
                      width: 160,
                      height: 34,
                      focusNode: acceptFocusNode,
                      onPressed: () async {
                        if (await ref.read(walletProvider).isAuthenticated()) {
                          final msg = To();
                          msg.signerResponse = To_SignerResponse(
                            reqId: reqId,
                            accept: true,
                          );
                          ref.read(walletProvider).sendMsg(msg);

                          ref
                              .read(notificationsProvider.notifier)
                              .removeNotification(
                                notification.id,
                                reason:
                                    NotificationRemovalReason.acceptedByUser,
                              );

                          onTap?.call();
                        }
                      },
                      child: Text('Connect'.tr()),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      );
    });
  }
}

class DNotificationSignBalances extends HookConsumerWidget {
  const DNotificationSignBalances({super.key, required this.balances});

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
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: SideSwapColors.cerulean,
          ),
        ),
        const SizedBox(height: 8),
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: const Color(0xFF2C4E70),
          ),

          child: SizedBox(
            height: 85,
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
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleSmall,
                                    ),
                                    Row(
                                      children: [
                                        assetIcon,
                                        const SizedBox(width: 8),
                                        Text(
                                          ticker,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.titleSmall,
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

class DNotificationsSignRecipients extends HookConsumerWidget {
  const DNotificationsSignRecipients({super.key, required this.recipients});

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
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: SideSwapColors.cerulean,
          ),
        ),
        const SizedBox(height: 8),
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: const Color(0xFF2C4E70),
          ),
          child: SizedBox(
            height: 85,
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
                                          style: Theme.of(
                                            context,
                                          ).textTheme.titleSmall,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Row(
                                      children: [
                                        Text(
                                          amountStr,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.titleSmall,
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

class DNotificationsNetworkFee extends ConsumerWidget {
  const DNotificationsNetworkFee({super.key, required this.networkFee});

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
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: SideSwapColors.cerulean,
          ),
        ),
        const SizedBox(height: 8),
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: const Color(0xFF2C4E70),
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

class DNotificationSignPopup extends HookConsumerWidget {
  const DNotificationSignPopup({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final optionNotification = ref
        .watch(notificationsProvider.notifier)
        .getNotification(id);

    final acceptCallback = useCallback((
      String reqId,
      int notificationId,
    ) async {
      final jadeLockRepository = ref.read(jadeLockRepositoryProvider);

      await (switch (jadeLockRepository.isUnlocked()) {
        true => () async {
          var authorized = ref.read(jadeOneTimeAuthorizationProvider);

          if (!ref.read(jadeOneTimeAuthorizationProvider)) {
            authorized = await ref
                .read(jadeOneTimeAuthorizationProvider.notifier)
                .authorize();
          }

          if (!authorized) {
            return;
          }

          final msg = To();
          msg.signerResponse = To_SignerResponse(reqId: reqId, accept: true);
          ref.read(walletProvider).sendMsg(msg);

          ref
              .read(notificationsProvider.notifier)
              .removeNotification(
                notificationId,
                reason: NotificationRemovalReason.acceptedByUser,
              );

          if (context.mounted) {
            Navigator.of(context).pop();
          }
        },
        _ => () {},
      }());
    }, [id, ref]);

    return optionNotification.match(() => DPopupWithClose(child: SizedBox()), (
      notification,
    ) {
      final sign = (notification.type as NotificationTypeSignRequest).sign;
      final reqId = notification.type.reqId;
      final origin = notification.type.origin;
      final balances = sign.balances;
      final recipients = sign.recipients;
      final networkFee = sign.networkFee.toInt();

      return DPopupWithClose(
        width: 580,
        height: 605,
        onClose: () {
          final msg = To();
          msg.signerResponse = To_SignerResponse(reqId: reqId, accept: false);
          ref.read(walletProvider).sendMsg(msg);

          ref
              .read(notificationsProvider.notifier)
              .removeNotification(
                notification.id,
                reason: NotificationRemovalReason.rejectedByUser,
              );

          Navigator.of(context).pop();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      'Sign transaction'.tr(),
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const SizedBox(height: 8),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: 'Transaction generated on '.tr(),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: SideSwapColors.halfBaked,
                        ),
                        children: [
                          TextSpan(
                            text: origin,
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  DNotificationSignBalances(balances: balances),
                  const SizedBox(height: 8),
                  DNotificationsSignRecipients(recipients: recipients),
                  const SizedBox(height: 24),
                  DNotificationsNetworkFee(networkFee: networkFee),
                ],
              ),
            ),
            const Spacer(),
            ColoredBox(
              color: SideSwapColors.chathamsBlue,
              child: SizedBox(
                height: 175,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: [
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DCustomTextBigButton(
                              width: 245,
                              height: 44,
                              onPressed: () {
                                final msg = To();
                                msg.signerResponse = To_SignerResponse(
                                  reqId: reqId,
                                  accept: false,
                                );
                                ref.read(walletProvider).sendMsg(msg);

                                ref
                                    .read(notificationsProvider.notifier)
                                    .removeNotification(
                                      notification.id,
                                      reason: NotificationRemovalReason
                                          .rejectedByUser,
                                    );

                                Navigator.of(context).pop();
                              },
                              child: Text('Cancel'.tr()),
                            ),
                            DCustomFilledBigButton(
                              width: 245,
                              height: 44,
                              autofocus: true,
                              onPressed: () async {
                                await acceptCallback(reqId, notification.id);
                              },
                              child: Text('Broadcast'.tr()),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
