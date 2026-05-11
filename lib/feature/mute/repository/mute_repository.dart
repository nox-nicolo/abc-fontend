import 'dart:convert';

import 'package:africa_beuty/core/constants/server_constants.dart';
import 'package:africa_beuty/core/failure/failure.dart';
import 'package:africa_beuty/core/http/api_client.dart';
import 'package:fpdart/fpdart.dart';

class MuteRepository {
  Future<Either<AppFailure, Unit>> mute({
    required String targetType,
    required String targetId,
  }) async {
    try {
      final response = await ApiClient.instance.post(
        Uri.parse(
          '${ServerConstants.serverUrl}/users/me/mutes/$targetType/$targetId',
        ),
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return const Right(unit);
      }
      return Left(AppFailure(_detail(response.body)));
    } catch (e) {
      return Left(AppFailure('Could not mute $targetType: $e'));
    }
  }

  Future<Either<AppFailure, Unit>> unmute({
    required String targetType,
    required String targetId,
  }) async {
    try {
      final response = await ApiClient.instance.delete(
        Uri.parse(
          '${ServerConstants.serverUrl}/users/me/mutes/$targetType/$targetId',
        ),
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return const Right(unit);
      }
      return Left(AppFailure(_detail(response.body)));
    } catch (e) {
      return Left(AppFailure('Could not unmute $targetType: $e'));
    }
  }

  String _detail(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map && decoded['detail'] != null) {
        return decoded['detail'].toString();
      }
    } catch (_) {}
    return 'Mute request failed';
  }
}
