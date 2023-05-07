import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/models/swap_models.dart';
import 'package:sideswap/providers/swap_provider.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap/screens/swap/fee_suggestions.dart';

class FeeRatesDropdown extends StatelessWidget {
  const FeeRatesDropdown({
    super.key,
    this.borderDecoration,
  });

  final BoxDecoration? borderDecoration;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        onTap: () {
          Widget builder(BuildContext context) {
            return const FeeRates();
          }

          Navigator.of(context, rootNavigator: true).push<void>(
            FlavorConfig.isDesktop
                ? DialogRoute(builder: builder, context: context)
                : MaterialPageRoute(builder: builder),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 8),
              Consumer(
                builder: ((context, ref, child) {
                  final currentFeeRate =
                      ref.watch(bitcoinCurrentFeeRateStateNotifierProvider);
                  if (currentFeeRate is SwapCurrentFeeRateData) {
                    return Text(
                      ref
                          .read(bitcoinFeeRatesProvider)
                          .feeRateDescription(currentFeeRate.feeRate),
                      overflow: TextOverflow.clip,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    );
                  }
                  return Container();
                }),
              ),
              const Icon(
                Icons.keyboard_arrow_down,
                size: 16,
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }
}
