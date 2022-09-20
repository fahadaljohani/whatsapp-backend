import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp/common/widgets/loader.dart';
import 'package:whatsapp/features/chat/repository/chat_repository.dart';
import 'package:whatsapp/models/message.dart';
import 'package:whatsapp/screens/widgets/my_messages.dart';
import 'package:whatsapp/screens/widgets/sender_message.dart';

class ChatList extends ConsumerStatefulWidget {
  final String recieverId;

  const ChatList({
    Key? key,
    required this.recieverId,
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
        stream: ref.read(chatRepositoryProvider).getMessages(widget.recieverId),
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

              if (message.senderId == FirebaseAuth.instance.currentUser!.uid) {
                return MyMessage(
                  text: message.text,
                  time: DateFormat.Hm().format(message.timeSent),
                  type: message.type,
                );
              }
              return SenderMessage(
                text: message.text,
                time: DateFormat.Hm().format(message.timeSent),
                type: message.type,
              );
            }),
          );
        });
  }
}