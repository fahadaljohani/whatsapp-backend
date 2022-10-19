import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/colors.dart';
import 'package:whatsapp/common/utils/utils.dart';
import 'package:whatsapp/features/group/controller/group_controller.dart';
import 'package:whatsapp/features/group/widgets/select_group_contact.dart';

class CraeteGroupScreen extends ConsumerStatefulWidget {
  static const String routeName = '/group-screen';

  const CraeteGroupScreen({super.key});

  @override
  ConsumerState<CraeteGroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends ConsumerState<CraeteGroupScreen> {
  File? image;
  TextEditingController groupController = TextEditingController();

  void createGroup() {
    if (image != null && groupController.text.trim().isNotEmpty) {
      ref.read(groupControllerProvider).createGroup(
            context,
            image!,
            groupController.text.trim(),
            ref.read(selectedContactsProvider),
          );
    }
    ref.read(selectedContactsProvider.state).update((state) => []);
    Navigator.pop(context);
  }

  void selectImage() async {
    image = await pickImageFromGallery();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    groupController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Group'),
        backgroundColor: backgroundColor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 15,
          ),
          Center(
            child: Stack(
              children: [
                image == null
                    ? const CircleAvatar(
                        backgroundImage: NetworkImage(
                          'https://i.pinimg.com/564x/6f/61/49/6f6149e35160ea4aad3826f6016f7533.jpg',
                        ),
                        radius: 64,
                      )
                    : CircleAvatar(
                        backgroundImage: FileImage(image!),
                        radius: 64,
                      ),
                Positioned(
                  left: 80,
                  bottom: -10,
                  child: IconButton(
                    onPressed: selectImage,
                    icon: const Icon(Icons.add_a_photo),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: groupController,
              decoration: const InputDecoration(
                hintText: 'Enter Group Name',
              ),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            child: const Text(
              'Select Group Member',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          const SelectGroupContact(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: tabColor,
        onPressed: createGroup,
        child: const Icon(
          Icons.done,
          color: whiteColor,
        ),
      ),
    );
  }
}
