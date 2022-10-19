import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp/colors.dart';
import 'package:whatsapp/common/widgets/loader.dart';
import 'package:whatsapp/features/chat/controller/chat_controller.dart';
import 'package:whatsapp/features/chat/screen/chat_list_screen.dart';
import 'package:whatsapp/models/contact.dart';
import 'package:whatsapp/models/group.dart';

class ContactList extends ConsumerWidget {
  const ContactList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: SingleChildScrollView(
        child: SingleChildScrollView(
          child: Column(
            children: [
              StreamBuilder<List<GroupModel>>(
                  stream: ref.watch(chatControllerProvider).getGroupContacts(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Loader();
                    }
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final groupData = snapshot.data![index];
                          return Column(
                            children: [
                              InkWell(
                                onTap: () => Navigator.pushNamed(
                                    context, ChatListScreen.routeName,
                                    arguments: {
                                      'name': groupData.name,
                                      'receiverId': groupData.groupId,
                                      'receiverPic': groupData.profilePic,
                                      'isGroupChat': true,
                                    }),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(groupData.profilePic),
                                    radius: 30,
                                  ),
                                  title: Text(
                                    groupData.name,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  subtitle: Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: Text(
                                        groupData.lastMessage,
                                        style: const TextStyle(fontSize: 15),
                                      )),
                                  trailing: Text(
                                    DateFormat.Hm().format(groupData.createdAt),
                                    style: const TextStyle(
                                        fontSize: 13, color: greyColor),
                                  ),
                                ),
                              ),
                              const Divider(
                                color: dividerColor,
                                indent: 85,
                              ),
                            ],
                          );
                        });
                  }),
              StreamBuilder<List<Contact>>(
                  stream: ref.watch(chatControllerProvider).getContacts(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Loader();
                    }

                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final contact = snapshot.data![index];
                          return Column(
                            children: [
                              InkWell(
                                onTap: () => Navigator.pushNamed(
                                    context, ChatListScreen.routeName,
                                    arguments: {
                                      'name': contact.name,
                                      'receiverId': contact.contactId,
                                      'receiverPic': contact.profilePic,
                                      'isGroupChat': false,
                                    }),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(contact.profilePic),
                                    radius: 30,
                                  ),
                                  title: Text(
                                    contact.name,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  subtitle: Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: Text(
                                        contact.lastMassage,
                                        style: const TextStyle(fontSize: 15),
                                      )),
                                  trailing: Text(
                                    DateFormat.Hm().format(contact.timeSent),
                                    style: const TextStyle(
                                        fontSize: 13, color: greyColor),
                                  ),
                                ),
                              ),
                              const Divider(
                                color: dividerColor,
                                indent: 85,
                              ),
                            ],
                          );
                        });
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
