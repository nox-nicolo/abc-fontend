import 'dart:async';
import 'dart:convert';

import 'package:africa_beuty/core/constants/server_constants.dart';
import 'package:africa_beuty/core/failure/failure.dart';
import 'package:africa_beuty/feature/auth/repositories/local_storage_service.dart';
import 'package:africa_beuty/feature/profile/model/three_dots/stylists/create_stylist.dart';
import 'package:africa_beuty/feature/profile/model/three_dots/stylists/edit_stylist.dart';
import 'package:africa_beuty/feature/profile/model/three_dots/stylists/search_stylists.dart';
import 'package:africa_beuty/feature/profile/model/three_dots/stylists/view_single_stylists.dart';
import 'package:africa_beuty/feature/profile/model/three_dots/stylists/view_stylists.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;

class SalonStylistRepository {
  final http.Client _client;

  SalonStylistRepository({http.Client? client})
    : _client = client ?? http.Client();

  Future<Either<AppFailure, StylistListResponse>> getSalonStylists({
    int limit = 20,
    int offset = 0,
  }) async {
    final token = await LocalStorageService.getAccessToken();

    if (token == null || token.isEmpty) {
      return Left(AppFailure('Authentication required'));
    }

    final uri = Uri.parse('${ServerConstants.serverUrl}/profile/stylists')
        .replace(
          queryParameters: {
            'limit': limit.toString(),
            'offset': offset.toString(),
          },
        );

    try {
      final response = await _client
          .get(
            uri,
            headers: {
              'Authorization': 'Bearer $token',
              'Accept': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);

        if (decoded is! Map<String, dynamic>) {
          return Left(AppFailure('Unexpected server response'));
        }

        final stylistResponse = StylistListResponse.fromJson(decoded);
        return Right(stylistResponse);
      }

      return Left(_mapHttpError(response));
    } on TimeoutException {
      return Left(AppFailure('Request timed out'));
    } on http.ClientException {
      return Left(AppFailure('Network error. Please try again.'));
    } on FormatException {
      return Left(AppFailure('Invalid server response'));
    } catch (e) {
      return Left(AppFailure('Mapping Error: ${e.toString()}'));
    }
  }

  Future<Either<AppFailure, StylistSearchResponse>> searchStylists({
    required String query,
    int limit = 10,
  }) async {
    final trimmedQuery = query.trim();

    if (trimmedQuery.isEmpty) {
      return const Right(StylistSearchResponse(items: [], query: '', count: 0));
    }

    final token = await LocalStorageService.getAccessToken();

    if (token == null || token.isEmpty) {
      return Left(AppFailure('Authentication required'));
    }

    final uri = Uri.parse(
      '${ServerConstants.serverUrl}/profile/stylists/search-users',
    ).replace(queryParameters: {'q': trimmedQuery, 'limit': limit.toString()});

    try {
      final response = await _client
          .get(
            uri,
            headers: {
              'Authorization': 'Bearer $token',
              'Accept': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);

        if (decoded is! Map<String, dynamic>) {
          return Left(AppFailure('Unexpected server response'));
        }

        final result = StylistSearchResponse.fromJson(decoded);

        return Right(result);
      }

      return Left(_mapHttpError(response));
    } on TimeoutException {
      return Left(AppFailure('Request timed out'));
    } on http.ClientException {
      return Left(AppFailure('Network error. Please try again.'));
    } on FormatException {
      return Left(AppFailure('Invalid server response'));
    } catch (e) {
      return Left(AppFailure('Mapping Error: ${e.toString()}'));
    }
  }

  Future<Either<AppFailure, CreateSalonStylistResponse>> createStylist({
    required CreateSalonStylistRequest request,
  }) async {
    final token = await LocalStorageService.getAccessToken();

    if (token == null || token.isEmpty) {
      return Left(AppFailure('Authentication required'));
    }

    final uri = Uri.parse('${ServerConstants.serverUrl}/profile/stylist');

    try {
      final response = await _client
          .post(
            uri,
            headers: {
              'Authorization': 'Bearer $token',
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
            body: jsonEncode(request.toJson()),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);

        if (decoded is! Map<String, dynamic>) {
          return Left(AppFailure('Unexpected server response'));
        }

        final result = CreateSalonStylistResponse.fromJson(decoded);
        return Right(result);
      }

      return Left(_mapHttpError(response));
    } on TimeoutException {
      return Left(AppFailure('Request timed out'));
    } on http.ClientException {
      return Left(AppFailure('Network error. Please try again.'));
    } on FormatException {
      return Left(AppFailure('Invalid server response'));
    } catch (e) {
      return Left(AppFailure('Mapping Error: ${e.toString()}'));
    }
  }

  Future<Either<AppFailure, SalonStylistDetail>> getSalonStylistDetail({
    required String stylistId,
  }) async {
    final token = await LocalStorageService.getAccessToken();

    if (token == null || token.isEmpty) {
      return Left(AppFailure('Authentication required'));
    }

    final uri = Uri.parse(
      '${ServerConstants.serverUrl}/profile/stylist/$stylistId',
    );

    try {
      final response = await _client
          .get(
            uri,
            headers: {
              'Authorization': 'Bearer $token',
              'Accept': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);

        if (decoded is! Map<String, dynamic>) {
          return Left(AppFailure('Unexpected server response'));
        }

        final result = SalonStylistDetail.fromJson(decoded);
        return Right(result);
      }

      return Left(_mapHttpError(response));
    } on TimeoutException {
      return Left(AppFailure('Request timed out'));
    } on http.ClientException {
      return Left(AppFailure('Network error. Please try again.'));
    } on FormatException {
      return Left(AppFailure('Invalid server response'));
    } catch (e) {
      return Left(AppFailure('Mapping Error: ${e.toString()}'));
    }
  }

  Future<Either<AppFailure, SalonStylistDetail>> editStylist({
    required String stylistId,
    required EditSalonStylistRequest request,
  }) async {
    final token = await LocalStorageService.getAccessToken();

    if (token == null || token.isEmpty) {
      return Left(AppFailure('Authentication required'));
    }

    final uri = Uri.parse(
      '${ServerConstants.serverUrl}/profile/stylist/$stylistId',
    );

    try {
      final response = await _client
          .patch(
            uri,
            headers: {
              'Authorization': 'Bearer $token',
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
            body: jsonEncode(request.toJson()),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);

        if (decoded is! Map<String, dynamic>) {
          return Left(AppFailure('Unexpected server response'));
        }

        final result = SalonStylistDetail.fromJson(decoded);
        return Right(result);
      }

      return Left(_mapHttpError(response));
    } on TimeoutException {
      return Left(AppFailure('Request timed out'));
    } on http.ClientException {
      return Left(AppFailure('Network error. Please try again.'));
    } on FormatException {
      return Left(AppFailure('Invalid server response'));
    } catch (e) {
      return Left(AppFailure('Mapping Error: ${e.toString()}'));
    }
  }

  AppFailure _mapHttpError(http.Response response) {
    switch (response.statusCode) {
      case 401:
      case 403:
        return AppFailure('Session expired. Please login again.');
      case 404:
        return AppFailure('Stylists not found');
      case 500:
      case 502:
      case 503:
        return AppFailure('Server error. Please try later.');
      default:
        return AppFailure(_safeErrorMessage(response.body));
    }
  }

  String _safeErrorMessage(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map && decoded['detail'] != null) {
        return decoded['detail'].toString();
      }
    } catch (_) {}
    return 'Failed to load stylists';
  }
}
