// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_tag_people.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TagPeopleViewModel)
final tagPeopleViewModelProvider = TagPeopleViewModelProvider._();

final class TagPeopleViewModelProvider
    extends $NotifierProvider<TagPeopleViewModel, AsyncValue<TagPeopleState>> {
  TagPeopleViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tagPeopleViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tagPeopleViewModelHash();

  @$internal
  @override
  TagPeopleViewModel create() => TagPeopleViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<TagPeopleState> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<TagPeopleState>>(value),
    );
  }
}

String _$tagPeopleViewModelHash() =>
    r'635d93312a808afdf5b2288a9ac5f97f38280135';

abstract class _$TagPeopleViewModel
    extends $Notifier<AsyncValue<TagPeopleState>> {
  AsyncValue<TagPeopleState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<TagPeopleState>, AsyncValue<TagPeopleState>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<TagPeopleState>,
                AsyncValue<TagPeopleState>
              >,
              AsyncValue<TagPeopleState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
