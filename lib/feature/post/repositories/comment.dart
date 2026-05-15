import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:africa_beuty/core/constants/server_constants.dart';
import 'package:africa_beuty/core/failure/failure.dart';
import 'package:africa_beuty/core/http/api_client.dart';
import 'package:africa_beuty/feature/post/model/comment.dart';
import 'package:fpdart/fpdart.dart';

abstract class CommentRepository {
  Future<Either<AppFailure, CommentListPage>> list({
    required String postId,
    String? parentCommentId,
    String? cursor,
    int limit = 20,
  });

  Future<Either<AppFailure, CommentModel>> create({
    required String postId,
    required String content,
    String? parentCommentId,
  });

  Future<Either<AppFailure, bool>> delete({
    required String postId,
    required String commentId,
  });

  Future<Either<AppFailure, ({bool liked, int likesCount})>> toggleLike({
    required String postId,
    required String commentId,
  });
}

class CommentRepositoryImpl implements CommentRepository {
  @override
  Future<Either<AppFailure, CommentListPage>> list({
    required String postId,
    String? parentCommentId,
    String? cursor,
    int limit = 20,
  }) async {
    try {
      final params = <String, String>{
        'limit': limit.toString(),
        if (cursor != null) 'cursor': cursor,
        if (parentCommentId != null) 'parent_comment_id': parentCommentId,
      };

      final uri = Uri.parse(
        '${ServerConstants.serverUrl}/posts/$postId/comments',
      ).replace(queryParameters: params);

      final response = await ApiClient.instance
          .get(uri)
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        return Right(CommentListPage.fromMap(body));
      }

      final body = _safeDecode(response.body);
      return Left(AppFailure(body?['detail'] ?? 'Failed to load comments'));
    } on SocketException {
      return Left(AppFailure('No internet connection'));
    } on TimeoutException {
      return Left(AppFailure('Request timed out'));
    } on SessionExpiredException catch (e) {
      return Left(AppFailure(e.toString()));
    } catch (e) {
      return Left(AppFailure('Load comments error: $e'));
    }
  }

  @override
  Future<Either<AppFailure, CommentModel>> create({
    required String postId,
    required String content,
    String? parentCommentId,
  }) async {
    try {
      final uri = Uri.parse(
        '${ServerConstants.serverUrl}/posts/$postId/comments',
      );

      final response = await ApiClient.instance
          .post(
            uri,
            extra: const {'Content-Type': 'application/json'},
            body: jsonEncode({
              'content': content,
              if (parentCommentId != null) 'parent_comment_id': parentCommentId,
            }),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        return Right(CommentModel.fromMap(body));
      }

      final body = _safeDecode(response.body);
      return Left(AppFailure(body?['detail'] ?? 'Failed to post comment'));
    } on SocketException {
      return Left(AppFailure('No internet connection'));
    } on TimeoutException {
      return Left(AppFailure('Request timed out'));
    } on SessionExpiredException catch (e) {
      return Left(AppFailure(e.toString()));
    } catch (e) {
      return Left(AppFailure('Post comment error: $e'));
    }
  }

  @override
  Future<Either<AppFailure, bool>> delete({
    required String postId,
    required String commentId,
  }) async {
    try {
      final uri = Uri.parse(
        '${ServerConstants.serverUrl}/posts/$postId/comments/$commentId',
      );

      final response = await ApiClient.instance
          .delete(uri)
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) return const Right(true);

      final body = _safeDecode(response.body);
      return Left(AppFailure(body?['detail'] ?? 'Failed to delete comment'));
    } on SocketException {
      return Left(AppFailure('No internet connection'));
    } on TimeoutException {
      return Left(AppFailure('Request timed out'));
    } on SessionExpiredException catch (e) {
      return Left(AppFailure(e.toString()));
    } catch (e) {
      return Left(AppFailure('Delete comment error: $e'));
    }
  }

  @override
  Future<Either<AppFailure, ({bool liked, int likesCount})>> toggleLike({
    required String postId,
    required String commentId,
  }) async {
    try {
      final uri = Uri.parse(
        '${ServerConstants.serverUrl}/posts/$postId/comments/$commentId/like',
      );

      final response = await ApiClient.instance
          .post(uri)
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        return Right((
          liked: body['liked'] as bool? ?? false,
          likesCount: (body['likes_count'] as num?)?.toInt() ?? 0,
        ));
      }

      final body = _safeDecode(response.body);
      return Left(AppFailure(body?['detail'] ?? 'Failed to like comment'));
    } on SocketException {
      return Left(AppFailure('No internet connection'));
    } on TimeoutException {
      return Left(AppFailure('Request timed out'));
    } on SessionExpiredException catch (e) {
      return Left(AppFailure(e.toString()));
    } catch (e) {
      return Left(AppFailure('Like comment error: $e'));
    }
  }
}

Map<String, dynamic>? _safeDecode(String body) {
  try {
    return jsonDecode(body) as Map<String, dynamic>;
  } catch (_) {
    return null;
  }
}
