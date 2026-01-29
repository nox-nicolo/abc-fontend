

import 'package:africa_beuty/core/widgets/activity_feed.dart';
import 'package:africa_beuty/core/widgets/grid_widget.dart';
import 'package:africa_beuty/core/widgets/spacing.dart';
import 'package:africa_beuty/feature/post/view/page/single_post.dart';
import 'package:africa_beuty/feature/post/view/widgets/view_post/booking.dart';
import 'package:africa_beuty/feature/profile/model/salon.dart';
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
  displayAds: 'http://192.168.43.160:8000/assets/images/user_profile_picture/service/adaf35b02bf24a21ba6abdc81553b5f6.jpg', 
  profileCompletion: 0.0,
  profilePicture: 'http://192.168.43.160:8000/assets/images/user_profile_picture/service/adaf35b02bf24a21ba6abdc81553b5f6.jpg', 
  contacts: [],
  workingHours: [
    WorkingHourModel(dayOfWeek: 0, isOpen: true, openTime: '09:00:00', closeTime: '18:00:00'),
    WorkingHourModel(dayOfWeek: 1, isOpen: true, openTime: '09:00:00', closeTime: '18:00:00'),
    WorkingHourModel(dayOfWeek: 2, isOpen: true, openTime: '09:00:00', closeTime: '18:00:00'),
    WorkingHourModel(dayOfWeek: 3, isOpen: true, openTime: '09:00:00', closeTime: '18:00:00'),
    WorkingHourModel(dayOfWeek: 4, isOpen: true, openTime: '09:00:00', closeTime: '18:00:00'),
    WorkingHourModel(dayOfWeek: 5, isOpen: true, openTime: '09:00:00', closeTime: '18:00:00'),
    WorkingHourModel(dayOfWeek: 6, isOpen: true, openTime: '09:00:00', closeTime: '18:00:00'),
  ], 
  gallery: [
    GalleryModel(id: '1', imageUrl: 'http://192.168.43.160:8000/assets/images/user_profile_picture/service/adaf35b02bf24a21ba6abdc81553b5f6.jpg'),
    GalleryModel(id: '2', imageUrl: 'http://192.168.43.160:8000/assets/images/user_profile_picture/service/adaf35b02bf24a21ba6abdc81553b5f6.jpg'),
    GalleryModel(id: '3', imageUrl: 'http://192.168.43.160:8000/assets/images/user_profile_picture/service/adaf35b02bf24a21ba6abdc81553b5f6.jpg'),
    GalleryModel(id: '4', imageUrl: 'http://192.168.43.160:8000/assets/images/user_profile_picture/service/adaf35b02bf24a21ba6abdc81553b5f6.jpg'),
  ], 
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

    _tabController = TabController(length: 2, vsync: this)
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

  // Logic to get more data (Pagination)
  Future<void> _loadMoreData() async {
    setState(() => isLoadingMore = true);
    
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay
    
    setState(() {
      items.addAll(List.generate(15, (index) => items.length + index));
      isLoadingMore = false;
    });
  }

  // Logic to refresh data (Pull-to-refresh)
  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      items = List.generate(15, (index) => index); // Reset to first 15
    });
  }

  // Follow Bottom Sheet
  void _showFollowersBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Column(
              children: [
                // DRAG HANDLE
                Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 8),
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),

                // GLOBAL UNFOLLOW BUTTON (ONLY IF FOLLOWING)
                if (!notFollowing)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 8),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        minimumSize: const Size.fromHeight(44),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        // UNFOLLOW SALON
                        setState(() {
                          notFollowing = true;
                        });
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Unfollow',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),

                // HEADER
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Followers · ${salon.followers}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                  ),
                ),

                const Divider(height: 1),

                // FOLLOWERS LIST
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: 20, // mock followers count for now
                    itemBuilder: (context, index) {
                      final bool isFollowing = index % 3 == 0;

                      return ListTile(
                        leading: CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(
                            salon.profilePicture,
                          ),
                        ),
                        title: Text(
                          'username_$index',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: const Text('Full Name'),
                        trailing: isFollowing
                            ? OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                onPressed: () {
                                  // unfollow logic
                                },
                                child: const Text('Following'),
                              )
                            : FilledButton(
                                style: FilledButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                onPressed: () {
                                  // follow logic
                                },
                                child: const Text('Follow'),
                              ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showSalonActionsSheet(BuildContext context) {
    bool notificationsOn = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // DRAG HANDLE
                  Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 8),
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),

                  // SALON HEADER
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(salon.profilePicture),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                salon.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w800),
                              ),
                              Text(
                                "@${salon.username}",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Divider(height: 1),

                  // NOTIFICATIONS
                  ListTile(
                    leading: Icon(
                      notificationsOn
                          ? Icons.notifications_active
                          : Icons.notifications_off,
                    ),
                    title: const Text(
                      'Notifications',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      notificationsOn
                          ? 'You will receive updates from this salon'
                          : 'Notifications are turned off',
                    ),
                    trailing: Switch(
                      value: notificationsOn,
                      onChanged: (value) {
                        setModalState(() {
                          notificationsOn = value;
                        });
                      },
                    ),
                  ),

                  const Divider(height: 1),

                  // CONTACTS
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Contact salon',
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge
                            ?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Colors.grey[700],
                            ),
                      ),
                    ),
                  ),

                  ListTile(
                    leading: const Icon(Icons.call),
                    title: const Text('Call'),
                    onTap: () {
                      // launch tel:
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.sms),
                    title: const Text('SMS'),
                    onTap: () {
                      // launch sms:
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.chat),
                    title: const Text('WhatsApp'),
                    onTap: () {
                      // launch whatsapp:
                    },
                  ),

                  const Divider(height: 1),

                  // SHARE
                  ListTile(
                    leading: const Icon(Icons.share),
                    title: const Text(
                      'Share salon',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    onTap: () {
                      // share logic
                    },
                  ),

                  const Divider(height: 1),

                  // DANGEROUS ACTIONS
                  ListTile(
                    leading: const Icon(Icons.flag, color: Colors.red),
                    title: const Text(
                      'Report salon',
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () {
                      // report logic
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.block, color: Colors.red),
                    title: const Text(
                      'Block salon',
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () {
                      // block logic
                    },
                  ),

                  const SizedBox(height: 8),
                ],
              ),
            );
          },
        );
      },
    );
  }



  bool notFollowing = true;
  List<int> items = List.generate(15, (index) => index);
  bool isLoadingMore = false;

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
      onRefresh: _handleRefresh,
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
              // Better alignment when pinned
              centerTitle: false,
              titlePadding: const EdgeInsetsDirectional.only(start: 12, bottom: 12, end: 12),

              // COLLAPSED (PINNED) TITLE: avatar size + alignment fixed
              title: _isSliverAppBarExpanded
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                spreadRadius: 1,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: salon.profilePicture,
                              fit: BoxFit.cover,
                              errorWidget: (_, __, ___) => const Icon(Icons.person),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            salon.username,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
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
                    // Base Layer
                    Container(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [Colors.brown.shade400, Colors.blueGrey.shade500],
                        ),
                      ),
                    ),

                    // COVER IMAGE
                    if (salon.displayAds.isNotEmpty)
                      CachedNetworkImage(
                        imageUrl: salon.displayAds,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => const SizedBox.shrink(),
                      ),

                    // Bottom Gradient (contrast)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      height: 160,
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black54,
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),

                    // EXPANDED HEADER CONTENT (keeps your structure: title/user, followers+open, slogan)
                    Positioned.fill(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                // Profile Image with Border + Shadow
                                Container(
                                  width: 96,
                                  height: 96,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 3),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 10,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl: salon.profilePicture,
                                      fit: BoxFit.cover,
                                      placeholder: (_, __) => Container(color: Colors.grey[300]),
                                      errorWidget: (_, __, ___) =>
                                          const Icon(Icons.person, size: 40),
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 15),

                                // Title + Username
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        salon.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "@${salon.username}",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.7),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            // Row: Left = Follow/Follower/Options, Right = Open/Hours
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                // LEFT SIDE
                                Row(
                                  children: [
                                    if (notFollowing)
                                      FilledButton.icon(
                                        style: FilledButton.styleFrom(
                                          backgroundColor: Colors.blueAccent,
                                          foregroundColor: Colors.white,
                                        ),
                                        onPressed: () {
                                          setState(() => notFollowing = false);
                                        },
                                        icon: const Icon(Icons.add, size: 18),
                                        label: const Text("Follow"),
                                      )
                                    else
                                      GestureDetector(
                                        onTap: () {
                                          _showFollowersBottomSheet(context);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.18),
                                            borderRadius: BorderRadius.circular(18),
                                            border: Border.all(color: Colors.white24),
                                          ),
                                          child: Row(
                                            children: [
                                              Text(
                                                '${salon.followers}',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                              const Text(
                                                'Followers',
                                                style: TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                    const SizedBox(width: 10),

                                    if (!notFollowing)
                                      Material(
                                        color: Colors.white.withOpacity(0.12),
                                        shape: const CircleBorder(),
                                        clipBehavior: Clip.antiAlias,
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.more_horiz,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            _showSalonActionsSheet(context);
                                          },
                                        ),
                                      ),
                                  ],
                                ),

                                const Spacer(),

                                // RIGHT SIDE (Open status + hours)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: todaysHours.isOpen
                                                ? Colors.greenAccent
                                                : Colors.redAccent,
                                            boxShadow: [
                                              BoxShadow(
                                                color: (todaysHours.isOpen
                                                        ? Colors.greenAccent
                                                        : Colors.redAccent)
                                                    .withOpacity(0.55),
                                                blurRadius: 6,
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
                                            color: todaysHours.isOpen
                                                ? Colors.greenAccent
                                                : Colors.redAccent,
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
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            // SLOGAN at bottom (restored)
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    salon.slogan.isNotEmpty ? salon.slogan : "",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.92),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // BIO TEXT
                  Text(
                    salon.description,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),

                  const SizedBox(height: 6),

                  // READ MORE (optional future expansion)
                  GestureDetector(
                    onTap: () {
                      // Later: expand bio or open bottom sheet
                    },
                    child: Text(
                      "Read more",
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // TRUST / CONTEXT CHIPS
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.location_on, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              "City Center",
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              "4.5 Rating",
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.verified, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              "Certified",
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.workspace_premium, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              "5+ Years",
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // SOFT CTA
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      // Scroll to services / gallery / booking
                    },
                    icon: const Icon(Icons.design_services_outlined),
                    label: const Text("View Services"),
                  ),
                ],
              ),
            ),
          ),

          SliverSpaceHeader(title: 'Salon Gallery'),
          SliverToBoxAdapter(
            child: salon.gallery.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: Text('No visuals uploaded')),
                  )
                : SizedBox(
                    height: 190, // Portfolio feel
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: salon.gallery.length,
                      itemBuilder: (context, i) {
                        return TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: 1),
                          duration: Duration(milliseconds: 450 + (i * 120)),
                          curve: Curves.easeOutCubic,
                          builder: (context, value, child) {
                            return Transform.translate(
                              offset: Offset(30 * (1 - value), 0),
                              child: Opacity(opacity: value, child: child),
                            );
                          },
                          child: Container(
                            width: 150,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                  offset: Offset(0, 6),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: CachedNetworkImage(
                                imageUrl: salon.gallery[i].imageUrl,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: Colors.grey[200],
                                  child: const Center(
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: Colors.grey[300],
                                  child: const Icon(
                                    Icons.broken_image,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
          
          // Book Button
          SliverSpaceHeader(title: ''),
          SliverToBoxAdapter(
            child: BookingNowGlowButton(
              onPressed: () {},
            ),
          ),

          SliverSpaceHeader(title: ''),
          SliverPersistentHeader(
            pinned: true,
            delegate: _StickyTabBarDelegate(
              tabBar: TabBar(
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Theme.of(context).colorScheme.primary,
                unselectedLabelColor:
                    Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                tabs: const [
                  Tab(
                    icon: Icon(Bootstrap.grid_3x3_gap_fill),
                    text: 'Grid',
                  ),
                  Tab(
                    icon: Icon(Bootstrap.view_stacked),
                    text: 'Posts',
                  ),
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
            ),

            // Loading Spinner at the bottom
            if (isLoadingMore)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
        ],
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          // HEADER SHIMMER (Cover + Avatar)
          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: 280,
            pinned: true,
            backgroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Colors.grey[300],
                child: Stack(
                  children: [
                    // Bottom gradient placeholder
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      height: 140,
                      child: Container(color: Colors.grey[350]),
                    ),

                    // Avatar placeholder
                    Positioned(
                      bottom: 24,
                      left: 16,
                      child: Container(
                        width: 96,
                        height: 96,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    // Title + username placeholders
                    Positioned(
                      bottom: 48,
                      left: 128,
                      right: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 20,
                            width: 180,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 14,
                            width: 120,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // BIO SHIMMER
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 14, width: double.infinity, color: Colors.white),
                  const SizedBox(height: 8),
                  Container(height: 14, width: double.infinity, color: Colors.white),
                  const SizedBox(height: 8),
                  Container(height: 14, width: 220, color: Colors.white),
                ],
              ),
            ),
          ),

          // GALLERY SHIMMER
          SliverToBoxAdapter(
            child: SizedBox(
              height: 190,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 4,
                itemBuilder: (_, __) => Container(
                  width: 150,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ),

          // BOOK BUTTON SHIMMER
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Container(
                height: 54,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          ),

          // POSTS SHIMMER
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, __) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              childCount: 3,
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