// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stylist.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SalonStylists)
final salonStylistsProvider = SalonStylistsProvider._();

final class SalonStylistsProvider
    extends $AsyncNotifierProvider<SalonStylists, List<SalonStylistModel>> {
  SalonStylistsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'salonStylistsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$salonStylistsHash();

  @$internal
  @override
  SalonStylists create() => SalonStylists();
}

String _$salonStylistsHash() => r'171222b322eadb2ffe01191de3c15faf2dae7172';

abstract class _$SalonStylists extends $AsyncNotifier<List<SalonStylistModel>> {
  FutureOr<List<SalonStylistModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<SalonStylistModel>>,
              List<SalonStylistModel>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<SalonStylistModel>>,
                List<SalonStylistModel>
              >,
              AsyncValue<List<SalonStylistModel>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
