import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp/common/widgets/loader.dart';
import 'package:whatsapp/features/chat/controller/chat_controller.dart';
import 'package:whatsapp/models/message.dart';
import 'package:whatsapp/features/chat/widgets/my_messages.dart';
import 'package:whatsapp/features/chat/widgets/sender_message.dart';
import 'package:whatsapp/provider/message_reply_provider.dart';

class ChatList extends ConsumerStatefulWidget {
  final String recieverId;
  final bool isGroupChat;

  const ChatList({
    Key? key,
    required this.recieverId,
    required this.isGroupChat,
  }) : super(
          key: key,
        );

  @override
  ConsumerState<ChatList> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  ScrollController messageController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
        stream: widget.isGroupChat
            ? ref
                .read(chatControllerProvider)
                .getGroupMessages(widget.recieverId)
            : ref.read(chatControllerProvider).getMessages(widget.recieverId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }

          SchedulerBinding.instance.addPostFrameCallback(
            (_) {
              messageController
                  .jumpTo(messageController.position.maxScrollExtent);
            },
          );

          return ListView.builder(
            controller: messageController,
            itemCount: snapshot.data!.length,
            itemBuilder: ((context, index) {
              final message = snapshot.data![index];
              if (message.isSeen != true &&
                  message.recieverId ==
                      FirebaseAuth.instance.currentUser!.uid) {
                ref.read(chatControllerProvider).setMessageSeen(
                    context, widget.recieverId, message.messageId);
              }

              if (message.senderId == FirebaseAuth.instance.currentUser!.uid) {
                return MyMessage(
                  text: message.text,
                  time: DateFormat.Hm().format(message.timeSent),
                  type: message.type,
                  isSeen: message.isSeen,
                  replyMessage: message.replyMessage,
                  replyMessageType: message.messageReplyType,
                  replyTo: message.replyTo,
                  onLeftSwip: () {
                    ref.read(messageRepyProvider.state).update((state) {
                      return MessageReply(
                        replyMessage: message.text,
                        isMe: true,
                        replyType: message.type,
                      );
                    });
                  },
                );
              }
              return SenderMessage(
                text: message.text,
                time: DateFormat.Hm().format(message.timeSent),
                type: message.type,
                isSeen: message.isSeen,
                replyMessage: message.replyMessage,
                replyMessageType: message.messageReplyType,
                replyTo: message.replyTo,
                onRightSwipe: () {
                  ref.read(messageRepyProvider.state).update((state) {
                    return MessageReply(
                      replyMessage: message.text,
                      isMe: false,
                      replyType: message.type,
                    );
                  });
                },
              );
            }),
          );
        });
  }
}
