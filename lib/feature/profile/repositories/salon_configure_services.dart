import 'dart:async';
import 'dart:convert';

import 'package:africa_beuty/core/constants/server_constants.dart';
import 'package:africa_beuty/core/failure/failure.dart';
import 'package:africa_beuty/feature/auth/repositories/local_storage_service.dart';
import 'package:africa_beuty/feature/profile/model/config_service_salon.dart';
import 'package:africa_beuty/feature/profile/model/config_service_update_create.dart';
import 'package:africa_beuty/feature/profile/model/salon_configure_services.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;

class SalonServiceRepository {
  final http.Client _client;

  SalonServiceRepository({http.Client? client})
      : _client = client ?? http.Client();

  // --------------------------------------------------
  // List services for selection
  // --------------------------------------------------
  Future<Either<AppFailure, List<SalonServiceItemModel>>>
      listServicesForSelection({
    String? query,
    bool includeArchived = false,
    int limit = 100,
    int offset = 0,
  }) async {
    final token = await LocalStorageService.getAccessToken();

    if (token == null || token.isEmpty) {
      return Left(AppFailure('Authentication required'));
    }

    final uri = Uri.parse(
      '${ServerConstants.serverUrl}/profile/salon/services',
    ).replace(
      queryParameters: {
        if (query != null && query.isNotEmpty) 'q': query,
        'include_archived': includeArchived.toString(),
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

        final items = decoded['items'];

        if (items is! List) {
          return Left(AppFailure('Invalid service list format'));
        }

        final services = items
            .map(
              (e) => SalonServiceItemModel.fromMap(
                e as Map<String, dynamic>,
              ),
            )
            .toList();

        return Right(services);
      }

      return Left(_mapHttpError(response));
    } on TimeoutException {
      return Left(AppFailure('Request timed out'));
    } on http.ClientException catch (e) {
      return Left(AppFailure('Client error: ${e.message}'));
    } on FormatException {
      return Left(AppFailure('Invalid server response'));
    } catch (e) {
      return Left(AppFailure('Mapping Error: ${e.toString()}'));
    }
  }

  // --------------------------------------------------
  // Get single service config (Create / Update page)
  // --------------------------------------------------
  Future<Either<AppFailure, SalonServiceConfigModel>>
      getServiceConfig({
    required String serviceId,
    required String subServiceId,
  }) async {
    final token = await LocalStorageService.getAccessToken();

    if (token == null || token.isEmpty) {
      return Left(AppFailure('Authentication required'));
    }

    final uri = Uri.parse(
      '${ServerConstants.serverUrl}'
      '/profile/salon/services/$serviceId/sub/$subServiceId/configure',
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

        return Right(
          SalonServiceConfigModel.fromMap(decoded),
        );
      }

      return Left(_mapHttpError(response));
    } on TimeoutException {
      return Left(AppFailure('Request timed out'));
    } on http.ClientException catch (e) {
      return Left(AppFailure('Client error: ${e.message}'));
    } on FormatException {
      return Left(AppFailure('Invalid server response'));
    } catch (e) {
      return Left(AppFailure('Mapping Error: ${e.toString()}'));
    }
  }

  // --------------------------------------------------
  // Create salon service config
  // --------------------------------------------------
  Future<Either<AppFailure, void>> createServiceConfig({
    required SalonServiceConfigRequestModel payload,
  }) async {
    final token = await LocalStorageService.getAccessToken();

    if (token == null || token.isEmpty) {
      return Left(AppFailure('Authentication required'));
    }

    final uri = Uri.parse(
      '${ServerConstants.serverUrl}/profile/salon/services',
    );

    try {
      final response = await _client
          .post(
            uri,
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(payload.toMap()),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return const Right(null);
      }

      return Left(_mapHttpError(response));
    } on TimeoutException {
      return Left(AppFailure('Request timed out'));
    } on http.ClientException catch (e) {
      return Left(AppFailure('Client error: ${e.message}'));
    } on FormatException {
      return Left(AppFailure('Invalid server response'));
    } catch (e) {
      return Left(AppFailure('Mapping Error: ${e.toString()}'));
    }
  }

  // --------------------------------------------------
  // Update salon service config
  // --------------------------------------------------
  Future<Either<AppFailure, void>> updateServiceConfig({
    required String salonServicePriceId,
    required SalonServiceConfigRequestModel payload,
  }) async {
    final token = await LocalStorageService.getAccessToken();

    if (token == null || token.isEmpty) {
      return Left(AppFailure('Authentication required'));
    }

    final uri = Uri.parse(
      '${ServerConstants.serverUrl}/profile/salon/services/$salonServicePriceId',
    );

    try {
      final response = await _client
          .put(
            uri,
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(payload.toMap()),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return const Right(null);
      }

      return Left(_mapHttpError(response));
    } on TimeoutException {
      return Left(AppFailure('Request timed out'));
    } on http.ClientException catch (e) {
      return Left(AppFailure('Client error: ${e.message}'));
    } on FormatException {
      return Left(AppFailure('Invalid server response'));
    } catch (e) {
      return Left(AppFailure('Mapping Error: ${e.toString()}'));
    }
  }




  // --------------------------------------------------
  // Error mapping
  // --------------------------------------------------
  AppFailure _mapHttpError(http.Response response) {
    switch (response.statusCode) {
      case 400:
        return AppFailure(_safeErrorMessage(response.body));
      case 401:
      case 403:
        return AppFailure('Session expired. Please login again.');
      case 404:
        return AppFailure('Salon services endpoint not found');
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
    return 'Failed to load salon services';
  }
}
