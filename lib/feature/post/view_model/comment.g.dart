// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CommentsViewModel)
final commentsViewModelProvider = CommentsViewModelFamily._();

final class CommentsViewModelProvider
    extends $NotifierProvider<CommentsViewModel, CommentsState> {
  CommentsViewModelProvider._({
    required CommentsViewModelFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'commentsViewModelProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$commentsViewModelHash();

  @override
  String toString() {
    return r'commentsViewModelProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  CommentsViewModel create() => CommentsViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CommentsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CommentsState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CommentsViewModelProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$commentsViewModelHash() => r'e6fd36cde2ed676fe2bc9613bce841a5955f467b';

final class CommentsViewModelFamily extends $Family
    with
        $ClassFamilyOverride<
          CommentsViewModel,
          CommentsState,
          CommentsState,
          CommentsState,
          String
        > {
  CommentsViewModelFamily._()
    : super(
        retry: null,
        name: r'commentsViewModelProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CommentsViewModelProvider call(String postId) =>
      CommentsViewModelProvider._(argument: postId, from: this);

  @override
  String toString() => r'commentsViewModelProvider';
}

abstract class _$CommentsViewModel extends $Notifier<CommentsState> {
  late final _$args = ref.$arg as String;
  String get postId => _$args;

  CommentsState build(String postId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<CommentsState, CommentsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CommentsState, CommentsState>,
              CommentsState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
