import 'dart:async';
import 'dart:io';

import 'package:africa_beuty/core/constants/server_constants.dart';
import 'package:africa_beuty/core/failure/failure.dart';
import 'package:africa_beuty/core/http/api_client.dart';
import 'package:africa_beuty/core/http/response_body.dart';
import 'package:africa_beuty/feature/auth/repositories/local_storage_service.dart';
import 'package:africa_beuty/feature/profile/model/profile_trust.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;

class ProfileTrustRepository {
  Future<Either<AppFailure, ProfileTrustModel>> getTrustStatus() async {
    try {
      final response = await ApiClient.instance
          .get(Uri.parse('${ServerConstants.serverUrl}/profile/trust'))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return Right(ProfileTrustModel.fromMap(decodeMapOrThrow(response)));
      }

      return Left(
        AppFailure(
          responseErrorMessage(response, 'Failed to load trust status'),
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

  Future<Either<AppFailure, void>> uploadBusinessDocument(File file) async {
    try {
      final token = await LocalStorageService.getAccessToken();
      if (token == null || token.isEmpty) {
        return Left(AppFailure('Authentication required'));
      }

      final request = http.MultipartRequest(
        'POST',
        Uri.parse(
          '${ServerConstants.serverUrl}/profile/salon/trust/business-document',
        ),
      );
      request.headers['Authorization'] = 'Bearer $token';
      request.fields['document_type'] = 'business_document';
      request.files.add(
        await http.MultipartFile.fromPath('document', file.path),
      );

      final streamed = await request.send().timeout(
        const Duration(seconds: 20),
      );
      final response = await http.Response.fromStream(streamed);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return const Right(null);
      }

      return Left(
        AppFailure(responseErrorMessage(response, 'Failed to upload document')),
      );
    } on TimeoutException {
      return Left(AppFailure('Request timed out'));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
