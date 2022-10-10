// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/colors.dart';

import 'package:whatsapp/enums/message_enums.dart';
import 'package:whatsapp/provider/message_reply_provider.dart';

class MessageReplyPreview extends ConsumerWidget {
  final String replyedMessage;
  final bool isMe;
  final MessageEnum messageEnum;
  const MessageReplyPreview({
    super.key,
    required this.replyedMessage,
    required this.isMe,
    required this.messageEnum,
  });

  void cancelReplyMessage(WidgetRef ref) {
    ref.watch(messageRepyProvider.state).update((state) => null);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(color: appBarColor),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  isMe ? 'You' : 'Opposite',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              GestureDetector(
                onTap: () => cancelReplyMessage(ref),
                child: const Icon(
                  Icons.close,
                  size: 16,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Text(replyedMessage),
        ],
      ),
    );
  }
}
