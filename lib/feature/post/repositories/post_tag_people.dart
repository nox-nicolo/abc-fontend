import 'dart:convert';
import 'package:africa_beuty/core/constants/server_constants.dart';
import 'package:africa_beuty/core/failure/failure.dart';
import 'package:africa_beuty/core/http/paginated_response.dart';
import 'package:africa_beuty/feature/auth/repositories/local_storage_service.dart';
import 'package:africa_beuty/feature/post/model/post_tag_people.dart';
import 'package:africa_beuty/feature/post/repositories/post_tag_people_local.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;

abstract class TagPeopleRepository {
  Future<Either<AppFailure, List<PostTagPeopleModel>>> searchUsers(
    String query,
  );

  Future<Either<AppFailure, List<PostTagPeopleModel>>> getRecommendedUsers();

  Future<Either<AppFailure, List<PostTagPeopleModel>>> getRecentUsers();

  Future<List<PostTagPeopleModel>> getCachedUsers();

  Future<void> cacheUsers(List<PostTagPeopleModel> users);
}

class TagPeopleRepositoryImpl implements TagPeopleRepository {
  List<PostTagPeopleModel>? _cachedUsers;

  // --------------------------
  // SEARCH
  // --------------------------
  @override
  Future<Either<AppFailure, List<PostTagPeopleModel>>> searchUsers(
    String query,
  ) async {
    try {
      final token = await LocalStorageService.getAccessToken();

      if (token == null) return Left(AppFailure("No access token found"));

      final request = Uri.parse(
        '${ServerConstants.serverUrl}/users/tags/search?query=${Uri.encodeQueryComponent(query)}',
      );
      print(request);

      final response = await http.get(
        request,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final json = jsonDecode(response.body);

      if (response.statusCode != 200) {
        return Left(AppFailure(json['detail'] ?? 'Search failed'));
      }

      final users = listFromPaginatedBody(
        json,
      ).map((e) => PostTagPeopleModel.fromMap(e)).toList();

      return Right(users);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  // --------------------------
  // RECOMMENDED USERS
  // --------------------------
  @override
  Future<Either<AppFailure, List<PostTagPeopleModel>>>
  getRecommendedUsers() async {
    try {
      final token = await LocalStorageService.getAccessToken();
      if (token == null) return Left(AppFailure("No access token found"));

      final response = await http.get(
        Uri.parse('${ServerConstants.serverUrl}/users/tags/recommended'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final json = jsonDecode(response.body);

      if (response.statusCode != 200) {
        return Left(
          AppFailure(json['detail'] ?? 'Failed to load recommendations'),
        );
      }

      final users = listFromPaginatedBody(
        json,
      ).map((e) => PostTagPeopleModel.fromMap(e)).toList();

      await cacheUsers(users);

      return Right(users);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  // --------------------------
  // RECENT USERS
  // --------------------------
  @override
  Future<Either<AppFailure, List<PostTagPeopleModel>>> getRecentUsers() async {
    try {
      final users = await TagPeopleLocalRepository.getRecentUsers();
      // Always return success (even if the list is empty) instead of an AppFailure.
      return Right(users);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  // --------------------------
  // IN-MEMORY CACHE
  // --------------------------
  @override
  Future<void> cacheUsers(List<PostTagPeopleModel> users) async {
    _cachedUsers = users;
  }

  @override
  Future<List<PostTagPeopleModel>> getCachedUsers() async {
    return _cachedUsers ?? [];
  }
}
