import 'package:flutter/foundation.dart';
import 'package:message/core/models/user_model.dart';
import 'package:message/features/home/models/chat_list_model.dart';

class HomeScreenState extends ChangeNotifier {
  User? _user;
  List<ChatModel> _readChatList = [];
  List<ChatModel> _unreadChatList = [];
  String? _error;
  bool _loading = false;

  User? get user => _user;
  List<ChatModel> get readChatList => _readChatList;
  List<ChatModel> get unreadChatList => _unreadChatList;
  String? get error => _error;
  bool get loading => _loading;

  void setUser(User? user) {
    _user = user;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  void setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void setChats({
    required List<ChatModel> readChatList,
    required List<ChatModel> unreadChatList,
  }) {
    _readChatList = readChatList;
    _unreadChatList = unreadChatList;
    notifyListeners();
  }

  void updateChatPreview({
    required String chatId,
    required String messageText,
  }) {
    for (final chat in _readChatList) {
      if (chat.chatId == chatId) {
        chat.previewChat = messageText;
      }
    }

    for (final chat in _unreadChatList) {
      if (chat.chatId == chatId) {
        chat.previewChat = messageText;
      }
    }

    notifyListeners();
  }

  void reset() {
    _error = null;
    _readChatList = [];
    _unreadChatList = [];
    notifyListeners();
  }
}