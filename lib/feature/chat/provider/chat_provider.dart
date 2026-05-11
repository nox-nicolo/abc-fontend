import 'package:africa_beuty/feature/chat/model/chat.dart';
import 'package:africa_beuty/feature/chat/repository/chat_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepositoryImpl();
});

final chatConversationsProvider =
    FutureProvider.autoDispose<List<ChatConversation>>((ref) async {
      final result = await ref.read(chatRepositoryProvider).conversations();
      return result.fold((failure) => throw failure.message, (items) => items);
    });

final chatThreadProvider = FutureProvider.autoDispose
    .family<ChatThread, String>((ref, conversationId) async {
      final result = await ref
          .read(chatRepositoryProvider)
          .messages(conversationId);
      return result.fold(
        (failure) => throw failure.message,
        (thread) => thread,
      );
    });
