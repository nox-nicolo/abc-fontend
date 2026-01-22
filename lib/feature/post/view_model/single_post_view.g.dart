// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'single_post_view.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SinglePostViewModelNotifier)
final singlePostViewModelProvider = SinglePostViewModelNotifierFamily._();

final class SinglePostViewModelNotifierProvider
    extends
        $NotifierProvider<
          SinglePostViewModelNotifier,
          AsyncValue<SinglePostViewModel>
        > {
  SinglePostViewModelNotifierProvider._({
    required SinglePostViewModelNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'singlePostViewModelProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$singlePostViewModelNotifierHash();

  @override
  String toString() {
    return r'singlePostViewModelProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SinglePostViewModelNotifier create() => SinglePostViewModelNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<SinglePostViewModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<SinglePostViewModel>>(
        value,
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SinglePostViewModelNotifierProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$singlePostViewModelNotifierHash() =>
    r'1a0fb68e19b8592d0c1526bf1744e538ed0f0ab5';

final class SinglePostViewModelNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          SinglePostViewModelNotifier,
          AsyncValue<SinglePostViewModel>,
          AsyncValue<SinglePostViewModel>,
          AsyncValue<SinglePostViewModel>,
          String
        > {
  SinglePostViewModelNotifierFamily._()
    : super(
        retry: null,
        name: r'singlePostViewModelProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SinglePostViewModelNotifierProvider call(String postId) =>
      SinglePostViewModelNotifierProvider._(argument: postId, from: this);

  @override
  String toString() => r'singlePostViewModelProvider';
}

abstract class _$SinglePostViewModelNotifier
    extends $Notifier<AsyncValue<SinglePostViewModel>> {
  late final _$args = ref.$arg as String;
  String get postId => _$args;

  AsyncValue<SinglePostViewModel> build(String postId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<SinglePostViewModel>,
              AsyncValue<SinglePostViewModel>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<SinglePostViewModel>,
                AsyncValue<SinglePostViewModel>
              >,
              AsyncValue<SinglePostViewModel>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
