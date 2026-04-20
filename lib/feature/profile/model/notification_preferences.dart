class NotificationPreferences {
  final bool allowReminders;
  final int reminderLeadMinutes;

  const NotificationPreferences({
    required this.allowReminders,
    required this.reminderLeadMinutes,
  });

  factory NotificationPreferences.fromMap(Map<String, dynamic> map) {
    return NotificationPreferences(
      allowReminders: map['allow_reminders'] as bool? ?? true,
      reminderLeadMinutes: map['reminder_lead_minutes'] as int? ?? 30,
    );
  }

  NotificationPreferences copyWith({
    bool? allowReminders,
    int? reminderLeadMinutes,
  }) {
    return NotificationPreferences(
      allowReminders: allowReminders ?? this.allowReminders,
      reminderLeadMinutes: reminderLeadMinutes ?? this.reminderLeadMinutes,
    );
  }

  static const List<int> allowedLeadMinutes = [5, 15, 30, 60, 120];
}
