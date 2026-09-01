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
    DateTime? updatedAt,
  }) {
    final timestamp = updatedAt ?? DateTime.now();

    for (final chat in _readChatList) {
      if (chat.chatId == chatId) {
        chat.previewChat = messageText;
        chat.lastUpdate = timestamp;
        chat.formattedDate = _formatDate(timestamp);
        chat.formattedTime = _formatTime(timestamp);
      }
    }

    for (final chat in _unreadChatList) {
      if (chat.chatId == chatId) {
        chat.previewChat = messageText;
        chat.lastUpdate = timestamp;
        chat.formattedDate = _formatDate(timestamp);
        chat.formattedTime = _formatTime(timestamp);
      }
    }

    notifyListeners();
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);

    if (target == today) {
      return 'Today';
    }

    final yesterday = today.subtract(const Duration(days: 1));
    if (target == yesterday) {
      return 'Yesterday';
    }

    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTime(DateTime date) {
    final hour = date.hour;
    final minute = date.minute.toString().padLeft(2, '0');
    final suffix = hour >= 12 ? 'PM' : 'AM';
    final formattedHour = hour % 12 == 0 ? 12 : hour % 12;
    return '$formattedHour:$minute $suffix';
  }

  void reset() {
    _error = null;
    _readChatList = [];
    _unreadChatList = [];
    notifyListeners();
  }
}