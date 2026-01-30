

import 'package:africa_beuty/feature/profile/model/salon_view_followers.dart';

class SalonFollowersState {
  final List<SalonFollowerItemModel> items;
  final int count;
  final String? nextCursor;
  final bool isLoading;
  final bool isLoadingMore;

  const SalonFollowersState({
    required this.items,
    required this.count,
    required this.nextCursor,
    required this.isLoading,
    required this.isLoadingMore,
  });

  factory SalonFollowersState.initial() {
    return const SalonFollowersState(
      items: [],
      count: 0,
      nextCursor: null,
      isLoading: true,
      isLoadingMore: false,
    );
  }

  SalonFollowersState copyWith({
    List<SalonFollowerItemModel>? items,
    int? count,
    String? nextCursor,
    bool? isLoading,
    bool? isLoadingMore,
  }) {
    return SalonFollowersState(
      items: items ?? this.items,
      count: count ?? this.count,
      nextCursor: nextCursor ?? this.nextCursor,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}
