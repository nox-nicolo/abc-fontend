import 'dart:async';
import 'dart:convert';

import 'package:africa_beuty/core/constants/server_constants.dart';
import 'package:africa_beuty/core/failure/failure.dart';
import 'package:africa_beuty/feature/auth/repositories/local_storage_service.dart';
import 'package:africa_beuty/feature/booking/model/start_booking.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;

class BookingRepository {
  final http.Client _client;

  BookingRepository({http.Client? client})
      : _client = client ?? http.Client();

  // --------------------------------------------------
  // Create Booking
  // --------------------------------------------------
  Future<Either<AppFailure, BookingModel>> createBooking({
    required Map<String, dynamic> payload,
  }) async {
    final token = await LocalStorageService.getAccessToken();

    if (token == null || token.isEmpty) {
      return Left(AppFailure('Authentication required'));
    }

    final uri = Uri.parse('${ServerConstants.serverUrl}/booking');

    try {
      final response = await _client
          .post(
            uri,
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(payload),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);

        if (decoded is! Map<String, dynamic>) {
          return Left(AppFailure('Unexpected server response'));
        }

        // ✅ CORRECT: response → BookingModel
        return Right(BookingModel.fromMap(decoded));
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
        return AppFailure('Booking endpoint not found');
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
    return 'Failed to create booking';
  }
}
