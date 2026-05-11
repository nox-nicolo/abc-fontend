import 'package:africa_beuty/feature/notifications/model/notification.dart';
import 'package:africa_beuty/feature/notifications/providers/notification.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification.g.dart';

class NotificationsState {
  final List<NotificationModel> items;
  final String? nextCursor;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;

  const NotificationsState({
    this.items = const [],
    this.nextCursor,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
  });

  bool get hasMore => nextCursor != null;

  NotificationsState copyWith({
    List<NotificationModel>? items,
    String? nextCursor,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    bool clearCursor = false,
    bool clearError = false,
  }) {
    return NotificationsState(
      items: items ?? this.items,
      nextCursor: clearCursor ? null : (nextCursor ?? this.nextCursor),
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

@riverpod
class NotificationsViewModel extends _$NotificationsViewModel {
  @override
  NotificationsState build() {
    Future.microtask(load);
    return const NotificationsState(isLoading: true);
  }

  Future<void> load() async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
      items: const [],
      clearCursor: true,
    );

    final res = await ref.read(notificationRepositoryProvider).list();

    if (!ref.mounted) return;

    state = switch (res) {
      Left(value: final f) => state.copyWith(
        isLoading: false,
        error: f.message,
      ),
      Right(value: final page) => state.copyWith(
        isLoading: false,
        items: page.items,
        nextCursor: page.nextCursor,
      ),
    };
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;
    state = state.copyWith(isLoadingMore: true);

    final res = await ref
        .read(notificationRepositoryProvider)
        .list(cursor: state.nextCursor);

    if (!ref.mounted) return;

    state = switch (res) {
      Left(value: final f) => state.copyWith(
        isLoadingMore: false,
        error: f.message,
      ),
      Right(value: final page) => state.copyWith(
        isLoadingMore: false,
        items: [...state.items, ...page.items],
        nextCursor: page.nextCursor,
      ),
    };
  }

  Future<void> markAllRead() async {
    final snapshot = state.items;
    state = state.copyWith(
      items: snapshot
          .map((n) => n.copyWith(isRead: true, deliveryStatus: 'read'))
          .toList(),
    );

    final res = await ref.read(notificationRepositoryProvider).markAllRead();
    if (!ref.mounted) return;

    res.fold((f) => state = state.copyWith(items: snapshot, error: f.message), (
      _,
    ) {
      ref.invalidate(unreadCountProvider);
    });
  }

  Future<void> markRead(String notificationId) async {
    final idx = state.items.indexWhere((n) => n.id == notificationId);
    if (idx < 0 || state.items[idx].isRead) return;

    final snapshot = state.items;
    final updated = [...snapshot];
    updated[idx] = updated[idx].copyWith(isRead: true, deliveryStatus: 'read');
    state = state.copyWith(items: updated);

    final res = await ref
        .read(notificationRepositoryProvider)
        .markRead(notificationId);
    if (!ref.mounted) return;

    res.fold(
      (f) => state = state.copyWith(items: snapshot, error: f.message),
      (_) => ref.invalidate(unreadCountProvider),
    );
  }
}

@riverpod
Future<int> unreadCount(Ref ref) async {
  final res = await ref.read(notificationRepositoryProvider).unreadCount();
  return res.fold((_) => 0, (n) => n);
}
