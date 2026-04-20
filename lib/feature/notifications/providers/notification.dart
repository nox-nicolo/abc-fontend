import 'package:africa_beuty/feature/notifications/repositories/notification.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification.g.dart';

@riverpod
NotificationRepositoryImpl notificationRepository(Ref ref) {
  return NotificationRepositoryImpl();
}
