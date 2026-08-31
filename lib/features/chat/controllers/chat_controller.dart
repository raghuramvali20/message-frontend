import 'package:message/core/models/api_response.dart';
import 'package:message/core/storage_services/storage_services.dart';
import 'package:message/features/chat/models/message_model.dart';
import 'package:message/features/chat/services/chat_services.dart';
import 'package:message/features/chat/state/chat_screen_state.dart';

class ChatController{
  final ChatServices _services;
  final UserStorageService _userStorage;
  final ChatScreenState _state;

  ChatController(this._services, this._userStorage,  this._state);

  Future<void> fetchMessages(String chatId) async {
    _state.setActiveChatId(chatId);
    _state.setLoading(true);
    _state.setError(null);

    _state.setUser(await _userStorage.loadUser());

    final response = await _services.getChatsByChatId(chatId);

    if (response is SuccessResponse<List<MessageModel>>) {
      _state.setMessages(response.data);
    } else if (response is FailureResponse<List<MessageModel>>) {
      _state.setError(response.serverMessage);
    }

    _state.setLoading(false);
  }

  Future<void> sendMessage(
    String messageText,
    String chatId,
    String receiverId,
  ) async {
    final response = await _services.sendMessage(messageText, receiverId, chatId);
    if(response is SuccessResponse<MessageModel>){
      _state.addMessage(response.data);
    }
  }
}
