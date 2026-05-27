import 'dart:async';
import 'dart:convert';

import 'package:africa_beuty/core/constants/server_constants.dart';
import 'package:africa_beuty/core/failure/failure.dart';
import 'package:africa_beuty/core/http/api_client.dart';
import 'package:africa_beuty/core/http/response_body.dart';
import 'package:africa_beuty/feature/profile/model/profile_insights.dart';
import 'package:fpdart/fpdart.dart';

class ProfileInsightsRepository {
  Future<Either<AppFailure, ProfileInsightsModel>> getInsights() async {
    try {
      final response = await ApiClient.instance
          .get(Uri.parse('${ServerConstants.serverUrl}/profile/insights'))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return Right(ProfileInsightsModel.fromMap(decodeMapOrThrow(response)));
      }

      return Left(
        AppFailure(responseErrorMessage(response, 'Failed to load insights')),
      );
    } on TimeoutException {
      return Left(AppFailure('Request timed out'));
    } on SessionExpiredException catch (e) {
      return Left(AppFailure(e.toString()));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<void> recordServiceTap({
    required String salonId,
    required String salonServicePriceId,
  }) async {
    try {
      await ApiClient.instance
          .post(
            Uri.parse(
              '${ServerConstants.serverUrl}/profile/salon/$salonId/service-tap/$salonServicePriceId',
            ),
            body: jsonEncode({}),
          )
          .timeout(const Duration(seconds: 8));
    } catch (_) {
      // Insights are best-effort and should never block booking/profile flows.
    }
  }
}
