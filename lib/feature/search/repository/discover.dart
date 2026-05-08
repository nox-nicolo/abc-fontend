import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:africa_beuty/core/constants/server_constants.dart';
import 'package:africa_beuty/core/failure/failure.dart';
import 'package:africa_beuty/core/http/api_client.dart';
import 'package:africa_beuty/core/http/paginated_response.dart';
import 'package:africa_beuty/feature/search/model/discover.dart';
import 'package:fpdart/fpdart.dart';

class DiscoverRepository {
  Future<Either<AppFailure, List<NearbySalonItem>>> getNearby({
    required double lat,
    required double lng,
    double radiusKm = 15,
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
      if (response.statusCode == 200) {
        final list = listFromPaginatedBody(jsonDecode(response.body));
        return Right(
          list
              .map((e) => NearbySalonItem.fromMap(e as Map<String, dynamic>))
              .toList(),
        );
      }
      return Left(AppFailure('Failed to load nearby salons'));
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
      final uri = Uri.parse(
        '${ServerConstants.serverUrl}/search/top-salons',
      ).replace(queryParameters: {'limit': limit.toString()});
      final response = await ApiClient.instance
          .get(uri)
          .timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        final list = listFromPaginatedBody(jsonDecode(response.body));
        return Right(
          list
              .map((e) => TopSalonItem.fromMap(e as Map<String, dynamic>))
              .toList(),
        );
      }
      return Left(AppFailure('Failed to load top salons'));
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
      if (response.statusCode == 200) {
        final list = listFromPaginatedBody(jsonDecode(response.body));
        return Right(
          list
              .map((e) => TrendingStyleItem.fromMap(e as Map<String, dynamic>))
              .toList(),
        );
      }
      return Left(AppFailure('Failed to load trending styles'));
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
}
