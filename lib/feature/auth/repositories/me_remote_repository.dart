import 'package:africa_beuty/core/constants/server_constants.dart';
import 'package:africa_beuty/core/failure/failure.dart';
import 'package:africa_beuty/core/http/api_client.dart';
import 'package:africa_beuty/core/http/response_body.dart';
import 'package:africa_beuty/feature/auth/model/me_model.dart';
import 'package:fpdart/fpdart.dart';

class MeRemoteRepository {
  Future<Either<AppFailure, MeModel>> getMe() async {
    try {
      final response = await ApiClient.instance.get(
        Uri.parse('${ServerConstants.serverUrl}/auth/me'),
      );

      if (response.statusCode != 200) {
        return Left(
          AppFailure(responseErrorMessage(response, 'Failed to load account')),
        );
      }
      final resBodyMap = decodeMapOrThrow(response);

      return Right(MeModel.fromMap(resBodyMap));
    } on SessionExpiredException catch (e) {
      return Left(AppFailure(e.toString()));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
