import 'package:africa_beuty/feature/auth/model/me_model.dart';
import 'package:africa_beuty/feature/auth/repositories/local_storage_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_provider.g.dart';

// Provider for current user state (cached)
@riverpod 
class CurrentUser extends _$CurrentUser {
  @override 
  MeModel? build() {
    // Load user from storage when provider is created
    _loadFromStorage();
    return null;
  }

  void _loadFromStorage() async {
    final userData = await LocalStorageService.getuserData();
    if (userData != null) {
      state = userData;
    }
  }

  // Update user data in memory
  void setUser(MeModel user) {
    state = user; 
  }

  // Clear user data 
  void clearUser() {
    state = null;
  }
}

