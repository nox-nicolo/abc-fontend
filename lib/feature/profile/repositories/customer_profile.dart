import 'dart:async';
import 'dart:convert';

import 'package:africa_beuty/core/constants/server_constants.dart';
import 'package:africa_beuty/core/failure/failure.dart';
import 'package:africa_beuty/core/http/api_client.dart';
import 'package:africa_beuty/core/http/response_body.dart';
import 'package:africa_beuty/feature/profile/model/customer_profile.dart';
import 'package:africa_beuty/feature/profile/model/following.dart';
import 'package:fpdart/fpdart.dart';

class CustomerProfileRepository {
  // ── GET /users/me/profile ─────────────────────────────────────────
  Future<Either<AppFailure, CustomerProfileModel>> getMyProfile() async {
    try {
      final uri = Uri.parse('${ServerConstants.serverUrl}/users/me/profile');
      final response = await ApiClient.instance
          .get(uri)
          .timeout(const Duration(seconds: 15));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = decodeMapOrThrow(response);
        return Right(CustomerProfileModel.fromMap(decoded));
      }
      return Left(
        AppFailure(responseErrorMessage(response, 'Failed to load profile')),
      );
    } on TimeoutException {
      return Left(AppFailure('Request timed out'));
    } on SessionExpiredException catch (e) {
      return Left(AppFailure(e.toString()));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  // ── PUT /users/me/profile ─────────────────────────────────────────
  Future<Either<AppFailure, CustomerProfileModel>> updateMyProfile({
    String? name,
    String? bio,
    String? city,
    String? country,
    String? gender,
  }) async {
    try {
      final uri = Uri.parse('${ServerConstants.serverUrl}/users/me/profile');
      final body = <String, dynamic>{};
      if (name != null) body['name'] = name;
      if (bio != null) body['bio'] = bio;
      if (city != null) body['city'] = city;
      if (country != null) body['country'] = country;
      if (gender != null) body['gender'] = gender;

      final response = await ApiClient.instance
          .put(uri, body: jsonEncode(body))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = decodeMapOrThrow(response);
        return Right(CustomerProfileModel.fromMap(decoded));
      }
      return Left(
        AppFailure(responseErrorMessage(response, 'Failed to update profile')),
      );
    } on TimeoutException {
      return Left(AppFailure('Request timed out'));
    } on SessionExpiredException catch (e) {
      return Left(AppFailure(e.toString()));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  // ── GET /users/{user_id}/profile ──────────────────────────────────
  Future<Either<AppFailure, CustomerProfileModel>> getUserProfile(
    String userId,
  ) async {
    try {
      final uri = Uri.parse(
        '${ServerConstants.serverUrl}/users/$userId/profile',
      );
      final response = await ApiClient.instance
          .get(uri)
          .timeout(const Duration(seconds: 15));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = decodeMapOrThrow(response);
        return Right(CustomerProfileModel.fromMap(decoded));
      }
      return Left(
        AppFailure(responseErrorMessage(response, 'Failed to load profile')),
      );
    } on TimeoutException {
      return Left(AppFailure('Request timed out'));
    } on SessionExpiredException catch (e) {
      return Left(AppFailure(e.toString()));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  // ── GET /users/me/following ───────────────────────────────────────
  Future<Either<AppFailure, List<FollowedSalonModel>>> getMyFollowing() async {
    try {
      final uri = Uri.parse('${ServerConstants.serverUrl}/users/me/following');
      final response = await ApiClient.instance
          .get(uri)
          .timeout(const Duration(seconds: 15));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = decodeMapOrThrow(response);
        final items = (decoded['items'] as List<dynamic>? ?? [])
            .map((e) => FollowedSalonModel.fromMap(e as Map<String, dynamic>))
            .toList();
        return Right(items);
      }
      return Left(
        AppFailure(responseErrorMessage(response, 'Failed to load following')),
      );
    } on TimeoutException {
      return Left(AppFailure('Request timed out'));
    } on SessionExpiredException catch (e) {
      return Left(AppFailure(e.toString()));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  // ── DELETE /profile/salon/{id}/follow ─────────────────────────────
  Future<Either<AppFailure, void>> unfollowSalon(String salonId) async {
    try {
      final uri = Uri.parse(
        '${ServerConstants.serverUrl}/profile/salon/$salonId/follow',
      );
      final response = await ApiClient.instance
          .delete(uri)
          .timeout(const Duration(seconds: 15));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return const Right(null);
      }
      return Left(
        AppFailure(responseErrorMessage(response, 'Failed to unfollow')),
      );
    } on TimeoutException {
      return Left(AppFailure('Request timed out'));
    } on SessionExpiredException catch (e) {
      return Left(AppFailure(e.toString()));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
