import 'package:message/core/services/socket_services.dart';
import 'package:message/features/chat/models/message_model.dart';
import 'package:message/features/chat/state/chat_screen_state.dart';
import 'package:message/features/home/state/home_screen_state.dart';

class SocketController {
  final HomeScreenState _homeScreenState;
  final ChatScreenState _chatScreenState;
  final SocketService _socketService;

  SocketController(
    this._homeScreenState,
    this._chatScreenState,
    this._socketService,
  ) {
    _socketService.onNewMessage = _handleNewMessage;
    _socketService.onMessageReceived = _handleMessageReceived;
    _socketService.onMessageSeen = _handleMessageSeen;
    _socketService.onUserOnline = _handleUserOnline;
    _socketService.onUserOffline = _handleUserOffline;
    _socketService.onTyping = _handleTyping;
    _socketService.onTypingStopped = _handleTypingStopped;
  }

  void _handleUserOnline(dynamic data) {
    _handlePresence(data, online: true);
  }

  void _handleUserOffline(dynamic data) {
    _handlePresence(data, online: false);
  }

  void _handlePresence(dynamic data, {required bool online}) {
    if (data == null || data is! Map) return;

    final userId = data['userId']?.toString();
    if (userId == null || userId.isEmpty) return;

    final rawLastSeen = data['lastSeen'];
    final lastSeen = rawLastSeen is String
        ? DateTime.tryParse(rawLastSeen)
        : rawLastSeen is DateTime
        ? rawLastSeen
        : null;
    _homeScreenState.updateChatPresence(
      userId,
      online: online,
      lastSeen: lastSeen,
    );
    _chatScreenState.setPresence(userId, online: online, lastSeen: lastSeen);
  }

  void _handleTyping(dynamic data) {
    if (data == null || data is! Map) return;

    final senderId = data['senderId']?.toString();
    if (senderId == null || senderId.isEmpty) return;

    _chatScreenState.setTyping(senderId, true);
  }

  void _handleTypingStopped(dynamic data) {
    if (data == null || data is! Map) return;

    final senderId = data['senderId']?.toString();
    if (senderId == null || senderId.isEmpty) return;

    _chatScreenState.setTyping(senderId, false);
  }

  void _handleMessageReceived(dynamic data) {
    if (data == null || data is! Map) return;

    final messageId = data['messageId']?.toString();
    final status = data['status']?.toString();
    if (messageId == null || status == null) return;

    _chatScreenState.updateMessageStatus(messageId, StatusCode.received);
  }

  void _handleMessageSeen(dynamic data) {
    if (data == null || data is! Map) return;

    final messageId = data['messageId']?.toString();
    final status = data['status']?.toString();
    if (messageId == null || status == null) return;

    _chatScreenState.updateMessageStatus(messageId, StatusCode.seen);
  }

  void _handleNewMessage(dynamic data) {
    if (data == null) return;

    final payload = data is Map ? data['serverMessage'] ?? data : data;
    if (payload is! Map) return;

    final message = MessageModel.fromJson(Map<String, dynamic>.from(payload));
    message.statusCode = StatusCode.received;

    final isChatActive = _chatScreenState.activeChatId == message.chatId;
    final updatedAt = DateTime.tryParse(message.time) ?? DateTime.now();

    _homeScreenState.updateChatPreview(
      chatId: message.chatId,
      messageText: message.messageText,
      updatedAt: updatedAt,
      markAsUnread: !isChatActive,
    );

    if (isChatActive) {
      _chatScreenState.addMessage(message);
      _homeScreenState.markChatAsRead(message.chatId);
    } else {
      _homeScreenState.markChatAsUnread(message.chatId);
    }
  }
}
