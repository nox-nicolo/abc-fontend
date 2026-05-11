import 'dart:convert';

import 'package:africa_beuty/core/constants/server_constants.dart';
import 'package:africa_beuty/core/failure/failure.dart';
import 'package:africa_beuty/core/http/api_client.dart';
import 'package:africa_beuty/feature/profile/model/settings/availability_override.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intl/intl.dart';

class AvailabilityCalendarRepository {
  Future<Either<AppFailure, List<AvailabilityOverride>>> listOverrides({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final uri =
          Uri.parse(
            '${ServerConstants.serverUrl}/profile/availability-overrides',
          ).replace(
            queryParameters: {
              'start_date': DateFormat('yyyy-MM-dd').format(startDate),
              'end_date': DateFormat('yyyy-MM-dd').format(endDate),
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
              .map(AvailabilityOverride.fromMap)
              .toList(),
        );
      }
      return Left(AppFailure(_safeDetail(response.body)));
    } catch (e) {
      return Left(AppFailure('Could not load calendar: $e'));
    }
  }

  Future<Either<AppFailure, AvailabilityOverride>> saveOverride({
    required DateTime date,
    required bool isClosed,
    required String? openTime,
    required String? closeTime,
    required String? reason,
  }) async {
    try {
      final uri = Uri.parse(
        '${ServerConstants.serverUrl}/profile/availability-overrides',
      );
      final response = await ApiClient.instance.put(
        uri,
        body: jsonEncode({
          'date': DateFormat('yyyy-MM-dd').format(date),
          'is_closed': isClosed,
          'open_time': isClosed ? null : openTime,
          'close_time': isClosed ? null : closeTime,
          'reason': reason?.trim().isEmpty == true ? null : reason?.trim(),
        }),
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return Right(
          AvailabilityOverride.fromMap(
            jsonDecode(response.body) as Map<String, dynamic>,
          ),
        );
      }
      return Left(AppFailure(_safeDetail(response.body)));
    } catch (e) {
      return Left(AppFailure('Could not save calendar day: $e'));
    }
  }

  Future<Either<AppFailure, Unit>> deleteOverride(String id) async {
    try {
      final uri = Uri.parse(
        '${ServerConstants.serverUrl}/profile/availability-overrides/$id',
      );
      final response = await ApiClient.instance.delete(uri);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return const Right(unit);
      }
      return Left(AppFailure(_safeDetail(response.body)));
    } catch (e) {
      return Left(AppFailure('Could not delete calendar day: $e'));
    }
  }

  String _safeDetail(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map && decoded['detail'] != null) {
        return decoded['detail'].toString();
      }
    } catch (_) {}
    return 'Calendar request failed';
  }
}
