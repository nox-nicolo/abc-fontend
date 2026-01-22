import 'dart:io';
import 'package:africa_beuty/feature/profile/model/settings/profile_cover.dart';
import 'package:africa_beuty/feature/profile/providers/settings/salon_update.dart'; // Your update repository provider
import 'package:africa_beuty/feature/profile/view_model/salon.dart'; // To invalidate main profile
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_cover.g.dart';

@riverpod
class SalonUpdateViewModel extends _$SalonUpdateViewModel {
  @override
  AsyncValue<MediaUpdate?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> updateAccountMedia({
    required File? profileImage,
    required File? coverImage,
  }) async {
    state = const AsyncValue.loading();

    final repository = ref.read(salonUpdateProvider);
    final result = await repository.updateAccountMedia(
      profileImage: profileImage,
      coverImage: coverImage,
    );

    switch (result) {
      case Left(value: final l):
        state = AsyncValue.error(l.message, StackTrace.current);
      case Right(value: final r):
        state = AsyncValue.data(r);
        
        // IMPORTANT: We need to trigger the main profile refresh 
        // and wait for it to complete.
        await ref.read(salonProfileViewModelProvider.notifier).getSalonProfileData();
    }
  }

  // View Model for Profile Details
  Future<void> updateSalonDetails({
    required String title,
    required String slogan,
    required String description,
  }) async {
    state = const AsyncValue.loading();

    final repository = ref.read(salonUpdateProvider);
    final result = await repository.updateSalonDetails(
      title: title,
      slogan: slogan,
      description: description,
    );

    switch (result) {
      case Left(value: final l):
        state = AsyncValue.error(l.message, StackTrace.current);
      case Right(value: final _):
        // On success, refresh the main salon profile so all screens update
        await ref.read(salonProfileViewModelProvider.notifier).getSalonProfileData();
        state = const AsyncValue.data(null); // Reset update state
    }
  }

  // View Model for Contact and Locations
  
  // Handle Contact & Location
  Future<void> updateContactLocation({
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
    state = const AsyncValue.loading();
    
    final repository = ref.read(salonUpdateProvider);
    final result = await repository.updateContactLocation(
      phoneNumbers: phoneNumbers,
      email: email,
      website: website,
      country: country,
      city: city,
      street: street,
      address: address,
      latitude: latitude,
      longitude: longitude,
    );

    switch (result) {
      case Left(value: final l):
        state = AsyncValue.error(l.message, StackTrace.current);
      case Right(value: final _):
        // Sync the main profile
        await ref.read(salonProfileViewModelProvider.notifier).getSalonProfileData();
        state = const AsyncValue.data(null);
    }
  }

  // Working Hours:

  Future<void> updateWorkingHours(List<Map<String, dynamic>> workingDays) async {
    state = const AsyncValue.loading();
    
    final repository = ref.read(salonUpdateProvider);
    final result = await repository.updateWorkingHours(workingDays);

    switch (result) {
      case Left(value: final l):
        state = AsyncValue.error(l.message, StackTrace.current);
      case Right(value: _):
        await ref.read(salonProfileViewModelProvider.notifier).getSalonProfileData();
        state = const AsyncValue.data(null);
    }
  }

  // Salon Galleries

  Future<void> updateGallery({
    required List<File> newFiles,
    required List<String> deleteIds,
  }) async {
    state = const AsyncValue.loading();

    final repository = ref.read(salonUpdateProvider);
    final result = await repository.updateGallery(
      newFiles: newFiles,
      deleteIds: deleteIds,
    );

    switch (result) {
      case Left(value: final l):
        state = AsyncValue.error(l.message, StackTrace.current);
      case Right(value: _):
        await ref.read(salonProfileViewModelProvider.notifier).getSalonProfileData();
        state = const AsyncValue.data(null);
    }
  }
}
