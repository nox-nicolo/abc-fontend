import 'package:africa_beuty/feature/post/view/page/hashtag_result.dart';
import 'package:africa_beuty/feature/profile/view/page/view_profile.dart';
import 'package:africa_beuty/feature/search/model/search.dart';
import 'package:flutter/material.dart';

class SearchResultItem extends StatelessWidget {
  final SearchResult result;

  const SearchResultItem({
    super.key,
    required this.result,
  });

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
        backgroundImage:
            user.avatarUrl != null ? NetworkImage(user.avatarUrl!) : null,
        child: user.avatarUrl == null
            ? const Icon(Icons.person)
            : null,
      ),
      title: Text(user.username),
      subtitle: user.fullName != null ? Text(user.fullName!) : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ViewProfilePage(isServiceProfile: false, userId: user.id),
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
        backgroundImage:
            salon.coverImage != null ? NetworkImage(salon.coverImage!) : null,
        child: salon.coverImage == null
            ? const Icon(Icons.store)
            : null,
      ),
      title: Text(salon.title ?? salon.slogan),
      subtitle: Text(salon.ownerName),
      trailing: salon.isVerified
          ? const Icon(Icons.verified, color: Colors.blue)
          : null,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ViewProfilePage(isServiceProfile: true, userId: salon.id),
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
        backgroundImage:
            service.imageUrl != null ? NetworkImage(service.imageUrl!) : null,
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
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // TODO: navigate to service detail
      },
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
            builder: (_) => HashtagScreen(
              hashtagId: hashtag.id, 
            ),
          ),
        );
      },
    );
  }
}
