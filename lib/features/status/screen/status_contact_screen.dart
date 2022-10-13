import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp/colors.dart';
import 'package:whatsapp/common/widgets/loader.dart';
import 'package:whatsapp/features/status/controller/status_controller.dart';
import 'package:whatsapp/features/status/screen/status_view_screen.dart';
import 'package:whatsapp/models/status.dart';

class StatusContactScreen extends ConsumerWidget {
  const StatusContactScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: SingleChildScrollView(
        child: FutureBuilder<List<Status>>(
            future:
                ref.read(statusControllerProvider).getStatus(context: context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Loader();
              }
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final statusData = snapshot.data![index];
                    return Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                                context, StatusViewScreen.routeName,
                                arguments: statusData);
                          },
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(statusData.profilePic),
                              radius: 30,
                            ),
                            title: Text(
                              statusData.username,
                              style: const TextStyle(fontSize: 18),
                            ),
                            trailing: Text(
                              DateFormat.Hm().format(statusData.createdAt),
                              style: const TextStyle(
                                fontSize: 13,
                                color: greyColor,
                              ),
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
