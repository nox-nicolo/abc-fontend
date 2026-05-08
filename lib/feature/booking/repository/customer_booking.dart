import 'dart:async';
import 'dart:convert';

import 'package:africa_beuty/core/constants/server_constants.dart';
import 'package:africa_beuty/core/failure/failure.dart';
import 'package:africa_beuty/core/http/api_client.dart';
import 'package:africa_beuty/core/http/paginated_response.dart';
import 'package:africa_beuty/feature/booking/model/booking_status.dart';
import 'package:africa_beuty/feature/booking/model/start_booking.dart';
import 'package:fpdart/fpdart.dart';

class CustomerBookingRepository {
  // ── GET /booking/my ──────────────────────────────────────────────
  Future<Either<AppFailure, List<BookingListItem>>> getMyBookings({
    String? status,
    bool? upcoming,
  }) async {
    try {
      final params = <String, String>{};
      if (status != null) params['status'] = status;
      if (upcoming != null) params['upcoming'] = upcoming.toString();

      final uri = Uri.parse(
        '${ServerConstants.serverUrl}/booking/my',
      ).replace(queryParameters: params.isEmpty ? null : params);

      final response = await ApiClient.instance
          .get(uri)
          .timeout(const Duration(seconds: 15));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);
        return Right(
          BookingListItem.listFromJson(listFromPaginatedBody(decoded)),
        );
      }

      return Left(_detail(response.body, 'Failed to load bookings'));
    } on TimeoutException {
      return Left(AppFailure('Request timed out'));
    } on SessionExpiredException catch (e) {
      return Left(AppFailure(e.toString()));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  // ── GET /booking/{id} ────────────────────────────────────────────
  Future<Either<AppFailure, BookingModel>> getBooking(String id) async {
    try {
      final uri = Uri.parse('${ServerConstants.serverUrl}/booking/$id');

      final response = await ApiClient.instance
          .get(uri)
          .timeout(const Duration(seconds: 15));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        return Right(BookingModel.fromMap(decoded));
      }

      return Left(_detail(response.body, 'Failed to load booking'));
    } on TimeoutException {
      return Left(AppFailure('Request timed out'));
    } on SessionExpiredException catch (e) {
      return Left(AppFailure(e.toString()));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  // ── POST /booking/{id}/cancel ────────────────────────────────────
  Future<Either<AppFailure, BookingModel>> cancel(
    String id, {
    String? reason,
  }) async {
    try {
      final uri = Uri.parse('${ServerConstants.serverUrl}/booking/$id/cancel');

      final response = await ApiClient.instance
          .post(
            uri,
            body: jsonEncode({
              if (reason != null && reason.isNotEmpty) 'reason': reason,
            }),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        return Right(BookingModel.fromMap(decoded));
      }

      return Left(_detail(response.body, 'Failed to cancel booking'));
    } on TimeoutException {
      return Left(AppFailure('Request timed out'));
    } on SessionExpiredException catch (e) {
      return Left(AppFailure(e.toString()));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  // ── POST /booking/{id}/reschedule ────────────────────────────────
  Future<Either<AppFailure, BookingModel>> reschedule(
    String id,
    DateTime startAt,
  ) async {
    try {
      final uri = Uri.parse(
        '${ServerConstants.serverUrl}/booking/$id/reschedule',
      );

      final response = await ApiClient.instance
          .post(
            uri,
            body: jsonEncode({'start_at': startAt.toUtc().toIso8601String()}),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        return Right(BookingModel.fromMap(decoded));
      }

      return Left(_detail(response.body, 'Failed to reschedule booking'));
    } on TimeoutException {
      return Left(AppFailure('Request timed out'));
    } on SessionExpiredException catch (e) {
      return Left(AppFailure(e.toString()));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  // ── POST /booking/{id}/review ────────────────────────────────────
  Future<Either<AppFailure, void>> review(
    String id, {
    required int rating,
    String? comment,
  }) async {
    try {
      final uri = Uri.parse('${ServerConstants.serverUrl}/booking/$id/review');

      final response = await ApiClient.instance
          .post(
            uri,
            body: jsonEncode({
              'rating': rating,
              if (comment != null && comment.isNotEmpty) 'comment': comment,
            }),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return const Right(null);
      }

      return Left(_detail(response.body, 'Failed to submit review'));
    } on TimeoutException {
      return Left(AppFailure('Request timed out'));
    } on SessionExpiredException catch (e) {
      return Left(AppFailure(e.toString()));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  AppFailure _detail(String body, String fallback) {
    try {
      final decoded = jsonDecode(body);
      return AppFailure(decoded['detail'] ?? fallback);
    } catch (_) {
      return AppFailure(fallback);
    }
  }
}
