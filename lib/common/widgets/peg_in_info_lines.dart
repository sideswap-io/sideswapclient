import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/providers/pegs_provider.dart';
import 'package:sideswap/providers/server_status_providers.dart';

/// The bulleted peg-in explainer, shared by the mobile receive screen and the
/// desktop peg dialog.
///
/// The caller owns the container (padding, background) and passes the bullet
/// [bulletSpacing] its platform uses. The conversion-rate row is computed here
/// from the peg-in server fee percent alone -- `100 - percent` -- and hidden
/// when that percent is zero, so both platforms follow the one rule. See
/// ADR-0001, decision 6.
class PegInInfoLines extends ConsumerWidget {
  const PegInInfoLines({
    super.key,
    required this.bulletSpacing,
  });

  final double bulletSpacing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pegRepository = ref.watch(pegRepositoryProvider);
    // Until the server has sent the instant credit limit, render nothing at
    // all -- not an empty bullet list, not a placeholder. A zero default is
    // "not loaded", not a genuine zero limit, and must make no claim. See
    // ADR-0001.
    if (!pegRepository.pegInWalletBalanceLoaded()) {
      return const SizedBox.shrink();
    }
    // Branch on the repository's domain boolean, not the formatted balance.
    final instantCreditAvailable = pegRepository.pegInInstantCreditAvailable();

    // One conversion-rate rule for both platforms: read the peg-in server fee
    // percent directly -- neither the swap type nor the deliver asset -- and
    // hide the row when it is zero (a zero rate says nothing). Prior art: the
    // swap price text likewise returns nothing at a zero server percent.
    final pegInServerFeePercent = ref.watch(pegInServerFeePercentProvider);
    final showConversionRate = pegInServerFeePercent != 0;
    final conversionRateText = (100 - pegInServerFeePercent).toStringAsFixed(2);

    final bodyStyle = Theme.of(context).textTheme.labelMedium?.copyWith(
      fontSize: 13,
      color: SideSwapColors.ceruleanFrost,
    );

    return Column(
      children: [
        _Bullet(child: Text('PEGIN_1STLINE'.tr(), style: bodyStyle)),
        SizedBox(height: bulletSpacing),
        _Bullet(child: Text('PEGIN_2NDLINE'.tr(), style: bodyStyle)),
        // The leading gap belongs to the conversion bullet: it has to collapse
        // with the row, not linger behind it. Its rule is independent of the
        // limit, so it renders in both live states.
        if (showConversionRate) ...[
          SizedBox(height: bulletSpacing),
          _Bullet(
            child: Text(
              'PEGIN_CONVERSION_RATE'.tr(args: [conversionRateText]),
              style: bodyStyle,
            ),
          ),
        ],
        SizedBox(height: bulletSpacing),
        // Available: three amount bullets carrying the limit and 300-sat fee.
        // Unavailable: the standalone sentence plus a fee line. The formatted
        // balance is read only on the available branch.
        if (instantCreditAvailable)
          ..._amountBullets(pegRepository.pegInWalletBalance(), bodyStyle)
        else ...[
          _Bullet(
            child: Text('PEGIN_INSTANT_UNAVAILABLE'.tr(), style: bodyStyle),
          ),
          _Bullet(child: Text('PEGIN_FEE_LINE'.tr(), style: bodyStyle)),
        ],
      ],
    );
  }

  List<Widget> _amountBullets(String walletBalance, TextStyle? bodyStyle) => [
    _AmountBullet(
      prefix: 'PEGIN_LESS'.tr(),
      amount: 'PEGIN_LESS_AMOUNT'.tr(args: [walletBalance]),
      suffix: 'PEGIN_LESS_END'.tr(),
      bodyStyle: bodyStyle,
    ),
    _AmountBullet(
      prefix: 'PEGIN_GREATER'.tr(),
      amount: 'PEGIN_GREATER_AMOUNT'.tr(args: [walletBalance]),
      suffix: 'PEGIN_GREATER_END'.tr(),
      bodyStyle: bodyStyle,
    ),
    _AmountBullet(
      prefix: 'PEGIN_RELEASED'.tr(),
      amount: 'PEGIN_LESS_AMOUNT'.tr(args: [walletBalance]),
      suffix: 'PEGIN_RELEASED_END'.tr(),
      bodyStyle: bodyStyle,
    ),
  ];
}

class _Bullet extends StatelessWidget {
  const _Bullet({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '•',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            fontSize: 13,
            color: SideSwapColors.ceruleanFrost,
          ),
        ),
        const SizedBox(width: 8),
        Flexible(child: child),
      ],
    );
  }
}

/// A bullet whose middle span is a peg-in amount, highlighted in turquoise.
class _AmountBullet extends StatelessWidget {
  const _AmountBullet({
    required this.prefix,
    required this.amount,
    required this.suffix,
    required this.bodyStyle,
  });

  final String prefix;
  final String amount;
  final String suffix;
  final TextStyle? bodyStyle;

  @override
  Widget build(BuildContext context) {
    final amountStyle = bodyStyle?.copyWith(
      color: SideSwapColors.brightTurquoise,
    );

    return _Bullet(
      child: RichText(
        text: TextSpan(
          text: prefix,
          style: bodyStyle,
          children: [
            TextSpan(text: amount, style: amountStyle),
            TextSpan(text: suffix, style: bodyStyle),
          ],
        ),
      ),
    );
  }
}
