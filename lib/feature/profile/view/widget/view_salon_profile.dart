import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class ViewServiceProfilePage extends StatefulWidget {
  const ViewServiceProfilePage({super.key});

  @override
  State<ViewServiceProfilePage> createState() =>
      _ViewServiceProfilePageState();
}

class _ViewServiceProfilePageState extends State<ViewServiceProfilePage>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late TabController _tabController;

  static const kExpandedHeight = kToolbarHeight + 270;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  bool get _isCollapsed =>
      _scrollController.hasClients &&
      _scrollController.offset > kExpandedHeight - kToolbarHeight;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          // 🔹 HEADER
          SliverAppBar(
            pinned: true,
            expandedHeight: size.height * .45,
            collapsedHeight: size.height * .12,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.all(10),
              title: _isCollapsed
                  ? Row(
                      children: const [
                        CircleAvatar(radius: 18),
                        SizedBox(width: 10),
                        Text('Salon Name'),
                        Spacer(),
                        Text('Book Now'),
                      ],
                    )
                  : null,
              background: _ServiceProfileHeader(size: size),
            ),
          ),

          // 🔹 BIO
          const _SectionTitle(title: 'Bio'),
          const _ServiceBio(),

          // 🔹 LOCATION
          const _SectionTitle(title: 'Location'),
          const _Placeholder(height: 120, label: 'Map'),

          // 🔹 SERVICES
          const _SectionTitle(title: 'Services Offered'),
          const _HorizontalPlaceholder(label: 'Services'),

          // 🔹 POSTS / MEDIA
          const _SectionTitle(title: 'Posts'),
          SliverPersistentHeader(
            pinned: true,
            delegate: _TabHeaderDelegate(_tabController),
          ),
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: const [
                _Placeholder(label: 'Media Grid'),
                _Placeholder(label: 'Categories'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class _ServiceProfileHeader extends StatelessWidget {
  final Size size;
  const _ServiceProfileHeader({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [Colors.brown.shade400, Colors.blueGrey.shade500],
        ),
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            children: [
              const CircleAvatar(radius: 50),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Salon Name', style: TextStyle(fontSize: 20)),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(OctIcons.verified, size: 14, color: Colors.blue),
                      SizedBox(width: 5),
                      Text('@salonusername'),
                    ],
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}



class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  final String label;
  final double height;

  const _Placeholder({
    required this.label,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: height,
        margin: const EdgeInsets.all(16),
        color: Colors.grey.shade300,
        child: Center(child: Text(label)),
      ),
    );
  }
}

class _HorizontalPlaceholder extends StatelessWidget {
  final String label;
  const _HorizontalPlaceholder({required this.label});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 5,
          itemBuilder: (_, __) => Container(
            width: 140,
            margin: const EdgeInsets.all(8),
            color: Colors.grey.shade300,
            child: Center(child: Text(label)),
          ),
        ),
      ),
    );
  }
}

class _TabHeaderDelegate extends SliverPersistentHeaderDelegate {
  final TabController controller;
  _TabHeaderDelegate(this.controller);

  @override
  Widget build(_, __, ___) {
    return TabBar(
      controller: controller,
      tabs: const [
        Tab(text: 'Media'),
        Tab(text: 'Category'),
      ],
    );
  }

  @override
  double get maxExtent => 48;
  @override
  double get minExtent => 48;
  @override
  bool shouldRebuild(_) => false;
}


class _ServiceBio extends StatelessWidget {
  const _ServiceBio();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This is the salon bio. A short description about the salon, '
              'its style, specialty, and vibe. Keep it clean, simple, '
              'and readable for users.',
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  'Rated 4.5',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(width: 6),
                Icon(
                  Icons.star,
                  size: 18,
                  color: Colors.amber.shade600,
                ),
                const Spacer(),
                Icon(
                  Icons.chat_bubble_outline,
                  size: 28,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
