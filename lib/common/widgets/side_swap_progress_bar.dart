import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sideswap/common/screen_utils.dart';

class SideSwapProgressBar extends StatefulWidget {
  SideSwapProgressBar({
    Key key,
    this.percent = 0,
    this.displayText = true,
    this.duration = const Duration(milliseconds: 500),
    this.text,
  }) : super(key: key);

  final int percent;
  final bool displayText;
  final Duration duration;
  final String text;

  @override
  _SideSwapProgressBarState createState() => _SideSwapProgressBarState();
}

class _SideSwapProgressBarState extends State<SideSwapProgressBar> {
  final _containerKey = GlobalKey();
  double _maxWidth;

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
    final renderBox =
        _containerKey.currentContext.findRenderObject() as RenderBox;
    return renderBox.size.width;
  }

  @override
  Widget build(BuildContext context) {
    Future.microtask(() {
      _maxWidth = getMaxWidth();
    });

    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Container(
            key: _containerKey,
            height: 4.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(2.w)),
              color: Colors.white,
            ),
            child: Row(
              children: [
                if (_maxWidth != null) ...[
                  AnimatedContainer(
                    duration: widget.duration,
                    width: _maxWidth * (widget.percent / 100),
                    height: 8.w,
                    decoration: BoxDecoration(
                      color: Color(0xFF00C5FF),
                      borderRadius: BorderRadius.all(Radius.circular(2.w)),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Visibility(
            visible: widget.displayText,
            child: Padding(
              padding: EdgeInsets.only(top: 12.w),
              child: Text(
                widget.text ?? '${widget.percent} %',
                style: GoogleFonts.roboto(
                  fontSize: 16.sp,
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
