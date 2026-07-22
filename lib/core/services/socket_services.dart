import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  IO.Socket? socket;
  void Function(dynamic data)? onNewMessage;

  void init(String userId) {
    socket = IO.io(
      'http://10.134.226.133:3000',
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
  }
}