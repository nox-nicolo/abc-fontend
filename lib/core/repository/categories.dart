import 'dart:convert';

import 'package:africa_beuty/core/constants/server_constants.dart';
import 'package:africa_beuty/core/failure/failure.dart';
import 'package:africa_beuty/core/model/services.dart';
import 'package:africa_beuty/feature/auth/repositories/local_storage_service.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;

class RemotePostCategories {
  
  // Get all the Major services. 
  Future<Either<AppFailure, List<MajorServiceModel>>> getMajor() async {
    try {
      final token = await LocalStorageService.getAccessToken();

      if (token == null ) {
        return Left(AppFailure('Access denied'));
      }

      final response = await http.get(
        Uri.parse(
          '${ServerConstants.serverUrl}/services/major',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', 
        }
      );

    if (response.statusCode != 200) {
      final errorMap = jsonDecode(response.body);
      return Left(AppFailure(errorMap['detail'] ?? 'Unknown error'));
    }

    final List<dynamic> resList = jsonDecode(response.body);

    final services = resList
      .map(
        (item) => MajorServiceModel.fromMap(item as Map<String, dynamic>)
      )
      .toList();

    return Right(
      services
    );

    } catch (e) {
      return Left(AppFailure(e.toString()));
    }

  }
  
  Future<Either<AppFailure, List<PostMinorCategoriesModel>>> getMinor() async {
    
    try {
      final token = await LocalStorageService.getAccessToken();

      if (token == null ) {
        return Left(AppFailure('Access denied'));
      }

      final response = await http.get(
        Uri.parse(
          '${ServerConstants.serverUrl}/services/minor/',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', 
        }
      );


    if (response.statusCode != 200) {
      final errorMap = jsonDecode(response.body);
      return Left(AppFailure(errorMap['detail'] ?? 'Unknown error'));
    }

    final List<dynamic> resList = jsonDecode(response.body);

    final services = resList
      .map(
        (item) => PostMinorCategoriesModel.fromMap(item as Map<String, dynamic>)
      )
      .toList();

    return Right(
      services
    );

    } catch (e) {
      return Left(AppFailure(e.toString()));
    }

  }
}