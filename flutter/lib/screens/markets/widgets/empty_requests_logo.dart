import 'package:flutter/material.dart';
import 'package:sideswap/screens/markets/widgets/empty_requests_logo_container.dart';

class EmptyRequestsLogo extends StatelessWidget {
  const EmptyRequestsLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 238,
      height: 180,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              EmptyRequestsLogoContainer(
                opacity: 0.2,
              ),
              Padding(
                padding: EdgeInsets.only(top: 12),
                child: EmptyRequestsLogoContainer(
                  opacity: 0.2,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(left: 40, top: 48),
            child: EmptyRequestsLogoContainer(
              icon: EmptyRequestLogoIcon.ok,
            ),
          ),
        ],
      ),
    );
  }
}
