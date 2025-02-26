import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';

class TxDetailsColumn extends StatelessWidget {
  const TxDetailsColumn({
    super.key,
    required this.description,
    required this.details,
    this.isCopyVisible = false,
    TextStyle? descriptionStyle,
    TextStyle? detailsStyle,
  }) : _descriptionStyle =
           descriptionStyle ??
           const TextStyle(
             fontSize: 15,
             fontWeight: FontWeight.w500,
             color: SideSwapColors.brightTurquoise,
           ),
       _detailsStyle =
           detailsStyle ??
           const TextStyle(
             fontSize: 14,
             fontWeight: FontWeight.normal,
             color: Colors.white,
           );

  final String description;
  final String details;
  final bool isCopyVisible;
  final TextStyle _descriptionStyle;
  final TextStyle _detailsStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(description, style: _descriptionStyle),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(child: SelectableText(details, style: _detailsStyle)),
              if (isCopyVisible) ...[
                Padding(
                  padding: const EdgeInsets.only(left: 13),
                  child: SizedBox(
                    width: 26,
                    height: 26,
                    child: TextButton(
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      onPressed: () async {
                        await copyToClipboard(context, details);
                      },
                      child: SvgPicture.asset(
                        'assets/copy.svg',
                        width: 18,
                        height: 18,
                        colorFilter: const ColorFilter.mode(
                          SideSwapColors.brightTurquoise,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
