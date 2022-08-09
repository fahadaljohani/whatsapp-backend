import 'package:flutter/material.dart';
import 'package:whatsapp/colors.dart';
import 'package:whatsapp/screens/widgets/contact_list.dart';

class MobileScreen extends StatefulWidget {
  //  final TabController _Controller;
  const MobileScreen({Key? key}) : super(key: key);

  @override
  State<MobileScreen> createState() => _MobileScreenState();
}

class _MobileScreenState extends State<MobileScreen> {
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
                labelStyle:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                labelColor: tabColor,
                indicatorWeight: 4,
                tabs: [
                  Tab(text: 'CHATS'),
                  Tab(text: 'STATUS'),
                  Tab(text: 'CALLS'),
                ]),
          ),
          body: TabBarView(
            children: [
              ContactList(),
              Text('STATUS'),
              Text('CALLS'),
            ],
          )),
    );
  }
}
