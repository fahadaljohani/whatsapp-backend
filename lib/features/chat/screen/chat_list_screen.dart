import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/colors.dart';
import 'package:whatsapp/common/widgets/loader.dart';
import 'package:whatsapp/features/auth/controller/auth_controller.dart';
import 'package:whatsapp/features/call/controller/call_controller.dart';
import 'package:whatsapp/features/chat/widgets/bottom_text_field.dart';
import 'package:whatsapp/features/chat/widgets/chat_list.dart';
import 'package:whatsapp/models/user_model.dart';

class ChatListScreen extends ConsumerWidget {
  static const String routeName = '/chat-list-screen';
  final String name;
  final String receiverId;
  final String receiverPic;
  final bool isGroupChat;
  final ScrollController messageController = ScrollController();

  ChatListScreen({
    Key? key,
    required this.name,
    required this.receiverId,
    required this.receiverPic,
    required this.isGroupChat,
  }) : super(key: key);

  void makeCall(BuildContext context, WidgetRef ref) {
    ref.read(callControllerProvider).makeCall(
        context: context,
        receiverId: receiverId,
        receiverName: name,
        receiverPic: receiverPic);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: StreamBuilder<UserModel?>(
            stream: ref.watch(authControllerProvider).getUserById(receiverId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Loader();
              }

              return isGroupChat
                  ? Text(name)
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name),
                        Text(
                          snapshot.data!.isOnline == true
                              ? 'Online'
                              : 'Offline',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    );
            }),
        centerTitle: false,
        actions: [
          IconButton(
              onPressed: () => makeCall(context, ref),
              icon: const Icon(Icons.video_call)),
          IconButton(
              onPressed: () => makeCall(context, ref),
              icon: const Icon(Icons.call)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatList(
              recieverId: receiverId,
              isGroupChat: isGroupChat,
            ),
          ),
          BottomTextField(
            recieverId: receiverId,
            isGroupChat: isGroupChat,
          ),
        ],
      ),
    );
  }
}
