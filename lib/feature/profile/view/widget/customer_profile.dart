import 'package:africa_beuty/core/widgets/activity_feed.dart';
import 'package:africa_beuty/core/widgets/grid_widget.dart';
import 'package:africa_beuty/feature/post/view/page/single_post.dart';
import 'package:africa_beuty/feature/profile/view/widget/setting.dart';
import 'package:africa_beuty/feature/profile/view/widget/three_dots.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class CustomerProfileSliverWidget extends StatefulWidget {
  const CustomerProfileSliverWidget({super.key});

  @override
  State<CustomerProfileSliverWidget> createState() => _CustomerProfileSliverWidgetState();
}

class _CustomerProfileSliverWidgetState extends State<CustomerProfileSliverWidget>
    with SingleTickerProviderStateMixin {
  static const kExpandedHeight = kToolbarHeight + 270;

  // Control scrolls in the slivers
  late ScrollController _scrollController;

  // Page controller for PageView
  final PageController _pageController = PageController();

  // Tab controller for TabBar
  late TabController _tabController;

  // Initialize the scroll controller and tab controller
  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {});
      });

    // Initialize the TabController
    _tabController = TabController(length: 3, vsync: this);

    // Sync TabController with PageView
    _pageController.addListener(() {
      if (_pageController.page!.round() != _tabController.index) {
        _tabController.index = _pageController.page!.round();
      }
    });
  }

  // Dispose the scroll controller, page controller, and tab controller
  @override
  void dispose() {
    _scrollController.dispose();
    _pageController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  // Check if the appBar is expanded
  bool get _isSliverAppBarExpanded {
    return _scrollController.hasClients &&
        _scrollController.offset > (kExpandedHeight - kToolbarHeight);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Top SliverAppBar with flexible space
          SliverAppBar(
            floating: false,
            pinned: true,
            collapsedHeight: size.height * .12,
            expandedHeight: size.height * .45,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                // bottomLeft: Radius.circular(20),
                // bottomRight: Radius.circular(20),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.all(10),
              title: _isSliverAppBarExpanded
                  ? Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          foregroundImage: AssetImage(
                            'assets/images/dp.jpg', 
                          ), 
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Username',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    )
                  : null,
              background: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0.5, 0.5),
                    radius: 1.0,
                    colors: [Colors.brown.shade400, Colors.blueGrey.shade500],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 50.0,
                          foregroundImage: AssetImage(
                            'assets/images/dp.jpg', 
                          ), 
                        ),
                        const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: size.width * .65,
                              child: Text(
                                'Name of the customer to be here',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.headlineSmall,
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: size.width * .6,
                              child: Text(
                                'Username of the customer will be here',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SettingAccount(isCustomer: true),
                        SizedBox(width: 10),
                        ThreeDotsOptions(isCustomer: true),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Second SliverAppBar with TabBar
          SliverAppBar(
            pinned: true,
            automaticallyImplyLeading: false,
            toolbarHeight: 45.0,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(5.0),
              child: TabBar(
                controller: _tabController, // Connect TabBar to TabController
                labelPadding: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                onTap: (index) {
                  // Sync TabBar with PageView
                  _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                tabs: const [
                  Tab(icon: Icon(Bootstrap.grid_3x3_gap_fill),),
                  Tab(icon: Icon(Bootstrap.view_stacked)),
                  Tab(icon: Icon(Bootstrap.list_task)),
                ],
              ),
            ),
          ),

          // SliverFillRemaining with PageView
          SliverFillRemaining(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                // Sync PageView with TabBar
                _tabController.index = index;
              },
              children: [
                Container(
                  child: UniversalPostGrid(posts: const [], onPostTap: (post) => print(post)),
                ),
                Container(
                  padding: const EdgeInsets.all(1),
                  child: ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Post(
                        postId: 'postId_$index',
                        isLiked: false,
                        aspectRatio: 1,
                        username: 'user123',
                        profileImage: 'assets/images/dp.jpg',
                        images: ['assets/images/dp.jpg'],
                        likesCount: 1400,
                        sharesCount: 1200,
                        commentsCount: 450,
                        description: 'This is a sample post description, showcasing how to pass dynamic data to the Post widget.',
                        datePosted: '12/02/2025 18:12:32',
                      );
                    }
                  )
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return ActivityFeed();
                    }
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