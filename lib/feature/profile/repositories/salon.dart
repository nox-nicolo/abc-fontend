import 'dart:async';
import 'dart:convert';
import 'package:africa_beuty/core/constants/server_constants.dart';
import 'package:africa_beuty/core/failure/failure.dart';
import 'package:africa_beuty/feature/auth/repositories/local_storage_service.dart';
import 'package:africa_beuty/feature/profile/model/salon.dart';
import 'package:africa_beuty/feature/profile/repositories/local_salon.dart';// Your local storage
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;

class SalonProfileRepository {
  final http.Client _client;

  SalonProfileRepository({http.Client? client})
      : _client = client ?? http.Client();

  /// NEW: Get data from local cache first for instant UI
  Future<Either<AppFailure, SalonProfileModel>> getCachedProfile() async {
    final cachedData = await SalonProfileStorage.load();
    if (cachedData != null) {
      return Right(cachedData);
    }
    return Left(AppFailure('No cached data found'));
  }

  Future<Either<AppFailure, SalonProfileModel>> salonProfile() async {
    final token = await LocalStorageService.getAccessToken();

    if (token == null || token.isEmpty) {
      return Left(AppFailure('Authentication required'));
    }

    final uri = Uri.parse('${ServerConstants.serverUrl}/profile/salon');

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

        final salonModel = SalonProfileModel.fromMap(decoded);

        // 🔥 FUNCTIONALITY ADDED: Sync to local storage on every successful fetch
        await SalonProfileStorage.save(salonModel);

        return Right(salonModel);
      }

      return Left(_mapHttpError(response));
    } on TimeoutException {
      return Left(AppFailure('Request timed out'));
    } on http.ClientException {
      // 💡 ADDED: If network fails, try to return cache instead of showing error
      final cached = await SalonProfileStorage.load();
      if (cached != null) return Right(cached);
      
      return Left(AppFailure('Network error. Please try again.'));
    } on FormatException {
      return Left(AppFailure('Invalid server response'));
    } catch (e) {
      return Left(AppFailure('Mapping Error: ${e.toString()}'));
    }
  }

  // --- Keep your existing _mapHttpError and _safeErrorMessage exactly as they are ---
  AppFailure _mapHttpError(http.Response response) {
    switch (response.statusCode) {
      case 401:
      case 403:
        return AppFailure('Session expired. Please login again.');
      case 404:
        return AppFailure('Salon profile not found');
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
    return 'Failed to load profile';
  }
}