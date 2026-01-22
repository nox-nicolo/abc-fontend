// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_tag_people.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(tagPeopleRemoteRepoProvider)
final tagPeopleRemoteRepoProviderProvider =
    TagPeopleRemoteRepoProviderProvider._();

final class TagPeopleRemoteRepoProviderProvider
    extends
        $FunctionalProvider<
          TagPeopleRepositoryImpl,
          TagPeopleRepositoryImpl,
          TagPeopleRepositoryImpl
        >
    with $Provider<TagPeopleRepositoryImpl> {
  TagPeopleRemoteRepoProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tagPeopleRemoteRepoProviderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tagPeopleRemoteRepoProviderHash();

  @$internal
  @override
  $ProviderElement<TagPeopleRepositoryImpl> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TagPeopleRepositoryImpl create(Ref ref) {
    return tagPeopleRemoteRepoProvider(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TagPeopleRepositoryImpl value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TagPeopleRepositoryImpl>(value),
    );
  }
}

String _$tagPeopleRemoteRepoProviderHash() =>
    r'c4c6f21837a0e72341cac3b31278928ab6d4a8ac';
