// booking_list_repository.dart
import 'dart:async';
import 'dart:convert';

import 'package:africa_beuty/core/constants/server_constants.dart';
import 'package:africa_beuty/core/failure/failure.dart';
import 'package:africa_beuty/feature/auth/repositories/local_storage_service.dart';
import 'package:africa_beuty/feature/booking/model/booking_status.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;

class BookingListRepository {
  final http.Client _client;

  BookingListRepository({http.Client? client})
      : _client = client ?? http.Client();

  Future<Either<AppFailure, List<BookingListItem>>> fetchBookings({
    required String status,
  }) async {
    final token = await LocalStorageService.getAccessToken();
    if (token == null || token.isEmpty) {
      return Left(AppFailure('Authentication required'));
    }

    if (status == 'confirmed') {
      status = 'confirmed&upcoming=true';
    }

    final uri = Uri.parse(
      '${ServerConstants.serverUrl}/booking/salon?status=$status',
    );

    try {
      final response = await _client.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode >= 200 &&
          response.statusCode < 300) {
        final decoded = jsonDecode(response.body) as List;
        return Right(
          BookingListItem.listFromJson(decoded),
        );
      }

      return Left(_mapError(response));
    } on TimeoutException {
      return Left(AppFailure('Request timed out'));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  AppFailure _mapError(http.Response response) {
    try {
      final decoded = jsonDecode(response.body);
      return AppFailure(decoded['detail'] ?? 'Failed to load bookings');
    } catch (_) {
      return AppFailure('Failed to load bookings');
    }
  }
}
