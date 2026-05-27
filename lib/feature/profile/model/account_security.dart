class AccountDevice {
  const AccountDevice({
    required this.id,
    required this.deviceId,
    required this.platform,
    required this.pushProvider,
    required this.isActive,
    required this.lastSeenAt,
  });

  final String id;
  final String deviceId;
  final String platform;
  final String pushProvider;
  final bool isActive;
  final DateTime? lastSeenAt;

  factory AccountDevice.fromMap(Map<String, dynamic> map) {
    return AccountDevice(
      id: map['id']?.toString() ?? '',
      deviceId: map['device_id']?.toString() ?? '',
      platform: map['platform']?.toString() ?? 'unknown',
      pushProvider: map['push_provider']?.toString() ?? '',
      isActive: map['is_active'] as bool? ?? false,
      lastSeenAt: DateTime.tryParse(map['last_seen_at']?.toString() ?? ''),
    );
  }
}

class MutedAccount {
  const MutedAccount({
    required this.id,
    required this.targetType,
    required this.targetId,
    required this.createdAt,
    this.reason,
  });

  final String id;
  final String targetType;
  final String targetId;
  final DateTime? createdAt;
  final String? reason;

  factory MutedAccount.fromMap(Map<String, dynamic> map) {
    return MutedAccount(
      id: map['id']?.toString() ?? '',
      targetType: map['target_type']?.toString() ?? '',
      targetId: map['target_id']?.toString() ?? '',
      createdAt: DateTime.tryParse(map['created_at']?.toString() ?? ''),
      reason: map['reason']?.toString(),
    );
  }
}

class LoginActivity {
  const LoginActivity({
    required this.title,
    required this.subtitle,
    required this.createdAt,
    required this.isCurrent,
  });

  final String title;
  final String subtitle;
  final DateTime createdAt;
  final bool isCurrent;
}
