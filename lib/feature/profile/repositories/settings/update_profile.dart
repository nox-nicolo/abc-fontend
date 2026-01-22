
import 'dart:convert';
import 'dart:io';

import 'package:africa_beuty/core/constants/server_constants.dart';
import 'package:africa_beuty/core/failure/failure.dart';
import 'package:africa_beuty/feature/auth/repositories/local_storage_service.dart';
import 'package:africa_beuty/feature/profile/model/settings/profile_cover.dart';
import 'package:africa_beuty/feature/profile/model/settings/profile_details.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;

class UpdateSalonRepository {

  // Cover and Profile Picture
  Future<Either<AppFailure, MediaUpdate>> updateAccountMedia({
    File? profileImage,
    File? coverImage,
  }) async {
    final token = await LocalStorageService.getAccessToken();
    if (token == null) return Left(AppFailure('Authentication required'));

    final uri = Uri.parse('${ServerConstants.serverUrl}/profile/upload_account_media');

    try {
      final request = http.MultipartRequest('PATCH', uri);
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      if (profileImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'profile_image', // Changed from 'profile_picture'
          profileImage.path,
        ));
      }

      if (coverImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'cover_ads', // Changed from 'display_ads'
          coverImage.path,
        ));
      }

      final streamedResponse = await request.send().timeout(const Duration(seconds: 30));
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return Right(MediaUpdate.fromJson(response.body));
      }
      return Left(_mapHttpError(response));
    } catch (e) {
      return Left(AppFailure('Upload failed: ${e.toString()}'));
    }
  }

  // Inside UpdateSalon Details

  Future<Either<AppFailure, SalonProfileUpdate>> updateSalonDetails({
    required String title,
    required String slogan,
    required String description,
  }) async {
    final token = await LocalStorageService.getAccessToken();
    if (token == null) return Left(AppFailure('Authentication required'));

    final uri = Uri.parse('${ServerConstants.serverUrl}/profile/salon_profile');

    try {
      final response = await http.patch(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'title': title,
          'slogan': slogan,
          'description': description,
        }),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return Right(SalonProfileUpdate.fromJson(response.body));
      }
      return Left(_mapHttpError(response));
    } catch (e) {
      return Left(AppFailure('Update failed: ${e.toString()}'));
    }
  }

  // Function for the Location and Contacts
  // Inside UpdateSalonRepository class

  Future<Either<AppFailure, SalonProfileUpdate>> updateContactLocation({
    required List<String> phoneNumbers,
    required String email,
    required String website,
    required String country,
    required String city,
    required String street,
    required String address,
    required double latitude,
    required double longitude,
  }) async {
    final token = await LocalStorageService.getAccessToken();
    if (token == null) return Left(AppFailure('Authentication required'));

    final uri = Uri.parse('${ServerConstants.serverUrl}/profile/contact');

    try {
      final response = await http.patch(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'phone_numbers': phoneNumbers,
          'email': email,
          'website': website,
          'country': country,
          'city': city,
          'street': street,
          'address': address,
          'latitude': latitude,
          'longitude': longitude,
        }),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return Right(SalonProfileUpdate.fromJson(response.body));
      }
      return Left(_mapHttpError(response));
    } catch (e) {
      return Left(AppFailure('Update failed: ${e.toString()}'));
    }
  }

  // Update working hours:

  Future<Either<AppFailure, void>> updateWorkingHours(List<Map<String, dynamic>> workingDays) async {
    final token = await LocalStorageService.getAccessToken();
    if (token == null) return Left(AppFailure('Authentication required'));

    final uri = Uri.parse('${ServerConstants.serverUrl}/profile/working_hours');

    try {
      final response = await http.put(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        // Matches SalonWorkingHoursUpdateRequest structure
        body: jsonEncode({
          'working_days': workingDays,
        }),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return const Right(null);
      }
      return Left(_mapHttpError(response));
    } catch (e) {
      return Left(AppFailure('Failed to update working hours: $e'));
    }
  }
  
  // Updateing Salon Galleries

  Future<Either<AppFailure, void>> updateGallery({
    required List<File> newFiles,
    required List<String> deleteIds,
  }) async {
    final token = await LocalStorageService.getAccessToken();
    if (token == null) return Left(AppFailure('Authentication required'));

    // URL updated to /salon_gallery
    final uri = Uri.parse('${ServerConstants.serverUrl}/profile/salon_gallery');

    try {
      final request = http.MultipartRequest('PATCH', uri);
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      // 1. Add IDs to delete
      // FastAPI List[str] = Form() usually expects multiple fields with same key
      for (var id in deleteIds) {
        request.fields['delete_ids'] = id; 
      }

      // 2. Add new files
      for (var file in newFiles) {
        request.files.add(await http.MultipartFile.fromPath(
          'files', // Key matches backend 'files'
          file.path,
        ));
      }

      final streamedResponse = await request.send().timeout(const Duration(seconds: 60));
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return const Right(null);
      }
      return Left(_mapHttpError(response));
    } catch (e) {
      return Left(AppFailure('Gallery update failed: $e'));
    }
  }
  
  // Reusable methods
  AppFailure _mapHttpError(http.Response response) {
    switch (response.statusCode) {
      case 401:
      case 403:
        return AppFailure('Session expired. Please login again.');
      case 404:
        return AppFailure('Salon profile not found');
      case 500:
      case 502:
      case 503:
        return AppFailure('Server error. Please try later.');
      default:
        return AppFailure(_safeErrorMessage(response.body));
    }
  }

  String _safeErrorMessage(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map && decoded['detail'] != null) {
        return decoded['detail'].toString();
      }
    } catch (_) {}
    return 'Failed to load profile';
  }
}