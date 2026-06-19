import 'package:flutter/widgets.dart';
import 'package:message/core/models/api_response.dart';
import 'package:message/core/models/user_model.dart';
import 'package:message/core/storage_services/storage_services.dart';
import 'package:message/features/chat/models/message_model.dart';
import 'package:message/features/chat/services/chat_services.dart';

class ChatController with ChangeNotifier {
    final ChatServices _services;
    final UserStorageService _userStorage;
    ChatController(this._services, this._userStorage);

    String? _error;
    User? _user;
    List<MessageModel>? _messages;
    bool _loading = false;
    

    String? get error => _error;
    User? get user => _user;
    List<MessageModel>? get messages => _messages;
    bool get loading => _loading;


    Future<void> fetchMessages(String chatId) async {
        _loading = true;
        _error = null;
        notifyListeners();

        _user = await _userStorage.loadUser();

        final response = await _services.getChatsByChatId(chatId);
        
        if(response is SuccessResponse<List<MessageModel>>){
            _messages = response.data;
        }else if(response is FailureResponse<List<MessageModel>>){
            _error =  response.serverMessage;
        }

        _loading = false;
        notifyListeners();
    }

}