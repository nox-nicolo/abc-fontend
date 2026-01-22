// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_hashtags.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(HashtagViewModel)
final hashtagViewModelProvider = HashtagViewModelProvider._();

final class HashtagViewModelProvider
    extends $NotifierProvider<HashtagViewModel, AsyncValue<HashtagState>> {
  HashtagViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hashtagViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hashtagViewModelHash();

  @$internal
  @override
  HashtagViewModel create() => HashtagViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<HashtagState> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<HashtagState>>(value),
    );
  }
}

String _$hashtagViewModelHash() => r'b15722a4242576286fe6e7f213970220cd59b359';

abstract class _$HashtagViewModel extends $Notifier<AsyncValue<HashtagState>> {
  AsyncValue<HashtagState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<HashtagState>, AsyncValue<HashtagState>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<HashtagState>, AsyncValue<HashtagState>>,
              AsyncValue<HashtagState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
