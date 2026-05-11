import 'dart:async';

import 'package:africa_beuty/core/reminders/reminder_service.dart';
import 'package:africa_beuty/feature/profile/model/notification_preferences.dart';
import 'package:africa_beuty/feature/profile/providers/notification_preferences.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_preferences.g.dart';

@riverpod
class NotificationPreferencesViewModel
    extends _$NotificationPreferencesViewModel {
  @override
  AsyncValue<NotificationPreferences> build() {
    _fetch();
    return const AsyncValue.loading();
  }

  Future<void> _fetch() async {
    final repo = ref.read(notificationPreferencesRepositoryProvider);
    final res = await repo.getPreferences();
    switch (res) {
      case Left(value: final l):
        state = AsyncValue.error(l.message, StackTrace.current);
      case Right(value: final r):
        state = AsyncValue.data(r);
    }
  }

  Future<bool> update({
    bool? allowLikes,
    bool? allowComments,
    bool? allowBookings,
    bool? allowPromotions,
    bool? allowReminders,
    int? reminderLeadMinutes,
  }) async {
    final repo = ref.read(notificationPreferencesRepositoryProvider);
    final res = await repo.updatePreferences(
      allowLikes: allowLikes,
      allowComments: allowComments,
      allowBookings: allowBookings,
      allowPromotions: allowPromotions,
      allowReminders: allowReminders,
      reminderLeadMinutes: reminderLeadMinutes,
    );
    switch (res) {
      case Left(value: final l):
        state = AsyncValue.error(l.message, StackTrace.current);
        return false;
      case Right(value: final r):
        state = AsyncValue.data(r);
        // Re-sync local notifications to reflect new prefs.
        unawaited(ReminderService.instance.syncFromServer());
        return true;
    }
  }
}
