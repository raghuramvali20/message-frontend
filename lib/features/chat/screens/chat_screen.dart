import 'package:flutter/material.dart';
import 'package:message/core/theme/app_theme.dart';
import 'package:message/features/chat/controllers/chat_controller.dart';
import 'package:message/features/chat/models/chat_arguments.dart';
import 'package:message/features/chat/state/chat_screen_state.dart';
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
        context.read<ChatScreenState>().setPresence(
          args!.chatUserId,
          online: args!.online,
          lastSeen: args!.lastSeen,
        );

        if (!mounted) return;
        await context.read<ChatController>().fetchMessages(args!.chatId);
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    final chatId = args?.chatId;
    if (chatId != null) {
      context.read<ChatScreenState>().clearActiveChat(chatId);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (args == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final chatState = context.watch<ChatScreenState>();
    final isTyping = chatState.isTyping(args!.chatUserId);
    final isOnline = chatState.isOnline(args!.chatUserId);
    final lastSeen = chatState.lastSeen(args!.chatUserId);

    print("$isTyping, $isOnline, $lastSeen");

    String statusText;
    if (isTyping) {
      statusText = 'Typing...';
    } else if (isOnline) {
      statusText = 'Online';
    } else if (lastSeen != null) {
      statusText = 'Last seen ${_formatLastSeen(lastSeen)}';
    } else {
      statusText = 'Offline';
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
                  Text(statusText, style: AppTypography.bodySm),
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

  String _formatLastSeen(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) {
      return 'just now';
    }
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    }
    if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    }
    return '${date.day}/${date.month}/${date.year}';
  }
}
