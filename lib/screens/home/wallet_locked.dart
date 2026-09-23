import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/pulsing_dots.dart';

import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/models/connection_models.dart';
import 'package:sideswap/providers/connection_state_providers.dart';
import 'package:sideswap/providers/pin_available_provider.dart';
import 'package:sideswap/providers/wallet.dart';

/// Shown to a wallet that is locked, for both credentials.
///
/// It renders the unlock attempt and only the attempt: while the client is
/// *unlocking* it shows the dots and no affordance, so a second `To_Login`
/// cannot be enqueued. Outside that state it offers an icon, a line of copy and
/// a button that are true for the credential this wallet actually uses.
/// See ADR-0008.
class WalletLocked extends HookConsumerWidget {
  const WalletLocked({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serverLoginState = ref.watch(serverLoginProvider);
    final unlocking = serverLoginState is ServerLoginStateLoginProcessing;

    // The failure is captured, not watched. The root handler invalidates
    // serverLoginProvider one microtask later -- watching the message would
    // render it for a single frame and then lose it (ADR-0008 decision 3).
    //
    // Seeded from the state present at mount: the cold-start path sets
    // Status.lockedWalet and immediately starts an unlock, so this screen can
    // be built with a failure already in the provider, and WidgetRef.listen has
    // no fireImmediately to catch one that arrived before the screen existed.
    final failure = useState<String?>(switch (serverLoginState) {
      ServerLoginStateError(:final message) => _failureMessage(message),
      _ => null,
    });

    // Registered before anything else this build watches. Riverpod closes every
    // ref.listen subscription at the top of a rebuild and reinstates it only
    // when this line runs again, so a ref.watch placed above it opens a window
    // in which a login result would be dropped from the capture.
    //
    // The callback writes hook state, and Riverpod invokes listen callbacks
    // synchronously -- which is safe only because rebuilding serverLoginProvider
    // can only yield `logout`, and the default arm ignores it. A build() that
    // could yield an error or processing state would setState during build.
    ref.listen(serverLoginProvider, (_, next) {
      switch (next) {
        // Cleared only here. The invalidate arrives through this same listener
        // as `logout`, so any broader clear condition would eat the message
        // before the user ever sees it.
        case ServerLoginStateLoginProcessing():
          failure.value = null;
        case ServerLoginStateError(:final message):
          failure.value = _failureMessage(message);
        default:
          break;
      }
    });

    final usePinProtection = ref.watch(pinAvailableProvider);

    void startUnlock() {
      ref.read(walletProvider).unlockWallet();
    }

    return SideSwapScaffold(
      body: SafeArea(
        child: GestureDetector(
          // Inert while unlocking: the transparent Container below makes the
          // whole screen tappable, so hiding the button is not enough.
          onTap: unlocking ? null : startUnlock,
          child: Container(
            color: Colors.transparent,
            child: Center(
              child: Column(
                children: [
                  // The three large gaps shrink; everything else keeps its
                  // size, and UNLOCK is pinned below the flexing part.
                  //
                  // `SideSwapScaffold` puts this screen in a
                  // `DPopupWithClose(height: 605)` on desktop, less 40 px of
                  // its own padding, so the box is 565 px at every window
                  // size. The design column needs 650 px at rest and 592 px
                  // while unlocking, which is where the 85 px and the 27 px
                  // overflows came from. A scroll view would clear the
                  // overflow and hide the copy instead: the label's top edge
                  // would sit 59 px under the fold, and the dots would be off
                  // the box entirely.
                  //
                  // So the gaps yield instead of the content. The screen keeps
                  // its phone layout wherever there is room for it, and
                  // compacts where there is not. The tree shape never switches
                  // on a height threshold, so ADR-0014 decision 10 holds.
                  Expanded(
                    child: Column(
                      children: [
                        _shrinkingGap(92),
                        SizedBox(
                          width: 158,
                          height: 158,
                          child: SvgPicture.asset('assets/logo.svg'),
                        ),
                        if (unlocking) ...[
                          // Placed to land where the dots sit on
                          // PreLaunchPage, which the user was looking at a
                          // moment earlier. The two screens lay out
                          // differently, so this is arithmetic against that
                          // screen's offsets rather than a shared constant,
                          // and it is trued up by making the transition on a
                          // device. It is the gap that yields on a short
                          // screen, so the dots stay on it.
                          _shrinkingGap(332),
                          const PulsingDots(),
                          // The dots are the last thing in this arm, and the
                          // gaps give up the whole shortfall, so without this
                          // they come to rest flush against the popup's
                          // bottom edge. It is the margin UNLOCK carries in
                          // the other arm, and being fixed it takes the same
                          // room out of both screens, so the phone layout the
                          // 332 px is trued up against does not move.
                          const SizedBox(height: 14),
                        ] else ...[
                          _shrinkingGap(236),
                          switch (usePinProtection) {
                            // A PIN wallet has no fingerprint to touch; it
                            // gets the padlock both PIN welcome screens
                            // already use, sized to the box the fingerprint
                            // icon occupied so neither credential shifts the
                            // layout.
                            true => SvgPicture.asset(
                              'assets/locker2.svg',
                              height: 46,
                            ),
                            false => const Icon(
                              Icons.fingerprint,
                              size: 46,
                              color: Color(0xFFC6E8FD),
                            ),
                          },
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Text(
                              switch (usePinProtection) {
                                true => 'Unlock your wallet'.tr(),
                                false => 'Touch to unlock'.tr(),
                              },
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                                color: Color(0xFFC6E8FD),
                              ),
                            ),
                          ),
                          if (failure.value case final String message)
                            Padding(
                              // Inset to the button's margin and bounded: this
                              // is the one string on the screen the client
                              // chooses, so it has no length the layout can
                              // rely on, and the gaps above are the only slack
                              // it has to take.
                              padding: const EdgeInsets.only(
                                top: 16,
                                left: 24,
                                right: 24,
                              ),
                              child: Text(
                                message,
                                textAlign: TextAlign.center,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      color: SideSwapColors.bitterSweet,
                                    ),
                              ),
                            ),
                        ],
                      ],
                    ),
                  ),
                  if (!unlocking)
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 8,
                        bottom: 14,
                        left: 24,
                        right: 24,
                      ),
                      child: CustomBigButton(
                        width: double.maxFinite,
                        height: 54,
                        text: 'UNLOCK'.tr(),
                        onPressed: startUnlock,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A vertical gap of [height] that yields when the column is short.
///
/// A `SizedBox` is tight, but `Flexible(fit: FlexFit.loose)` lays it out
/// against its flex share as a *maximum*, and a tight constraint is clamped to
/// the one it is enforced against. The gap is therefore `min(height, share)`:
/// the design figure wherever the column has room for it, and less where it
/// has not. That is what lets one layout serve both a phone and the 565 px box
/// the desktop popup declares, with no scroll view and no height threshold in
/// the tree.
///
/// The flex *is* [height], so several gaps in one column give up the shortfall
/// in proportion to their design sizes. Equal flex would not do: the free
/// space is split before any gap is clamped, and the room a small gap leaves
/// unused is not handed to a larger one. A 92 px gap and a 332 px gap sharing
/// 632 px equally would take 92 and 316 -- the large one squeezed by 16 px on
/// a screen with 224 px to spare.
///
/// It must stay a direct child of the column that is to yield. `Flexible` is a
/// [ParentDataWidget], so it reaches the column through a widget that builds
/// no render object of its own, but a `Padding` or a `SizedBox` between the
/// two puts the flex on the wrong render object and trips the framework's
/// "Flexible widgets must be placed directly inside Flex widgets" assertion.
Widget _shrinkingGap(double height) => Flexible(
  flex: height.round(),
  fit: FlexFit.loose,
  child: SizedBox(height: height),
);

/// Null and empty are the same failure to the user: the client told us nothing.
/// `'Unknown error'` cannot stand in -- it is parameterised and renders a
/// dangling colon when given nothing.
String _failureMessage(String? message) =>
    (message == null || message.isEmpty)
        ? 'Could not unlock your wallet. Please try again.'.tr()
        : message;
