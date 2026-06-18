import 'package:flutter/widgets.dart';
import 'package:message/core/models/api_response.dart';
import 'package:message/core/models/user_model.dart';
import 'package:message/core/storage_services/storage_services.dart';
import 'package:message/features/home/models/chat_list_model.dart';
import 'package:message/features/home/services/chat_list_service.dart';

class ChatListController with ChangeNotifier{

    final ChatListService _service;
    final UserStorageService _userStorage;

    ChatListController(this._service, this._userStorage);

    User? _user;
    List<ChatModel>? _chatList;
    String? _error;
    bool _loading = false;

    List<ChatModel>? get chatList => _chatList;
    String? get error => _error;
    bool get loading => _loading;

    Future<void> fetchChats() async{
        _loading = true;
        _error = null;
        notifyListeners();

        _user = await _userStorage.loadUser();
        print(_user!.id);
        if(_user != null){
            final response = await _service.fetchChats(_user!.id);
            if(response is SuccessResponse<List<ChatModel>>){
                _chatList = response.data;
            }else if(response is FailureResponse<List<ChatModel>>){
                _error = response.serverMessage;
            }
        }else{
            _error = "Unauthenticated user";
        }

        _loading = false;
        notifyListeners();
    }
}