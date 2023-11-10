import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:sideswap/screens/markets/widgets/empty_requests_logo.dart';

class EmptyRequestsPage extends StatelessWidget {
  const EmptyRequestsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: constraints.maxWidth,
              minHeight: constraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Center(
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 67),
                      child: EmptyRequestsLogo(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 43),
                      child: Text(
                        'No working orders'.tr(),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
