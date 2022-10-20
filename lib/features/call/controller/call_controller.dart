// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp/features/auth/controller/auth_controller.dart';

import 'package:whatsapp/features/call/repository/call_repository.dart';
import 'package:whatsapp/models/call.dart';
import 'package:hive_flutter/hive_flutter.dart';

final callControllerProvider = Provider((ref) {
  final callRepository = ref.read(callRepositoryProvider);
  return CallController(callRepository: callRepository, ref: ref);
});

class CallController {
  final CallRepository callRepository;
  final ProviderRef ref;
  CallController({
    required this.callRepository,
    required this.ref,
  });

  void makeCall({
    required BuildContext context,
    required String receiverId,
    required String receiverName,
    required String receiverPic,
  }) {
    ref.read(getUserDataControllerProvider).whenData((value) {
      String callId = const Uuid().v1();
      Call senderCall = Call(
        callId: callId,
        callerId: value!.uid,
        callerName: value.name,
        callerPic: value.profilePic,
        receiverId: receiverId,
        receiverName: receiverName,
        receiverPic: receiverPic,
        hasDial: true,
        createdAt: DateTime.now(),
      );
      Call receiverCall = Call(
        callId: callId,
        callerId: value.uid,
        callerName: value.name,
        callerPic: value.profilePic,
        receiverId: receiverId,
        receiverName: receiverName,
        receiverPic: receiverPic,
        hasDial: false,
        createdAt: DateTime.now(),
      );
      callRepository.makeCall(
          context: context, sender: senderCall, receiver: receiverCall);
      // save data to mobile app .
      Box boxCall = Hive.box<Call>('call');
      boxCall.add(senderCall);
    });
  }

  void endCall(String senderId, String receiverId) {
    callRepository.endCall(senderId, receiverId);
  }

  Stream<DocumentSnapshot> get getCall => callRepository.getCall;
}
