import 'dart:async';
import 'dart:io';

import 'package:africa_beuty/core/constants/server_constants.dart';
import 'package:africa_beuty/core/failure/failure.dart';
import 'package:africa_beuty/core/http/api_client.dart';
import 'package:africa_beuty/core/http/paginated_response.dart';
import 'package:africa_beuty/core/http/response_body.dart';
import 'package:africa_beuty/feature/search/model/discover.dart';
import 'package:fpdart/fpdart.dart';

class DiscoverRepository {
  Future<Either<AppFailure, List<NearbySalonItem>>> getNearby({
    required double lat,
    required double lng,
    double radiusKm = 100,
    int limit = 10,
  }) async {
    try {
      final uri = Uri.parse('${ServerConstants.serverUrl}/search/nearby')
          .replace(
            queryParameters: {
              'lat': lat.toString(),
              'lng': lng.toString(),
              'radius_km': radiusKm.toString(),
              'limit': limit.toString(),
            },
          );
      final response = await ApiClient.instance
          .get(uri)
          .timeout(const Duration(seconds: 15));
      if (response.statusCode != 200) {
        return Left(
          AppFailure(
            responseErrorMessage(response, 'Failed to load nearby salons'),
          ),
        );
      }

      final list = listFromPaginatedBody(decodeMapOrThrow(response));
      return Right(
        list
            .whereType<Map<String, dynamic>>()
            .map(NearbySalonItem.fromMap)
            .toList(),
      );
    } on SocketException {
      return Left(AppFailure('No internet connection'));
    } on TimeoutException {
      return Left(AppFailure('Request timed out'));
    } on SessionExpiredException catch (e) {
      return Left(AppFailure(e.toString()));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<TopSalonItem>>> getTopSalons({
    int limit = 10,
  }) async {
    try {
      final primary = await _getTopSalonsFrom(
        Uri.parse(
          '${ServerConstants.serverUrl}/search/top-salons',
        ).replace(queryParameters: {'limit': limit.toString()}),
      );
      if (primary.isRight()) {
        final salons = primary.getOrElse((_) => const []);
        if (salons.isNotEmpty) return Right(salons);
      }

      final fallback = await _getTopSalonsFrom(
        Uri.parse(
          '${ServerConstants.serverUrl}/profile/top',
        ).replace(queryParameters: {'limit': limit.toString()}),
      );
      if (fallback.isRight()) return fallback;

      return primary;
    } on SocketException {
      return Left(AppFailure('No internet connection'));
    } on TimeoutException {
      return Left(AppFailure('Request timed out'));
    } on SessionExpiredException catch (e) {
      return Left(AppFailure(e.toString()));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<TrendingStyleItem>>> getTrending({
    int limit = 10,
  }) async {
    try {
      final uri = Uri.parse(
        '${ServerConstants.serverUrl}/search/trending',
      ).replace(queryParameters: {'limit': limit.toString()});
      final response = await ApiClient.instance
          .get(uri)
          .timeout(const Duration(seconds: 15));
      if (response.statusCode != 200) {
        return Left(
          AppFailure(
            responseErrorMessage(response, 'Failed to load trending styles'),
          ),
        );
      }

      final list = listFromPaginatedBody(decodeMapOrThrow(response));
      return Right(
        list
            .whereType<Map<String, dynamic>>()
            .map(TrendingStyleItem.fromMap)
            .toList(),
      );
    } on SocketException {
      return Left(AppFailure('No internet connection'));
    } on TimeoutException {
      return Left(AppFailure('Request timed out'));
    } on SessionExpiredException catch (e) {
      return Left(AppFailure(e.toString()));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<TopSalonItem>>> _getTopSalonsFrom(
    Uri uri,
  ) async {
    final response = await ApiClient.instance
        .get(uri)
        .timeout(const Duration(seconds: 15));
    if (response.statusCode != 200) {
      return Left(
        AppFailure(responseErrorMessage(response, 'Failed to load top salons')),
      );
    }

    final list = listFromPaginatedBody(decodeMapOrThrow(response));
    return Right(
      list.whereType<Map<String, dynamic>>().map(TopSalonItem.fromMap).toList(),
    );
  }
}
