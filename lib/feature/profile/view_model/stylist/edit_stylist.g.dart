// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_stylist.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(EditStylistViewModel)
final editStylistViewModelProvider = EditStylistViewModelProvider._();

final class EditStylistViewModelProvider
    extends
        $NotifierProvider<
          EditStylistViewModel,
          AsyncValue<SalonStylistDetail?>
        > {
  EditStylistViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'editStylistViewModelProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$editStylistViewModelHash();

  @$internal
  @override
  EditStylistViewModel create() => EditStylistViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<SalonStylistDetail?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<SalonStylistDetail?>>(
        value,
      ),
    );
  }
}

String _$editStylistViewModelHash() =>
    r'76f04d0765e5b5dd2bb7286b3f3a5dad633667df';

abstract class _$EditStylistViewModel
    extends $Notifier<AsyncValue<SalonStylistDetail?>> {
  AsyncValue<SalonStylistDetail?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<SalonStylistDetail?>,
              AsyncValue<SalonStylistDetail?>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<SalonStylistDetail?>,
                AsyncValue<SalonStylistDetail?>
              >,
              AsyncValue<SalonStylistDetail?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
