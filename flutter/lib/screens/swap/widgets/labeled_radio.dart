import 'package:flutter/material.dart';

class LabeledRadio<T> extends StatelessWidget {
  const LabeledRadio({
    super.key,
    required this.label,
    required this.groupValue,
    required this.value,
    this.onChanged,
  });

  final String label;
  final T groupValue;
  final T value;
  final ValueChanged<T>? onChanged;

  @override
  Widget build(BuildContext context) {
    final textColor =
        (groupValue == value) ? Colors.white : const Color(0xFF709EBA);

    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: InkWell(
        onTap: onChanged == null ? null : () => onChanged!(value),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 22,
              height: 22,
              child: Theme(
                data: Theme.of(context).copyWith(
                  unselectedWidgetColor: const Color(0xFF709EBA),
                ),
                child: Radio<T>(
                  activeColor: const Color(0xFF00C5FF),
                  groupValue: groupValue,
                  value: value,
                  onChanged: onChanged == null
                      ? null
                      : (value) {
                          if (value != null) {
                            onChanged!(value);
                          }
                        },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
