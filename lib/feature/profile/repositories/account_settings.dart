import 'dart:async';
import 'dart:convert';

import 'package:africa_beuty/core/constants/server_constants.dart';
import 'package:africa_beuty/core/failure/failure.dart';
import 'package:africa_beuty/core/http/api_client.dart';
import 'package:africa_beuty/core/http/response_body.dart';
import 'package:fpdart/fpdart.dart';

class AccountSettingsRepository {
  Future<Either<AppFailure, Map<String, dynamic>>> getSettings() async {
    try {
      final response = await ApiClient.instance.get(
        Uri.parse('${ServerConstants.serverUrl}/users/me/account-settings'),
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = decodeMapOrThrow(response);
        return Right(
          Map<String, dynamic>.from(decoded['settings'] as Map? ?? {}),
        );
      }
      return Left(
        AppFailure(responseErrorMessage(response, 'Failed to load settings')),
      );
    } on TimeoutException {
      return Left(AppFailure('Request timed out'));
    } on SessionExpiredException catch (e) {
      return Left(AppFailure(e.toString()));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, Map<String, dynamic>>> updateSettings(
    Map<String, dynamic> settings,
  ) async {
    try {
      final response = await ApiClient.instance.patch(
        Uri.parse('${ServerConstants.serverUrl}/users/me/account-settings'),
        body: jsonEncode({'settings': settings}),
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = decodeMapOrThrow(response);
        return Right(
          Map<String, dynamic>.from(decoded['settings'] as Map? ?? {}),
        );
      }
      return Left(
        AppFailure(responseErrorMessage(response, 'Failed to update settings')),
      );
    } on SessionExpiredException catch (e) {
      return Left(AppFailure(e.toString()));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
