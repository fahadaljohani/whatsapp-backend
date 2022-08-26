// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:whatsapp/info.dart';
import 'package:whatsapp/screens/widgets/my_messages.dart';
import 'package:whatsapp/screens/widgets/sender_message.dart';

class ChatList extends StatelessWidget {
  const ChatList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: ScrollController(),
      itemCount: messages.length,
      itemBuilder: ((context, index) {
        final message = messages[index];
        if (messages[index]['isMe'] == true) {
          return MyMessage(
            text: message['text'].toString(),
            time: message['time'].toString(),
          );
        }
        return SenderMessage(
          text: message['text'].toString(),
          time: message['time'].toString(),
        );
      }),
    );
  }
}
