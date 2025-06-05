import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/providers/receive_address_providers.dart';

class WrappedAddressReceive extends StatelessWidget {
  const WrappedAddressReceive({
    super.key,
    required this.wrapText,
    required this.receiveAddress,
  });

  final bool wrapText;
  final ReceiveAddress receiveAddress;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...switch (wrapText) {
          true => [
            Wrap(
              spacing: 5,
              children: receiveAddress.recvAddressList.mapIndexed((
                index,
                item,
              ) {
                final length = receiveAddress.recvAddressList.length;
                final color =
                    [0, 1, length - 2, length - 1].any((e) => e == index)
                    ? SideSwapColors.brightTurquoise
                    : DefaultTextStyle.of(context).style.color ?? Colors.white;

                return Text(
                  item,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: color,
                  ),
                );
              }).toList(),
            ),
          ],
          _ => [
            SelectableText(
              receiveAddress.recvAddress,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
            ),
          ],
        },
      ],
    );
  }
}
