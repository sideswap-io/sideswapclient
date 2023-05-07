import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/providers/contact_provider.dart';
import 'package:sideswap/providers/payment_requests_provider.dart';
import 'package:sideswap/protobuf/sideswap.pb.dart' show Contact;

final friendsProvider =
    ChangeNotifierProvider<FriendsProvider>((ref) => FriendsProvider(ref));

class Friend {
  Contact contact;

  Friend({
    required this.contact,
    int? backgroundColor,
    this.avatar,
  }) : _backgroundColor = backgroundColor;

  final int? _backgroundColor;
  int get backgroundColor {
    return _backgroundColor ?? FriendsProvider.generateBackgroundColor(this);
  }

  final String? avatar;

  Friend copyWith({
    Contact? contact,
    int? backgroundColor,
    String? avatar,
  }) {
    return Friend(
      contact: contact ?? this.contact,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      avatar: avatar ?? this.avatar,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Friend &&
        other.contact == contact &&
        other._backgroundColor == _backgroundColor &&
        other.avatar == avatar;
  }

  @override
  int get hashCode =>
      contact.name.hashCode ^
      contact.phone.hashCode ^
      _backgroundColor.hashCode ^
      avatar.hashCode;
}

class FriendsProvider with ChangeNotifier {
  final Ref ref;

  FriendsProvider(this.ref) {
    ref.read(contactProvider).friendsLoadedData.listen((value) {
      friends.clear();
      friends.addAll(value);
      ref.read(paymentRequestsProvider).createFakeRequests();
      notifyListeners();
    });
  }

  List<Friend> friends = <Friend>[];

  Friend? getFriendByName(String name) {
    if (name.length < 3) {
      return null;
    }

    final index = friends.indexWhere(
        (e) => e.contact.name.toLowerCase().contains(name.toLowerCase()));
    if (index < 0) {
      return null;
    }

    return friends[index];
  }

  List<Friend> getFriendListByName(String searchString) {
    return friends
        .where((e) =>
            e.contact.name.toLowerCase().contains(searchString.toLowerCase()))
        .toList();
  }

  String getInitials(Contact contact) {
    if (contact.name.isEmpty) {
      return ' ';
    }

    final nameArray =
        contact.name.replaceAll(RegExp(r'\s+\b|\b\s'), ' ').split(' ');
    final initials = ((nameArray[0])[0]) +
        (nameArray.length == 1
            ? (nameArray[0][1])
            : (nameArray[nameArray.length - 1])[0]);

    return initials.toUpperCase();
  }

  Image? getAvatar(Friend friend) {
    Image? avatarImage;
    if (friend.avatar != null && friend.avatar!.isNotEmpty) {
      final bytes = base64Decode(friend.avatar ?? '');
      avatarImage = Image.memory(bytes);
    }

    return avatarImage;
  }

  static int generateBackgroundColor(Friend friend) {
    return Colors.primaries[friend.hashCode % Colors.primaries.length].value;
  }
}
