import 'package:flutter/material.dart';
import 'package:message/features/chat/models/chat_arguments.dart';
import 'package:message/features/chat/widgets/build_messages.dart';
import 'package:message/features/chat/widgets/build_send_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  static const String routeName = "chat-screen";

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  @override
  Widget build(BuildContext context) {

    final args = ModalRoute.of(context)!.settings.arguments as ChatArguments;
    

    return Scaffold(
      appBar: AppBar(
        title: Text(args.chatUserName),
      ),
      body: Column(
        children: [
            BuildMessages(chatId: args.chatId),
            BuildSendMessage()
        ],
      ),
    );
  }
}