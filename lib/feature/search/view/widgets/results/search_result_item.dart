import 'package:africa_beuty/core/failure/failure.dart';
import 'package:africa_beuty/feature/post/view/page/hashtag_result.dart';
import 'package:africa_beuty/feature/profile/view/page/view_profile.dart';
import 'package:africa_beuty/feature/saved/provider/saved_provider.dart';
import 'package:africa_beuty/feature/search/model/search.dart';
import 'package:africa_beuty/feature/service/view/page/service_view_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

class SearchResultItem extends StatelessWidget {
  final SearchResult result;

  const SearchResultItem({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return switch (result) {
      SearchUserResult r => _UserTile(user: r),
      SearchSalonResult r => _SalonTile(salon: r),
      SearchServiceResult r => _ServiceTile(service: r),
      SearchHashtagResult r => _HashtagTile(hashtag: r),
    };
  }
}

////////////////////////////////////////////////////////////
/// USER TILE
////////////////////////////////////////////////////////////

class _UserTile extends StatelessWidget {
  final SearchUserResult user;

  const _UserTile({required this.user});

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

  const _SalonTile({required this.salon});

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
            onToggle: (ref, id) =>
                ref.read(savedRepositoryProvider).toggleSalon(id),
          ),
        ],
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) =>
                ViewProfilePage(isServiceProfile: true, userId: salon.id),
          ),
        );
      },
    );
  }
}

////////////////////////////////////////////////////////////
/// SERVICE TILE
////////////////////////////////////////////////////////////

class _ServiceTile extends StatelessWidget {
  final SearchServiceResult service;

  const _ServiceTile({required this.service});

  @override
  Widget build(BuildContext context) {
    final priceText = service.priceMin != null
        ? 'From \$${service.priceMin!.toStringAsFixed(0)}'
        : null;

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
          service.parentServiceName,
          priceText,
        ].where((e) => e != null).join(' • '),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SaveButton(
            id: service.id,
            onToggle: (ref, id) =>
                ref.read(savedRepositoryProvider).toggleService(id),
          ),
          const Icon(Icons.chevron_right),
        ],
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ServiceDetailsPage(serviceId: service.id),
          ),
        );
      },
    );
  }
}

class _SaveButton extends ConsumerStatefulWidget {
  const _SaveButton({required this.id, required this.onToggle});

  final String id;
  final Future<Either<AppFailure, bool>> Function(WidgetRef ref, String id)
  onToggle;

  @override
  ConsumerState<_SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends ConsumerState<_SaveButton> {
  bool _saved = false;
  bool _loading = false;

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

  const _HashtagTile({required this.hashtag});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.tag),
      title: Text('#${hashtag.tag}'),
      subtitle: Text('${hashtag.postCount} posts'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => HashtagScreen(hashtagId: hashtag.id),
          ),
        );
      },
    );
  }
}
