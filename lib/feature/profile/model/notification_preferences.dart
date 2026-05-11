class NotificationPreferences {
  final bool allowLikes;
  final bool allowComments;
  final bool allowBookings;
  final bool allowPromotions;
  final bool allowReminders;
  final int reminderLeadMinutes;

  const NotificationPreferences({
    required this.allowLikes,
    required this.allowComments,
    required this.allowBookings,
    required this.allowPromotions,
    required this.allowReminders,
    required this.reminderLeadMinutes,
  });

  factory NotificationPreferences.fromMap(Map<String, dynamic> map) {
    return NotificationPreferences(
      allowLikes: map['allow_likes'] as bool? ?? true,
      allowComments: map['allow_comments'] as bool? ?? true,
      allowBookings: map['allow_bookings'] as bool? ?? true,
      allowPromotions: map['allow_promotions'] as bool? ?? true,
      allowReminders: map['allow_reminders'] as bool? ?? true,
      reminderLeadMinutes: map['reminder_lead_minutes'] as int? ?? 30,
    );
  }

  NotificationPreferences copyWith({
    bool? allowLikes,
    bool? allowComments,
    bool? allowBookings,
    bool? allowPromotions,
    bool? allowReminders,
    int? reminderLeadMinutes,
  }) {
    return NotificationPreferences(
      allowLikes: allowLikes ?? this.allowLikes,
      allowComments: allowComments ?? this.allowComments,
      allowBookings: allowBookings ?? this.allowBookings,
      allowPromotions: allowPromotions ?? this.allowPromotions,
      allowReminders: allowReminders ?? this.allowReminders,
      reminderLeadMinutes: reminderLeadMinutes ?? this.reminderLeadMinutes,
    );
  }

  static const List<int> allowedLeadMinutes = [5, 15, 30, 60, 120];
}
