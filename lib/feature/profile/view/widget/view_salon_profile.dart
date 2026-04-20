

import 'package:africa_beuty/core/widgets/activity_feed.dart';
import 'package:africa_beuty/core/widgets/grid_widget.dart';
import 'package:africa_beuty/core/widgets/spacing.dart';
import 'package:africa_beuty/feature/booking/provider/booking_draft.dart';
import 'package:africa_beuty/feature/booking/view/widgets/start_booking/select_time.dart';
import 'package:africa_beuty/feature/search/provider/discover.dart';
import 'package:africa_beuty/feature/post/view/page/single_post.dart';
import 'package:africa_beuty/feature/post/view/widgets/view_post/booking.dart';
import 'package:africa_beuty/feature/profile/model/salon_view_profile.dart';
import 'package:africa_beuty/feature/profile/view/widget/salon_profile_view_services.dart';
import 'package:africa_beuty/feature/profile/view_model/salon_activity.dart';
import 'package:africa_beuty/feature/profile/view_model/salon_profile_post.dart';
import 'package:africa_beuty/feature/profile/view_model/salon_view_follow_action.dart';
import 'package:africa_beuty/feature/profile/view_model/salon_view_profile.dart';
import 'package:africa_beuty/feature/profile/view_model/salon_view_profile_followers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:latlong2/latlong.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';


class ViewServiceProfilePage extends ConsumerStatefulWidget {
  final String salonId;

  const ViewServiceProfilePage({
    super.key,
    required this.salonId,
  });

  @override
  ConsumerState<ViewServiceProfilePage> createState() => _ViewServiceProfilePageState();

}


class _ViewServiceProfilePageState extends ConsumerState<ViewServiceProfilePage>
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
    final state = ref.watch(
      salonViewProfileViewModelProvider(widget.salonId),
    );

    return Scaffold(
      body: state.when(
        loading: _buildLoadingShimmer,
        error: (e, _) => Center(child: Text(e.toString())),
        data: (salon) => _buildContent(context, salon),
      ),
    );
  }

  // Logic to refresh data (Pull-to-refresh)
  Future<void> _handleRefresh() async {
    ref.invalidate(
      salonViewProfileViewModelProvider(widget.salonId),
    );
  }

  // To be updated in the AddroidManifest.xml file
  // <queries>
  //   <intent>
  //     <action android:name="android.intent.action.VIEW" />
  //     <data android:scheme="tel" />
  //   </intent>
  //   <intent>
  //     <action android:name="android.intent.action.VIEW" />
  //     <data android:scheme="sms" />
  //   </intent>
  //   <intent>
  //     <action android:name="android.intent.action.VIEW" />
  //     <data android:scheme="mailto" />
  //   </intent>
  //   <intent>
  //     <action android:name="android.intent.action.VIEW" />
  //     <data android:scheme="https" />
  //   </intent>
  // </queries>

  // for IoS info.plist
  // <key>LSApplicationQueriesSchemes</key>
  // <array>
  //   <string>tel</string>
  //   <string>sms</string>
  //   <string>mailto</string>
  //   <string>https</string>
  // </array>
  
  Future<void> openPhone(String phoneNumber) async {
    final uri = Uri(scheme: 'tel', path: phoneNumber);

    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  }

  // 
  Future<void> openSms(String phoneNumber) async {
    final uri = Uri.parse('sms:$phoneNumber');

    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  }

  // 
  Future<void> openWhatsApp(String phoneNumber) async {
    // Remove any non-numeric characters (like + or spaces)
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    final uri = Uri.parse('https://wa.me/$cleanPhone');

    // mode: LaunchMode.externalApplication is essential for WhatsApp!
    await launchUrl(
      uri, 
      mode: LaunchMode.externalApplication
    );
  }

  // 
  Future<void> openEmail(String email) async {
    final uri = Uri.parse('mailto:$email');

    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,   
    );
  }

  // 
  Future<void> openMap(double lat, double lng) async {
    // Opens Google Maps with turn-by-turn directions from the user's location.
    // Fallback to Apple Maps on iOS via geo: scheme.
    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving',
    );
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  void _showFollowersBottomSheet(
    BuildContext context,
    SalonViewProfileModel salon,
  ) {
       // 
    final followLoading =
        ref.watch(salonFollowActionViewModelProvider);
    final followVM =
        ref.read(salonFollowActionViewModelProvider.notifier);


    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Consumer(
          builder: (context, ref, _) {
            final notifier = ref.read(
              salonFollowersViewModelProvider(salon.salon.id).notifier,
            );

            // LOAD FIRST PAGE ONCE
            WidgetsBinding.instance.addPostFrameCallback((_) {
              notifier.loadInitial(salon.salon.id);
            });

            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.6,
              minChildSize: 0.4,
              maxChildSize: 0.9,
              builder: (context, scrollController) {
                return Column(
                  children: [
                    // ───── Drag Handle ─────
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

                    // ───── UNFOLLOW SALON BUTTON ─────
                    if (salon.viewer.isFollowing)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 48,
                          vertical: 8,
                        ),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                            minimumSize: const Size.fromHeight(44),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: followLoading
                            ? null
                            : () async {
                                final success = await followVM.unfollow(
                                  salonId: salon.salon.id,
                                );

                                if (success && context.mounted) {
                                  Navigator.of(context).pop(); // close sheet
                                }
                              },
                          
                          child: const Text(
                            'Unfollow',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),

                    // ───── Header ─────
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Text(
                        'Followers · ${salon.metrics.followersCount}',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                    ),

                    const Divider(height: 1),

                    // ───── Followers List ─────
                    Expanded(
                      child: Consumer(
                        builder: (context, ref, _) {
                          final state = ref.watch(
                            salonFollowersViewModelProvider(salon.salon.id),
                          );

                          // pagination listener
                          scrollController.addListener(() {
                            if (scrollController.position.pixels >=
                                scrollController.position.maxScrollExtent - 200) {
                              notifier.loadMore(salon.salon.id);
                            }
                          });

                          // FIRST LOADING
                          if (state.isLoading && state.items.isEmpty) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          // EMPTY
                          if (state.items.isEmpty) {
                            return const Center(
                              child: Text('No followers yet'),
                            );
                          }

                          return ListView.builder(
                            controller: scrollController,
                            itemCount: state.items.length +
                                (state.isLoadingMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index >= state.items.length) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }

                              final follower = state.items[index];

                              return ListTile(
                                leading: CircleAvatar(
                                  radius: 22,
                                  backgroundImage: follower.avatar != null
                                      ? NetworkImage(follower.avatar!)
                                      : null,
                                  backgroundColor: Colors.grey.shade300,
                                ),
                                title: Text(
                                  follower.username,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Text(follower.name),
                                trailing: follower.isFollowing
                                    ? OutlinedButton(
                                        onPressed: followLoading
                                          ? null
                                          : () async {
                                              final success = await followVM.unfollow(
                                                salonId: salon.salon.id,
                                              );
                                        },
                                        child: const Text('Following'),
                                      )
                                    : FilledButton(
                                        onPressed: followLoading
                                          ? null
                                          : () async {
                                              final success = await followVM.follow(
                                                salonId: salon.salon.id,
                                              );
                                        },
                                        child: const Text('Follow'),
                                      ),
                              );
                            },
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
      },
    );
  }



  void _showSalonActionsSheet(
    BuildContext context,
    SalonViewProfileModel salon,) 
  {
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
                          backgroundImage: NetworkImage(salon.salon.profilePicture),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                salon.salon.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w800),
                              ),
                              Text(
                                "@${salon.salon.username}",
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
                    onTap: () => openPhone(salon.contacts.phone.toString()),
                  ),
                  ListTile(
                    leading: const Icon(Icons.sms),
                    title: const Text('SMS'),
                    onTap: () => openSms(salon.contacts.phone.toString()),
                  ),
                  ListTile(
                    leading: const Icon(Icons.chat),
                    title: const Text('WhatsApp'),
                    onTap: () => openWhatsApp(salon.contacts.phone.toString()),
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

  void _showSalonServicesSheet(
    BuildContext context,
    SalonViewProfileModel salon,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetCtx) => SalonServicesSheet(
        salon: salon,
        onBook: (service) {
          // Close the sheet first
          Navigator.of(sheetCtx).pop();

          // Pre-fill the booking draft with what we know
          ref.read(bookingDraftProvider.notifier)
            ..reset()
            ..selectSalonOffer(
              salonServicePriceId: service.id,
              salonName: salon.salon.name,
              price: (service.priceMin ?? 0).toDouble(),
              currency: service.currency,
              durationMinutes: service.durationMinutes ?? 60,
            );

          // Jump straight to date/time picker — style & salon already chosen
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const PickDateTimePage()),
          );
        },
      ),
    );
  }



  bool notFollowing = true;
  List<int> items = List.generate(15, (index) => index);
  bool isLoadingMore = false;

  Widget _buildContent(BuildContext context, SalonViewProfileModel salon) {
    // Dart weekday: Mon=1, Tue=2... Sun=7. 
    // We subtract 1 to match your backend (Mon=0... Sun=6).
    final int currentDayIndex = DateTime.now().weekday - 1;

    final todaysHours = salon.availability.weekly.firstWhere(
      (h) => h.day == currentDayIndex,
      orElse: () => SalonWeeklyModel(
        day: currentDayIndex,
        isOpen: false,
        open: '',
        close: '',
      ),
    );

    String formatTime(String time) {
      if (time.isEmpty) return '';
      final parts = time.split(':');
      return parts.length >= 2 ? '${parts[0]}:${parts[1]}' : time;
    }

    final size = MediaQuery.of(context).size;

    // 
    final isFollowing = salon.viewer.isFollowing;
    final followLoading =
        ref.watch(salonFollowActionViewModelProvider);
    final followVM =
        ref.read(salonFollowActionViewModelProvider.notifier);

    final postsState = ref.watch(profilePostsViewModelProvider(salon.salon.id));
    final postsNotifier = ref.read(profilePostsViewModelProvider(salon.salon.id).notifier);

    final activityState = ref.watch(salonActivityViewModelProvider(salon.salon.id));
    final activityNotifier =
        ref.read(salonActivityViewModelProvider(salon.salon.id).notifier);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Only call if still loading and no data
      if (postsState.isLoading && !postsState.hasValue) {
        postsNotifier.getInitialPosts();
      }
      if (_selectedTabIndex == 2 &&
          activityState.isLoading &&
          !activityState.hasValue) {
        activityNotifier.getInitialActivity();
      }
    });


    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            final metrics = notification.metrics;
            final threshold = 300.0; // px before bottom
            final nearBottom =
                metrics.pixels >= (metrics.maxScrollExtent - threshold);

            if (!nearBottom) return false;

            if (_selectedTabIndex == 0 || _selectedTabIndex == 1) {
              postsNotifier.getMorePosts();
            } else if (_selectedTabIndex == 2) {
              activityNotifier.getMoreActivity();
            }
            return false;
          },
          child: CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Material(
                    color: Colors.black26,
                    shape: const CircleBorder(),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
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
                                  imageUrl: salon.salon.profilePicture,
                                  fit: BoxFit.cover,
                                  errorWidget: (_, __, ___) => const Icon(Icons.person),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                salon.salon.username,
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
                        if (salon.salon.coverImage.isNotEmpty)
                          CachedNetworkImage(
                            imageUrl: salon.salon.coverImage,
                            fit: BoxFit.cover,
                            errorWidget: (_, _, _) => const SizedBox.shrink(),
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
                                          imageUrl: salon.salon.profilePicture,
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
                                            salon.salon.name,
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
                                            "@${salon.salon.username}",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.white.withValues(alpha: 0.7),
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
                                        /// ---------------- FOLLOW / FOLLOWERS ----------------
                                        if (!isFollowing)
                                          FilledButton.icon(
                                            style: FilledButton.styleFrom(
                                              backgroundColor: Theme.of(context).colorScheme.secondary,
                                              foregroundColor: Theme.of(context).colorScheme.onSecondary,
                                            ),
                                            onPressed: followLoading
                                                ? null
                                                : () {
                                                    followVM.follow(
                                                      salonId: salon.salon.id,
                                                    );
                                                  },
                                            icon: followLoading
                                                ? SizedBox(
                                                    height: 16,
                                                    width: 16,
                                                    child: CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      color: Theme.of(context).colorScheme.primary,
                                                    ),
                                                  )
                                                : const Icon(Icons.add, size: 18),
                                            label: const Text("Follow"),
                                          )
                                        else
                                          GestureDetector(
                                            onTap: () {
                                              _showFollowersBottomSheet(context, salon);
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withValues(alpha: 0.18),
                                                borderRadius: BorderRadius.circular(18),
                                                border: Border.all(color: Colors.white24),
                                              ),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    '${salon.metrics.followersCount}',
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
          
                                        /// ---------------- MORE ACTIONS ----------------
                                        if (isFollowing)
                                          Material(
                                            color: Colors.white.withValues(alpha: 0.12),
                                            shape: const CircleBorder(),
                                            clipBehavior: Clip.antiAlias,
                                            child: IconButton(
                                              icon: const Icon(
                                                Icons.more_horiz,
                                                color: Colors.white,
                                              ),
                                              onPressed: () {
                                                _showSalonActionsSheet(context, salon);
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
                                                color: todaysHours.isOpen ? Colors.greenAccent : Colors.redAccent,
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              todaysHours.isOpen ? "OPEN" : "CLOSED",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w900,
                                                color: todaysHours.isOpen ? Colors.greenAccent : Colors.redAccent,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 2),
                                        if (todaysHours.isOpen)
                                          Text(
                                            "${formatTime(todaysHours.open.toString())} - ${formatTime(todaysHours.close.toString())}",
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          )
                                        else
                                          const Text(
                                            "Closed today",
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
                                        salon.salon.slogan.isNotEmpty ? salon.salon.slogan : "",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.white.withValues(alpha: 0.92),
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
                        salon.salon.description,
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
                          "", // "Read more",
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
                        runAlignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
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
                                const Icon(Icons.star, size: 18, color: Color.fromARGB(255, 255, 174, 0),),
                                const SizedBox(width: 4),
                                Text(
                                  salon.metrics.rating.toString(),
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
                                const Icon(Icons.verified, size: 18, color: Color.fromARGB(255, 205, 250, 3),),
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
                                const Icon(Icons.workspace_premium, size: 18, color: Color.fromARGB(255, 151, 143, 116),),
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
          
                      Container(
                        width: size.width * 0.9,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(20),
                          // Added the border color here
                          border: Border.all(
                            color: Theme.of(context).colorScheme.secondary,
                            width: 1, // You can adjust thickness here
                          ),
                        ),
                        child: Row(
                          // mainAxisSize: MainAxisSize.min is no longer strictly necessary 
                          // since the Container has a fixed width, but it doesn't hurt.
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 18,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            const SizedBox(width: 4),
                            // Expanded is the secret sauce for text overflow
                            Expanded(
                              child: GestureDetector(
                                onTap: () => openMap(
                                  salon.contacts.location?.lat ?? 0,
                                  salon.contacts.location?.lng ?? 0,
                                ),
                                child: Text(
                                  salon.contacts.location?.address ?? "No Address",
                                  // Handles the "..." at the end
                                  overflow: TextOverflow.ellipsis, 
                                  maxLines: 1,
                                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                        decorationThickness: 5,
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
          
                      if (salon.contacts.location != null &&
                          (salon.contacts.location!.lat != 0 ||
                              salon.contacts.location!.lng != 0)) ...[
                        const SizedBox(height: 16),
                        _SalonMapView(
                          currentSalonId: salon.salon.id,
                          lat: salon.contacts.location!.lat,
                          lng: salon.contacts.location!.lng,
                        ),
                      ],

                      const SizedBox(height: 16),

                      // SOFT CTA
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {
                          _showSalonServicesSheet(context, salon);
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
                child: salon.media.gallery.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: Text('No visuals uploaded')),
                  )
                : SizedBox(
                    height: 190, // Portfolio feel
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: salon.media.gallery.length,
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
                                imageUrl: salon.media.gallery[i].imageUrl,
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
                  onPressed: () => _showSalonServicesSheet(context, salon),
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
                        Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                    tabs: const [
                      Tab(
                        icon: Icon(Bootstrap.grid_3x3_gap_fill),
                        text: 'Grid',
                      ),
                      Tab(
                        icon: Icon(Bootstrap.view_stacked),
                        text: 'Posts',
                      ),
                      Tab(
                        icon: Icon(Bootstrap.activity),
                        text: 'Activity',
                      ),
                    ],
                  ),
                ),
              ),
          
            //   if (_selectedTabIndex == 0)
            //     UniversalPostGrid(posts: const [], onPostTap: (post) => print(post))
            //   else if (_selectedTabIndex == 1)
            //     SliverList(
            //       delegate: SliverChildBuilderDelegate(
            //         (_, i) => Post(
            //           postId: 'postId_$i',
            //           isLiked: false,
            //           aspectRatio: 1,
            //           username: salon.salon.username,
            //           profileImage: salon.salon.profilePicture,
            //           images: [salon.salon.coverImage],
            //           likesCount: 100,
            //           sharesCount: 50,
            //           commentsCount: 20,
            //           description: 'Salon highlight',
            //           datePosted: 'Today',
            //         ),
            //         childCount: 3,
            //       ),
            //     ),
          
            //     // Loading Spinner at the bottom
            //     if (isLoadingMore)
            //       const SliverToBoxAdapter(
            //         child: Padding(
            //           padding: EdgeInsets.symmetric(vertical: 20),
            //           child: Center(child: CircularProgressIndicator()),
            //         ),
            //       ),
            // ],
              if (_selectedTabIndex == 2)
                activityState.when(
                  loading: () => const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (e, _) => SliverToBoxAdapter(
                    child: Center(child: Text('Error: $e')),
                  ),
                  data: (items) {
                    if (items.isEmpty) {
                      return const SliverFillRemaining(
                        child: Center(child: Text('No recent activity')),
                      );
                    }
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) =>
                            ActivityFeedTile(item: items[index]),
                        childCount: items.length,
                      ),
                    );
                  },
                )
              else
              postsState.when(
                loading: () => const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => SliverToBoxAdapter(
                  child: Center(child: Text('Error: $e')),
                ),
                data: (posts) {
                  if (posts.isEmpty) {
                    return const SliverFillRemaining(
                      child: Center(child: Text('No posts yet')),
                    );
                  }

                  if (_selectedTabIndex == 0) {
                    // GRID TAB
                    return UniversalPostGrid(
                      posts: posts,
                      onPostTap: (post) {
                        // Logic to navigate or switch to List view
                      },
                    );
                  } else {
                    // LIST TAB
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final post = posts[index];
                          return Post(
                            postId: post.id,
                            aspectRatio: post.media.first.aspectRatio,
                            username: post.author.username,
                            profileImage: post.author.profilePicture,
                            images: post.media.map((m) => m.url).toList(),
                            likesCount: post.stats.likes,
                            isLiked: post.viewerState.isLiked,
                            sharesCount: post.stats.shares,
                            commentsCount: post.stats.comments,
                            description: post.caption,
                            datePosted: post.createdAt,
                          );
                        },
                        childCount: posts.length,
                      ),
                    );
                  }
                },
              ),
          
              // 3. PAGINATION SPINNER
              if ((_selectedTabIndex == 2 && activityNotifier.isLoadingMore) ||
                  (_selectedTabIndex != 2 &&
                      postsState.isLoading &&
                      postsState.hasValue))
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
            ],
          ),
        ),
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

// ── Embedded OpenStreetMap tile map ───────────────────────────────────────────

class _SalonMapView extends ConsumerWidget {
  /// The salon currently being viewed.
  final String currentSalonId;
  final double lat;
  final double lng;

  const _SalonMapView({
    required this.currentSalonId,
    required this.lat,
    required this.lng,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final center = LatLng(lat, lng);
    final nearbyAsync = ref.watch(
      nearbySalonsAtProvider((lat: lat, lng: lng)),
    );

    // Build markers for nearby salons (excluding the one being viewed)
    final nearbyMarkers = nearbyAsync.whenOrNull(
      data: (items) => items
          .where((s) => s.id != currentSalonId && s.lat != null && s.lng != null)
          .map(
            (s) => Marker(
              point: LatLng(s.lat!, s.lng!),
              width: 32,
              height: 32,
              child: GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ViewServiceProfilePage(salonId: s.id),
                  ),
                ),
                child: const Icon(Icons.location_pin, color: Colors.orange, size: 32),
              ),
            ),
          )
          .toList(),
    ) ?? [];

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 200,
        child: Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                initialCenter: center,
                initialZoom: 14,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.pinchZoom | InteractiveFlag.doubleTapZoom,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.africa_beuty.app',
                ),
                MarkerLayer(
                  markers: [
                    // Other nearby salons (orange)
                    ...nearbyMarkers,
                    // Current salon (red, on top)
                    Marker(
                      point: center,
                      width: 44,
                      height: 44,
                      child: const Icon(Icons.location_pin, color: Colors.red, size: 44),
                    ),
                  ],
                ),
              ],
            ),

            // "Get directions" button
            Positioned(
              bottom: 10,
              right: 10,
              child: GestureDetector(
                onTap: () {
                  final uri = Uri.parse(
                    'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving',
                  );
                  launchUrl(uri, mode: LaunchMode.externalApplication);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.directions, color: Colors.white, size: 14),
                      SizedBox(width: 5),
                      Text(
                        'Get directions',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Legend: nearby count
            if (nearbyMarkers.isNotEmpty)
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.location_pin, color: Colors.orange, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        '${nearbyMarkers.length} nearby salon${nearbyMarkers.length == 1 ? '' : 's'}',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}