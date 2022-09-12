// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:whatsapp/features/select_contact/repository/select_contact_repository.dart';

final getContactsController = FutureProvider((ref) {
  final contactController = ref.watch(selectContactsRepositoryProvider);
  return contactController.getContacts();
});

final selectContactControllerProvider = Provider((ref) {
  final selectContactRepository = ref.read(selectContactsRepositoryProvider);
  return SelectContactController(
      selectContactRepository: selectContactRepository);
});

class SelectContactController {
  final SelectContactRepository selectContactRepository;
  SelectContactController({
    required this.selectContactRepository,
  });
  void selectContact(BuildContext context, Contact contact) {
    selectContactRepository.selectContact(context: context, contact: contact);
  }
}
