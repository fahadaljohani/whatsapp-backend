import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:whatsapp/colors.dart';
import 'package:whatsapp/models/call.dart';

class CallsMissedScreen extends StatelessWidget {
  static const String routeName = '/calls-missed-screen';
  Box boxCall = Hive.box<Call>('call');
  CallsMissedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: boxCall.listenable(),
      builder: (BuildContext context, Box box, Widget? child) {
        if (box.isEmpty) {
          return const Center(
            child: Text('no calls available.'),
          );
        } else {
          return ListView.builder(
              itemCount: box.length,
              itemBuilder: (context, index) {
                Call call = box.getAt(index);
                return Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(call.receiverPic),
                          radius: 30,
                        ),
                        title: Text(
                          call.receiverName,
                          style: const TextStyle(fontSize: 18),
                        ),

                        // trailing: Text(
                        //   DateFormat.Hm().format(groupData.createdAt),
                        //   style: const TextStyle(
                        //       fontSize: 13, color: greyColor),
                        // ),
                      ),
                      const Divider(
                        color: dividerColor,
                        indent: 85,
                      ),
                    ],
                  ),
                );
              });
        }
      },
    );
  }
}
