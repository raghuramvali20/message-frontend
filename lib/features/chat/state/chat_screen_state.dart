import 'package:flutter/widgets.dart';
import 'package:message/core/models/user_model.dart';
import 'package:message/features/chat/models/message_model.dart';

class ChatScreenState extends ChangeNotifier {
  String? _error;
  String? _activeChatId;
  User? _user;
  final List<MessageModel> _messages = [];
  bool _loading = false;

  String? get error => _error;
  String? get activeChatId => _activeChatId;
  User? get user => _user;
  bool get loading => _loading;
  List<MessageModel> get messages => _messages;

  void setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void setActiveChatId(String? activeChatId) {
    _activeChatId = activeChatId;
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
}
