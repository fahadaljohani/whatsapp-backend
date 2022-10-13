// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/features/auth/controller/auth_controller.dart';

import 'package:whatsapp/features/status/repository/status_repository.dart';
import 'package:whatsapp/models/status.dart';

final statusControllerProvider = Provider(
  (ref) {
    final statusRepository = ref.read(statusRepositoryProvider);
    return Statuscontroller(statusRepository: statusRepository, ref: ref);
  },
);

class Statuscontroller {
  final StatusRepository statusRepository;
  final ProviderRef ref;
  Statuscontroller({
    required this.statusRepository,
    required this.ref,
  });

  void addStatus(BuildContext context, File statusImage) {
    ref.read(getUserDataControllerProvider).whenData((value) => {
          statusRepository.uploadStatus(
            context: context,
            file: statusImage,
            profilePic: value!.profilePic,
            phoneNumber: value.phoneNumber,
            username: value.name,
            uid: value.uid,
          )
        });
  }

  Future<List<Status>> getStatus({required BuildContext context}) {
    return statusRepository.getStatus(context: context);
  }
}
