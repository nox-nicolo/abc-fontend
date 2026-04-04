import 'dart:async';
import 'dart:convert';

import 'package:africa_beuty/core/constants/server_constants.dart';
import 'package:africa_beuty/core/failure/failure.dart';
import 'package:africa_beuty/core/http/api_client.dart';
import 'package:africa_beuty/feature/booking/model/booking_status.dart';
import 'package:fpdart/fpdart.dart';

class BookingListRepository {
  /// Fetches the **salon's** bookings from GET /booking/salon.
  Future<Either<AppFailure, List<BookingListItem>>> fetchBookings({
    String? status,
    bool? upcoming,
    String? date,
  }) async {
    try {
      final params = <String, String>{};
      if (status != null) params['status'] = status;
      if (upcoming != null) params['upcoming'] = upcoming.toString();
      if (date != null) params['date'] = date;

      final uri = Uri.parse(
        '${ServerConstants.serverUrl}/booking/salon',
      ).replace(queryParameters: params.isEmpty ? null : params);

      final response = await ApiClient.instance
          .get(uri)
          .timeout(const Duration(seconds: 15));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body) as List;
        return Right(BookingListItem.listFromJson(decoded));
      }

      return Left(_mapError(response.body));
    } on TimeoutException {
      return Left(AppFailure('Request timed out'));
    } on SessionExpiredException catch (e) {
      return Left(AppFailure(e.toString()));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  AppFailure _mapError(String body) {
    try {
      final decoded = jsonDecode(body);
      return AppFailure(decoded['detail'] ?? 'Failed to load bookings');
    } catch (_) {
      return AppFailure('Failed to load bookings');
    }
  }
}
