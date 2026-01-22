// feature/post/repositories/hashtag_repository.dart
import 'dart:convert';

import 'package:africa_beuty/core/constants/server_constants.dart';
import 'package:africa_beuty/core/failure/failure.dart';
import 'package:africa_beuty/feature/post/model/post_hashtags.dart';
import 'package:africa_beuty/feature/auth/repositories/local_storage_service.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;

/// Interface
abstract class HashtagRepository {
  Future<Either<AppFailure, List<PostHashtagsModel>>> search(String query);
  Future<Either<AppFailure, List<PostHashtagsModel>>> trending();
  Future<Either<AppFailure, List<PostHashtagsModel>>> suggestions();
}

/// Remote implementation (simple)
class HashtagRepositoryImpl implements HashtagRepository {
  @override
  Future<Either<AppFailure, List<PostHashtagsModel>>> search(String query) async {
    try {

      final token = await LocalStorageService.getAccessToken();

      if (token == null) return Left(AppFailure('No access token'));

      final uri = Uri.parse('${ServerConstants.serverUrl}/posts/hashtags/search?q=${Uri.encodeQueryComponent(query)}');
      
      final resp = await http.get(uri, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      });

      if (resp.statusCode != 200) {
        final body = jsonDecode(resp.body);
        return Left(AppFailure(body['detail'] ?? 'Search failed'));
      }

      final data = jsonDecode(resp.body) as List;
      final tags = data.map((e) => PostHashtagsModel.fromMap(e as Map<String, dynamic>)).toList();
      return Right(tags);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, List<PostHashtagsModel>>> trending() async {
    try {
      final token = await LocalStorageService.getAccessToken();
      if (token == null) return Left(AppFailure('No access token'));
      final uri = Uri.parse('${ServerConstants.serverUrl}/posts/hashtags/popular');
      final resp = await http.get(uri, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      });

      if (resp.statusCode != 200) {
        final body = jsonDecode(resp.body);
        return Left(AppFailure(body['detail'] ?? 'Failed to load trending hashtags'));
      }

      final data = jsonDecode(resp.body) as List;
      final tags = data.map((e) => PostHashtagsModel.fromMap(e as Map<String, dynamic>)).toList();
      return Right(tags);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, List<PostHashtagsModel>>> suggestions() async {
    // alias for trending or dedicated endpoint
    return trending();
  }
}
