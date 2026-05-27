import 'dart:async';

import 'package:africa_beuty/core/constants/server_constants.dart';
import 'package:africa_beuty/core/failure/failure.dart';
import 'package:africa_beuty/core/http/api_client.dart';
import 'package:africa_beuty/core/http/response_body.dart';
import 'package:africa_beuty/feature/profile/model/audit_log.dart';
import 'package:fpdart/fpdart.dart';

class AuditLogRepository {
  Future<Either<AppFailure, AuditLogResponse>> getAuditLog({
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final uri = Uri.parse('${ServerConstants.serverUrl}/users/me/audit-log')
          .replace(
            queryParameters: {
              'limit': limit.toString(),
              'offset': offset.toString(),
            },
          );
      final response = await ApiClient.instance.get(uri);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return Right(AuditLogResponse.fromMap(decodeMapOrThrow(response)));
      }
      return Left(
        AppFailure(responseErrorMessage(response, 'Failed to load activity')),
      );
    } on TimeoutException {
      return Left(AppFailure('Request timed out'));
    } on SessionExpiredException catch (e) {
      return Left(AppFailure(e.toString()));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
