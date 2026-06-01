import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:africa_beuty/core/constants/server_constants.dart';
import 'package:africa_beuty/core/failure/failure.dart';
import 'package:africa_beuty/core/http/api_client.dart';
import 'package:africa_beuty/core/http/response_body.dart';
import 'package:africa_beuty/feature/search/model/search.dart';
import 'package:fpdart/fpdart.dart';

class SearchHistoryItem {
  const SearchHistoryItem({
    required this.id,
    required this.query,
    required this.entity,
    this.entityId,
  });

  final String id;
  final String query;
  final String entity;
  final String? entityId;

  factory SearchHistoryItem.fromMap(Map<String, dynamic> map) {
    return SearchHistoryItem(
      id: map['id']?.toString() ?? '',
      query: map['query']?.toString() ?? '',
      entity: map['entity']?.toString() ?? 'query',
      entityId: map['entity_id']?.toString(),
    );
  }
}

class SearchHistoryRepository {
  Future<Either<AppFailure, List<SearchHistoryItem>>> list({
    int limit = 10,
  }) async {
    try {
      final uri = Uri.parse(
        '${ServerConstants.serverUrl}/search/history',
      ).replace(queryParameters: {'limit': limit.toString()});
      final response = await ApiClient.instance.get(uri);
      if (response.statusCode != 200) {
        return Left(
          AppFailure(
            responseErrorMessage(response, 'Failed to load recent searches'),
          ),
        );
      }
      final body = decodeMapOrThrow(response);
      final items = (body['items'] as List? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(SearchHistoryItem.fromMap)
          .toList();
      return Right(items);
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

  Future<Either<AppFailure, bool>> saveResult({
    required String query,
    required SearchResult result,
  }) {
    return save(
      query: query,
      entity: result.entity.name,
      entityId: switch (result) {
        SearchServiceResult(:final salonServicePriceId, :final id) =>
          salonServicePriceId ?? id,
        _ => result.id,
      },
    );
  }

  Future<Either<AppFailure, bool>> save({
    required String query,
    required String entity,
    String? entityId,
  }) async {
    try {
      final response = await ApiClient.instance.post(
        Uri.parse('${ServerConstants.serverUrl}/search/history'),
        extra: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'query': query,
          'entity': entity,
          'entity_id': entityId,
        }),
      );
      if (response.statusCode != 200) {
        return Left(
          AppFailure(responseErrorMessage(response, 'Failed to save search')),
        );
      }
      return const Right(true);
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

  Future<Either<AppFailure, bool>> deleteItem(String id) async {
    try {
      final response = await ApiClient.instance.delete(
        Uri.parse('${ServerConstants.serverUrl}/search/history/$id'),
      );
      if (response.statusCode != 200) {
        return Left(
          AppFailure(responseErrorMessage(response, 'Failed to remove search')),
        );
      }
      return const Right(true);
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

  Future<Either<AppFailure, bool>> clear() async {
    try {
      final response = await ApiClient.instance.delete(
        Uri.parse('${ServerConstants.serverUrl}/search/history'),
      );
      if (response.statusCode != 200) {
        return Left(
          AppFailure(
            responseErrorMessage(response, 'Failed to clear search history'),
          ),
        );
      }
      return const Right(true);
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
