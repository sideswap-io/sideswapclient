import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/providers/swap_providers.dart';
import 'package:sideswap/screens/swap/fee_suggestions.dart';

class FeeRatesDropdown extends StatelessWidget {
  const FeeRatesDropdown({super.key, this.borderDecoration});

  final BoxDecoration? borderDecoration;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        onTap: () async {
          await Navigator.of(context).push(
            RawDialogRoute<Widget>(pageBuilder: (_, _, _) => FeeRatesDialog()),
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
                  final optionCurrentFeeRate = ref.watch(
                    bitcoinCurrentFeeRateProvider,
                  );

                  return optionCurrentFeeRate.match(
                    () => const SizedBox(),
                    (feeRate) => Text(
                      'Fee rate: {} sat/vbyte'.tr(args: ['$feeRate']),
                      overflow: TextOverflow.clip,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                  );
                }),
              ),
              const Icon(Icons.keyboard_arrow_down, size: 16),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }
}
