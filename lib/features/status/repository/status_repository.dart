// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp/common/repository/common_firebase_repository.dart';
import 'package:whatsapp/common/utils/utils.dart';
import 'package:whatsapp/features/select_contact/repository/select_contact_repository.dart';
import 'package:whatsapp/models/status.dart';

final statusRepositoryProvider = Provider(
  (ref) => StatusRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    ref: ref,
  ),
);

class StatusRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final ProviderRef ref;
  StatusRepository({
    required this.firestore,
    required this.auth,
    required this.ref,
  });

  void uploadStatus({
    required BuildContext context,
    required File file,
    required String profilePic,
    required String phoneNumber,
    required String username,
    required String uid,
  }) async {
    String statusId = const Uuid().v1();
    List<Contact> contacts = [];
    if (await FlutterContacts.requestPermission()) {
      contacts = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true);
    }
    List<String> uidsWhoCanSee = [];
    for (var i = 0; i < contacts.length; i++) {
      var statusCollection = await firestore
          .collection('users')
          .where(
            'phoneNumber',
            isEqualTo: contacts[i].phones[0].number.replaceAll(' ', ''),
          )
          .get();
      if (statusCollection.docs.isNotEmpty) {
        uidsWhoCanSee.add(statusCollection.docs[0].data()['uid']);
      }
    }
    final imageUrl = await ref
        .read(commonFirebaseRepositoryProvider)
        .uploadStorageToFirebse(file: file, ref: '/status/$statusId$uid');

    List<String> statusImages = [];
    var statusSnapshot = await firestore
        .collection('status')
        .where('uid', isEqualTo: auth.currentUser!.uid)
        .get();
    if (statusSnapshot.docs.isNotEmpty) {
      Status status = Status.fromMap(statusSnapshot.docs[0].data());
      statusImages = status.photoUrl;
      statusImages.add(imageUrl);
      await firestore
          .collection('status')
          .doc(statusSnapshot.docs[0].id)
          .update({'photoUrl': statusImages});
      return;
    } else {
      Status status = Status(
        statusId: statusId,
        uid: uid,
        username: username,
        profilePic: profilePic,
        phoneNumber: phoneNumber,
        createdAt: DateTime.now(),
        whoCanSee: [uid, ...uidsWhoCanSee],
        photoUrl: [imageUrl],
      );
      await firestore.collection('status').doc(statusId).set(status.toMap());
    }
  }

  Future<List<Status>> getStatus({required BuildContext context}) async {
    List<Status> statusList = [];
    try {
      List<Contact> contacts =
          await ref.read(selectContactsRepositoryProvider).getContacts();

      for (var i = 0; i < contacts.length; i++) {
        var statusSnapshots = await firestore
            .collection('status')
            .where(
              'phoneNumber',
              isEqualTo: contacts[i].phones[0].number.replaceAll(' ', ''),
            )
            .where('createdAt',
                isLessThanOrEqualTo: DateTime.now()
                    .subtract(const Duration(hours: 24))
                    .millisecondsSinceEpoch)
            .get();
        if (statusSnapshots.docs.isNotEmpty && statusSnapshots.docs[0].exists) {
          Status status = Status.fromMap(statusSnapshots.docs[0].data());
          if (status.whoCanSee.contains(auth.currentUser!.uid)) {
            statusList.add(status);
          }
        }
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
    return statusList;
  }
}
