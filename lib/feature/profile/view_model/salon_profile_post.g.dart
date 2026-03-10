// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'salon_profile_post.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ProfilePostsViewModel)
final profilePostsViewModelProvider = ProfilePostsViewModelFamily._();

final class ProfilePostsViewModelProvider
    extends
        $NotifierProvider<ProfilePostsViewModel, AsyncValue<List<PostModel>>> {
  ProfilePostsViewModelProvider._({
    required ProfilePostsViewModelFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'profilePostsViewModelProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$profilePostsViewModelHash();

  @override
  String toString() {
    return r'profilePostsViewModelProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ProfilePostsViewModel create() => ProfilePostsViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<PostModel>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<PostModel>>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ProfilePostsViewModelProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$profilePostsViewModelHash() =>
    r'dd059a9aa73174e2862ab22eabe6ce7a5dff3768';

final class ProfilePostsViewModelFamily extends $Family
    with
        $ClassFamilyOverride<
          ProfilePostsViewModel,
          AsyncValue<List<PostModel>>,
          AsyncValue<List<PostModel>>,
          AsyncValue<List<PostModel>>,
          String
        > {
  ProfilePostsViewModelFamily._()
    : super(
        retry: null,
        name: r'profilePostsViewModelProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ProfilePostsViewModelProvider call(String userId) =>
      ProfilePostsViewModelProvider._(argument: userId, from: this);

  @override
  String toString() => r'profilePostsViewModelProvider';
}

abstract class _$ProfilePostsViewModel
    extends $Notifier<AsyncValue<List<PostModel>>> {
  late final _$args = ref.$arg as String;
  String get userId => _$args;

  AsyncValue<List<PostModel>> build(String userId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<List<PostModel>>, AsyncValue<List<PostModel>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<PostModel>>,
                AsyncValue<List<PostModel>>
              >,
              AsyncValue<List<PostModel>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
