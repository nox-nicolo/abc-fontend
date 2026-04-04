import 'dart:async';
import 'dart:convert';

import 'package:africa_beuty/core/constants/server_constants.dart';
import 'package:africa_beuty/core/failure/failure.dart';
import 'package:africa_beuty/core/http/api_client.dart';
import 'package:africa_beuty/feature/booking/model/start_booking.dart';
import 'package:fpdart/fpdart.dart';

class BookingRepository {
  Future<Either<AppFailure, BookingModel>> createBooking({
    required Map<String, dynamic> payload,
  }) async {
    try {
      final uri = Uri.parse('${ServerConstants.serverUrl}/booking');

      final response = await ApiClient.instance
          .post(uri, body: jsonEncode(payload))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);
        if (decoded is! Map<String, dynamic>) {
          return Left(AppFailure('Unexpected server response'));
        }
        return Right(BookingModel.fromMap(decoded));
      }

      return Left(_mapHttpError(response.statusCode, response.body));
    } on TimeoutException {
      return Left(AppFailure('Request timed out'));
    } on SessionExpiredException catch (e) {
      return Left(AppFailure(e.toString()));
    } on FormatException {
      return Left(AppFailure('Invalid server response'));
    } catch (e) {
      return Left(AppFailure('Error: $e'));
    }
  }

  AppFailure _mapHttpError(int status, String body) {
    switch (status) {
      case 400:
        return AppFailure(_safeDetail(body));
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
        return AppFailure(_safeDetail(body));
    }
  }

  String _safeDetail(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map && decoded['detail'] != null) {
        return decoded['detail'].toString();
      }
    } catch (_) {}
    return 'Failed to create booking';
  }
}
