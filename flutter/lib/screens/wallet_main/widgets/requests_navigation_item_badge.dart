import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/models/payment_requests_provider.dart';

class RequestsNavigationItemBadge extends StatelessWidget {
  const RequestsNavigationItemBadge({
    super.key,
    required this.backgroundColor,
    required this.itemColor,
    required this.assetName,
  });

  final Color backgroundColor;
  final Color itemColor;
  final String assetName;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        return SizedBox(
          width: 32,
          height: 32,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: SvgPicture.asset(
                  assetName,
                  width: 32,
                ),
              ),
              Consumer(
                builder: (context, ref, _) {
                  final requests = ref.watch(
                      paymentRequestsProvider.select((p) => p.paymentRequests));
                  final length = requests.length;
                  final badgeNumber = length > 99 ? '99+' : '$length';
                  return Visibility(
                    visible: length != 0,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: backgroundColor,
                            width: 2,
                          ),
                          color: itemColor,
                        ),
                        child: Center(
                          child: Text(
                            badgeNumber,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: backgroundColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        );
      },
    );
  }
}
