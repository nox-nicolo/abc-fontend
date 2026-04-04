import 'package:africa_beuty/core/widgets/spacing.dart';
import 'package:africa_beuty/feature/booking/view/pages/customer_booking.dart';
import 'package:africa_beuty/feature/profile/model/customer_profile.dart';
import 'package:africa_beuty/feature/profile/view/widget/setting.dart';
import 'package:africa_beuty/feature/profile/view/widget/three_dots.dart';
import 'package:africa_beuty/feature/profile/view_model/customer_profile.dart';
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

    _scrollController = ScrollController()
      ..addListener(() => setState(() {}));

    _tabController = TabController(length: 2, vsync: this)
      ..addListener(() {
        if (_tabController.indexIsChanging) {
          setState(() => _selectedTabIndex = _tabController.index);
        }
      });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(myCustomerProfileViewModelProvider);
      if (state is! AsyncData || state.value == null) {
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
      error: (e, _) => Center(child: Text(e.toString())),
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
                                  : Image.asset('assets/images/dp.jpg',
                                      fit: BoxFit.cover,
                                      width: 48,
                                      height: 48),
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
                                                  'assets/images/dp.jpg'),
                                        )
                                      : Image.asset('assets/images/dp.jpg',
                                          fit: BoxFit.cover,
                                          width: 100,
                                          height: 100),
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
                                                color: Colors.black
                                                    .withValues(alpha: 0.6),
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
                                                color: Colors.black
                                                    .withValues(alpha: 0.6),
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
                                child:
                                    const SettingAccount(isCustomer: true),
                              ),
                              const SizedBox(width: 8),
                              Material(
                                color: Colors.black26,
                                shape: const CircleBorder(),
                                clipBehavior: Clip.antiAlias,
                                child:
                                    const ThreeDotsOptions(isCustomer: true),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (profile.city != null || profile.country != null)
                      _DetailRow(
                        icon: Icons.location_on_outlined,
                        text: [profile.city, profile.country]
                            .where((s) => s != null && s.isNotEmpty)
                            .join(', '),
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

          // ── Sticky tab bar (Bookings | Reviews) ─────────────────────────
          SliverSpaceHeader(title: ''),
          SliverPersistentHeader(
            pinned: true,
            delegate: _StickyTabBarDelegate(
              tabBar: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(
                    icon: Icon(Bootstrap.calendar_check),
                    text: 'Bookings',
                  ),
                  Tab(
                    icon: Icon(Bootstrap.star),
                    text: 'Reviews',
                  ),
                ],
              ),
            ),
          ),

          // ── Tab content ──────────────────────────────────────────────────
          if (_selectedTabIndex == 0)
            SliverToBoxAdapter(
              child: _BookingsTab(),
            )
          else
            const SliverToBoxAdapter(
              child: _ReviewsTab(),
            ),
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
              expandedHeight: 250, backgroundColor: Colors.white),
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

// ── Bookings tab ──────────────────────────────────────────────────────────────

class _BookingsTab extends StatelessWidget {
  const _BookingsTab();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Icon(Bootstrap.calendar_check,
              size: 48, color: Colors.pinkAccent),
          const SizedBox(height: 16),
          Text(
            'Your Bookings',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'View and manage all your upcoming\nand past appointments.',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CustomerBookingPage(),
                ),
              );
            },
            icon: const Icon(Icons.arrow_forward_rounded, size: 18),
            label: const Text('Go to Bookings'),
          ),
        ],
      ),
    );
  }
}

// ── Reviews tab ───────────────────────────────────────────────────────────────

class _ReviewsTab extends StatelessWidget {
  const _ReviewsTab();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(Bootstrap.star, size: 48, color: Colors.amber[600]),
          const SizedBox(height: 16),
          Text(
            'Your Reviews',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Reviews you leave after completed\nappointments will appear here.',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────

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
                  offset: Offset(0, 1)),
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
                  offset: Offset(0, 1)),
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
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(covariant _StickyTabBarDelegate old) =>
      tabBar != old.tabBar;
}
