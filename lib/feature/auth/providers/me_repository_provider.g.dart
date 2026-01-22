// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'me_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(getMeDataRepository)
final getMeDataRepositoryProvider = GetMeDataRepositoryProvider._();

final class GetMeDataRepositoryProvider
    extends
        $FunctionalProvider<
          MeRemoteRepository,
          MeRemoteRepository,
          MeRemoteRepository
        >
    with $Provider<MeRemoteRepository> {
  GetMeDataRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getMeDataRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getMeDataRepositoryHash();

  @$internal
  @override
  $ProviderElement<MeRemoteRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MeRemoteRepository create(Ref ref) {
    return getMeDataRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MeRemoteRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MeRemoteRepository>(value),
    );
  }
}

String _$getMeDataRepositoryHash() =>
    r'9d6da4361289a1364546ef8cbda325484dd0fc9a';
