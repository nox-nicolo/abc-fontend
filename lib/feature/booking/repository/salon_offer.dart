import 'dart:async';
import 'dart:convert';

import 'package:africa_beuty/core/constants/server_constants.dart';
import 'package:africa_beuty/core/failure/failure.dart';
import 'package:africa_beuty/feature/auth/repositories/local_storage_service.dart';
import 'package:africa_beuty/feature/booking/model/salon_offer.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;

class SalonOfferRepository {
  final http.Client _client;

  SalonOfferRepository({http.Client? client})
      : _client = client ?? http.Client();

  Future<Either<AppFailure, List<SalonOfferModel>>> getSalonsByStyle({
    required String subServiceId,
  }) async {
    final token = await LocalStorageService.getAccessToken();

    if (token == null || token.isEmpty) {
      return Left(AppFailure('Authentication required'));
    }

    final uri = Uri.parse(
      '${ServerConstants.serverUrl}/booking/salonsbystyle'
      '?sub_service_id=$subServiceId',
    );

    try {
      final response = await _client
          .get(
            uri,
            headers: {
              'Authorization': 'Bearer $token',
              'Accept': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode >= 200 &&
          response.statusCode < 300) {
        final decoded = jsonDecode(response.body);

        final results = decoded['results'] as List<dynamic>;

        return Right(
          SalonOfferModel.listFromJson(results),
        );
      }

      return Left(_mapHttpError(response));
    } on TimeoutException {
      return Left(AppFailure('Request timed out'));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  AppFailure _mapHttpError(http.Response response) {
    try {
      final decoded = jsonDecode(response.body);
      return AppFailure(decoded['detail'] ?? 'Failed to load salons');
    } catch (_) {
      return AppFailure('Failed to load salons');
    }
  }
}
