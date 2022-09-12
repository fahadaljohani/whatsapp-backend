// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/features/chat/repository/chat_repository.dart';

final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatRepositoryController(chatRepository: chatRepository);
});

class ChatRepositoryController {
  final ChatRepository chatRepository;
  ChatRepositoryController({
    required this.chatRepository,
  });
}
