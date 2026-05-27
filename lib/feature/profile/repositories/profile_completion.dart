import 'dart:async';

import 'package:africa_beuty/core/constants/server_constants.dart';
import 'package:africa_beuty/core/failure/failure.dart';
import 'package:africa_beuty/core/http/api_client.dart';
import 'package:africa_beuty/core/http/response_body.dart';
import 'package:africa_beuty/feature/profile/model/profile_completion.dart';
import 'package:fpdart/fpdart.dart';

class ProfileCompletionRepository {
  Future<Either<AppFailure, ProfileCompletionModel>> getCompletion() async {
    try {
      final response = await ApiClient.instance.get(
        Uri.parse('${ServerConstants.serverUrl}/users/me/profile-completion'),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return Right(
          ProfileCompletionModel.fromMap(decodeMapOrThrow(response)),
        );
      }
      return Left(
        AppFailure(
          responseErrorMessage(response, 'Failed to load profile completion'),
        ),
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
