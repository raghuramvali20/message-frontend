import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  IO.Socket? socket;
  void Function(dynamic data)? onNewMessage;
  void Function(dynamic data)? onMessageReceived;
  void Function(dynamic data)? onMessageSeen;
  void Function(dynamic data)? onUserOnline;
  void Function(dynamic data)? onUserOffline;
  void Function(dynamic data)? onTyping;
  void Function(dynamic data)? onTypingStopped;

  void init(String userId) {
    socket = IO.io(
      'http://192.168.18.72:3000',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .build(),
    );

    socket!.onConnect((_) {
      socket!.emit('connect_user', userId);
    });

    socket!.on('newMessage', (data) {
      onNewMessage?.call(data);
    });

    socket!.on('message_received', (data) {
      onMessageReceived?.call(data);
    });

    socket!.on('message_seen', (data) {
      onMessageSeen?.call(data);
    });

    socket!.on('user_online', (data) {
      onUserOnline?.call(data);
      print(data);
    });

    socket!.on('user_offline', (data) {
      onUserOffline?.call(data);
    });

    socket!.on('user_typing', (data) {
      onTyping?.call(data);
    });

    socket!.on('user_stopped_typing', (data) {
      onTypingStopped?.call(data);
    });
  }

  void emitTyping({
    required String chatId,
    required String senderId,
    required String receiverId,
    required bool isTyping,
  }) {
    if (socket == null) return;

    final event = isTyping ? 'user_typing' : 'user_stopped_typing';
    socket!.emit(event, {
      'chatId': chatId,
      'senderId': senderId,
      'receiverId': receiverId,
    });
  }

  void emitMessageSeen({
    required String messageId,
    required String chatId,
    required String userId,
    required String senderId,
  }) {
    if (socket == null) return;

    socket!.emit('message_seen', {
      'messageId': messageId,
      'chatId': chatId,
      'userId': userId,
      'senderId': senderId,
    });
  }
}