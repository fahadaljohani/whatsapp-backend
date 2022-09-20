import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp/common/repository/common_firebase_repository.dart';
import 'package:whatsapp/common/utils/utils.dart';
import 'package:whatsapp/enums/message_enums.dart';
import 'package:whatsapp/models/contact.dart';
import 'package:whatsapp/models/message.dart';
import 'package:whatsapp/models/user_model.dart';

final chatRepositoryProvider = Provider(
  (ref) => ChatRepository(
      firestore: FirebaseFirestore.instance,
      auth: FirebaseAuth.instance,
      ref: ref),
);

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final ProviderRef ref;
  ChatRepository({
    required this.firestore,
    required this.auth,
    required this.ref,
  });

  void _saveContactToContactsSubCollections({
    required UserModel senderUser,
    required UserModel recieverUser,
    required String lastMassage,
    required DateTime timeSent,
  }) async {
    final recieverContact = Contact(
        name: senderUser.name,
        profilePic: senderUser.profilePic,
        lastMassage: lastMassage,
        timeSent: timeSent,
        contactId: senderUser.uid);
    await firestore
        .collection('users')
        .doc(recieverUser.uid)
        .collection('chats')
        .doc(senderUser.uid)
        .set(
          recieverContact.toMap(),
        );
    final senderContact = Contact(
        name: recieverUser.name,
        profilePic: recieverUser.profilePic,
        lastMassage: lastMassage,
        timeSent: timeSent,
        contactId: recieverUser.uid);
    await firestore
        .collection('users')
        .doc(senderUser.uid)
        .collection('chats')
        .doc(recieverUser.uid)
        .set(
          senderContact.toMap(),
        );
  }

  void _saveMessageToMessagesSubCollections({
    required String senderName,
    required String senderId,
    required String recieverName,
    required String recieverId,
    required String text,
    required DateTime timeSent,
    required String messageId,
    required bool isSeen,
    required MessageEnum type,
  }) async {
    final userMessage = Message(
      text: text,
      timeSent: timeSent,
      senderName: senderName,
      senderId: senderId,
      recieverName: recieverName,
      recieverId: recieverId,
      messageId: messageId,
      isSeen: isSeen,
      type: type,
    );
    await firestore
        .collection('users')
        .doc(recieverId)
        .collection('chats')
        .doc(senderId)
        .collection('messages')
        .doc(messageId)
        .set(userMessage.toMap());

    await firestore
        .collection('users')
        .doc(senderId)
        .collection('chats')
        .doc(recieverId)
        .collection('messages')
        .doc(messageId)
        .set(userMessage.toMap());
  }

  void sendTextMessage({
    required BuildContext context,
    required String recieverId,
    required UserModel senderUser,
    required String text,
    required MessageEnum messageEnum,
  }) async {
    try {
      final messageId = const Uuid().v1();
      UserModel recieverUser;
      var userMap = await firestore.collection('users').doc(recieverId).get();
      recieverUser = UserModel.fromMap(userMap.data()!);
      final timeSent = DateTime.now();
      _saveContactToContactsSubCollections(
        senderUser: senderUser,
        recieverUser: recieverUser,
        lastMassage: text,
        timeSent: timeSent,
      );
      _saveMessageToMessagesSubCollections(
        senderId: senderUser.uid,
        senderName: senderUser.name,
        recieverId: recieverUser.uid,
        recieverName: recieverUser.name,
        text: text,
        timeSent: timeSent,
        isSeen: false,
        messageId: messageId,
        type: messageEnum,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void sendFileMessage({
    required BuildContext context,
    required String recieverId,
    required UserModel senderUser,
    required File file,
    required MessageEnum messageEnum,
  }) async {
    try {
      String messageId = const Uuid().v1();
      DateTime timeSent = DateTime.now();
      UserModel recieverUser;
      final userDataMap =
          await firestore.collection('users').doc(recieverId).get();
      recieverUser = UserModel.fromMap(userDataMap.data()!);
      String imageUrl = await ref
          .read(commonFirebaseRepositoryProvider)
          .uploadStorageToFirebse(
            file: file,
            ref:
                'chats/${messageEnum.type}/${senderUser.uid}/$recieverId/$messageId',
          );
      String messageContent = "";
      switch (messageEnum) {
        case MessageEnum.image:
          messageContent = '📹 photo';
          break;
        case MessageEnum.video:
          messageContent = '📸 video';
          break;
        case MessageEnum.audio:
          messageContent = '🔊 audio';
          break;
        case MessageEnum.gif:
          messageContent = "git";
          break;
        default:
          messageContent = "git";
          break;
      }
      _saveContactToContactsSubCollections(
          senderUser: senderUser,
          recieverUser: recieverUser,
          lastMassage: messageContent,
          timeSent: timeSent);
      _saveMessageToMessagesSubCollections(
          senderName: senderUser.name,
          senderId: senderUser.uid,
          recieverName: recieverUser.name,
          recieverId: recieverUser.uid,
          text: imageUrl,
          timeSent: timeSent,
          messageId: messageId,
          isSeen: false,
          type: messageEnum);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Stream<List<Contact>> getContacts() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((event) {
      List<Contact> contacts = [];
      for (var document in event.docs) {
        Contact contact = Contact.fromMap(document.data());
        contacts.add(contact);
      }
      return contacts;
    });
  }

  Stream<List<Message>> getMessages(String userId) {
    return firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('chats')
        .doc(userId)
        .collection('messages')
        .orderBy('timeSent')
        .snapshots()
        .map((event) {
      List<Message> messages = [];
      for (var document in event.docs) {
        final message = Message.fromMap(document.data());
        messages.add(message);
      }
      return messages;
    });
  }
}
