import 'package:africa_beuty/core/providers/user_provider.dart';
import 'package:africa_beuty/core/widgets/app_state.dart';
import 'package:africa_beuty/feature/chat/model/chat.dart';
import 'package:africa_beuty/feature/chat/provider/chat_provider.dart';
import 'package:africa_beuty/feature/chat/view/widget/single_chat_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ChatsPage extends ConsumerWidget {
  const ChatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(chatConversationsProvider);
    final role = ref.watch(currentUserProvider)?.role;
    final isCustomer = role == 'customer' || role == null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: () => ref.invalidate(chatConversationsProvider),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(chatConversationsProvider),
        child: state.when(
          loading: () => const AppLoadingState(),
          error: (error, _) => ListView(
            children: [
              SizedBox(height: MediaQuery.sizeOf(context).height * 0.16),
              AppErrorState(
                message: error,
                onRetry: () => ref.invalidate(chatConversationsProvider),
              ),
            ],
          ),
          data: (items) {
            if (items.isEmpty) {
              return ListView(
                children: const [
                  SizedBox(height: 120),
                  AppEmptyState(
                    icon: Icons.chat_bubble_outline_rounded,
                    title: 'No messages yet',
                    message: 'Your conversations will appear here.',
                  ),
                ],
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: items.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final chat = items[index];
                return _ConversationTile(
                  conversation: chat,
                  isCustomer: isCustomer,
                  onTap: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => SingleChatPage(conversationId: chat.id),
                      ),
                    );
                    ref.invalidate(chatConversationsProvider);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  const _ConversationTile({
    required this.conversation,
    required this.isCustomer,
    required this.onTap,
  });

  final ChatConversation conversation;
  final bool isCustomer;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final name = isCustomer
        ? conversation.salonName
        : conversation.customerName;
    final avatar = isCustomer
        ? conversation.salonAvatar
        : conversation.customerAvatar;
    final preview = conversation.lastMessagePreview ?? 'Start conversation';

    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundImage: avatar == null ? null : NetworkImage(avatar),
        child: avatar == null ? Text(_initials(name)) : null,
      ),
      title: Text(
        name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
      subtitle: Text(preview, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (conversation.lastMessageAt != null)
            Text(
              DateFormat('HH:mm').format(conversation.lastMessageAt!),
              style: Theme.of(context).textTheme.labelSmall,
            ),
          if (conversation.unreadCount > 0) ...[
            const SizedBox(height: 6),
            Badge(label: Text('${conversation.unreadCount}')),
          ],
        ],
      ),
    );
  }

  String _initials(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return '?';
    return trimmed.characters.first.toUpperCase();
  }
}
