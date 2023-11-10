import 'package:flutter/material.dart';
import 'package:sideswap/common/sideswap_colors.dart';

class SideSwapProgressBar extends StatefulWidget {
  const SideSwapProgressBar({
    super.key,
    this.percent = 0,
    this.displayText = true,
    this.duration = const Duration(milliseconds: 500),
    this.text,
  });

  final int percent;
  final bool displayText;
  final Duration duration;
  final String? text;

  @override
  SideSwapProgressBarState createState() => SideSwapProgressBarState();
}

class SideSwapProgressBarState extends State<SideSwapProgressBar> {
  final _containerKey = GlobalKey();
  double _maxWidth = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => afterBuild(context));
  }

  void afterBuild(BuildContext context) {
    setState(() {
      _maxWidth = getMaxWidth();
    });
  }

  double getMaxWidth() {
    final renderBox = _containerKey.currentContext?.findRenderObject();
    if (renderBox == null) {
      return 0;
    }

    return (renderBox as RenderBox).size.width;
  }

  @override
  Widget build(BuildContext context) {
    Future.microtask(() {
      _maxWidth = getMaxWidth();
    });

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Container(
            key: _containerKey,
            height: 4,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(2)),
              color: Colors.white,
            ),
            child: Row(
              children: [
                if (_maxWidth != 0) ...[
                  AnimatedContainer(
                    duration: widget.duration,
                    width: _maxWidth * (widget.percent / 100),
                    height: 8,
                    decoration: const BoxDecoration(
                      color: SideSwapColors.brightTurquoise,
                      borderRadius: BorderRadius.all(Radius.circular(2)),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Visibility(
            visible: widget.displayText,
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                widget.text ?? '${widget.percent} %',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
