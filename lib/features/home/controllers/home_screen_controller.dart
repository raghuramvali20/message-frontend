import 'package:message/core/models/api_response.dart';
import 'package:message/core/services/socket_services.dart';
import 'package:message/core/storage_services/storage_services.dart';
import 'package:message/features/home/models/chat_list_model.dart';
import 'package:message/features/home/services/chat_list_service.dart';
import 'package:message/features/home/state/home_screen_state.dart';

class HomeScreenController {
  final ChatListService _service;
  final UserStorageService _userStorage;
  final SocketService _socketService;
  final HomeScreenState _state;

  HomeScreenController(this._service, this._userStorage, this._socketService, this._state);

  Future<void> initSocket() async {
    final userId = _state.user?.id;
    if (userId != null) {
      _socketService.init(userId);
    }
  }

  Future<void> fetchChats() async {
    _state.setLoading(true);
    _state.setError(null);
    _state.setChats(readChatList: [], unreadChatList: []);

    final user = await _userStorage.loadUser();
    _state.setUser(user);

    if (user == null) {
      _state.setError('Unauthenticated user');
      _state.setLoading(false);
      return;
    }

    final response = await _service.fetchChats(user.id);

    if (response is SuccessResponse<List<ChatModel>>) {
      final data = response.data ?? [];

      final readChats =
          data.where((chat) => (chat.unreadMessages ?? 0) == 0).toList();
      final unreadChats =
          data.where((chat) => (chat.unreadMessages ?? 0) > 0).toList();

      _state.setChats(readChatList: readChats, unreadChatList: unreadChats);
    } else if (response is FailureResponse<List<ChatModel>>) {
      _state.setError(response.serverMessage);
      _state.setChats(readChatList: [], unreadChatList: []);
    }

    _state.setLoading(false);
  }
}