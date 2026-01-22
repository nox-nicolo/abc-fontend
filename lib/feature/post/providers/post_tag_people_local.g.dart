// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_tag_people_local.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(tagPeopleLocalRepositoryProvider)
final tagPeopleLocalRepositoryProviderProvider =
    TagPeopleLocalRepositoryProviderProvider._();

final class TagPeopleLocalRepositoryProviderProvider
    extends
        $FunctionalProvider<
          TagPeopleLocalRepository,
          TagPeopleLocalRepository,
          TagPeopleLocalRepository
        >
    with $Provider<TagPeopleLocalRepository> {
  TagPeopleLocalRepositoryProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tagPeopleLocalRepositoryProviderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tagPeopleLocalRepositoryProviderHash();

  @$internal
  @override
  $ProviderElement<TagPeopleLocalRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TagPeopleLocalRepository create(Ref ref) {
    return tagPeopleLocalRepositoryProvider(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TagPeopleLocalRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TagPeopleLocalRepository>(value),
    );
  }
}

String _$tagPeopleLocalRepositoryProviderHash() =>
    r'4d6f608d5035e532b0c0dc6b6537e9240a66a479';
