import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/colors.dart';
import 'package:whatsapp/common/widgets/loader.dart';
import 'package:whatsapp/features/auth/controller/auth_controller.dart';
import 'package:whatsapp/features/chat/widgets/bottom_text_field.dart';
import 'package:whatsapp/features/chat/widgets/chat_list.dart';
import 'package:whatsapp/models/user_model.dart';

class ChatListScreen extends ConsumerWidget {
  static const String routeName = '/chat-list-screen';
  final String name;
  final String uid;
  ScrollController messageController = ScrollController();

  ChatListScreen({Key? key, required this.name, required this.uid})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: StreamBuilder<UserModel?>(
            stream: ref.watch(authControllerProvider).getUserById(uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Loader();
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name),
                  Text(
                    snapshot.data!.isOnline == true ? 'Online' : 'Offline',
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
          IconButton(onPressed: () {}, icon: const Icon(Icons.video_call)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.call)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatList(
              recieverId: uid,
            ),
          ),
          BottomTextField(
            recieverId: uid,
          ),
        ],
      ),
    );
  }
}
