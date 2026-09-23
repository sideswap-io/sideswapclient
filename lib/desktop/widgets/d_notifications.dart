import 'dart:async';

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
import 'package:sideswap/desktop/widgets/d_scroll_when_short.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/asset_image_providers.dart';
import 'package:sideswap/providers/jade_provider.dart';
import 'package:sideswap/providers/notification_removal_reason.dart';
import 'package:sideswap/providers/notifications_provider.dart';
import 'package:sideswap/providers/signer_acceptance_provider.dart';
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
            // Dismissal, not a toggle. The entry outlives the click by the
            // length of the collapse animation, so its catcher is still there
            // to take a second one — and a toggle would read that second click
            // as "open again", which is the "sometimes I have to click twice"
            // this panel was reported for.
            onTap: () {
              expanded.value = false;
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
        // Through a microtask, like its sibling below and for the same
        // reason: an effect body runs inside the rebuild that scheduled it,
        // and a write to a hook's state from there is taken without a rebuild
        // following it — measured, not deduced. The effect keyed on `expanded`
        // therefore never runs, so the panel is left open with `expanded`
        // already false, and every later dismissal writes the value the state
        // already holds and is a no-op: the panel is unclosable, by a click
        // outside it and by the toolbar button alike — the catcher takes that
        // click before the button does.
        Future.microtask(() => expanded.value = false);
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
        // Deferred for the reason the two writes above are. Lost here it is
        // the mirror image: the flag reads true with no overlay under it, and
        // the panel the listener asked to be shown never opens.
        Future.microtask(() => expanded.value = true);
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

/// Which of the two kinds of request an entry is.
enum NotificationItemKind { sign, connect }

NotificationItemKind notificationItemKind(NotificationType type) =>
    switch (type) {
      NotificationTypeSignRequest() => NotificationItemKind.sign,
      NotificationTypeConnect() => NotificationItemKind.connect,
    };

/// The identity of a panel child: the request it shows, not the slot it sits in.
///
/// Not the notification id on its own. A request carrying both a connect and a
/// sign payload is two entries under one id — `addNotification` increments the
/// counter once and files both against it — and two siblings under one key are
/// not an error the framework reports: `SliverMultiBoxAdaptorElement`
/// resolves both to the same index, overwrites one entry with the other and
/// ends the rebuild a child short, silently.
Key notificationChildKey(NotificationData notification) =>
    ValueKey((notification.id, notificationItemKind(notification.type)));

/// What an item of [kind] lays itself out at, in logical pixels.
///
/// The two arguments are the only two things the height depends on, and they
/// are taken apart because they come from different places. The **kind** is
/// fixed for the widget doing the laying out; it must not be read off the
/// entry the item looks up, because `getNotification` matches by id and the
/// two entries of a dual-payload request share one — the connect item's lookup
/// answers with the sign entry. The **state** is a live fact about the request
/// and does come from that entry.
///
/// The single place that says what an item is worth in pixels: the panel makes
/// room for its first item from this, and each item lays itself out at it.
///
/// Deliberately not a theme value. It was one, and the theme carried 189 and
/// 286 while the items rendered 475 and 358 — the field was never read, and a
/// style nothing honours is worse than no style at all.
double notificationItemHeight(
  NotificationItemKind kind,
  NotificationItemState state,
) => switch ((kind, state)) {
  (NotificationItemKind.sign, NotificationItemStateCanceled()) => 110,
  (NotificationItemKind.sign, _) => 475,
  (NotificationItemKind.connect, NotificationItemStateCanceled()) => 182,
  (NotificationItemKind.connect, _) => 358,
};

/// What [notification] lays itself out at, read from the entry itself.
///
/// Only sound where the entry in hand *is* the one being rendered — the panel
/// reading its own list. An item must use [notificationItemHeight] with its
/// own kind instead.
double notificationEntryHeight(NotificationData notification) =>
    notificationItemHeight(
      notificationItemKind(notification.type),
      notification.type.notificationItemState,
    );

const _panelWidth = 370.0;

/// The panel with nothing in it. The empty item has no height of its own — it
/// fills whatever box it is given — so this is a standalone number rather than
/// an item plus [_panelChrome].
const _emptyPanelHeight = 163.0;

/// What the panel puts around its first item: the 28-high title row, the 10
/// gap under it, and 10 of padding at each end.
const _panelChrome = 58.0;

/// The gap the list leaves under every item but the last.
const _itemSpacing = 10.0;

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

    // Derived from the first entry rather than measured off the first child.
    // A measurement has to hang a key on a child, and a child that can be
    // relocated cannot carry one: the key changes as the child moves, so the
    // element is destroyed at exactly the moment it is being moved. The
    // derivation is exact — an item's box is a constant of its kind and its
    // state, which is what [notificationItemHeight] is.
    final panelHeight = notifications.isEmpty
        ? _emptyPanelHeight
        : notificationEntryHeight(notifications.first) + _panelChrome;

    // The panel hands the keyboard to one item and one only: whichever is
    // first the first time it has anything to show. Everything arriving after
    // that arrives into a panel the user is already working in, and takes
    // nothing — the same rule as the item's own focus drop, seen from the
    // other side.
    //
    // A latch rather than the list this build started with, because the panel
    // can be opened with nothing pending and be given its first request
    // afterwards; that request is still the one the panel opened on.
    final autofocused = useRef<Key?>(null);
    if (autofocused.value == null && notifications.isNotEmpty) {
      autofocused.value = notificationChildKey(notifications.first);
    }

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
        // Dismiss and swallow, both stated rather than inherited.
        //
        // `opaque` is the behavioural half: a childless GestureDetector
        // defaults to `translucent` (`GestureDetector._defaultBehavior`), which
        // lets the dismissing click carry on into whatever sits under the
        // panel. `fill` changes nothing observable — the catcher already covers
        // the stack under the tight constraints the overlay hands it — but it
        // says so, instead of resting on how a childless proxy box happens to
        // size itself, which is not a guarantee anything documents.
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
          ),
        ),
        Positioned(
          top: offset.dy,
          left: offset.dx,
          child: SizedBox(
            width: _panelWidth,
            height: panelHeight,
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
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(fontSize: 14),
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
                                  final notification = notifications[index];
                                  final childKey = notificationChildKey(
                                    notification,
                                  );
                                  final autofocus =
                                      childKey == autofocused.value;

                                  return Column(
                                    key: childKey,
                                    children: [
                                      notification.type.map(
                                        signRequest: (signRequest) =>
                                            NotificationItemSignRequest(
                                              notificationId: notification.id,
                                              signRequest: signRequest,
                                              autofocus: autofocus,
                                            ),
                                        connect: (connect) =>
                                            NotificationItemConnectRequest(
                                              notificationId: notification.id,
                                              connect: connect,
                                              autofocus: autofocus,
                                            ),
                                      ),
                                      index < notifications.length - 1
                                          ? const SizedBox(height: _itemSpacing)
                                          : const SizedBox.shrink(),
                                    ],
                                  );
                                },
                                // Not optional next to the keys above: a
                                // sliver relocates a keyed child only through
                                // this callback, and a key without one is
                                // worse than no key at all — every child is
                                // deactivated on a list change instead of only
                                // the ones that moved. Built from the list
                                // read in this build rather than memoized,
                                // because the delegate is rebuilt every time
                                // and resolves keys through the new one.
                                findChildIndexCallback: (key) {
                                  final index = notifications.indexWhere(
                                    (notification) =>
                                        notificationChildKey(notification) ==
                                        key,
                                  );

                                  // An entry that is gone: the sliver
                                  // deactivates its child, which is what
                                  // should happen.
                                  return index < 0 ? null : index;
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
                style: Theme.of(context).textTheme.bodySmall
                    ?.copyWith(color: SideSwapColors.cornFlower),
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
    this.autofocus = true,
    this.style,
  });

  final int notificationId;
  final NotificationTypeSignRequest signRequest;

  /// Whether this item may take the keyboard when it appears.
  ///
  /// Defaults to true: an item on its own is the only thing on screen, and
  /// only the panel knows that one of several has already been granted it.
  final bool autofocus;
  final NotificationItemSignRequestStyle? style;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemStyle =
        style ??
        Theme.of(context).extension<NotificationItemSignRequestStyle>()!;

    final optionNotification = ref
        .watch(notificationsProvider.notifier)
        .getNotification(notificationId);

    // The request this element was given to render. Everything below answers
    // for *this* request id and nothing else: an element repurposed to another
    // request is rebuilt with a new one, so its busy state, its focus and its
    // acceptance follow the request rather than the element.
    final reqId = signRequest.reqId;

    // Built lazily, but never collected once built. The panel shows one item
    // at a time, so an arrival that puts two items above the one the user is
    // on would otherwise take that one's element out from under them — and an
    // element the list collects takes the focus node in it with it, whatever
    // the sliver did to relocate it first. Keeping what is built is what makes
    // the relocation worth anything; building everything up front is not, and
    // a panel is not a feed.
    useAutomaticKeepAlive();

    final acceptFocusNode = useFocusNode();

    // A scope over this item's own subtree. Both focus rules below are answered
    // against this node rather than against the controls, which is what keeps
    // them independent of how any individual button manages its focus node.
    // ADR-0009 decision 5.
    final itemFocusScopeNode = useFocusScopeNode();

    // Whether this item held the focus when the press was made, captured
    // synchronously *before* the disable rather than tested after it: disabling
    // a control unfocuses it in the same turn, so a rule phrased as "restore if
    // focus is still inside this item" would refuse every restoration —
    // including the one after a failed gate the user is left to retry.
    final focusWasHere = useRef(false);

    final previousReqId = useRef<String?>(null);

    // Busy for *this* request id, read from the set the single-flight guard is
    // kept in. The set lives in a `keepAlive` notifier, so it is unaffected by
    // this element being unmounted, recreated or repurposed — which is ADR-0009
    // decision 2 seen from the widget side. Declared above the `match` for the
    // same reason the hooks are.
    final acceptInFlight = ref.watch(
      signerAcceptanceProvider.select((inFlight) => inFlight.contains(reqId)),
    );

    // Focus does not ride along to another request. When a prepend or a removal
    // repurposes this element, any focus its subtree holds is dropped rather
    // than handed to a request the user has not read — where a repeated Enter
    // would reject it, or raise the gate for it. ADR-0009 decision 5.
    useEffect(() {
      final previous = previousReqId.value;
      previousReqId.value = reqId;

      if (previous == null || previous == reqId) {
        return null;
      }

      // Whatever the previous request armed is abandoned with it. Clearing the
      // capture is what stops the restoration below from landing on the
      // arriving request: both effects run in the same synchronous build, and
      // `unfocus` only marks the change for the next microtask — so the
      // restoration would still read this scope as focused and hand the focus
      // to a control the user has not read. This effect is declared first so
      // that ordering holds.
      focusWasHere.value = false;

      if (itemFocusScopeNode.hasFocus) {
        itemFocusScopeNode.unfocus();
      }

      return null;
    }, [reqId]);

    // Restores the focus the disable took, and only that. An effect rather than
    // a listener, because a listener is called the moment the set changes —
    // while the control is still disabled, and a disabled
    // `FocusableActionDetector` refuses the focus it is offered. An effect runs
    // after the rebuild that re-enables it.
    //
    // Nothing to restore unless this item held the focus when the press was
    // made, and nothing to restore if something outside this item has claimed
    // it since: a control the user tabbed to on another item is not this item's
    // to take back. ADR-0009 decision 5.
    useEffect(() {
      if (acceptInFlight) {
        return null;
      }

      if (!focusWasHere.value) {
        return null;
      }
      focusWasHere.value = false;

      // `hasPrimaryFocus`, not `hasFocus`: disabling the control hands the
      // focus up to this scope node itself, so holding it *directly* is what
      // "nothing has claimed it since" looks like. A control that holds it
      // instead — Cancel on this very item, or a control on another one — is
      // the user's choice and not this item's to take back.
      if (!itemFocusScopeNode.hasPrimaryFocus) {
        return null;
      }

      acceptFocusNode.requestFocus();

      return null;
    }, [acceptInFlight]);

    // The item takes the keyboard when it appears, so the request it shows is
    // answerable without reaching for the mouse — but only if it is the item
    // the panel granted it to. An arrival into a panel the user is already
    // working in takes nothing: a control the user has not read must not end
    // up under the next Enter.
    //
    // Restoring the focus the disable takes is a separate rule and lives in
    // the effect above: re-running this on the busy flag would fire it for
    // every item whose attempt ends, including one the user has since tabbed
    // away from.
    useEffect(() {
      if (autofocus) {
        acceptFocusNode.requestFocus();
      }

      return null;
    }, const []);

    return optionNotification.match(() => DPopupWithClose(child: SizedBox()), (
      notification,
    ) {
      final sign = (notification.type as NotificationTypeSignRequest).sign;
      final origin = notification.type.origin;
      final balances = sign.balances;
      final recipients = sign.recipients;
      final networkFee = sign.networkFee.toInt();

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

      final defaultStyle =
          notification.type.notificationItemState ==
              NotificationItemState.canceled()
          ? NotificationItemSignRequestStyle(
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

      return FocusScope(
        node: itemFocusScopeNode,
        child: Container(
          height: notificationItemHeight(
            NotificationItemKind.sign,
            notification.type.notificationItemState,
          ),
          decoration: defaultStyle.decoration ?? itemStyle.decoration,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Liquid Connect: Signature Required'.tr(),
                  style:
                      defaultStyle.titleTextStyle ?? itemStyle.titleTextStyle,
                ),
                const SizedBox(height: 8),
                Text(
                  origin,
                  style: Theme.of(context).textTheme.titleSmall
                      ?.copyWith(fontSize: 13),
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
                      style: Theme.of(context).textTheme.titleSmall
                          ?.copyWith(fontSize: 13),
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
                        },
                        child: Text('Cancel'.tr()),
                      ),
                      DCustomFilledBigButton(
                        width: 160,
                        height: 34,
                        focusNode: acceptFocusNode,
                        onPressed: acceptInFlight
                            ? null
                            : () {
                                // Captured before the ask, not tested after it:
                                // the rebuild that disables this control takes
                                // its focus away in the same turn.
                                // ADR-0009 decision 5.
                                focusWasHere.value =
                                    itemFocusScopeNode.hasFocus;

                                // Unawaited by design. Once the gate is crossed
                                // the widget is no longer a party to the outcome,
                                // and an awaited result would put this element's
                                // survival back on the acceptance path — which is
                                // the defect this moved out of the widget.
                                // ADR-0009 decision 2.
                                unawaited(
                                  ref
                                      .read(signerAcceptanceProvider.notifier)
                                      .accept(
                                        notificationId: notificationId,
                                        reqId: reqId,
                                      ),
                                );
                              },
                        child: Text('Broadcast'.tr()),
                      ),
                    ],
                  ),
                ],
              ],
            ),
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
    this.autofocus = true,
    this.style,
  });

  final int notificationId;
  final NotificationTypeConnect connect;

  /// Whether this item may take the keyboard when it appears.
  ///
  /// Defaults to true: an item on its own is the only thing on screen, and
  /// only the panel knows that one of several has already been granted it.
  final bool autofocus;
  final NotificationItemConnectRequestStyle? style;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemStyle =
        style ??
        Theme.of(context).extension<NotificationItemConnectRequestStyle>()!;

    final optionNotification = ref
        .watch(notificationsProvider.notifier)
        .getNotification(notificationId);

    // The request this element was given to render. Everything below answers
    // for *this* request id and nothing else: an element repurposed to another
    // request is rebuilt with a new one, so its busy state, its focus and its
    // acceptance follow the request rather than the element.
    final reqId = connect.reqId;

    // Built lazily, but never collected once built. The panel shows one item
    // at a time, so an arrival that puts two items above the one the user is
    // on would otherwise take that one's element out from under them — and an
    // element the list collects takes the focus node in it with it, whatever
    // the sliver did to relocate it first. Keeping what is built is what makes
    // the relocation worth anything; building everything up front is not, and
    // a panel is not a feed.
    useAutomaticKeepAlive();

    final acceptFocusNode = useFocusNode();

    // A scope over this item's own subtree. Both focus rules below are answered
    // against this node rather than against the controls, which is what keeps
    // them independent of how any individual button manages its focus node.
    // ADR-0009 decision 5.
    final itemFocusScopeNode = useFocusScopeNode();

    // Whether this item held the focus when the press was made, captured
    // synchronously *before* the disable rather than tested after it: disabling
    // a control unfocuses it in the same turn, so a rule phrased as "restore if
    // focus is still inside this item" would refuse every restoration —
    // including the one after a failed gate the user is left to retry.
    final focusWasHere = useRef(false);

    final previousReqId = useRef<String?>(null);

    // Busy for *this* request id, read from the set the single-flight guard is
    // kept in. The set lives in a `keepAlive` notifier, so it is unaffected by
    // this element being unmounted, recreated or repurposed — which is ADR-0009
    // decision 2 seen from the widget side. Declared above the `match` for the
    // same reason the hooks are.
    final acceptInFlight = ref.watch(
      signerAcceptanceProvider.select((inFlight) => inFlight.contains(reqId)),
    );

    // Focus does not ride along to another request. When a prepend or a removal
    // repurposes this element, any focus its subtree holds is dropped rather
    // than handed to a request the user has not read — where a repeated Enter
    // would reject it, or raise the gate for it. ADR-0009 decision 5.
    useEffect(() {
      final previous = previousReqId.value;
      previousReqId.value = reqId;

      if (previous == null || previous == reqId) {
        return null;
      }

      // Whatever the previous request armed is abandoned with it. Clearing the
      // capture is what stops the restoration below from landing on the
      // arriving request: both effects run in the same synchronous build, and
      // `unfocus` only marks the change for the next microtask — so the
      // restoration would still read this scope as focused and hand the focus
      // to a control the user has not read. This effect is declared first so
      // that ordering holds.
      focusWasHere.value = false;

      if (itemFocusScopeNode.hasFocus) {
        itemFocusScopeNode.unfocus();
      }

      return null;
    }, [reqId]);

    // Restores the focus the disable took, and only that. An effect rather than
    // a listener, because a listener is called the moment the set changes —
    // while the control is still disabled, and a disabled
    // `FocusableActionDetector` refuses the focus it is offered. An effect runs
    // after the rebuild that re-enables it.
    //
    // Nothing to restore unless this item held the focus when the press was
    // made, and nothing to restore if something outside this item has claimed
    // it since: a control the user tabbed to on another item is not this item's
    // to take back. ADR-0009 decision 5.
    useEffect(() {
      if (acceptInFlight) {
        return null;
      }

      if (!focusWasHere.value) {
        return null;
      }
      focusWasHere.value = false;

      // `hasPrimaryFocus`, not `hasFocus`: disabling the control hands the
      // focus up to this scope node itself, so holding it *directly* is what
      // "nothing has claimed it since" looks like. A control that holds it
      // instead — Cancel on this very item, or a control on another one — is
      // the user's choice and not this item's to take back.
      if (!itemFocusScopeNode.hasPrimaryFocus) {
        return null;
      }

      acceptFocusNode.requestFocus();

      return null;
    }, [acceptInFlight]);

    // The item takes the keyboard when it appears, so the request it shows is
    // answerable without reaching for the mouse — but only if it is the item
    // the panel granted it to. An arrival into a panel the user is already
    // working in takes nothing: a control the user has not read must not end
    // up under the next Enter.
    //
    // Restoring the focus the disable takes is a separate rule and lives in
    // the effect above: re-running this on the busy flag would fire it for
    // every item whose attempt ends, including one the user has since tabbed
    // away from.
    useEffect(() {
      if (autofocus) {
        acceptFocusNode.requestFocus();
      }

      return null;
    }, const []);

    return optionNotification.match(() => DPopupWithClose(child: SizedBox()), (
      notification,
    ) {
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

      final defaultStyle =
          notification.type.notificationItemState ==
              NotificationItemState.canceled()
          ? NotificationItemConnectRequestStyle(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: SideSwapColors.indigo.withValues(alpha: 0.5),
              ),
              titleTextStyle: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: Colors.white.withValues(alpha: 0.5)),
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

      return FocusScope(
        node: itemFocusScopeNode,
        child: Container(
          height: notificationItemHeight(
            NotificationItemKind.connect,
            notification.type.notificationItemState,
          ),
          decoration: defaultStyle.decoration ?? itemStyle.decoration,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Connect request'.tr(),
                  style:
                      defaultStyle.titleTextStyle ?? itemStyle.titleTextStyle,
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
                          text: 'Sharing watch-only access (descriptor/xpub and Liquid master blinding key) reveals your full past and future activity for the selected accounts to this site. Only connect to sites you trust.'
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
                      style: Theme.of(context).textTheme.titleSmall
                          ?.copyWith(fontSize: 13),
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
                        },
                        child: Text('Cancel'.tr()),
                      ),
                      DCustomFilledBigButton(
                        width: 160,
                        height: 34,
                        focusNode: acceptFocusNode,
                        onPressed: acceptInFlight
                            ? null
                            : () {
                                // Captured before the ask, not tested after it:
                                // the rebuild that disables this control takes
                                // its focus away in the same turn.
                                // ADR-0009 decision 5.
                                focusWasHere.value =
                                    itemFocusScopeNode.hasFocus;

                                // Unawaited by design. Once the gate is crossed
                                // the widget is no longer a party to the outcome,
                                // and an awaited result would put this element's
                                // survival back on the acceptance path — which is
                                // the defect this moved out of the widget.
                                // ADR-0009 decision 2.
                                unawaited(
                                  ref
                                      .read(signerAcceptanceProvider.notifier)
                                      .accept(
                                        notificationId: notificationId,
                                        reqId: reqId,
                                      ),
                                );
                              },
                        child: Text('Connect'.tr()),
                      ),
                    ],
                  ),
                ],
              ],
            ),
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
        // The body flexes to the declared height through a `Spacer()`, so the
        // wrapper supplies the `Flexible` half only. ADR-0014's floor sweep
        // for this surface is #268.
        scrollOwner: ScrollOwner.child,
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
                      style: Theme.of(context).textTheme.displaySmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const SizedBox(height: 8),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: 'Transaction generated on '.tr(),
                        style: Theme.of(context).textTheme.titleSmall
                            ?.copyWith(color: SideSwapColors.halfBaked),
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
