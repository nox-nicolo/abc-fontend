class ProfileInsightsModel {
  const ProfileInsightsModel({required this.role, this.customer, this.salon});

  final String role;
  final CustomerInsightsModel? customer;
  final SalonInsightsModel? salon;

  factory ProfileInsightsModel.fromMap(Map<String, dynamic> map) {
    return ProfileInsightsModel(
      role: map['role']?.toString() ?? '',
      customer: map['customer'] is Map<String, dynamic>
          ? CustomerInsightsModel.fromMap(
              map['customer'] as Map<String, dynamic>,
            )
          : null,
      salon: map['salon'] is Map<String, dynamic>
          ? SalonInsightsModel.fromMap(map['salon'] as Map<String, dynamic>)
          : null,
    );
  }
}

class CustomerInsightsModel {
  const CustomerInsightsModel({
    required this.savedStylesCount,
    required this.followedSalonsCount,
    required this.recentBookingCategories,
  });

  final int savedStylesCount;
  final int followedSalonsCount;
  final List<BookingCategoryInsightModel> recentBookingCategories;

  factory CustomerInsightsModel.fromMap(Map<String, dynamic> map) {
    return CustomerInsightsModel(
      savedStylesCount: _asInt(map['saved_styles_count']),
      followedSalonsCount: _asInt(map['followed_salons_count']),
      recentBookingCategories:
          (map['recent_booking_categories'] as List<dynamic>? ?? [])
              .whereType<Map<String, dynamic>>()
              .map(BookingCategoryInsightModel.fromMap)
              .toList(),
    );
  }
}

class BookingCategoryInsightModel {
  const BookingCategoryInsightModel({required this.name, required this.count});

  final String name;
  final int count;

  factory BookingCategoryInsightModel.fromMap(Map<String, dynamic> map) {
    return BookingCategoryInsightModel(
      name: map['name']?.toString() ?? '',
      count: _asInt(map['count']),
    );
  }
}

class SalonInsightsModel {
  const SalonInsightsModel({
    required this.profileViews,
    required this.uniqueProfileViewers,
    required this.serviceTaps,
    required this.bookingConversionRate,
    required this.returningCustomers,
    required this.followerGrowth,
  });

  final int profileViews;
  final int uniqueProfileViewers;
  final int serviceTaps;
  final double bookingConversionRate;
  final int returningCustomers;
  final FollowerGrowthInsightModel followerGrowth;

  factory SalonInsightsModel.fromMap(Map<String, dynamic> map) {
    return SalonInsightsModel(
      profileViews: _asInt(map['profile_views']),
      uniqueProfileViewers: _asInt(map['unique_profile_viewers']),
      serviceTaps: _asInt(map['service_taps']),
      bookingConversionRate: _asDouble(map['booking_conversion_rate']),
      returningCustomers: _asInt(map['returning_customers']),
      followerGrowth: FollowerGrowthInsightModel.fromMap(
        map['follower_growth'] as Map<String, dynamic>? ?? const {},
      ),
    );
  }
}

class FollowerGrowthInsightModel {
  const FollowerGrowthInsightModel({
    required this.totalFollowers,
    required this.last30Days,
    required this.previous30Days,
    required this.delta,
  });

  final int totalFollowers;
  final int last30Days;
  final int previous30Days;
  final int delta;

  factory FollowerGrowthInsightModel.fromMap(Map<String, dynamic> map) {
    return FollowerGrowthInsightModel(
      totalFollowers: _asInt(map['total_followers']),
      last30Days: _asInt(map['last_30_days']),
      previous30Days: _asInt(map['previous_30_days']),
      delta: _asInt(map['delta']),
    );
  }
}

int _asInt(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

double _asDouble(Object? value) {
  if (value is double) return value;
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0;
}
