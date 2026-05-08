import 'package:africa_beuty/feature/chat/view/widget/single_chat_page.dart';
import 'package:flutter/material.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';

  static const List<String> _filters = <String>[
    'All',
    'Unread',
    'Booked',
    'Archived',
  ];

  final List<_ChatPreview> _chats = <_ChatPreview>[
    const _ChatPreview(
      name: 'Amina Luxe Studio',
      message: 'Your bridal trial is confirmed for Friday at 4:30 PM.',
      time: '2m',
      unreadCount: 2,
      isPinned: true,
      isOnline: true,
      accentColor: Color(0xFFD98F70),
      category: 'Booked',
      avatarLabel: 'AL',
    ),
    const _ChatPreview(
      name: 'Nia Beauty Concierge',
      message: 'We shortlisted 3 premium stylists that match your vibe.',
      time: '18m',
      unreadCount: 0,
      isPinned: true,
      isOnline: false,
      accentColor: Color(0xFF7AA7A2),
      category: 'All',
      avatarLabel: 'NB',
    ),
    const _ChatPreview(
      name: 'Zuri Braids House',
      message: 'Come 15 minutes early so we can prep your scalp treatment.',
      time: '9:24',
      unreadCount: 1,
      isPinned: false,
      isOnline: true,
      accentColor: Color(0xFFB58ED3),
      category: 'Unread',
      avatarLabel: 'ZH',
    ),
    const _ChatPreview(
      name: 'Glow Rituals',
      message: 'Thanks for visiting us. Your aftercare guide is ready.',
      time: 'Tue',
      unreadCount: 0,
      isPinned: false,
      isOnline: false,
      accentColor: Color(0xFFE2B95B),
      category: 'Archived',
      avatarLabel: 'GR',
    ),
    const _ChatPreview(
      name: 'Makeda Signature Salon',
      message: 'We can move your silk press to 11:00 AM if that helps.',
      time: 'Mon',
      unreadCount: 0,
      isPinned: false,
      isOnline: true,
      accentColor: Color(0xFF6F8EF6),
      category: 'Booked',
      avatarLabel: 'MS',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final query = _searchController.text.trim().toLowerCase();

    final filteredChats = _chats.where((chat) {
      final matchesFilter =
          _selectedFilter == 'All' || chat.category == _selectedFilter;
      final matchesQuery =
          query.isEmpty ||
          chat.name.toLowerCase().contains(query) ||
          chat.message.toLowerCase().contains(query);
      return matchesFilter && matchesQuery;
    }).toList();

    final pinned = filteredChats.where((chat) => chat.isPinned).toList();
    final recent = filteredChats.where((chat) => !chat.isPinned).toList();
    final unreadTotal = _chats.fold<int>(
      0,
      (sum, chat) => sum + chat.unreadCount,
    );

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              colorScheme.surfaceContainerHighest,
              colorScheme.surface,
              colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Messages',
                                  style: theme.textTheme.headlineMedium
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Keep bookings, style notes, and salon updates in one premium inbox.',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 48,
                            width: 48,
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.82),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: const <BoxShadow>[
                                BoxShadow(
                                  color: Color(0x14000000),
                                  blurRadius: 20,
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                            child: const Icon(Icons.edit_outlined),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          gradient: const LinearGradient(
                            colors: <Color>[
                              Color(0xFF2D221C),
                              Color(0xFF4B352A),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: const <BoxShadow>[
                            BoxShadow(
                              color: Color(0x26000000),
                              blurRadius: 28,
                              offset: Offset(0, 18),
                            ),
                          ],
                        ),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    '$unreadTotal unread conversations',
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Your premium beauty support line is active with live salon replies.',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: Colors.white70,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.12),
                                ),
                              ),
                              child: Column(
                                children: <Widget>[
                                  const Icon(
                                    Icons.auto_awesome_rounded,
                                    color: Color(0xFFF1C78A),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'VIP',
                                    style: theme.textTheme.labelLarge?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      TextField(
                        controller: _searchController,
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search_rounded),
                          hintText: 'Search salons, bookings, or beauty notes',
                          suffixIcon: Container(
                            margin: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              Icons.tune_rounded,
                              color: colorScheme.primary,
                            ),
                          ),
                          filled: true,
                          fillColor: colorScheme.surface.withValues(alpha: 0.92),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(22),
                            borderSide: BorderSide(
                              color: colorScheme.outlineVariant,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(22),
                            borderSide: BorderSide(
                              color: colorScheme.primary,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 48,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      final filter = _filters[index];
                      final isSelected = _selectedFilter == filter;
                      return ChoiceChip(
                        label: Text(filter),
                        selected: isSelected,
                        onSelected: (_) {
                          setState(() {
                            _selectedFilter = filter;
                          });
                        },
                        labelStyle: theme.textTheme.labelLarge?.copyWith(
                          color: isSelected
                              ? colorScheme.onPrimary
                              : colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                        selectedColor: colorScheme.primary,
                        backgroundColor: colorScheme.surface,
                        surfaceTintColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: isSelected
                                ? colorScheme.primary
                                : colorScheme.outlineVariant,
                          ),
                        ),
                        showCheckmark: false,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                      );
                    },
                    separatorBuilder: (_, _) => const SizedBox(width: 10),
                    itemCount: _filters.length,
                  ),
                ),
              ),
              if (pinned.isNotEmpty)
                SliverToBoxAdapter(
                  child: _SectionLabel(
                    title: 'Pinned',
                    actionText: 'Priority inbox',
                  ),
                ),
              if (pinned.isNotEmpty)
                SliverList.builder(
                  itemCount: pinned.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _ChatCard(
                      chat: pinned[index],
                      onTap: () => _openChat(context, pinned[index]),
                    );
                  },
                ),
              SliverToBoxAdapter(
                child: _SectionLabel(
                  title: pinned.isEmpty ? 'Conversations' : 'Recent',
                  actionText: '${filteredChats.length} active',
                ),
              ),
              if (recent.isEmpty && pinned.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            height: 84,
                            width: 84,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              shape: BoxShape.circle,
                              boxShadow: const <BoxShadow>[
                                BoxShadow(
                                  color: Color(0x14000000),
                                  blurRadius: 24,
                                  offset: Offset(0, 12),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.chat_bubble_outline_rounded,
                              size: 34,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            'No chats match this filter yet',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try a different filter or search term to find your latest conversation.',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                SliverList.builder(
                  itemCount: recent.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _ChatCard(
                      chat: recent[index],
                      onTap: () => _openChat(context, recent[index]),
                    );
                  },
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 28)),
            ],
          ),
        ),
      ),
    );
  }

  void _openChat(BuildContext context, _ChatPreview chat) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SingleChatPage(
          contactName: chat.name,
          accentColor: chat.accentColor,
          avatarLabel: chat.avatarLabel,
          isOnline: chat.isOnline,
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.title, required this.actionText});

  final String title;
  final String actionText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
      child: Row(
        children: <Widget>[
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          Text(
            actionText,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatCard extends StatelessWidget {
  const _ChatCard({required this.chat, required this.onTap});

  final _ChatPreview chat;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: Ink(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: theme.colorScheme.outlineVariant),
              boxShadow: const <BoxShadow>[
                BoxShadow(
                  color: Color(0x12000000),
                  blurRadius: 22,
                  offset: Offset(0, 14),
                ),
              ],
            ),
            child: Row(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      height: 58,
                      width: 58,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: <Color>[
                            chat.accentColor,
                            chat.accentColor.withValues(alpha: 0.72),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        chat.avatarLabel,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (chat.isOnline)
                      Positioned(
                        right: 2,
                        bottom: 2,
                        child: Container(
                          height: 14,
                          width: 14,
                          decoration: BoxDecoration(
                            color: const Color(0xFF42B883),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              chat.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          if (chat.isPinned)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: chat.accentColor.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                'Pinned',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: chat.accentColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 7),
                      Text(
                        chat.message,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      chat.time,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 14),
                    if (chat.unreadCount > 0)
                      Container(
                        height: 24,
                        constraints: const BoxConstraints(minWidth: 24),
                        padding: const EdgeInsets.symmetric(horizontal: 7),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1F7A5C),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${chat.unreadCount}',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      )
                    else
                      const Icon(
                        Icons.done_all_rounded,
                        color: Color(0xFF9CB3AA),
                        size: 20,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChatPreview {
  const _ChatPreview({
    required this.name,
    required this.message,
    required this.time,
    required this.unreadCount,
    required this.isPinned,
    required this.isOnline,
    required this.accentColor,
    required this.category,
    required this.avatarLabel,
  });

  final String name;
  final String message;
  final String time;
  final int unreadCount;
  final bool isPinned;
  final bool isOnline;
  final Color accentColor;
  final String category;
  final String avatarLabel;
}
