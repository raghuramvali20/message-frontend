import 'package:message/core/models/api_response.dart';
import 'package:message/core/services/socket_services.dart';
import 'package:message/core/storage_services/storage_services.dart';
import 'package:message/features/chat/models/message_model.dart';
import 'package:message/features/chat/services/chat_services.dart';
import 'package:message/features/chat/state/chat_screen_state.dart';
import 'package:message/features/home/state/home_screen_state.dart';

class ChatController{
  final ChatServices _services;
  final UserStorageService _userStorage;
  final ChatScreenState _state;
  final HomeScreenState _homeScreenState;
  final SocketService _socketService;

  SocketService get socketService => _socketService;

  ChatController(this._services, this._userStorage, this._state, this._homeScreenState, this._socketService);

  Future<void> fetchMessages(String chatId) async {
    _state.setActiveChatId(chatId);
    _homeScreenState.markChatAsRead(chatId);
    _state.setLoading(true);
    _state.setError(null);

    final currentUser = await _userStorage.loadUser();
    _state.setUser(currentUser);

    final response = await _services.getChatsByChatId(chatId);

    if (response is SuccessResponse<List<MessageModel>>) {
      _state.setMessages(response.data);
      _markSeenMessages(response.data, currentUser?.id ?? '');
    } else if (response is FailureResponse<List<MessageModel>>) {
      _state.setError(response.serverMessage);
    }

    _state.setLoading(false);
  }

  void _markSeenMessages(List<MessageModel> messages, String currentUserId) {
    if (currentUserId.isEmpty) return;

    for (final message in messages) {
      if (message.senderId != currentUserId && message.statusCode != StatusCode.seen) {
        _socketService.emitMessageSeen(
          messageId: message.id ?? message.time,
          chatId: message.chatId,
          userId: currentUserId,
          senderId: message.senderId,
        );
        message.statusCode = StatusCode.seen;
      }
    }
  }

  Future<void> sendMessage(
    String messageText,
    String chatId,
    String receiverId,
  ) async {
    final response = await _services.sendMessage(messageText, receiverId, chatId);
    if (response is SuccessResponse<MessageModel>) {
      response.data.statusCode = StatusCode.sent;
      _state.addMessage(response.data);

      final sentAt = DateTime.tryParse(response.data.time) ?? DateTime.now();
      _homeScreenState.updateChatPreview(
        chatId: chatId,
        messageText: response.data.messageText,
        updatedAt: sentAt,
      );
    } else if (response is FailureResponse<MessageModel>) {
      _state.setError(response.serverMessage);
    }
  }
}
