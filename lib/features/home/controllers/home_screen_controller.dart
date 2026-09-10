import 'package:message/core/models/api_response.dart';
import 'package:message/core/models/user_model.dart';
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

  HomeScreenController(
    this._service,
    this._userStorage,
    this._socketService,
    this._state,
  );

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
      final data = response.data;
      _state.setAllChats(data);
    } else if (response is FailureResponse<List<ChatModel>>) {
      _state.setError(response.serverMessage);
      _state.setChats(readChatList: [], unreadChatList: []);
    }

    _state.setLoading(false);
  }

  Future<ChatModel?> ensureChatForUser(User user) async {
    final existingChat = _state.chats.cast<ChatModel?>().firstWhere(
      (chat) => chat?.chatUserId == user.id,
      orElse: () => null,
    );
    if (existingChat != null) return existingChat;

    final response = await _service.ensureChat(user.id);
    if (response is SuccessResponse<ChatModel>) {
      _state.addOrUpdateChat(response.data);
      return response.data;
    }

    if (response is FailureResponse<ChatModel>) {
      _state.setError(response.serverMessage);
    }
    return null;
  }

  Future<bool> acceptChat(String chatId) async {
    final response = await _service.acceptChat(chatId);
    if (response is SuccessResponse<bool>) {
      await fetchChats();
      return true;
    }
    if (response is FailureResponse<bool>) _state.setError(response.serverMessage);
    return false;
  }

  Future<bool> blockChat(String chatId) async {
    final response = await _service.blockChat(chatId);
    if (response is SuccessResponse<bool>) {
      await fetchChats();
      return true;
    }
    if (response is FailureResponse<bool>) _state.setError(response.serverMessage);
    return false;
  }
}
