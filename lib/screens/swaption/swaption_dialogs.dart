import 'package:collection/collection.dart';
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
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class SwaptionDialog extends HookConsumerWidget {
  const SwaptionDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationsProvider);
    final optionShowNotificationMenu = ref.watch(showNotificationMenuProvider);
    final notificationData = useState<NotificationData?>(null);

    useEffect(() {
      optionShowNotificationMenu.match(
        () {
          notificationData.value = null;
        },
        (notificationId) {
          notificationData.value = notifications.firstWhereOrNull(
            (e) => e.id == notificationId,
          );

          if (notificationData.value == null) {
            Future.microtask(() {
              ref.invalidate(showNotificationMenuProvider);
            });
          }
        },
      );

      return;
    }, [notifications, optionShowNotificationMenu]);

    useEffect(() {
      if (notificationData.value != null &&
          notificationData.value?.type.notificationItemState ==
              NotificationItemStateCanceled()) {
        Future.microtask(() {
          if (context.mounted) {
            Navigator.of(context, rootNavigator: true).pop();
          }
        });
        return;
      }

      return;
    }, [notificationData.value?.type.notificationItemState]);

    return switch (notificationData.value?.type) {
      NotificationTypeConnect() => SwaptionConnectDialog(
        notificationId: notificationData.value!.id,
      ),
      NotificationTypeSignRequest() => SwaptionSignRequestDialog(
        notificationId: notificationData.value!.id,
      ),
      _ => SideSwapPopup(
        onClose: () {
          Navigator.of(context, rootNavigator: true).pop();
        },
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) {
            Navigator.of(context, rootNavigator: true).pop();
          }
        },
        child: SizedBox(),
      ),
    };
  }
}

class SwaptionConnectDialog extends HookConsumerWidget {
  const SwaptionConnectDialog({required this.notificationId, super.key});

  final int notificationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationsProvider);
    final optionNotificationData = useState(Option<NotificationData>.none());

    useEffect(() {
      final data = notifications.firstWhereOrNull(
        (e) => e.id == notificationId,
      );
      optionNotificationData.value = Option.fromNullable(data);

      return;
    }, [notifications]);

    final onClose = useCallback(({bool cancel = true}) {
      optionNotificationData.value.match(() {}, (notificationData) {
        final notification = notificationData.type as NotificationTypeConnect;

        if (cancel) {
          final msg = To();
          msg.signerResponse = To_SignerResponse(
            reqId: notification.reqId,
            accept: false,
          );
          ref.read(walletProvider).sendMsg(msg);
        }
      });

      Navigator.of(context, rootNavigator: true).pop(false);
    }, [optionNotificationData.value]);

    final onAllow = useCallback(() {
      optionNotificationData.value.match(
        () {
          Navigator.of(context, rootNavigator: true).pop(false);
        },
        (notificationData) async {
          final notification = notificationData.type as NotificationTypeConnect;
          if (await ref.read(walletProvider).isAuthenticated()) {
            final msg = To();
            msg.signerResponse = To_SignerResponse(
              reqId: notification.reqId,
              accept: true,
            );
            ref.read(walletProvider).sendMsg(msg);
          }

          if (context.mounted) {
            Navigator.of(context, rootNavigator: true).pop(true);
          }
        },
      );
    }, [optionNotificationData.value]);

    final optionTtl = ref.watch(
      signRequestNotificationTtlProvider(notificationId),
    );

    useEffect(() {
      optionTtl.match(() {}, (ttl) {
        if (ttl <= 0) {
          Future.microtask(() {
            onClose(cancel: false);
            ref
                .read(notificationsProvider.notifier)
                .removeNotification(
                  notificationId,
                  reason: NotificationRemovalReason.expired,
                );
          });
        }
      });

      return;
    }, [optionTtl]);

    return SideSwapPopup(
      enableInsideHorizontalPadding: false,
      onClose: () {
        onClose();
      },
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
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Do you want to connect to this website?'.tr(),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 18),
                    SwaptionConnectBox(
                      optionNotificationData: optionNotificationData.value,
                    ),
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
                            text:
                                'Sharing watch-only access (descriptor/xpub and Liquid master blinding key) reveals your full past and future activity for the selected accounts to this site. Only connect to sites you trust.'
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
                        style: Theme.of(
                          context,
                        ).textTheme.titleSmall?.copyWith(fontSize: 13),
                      );
                    }),
                    const SizedBox(height: 32),
                    CustomBigButton(
                      width: double.infinity,
                      height: 54,
                      text: 'Allow'.tr(),
                      backgroundColor: SideSwapColors.brightTurquoise,
                      onPressed: () {
                        onAllow();
                      },
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
                  optionNotificationData.value.match(() => const SizedBox(), (
                    notification,
                  ) {
                    final notificationType =
                        notification.type as NotificationTypeConnect;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/web_icon_transparent.svg',
                          width: 20,
                          height: 20,
                        ),
                        const SizedBox(width: 6),
                        Text(notificationType.origin),
                      ],
                    );
                  }),
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
  const SwaptionConnectBox({required this.optionNotificationData, super.key});

  final Option<NotificationData> optionNotificationData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return optionNotificationData.match(() => const SizedBox(), (
      notificationData,
    ) {
      final notification = notificationData.type as NotificationTypeConnect;
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
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: SideSwapColors.brightTurquoise,
                    ),
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
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: SideSwapColors.brightTurquoise,
                    ),
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
    });
  }
}

class SwaptionSignRequestDialog extends HookConsumerWidget {
  const SwaptionSignRequestDialog({required this.notificationId, super.key});

  final int notificationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationsProvider);
    final optionNotificationData = useState(Option<NotificationData>.none());

    useEffect(() {
      final data = notifications.firstWhereOrNull(
        (e) => e.id == notificationId,
      );
      optionNotificationData.value = Option.fromNullable(data);

      return;
    }, [notifications]);

    final onClose = useCallback(({bool cancel = true}) {
      optionNotificationData.value.match(() {}, (notificationData) {
        final notification =
            notificationData.type as NotificationTypeSignRequest;

        if (cancel) {
          final msg = To();
          msg.signerResponse = To_SignerResponse(
            reqId: notification.reqId,
            accept: false,
          );
          ref.read(walletProvider).sendMsg(msg);
        }
      });

      Navigator.of(context, rootNavigator: true).pop(false);
    }, [optionNotificationData.value]);

    final onAllow = useCallback(() {
      optionNotificationData.value.match(
        () {
          Navigator.of(context, rootNavigator: true).pop(false);
        },
        (notificationData) {
          final notification =
              notificationData.type as NotificationTypeSignRequest;
          final msg = To();
          msg.signerResponse = To_SignerResponse(
            reqId: notification.reqId,
            accept: true,
          );
          ref.read(walletProvider).sendMsg(msg);

          Navigator.of(context, rootNavigator: true).pop(true);
        },
      );
    }, [optionNotificationData.value]);

    final optionTtl = ref.watch(
      signRequestNotificationTtlProvider(notificationId),
    );

    useEffect(() {
      optionTtl.match(() {}, (ttl) {
        if (ttl <= 0) {
          Future.microtask(() {
            onClose(cancel: false);
            ref
                .read(notificationsProvider.notifier)
                .removeNotification(
                  notificationId,
                  reason: NotificationRemovalReason.expired,
                );
          });
          return;
        }
      });

      return;
    }, [optionTtl]);

    return SideSwapPopup(
      enableInsideHorizontalPadding: false,
      onClose: () {
        onClose();
      },
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
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    optionNotificationData.value.match(() => const SizedBox(), (
                      notificationData,
                    ) {
                      final notificationType =
                          notificationData.type as NotificationTypeSignRequest;
                      return Text(
                        notificationType.origin,
                        style: Theme.of(
                          context,
                        ).textTheme.titleSmall?.copyWith(fontSize: 13),
                      );
                    }),
                    optionNotificationData.value.match(() => const SizedBox(), (
                      notificationData,
                    ) {
                      final notificationType =
                          notificationData.type as NotificationTypeSignRequest;
                      return Column(
                        children: [
                          const SizedBox(height: 10),
                          NotificationSignBalances(
                            balances: notificationType.sign.balances,
                          ),
                          const SizedBox(height: 8),
                          NotificationsSignRecipients(
                            recipients: notificationType.sign.recipients,
                          ),
                          const SizedBox(height: 8),
                          NotificationsNetworkFee(
                            networkFee: notificationType.sign.networkFee
                                .toInt(),
                          ),
                          const SizedBox(height: 8),
                          optionTtl.match(() => const SizedBox(), (ttl) {
                            return Text(
                              'Time-to-live: {} seconds'.plural(
                                ttl,
                                args: ['$ttl'],
                              ),
                              style: Theme.of(
                                context,
                              ).textTheme.titleSmall?.copyWith(fontSize: 13),
                            );
                          }),
                        ],
                      );
                    }),
                    const Spacer(),
                    CustomBigButton(
                      width: double.infinity,
                      height: 54,
                      text: 'Broadcast'.tr(),
                      backgroundColor: SideSwapColors.brightTurquoise,
                      onPressed: () {
                        onAllow();
                      },
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
                  optionNotificationData.value.match(() => const SizedBox(), (
                    notification,
                  ) {
                    final notificationType =
                        notification.type as NotificationTypeSignRequest;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/web_icon_transparent.svg',
                          width: 20,
                          height: 20,
                        ),
                        const SizedBox(width: 6),
                        Text(notificationType.origin),
                      ],
                    );
                  }),
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
