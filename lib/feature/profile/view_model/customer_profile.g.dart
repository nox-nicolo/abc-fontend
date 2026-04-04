// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_profile.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MyCustomerProfileViewModel)
final myCustomerProfileViewModelProvider =
    MyCustomerProfileViewModelProvider._();

final class MyCustomerProfileViewModelProvider
    extends
        $NotifierProvider<
          MyCustomerProfileViewModel,
          AsyncValue<CustomerProfileModel>
        > {
  MyCustomerProfileViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myCustomerProfileViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myCustomerProfileViewModelHash();

  @$internal
  @override
  MyCustomerProfileViewModel create() => MyCustomerProfileViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<CustomerProfileModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<CustomerProfileModel>>(
        value,
      ),
    );
  }
}

String _$myCustomerProfileViewModelHash() =>
    r'7dce684e7e07a6d67821044825e1f6dbcb6cb959';

abstract class _$MyCustomerProfileViewModel
    extends $Notifier<AsyncValue<CustomerProfileModel>> {
  AsyncValue<CustomerProfileModel> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<CustomerProfileModel>,
              AsyncValue<CustomerProfileModel>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<CustomerProfileModel>,
                AsyncValue<CustomerProfileModel>
              >,
              AsyncValue<CustomerProfileModel>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(UserProfileViewModel)
final userProfileViewModelProvider = UserProfileViewModelFamily._();

final class UserProfileViewModelProvider
    extends
        $NotifierProvider<
          UserProfileViewModel,
          AsyncValue<CustomerProfileModel>
        > {
  UserProfileViewModelProvider._({
    required UserProfileViewModelFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'userProfileViewModelProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$userProfileViewModelHash();

  @override
  String toString() {
    return r'userProfileViewModelProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  UserProfileViewModel create() => UserProfileViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<CustomerProfileModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<CustomerProfileModel>>(
        value,
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is UserProfileViewModelProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userProfileViewModelHash() =>
    r'7f5e2ed0f86c9b74303ea6a642a2e5088fe97718';

final class UserProfileViewModelFamily extends $Family
    with
        $ClassFamilyOverride<
          UserProfileViewModel,
          AsyncValue<CustomerProfileModel>,
          AsyncValue<CustomerProfileModel>,
          AsyncValue<CustomerProfileModel>,
          String
        > {
  UserProfileViewModelFamily._()
    : super(
        retry: null,
        name: r'userProfileViewModelProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UserProfileViewModelProvider call(String userId) =>
      UserProfileViewModelProvider._(argument: userId, from: this);

  @override
  String toString() => r'userProfileViewModelProvider';
}

abstract class _$UserProfileViewModel
    extends $Notifier<AsyncValue<CustomerProfileModel>> {
  late final _$args = ref.$arg as String;
  String get userId => _$args;

  AsyncValue<CustomerProfileModel> build(String userId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<CustomerProfileModel>,
              AsyncValue<CustomerProfileModel>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<CustomerProfileModel>,
                AsyncValue<CustomerProfileModel>
              >,
              AsyncValue<CustomerProfileModel>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
