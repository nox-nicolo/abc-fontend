import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:africa_beuty/core/constants/server_constants.dart';
import 'package:africa_beuty/core/failure/failure.dart';
import 'package:africa_beuty/core/http/api_client.dart';
import 'package:africa_beuty/feature/ads/model/ad_campaign.dart';
import 'package:fpdart/fpdart.dart';

class AdRepository {
  Future<Either<AppFailure, List<AdCampaign>>> fetchAds({
    required String placement,
    int limit = 1,
    String? country,
    String? city,
    String? categoryId,
  }) async {
    try {
      final params = {
        'placement': placement,
        'limit': limit.toString(),
        if (country != null && country.isNotEmpty) 'country': country,
        if (city != null && city.isNotEmpty) 'city': city,
        if (categoryId != null && categoryId.isNotEmpty)
          'category_id': categoryId,
      };

      final uri = Uri.parse(
        '${ServerConstants.serverUrl}/ads',
      ).replace(queryParameters: params);

      final response = await ApiClient.instance
          .get(uri)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        return Left(AppFailure('Failed to load ads'));
      }

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final rawItems = (decoded['items'] as List?) ?? const [];
      return Right(
        rawItems
            .whereType<Map<String, dynamic>>()
            .map(AdCampaign.fromMap)
            .toList(),
      );
    } on SocketException {
      return Left(AppFailure('No internet connection'));
    } on TimeoutException {
      return Left(AppFailure('Request timed out'));
    } on SessionExpiredException catch (e) {
      return Left(AppFailure(e.toString()));
    } catch (e) {
      return Left(AppFailure('Ad error: $e'));
    }
  }

  Future<void> recordImpression(AdCampaign ad) async {
    await _recordEvent(ad, 'impression');
  }

  Future<void> recordClick(AdCampaign ad) async {
    await _recordEvent(ad, 'click');
  }

  Future<void> _recordEvent(AdCampaign ad, String event) async {
    try {
      await ApiClient.instance
          .post(
            Uri.parse('${ServerConstants.serverUrl}/ads/${ad.id}/$event'),
            body: jsonEncode({'placement': ad.placement}),
          )
          .timeout(const Duration(seconds: 6));
    } catch (_) {
      // Ad analytics should never block the user experience.
    }
  }
}
