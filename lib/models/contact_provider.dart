import 'dart:convert';
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contact/contacts.dart' as flutter_contacts;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:rxdart/subjects.dart';
import 'package:sideswap/common/permission_handler.dart';

import 'package:sideswap/common/utils/custom_logger.dart';
import 'package:sideswap/models/utils_provider.dart';
import 'package:sideswap/models/wallet.dart';

import 'package:image/image.dart' as image;
import 'package:sideswap/protobuf/sideswap.pb.dart';

enum ContactsLoadingState {
  idle,
  running,
  done,
}

final contactProvider =
    ChangeNotifierProvider<ContactProvider>((ref) => ContactProvider(ref.read));

class ContactProvider with ChangeNotifier {
  ContactProvider(this.read) {
    percentageLoaded.listen((value) {
      logger.d('Loaded $value %');
    });
  }

  final Reader read;

  final BehaviorSubject<int> percentageLoaded = BehaviorSubject();

  List<Contact> contactsData;
  ContactsLoadingState contactsLoadingState = ContactsLoadingState.idle;

  Future<void> loadContacts() async {
    contactsLoadingState = ContactsLoadingState.idle;
    notifyListeners();

    var hasContactPermission = await PermissionHandler.hasContactPermission();
    if (!hasContactPermission) {
      hasContactPermission = await PermissionHandler.requestContactPermission(
        onPermissionDenied: () {
          logger.e('Contact permission denied!');
        },
      );
    }

    if (!hasContactPermission) {
      return;
    }

    contactsLoadingState = ContactsLoadingState.running;
    notifyListeners();

    contactsData ??= <Contact>[];

    percentageLoaded.add(0);
    contactsData.clear();

    final deviceContacts = flutter_contacts.Contacts.listContacts();
    final total = await deviceContacts.length;
    var counter = 0;

    while (await deviceContacts.moveNext()) {
      final contact = await deviceContacts.current;
      final avatar = await getContactAvatar(contact);

      if (contact.phones.isNotEmpty) {
        for (var i = 0; i < contact.phones.length; i++) {
          addContactToLocalList(
            contact.phones[i].value,
            contact.displayName,
            avatar,
          );
        }
      }

      counter++;
      percentageLoaded.add(counter * 100 ~/ total);
    }

    read(walletProvider).uploadDeviceContacts(contacts: contactsData);
  }

  void addContactToLocalList(
    String phone,
    String displayName,
    Uint8List avatar,
  ) {
    if (phone == null || displayName == null) {
      return;
    }

    phone = phone.replaceAll(' ', '');

    if (contactsData?.firstWhere((e) => e.phone == phone, orElse: () => null) ==
            null &&
        phone.isNotEmpty &&
        displayName.isNotEmpty &&
        !phone.startsWith('*')) {
      String avatarString;
      if (avatar != null) {
        final img = image.decodeImage(avatar);
        final jpgBytes = image.encodeJpg(img);
        avatarString = base64Encode(jpgBytes);
      }

      final contactData = Contact();
      contactData.phone = phone;
      contactData.name = displayName;
      // TODO: add contact avatar when available
      // contactData.avatar = avatarString;
      contactsData.add(contactData);
    }
  }

  Future<Uint8List> getContactAvatar(flutter_contacts.Contact contact) async {
    try {
      return flutter_contacts.Contacts.getContactImage(contact.identifier);
    } catch (err) {
      logger.e(err);
    }

    return null;
  }

  void onError({String error}) {
    logger.d('Import contacts onError');
    read(utilsProvider)
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
    Future<void>.delayed(Duration(milliseconds: 500), () {
      contactsLoadingState = ContactsLoadingState.idle;
    });
  }
}
