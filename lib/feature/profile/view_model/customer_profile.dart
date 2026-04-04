import 'package:africa_beuty/feature/profile/model/customer_profile.dart';
import 'package:africa_beuty/feature/profile/providers/customer_profile.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'customer_profile.g.dart';

// ── Own profile ───────────────────────────────────────────────────────────────
@riverpod
class MyCustomerProfileViewModel extends _$MyCustomerProfileViewModel {
  @override
  AsyncValue<CustomerProfileModel> build() {
    _fetch();
    return const AsyncValue.loading();
  }

  Future<void> _fetch() async {
    final repo = ref.read(customerProfileRepositoryProvider);
    final res = await repo.getMyProfile();
    switch (res) {
      case Left(value: final l):
        state = AsyncValue.error(l.message, StackTrace.current);
      case Right(value: final r):
        state = AsyncValue.data(r);
    }
  }

  Future<void> refresh() => _fetch();

  Future<bool> update({
    String? name,
    String? bio,
    String? city,
    String? country,
    String? gender,
  }) async {
    final repo = ref.read(customerProfileRepositoryProvider);
    final res = await repo.updateMyProfile(
      name: name,
      bio: bio,
      city: city,
      country: country,
      gender: gender,
    );
    switch (res) {
      case Left(value: final l):
        state = AsyncValue.error(l.message, StackTrace.current);
        return false;
      case Right(value: final r):
        state = AsyncValue.data(r);
        return true;
    }
  }
}

// ── Another user's profile (parameterized by userId) ─────────────────────────
@riverpod
class UserProfileViewModel extends _$UserProfileViewModel {
  @override
  AsyncValue<CustomerProfileModel> build(String userId) {
    _fetch(userId);
    return const AsyncValue.loading();
  }

  Future<void> _fetch(String userId) async {
    final repo = ref.read(customerProfileRepositoryProvider);
    final res = await repo.getUserProfile(userId);
    switch (res) {
      case Left(value: final l):
        state = AsyncValue.error(l.message, StackTrace.current);
      case Right(value: final r):
        state = AsyncValue.data(r);
    }
  }
}
