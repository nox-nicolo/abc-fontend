// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_posts.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FeedViewModel)
final feedViewModelProvider = FeedViewModelProvider._();

final class FeedViewModelProvider
    extends $NotifierProvider<FeedViewModel, AsyncValue<List<PostModel>>> {
  FeedViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'feedViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$feedViewModelHash();

  @$internal
  @override
  FeedViewModel create() => FeedViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<PostModel>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<PostModel>>>(value),
    );
  }
}

String _$feedViewModelHash() => r'86c2d940b33d05d5421e212bb81b9e50fcae4ab0';

abstract class _$FeedViewModel extends $Notifier<AsyncValue<List<PostModel>>> {
  AsyncValue<List<PostModel>> build();
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
    element.handleCreate(ref, build);
  }
}
