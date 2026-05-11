import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:africa_beuty/core/constants/server_constants.dart';
import 'package:africa_beuty/core/failure/failure.dart';
import 'package:africa_beuty/core/http/api_client.dart';
import 'package:africa_beuty/feature/chat/model/chat.dart';
import 'package:fpdart/fpdart.dart';

abstract class ChatRepository {
  Future<Either<AppFailure, List<ChatConversation>>> conversations();
  Future<Either<AppFailure, ChatConversation>> startConversation(
    String salonId,
  );
  Future<Either<AppFailure, ChatThread>> messages(String conversationId);
  Future<Either<AppFailure, ChatMessage>> sendMessage({
    required String conversationId,
    required String body,
  });
}

class ChatRepositoryImpl implements ChatRepository {
  @override
  Future<Either<AppFailure, List<ChatConversation>>> conversations() async {
    try {
      final uri = Uri.parse('${ServerConstants.serverUrl}/chat/conversations');
      final response = await ApiClient.instance.get(uri);
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final items = (body['items'] as List<dynamic>? ?? [])
            .map((e) => ChatConversation.fromMap(e as Map<String, dynamic>))
            .toList();
        return Right(items);
      }
      return Left(AppFailure(_detail(response.body, 'Failed to load chats')));
    } on SocketException {
      return Left(AppFailure('No internet connection'));
    } on TimeoutException {
      return Left(AppFailure('Request timed out'));
    } on SessionExpiredException catch (e) {
      return Left(AppFailure(e.toString()));
    } catch (e) {
      return Left(AppFailure('Load chats error: $e'));
    }
  }

  @override
  Future<Either<AppFailure, ChatConversation>> startConversation(
    String salonId,
  ) async {
    try {
      final uri = Uri.parse('${ServerConstants.serverUrl}/chat/conversations');
      final response = await ApiClient.instance.post(
        uri,
        extra: {'Content-Type': 'application/json'},
        body: jsonEncode({'salon_id': salonId}),
      );
      if (response.statusCode == 200) {
        return Right(ChatConversation.fromMap(jsonDecode(response.body)));
      }
      return Left(AppFailure(_detail(response.body, 'Failed to start chat')));
    } on SocketException {
      return Left(AppFailure('No internet connection'));
    } on TimeoutException {
      return Left(AppFailure('Request timed out'));
    } on SessionExpiredException catch (e) {
      return Left(AppFailure(e.toString()));
    } catch (e) {
      return Left(AppFailure('Start chat error: $e'));
    }
  }

  @override
  Future<Either<AppFailure, ChatThread>> messages(String conversationId) async {
    try {
      final uri = Uri.parse(
        '${ServerConstants.serverUrl}/chat/conversations/$conversationId/messages',
      );
      final response = await ApiClient.instance.get(uri);
      if (response.statusCode == 200) {
        return Right(ChatThread.fromMap(jsonDecode(response.body)));
      }
      return Left(
        AppFailure(_detail(response.body, 'Failed to load messages')),
      );
    } on SocketException {
      return Left(AppFailure('No internet connection'));
    } on TimeoutException {
      return Left(AppFailure('Request timed out'));
    } on SessionExpiredException catch (e) {
      return Left(AppFailure(e.toString()));
    } catch (e) {
      return Left(AppFailure('Load messages error: $e'));
    }
  }

  @override
  Future<Either<AppFailure, ChatMessage>> sendMessage({
    required String conversationId,
    required String body,
  }) async {
    try {
      final uri = Uri.parse(
        '${ServerConstants.serverUrl}/chat/conversations/$conversationId/messages',
      );
      final response = await ApiClient.instance.post(
        uri,
        extra: {'Content-Type': 'application/json'},
        body: jsonEncode({'body': body}),
      );
      if (response.statusCode == 200) {
        return Right(ChatMessage.fromMap(jsonDecode(response.body)));
      }
      return Left(AppFailure(_detail(response.body, 'Failed to send message')));
    } on SocketException {
      return Left(AppFailure('No internet connection'));
    } on TimeoutException {
      return Left(AppFailure('Request timed out'));
    } on SessionExpiredException catch (e) {
      return Left(AppFailure(e.toString()));
    } catch (e) {
      return Left(AppFailure('Send message error: $e'));
    }
  }
}

String _detail(String body, String fallback) {
  try {
    final decoded = jsonDecode(body) as Map<String, dynamic>;
    return decoded['detail']?.toString() ?? fallback;
  } catch (_) {
    return fallback;
  }
}
