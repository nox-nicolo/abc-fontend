// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hashtags.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(HashtagViewModel)
final hashtagViewModelProvider = HashtagViewModelFamily._();

final class HashtagViewModelProvider
    extends $NotifierProvider<HashtagViewModel, AsyncValue<HashtagGridModel>> {
  HashtagViewModelProvider._({
    required HashtagViewModelFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'hashtagViewModelProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$hashtagViewModelHash();

  @override
  String toString() {
    return r'hashtagViewModelProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  HashtagViewModel create() => HashtagViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<HashtagGridModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<HashtagGridModel>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is HashtagViewModelProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$hashtagViewModelHash() => r'a41d1f70610049c7997a8d1cce25b0d4b1cc1c71';

final class HashtagViewModelFamily extends $Family
    with
        $ClassFamilyOverride<
          HashtagViewModel,
          AsyncValue<HashtagGridModel>,
          AsyncValue<HashtagGridModel>,
          AsyncValue<HashtagGridModel>,
          String
        > {
  HashtagViewModelFamily._()
    : super(
        retry: null,
        name: r'hashtagViewModelProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  HashtagViewModelProvider call(String hashtagId) =>
      HashtagViewModelProvider._(argument: hashtagId, from: this);

  @override
  String toString() => r'hashtagViewModelProvider';
}

abstract class _$HashtagViewModel
    extends $Notifier<AsyncValue<HashtagGridModel>> {
  late final _$args = ref.$arg as String;
  String get hashtagId => _$args;

  AsyncValue<HashtagGridModel> build(String hashtagId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<HashtagGridModel>, AsyncValue<HashtagGridModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<HashtagGridModel>,
                AsyncValue<HashtagGridModel>
              >,
              AsyncValue<HashtagGridModel>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
