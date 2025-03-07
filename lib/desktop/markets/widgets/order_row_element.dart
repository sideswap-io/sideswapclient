import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/markets/widgets/order_item.dart';
import 'package:sideswap/providers/orders_panel_provider.dart';

class OrderRowElement extends ConsumerWidget {
  const OrderRowElement({
    required this.index,
    required this.orders,
    required this.text,
    this.style,
    super.key,
  });

  final int index;
  final Iterable<InternalUiOrder> orders;
  final String text;
  final OrderRowElementStyle? style;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final defaultStyle =
        style ?? Theme.of(context).extension<OrderRowElementStyle>()!;

    return (index == 0 && orders.isEmpty)
        ? Padding(
          padding: defaultStyle.padding,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              'No active bids'.tr(),
              style: TextStyle(color: defaultStyle.textColor),
            ),
          ),
        )
        : OrderItem(order: orders.elementAtOrNull(index));
  }
}

class OrderRowElementStyle extends ThemeExtension<OrderRowElementStyle> {
  const OrderRowElementStyle({required this.padding, required this.textColor});

  final EdgeInsetsGeometry padding;
  final Color textColor;

  @override
  OrderRowElementStyle copyWith({
    EdgeInsetsGeometry? padding,
    Color? textColor,
  }) {
    return OrderRowElementStyle(
      padding: padding ?? this.padding,
      textColor: textColor ?? this.textColor,
    );
  }

  @override
  OrderRowElementStyle lerp(
    ThemeExtension<OrderRowElementStyle> other,
    double t,
  ) {
    if (other is! OrderRowElementStyle) {
      return this;
    }

    return OrderRowElementStyle(
      padding:
          EdgeInsetsGeometry.lerp(padding, other.padding, t) ?? EdgeInsets.zero,
      textColor: Color.lerp(textColor, other.textColor, t) ?? Colors.white,
    );
  }
}
