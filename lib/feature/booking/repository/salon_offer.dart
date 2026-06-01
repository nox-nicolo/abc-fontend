import 'dart:async';
import 'dart:convert';

import 'package:africa_beuty/core/constants/server_constants.dart';
import 'package:africa_beuty/core/failure/failure.dart';
import 'package:africa_beuty/core/http/api_client.dart';
import 'package:africa_beuty/core/http/paginated_response.dart';
import 'package:africa_beuty/feature/booking/model/booking_stylist.dart';
import 'package:africa_beuty/feature/booking/model/salon_offer.dart';
import 'package:fpdart/fpdart.dart';

class SalonOfferRepository {
  Future<Either<AppFailure, List<SalonOfferModel>>> getSalonsByStyle({
    required String subServiceId,
  }) async {
    try {
      final uri = Uri.parse(
        '${ServerConstants.serverUrl}/booking/salonsbystyle'
        '?sub_service_id=$subServiceId',
      );

      final response = await ApiClient.instance
          .get(uri)
          .timeout(const Duration(seconds: 15));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);
        final results = listFromPaginatedBody(decoded, key: 'results');
        return Right(SalonOfferModel.listFromJson(results));
      }

      return Left(_mapHttpError(response.body));
    } on TimeoutException {
      return Left(AppFailure('Request timed out'));
    } on SessionExpiredException catch (e) {
      return Left(AppFailure(e.toString()));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<BookingStylistModel>>> getStylistsForOffer({
    required String salonServicePriceId,
    DateTime? startAt,
    String? excludeBookingId,
  }) async {
    try {
      final uri =
          Uri.parse(
            '${ServerConstants.serverUrl}/booking/offers/'
            '$salonServicePriceId/stylists',
          ).replace(
            queryParameters: {
              if (startAt != null)
                'start_at': startAt.toUtc().toIso8601String(),
              if (excludeBookingId != null && excludeBookingId.isNotEmpty)
                'exclude_booking_id': excludeBookingId,
            },
          );

      final response = await ApiClient.instance
          .get(uri)
          .timeout(const Duration(seconds: 15));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);
        final results = listFromPaginatedBody(decoded, key: 'results');
        return Right(BookingStylistModel.listFromJson(results));
      }

      return Left(_mapHttpError(response.body));
    } on TimeoutException {
      return Left(AppFailure('Request timed out'));
    } on SessionExpiredException catch (e) {
      return Left(AppFailure(e.toString()));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  AppFailure _mapHttpError(String body) {
    try {
      final decoded = jsonDecode(body);
      return AppFailure(decoded['detail'] ?? 'Failed to load salons');
    } catch (_) {
      return AppFailure('Failed to load salons');
    }
  }
}
