import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp/colors.dart';
import 'package:whatsapp/common/utils/utils.dart';
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
          return SlidableAutoCloseBehavior(
            closeWhenOpened: true,
            child: ListView.builder(
                itemCount: box.length,
                itemBuilder: (context, index) {
                  Call call = box.getAt(index);
                  return Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Column(
                      children: [
                        Slidable(
                          key: Key(call.callId),
                          endActionPane: ActionPane(
                            motion: const StretchMotion(),
                            dismissible: DismissiblePane(
                              onDismissed: () {
                                showSnackBar(
                                  context: context,
                                  content:
                                      "call from ${call.receiverName} deleted",
                                );
                                call.delete();
                              },
                            ),
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  showSnackBar(
                                    context: context,
                                    content:
                                        "$call from ${call.receiverName} deleted",
                                  );
                                  call.delete();
                                },
                                backgroundColor: Colors.redAccent,
                                icon: Icons.delete,
                                label: 'Delete',
                              ),
                            ],
                          ),
                          child: Builder(builder: (context) {
                            return ListTile(
                              onTap: () {
                                final slidbale = Slidable.of(context);
                                final isClosed =
                                    slidbale?.actionPaneType.value ==
                                        ActionPaneType.none;
                                if (isClosed) {
                                  slidbale?.openEndActionPane();
                                } else {
                                  slidbale?.close();
                                }
                              },
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(call.receiverPic),
                                radius: 25,
                              ),
                              title: Text(
                                call.receiverName,
                                style: call.hasDial
                                    ? const TextStyle(
                                        fontSize: 16, color: whiteColor)
                                    : const TextStyle(
                                        fontSize: 15, color: Colors.red),
                              ),
                              subtitle: call.hasDial
                                  ? const Text(
                                      '📞Outgoin',
                                      style: TextStyle(
                                          fontSize: 13, color: greyColor),
                                    )
                                  : Text(
                                      '📞Missed',
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.redAccent.shade200),
                                    ),
                              trailing: Text(
                                DateFormat.Hm().format(call.createdAt),
                                style: const TextStyle(
                                    fontSize: 13, color: greyColor),
                              ),
                            );
                          }),
                        ),
                        const Divider(
                          color: dividerColor,
                          indent: 85,
                        ),
                      ],
                    ),
                  );
                }),
          );
        }
      },
    );
  }
}
