import 'package:faker/faker.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/models/friends_provider.dart';

//  TODO: remove this provider?

final paymentRequestsProvider = ChangeNotifierProvider<PaymentRequestsProvider>(
    (ref) => PaymentRequestsProvider(ref));

enum PaymentRequestType {
  sent,
  received,
}

class PaymentRequest {
  final PaymentRequestType type;
  final DateTime dateTime;
  final Friend friend;
  final String amount;
  final String assetId;
  final String? message;
  PaymentRequest({
    required this.type,
    required this.dateTime,
    required this.friend,
    required this.amount,
    required this.assetId,
    this.message,
  });

  PaymentRequest copyWith({
    PaymentRequestType? type,
    DateTime? dateTime,
    Friend? friend,
    String? amount,
    String? assetId,
    String? message,
  }) {
    return PaymentRequest(
      type: type ?? this.type,
      dateTime: dateTime ?? this.dateTime,
      friend: friend ?? this.friend,
      amount: amount ?? this.amount,
      assetId: assetId ?? this.assetId,
      message: message ?? this.message,
    );
  }

  @override
  String toString() {
    return 'PaymentRequest(type: $type, dateTime: $dateTime, friend: $friend, amount: $amount, assetId: $assetId, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PaymentRequest &&
        other.type == type &&
        other.dateTime == dateTime &&
        other.friend == friend &&
        other.amount == amount &&
        other.assetId == assetId &&
        other.message == message;
  }

  @override
  int get hashCode {
    return type.hashCode ^
        dateTime.hashCode ^
        friend.hashCode ^
        amount.hashCode ^
        assetId.hashCode ^
        message.hashCode;
  }
}

class PaymentRequestsProvider with ChangeNotifier {
  final Ref ref;

  PaymentRequestsProvider(this.ref);

  List<PaymentRequest> paymentRequests = <PaymentRequest>[];

  void createFakeRequests() {
    final random = RandomGenerator(seed: 63833423);
    final faker = Faker.withGenerator(random);
    for (var i = 0; i < 10; i++) {
      final request = PaymentRequest(
        type:
            i % 2 == 0 ? PaymentRequestType.sent : PaymentRequestType.received,
        amount: random.numberOfLength(14),
        dateTime: faker.date.dateTime(minYear: 2020, maxYear: 2021),
        friend: ref.read(friendsProvider).friends.first,
        assetId:
            'a0682b2b1493596f93cea5f4582df6a900b5e1a491d5ac39dea4bb39d0a45bbf',
        message:
            'Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum ',
      );

      paymentRequests.add(request);
    }
  }

  void removeRequest(PaymentRequest request) {
    paymentRequests.remove(request);
    notifyListeners();
  }
}
