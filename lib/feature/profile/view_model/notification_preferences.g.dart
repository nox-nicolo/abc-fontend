// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_preferences.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(NotificationPreferencesViewModel)
final notificationPreferencesViewModelProvider =
    NotificationPreferencesViewModelProvider._();

final class NotificationPreferencesViewModelProvider
    extends
        $NotifierProvider<
          NotificationPreferencesViewModel,
          AsyncValue<NotificationPreferences>
        > {
  NotificationPreferencesViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationPreferencesViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationPreferencesViewModelHash();

  @$internal
  @override
  NotificationPreferencesViewModel create() =>
      NotificationPreferencesViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<NotificationPreferences> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<NotificationPreferences>>(
        value,
      ),
    );
  }
}

String _$notificationPreferencesViewModelHash() =>
    r'9ca527f93ec41da246d728b571ddd55dc18f5c43';

abstract class _$NotificationPreferencesViewModel
    extends $Notifier<AsyncValue<NotificationPreferences>> {
  AsyncValue<NotificationPreferences> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<NotificationPreferences>,
              AsyncValue<NotificationPreferences>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<NotificationPreferences>,
                AsyncValue<NotificationPreferences>
              >,
              AsyncValue<NotificationPreferences>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
