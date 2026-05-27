/* ------------------------------------------------------------
   Feature: Search – Search Repository
------------------------------------------------------------- */

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:africa_beuty/core/constants/server_constants.dart';
import 'package:africa_beuty/core/failure/failure.dart';
import 'package:africa_beuty/feature/auth/repositories/local_storage_service.dart';
import 'package:africa_beuty/feature/search/model/search.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;

/* ------------------------------------------------------------
   Interface
------------------------------------------------------------- */

abstract class SearchRepository {
  /// SEARCH across users, salons, services, hashtags
  Future<Either<AppFailure, List<SearchResult>>> search({
    required String query,
    int limit = 20,
  });

  /// SEARCH people only, for direct post sharing.
  Future<Either<AppFailure, List<SearchUserResult>>> searchUsers({
    required String query,
    int limit = 20,
  });
}

/* ------------------------------------------------------------
   Remote Implementation
------------------------------------------------------------- */

class SearchRepositoryImpl implements SearchRepository {
  @override
  Future<Either<AppFailure, List<SearchResult>>> search({
    required String query,
    int limit = 20,
  }) async {
    try {
      // 1. Get access token
      final token = await LocalStorageService.getAccessToken();
      if (token == null) {
        return Left(AppFailure('No access token'));
      }

      // 2. Build URI
      final uri = Uri.parse(
        '${ServerConstants.serverUrl}/search'
        '?q=${Uri.encodeQueryComponent(query)}'
        '&limit=$limit',
      );

      // 3. Send request
      final response = await http
          .get(
            uri,
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 15));

      // 4. Handle response
      if (response.statusCode != 200) {
        Map<String, dynamic>? body;
        try {
          body = jsonDecode(response.body);
        } catch (_) {}
        return Left(AppFailure(body?['detail'] ?? 'Search failed'));
      }

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final List resultsJson = decoded['results'] ?? [];

      // 5. Map backend snake_case → camelCase
      final results = resultsJson.map<SearchResult>((raw) {
        final Map<String, dynamic> map = _normalizeKeys(raw);
        return SearchResult.fromMap(map);
      }).toList();

      return Right(results);
    } on SocketException {
      return Left(AppFailure('No internet connection'));
    } on TimeoutException {
      return Left(AppFailure('Request timed out'));
    } catch (e) {
      return Left(AppFailure('Search error: $e'));
    }
  }

  @override
  Future<Either<AppFailure, List<SearchUserResult>>> searchUsers({
    required String query,
    int limit = 20,
  }) async {
    try {
      final token = await LocalStorageService.getAccessToken();
      if (token == null) {
        return Left(AppFailure('No access token'));
      }

      final uri = Uri.parse(
        '${ServerConstants.serverUrl}/search/users'
        '?q=${Uri.encodeQueryComponent(query)}'
        '&limit=$limit',
      );

      final response = await http
          .get(
            uri,
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        Map<String, dynamic>? body;
        try {
          body = jsonDecode(response.body);
        } catch (_) {}
        return Left(AppFailure(body?['detail'] ?? 'User search failed'));
      }

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final List resultsJson = decoded['results'] ?? [];

      return Right(
        resultsJson
            .whereType<Map<String, dynamic>>()
            .map((raw) => SearchUserResult.fromMap(_normalizeKeys(raw)))
            .toList(),
      );
    } on SocketException {
      return Left(AppFailure('No internet connection'));
    } on TimeoutException {
      return Left(AppFailure('Request timed out'));
    } catch (e) {
      return Left(AppFailure('User search error: $e'));
    }
  }

  /* ------------------------------------------------------------
     Snake_case → camelCase normalization
  ------------------------------------------------------------- */

  Map<String, dynamic> _normalizeKeys(Map<String, dynamic> raw) {
    return {
      'id': raw['id'],
      'entity': raw['entity'],
      'score': raw['score'],

      // USER
      'username': raw['username'],
      'fullName': raw['full_name'],
      'avatarUrl': raw['avatar_url'],

      // SALON
      'slogan': raw['slogan'],
      'title': raw['title'],
      'coverImage': raw['cover_image'],
      'isVerified': raw['is_verified'],
      'ownerName': raw['owner_name'],

      // SERVICE
      'serviceName': raw['service_name'],
      'category': raw['category'],
      'parentServiceName': raw['parent_service_name'],
      'priceMin': raw['price_min'],
      'priceMax': raw['price_max'],
      'imageUrl': raw['image_url'],

      // HASHTAG
      'tag': raw['tag'],
      'postCount': raw['post_count'],
    };
  }
}
