/* ------------------------------------------------------------
   Feature: Post – Repository
------------------------------------------------------------- */

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:africa_beuty/core/constants/server_constants.dart';
import 'package:africa_beuty/core/failure/failure.dart';
import 'package:africa_beuty/core/http/api_client.dart';
import 'package:africa_beuty/feature/auth/repositories/local_storage_service.dart';
import 'package:africa_beuty/feature/post/model/create_post.dart';
import 'package:africa_beuty/feature/post/model/post.dart';
import 'package:africa_beuty/feature/post/model/single_post_view.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;

/* ------------------------------------------------------------
   Interface
------------------------------------------------------------- */

abstract class PostRepository {
  Future<Either<AppFailure, String>> createPost(CreatePostModel post);

  Future<Either<AppFailure, bool>> updatePost(
    String postId,
    CreatePostModel post,
  );

  Future<Either<AppFailure, bool>> deletePost(String postId);

  Future<Either<AppFailure, bool>> repost(String postId);

  Future<Either<AppFailure, ({String? myReaction, Map<String, int> reactions})>>
  reactToPost({required String postId, required String reaction});

  Future<Either<AppFailure, int>> sharePost({
    required String postId,
    required List<String> userIds,
    String? message,
  });

  Future<Either<AppFailure, bool>> togglePin(String postId);

  Future<Either<AppFailure, bool>> toggleBookmark(String postId);

  Future<Either<AppFailure, SinglePostViewModel>> getSinglePostView(
    String postId,
  );

  Future<Either<AppFailure, OtherPostsSectionModel>> getMoreOtherPosts({
    required String postId,
    DateTime? cursor,
    int limit = 10,
  });

  Future<Either<AppFailure, List<PostModel>>> getFeed(int page);

  Future<Either<AppFailure, List<PostModel>>> getUserPosts(
    String userId,
    int page,
  );
}

/* ------------------------------------------------------------
   Remote Implementation
------------------------------------------------------------- */

class PostRepositoryImpl implements PostRepository {
  static const _postUploadTimeout = Duration(minutes: 2);

  /* ----------------------------------------------------------
     CREATE POST
  ----------------------------------------------------------- */
  @override
  Future<Either<AppFailure, String>> createPost(CreatePostModel post) async {
    try {
      final token = await LocalStorageService.getAccessToken();
      if (token == null) {
        return Left(AppFailure('No access token'));
      }

      final uri = Uri.parse('${ServerConstants.serverUrl}/posts/');

      final request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer $token'
        ..fields['caption'] = post.caption
        ..fields['post_type'] = post.postType
        ..fields['category'] = post.category
        ..fields['author'] = post.author
        ..fields['status'] = post.status
        ..fields['hashtags'] = jsonEncode(post.hashtags)
        ..fields['tagged'] = jsonEncode(post.tagged)
        ..fields['settings'] = jsonEncode(post.settings.toMap())
        ..fields['media_metadata'] = jsonEncode(
          post.media.map((m) => {'aspect_ratio': m.aspectRatio}).toList(),
        );

      for (final media in post.media) {
        final file = File(media.path);
        if (!await file.exists()) {
          return Left(AppFailure('File not found: ${media.path}'));
        }

        request.files.add(
          await http.MultipartFile.fromPath('media', file.path),
        );
      }

      final streamed = await request.send().timeout(_postUploadTimeout);
      final response = await http.Response.fromStream(streamed);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = _safeDecode(response.body);
        final postId = body?['post_id']?.toString();
        if (postId == null || postId.isEmpty) {
          return Left(
            AppFailure(
              'Post created, but the server did not return a post id.',
            ),
          );
        }
        return Right(postId);
      }

      final body = _safeDecode(response.body);
      return Left(AppFailure(body?['detail'] ?? 'Failed to create post'));
    } on SocketException {
      return Left(AppFailure('No internet connection'));
    } on TimeoutException {
      return Left(
        AppFailure(
          'Post upload is taking longer than expected. Please check your posts before trying again.',
        ),
      );
    } catch (e) {
      return Left(AppFailure('Create post error: $e'));
    }
  }

  /* ----------------------------------------------------------
     SINGLE POST VIEW
  ----------------------------------------------------------- */
  @override
  Future<Either<AppFailure, SinglePostViewModel>> getSinglePostView(
    String postId,
  ) async {
    try {
      final token = await LocalStorageService.getAccessToken();
      if (token == null) {
        return Left(AppFailure('No access token'));
      }

      final uri = Uri.parse('${ServerConstants.serverUrl}/posts/$postId');

      final response = await http
          .get(
            uri,
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        return Right(SinglePostViewModel.fromMap(body));
      }

      final body = _safeDecode(response.body);
      return Left(AppFailure(body?['detail'] ?? 'Failed to load post'));
    } on SocketException {
      return Left(AppFailure('No internet connection'));
    } on TimeoutException {
      return Left(AppFailure('Request timed out'));
    } catch (e) {
      return Left(AppFailure('Load post error: $e'));
    }
  }

  /* ----------------------------------------------------------
     OTHER POSTS (CURSOR)
  ----------------------------------------------------------- */
  @override
  Future<Either<AppFailure, OtherPostsSectionModel>> getMoreOtherPosts({
    required String postId,
    DateTime? cursor,
    int limit = 10,
  }) async {
    try {
      final token = await LocalStorageService.getAccessToken();
      if (token == null) {
        return Left(AppFailure('No access token'));
      }

      final params = <String, String>{
        'limit': limit.toString(),
        if (cursor != null) 'cursor': cursor.toIso8601String(),
      };

      final uri = Uri.parse(
        '${ServerConstants.serverUrl}/posts/$postId/other-posts',
      ).replace(queryParameters: params);

      final response = await http
          .get(
            uri,
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return Right(OtherPostsSectionModel.fromMap(body));
      }

      final body = _safeDecode(response.body);
      return Left(AppFailure(body?['detail'] ?? 'Failed to load more posts'));
    } on SocketException {
      return Left(AppFailure('No internet connection'));
    } on TimeoutException {
      return Left(AppFailure('Request timed out'));
    } catch (e) {
      return Left(AppFailure('Load more posts error: $e'));
    }
  }

  /* ----------------------------------------------------------
     SAFE DEFAULTS (NO CRASHES)
  ----------------------------------------------------------- */

  @override
  Future<Either<AppFailure, bool>> deletePost(String postId) async {
    try {
      final response = await ApiClient.instance
          .delete(Uri.parse('${ServerConstants.serverUrl}/posts/$postId'))
          .timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) return const Right(true);
      final body = _safeDecode(response.body);
      return Left(AppFailure(body?['detail'] ?? 'Failed to delete post'));
    } on SocketException {
      return Left(AppFailure('No internet connection'));
    } on TimeoutException {
      return Left(AppFailure('Request timed out'));
    } on SessionExpiredException catch (e) {
      return Left(AppFailure(e.toString()));
    } catch (e) {
      return Left(AppFailure('Delete post error: $e'));
    }
  }

  @override
  Future<Either<AppFailure, bool>> repost(String postId) async {
    try {
      final response = await ApiClient.instance
          .post(Uri.parse('${ServerConstants.serverUrl}/posts/$postId/repost'))
          .timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        final body = _safeDecode(response.body);
        final reposted = (body?['reposted'] as bool?) ?? true;
        return Right(reposted);
      }
      final body = _safeDecode(response.body);
      return Left(AppFailure(body?['detail'] ?? 'Failed to repost'));
    } on SocketException {
      return Left(AppFailure('No internet connection'));
    } on TimeoutException {
      return Left(AppFailure('Request timed out'));
    } on SessionExpiredException catch (e) {
      return Left(AppFailure(e.toString()));
    } catch (e) {
      return Left(AppFailure('Repost error: $e'));
    }
  }

  @override
  Future<Either<AppFailure, ({String? myReaction, Map<String, int> reactions})>>
  reactToPost({required String postId, required String reaction}) async {
    try {
      final response = await ApiClient.instance
          .post(
            Uri.parse('${ServerConstants.serverUrl}/posts/$postId/reactions'),
            extra: {'Content-Type': 'application/json'},
            body: jsonEncode({'reaction': reaction}),
          )
          .timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        final body = _safeDecode(response.body) ?? {};
        final reactions = (body['reactions'] as Map<String, dynamic>? ?? {})
            .map((key, value) => MapEntry(key, (value as num?)?.toInt() ?? 0));
        return Right((
          myReaction: body['my_reaction'] as String?,
          reactions: reactions,
        ));
      }
      final body = _safeDecode(response.body);
      return Left(AppFailure(body?['detail'] ?? 'Failed to react'));
    } on SocketException {
      return Left(AppFailure('No internet connection'));
    } on TimeoutException {
      return Left(AppFailure('Request timed out'));
    } on SessionExpiredException catch (e) {
      return Left(AppFailure(e.toString()));
    } catch (e) {
      return Left(AppFailure('Reaction error: $e'));
    }
  }

  @override
  Future<Either<AppFailure, int>> sharePost({
    required String postId,
    required List<String> userIds,
    String? message,
  }) async {
    try {
      final response = await ApiClient.instance
          .post(
            Uri.parse('${ServerConstants.serverUrl}/posts/$postId/share'),
            extra: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'user_ids': userIds,
              if (message != null && message.trim().isNotEmpty)
                'message': message.trim(),
            }),
          )
          .timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        final body = _safeDecode(response.body) ?? {};
        return Right((body['shared_count'] as num?)?.toInt() ?? 0);
      }
      final body = _safeDecode(response.body);
      return Left(AppFailure(body?['detail'] ?? 'Failed to share post'));
    } on SocketException {
      return Left(AppFailure('No internet connection'));
    } on TimeoutException {
      return Left(AppFailure('Request timed out'));
    } on SessionExpiredException catch (e) {
      return Left(AppFailure(e.toString()));
    } catch (e) {
      return Left(AppFailure('Share post error: $e'));
    }
  }

  @override
  Future<Either<AppFailure, bool>> toggleBookmark(String postId) async {
    try {
      final response = await ApiClient.instance
          .post(
            Uri.parse('${ServerConstants.serverUrl}/posts/$postId/bookmark'),
          )
          .timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        final body = _safeDecode(response.body);
        final saved = (body?['saved'] as bool?) ?? false;
        return Right(saved);
      }
      final body = _safeDecode(response.body);
      return Left(AppFailure(body?['detail'] ?? 'Failed to bookmark post'));
    } on SocketException {
      return Left(AppFailure('No internet connection'));
    } on TimeoutException {
      return Left(AppFailure('Request timed out'));
    } on SessionExpiredException catch (e) {
      return Left(AppFailure(e.toString()));
    } catch (e) {
      return Left(AppFailure('Bookmark error: $e'));
    }
  }

  @override
  Future<Either<AppFailure, bool>> togglePin(String postId) async {
    try {
      final response = await ApiClient.instance
          .post(Uri.parse('${ServerConstants.serverUrl}/posts/$postId/pin'))
          .timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        final body = _safeDecode(response.body);
        final pinned = (body?['pinned'] as bool?) ?? true;
        return Right(pinned);
      }
      final body = _safeDecode(response.body);
      return Left(AppFailure(body?['detail'] ?? 'Failed to pin post'));
    } on SocketException {
      return Left(AppFailure('No internet connection'));
    } on TimeoutException {
      return Left(AppFailure('Request timed out'));
    } on SessionExpiredException catch (e) {
      return Left(AppFailure(e.toString()));
    } catch (e) {
      return Left(AppFailure('Pin post error: $e'));
    }
  }

  @override
  Future<Either<AppFailure, List<PostModel>>> getFeed(int page) async =>
      Left(AppFailure('Not implemented'));

  @override
  Future<Either<AppFailure, List<PostModel>>> getUserPosts(
    String userId,
    int page,
  ) async => Left(AppFailure('Not implemented'));

  @override
  Future<Either<AppFailure, bool>> updatePost(
    String postId,
    CreatePostModel post,
  ) async => Left(AppFailure('Not implemented'));
}

/* ------------------------------------------------------------
   Helpers
------------------------------------------------------------- */

Map<String, dynamic>? _safeDecode(String body) {
  try {
    return jsonDecode(body) as Map<String, dynamic>;
  } catch (_) {
    return null;
  }
}
