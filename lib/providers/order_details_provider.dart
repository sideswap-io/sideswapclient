import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/screens/order/widgets/order_details.dart';

part 'order_details_provider.g.dart';

@Riverpod(keepAlive: true)
class OrderDetailsDataNotifier extends _$OrderDetailsDataNotifier {
  @override
  OrderDetailsData build() {
    return OrderDetailsData.empty();
  }

  void setOrderDetailsData(OrderDetailsData value) {
    state = value;
  }
}
