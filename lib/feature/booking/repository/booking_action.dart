// booking_action.dart
import 'dart:convert';
import 'package:africa_beuty/core/constants/server_constants.dart';
import 'package:africa_beuty/core/failure/failure.dart';
import 'package:africa_beuty/feature/auth/repositories/local_storage_service.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;

class BookingActionRepository {
  Future<Either<AppFailure, void>> _post(
    String path,
  ) async {
    final token = await LocalStorageService.getAccessToken();
    if (token == null) {
      return Left(AppFailure('Not authenticated'));
    }

    final res = await http.post(
      Uri.parse('${ServerConstants.serverUrl}$path'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return const Right(null);
    }

    try {
      final decoded = jsonDecode(res.body);
      return Left(AppFailure(decoded['detail'] ?? 'Action failed'));
    } catch (_) {
      return Left(AppFailure('Action failed'));
    }
  }

  Future<Either<AppFailure, void>> accept(String id) =>
      _post('/booking/$id/confirm');

  Future<Either<AppFailure, void>> reject(String id) =>
      _post('/booking/$id/reject');

  Future<Either<AppFailure, void>> complete(String id) =>
      _post('/booking/$id/complete');
}
