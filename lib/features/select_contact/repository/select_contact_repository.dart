// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/common/utils/utils.dart';
import 'package:whatsapp/features/chat/screen/chat_list_screen.dart';
import 'package:whatsapp/models/user_model.dart';

final selectContactsRepositoryProvider = Provider(
  ((ref) => SelectContactRepository(firestore: FirebaseFirestore.instance)),
);

class SelectContactRepository {
  final FirebaseFirestore firestore;
  SelectContactRepository({
    required this.firestore,
  });

  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(
            withProperties: true, withPhoto: true);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return contacts;
  }

  void selectContact(
      {required BuildContext context, required Contact contact}) async {
    try {
      final userCollections = await firestore.collection('users').get();
      bool isFound = false;
      for (var document in userCollections.docs) {
        final userData = UserModel.fromMap(document.data());
        final contactPhone = contact.phones[0].number.replaceAll(' ', '');
        if (userData.phoneNumber == contactPhone) {
          isFound = true;
          Navigator.pushNamed(context, ChatListScreen.routeName, arguments: {
            'name': userData.name,
            'receiverId': userData.uid,
            'receiverPic': userData.profilePic,
            'isGroupChat': false,
          });
        }
      }
      if (!isFound) {
        showSnackBar(context: context, content: 'user contact not found');
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
