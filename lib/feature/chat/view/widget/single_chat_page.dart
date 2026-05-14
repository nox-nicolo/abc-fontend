import 'package:africa_beuty/core/providers/user_provider.dart';
import 'package:africa_beuty/feature/chat/model/chat.dart';
import 'package:africa_beuty/feature/chat/provider/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class SingleChatPage extends ConsumerStatefulWidget {
  const SingleChatPage({
    super.key,
    this.conversationId,
    this.salonId,
    this.initialTitle,
  }) : assert(conversationId != null || salonId != null);

  final String? conversationId;
  final String? salonId;
  final String? initialTitle;

  @override
  ConsumerState<SingleChatPage> createState() => _SingleChatPageState();
}

class _SingleChatPageState extends ConsumerState<SingleChatPage> {
  final _messageController = TextEditingController();
  String? _conversationId;
  bool _starting = false;
  bool _sending = false;
  String? _startError;

  @override
  void initState() {
    super.initState();
    _conversationId = widget.conversationId;
    if (_conversationId == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _start());
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _start() async {
    final salonId = widget.salonId;
    if (salonId == null || _starting) return;

    setState(() {
      _starting = true;
      _startError = null;
    });

    final result = await ref
        .read(chatRepositoryProvider)
        .startConversation(salonId);
    if (!mounted) return;

    result.fold(
      (failure) {
        setState(() {
          _starting = false;
          _startError = failure.message;
        });
      },
      (conversation) {
        setState(() {
          _conversationId = conversation.id;
          _starting = false;
        });
        ref.invalidate(chatConversationsProvider);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final conversationId = _conversationId;

    if (conversationId == null) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.initialTitle ?? 'Chat')),
        body: Center(
          child: _startError == null
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_startError!, textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: _starting ? null : _start,
                      child: const Text('Try again'),
                    ),
                  ],
                ),
        ),
      );
    }

    final threadState = ref.watch(chatThreadProvider(conversationId));
    final role = ref.watch(currentUserProvider)?.role;
    final isCustomer = role == 'customer' || role == null;

    return Scaffold(
      appBar: AppBar(
        title: threadState.maybeWhen(
          data: (thread) => Text(
            isCustomer
                ? thread.conversation.salonName
                : thread.conversation.customerName,
          ),
          orElse: () => Text(widget.initialTitle ?? 'Chat'),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: threadState.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text(error.toString())),
              data: (thread) => _MessageList(messages: thread.items),
            ),
          ),
          _Composer(
            controller: _messageController,
            sending: _sending,
            onSend: () => _send(conversationId),
          ),
        ],
      ),
    );
  }

  Future<void> _send(String conversationId) async {
    final body = _messageController.text.trim();
    if (body.isEmpty || _sending) return;

    setState(() => _sending = true);
    final result = await ref
        .read(chatRepositoryProvider)
        .sendMessage(conversationId: conversationId, body: body);
    if (!mounted) return;

    result.fold(
      (failure) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(failure.message)));
      },
      (_) {
        _messageController.clear();
        ref.invalidate(chatThreadProvider(conversationId));
        ref.invalidate(chatConversationsProvider);
      },
    );
    setState(() => _sending = false);
  }
}

class _MessageList extends StatelessWidget {
  const _MessageList({required this.messages});

  final List<ChatMessage> messages;

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) {
      return const Center(child: Text('Start the conversation'));
    }

    return ListView.builder(
      reverse: true,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 20),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[messages.length - index - 1];
        return _MessageBubble(message: message);
      },
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isMine = message.isMine;
    final isBooking = message.messageType.startsWith('booking_');

    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.78,
        ),
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: isMine ? scheme.primary : scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMine ? 16 : 4),
            bottomRight: Radius.circular(isMine ? 4 : 16),
          ),
          border: isBooking
              ? Border.all(
                  color: isMine ? scheme.onPrimary : scheme.primary,
                  width: 0.8,
                )
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isBooking) ...[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.event_available,
                    size: 16,
                    color: isMine ? scheme.onPrimary : scheme.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Booking',
                    style: TextStyle(
                      color: isMine ? scheme.onPrimary : scheme.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
            ],
            Text(
              message.body,
              style: TextStyle(
                color: isMine ? scheme.onPrimary : scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('HH:mm').format(message.createdAt),
              style: TextStyle(
                color: (isMine ? scheme.onPrimary : scheme.onSurfaceVariant)
                    .withValues(alpha: 0.68),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  const _Composer({
    required this.controller,
    required this.sending,
    required this.onSend,
  });

  final TextEditingController controller;
  final bool sending;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                minLines: 1,
                maxLines: 4,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
                decoration: const InputDecoration(
                  hintText: 'Write a message...',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              tooltip: 'Send',
              onPressed: sending ? null : onSend,
              icon: sending
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }
}
