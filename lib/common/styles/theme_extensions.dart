import 'dart:ui';

import 'package:flutter/material.dart';

class MarketColorsStyle extends ThemeExtension<MarketColorsStyle> {
  final Color? sellColor;
  final Color? buyColor;

  MarketColorsStyle({this.sellColor, this.buyColor});

  @override
  MarketColorsStyle copyWith({Color? sellColor, Color? buyColor}) {
    return MarketColorsStyle(
      sellColor: sellColor ?? this.sellColor,
      buyColor: buyColor ?? this.buyColor,
    );
  }

  @override
  MarketColorsStyle lerp(
    covariant ThemeExtension<MarketColorsStyle>? other,
    double t,
  ) {
    if (other is! MarketColorsStyle) {
      return this;
    }

    return MarketColorsStyle(
      sellColor: Color.lerp(sellColor, other.sellColor, t),
      buyColor: Color.lerp(buyColor, other.buyColor, t),
    );
  }
}

class ColoredContainerStyle extends ThemeExtension<ColoredContainerStyle> {
  ColoredContainerStyle({
    this.backgroundColor,
    this.borderColor,
    this.horizontalPadding,
  });

  final Color? backgroundColor;
  final Color? borderColor;
  final double? horizontalPadding;

  @override
  ColoredContainerStyle copyWith({
    Color? backgroundColor,
    Color? borderColor,
    double? horizontalPadding,
  }) {
    return ColoredContainerStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderColor: borderColor ?? this.borderColor,
      horizontalPadding: horizontalPadding ?? this.horizontalPadding,
    );
  }

  @override
  ColoredContainerStyle lerp(
    covariant ThemeExtension<ColoredContainerStyle>? other,
    double t,
  ) {
    if (other is! ColoredContainerStyle) {
      return this;
    }

    return ColoredContainerStyle(
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

class MarketAssetRowStyle extends ThemeExtension<MarketAssetRowStyle> {
  MarketAssetRowStyle({
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
  MarketAssetRowStyle copyWith({
    TextStyle? labelStyle,
    TextStyle? errorLabelStyle,
    TextStyle? amountStyle,
    TextStyle? errorAmountStyle,
    TextStyle? tickerStyle,
    TextStyle? errorTickerStyle,
    TextStyle? conversionStyle,
  }) {
    return MarketAssetRowStyle(
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
  MarketAssetRowStyle lerp(
    covariant ThemeExtension<MarketAssetRowStyle>? other,
    double t,
  ) {
    if (other is! MarketAssetRowStyle) {
      return this;
    }

    return MarketAssetRowStyle(
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
