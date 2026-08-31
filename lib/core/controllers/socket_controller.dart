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

    if (_chatScreenState.activeChatId == message.chatId) {
      _chatScreenState.addMessage(message);
    }
    _homeScreenState.updateChatPreview(chatId: message.chatId, messageText: message.messageText);
  }
}
