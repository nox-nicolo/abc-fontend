class ProfileTrustModel {
  const ProfileTrustModel({
    required this.role,
    required this.verifiedEmail,
    required this.verifiedPhone,
    required this.verifiedSalonOwner,
    required this.businessDocumentUploaded,
    required this.profileReviewStatus,
    required this.safetyBadge,
    required this.indicators,
  });

  final String role;
  final bool verifiedEmail;
  final bool verifiedPhone;
  final bool verifiedSalonOwner;
  final bool businessDocumentUploaded;
  final String profileReviewStatus;
  final bool safetyBadge;
  final List<TrustIndicatorModel> indicators;

  factory ProfileTrustModel.fromMap(Map<String, dynamic> map) {
    return ProfileTrustModel(
      role: map['role']?.toString() ?? '',
      verifiedEmail: map['verified_email'] as bool? ?? false,
      verifiedPhone: map['verified_phone'] as bool? ?? false,
      verifiedSalonOwner: map['verified_salon_owner'] as bool? ?? false,
      businessDocumentUploaded:
          map['business_document_uploaded'] as bool? ?? false,
      profileReviewStatus:
          map['profile_review_status']?.toString() ?? 'not_submitted',
      safetyBadge: map['safety_badge'] as bool? ?? false,
      indicators: (map['indicators'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(TrustIndicatorModel.fromMap)
          .toList(),
    );
  }
}

class TrustIndicatorModel {
  const TrustIndicatorModel({
    required this.key,
    required this.label,
    required this.isMet,
    required this.status,
    required this.detail,
  });

  final String key;
  final String label;
  final bool isMet;
  final String status;
  final String detail;

  factory TrustIndicatorModel.fromMap(Map<String, dynamic> map) {
    return TrustIndicatorModel(
      key: map['key']?.toString() ?? '',
      label: map['label']?.toString() ?? '',
      isMet: map['is_met'] as bool? ?? false,
      status: map['status']?.toString() ?? '',
      detail: map['detail']?.toString() ?? '',
    );
  }
}
