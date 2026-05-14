import 'package:africa_beuty/core/widgets/skeleton.dart';
import 'package:africa_beuty/feature/profile/model/customer_profile.dart';
import 'package:africa_beuty/feature/profile/view_model/customer_profile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ViewCustomerProfilePage extends ConsumerWidget {
  final String userId;

  const ViewCustomerProfilePage({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userProfileViewModelProvider(userId));

    return Scaffold(
      body: state.when(
        loading: () => const _PublicCustomerSkeleton(),
        error: (error, _) => CustomScrollView(
          slivers: [
            const SliverAppBar(pinned: true, title: Text('Customer')),
            SliverFillRemaining(
              child: Center(child: Text(error.toString())),
            ),
          ],
        ),
        data: (profile) => _PublicCustomerContent(profile: profile),
      ),
    );
  }
}

class _PublicCustomerContent extends StatelessWidget {
  final CustomerProfileModel profile;

  const _PublicCustomerContent({required this.profile});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final location = [
      profile.city,
      profile.country,
    ].where((item) => item != null && item.isNotEmpty).join(', ');

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 310,
          title: Text(profile.username),
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    scheme.primary,
                    scheme.secondary,
                    scheme.tertiaryContainer,
                  ],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 64, 20, 18),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _CustomerAvatar(url: profile.profilePicture, size: 92),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  profile.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '@${profile.username}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          _HeroStat(
                            value: '${profile.stats.followingCount}',
                            label: 'Following',
                          ),
                          const SizedBox(width: 18),
                          _HeroStat(
                            value: '${profile.stats.bookingsCount}',
                            label: 'Visits',
                          ),
                          const SizedBox(width: 18),
                          _HeroStat(
                            value: '${profile.stats.reviewsCount}',
                            label: 'Reviews',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                if (profile.bio != null && profile.bio!.isNotEmpty)
                  _ProfilePanel(
                    title: 'About',
                    child: Text(profile.bio!),
                  ),
                if (profile.bio != null && profile.bio!.isNotEmpty)
                  const SizedBox(height: 14),
                _ProfilePanel(
                  title: 'Customer Snapshot',
                  child: Column(
                    children: [
                      if (location.isNotEmpty)
                        _InfoRow(
                          icon: Icons.location_on_outlined,
                          title: 'Location',
                          subtitle: location,
                        ),
                      if (profile.gender != null && profile.gender!.isNotEmpty)
                        _InfoRow(
                          icon: Icons.person_outline_rounded,
                          title: 'Profile',
                          subtitle: _capitalize(profile.gender!),
                        ),
                      _InfoRow(
                        icon: Icons.privacy_tip_outlined,
                        title: 'Privacy',
                        subtitle:
                            'Only public customer profile details are visible here.',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                _ProfilePanel(
                  title: 'Style DNA',
                  subtitle: 'Preference signals that help salons understand customer taste.',
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      for (final service in profile.preferredServices)
                        _PreferenceChip(label: service),
                      if (profile.preferredServices.isEmpty) ...[
                        const _PreferenceChip(label: 'Beauty discovery'),
                        const _PreferenceChip(label: 'Salon matching'),
                        const _PreferenceChip(label: 'Fresh styles'),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                _ProfilePanel(
                  title: 'Beauty Pulse',
                  subtitle: 'Profile-level trust signals, not private booking details.',
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _PulseTile(
                              value: '${profile.stats.bookingsCount}',
                              label: 'Visits',
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _PulseTile(
                              value: '${profile.stats.reviewsCount}',
                              label: 'Reviews',
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _PulseTile(
                              value: profile.isSalonOwner ? 'Salon' : 'Member',
                              label: 'Role',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      const _InfoRow(
                        icon: Icons.verified_user_outlined,
                        title: 'Trust boundary',
                        subtitle:
                            'Chats, saved salons, and full booking history remain private.',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _capitalize(String value) =>
      value.isEmpty ? value : '${value[0].toUpperCase()}${value.substring(1)}';
}

class _CustomerAvatar extends StatelessWidget {
  final String? url;
  final double size;

  const _CustomerAvatar({required this.url, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
      ),
      child: ClipOval(
        child: url != null && url!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: url!,
                fit: BoxFit.cover,
                errorWidget: (_, _, _) => const Icon(Icons.person),
              )
            : const ColoredBox(
                color: Colors.white24,
                child: Icon(Icons.person, color: Colors.white, size: 42),
              ),
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  final String value;
  final String label;

  const _HeroStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(color: Colors.white70),
        ),
      ],
    );
  }
}

class _ProfilePanel extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;

  const _ProfilePanel({required this.title, this.subtitle, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.55)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _InfoRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: scheme.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PreferenceChip extends StatelessWidget {
  final String label;

  const _PreferenceChip({required this.label});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _PulseTile extends StatelessWidget {
  final String value;
  final String label;

  const _PulseTile({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        children: [
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: scheme.primary,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}

class _PublicCustomerSkeleton extends StatelessWidget {
  const _PublicCustomerSkeleton();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      slivers: [
        const SliverAppBar(
          pinned: true,
          expandedHeight: 310,
          flexibleSpace: FlexibleSpaceBar(
            background: Skeleton(height: double.infinity),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList.separated(
            itemBuilder: (_, _) => const SkeletonCard(
              width: double.infinity,
              height: 150,
              radius: 18,
            ),
            separatorBuilder: (_, _) => const SizedBox(height: 14),
            itemCount: 3,
          ),
        ),
      ],
    );
  }
}
