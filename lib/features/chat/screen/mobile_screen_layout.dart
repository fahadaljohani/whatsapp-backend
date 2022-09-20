import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/colors.dart';
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
    with WidgetsBindingObserver {
  // - properties
  List<Contact> contacts = [];
  // - actions
  void navigatoToSelectContacts() {
    Navigator.pushNamed(context, SelectContactScreen.routeName);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
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
    return DefaultTabController(
      length: 3,
      child: Scaffold(
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
          bottom: const TabBar(
              indicatorColor: tabColor,
              unselectedLabelColor: greyColor,
              labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              labelColor: tabColor,
              indicatorWeight: 4,
              tabs: [
                Tab(text: 'CHATS'),
                Tab(text: 'STATUS'),
                Tab(text: 'CALLS'),
              ]),
        ),
        body: const TabBarView(
          children: [
            ContactList(),
            Text('STATUS'),
            Text('CALLS'),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: navigatoToSelectContacts,
          backgroundColor: tabColor,
          child: const Icon(Icons.comment, color: whiteColor),
        ),
      ),
    );
  }
}
