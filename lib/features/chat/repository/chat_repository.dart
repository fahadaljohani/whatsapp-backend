// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/features/auth/controller/auth_controller.dart';

final chatRepositoryProvider = Provider(
  (ref) => ChatRepository(firestore: FirebaseFirestore.instance, ref: ref),
);

class ChatRepository {
  final FirebaseFirestore firestore;
  final ProviderRef ref;
  ChatRepository({
    required this.firestore,
    required this.ref,
  });
}
