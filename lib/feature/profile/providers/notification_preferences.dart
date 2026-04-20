import 'package:africa_beuty/feature/profile/repositories/notification_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_preferences.g.dart';

@riverpod
NotificationPreferencesRepository notificationPreferencesRepository(Ref ref) {
  return NotificationPreferencesRepository();
}
