

import 'package:africa_beuty/core/widgets/activity_feed.dart';
import 'package:africa_beuty/core/widgets/grid_widget.dart';
import 'package:africa_beuty/core/widgets/spacing.dart';
import 'package:africa_beuty/feature/post/view/page/single_post.dart';
import 'package:africa_beuty/feature/profile/model/salon.dart';
import 'package:africa_beuty/feature/profile/view/widget/setting.dart';
import 'package:africa_beuty/feature/profile/view/widget/three_dots.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:shimmer/shimmer.dart';

SalonProfileModel salon = SalonProfileModel(
  id: 'id',
  username: 'username', 
  title: 'title', 
  slogan: 'slogan', 
  description: 'This is the description for salon slogan is another thing!', 
  displayAds: 'http://192.168.43.160:8000/assets/user_profile_picture/user.png', 
  profileCompletion: 0.0,
  profilePicture: 'http://192.168.43.160:8000/assets/user_profile_picture/user.png', 
  contacts: [],
  workingHours: [], 
  gallery: [], 
  followers: 12, 
  rated: 0
);


class ViewServiceProfilePage extends StatefulWidget {
  const ViewServiceProfilePage({super.key});

  @override
  State<ViewServiceProfilePage> createState() => _ViewServiceProfilePageState();
}


class _ViewServiceProfilePageState extends State<ViewServiceProfilePage>
    with SingleTickerProviderStateMixin {
  static const kExpandedHeight = kToolbarHeight + 270;

  late ScrollController _scrollController;
  late TabController _tabController;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()..addListener(() => setState(() {}));

    _tabController = TabController(length: 3, vsync: this)
      ..addListener(() {
        if (_tabController.indexIsChanging) {
          setState(() {
            _selectedTabIndex = _tabController.index;
          });
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
    return Scaffold(
      body: _buildContent(context, salon),
    );
  }

  Widget _buildContent(BuildContext context, SalonProfileModel salon) {
    // Dart weekday: Mon=1, Tue=2... Sun=7. 
    // We subtract 1 to match your backend (Mon=0... Sun=6).
    final int currentDayIndex = DateTime.now().weekday - 1;

    final todaysHours = salon.workingHours.firstWhere(
      (h) => h.dayOfWeek == currentDayIndex,
      // If today isn't in the list, we assume they are closed
      orElse: () => WorkingHourModel(
        dayOfWeek: currentDayIndex, 
        isOpen: false, 
        openTime: '', 
        closeTime: ''
      ),
    );

    // Helper to format "10:00:00" -> "10:00"
    String formatTime(String time) {
      if (time.isEmpty) return '';
      final parts = time.split(':');
      if (parts.length >= 2) return '${parts[0]}:${parts[1]}';
      return time;
    }

    final size = MediaQuery.of(context).size;

    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 2));
      },
      child: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
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
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black,
                                blurRadius: 50,
                                spreadRadius: 2,
                                offset: const Offset(0, 3), // Moves shadow down slightly
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.grey[200],
                            child: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: salon.profilePicture,
                                fit: BoxFit.cover,
                                width: 48,
                                height: 48,
                                errorWidget: (context, url, error) => const Icon(Icons.person),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          salon.username,
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
                    // 1. YOUR ORIGINAL GRADIENT (Base Layer)
                    Container(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [Colors.brown.shade400, Colors.blueGrey.shade500],
                        ),
                      ),
                    ),

                    // 2. COVER IMAGE (Displayed only if URL is not empty)
                    if (salon.displayAds.isNotEmpty)
                      CachedNetworkImage(
                        imageUrl: salon.displayAds,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => const SizedBox.shrink(),
                      ),

                    // 3. DARK OVERLAY (Ensures text readability over any image)
                    if (salon.displayAds.isNotEmpty)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.2), // Adjust darkness here
                        ),
                      ),

                    // 4. YOUR ORIGINAL CONTENT COLUMN
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.white24,
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: salon.profilePicture,
                                    fit: BoxFit.cover,
                                    width: 100,
                                    height: 100,
                                    errorWidget: (context, url, error) => Image.asset('assets/images/dp.jpg'),
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
                                      salon.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        shadows: [
                                          Shadow(
                                            offset: const Offset(0, 1),
                                            blurRadius: 6.0,
                                            color: Colors.black.withOpacity(0.6),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      // Later Batch implementation
                                      // Icon(
                                      //   OctIcons.verified, 
                                      //   size: 14, 
                                      //   color: Colors.blue.shade500,
                                      //   shadows: const [Shadow(blurRadius: 4, color: Colors.black26)],
                                      // ),
                                      SizedBox(
                                        width: size.width * .5,
                                        child: Text(
                                          salon.username,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            shadows: [
                                              Shadow(
                                                offset: const Offset(0, 1),
                                                blurRadius: 6.0,
                                                color: Colors.black.withOpacity(0.6),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              // Followers Column with Shadows
                              GestureDetector(
                                onTap: () { /* Navigate to followers list if needed */ },
                                child: Column(
                                  children: [
                                    Text(
                                      '${salon.followers}',
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.onPrimary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        shadows: [
                                          Shadow(
                                            blurRadius: 4.0,
                                            color: Colors.black54,
                                            offset: Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      'Followers',
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.onPrimary,
                                        fontSize: 12,
                                        shadows: const [
                                          Shadow(
                                            blurRadius: 2.0,
                                            color: Colors.black45,
                                            offset: Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16), // Increased spacing for better UX
                              Row(
                                children: [
                                  Material(
                                    color: Colors.black26, // Semi-transparent black
                                    shape: const CircleBorder(),
                                    clipBehavior: Clip.antiAlias,
                                    child: const SettingAccount(isCustomer: false),
                                  ),
                                  const SizedBox(width: 8),
                                  Material(
                                    color: Colors.black26,
                                    shape: const CircleBorder(),
                                    clipBehavior: Clip.antiAlias,
                                    child: const ThreeDotsOptions(isCustomer: false),
                                  ),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  salon.slogan.isNotEmpty ? salon.slogan : "",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onPrimary,
                                    shadows: const [
                                      Shadow(
                                        blurRadius: 2.0,
                                        color: Colors.black45,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Pulsing-style status dot
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: todaysHours.isOpen ? Colors.greenAccent : Colors.redAccent,
                                          boxShadow: [
                                            BoxShadow(
                                              color: (todaysHours.isOpen ? Colors.greenAccent : Colors.redAccent).withOpacity(0.5),
                                              blurRadius: 4,
                                              spreadRadius: 1,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        todaysHours.isOpen ? "OPEN" : "CLOSED",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 1.1,
                                          color: todaysHours.isOpen ? Colors.greenAccent : Colors.redAccent,
                                          shadows: const [
                                            Shadow(blurRadius: 4, color: Colors.black87, offset: Offset(0, 1))
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  if (todaysHours.isOpen)
                                    Text(
                                      "${formatTime(todaysHours.openTime)} - ${formatTime(todaysHours.closeTime)}",
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        shadows: [
                                          Shadow(blurRadius: 4, color: Colors.black87, offset: Offset(0, 1))
                                        ],
                                      ),
                                    )
                                  else
                                    const Text(
                                      "See you tomorrow",
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.white70,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverSpaceHeader(title: 'Bio'),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                salon.description,
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
          ),

          SliverSpaceHeader(title: 'Visuals'),
          SliverToBoxAdapter(
            child: salon.gallery.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: Text('No visuals uploaded')),
                  )
                : SizedBox(
                    height: 160, // Set the height for your horizontal gallery
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: salon.gallery.length,
                      itemBuilder: (_, i) => Container(
                        width: 140, // Set the width for each image
                        margin: const EdgeInsets.only(right: 12), // Spacing between items
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: CachedNetworkImage(
                            imageUrl: salon.gallery[i].imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey[200],
                              child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[300],
                              child: const Icon(Icons.broken_image, color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
          ),

          SliverSpaceHeader(title: ''),
          SliverPersistentHeader(
            pinned: true,
            delegate: _StickyTabBarDelegate(
              tabBar: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(icon: Icon(Bootstrap.grid_3x3_gap_fill)),
                  Tab(icon: Icon(Bootstrap.view_stacked)),
                  Tab(icon: Icon(Bootstrap.list_task)),
                ],
              ),
            ),
          ),

          if (_selectedTabIndex == 0)
            const GridWidget()
          else if (_selectedTabIndex == 1)
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) => Post(
                  postId: 'postId_$i',
                  isLiked: false,
                  aspectRatio: 1,
                  username: salon.username,
                  profileImage: salon.profilePicture,
                  images: [salon.displayAds],
                  likesCount: 100,
                  sharesCount: 50,
                  commentsCount: 20,
                  description: 'Salon highlight',
                  datePosted: 'Today',
                ),
                childCount: 3,
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) => const ActivityFeed(),
                childCount: 5,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: CustomScrollView(
        slivers: [
          SliverAppBar(expandedHeight: 250, backgroundColor: Colors.white),
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


class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  const _StickyTabBarDelegate({required this.tabBar});

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlaps) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(covariant _StickyTabBarDelegate old) => tabBar != old.tabBar;
}