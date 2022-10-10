// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:whatsapp/enums/message_enums.dart';

class MessageReply {
  final String replyMessage;
  final bool isMe;
  final MessageEnum replyType;
  MessageReply({
    required this.replyMessage,
    required this.isMe,
    required this.replyType,
  });
}

final messageRepyProvider = StateProvider<MessageReply?>((ref) => null);
