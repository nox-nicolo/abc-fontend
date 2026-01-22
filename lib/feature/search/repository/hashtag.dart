/* ------------------------------------------------------------
   Feature: Hashtag – Hashtag Grid Repository
------------------------------------------------------------- */

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:africa_beuty/core/constants/server_constants.dart';
import 'package:africa_beuty/core/failure/failure.dart';
import 'package:africa_beuty/feature/auth/repositories/local_storage_service.dart';
import 'package:africa_beuty/feature/search/model/hashtag.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;

/* ------------------------------------------------------------
   Interface
------------------------------------------------------------- */

abstract class HashtagRepository {
  /// Get hashtag grid (header + post image previews)
  Future<Either<AppFailure, HashtagGridModel>> getHashtagGrid({
    required String hashtagId,
    String? cursor,
    int limit = 24,
  });
}

/* ------------------------------------------------------------
   Remote Implementation
------------------------------------------------------------- */

class HashtagRepositoryImpl implements HashtagRepository {
  @override
  Future<Either<AppFailure, HashtagGridModel>> getHashtagGrid({
    required String hashtagId,
    String? cursor,
    int limit = 24,
  }) async {
    try {

      // Get access token
      final token = await LocalStorageService.getAccessToken();
      if (token == null) {
        return Left(AppFailure('No access token'));
      }

      // Build URI
      final uri = Uri.parse(
        '${ServerConstants.serverUrl}/search/hashtags'
        '?id=$hashtagId'
        '&limit=$limit'
        '${cursor != null ? '&cursor=$cursor' : ''}',
      );

      // Send request
      final response = await http
          .get(
            uri,
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 15));
      print(response.body);
      // Handle non-200 responses
      if (response.statusCode != 200) {
        Map<String, dynamic>? body;
        try {
          body = jsonDecode(response.body);
        } catch (_) {}

        return Left(
          AppFailure(body?['detail'] ?? 'Failed to load hashtag'),
        );
      }

      // Decode JSON (NO NORMALIZATION)
      final decoded =
          jsonDecode(response.body) as Map<String, dynamic>;

      // Parse directly into model
      final model = HashtagGridModel.fromMap(decoded);

      return Right(model);
    } on SocketException {
      return Left(AppFailure('No internet connection'));
    } on TimeoutException {
      return Left(AppFailure('Request timed out'));
    } catch (e) {
      return Left(AppFailure('Hashtag error: $e'));
    }
  }
}
