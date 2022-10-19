import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/common/widgets/error.dart';
import 'package:whatsapp/common/widgets/loader.dart';
import 'package:whatsapp/features/select_contact/controller/select_contact_controller.dart';

final selectedContactsProvider = StateProvider<List<Contact>>((ref) => []);

class SelectGroupContact extends ConsumerStatefulWidget {
  const SelectGroupContact({super.key});

  @override
  ConsumerState<SelectGroupContact> createState() => _SelectGroupContactState();
}

class _SelectGroupContactState extends ConsumerState<SelectGroupContact> {
  List<Contact> selectedContact = [];

  void selectContact(Contact contact) {
    if (selectedContact.contains(contact)) {
      selectedContact.remove(contact);
    } else {
      selectedContact.add(contact);
    }

    ref.read(selectedContactsProvider.state).update(
          (state) => selectedContact,
        );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(getContactsController).when(
        data: (contactList) {
          return Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: contactList.length,
                itemBuilder: (context, index) {
                  final contact = contactList[index];
                  return InkWell(
                    onTap: () => selectContact(contact),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ListTile(
                        title: Text(contact.displayName),
                        leading: selectedContact.contains(contact)
                            ? const Icon(Icons.done, color: Colors.blue)
                            : null,
                      ),
                    ),
                  );
                }),
          );
        },
        error: (error, stackTrace) => ErrorScreen(error: error.toString()),
        loading: () => const Loader());
  }
}
