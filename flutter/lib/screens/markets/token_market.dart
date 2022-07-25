import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/models/markets_provider.dart';
import 'package:sideswap/models/token_market_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/markets/token_market_order_details.dart';
import 'package:sideswap/screens/markets/widgets/order_item.dart';

class TokenMarket extends ConsumerStatefulWidget {
  const TokenMarket({super.key});

  @override
  TokenMarketState createState() => TokenMarketState();
}

class TokenMarketState extends ConsumerState<TokenMarket> {
  late TokenMarketDropdownValue currentDropdownValue;
  final tokenRequestOrders = <RequestOrder>[];
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    currentDropdownValue = ref
        .read(tokenMarketProvider)
        .getDropdownValues()
        .where((e) => e.assetId.isEmpty)
        .first;

    tokenRequestOrders.addAll(ref
        .read(tokenMarketProvider)
        .getTokenList(currentDropdownValue.assetId));

    WidgetsBinding.instance.addPostFrameCallback((_) => afterBuild(context));
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void afterBuild(BuildContext context) async {
    subscribeToMarket();
  }

  void subscribeToMarket() {
    ref.read(marketsProvider).subscribeTokenMarket();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Text(
              'Assets'.tr(),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Color(0xFF00C5FF),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 16, right: 16),
            child: Consumer(
              builder: (context, ref, child) {
                final values =
                    ref.watch(tokenMarketProvider).getDropdownValues();
                if (!values.any((e) => e == currentDropdownValue)) {
                  currentDropdownValue =
                      values.where((e) => e.assetId.isEmpty).first;
                }

                // TODO: (somewhere in future) think how to resize width of popup menu and draw it below the line

                // return PopupMenuButton<TokenMarketDropdownValue>(
                //   padding: EdgeInsets.zero,
                //   enableFeedback: false,
                //   color: const Color(0xFF1E6389),
                //   offset: Offset(0, 26.h),
                //   elevation: 8,
                //   child: SizedBox(
                //     width: 400.w,
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       children: [
                //         Text(
                //           currentDropdownValue.name,
                //           style: const TextStyle(
                //             fontSize: 20.sp,
                //             fontWeight: FontWeight.normal,
                //             color: Colors.white,
                //           ),
                //         ),
                //         const Icon(Icons.arrow_drop_down),
                //       ],
                //     ),
                //   ),
                //   itemBuilder: (context) {
                //     return values
                //         .map((e) => PopupMenuItem<TokenMarketDropdownValue>(
                //               value: e,
                //               child: SizedBox(
                //                 width: 400.w,
                //                 child: Text(
                //                   e.name,
                //                   style: const TextStyle(
                //                     fontSize: 20.sp,
                //                     fontWeight: FontWeight.normal,
                //                     color: Colors.white,
                //                   ),
                //                 ),
                //               ),
                //             ))
                //         .toList();
                //   },
                //   onSelected: (value) {
                //     setState(() {
                //       currentDropdownValue = value;
                //     });
                //   },
                // );

                final items = values
                    .map((e) => DropdownMenuItem<TokenMarketDropdownValue>(
                        value: e, child: Text(e.name)))
                    .toList();

                return DropdownButtonHideUnderline(
                  child: DropdownButton<TokenMarketDropdownValue>(
                    value: currentDropdownValue,
                    items: items,
                    isExpanded: true,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                    dropdownColor: const Color(0xFF2B6F95),
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }

                      setState(() {
                        currentDropdownValue = value;
                      });
                    },
                  ),
                );
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 4, left: 16, right: 16),
            child: Divider(
              thickness: 1,
              height: 1,
              color: Color(0xFF2B6F95),
            ),
          ),
          Consumer(
            builder: (context, ref, child) {
              ref.watch(tokenMarketProvider).tokenMarketOrders;
              final newTokenMarketOrders = ref
                  .read(tokenMarketProvider)
                  .getTokenList(currentDropdownValue.assetId);
              tokenRequestOrders.clear();
              tokenRequestOrders.addAll(newTokenMarketOrders);
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: RawScrollbar(
                    thumbVisibility: true,
                    thickness: 3,
                    radius: const Radius.circular(2),
                    controller: scrollController,
                    thumbColor: const Color(0xFF78AECC),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: ListView.builder(
                        controller: scrollController,
                        shrinkWrap: true,
                        itemCount: tokenRequestOrders.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: OrderItem(
                              requestOrder: tokenRequestOrders[index],
                              useTokenMarketView: true,
                              onTap: () {
                                if (tokenRequestOrders[index].own) {
                                  ref.read(walletProvider).setOrderRequestView(
                                      tokenRequestOrders[index]);
                                  return;
                                }

                                Navigator.of(context, rootNavigator: true)
                                    .push<void>(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        TokenMarketOrderDetails(
                                      requestOrder: tokenRequestOrders[index],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
