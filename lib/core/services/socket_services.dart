import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket;

  void init(String userId) {
    socket = IO.io(
      'http://10.169.9.133:3000',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .build(),
    );

    socket.onConnect((_) {
      print('Socket connected: ${socket.id}');
      socket.emit('connect_user', userId);
    });

    socket.on('newMessage', (data) {
      print('New message event: $data');
      // Handle incoming message data here
    });

    socket.onDisconnect((_) => print('Socket disconnected'));
    socket.onError((err) => print('Socket error: $err'));
  }

  void dispose() {
    socket.dispose();
  }
}