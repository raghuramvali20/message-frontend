import 'package:flutter/widgets.dart';
import 'package:message/core/models/api_response.dart';
import 'package:message/core/models/user_model.dart';
import 'package:message/core/services/socket_services.dart';
import 'package:message/core/storage_services/storage_services.dart';
import 'package:message/features/home/models/chat_list_model.dart';
import 'package:message/features/home/services/chat_list_service.dart';

class HomeScreenController with ChangeNotifier{

    final ChatListService _service;
    final UserStorageService _userStorage;
    final SocketService _socket;

    HomeScreenController(this._service, this._userStorage, this._socket);

    User? _user;
    List<ChatModel>? _readChatList;
    List<ChatModel>? _unreadChatList;
    String? _error;
    bool _loading = false;

    List<ChatModel>? get readChatList => _readChatList;
    List<ChatModel>? get unreadChatList => _unreadChatList;
    String? get error => _error;
    bool get loading => _loading;
    User? get user => _user;

    Future<void> intiSocket() async{
        _socket.init(_user!.id);
    }

    Future<void> fetchChats() async{
        _loading = true;
        _error = null;
        _readChatList = [];
        _unreadChatList = [];
        notifyListeners();

        _user = await _userStorage.loadUser();
        if (_user == null) {
            _error = "Unauthenticated user";
        } else {
            final response = await _service.fetchChats(_user!.id);
            if (response is SuccessResponse<List<ChatModel>>) {
                final data = response.data ?? [];
                _readChatList = data.where((chat) => (chat.unreadMessages ?? 0) == 0).toList();
                _unreadChatList = data.where((chat) => (chat.unreadMessages ?? 0) > 0).toList();
            } else if (response is FailureResponse<List<ChatModel>>) {
                _error = response.serverMessage;
                _readChatList = [];
                _unreadChatList = [];
            }
        }

        _loading = false;
        notifyListeners();
    }
}