import 'package:flutter/foundation.dart';
import 'package:message/core/models/user_model.dart';
import 'package:message/features/home/models/chat_list_model.dart';

class HomeScreenState extends ChangeNotifier {
  User? _user;
  final List<ChatModel> _chats = [];
  String? _error;
  bool _loading = false;

  User? get user => _user;
  List<ChatModel> get chats => List.unmodifiable(_chats);
  List<ChatModel> get readChatList => _chats.where((chat) => !chat.hasUnread).toList();
  List<ChatModel> get unreadChatList => _chats.where((chat) => chat.hasUnread).toList();
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
    _chats
      ..clear()
      ..addAll([...readChatList, ...unreadChatList]);
    _sortChats();
    notifyListeners();
  }

  void setAllChats(List<ChatModel> chats) {
    _chats
      ..clear()
      ..addAll(chats);
    _sortChats();
    notifyListeners();
  }

  void updateChatPreview({
    required String chatId,
    required String messageText,
    DateTime? updatedAt,
    bool markAsUnread = false,
  }) {
    final timestamp = updatedAt ?? DateTime.now();
    final chat = _findChatById(chatId);

    if (chat == null) return;

    chat.previewChat = messageText;
    chat.lastUpdate = timestamp;
    chat.formattedDate = _formatDate(timestamp);
    chat.formattedTime = _formatTime(timestamp);
    chat.hasUnread = markAsUnread;

    _sortChats();
    notifyListeners();
  }

  void markChatAsRead(String chatId) {
    final chat = _findChatById(chatId);
    if (chat == null) return;

    chat.hasUnread = false;
    _sortChats();
    notifyListeners();
  }

  void markChatAsUnread(String chatId) {
    final chat = _findChatById(chatId);
    if (chat == null) return;

    chat.hasUnread = true;
    _sortChats();
    notifyListeners();
  }

  void updateChatPresence(
    String userId, {
    required bool online,
    DateTime? lastSeen,
  }) {
    final chat = _chats.cast<ChatModel?>().firstWhere(
      (chat) => chat?.chatUserId == userId,
      orElse: () => null,
    );
    if (chat == null) return;

    chat.online = online;
    chat.lastSeen = lastSeen;
    notifyListeners();
  }

  ChatModel? _findChatById(String chatId) {
    for (final chat in _chats) {
      if (chat.chatId == chatId) return chat;
    }
    return null;
  }

  void _sortChats() {
    _chats.sort((a, b) {
      final aTime = a.lastUpdate ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bTime = b.lastUpdate ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bTime.compareTo(aTime);
    });
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
    _chats.clear();
    notifyListeners();
  }
}