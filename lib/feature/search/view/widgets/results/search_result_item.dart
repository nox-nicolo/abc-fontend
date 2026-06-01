import 'package:africa_beuty/core/failure/failure.dart';
import 'package:africa_beuty/feature/booking/provider/booking_draft.dart';
import 'package:africa_beuty/feature/booking/view/widgets/start_booking/select_time.dart';
import 'package:africa_beuty/feature/post/view/page/hashtag_result.dart';
import 'package:africa_beuty/feature/profile/view/page/view_profile.dart';
import 'package:africa_beuty/feature/profile/view/widget/view_salon_profile.dart';
import 'package:africa_beuty/feature/saved/provider/saved_provider.dart';
import 'package:africa_beuty/feature/search/model/search.dart';
import 'package:africa_beuty/feature/service/view/page/service_view_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

class SearchResultItem extends StatelessWidget {
  final SearchResult result;
  final VoidCallback? onSelected;

  const SearchResultItem({super.key, required this.result, this.onSelected});

  @override
  Widget build(BuildContext context) {
    return switch (result) {
      SearchUserResult r => _UserTile(user: r, onSelected: onSelected),
      SearchSalonResult r => _SalonTile(salon: r, onSelected: onSelected),
      SearchServiceResult r => _ServiceTile(service: r, onSelected: onSelected),
      SearchHashtagResult r => _HashtagTile(hashtag: r, onSelected: onSelected),
    };
  }
}

////////////////////////////////////////////////////////////
/// USER TILE
////////////////////////////////////////////////////////////

class _UserTile extends StatelessWidget {
  final SearchUserResult user;
  final VoidCallback? onSelected;

  const _UserTile({required this.user, this.onSelected});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: user.avatarUrl != null
            ? NetworkImage(user.avatarUrl!)
            : null,
        child: user.avatarUrl == null ? const Icon(Icons.person) : null,
      ),
      title: Text(user.username),
      subtitle: user.fullName != null ? Text(user.fullName!) : null,
      // trailing: const Icon(Icons.chevron_right),  // Display later base on the user profile
      onTap: () {
        onSelected?.call();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) =>
                ViewProfilePage(isServiceProfile: false, userId: user.id),
          ),
        );
      },
    );
  }
}

////////////////////////////////////////////////////////////
/// SALON TILE
////////////////////////////////////////////////////////////

class _SalonTile extends StatelessWidget {
  final SearchSalonResult salon;
  final VoidCallback? onSelected;

  const _SalonTile({required this.salon, this.onSelected});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: salon.coverImage != null
            ? NetworkImage(salon.coverImage!)
            : null,
        child: salon.coverImage == null ? const Icon(Icons.store) : null,
      ),
      title: Text(salon.title ?? salon.slogan),
      subtitle: Text(salon.ownerName),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (salon.isVerified) const Icon(Icons.verified, color: Colors.blue),
          _SaveButton(
            id: salon.id,
            initialSaved: salon.isSaved,
            onToggle: (ref, id) =>
                ref.read(savedRepositoryProvider).toggleSalon(id),
          ),
        ],
      ),
      onTap: () {
        onSelected?.call();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ViewServiceProfilePage(salonId: salon.id),
          ),
        );
      },
    );
  }
}

////////////////////////////////////////////////////////////
/// SERVICE TILE
////////////////////////////////////////////////////////////

class _ServiceTile extends ConsumerWidget {
  final SearchServiceResult service;
  final VoidCallback? onSelected;

  const _ServiceTile({required this.service, this.onSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final priceText = _priceText(service);
    final offerId = service.salonServicePriceId;

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: service.imageUrl != null
            ? NetworkImage(service.imageUrl!)
            : null,
        child: service.imageUrl == null
            ? const Icon(Icons.design_services)
            : null,
      ),
      title: Text(service.serviceName),
      subtitle: Text(
        [
          if (service.salonName != null) 'At ${service.salonName}',
          service.parentServiceName,
          priceText,
          if (service.durationMinutes != null) '${service.durationMinutes} min',
        ].where((e) => e != null).join(' • '),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SaveButton(
            id: service.salonServicePriceId ?? service.id,
            initialSaved: service.isSaved,
            onToggle: (ref, id) =>
                ref.read(savedRepositoryProvider).toggleService(id),
          ),
          const Icon(Icons.chevron_right),
        ],
      ),
      onTap: () {
        onSelected?.call();
        if (offerId != null && offerId.isNotEmpty) {
          ref.read(bookingDraftProvider.notifier)
            ..reset()
            ..selectSalonOffer(
              salonServicePriceId: offerId,
              salonName: service.salonName ?? 'Selected salon',
              serviceName: service.serviceName,
              price: service.priceMin ?? 0,
              currency: service.currency ?? '',
              durationMinutes: service.durationMinutes ?? 60,
            );
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const PickDateTimePage()));
          return;
        }

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ServiceDetailsPage(serviceId: service.id),
          ),
        );
      },
    );
  }

  String? _priceText(SearchServiceResult service) {
    final currency = service.currency?.trim();
    final currencyPrefix = currency == null || currency.isEmpty
        ? ''
        : '$currency ';
    final min = service.priceMin;
    final max = service.priceMax;
    if (min == null && max == null) return null;
    if (min != null && max != null && max != min) {
      return '$currencyPrefix${min.toStringAsFixed(0)}-${max.toStringAsFixed(0)}';
    }
    final price = min ?? max;
    return 'From $currencyPrefix${price!.toStringAsFixed(0)}';
  }
}

class _SaveButton extends ConsumerStatefulWidget {
  const _SaveButton({
    required this.id,
    required this.onToggle,
    this.initialSaved = false,
  });

  final String id;
  final bool initialSaved;
  final Future<Either<AppFailure, bool>> Function(WidgetRef ref, String id)
  onToggle;

  @override
  ConsumerState<_SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends ConsumerState<_SaveButton> {
  late bool _saved;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _saved = widget.initialSaved;
  }

  @override
  void didUpdateWidget(covariant _SaveButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.id != widget.id ||
        oldWidget.initialSaved != widget.initialSaved) {
      _saved = widget.initialSaved;
    }
  }

  Future<void> _toggle() async {
    if (_loading) return;

    final previous = _saved;
    setState(() {
      _loading = true;
      _saved = !_saved;
    });

    final result = await widget.onToggle(ref, widget.id);
    if (!mounted) return;

    result.fold(
      (failure) {
        setState(() {
          _saved = previous;
          _loading = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(failure.message)));
      },
      (saved) {
        setState(() {
          _saved = saved;
          _loading = false;
        });
        ref.invalidate(savedCollectionProvider);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: _saved ? 'Unsave' : 'Save',
      onPressed: _loading ? null : _toggle,
      icon: Icon(_saved ? Icons.bookmark : Icons.bookmark_border),
    );
  }
}

////////////////////////////////////////////////////////////
/// HASHTAG TILE
////////////////////////////////////////////////////////////

class _HashtagTile extends StatelessWidget {
  final SearchHashtagResult hashtag;
  final VoidCallback? onSelected;

  const _HashtagTile({required this.hashtag, this.onSelected});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.tag),
      title: Text('#${hashtag.tag}'),
      subtitle: Text('${hashtag.postCount} posts'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        onSelected?.call();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => HashtagScreen(hashtagId: hashtag.id),
          ),
        );
      },
    );
  }
}
