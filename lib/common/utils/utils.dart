import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void showSnackBar({required BuildContext context, required String content}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}

Future<File?> pickImageFromGallery(ImageSource imageSource) async {
  File? pickedImage;
  final pickImage = await ImagePicker().pickImage(source: imageSource);
  if (pickImage != null) {
    pickedImage = File(pickImage.path);
  }
  return pickedImage;
}
