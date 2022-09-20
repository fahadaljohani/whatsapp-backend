import 'package:flutter/material.dart';
import 'package:whatsapp/colors.dart';
import 'package:whatsapp/features/chat/widgets/chat_list.dart';
import 'package:whatsapp/features/chat/widgets/contact_list.dart';
import 'package:whatsapp/screens/widgets/search_web_bar.dart';
import 'package:whatsapp/screens/widgets/web_app_bar.dart';
import 'package:whatsapp/screens/widgets/web_profile_bar.dart';

class WebScreen extends StatelessWidget {
  const WebScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // web contact list
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: const [
                  // // webprofile appbar
                  WebProfileBar(),
                  // // web search bar
                  SearchWebAppBar(),
                  // contact screen
                  ContactList(),
                ],
              ),
            ),
          ),
          // web chat list
          Container(
            width: size.width * 0.75,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/backgroundImage.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(children: [
              const WebAppBar(),
              const Expanded(
                  child: ChatList(
                recieverId: '',
              )),
              Container(
                height: size.height * 0.07,
                decoration: const BoxDecoration(
                  color: chatBarMessage,
                  border: Border(
                    bottom: BorderSide(
                      color: dividerColor,
                    ),
                  ),
                ),
                child: Row(children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.emoji_emotions_outlined,
                      color: greyColor,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.attach_file,
                      color: greyColor,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 15),
                      child: TextField(
                        decoration: InputDecoration(
                            hintText: 'Type a message',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                            ),
                            contentPadding: const EdgeInsets.all(10)),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.mic),
                  ),
                ]),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
