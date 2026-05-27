import 'package:africa_beuty/core/utils/api_datetime.dart';
import 'package:africa_beuty/core/utils/image_url.dart';

class ChatConversation {
  final String id;
  final String customerId;
  final String customerName;
  final String? customerAvatar;
  final String salonId;
  final String salonName;
  final String? salonAvatar;
  final String? lastMessagePreview;
  final String? lastMessageType;
  final DateTime? lastMessageAt;
  final int unreadCount;

  const ChatConversation({
    required this.id,
    required this.customerId,
    required this.customerName,
    this.customerAvatar,
    required this.salonId,
    required this.salonName,
    this.salonAvatar,
    this.lastMessagePreview,
    this.lastMessageType,
    this.lastMessageAt,
    required this.unreadCount,
  });

  factory ChatConversation.fromMap(Map<String, dynamic> map) {
    return ChatConversation(
      id: map['id'] ?? '',
      customerId: map['customer_id'] ?? '',
      customerName: map['customer_name'] ?? 'Customer',
      customerAvatar: resolveImageUrl(map['customer_avatar']),
      salonId: map['salon_id'] ?? '',
      salonName: map['salon_name'] ?? 'Salon',
      salonAvatar: resolveImageUrl(map['salon_avatar']),
      lastMessagePreview: map['last_message_preview'],
      lastMessageType: map['last_message_type'],
      lastMessageAt: map['last_message_at'] == null
          ? null
          : parseApiDateTime(map['last_message_at']),
      unreadCount: map['unread_count'] ?? 0,
    );
  }
}

class ChatMessage {
  final String id;
  final String conversationId;
  final String? senderUserId;
  final String senderRole;
  final String messageType;
  final String body;
  final String? bookingId;
  final bool createdBySystem;
  final bool isMine;
  final DateTime? readAt;
  final DateTime createdAt;

  const ChatMessage({
    required this.id,
    required this.conversationId,
    this.senderUserId,
    required this.senderRole,
    required this.messageType,
    required this.body,
    this.bookingId,
    required this.createdBySystem,
    required this.isMine,
    this.readAt,
    required this.createdAt,
  });

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'] ?? '',
      conversationId: map['conversation_id'] ?? '',
      senderUserId: map['sender_user_id'],
      senderRole: map['sender_role'] ?? '',
      messageType: map['message_type'] ?? 'text',
      body: map['body'] ?? '',
      bookingId: map['booking_id'],
      createdBySystem: map['created_by_system'] ?? false,
      isMine: map['is_mine'] ?? false,
      readAt: map['read_at'] == null ? null : parseApiDateTime(map['read_at']),
      createdAt: parseApiDateTime(map['created_at']),
    );
  }
}

class ChatThread {
  final ChatConversation conversation;
  final List<ChatMessage> items;

  const ChatThread({required this.conversation, required this.items});

  factory ChatThread.fromMap(Map<String, dynamic> map) {
    return ChatThread(
      conversation: ChatConversation.fromMap(map['conversation'] ?? {}),
      items: (map['items'] as List<dynamic>? ?? [])
          .map((e) => ChatMessage.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
