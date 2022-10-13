import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/colors.dart';
import 'package:whatsapp/features/status/controller/status_controller.dart';

class ConfirmStatusScreen extends ConsumerWidget {
  static const String routeName = '/confirm-status-screen';
  final File file;
  const ConfirmStatusScreen({super.key, required this.file});

  void addStatus(BuildContext context, WidgetRef ref) {
    ref.read(statusControllerProvider).addStatus(context, file);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: const Text('confirm status'),
      ),
      body: AspectRatio(
        aspectRatio: 9 / 16,
        child: Image.file(file),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addStatus(context, ref),
        backgroundColor: tabColor,
        child: const Icon(
          Icons.done,
          color: whiteColor,
        ),
      ),
    );
  }
}
