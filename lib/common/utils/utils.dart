// import 'package:enough_giphy_flutter/enough_giphy_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void showSnackBar({required BuildContext context, required String content}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}

Future<File?> pickImageFromGallery() async {
  File? image;
  final pickedImage =
      await ImagePicker().pickImage(source: ImageSource.gallery);
  if (pickedImage != null) {
    image = File(pickedImage.path);
  }
  return image;
}

Future<File?> pickVideoFromGallery() async {
  File? video;
  final pickedVideo =
      await ImagePicker().pickVideo(source: ImageSource.gallery);
  if (pickedVideo != null) {
    video = File(pickedVideo.path);
  }
  return video;
}

// Future<GiphyGif?> pickGif(BuildContext context) async {
//   GiphyGif? gif;
//   try {
//     const String apiKey = "0qOF4UQbsfX0Tv5NHTIqeG0cmqfZym6V";
//     gif = await Giphy.getGif(context: context, apiKey: apiKey);
//   } catch (e) {
//     showSnackBar(context: context, content: e.toString());
//   }
//   return gif;
// }
