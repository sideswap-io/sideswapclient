import 'package:flutter/material.dart';
import 'package:sideswap/screens/markets/widgets/empty_requests_logo_container.dart';

class EmptyRequestsLogo extends StatelessWidget {
  const EmptyRequestsLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EmptyRequestsLogoContainer(opacity: 0.2),
            SizedBox(height: 12),
            EmptyRequestsLogoContainer(opacity: 0.2),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(left: 40, top: 48),
          child: EmptyRequestsLogoContainer(),
        ),
      ],
    );
  }
}
