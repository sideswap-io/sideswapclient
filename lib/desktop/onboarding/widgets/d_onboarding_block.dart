import 'package:flutter/material.dart';

/// The design height of the onboarding illustration block.
const double kDOnboardingBlockHeight = 640;

/// The gap the block keeps above itself at every window height.
const double kDOnboardingBlockGap = 24;

/// Centres a [kDOnboardingBlockHeight] block vertically without letting it
/// touch the top of the page.
///
/// The symmetric padding makes the gap above the block
/// `max(kDOnboardingBlockGap, (height - kDOnboardingBlockHeight) / 2)`: it is
/// [kDOnboardingBlockGap] at the supported floor of 620 px and the unchanged
/// 100 px at the design height of 840 px.
///
/// The block never grows to make room. It is `min(kDOnboardingBlockHeight,
/// height - 2 * kDOnboardingBlockGap)`, so below a height of
/// `kDOnboardingBlockHeight + 2 * kDOnboardingBlockGap` its consumers lose
/// 48 px of vertical room. Both consumer columns measure under the 572 px this
/// leaves at the supported floor -- 535 px for `DPinWelcome` and 541 px for
/// `DNewWalletBackupPrompt` -- so nothing overflows there. Below the floor no
/// desktop surface fits, which ADR-0014 decision 6 accepts.
class DOnboardingBlock extends StatelessWidget {
  const DOnboardingBlock({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDOnboardingBlockGap),
      child: Center(
        child: SizedBox(height: kDOnboardingBlockHeight, child: child),
      ),
    );
  }
}
