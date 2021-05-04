import 'package:flutter/material.dart';
import 'package:sideswap/common/screen_utils.dart';

class CustomCheckBox extends StatefulWidget {
  const CustomCheckBox({Key key, this.onChanged, this.child}) : super(key: key);

  final ValueChanged<bool> onChanged;
  final Widget child;

  @override
  _CustomCheckBoxState createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  bool _checked = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _checked = !_checked;
        if (widget.onChanged != null) {
          widget.onChanged(_checked);
        }
        setState(() {});
      },
      child: Container(
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 11.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 36.w,
                height: 36.w,
                child: Center(
                  child: Container(
                    width: 16.w,
                    height: 16.w,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _checked ? Color(0xFFB1EDFF) : Color(0xFF00C5FF),
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(4.w),
                      ),
                      color: _checked ? Color(0xFF00C5FF) : Color(0xFF357CA4),
                    ),
                    child: Center(
                      child: Visibility(
                        visible: _checked,
                        child: Icon(
                          Icons.check,
                          size: 13.w,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              widget.child,
            ],
          ),
        ),
      ),
    );
  }
}
