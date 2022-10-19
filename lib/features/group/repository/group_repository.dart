// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp/common/repository/common_firebase_repository.dart';
import 'package:whatsapp/models/group.dart';

final groupRepositoryProvider = Provider(
    (ref) => GroupRepository(firestore: FirebaseFirestore.instance, ref: ref));

class GroupRepository {
  final FirebaseFirestore firestore;
  final ProviderRef ref;
  GroupRepository({
    required this.firestore,
    required this.ref,
  });

  void createGroup({
    required BuildContext context,
    required File profilePic,
    required String name,
    required List<Contact> contacts,
    required String senderId,
  }) async {
    final groupId = const Uuid().v1();
    List<String> uidsGroupMember = [];
    final photoUrl = await ref
        .read(commonFirebaseRepositoryProvider)
        .uploadStorageToFirebse(file: profilePic, ref: '/group/$groupId');
    for (var i = 0; i < contacts.length; i++) {
      var userSnapshot = await firestore
          .collection('users')
          .where('phoneNumber',
              isEqualTo: contacts[i].phones[0].number.replaceAll(' ', ''))
          .get();
      if (userSnapshot.docs.isNotEmpty && userSnapshot.docs[0].exists) {
        uidsGroupMember.add(userSnapshot.docs[0].data()['uid']);
      }
    }

    GroupModel group = GroupModel(
      name: name,
      groupId: groupId,
      senderId: senderId,
      profilePic: photoUrl,
      uidsGroupMember: [senderId, ...uidsGroupMember],
      createdAt: DateTime.now(),
      lastMessage: '',
    );
    await firestore.collection('group').doc(groupId).set(group.toMap());
  }
}
