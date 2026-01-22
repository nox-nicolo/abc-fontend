/* ------------------------------------------------------------
   Feature: Home – Home Repository
------------------------------------------------------------- */

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:africa_beuty/core/constants/server_constants.dart';
import 'package:africa_beuty/core/failure/failure.dart';
import 'package:africa_beuty/feature/auth/repositories/local_storage_service.dart';
import 'package:africa_beuty/feature/home/model/categories.dart';
import 'package:africa_beuty/feature/home/model/home_posts.dart';
import 'package:africa_beuty/feature/home/model/post_like.dart';
import 'package:africa_beuty/feature/home/model/top_salon.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;

/* ------------------------------------------------------------
   Interface
------------------------------------------------------------- */

abstract class HomeRepository {
  Future<Either<AppFailure, List<TopSalonModel>>> getTopSalons();
  Future<Either<AppFailure, List<SelectedServiceModel>>> getCategories();
  Future<Either<AppFailure, FeedResponse>> getFeed({
    int limit = 20,
    String? cursor,
  });
  // Future<Either<AppFailure, List<EventModel>>> getEvents();
    Future<Either<AppFailure, PostLikeModel>> toggleLike({
    required String postId,
  });


}

/* ------------------------------------------------------------
   Remote Implementation
------------------------------------------------------------- */

class HomeRepositoryImpl implements HomeRepository {
  /* ------------------------------------------------------------
     TOP SALONS
  ------------------------------------------------------------- */
  @override
  Future<Either<AppFailure, List<TopSalonModel>>> getTopSalons({
    int limit = 10,
  }) async {
    try {
      final token = await LocalStorageService.getAccessToken();
      if (token == null) return Left(AppFailure('No access token'));

      final uri = Uri.parse(
        '${ServerConstants.serverUrl}/profile/top?limit=$limit',
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
        return Left(
          AppFailure(body?['detail'] ?? 'Failed to load top salons'),
        );
      }

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final List results = decoded['results'] ?? [];

      final salons = results
          .map((e) => TopSalonModel.fromMap(e as Map<String, dynamic>))
          .toList();

      return Right(salons);
    } on SocketException {
      return Left(AppFailure('No internet connection'));
    } on TimeoutException {
      return Left(AppFailure('Request timed out'));
    } catch (e) {
      return Left(AppFailure('Top salons error: $e'));
    }
  }


  /* ------------------------------------------------------------
     CATEGORIES
  ------------------------------------------------------------- */
  @override
  Future<Either<AppFailure, List<SelectedServiceModel>>> getCategories() async {
    try {
      final token = await LocalStorageService.getAccessToken();
      if (token == null) return Left(AppFailure('No access token'));

      final uri = Uri.parse(
        '${ServerConstants.serverUrl}/users/user_select_services',
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
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode != 200) {
        Map<String, dynamic>? body;
        try {
          body = jsonDecode(response.body);
        } catch (_) {}
        return Left(
          AppFailure(body?['detail'] ?? 'Failed to load categories'),
        );
      }

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final List services = decoded['selected_services'] ?? [];

      final categories = services
          .map(
            (e) => SelectedServiceModel.fromMap(
              e as Map<String, dynamic>,
            ),
          )
          .toList();

      return Right(categories);
    } on SocketException {
      return Left(AppFailure('No internet connection'));
    } on TimeoutException {
      return Left(AppFailure('Request timed out'));
    } catch (e) {
      return Left(AppFailure('Categories error: $e'));
    }
  }


  /* ------------------------------------------------------------
     HOME FEED
  ------------------------------------------------------------- */
  @override
  Future<Either<AppFailure, FeedResponse>> getFeed({
    int limit = 20,
    String? cursor,
  }) async {
    try {
      final token = await LocalStorageService.getAccessToken();
      if (token == null) return Left(AppFailure('No access token'));

      final uri = Uri.parse(
        '${ServerConstants.serverUrl}/posts'
        '?option=explore'
        '&limit=$limit'
        '${cursor != null ? '&cursor=$cursor' : ''}',
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
        return Left(
          AppFailure(body?['detail'] ?? 'Failed to load posts'),
        );
      }

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;

      final List<PostModel> items =
          (decoded['items'] as List? ?? [])
              .map((e) => PostModel.fromMap(e as Map<String, dynamic>))
              .toList();

      final String? nextCursor = decoded['next_cursor'];

      return Right(
        FeedResponse(
          items: items,
          nextCursor: nextCursor,
        ),
      );
    } on SocketException {
      return Left(AppFailure('No internet connection'));
    } on TimeoutException {
      return Left(AppFailure('Request timed out'));
    } catch (e) {
      return Left(AppFailure('Posts error: $e'));
    }
  }



  /* ------------------------------------------------------------
     EVENTS
  ------------------------------------------------------------- */
  // @override
  // Future<Either<AppFailure, List<EventModel>>> getEvents() async {
  //   try {
  //     final token = await LocalStorageService.getAccessToken();
  //     if (token == null) return Left(AppFailure('No access token'));

  //     final uri =
  //         Uri.parse('${ServerConstants.serverUrl}/events/upcoming');

  //     final response = await http
  //         .get(
  //           uri,
  //           headers: {
  //             'Authorization': 'Bearer $token',
  //             'Content-Type': 'application/json',
  //           },
  //         )
  //         .timeout(const Duration(seconds: 15));

  //     if (response.statusCode != 200) {
  //       return Left(AppFailure('Failed to load events'));
  //     }

  //     final decoded = jsonDecode(response.body) as Map<String, dynamic>;
  //     final List results = decoded['results'] ?? [];

  //     final events =
  //         results.map((e) => EventModel.fromMap(e)).toList();

  //     return Right(events);
  //   } on SocketException {
  //     return Left(AppFailure('No internet connection'));
  //   } on TimeoutException {
  //     return Left(AppFailure('Request timed out'));
  //   } catch (e) {
  //     return Left(AppFailure('Events error: $e'));
  //   }
  // }

  
  /* ------------------------------------------------------------
    Post Like
  ------------------------------------------------------------- */
  @override
  Future<Either<AppFailure, PostLikeModel>> toggleLike({
    required String postId,
  }) async {
    try {
      final token = await LocalStorageService.getAccessToken();
      if (token == null) return Left(AppFailure('No access token'));

      final uri = Uri.parse(
        '${ServerConstants.serverUrl}/posts/$postId/like',
      );

      final response = await http
          .post(
            uri,
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        return Left(AppFailure('Failed to like post'));
      }

      final Map<String, dynamic> decodedData = jsonDecode(response.body);
      
      // Pass the Map to fromMap instead of fromJson
      return Right(PostLikeModel.fromMap(decodedData));
    } on SocketException {
      return Left(AppFailure('No internet connection'));
    } on TimeoutException {
      return Left(AppFailure('Request timed out'));
    } catch (e) {
      return Left(AppFailure('Like error: $e'));
    }
  }

}



class FeedResponse {
  FeedResponse({
    required this.items,
    required this.nextCursor,
  });

  final List<PostModel> items;
  final String? nextCursor;
}
