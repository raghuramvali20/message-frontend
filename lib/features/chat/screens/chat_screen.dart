import 'package:flutter/material.dart';
import 'package:message/core/theme/app_theme.dart';
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
    

    return SafeArea(
        top: false,
      child: Scaffold(
        appBar: AppBar(
            shadowColor: Colors.black,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(args.profilePic),
            ),
            SizedBox(width: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(args.chatUserName),
                  Text(
                    "Online", //user status. 
                    style: AppTypography.bodySm,
                  )
                ],
              ),
            ],
          ),
        ),
        body: Column(
          children: [
              BuildMessages(chatId: args.chatId),
              BuildSendMessage(chatId: args.chatId, receiverId: args.chatUserId,)
          ],
        ),
      ),
    );
  }
}