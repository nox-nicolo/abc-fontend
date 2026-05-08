import 'package:flutter/material.dart';

class SingleChatPage extends StatefulWidget {
  const SingleChatPage({
    super.key,
    required this.contactName,
    required this.accentColor,
    required this.avatarLabel,
    required this.isOnline,
  });

  final String contactName;
  final Color accentColor;
  final String avatarLabel;
  final bool isOnline;

  @override
  State<SingleChatPage> createState() => _SingleChatPageState();
}

class _SingleChatPageState extends State<SingleChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<_ChatMessage> _messages = <_ChatMessage>[
    const _ChatMessage(
      text:
          'Welcome back. We prepared your premium styling timeline for this week.',
      isMine: false,
      time: '09:12',
    ),
    const _ChatMessage(
      text: 'Perfect. I want a polished, soft glam finish for the event.',
      isMine: true,
      time: '09:14',
    ),
    const _ChatMessage(
      text:
          'That works beautifully. We recommend hydration prep, silk press, and a finishing glow treatment.',
      isMine: false,
      time: '09:16',
    ),
    const _ChatMessage(
      text: 'Please keep the appointment and share the prep checklist with me.',
      isMine: true,
      time: '09:18',
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final scheme = theme.colorScheme;
    return Scaffold(
      backgroundColor: scheme.surface,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              widget.accentColor.withValues(alpha: 0.22),
              scheme.surface,
              scheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: scheme.surface.withValues(alpha: 0.82),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: scheme.outline.withValues(alpha: 0.3)),
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                        color: Color(0x12000000),
                        blurRadius: 24,
                        offset: Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Row(
                    children: <Widget>[
                      _CircleIconButton(
                        icon: Icons.arrow_back_ios_new_rounded,
                        onTap: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: <Color>[
                              widget.accentColor,
                              widget.accentColor.withOpacity(0.72),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          widget.avatarLabel,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget.contactName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: <Widget>[
                                Container(
                                  height: 8,
                                  width: 8,
                                  decoration: BoxDecoration(
                                    color: widget.isOnline
                                        ? const Color(0xFF42B883)
                                        : const Color(0xFFC4B8AC),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  widget.isOnline
                                      ? 'Online now'
                                      : 'Replies within 15 mins',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: scheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const _CircleIconButton(icon: Icons.call_outlined),
                      const SizedBox(width: 8),
                      const _CircleIconButton(icon: Icons.more_horiz_rounded),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      colors: <Color>[
                        scheme.surface,
                        widget.accentColor.withValues(alpha: 0.08),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: Border.all(color: scheme.outlineVariant),
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Next appointment',
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Friday, 4:30 PM',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Bridal prep and glow finish session',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: scheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.event_available_rounded),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                  itemCount: _messages.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return Center(
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 18),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: scheme.surfaceContainerHighest.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            'Today',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      );
                    }

                    final message = _messages[index - 1];
                    final alignment = message.isMine
                        ? Alignment.centerRight
                        : Alignment.centerLeft;
                    final bubbleColor = message.isMine
                        ? scheme.onSurface
                        : scheme.surfaceContainerHighest;

                    return Align(
                      alignment: alignment,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.78,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: bubbleColor,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(22),
                            topRight: const Radius.circular(22),
                            bottomLeft: Radius.circular(
                              message.isMine ? 22 : 8,
                            ),
                            bottomRight: Radius.circular(
                              message.isMine ? 8 : 22,
                            ),
                          ),
                          boxShadow: const <BoxShadow>[
                            BoxShadow(
                              color: Color(0x10000000),
                              blurRadius: 18,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              message.text,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: message.isMine
                                    ? scheme.surface
                                    : scheme.onSurface,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              message.time,
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: message.isMine
                                    ? scheme.surface.withValues(alpha: 0.7)
                                    : scheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: scheme.surface.withValues(alpha: 0.96),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                        color: Color(0x14000000),
                        blurRadius: 24,
                        offset: Offset(0, 14),
                      ),
                    ],
                  ),
                  child: Row(
                    children: <Widget>[
                      const _CircleIconButton(icon: Icons.add_rounded),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) => _sendMessage(),
                          decoration: const InputDecoration(
                            hintText: 'Write a message...',
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            filled: false,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: <Color>[
                              widget.accentColor,
                              const Color(0xFF2D221C),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: IconButton(
                          onPressed: _sendMessage,
                          icon: const Icon(
                            Icons.arrow_upward_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) {
      return;
    }

    setState(() {
      _messages.add(
        _ChatMessage(
          text: text,
          isMine: true,
          time: TimeOfDay.now().format(context),
        ),
      );
      _messageController.clear();
    });
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF5EFE8),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(height: 42, width: 42, child: Icon(icon, size: 20)),
      ),
    );
  }
}

class _ChatMessage {
  const _ChatMessage({
    required this.text,
    required this.isMine,
    required this.time,
  });

  final String text;
  final bool isMine;
  final String time;
}
