import 'package:flutter/material.dart';
import 'package:message/core/theme/app_theme.dart';
import 'package:message/features/chat/controllers/chat_controller.dart';
import 'package:message/features/chat/models/chat_arguments.dart';
import 'package:message/features/chat/widgets/build_messages.dart';
import 'package:message/features/chat/widgets/build_send_message.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  static const String routeName = "chat-screen";

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ChatArguments? args;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final routeArgs = ModalRoute.of(context)?.settings.arguments;
      if (routeArgs is ChatArguments) {
        args = routeArgs;

        if (!mounted) return;
        await context.read<ChatController>().fetchMessages(args!.chatId);
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (args == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(args!.profilePic),
              ),
              const SizedBox(width: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(args!.chatUserName),
                  const Text("Online", style: AppTypography.bodySm),
                ],
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            BuildMessages(chatId: args!.chatId),
            BuildSendMessage(
              chatId: args!.chatId,
              receiverId: args!.chatUserId,
            ),
          ],
        ),
      ),
    );
  }
}