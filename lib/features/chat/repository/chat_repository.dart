import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp/common/repository/common_firebase_repository.dart';
import 'package:whatsapp/common/utils/utils.dart';
import 'package:whatsapp/enums/message_enums.dart';
import 'package:whatsapp/models/contact.dart';
import 'package:whatsapp/models/group.dart';
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

  // - actions
  void sendTextMessage({
    required BuildContext context,
    required String recieverId,
    required UserModel senderUser,
    required String text,
    required MessageEnum messageEnum,
    required String? replyMessage,
    required bool? isMe,
    required MessageEnum? messageReplyType,
    required bool isGroupChat,
  }) async {
    try {
      final messageId = const Uuid().v1();

      UserModel? recieverUser;
      if (!isGroupChat) {
        var userMap = await firestore.collection('users').doc(recieverId).get();
        recieverUser = UserModel.fromMap(userMap.data()!);
      }

      final timeSent = DateTime.now();
      _saveContactToContactsSubCollections(
        senderUser: senderUser,
        recieverUser: recieverUser,
        lastMassage: text,
        timeSent: timeSent,
        isGroupChat: isGroupChat,
        receiverId: recieverId,
      );
      _saveMessageToMessagesSubCollections(
        senderId: senderUser.uid,
        senderName: senderUser.name,
        recieverId: recieverId,
        recieverName: recieverUser?.name,
        text: text,
        timeSent: timeSent,
        isSeen: false,
        messageId: messageId,
        type: messageEnum,
        replyMessage: replyMessage ?? '',
        replyTo: isMe == null
            ? ''
            : isMe
                ? senderUser.name
                : recieverUser?.name,
        messageReplyType: messageReplyType ?? MessageEnum.text,
        isGroupChat: isGroupChat,
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
    required String? replyMessage,
    required bool? isMe,
    required MessageEnum? messageReplyType,
    required bool isGroupChat,
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
        timeSent: timeSent,
        isGroupChat: isGroupChat,
        receiverId: recieverId,
      );
      _saveMessageToMessagesSubCollections(
        senderName: senderUser.name,
        senderId: senderUser.uid,
        recieverName: recieverUser.name,
        recieverId: recieverUser.uid,
        text: imageUrl,
        timeSent: timeSent,
        messageId: messageId,
        isSeen: false,
        type: messageEnum,
        replyMessage: replyMessage ?? '',
        replyTo: isMe == null
            ? ''
            : isMe
                ? senderUser.name
                : recieverUser.name,
        messageReplyType: messageReplyType ?? MessageEnum.text,
        isGroupChat: isGroupChat,
      );
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

  Stream<List<Message>> getGroupMessages({required String groupId}) {
    return firestore
        .collection('group')
        .doc(groupId)
        .collection('chats')
        .orderBy('timeSent')
        .snapshots()
        .map((event) {
      List<Message> messages = [];
      for (var document in event.docs) {
        var message = Message.fromMap(document.data());
        messages.add(message);
      }
      return messages;
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

  Stream<List<GroupModel>> getGroupContacts() {
    return firestore.collection('group').snapshots().map((event) {
      List<GroupModel> groups = [];
      for (var document in event.docs) {
        var group = GroupModel.fromMap(document.data());
        if (group.uidsGroupMember.contains(auth.currentUser!.uid)) {
          groups.add(group);
        }
      }
      return groups;
    });
  }

  // - helper
  void _saveContactToContactsSubCollections({
    required UserModel senderUser,
    required UserModel? recieverUser,
    required String lastMassage,
    required DateTime timeSent,
    required bool isGroupChat,
    required String receiverId,
  }) async {
    if (isGroupChat) {
      await firestore.collection('group').doc(receiverId).update({
        'lastMessage': lastMassage,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
      });
    } else {
      final senderContact = Contact(
          name: recieverUser!.name,
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
      final recieverContact = Contact(
        name: senderUser.name,
        profilePic: senderUser.profilePic,
        lastMassage: lastMassage,
        timeSent: timeSent,
        contactId: senderUser.uid,
      );
      await firestore
          .collection('users')
          .doc(recieverUser.uid)
          .collection('chats')
          .doc(senderUser.uid)
          .set(
            recieverContact.toMap(),
          );
    }
  }

  void _saveMessageToMessagesSubCollections({
    required String senderName,
    required String senderId,
    required String? recieverName,
    required String recieverId,
    required String text,
    required DateTime timeSent,
    required String messageId,
    required bool isSeen,
    required MessageEnum type,
    required String? replyMessage,
    required String? replyTo,
    required MessageEnum? messageReplyType,
    required bool isGroupChat,
  }) async {
    final userMessage = Message(
      text: text,
      timeSent: timeSent,
      senderName: senderName,
      senderId: senderId,
      recieverName: recieverName ?? '',
      recieverId: recieverId,
      messageId: messageId,
      isSeen: isSeen,
      type: type,
      replyMessage: replyMessage,
      replyTo: replyTo,
      messageReplyType: messageReplyType,
    );
    if (isGroupChat) {
      await firestore
          .collection('group')
          .doc(recieverId)
          .collection('chats')
          .doc(messageId)
          .set(userMessage.toMap());
    } else {
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
  }

  void setMessageSeen(
    BuildContext context,
    String receiverId,
    String messageId,
  ) async {
    try {
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(receiverId)
          .collection('messages')
          .doc(messageId)
          .update({'isSeen': true});
      await firestore
          .collection('users')
          .doc(receiverId)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .collection('messages')
          .doc(messageId)
          .update({'isSeen': true});
    } catch (e) {
      if (kDebugMode) print(e.toString());
      //showSnackBar(context: context, content: e.toString());
    }
  }
}
