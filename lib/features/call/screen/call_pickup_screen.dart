import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:whatsapp/colors.dart';
import 'package:whatsapp/features/call/controller/call_controller.dart';
import 'package:whatsapp/features/call/screen/call_screen.dart';
import 'package:whatsapp/models/call.dart';

class CallPickupScreen extends ConsumerWidget {
  final Widget scaffold;
  const CallPickupScreen({super.key, required this.scaffold});

  // void endCall(String senderId, String receiverId, WidgetRef ref) {
  //   ref.read(callControllerProvider).endCall(senderId, receiverId);
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<DocumentSnapshot>(
        stream: ref.watch(callControllerProvider).getCall,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.data() != null) {
            Call call =
                Call.fromMap(snapshot.data!.data() as Map<String, dynamic>);
            if (!call.hasDial) {
              // save incoming call data in the Hive phone memory.
              Box boxCall = Hive.box<Call>('call');
              boxCall.add(call);
              return Scaffold(
                body: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      const Text('Incoming call',
                          style: TextStyle(fontSize: 30, color: whiteColor)),
                      const SizedBox(height: 50),
                      CircleAvatar(
                        backgroundImage: NetworkImage(call.callerPic),
                        radius: 64,
                      ),
                      const SizedBox(height: 50),
                      Text(
                        call.callerName,
                        style: const TextStyle(
                            fontSize: 25,
                            color: whiteColor,
                            fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 75),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              //endCall(call.callerId, call.receiverId, ref);
                            },
                            icon: const Icon(Icons.call_end,
                                color: Colors.redAccent),
                          ),
                          const SizedBox(width: 25),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CallScreen(
                                    channelId: call.callId,
                                    call: call,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.call,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      )
                    ]),
              );
            }
          }
          return scaffold;
        });
  }
}
