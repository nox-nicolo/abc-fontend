import 'package:africa_beuty/feature/ads/model/ad_campaign.dart';
import 'package:africa_beuty/feature/ads/repository/ad_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const adPlacementHomeFeed = 'home_feed';
const adPlacementSearch = 'search';
const adPlacementPostView = 'post_view';

final adRepositoryProvider = Provider<AdRepository>((ref) => AdRepository());

final adsByPlacementProvider = FutureProvider.autoDispose
    .family<List<AdCampaign>, String>((ref, placement) async {
      final repo = ref.read(adRepositoryProvider);
      final result = await repo.fetchAds(placement: placement, limit: 3);
      return result.fold((_) => const [], (ads) => ads);
    });
