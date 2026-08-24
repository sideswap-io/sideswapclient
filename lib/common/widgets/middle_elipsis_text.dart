import 'package:flutter/material.dart';

class MiddleEllipsisText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign textAlign;
  final int? maxLines;
  final bool? softWrap;

  const MiddleEllipsisText({
    super.key,
    required this.text,
    this.style,
    this.textAlign = TextAlign.start,
    this.maxLines = 1,
    this.softWrap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final textPainter = TextPainter(
          text: TextSpan(text: text, style: style),
          maxLines: maxLines,
          textDirection: Directionality.of(context),
          textAlign: textAlign,
        )..layout(minWidth: 0, maxWidth: constraints.maxWidth);

        if (!textPainter.didExceedMaxLines) {
          return Text(
            text,
            style: style,
            textAlign: textAlign,
            maxLines: maxLines,
            softWrap: softWrap,
          );
        }

        final chars = text.characters.toList();
        int lo = 0, hi = chars.length ~/ 2;
        while (lo < hi) {
          final mid = (lo + hi + 1) >> 1;
          final candidate =
              '${chars.take(mid).join()}…${chars.skip(chars.length - mid).join()}';
          final tp = TextPainter(
            text: TextSpan(text: candidate, style: style),
            textDirection: Directionality.of(context),
            maxLines: 1,
          )..layout(minWidth: 0, maxWidth: double.infinity);
          if (tp.width <= constraints.maxWidth) {
            lo = mid;
          } else {
            hi = mid - 1;
          }
        }

        final truncated = lo > 0
            ? '${chars.take(lo).join()}…${chars.skip(chars.length - lo).join()}'
            : '…';

        return Text(
          truncated,
          style: style,
          textAlign: textAlign,
          maxLines: 1,
          softWrap: softWrap,
        );
      },
    );
  }
}
