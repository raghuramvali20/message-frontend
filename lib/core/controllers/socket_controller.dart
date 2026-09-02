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
  }

  void _handleNewMessage(dynamic data) {
    if (data == null) return;

    final payload = data is Map ? data['serverMessage'] ?? data : data;
    if (payload is! Map) return;

    final message = MessageModel.fromJson(Map<String, dynamic>.from(payload));
    message.statusCode = StatusCode.received;

    final isChatActive = _chatScreenState.activeChatId == message.chatId;

    if (isChatActive) {
      _chatScreenState.addMessage(message);
      _homeScreenState.markChatAsRead(message.chatId);
    } else {
      final updatedAt = DateTime.tryParse(message.time) ?? DateTime.now();
      _homeScreenState.updateChatPreview(
        chatId: message.chatId,
        messageText: message.messageText,
        updatedAt: updatedAt,
        markAsUnread: true,
      );
    }
  }
}
