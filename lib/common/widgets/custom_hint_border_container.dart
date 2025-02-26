import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class _CustomHintBorderContainerPainter extends CustomPainter {
  _CustomHintBorderContainerPainter({
    required Color color,
    required this.textWidth,
    this.radius = 0,
    this.left = 0,
    this.strokeWidth = 2,
  }) : painter =
           Paint()
             ..style = PaintingStyle.stroke
             ..strokeWidth = strokeWidth
             ..color = color;

  final Paint painter;
  final double radius;
  final double textWidth;
  final double left;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final leftShift =
        left > (size.width - textWidth) ? (size.width - textWidth) : left;
    var path = Path();

    path.moveTo((leftShift + textWidth), 0);

    path.lineTo(size.width - radius, 0);
    path.cubicTo(size.width - radius, 0, size.width, 0, size.width, radius);
    path.lineTo(size.width, size.height - radius);
    path.cubicTo(
      size.width,
      size.height - radius,
      size.width,
      size.height,
      size.width - radius,
      size.height,
    );

    path.lineTo(radius, size.height);
    path.cubicTo(radius, size.height, 0, size.height, 0, size.height - radius);

    path.lineTo(0, radius);
    path.cubicTo(0, radius, 0, 0, radius, 0);
    path.lineTo(leftShift, 0);

    canvas.drawPath(path, painter);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}

class CustomHintBorderContainer extends HookConsumerWidget {
  const CustomHintBorderContainer({
    required this.width,
    required this.height,
    required this.title,
    this.color = Colors.black12,
    this.radius,
    this.textStyle,
    this.strokeWidth = 2,
    this.left = 20,
    this.child,
    super.key,
  });

  final Color color;
  final double width;
  final double height;
  final String title;
  final double? radius;
  final TextStyle? textStyle;
  final double strokeWidth;
  final double left;
  final Widget? child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textKey = useMemoized(() => GlobalKey());
    final textWidth = useState(0.0);
    final textHeight = useState(0.0);

    Future(() {
      if (textKey.currentContext != null) {
        final box = textKey.currentContext!.findRenderObject() as RenderBox;
        textHeight.value = box.size.height;
        textWidth.value = box.size.width;
      }
    });

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        CustomPaint(
          painter: _CustomHintBorderContainerPainter(
            color: color,
            textWidth: textWidth.value,
            radius: radius ?? 0,
            left: left,
            strokeWidth: strokeWidth,
          ),
          child: SizedBox(height: height, width: width, child: child),
        ),
        Positioned(
          top: -textHeight.value / 2,
          left: left,
          child: Padding(
            key: textKey,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(title, style: textStyle),
          ),
        ),
      ],
    );
  }
}
