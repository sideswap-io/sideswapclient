// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

import 'package:flutter/material.dart';

class OrderRowElementTheme extends ThemeExtension<OrderRowElementTheme> {
  const OrderRowElementTheme({required this.padding, required this.textColor});

  final EdgeInsetsGeometry padding;
  final Color textColor;

  @override
  OrderRowElementTheme copyWith({
    EdgeInsetsGeometry? padding,
    Color? textColor,
  }) {
    return OrderRowElementTheme(
      padding: padding ?? this.padding,
      textColor: textColor ?? this.textColor,
    );
  }

  @override
  OrderRowElementTheme lerp(
    ThemeExtension<OrderRowElementTheme> other,
    double t,
  ) {
    if (other is! OrderRowElementTheme) {
      return this;
    }

    return OrderRowElementTheme(
      padding:
          EdgeInsetsGeometry.lerp(padding, other.padding, t) ?? EdgeInsets.zero,
      textColor: Color.lerp(textColor, other.textColor, t) ?? Colors.white,
    );
  }
}

class MarketColorsTheme extends ThemeExtension<MarketColorsTheme> {
  final Color? sellColor;
  final Color? buyColor;

  MarketColorsTheme({this.sellColor, this.buyColor});

  @override
  MarketColorsTheme copyWith({Color? sellColor, Color? buyColor}) {
    return MarketColorsTheme(
      sellColor: sellColor ?? this.sellColor,
      buyColor: buyColor ?? this.buyColor,
    );
  }

  @override
  MarketColorsTheme lerp(
    covariant ThemeExtension<MarketColorsTheme>? other,
    double t,
  ) {
    if (other is! MarketColorsTheme) {
      return this;
    }

    return MarketColorsTheme(
      sellColor: Color.lerp(sellColor, other.sellColor, t),
      buyColor: Color.lerp(buyColor, other.buyColor, t),
    );
  }
}

class ColoredContainerTheme extends ThemeExtension<ColoredContainerTheme> {
  ColoredContainerTheme({
    this.backgroundColor,
    this.borderColor,
    this.horizontalPadding,
  });

  final Color? backgroundColor;
  final Color? borderColor;
  final double? horizontalPadding;

  @override
  ColoredContainerTheme copyWith({
    Color? backgroundColor,
    Color? borderColor,
    double? horizontalPadding,
  }) {
    return ColoredContainerTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderColor: borderColor ?? this.borderColor,
      horizontalPadding: horizontalPadding ?? this.horizontalPadding,
    );
  }

  @override
  ColoredContainerTheme lerp(
    covariant ThemeExtension<ColoredContainerTheme>? other,
    double t,
  ) {
    if (other is! ColoredContainerTheme) {
      return this;
    }

    return ColoredContainerTheme(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      borderColor: Color.lerp(borderColor, other.borderColor, t),
      horizontalPadding: lerpDouble(
        horizontalPadding,
        other.horizontalPadding,
        t,
      ),
    );
  }
}

class MarketAssetRowTheme extends ThemeExtension<MarketAssetRowTheme> {
  MarketAssetRowTheme({
    this.labelStyle,
    this.errorLabelStyle,
    this.amountStyle,
    this.errorAmountStyle,
    this.tickerStyle,
    this.errorTickerStyle,
    this.conversionStyle,
  });

  final TextStyle? labelStyle;
  final TextStyle? errorLabelStyle;
  final TextStyle? amountStyle;
  final TextStyle? errorAmountStyle;
  final TextStyle? tickerStyle;
  final TextStyle? errorTickerStyle;
  final TextStyle? conversionStyle;

  @override
  MarketAssetRowTheme copyWith({
    TextStyle? labelStyle,
    TextStyle? errorLabelStyle,
    TextStyle? amountStyle,
    TextStyle? errorAmountStyle,
    TextStyle? tickerStyle,
    TextStyle? errorTickerStyle,
    TextStyle? conversionStyle,
  }) {
    return MarketAssetRowTheme(
      labelStyle: labelStyle ?? this.labelStyle,
      errorLabelStyle: errorLabelStyle ?? this.errorAmountStyle,
      amountStyle: amountStyle ?? this.amountStyle,
      errorAmountStyle: errorAmountStyle ?? this.errorAmountStyle,
      tickerStyle: tickerStyle ?? this.tickerStyle,
      errorTickerStyle: errorTickerStyle ?? this.errorTickerStyle,
      conversionStyle: conversionStyle ?? this.conversionStyle,
    );
  }

  @override
  MarketAssetRowTheme lerp(
    covariant ThemeExtension<MarketAssetRowTheme>? other,
    double t,
  ) {
    if (other is! MarketAssetRowTheme) {
      return this;
    }

    return MarketAssetRowTheme(
      labelStyle: TextStyle.lerp(labelStyle, other.labelStyle, t),
      errorLabelStyle: TextStyle.lerp(
        errorLabelStyle,
        other.errorLabelStyle,
        t,
      ),
      amountStyle: TextStyle.lerp(amountStyle, other.amountStyle, t),
      errorAmountStyle: TextStyle.lerp(
        errorAmountStyle,
        other.errorAmountStyle,
        t,
      ),
      tickerStyle: TextStyle.lerp(tickerStyle, other.tickerStyle, t),
      errorTickerStyle: TextStyle.lerp(
        errorTickerStyle,
        other.errorTickerStyle,
        t,
      ),
      conversionStyle: TextStyle.lerp(
        conversionStyle,
        other.conversionStyle,
        t,
      ),
    );
  }
}
