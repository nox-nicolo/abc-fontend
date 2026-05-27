import 'package:africa_beuty/feature/search/model/discover.dart';
import 'package:africa_beuty/feature/search/repository/discover.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

final _discoverRepo = DiscoverRepository();

enum LocationDiscoveryAction { openLocationSettings, openAppSettings }

class LocationDiscoveryException implements Exception {
  final String message;
  final LocationDiscoveryAction action;

  const LocationDiscoveryException(this.message, this.action);

  @override
  String toString() => message;
}

// ── Location helper ───────────────────────────────────────────────────────────

/// Returns the device's current position, handling permission flow.
/// Throws a descriptive string on denial/unavailability.
Future<Position> _getPosition() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw const LocationDiscoveryException(
      'Turn on location services to find salons near you.',
      LocationDiscoveryAction.openLocationSettings,
    );
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw const LocationDiscoveryException(
        'Allow location access to find nearby salons.',
        LocationDiscoveryAction.openAppSettings,
      );
    }
  }
  if (permission == LocationPermission.deniedForever) {
    throw const LocationDiscoveryException(
      'Location permission is off. Enable it in settings to discover salons nearby.',
      LocationDiscoveryAction.openAppSettings,
    );
  }

  return Geolocator.getCurrentPosition(
    locationSettings: const LocationSettings(accuracy: LocationAccuracy.low),
  );
}

// ── Providers ─────────────────────────────────────────────────────────────────

final nearbySalonsProvider = FutureProvider.autoDispose<List<NearbySalonItem>>((
  ref,
) async {
  final position = await _getPosition();
  final result = await _discoverRepo.getNearby(
    lat: position.latitude,
    lng: position.longitude,
  );
  return result.fold((l) => throw l.message, (r) => r);
});

/// Nearby salons centred on a known coordinate (e.g. a salon being viewed).
/// Does NOT request device GPS.
typedef _Coords = ({double lat, double lng});

final nearbySalonsAtProvider = FutureProvider.autoDispose
    .family<List<NearbySalonItem>, _Coords>((ref, coords) async {
      final result = await _discoverRepo.getNearby(
        lat: coords.lat,
        lng: coords.lng,
        limit: 20,
      );
      return result.fold((l) => throw l.message, (r) => r);
    });

final topSalonsProvider = FutureProvider.autoDispose<List<TopSalonItem>>((
  ref,
) async {
  final result = await _discoverRepo.getTopSalons();
  return result.fold((l) => throw l.message, (r) => r);
});

final topSalonsAllProvider = FutureProvider.autoDispose<List<TopSalonItem>>((
  ref,
) async {
  final result = await _discoverRepo.getTopSalons(limit: 50);
  return result.fold((l) => throw l.message, (r) => r);
});

final trendingStylesProvider =
    FutureProvider.autoDispose<List<TrendingStyleItem>>((ref) async {
      final result = await _discoverRepo.getTrending();
      return result.fold((l) => throw l.message, (r) => r);
    });

final trendingStylesAllProvider =
    FutureProvider.autoDispose<List<TrendingStyleItem>>((ref) async {
      final result = await _discoverRepo.getTrending(limit: 50);
      return result.fold((l) => throw l.message, (r) => r);
    });

final nearbySalonsAllProvider =
    FutureProvider.autoDispose<List<NearbySalonItem>>((ref) async {
      final position = await _getPosition();
      final result = await _discoverRepo.getNearby(
        lat: position.latitude,
        lng: position.longitude,
        limit: 50,
      );
      return result.fold((l) => throw l.message, (r) => r);
    });
