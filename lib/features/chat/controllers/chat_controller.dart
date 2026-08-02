import 'package:message/core/models/api_response.dart';
import 'package:message/core/storage_services/storage_services.dart';
import 'package:message/features/chat/models/message_model.dart';
import 'package:message/features/chat/services/chat_services.dart';
import 'package:message/features/chat/services/date_time_managing_service.dart';
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
      _state.setMessages(response.data.map((msg) {
        // create service with timestamp string
        final timeAndDate = DateTimeManagingService(msg.time).convertTimeAndDate();
        msg.formattedTime = timeAndDate.time;
        msg.formattedDate = timeAndDate.date;
        return msg;
      }).toList());
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
    
    // print(messageText);
    final response = await _services.sendMessage(messageText, receiverId, chatId);
    if(response is SuccessResponse<MessageModel>){
    // enrich with formatted values
        MessageModel message = response.data;
        final timeAndDate = DateTimeManagingService(message.time).convertTimeAndDate();
        message.formattedTime = timeAndDate.time;
        message.formattedDate = timeAndDate.date;
        _state.addMessage(message);
    }

   
  }
}
