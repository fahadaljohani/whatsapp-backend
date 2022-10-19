// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/features/auth/controller/auth_controller.dart';

import 'package:whatsapp/features/group/repository/group_repository.dart';

final groupControllerProvider = Provider((ref) {
  final groupRepository = ref.read(groupRepositoryProvider);
  return GroupController(groupRepository: groupRepository, ref: ref);
});

class GroupController {
  final GroupRepository groupRepository;
  final ProviderRef ref;
  GroupController({
    required this.groupRepository,
    required this.ref,
  });

  void createGroup(
    BuildContext context,
    File profilePic,
    String name,
    List<Contact> contacts,
  ) {
    ref.read(getUserDataControllerProvider).whenData((value) {
      groupRepository.createGroup(
        context: context,
        profilePic: profilePic,
        name: name,
        contacts: contacts,
        senderId: value!.uid,
      );
    });
  }
}
