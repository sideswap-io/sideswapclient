import 'package:flutter/material.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/models/markets_provider.dart';
import 'package:sideswap/screens/markets/widgets/order_item.dart';

class FilledRequestsPage extends StatefulWidget {
  const FilledRequestsPage({
    Key? key,
    required this.requests,
  }) : super(key: key);

  final List<RequestOrder> requests;

  @override
  _FilledRequestsPageState createState() => _FilledRequestsPageState();
}

class _FilledRequestsPageState extends State<FilledRequestsPage> {
  late ScrollController scrollController;
  bool isScrollbarVisible = false;
  final listViewKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    WidgetsBinding.instance?.addPostFrameCallback((_) => afterBuild(context));
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void afterBuild(BuildContext context) async {
    shouldDisplayScrollbar();
  }

  void shouldDisplayScrollbar() {
    final renderBox = listViewKey.currentContext?.findRenderObject();
    if (renderBox != null) {
      if (widget.requests.length * 210.h >
          (renderBox as RenderBox).size.height) {
        setState(() {
          isScrollbarVisible = true;
        });
      } else {
        setState(() {
          isScrollbarVisible = false;
        });
      }
    }
  }

  @override
  void didUpdateWidget(covariant FilledRequestsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // refresh scrollbar when requests size changed
    final newListSize = widget.requests.length;
    final oldListSize = oldWidget.requests.length;
    if (newListSize != oldListSize) {
      final oldOffset = scrollController.offset;
      scrollController.animateTo(oldOffset,
          duration: const Duration(milliseconds: 1), curve: Curves.linear);
      shouldDisplayScrollbar();
    }
  }

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 16.h),
                      child: SizedBox(
                        height: 100,
                        child: RawScrollbar(
                          isAlwaysShown: isScrollbarVisible,
                          thickness: 3,
                          radius: Radius.circular(2.r),
                          controller: scrollController,
                          thumbColor: const Color(0xFF78AECC),
                          child: ListView.builder(
                            key: listViewKey,
                            controller: scrollController,
                            shrinkWrap: true,
                            itemCount: widget.requests.length,
                            itemBuilder: (context, index) {
                              return widget.requests[index].requestOrderType ==
                                      RequestOrderType.order
                                  ? Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.w),
                                      child: OrderItem(
                                        requestOrder: widget.requests[index],
                                      ),
                                    )
                                  : Container();
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// TODO: add for user request payment
// RequestPaymentItem(
//     request: requests[index],
//     onCancelPressed: () {
//       context.read(utilsProvider).settingsErrorDialog(
//             title: 'REQUEST_REMOVE_QUESTION'.tr(args: [
//               (requests[index].friend.contact.name)
//             ]),
//             buttonText: 'YES'.tr(),
//             secondButtonText: 'NO'.tr(),
//             onPressed: (context) {
//               context
//                   .read(paymentRequestsProvider)
//                   .removeRequest(requests[index]);
//               Navigator.of(context).pop();
//             },
//             onSecondPressed: (context) {
//               Navigator.of(context).pop();
//             },
//           );
//     },
//   ),
