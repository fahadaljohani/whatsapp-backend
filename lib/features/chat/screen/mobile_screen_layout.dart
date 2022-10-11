import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/colors.dart';
import 'package:whatsapp/common/utils/utils.dart';
import 'package:whatsapp/features/auth/controller/auth_controller.dart';
import 'package:whatsapp/features/chat/widgets/contact_list.dart';
import 'package:whatsapp/features/select_contact/screen/select_contact_screen.dart';

class MobileScreen extends ConsumerStatefulWidget {
  static const String routeName = '/mobile-screen';
  //  final TabController _Controller;
  const MobileScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MobileScreen> createState() => _MobileScreenState();
}

class _MobileScreenState extends ConsumerState<MobileScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  // - properties
  late TabController tabBarController;
  List<Contact> contacts = [];
  File? image;
  // - actions
  void navigatoToSelectContacts() {
    Navigator.pushNamed(context, SelectContactScreen.routeName);
  }

  @override
  void initState() {
    super.initState();
    tabBarController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    tabBarController.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(authControllerProvider).setUserState(true);
        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        ref.read(authControllerProvider).setUserState(false);
        break;
    }
  }

  // - buildContext
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: const Text('whatsapp'),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          )
        ],
        bottom: TabBar(
            controller: tabBarController,
            indicatorColor: tabColor,
            unselectedLabelColor: greyColor,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            labelColor: tabColor,
            indicatorWeight: 4,
            tabs: const [
              Tab(text: 'CHATS'),
              Tab(text: 'STATUS'),
              Tab(text: 'CALLS'),
            ]),
      ),
      body: TabBarView(
        controller: tabBarController,
        children: const [
          ContactList(),
          Text('STATUS'),
          Text('CALLS'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (tabBarController.index == 0) {
            navigatoToSelectContacts();
          } else {
            image = await pickImageFromGallery();
            if (image != null) {}
          }
        },
        backgroundColor: tabColor,
        child: const Icon(Icons.comment, color: whiteColor),
      ),
    );
  }
}
