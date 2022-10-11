import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/enums/message_enums.dart';
import 'package:whatsapp/features/auth/controller/auth_controller.dart';
import 'package:whatsapp/features/chat/repository/chat_repository.dart';
import 'package:whatsapp/models/contact.dart';
import 'package:whatsapp/models/message.dart';
import 'package:whatsapp/provider/message_reply_provider.dart';

final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatRepositoryController(chatRepository: chatRepository, ref: ref);
});

class ChatRepositoryController {
  final ChatRepository chatRepository;
  final ProviderRef ref;
  ChatRepositoryController({
    required this.chatRepository,
    required this.ref,
  });

  void sendTextMessge({
    required BuildContext context,
    required String recieverId,
    required String text,
    required MessageEnum messageEnum,
  }) {
    final replyMessage = ref.read(messageRepyProvider);
    ref.read(authControllerProvider).getCurrentUserData().then((value) {
      chatRepository.sendTextMessage(
        context: context,
        recieverId: recieverId,
        senderUser: value!,
        text: text,
        messageEnum: messageEnum,
        replyMessage: replyMessage?.replyMessage,
        isMe: replyMessage?.isMe,
        messageReplyType: replyMessage?.replyType,
      );
    });
    ref.read(messageRepyProvider.state).update((state) => null);
  }

  void sendFileMessage({
    required BuildContext context,
    required String recieverId,
    required File file,
    required MessageEnum messageEnum,
  }) {
    final replyMessage = ref.read(messageRepyProvider);
    ref.read(authControllerProvider).getCurrentUserData().then((value) {
      chatRepository.sendFileMessage(
        context: context,
        recieverId: recieverId,
        senderUser: value!,
        file: file,
        messageEnum: messageEnum,
        replyMessage: replyMessage?.replyMessage,
        isMe: replyMessage?.isMe,
        messageReplyType: replyMessage?.replyType,
      );
    });
    ref.read(messageRepyProvider.state).update((state) => null);
  }

  Stream<List<Contact>> getContacts() {
    return chatRepository.getContacts();
  }

  Stream<List<Message>> getMessages(String userId) {
    return chatRepository.getMessages(userId);
  }

  void setMessageSeen(
    BuildContext context,
    String receiverId,
    String messageId,
  ) {
    chatRepository.setMessageSeen(context, receiverId, messageId);
  }
}
