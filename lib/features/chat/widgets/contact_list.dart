import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp/colors.dart';
import 'package:whatsapp/common/widgets/loader.dart';
import 'package:whatsapp/features/chat/controller/chat_controller.dart';
import 'package:whatsapp/features/chat/screen/chat_list_screen.dart';
import 'package:whatsapp/models/contact.dart';

class ContactList extends ConsumerWidget {
  const ContactList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: SingleChildScrollView(
        child: StreamBuilder<List<Contact>>(
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
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ChatListScreen(
                                name: contact.name,
                                uid: contact.contactId,
                              ),
                            ));
                          },
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(contact.profilePic),
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
      ),
    );
  }
}
