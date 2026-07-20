import 'package:flutter/widgets.dart';
import 'package:message/core/models/api_response.dart';
import 'package:message/core/models/user_model.dart';
import 'package:message/core/services/socket_services.dart';
import 'package:message/core/storage_services/storage_services.dart';
import 'package:message/features/chat/models/message_model.dart';
import 'package:message/features/chat/services/chat_services.dart';
import 'package:message/features/chat/services/date_time_managing_service.dart';

class ChatController with ChangeNotifier {
  final ChatServices _services;
  final UserStorageService _userStorage;
  final SocketService _socketService;

  ChatController(this._services, this._userStorage, this._socketService) {
    _socketService.onNewMessage = _handleNewMessage;
  }

  String? _error;
  String? _activeChatId;
  User? _user;
  List<MessageModel>? _messages;
  bool _loading = false;

  String? get error => _error;
  User? get user => _user;
  List<MessageModel>? get messages => _messages;
  bool get loading => _loading;

  Future<void> fetchMessages(String chatId) async {
    _activeChatId = chatId;
    _loading = true;
    _error = null;
    notifyListeners();

    _user = await _userStorage.loadUser();

    final response = await _services.getChatsByChatId(chatId);

    if (response is SuccessResponse<List<MessageModel>>) {
      _messages = response.data.map((msg) {
        // create service with timestamp string
        final timeAndDate = DateTimeManagingService(msg.time).convertTimeAndDate();
        msg.formattedTime = timeAndDate.time;
        msg.formattedDate = timeAndDate.date;
        return msg;
      }).toList();
    } else if (response is FailureResponse<List<MessageModel>>) {
      _error = response.serverMessage;
    }

    _loading = false;
    notifyListeners();
  }

  void _handleNewMessage(dynamic data) {
    if (data == null) return;

    final payload = data is Map ? data['serverMessage'] ?? data : data;
    if (payload is! Map) return;

    final message = MessageModel.fromJson(Map<String, dynamic>.from(payload));
    final timeAndDate = DateTimeManagingService(message.time).convertTimeAndDate();
    message.formattedTime = timeAndDate.time;
    message.formattedDate = timeAndDate.date;

    if (_activeChatId == message.chatId) {
      _messages ??= [];
      _messages!.add(message);
      notifyListeners();
    }
  }

  Future<void> sendMessage(
    String messageText,
    String chatId,
    String receiverId,
  ) async {
    final nowIso = DateTime.now().toUtc().toIso8601String();
    MessageModel message = MessageModel(
      chatId: chatId,
      senderId: user!.id,
      receiverId: receiverId,
      messageText: messageText,
      time: nowIso,
    );

    // enrich with formatted values
    final timeAndDate = DateTimeManagingService(message.time).convertTimeAndDate();
    message.formattedTime = timeAndDate.time;
    message.formattedDate = timeAndDate.date;

    messages!.add(message);
    notifyListeners();
  }
}
