import 'package:flutter/widgets.dart';
import 'package:message/core/models/user_model.dart';
import 'package:message/features/chat/models/message_model.dart';

class ChatScreenState extends ChangeNotifier {
  String? _error;
  String? _activeChatId;
  User? _user;
  final List<MessageModel> _messages = [];
  final Map<String, bool> _typingUsers = {};
  final Map<String, bool> _presenceByUserId = {};
  final Map<String, DateTime> _lastSeenByUserId = {};
  bool _loading = false;

  String? get error => _error;
  String? get activeChatId => _activeChatId;
  User? get user => _user;
  bool get loading => _loading;
  List<MessageModel> get messages => _messages;
  Map<String, bool> get typingUsers => Map.unmodifiable(_typingUsers);
  Map<String, bool> get presenceByUserId => Map.unmodifiable(_presenceByUserId);
  Map<String, DateTime> get lastSeenByUserId =>
      Map.unmodifiable(_lastSeenByUserId);

  bool isTyping(String userId) => _typingUsers[userId] == true;
  bool isOnline(String userId) => _presenceByUserId[userId] == true;
  DateTime? lastSeen(String userId) => _lastSeenByUserId[userId];

  void setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void setActiveChatId(String? activeChatId) {
    _activeChatId = activeChatId;
    notifyListeners();
  }

  void clearActiveChat(String chatId) {
    if (_activeChatId != chatId) return;

    _activeChatId = null;
    notifyListeners();
  }

  void setUser(User? user) {
    _user = user;
    notifyListeners();
  }

  void setMessages(List<MessageModel> messages) {
    _messages
      ..clear()
      ..addAll(messages);
    notifyListeners();
  }

  void setLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  void addMessage(MessageModel message) {
    _messages.add(message);
    notifyListeners();
  }

  void updateMessageStatus(String messageId, StatusCode status) {
    for (final message in _messages) {
      if (message.id == messageId ||
          message.id == null && message.time == messageId) {
        message.statusCode = status;
      }
    }
    notifyListeners();
  }

  void setTyping(String userId, bool isTyping) {
    print("typing is started");
    _typingUsers[userId] = isTyping;
    notifyListeners();
  }

  void setPresence(String userId, {required bool online, DateTime? lastSeen}) {
    _presenceByUserId[userId] = online;
    if (lastSeen != null) {
      _lastSeenByUserId[userId] = lastSeen;
    }
    notifyListeners();
  }
}
