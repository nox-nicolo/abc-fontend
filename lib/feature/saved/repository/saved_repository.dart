import 'dart:convert';

import 'package:africa_beuty/core/constants/server_constants.dart';
import 'package:africa_beuty/core/failure/failure.dart';
import 'package:africa_beuty/core/http/api_client.dart';
import 'package:africa_beuty/feature/saved/model/saved_item.dart';
import 'package:fpdart/fpdart.dart';

class SavedRepository {
  Future<Either<AppFailure, SavedCollection>> getSaved() async {
    try {
      final salonsResult = await _getList(
        '/users/me/saved/salons',
        SavedSalon.fromMap,
      );
      final servicesResult = await _getList(
        '/users/me/saved/services',
        SavedService.fromMap,
      );
      final stylesResult = await _getList(
        '/users/me/saved/styles',
        SavedStyle.fromMap,
      );

      if (salonsResult case Left(value: final failure)) return Left(failure);
      if (servicesResult case Left(value: final failure)) return Left(failure);
      if (stylesResult case Left(value: final failure)) return Left(failure);

      return Right(
        SavedCollection(
          salons: (salonsResult as Right<AppFailure, List<SavedSalon>>).value,
          services:
              (servicesResult as Right<AppFailure, List<SavedService>>).value,
          styles: (stylesResult as Right<AppFailure, List<SavedStyle>>).value,
        ),
      );
    } on SessionExpiredException catch (e) {
      return Left(AppFailure(e.toString()));
    } catch (e) {
      return Left(AppFailure('Saved items error: $e'));
    }
  }

  Future<Either<AppFailure, List<T>>> _getList<T>(
    String path,
    T Function(Map<String, dynamic>) fromMap,
  ) async {
    try {
      final response = await ApiClient.instance.get(
        Uri.parse('${ServerConstants.serverUrl}$path'),
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        return Left(AppFailure(_detail(response.body, 'Failed to load saved')));
      }

      final decoded = jsonDecode(response.body);
      final list = _extractList(decoded);
      return Right(
        list
            .whereType<Map>()
            .map((item) => fromMap(Map<String, dynamic>.from(item)))
            .toList(),
      );
    } on SessionExpiredException {
      rethrow;
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, bool>> toggleSalon(String salonId) =>
      _toggle('/users/me/saved/salons/$salonId');

  Future<Either<AppFailure, bool>> toggleService(String serviceId) =>
      _toggle('/users/me/saved/services/$serviceId');

  Future<Either<AppFailure, bool>> toggleStyle(String styleId) =>
      _toggle('/users/me/saved/styles/$styleId');

  Future<Either<AppFailure, bool>> _toggle(String path) async {
    try {
      final response = await ApiClient.instance.post(
        Uri.parse('${ServerConstants.serverUrl}$path'),
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        return Left(
          AppFailure(_detail(response.body, 'Failed to update saved')),
        );
      }

      final decoded = jsonDecode(response.body);
      if (decoded is Map) {
        final saved = decoded['saved'] ?? decoded['is_saved'];
        if (saved is bool) return Right(saved);
      }
      return const Right(true);
    } on SessionExpiredException catch (e) {
      return Left(AppFailure(e.toString()));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  List _extractList(dynamic decoded) {
    if (decoded is List) return decoded;
    if (decoded is Map) {
      for (final key in ['items', 'results', 'saved']) {
        final value = decoded[key];
        if (value is List) return value;
      }
    }
    return const [];
  }

  String _detail(String body, String fallback) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map && decoded['detail'] != null) {
        return decoded['detail'].toString();
      }
    } catch (_) {}
    return fallback;
  }
}
