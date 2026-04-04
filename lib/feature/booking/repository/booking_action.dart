import 'dart:convert';

import 'package:africa_beuty/core/constants/server_constants.dart';
import 'package:africa_beuty/core/failure/failure.dart';
import 'package:africa_beuty/core/http/api_client.dart';
import 'package:africa_beuty/feature/booking/model/start_booking.dart';
import 'package:fpdart/fpdart.dart';

class BookingActionRepository {
  Future<Either<AppFailure, BookingModel>> _post(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    try {
      final res = await ApiClient.instance.post(
        Uri.parse('${ServerConstants.serverUrl}$path'),
        body: body != null ? jsonEncode(body) : null,
      );

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final decoded = jsonDecode(res.body) as Map<String, dynamic>;
        return Right(BookingModel.fromMap(decoded));
      }

      try {
        final decoded = jsonDecode(res.body);
        return Left(AppFailure(decoded['detail'] ?? 'Action failed'));
      } catch (_) {
        return Left(AppFailure('Action failed'));
      }
    } on SessionExpiredException catch (e) {
      return Left(AppFailure(e.toString()));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, BookingModel>> accept(String id) =>
      _post('/booking/$id/confirm');

  Future<Either<AppFailure, BookingModel>> reject(String id) =>
      _post('/booking/$id/reject');

  Future<Either<AppFailure, BookingModel>> complete(String id) =>
      _post('/booking/$id/complete');
}
