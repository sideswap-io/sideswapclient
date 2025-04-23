import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';

import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/providers/server_status_providers.dart';
import 'package:sideswap/providers/swap_providers.dart';

class FeeRates extends StatelessWidget {
  const FeeRates({super.key});

  @override
  Widget build(BuildContext context) {
    return SideSwapScaffold(
      canPop: true,
      appBar: CustomAppBar(
        title: 'Fee Suggestions'.tr(),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 32, left: 16, right: 16),
          child: Consumer(
            builder: (context, ref, _) {
              final feeRates = ref.watch(bitcoinFeeRatesProvider);

              if (feeRates.isEmpty) {
                return const SizedBox();
              }

              return ListView.builder(
                itemCount: feeRates.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Container(
                      height: 50,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: SideSwapColors.chathamsBlue,
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8),
                          ),
                          onTap: () {
                            ref
                                .read(
                                  bitcoinCurrentFeeRateNotifierProvider
                                      .notifier,
                                )
                                .setFeeRate(feeRates[index]);
                            Navigator.of(context).pop();
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                ref.read(
                                  bitcoinFeeRateDescriptionProvider(
                                    feeRates[index],
                                  ),
                                ),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
