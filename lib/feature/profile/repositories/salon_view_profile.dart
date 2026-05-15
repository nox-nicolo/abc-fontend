import 'dart:async';

import 'package:africa_beuty/core/constants/server_constants.dart';
import 'package:africa_beuty/core/failure/failure.dart';
import 'package:africa_beuty/core/http/response_body.dart';
import 'package:africa_beuty/feature/auth/repositories/local_storage_service.dart';
import 'package:africa_beuty/feature/profile/model/salon_view_followers.dart';
import 'package:africa_beuty/feature/profile/model/salon_view_profile.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;

class SalonRepository {
  final http.Client _client;

  SalonRepository({http.Client? client}) : _client = client ?? http.Client();

  // ------------------------------------------------------------------
  // Public: View Salon Profile
  // ------------------------------------------------------------------
  Future<Either<AppFailure, SalonViewProfileModel>> getSalonProfile(
    String salonId,
  ) async {
    final token = await LocalStorageService.getAccessToken();
    final uri = Uri.parse(
      '${ServerConstants.serverUrl}/profile/salon/$salonId',
    );

    try {
      final response = await _client
          .get(
            uri,
            headers: {
              if (token != null && token.isNotEmpty)
                'Authorization': 'Bearer $token',
              'Accept': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = decodeMapOrThrow(response);

        return Right(SalonViewProfileModel.fromMap(decoded));
      }

      return Left(_mapHttpError(response));
    } on TimeoutException {
      return Left(AppFailure('Request timed out'));
    } on http.ClientException {
      return Left(AppFailure('Network error. Please try again.'));
    } on FormatException {
      return Left(AppFailure('Invalid server response'));
    } catch (e) {
      return Left(AppFailure('Mapping error: ${e.toString()}'));
    }
  }

  // ------------------------------------------------------------------
  // Public: Salon Followers (paginated)
  // ------------------------------------------------------------------
  Future<Either<AppFailure, SalonFollowersResponseModel>> getSalonFollowers(
    String salonId, {
    String? cursor,
    int limit = 20,
  }) async {
    final token = await LocalStorageService.getAccessToken();

    final uri = Uri.parse(
      '${ServerConstants.serverUrl}/profile/salon/$salonId/followers'
      '${cursor != null ? '?cursor=$cursor&limit=$limit' : '?limit=$limit'}',
    );

    try {
      final response = await _client
          .get(
            uri,
            headers: {
              if (token != null && token.isNotEmpty)
                'Authorization': 'Bearer $token',
              'Accept': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = decodeMapOrThrow(response);

        return Right(SalonFollowersResponseModel.fromMap(decoded));
      }

      return Left(_mapHttpError(response));
    } on TimeoutException {
      return Left(AppFailure('Request timed out'));
    } on http.ClientException {
      return Left(AppFailure('Network error. Please try again.'));
    } on FormatException {
      return Left(AppFailure('Invalid server response'));
    } catch (e) {
      return Left(AppFailure('Mapping error: ${e.toString()}'));
    }
  }

  // ------------------------------------------------------------------
  // Follow salon
  // ------------------------------------------------------------------
  Future<Either<AppFailure, void>> followSalon(String salonId) async {
    final token = await LocalStorageService.getAccessToken();

    final uri = Uri.parse(
      '${ServerConstants.serverUrl}/profile/salon/$salonId/follow',
    );

    try {
      final response = await _client.post(
        uri,
        headers: {
          if (token != null && token.isNotEmpty)
            'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return const Right(null);
      }

      return Left(_mapHttpError(response));
    } catch (_) {
      return Left(AppFailure('Network error'));
    }
  }

  // ------------------------------------------------------------------
  // Unfollow salon
  // ------------------------------------------------------------------
  Future<Either<AppFailure, void>> unfollowSalon(String salonId) async {
    final token = await LocalStorageService.getAccessToken();

    final uri = Uri.parse(
      '${ServerConstants.serverUrl}/profile/salon/$salonId/follow',
    );

    try {
      final response = await _client.delete(
        uri,
        headers: {
          if (token != null && token.isNotEmpty)
            'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return const Right(null);
      }

      return Left(_mapHttpError(response));
    } catch (_) {
      return Left(AppFailure('Network error'));
    }
  }
  // ------------------------------------------------------------------

  // ------------------------------------------------------------------
  // Error mapping (same philosophy as your example)
  // ------------------------------------------------------------------
  AppFailure _mapHttpError(http.Response response) {
    switch (response.statusCode) {
      case 401:
      case 403:
        return AppFailure('Authentication required');
      case 404:
        return AppFailure('Resource not found');
      case 500:
      case 502:
      case 503:
        return AppFailure('Server error. Please try later.');
      default:
        return AppFailure(_safeErrorMessage(response.body));
    }
  }

  String _safeErrorMessage(String body) {
    final decoded = tryDecodeMap(body);
    if (decoded != null && decoded['detail'] != null) {
      return decoded['detail'].toString();
    }
    return 'Request failed';
  }
}
