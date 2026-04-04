// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_view_page.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(serviceDetails)
final serviceDetailsProvider = ServiceDetailsFamily._();

final class ServiceDetailsProvider
    extends
        $FunctionalProvider<
          AsyncValue<ServiceDetailsData>,
          ServiceDetailsData,
          FutureOr<ServiceDetailsData>
        >
    with
        $FutureModifier<ServiceDetailsData>,
        $FutureProvider<ServiceDetailsData> {
  ServiceDetailsProvider._({
    required ServiceDetailsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'serviceDetailsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$serviceDetailsHash();

  @override
  String toString() {
    return r'serviceDetailsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ServiceDetailsData> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ServiceDetailsData> create(Ref ref) {
    final argument = this.argument as String;
    return serviceDetails(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ServiceDetailsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$serviceDetailsHash() => r'd1198fe04ffda4b8ac03be1b79b3f052f068010a';

final class ServiceDetailsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ServiceDetailsData>, String> {
  ServiceDetailsFamily._()
    : super(
        retry: null,
        name: r'serviceDetailsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ServiceDetailsProvider call(String serviceId) =>
      ServiceDetailsProvider._(argument: serviceId, from: this);

  @override
  String toString() => r'serviceDetailsProvider';
}
