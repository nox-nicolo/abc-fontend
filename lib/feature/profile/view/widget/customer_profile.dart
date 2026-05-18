import 'package:africa_beuty/core/widgets/app_state.dart';
import 'package:africa_beuty/core/widgets/spacing.dart';
import 'package:africa_beuty/feature/booking/view/pages/customer_booking.dart';
import 'package:africa_beuty/feature/chat/view/page/chats_page.dart';
import 'package:africa_beuty/feature/notifications/view/widget/notifications_bell.dart';
import 'package:africa_beuty/feature/profile/model/customer_profile.dart';
import 'package:africa_beuty/feature/profile/view/page/following_page.dart';
import 'package:africa_beuty/feature/profile/view/widget/setting.dart';
import 'package:africa_beuty/feature/profile/view/widget/three_dots.dart';
import 'package:africa_beuty/feature/profile/view_model/customer_profile.dart';
import 'package:africa_beuty/feature/saved/view/page/saved_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:shimmer/shimmer.dart';

class CustomerProfileSliverWidget extends ConsumerStatefulWidget {
  const CustomerProfileSliverWidget({super.key});

  @override
  ConsumerState<CustomerProfileSliverWidget> createState() =>
      _CustomerProfileSliverWidgetState();
}

class _CustomerProfileSliverWidgetState
    extends ConsumerState<CustomerProfileSliverWidget>
    with SingleTickerProviderStateMixin {
  static const kExpandedHeight = kToolbarHeight + 270;

  late ScrollController _scrollController;
  late TabController _tabController;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()..addListener(() => setState(() {}));

    _tabController = TabController(length: 2, vsync: this)
      ..addListener(() {
        if (_tabController.indexIsChanging) {
          setState(() => _selectedTabIndex = _tabController.index);
        }
      });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(myCustomerProfileViewModelProvider);
      if (state.hasError) {
        ref.read(myCustomerProfileViewModelProvider.notifier).refresh();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  bool get _isSliverAppBarExpanded =>
      _scrollController.hasClients &&
      _scrollController.offset > (kExpandedHeight - kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(myCustomerProfileViewModelProvider);

    return profileState.when(
      loading: () => _buildShimmer(),
      error: (e, _) => AppErrorState(
        message: e,
        onRetry: () =>
            ref.read(myCustomerProfileViewModelProvider.notifier).refresh(),
      ),
      data: (profile) => _buildContent(context, profile),
    );
  }

  Widget _buildContent(BuildContext context, CustomerProfileModel profile) {
    final size = MediaQuery.of(context).size;

    return RefreshIndicator(
      onRefresh: () =>
          ref.read(myCustomerProfileViewModelProvider.notifier).refresh(),
      child: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Header ──────────────────────────────────────────────────────
          SliverAppBar(
            automaticallyImplyLeading: false,
            actions: const [NotificationsBell(), SizedBox(width: 6)],
            expandedHeight: size.height * .45,
            collapsedHeight: size.height * .12,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.all(10),
              title: _isSliverAppBarExpanded
                  ? Row(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black,
                                blurRadius: 50,
                                spreadRadius: 2,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.grey,
                            child: ClipOval(
                              child: profile.profilePicture != null
                                  ? CachedNetworkImage(
                                      imageUrl: profile.profilePicture!,
                                      fit: BoxFit.cover,
                                      width: 48,
                                      height: 48,
                                      errorWidget: (ctx, url, err) =>
                                          const Icon(Icons.person),
                                    )
                                  : Image.asset(
                                      'assets/images/dp.jpg',
                                      fit: BoxFit.cover,
                                      width: 48,
                                      height: 48,
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          profile.username,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    )
                  : null,
              background: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [
                            Colors.brown.shade400,
                            Colors.blueGrey.shade500,
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Avatar + name/username
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.white24,
                                child: ClipOval(
                                  child: profile.profilePicture != null
                                      ? CachedNetworkImage(
                                          imageUrl: profile.profilePicture!,
                                          fit: BoxFit.cover,
                                          width: 100,
                                          height: 100,
                                          errorWidget: (ctx, url, err) =>
                                              Image.asset(
                                                'assets/images/dp.jpg',
                                              ),
                                        )
                                      : Image.asset(
                                          'assets/images/dp.jpg',
                                          fit: BoxFit.cover,
                                          width: 100,
                                          height: 100,
                                        ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: size.width * .6,
                                    child: Text(
                                      profile.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            shadows: [
                                              Shadow(
                                                offset: const Offset(0, 1),
                                                blurRadius: 6.0,
                                                color: Colors.black.withValues(
                                                  alpha: 0.6,
                                                ),
                                              ),
                                            ],
                                          ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    width: size.width * .5,
                                    child: Text(
                                      '@${profile.username}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            shadows: [
                                              Shadow(
                                                offset: const Offset(0, 1),
                                                blurRadius: 6.0,
                                                color: Colors.black.withValues(
                                                  alpha: 0.6,
                                                ),
                                              ),
                                            ],
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Stats: Bookings + Reviews only (no Following)
                          Row(
                            children: [
                              _StatChip(
                                value: '${profile.stats.followingCount}',
                                label: 'Following',
                              ),
                              const SizedBox(width: 24),
                              _StatChip(
                                value: '${profile.stats.bookingsCount}',
                                label: 'Bookings',
                              ),
                              const SizedBox(width: 24),
                              _StatChip(
                                value: '${profile.stats.reviewsCount}',
                                label: 'Reviews',
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // Settings + three-dots
                          Row(
                            children: [
                              Material(
                                color: Colors.black26,
                                shape: const CircleBorder(),
                                clipBehavior: Clip.antiAlias,
                                child: const SettingAccount(isCustomer: true),
                              ),
                              const SizedBox(width: 8),
                              Material(
                                color: Colors.black26,
                                shape: const CircleBorder(),
                                clipBehavior: Clip.antiAlias,
                                child: const ThreeDotsOptions(isCustomer: true),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Bio ─────────────────────────────────────────────────────────
          if (profile.bio != null && profile.bio!.isNotEmpty) ...[
            SliverSpaceHeader(title: 'Bio'),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 4,
                ),
                child: Text(
                  profile.bio!,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
            ),
          ],

          // ── Location & Details ───────────────────────────────────────────
          if (profile.city != null ||
              profile.country != null ||
              profile.gender != null) ...[
            SliverSpaceHeader(title: 'Details'),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 4,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (profile.city != null || profile.country != null)
                      _DetailRow(
                        icon: Icons.location_on_outlined,
                        text: [
                          profile.city,
                          profile.country,
                        ].where((s) => s != null && s.isNotEmpty).join(', '),
                      ),
                    if (profile.gender != null &&
                        profile.gender!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      _DetailRow(
                        icon: Icons.person_outline,
                        text: _capitalize(profile.gender!),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],

          SliverSpaceHeader(title: 'Beauty Hub'),
          SliverToBoxAdapter(child: _BeautyHubActions()),

          // ── Sticky tab bar ───────────────────────────────────────────────
          SliverPersistentHeader(
            pinned: true,
            delegate: _StickyTabBarDelegate(
              tabBar: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(icon: Icon(Icons.auto_awesome), text: 'Style DNA'),
                  Tab(icon: Icon(Bootstrap.graph_up), text: 'Beauty Pulse'),
                ],
              ),
            ),
          ),

          // ── Tab content ──────────────────────────────────────────────────
          if (_selectedTabIndex == 0)
            SliverToBoxAdapter(child: _StyleDnaTab(profile: profile))
          else
            SliverToBoxAdapter(child: _BeautyPulseTab(profile: profile)),
        ],
      ),
    );
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: CustomScrollView(
        slivers: [
          const SliverAppBar(
            expandedHeight: 250,
            backgroundColor: Colors.white,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(height: 100, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Premium profile tabs ─────────────────────────────────────────────────────

class _StyleDnaTab extends StatelessWidget {
  final CustomerProfileModel profile;

  const _StyleDnaTab({required this.profile});

  @override
  Widget build(BuildContext context) {
    final styles = [
      if (profile.gender != null && profile.gender!.isNotEmpty)
        _InsightChip(
          icon: Icons.person_outline,
          label: _capitalize(profile.gender!),
        ),
      if (profile.city != null && profile.city!.isNotEmpty)
        _InsightChip(icon: Icons.location_city_rounded, label: profile.city!),
      const _InsightChip(icon: Icons.spa_rounded, label: 'Salon discovery'),
      const _InsightChip(
        icon: Icons.auto_awesome_rounded,
        label: 'Fresh looks',
      ),
      const _InsightChip(
        icon: Icons.favorite_rounded,
        label: 'Saved inspiration',
      ),
    ];

    return _PremiumTabSurface(
      title: 'Style DNA',
      subtitle:
          'A profile-native snapshot of preferences that helps the app understand taste, location, and beauty intent.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(spacing: 10, runSpacing: 10, children: styles),
          const SizedBox(height: 18),
          const _PremiumMetricStrip(
            items: [
              _MetricItem(value: 'Smart', label: 'matching'),
              _MetricItem(value: 'Private', label: 'taste map'),
              _MetricItem(value: 'Local', label: 'salon fit'),
            ],
          ),
          const SizedBox(height: 18),
          _InsightRow(
            icon: Icons.tune_rounded,
            title: 'Recommendation signal',
            subtitle:
                'Saved salons, followed salons, and booked services can shape future discovery without turning the profile into a booking screen.',
          ),
          const SizedBox(height: 10),
          _InsightRow(
            icon: Icons.lock_outline_rounded,
            title: 'Customer controlled',
            subtitle:
                'Preferences stay lightweight and personal; detailed booking history remains in the booking area.',
          ),
        ],
      ),
    );
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
}

class _BeautyPulseTab extends StatelessWidget {
  final CustomerProfileModel profile;

  const _BeautyPulseTab({required this.profile});

  @override
  Widget build(BuildContext context) {
    return _PremiumTabSurface(
      title: 'Beauty Pulse',
      subtitle:
          'A personal activity layer for progress, trust, and relationship signals across the beauty community.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PremiumMetricStrip(
            items: [
              _MetricItem(
                value: '${profile.stats.followingCount}',
                label: 'following',
              ),
              _MetricItem(
                value: '${profile.stats.bookingsCount}',
                label: 'visits',
              ),
              _MetricItem(
                value: '${profile.stats.reviewsCount}',
                label: 'reviews',
              ),
            ],
          ),
          const SizedBox(height: 18),
          const _InsightRow(
            icon: Icons.workspace_premium_rounded,
            title: 'Beauty reputation',
            subtitle:
                'Completed visits, helpful reviews, and salon relationships can build a premium customer profile over time.',
          ),
          const SizedBox(height: 10),
          const _InsightRow(
            icon: Icons.timeline_rounded,
            title: 'Journey timeline',
            subtitle:
                'Future highlights can show milestones like loyal customer, regular visitor, and style explorer.',
          ),
          const SizedBox(height: 10),
          const _InsightRow(
            icon: Icons.verified_rounded,
            title: 'Trust signals',
            subtitle:
                'Keep operational actions in Bookings and use this tab to show profile-level credibility.',
          ),
        ],
      ),
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────

class _PremiumTabSurface extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const _PremiumTabSurface({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest.withValues(alpha: 0.48),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: scheme.outlineVariant.withValues(alpha: 0.55),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 18),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class _InsightChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InsightChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: scheme.primary),
          const SizedBox(width: 7),
          Text(label, style: Theme.of(context).textTheme.labelMedium),
        ],
      ),
    );
  }
}

class _PremiumMetricStrip extends StatelessWidget {
  final List<_MetricItem> items;

  const _PremiumMetricStrip({required this.items});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          Expanded(child: _MetricTile(item: items[i])),
          if (i != items.length - 1) const SizedBox(width: 8),
        ],
      ],
    );
  }
}

class _MetricItem {
  final String value;
  final String label;

  const _MetricItem({required this.value, required this.label});
}

class _MetricTile extends StatelessWidget {
  final _MetricItem item;

  const _MetricTile({required this.item});

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
            item.value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: scheme.primary,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            item.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}

class _InsightRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _InsightRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: scheme.secondary.withValues(alpha: 0.12),
          child: Icon(icon, size: 18, color: scheme.secondary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BeautyHubActions extends StatelessWidget {
  const _BeautyHubActions();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        children: [
          Expanded(
            child: _HubAction(
              icon: Bootstrap.calendar_check,
              label: 'Bookings',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CustomerBookingPage()),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _HubAction(
              icon: Bootstrap.bookmark,
              label: 'Saved',
              onTap: () => Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const SavedPage())),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _HubAction(
              icon: Bootstrap.heart,
              label: 'Following',
              onTap: () => Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const FollowingPage())),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _HubAction(
              icon: Bootstrap.chat_dots,
              label: 'Chats',
              onTap: () => Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const ChatsPage())),
            ),
          ),
        ],
      ),
    );
  }
}

class _HubAction extends StatelessWidget {
  const _HubAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        height: 72,
        decoration: BoxDecoration(
          border: Border.all(color: scheme.outlineVariant),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: scheme.primary),
            const SizedBox(height: 6),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String value;
  final String label;
  const _StatChip({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            shadows: const [
              Shadow(
                blurRadius: 4,
                color: Colors.black54,
                offset: Offset(0, 1),
              ),
            ],
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: 12,
            shadows: const [
              Shadow(
                blurRadius: 2,
                color: Colors.black45,
                offset: Offset(0, 1),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _DetailRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 6),
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }
}

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  const _StickyTabBarDelegate({required this.tabBar});

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(covariant _StickyTabBarDelegate old) =>
      tabBar != old.tabBar;
}
