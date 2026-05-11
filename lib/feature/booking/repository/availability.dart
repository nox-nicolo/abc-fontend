import 'dart:convert';

import 'package:africa_beuty/core/constants/server_constants.dart';
import 'package:africa_beuty/core/failure/failure.dart';
import 'package:africa_beuty/core/http/api_client.dart';
import 'package:africa_beuty/feature/booking/model/availability.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intl/intl.dart';

class AvailabilityRepository {
  Future<Either<AppFailure, List<AvailabilityDay>>> getAvailability({
    required String salonServicePriceId,
    required DateTime startDate,
    int days = 14,
  }) async {
    try {
      final uri = Uri.parse('${ServerConstants.serverUrl}/booking/availability')
          .replace(
            queryParameters: {
              'salon_service_price_id': salonServicePriceId,
              'start_date': DateFormat('yyyy-MM-dd').format(startDate),
              'days': days.toString(),
            },
          );
      final response = await ApiClient.instance.get(uri);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);
        final items = decoded is Map<String, dynamic>
            ? decoded['items'] as List? ?? const []
            : const [];
        return Right(
          items
              .whereType<Map<String, dynamic>>()
              .map(AvailabilityDay.fromMap)
              .toList(),
        );
      }
      return Left(AppFailure(_safeDetail(response.body)));
    } catch (e) {
      return Left(AppFailure('Could not load available times: $e'));
    }
  }

  String _safeDetail(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map && decoded['detail'] != null) {
        return decoded['detail'].toString();
      }
    } catch (_) {}
    return 'Could not load available times';
  }
}
