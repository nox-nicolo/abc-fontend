import 'dart:convert';
import 'dart:io';

import 'package:africa_beuty/core/constants/server_constants.dart';
import 'package:africa_beuty/core/failure/failure.dart';
import 'package:africa_beuty/core/http/api_client.dart';
import 'package:africa_beuty/core/http/paginated_response.dart';
import 'package:africa_beuty/core/model/services.dart';
import 'package:africa_beuty/feature/auth/model/me_model.dart';
import 'package:africa_beuty/feature/auth/model/signin_model.dart';
import 'package:africa_beuty/feature/auth/model/signup_model.dart';
import 'package:africa_beuty/feature/auth/model/userprofile_model.dart';
import 'package:africa_beuty/feature/auth/model/verification_model.dart';
import 'package:africa_beuty/feature/auth/repositories/local_storage_service.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;

class AuthRemoteRepository {
  Future<Either<AppFailure, SignupModel>> signup({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String role,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ServerConstants.serverUrl}/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
          'role': role,
        }),
      );

      final resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 201) {
        // handle error
        return Left(AppFailure(resBodyMap['detail']));
      }
      // if status is ok then convert json to a map
      return Right(SignupModel.fromMap(resBodyMap));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, SigninModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ServerConstants.serverUrl}/auth/login'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'username': email, 'password': password},
      );

      final resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;
      // so here I return the response from the data..
      if (response.statusCode != 200) {
        // handle error
        return Left(AppFailure(resBodyMap['detail']));
      }
      return Right(SigninModel.fromMap(resBodyMap));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, VerificationCodeModel>> newCode({
    required String code,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ServerConstants.serverUrl}/auth/code'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"code": code}),
      );

      final respBodyMap = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200) {
        return Left(AppFailure(respBodyMap['detail']));
      }

      return Right(VerificationCodeModel.fromMap(respBodyMap));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, VerificationModel>> verify({
    required String code,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ServerConstants.serverUrl}/auth/verify'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"code": code}),
      );

      final resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200) {
        return Left(AppFailure(resBodyMap['detail']));
      }

      return Right(VerificationModel.fromMap(resBodyMap));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, SetAccountModel>> setAccount() async {
    try {
      final response = await ApiClient.instance.get(
        Uri.parse('${ServerConstants.serverUrl}/setup/setup_account'),
      );

      final resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200) {
        return Left(AppFailure(resBodyMap['detail']));
      }

      return Right(SetAccountModel.fromMap(resBodyMap));
    } on SessionExpiredException catch (e) {
      return Left(AppFailure(e.toString()));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, UploadAccountModel>> uploadAccount({
    File? pictureUrl,
    required String username,
  }) async {
    try {
      final token = await LocalStorageService.getAccessToken();

      if (token == null) {
        return Left(AppFailure("No Access Token"));
      }

      var uri = Uri.parse('${ServerConstants.serverUrl}/setup/upload_account');

      var request = http.MultipartRequest('PATCH', uri);

      // Add the token to headers
      request.headers['Authorization'] = 'Bearer $token';

      // Add text if provided
      request.fields['data'] = username;

      // Add file if provided
      if (pictureUrl != null) {
        request.files.add(
          await http.MultipartFile.fromPath('image_name', pictureUrl.path),
        );
      }

      // Send the request
      var streamedResponse = await request.send();

      // Response handling
      final response = await http.Response.fromStream(streamedResponse);

      final resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200) {
        return Left(AppFailure(resBodyMap['detail']));
      }

      return Right(UploadAccountModel.fromMap(resBodyMap));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  // Get all the Major services.
  Future<Either<AppFailure, List<MajorServiceModel>>> getMajor() async {
    try {
      final response = await ApiClient.instance.get(
        Uri.parse('${ServerConstants.serverUrl}/services/major'),
      );

      if (response.statusCode != 200) {
        final errorMap = jsonDecode(response.body);
        return Left(AppFailure(errorMap['detail'] ?? 'Unknown error'));
      }

      final resList = listFromPaginatedBody(jsonDecode(response.body));
      final services = resList
          .map(
            (item) => MajorServiceModel.fromMap(item as Map<String, dynamic>),
          )
          .toList();

      return Right(services);
    } on SessionExpiredException catch (e) {
      return Left(AppFailure(e.toString()));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, UploadServiceModel>> uploadService({
    required List<String> selected,
  }) async {
    try {
      final response = await ApiClient.instance.post(
        Uri.parse('${ServerConstants.serverUrl}/setup/services_selected'),
        body: jsonEncode({'service': selected}),
      );

      final resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200) {
        return Left(AppFailure(resBodyMap['detail'] ?? 'Unknown error'));
      }

      return Right(UploadServiceModel.fromMap(resBodyMap));
    } on SessionExpiredException catch (e) {
      return Left(AppFailure(e.toString()));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, MeModel>> me() async {
    try {
      final response = await ApiClient.instance.get(
        Uri.parse('${ServerConstants.serverUrl}/auth/me'),
      );

      final resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200) {
        return Left(AppFailure(resBodyMap['detail']));
      }

      return Right(MeModel.fromMap(resBodyMap));
    } on SessionExpiredException catch (e) {
      return Left(AppFailure(e.toString()));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  /// Revokes the refresh token on the server, then clears local auth data.
  /// Always clears locally — even if the network call fails.
  Future<void> signOut() async {
    try {
      final refreshToken = await LocalStorageService.getRefreshToken();
      if (refreshToken != null) {
        await http
            .post(
              Uri.parse('${ServerConstants.serverUrl}/auth/logout'),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode({'refresh_token': refreshToken}),
            )
            .timeout(const Duration(seconds: 10));
      }
    } catch (_) {
      // Best-effort: always clear locally regardless of network errors.
    }
    await LocalStorageService.clearAuthData();
  }
}
