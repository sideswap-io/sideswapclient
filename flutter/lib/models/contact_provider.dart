import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_contacts/flutter_contacts.dart' as flutter_contacts;
import 'package:image/image.dart' as image;
import 'package:rxdart/subjects.dart';

import 'package:sideswap/common/utils/custom_logger.dart';
import 'package:sideswap/common_platform.dart';
import 'package:sideswap/models/friends_provider.dart';
import 'package:sideswap/models/utils_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/protobuf/sideswap.pb.dart';

enum ContactsLoadingState {
  idle,
  running,
  done,
}

final contactProvider =
    ChangeNotifierProvider<ContactProvider>((ref) => ContactProvider(ref));

class ContactProvider with ChangeNotifier {
  ContactProvider(this.ref) {
    percentageLoaded.listen((value) {
      logger.d('Loaded $value %');
    });
  }

  final Ref ref;

  final BehaviorSubject<int> percentageLoaded = BehaviorSubject();
  final BehaviorSubject<List<Friend>> friendsLoadedData = BehaviorSubject();

  List<Friend> friendsData = <Friend>[];
  ContactsLoadingState contactsLoadingState = ContactsLoadingState.idle;

  Future<void> loadContacts() async {
    if (contactsLoadingState != ContactsLoadingState.idle) {
      return;
    }

    contactsLoadingState = ContactsLoadingState.idle;
    notifyListeners();

    var hasContactPermission = await commonPlatform.hasContactPermission();
    if (!hasContactPermission) {
      hasContactPermission = await commonPlatform.requestContactPermission();
    }

    if (!hasContactPermission) {
      return;
    }

    contactsLoadingState = ContactsLoadingState.running;
    notifyListeners();

    percentageLoaded.add(0);
    friendsData.clear();

    final lightContacts = await flutter_contacts.FlutterContacts.getContacts();
    final total = lightContacts.length;
    var counter = 0;

    var uploadContacts = To_UploadContacts();

    for (var i = 0; i < total; i++) {
      final contact = await flutter_contacts.FlutterContacts.getContact(
          lightContacts[i].id);
      if (contact == null) {
        continue;
      }

      if (contact.phones.isNotEmpty) {
        for (var i = 0; i < contact.phones.length; i++) {
          addContactToLocalList(
            contact.phones[i].normalizedNumber,
            contact.displayName,
            contact.thumbnail,
          );
        }
      }

      final identifier = contact.id;
      final displayName = contact.displayName;

      var uploadContact = UploadContact();
      uploadContact.identifier = identifier;
      uploadContact.name = displayName;
      for (final phone in contact.phones) {
        uploadContact.phones.add(phone.normalizedNumber);
      }
      if (uploadContact.phones.isNotEmpty) {
        uploadContacts.contacts.add(uploadContact);
      }

      counter++;
      percentageLoaded.add(counter * 100 ~/ total);
    }

    ref.read(walletProvider).uploadDeviceContacts(uploadContacts);
    friendsLoadedData.add(friendsData);
  }

  void addContactToLocalList(
    String? phone,
    String? displayName,
    Uint8List? avatar,
  ) {
    if (phone == null || displayName == null) {
      return;
    }

    phone = phone.replaceAll(' ', '');

    try {
      // intentional used
      // ignore: unused_local_variable
      final contact = friendsData.firstWhere((e) => e.contact.phone == phone);
    } on StateError {
      // contact not found
      if (phone.isNotEmpty &&
          displayName.isNotEmpty &&
          !phone.startsWith('*')) {
        // ignore: unused_local_variable
        String? avatarString;
        if (avatar != null) {
          final img = image.decodeImage(avatar);
          if (img != null) {
            final jpgBytes = image.encodeJpg(img);
            avatarString = base64Encode(jpgBytes);
          }
        }

        final contactData = Contact();
        contactData.phone = phone;
        contactData.name = displayName;
        var friendData = Friend(contact: contactData, avatar: avatarString);
        friendsData.add(friendData);
      }
    }
  }

  void onError({String error = ''}) async {
    logger.d('Import contacts onError');
    await ref
        .read(utilsProvider)
        .showErrorDialog('Error importing contacts: $error'.tr());

    contactsLoadingState = ContactsLoadingState.done;
    notifyListeners();

    _onIdle();
  }

  void onDone() {
    logger.d('Import contacts onDone');
    contactsLoadingState = ContactsLoadingState.done;
    notifyListeners();

    _onIdle();
  }

  void _onIdle() {
    Future<void>.delayed(const Duration(milliseconds: 500), () {
      contactsLoadingState = ContactsLoadingState.idle;
    });
  }
}
