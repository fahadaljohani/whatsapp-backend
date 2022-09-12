import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp/common/utils/utils.dart';
import 'package:whatsapp/features/auth/controller/auth_controller.dart';

class UserInformationScreen extends ConsumerStatefulWidget {
  static const String routeName = "/user-informatio-screen";
  final String verificationId;
  const UserInformationScreen({
    Key? key,
    required this.verificationId,
  }) : super(key: key);

  @override
  ConsumerState<UserInformationScreen> createState() =>
      _UserInformationScreenState();
}

class _UserInformationScreenState extends ConsumerState<UserInformationScreen> {
  TextEditingController nameController = TextEditingController();
  File? profileImage;

  void selectImageFromGallery() async {
    final pickImage = await pickImageFromGallery(ImageSource.gallery);
    if (pickImage != null) {
      setState(() {
        profileImage = pickImage;
      });
    }
  }

  void saveUserData() {
    String name = nameController.text.trim();
    if (name.isNotEmpty) {
      ref
          .read(authControllerProvider)
          .saveUserData(context: context, name: name, profilePic: profileImage);
    }
  }

  // - dispose
  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 50),
        Stack(children: [
          profileImage == null
              ? const CircleAvatar(
                  backgroundImage: NetworkImage(
                    'https://i.pinimg.com/564x/6f/61/49/6f6149e35160ea4aad3826f6016f7533.jpg',
                  ),
                  radius: 64,
                )
              : CircleAvatar(
                  backgroundImage: FileImage(profileImage!),
                  radius: 64,
                ),
          Positioned(
            left: 80,
            bottom: -10,
            child: IconButton(
              onPressed: selectImageFromGallery,
              icon: const Icon(Icons.add_a_photo),
            ),
          ),
        ]),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              width: size.width * 0.85,
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(hintText: 'Enter your name'),
              ),
            ),
            IconButton(
              onPressed: saveUserData,
              icon: const Icon(Icons.done),
            ),
          ],
        ),
      ],
    ));
  }
}
