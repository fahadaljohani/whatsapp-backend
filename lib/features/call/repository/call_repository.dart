// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/common/utils/utils.dart';
import 'package:whatsapp/features/call/screen/call_screen.dart';
import 'package:whatsapp/models/call.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final callRepositoryProvider = Provider(
  (ref) => CallRepository(
      firestore: FirebaseFirestore.instance, auth: FirebaseAuth.instance),
);

class CallRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  CallRepository({
    required this.firestore,
    required this.auth,
  });

  void makeCall({
    required BuildContext context,
    required Call sender,
    required Call receiver,
  }) async {
    try {
      await firestore
          .collection('call')
          .doc(sender.callerId)
          .set(sender.toMap());
      await firestore
          .collection('call')
          .doc(receiver.receiverId)
          .set(receiver.toMap());

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallScreen(
            channelId: sender.callId,
            call: sender,
          ),
        ),
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void deleteCall(String senderId, String receiverId) async {
    try {
      await firestore.collection('call').doc(senderId).delete();
      await firestore.collection('call').doc(receiverId).delete();
    } catch (e) {
      if (kDebugMode) print(e.toString());
    }
  }

  Stream<DocumentSnapshot> get getCall =>
      firestore.collection('call').doc(auth.currentUser!.uid).snapshots();
}
